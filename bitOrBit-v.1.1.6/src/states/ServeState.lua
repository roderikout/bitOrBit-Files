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

    --line orbit grow at start and shrink at end
    self.orbitWidth = {w = 0}
    self.planet.orbitWidth = self.orbitWidth.w
    self.isTimeForStart = false

    local grow, shrink

    grow = function() 
              timer.tween(0.9, self.orbitWidth, {w = self.planet.orbitColoredArea - self.planet.spaceBetween}, 'in-out-sine')
         end

    grow()
    
    --debugging
    self.debug = "Nothing happnning"

    --test keyPressed
    timer.after(1, function() self.isTimeForStart = true end)
end

function ServeState:update(dt)

      timer.update(dt)
      self.planet.orbitWidth = self.orbitWidth.w

    if love.keyboard.wasPressed('space') and self.isTimeForStart then
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

    if #self.planet.colorZones > 0 then
      self.debug = self.planet.colorZones[1].max
    end

end

function ServeState:render()

  self.planet:render()

  printTitle(self.level, self.debug, self.instructionsOn)

  if self.isTimeForStart then
    self:renderGraphics()
  end

  if #self.planet.colorZones > 0 then
    love.graphics.setFont(gFonts['small'])
    love.graphics.setColor(255,255,255,255)
    love.graphics.print("Pmin text: " .. tostring(self.planet.colorZones[1].min), 10, 500)
    love.graphics.print("Pmax text: " .. tostring(self.planet.colorZones[1].max), 10, 530)
    love.graphics.print("Pmin text: " .. tostring(self.planet.colorZones[2].min), 10, 560)
    love.graphics.print("Pmax text: " .. tostring(self.planet.colorZones[2].max), 10, 590)
    love.graphics.print("Zones text: " .. tostring(#self.planet.colorZones), 10, 620)
  end
 
end 

function ServeState:renderGraphics()
  
  love.graphics.setFont(gFonts['big'])
  local fontHeight = gFonts['big']:getHeight()
  love.graphics.printf("Level " .. tostring(self.level),
      0, WINDOW_HEIGHT / 2, WINDOW_WIDTH, 'center')

  -- instructions text
  love.graphics.setFont(gFonts['medium'])
  love.graphics.printf('Press Space to spawn probes!', 0, WINDOW_HEIGHT / 2 + fontHeight,
      WINDOW_WIDTH, 'center')
  
end