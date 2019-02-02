--[[ 

	BitOrBit v.1.1.5

    Author: Rodrigo Garcia
    roderikout@gmail.com

  	-- Dependencies --

	Dependencias de clases y de otros archivos

]]--

-- https://github.com/vrld/hump/blob/master/class.lua
Class = require 'lib/class'

utils = require 'lib/utils'  --funciones utilitarias bajadas de GitHub, casi todas en lume, algunas no estan y otras anadidas por mi (buscar copyright)
lume = require 'lib/lume'  --funciones auxiliares bajadas de GitHub, tiene mas que Utils pero utils tiene unas que no hay aca (buscar copyright)
 
cameraMain = require 'lib/camera'.new(0,0)
timer = require 'lib/timer'
vector = require 'lib/vector'

--Controlador de la State Machine
require 'src/StateMachine'

-- each of the individual states our game can be in at once; each state has
-- its own update and render methods that can be called by our state machine
-- each frame, to avoid bulky code in main.lua
require 'src/states/BaseState'
require 'src/states/PlayState'
require 'src/states/StartState'
require 'src/states/ServeState'
require 'src/states/VictoryState'
require 'src/states/WinState'

-- assets
require 'src/Planet'
require 'src/Probe'
require 'src/LevelMaker'
require 'src/ColorZones'

--otras utilidades
require 'src/Constants'
require 'src/Prints'

--recortando funciones esto va en UTILS
--keyboard & mouse
isDown = love.keyboard.isDown

--utils
randomInt = utils.randomInt
clamp = utils.clamp
intersectSegment = utils.intersectSegment

--graphics
rectangle = love.graphics.rectangle
circle = love.graphics.circle 
line = love.graphics.line 
setLineWidth = love.graphics.setLineWidth 
setColor = love.graphics.setColor 
getDimensions = love.graphics.getDimensions 

----------

width, height = getDimensions()