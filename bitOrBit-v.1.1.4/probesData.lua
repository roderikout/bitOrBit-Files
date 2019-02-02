
--datos de la probe 
  --[[Limpiar variables en general. Probar crear una tabla con todos estos valores de probe. 
  La idea es que cada probe sea independiente y pueda manipularse por separado en lugar 
  de depender de las demas--]]
  probeSpeedInitialMin = 300
  probeSpeedInitialMax = 400 
  probeX = planets[1].planetaGravityRadius * 2/5 
  probeY = planets[1].planetaGravityRadius * 2/5
  probXprev = 0
  probYprev = 0
  probXpost = 0
  probYpost = 0
  probeSizeMin = 15
  probeSizeMax = 25
  probeDirectionMin = math.rad(180)
  probeDirectionMax = math.rad(190)
  probeLanzar = false
  probeExplode = false
  probeThrustTotal = 200
  probes = {}
  probesOrbiting = {}
  fragmentsOfProbe = {}
  probesMax = 3 
  probeSelected = 0
  launchInterval = 0.5
  timeProbes = 0