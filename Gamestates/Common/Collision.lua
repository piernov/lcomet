--[[
	Gamestates/Common/Collision.lua
	Collision handling
	by piernov
]]--

local Collision = {}
local newPlanets = {}

local function beginContact(a, b, coll)
	local x,y = coll:getNormal()
	local an = a:getUserData()
	local bn = b:getUserData()
	if ( an == "Bullet" or bn == "Bullet" ) and (an == "Planet" or bn == "Planet") then
			local obj
			if an == "Planet" then
				obj = a
			else
				obj = b
			end

			local r = obj:getShape():getRadius()
			local x,y = obj:getBody():getPosition()
print(r)
			table.insert(newPlanets, {x = x, y = y, r = r})

			a:destroy()
			b:destroy()
	end

end

local function endContact(a, b, coll)
end

local function preSolve(a, b, coll)
end

local function postSolve(a, b, coll, normalimpulse1, tangentimpulse1, normalimpulse2, tangentimpulse2)
	print("postSolve: ", a, b, coll, normalimpulse1,tangentimpulse1,normalimpulse2,tangentimpulse2)
end

function Collision:update(world, objects)
	-- Add new planets from explosion
	for k,v in pairs(newPlanets) do
--	print("Update: ", v.r, v.x, v.y, world)
		for i=1,2 do
			if v.r >=20 then
				local planet = {}
				planet.body = love.physics.newBody(world, math.floor(v.x), math.floor(v.y), "dynamic")
				planet.shape = love.physics.newCircleShape(v.r/2)
				planet.fixture = love.physics.newFixture(planet.body, planet.shape, (v.r/20)+4)
				planet.fixture:setUserData("Planet")

				local x = math.random(v.r/5)
				math.randomseed( tonumber(tostring(os.time()):reverse():sub(1,6)) )

				local y = math.random(v.r/5)
				math.randomseed( tonumber(tostring(os.time()):reverse():sub(1,6)) )

				planet.body:applyLinearImpulse( x-(v.r/10), y-(v.r/10) )
				table.insert(objects.Planets, planet)
			end
		end
		table.remove(newPlanets, k)
	end
--print("nbPlanets: ", #objects.Planets)

end

function Collision:init(world, objects)
	world:setCallbacks(beginContact, endContact, preSolve, postSolve)
end

return Collision
