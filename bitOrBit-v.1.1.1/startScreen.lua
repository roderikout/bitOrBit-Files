map = {
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

-- flags
a = 1
b = "up"
instructionsOn = false


startDraw = function ()
				drawStartScreen()
				local font = love.graphics.setNewFont(30)
				local font2 = love.graphics.setNewFont(20)
				local fontHeight = font:getHeight()
				
				if not instructionsOn then
					love.graphics.setFont(font)
					love.graphics.print("Press \"Space\" to start", width/2 - a, height/2)
					love.graphics.print("Press \"i\" to read the instructions", width/2 - a, height/2 + fontHeight)
				else
					love.graphics.setFont(font2)
					love.graphics.printf("-Try to take each probe to the orbit of the correct color using only the thrusters to accelerate or decelerate it\n\n\nKeys:\n\n-Press 'Space' to launch the probes\n\n-Use up and down arrows to accelerate or decelerate the probe\n\n-Press 'P' to select and cicle between the probes\n\n-Press 'X' when a probe is selected to destroy it and create a new one\n\n-Press 'R' to reset all the probes\n\n-Use 'A' and 'Z' to zoom in and out\n\n-Press 'F' to follow the selected probe\n\n-Press 'Escape' to exit the game\n\n-Press 'Space' to start the game\n\n-Press 'H' to pause the game\n\n-Press 'I' to exit the instructions", width/2, 60, 600, 'left')
				end
			end
startUpdate = function (dt)
				if b =="up" then
					a = a + (10 * dt)
					if a > 7 then
						b = "down"
					end
				elseif b == "down" then
					a = a - (10 * dt)
					if a < 1 then
						b = "up"
					end
				end
			end

function drawStartScreen()
	for y=1, #map do
		for x=1, #map[y] do
			if map[y][x] == 1 then
				love.graphics.rectangle("fill", x * 37, y * 37, 30 + a, 30 + a)
			elseif map[y][x] == 2 then

			elseif map[y][x] == 3 then

			end
		end
	end
end