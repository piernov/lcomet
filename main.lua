--[[
	main.lua
	Main file used by LÖVE to start the game
	by piernov
]]--

--require 'love2d-fakecanvas/fakecanvas' -- Load canvas emulation library

Debug = false -- Set to true to view the answer in Solo mode

Mute = false

Screen = {} -- Contains window width and height
--Fonts = {} -- Used to store preloaded fonts

Gamestate = require "hump.gamestate"
--Config = require "Gamestates/Config"
--Menu = require "Gamestates/Menu"
Solo = require "Gamestates/Solo"

local min_dt = 1/25 -- Cap FPS to 25, avoid extensive CPU use, snippet from LÖVE Wiki under love.timer.sleep()
local next_time = 0

function love.load()
--	Config:loadUserConfig() -- Read user configuration file to load player_name
	Screen.width, Screen.height = love.window.getMode()
	love.resize(Screen.width, Screen.height) -- Call love.resize() in order to preload fonts
--	love.graphics.setFont(Fonts[4]) -- Use font with size 4% by default

	Gamestate.registerEvents() -- Initialize hump Gamestate library
	Gamestate.switch(Solo) -- Switch to menu

--	next_time = love.timer.getTime() -- FPS limiting
end

function love.resize(w, h)
	Screen.width, Screen.height = w, h
--	Fonts[4] = love.graphics.newFont("Resources/vermin_vibes_1989.ttf", 0.04*Screen.height)
--	Fonts[3] = love.graphics.newFont("Resources/vermin_vibes_1989.ttf", 0.03*Screen.height)
end

-- FPS limiting
function love.update(dt)
	next_time = next_time + min_dt
end

function love.draw()
	local cur_time = love.timer.getTime()
	if next_time <= cur_time then
		next_time = cur_time
		return
	end
	love.timer.sleep(next_time - cur_time)
end
-- End

function love.keypressed(key)
	if key == "escape" then -- Handle return key on Android or Escape key on regular keyboard
		if Previous then -- Switch to previous entry if we aren't a the menu's root, otherwise quit
			Gamestate.switch(require(Previous))
		else
			love.event.quit()
		end
	end
end
