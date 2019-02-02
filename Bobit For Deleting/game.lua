
Game = Object:extend()

utils = require ("utils")  --funciones utilitarias creadas por mi
lume = require ("lume")  --funciones auxiliares bajadas de GitHub (buscar copyright)
require ("shortenSomeFunctions")  --recorta la llamada a algunas funciones (no en uso)

----------

width, height = getDimensions()

----------

cameraMain = require ("camera").new(0,0)
timer = require ("timer")
vector = require("vector")

require ("prints") --funciones de textos en pantalla start (debería tener todos los textos)

require ("mouseAndCameras") --Funciones de uso de ratón y cámaras
require ("gameMechanics") --mecánicas generales del juegeo. Separar las que pertenecen a las probes, los planetas, a los niveles y al juego
require ("keyboards") --funciones para el teclado

--
require ("planeta")
require ("planetsData")

----------

require ("probe7")
require ("probeActive")
require ("probeExplode")
require ("probesData")
---

require ("level")
require ("levelStart")

-----

music = love.audio.newSource("gfx/orbitSong3.ogg", "static")
music2 = love.audio.newSource("gfx/orbitSong2.ogg", "static")
bwam = love.audio.newSource("gfx/Bwam2.ogg")
pop = love.audio.newSource("gfx/Pop3.ogg")
explosion = love.audio.newSource("gfx/Xplode2.ogg")
trust = love.audio.newSource("gfx/Trust2.ogg")

-------

level = Level()

function Game:new()
	self.level = LevelStart()
	self.gameState = "Start"
	self.allLevels = {Level1(), Level2()}
end

function Game:draw()
	self.level:draw()
end

function Game:update(dt)
	self.level:update(dt)
end

function Game:checkWin() -- chequea si se lograron todas las orbitas de un nivel. Si se completaron todos los niveles el estado de juego es Win, lo que pone la pantalla a Win en pausa. Si solo se completo un nivel, sube al siguiente nivel y resetea initLevel, resetea orbits needed to win, zonas Color y probes, deselecciona la probe seleccionada. (Debería ir en Levels pero no he podido pasarlo exitosamente)
  if #level.orbitsNeededToWin > 0 then
    if utils.tableCount(level.orbitsNeededToWin, true) == #level.orbitsNeededToWin then
      level.currentLevel = level.currentLevel + 1
      if level.currentLevel > #game.allLevels then
        game.gameState = "win"
      else
        game.level = game.allLevels[level.currentLevel]
        level.initLevel = false
        level.orbitsNeededToWin = {}
        zonasColor = {}
        probes = {}
      end
      probeSelected = 0
    end
  end
end

function Game:checkOrbitsDone()  --Chequea si lograste alguna orbita estable, si es asi llena la posición de la tabla de ese nivel con un true, si se desestabiliza la llena con false. (Debería ir en Levels pero no he podido pasarlo exitosamente)
  for i, probe in ipairs(probes) do
    if probe.intersect then
      level.orbitsNeededToWin[i] = true
    elseif not probe.intersect then
      level.orbitsNeededToWin[i] = false
    end
  end
end

