--24-11-2017

local alpha = 80

orbitsNeeded = {}

function orbitsNeededByLevel(orbits)
  for i = 1, orbits do
    table.insert(orbitsNeeded, false)
  end
end

--orbitsDone = {false, false, false}
lineasMinMax = {}

--game state
state = "start"

--funciones de juego
function launchProbes(dt) --Lanza las probes
  local probesOrbiting = {}
  if #probes == 0 and probeLanzar then -- Ojo con Probelanzar
    local modRad = lume.random(50)
    local uno = {probeX, probeY, lume.randomchoice({math.rad(180 - modRad), math.rad(270 + modRad)})}
    local dos = {probeX, -probeY, lume.randomchoice({math.rad(180 + modRad), math.rad(90 - modRad)})}
    local tres = {-probeX, probeY, lume.randomchoice({math.rad(270 - modRad), math.rad(0 + modRad)})}
    local cuatro = {-probeX, -probeY, lume.randomchoice({math.rad(0 - modRad), math.rad(90 + modRad)})}
    local probeData = lume.randomchoice({uno,dos,tres,cuatro})
    local p = #probes + 1 
    local probStr = "probe" .. tostring(p)
    probStr = Probe(probeData[1], probeData[2], utils.randomInt(probeSpeedInitialMin, probeSpeedInitialMax), probeData[3])
    probStr.name = probStr
    probStr.number = p
    probStr.popX = probStr.x
    probStr.popY = probStr.y
    probes[p] = probStr
    timeProbes = timeProbes + dt
  elseif #probes > 0 and #probes < probesMaxByLevel and probeLanzar then
    for i, prob in ipairs(probes) do
      probesOrbiting[i] = prob.number
    end
    timeProbes = timeProbes + dt
    for i = 1, probesMaxByLevel do
      if timeProbes > launchInterval then
        if utils.tableCount(probesOrbiting, i) == 0 then
          local modRad = lume.random(40)
          local uno = {probeX, probeY, lume.randomchoice({math.rad(180 - modRad), math.rad(270 + modRad)})}
          local dos = {probeX, -probeY, lume.randomchoice({math.rad(180 + modRad), math.rad(90 - modRad)})}
          local tres = {-probeX, probeY, lume.randomchoice({math.rad(270 - modRad), math.rad(0 + modRad)})}
          local cuatro = {-probeX, -probeY, lume.randomchoice({math.rad(0 - modRad), math.rad(90 + modRad)})}
          local probeData = lume.randomchoice({uno,dos,tres,cuatro})
          local probStr = "probe" .. tostring(i)
          probStr = Probe(probeData[1], probeData[2], utils.randomInt(probeSpeedInitialMin, probeSpeedInitialMax), probeData[3])
          probStr.name = probStr
          probStr.name = probStr
          probStr.number = i
          probStr.popX = probStr.x
          probStr.popY = probStr.y
          table.insert(probes, i, probStr)
          timeProbes = 0
        end
      end
    end
  end
end

function gravityBeam() -- dibujar beam de atraccion gravitatoria
  if state == "play" then
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

function colorToLine(i, alpha)  --asigna colores a probes y orbitas según número de probes
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

function colorZones() --genera los círculos de las zonas orbitales
  local spaceBetween = planets[1].planetaRadius * 5/6
  local spaceZone = planets[1].planetaGravityRadius - planets[1].planetaRadius - spaceBetween
  local colorZone = spaceZone / (probesMaxByLevel) -- + 1
  local lineWidth = colorZone - spaceBetween

  for i = 1, probesMaxByLevel do
    if orbitsNeeded[i] then
      alpha = 200
    elseif not orbitsNeeded[i] then
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
  end
end

function checkOrbitsDone()  --Chequea si pasas de nivel
  for i, probe in ipairs(probes) do
    if probe.intersect then
      orbitsNeeded[i] = true
    elseif not probe.intersect then
      orbitsNeeded[i] = false
    end
  end
  
  if utils.tableCount(orbitsNeeded, true) == #orbitsNeeded then
    state = "win"
  end
end