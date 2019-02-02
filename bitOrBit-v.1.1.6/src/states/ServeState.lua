--[[
    BitOrBit v.1.1.6

    Author: Rodrigo Garcia
    roderikout@gmail.com

    Original by: Colton Ogden, cogden@cs50.harvard.edu

    -- LaunchState Class --

    The state in which we are waiting to serve the probes. Hit space
    to begin
]]

ServeState = Class{__includes = BaseState}

function ServeState:enter(params)

    self.level = params.level
    self.firstLevel = params.firstLevel
    self.planet = params.planet
    self.lastLevel = params.lastLevel    
    
    --other flags
    self.instructionsOn = false
    
    gSounds['musicIntro']:stop()
    gSounds['launch']:play()

    --debugging
    self.debug = "Nothing happnning"
end

function ServeState:update(dt)

    if love.keyboard.wasPressed('space') then
      -- pass in all important state info to the PlayState
      gSounds['select']:play()
      gStateMachine:change('play', {
          level = self.level,
          firstLevel = self.firstLevel,
          planet = self.planet,
          lastLevel = self.lastLevel,
      })
    elseif love.keyboard.wasPressed('escape') then
      gStateMachine:change('start')
    elseif love.keyboard.wasPressed('i') then
      self.instructionsOn = not self.instructionsOn
    end
end

function ServeState:render()
  self.planet:render()

  --printTitle(self.level, self.debug, self.instructionsOn)

  love.graphics.setFont(gFonts['big'])
  local fontHeight = gFonts['big']:getHeight()
  love.graphics.printf("Level " .. tostring(self.level),
      0, WINDOW_HEIGHT / 2, WINDOW_WIDTH, 'center')

  -- instructions text
  love.graphics.setFont(gFonts['medium'])
  love.graphics.printf('Press Space to spawn probes!', 0, WINDOW_HEIGHT / 2 + fontHeight,
      WINDOW_WIDTH, 'center')
end 