--08-12-2017

-- este archivo se va a llamar probesMechanics y debería estar dentro del objeto Level

--funciones de lanzamiento de las probes

function launchProbes(dt) --Lanza las probes si no hay probes en el sistema
  local probesOrbiting = {} -- Tabla para las probes orbitando
  if #game.level.probes == 0 and game.level.probeLanzar then -- Para lanzar la primera probe. Probelanzar esta definida en probesData
    manageLaunchProbes(true, dt, 0) --Funcion para manejar la direccion y velocidad inicial de las probes
  elseif #game.level.probes > 0 and #game.level.probes < game.level.probesLevel and game.level.probeLanzar then
    for i, prob in ipairs(game.level.probes) do
      probesOrbiting[i] = prob.number
    end
    timeProbes = timeProbes + dt  --ticker para lanzar las probes una por una
    for i = 1, game.level.probesLevel do
      if timeProbes > launchInterval then
        if utils.tableCount(probesOrbiting, i) == 0 then  --si alguna probe se perdió o explotó se vuelve a lanzar
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

  bwam:play() -- sonido de lanzar probe
  local p = #game.level.probes + 1
  local probString = "probe" .. tostring(p)  --crear las probes
  local probStr = ProbeActive(probeData[1], probeData[2], utils.randomInt(probeSpeedInitialMin, probeSpeedInitialMax), probeData[3])
  probStr.name = probString
  probStr.type = "active"
  probStr.popX = probStr.x
  probStr.popY = probStr.y
 

  if first then --si es la primera probe
    probStr.number = p
    game.level.probes[p] = probStr
    timeProbes = timeProbes + dt
  else --si es cualquier otra probe despues de la primera
    probStr.number = i
    table.insert(game.level.probes, i, probStr)
    timeProbes = 0
  end

end