
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

function cameraFollowsProbe() -- Hace que la camara vaya a la probe seleccionada cuando se le dio a F en modulo keyboard, (debería ir en mouse and cameras)
	if cameraFollows and probes[probeSelected] then
		cameraMain:zoomTo(1.5)
        cameraMain:lockPosition(probes[probeSelected].x, probes[probeSelected].y, cameraMain.smooth.damped(3))
	else
		cameraMain:zoomTo(0.65)
        cameraMain:lockPosition(planets[1].planetaX, planets[1].planetaY, cameraMain.smooth.damped(3))
	end
end