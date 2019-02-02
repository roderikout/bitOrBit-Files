--02-12-2017

--instancia de probe

ProbeActive = Probe:extend()

function ProbeActive:new(x, y, speed, direction)

  ProbeActive.super.new(self, x, y, speed, direction)
  
  self.prevPos = vector(0,0)
  self.postPos = vector(0,0)

  self.r = 15
  self.planet = "none"
  self.name = "none"
  self.type = "active"
  self.number = 0
  self.selected = false
  self.newBorn = true

  self.probeThrustPower = 50
  self.probeThrustTotal = 200

  self.highestDistance = {0, 0, 0}
  self.lowestDistance = {10000, 0, 0}

  --Pop circle waves
  self.popX = 0
  self.popY = 0
  self.radCirc = 10
  self.alphaCirc = 80
  self.lineaCircles = 3

  self.up = false
  self.down = false

  self.probeInOrbitLine = {}
  self.probeMinMax = {}

  self.pIn = {0,0}
  self.pMin = {0,0}
  self.pMax = {0,0}

  self.intersect = false
  self.laps = 0

  self.firstIntersection = false

  self.drawForce = false
  self.drawInOrbitLine = false

  self.inMyOrbit = false

  

  self.die = false
  self.dead = false

  local intersection = false
  local vectorPlanet = {0,0}
  local zonaMin = 0
  local zonaMax = 0
  local distancia = 0
  local angle = 0

end
  
function ProbeActive:draw()

  if (self.selected == false and probeSelected == 0) or self.selected then  --probesSelected esta en probesData
    self.alpha = 255
  elseif self.number ~= probeSelected then
    self.alpha = 155
  end

  self:popCirclesDraw()

  self:drawForces()

  self:drawProbeInOrbitLine()

  if game.gameState == "play" and not game.gameWin then
    if self.up then
      self:drawThrust("up")
    elseif self.down then
      self:drawThrust("down")
    end
  end

  ProbeActive.super.draw(self)
  ProbeActive.super.probeDraw(self)
  ProbeActive.super.stelaDraw(self)



end
  
function ProbeActive:update(dt)

  ProbeActive.super.update(self, dt)

  self:popCirclesUpdate(dt)
  
  if self.selected and not game.gameWin then
    if love.keyboard.isDown("up") then
      self.up = true
      trust:play()
    elseif love.keyboard.isDown("down") then
      self.down = true
      trust:play()
    else
      self.up = false
      self.down = false
      trust:stop()
    end
  end

  self:checkLowHigh()
  self:dyingToDead()


end

function Probe:popCirclesUpdate(dt)  --ondas de aparición de la probe
  if self.radCirc > 0 then
    self.radCirc = self.radCirc + (15 * (dt * 5))
    self.alphaCirc =  self.alphaCirc - (21 * (dt * 5))
    if self.radCirc > 190 then
      self.radCirc = 0
      self.alphaCirc = 0
    end
  end
end


function ProbeActive:keyboardMove(dt)  --movimiento de la probe con el teclado
  if self.selected then
    self.vectorDirection = vector.fromPolar(self.direction, self.probeThrustPower)
    local b = self.vectorDirection:rotated(math.pi/2)
    if love.keyboard.isDown("up") then
      self.sp = self.sp + self.vectorDirection * dt
    elseif love.keyboard.isDown("down") then
      self.sp = self.sp - self.vectorDirection * dt
    end
  end
end

function ProbeActive:popCirclesDraw() --dibujar las ondas de aparicicón de la probe
  love.graphics.setLineWidth(self.lineaCircles)
  love.graphics.setColor(250, 250, 250, self.alphaCirc)
  love.graphics.circle("line", self.popX, self.popY, self.radCirc)
  love.graphics.setColor(250, 250, 250, self.alphaCirc - 5)
  love.graphics.circle("line", self.popX, self.popY, self.radCirc - 20)
  love.graphics.setColor(250, 250, 250, self.alphaCirc - 10)
  love.graphics.circle("line", self.popX, self.popY, self.radCirc - 40)
  love.graphics.setColor(255, 255, 255, 255)
  love.graphics.setLineWidth(1)
end

function ProbeActive:drawThrust(dir)  --dibujar el propulsor 
  love.graphics.setLineWidth(15)
  local rInt = utils.randomInt(1,2)
  local direction = math.atan2((self.pos.y - self.prevPos.y), (self.pos.x - self.prevPos.x))
  if dir == "up" then
    local long = lume.random(0.5, 2)
    local shift = lume.random(-2, 2)
    love.graphics.setColor(255,255,255,150)
    love.graphics.polygon('fill', self.pos.x +(math.sin(direction) * 10), self.pos.y - (math.cos(direction) * 10), self.pos.x - (math.sin(direction) * 10), self.pos.y + (math.cos(direction) * 10), self.pos.x - (self.vectorDirection.x * long - shift), self.pos.y - (self.vectorDirection.y * long - shift))
  elseif dir == "down" then
    local long = lume.random(0.5, 2)
    local shift = lume.random(-2, 2)
    love.graphics.setColor(255,255,255,150)
    love.graphics.polygon('fill', self.pos.x - (math.sin(direction) * 10), self.pos.y + (math.cos(direction) * 10), self.pos.x + (math.sin(direction) * 10), self.pos.y - (math.cos(direction) * 10), self.pos.x + (self.vectorDirection.x * long - shift), self.pos.y + (self.vectorDirection.y * long - shift))
  end
  love.graphics.setColor(255,255,255,255)
  love.graphics.setLineWidth(1)
end

function ProbeActive:checkLowHigh() --Define la zona más alta y la más baja de las orbitas
  for i, planet in ipairs(game.level.planetas) do
    intersection = false
    vectorPlanet = vector.new(planet.x, planet.y)
    zonaMin = planet.zonasColor[self.number].min
    zonaMax = planet.zonasColor[self.number].max 
    distancia = utils.distanceTo(self.x, self.y, planet.x, planet.y)
    angle = math.atan2((self.pos.y - planet.y), (self.pos.x - planet.x))

    self:checkInsideOrbit()
    self:checkLaps()

  end
end

function ProbeActive:checkInsideOrbit() --chequea que una probe se encuentra en su orbita
   if distancia - self.r > zonaMin and distancia + self.r < zonaMax then 
      self.pIn = vector.fromPolar(angle, distancia)
      self.pMin = vector.fromPolar(angle, zonaMin)
      self.pMax = vector.fromPolar(angle, zonaMax)
      self.inMyOrbit = true
      table.insert(self.probeMinMax, {pIn = self.pIn, pMin = self.pMin, pMax = self.pMax})
      if #self.probeInOrbitLine == 0 then
        table.insert(self.probeInOrbitLine, {pIn = self.pIn, pMin = self.pMin, pMax = self.pMax})
      end
    elseif distancia - self.r < zonaMin or distancia + self.r > zonaMax then
      self.probeInOrbitLine = {}
      self.probeMinMax = {}
      self.laps = 0
      self.inMyOrbit = false
    end
end

function ProbeActive:checkLaps() --chequea que una probe haya dado una revolución exitosa
  if self.inMyOrbit then
    intersection = utils.intersectSegment(self.prevPos.x, self.prevPos.y, self.postPos.x, self.postPos.y, self.probeInOrbitLine[1].pMin.x, self.probeInOrbitLine[1].pMin.y, self.probeInOrbitLine[1].pMax.x, self.probeInOrbitLine[1].pMax.y)
  end

  if intersection then
    if self.firstIntersection == false then
      self.laps = self.laps + 1
      self.firstIntersection = true
    end
  else
    self.firstIntersection = false
  end

  if self.laps > 2 then
    self.intersect = true
  else
    self.intersect = false
  end
end

function ProbeActive:drawProbeInOrbitLine()  --dibuja una linea en la entrada de la probe a su orbita. (desactivada)
  if #self.probeInOrbitLine > 0 and self.drawInOrbitLine then
    love.graphics.setColor(utils.colorToLine(self.number, 120))
    love.graphics.setPointSize(5)
    love.graphics.points(self.probeInOrbitLine[1].pIn.x, self.probeInOrbitLine[1].pIn.y) --point in
    love.graphics.line(self.probeInOrbitLine[1].pMin.x, self.probeInOrbitLine[1].pMin.y, self.probeInOrbitLine[1].pMax.x, self.probeInOrbitLine[1].pMax.y)
    love.graphics.setPointSize(1)
    love.graphics.setColor(255,255,255,255)
  end
end

function ProbeActive:drawForces() --dibuja los vectores de velocidad de la probe. (desactivada)
  if self.drawForce then
    love.graphics.setColor(250,250,250,50)
    love.graphics.line(self.pos.x, self.pos.y, self.pos.x + (self.sp.x * 0.3), self.pos.y + (self.sp.y * 0.3)) 
    love.graphics.setColor(255,255,255,255)
  end
end

function ProbeActive:dyingToDead() --hace que una probe que explotó se convierta en sus fragmentos y luego muera
  if self.die and not self.dead then
    local numFragments = lume.random(19, 29)
    for j = 1, numFragments do
      local sizeFragments = lume.random(2, 6)
      local probFrag = ProbeExplode(self.pos.x, self.pos.y, lume.random(200,250), lume.random(0, math.rad(360)))
      probFrag.parent = self.name
      probFrag.number = j
      probFrag.mass = sizeFraments
      probFrag.r = sizeFragments
      probFrag.type = "explode"
      table.insert(game.level.fragmentsOfProbe, j, probFrag)
      self.die = false
      self.dead = true
    end
  elseif self.dead then
    table.remove(game.level.probes, self.number)
  end
end