--Funciones de teclado --[[Hay unas funciones de teclado que no están bien, las que se presionan seguido]]
function love.keypressed(key)
  --Teclas de control de juego
  if level == 1 then
    if key == "a" then  --Zoom
      if cameraMain.scale + 0.1 < 3 then
        cameraMain.scale = cameraMain.scale + 0.1
      else
        cameraMain.scale = 3
      end
    elseif key == "z" then
      if cameraMain.scale - 0.1 > 0.1 then
        cameraMain.scale = cameraMain.scale - 0.1
      else
        cameraMain.scale = 0.1
      end
    elseif key == "p" then  -- rotar en seleccion de probes
      if #probes > 0 then
        probeSelected = probeSelected + 1
        if probeSelected > #probes then
          probeSelected = 0
          cameraFollows = false
        end
        for i, prob in ipairs(probes) do
          prob.selected = false
        end
        if probeSelected > 0 then
          probes[probeSelected].selected = true
        end
      end
    elseif key == "x" then   --Lanzar la probe
      table.remove(probes, probeSelected)
      probeSelected = 0
      hechoR, hechoN, hechoA = false, false, false
    elseif key == "r" then   --Lanzar la probe
      probes = {}
      probeSelected = 0
      state = "play"
    elseif key == "f" then   --Lanzar la probe
      cameraFollows = not cameraFollows
    elseif key == "c" then   --Lanzar la probe
      testColors = testColors + 1
      if testColors > probesMax then testColors = 1 end
    elseif key == "space" then   --Lanzar la probe
      state = "play"
      probeLanzar = true
    elseif key == "h" then   --Lanzar la probe
      if state == "play" then
        state = "pause"
      elseif state == "pause" then
        state = "play"
      end
    end
  end
  if level == "start" then
    if key == "space" then  --Zoom
      level = 1
      state = "play"
    end
  end
  if key == "escape" then  --Salir del juego
    if level == "start" then
      love.event.quit()
    else
      level = "start"
    end
  elseif key == "i" then
    instructionsOn = not instructionsOn
  end
end
