
probesLevel1 = 2
initLevel1 = false

level1Draw = function ()
					cameraMain:draw(function()
					                  --rockDraw()
					                  colorZones()
					                  for i, prob in ipairs(probes) do
					                      prob:draw()
					                  end
					                  gravityBeam()
					                  --drawForces()
					                  for i, planet in ipairs(planetas) do
					                    planet:draw()
					                  end
					                end)  
					  
					  printTexts()
					end
level1Update = function (dt)
						
						--delta = dt
						if state == 'pause' then
					    	return
					  	end
					  
					  	mouseUpdate()
					  	launchProbes(dt)
					  	checkOrbitsDone()
					  	cameraFollowsPlanet()
					  
					  	for i, prob in ipairs(probes) do
					    	for j, planet in ipairs(planetas) do
						      	prob:update(dt)
						      	prob:influencedByGravityOf(planet)
						      	if state == "play" then
						      		prob:keyboardMove(dt)
						      	end
					    	end
					  	end
					end
