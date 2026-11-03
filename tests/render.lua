-- Run in a disposable REAPER instance with a blank project and a fixture.wav beside this script.
local dir=debug.getinfo(1,"S").source:sub(2):match("^(.*[/\\])")
local r=reaper
local function test()
  local m=dofile(dir.."regionen.lua")
  local p=r.EnumProjects(-1,"")
  assert(r.CountMediaItems(p)==0)
  assert(r.InsertMedia(dir.."fixture.wav",0)>0)
  m.region(p,"Feuer",0,1,true)
  m.region(p,"Luft",1,2,true)
  m.region(p,"Feuer",2,3,true)
  m.region(p,"Feuer",3,4,false)
  m.region(p,"Nur Fragment",4,5,false)
  r.AddProjectMarker2(p,true,0,5,m.whole,-1,0)
  r.AddProjectMarker2(p,true,0,1,"Fremde Region",-1,0)
  assert(m.prepare(p,dir.."Geschnitten")==2)
  local ok,targets=r.GetSetProjectInfo_String(p,"RENDER_TARGETS","",false)
  assert(ok and targets:find("003") and targets:find("002") and targets:find("Gesamtprobe") and not targets:find("001") and not targets:find("Teil"),targets)
  r.Main_SaveProjectEx(p,dir.."fixture.rpp",0)
  return targets
end
local ok,result=xpcall(test,debug.traceback)
local f=assert(io.open(dir.."result.txt","w"));f:write(tostring(ok),"\n",tostring(result));f:close()
if ok then reaper.Main_OnCommand(41824,0) end
