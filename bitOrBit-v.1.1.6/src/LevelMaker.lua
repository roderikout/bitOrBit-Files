--[[
    BitOrBit v.1.1.6

    Author: Rodrigo Garcia
    roderikout@gmail.com

    Original by: Colton Ogden, cogden@cs50.harvard.edu
    
    -- Level Maker --

    Para hacer los niveles. ARREGLAR, demasiado sencillo
  
]]



LevelMaker = Class{}

function LevelMaker.createLevel(level, planet)

	local levelData = {}
	local planet = planet
	local numberOfProbes = 0
	local multSpeedOfProbes = 0
	local orbitsNeededToWin = {}
	local probes = {}
	local coordProbeX = planet.x * 1.2
	local coordProbeY = planet.y * 1.2
	
	if level < 3 then
		numberOfProbes = level + 1
		multSpeedOfProbes = 0.4
	elseif level >= 3 and level < 6 then
		numberOfProbes = level + 1
		multSpeedOfProbes = 0.8
	else
		numberOfProbes = 7
		multSpeedOfProbes = 1
	end	

    for i = 1, numberOfProbes do
      table.insert(orbitsNeededToWin, false)
      if love.timer.getFPS() > 40 then
      	table.insert(probes, i, Probe(coordProbeX , coordProbeY, 450, 260))
      else
      	table.insert(probes, i, Probe(coordProbeX , coordProbeY, 350, 260))
      end
      probes[i].popX = coordProbeX
      probes[i].popY = coordProbeY
      probes[i].number = i
    end

	levelData = {orbitsNeededToWin, probes}

	return levelData
end

--[[function PlayState:manageLaunchProbes(first, dt, i)
  local modRad = lume.random(50)
  local uno = {self.probeX, self.probeY, lume.randomchoice({math.rad(300 - modRad), math.rad(270 + modRad)})}
  local dos = {self.probeX, -self.probeY, lume.randomchoice({math.rad(300 + modRad), math.rad(90 - modRad)})}
  local tres = {-self.probeX, self.probeY, lume.randomchoice({math.rad(360 - modRad), math.rad(0 + modRad)})}
  local cuatro = {-self.probeX, -self.probeY, lume.randomchoice({math.rad(100 - modRad), math.rad(90 + modRad)})}
  local probeData = lume.randomchoice({uno,dos,tres,cuatro})

end--]]