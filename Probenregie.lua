local r=reaper
local dir=debug.getinfo(1,"S").source:sub(2):match("^(.*[/\\])")
local regions=dofile(dir.."regionen.lua")
local p,path=r.EnumProjects(-1,"")
local ns="Probenregie_v1"
local function publish(k,v) r.SetExtState(ns,k,v,false) end
local function get(k) local _,v=r.GetProjExtState(p,ns,k); return v end
local function put(k,v) r.SetProjExtState(p,ns,k,tostring(v)) end
local function hex(s) return (s:gsub(".",function(c) return ("%02x"):format(c:byte()) end)) end
local function unhex(s) return (s:gsub("%x%x",function(c) return string.char(tonumber(c,16)) end)) end
local function save() r.MarkProjectDirty(p); r.Main_SaveProject(p,false) end
local function pos() return r.GetPlayPositionEx(p) end
local function rec() return r.GetPlayStateEx(p)==5 end
local session=r.genGuid():gsub("[^%w]","")
local rev,last,msg=0,"","Bereit"
local function closeSong(t,ok)
  local title=get("open")
  assert(title~="","Kein offenes Lied.")
  regions.region(p,title,tonumber(get("begin")),t,ok)
  put("open","")
end
local function mediaEnd()
  local ending=0
  for i=0,r.CountMediaItems(p)-1 do
    local item=r.GetMediaItem(p,i)
    ending=math.max(ending,r.GetMediaItemInfo_Value(item,"D_POSITION")+r.GetMediaItemInfo_Value(item,"D_LENGTH"))
  end
  return ending
end
local function finish(t)
  local recorded=mediaEnd()
  if recorded>0 then t=recorded end
  if get("open")~="" then
    if t>tonumber(get("begin")) then closeSong(t,false) else put("open","") end
  end
  local a=tonumber(get("sessionStart"))
  if a and t>a then
    assert(r.AddProjectMarker2(p,true,a,t,regions.whole,-1,0)>=0,"Gesamtregion fehlt.")
    put("sessionStart",""); r.UpdateArrange()
  end
end
local function command(cmd,arg)
  if cmd=="record" then
    assert(path~="","Zuerst als eigenes Probenprojekt speichern und Regie neu starten.")
    assert(r.GetPlayStateEx(p)==0 and r.CountMediaItems(p)==0 and get("sessionStart")=="","Neues, leeres Probenprojekt verwenden.")
    assert(r.GetSetRepeat(-1)==0,"Wiederholung zuerst ausschalten.")
    local armed=false
    for i=0,r.CountTracks(p)-1 do
      if r.GetMediaTrackInfo_Value(r.GetTrack(p,i),"I_RECARM")==1 then armed=true end
    end
    assert(armed,"Zuerst Mikrofonspuren scharf schalten.")
    r.SetEditCurPos2(p,0,false,false)
    r.Main_OnCommand(1013,0)
    assert(rec(),"REAPER bestätigt keine laufende Aufnahme.")
    put("sessionStart",0); return "Probe läuft"
  elseif cmd=="export" then
    assert(r.GetPlayStateEx(p)==0 and get("sessionStart")=="","Zuerst Aufnahme beenden.")
    local _,currentPath=r.EnumProjects(-1,"")
    local n=regions.prepare(p,currentPath:match("^(.*[/\\])").."Geschnitten")
    r.Main_OnCommand(40015,0)
    return ("Renderdialog am PC: Gesamtprobe + %d Lieder"):format(n)
  end
  assert(rec() and get("sessionStart")~="","Keine laufende Probenaufnahme.")
  local t=pos()
  if cmd=="marker" then
    arg=arg:match("^%s*(.-)%s*$")
    assert(#arg>0 and #arg<=160 and not arg:find("[%c|]"),"Ungültiger Markername.")
    assert(r.AddProjectMarker2(p,false,t,0,arg,-1,0)>=0,"Marker konnte nicht gesetzt werden.")
    r.UpdateArrange()
    return "Marker gesetzt: "..arg
  elseif cmd=="begin" then
    assert(get("open")=="","Zuerst aktuellen Take beenden.")
    assert(#arg>0 and #arg<=160 and not arg:find("[%c|]"),"Ungültiger Titel.")
    put("begin",t); put("open",arg); return "Lied läuft"
  elseif cmd=="ok" or cmd=="part" then
    closeSong(t,cmd=="ok"); return cmd=="ok" and "Vollständiger Take markiert" or "Teilversuch markiert"
  elseif cmd=="stop" then
    r.Main_OnCommand(40667,0)
    assert(not rec(),"Aufnahme läuft noch.")
    finish(t); save(); return "Probe beendet"
  end
  error("Unbekannter Befehl")
end
if path=="" then r.MB("Speichere das Projekt zuerst in seinem eigenen Probenordner.","Probenregie",0); return end
if get("sessionStart")~="" and not rec() then
  local ending=mediaEnd()
  if ending>0 then finish(ending); save() else put("open",""); put("sessionStart","") end
end
local wasRecording=rec()
local previous=pos()
publish("request","")
r.atexit(function() publish("status","") end)
local function tick()
  if r.EnumProjects(-1,"")~=p then return end
  if wasRecording and not rec() and get("sessionStart")~="" then
    finish(previous); save(); rev=rev+1; msg="Am Rechner gestoppt. Grenzen prüfen."
  end
  local packet=r.GetExtState(ns,"request")
  if packet~="" then
    publish("request","")
    local id,version,beat,verb,data=packet:match("^([%w%-]+)%.([%w%-]+)%.(%d+)%.(%a+)%.(%x*)$")
    if id and version==session.."-"..rev and math.abs(os.time()-tonumber(beat))<=5 then
      local ok,result=pcall(command,verb,unhex(data))
      last=id; rev=rev+1; msg=ok and result or (tostring(result):match(":%d+: (.*)") or tostring(result))
    end
  end
  wasRecording=rec()
  if wasRecording then previous=pos() end
  publish("status",table.concat({session.."-"..rev,last,wasRecording and "1" or "0",hex(get("open")),hex(msg),os.time(),math.floor(math.max(0,previous)),r.CountMediaItems(p)==0 and "1" or "0"},"."))
  r.defer(tick)
end
tick()
