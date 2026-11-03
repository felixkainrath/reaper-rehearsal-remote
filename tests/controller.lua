-- Exercise the production controller in REAPER without opening microphone inputs.
local dir=debug.getinfo(1,"S").source:sub(2):match("^(.*[/\\])")
local r=reaper
local function check()
  local nextTick,playing,time=nil,0,0
  local fake=setmetatable({
    EnumProjects=function() return 0,dir.."probe.rpp" end,
    GetPlayStateEx=function() return playing end, GetPlayPositionEx=function() return time end,
    GetSetRepeat=function() return 0 end, GetMediaTrackInfo_Value=function() return 1 end,
    CountTracks=function() return 1 end,GetTrack=function() return 0 end,
    CountMediaItems=function() return 0 end,Main_SaveProject=function() end,
    Main_OnCommand=function(id) assert(id==1013 or id==40667); playing=id==1013 and 5 or 0 end,
    defer=function(fn) nextTick=fn end,atexit=function() end,
  },{__index=r})
  local env=setmetatable({reaper=fake},{__index=_G})
  env.dofile=function(path) return assert(loadfile(path,"t",env))() end
  env.dofile(dir.."Probenregie.lua")
  local ns="Probenregie_v1"
  local function req(cmd,data,override)
    local version=r.GetExtState(ns,"status"):match("^([^.]+)")
    local packet="test."..version.."."..(override or os.time()).."."..cmd.."."..(data or "")
    r.SetExtState(ns,"request",packet,false); nextTick()
    return packet
  end
  req("record",nil,os.time()-30);assert(playing==0)
  req("record");assert(playing==5)
  time=1;local old=req("begin","4cc3bc667465");local _,title=r.GetProjExtState(0,ns,"open");assert(title=="Lüfte")
  time=1.5;local mark=req("marker","426cc3a4736572")
  r.SetExtState(ns,"request",mark,false);nextTick()
  req("marker","20");req("marker","0a")
  time=2;req("ok")
  r.SetExtState(ns,"request",old,false);nextTick()
  local _,open=r.GetProjExtState(0,ns,"open");assert(open=="")
  time=3;req("begin","4cc3bc667465");time=4;req("stop");assert(playing==0)
  local markers=0
  for i=0,r.GetNumRegionsOrMarkers(0)-1 do
    local _,isRegion,position,_,name=r.EnumProjectMarkers2(0,i)
    if not isRegion then
      markers=markers+1;assert(name=="Bläser" and position==1.5)
    end
  end
  assert(markers==1)
  local rows={}
  for i=0,r.GetNumRegionsOrMarkers(0)-1 do local _,_,a,b,name=r.EnumProjectMarkers2(0,i);rows[name]={a,b} end
  assert(rows["PR | 001 | OK | Lüfte"][1]==1)
  assert(rows["PR | 002 | Teil | Lüfte"][2]==4)
  assert(rows["PR | Gesamtprobe"][2]==4)
end
local ok,result=xpcall(check,debug.traceback)
local f=assert(io.open(dir.."controller-result.txt","w"));f:write(tostring(ok),"\n",tostring(result));f:close()
