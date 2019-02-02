--[[ 

  BitOrBit v.1.1.6

    Author: Rodrigo Garcia
    roderikout@gmail.com

    -- Planet class --

  Para crear los planetas

]]--


Planet = Class{}

-- self.vector = require ("vector")

function Planet:init(x, y, radius, mass, gravityRadius, orbits)
  
  --local self = self or {}
  
  self.x = x
  self.y = y
  self.radius = radius
  self.mass = mass
  self.gravityRadius = gravityRadius

  self.pos = vector(self.x,self.y)

  self.name = 'none'

  --colored orbits data
  self.orbits = orbits
  self.orbitsNeededToWin = {}

  self.spaceBetween = self.radius * 5/6
  self.totalOrbitArea = self.gravityRadius - self.radius - self.spaceBetween
  self.orbitColoredArea = self.totalOrbitArea / self.orbits
  self.orbitWidth = self.orbitColoredArea - self.spaceBetween

  self.alpha = 80

  self.colorZones = {}
    
end

-- member functions

function Planet:render()
  
  --planet
  love.graphics.setColor(150,150,250,255)
  love.graphics.circle("fill", self.x, self.y, self.radius)
  love.graphics.setColor(30,30,30,255)
  love.graphics.circle("fill", self.x, self.y, self.radius - self.radius/10)
  
  --gravity
  love.graphics.setColor(150,150,150,255)
  love.graphics.circle("line", self.x, self.y, self.gravityRadius)
  love.graphics.setColor(255,255,255,255)

  --colored orbits
  self:renderColorZones()

end

function Planet:renderColorZones()

  for i = 1, self.orbits do
    if #self.orbitsNeededToWin > 0 then
      if self.orbitsNeededToWin[i] then
        self.alpha = 200
      elseif not self.orbitsNeededToWin[i] then
        self.alpha = 80
      end
    end

    love.graphics.setLineWidth(self.orbitWidth)
    love.graphics.setColor(utils.colorToLine(i, self.alpha))
    local zona = (((self.orbitWidth + self.spaceBetween) * i) - self.orbitWidth/2 + self.spaceBetween)
    local orbit = love.graphics.circle("line", self.x, self.y, zona)
    love.graphics.setLineWidth(1)
    love.graphics.setColor(100,100,100,255)
    local lineDwnOrbit = love.graphics.circle("line", self.x, self.y, zona - self.orbitWidth/2)
    local lineUpOrbit = love.graphics.circle("line", self.x, self.y, zona + self.orbitWidth/2)
    table.insert(self.colorZones, {min = zona - (self.orbitWidth / 2), max = zona + (self.orbitWidth / 2)})
    love.graphics.setColor(255,255,255,255)
  end

end