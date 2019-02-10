--[[

	BitOrBit v.1.1.6

    Author: Rodrigo Garcia
    roderikout@gmail.com

	Juego de orbitas planetarias

]]--

require 'src/Dependencies'

function love.load()

	-- set love's default filter to "nearest-neighbor", which essentially
    -- means there will be no filtering of pixels (blurriness), which is
    -- important for a nice crisp, 2D look
    love.graphics.setDefaultFilter('nearest', 'nearest')

    --love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)

	--Seed the Random Number Generator (RNG)
	math.randomseed(os.time())

	--shuffle de RNG
	for i = 1, math.random(10) do
		math.random()
	end

	--load fonts
	gFonts = {

		['big'] = love.graphics.setNewFont(50),
		['medium'] = love.graphics.setNewFont(30),
		['small'] = love.graphics.setNewFont(20)

	}
	--load sounds
	gSounds = {

		['musicGamePlay'] = love.audio.newSource("sounds/orbitSong3.ogg", "static"),
		['musicIntro'] = love.audio.newSource("sounds/orbitSong2.ogg", "static"),
		['bwam'] = love.audio.newSource("sounds/Bwam2.ogg"),
		['pop'] = love.audio.newSource("sounds/Pop3.ogg"),
		['explosion'] = love.audio.newSource("sounds/Xplode2.ogg"),
		['trust'] = love.audio.newSource("sounds/Trust2.ogg"),
		['select'] = love.audio.newSource("sounds/select.wav"),
		['launch'] = love.audio.newSource("sounds/launch.wav")
 
	}

	--generate State Machine

	gStateMachine = StateMachine {

		['start'] = function() return StartState() end,
		['newLevel'] = function() return NewLevelState() end,
		['serve'] = function() return ServeState() end,
		['play'] = function() return PlayState() end,
		['victory'] = function() return VictoryState() end,
		['win'] = function() return WinState() end

	}

	gStateMachine:change('start')

	-- a table we'll use to keep track of which keys have been pressed this
    -- frame, to get around the fact that LÖVE's default callback won't let us
    -- test for input from within other functions
	love.keyboard.keysPressed = {}
  
end


function love.update(dt)
	
	gStateMachine:update(dt)
	
	-- reset keys pressed
	love.keyboard.keysPressed = {}

	-- size of our actual window
	WINDOW_WIDTH, WINDOW_HEIGHT = love.graphics.getDimensions()

end

--[[
    A callback that processes key strokes as they happen, just the once.
    Does not account for keys that are held down, which is handled by a
    separate function (`love.keyboard.isDown`). Useful for when we want
    things to happen right away, just once, like when we want to quit.
]]
function love.keypressed(key)
	--add to our table of keys pressed this frame
	love.keyboard.keysPressed[key] = true
end

--[[
    A custom function that will let us test for individual keystrokes outside
    of the default `love.keypressed` callback, since we can't call that logic
    elsewhere by default.
]]
function love.keyboard.wasPressed(key)
    if love.keyboard.keysPressed[key] then
        return true
    else
        return false
    end
end

function love.mousereleased( x, y, button, istouch, presses )

    MOUSE_X = x
    MOUSE_Y = y
    MOUSE_BUTTON = button
    MOUSE_IS_TOUCH = istouch
    MOUSE_PRESSES = presses

end


function love.draw()

	gStateMachine:render()

end