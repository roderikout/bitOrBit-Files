
local printText = love.graphics.print
local setColor = love.graphics.setColor 
local rectangle = love.graphics.rectangle

local yPos = 10
local yShift = 600


function printTexts()
  local font = love.graphics.setNewFont(12)
  setColor(255,255,255,255)
  printText("FPS: " .. tostring(love.timer.getFPS()), 10, yPos)
  local font = love.graphics.setNewFont(24)
  printText("Level: " .. tostring(game.level.currentLevel), 10, yPos * 3)
  local font = love.graphics.setNewFont(15)
  printText("Press 'i' for keys", 10, yPos * 9)
  --printText("Planetas: " .. tostring(#level.planetas), 10, yPos * 12)
  --[[for i, prob in ipairs(level.probes) do
    printText("Prob #: " .. tostring(i) ..
              ", intersect: " .. tostring(prob.intersect) ..
              ", laps: " .. tostring(prob.laps) 
             -- ", Die: " .. tostring(prob.die)
              , 10, 140 + (i * 10))
  end--]]
  if game.level.instructionsOn then
    --setColor(0,0,0)
    printText("Keys: ", 10, (yPos * 3) + yShift)
    printText("Space: start the game ", 10, (yPos * 4.5)+ yShift)
    printText("P: to select probes", 10, (yPos * 6)+ yShift)
    printText("X: to destroy selected probe ", 10, (yPos * 7.5)+ yShift)
    printText("R: to reset the system     ", 10, (yPos * 9)+ yShift)
    printText("Up & down arrows: to increase and decrease \n velocity of selected probe", 10, (yPos * 10.5)+ yShift)
    printText("Escape: to exit the game   ", 10, (yPos * 13.5)+ yShift)
    printText("H: to pause the game   ", 10, (yPos * 15)+ yShift)
    printText("F: to follow the selected probe   ", 10, (yPos * 16.5)+ yShift)
  end

  if game.gameWin then
    local font = love.graphics.setNewFont(60)
    setColor(0, 0, 0, 100)
    rectangle('fill', 0, 0, width, height)
    setColor(255,255,255,255)
    printText("You Win!!", width / 2 - 100, height / 2)
  elseif game.gameState == 'pause' and not game.gameWin then
    local font = love.graphics.setNewFont(60)
    setColor(0, 0, 0, 100)
    rectangle('fill', 0, 0, width, height)
    setColor(255,255,255,255)
    printText("PAUSE", width / 2 - 100, height / 2)
  end

  --printText("#probes: " .. tostring(#probes), 10, 40)
  --printText("#probesOrbiting: " .. tostring(#probesOrbiting), 10, 50)
  --printText("probeSelected: " .. tostring(probeSelected), 10, 60)
  --printText("Hecho Rojo:      " .. tostring(circlesDone[1]), 10, 80)
  --printText("Hecho Naranja:   " .. tostring(circlesDone[2]), 10, 90)
  --printText("Hecho Amarillo: " .. tostring(circlesDone[3]), 10, 100)
  --printText("Intersect: " .. tostring(mensaje), 10, 120)
  --[[for i, prob in ipairs(probes) do
    printText("Prob #: " .. tostring(i) .. 
              ", Nombre: " .. tostring(prob.number) ..
              ", Selected: " .. tostring(prob.selected) ..
              ", Laps: " .. tostring(prob.laps)
              , 10, 140 + (i * 10))
  end]]
end