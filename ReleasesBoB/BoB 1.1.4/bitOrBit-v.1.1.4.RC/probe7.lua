--30-11-2017

Probe = Object:extend()

function Probe:new(x, y, speed, direction)

  self.x = x
  self.y = y
  self.pos= vector(self.x, self.y)
  self.speed = speed
  self.direction = direction
  self.sp = vector.fromPolar(self.direction, self.speed)

  self.gravityAngle = 0

  self.probeStela = {}
  self.stelaMax = 40
  
  self.alpha = 255
  --self.stelaAlpha = self.alpha/10
  self.vectorDirection = {x =0, y = 0}
  self.distanceToPlanet = 0
  
end
  
function Probe:draw()

  --draw probe
  self:probeDraw()

  -- draw estela
  self:stelaDraw()

end

function Probe:probeDraw()
  love.graphics.setColor(colorToLine(self.number, self.alpha)) 
  love.graphics.circle("fill", self.x, self.y, self.r)
  love.graphics.setColor(0,0,0,255)
  love.graphics.circle("line", self.x, self.y, self.r)
  love.graphics.setColor(255,255,255,255)
end

function Probe:stelaDraw()
  for i, probs in ipairs(self.probeStela) do
    love.graphics.setColor(colorToLine(self.number, self.alpha/10 * (#self.probeStela - i * 1.8) / #self.probeStela))
    love.graphics.circle('fill', probs.x, probs.y, self.r / (1 + (i * 0.02)))    
  end
end
  
function Probe:update(dt)

  self.prevPos = self.pos

  self:stelaUpdate()

  self.pos = self.pos + self.sp * dt

  self.postPos = self.pos

  self.direction = math.atan2((self.pos.y - self.prevPos.y), (self.pos.x - self.prevPos.x))

  self.x = self.pos.x
  self.y = self.pos.y

end

function Probe:stelaUpdate()
  if #self.probeStela < self.stelaMax then
    table.insert(self.probeStela, 1, self.pos)
  end
  if #self.probeStela == self.stelaMax then
    table.remove(self.probeStela, #self.probeStela)
  end
end

function Probe:influencedByGravityOf(planet)

    self.planet = planet
    self.distanceToPlanet = self.pos:dist(planet.pos)
    local distanceToPlanetSq = self.pos:dist2(planet.pos)
    local gravity = (planet.mass / distanceToPlanetSq)
    local gravAngle = math.atan2((self.pos.y - planet.pos.y), (self.pos.x - planet.pos.x))
    local xGrav = math.sin(gravAngle - math.pi/2) * gravity
    local yGrav = math.cos(gravAngle + math.pi/2) * gravity
    local gravAccel = vector(xGrav, yGrav)
    self.sp = self.sp + gravAccel

end

