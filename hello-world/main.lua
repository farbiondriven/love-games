Platform = {}
Player = {}
LEFT = "0"
RIGHT = "1"
FRONT = "2"
BACK = "3"

Gigi_Images = {}

function love.load()
	Platform.img = love.graphics.newImage('pictures/backgrounds/land.jpg')
	Platform.width = love.graphics.getWidth()
	Platform.height = love.graphics.getHeight()
	Platform.x = 0
	Platform.y = Platform.height / 2

	Player.x = love.graphics.getWidth() / 2
	Player.y = love.graphics.getHeight() / 1.7
	Platform.scale_coefficient = 0.9 / (Player.y - 1)
	Player.speed = 200
	Gigi_Images.walking = love.graphics.newImage('pictures/gigi/sinistra1_crop.png')
	Gigi_Images.back_picture = love.graphics.newImage('pictures/gigi/back1.png')
	Player.img = Gigi_Images.walking
	Player.scale = Platform.scale_coefficient * (Player.y - 1) + 0.1
	Player.orientation = FRONT
	Player.ground = Player.y

	Player.y_velocity = 0

	Player.jump_height = -300
	Player.gravity = -400
end

function love.update(dt)
	if love.keyboard.isDown('d') or love.keyboard.isDown('right') then
		Player.img = Gigi_Images.walking
		Player.orientation = RIGHT
		if Player.x < (love.graphics.getWidth() - Player.img:getWidth()) then
			Player.x = Player.x + (Player.speed * dt)
		end
	elseif love.keyboard.isDown('a') or love.keyboard.isDown('left') then
		Player.img = Gigi_Images.walking
		Player.orientation = LEFT
		if Player.x > 0 then
			Player.x = Player.x - (Player.speed * dt)
		end
	elseif love.keyboard.isDown('w') or love.keyboard.isDown('up') then
		Player.orientation = BACK
		Player.img = Gigi_Images.back_picture
		if Player.y > 0 then
			Player.y = Player.y - (Player.speed * dt)
			if Player.y < 0 then
				Player.y = 0
			end
		end
	elseif love.keyboard.isDown('s') or love.keyboard.isDown('down') then
		Player.orientation = FRONT
		Player.img = Gigi_Images.back_picture
		if Player.y >= 0 then
			Player.y = Player.y + (Player.speed * dt)
		end
	end

	if love.keyboard.isDown('space') then
		if Player.y_velocity == 0 then
			Player.y_velocity = Player.jump_height
		end
	end

	if Player.y_velocity ~= 0 then
		Player.y = Player.y + Player.y_velocity * dt
		Player.y_velocity = Player.y_velocity - Player.gravity * dt
	end

	if Player.y > Player.ground then
		Player.y_velocity = 0
		Player.y = Player.ground
	end
	Player.scale = Platform.scale_coefficient * (Player.y - 1) + 0.1
end

function love.draw()
	-- love.graphics.setColor(1, 1, 1)
	-- love.graphics.rectangle('fill', Platform.x, Platform.y, Platform.width, Platform.height)
	love.graphics.draw(Platform.img)
	local orientation_value = 1
	if Player.orientation == RIGHT then
		orientation_value = -1
	end
	love.graphics.draw(Player.img, Player.x, Player.y, 0, Player.scale * orientation_value, Player.scale, 0, 32)
	love.graphics.print(string.format("Position is %d-%d and scale %f - coefficient %f",
		Player.x, Player.y, Player.scale, Platform.height), 0, 0)
end
