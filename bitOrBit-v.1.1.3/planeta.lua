Planeta = Object:extend()

function Planeta:new(x, y, radius, mass, gravityRadius)
  
  self.x = x
  self.y = y
  self.radius = radius
  self.mass = mass
  self.gravityRadius = gravityRadius

  self.pos = vector(self.x,self.y)
  
  self.name = "none"
  self.probes = 0
  self.namesProbes = {}

  --gravity zones
  self.alpha = 80  --para color zones que deberia ser de planets
  self.zonasColor = {}
  
end

-- member functions

function Planeta:draw()
  for i = 1, game.level.probesLevel do
    self:colorZones(i)
  end
  if not game.gameWin then
    self:gravityBeam()
  end
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

function Planeta:update()

  

end

function Planeta:colorZones(i) --genera el círculo de la zona orbital del planeta i (# del planeta)
  local spaceBetween = self.radius * 5/6
  local spaceZone = self.gravityRadius - self.radius - spaceBetween
  local colorZone = spaceZone / game.level.probesLevel
  local lineWidth = colorZone - spaceBetween

  if game.level.orbitsNeededToWin[i] then
    self.alpha = 200
  elseif not game.level.orbitsNeededToWin[i] then
    self.alpha = 80
  end

  love.graphics.setLineWidth(lineWidth)
  love.graphics.setColor(utils.colorToLine(i, self.alpha))
  local zona = (((lineWidth + spaceBetween) * i) - lineWidth/2 + spaceBetween)
  local orbit = love.graphics.circle("line", self.pos.x, self.pos.y, zona)
  love.graphics.setLineWidth(1)
  love.graphics.setColor(100,100,100,255)
  local lineDwnOrbit = love.graphics.circle("line", self.pos.x, self.pos.y, zona - lineWidth/2)
  local lineUpOrbit = love.graphics.circle("line", self.pos.x, self.pos.y, zona + lineWidth/2)
  if #self.zonasColor < game.level.probesLevel then
    table.insert(self.zonasColor, {min = zona - (lineWidth / 2), max = zona + (lineWidth / 2)})
  end
  love.graphics.setColor(255,255,255,255)
end

function Planeta:gravityBeam() -- dibujar beam de atraccion gravitatoria
  if game.gameState == "play" then
    for i, prob in ipairs(game.level.probes) do
      if prob.selected then
        local anglePlanet =  math.atan2((prob.pos.y - self.pos.y), (prob.pos.x - self.pos.x))
        local rDistRel = prob.r + utils.randomInt(5, 25)
        red, green, blue, alpha = utils.colorToLine(i, 150)
        love.graphics.setColor(red - 50, green - 50, blue + 50, alpha)
        love.graphics.polygon("fill", self.x, self.y, prob.x + (math.sin(anglePlanet) * rDistRel), prob.y - (math.cos(anglePlanet) * rDistRel), prob.x - (math.sin(anglePlanet) * rDistRel), prob.y + (math.cos(anglePlanet) * rDistRel))
        love.graphics.arc("fill", prob.pos.x, prob.pos.y, rDistRel, anglePlanet + math.rad(90), anglePlanet - math.rad(90))
        love.graphics.setColor(0,0,0,255)
        love.graphics.line(self.x, self.y, prob.x + (math.sin(anglePlanet) * rDistRel), prob.y - (math.cos(anglePlanet) * rDistRel))
        love.graphics.line(self.x, self.y, prob.x - (math.sin(anglePlanet) * rDistRel), prob.y + (math.cos(anglePlanet) * rDistRel))
        love.graphics.arc("line","open", prob.pos.x, prob.pos.y, rDistRel, anglePlanet + math.rad(90), anglePlanet - math.rad(90))
        love.graphics.setColor(255,255,255,255)
      end
    end
  end
end