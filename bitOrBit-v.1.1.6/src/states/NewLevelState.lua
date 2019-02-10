--[[
    BitOrBit v.1.1.6

    Author: Rodrigo Garcia
    roderikout@gmail.com

    Original by: Colton Ogden, cogden@cs50.harvard.edu

    -- New Level State Class --

    Represents the state that the game is in when we've just completed a level.
    Very similar to the ServeState, except here we increment the level.
]]

NewLevelState = Class{__includes = BaseState}

function NewLevelState:enter(params)
    self.level = params.level
    self.firstLevel = params.firstLevel
    self.planet = params.planet
    self.lastLevel = params.lastLevel

    self.planet.orbitsNeededToWin = LevelMaker.createLevel(self.level, self.planet)[1]

    --Button
    self.buttonFill = 'line'
    self.buttonFontColor = {255,255,255,255}
    --mouse
    MOUSE_X = 0
    MOUSE_Y = 0
    MOUSE_BUTTON = nil
    MOUSE_IS_TOUCH = nil
    MOUSE_PRESSES = nil 
end

function NewLevelState:update(dt)
    
    if love.keyboard.wasPressed('space') then
        self.firstLevel = false
        gSounds['select']:play()
        gStateMachine:change('serve', {
            level = self.level,
            firstLevel = self.firstLevel,
            planet = self.planet,
            lastLevel = self.lastLevel,
        })
    elseif love.keyboard.wasPressed('escape') then --we no longer have this globally, so include here
        gStateMachine:change('start')
    end

    self:mousePresses()
    self:mouseHover()
end

function NewLevelState:render()

    local fontHeight = gFonts['big']:getHeight()

    if not self.firstLevel then
        love.graphics.setFont(gFonts['big'])
        love.graphics.printf("Level " .. tostring(self.level - 1) .. " complete!",
          0, WINDOW_HEIGHT / 2, WINDOW_WIDTH, 'center')
        -- instructions text
        love.graphics.setFont(gFonts['medium'])
        love.graphics.printf('Press Space to next level!', 0, WINDOW_HEIGHT / 2 + fontHeight,
          WINDOW_WIDTH, 'center')
    else
        love.graphics.setFont(gFonts['big'])
        love.graphics.printf("Welcome to Bit OrBit ",
          0, WINDOW_HEIGHT / 2, WINDOW_WIDTH, 'center')
        -- instructions text
        love.graphics.setFont(gFonts['medium'])
        love.graphics.printf('Press Space to continue!', 0, WINDOW_HEIGHT / 2 + fontHeight,
          WINDOW_WIDTH, 'center')
    end

    self:drawStartButton()
end

function NewLevelState:drawStartButton()

    love.graphics.rectangle(self.buttonFill, WINDOW_WIDTH/2 - 175, WINDOW_HEIGHT/4 * 2.8, 350, 80)
    love.graphics.setColor(self.buttonFontColor)
    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf("Click here to launch", WINDOW_WIDTH/2 - 175, WINDOW_HEIGHT/4 * 2.8 + 20, 350, "center")
    love.graphics.setColor(255,255,255,255)

end

function NewLevelState:mousePresses ()

    if MOUSE_X > WINDOW_WIDTH/2 - 175 and MOUSE_X < (WINDOW_WIDTH/2 - 175) + 350 and MOUSE_Y > WINDOW_HEIGHT/4 * 2.8 and MOUSE_Y < (WINDOW_HEIGHT/4 * 2.8) + 80 then
       self.firstLevel = false
        gSounds['select']:play()
        gStateMachine:change('serve', {
            level = self.level,
            firstLevel = self.firstLevel,
            planet = self.planet,
            lastLevel = self.lastLevel,
        })
    end

end

function NewLevelState:mouseHover()
    local mouseX = love.mouse.getX( )
    local mouseY = love.mouse.getY( )

    if mouseX > WINDOW_WIDTH/2 - 175 and mouseX < (WINDOW_WIDTH/2 - 175) + 350 and mouseY > WINDOW_HEIGHT/4 * 2.8 and mouseY < (WINDOW_HEIGHT/4 * 2.8) + 80 then
        self.buttonFill = "fill"
        self.buttonFontColor = {0,0,0}
    else
        self.buttonFill = "line"
        self.buttonFontColor = {255,255,255,255}
    end
end