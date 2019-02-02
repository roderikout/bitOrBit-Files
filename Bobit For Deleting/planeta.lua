Planeta = Object:extend()
vector = require ("vector")

function Planeta:new(x, y, radius, mass, gravityRadius)
  
  local self = self or {}
  
  self.x = x
  self.y = y
  self.radius = radius
  self.mass = mass
  self.gravityRadius = gravityRadius

  self.pos = vector(self.x,self.y)
  
  self.name = "none"
  self.probes = 0
  self.namesProbes = {}
  
end

-- member functions

function Planeta:draw()
  
  --planeta
  love.graphics.setColor(150,150,250,255)
  love.graphics.circle("fill", self.x, self.y, self.radius)
  love.graphics.setColor(10,10,10,255)
  love.graphics.circle("fill", self.x, self.y, self.radius - 10)
  
  --gravedad
  love.graphics.setColor(150,150,150,255)
  love.graphics.circle("line", self.x, self.y, self.gravityRadius)
  love.graphics.setColor(255,255,255,255)
  
end
  