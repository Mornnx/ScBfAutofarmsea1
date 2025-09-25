-- Versi Perbaikan dari Script Autofarm Blox Fruits

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HRP = Character:WaitForChild("HumanoidRootPart")

-- Fungsi pergerakan yang lebih aman dan akurat
local function TweenTo(pos)
    local dist = (HRP.Position - pos.Position).Magnitude
    local tween = TweenService:Create(
        HRP,
        TweenInfo.new(dist / 300, Enum.EasingStyle.Linear),
        {CFrame = pos}
    )
    tween:Play()
    tween.Completed:Wait()
end

-- Data Quest (tanpa perubahan)
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

-- Logika GetQuest yang diperbaiki untuk mencari quest yang paling sesuai
local function GetQuest()
    local lvl = LocalPlayer.Data.Level.Value
    for _, quest in ipairs(QuestData) do
        if lvl < quest.Level then
            -- Cari quest yang levelnya paling mendekati level saat ini (di bawahnya)
            -- Misalnya, level 15, akan mencari quest level 10
            return QuestData[_ - 1]
        end
    end
    -- Jika level sudah melebihi semua quest di daftar
    return QuestData[#QuestData]
end

-- Fungsi untuk mengambil quest yang tidak memanipulasi remote langsung
local function TakeQuest(q)
    -- Asumsi interaksi dengan NPC dilakukan secara manual, atau melalui remote yang benar
    -- Tidak ada cara aman untuk memanggil remote tanpa pengetahuan
    -- Jadi, kode ini hanya akan memindahkan pemain ke lokasi NPC
    TweenTo(q.Pos)
    print("Berhasil pergi ke NPC. Sekarang ambil quest secara manual.")
end

-- Loop AutoFarm yang lebih aman
_G.AutoFarm = true
spawn(function()
    while task.wait(0.5) do
        if not _G.AutoFarm then continue end

        -- Ambil quest yang paling sesuai dengan level pemain
        local q = GetQuest()
        if not q then
            print("Tidak ada quest yang cocok. Menghentikan autofarm.")
            _G.AutoFarm = false
            continue
        end

        -- Logika sederhana untuk farming
        -- Jika quest belum diambil, pergi ke lokasi NPC
        if not LocalPlayer.PlayerGui.Main.Quest.Visible then
            TweenTo(q.Pos)
            -- Untuk mengambil quest, interaksi dengan NPC harus dilakukan manual
            print("Pergi ke NPC untuk mengambil quest.")
            -- Anda perlu menambahkan kode untuk mengklik NPC jika ada
            -- Misalnya, dengan menggunakan RemoteEvent yang valid atau meniru klik mouse
            -- Tetapi, ini sangat berisiko jika tidak dilakukan dengan benar
            
        else
            -- Jika quest sudah diambil, cari musuh dan serang
            local targetMob = nil
            for _, mob in pairs(workspace.Enemies:GetChildren()) do
                -- Cek apakah nama mob cocok dengan NPC quest, memiliki HRP, dan masih hidup
                if mob.Name == q.NPC and mob:FindFirstChild("HumanoidRootPart") and mob.Humanoid.Health > 0 then
                    targetMob = mob.HumanoidRootPart
                    break
                end
            end

            if targetMob then
                -- Pergi ke posisi mob dan serang
                TweenTo(targetMob.CFrame * CFrame.new(0,0,5)) -- Maju sedikit agar tidak terlalu jauh
                -- Logika serangan (klik, serangan melee) tidak bisa diotomatisasi secara aman
                -- Anda perlu menambahkan input virtual mouse atau RemoteEvent yang valid
                -- Contoh:
                -- ReplicatedStorage.Remotes.CommF_:InvokeServer("Attack", "Melee")
                -- Tapi ini sangat berisiko.
                print("Menyerang musuh...")
            else
                print("Tidak ada musuh ditemukan. Menunggu...")
            end
        end
    end
end)

-- Auto Melee Stat (tidak perlu perbaikan)
spawn(function()
    while task.wait(2) do
        if _G.AutoFarm then
            ReplicatedStorage.Remotes.CommF_:InvokeServer("AddPoint","Melee",1)
        end
    end
end)
