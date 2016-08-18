--[[
	Gamestates/Menu.lua
	Main menu
	by piernov

	Comment: might not be a good idea to immediately load both Solo and Multiplayer mode.
]]--

local Menu = {}
local Gui = require "Quickie"
local Utils = require "Utils"
local GUI = { Menu = require("GUI/Menu")}
local Gamestates = {
	Solo = require("Gamestates/Solo"),
--	Multiplayer = require("Gamestates/Multiplayer"),
--	About = require("Gamestates/About")
}
Gamestates.Options = Config


function Menu:enter()
	Previous = nil -- Menu's root

-- Redefine Quickie's colors
	Gui.core.style.color.normal.fg[1] = 0
	Gui.core.style.color.normal.fg[2] = 0
	Gui.core.style.color.normal.fg[3] = 255

	Gui.core.style.color.normal.bg[1] = 0
	Gui.core.style.color.normal.bg[2] = 0
	Gui.core.style.color.normal.bg[3] = 0

	Gui.core.style.color.hot.fg[1] = 0
	Gui.core.style.color.hot.fg[2] = 0
	Gui.core.style.color.hot.fg[3] = 255

	Gui.core.style.color.hot.bg[1] = 48
	Gui.core.style.color.hot.bg[2] = 48
	Gui.core.style.color.hot.bg[3] = 48

	Gui.core.style.color.active.fg[1] = 0
	Gui.core.style.color.active.fg[2] = 0
	Gui.core.style.color.active.fg[3] = 255

	Gui.core.style.color.active.bg[1] = 24
	Gui.core.style.color.active.bg[2] = 24
	Gui.core.style.color.active.bg[3] = 24
-- End
--	Menu.Music = love.audio.newSource("Resources/BlueMind.ogg")
--	Menu.Music:setLooping(true)
--	if Config.Mute == false then
--		Menu.Music:play()
--	end
end

function Menu:update(dt)
	Gui.group{grow = "down", pos = {Utils.percentCoordinates(10, 10)}, function()
		for _, name in ipairs(GUI.Menu.Buttons) do
			if Gui.Button{text = name, size = {Utils.percentCoordinates(80, 20)}} then -- Display main menu buttons and switch gamestate if clicked
				Gamestate.switch(Gamestates[name])
			end
		end
	end}
end

function Menu:draw()
	Gui.core.draw()
end



return Menu
