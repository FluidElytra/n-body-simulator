Slidebar = Object:extend()

local selector_velocity = 0.5 -- increase the selector diameter every time step
local bubble_velocity = 0.5

function Slidebar:new(label, x, y, value, inf, sup, font)
	--- x, y : position of the slide bar (does not include the label)
	-- value : initial value (scalar)
	-- inf, supp : min and max value the Slidebar may return (scalars)

	self.label = label
	self.x = x
	self.y = y
	self.value = value
	self.inf = inf
	self.sup = sup
	self.font = font

	self.bubble_info = ""
	self.bubble_alpha = 0

	self.w = 200
	self.h = 4
	self.selector_r = 10
	self.selector_r0 = 10

	self.color_label = white
	self.color_selector = white
	self.color_main = white
	self.color_value = green

	self.max_value = sup
	
	self.state = "none"

	local x0 = math.ceil(self.x + (self.value-self.inf) * self.w/(self.sup - self.inf))
 	self.selectorPosition = Vector(x0,y+self.h*0.5) -- position initiale
end


function Slidebar:update()
	if self:collideAll() then -- is the item flight over ?
		if self.state ~= "clicked" then
			self.state = "fly"
		end
		if love.mouse.isDown(1) and self:collide() then -- is the item clicked ?
			self.state = "clicked"
			-- drag
			local x, y = love.mouse.getPosition()
			if self.selectorPosition.x <= self.x + self.w and self.selectorPosition.x >= self.x then -- bug
				self.selectorPosition.x = x
			end
			-- growth animation
			if self.selector_r < 1.25 * self.selector_r0 then
				self.selector_r = self.selector_r + selector_velocity
			end
		else
			if self.state ~= "clicked" then
				self.state = "fly"
			end
			-- decay animation
			if self.selector_r > self.selector_r0 then
				self.selector_r = self.selector_r - selector_velocity
			end
		end
	else
		self.state = "none"
	end

	self.value = math.ceil(self.inf + (self.selectorPosition.x - self.x) * (self.sup - self.inf)/self.w) -- update output value
	if self.value > self.max_value then
		self.value = self.max_value
		-- update selector position
		self.selectorPosition.x =  math.ceil(self.x + (self.value-self.inf) * self.w/(self.sup - self.inf))
	end
end


function Slidebar:draw()
	self.color_value[4] = 0
	if self.state == "none" then
		self.color_label = white
		self.color_selector = white
		self.color_main = white
	elseif self.state == "fly" then
		self.color_label = pink
		self.color_selector = pink
		self.color_main = pink
	elseif self.state == "clicked" then
		self.color_selector = pink
		self.color_value[4] = 1
	end

	-- label
	local label_size = 120
	local yoffset = 8
	love.graphics.setColor(self.color_label)
	love.graphics.printf(self.label,self.font,self.x-label_size,self.y-yoffset,label_size,"left",0,1,1)

	-- bar and inf and sup labels
	love.graphics.setColor(self.color_main)
	love.graphics.printf(self.inf,self.font,self.x-55,self.y-yoffset,50,"right",0,1,1) -- inf
	love.graphics.printf(self.sup,self.font,self.x+self.w+5,self.y-yoffset,50,"left",0,1,1) -- sup
	love.graphics.rectangle("fill", self.x, self.y,self.w, self.h)

	-- selector
	love.graphics.setColor(self.color_selector)
	love.graphics.circle("fill", self.selectorPosition.x, self.selectorPosition.y, self.selector_r)
	
	-- value
	love.graphics.setColor(self.color_value)
	love.graphics.printf(self.value,self.font,self.selectorPosition.x-20,self.selectorPosition.y-29,40,"center",0,1,1)
	if self.value == self.max_value then
		love.graphics.printf("max",self.font,self.selectorPosition.x-20,self.selectorPosition.y+10,40,"center",0,1,1)
	end
	-- info bubble
	self:bubble()

	love.graphics.setColor(1, 1, 1, 1)
end


function Slidebar:collide()
	local tolerance = 1.5 
	-- true if the mouse is on the button
	local x, y = love.mouse.getPosition()
	local r = math.sqrt((x-self.selectorPosition.x)^2+(y-self.selectorPosition.y)^2)
	if r < self.selector_r*tolerance then
		return true
	else
		return false
	end
end


function Slidebar:collideAll()
	-- true if the mouse is on the button
	local x,y = love.mouse.getPosition()
	if x > self.x and x < self.x + self.w and y < self.y + 1.5*self.selector_r and y > self.y - 1.5*self.selector_r then
		return true
	else
		return false
	end
end


function Slidebar:bubble() -- a découper pour ne pas tout calculer à chaque fois
	if self.bubble_info ~= "" then
		local bubble_w = 200 -- max width of the bubble
		local width, wrapped_text = self.font:getWrap(self.bubble_info, bubble_w) -- max width of the text and text table
		if #wrapped_text == 1 then
			bubble_w = self.font:getWidth(self.bubble_info)
		end
		local bubble_h = self.font:getHeight(self.bubble_info)*#wrapped_text
		local alpha_max = 0.3
		local text_offset = 5
		local bubble_x = self.x+self.w+30
		local bubble_y = self.y - bubble_h*0.5

		if self.state == "fly" then
			if self.bubble_alpha < alpha_max then -- apparition
				self.bubble_alpha = self.bubble_alpha + 0.02
			end
		else
			if self.bubble_alpha > 0 then -- disparition
				self.bubble_alpha = self.bubble_alpha - 0.02
			end
		end
		love.graphics.setColor(0,0,0,self.bubble_alpha)
		love.graphics.rectangle("fill", bubble_x, bubble_y, bubble_w+2*text_offset, bubble_h, 5, 5)
		love.graphics.setColor(1,1,1,self.bubble_alpha)
		for i, text in pairs(wrapped_text) do
			local y = bubble_y + (i-1)*self.font:getHeight(self.bubble_info)
			love.graphics.printf(text, self.font, bubble_x+text_offset, y, bubble_w, "left",0,1,1)
		end
		-- love.graphics.printf(self.bubble_info,self.font,self.x+self.w+30+text_offset, self.y - bubble_h*0.5,bubble_w,"left",0,1,1)
		love.graphics.setColor(1,1,1,1)
	end
end