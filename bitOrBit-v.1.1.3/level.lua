--08-12-2017

Level = Object:extend()

--require ("levelStart")
require ("level1")
require ("level2")


function Level:new()

	self.initLevel = false  --flag para comenzar el nivel con todos sus valores iniciales
	self.instructionsOn = false
  self.orbitsNeededToWin = {} -- tabla que se llena con las orbitas que se necesitan para ganar

  self.cameraFollows = false

  self.probes = {}
  self.fragmentsOfProbe = {}
  self.probeLanzar = false

  self.planetas = {}

 --crear planetas
  self:initiatePlanets()
  self:initiateProbes()

end


function Level:draw()
	cameraMain:draw(
    function()
        self:drawTableEntities(self.planetas) --dibuja las probes o los planetas
        self:drawTableEntities(self.probes) --dibuja las probes o los planetas
        for i, probe in ipairs(self.probes) do
          self:drawTableEntities(self.fragmentsOfProbe) --dibuja las probes o los planetas
        end
        end)  
	printTexts() --imprime textos en la pantalla. En prints.lua
end

function Level:update(dt)
	if game.gameState == 'pause' then
		return
	end
  if self.currentLevel > 0 then
  	self:initiateLevel(self.probesLevel)
  	launchProbes(dt) --lanza las probes, se crea en gameMechanics.lua
  	self:cameraFollowsProbe() --seguir la probe con la camara
  	self:probeMechanics(dt, self.probes, self.planetas) 
    self:probeMechanics(dt, self.fragmentsOfProbe, self.planetas)
    Game:checkWin()  -- Chequea si se gano finalmente
    Game:checkOrbitsDone() -- Chequea si se supero un nivel
  end
end

function Level:initiateLevel(probesLevel) --para setear el nivel al inicio del juego. Con un flag.
  if not self.initLevel  then 
    self:orbitsNeededByLevel(probesLevel)
    self.initLevel = true
  end
end

function Level:probeMechanics(dt, tableProbes, tablePlanets) --activa la mecanica orbital de las probes
  for i, prob in ipairs(tableProbes) do
    for j, planet in ipairs(tablePlanets) do
        
        prob:influencedByGravityOf(planet) --influencia gravitacional del planeta
        prob:checkDestroyProbe(planet) --si la probe se destruye
        prob:update(dt) 
        
        if game.gameState == "play" and tableProbes == self.probes then
          prob:keyboardMove(dt) --mover la probe con up y down
        end
    end
  end
end

function Level:drawTableEntities(table)  -- dibuja planetas y probes
  for i, entity in ipairs(table) do
    entity:draw()
  end
end

function Level:orbitsNeededByLevel(orbits) --setting de las orbitas necesarias para completar cada nivel
  for i = 1, orbits do
    table.insert(self.orbitsNeededToWin, false)
  end
end

function Level:cameraFollowsProbe() -- Hace que la camara vaya a la probe seleccionada cuando se le dio a F
  if game.level.cameraFollows and self.probes[probeSelected] then  -- por qué no funciona con self y sí con level?
    cameraMain:zoomTo(1.5)
        cameraMain:lockPosition(self.probes[probeSelected].x, self.probes[probeSelected].y, cameraMain.smooth.damped(3))
  else
    cameraMain:zoomTo(0.65)
        cameraMain:lockPosition(0, 0, cameraMain.smooth.damped(3)) --Ojo con esto cuando haya varios planetas
  end
end

function Level:initiatePlanets()
  if self.planets then
    for i, _ in ipairs(self.planets) do
      local plan  = Planeta(
                      self.planets[i].x, 
                      self.planets[i].y, 
                      self.planets[i].radius,
                      self.planets[i].mass,
                      self.planets[i].gravityRadius
                      )
      plan.name = self.planets[i].name
      plan.probes = self.planets[i].satellites
      self.planetas[i] = plan
    end
  end
end

function Level:initiateProbes()
  probeSpeedInitialMin = 300
  probeSpeedInitialMax = 400
  for i, planet in ipairs(self.planetas) do
    probeX = planet.gravityRadius * 2/5 
    probeY = planet.gravityRadius * 2/5
  end
  probXprev = 0
  probYprev = 0
  probXpost = 0
  probYpost = 0
  probeSizeMin = 15
  probeSizeMax = 25
  probeDirectionMin = math.rad(180)
  probeDirectionMax = math.rad(190)
  probeExplode = false
  probeThrustTotal = 200
  probesOrbiting = {}
  probesMax = 3 
  probeSelected = 0
  launchInterval = 0.5
  timeProbes = 0
end