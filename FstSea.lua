-- 🌊 Mini Redz-Style Autofarm (First Sea)
-- UI pakai OrionLib

local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Orion/main/source"))()
local Window = OrionLib:MakeWindow({Name = "Mini RedzHub First Sea", HidePremium = false, SaveConfig = true, ConfigFolder = "MiniRedz"})

local plr = game.Players.LocalPlayer
local vu = game:GetService("VirtualUser")
local hrp = plr.Character:WaitForChild("HumanoidRootPart")
local TweenService = game:GetService("TweenService")

-- Anti AFK
plr.Idled:Connect(function()
    vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
    wait(1)
    vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
end)

-- Setting
getgenv().Farm = false
getgenv().BringMob = true
getgenv().Weapon = "Melee"
getgenv().Stats = true

-- Fungsi Tween
function TP(pos)
    local tween = TweenService:Create(hrp, TweenInfo.new((hrp.Position - pos.Position).Magnitude/250, Enum.EasingStyle.Linear), {CFrame = pos})
    tween:Play()
    tween.Completed:Wait()
end

-- Fungsi Float
function FloatFarm()
    hrp.Velocity = Vector3.new(0,0,0)
    hrp.CFrame = hrp.CFrame + Vector3.new(0,15,0)
end

-- Fungsi BringMob
function BringMob(mobName)
    for _, v in pairs(workspace.Enemies:GetChildren()) do
        if v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
            if string.find(v.Name, mobName) then
                v.HumanoidRootPart.CFrame = hrp.CFrame * CFrame.new(0,0,-5)
                v.HumanoidRootPart.CanCollide = false
                v.Humanoid.WalkSpeed = 0
                v.Humanoid.JumpPower = 0
            end
        end
    end
end

-- Orion UI Tabs
local Tab = Window:MakeTab({Name = "Main Farm", Icon = "rbxassetid://4483345998", PremiumOnly = false})

Tab:AddToggle({
    Name = "Auto Farm",
    Default = false,
    Callback = function(v) getgenv().Farm = v end
})

Tab:AddToggle({
    Name = "Bring Mob",
    Default = true,
    Callback = function(v) getgenv().BringMob = v end
})

Tab:AddDropdown({
    Name = "Select Weapon",
    Default = "Melee",
    Options = {"Melee", "Sword", "Gun", "Fruit"},
    Callback = function(v) getgenv().Weapon = v end
})

Tab:AddToggle({
    Name = "Auto Stats Melee",
    Default = true,
    Callback = function(v) getgenv().Stats = v end
})

-- Farming Loop
spawn(function()
    while wait() do
        if getgenv().Farm then
            local myLevel = plr.Data.Level.Value
            -- (Cari quest sesuai level → sama kayak script sebelumnya)
            -- Contoh farming Military Soldier (lvl 300)
            if myLevel >= 300 and myLevel < 400 then
                local Quest = "MilitarySoldierQuest"
                local Mob = "Military Soldier"
                local Qpos = CFrame.new(-4805, 21, 4388)
                -- Teleport
                TP(Qpos)
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", Quest, 1)
                repeat wait()
                    FloatFarm()
                    if getgenv().BringMob then BringMob(Mob) end
                    vu:CaptureController()
                    vu:Button1Down(Vector2.new(1280,672))
                until not getgenv().Farm or plr.PlayerGui.Main.Quest.Visible == false
            end
        end
    end
end)

-- Auto Stats
spawn(function()
    while wait(3) do
        if getgenv().Stats then
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AddPoint", "Melee", 3)
        end
    end
end)

OrionLib:Init()
