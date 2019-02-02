
Level1 = Level:extend()

function Level1:new()
	
	Level1.super.new(self)

	self.probesLevel = 2
	self.levelNumber = 1

end

function Level1:draw()
	
  Level1.super.draw(self)

end

function Level1:update(dt)
	music2:stop()
	music:play()	
  	Level1.super.update(self, dt)
end