-- 📌 Blox Fruits Autofarm First Sea (Full Quest List, Skip Boss)
-- Auto Quest, Auto Farm Melee, Auto Tween + Bring Mob

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HRP = Character:WaitForChild("HumanoidRootPart")

local function TweenTo(pos)
    local dist = (HRP.Position - pos.Position).Magnitude
    local tween = TweenService:Create(
        HRP,
        TweenInfo.new(dist/300, Enum.EasingStyle.Linear),
        {CFrame = pos}
    )
    tween:Play()
    tween.Completed:Wait()
end

-- 📌 Full Quest Data First Sea (skip boss)
local QuestData = {
    {Level = 1, NPC = "Bandit [Lv. 5]", Quest = "BanditQuest1", Pos = CFrame.new(1060,17,1547)},
    {Level = 10, NPC = "Monkey [Lv. 14]", Quest = "JungleQuest", Pos = CFrame.new(-1611,36,152)},
    {Level = 30, NPC = "Pirate [Lv. 35]", Quest = "BuggyQuest1", Pos = CFrame.new(-1115,14,3939)},
    {Level = 60, NPC = "Desert Bandit [Lv. 60]", Quest = "DesertQuest", Pos = CFrame.new(894,7,4391)},
    {Level = 90, NPC = "Snow Bandit [Lv. 90]", Quest = "SnowQuest", Pos = CFrame.new(1180,106, -1172)},
    {Level = 120, NPC = "Chief Petty Officer [Lv. 120]", Quest = "MarineQuest2", Pos = CFrame.new(-5001,20,4325)},
    {Level = 150, NPC = "Sky Bandit [Lv. 150]", Quest = "SkyQuest", Pos = CFrame.new(-4981,278, -2820)},
    {Level = 190, NPC = "Dark Master [Lv. 175]", Quest = "SkyQuest2", Pos = CFrame.new(-5250,390, -2220)},
    {Level = 220, NPC = "Prisoner [Lv. 190]", Quest = "PrisonerQuest", Pos = CFrame.new(5306,1,475)},
    {Level = 275, NPC = "Toga Warrior [Lv. 250]", Quest = "ColosseumQuest", Pos = CFrame.new(-1631,7,4320)},
    {Level = 300, NPC = "Military Soldier [Lv. 300]", Quest = "MagmaQuest", Pos = CFrame.new(-5312,12,8515)},
    {Level = 375, NPC = "Fishman Warrior [Lv. 375]", Quest = "FishmanQuest", Pos = CFrame.new(61123,18,1564)},
    {Level = 450, NPC = "God's Guard [Lv. 450]", Quest = "SkyExp1Quest", Pos = CFrame.new(-4698,845, -1912)},
    {Level = 525, NPC = "Shanda [Lv. 475]", Quest = "SkyExp2Quest", Pos = CFrame.new(-7670,5567, -497)},
    {Level = 575, NPC = "Royal Squad [Lv. 525]", Quest = "SkyExp3Quest", Pos = CFrame.new(-7828,5635, -1567)},
    {Level = 625, NPC = "Galley Pirate [Lv. 625]", Quest = "FountainQuest", Pos = CFrame.new(5748,38,4841)},
    {Level = 675, NPC = "Galley Captain [Lv. 650]", Quest = "FountainQuest2", Pos = CFrame.new(5670,38,4936)},
}

local function GetQuest()
    local lvl = LocalPlayer.Data.Level.Value
    local q = nil
    for _,quest in pairs(QuestData) do
        if lvl >= quest.Level then
            q = quest
        end
    end
    return q
end

local function TakeQuest(q)
    TweenTo(q.Pos)
    ReplicatedStorage.Remotes.CommF_:InvokeServer("StartQuest", q.Quest, 1)
end

-- 📌 AutoFarm Loop
_G.AutoFarm = true
spawn(function()
    while task.wait() do
        if _G.AutoFarm then
            local q = GetQuest()
            if not q then continue end

            if not LocalPlayer.PlayerGui.Main.Quest.Visible then
                TakeQuest(q)
            else
                for _,mob in pairs(workspace.Enemies:GetChildren()) do
                    if mob.Name == q.NPC and mob:FindFirstChild("HumanoidRootPart") and mob.Humanoid.Health > 0 then
                        mob.HumanoidRootPart.CFrame = HRP.CFrame * CFrame.new(0,0,-5)
                        mob.HumanoidRootPart.Anchored = false
                        TweenTo(mob.HumanoidRootPart.CFrame * CFrame.new(0,5,0))
                        VirtualUser:CaptureController()
                        VirtualUser:Button1Down(Vector2.new(0,0,0))
                    end
                end
            end
        end
    end
end)

-- 📌 Auto Melee Stat
spawn(function()
    while task.wait(2) do
        if _G.AutoFarm then
            ReplicatedStorage.Remotes.CommF_:InvokeServer("AddPoint","Melee",1)
        end
    end
end)                            mob.HumanoidRootPart.CFrame = hrp.CFrame * CFrame.new(0,0,-5)
                            mob.HumanoidRootPart.Anchored = false
                            TweenTo(mob.HumanoidRootPart.CFrame * CFrame.new(0,5,0))
                            game:GetService("VirtualUser"):CaptureController()
                            game:GetService("VirtualUser"):Button1Down(Vector2.new(0,0,0))
                        end
                    end
                end
            end)
        end
    end)
end

-- 📌 Auto Stat (Melee only)
spawn(function()
    while task.wait(2) do
        if _G.AutoStats then
            local args = {"AddPoint","Melee",1}
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
        end
    end
end)

-- 📌 Anti Fall (floating on water)
spawn(function()
    while task.wait() do
        local hrp = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp and hrp.Position.Y < 1 then
            hrp.Velocity = Vector3.new(0,50,0)
        end
    end
end)
