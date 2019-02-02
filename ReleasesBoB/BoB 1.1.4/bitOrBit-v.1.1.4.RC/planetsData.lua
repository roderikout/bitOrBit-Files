--Datos de los planetas
--[[no tiene mucho sentido crear un listado de planetas para luego crear otro, pensar esto mejor y ciudadi al arreglarlo que uso los dos tipos en el codigo]]
planets = {}

local alpha = 80  --para color zones que deberia ser de planets
  
planets[1] = {planetaX = 0,
            planetaY = 0,
            planetaRadius = 30,
            planetaMass = 1000000,
            planetaGravityRadius = 600,
            name = "planeta1",
            satellites = 0}

planetas = {}

--crear planetas
for i, plnts in ipairs(planets) do
  local plan = "planeta_".. tostring(i)
  plan  = Planeta(planets[i].planetaX, 
                  planets[i].planetaY, 
                  planets[i].planetaRadius,
                  planets[i].planetaMass,
                  planets[i].planetaGravityRadius
                  )
  plan.name = planets[i].name
  plan.probes = planets[i].satellites
  planetas[i] = plan
end

--zonas de gravedad
zonasColor = {}

function colorToLine(i, alpha)  --asigna colores a probes y orbitas según número de probes, maximo 7 probes. Buscar otro método más amplio

  if i == 1 then  -- rojo
    red, green, blue = 255, 0 , 0
  elseif i == 2 then  -- naranja
    red, green, blue = 255, 100, 0
  elseif i == 3 then -- amarillo
    red, green, blue = 255, 255, 0
  elseif i == 4 then -- verde
    red, green, blue = 0, 255, 0
  elseif i == 5 then -- cyan
    red, green, blue = 0, 255, 255
  elseif i == 6 then -- azul
    red, green, blue = 0, 0, 255
  elseif i == 7 then -- magenta
    red, green, blue = 255, 0, 255
  end

  return red, green, blue, alpha
end

function colorZones() --genera los círculos de las zonas orbitales, debería pertenecer a planeta
  local spaceBetween = planets[1].planetaRadius * 5/6
  local spaceZone = planets[1].planetaGravityRadius - planets[1].planetaRadius - spaceBetween
  local colorZone = spaceZone / game.level.probesLevel
  local lineWidth = colorZone - spaceBetween

  for i = 1, game.level.probesLevel do
    if level.orbitsNeededToWin[i] then
      alpha = 200
    elseif not level.orbitsNeededToWin[i] then
      alpha = 80
    end

    love.graphics.setLineWidth(lineWidth)
    love.graphics.setColor(colorToLine(i, alpha))
    local zona = (((lineWidth + spaceBetween) * i) - lineWidth/2 + spaceBetween)
    local orbit = love.graphics.circle("line", planets[1].planetaX, planets[1].planetaY, zona)
    love.graphics.setLineWidth(1)
    love.graphics.setColor(100,100,100,255)
    local lineDwnOrbit = love.graphics.circle("line", planets[1].planetaX, planets[1].planetaY, zona - lineWidth/2)
    local lineUpOrbit = love.graphics.circle("line", planets[1].planetaX, planets[1].planetaY, zona + lineWidth/2)
    table.insert(zonasColor, {min = zona - (lineWidth / 2), max = zona + (lineWidth / 2)})
    love.graphics.setColor(255,255,255,255)

  end
end

function gravityBeam() -- dibujar beam de atraccion gravitatoria, debería pertenecer al planeta
  if game.gameState == "play" then
    for i, prob in ipairs(probes) do
      for j, planet in ipairs(planetas) do
        if prob.selected then
          local anglePlanet =  math.atan2((prob.pos.y - planet.pos.y), (prob.pos.x - planet.pos.x))
          local rDistRel = prob.r + utils.randomInt(5, 25)
          red, green, blue, alpha = colorToLine(i, 150)
          love.graphics.setColor(red - 50, green - 50, blue + 50, alpha)
          love.graphics.polygon("fill", planet.x, planet.y, prob.x + (math.sin(anglePlanet) * rDistRel), prob.y - (math.cos(anglePlanet) * rDistRel), prob.x - (math.sin(anglePlanet) * rDistRel), prob.y + (math.cos(anglePlanet) * rDistRel))
          love.graphics.arc("fill", prob.pos.x, prob.pos.y, rDistRel, anglePlanet + math.rad(90), anglePlanet - math.rad(90))
          love.graphics.setColor(0,0,0,255)
          love.graphics.line(planet.x, planet.y, prob.x + (math.sin(anglePlanet) * rDistRel), prob.y - (math.cos(anglePlanet) * rDistRel))
          love.graphics.line(planet.x, planet.y, prob.x - (math.sin(anglePlanet) * rDistRel), prob.y + (math.cos(anglePlanet) * rDistRel))
          love.graphics.arc("line","open", prob.pos.x, prob.pos.y, rDistRel, anglePlanet + math.rad(90), anglePlanet - math.rad(90))
          love.graphics.setColor(255,255,255,255)
        end
      end
    end
  end
end