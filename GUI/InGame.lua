--[[
	GUI/InGame.lua
	Game interface
	by Roildan & piernov
]]--

local InGame = {}

InGame.Polygons = {} -- Tableau utilisé pour la fonction InGame.drawPolygon(polygon)

InGame.Colors = { {255, 0, 0, 255}, {255, 128, 0, 255}, {255, 255, 0, 255}, {0, 255, 0, 255}, {128, 128, 128, 255}, {255, 255, 255, 255} } -- Tableau de 6 couleurs.

function InGame.drawPolygon(polygon) -- Fonction pour dessiner.
	if polygon.Colors then
		love.graphics.setColor(unpack(polygon.Colors))
	end

	if polygon.LineWidth then
		love.graphics.setLineWidth(polygon.LineWidth*(Screen.width+Screen.height)/2)
	end

	if polygon.Type == "rectangle" then
		love.graphics.rectangle(polygon.DrawMode, polygon.Position.x*Screen.width, polygon.Position.y*Screen.height,
			polygon.Dimension.width*Screen.width, polygon.Dimension.height*Screen.height)

	elseif polygon.Type == "polygon" then
		love.graphics.polygon(polygon.DrawMode, polygon.Position.x1*Screen.width, polygon.Position.y1*Screen.height,
			polygon.Position.x2*Screen.width, polygon.Position.y2*Screen.height,
			polygon.Position.x3*Screen.width, polygon.Position.y3*Screen.height,
			polygon.Position.x4*Screen.width, polygon.Position.y4*Screen.height)

	elseif polygon.Type == "line" then
		love.graphics.line(polygon.Position.x1*Screen.width, polygon.Position.y1*Screen.height,
			polygon.Position.x2*Screen.width, polygon.Position.y2*Screen.height)
	elseif polygon.Type == "print" then
		love.graphics.print(polygon.Text, polygon.Position.x*Screen.width, polygon.Position.y*Screen.height)
	end
end

function InGame.displayPopup(text) -- Display a popup on the center of the screen
	love.graphics.setFont(Fonts[4])
	InGame.drawPolygon({ Type = "rectangle", LineWidth = 0.01, DrawMode = "line", Position = { x = 0.30, y = 0.40}, Dimension = {width = 0.40, height = 0.20}, Colors = {0, 0, 255, 255}})
	InGame.drawPolygon({ Type = "rectangle", DrawMode = "fill", Position = { x = 0.30, y = 0.40}, Dimension = {width = 0.40, height = 0.20}, Colors = {0, 0, 0, 255}})
	InGame.drawPolygon({ Type = "print", Text = text, Position = {x = 0.45, y = 0.48}, Colors = {255, 255, 255, 255}})
	love.graphics.setFont(Fonts[3])
end

function InGame.loadInterface() -- Interface used in both Solo and Multiplayer mode
	love.graphics.setBackgroundColor(0, 0, 0)

end

function InGame.loadMultiplayerInterface() -- Addition elements for Multiplayer

end

return InGame