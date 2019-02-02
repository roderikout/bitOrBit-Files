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
end