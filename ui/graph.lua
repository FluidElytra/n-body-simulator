Graph = Object:extend()


function Graph:new(position, dimension, x_scale, y_scale)
	-- graph dimensions
	self.position = position
	self.dimension = dimension
	self.x_scale = x_scale
	self.y_scale = y_scale
	self.x_unit2pixels = (self.x_scale.y-self.x_scale.x) / self.dimension.x
	self.y_unit2pixels = (self.y_scale.y-self.y_scale.x) / self.dimension.y

	self.center = Vector(self.position.x + self.dimension.x/2, self.position.y + self.dimension.y/2)
end

function Graph:update()
	
end

function Graph:draw()
	local cross_size = 20
	local tic_size = 10
	local tic_n = 5
	local tic_x = self.position.x
	local tic_y = self.position.y+self.dimension.y
	local tic_step = self.dimension.y/(tic_n-1)
	local label = self.x_scale.x

	-- graph frame
	love.graphics.setColor(1, 1, 1)
	love.graphics.rectangle('line', self.position.x, self.position.y, self.dimension.x, self.dimension.y)
	love.graphics.line(self.center.x-cross_size/2,self.center.y,self.center.x+cross_size/2,self.center.y)
	love.graphics.line(self.center.x,self.center.y-cross_size/2,self.center.x,self.center.y+cross_size/2)
	-- xticks
	for i = 1,tic_n do
		
		love.graphics.line(tic_x,tic_y,tic_x,tic_y-tic_size)
		-- tick label
		love.graphics.printf(tostring(label/ua),CMU_serif,tic_x-15,tic_y+5,30,"center",0,1,1)

		tic_x = tic_x + tic_step
		label = label + tic_step*self.x_unit2pixels
	end

	love.graphics.printf("x [ua]",CMU_serif_italic,self.position.x+0.5*self.dimension.x-40,self.position.y+self.dimension.y+20,100,"center",0,1,1)

	-- yticks
	local label = self.y_scale.x
	for i = 1,tic_n do
		
		love.graphics.line(self.position.x,tic_y,self.position.x + tic_size,tic_y)
		-- tick label
		love.graphics.printf(tostring(label/ua),CMU_serif,self.position.x-30,tic_y-10,30,"center",0,1,1)
		tic_y = tic_y - tic_step
		label = label + tic_step*self.y_unit2pixels
	end

	love.graphics.printf("y [ua]",CMU_serif_italic,self.position.x-120,self.position.y+0.5*self.dimension.y-20,90,"center",0,1,1)

	love.graphics.setColor(1, 1, 1)

end

function Graph:plot(points, color)
	local radius = 7
	if #points > 0 then
		for i = 0,#points do
			-- transform x, y in the frame of the graph
			local x_graph = self.center.x + points[i].x / self.x_unit2pixels
			local y_graph = self.center.y - points[i].y / self.y_unit2pixels
			-- plot the points
			love.graphics.setColor(color)
			love.graphics.circle('fill', x_graph, y_graph, radius)
			love.graphics.setColor(1, 1, 1)
		end
	else
		-- transform x, y in the frame of the graph
		local x_graph = self.center.x + points.x / self.x_unit2pixels
		local y_graph = self.center.y - points.y / self.y_unit2pixels
		-- plot the points
		if x_graph < self.position.x + self.dimension.x and x_graph > self.position.x then
			if y_graph < self.position.y + self.dimension.y and y_graph > self.position.y then
				love.graphics.setColor(color)
				love.graphics.circle('fill', x_graph, y_graph, radius)
				love.graphics.setColor(1, 1, 1)
			end
		end
	end
end

function Graph:plotline(line, color)
	local tail = 100
	local N_sup = #line
	local N_inf = N_sup-tail
	if #line < tail+1 then
		N_inf = 2
	end

	for i = N_inf,N_sup do
		if i%2 == 0 then
			-- transform x, y in the frame of the graph
			local x1 = self.center.x + line[i-1].x / self.x_unit2pixels
			local y1 = self.center.y - line[i-1].y / self.y_unit2pixels
			local x2 = self.center.x + line[i].x   / self.x_unit2pixels
			local y2 = self.center.y - line[i].y   / self.y_unit2pixels
			if x1 < self.position.x + self.dimension.x and x1 > self.position.x then
				if y1 < self.position.y + self.dimension.y and y1 > self.position.y then
					-- plot the points
					love.graphics.setColor(color)
					love.graphics.line(x1, y1, x2, y2)
					love.graphics.setColor(1, 1, 1)
				end
			end
		end
	end
end