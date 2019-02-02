require("startScreen")
require("level1")

--level
  level = "start"
  probesMaxByLevel = 0

function levels(level)

	if level == "start" then
		levelDraw = startDraw
		levelUpdate = startUpdate
	end
	if level == 1 then
		probesMaxByLevel = probesLevel1
		if not initLevel1  then
			orbitsNeededByLevel(probesMaxByLevel)
			initLevel1 = true
		end
		levelDraw = level1Draw
		levelUpdate = level1Update
	end
end