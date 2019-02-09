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
 
timer = require 'lib/timer'
vector = require 'lib/vector'

--Controlador de la State Machine
require 'src/StateMachine'

-- each of the individual states our game can be in at once; each state has
-- its own update and render methods that can be called by our state machine
-- each frame, to avoid bulky code in main.lua
require 'src/states/BaseState'
require 'src/states/StartState'
require 'src/states/NewLevelState'
require 'src/states/ServeState'
require 'src/states/PlayState'
require 'src/states/VictoryState'
require 'src/states/WinState'

-- assets
require 'src/Planet'
require 'src/Probe'
require 'src/LevelMaker'

--otras utilidades
require 'src/Constants'
require 'src/Prints'