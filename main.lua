local bullets = {}
local bulletImg = nil
local bulletSpeed = 2000
local canShoot = true
local canShootTimerMax = 0.2
local canShootTimer = canShootTimerMax
local minSpeed = 110
local maxSpeed = 310

function love.load(arg)
  player = { x = 200, y = 400, speed = 200, scale = 1, angle = 0, img = nil }
  player.img = love.graphics.newImage('assets/jas.png')
  bulletImg = love.graphics.newImage('assets/bullet.png')
end

function love.update(dt)
  local kb = love.keyboard
  -- game
  if kb.isDown('escape') then
    love.event.push('quit')
  end

  -- player direction throttle
  if kb.isDown('up', 'down') or player.speed then
    if player.y > 0 and player.y < love.graphics.getHeight() - player.img:getHeight() and
      player.x > 0 and player.x < love.graphics.getWidth() - player.img:getWidth()
     then
      player.y = player.y + (-math.cos(player.angle) * player.speed * dt)
      player.x = player.x + (math.sin(player.angle) * player.speed * dt)
    elseif player.y <= 0 then
      player.y = player.y + 1
    elseif player.y >= love.graphics.getHeight() - player.img:getHeight() then
      player.y = player.y - 1
    elseif player.x <= 0 then
      player.x = player.x + 1
    elseif player.x >= love.graphics.getWidth() - player.img:getWidth() then
      player.x = player.x - 1
    end
    -- scale on up and down
    if kb.isDown('up') then
      if player.speed <= maxSpeed then
        player.speed = player.speed + 2
      end
      if player.scale > 1 then
        player.scale = player.scale - (player.speed * dt / 100)
      end
    end
    if kb.isDown('down') then
      if player.speed >= minSpeed then
        player.speed = player.speed - 3
      end
      if player.scale < 1.5 then
        player.scale = player.scale + (player.speed * dt / 100)
      end
    end
  end
  -- decrease speed if no throttle
  if player.speed > minSpeed then
    player.speed = player.speed - 0.2
  end
  -- rotate player left and right
  if kb.isDown('left') then
    player.angle = player.angle - (dt * math.pi / 2) * 1.5 -- 1.5 for more speed
    player.angle = player.angle % (2 * math.pi)
  elseif kb.isDown('right') then
    player.angle = player.angle + (dt * math.pi / 2) * 1.5
    player.angle = player.angle % (2 * math.pi)
  end

  -- bullets
  if kb.isDown('lalt') then
    newBullet = {
      x = player.x,
      y = player.y,
      angle = player.angle,
      img = bulletImg
    }
    table.insert(bullets, newBullet)
    canShoot = false
    canShootTimer = canShootTimerMax
  end
  for i, bullet in ipairs(bullets) do
    bullet.y = bullet.y + (-math.cos(bullet.angle) * bulletSpeed * dt)
    bullet.x = bullet.x + (math.sin(bullet.angle) * bulletSpeed * dt)
    if bullet.y < 0 then
      table.remove(bullets, i)
    end
  end
end

function love.draw()
  -- draw bullets
  for i, bullet in ipairs(bullets) do
    love.graphics.draw(bullet.img, bullet.x, bullet.y)
  end
  -- draw player
  love.graphics.draw(
    player.img,
    player.x, player.y,
    player.angle,
    player.scale, player.scale,
    player.img:getWidth()/2, player.img:getHeight()/2
  )
  love.graphics.print('Velocity: ' .. math.floor(player.speed), 10, 0)
end
