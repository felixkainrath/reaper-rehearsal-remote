local r=reaper
local dir=debug.getinfo(1,"S").source:sub(2):match("^(.*[/\\])")
local p,path=r.EnumProjects(-1,"")
assert(path:match("Testprobe.rpp$"))
local function log(s) local f=assert(io.open(dir.."live.txt","a"));f:write(s,"\n");f:close() end
r.InsertTrackAtIndex(0,true)
local track=r.GetTrack(p,0)
r.SetMediaTrackInfo_Value(track,"I_RECINPUT",-1)
r.SetMediaTrackInfo_Value(track,"I_RECMODE",1)
r.SetMediaTrackInfo_Value(track,"I_RECARM",1)
log("Start "..path.." / "..r.kbd_getTextFromCmd(40667,0))
dofile(dir.."Probenregie.lua")
local cmds={"record","begin","ok","begin","stop"}
local i=0
local nextTime=r.time_precise()+1
local function run()
  if r.time_precise()<nextTime then r.defer(run);return end
  local s=r.GetExtState("Probenregie_v1","status")
  log(s)
  i=i+1
  if i>#cmds then log("Items "..r.CountMediaItems(p).." Regions "..r.GetNumRegionsOrMarkers(p));return end
  local ver=s:match("^([^.]+)")
  r.SetExtState("Probenregie_v1","request","req"..i.."."..ver.."."..os.time().."."..cmds[i].."."..(cmds[i]=="begin" and "45726465" or ""),false)
  nextTime=r.time_precise()+1.2;r.defer(run)
end
run()
