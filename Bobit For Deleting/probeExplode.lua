--30-11-2017

ProbeExplode = Probe:extend()

function ProbeExplode:new(x, y, speed, direction)

  ProbeExplode.super.new(self, x, y, speed, direction)

  self.r = 3
  self.type = "explode"
  self.stelaMax = 20

end
  
function ProbeExplode:draw()

  ProbeExplode.super.stelaDraw(self)
  self:probeDraw()
  
end
  
function ProbeExplode:update(dt)

  ProbeExplode.super.update(self, dt)
  ProbeExplode.super.stelaUpdate(self)
  self:probeDead()
  self:probeDecay(dt)

end

function ProbeExplode:probeDraw()
  love.graphics.setColor(255,255,255, self.alpha) 
  love.graphics.circle("fill", self.x, self.y, self.r)
  love.graphics.setColor(0,0,0,self.alpha)
  love.graphics.circle("line", self.x, self.y, self.r)
  love.graphics.setColor(255,255,255,255)
end

function ProbeExplode:probeDecay(dt)
  if level.currentLevel == 1 then
    local shift = lume.random(500, 600) 
    self.alpha = self.alpha - shift * dt
    if self.alpha < 0 then
      table.remove(fragmentsOfProbe, #fragmentsOfProbe)
    end
  end
end

function ProbeExplode:probeDead()
  if self.dead then
    table.remove(fragmentsOfProbe, #fragmentsOfProbe)
  end
end