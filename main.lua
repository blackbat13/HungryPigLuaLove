function love.load()
    math.randomseed(os.time())
    Const = {width = 800, height = 800, margin = 50, framerate = 60}

    Pig = {
        x = Const.width / 2,
        y = Const.height / 2,
        vx = 0,
        vy = 0,
        v = 3,
        points = 0,
        dead = false,
        bot = false,
        images = {
            left = love.graphics.newImage("images/pig_left.png"),
            right = love.graphics.newImage("images/pig_right.png"),
            up = love.graphics.newImage("images/pig_up.png"),
            down = love.graphics.newImage("images/pig_down.png"),
            dead = love.graphics.newImage("images/pig_dead.png")
        },
        sound = love.audio.newSource("sounds/pig.wav", "static")
    }

    Pig.drawable = Pig.images.down

    Beet = {
        x = 200,
        y = 200,
        drawable = love.graphics.newImage("images/beetroot.png")
    }

    Background = love.graphics.newImage("images/bg.png")

    Fonts = {
        points = love.graphics.newFont("fonts/kenney_bold.ttf", 60),
        gameover = love.graphics.newFont("fonts/kenney_bold.ttf", 70),
        tryagain = love.graphics.newFont("fonts/kenney_bold.ttf", 30)
    }
end

function love.draw()
    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(Background)
    love.graphics.draw(Beet.drawable, Beet.x, Beet.y, 0, 1, 1, Beet.drawable.getWidth(Beet.drawable) / 2, Beet.drawable.getHeight(Beet.drawable) / 2)
    love.graphics.draw(Pig.drawable, Pig.x, Pig.y, 0, 1, 1, Pig.drawable.getWidth(Pig.drawable) / 2, Pig.drawable.getHeight(Pig.drawable) / 2)
    love.graphics.setColor(love.math.colorFromBytes(253, 238, 0))
    DrawCenteredText(Const.width / 2, 50, Pig.points, Fonts.points)
    if Pig.dead then
        love.graphics.setColor(love.math.colorFromBytes(227, 0, 34))
        DrawCenteredText(Const.width / 2, Const.height / 2, "GAME OVER", Fonts.gameover)
        DrawCenteredText(Const.width / 2, 2 * Const.height / 3, "Press SPACE to try again", Fonts.tryagain)
    end
end

function DrawCenteredText(x, y, text, font)
	local textWidth  = font:getWidth(text)
	local textHeight = font:getHeight()
	love.graphics.print(text, font, x, y, 0, 1, 1, textWidth/2, textHeight/2)
end

function love.update(dt)
    if Pig.dead then
        return
    end

    Pig.x = Pig.x + Pig.vx * dt * Const.framerate
    Pig.y = Pig.y + Pig.vy * dt * Const.framerate

    if Collides(Pig, Beet) then
        Beet.x = math.random(Const.margin, Const.width - Const.margin)
        Beet.y = math.random(Const.margin, Const.height - Const.margin)
        Pig.v = Pig.v + 0.8
        Pig.points = Pig.points + 1

    end

    if Pig.x < 0 or Pig.x > Const.width or Pig.y < 0 or Pig.y > Const.height then
        Pig.dead = true
        Pig.x = Const.width / 2
        Pig.y = Const.height / 3
        Pig.drawable = Pig.images.dead
    end

    if Pig.bot then
        Bot()
    end
end

function love.keypressed(key, scancode, isrepeat)
    if Pig.dead then
        if key == "space" then
            Restart()
        end
        
        return
    end

    if key == "left" then
        Pig.vx = -Pig.v
        Pig.vy = 0
        Pig.drawable = Pig.images.left
    end

    if key == "right" then
        Pig.vx = Pig.v
        Pig.vy = 0
        Pig.drawable = Pig.images.right
    end

    if key == "up" then
        Pig.vx = 0
        Pig.vy = -Pig.v
        Pig.drawable = Pig.images.up
    end

    if key == "down" then
        Pig.vx = 0
        Pig.vy = Pig.v
        Pig.drawable = Pig.images.down
    end

    if key == "b" then
        Pig.bot = not Pig.bot
    end
end

function Restart()
    Pig.drawable = Pig.images.down
    Pig.x = Const.width / 2
    Pig.y = Const.height / 2
    Pig.vx = 0
    Pig.vy = 0
    Pig.v = 3
    Pig.points = 0
    Pig.dead = false
    Pig.bot = false
end

function Collides(actor1, actor2)
    return actor1.x + actor1.drawable.getWidth(actor1.drawable) >= actor2.x and
            actor1.x <= actor2.x + actor2.drawable.getWidth(actor2.drawable) and
            actor1.y + actor1.drawable.getHeight(actor1.drawable) >= actor2.y and
            actor1.y <= actor2.y + actor2.drawable.getHeight(actor2.drawable)
end

function Bot()
    if Pig.x - Beet.x >= Pig.v then
        love.keypressed("left")
    elseif Beet.x - Pig.x >= Pig.v then
        love.keypressed("right")
    elseif Pig.y - Beet.y >= Pig.v then
        love.keypressed("up")
    elseif Beet.y - Pig.y >= Pig.v then
        love.keypressed("down")
    end
end