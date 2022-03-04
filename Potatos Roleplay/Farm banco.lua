-- pode ta um pouco bugado
local char = game.Players.LocalPlayer.Character
local back = game.Players.LocalPlayer.Backpack
local root = char.HumanoidRootPart
local prompt = "ProximityPrompt"

function firep(v)
    fireproximityprompt(v[prompt])
end

local init = workspace.Roubo
local goal = workspace.Entrega

repeat
    root.CFrame = init.CFrame
    task.wait()
    
    firep(init)
until back:FindFirstChild("Saco de Farina")
local bag = back["Saco de Farina"]

do
    root.CFrame = goal.CFrame*CFrame.new(0,0,5)
    wait(.2)
    
    bag.Parent = char
    for i = 1,5 do 
        firep(goal);wait(.1)
    end
end
