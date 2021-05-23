# Soupy-love
Löve2D state-manager, timers, and other helpful functions

## Usage

### Include the library in your project
Step 1: Place the "soupy.lua" library somewhere in your source folder (e.g. "/lib/soupy.lua")<br/>
Step 2: Add a variable to require the library in your main.lua file:
```lua
Soupy = require("lib.soupy")
```

### Soupy functions
Soupy currently comes with a statemanager, timers, and a couple of math / physics related functions to use in your game.

#### State manager
Step 1: In `love.load()`, add your game's states like so:
```lua
function love.load()
	Soupy.addState("scenes.menu", "menu") -- Argument 1 is the file path for require, argument 2 is the state's name
	Soupy.addState("scenes.game", "game")
end
```

Step 2: Enable the state you would like to start in:
```lua
function love.load()
	Soupy.addState("scenes.menu", "menu")
	Soupy.addState("scenes.game", "game")
	
	Soupy.enterState("menu")
end
```
After this you can freely swap between states using `Soupy.enterState(name)`

Step 3: Forward the Love events you need to the Soupy library
```lua
function love.update(dt)
	Soupy.event.update(dt)
end

function love.draw()
	Soupy.event.draw()
end

function love.keypressed(key, unicode)
	Soupy.event.keypressed(key, unicode)
end

function love.keyreleased(key, unicode)
	Soupy.event.keyreleased(key, unicode)
end

function love.mousepressed(x, y, button)
	Soupy.event.mousepressed(x, y, button)
end

function love.mousereleased(x, y, button)
	Soupy.event.mousereleased(x, y, button)
end
```

Step 4: Create the state script (e.g. "scenes/menu.lua"):
```lua
local menu = { }

function menu:load()
end

function menu:draw()
end

function menu:update(dt)
end

function menu:keypressed(key, unicode)
end

function menu:keyreleased(key, unicode)
end

function menu:mousepressed(x, y, button)
end

function menu:mousereleased(x, y, button)
end

function menu:cleanup() -- This function is called when you do Soupy.removeState(name), and is used to clean up any variables/assets that are no longer needed
end
```

#### Timers
`Soupy.timer.new(interval, repeats, callback, args)`
- **interval:** How long to wait before firing the callback (in seconds)
- **repeats:** Whether or not the timer should repeat
- **callback:** Function to execute
- **args:** Any arguments you want to pass onto the callback function
```lua
function myCallback(arg1, arg2, arg3)
	print(arg1)
	print(arg2)
	print(arg3)
end

local myTimer = Soupy.timer.new(5, true, myCallback, "Test1", "Test2", "Test3")

-- Outcome:
--   Test1
--   Test2
--   Test3
--   Test1
--   Test2
--   Test3
--   ...
```
If you need to kill a timer you can use `Soupy.timer.stop(timer)`, the timer parameter being the timer object

#### Math
`Soupy.math.hypot(x, y)`<br/>
Returns `math.sqrt(x * x + y * y)`, find more information [here](https://en.wikipedia.org/wiki/Hypot)

`Soupy.math.distance(x1, y1, x2, y2)`<br/>
Returns the distance between 2 points

#### Physics
`Soupy.physics.circlesIntersect(x1, y1, r1, x2, y2, r2)`<br/>
Checks if 2 circles intersect with each other

`Soupy.physics.boxCollision(x1, y1, w1, h1, x2, y2, w2, h2)`<br/>
Simple bounding box collision, checks if the rectangle at x1, y2 with size w1, h1 overlaps with the rectangle at x2, y2 with size w1, h2

`Soupy.physics.gravitateToward(x1, y1, x2, y2, f)`<br/>
Helps simulate a gravity pull of x1, y1 toward point x2, y2 with f to determine how strong the pull is
```lua
local fx, fy = Soupy.physics.gravitateToward(self.x, self.y, screenCenterX, screenCenterY, 500)
self.velocityX = self.velocityX + fx
self.velocityY = self.velocityY + fy

self.x = self.x + self.velocityX * dt
self.y = self.y + self.velocityY * dt
```

## License
MIT
