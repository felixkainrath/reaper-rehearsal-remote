-- REAPER 7.79+. All positions use project seconds.
local M = {}
local r = reaper
local prefix = "PR | "
local whole = "PR | Gesamtprobe"

function M.region(p, title, start, finish, complete)
  assert(finish > start, "Ende liegt vor dem Anfang.")
  local number = 1
  for i=0,r.GetNumRegionsOrMarkers(p)-1 do
    local _, region, _, _, name = r.EnumProjectMarkers2(p,i)
    local n = region and name:match("^PR | (%d+) | ")
    if n then number = math.max(number, tonumber(n)+1) end
  end
  local name = ("%s%03d | %s | %s"):format(prefix,number,complete and "OK" or "Teil",title)
  assert(r.AddProjectMarker2(p,true,start,finish,name,-1,0)>=0,"Region konnte nicht angelegt werden.")
  r.UpdateArrange()
end

function M.prepare(p, directory)
  assert(r.CountMediaItems(p)>0, "Keine Audio-Items im Projekt.")
  local winners, count, full = {}, 0, nil
  local rows = {}
  for i=0,r.GetNumRegionsOrMarkers(p)-1 do
    local _, region, a, b, name = r.EnumProjectMarkers2(p,i)
    if region then
      local marker = r.GetRegionOrMarker(p,i,"")
      rows[#rows+1]=marker
      if name==whole then assert(not full,"Mehrere Gesamtproben vorhanden."); full=marker end
      local n,title=name:match("^PR | (%d+) | OK | (.+)$")
      if n and b>a then
        local prev=winners[title]
        if not prev or tonumber(n)>prev.n then winners[title]={n=tonumber(n),marker=marker} end
      end
    end
  end
  assert(full,"Region PR | Gesamtprobe fehlt. Grenzen in REAPER prüfen.")
  local chosen={[full]=true}
  for _,v in pairs(winners) do chosen[v.marker]=true; count=count+1 end
  for _,marker in ipairs(rows) do r.SetRegionOrMarkerInfo_Value(p,marker,"B_UISEL",chosen[marker] and 1 or 0) end
  local function num(key,value) r.GetSetProjectInfo(p,key,value,true) end
  local function str(key,value) r.GetSetProjectInfo_String(p,key,value,true) end
  num("RENDER_SETTINGS",0); num("RENDER_BOUNDSFLAG",5); num("RENDER_CHANNELS",2)
  num("RENDER_TAILFLAG",0); num("RENDER_ADDTOPROJ",0); num("RENDER_NORMALIZE",0)
  str("RENDER_FORMAT2","ZXZhdxgAAA=="); str("RENDER_FORMAT","bDNwbQABAAAAAAAAAgAAAP////8EAAAAAAEAAAAAAAA=") -- little-endian 'mp3l'
  str("RENDER_FILE",directory); str("RENDER_PATTERN","$format/$project - $region")
  return count
end
M.whole=whole
return M
