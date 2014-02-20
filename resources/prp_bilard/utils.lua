ballNames={
	[2995]="",
	[2996]="",
	[2997]="",
	[2998]="",
	[2999]="",
	[3000]="",
	[3001]="",

	[3002]="", 

	[3003]="",

	[3100]="",
	[3101]="",
	[3102]="",
	[3103]="",
	[3104]="",
	[3105]="",
	[3106]="",
}


function shuffle(t)
  local n = #t
 
  while n >= 2 do
    -- n is now the last pertinent index
    local k = math.random(n) -- 1 <= k <= n
    -- Quick swap
    t[n], t[k] = t[k], t[n]
    n = n - 1
  end
 
  return t
end

function findRotation(startX, startY, targetX, targetY)	-- Doomed-Space-Marine
	local t = -math.deg(math.atan2(targetX - startX, targetY - startY))
	
	if t < 0 then
		t = t + 360
	end
	
	return t
end
