--Datos de los planetas
--[[no tiene mucho sentido crear un listado de planetas para luego crear otro, pensar esto mejor y ciudadi al arreglarlo que uso los dos tipos en el codigo]]
planets = {}
  
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