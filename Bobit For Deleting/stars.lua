
--[[rocks (mas bien estrellas)
  rocks = {}
  rockSizeMin = 5
  rockSizeMax = 20
  rockAngle = 0
  rockXminLeft = 0
  rockXmaxLeft = width2
  rockXminRight = 320
  rockXmaxRight = 500
  rockAlpha = utils.randomInt(80, 150)
  rockQuantity = utils.randomInt(150, 200)
  rockBlue = utils.randomDist(150, 250, 4)

  for i = 1, rockQuantity do
    local rock = "roca_" .. tostring(i)
    rock = {rockX = utils.randomInt(rockXminLeft, rockXmaxLeft),
            rockY = utils.randomInt(0, height2),
            rockSize = utils.randomDist(rockSizeMin, rockSizeMax, 3)
            }
    rocks[i] = rock
  end]]


function rockDraw()
  for i, rocas in ipairs(rocks) do
    love.graphics.setColor(50, 50, rockBlue, rockAlpha)
    love.graphics.rectangle("fill", rocas.rockX, rocas.rockY, rocas.rockSize, rocas.rockSize)
    love.graphics.setColor(255, 255, 255, 255)
  end
end