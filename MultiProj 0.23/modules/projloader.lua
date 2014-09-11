

local tinsert = table.insert


local max = math.max

local old = {} 

old.graphics = love.graphics

old.mouse = love.mouse
old.timer = love.timer
old.framebuffer = love.graphics.newFramebuffer or love.graphics.newUIParent
old.image = love.image
old.filesystem = love.filesystem


function env_require(module, env) -- replacement require that loads the file in the correct environment
  local loaders = package.loaders
  local errors  = {}
  local load_fn
  for _, loader in ipairs(loaders) do
    local fn = loader(module)
    if type(fn) == 'function' then
      load_fn = fn
      break
    elseif type(fn) == 'string' then
      errors[#errors + 1] = fn
    end
  end

  if not load_fn then
    error(table.concat(errors, '\n'))
  end
  setfenv(load_fn, env)
  return load_fn(module)
end

--=======================================================


local function ParseConf(proj, path) --pull some settings from the conf to use in the project
    if not love.filesystem.exists(path.."conf.lua") then
        return 
    end

    local msg = love.filesystem.read(path.."conf.lua")

    proj.width = msg:match("screen.width -= -(%d+)") or proj.width
    proj.height = msg:match("screen.height -= -(%d+)") or proj.height
    proj.title = msg:match([=[title -= -['"](.-)['"]]=]) or proj.title

end

--=====================================================
--								PROJECT	
--=====================================================

local Environment = {}

Environment.__index = _G
setmetatable(Environment,Environment)

 Environment.love = {}
    
	Environment.love.mouse = {}

	Environment.love.graphics = {}
	
	Environment.love.image = {}

	Environment.love.timer = old.timer

	setmetatable(Environment.love.graphics, Environment.love.graphics)
	Environment.love.graphics.__index = old.graphics   

	 setmetatable(Environment.love.mouse, Environment.love.mouse)
	Environment.love.mouse.__index = old.mouse 
	
	 setmetatable(Environment.love.image, Environment.love.image)
	Environment.love.image.__index = old.image

function Environment:Create()
	local temp = {}
	
	temp.__index = Environment
	setmetatable(temp,temp)
	
	return temp
end


local f = RequireFrame()

Player = {} --basic methods common to all objects

Player.__index = f
setmetatable(Player,Player)


function Player:Create(name, code, bool)

	local dir = "Projects/"..name.."/"..name.."/"
	
	local new = CreateFrame("Frame") --new Player
		
		new.__index = Player
		setmetatable(new, new)
    new.env = Environment:Create() --the environment of the Player

		new:SetBackdrop({
		edgeFile = "images/project-border.png",
		edgeSize = 16,
		insets = {left = 4,right = 4, top = 4, bottom = 4}

	})
	
	new:SetSize(400,300)
	new:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 30, 30)
	
	new.path = dir
    
  new.title = path
	
	new.bg = new:CreateTexture()
	new.bg:SetTexture(100,100,100,255)
	new.bg:SetPoint("TOPLEFT", new, "TOPLEFT", 10,10)
	new.bg:SetPoint("BOTTOMRIGHT", new, "BOTTOMRIGHT", -10,-10)
	
	new.canv = CreateFrame("Frame", nil, new)
	new.canv:SetPoint("TOPLEFT", new, "TOPLEFT", 10,30)
	new.canv:SetPoint("BOTTOMRIGHT", new, "BOTTOMRIGHT", -10, -10)
	new.canv.bg = new.canv:CreateTexture()
	new.canv.bg:SetTexture(0,0,0,255)
	new.canv.bg:SetAllPoints(new.canv)

	new.play = CreateFrame("Button", nil, new)
	new.play:SetPushedTexture("images/playdown.png")
	new.play:SetNormalTexture("images/play.png")
	new.play:SetSize(16,16)
	new.play:SetPoint("TOPLEFT", new, "TOPLEFT", 15, 10)
	new.play:SetScript("OnMouseDown", function() new.paused = not new.paused end)
	
	new.width = 800 --this is the width the program thinks it is
	new.height = 600
	
	new.scalex = 400/new.width
	new.scaley = 300/new.height
	
	new:EnableKeyboard(true)
	
	
	new:SetScript("OnMouseDown", function(self, x, y, button) --drag or size
		new:SetFocus(true)
		if y-self:GetTop() < 30 then
			self:StartMoving()
		elseif y - self:GetBottom() > - 10 then
			self:StartSizing("BOTTOM")
		elseif x - self:GetLeft() < 10 then
			self:StartSizing("LEFT")
		elseif x - self:GetRight() > -10  then
			self:StartSizing("RIGHT")
		end
	
	end)
	
	new:SetScript("OnMouseUp", function(self)
		self:StopMovingOrSizing()
	end)
	
	new:SetScript("OnClick", function(self, x, y, button) -- enable fullscreen
		if self.clicktime and not self.fullscreen then
			if self.clicktime -love.timer.getTime() > -1 then
				self:ToggleFullScreen()
			end
		end	
		self.clicktime = love.timer.getTime()
	end)
	
	new:SetScript("OnEscapePressed", function(self) --close fullscreen
		if self.fullscreen then
			print("esc")
			self:ToggleFullScreen()
		end	
	end)
	
	
		

    ParseConf(new, dir) -- check the conf.lua for settings


    --setmetatable(new.env, {__index = _G})
    setfenv(1, new.env)

    
   
		
    function new.env.love.mouse.getPosition()
        local x,y = old.mouse.getPosition()
        
        x = (x - new.canv:GetLeft()*UIParent.scale-UIParent:GetLeft()*UIParent.scale)/(new.scalex*UIParent.scale)
        y = (y - new.canv:GetTop()*UIParent.scale-UIParent:GetTop()*UIParent.scale)/(new.scaley*UIParent.scale)

        x = math.max(x, 0)
        x = math.min(x, new.canv:GetWidth()/(new.scalex*UIParent.scale))

        y = math.max(y, 0)
        y = math.min(y, new.canv:GetHeight()/(new.scaley*UIParent.scale))
        return x,y
    end

		function new.env.love.mouse.getX()
			return (old.mouse.getX() - new.canv:GetLeft()*UIParent.scale-UIParent:GetLeft()*UIParent.scale)/(new.scalex*UIParent.scale)
		end
		
		function new.env.love.mouse.getY()
			return (old.mouse.getY() - new.canv:GetTop()*UIParent.scale-UIParent:GetTop()*UIParent.scale)/(new.scaley*UIParent.scale)
		end		
		
    local function offx(x)
        x = x and (x*new.scalex*UIParent.scale)+new.canv:GetLeft()*UIParent.scale+UIParent:GetLeft()*UIParent.scale
            or UIParent:GetLeft()*UIParent.scale + new.canv:GetLeft()*UIParent.scale
        return x
    end

    local function offy(y)
        y = y and (y*new.scaley*UIParent.scale)+new.canv:GetTop()*UIParent.scale+UIParent:GetTop()*UIParent.scale 
            or UIParent:GetTop()*UIParent.scale + new.canv:GetTop()*UIParent.scale
        return y
    end

    local function scx(x)
        return x and x*new.scalex*UIParent.scale or new.scalex*UIParent.scale
    end

    local function scy(y)
        return y and y*new.scaley*UIParent.scale or new.scaley*UIParent.scale
    end


    --blank out a few functions so they cant be called
    --================================================
    
    function new.env.love.graphics.clear() end
    function new.env.love.graphics.push() end
    function new.env.love.graphics.pop() end
    function new.env.love.graphics.rotate() end
    function new.env.love.graphics.scale() end
    function new.env.love.graphics.toggleFullscreen() end
 

    -- redefine other functions 
    --================================================
	
		function new.env.love.graphics.toggleFullscreen()
			--change the current fullscreen thing to a function then call it
			new:ToggleFullScreen()
		end
	
		function new.env.love.graphics.translate(x,y)
			old.graphics.translate(x*new.scalex,y*new.scaley)
		end
		
		
		function new.env.love.graphics.setScissor(x,y,width,height)
			if x then
				
			else
			
			end
		end
		
		function new.env.love.mouse.isDown(button)
			if new.focus then
				return old.mouse.isDown(button)
			end
		end
		
		
    function new.env.love.graphics.drawq(image, quad, x, y, r ,sx, sy, ox, oy)
        x = offx(x)
        y = offy(y)

        sx = scx(sx)
        sy = scy(sy)
        ox = ox and ox*new.scalex or ox --this is wrong
        oy = oy and oy*new.scaley or oy

        old.graphics.drawq(image,quad,x,y,r,sx,sy,ox,oy)
    end

    function new.env.love.graphics.getBackgroundColor()
        return unpack(new.bcolor or {0,0,0})
    end

    function new.env.love.graphics.getCaption()
        return new.caption
    end

    function new.env.love.graphics.getHeight()
        return new.canv:GetHeight()*new.scaley
    end

    function new.env.love.graphics.getWidth()
        return new.canv:GetWidth()*new.scalex
    end

    function new.env.love.graphics.line(...)
        local t = {...}
        for i = 1, #t,2 do
            t[i] = offx(t[i])
            t[i+1] = offy(t[i+1])
        end

        old.graphics.line(unpack(t))
    end

    function new.env.love.graphics.point(x,y)
        x = offx(x)
        y = offy(y)
        old.graphics.point(x,y)
    end

    function new.env.love.graphics.polygon(mode, ...)
			local t = {}
				for i = 1, select("#", ...) do
					t[#t+1] = select(i,...)
				end
        for i = 1, #t, 2 do
            t[i] = offx(t[i])
            t[i+1] = offy(t[i+1])
        end
        old.graphics.polygon(mode, unpack(t))
    end


    function new.env.love.graphics.quad(mode,ulx,uly,urx,ury,blx,bly,brx,bry)
        ulx = offx(ulx)
        uly = offy(uly)
        urx = offx(ulx)
        ury = offy(uly)
        blx = offx(ulx)
        bly = offy(uly)
        brx = offx(ulx)
        bry = offy(uly)



        old.graphics.quad(mode, ulx,uly,urx,ury,blx,bly,brx,bry)
    end

    function new.env.love.graphics.setRenderTarget(targ)
        new.fb = targ
        old.graphics.rendertarget(targ)
    end

    function new.env.love.graphics.print(text,x,y,r,sx,sy)
        x = offx(x)
        y = offy(y)

        sx = scx(sx)
        sy = scy(sy)
        old.graphics.print(text,x,y,r,sx,sy)
    end

    function new.env.love.graphics.printf(text, x, y, limit, align)
        x = offx(x)
        y = offy(f)

        limit = limit*new.scalex
        old.graphics.printf(text, x, y, limit,align)                
    end

    function love.graphics.draw(drawable, x,y,r,sx,sy,ox,oy)
        x = offx(x)
        y = offy(y)

        sx = scx(sx)
        sy = scy(sy)
        ox = ox and ox*new.scalex*UIParent.scale or ox
        oy = oy and oy*new.scaley*UIParent.scale or oy

        old.graphics.draw(drawable, x, y, r, sx, sy, ox, oy)
    end

    function love.graphics.rectangle(mode, x, y, width, height)
        if not new.fb then
            x = offx(x)
            y = offy(y)
            width = width*new.scalex*UIParent.scale
            height = height *new.scaley*UIParent.scale
        end
        old.graphics.rectangle(mode, x, y, width, height)
    end

    function love.graphics.newFramebuffer(...)
        return old.graphics.newFramebuffer(...)
    end

    function love.graphics.newUIParent(...)
        return old.graphics.framebuffer(...)
    end
    
    function love.graphics.triangle(mode, x1,y1,x2,y2,x3,y3)
        x1 = offx(x1)
        y1 = offy(y1)
        x2 = offx(x2)
        y2 = offy(y2)
        x3 = offx(x3)
        y3 = offy(y3)
        old.graphics.triangle(mode,x1,y1,x2,y2,x3,y3)
    end

    function love.graphics.circle(mode,x,y,radius,segments)
        x = offx(x)
        y = offy(y)
        radius = radius*((new.scalex+new.scaley)/2)
        old.graphics.circle(mode, x, y, radius, segments)
    end

    function love.graphics.setColor(...)
        old.graphics.setColor(...)
    end

    function require(path)
        env_require(dir, new.env)
    end

    function love.graphics.newImage(path)
        return old.graphics.newImage(new.path..path)
    end

    function love.graphics.newFont(path, size)
        return old.graphics.newFont(new.path..path, size)
    end

    function love.graphics.setBackgroundColor(r,g,b)
        --need to check they are all numbers
        new.canv.bg:SetTexture(r,g,b)
    end
		
		function love.graphics.setMode(width, height, fullscreen, vsync, fsaa)
			new.width = width
			new.height = height
			if fullscreen then
				new.__SCRIPTS.OnClick(new)
				new.__SCRIPTS.OnClick(new)
			end
			--check this out and work out vsync
		
		end
		
		
		--=================== handling events ==============================
		--=================================================
		--=================================================
			
		new:SetScript("OnKeyDown", function(self, key, uni)
			if new.focus then
				if new.env.keypressed then
					new.env.keypressed(key,uni)
				end
				if key == "print" then
					local toggled
					if not new.fullscreen then
						new:ToggleFullScreen()
						toggled = true
					end
					new.canv:Draw(new.canv)
					local img = old.graphics.newScreenshot()
					
					local i = 1
					---[[
					if not old.filesystem.exists("projects/"..name) then
						old.filesystem.mkdir("projects/"..name)
					end
					if not old.filesystem.exists("projects/"..name.."/screenshots") then
						old.filesystem.mkdir("projects/"..name.."/screenshots")
					end
					--]]
					while old.filesystem.exists("projects/"..name.."/screenshots/screenshot"..i..".tga") do
						i = i+1
					end
					img:encode("projects/"..name.."/screenshots/screenshot"..i..".tga", "tga")
					if toggled and new.fullscreen  then
						new:ToggleFullScreen()
					end
					
				end
			end
		end)
		
		new.canv:SetScript("OnMouseDown", function(self,x,y,button)
			new:SetFocus(true)
			if new.env.mousepressed then
				new.env.mousepressed((x-new:GetLeft())/new.scalex*UIParent.scale,(y-new:GetTop())/new.scaley*UIParent.scale)
			end
		end)

		new.canv:SetScript("OnClick", function(self,x,y,button)
			if new.env.mousereleased then
				new.env.mousereleased((x-new:GetLeft())/new.scalex*UIParent.scale,(y-new:GetTop())/new.scaley*UIParent.scale)
			end
		end)
		
		new.canv:SetScript("OnUpdate", function(self, dt)
			if not new.paused and new.env.love.update then
				new.env.love.update(dt)
			end
		end)
		
		new.canv:SetScript("OnDraw", function(self)
			old.graphics.setScissor(self:GetLeft(), self:GetTop(), self:GetWidth(), self:GetHeight())
			new.scalex = self:GetWidth()/new.width
			new.scaley = self:GetHeight()/new.height
			if new.color then
				old.graphics.setColor(new.color)
			end
			if new.env.love.draw then
				new.env.love.draw()
			end
			if new.err then
				love.graphics.print(new.err, 10, 10)
			end
			old.graphics.setScissor()
			new.color = {old.graphics.getColor()}
			love.graphics.setColor(255,255,255,255)
		end)
		
		--=================================================
		--=================================================
		--=================================================
		
		
		new:SetScript("OnEnterPressed", function(self)
			
		end)
		
		if bool then
			--local ok, f = xpcall(loadstring(code), debug.traceback)
			--if ok then
				local f,err = loadstring(code)
				if not err then
					setfenv(f, new.env)
					f()
				else
					new.err = err --err:match("[.-](.+)")
				end
			--else
				--print error
			--end
		else
			new:load()
		end
		
		if new.env.love.load then
			new.env.love.load()
		end
		
		new:SetFocus(true)
    
    return new
	
	
end


function Player:ToggleFullScreen()
	if self.fullscreen then
		self.fullscreen = false
		self:ClearAllPoints()
		self:SetPoint("TOPLEFT", UIParent, "TOPLEFT", self.mincoords[1], self.mincoords[2])
		self:SetPoint("BOTTOMRIGHT", UIParent, "TOPLEFT", self.mincoords[3], self.mincoords[4])
	else
			self.mincoords = {self:GetLeft(), self:GetTop(), self:GetRight(), self:GetBottom()}
			self:ClearAllPoints()
			self:SetPoint("TOPLEFT", UIParent, "TOPLEFT", -10, -30)
			self:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", 10, 10)
			self.fullscreen = true
	end
end

function Player:SetFocus(var)
	for i = 1, #Projects do
		if Projects[i].Player == self then
			Projects[i].focus = var
			Projects[i].paused = not var
		else
			if Settings.AutoPause then
				Projects[i].paused = true
			end
			Projects[i].focus = nil
		end
	end
end

function Player:load()
	env_require(self.path.."main", self.env) 
end

local Project = {}

function Project:Create(name,user)
user = user or CURRENT_USER
	if not name then
		name = "proj"..#Projects+1
	end
	
	local p = {}
	p.name = name
	p.editor = LuaEdit:Create(name.."Editor")
	print(name.."Editor")
	p.editor.name = name
	--p.Player = Player:Create(name.."Player","",true)

	p.creator = user.name or CURRENT_USER
	p.created = os.date("%d:%m:%y")
	
	user.selectedline = 0
	user.linepos = 0
	user.selectedproject = name
	tinsert(Projects,p)
end



return Project










