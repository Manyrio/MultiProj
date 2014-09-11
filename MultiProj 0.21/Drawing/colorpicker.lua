

local UIParent = require "GUI"

local m = CreateFrame("Frame")
m:SetFrameStrata("TOOLTIP")
m:SetSize(300,300)

m:Hide()


 m.colorwheel = love.graphics.newPixelEffect [[

    extern vec2 mstart;

    extern float size;

    vec3 HSV(float h, float s, float v)
    {
    	if (s <= 0 ) { return vec3 (0.0); }
        h = h * 6;
    	float c = v*s;
    	float x = (1-abs((mod(h,2)-1)))*c;
    	float m = v-c;
    	float r = 0.0;
        float g = 0.0;
        float b = 0.0;

    	if (h < 1) { r = c; g = x;b = 0.0;}
	    else if (h < 2) { r = x; g = c; b = 0.0; }
	    else if (h < 3) { r = 0.0; g = c; b = x; }
	    else if (h < 4) { r = 0.0; g = x; b = c; }
	    else if (h < 5) { r = x; g = 0.0; b = c; }
	    else  { r = c; g = 0.0; b = x; }

    	return vec3(r+m,g+m,b+m);
    }


    vec4 effect(vec4 global_color, Image texture, vec2 tc, vec2 pc)
        {
        float H = (mod(degrees(atan(pc.y-mstart.y,pc.x-mstart.x)), 360))/360;
        float C = (sqrt(pow(pc.y-mstart.y,2) + pow(pc.x-mstart.x,2)))/(size/4);
        float L = 1.0;
        if (C > 1.0) { L = 1.0 - (C - 1.0)*2; }
        if (C < 1.6) { return vec4(HSV(H,C,L), 1.0);}
        else return vec4(0.0);
    }
]]

m.saturation =  love.graphics.newPixelEffect [[

extern vec3 color;
extern vec2 mouse;
extern vec2 mstart;
extern float size;

 vec4 effect(vec4 global_color, Image texture, vec2 tc, vec2 pc)
        {
        float H = (mod(degrees(atan(pc.y-mstart.y,pc.x-mstart.x)), 360))/360;
        float C = (sqrt(pow(pc.y-mstart.y,2) + pow(pc.x-mstart.x,2)))/(size/4);
        if (C < 1.0) {
        return vec4(color.r-H, color.g-H, color.b-H,0.0+C);
        }
        else if (C < 1.2) {
            return vec4(color.r-H, color.g-H, color.b-H,1.0);
        }
        else if (C < 1.4) {
            float H = (mod(degrees(atan(mouse.y-mstart.y,mouse.x-mstart.x)), 360))/360;
            float C = (sqrt(pow(mouse.y-mstart.y,2) + pow(mouse.x-mstart.x,2)))/(size/4);
            return vec4(color.r-H, color.g-H, color.b-H,0.0+C);
        }
    else
        return vec4(0.0);
    }


]]


--===================================================================
--===================================================================
--===================================================================
--===================================================================


m.size = 0
m.sizemax = 400
m.showspeed = 3000
m.spinspeed = 300
m.mx = 0
m.my = 0
m.r = 0
m.g = 0
m.b = 0
m.angle = 0


local mx,my

local scrnheight = love.graphics.getHeight()
local scrnwidth = love.graphics.getWidth()

local floor = math.floor


m.colorwheel:send("size", m.size)



m:SetScript("OnUpdate", function(self, dt)
	mx,my = love.mouse.getPosition()

    if self.state == "cw" then
        self.size = math.min(self.size+dt*self.showspeed, self.sizemax)
        self.colorwheel:send("size", self.size)

        local H = (math.deg(math.atan2((scrnheight-my)-(scrnheight-self.my),mx-self.mx)) % 360)/360*255
        local C = math.sqrt(((scrnheight-my)-(scrnheight-self.my))^2 + (mx-self.mx)^2)/(self.size/4)*255
        local L = 255
        
        if C > 255 then
            L = 255 - (C - 255)*2
        end

        self.r,self.g,self.b = HSV(H,math.min(C,255),math.min(math.max(L,0),255))
        self.a = 255
        self.rr, self.rg, self.rb = self.r, self.g, self.b
    elseif self.state == "v" then
        self.angle = math.min(self.angle+dt*self.spinspeed, 360)
        self.saturation:send("mouse", {mx, scrnheight-my})
 
    end
end)

m:SetScript("OnShow", function(self)
    self.sizemax = self:GetWidth()
    self.size = self:GetWidth()
    if not self.state then
        self.state = "cw"
        self.colorwheel:send("mstart", {mx,600-my})
        self.mx = mx
        self.my = my
    elseif self.state == "v" then

    end
end)



m:SetScript("OnMouseUp", function(self, x, y, button)
    if self.state == "cw" then
        self.selectedcolor = {self.r, self.g, self.b}
        self.state = "v"
        self.saturation:send("color", {self.r/255, self.g/255, self.b/255})
        self.saturation:send("mstart", {self.mx, scrnheight-self.my})
        self.saturation:send("size", self.size)
       
    elseif self.state == "v" then
        local H = (math.deg(math.atan2((scrnheight-my)-(scrnheight-self.my),mx-self.mx)) % 360)/360*255
        local C = math.sqrt(((scrnheight-my)-(scrnheight-self.my))^2 + (mx-self.mx)^2)/(self.size/4)*255
        self.r,self.g,self.b,self.a = math.max(self.rr-H,0), math.max(self.rg-H,0), math.max(self.rb-H,0), math.min(math.max(C,0),255)
        self.state = nil
         self.size = 0
         self:Hide()
    end
end)

function m:GetColor()
    return self.r,self.g,self.b,self.a or 255
end

function HSV(h, s, v)
    if s <= 0 then return v,v,v end
    h, s, v = h/256*6, s/255, v/255
    local c = v*s
    local x = (1-math.abs((h%2)-1))*c
    local m,r,g,b = (v-c), 0,0,0
    if h < 1     then r,g,b = c,x,0
    elseif h < 2 then r,g,b = x,c,0
    elseif h < 3 then r,g,b = 0,c,x
    elseif h < 4 then r,g,b = 0,x,c
    elseif h < 5 then r,g,b = x,0,c
    else              r,g,b = c,0,x
    end return (r+m)*255,(g+m)*255,(b+m)*255
end


m:SetScript("OnDraw", function (self)
    if self.state == "cw" then
        love.graphics.setPixelEffect(self.colorwheel)
        love.graphics.rectangle("fill", 0, 0, scrnwidth, scrnheight)
        love.graphics.setPixelEffect()
        love.graphics.setColor(self.r,self.g,self.b,255)
        self.rt = math.sqrt((mx-self.mx)^2 + (my-self.my)^2)
        love.graphics.circle("fill",self.mx,self.my, math.min(self.rt,self.size/2),self.rt*8)
        love.graphics.setColor(255,255,255,255)
        love.graphics.print("R: "..floor(self.r).." \nG: "..floor(self.g).." \nB: "..floor(self.b), self.mx -10,self.my-20)
    elseif self.state == "v" then
        love.graphics.setPixelEffect(self.saturation)
        love.graphics.rectangle("fill", 0, 0, scrnwidth, scrnheight)
        love.graphics.setPixelEffect()
         love.graphics.setColor(255,255,255,255)
        love.graphics.print("R: "..floor(self.r).." \nG: "..floor(self.g).." \nB: "..floor(self.b), self.mx -10,self.my-20)
    end
end)



return m