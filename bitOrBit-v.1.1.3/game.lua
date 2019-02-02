
---08-12-2017

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

--require ("mouseAndCameras") --Funciones de uso de ratón y cámaras
require ("gameMechanics") --mecánicas generales del juegeo. Separar las que pertenecen a las probes, los planetas, a los niveles y al juego
require ("keyboards") --funciones para el teclado

--
require ("planeta") --Objeto planeta

----------

require ("probe7") --Objeto probe (super)
require ("probeActive") --Instancia de probe
require ("probeExplode") --Instancia de probe

---

require ("screens")
require ("screenStart") --Instancia de level con los datos de la pantalla de inicio


----

require ("level") --Objeto level
require ("level1") --Instancia de level

-----

music = love.audio.newSource("gfx/orbitSong3.ogg", "static")
music2 = love.audio.newSource("gfx/orbitSong2.ogg", "static")
bwam = love.audio.newSource("gfx/Bwam2.ogg")
pop = love.audio.newSource("gfx/Pop3.ogg")
explosion = love.audio.newSource("gfx/Xplode2.ogg")
trust = love.audio.newSource("gfx/Trust2.ogg")

-------

--screen = ScreenStart() -- no se está reiniciando level en cada frame?

--camaras
cameraMain:zoom(0.65)

function Game:new()
	self.screen = ScreenStart()
  self.level = Level1()
  self.gameView = "screen"
	self.gameState = "start"
  self.gameWin = false
  self.newGame = true
  --self.level = Level2()
  --self.gameState = "play"
	self.allLevels = {Level1(), Level2()}
end

function Game:draw()
  if self.gameView == "screen" then
    self.screen:draw()
  else
	 self.level:draw()
  end
end

function Game:update(dt)
  if self.gameView == "screen" then
    self.screen:update(dt)
  else
	 self.level:update(dt)
  end
end

function Game:checkWin() -- chequea si se lograron todas las orbitas de un nivel. Si se completaron todos los niveles el estado de juego es Win, lo que pone la pantalla a Win en pausa. Si solo se completo un nivel, sube al siguiente nivel y resetea initLevel, resetea orbits needed to win, zonas Color y probes, deselecciona la probe seleccionada. (Debería ir en Levels pero no he podido pasarlo exitosamente)
  if #game.level.orbitsNeededToWin > 0 then
    if utils.tableCount(game.level.orbitsNeededToWin, true) == #game.level.orbitsNeededToWin then
      if game.level.currentLevel == #game.allLevels then
        game.gameWin = true
      else
        game.level.currentLevel = game.level.currentLevel + 1
        game.level = game.allLevels[game.level.currentLevel]
        game.level.initLevel = false
        game.level.orbitsNeededToWin = {}
        for i, planet in ipairs(game.level.planetas) do
          planet.zonasColor = {}  --Se crea y se llena en planeta.lua
        end
        game.level.probes = {}  --Se llena en gameMechanics.lua, manageLaunchProbes() 
        music:stop()
      end
      probeSelected = 0 --Se crea en probesData.lua
    end
  end
end

function Game:checkOrbitsDone()  --Chequea si lograste alguna orbita estable, si es asi llena la posición de la tabla de ese nivel con un true, si se desestabiliza la llena con false. (Debería ir en Levels pero no he podido pasarlo exitosamente)
  for i, probe in ipairs(game.level.probes) do
    if probe.intersect then
      game.level.orbitsNeededToWin[i] = true
    elseif not probe.intersect then
      game.level.orbitsNeededToWin[i] = false
    end
  end
end

-- funciones del mouse
--function mouseUpdate()
--  mouseX, mouseY = cameraMain:worldCoords(love.mouse.getX(), love.mouse.getY())
--end