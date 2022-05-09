-- Script experimental, feito para testar metodos de burlar diversas protecoes do ACS

-- Fiz esse loop no ReplicatedStorage pra caso mudem o folder do ACS  
local rs = game.ReplicatedStorage
local res = {
    "Atirar", "Drag", "Equip", "NVG", "Refil", "SVFlash",
    "Squad", "Stance", "Whizz", "HitEffect", "HeadRot"
}

function resCount(tbl)
    local amt = 0
    for i,v in next, tbl do
        if table.find(res,v.Name) then amt = amt + 1 end
    end
    
    return amt
end

function loop(this)
    for i,v in next, this do
        if resCount(v:GetChildren()) >= 5 then
            return v
        else 
            local fl = loop(v:GetChildren())
            if fl then return fl end
        end
    end
end

local evt = loop(rs:GetChildren())

-- Setting
local plr = game.Players.LocalPlayer
local char = plr.Character
local id = evt.TigreID:InvokeServer(plr.UserId).."-"..plr.UserId

local mod = {
	DamageMod 		= 1000
	,minDamageMod 	= 1
}  

local pawn,gun
if char:FindFirstChildOfClass("Tool") then
    pawn,gun = plr, gun
end

while not gun do
    for i,v in next, game.Players:GetPlayers() do
        local tool = v.Character and v.Character:FindFirstChildOfClass("Tool")
        if tool and tool:FindFirstChild("ACS_Animations") then
            pawn,gun = v,tool; break
        end
    end; task.wait()
end

-- Main
local data = require(gun:GetChildren()[1])
evt.Equip:FireServer(gun, 1, data, mod)
wait(1)

for i,v in next, game.Players:GetPlayers() do
    local hum = v.Character and v.Character:FindFirstChild("Humanoid")
    if not hum or hum.Health <= 0 then continue end
    
    task.spawn(evt.TigreDG.InvokeServer,evt.TigreDG,
        gun, hum, 1, 1, data, mod, nil, nil, id)
end

wait(4)
plr:Kick("Saindo para evitar banimentos, espere antes de entrar denovo")
