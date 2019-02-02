--Datos de los planetas
--[[no tiene mucho sentido crear un listado de planetas para luego crear otro, pensar esto mejor y ciudadi al arreglarlo que uso los dos tipos en el codigo]]
--[[planets = {}
  
planets[1] = {x = 0,
            y = 0,
            radius = 30,
            mass = 1000000,
            gravityRadius = 600,
            name = "planeta1",
            satellites = 0}
--]]


--[[--crear planetas
planetas = {}

for i, _ in ipairs(level.planets) do
  local plan  = Planeta(
                  level.planets[i].x, 
                  level.planets[i].y, 
                  level.planets[i].radius,
                  level.planets[i].mass,
                  level.planets[i].gravityRadius
                  )
  plan.name = level.planets[i].name
  plan.probes = level.planets[i].satellites
  planetas[i] = plan
end--]]