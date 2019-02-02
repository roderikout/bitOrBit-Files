
--08-12-2017

Level2 = Level:extend()

function Level2:new()

	self.probesLevel = 3  --cuantas probes tiene este nivel
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
	self.currentLevel = 2
	Level1.super.new(self)

end

function Level2:draw()
  Level2.super.draw(self)
end

function Level2:update(dt)
	music2:stop()
	music:setLooping(true)
	music:play()
  	Level2.super.update(self, dt)
end