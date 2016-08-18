--[[
	Gamestates/Solo.lua
	Solo mode
	by piernov
]]--

local GUI = { InGame = require("GUI/InGame")}
local Collision = require("Gamestates/Common/Collision")

local Solo = {
	Objects = {
		Planets = {},
		Players = {},
		Bullets = {},
	},
}

local newPlanets = {}
local nbPlayers = 1

function Solo:resize() -- Called in :enter() and when the window is resized
	Solo.Display = love.graphics.newCanvas(Screen.width, Screen.height) -- Create the canvas containing base interface to avoid drawing it entirely each frame
	love.graphics.setCanvas(Solo.Display)
		for id, polygon in ipairs(GUI.InGame.Polygons) do
			GUI.InGame.drawPolygon(polygon)
		end
	love.graphics.setCanvas()
end

function Solo:enter() -- Initialize or reset variables when entering game
	Previous = "Gamestates/Menu"
	Solo:resize() -- Call the function filling the canvas
end

function Solo:init()
	GUI.InGame.loadInterface()

	love.physics.setMeter(640) --the height of a meter our worlds will be 64px
	Solo.World = love.physics.newWorld(0, 0, true) --create a world for the bodies to exist in with horizontal gravity of 0 and vertical gravity of 9.81
	Collision:init(Solo.World, Solo.Objects)

	for i=1,4 do
		Solo.Objects.Planets[i] = {}
		Solo.Objects.Planets[i].body = love.physics.newBody(Solo.World, 100*i, 100*i, "dynamic")
		Solo.Objects.Planets[i].shape = love.physics.newCircleShape(40)
		Solo.Objects.Planets[i].fixture = love.physics.newFixture(Solo.Objects.Planets[i].body, Solo.Objects.Planets[i].shape, 4)
		Solo.Objects.Planets[i].fixture:setUserData("Planet")
	end

	for i=1,nbPlayers do
		Solo.Objects.Players[i] = {}
		Solo.Objects.Players[i].body = love.physics.newBody(Solo.World, 400, 200, "dynamic")
		Solo.Objects.Players[i].shape = love.physics.newPolygonShape(20, 0, -10, 17.32, -10, -17.32)
		Solo.Objects.Players[i].fixture = love.physics.newFixture(Solo.Objects.Players[i].body, Solo.Objects.Players[i].shape, 2)
		Solo.Objects.Players[i].body:setFixedRotation(true)
	        Solo.Objects.Players[i].fixture:setUserData("Player")
		Solo.Objects.Players[i].lastshoot = 100
	end
end

local function resetPos(v)
    x, y = v.body:getPosition()
	if x > Screen.width then
        x = 0
    elseif x < 0 then
        x = Screen.width
    end
    if y > Screen.height then
        y = 0
    elseif y < 0 then
        y = Screen.height
    end
    v.body:setPosition(x,y)
end

function Solo:update(dt)
--	Solo.World:update(dt) --this puts the world into motion

	for k,v in pairs(Solo.Objects.Planets) do
		resetPos(v)
	end
	for k,v in pairs(Solo.Objects.Bullets) do
		if v.time+dt >= 1 then
			v.fixture:destroy()
			v.fixture = nil
			v.body = nil
			v.shape = nil
			table.remove(Solo.Objects.Bullets, k)
		else
			v.time = v.time + dt
			resetPos(v)
		end
	end

	resetPos(Solo.Objects.Players[1])

	Collision:update(Solo.World, Solo.Objects)

	for i=1,nbPlayers do
		local player = Solo.Objects.Players[i]

		if love.keyboard.isDown("right") then --press the right arrow key to push the ball to the right
			player.body:setAngle(player.body:getAngle()+dt*3)
		end

		if love.keyboard.isDown("left") then --press the left arrow key to push the ball to the left
			player.body:setAngle(player.body:getAngle()-dt*3)
		end

		if love.keyboard.isDown("up") then --press the up arrow key to set the ball in the air
			player.body:applyForce(math.cos(player.body:getAngle()) , math.sin(player.body:getAngle()))
		end

		if love.keyboard.isDown("space") then
			if player.lastshoot < 0.1 then
				player.lastshoot = player.lastshoot + dt
			else
				player.lastshoot = 0

				local bullet = {}
				bullet.time = 0
				bullet.body = love.physics.newBody(Solo.World, player.body:getX() + math.cos(player.body:getAngle())*20, player.body:getY() +  math.sin(player.body:getAngle())*20, "dynamic")
				bullet.shape = love.physics.newCircleShape(6)
				bullet.fixture = love.physics.newFixture(bullet.body, bullet.shape, 5)
				bullet.fixture:setUserData("Bullet")
				bullet.body:setAngle(player.body:getAngle())
				bullet.body:applyLinearImpulse( math.cos(player.body:getAngle()) , math.sin(player.body:getAngle()) )
				table.insert(Solo.Objects.Bullets, bullet)
			end
		end
	end

	Solo.World:update(dt)

end


local function objCleanup(tbl)
	for k,v in pairs(tbl) do
		if v.fixture:isDestroyed() then
			v.fixture = nil
			v.body = nil
			v.shape = nil
			table.remove(tbl, k)
		end
	end
end

function Solo:draw()
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.setBlendMode("alpha", "premultiplied")
	love.graphics.draw(Solo.Display)
	love.graphics.setBlendMode('alpha')

	objCleanup(Solo.Objects.Planets)
	objCleanup(Solo.Objects.Bullets)

	for k,v in pairs(Solo.Objects.Planets) do
		love.graphics.setColor(193, 47, 14) --set the drawing color to red for the ball
		love.graphics.circle("fill", v.body:getX(), v.body:getY(), v.shape:getRadius())
	end

	for _,v in ipairs(Solo.Objects.Bullets) do
		love.graphics.setColor(44, 44, 192) --set the drawing color to red for the ball
		love.graphics.circle("fill", v.body:getX(), v.body:getY(), v.shape:getRadius())
	end

	for _,v in ipairs(Solo.Objects.Players) do
		love.graphics.setColor(193, 47, 14) --set the drawing color to red for the ball
		love.graphics.polygon("fill", v.body:getWorldPoints(v.shape:getPoints()))
		love.graphics.setColor(255,255,255)
		love.graphics.circle("fill", v.body:getX() + math.cos(v.body:getAngle())*20, v.body:getY() +  math.sin(v.body:getAngle())*20, 5)
	end
end

function Solo:leave()
end

return Solo
