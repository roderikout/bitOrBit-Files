
function love.load()

	math.randomseed(os.time())

	for i = 1, math.random(10) do --Asegurar un random nuevo
	    math.random()
	end

	Object = require ("classic")
	
	require ("game")


	game = Game()

end

function love.update(dt)
	game:update(dt)
end

function love.draw()
	game:draw()
end