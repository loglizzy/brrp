-- conceito simples, funciona em varios jogos

local w,n = {},{}
local p = game.Players.LocalPlayer

local h = (p.Character or p.CharacterAdded:Wait()):WaitForChild("Humanoid")

for i,T in next, game:GetService("Teams"):GetChildren() do
    for i,v in next, T:GetChildren() do
        if v:IsA("Tool") and not n[v.Name] then
            v.Parent = p.Backpack
            w[v],n[v.Name] = T, true
        end
    end
end

h.Died:wait()
for i,v in next, w do
    i.Parent = v
end
