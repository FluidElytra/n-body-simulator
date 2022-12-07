Object = require "lib/classic"
Vector = require "lib/hump.vector"
Timer = require "lib/hump.timer"
utf8 = require("utf8")
require "ui/ui"
require "ui/slidebar"
require "ui/slidebutton"
require "ui/button"
require "ui/textbox"
require "ui/graph"
require "body"

timer = Timer.new()
devMode = false
love.window.setTitle("N-body simulation")
love.graphics.setDefaultFilter('nearest','nearest')
love.window.setMode(800, 700)
love.graphics.setBackgroundColor(31/255, 36/255, 48/255)
CMU_serif = love.graphics.newFont("fonts/computer-modern/cmunrm.ttf", 15)
CMU_serif_italic = love.graphics.newFont("fonts/computer-modern/cmunci.ttf", 35)
CMU_typewriter = love.graphics.newFont("fonts/computer-modern/cmuntb.ttf", 15)
pink = {228/255, 167/255, 239/255, 1}
green = {80/255, 250/255, 123/255, 1}
greeny = {80/255, 250/255, 123/255, 1}
white = {1, 1, 1, 1}
blue = {3/255, 236/255, 252/255}
yellow = {251/255, 255/255, 0/255}

ua = 149597870700 	-- [m] Unité astronomique (distance Terre-Soleil)
me = 5.972e24		-- [kg]	Masse terrestre
um = 1.989e30		-- [kg]	Unité massique (masse du Soleil)
G = 6.67408e-11 	-- gravitationnal constant

function love.load()
	bodies = {}

	--2*math.sqrt(G*bodies[0].m*(ua/2)/(ua)^2)

	local v = 20000
	local d = 5*ua
	local m = 4*um

	-- planet 0
	bodies[0] = Body(m, Vector(-d, 0) , Vector(0, 0), 1) -- sun
	bodies[0].V[0].x = 0.5*v
	bodies[0].V[0].y = 0.5*v
	bodies[0].color = yellow

	-- planet 1
	bodies[1] = Body(3*m, Vector(0, 0), Vector(0, 0), 0)
	bodies[1].V[0].x = -0.5*v
	bodies[1].V[0].y = -1.5*v
	bodies[1].color = greeny

	-- planet 2
	bodies[2] = Body(3*m, Vector(d, 0)  , Vector(0, 0), 2)
	bodies[2].V[0].x = -1.5*v
	bodies[2].V[0].y = 1.5*v
	bodies[2].color = pink


	UI = Ui(CMU_typewriter)
end

function love.update(dt)
	for i = 0, #bodies do
		bodies[i]:update('verlet', bodies)
	end

	UI:update()
end

function love.draw()
	UI:draw()
end


-- function love.textinput(t)
-- 	for i = 0, #UI.textbox do
-- 		UI.textbox[i]:getText(t)
-- 	end
-- end


function love.keypressed(key)
	for i = 0, #bodies do
		bodies[i]:reset(key)
	end
	-- for i = 0, #UI.textbox do
	-- 	UI.textbox[i]:controls()
	-- end
end

