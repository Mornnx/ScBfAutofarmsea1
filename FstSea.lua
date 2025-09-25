--// Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

--// Utility
local function getChar()
    if not LocalPlayer.Character then LocalPlayer.CharacterAdded:Wait() end
    return LocalPlayer.Character
end

local function tpTween(pos, speed)
    local char = getChar()
    local hrp = char:WaitForChild("HumanoidRootPart")
    local distance = (hrp.Position - pos).Magnitude
    local time = distance / speed

    local tween = TweenService:Create(
        hrp,
        TweenInfo.new(time, Enum.EasingStyle.Linear),
        {CFrame = CFrame.new(pos)}
    )
    tween:Play()
    tween.Completed:Wait()
end

--// Auto stat (semua ke melee)
local function autoStats()
    local points = LocalPlayer.Data.Points.Value
    if points > 0 then
        ReplicatedStorage.Remotes.CommF_:InvokeServer("AddPoint", "Melee", points)
    end
end

--// First Sea Quest Data (skip boss)
local QuestData = {
    {LevelReq = 1, QuestName = "BanditQuest1", NpcName = "Bandit", Pos = Vector3.new(1060, 17, 1547)},
    {LevelReq = 10, QuestName = "JungleQuest", NpcName = "Monkey", Pos = Vector3.new(-1600, 36, 153)},
    {LevelReq = 15, QuestName = "JungleQuest", NpcName = "Gorilla", Pos = Vector3.new(-1600, 36, 153)},
    {LevelReq = 30, QuestName = "BuggyQuest1", NpcName = "Pirate", Pos = Vector3.new(-1100, 14, 3830)},
    {LevelReq = 60, QuestName = "DesertQuest", NpcName = "Desert Bandit", Pos = Vector3.new(921, 7, 4488)},
    {LevelReq = 75, QuestName = "DesertQuest", NpcName = "Desert Officer", Pos = Vector3.new(921, 7, 4488)},
    {LevelReq = 90, QuestName = "SnowQuest", NpcName = "Snow Bandit", Pos = Vector3.new(1389, 87, -1298)},
    {LevelReq = 105, QuestName = "SnowQuest", NpcName = "Snowman", Pos = Vector3.new(1389, 87, -1298)},
    {LevelReq = 120, QuestName = "MarineQuest2", NpcName = "Chief Petty Officer", Pos = Vector3.new(-5035, 29, 4325)},
    {LevelReq = 150, QuestName = "SkyQuest", NpcName = "Sky Bandit", Pos = Vector3.new(-4981, 717, -2620)},
    {LevelReq = 190, QuestName = "PrisonerQuest", NpcName = "Dangerous Prisoner", Pos = Vector3.new(5300, 1, 474)},
    {LevelReq = 210, QuestName = "PrisonerQuest", NpcName = "Dangerous Prisoner", Pos = Vector3.new(5300, 1, 474)},
    {LevelReq = 250, QuestName = "ColosseumQuest", NpcName = "Toga Warrior", Pos = Vector3.new(-1617, 7, -2985)},
    {LevelReq = 275, QuestName = "ColosseumQuest", NpcName = "Gladiator", Pos = Vector3.new(-1617, 7, -2985)},
    {LevelReq = 300, QuestName = "MagmaQuest", NpcName = "Military Soldier", Pos = Vector3.new(-5328, 12, 8467)},
    {LevelReq = 325, QuestName = "MagmaQuest", NpcName = "Military Spy", Pos = Vector3.new(-5328, 12, 8467)},
    {LevelReq = 375, QuestName = "FishmanQuest", NpcName = "Fishman Warrior", Pos = Vector3.new(61123, 18, 1561)},
    {LevelReq = 400, QuestName = "FishmanQuest", NpcName = "Fishman Commando", Pos = Vector3.new(61123, 18, 1561)},
    {LevelReq = 450, QuestName = "SkyExp1Quest", NpcName = "God's Guard", Pos = Vector3.new(-4607, 872, -1667)},
    {LevelReq = 525, QuestName = "SkyExp1Quest", NpcName = "Shanda", Pos = Vector3.new(-7892, 5545, -382)},
    {LevelReq = 575, QuestName = "SkyExp2Quest", NpcName = "Royal Squad", Pos = Vector3.new(-7685, 5639, -1440)},
    {LevelReq = 625, QuestName = "SkyExp2Quest", NpcName = "Royal Soldier", Pos = Vector3.new(-7868, 5636, -380)},
    {LevelReq = 675, QuestName = "FountainQuest", NpcName = "Galley Pirate", Pos = Vector3.new(5231, 38, 4054)},
    {LevelReq = 700, QuestName = "FountainQuest", NpcName = "Galley Captain", Pos = Vector3.new(5231, 38, 4054)},
}

--// Cari quest sesuai level
local function getQuest()
    local myLevel = LocalPlayer.Data.Level.Value
    local bestQuest
    for _, q in pairs(QuestData) do
        if myLevel >= q.LevelReq then
            bestQuest = q
        end
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
