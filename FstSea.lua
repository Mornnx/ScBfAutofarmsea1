-- 🌊 Blox Fruits Autofarm (First Sea Only)
-- Auto Melee + Auto Stats Melee + BringMob + FloatFarm

repeat wait() until game:IsLoaded()
local vu = game:GetService("VirtualUser")
game:GetService("Players").LocalPlayer.Idled:connect(function()
   vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
   wait(1)
   vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
end)

local plr = game.Players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")

getgenv().AutoFarm = true
getgenv().AutoStats = true

-- 📌 Daftar Quest First Sea (tanpa Boss)
local QuestList = {
    [1]   = {Level=1,   Quest="BanditQuest1",    Npc="Bandit",       CFrame=CFrame.new(1060, 17, 1547)},
    [2]   = {Level=10,  Quest="QuestNPC2",       Npc="Monkey",       CFrame=CFrame.new(-1612, 37, 152)},
    [3]   = {Level=30,  Quest="QuestNPC3",       Npc="Pirate",       CFrame=CFrame.new(1034, 73, 3939)},
    [4]   = {Level=60,  Quest="QuestNPC4",       Npc="Desert Bandit",CFrame=CFrame.new(931, 7, 4484)},
    [5]   = {Level=90,  Quest="QuestNPC5",       Npc="Snow Bandit",  CFrame=CFrame.new(1176, 105, -1430)},
    [6]   = {Level=120, Quest="QuestNPC6",       Npc="Chief Petty Officer",CFrame=CFrame.new(3589, 75, -4733)},
    [7]   = {Level=150, Quest="QuestNPC7",       Npc="Sky Bandit",   CFrame=CFrame.new(-4921, 717, -2622)},
    [8]   = {Level=190, Quest="QuestNPC8",       Npc="Prisoner",     CFrame=CFrame.new(5300, 1, 474)},
    [9]   = {Level=250, Quest="QuestNPC9",       Npc="Toga Warrior", CFrame=CFrame.new(-1776, 15, -2765)},
    [10]  = {Level=300, Quest="QuestNPC10",      Npc="Military Soldier",CFrame=CFrame.new(-4805, 21, 4388)},
    [11]  = {Level=400, Quest="QuestNPC11",      Npc="Fishman Warrior",CFrame=CFrame.new(61123, 19, 1569)},
    [12]  = {Level=450, Quest="QuestNPC12",      Npc="God's Guard",  CFrame=CFrame.new(-4698, 845, -1912)},
    [13]  = {Level=525, Quest="QuestNPC13",      Npc="Galley Pirate",CFrame=CFrame.new(5580, 15, 4934)},
    [14]  = {Level=625, Quest="QuestNPC14",      Npc="Galley Captain",CFrame=CFrame.new(5649, 39, 4829)},
    [15]  = {Level=700, Quest="SecondSeaQuest",  Npc="Second Sea",   CFrame=CFrame.new(-1164, 55, 1720)},
}

-- 📌 Fungsi Tween Teleport
local TweenService = game:GetService("TweenService")
function TP(pos)
    local tween = TweenService:Create(hrp, TweenInfo.new((hrp.Position - pos.Position).Magnitude/250, Enum.EasingStyle.Linear), {CFrame = pos})
    tween:Play()
    tween.Completed:Wait()
end

-- 📌 Fungsi FloatFarm
function FloatFarm()
    hrp.Velocity = Vector3.new(0,0,0)
    hrp.CFrame = hrp.CFrame + Vector3.new(0,15,0)
end

-- 📌 Fungsi BringMob
function BringMob(QuestMobName)
    for _, v in pairs(workspace.Enemies:GetChildren()) do
        if v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
            if string.find(v.Name, QuestMobName) then
                v.HumanoidRootPart.CFrame = hrp.CFrame * CFrame.new(0,0,-5)
                v.HumanoidRootPart.CanCollide = false
                v.Humanoid.WalkSpeed = 0
                v.Humanoid.JumpPower = 0
            end
        end
    end
end

-- 📌 Auto Stats (Melee Only)
spawn(function()
    while getgenv().AutoStats do wait(3)
        local stat = require(game:GetService("ReplicatedStorage").Stats)
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AddPoint", "Melee", 3)
    end
end)

-- 📌 AutoFarm
spawn(function()
    while getgenv().AutoFarm do wait()
        local myLevel = plr.Data.Level.Value
        for i, data in pairs(QuestList) do
            if myLevel >= data.Level then
                -- teleport ke NPC Quest
                TP(data.CFrame)
                wait(1)
                -- ambil quest
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", data.Quest, 1)
                wait(1)
                -- farming
                repeat wait()
                    FloatFarm()
                    BringMob(data.Npc)
                    vu:CaptureController()
                    vu:Button1Down(Vector2.new(1280,672))
                until not getgenv().AutoFarm or plr.PlayerGui.Main.Quest.Visible == false
            end
        end
    end
end)end

-- cari musuh
local function getMob(name)
    for _, mob in pairs(workspace.Enemies:GetChildren()) do
        if mob.Name == name and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then
            return mob
        end
    end
    return nil
end

-- farming loop
spawn(function()
    while task.wait() do
        pcall(function()
            autoStats()
            local level = LocalPlayer.Data.Level.Value
            if level >= 700 then return end -- stop di level 700
            local quest = getQuest(level)
            if quest then
                -- ambil quest
                tpTween(quest.Pos, 200)
                ReplicatedStorage.Remotes.CommF_:InvokeServer("StartQuest", quest.QuestName, quest.NpcName)

                -- lawan musuh
                local mob = getMob(quest.NpcName)
                if mob then
                    repeat
                        tpTween(mob.HumanoidRootPart.Position + Vector3.new(0, 5, 0), 300)
                        ReplicatedStorage.Remotes.CommF_:InvokeServer("Attack", true)
                        task.wait(0.1)
                    until not mob or mob.Humanoid.Health <= 0
                end
            end
        end)
    end
end)        end
    end
    return bestQuest
end

--// Ambil quest
local function takeQuest(q)
    ReplicatedStorage.Remotes.CommF_:InvokeServer("StartQuest", q.QuestName, 1)
end

--// Farm loop
spawn(function()
    while task.wait(1) do
        autoStats()
        local q = getQuest()
        if q then
            if not LocalPlayer.PlayerGui:FindFirstChild("Quest") then
                tpTween(q.Pos, 300)
                takeQuest(q)
            else
                for _, v in pairs(workspace.Enemies:GetChildren()) do
                    if v.Name == q.NpcName and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                        tpTween(v.HumanoidRootPart.Position + Vector3.new(0, 3, 0), 300)
                        ReplicatedStorage.Remotes.CommF_:InvokeServer("Attack", true)
                        break
                    end
                end
            end
        end

        -- Second Sea auto quest trigger
        if LocalPlayer.Data.Level.Value >= 700 then
            ReplicatedStorage.Remotes.CommF_:InvokeServer("DressrosaQuestProgress", "Detective")
            break
        end
    end
end)
