if shared._ then return end; shared._ = true

local Player = game.Players.LocalPlayer
local Storage = game.ReplicatedStorage
local Teams = game:GetService("Teams")
local Undo,Guns,MCache = {},{},{}

function ChildrenOfTool(gc)
    local total = 0
    for i,v in next, gc do
        if v:IsA("Tool") then
            total = total + 1
        end
    end
    
    return total
end

-- GUI
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/loglizzy/Elerium-lib/main/lib.min.lua"))()
local Window,WRender = Library:AddWindow("Racismo 2.0.1 [BETA]", {
	main_color = Color3.fromRGB(45, 45, 45),
	min_size = Vector2.new(350, 600),
	toggle_key = Enum.KeyCode.RightShift,
	can_resize = true,
})

WRender.ImageColor3 = Color3.fromRGB(55,55,55)

-- UI funcs
function switch(self, data, state)
    local gun,old = self.gun,self.old
    for i,v in next, data do
        Guns[gun][i] = state and v or old[i]
        warn(gun, state and v or old[i])
    end
end

function FoldInto(tab,t,cl)
    local gc = t:GetChildren()
    local folder,render
    
    local len = ChildrenOfTool(gc)
    if len > 0 then
        folder,render = tab:AddFolder(
            ' <b><font color="rgb(180,180,180)">'..len..'</font></b>  '
            ..t.Name
        )
        
        render.Button.RichText = true
        if t:IsA("Team") or cl then
            render.ImageColor3 = cl or t.TeamColor.Color
            render.ImageTransparency = 0.6
            render.Button.TextButton_Roundify_4px.Visible = false
        end
        
        for i,v in next, gc do
            if not v:IsA("Tool") then continue end
            
            if v:FindFirstChild("ACS_Settings") then
                Guns[v] = require(v.ACS_Settings)
                local old = {}
                for i,v in next, Guns[v] do
                    old[i] = v
                end
                
                MCache[v] = {gun=v, old=old, switch=switch}
            end
            
            folder:AddSwitch(v.Name, function(s)
                Undo[v] = s and t
                v.Parent = s and Player.Backpack or t
            end)
        end
    end
    
    return folder,render
end

-- Tools Tab
local Tools = Window:AddTab("Times")
for i,t in next, Teams:GetChildren() do
    FoldInto(Tools, t)
end

Tools:Show()

-- Geral
local Geral = Window:AddTab("Geral")

FoldInto(Geral, Storage)
for i,t in next, Storage:GetChildren() do
    FoldInto(Geral, t)
end

-- ACS mods
local Mods = Window:AddTab("Mods")

local ACS = Mods:AddFolder("ACS")
ACS:AddSwitch("Munição Infinita", function(state)
    for i,v in next, MCache do
        v:switch({
            Ammo = math.huge,
            StoredAmmo = math.huge,
            AmmoInGun = math.huge
        }, state)
    end
end)

ACS:AddSwitch("Sem recuo", function(state)
    for i,v in next, MCache do
        v:switch({
            MaxRecoilPower = 0,
            camRecoil = {
                camRecoilRight={0,0},camRecoilUp={0,0},
                camRecoilLeft={0,0},camRecoilTilt={0,0}
            }
        }, state)
    end
end)

ACS:AddSwitch("Sem dispersão de balas", function(state)
    for i,v in next, MCache do
        v:switch({
            MaxSpread = 0
        }, state)
    end
end)

ACS:AddSwitch("Sem emperragem", function(state)
    for i,v in next, MCache do
        v:switch({
            CanBreak = false
        }, state)
    end
end)

ACS:AddSwitch("Sem gravidade em balas", function(state)
    for i,v in next, MCache do
        v:switch({
            CanBreak = false
        }, state)
    end
end)

ACS:AddSlider("Tiros em rajada", function(num)
    for i,v in next, MCache do
        Guns[v.gun].BurstShot = num
        warn(num)
    end
end,{min = 2, max = 10})

local Modes = ACS:AddFolder("Modos de tiro")
local _modes = {ChangeFiremode = true, Auto=false, Burst=false, Semi=true}

Modes:AddSwitch("Automatico", function(state)
    _modes["Auto"] = state
    for i,v in next, MCache do
        v:switch({
            FireModes = _modes
        }, state)
    end
end)

Modes:AddSwitch("Rajada", function(state)
    _modes["Burst"] = state
    for i,v in next, MCache do
        v:switch({
            FireModes = _modes
        }, state)
    end
end)

Modes:AddSwitch("Semi", function(state)
    _modes["Semi"] = state
    for i,v in next, MCache do
        v:switch({
            FireModes = _modes
        }, state)
    end
end)

-- NoCol mods
local NOC = Mods:AddFolder("NoCol")

-- Backpack Undo
function OnChar(char)
    char:WaitForChild("Humanoid").Died:wait()
    for i,v in next, Undo do
        if v then i.Parent = Player.Backpack end
    end
    
    Player.CharacterAdded:wait()
    for i,v in next, Undo do
        if v then i.Parent = Player.Backpack end
    end
end

Player.CharacterAdded:connect(OnChar)
OnChar(Player.Character or Player.CharacterAdded:wait())
