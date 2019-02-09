--[[
    BitOrBit v.1.1.5

    Author: Rodrigo Garcia
    roderikout@gmail.com

    Original by: Colton Ogden, cogden@cs50.harvard.edu
    
    -- PlayState Class --

    Represents the state of the game in which we are actively playing;
  
]]

PlayState = Class{__includes = BaseState}

--[[
    We initialize what's in our PlayState via a state table that we pass between
    states as we go from playing to serving.
]]
function PlayState:enter(params)
    
    self.level = params.level
    self.lastLevel = params.lastLevel
    self.firstLevel = params.firstLevel
    self.planet = params.planet

    --launching probes variables
    self.probesTable = LevelMaker.createLevel(self.level, self.planet)[2]
    self.probeLanzar = true
    self.probesOrbiting = {}
    self.probesForLaunch = {}
    self.launchInterval = 1
    self.timeProbes = 0

    self.probeSelected = 0

    self.paused = false

    gSounds['musicGamePlay']:play()
    gSounds['musicGamePlay']:setLooping(true)

    --debugging
    self.debug = 'Nothing happening'

end

function PlayState:update(dt)


  --manage pause state
  if self.paused then
      if love.keyboard.wasPressed('space') then
          self.paused = false
          for i, p in ipairs(self.probesTable) do
            p.paused = false
          end
      else
          return
      end
  elseif love.keyboard.wasPressed('space') then
      self.paused = true
      for i, p in ipairs(self.probesTable) do
        p.paused = true
      end
      return
  end

  --keyboard functions
  self:keyboardFunctions()

  --update probe launching and movement
  self:launchProbes(dt)
  if #self.probesOrbiting > 0 then
    self:probeMechanics(dt)
  end
  self:checkOrbitsDone()
  self:checkWin()
 
  if #self.planet.colorZones > 0 then
    self.debug = self.planet.colorZones[1].max
  end
end


function PlayState:keyboardFunctions()
   
  --manage exit and instructions
  if love.keyboard.wasPressed('escape') then
      gStateMachine:change('start')
  elseif love.keyboard.wasPressed('i') then
      self.instructionsOn = not self.instructionsOn
  end

  if love.keyboard.wasPressed('1') then
    if #self.probesForLaunch >= 1 then
      for i, p in ipairs(self.probesForLaunch) do   --recorrido por la tabla para desseleccionar cada probe
        p.selected = false
      end
      self.probesForLaunch[1].selected = true
      self.probeSelected = 1
    end
  elseif love.keyboard.wasPressed('2') then
    if #self.probesForLaunch >= 2 then
      for i, p in ipairs(self.probesForLaunch) do   --recorrido por la tabla para desseleccionar cada probe
        p.selected = false
      end
      self.probesForLaunch[2].selected = true
      self.probeSelected = 2
    end
  elseif love.keyboard.wasPressed('3') then
    if #self.probesForLaunch >= 3 then
      for i, p in ipairs(self.probesForLaunch) do   --recorrido por la tabla para desseleccionar cada probe
        p.selected = false
      end
      self.probesForLaunch[3].selected = true
      self.probeSelected = 3
    end
  elseif love.keyboard.wasPressed('4') then
    if #self.probesForLaunch >= 4 then
      for i, p in ipairs(self.probesForLaunch) do   --recorrido por la tabla para desseleccionar cada probe
        p.selected = false
      end
      self.probesForLaunch[4].selected = true
      self.probeSelected = 4
    end
  elseif love.keyboard.wasPressed('5') then
    if #self.probesForLaunch >= 5 then
      for i, p in ipairs(self.probesForLaunch) do   --recorrido por la tabla para desseleccionar cada probe
        p.selected = false
      end
      self.probesForLaunch[5].selected = true
      self.probeSelected = 5
    end
  elseif love.keyboard.wasPressed('6') then
    if #self.probesForLaunch >= 6 then
      for i, p in ipairs(self.probesForLaunch) do   --recorrido por la tabla para desseleccionar cada probe
        p.selected = false
      end
      self.probesForLaunch[6].selected = true
      self.probeSelected = 6
    end
  elseif love.keyboard.wasPressed('7') then
    if #self.probesForLaunch >= 7 then
      for i, p in ipairs(self.probesForLaunch) do   --recorrido por la tabla para desseleccionar cada probe
        p.selected = false
      end
      self.probesForLaunch[7].selected = true
      self.probeSelected = 7
    end
  elseif love.keyboard.wasPressed('8') then
    if #self.probesForLaunch >= 8 then
      for i, p in ipairs(self.probesForLaunch) do   --recorrido por la tabla para desseleccionar cada probe
        p.selected = false
      end
      self.probesForLaunch[8].selected = true
      self.probeSelected = 8
    end
  elseif love.keyboard.wasPressed('9') then
    if #self.probesForLaunch >= 9 then
      for i, p in ipairs(self.probesForLaunch) do   --recorrido por la tabla para desseleccionar cada probe
        p.selected = false
      end
      self.probesForLaunch[9].selected = true
      self.probeSelected = 9
    end
  elseif love.keyboard.wasPressed('0') then
    for i, p in ipairs(self.probesForLaunch) do   --recorrido por la tabla para desseleccionar cada probe
      p.selected = false
    end
    self.probeSelected = 0
  end

    if love.keyboard.wasPressed('x') then --remove probe
    if self.probeSelected > 0 then
      gSounds['explosion']:play()
      for i, p in ipairs(self.probesForLaunch) do
        if p.number == self.probeSelected then
          p.dead = true
        end
      end
      self.probesTable = LevelMaker.createLevel(self.level, self.planet)[2]
      self.probeSelected = 0
      self.timeProbes = 0
    end

  elseif love.keyboard.wasPressed('r') then -- reset all probes
    self.probesTable = LevelMaker.createLevel(self.level, self.planet)[2]
    self.probesForLaunch = {}
    self.probesOrbiting = {}
    self.probeSelected = 0
    self.timeProbes = 0
    self.paused  = false
    gSounds['explosion']:play()
  end

end

function PlayState:render()

  self.planet:render()
  self:drawTableEntities(self.probesForLaunch)

  if self.probeSelected > 0 then
    self:gravityBeam()
  end
  
  printTitle(self.level, self.debug, self.instructionsOn)

  if self.paused == true then
    love.graphics.setFont(gFonts['big'])
    love.graphics.printf("PAUSE",
      0, WINDOW_HEIGHT / 2, WINDOW_WIDTH, 'center')
  end

  --debugging
  if #self.planet.colorZones > 0 then
    love.graphics.setFont(gFonts['small'])
    love.graphics.setColor(255,255,255,255)
    love.graphics.print("Pmin text: " .. tostring(self.planet.colorZones[1].min), 10, 500)
    love.graphics.print("Pmax text: " .. tostring(self.planet.colorZones[1].max), 10, 530)
    love.graphics.print("Pmin text: " .. tostring(self.planet.colorZones[2].min), 10, 560)
    love.graphics.print("Pmax text: " .. tostring(self.planet.colorZones[2].max), 10, 590)
    love.graphics.print("Zones text: " .. tostring(#self.planet.colorZones), 10, 620)
  end

  

end

--[[ launchProbes:
  -Se encarga de lanzar las probes usando la funcion manageLaunchProbes en intervalos de tiempo X
  -Por cada probe lanzada se anade su numero id a la tabla probesOrbiting
  -Si por alguna razon cualquier probe deja de existir, se lanza de nuevo la misma probe pasado el tiempo X
]]--
function PlayState:launchProbes(dt)

  if self.timeProbes > self.launchInterval then
    if #self.probesForLaunch == 0 then
      self:manageLaunchProbes(true, 1)
    elseif #self.probesForLaunch > 0 and #self.probesForLaunch < #self.probesTable then
      for i, p in ipairs(self.probesTable) do
        if utils.tableCount(self.probesOrbiting, i) == 0 and self.timeProbes > self.launchInterval then
          self:manageLaunchProbes(false, i)
        end
      end
    end
  else
    self.timeProbes = self.timeProbes + dt
  end

end


--[[ manageLaunchProbes:
  -Establece la posicion, direccion y velocidad inicial de las probes, al azar, 
    segun un numero de posibilidades predeterminadas (4 opciones que no resultaron tan buenas) ARREGLAR, 
    se puede hacer en Enter muchas mas opciones una vez y en esta funcion solo se hace el randomchoice.  
  -El parametro first se refiere a si es la primera probe lanzada.
  -Establece las posibilidades para x, y y direccion
  -Selecciona una al azar
  -Le coloca un nombre ??
  -Crea una probe con esos datos al azar y con la velocidad tambien seleccionada entre dos limites.
  -Establece la posicion pop, para los circulos concentricos
  -La primera probe entra sola, las demas usando el parametro i
]]--

function PlayState:manageLaunchProbes(first, i)
  
  if first then
    self.probesForLaunch[1] = self.probesTable[1]
    self.probesForLaunch[1].dead = false
    self.probesOrbiting[1] = self.probesForLaunch[1].number
    self.timeProbes = 0
    gSounds['bwam']:play()
  else 
    table.insert(self.probesForLaunch, i, self.probesTable[i])
    table.insert(self.probesOrbiting, i, self.probesForLaunch[i].number)
    self.probesForLaunch[i].dead = false
    self.timeProbes = 0
    gSounds['bwam']:play()
  end

end



--[[ drawTableEntities:
  Para rendear todas las entidades que hay en una tabla (probes, por ejemplo)
]]--
function PlayState:drawTableEntities(table)
    
  for i, entity in ipairs(table) do
    entity:render()
  end

end

--[[ probeMechanics:
  -For loop entre todas las probes de la tabla y usa las funciones de:
    -influencedByGravityOf, para que se vean afectadas por la gravedad de un planeta
    -checkDestroyProbe, para ver si pasaron los limites interno y externo y destruir la probe
    -checkLowHigh, para establecer el punto alto y bajo de su orbita
    -Revisa si la probe esta muerta para eliminarla de la lista
    -Finalmente ejecuta el update de la probe
]]--
function PlayState:probeMechanics(dt)
  for i, p in ipairs(self.probesForLaunch) do        
      p:influencedByGravityOf(self.planet)
      p:checkDestroyProbe(self.planet)
      p:checkLowHigh(self.planet, self.colorZones)
      if p.dead then
        table.remove(self.probesForLaunch, i)
        table.remove(self.probesOrbiting, i)
        self.probesTable = LevelMaker.createLevel(self.level, self.planet)[2]
      end
      p:update(dt)
  end
end

--[[ gravityBeam:
  -Si estamos en modo play hacemos un for loop por todas las probes para ver si alguna esta seleccionada. ARREGLAR,
    se puede buscar si una esta seleccionada en la tabla y usar solo esa, no hacer el for loop cada frame
  -Dibuja el gravity beam sobre la probe seleccionada
]]--
function PlayState:gravityBeam()
  if not self.paused then
    for i, p in ipairs(self.probesForLaunch) do
      if p.selected then
        local anglePlanet =  math.atan2((p.pos.y - self.planet.pos.y), (p.pos.x - self.planet.pos.x))
        local rDistRel = p.r + utils.randomInt(5, 15)
        red, green, blue, alpha = utils.colorToLine(i, 150)
        love.graphics.setColor(red - 50, green - 50, blue + 50, alpha)
        love.graphics.polygon("fill", self.planet.x, self.planet.y, p.x + (math.sin(anglePlanet) * rDistRel), p.y - (math.cos(anglePlanet) * rDistRel), p.x - (math.sin(anglePlanet) * rDistRel), p.y + (math.cos(anglePlanet) * rDistRel))
        love.graphics.arc("fill", p.pos.x, p.pos.y, rDistRel, anglePlanet + math.rad(90), anglePlanet - math.rad(90))
        love.graphics.setColor(0,0,0,255)
        love.graphics.line(self.planet.x, self.planet.y, p.x + (math.sin(anglePlanet) * rDistRel), p.y - (math.cos(anglePlanet) * rDistRel))
        love.graphics.line(self.planet.x, self.planet.y, p.x - (math.sin(anglePlanet) * rDistRel), p.y + (math.cos(anglePlanet) * rDistRel))
        love.graphics.arc("line","open", p.pos.x, p.pos.y, rDistRel, anglePlanet + math.rad(90), anglePlanet - math.rad(90))
        love.graphics.setColor(255,255,255,255)
      end
    end
  end
end

--[[ checkOrbitsDone
  -For loop sobre las probes para ver si hay orbitas estables 
  -Si hay orbita estable se coloca un true en la misma posicion de la probe en la tabla orbitsNeededToWin, 
    creada segun el numero de probes de este nivel.
  -Se usa la propiedad intersect de la probe, que es cuando ha pasado 2 veces por el mismo punto de la orbita
    sin salirse de la misma
  -Si la probe se sale de la orbita, se llena esta posicion con false.
]]
function PlayState:checkOrbitsDone()  
  for i, p in ipairs(self.probesForLaunch) do
    if p.intersect then
      self.planet.orbitsNeededToWin[i] = true
    elseif not p.intersect then
      self.planet.orbitsNeededToWin[i] = false
    end
  end
end

--[[ checkWin:
  -Chequea si se lograron todas las orbitas de un nivel. 
  -Chequea si se completaron todos los niveles del juego.
  - Si solo se completo un nivel, sube al siguiente nivel y resetean 
    initLevel, orbitsNeededToWin, zonasColor y probes, y deselecciona la probe seleccionada.
]]
function PlayState:checkWin() 
  if #self.planet.orbitsNeededToWin > 0 then
    if utils.tableCount(self.planet.orbitsNeededToWin, true) == #self.planet.orbitsNeededToWin then
      self.level = self.level + 1
      if self.level <= self.lastLevel then
        self.planet = Planet(WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2, 20, 300000, 380, self.level + 1)
        gSounds['select']:play()
        
        gStateMachine:change('newLevel', {
            level = self.level,
            firstLevel = self.firstLevel,
            planet = self.planet,
            lastLevel = self.lastLevel,
        })
      else
        gSounds['select']:play()
      
        gStateMachine:change('win')
      end
    end
  end
end