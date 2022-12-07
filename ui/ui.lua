
Ui = Object:extend()


function Ui:new(font)
	self.font = font

	-- slidebars
	-- self.slidebar = {}
	-- self.slidebar[0] = Slidebar("Sun mass", 130, 700, 3, 1, 10, self.font) -- N_iter
	-- self.slidebar[0].bubble_info = "Mass of the planet. Changing the mass will affect the force balance that rules its motion."

	-- buttons
	self.button = {}

	-- textboxes
	self.textbox = {}

	-- graphes
	self.graph = {}
	local size_graph = 10
	self.graph[0] = Graph(Vector(150,20), Vector(600,600), Vector(-size_graph*ua, size_graph*ua),Vector(-size_graph*ua,size_graph*ua))
end


function Ui:update()
	-- buttons

	-- slidebars
	-- for i = 0, #self.slidebar do 
	-- 	self.slidebar[i]:update()
	-- end
	-- bodies[1].m = 0.3*self.slidebar[0].value * um

	-- textboxes

	-- graphes
	for i = 0, #self.graph do 
		-- things that may be updated in graphes (size, position, scale)
	end
end


function Ui:draw()
	-- buttons

	-- slidebars
	-- for i = 0, #self.slidebar do -- draw menu buttons
	-- 	self.slidebar[i]:draw()
	-- end

	-- textboxes

	-- graphes
	for i = 0, #self.graph do 
		self.graph[i]:draw()
		for j = 0, #bodies do
			self.graph[i]:plot(bodies[j].X[1], bodies[j].color)
			self.graph[i]:plotline(bodies[j].trajectory, bodies[j].color) -- earth
		end
	end
end


