-- Load and run once in REAPER's main action list.
local r=reaper
local dir=debug.getinfo(1,"S").source:sub(2):match("^(.*[/\\])")
local folder=r.GetResourcePath().."/reaper_www_root"
r.RecursiveCreateDirectory(folder,0)
local function install(src, name)
  local data=assert(src:read("*a")); src:close()
  local dest=assert(io.open(folder.."/"..name,"wb"))
  assert(dest:write(data)); assert(dest:close())
end
install(io.open(dir.."setliste.lokal.js","rb") or assert(io.open(dir.."probenregie-setliste.js","rb")), "probenregie-setliste.js")
install(assert(io.open(dir.."probe.html","rb")), "probenregie.html")
assert(r.AddRemoveReaScript(true,0,dir.."Probenregie.lua",true)~=0)
r.MB("Handyseite installiert. Unter Control/OSC/web ein Web browser interface hinzufügen. Die angezeigte Access URL auf dem iPhone mit /probenregie.html öffnen. Pro gespeicherter Probe die Aktion Probenregie.lua starten.","Probenregie",0)
