--[[
	Utils.lua
	Used for unclassified functions
	by piernov

	Comment: a bit useless, but still a more convenient than nothing for Quickie's functions
]]--

local Utils = {}

function Utils.percentCoordinates(x, y) -- Convert percentage to absolute coordinates
    x = (x/100)*Screen.width
    y = (y/100)*Screen.height
    return x, y
end

return Utils
