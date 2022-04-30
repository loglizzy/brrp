if shared._ then return end; shared._ = true

local Player = game.Players.LocalPlayer
local Teams = game:GetService("Teams")
local Undo = {}

-- GUI
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/loglizzy/Elerium-lib/main/lib.min.lua"))()
local Window,WRender = Library:AddWindow("Racismo 2.0.1 [BETA]", {
	main_color = Color3.fromRGB(45, 45, 45),
	min_size = Vector2.new(350, 600),
	toggle_key = Enum.KeyCode.RightShift,
	can_resize = true,
})

WRender.ImageColor3 = Color3.fromRGB(55,55,55)

-- Tools Tab 
local Tools = Window:AddTab("Times")

Tools:AddLabel("Times")
for i,t in next, Teams:GetChildren() do
    local gc = t:GetChildren()
    local folder,render
    
    if t:FindFirstChildOfClass("Tool") then
        local cl = t.TeamColor.Color
        folder,render = Tools:AddFolder(
            ' <b><font color="rgb(180,180,180)">'..#gc..'</font></b>  '
            ..t.Name
        )
        
        render.Button.RichText = true
        render.ImageColor3 = cl
        render.ImageTransparency = 0.6
        render.Button.TextButton_Roundify_4px.Visible = false
    end
    
    for i,v in next, gc do
        if not v:IsA("Tool") then continue end
        folder:AddSwitch(v.Name, function(s)
            Undo[v] = s and t
            v.Parent = (s and Player.Backpack) or t
        end)
    end
end

Tools:Show()

-- Geral
local Geral = Window:AddTab("Geral")
for i,t in next, game.ReplicatedStorage:GetChildren() do
    local gc = t:GetChildren()
    local folder,render
    
    local total = 0
    for i,v in next, gc do
        if v:IsA("Tool") then
            total = total + 1
        end
    end
    
    if t:FindFirstChildOfClass("Tool")  then
        folder,render = Geral:AddFolder(
            ' <b><font color="rgb(180,180,180)">'..total..'</font></b>  '
            ..t.Name
        )
        
        render.Button.RichText = true
        render.ImageTransparency = 0.6
    end
    
    for i,v in next, gc do
        if not v:IsA("Tool") then continue end
        
        folder:AddSwitch(v.Name, function(s)
            Undo[v] = s and t
            v.Parent = (s and Player.Backpack) or t
        end)
    end
end

-- Backpack Undo
function OnChar(char)
    char:WaitForChild("Humanoid").Died:wait()
    for i,v in next, Undo do
        i.Parent = v
    end
    
    Player.CharacterAdded:wait()
    for i,v in next, Undo do
        i.Parent = Player.Backpack
    end
end

Player.CharacterAdded:connect(OnChar)
OnChar(Player.Character or Player.CharacterAdded:wait())
