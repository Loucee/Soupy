
--[[
	Author: Lucy van Sandwijk
	Website: https://loucee.dev
	GitHub: https://github.com/Loucee/Soupy-love
]]

local soupy = {
	event = { },
	math = { },
	physics = { },
	timer = { }
}

local _current_state = ""
local _states = { }
local _timers = { }

--------------------------------------------------------------------------------

function soupy.event.update(dt)
	for index, state in pairs(_states) do
		if state and state._enabled and state.update then
			state:update(dt)
		end
	end

	-- Update timers
	for i = #_timers, 1, -1 do
		local t = _timers[i]

		t._timePassed = t._timePassed + dt
		if (t._timePassed >= t.interval) then
			t.callback(unpack(t.args))

			if (t.repeats) then
				t._timePassed = 0
			else
				table.remove(_timers, i)
			end
		end
	end
end

function soupy.event.draw()
	for index, state in pairs(_states) do
		if state and state._enabled and state.draw then
			state:draw()
		end
	end
end

function soupy.event.keypressed(key, unicode)
	for index, state in pairs(_states) do
		if state and state._enabled and state.keypressed then
			state:keypressed(key, unicode)
		end
	end
end

function soupy.event.keyreleased(key, unicode)
	for index, state in pairs(_states) do
		if state and state._enabled and state.keyreleased then
			state:keyreleased(key, unicode)
		end
	end
end

function soupy.event.mousepressed(x, y, button)
	for index, state in pairs(_states) do
		if state and state._enabled and state.mousepressed then
			state:mousepressed(x,y,button)
		end
	end
end

function soupy.event.mousereleased(x, y, button)
	for index, state in pairs(_states) do
		if state and state._enabled and state.mousereleased then
			state:mousereleased(x,y,button)
		end
	end
end

--------------------------------------------------------------------------------

function soupy.addState(file, name)
	local class = require(file)
	class._enabled = false
	class._identifier = name
	class:load()

	table.insert(_states, class)
end

function soupy.removeState(name)
	for index, state in pairs(_states) do
		if state._identifier == name then
			-- Call cleanup function if state has one
			if state.cleanup then
				state:cleanup()
			end
			table.remove(_states, index)
		end
	end
end

function soupy.enterState(name)
	if _current_state ~= name and _current_state ~= "" then
		soupy.leaveState(_current_state)
	end

	for index, state in pairs(_states) do
		if state._identifier == name then
			_current_state = name
			state._enabled = true
		end
	end
end

function soupy.leaveState(name)
	for index, state in pairs(_states) do
		if state._identifier == name then
			state._enabled = false
		end
	end
end

--------------------------------------------------------------------------------

function soupy.math.hypot(x, y)
	return math.sqrt(x * x + y * y)
end

function soupy.math.distance(fromX, fromY, toX, toY)
	local dx = fromX - toX
	local dy = fromY - toY
	return math.sqrt(dx * dx + dy * dy)
end

--------------------------------------------------------------------------------

function soupy.physics.gravitateToward(x1, y1, x2, y2, gravityPull)
	local dx = x1 - x2
	local dy = y1 - y2
	local f = gravityPull / math.pow(math.sqrt(dx * dx + dy * dy), 2)
	local angle = math.atan2(dy, dx)
	local fx = -f * math.cos(angle)
	local fy = -f * math.sin(angle)
	return fx, fy
end

function soupy.physics.circlesIntersect(x1, y1, r1, x2, y2, r2)
	return (x1 - x2) ^ 2 + (y1 - y2) ^ 2 <= (r1 + r2) ^ 2
end

function soupy.physics.boxCollision(x1, y1, w1, h1, x2, y2, w2, h2)
	return x1 < x2 + w2 and x2 < x1 + w1 and y1 < y2 + h2 and y2 < y1 + h1
end

--------------------------------------------------------------------------------

function soupy.timer.new(interval, repeats, callback, ...)
	local t = {
		_identifier = tostring(callback),
		_timePassed = 0,
		interval = interval,
		repeats = repeats,
		callback = callback,
		args = {...}
	}

	table.insert(_timers, t)
	return t
end

function soupy.timer.stop(t)
	for index, timer in pairs(_timers) do
		if timer._identifier == t._identifier then
			table.remove(_timers, index)
		end
	end
end

--------------------------------------------------------------------------------

return soupy
