--26-11-2017

Probe = Object:extend()
vector = require ("vector")
utils = require("utils")

function Probe:new(x, y, speed, direction)

  self.x = x
  self.y = y
  self.pos= vector(self.x, self.y)
  self.prevPos = vector(0,0)
  self.postPos = vector(0,0)
  self.speed = speed
  self.direction = direction
  self.sp = vector.fromPolar(self.direction, self.speed)

  self.r = 15
  self.planet = "none"
  self.name = "none"
  self.number = 0
  self.selected = false
  self.newBorn = true

  self.probeThrustPower = 50
  self.probeThrustTotal = 200

  self.gravityAngle = 0
  self.highestDistance = {0, 0, 0}
  self.lowestDistance = {10000, 0, 0}

  self.probeStela = {}
  self.stelaMax = 40

  --Pop circle waves
  self.popX = 0
  self.popY = 0
  self.radCirc = 10
  self.alphaCirc = 80
  self.lineaCircles = 3

  self.alpha = 255
  self.stelaAlpha = 25
  self.a = {x =0, y = 0}

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

  
end
  
function Probe:draw()

  self:drawEntire()

end
  
function Probe:update(dt)

  self.prevPos = self.pos
  if #self.probeStela < self.stelaMax then
    table.insert(self.probeStela, 1, self.pos)
  end
  if #self.probeStela == self.stelaMax then
    table.remove(self.probeStela, #self.probeStela)
  end
  self.pos = self.pos + self.sp * dt
  self.postPos = self.pos

  self.direction = math.atan2((self.pos.y - self.prevPos.y), (self.pos.x - self.prevPos.x))

  self.x = self.pos.x
  self.y = self.pos.y

  if self.radCirc > 0 then
    self.radCirc = self.radCirc + (15 * (dt * 5))
    self.alphaCirc =  self.alphaCirc - (21 * (dt * 5))
    if self.radCirc > 190 then
      self.radCirc = 0
      self.alphaCirc = 0
    end
  end
  
  if self.selected then
    if love.keyboard.isDown("up") then
      self.up = true
    elseif love.keyboard.isDown("down") then
      self.down = true
    else
      self.up = false
      self.down = false
    end
  end

  self:checkLowHigh()

end

function Probe:drawEntire()
  if (self.selected == false and probeSelected == 0) or self.selected then
    self.alpha = 255
  elseif self.number ~= probeSelected then
    self.alpha = 155
  end

  self:drawPopCircles()

  self:drawForces()

  self:drawProbeInOrbitLine()
  if state == "play" then
    if self.up then
      self:drawTrhust("up")
    elseif self.down then
      self:drawTrhust("down")
    end
  end

  -- estela
  for i, probs in ipairs(self.probeStela) do
    love.graphics.setColor(colorToLine(self.number, self.stelaAlpha * (#self.probeStela - i * 1.8) / #self.probeStela))
    love.graphics.circle('fill', probs.x, probs.y, self.r / (1 + (i * 0.02)))    
  end

  love.graphics.setColor(colorToLine(self.number, self.alpha)) 
  love.graphics.circle("fill", self.x, self.y, self.r)
  love.graphics.setColor(0,0,0,255)
  love.graphics.circle("line", self.x, self.y, self.r)
  love.graphics.setColor(255,255,255,255)

end

function Probe:influencedByGravityOf(planet)

    self.planet = planet
    local distanceToPlanet = self.pos:dist(planet.pos)
    local distanceToPlanet2 = self.pos:dist2(planet.pos)
    local gravity = (planet.mass / distanceToPlanet2)
    local gravAngle = math.atan2((self.pos.y - planet.pos.y), (self.pos.x - planet.pos.x))
    local xGrav = math.sin(gravAngle - math.pi/2) * gravity
    local yGrav = math.cos(gravAngle + math.pi/2) * gravity
    local gravAccel = vector(xGrav, yGrav)
    self.sp = self.sp + gravAccel

  if distanceToPlanet + self.r > planet.gravityRadius then --Si la probe se sale del campo de gravedad
    probeLanzar = true
    if self.selected then
      probeSelected = 0
    end
    table.remove(probes, self.number)
  elseif distanceToPlanet - self.r < planet.radius then  --Si la probe se estrella contra el planeta
     probeLanzar = true
    if self.selected then
      probeSelected = 0
    end
    table.remove(probes, self.number) 
  end

end

function Probe:keyboardMove(dt)
  if self.selected then
    self.a = vector.fromPolar(self.direction, self.probeThrustPower)
    local b = self.a:rotated(math.pi/2)
    if love.keyboard.isDown("up") then
      self.sp = self.sp + self.a * dt
    elseif love.keyboard.isDown("down") then
      self.sp = self.sp - self.a * dt
    end
  end
end

function Probe:drawPopCircles()
  love.graphics.setLineWidth(self.lineaCircles)
  love.graphics.setColor(250, 250, 250, self.alphaCirc)
  love.graphics.circle("line", self.popX, self.popY, self.radCirc)
  love.graphics.setColor(250, 250, 250, self.alphaCirc - 5)
  love.graphics.circle("line", self.popX, self.popY, self.radCirc - 20)
  love.graphics.setColor(250, 250, 250, self.alphaCirc - 10)
  love.graphics.circle("line", self.popX, self.popY, self.radCirc - 40)
  love.graphics.setColor(255, 255, 255, 255)
end

function Probe:drawTrhust(dir)
  love.graphics.setLineWidth(15)
  local rInt = utils.randomInt(1,2)
  local direction = math.atan2((self.pos.y - self.prevPos.y), (self.pos.x - self.prevPos.x))
  if dir == "up" then
    love.graphics.setColor(255,255,255,150)
    love.graphics.polygon('fill', self.pos.x +(math.sin(direction) * 10), self.pos.y - (math.cos(direction) * 10), self.pos.x - (math.sin(direction) * 10), self.pos.y + (math.cos(direction) * 10), self.pos.x - (self.a.x * 1), self.pos.y - (self.a.y * 1))
    --love.graphics.line(self.pos.x, self.pos.y, self.pos.x - (self.a.x * 2), self.pos.y - (self.a.y * 2))
  elseif dir == "down" then
    love.graphics.setColor(255,255,255,150)
    love.graphics.polygon('fill', self.pos.x - (math.sin(direction) * 10), self.pos.y + (math.cos(direction) * 10), self.pos.x + (math.sin(direction) * 10), self.pos.y - (math.cos(direction) * 10), self.pos.x + (self.a.x * 1), self.pos.y + (self.a.y * 1))
    --love.graphics.line(self.pos.x, self.pos.y, self.pos.x + (self.a.x * 2), self.pos.y + (self.a.y * 2))
  end
  love.graphics.setColor(255,255,255,255)
  love.graphics.setLineWidth(1)
end

function Probe:checkLowHigh()
  for i, planet in ipairs(planetas) do
    local intersection = false
    local vectorPlanet = vector.new(planet.x, planet.y)
    local zonaMin = zonasColor[self.number].min
    local zonaMax = zonasColor[self.number].max 
    local distancia = utils.distanceTo(self.x, self.y, planet.x, planet.y)
    local angle = math.atan2((self.pos.y - planet.y), (self.pos.x - planet.x))

    if distancia - self.r > zonaMin and distancia + self.r < zonaMax and not self.die then 
      self.pIn = vector.fromPolar(angle, distancia)
      self.pMin = vector.fromPolar(angle, zonaMin)
      self.pMax = vector.fromPolar(angle, zonaMax)
      self.inMyOrbit = true
      table.insert(self.probeMinMax, {pIn = self.pIn, pMin = self.pMin, pMax = self.pMax})
      if #self.probeInOrbitLine == 0 then
        table.insert(self.probeInOrbitLine, {pIn = self.pIn, pMin = self.pMin, pMax = self.pMax})
      end
    elseif distancia - self.r < zonaMin or distancia + self.r > zonaMax and not self.die then
      self.probeInOrbitLine = {}
      self.probeMinMax = {}
      self.laps = 0
      self.inMyOrbit = false
    end


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
end

function Probe:drawProbeInOrbitLine()  --revisar qué pasa con esta funcion
  if #self.probeInOrbitLine > 0 and self.drawInOrbitLine then
    love.graphics.setColor(colorToLine(self.number, 120))
    love.graphics.setPointSize(5)
    love.graphics.points(self.probeInOrbitLine[1].pIn.x, self.probeInOrbitLine[1].pIn.y) --point in
    love.graphics.line(self.probeInOrbitLine[1].pMin.x, self.probeInOrbitLine[1].pMin.y, self.probeInOrbitLine[1].pMax.x, self.probeInOrbitLine[1].pMax.y)
    love.graphics.setPointSize(1)
    love.graphics.setColor(255,255,255,255)
  end
end

function Probe:drawForces()
  if self.drawForce then
    love.graphics.setColor(250,250,250,50)
    love.graphics.line(self.pos.x, self.pos.y, self.pos.x + (self.sp.x * 0.3), self.pos.y + (self.sp.y * 0.3)) 
    love.graphics.setColor(255,255,255,255)
  end
end