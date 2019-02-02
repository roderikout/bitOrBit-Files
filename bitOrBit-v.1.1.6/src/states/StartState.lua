--[[
    BitOrBit v.1.1.6

    Author: Rodrigo Garcia
    roderikout@gmail.com

    Original by: Colton Ogden, cogden@cs50.harvard.edu

    -- StartState Class --

    Represents the state the game is in when we've just started; should
    simply display Bit Or Bit
]]

-- the "__includes" bit here means we're going to inherit all of the methods
-- that BaseState has, so it will have empty versions of all StateMachine methods
-- even if we don't override them ourselves; handy to avoid superfluous code!
StartState = Class{__includes = BaseState}

function StartState:init()
    self.map = {
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

    --logo position
    self.divideHeight = WINDOW_HEIGHT / (#self.map + 2)
    self.separationRectangles = self.divideHeight / 1.3

    --logo movement flags
    self.a = 1
    self.b = "up"

    --other flags
    self.instructionsOn = false

    --music
    gSounds['musicIntro']:stop()
    gSounds['musicGamePlay']:stop()
    gSounds['musicIntro']:play()
    gSounds['musicIntro']:setLooping(true)

    --Initializing level
    self.levelInit = INITIAL_LEVEL
    self.lastLevel = TOTAL_LEVELS
    self.firstLevel = true
    self.planet = Planet(WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2, 20, 300000, 380, self.levelInit + 1)

end

function StartState:update(dt)

    if love.keyboard.wasPressed('i') then
        gSounds['select']:play()
        self.instructionsOn = not self.instructionsOn
    elseif love.keyboard.wasPressed('space') then 
        gSounds['select']:play()
        self.map = nil
        gStateMachine:change('newLevel', {
            level = self.levelInit,
            firstLevel = self.firstLevel,
            planet = self.planet,
            lastLevel = self.lastLevel,
        })
    elseif love.keyboard.wasPressed('escape') then -- we no longer have this globally, so include here
        love.event.quit()
    end

    self:logoMovement(dt)

end

-- para hacer crecer y decrecer las letras del logo de BitOrBit
function StartState:logoMovement(dt)
    if self.b =="up" then
        self.a = self.a + (10 * dt)
        if self.a > 7 then
            self.b = "down"
        end
    elseif self.b == "down" then
        self.a = self.a - (10 * dt)
        if self.a < 1 then
            self.b = "up"
        end
    end
end

function StartState:render()
    self:drawStartLogo()
    self:drawStartText()
end

function StartState:drawStartLogo()
    --parsea la tabla map, si es 1 dibuja un cuadro, si es 0 no
    for y = 1, #self.map do
        for x = 1, #self.map[y] do
            if self.map[y][x] == 1 then
                love.graphics.rectangle("fill", x * self.divideHeight, y * self.divideHeight, self.separationRectangles + self.a, self.separationRectangles + self.a)
            end
        end
    end
end

function StartState:drawStartText()  --tratar de tomar los textos del archivo textos
    
    if not self.instructionsOn then
        love.graphics.setFont(gFonts['medium'])
        local fontHeight = gFonts['medium']:getHeight()
        love.graphics.print("Press \"Space\" to start", WINDOW_WIDTH/2 - self.a, WINDOW_HEIGHT/2)
        love.graphics.print("Press \"i\" to read the instructions", WINDOW_WIDTH/2 - self.a, WINDOW_HEIGHT/2 + fontHeight)
    else
        love.graphics.setFont(gFonts['small'])
        local fontHeight = gFonts['small']:getHeight()
        love.graphics.printf("Goal of the game:\n-Try to take each probe to the orbit of the correct color using the thrusters to accelerate or decelerate it\n\n\nKeys:\n-Press 'Space' to start the game / spawn the probes / pause the game\n-Press up or down arrows to accelerate or decelerate the probe\n-Press 'P' to select and cicle between the probes\n-Press 'X' when a probe is selected to destroy it and create a new one\n-Press 'R' to respawn all the probes\n-Press 'I' to enter / exit the instructions\n-Press 'Escape' to exit the game", WINDOW_WIDTH/2, WINDOW_HEIGHT/2 - self.divideHeight *3, WINDOW_WIDTH/2 - self.divideHeight, "left")
        --love.graphics.printf("Keys:", WINDOW_WIDTH/2, WINDOW_HEIGHT/2 + (fontHeight * 3), WINDOW_WIDTH/2 - self.divideHeight, "left")
        --love.graphics.printf("-Press 'Space' to start the game / spawn the probes / pause the game", WINDOW_WIDTH/2, WINDOW_HEIGHT/2 + (fontHeight *4), WINDOW_WIDTH/2 - self.divideHeight, "left")
        --love.graphics.printf("-Press up or down arrows to accelerate or decelerate the probe", WINDOW_WIDTH/2, WINDOW_HEIGHT/2 + (fontHeight *5), WINDOW_WIDTH/2 - self.divideHeight, "left")
        --love.graphics.printf("-Press 'P' to select and cicle between the probes", WINDOW_WIDTH/2, WINDOW_HEIGHT/2 + (fontHeight *6), WINDOW_WIDTH/2 - self.divideHeight, "left")
        --love.graphics.printf("-Press 'X' when a probe is selected to destroy it and create a new one", WINDOW_WIDTH/2, WINDOW_HEIGHT/2 + (fontHeight *7), WINDOW_WIDTH/2 - self.divideHeight, "left")
        --love.graphics.printf("-Press 'R' to respawn all the probes", WINDOW_WIDTH/2, WINDOW_HEIGHT/2 + (fontHeight *8), WINDOW_WIDTH/2 - self.divideHeight, "left")
        --love.graphics.printf("-Press 'Escape' to exit the game", WINDOW_WIDTH/2, WINDOW_HEIGHT/2 + (fontHeight *9), WINDOW_WIDTH/2 - self.divideHeight, "left")
        --love.graphics.printf("-Press 'I' to enter / exit the instructions", WINDOW_WIDTH/2, WINDOW_HEIGHT/2 + (fontHeight *10), WINDOW_WIDTH/2 - self.divideHeight, "left")
    end
end