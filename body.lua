Body = Object:extend()

local ua = 149597870700
local dt_simu = 3600*10 	-- [s] Time step (1 day)
local dot_size = ua/10

function Body:new(m, x_0, v_0, ID)
	self.X = {}
	self.V = {}
	self.A = {}
	self.X0 = x_0
	self.V0 = v_0
	self.X[0] = x_0
	self.X[1] = x_0
	self.V[0] = v_0
	self.V[1] = v_0
	self.A[0] = Vector(0,0)
	self.A[1] = Vector(0,0)
	self.trajectory = {self.X[1]}
	self.m  = m
	self.ID = ID
	self.color = {1,1,1}
end


function Body:update(method,neighbor)
	if method == 'verlet' then
		self:verlet(neighbor)
	elseif method == 'euler' then
	    self:euler(neighbor)
	end
end


function Body:euler(neighbor)
	local r = {}
	local F = {}
	local dir = {}
	local F_tot = Vector(0,0)
	local c = 0

	for i = 0,#neighbor do
		-- sum of the forces acting on the body
		if self.ID ~= neighbor[i].ID then
			r[c] = Vector(self.X[0].x-neighbor[i].X[0].x, self.X[0].y-neighbor[i].X[0].y)-- compute distance
			dir[c] = r[c]:normalized() -- force direction
			F[c] = -(G*self.m*neighbor[i].m)/(math.sqrt(r[c].x^2+r[c].y^2)^2)-- compute force
			F_tot = F_tot + F[c]*dir[c]
			c = c + 1
		end
	end

	self.A[1] = F_tot / self.m -- acceleration
	self.V[1] = self.V[0] + dt_simu * self.A[0] -- velocity
	self.X[1] = self.X[0] + dt_simu * self.V[0] -- position

	self.A[0] = self.A[1]
	self.V[0] = self.V[1]
	self.X[0] = self.X[1]

	if math.sqrt((self.trajectory[#self.trajectory].x-self.X[1].x)^2+(self.trajectory[#self.trajectory].y-self.X[1].y)^2) > dot_size then
		table.insert(self.trajectory, self.X[1])
	end
end

function Body:verlet(neighbor)
	local r = {}
	local F = {}
	local dir = {}
	local F_tot = Vector(0,0)
	local c = 0
	local A0 = Vector(0,0)

	-- sum of the forces
	for i = 0,#neighbor do
		if self.ID ~= neighbor[i].ID then
			r[c] = Vector(self.X[0].x-neighbor[i].X[0].x, self.X[0].y-neighbor[i].X[0].y)-- compute distance
			dir[c] = r[c]:normalized() -- force direction
			F[c] = -(G*self.m*neighbor[i].m)/(math.sqrt(r[c].x^2+r[c].y^2)^2)-- compute force
			F_tot = F_tot + F[c]*dir[c] -- contains the total force
			c = c + 1
		end
	end

	A0 = F_tot / self.m -- acceleration
	self.X[1] = self.X[0] + dt_simu * self.V[0] + 0.5*dt_simu^2*A0 -- position

	-- sum of the forces
	for i = 0,#neighbor do
		if self.ID ~= neighbor[i].ID then
			r[c] = Vector(self.X[1].x-neighbor[i].X[0].x, self.X[1].y-neighbor[i].X[0].y)-- compute distance
			dir[c] = r[c]:normalized() -- force direction
			F[c] = -(G*self.m*neighbor[i].m)/(math.sqrt(r[c].x^2+r[c].y^2)^2)-- compute force
			F_tot = F_tot + F[c]*dir[c] -- contains the total force
			c = c + 1
		end
	end

	self.A[1] = F_tot / self.m -- acceleration
	self.V[1] = self.V[0] + 0.5*dt_simu*(A0+self.A[1]) -- velocity
	
	self.A[0] = self.A[1]
	self.V[0] = self.V[1]
	self.X[0] = self.X[1]

	if math.sqrt((self.trajectory[#self.trajectory].x-self.X[1].x)^2+(self.trajectory[#self.trajectory].y-self.X[1].y)^2) > dot_size then
		table.insert(self.trajectory, self.X[1])
	end
end

function Body:reset(key)
	if love.keyboard.isDown("r") then
		self.X[1] = self.X0
		self.V[1] = self.V0
		self.X[0] = self.X0
		self.V[0] = self.V0
		self.trajectory = {self.X[1]}
	end
end


function table.removeKey(table, key)
    local element = table[key]
    table[key] = nil
    return element
end