--V. 26-11-2017
--Por Rodrigo Garcia Casado
----------------------------------------------------------------------

utils = require ("utils")  --funciones utilitarias creadas por mi
require ("shortenSomeFunctions")  --recorta la llamada a algunas funciones (no en uso)
require ("keyboards") --funciones de uso del teclado de todo el juego

---------------------------------------------------------------------

function love.load()
  --Dimensiones de las pantallas y del universo
  width, height = getDimensions()

  -- Classic, planeta y probe
  Object = require ("classic")  --
  cameraMain = require ("camera").new(0,0)
  timer = require ("timer")
  vector = require("vector")
  lume = require ("lume")  --funciones auxiliares bajadas de GitHub (buscar copyright)
  require ("prints") --funciones de textos en pantalla start (debería tener todos los textos)
  require ("planeta") --Objeto Planeta, debería usar instancias de un superobjeto ??
  require ("probe5")  --Objeto Probe, debería usar instancias de un superobjeto ??
  require ("planetsData") --Data para creación de los planetas
  require ("probesData") --Data para creación de las probes
  require ("mouseAndCameras") --Funciones de uso de ratón y cámaras
  require ("stars") --funciones para la creación de un fondo estrellado (no funciona por origen de X y Y)
  require ("levelHandler") --funciones para el seguimiento de los niveles
  require ("gameMechanics") --mecánicas generales del juegeo. Separar las que pertenecen a las probes, los planetas, a los niveles y al juego

end

------------------------------------------------------------------------

function love.draw(dt) 
  levelDraw(dt) --Variable que recoge la función draw de cada nivel
end

---------------------------------------------------------------------------

function love.update(dt)
  levels(level) --funcion para saber en qué nivel estamos
  levelUpdate(dt) --Variable que recoge la función update de cada nivel
end

------------------------------------------------------------------------------