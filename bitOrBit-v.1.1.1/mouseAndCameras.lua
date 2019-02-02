
--Del mouse
mouseX = 0
mouseY = 0
cameraFollows = false

--camaras
cameraMain:zoom(0.65)

-- funciones del mouse
function mouseUpdate()
  mouseX, mouseY = cameraMain:worldCoords(love.mouse.getX(), love.mouse.getY())
end

-- funciones de la camara
function cameraPlanets(x,y)  --[[Funcion de movimiento de cámara que se puede reciclar]]
  cameraMain:lookAt(x,y)
end

function cameraFollowsPlanet()
	if cameraFollows and probes[probeSelected] then
		cameraMain:zoomTo(1.5)
        --cameraMain:lookAt(probes[probeSelected].x, probes[probeSelected].y)
        cameraMain:lockPosition(probes[probeSelected].x, probes[probeSelected].y, cameraMain.smooth.damped(10))
	else
		cameraMain:zoomTo(0.65)
        --cameraMain:lookAt(planets[1].planetaX, planets[1].planetaY)
        cameraMain:lockPosition(planets[1].planetaX, planets[1].planetaY, cameraMain.smooth.damped(10))
	end
end