--08-12-2017

ScreenStart = Screen:extend()  --Este objeto debería ser otro diferente a Nivel. Un objeto dedicado a pantallas de transición, pantallas finales, de puntuación, inicio, instrucciones, configuración, etc.

-- flags
local a = 0 --Crece indefinido
local b = 0 --Será el seno de a

function ScreenStart:new()

	ScreenStart.super.new(self)

	self.instructionsOn = false

	self.map = { --Mapa del texto BitOrbIT
		{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
		{ 0, 1, 1, 1, 2, 0, 1, 0, 1, 1, 1, 0 },
		{ 0, 1, 0, 1, 1, 0, 1, 0, 0, 1, 0, 0 },
		{ 0, 1, 1, 1, 2, 0, 1, 0, 0, 1, 0, 0 },
		{ 0, 1, 0, 1, 1, 0, 1, 0, 0, 1, 0, 0 },
		{ 0, 1, 1, 1, 0, 0, 1, 0, 0, 1, 0, 0 },
		{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
		{ 0, 1, 1, 1, 1, 0, 1, 1, 1, 2, 0, 0 },
		{ 0, 1, 0, 0, 1, 0, 1, 0, 1, 1, 0, 0 },
		{ 0, 1, 0, 0, 1, 0, 1, 0, 1, 1, 0, 0 },
		{ 0, 1, 0, 0, 1, 0, 1, 1, 1, 2, 0, 0 },
		{ 0, 1, 1, 1, 1, 0, 1, 1, 3, 1, 0, 0 },
		{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
		{ 0, 1, 1, 1, 2, 0, 1, 0, 1, 1, 1, 0 },
		{ 0, 1, 0, 1, 1, 0, 1, 0, 0, 1, 0, 0 },
		{ 0, 1, 1, 1, 2, 0, 1, 0, 0, 1, 0, 0 },
		{ 0, 1, 0, 1, 1, 0, 1, 0, 0, 1, 0, 0 },
		{ 0, 1, 1, 1, 0, 0, 1, 0, 0, 1, 0, 0 },
		{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }
	}

end

function ScreenStart:update(dt)
	music2:setLooping(true)
	music2:play()

	a = a + (10 * dt)
	b = math.sin(a) + b
end

function ScreenStart:draw()

	self:drawStartLogo()
	self:drawStartText()
	
end

function ScreenStart:drawStartLogo()  --dibuja el nombre del juego con sus animaciones
	for y=1, #self.map do
		for x=1, #self.map[y] do
			if self.map[y][x] == 1 then
				love.graphics.rectangle("fill", x * 37, y * 37, 30 + b, 30 + b)
			elseif self.map[y][x] == 2 then

			elseif self.map[y][x] == 3 then

			end
		end
	end
end

function ScreenStart:drawStartText()  --escribe los textos de inicio y las instrucciones
	local font = love.graphics.setNewFont(30)
	local font2 = love.graphics.setNewFont(20)
	local fontHeight = font:getHeight()
	
	if not self.instructionsOn then
		love.graphics.setFont(font)
		love.graphics.print("Press \"Space\" to start", width/2 - b, height/2)
		love.graphics.print("Press \"i\" to read the instructions", width/2 - b, height/2 + fontHeight)
	else
		love.graphics.setFont(font2)
		love.graphics.printf("-Try to take each probe to the orbit of the correct color using only the thrusters to accelerate or decelerate it\n\n\nKeys:\n\n-Press 'Space' to launch the probes\n\n-Use up and down arrows to accelerate or decelerate the probe\n\n-Press 'P' to select and cicle between the probes\n\n-Press 'X' when a probe is selected to destroy it and create a new one\n\n-Press 'R' to reset all the probes\n\n-Use 'A' and 'Z' to zoom in and out\n\n-Press 'F' to follow the selected probe\n\n-Press 'Escape' to exit the game\n\n-Press 'Space' to start the game\n\n-Press 'H' to pause the game\n\n-Press 'I' to exit the instructions", width/2, 60, 600, 'left')
	end
end