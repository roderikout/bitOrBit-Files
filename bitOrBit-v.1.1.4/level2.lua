
Level2 = Level:extend()

function Level2:new()
	
	Level2.super.new(self)

	self.probesLevel = 3
	self.levelNumber = 2

end

function Level2:draw()
  
  Level2.super.draw(self)

end

function Level2:update(dt)
	music:stop()
	music:play()
  	Level2.super.update(self, dt)

end