const {execFileSync}=require('node:child_process');
const assert=require('node:assert/strict');
const fs=require('node:fs');
const path=require('node:path');
const folder=process.argv[2];
const files=fs.readdirSync(folder).filter(s=>s.endsWith('.mp3'));
assert.equal(files.length,3);
for(const name of files){
  const file=path.join(folder,name);
  const expected=name.includes('Gesamtprobe')?[200,300,400,500,600]:name.includes('002')?[300]:name.includes('003')?[400]:[];
  assert(expected.length);
  const meta=JSON.parse(execFileSync('ffprobe',['-v','error','-show_streams','-of','json',file])).streams[0];
  assert.equal(meta.channels,2);assert.equal(meta.codec_name,'mp3');assert(Math.abs(+meta.duration-expected.length)<0.05);
  if(process.argv[3])assert.equal(+meta.bit_rate,Number(process.argv[3]));
  const pcm=execFileSync('ffmpeg',['-loglevel','error','-i',file,'-f','s16le','-ac','1','-ar','48000','pipe:1'],{maxBuffer:2000000});
  const heard=expected.map((hz,i)=>{
    const start=48000*i+12000;let crosses=0;
    for(let k=start;k<start+24000;k++)if(pcm.readInt16LE(2*k)<=0&&pcm.readInt16LE(2*k+2)>0)crosses++;
    const result=crosses*2;assert(Math.abs(result-hz)<=4,name+' '+result+' statt '+hz);return result;
  });
  console.log(name,meta.bit_rate+' bit/s',meta.duration+' s',heard.join('/')+' Hz');
}
