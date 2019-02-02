--Funciones de teclado --[[Hay unas funciones de teclado que no están bien, las que se presionan seguido]]
function love.keypressed(key)
  --Teclas de control de juego
  if game.gameView ~= "screen" and not game.gameWin then
    if key == "p" then  -- rotar en seleccion de probes
      if #game.level.probes > 0 then
        pop:play()
        probeSelected = probeSelected + 1
        if probeSelected > #game.level.probes then
          probeSelected = 0
          game.level.cameraFollows = false
        end
        for i, prob in ipairs(game.level.probes) do
          prob.selected = false
        end
        if probeSelected > 0 then
          game.level.probes[probeSelected].selected = true
        end
      end
    elseif key == "x" then   --Eliminar la probe seleccionada
      table.remove(game.level.probes, probeSelected)
      probeSelected = 0
      explosion:play()
    elseif key == "r" then   --Relanzar todas las probes
      game.level.probes = {}
      probeSelected = 0
      for i, planet in ipairs(game.level.planetas) do
        planet.radius = game.level.planets[i].radius
        planet.mass = game.level.planets[i].mass
      end
      game.gameState  = "play"
    elseif key == "f" then   --Seguir la probe seleccionada, arreglar a que solo funcione si hay probe selected y que se resetee al inicio
      game.level.cameraFollows = not game.level.cameraFollows
    elseif key == "space" then   --Lanzar la probe
      game.gameState = "play"
      game.level.probeLanzar = true
    elseif key == "h" then   -- Pausar el juego
      if game.gameState == "play" then
        game.gameState = "pause"
      elseif game.gameState == "pause" then
        game.gameState = "play"
      end
    elseif key == "i" then --instrucciones on y off
      game.level.instructionsOn = not game.level.instructionsOn
    end
  end
  if game.gameView == "screen" then
    if key == "space" then  --si estamos en la pantalla de inicio y se presiona space
      game.gameView = "play"
      game.gameState = "play"
      if game.newGame then
        game.level = Level1()
        game.newGame = false
      end
    elseif key == "i" then --instrucciones on y off
      game.screen.instructionsOn = not game.screen.instructionsOn
    end
  end
  if key == "escape" then  --Salir del juego
    if game.gameView == "screen" then
      love.event.quit()
    else
      music:stop()
      game.level.probes = {}
      probeSelected = 0
      game.level.probeLanzar = false
      game.gameView = "screen"
      game.screen = ScreenStart()
      if game.gameWin then
        game.newGame = true
        game.gameWin = false
      end
      game.level.orbitsNeededToWin = {}
      game.level.initLevel = false
      for i, planet in ipairs(game.level.planetas) do
        planet.zonasColor = {}
      end
    end
  end
end
