
Level = Object:extend()

--require ("levelStart")
require ("level1")
require ("level2")




function Level:new()

	self.currentLevel = 0
	self.initLevel = false
	self.instructionsOn = false
  self.orbitsNeededToWin = {} -- tabla que se llena en levels segun cuantas orbitas correctas se necesitan para ganar (a Levels)

end


function Level:draw()
	cameraMain:draw(
    function()
      colorZones()
      self:drawTableEntities(probes)
      for i, probe in ipairs(probes) do
        self:drawTableEntities(fragmentsOfProbe)
      end
      gravityBeam()
      self:drawTableEntities(planetas)
        end)  
	printTexts()
end

function Level:update(dt)
	if game.gameState == 'pause' then
		return
	end
	--self:initiateLevel(self.probesLevel)
	launchProbes(dt)
	cameraFollowsProbe()
	self:probeMechanics(dt, probes, planetas)
  self:probeMechanics(dt, fragmentsOfProbe, planetas)
  Game:checkWin()  -- a Levels
  Game:checkOrbitsDone() -- a Levels
end

function Level:initiateLevel(probesLevel)
  if not self.initLevel  then
    self:orbitsNeededByLevel(probesLevel)
    self.initLevel = true
  end
end

function Level:probeMechanics(dt, tableProbes, tablePlanets)
  for i, prob in ipairs(tableProbes) do
    for j, planet in ipairs(tablePlanets) do
        
        prob:influencedByGravityOf(planet)
        prob:checkDestroyProbe(planet)
        prob:update(dt)
        
        if game.gameState == "play" and tableProbes == probes then
          prob:keyboardMove(dt)
        end
    end
  end
end

function Level:drawTableEntities(table)  -- dibuja planetas y probes
  for i, entity in ipairs(table) do
    entity:draw()
  end
end

function Level:orbitsNeededByLevel(orbits)
  for i = 1, orbits do
    table.insert(self.orbitsNeededToWin, false)
  end
end

