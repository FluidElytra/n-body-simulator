SlideButton = Object:extend()


function SlideButton:new(x,y,w,h,index,text,font)
	self.x, self.y, self.w0, self.h = x, y, w, h -- position and dimensions
	self.text = text
	self.font = font

	self.w = 80 -- initial width of the rectangle
	self.velocity = 3 -- animation velocity
	self.colorTouching = {228/255, 167/255, 239/255} -- if the mouse is on the button
	self.colorClicked = {1,1,1} -- if the mouse clicks on the button
	self.colorBase = {1,1,1} -- if nothing happens :(
	self.colorText = {31/255, 36/255, 48/255}
	self.index = index
	self.state = false -- state false by default and true if clicked
	self.mouseReleased = true -- triggers the release of the mouse button(1)
end


function SlideButton:update()
	if love.mouse.isDown(1) then -- state
		if self:collide() then
			if self.mouseReleased == true and self.state == false then
				self.state = true
				self.mouseReleased = false
			elseif self.mouseReleased == true and self.state == true then
				self.state = false
				self.mouseReleased = false
			end
		end
	else
		self.mouseReleased = true 
	end

	local wmax = self.w0*1.1 -- maximum width of the boxes
	if self:collide() then
		if self.w < wmax then
			self.w = self.w+self.velocity
		end
	else
		if self.w > self.w0 then
			self.w = self.w-1.5*self.velocity
		elseif self.w < self.w0-10 then
			self.w = self.w+1*self.velocity
		else
			self.w = self.w0
		end
	end
end


function SlideButton:draw()
	if self:collide() then
		love.graphics.setColor(self.colorTouching)
		if love.mouse.isDown(1) then
			love.graphics.setColor(self.colorClicked)
		end
	else
		love.graphics.setColor(self.colorBase)
		if self.state == true then
			love.graphics.setColor(self.colorTouching)
		end
	end

	love.graphics.rectangle("fill",self.x, self.y, self.w, self.h,2,2) -- draw the button shape
	love.graphics.setColor(self.colorText)
	love.graphics.printf(self.text,self.font,self.x+25,self.y+5,self.w,"center",0,1,1)
	love.graphics.setColor(1,1,1)
end


function SlideButton:collide()
	-- true if the mouse is on the button
	local x,y = love.mouse.getPosition()
	if x > self.x and x < self.x + self.w and y < self.y + self.h and y > self.y then
		return true
	else
		return false
	end
end