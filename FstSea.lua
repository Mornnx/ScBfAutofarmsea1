-- ⚡ Blox Fruits Autofarm (First Sea, Full List, Skip Boss) ⚡
-- GUI by Kavo UI, AutoFarm, AutoStat (Melee), BringMob, Tween

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("⚡ Blox Fruits AutoFarm (First Sea)", "DarkTheme")

local Tab = Window:NewTab("AutoFarm")
local Section = Tab:NewSection("Main Farm")

_G.AutoFarm = false
_G.AutoStats = true

Section:NewToggle("Auto Farm Level", "Farm sesuai level", function(v)
    _G.AutoFarm = v
    AutoFarm()
end)

Section:NewToggle("Auto Stats Melee", "Tambah stat ke Melee", function(v)
    _G.AutoStats = v
end)

-- 📌 Full Quest Data (skip boss)
local QuestData = {
    {Level = 1,   NPC = "Bandit [Lv. 5]",         QuestName = "BanditQuest1", QuestPos = CFrame.new(1060,17,1547)},
    {Level = 10,  NPC = "Monkey [Lv. 14]",        QuestName = "JungleQuest",  QuestPos = CFrame.new(-1611,36,152)},
    {Level = 30,  NPC = "Pirate [Lv. 35]",        QuestName = "BuggyQuest1",  QuestPos = CFrame.new(-1115,14,3939)},
    {Level = 60,  NPC = "Desert Bandit [Lv. 60]", QuestName = "DesertQuest",  QuestPos = CFrame.new(896,6,4390)},
    {Level = 90,  NPC = "Snow Bandit [Lv. 90]",   QuestName = "SnowQuest",    QuestPos = CFrame.new(1389,88,-1293)},
    {Level = 120, NPC = "Chief Petty Officer [Lv. 120]", QuestName = "MarineQuest2", QuestPos = CFrame.new(-5035,29,4325)},
    {Level = 150, NPC = "Sky Bandit [Lv. 150]",   QuestName = "SkyQuest",     QuestPos = CFrame.new(-4970,278,717)},
    {Level = 190, NPC = "Dark Master [Lv. 175]",  QuestName = "SkyQuest2",    QuestPos = CFrame.new(-5250,389,-228)},
    {Level = 220, NPC = "Prisoner [Lv. 190]",     QuestName = "PrisonerQuest",QuestPos = CFrame.new(5308,1,475)},
    {Level = 250, NPC = "Toga Warrior [Lv. 250]", QuestName = "ColosseumQuest",QuestPos = CFrame.new(-1577,8,-2986)},
    {Level = 300, NPC = "Military Soldier [Lv. 300]", QuestName = "MagmaQuest",QuestPos = CFrame.new(-5321,11,8467)},
    {Level = 330, NPC = "Military Spy [Lv. 330]", QuestName = "MagmaQuest",   QuestPos = CFrame.new(-5321,11,8467)},
    {Level = 370, NPC = "Fishman Warrior [Lv. 375]", QuestName = "FishmanQuest",QuestPos = CFrame.new(61123,19,1569)},
    {Level = 400, NPC = "Fishman Commando [Lv. 400]", QuestName = "FishmanQuest2",QuestPos = CFrame.new(61891,19,1471)},
    {Level = 450, NPC = "God's Guard [Lv. 450]",  QuestName = "SkyExp1Quest", QuestPos = CFrame.new(-4698,845,-1912)},
    {Level = 480, NPC = "Shanda [Lv. 475]",       QuestName = "SkyExp2Quest", QuestPos = CFrame.new(-7685,5567,-502)},
    {Level = 525, NPC = "Royal Squad [Lv. 525]",  QuestName = "SkyExp2Quest", QuestPos = CFrame.new(-7685,5567,-502)},
    {Level = 550, NPC = "Royal Soldier [Lv. 550]",QuestName = "SkyExp3Quest", QuestPos = CFrame.new(-7903,5638,-1412)},
    {Level = 625, NPC = "Galley Pirate [Lv. 625]",QuestName = "FountainQuest",QuestPos = CFrame.new(5242,38,4074)},
    {Level = 650, NPC = "Galley Captain [Lv. 650]",QuestName = "FountainQuest",QuestPos = CFrame.new(5242,38,4074)},
}

-- 📌 Ambil quest sesuai level
function GetQuest()
    local plr = game.Players.LocalPlayer
    local lvl = plr.Data.Level.Value
    local qData = nil
    for _,q in pairs(QuestData) do
        if lvl >= q.Level then
            qData = q
        end
    end
    return qData
end

-- 📌 Tween function
function TweenTo(pos)
    local ts = game:GetService("TweenService")
    local plr = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not plr then return end
    local dist = (plr.Position - pos.Position).Magnitude
    local tween = ts:Create(plr, TweenInfo.new(dist/300, Enum.EasingStyle.Linear), {CFrame = pos})
    tween:Play()
    tween.Completed:Wait()
end

-- 📌 AutoFarm loop
function AutoFarm()
    spawn(function()
        while _G.AutoFarm and task.wait() do
            pcall(function()
                local q = GetQuest()
                if not q then return end
                local plr = game.Players.LocalPlayer
                local char = plr.Character
                local hrp = char:WaitForChild("HumanoidRootPart")

                -- Ambil Quest
                if not plr.PlayerGui.Main.Quest.Visible then
                    TweenTo(q.QuestPos)
                    local args = {"StartQuest", q.QuestName, 1}
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
                else
                    -- Cari musuh
                    for _,mob in pairs(workspace.Enemies:GetChildren()) do
                        if mob.Name == q.NPC and mob:FindFirstChild("HumanoidRootPart") and mob.Humanoid.Health > 0 then
                            mob.HumanoidRootPart.CFrame = hrp.CFrame * CFrame.new(0,0,-5)
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
