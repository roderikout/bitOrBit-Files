--24-11-2017

--funciones de juego

function launchProbes(dt) --Lanza las probes
  local probesOrbiting = {}
  if #probes == 0 and probeLanzar then -- Ojo con Probelanzar, definido en ProbesData
    manageLaunchProbes(true, dt, 0)
  elseif #probes > 0 and #probes < game.level.probesLevel and probeLanzar then
    for i, prob in ipairs(probes) do
      probesOrbiting[i] = prob.number
    end
    timeProbes = timeProbes + dt
    for i = 1, game.level.probesLevel do
      if timeProbes > launchInterval then
        if utils.tableCount(probesOrbiting, i) == 0 then
          manageLaunchProbes(false, dt, i)
        end
      end
    end
  end
end

function manageLaunchProbes(first, dt, i) -- maneja la posicion, direccion y velocidad inicial de las probes, first se refiere a si es la primera probe lanzada
  
  -- por ahora esta este metodo para garantizar probes exitosos pero es muy limitado, solo a 4 variables.
  local modRad = lume.random(50)
  local uno = {probeX, probeY, lume.randomchoice({math.rad(180 - modRad), math.rad(270 + modRad)})}
  local dos = {probeX, -probeY, lume.randomchoice({math.rad(180 + modRad), math.rad(90 - modRad)})}
  local tres = {-probeX, probeY, lume.randomchoice({math.rad(270 - modRad), math.rad(0 + modRad)})}
  local cuatro = {-probeX, -probeY, lume.randomchoice({math.rad(0 - modRad), math.rad(90 + modRad)})}
  local probeData = lume.randomchoice({uno,dos,tres,cuatro})

  bwam:play()
  local p = #probes + 1
  local probString = "probe" .. tostring(p)
  local probStr = ProbeActive(probeData[1], probeData[2], utils.randomInt(probeSpeedInitialMin, probeSpeedInitialMax), probeData[3])
  probStr.name = probString
  probStr.type = "active"
  probStr.popX = probStr.x
  probStr.popY = probStr.y
 

  if first then
    probStr.number = p
    probes[p] = probStr
    timeProbes = timeProbes + dt
  else 
    probStr.number = i
    table.insert(probes, i, probStr)
    timeProbes = 0
  end

end