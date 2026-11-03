const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');
const vm = require('node:vm');
const script = fs.readFileSync(path.join(__dirname,'../probe.html'),'utf8').match(/<script>([\s\S]*?)<\/script>/)[1];
const nodes = new Map();
function get(id) {
  if (!nodes.has(id)) nodes.set(id,{value:'',options:[],querySelector(){return null},add(o){this.options.push(o);if(this.options.length===1)this.value=o.value}});
  return nodes.get(id);
}
const server={rev:0,recording:false,title:'',last:'',lastVerb:'',now:Math.floor(Date.now()/1000)};
const hex=s=>Buffer.from(s).toString('hex');
async function fetchMock(url) {
  if(url.includes('/SET/')) {
    const [id,version,beat,verb,data]=url.split('/').at(-1).split('.');
    assert.equal(version,'session-'+server.rev);assert.equal(Number(beat),server.now);
    server.last=id;server.rev++;server.lastVerb=verb;
    if(verb==='record')server.recording=true;
    if(verb==='marker')server.marker=Buffer.from(data,'hex').toString();
    if(verb==='begin')server.title=Buffer.from(data,'hex').toString();
    if(verb==='part'||verb==='ok')server.title='';
    if(verb==='stop')server.recording=false;
  }
  const packet=['session-'+server.rev,server.last,Number(server.recording),hex(server.title),hex('OK'),server.now,12,Number(server.lastVerb!=='stop')].join('.');
  return {ok:true,text:async()=> 'EXTSTATE\tProbenregie_v1\tstatus\t'+packet+'\n'};
}
const ctx=vm.createContext({window:{probenSetliste:['Beispiel']},document:{getElementById:get},Option:class{constructor(text,value){this.text=text;this.value=value}},localStorage:{getItem:()=>null,setItem(){}},TextDecoder,TextEncoder,AbortController,fetch:fetchMock,setTimeout(fn,ms){if(ms===180)queueMicrotask(fn)},clearTimeout(){},confirm:()=>true});
vm.runInContext(script,ctx);
(async()=>{
  await vm.runInContext('poll()',ctx);
  assert.equal(get('songs').options.length,2);assert.equal(get('begin').disabled,true);
  assert.equal(get('marker').disabled,true);
  await get('record').onclick();assert.equal(server.recording,true);
  get('songs').value='';get('custom').value='Höhenflug';
  await get('begin').onclick();assert.equal(server.title,'Höhenflug');assert.equal(get('begin').disabled,true);
  get('markerName').value='';await get('marker').onclick();assert.equal(server.lastVerb,'begin');
  get('markerName').value='  Bläser ab Takt 8  ';await get('marker').onclick();assert.equal(server.marker,'Bläser ab Takt 8');assert.equal(server.title,'Höhenflug');
  await get('part').onclick();assert.equal(server.title,'');assert.equal(get('songs').value,'Höhenflug');
  await get('stop').onclick();assert.equal(get('record').disabled,true);assert.equal(get('export').disabled,false);
  console.log('Handylogik OK: Setliste, Transportzustände, Unicode, Teilversuch, Bestätigung und Exportfreigabe.');
})().catch(e=>{console.error(e);process.exitCode=1});
