
Level1 = Level:extend()

function Level1:new()
	
	self.probesLevel = 2  --cuantas probes tiene este nivel
	self.planetsLevel = 1 -- cuantos planetas tiene este nivel
	self.planets = {
				{ --unico planeta de este nivel
				x = 0,
	            y = 0,
	            radius = 30,
	            mass = 1000000,
	            gravityRadius = 600,
	            name = "planeta1",
	            satellites = 0
	            }
	        }
	self.currentLevel = 1
	Level1.super.new(self)
end

function Level1:draw()
  Level1.super.draw(self)
end

function Level1:update(dt)
	music2:stop()
	music:setLooping(true)
	music:play()	
  	Level1.super.update(self, dt)
end