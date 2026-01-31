local plr = game:GetService("Players").LocalPlayer
local char = plr.Character
local root = char.HumanoidRootPart
local Plrs = game:GetService("Players")
local MyPlr = Plrs.LocalPlayer
local MyChar = MyPlr.Character
local UIS = game:GetService'UserInputService'
local RepStor = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")
local Run = game:GetService("RunService")
local mouse = game.Players.LocalPlayer:GetMouse()
local human = plr.Character:WaitForChild("Humanoid")

-- Anti Idle --
local VirtualUser=game:service'VirtualUser'
game:service'Players'.LocalPlayer.Idled:connect(function()
	VirtualUser:CaptureController()
	VirtualUser:ClickButton2(Vector2.new())
end)

showstartmessage = true
showtopplayersactive = false
showtopplayersfistactive = false
showtopplayersbodyactive = false
showtopplayersspeedactive = false
showtopplayersjumpactive = false
showtopplayerspsychicactive = false
farmbtsafetyactive = false
farmbtsafety2active = false
settplocation = false
playerdied = false
deathreturnactive = false
godmodeactive = false
noclip = false
resetplayerstat = false
killplayeractive = false
farmallactive = false
farmfistactive = false
farmbodyactive = false
farmspeedactive = false
farmjumpactive = false
farmpsychicactive = false
punchmodeactive = false
ESPEnabled = false
ESPLength = 20000

-- Оновлений скрипт з виправленою кнопкою ESP

local Plrs = game:GetService("Players")
local MyPlr = Plrs.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local Run = game:GetService("RunService")

-- [БЛОК ОЧИЩЕННЯ ПЕРЕД ЗАПУСКОМ]
local scriptTag = "MyUniqueESP"
if _G.ESPConnection then
    _G.ESPConnection:Disconnect() -- Зупиняємо старий цикл
end

-- Видаляємо всі старі ESP об'єкти з CoreGui
for _, child in pairs(CoreGui:GetChildren()) do
    if child.Name:sub(1, 4) == "ESP_" then
        child:Destroy()
    end
end

-- [НАЛАШТУВАННЯ]
local ESP_SETTINGS = {
    Enabled = true, -- Зробив True для тесту
    MaxDistance = 60000,
    TextSize = 14
}

local function Abbreviate(x)
    if not x then return "0" end
    x = tonumber(x) or 0
    local suffixes = {"k", "M", "B", "T", "Qa", "Qi", "sx", "Sp", "So", "No", "dc", "Ud"}
    if x < 1000 then return tostring(math.floor(x)) end
    local i = 1
    while x >= 1000 and i <= #suffixes do
        x = x / 1000
        i = i + 1
    end
    return string.format("%.10f%s", x, suffixes[i - 1] or "+")
end

local function GetStatusColor(p)
    local ls = p:FindFirstChild("leaderstats")
    local s = ls and ls:FindFirstChild("Status") and ls.Status.Value
    if s == "Criminal" then return Color3.new(1, 0, 1)
    elseif s == "Lawbreaker" then return Color3.new(1, 0, 0)
    elseif s == "Guardian" then return Color3.new(0, 0.8, 1)
    elseif s == "Protector" then return Color3.new(0, 0, 1)
    elseif s == "Superhero" then return Color3.new(1, 1, 0)
    end
    return Color3.new(1, 1, 1)
end

function RemoveESP(p)
    local find = CoreGui:FindFirstChild("ESP_" .. p.Name)
    if find then find:Destroy() end
end

function CreateESP(p)
    if CoreGui:FindFirstChild("ESP_" .. p.Name) then return end
    
    local bill = Instance.new("BillboardGui", CoreGui)
    bill.Name = "ESP_" .. p.Name
    bill.AlwaysOnTop = true
    bill.ResetOnSpawn = false -- Важливо
    bill.Size = UDim2.new(0, 250, 0, 180) 
    bill.StudsOffset = Vector3.new(0, 4.5, 0)
    
    local f = Instance.new("Frame", bill)
    f.BackgroundTransparency = 1
    f.Size = UDim2.new(1, 0, 1, 0)

    local l = Instance.new("UIListLayout", f)
    l.HorizontalAlignment = Enum.HorizontalAlignment.Center
    l.SortOrder = Enum.SortOrder.LayoutOrder

    local function Lbl(name, order, color)
        local t = Instance.new("TextLabel", f)
        t.Name = name
        t.BackgroundTransparency = 1
        t.Size = UDim2.new(1, 0, 0, 16)
        t.Font = Enum.Font.SourceSansBold
        t.TextSize = ESP_SETTINGS.TextSize
        t.TextColor3 = color
        t.TextStrokeTransparency = 0.5
        t.LayoutOrder = order
        return t
    end

    Lbl("Names", 1, Color3.new(1, 1, 1))           
    Lbl("Dist", 2, Color3.fromRGB(200, 200, 200))  
    Lbl("Health", 3, Color3.fromRGB(0, 255, 0))    
    Lbl("TPM", 4, Color3.fromRGB(255, 215, 0))     
    Lbl("Fist", 5, Color3.fromRGB(255, 0, 0))      
    Lbl("Psychic", 6, Color3.fromRGB(170, 0, 255)) 
end

-- [ОСНОВНИЙ ЦИКЛ]
_G.ESPConnection = Run.RenderStepped:Connect(function()
    for _, p in pairs(Plrs:GetPlayers()) do
        if p ~= MyPlr then
            if ESP_SETTINGS.Enabled then
                local b = CoreGui:FindFirstChild("ESP_" .. p.Name)
                if not b then CreateESP(p) end
                b = CoreGui:FindFirstChild("ESP_" .. p.Name)
                
                local char = p.Character
                local root = char and char:FindFirstChild("HumanoidRootPart")
                local myChar = MyPlr.Character
                local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")

                if b and root and myRoot then
                    local dist = (myRoot.Position - root.Position).Magnitude
                    if dist < ESP_SETTINGS.MaxDistance then
                        b.Enabled = true
                        b.Adornee = root
                        local fr = b.Frame
                        fr.Names.Text = p.Name
                        fr.Names.TextColor3 = GetStatusColor(p)
                        fr.Dist.Text = "Dist: " .. math.floor(dist)
                        
                        local hum = char:FindFirstChild("Humanoid")
                        fr.Health.Text = hum and "HP: " .. Abbreviate(hum.Health) or "HP: 0"
                        
                        fr.Fist.Text = "Fist: " .. Abbreviate(p:GetAttribute("FistStrength"))
                        fr.TPM.Text = "TPM: " .. Abbreviate(p:GetAttribute("TPM"))
                        fr.Psychic.Text = "Psy: " .. Abbreviate(p:GetAttribute("PsychicPower"))
                    else
                        b.Enabled = false
                    end
                elseif b then
                    b.Enabled = false
                end
            else
                RemoveESP(p)
            end
        end
    end
end)

-- Очищення при виході гравців
Plrs.PlayerRemoving:Connect(RemoveESP)

local MainGUI = Instance.new("ScreenGui")
local TopFrame = Instance.new("Frame")
local MainFrame = Instance.new("Frame")
local Open = Instance.new("TextButton")
local Close = Instance.new("TextButton")
local Minimize = Instance.new("TextButton")
local cf = Instance.new("Frame")
local c1 = Instance.new("TextLabel")
local c = Instance.new("TextButton")
local DeathReturn = Instance.new("TextButton")
local PunchMode = Instance.new("TextButton")
local WayPoints = Instance.new("TextButton")
local WayPointsFrame = Instance.new("Frame")
local FarmExp = Instance.new("TextButton")
local FarmExpFrame = Instance.new("Frame")
local ShowLocation = Instance.new("TextLabel")
local SetLocation = Instance.new("TextButton")
local TPLocation = Instance.new("TextButton")
local Location1 = Instance.new("TextButton")
local Location2 = Instance.new("TextButton")
local LocationFS1B = Instance.new("TextButton")
local LocationFS100B = Instance.new("TextButton")
local LocationFS10T = Instance.new("TextButton")
local LocationFS1Qa = Instance.new("TextButton")
local LocationFS1Qi = Instance.new("TextButton")
local LocationFS1Sx = Instance.new("TextButton")
local LocationFS1Sp = Instance.new("TextButton")
local LocationFS1So = Instance.new("TextButton")
local LocationFS1No = Instance.new("TextButton")
local LocationFS1Dc = Instance.new("TextButton")
local Location3 = Instance.new("TextButton")
local Location4 = Instance.new("TextButton")
local Location5 = Instance.new("TextButton")
local Location6 = Instance.new("TextButton")
local Location7 = Instance.new("TextButton")
local Location8 = Instance.new("TextButton")
local Location9 = Instance.new("TextButton")
local Location10 = Instance.new("TextButton")
local LocationBT1B = Instance.new("TextButton")
local LocationBT100B = Instance.new("TextButton")
local LocationBT10T = Instance.new("TextButton")
local LocationBT1Qa = Instance.new("TextButton")
local LocationBT1Qi = Instance.new("TextButton")
local LocationBT1Sx = Instance.new("TextButton")
local LocationBT1Sp = Instance.new("TextButton")
local LocationBT1Oc = Instance.new("TextButton")
local LocationBT1No = Instance.new("TextButton")
local LocationBT1Dc = Instance.new("TextButton")
local LocationPP1M  = Instance.new("TextButton")
local LocationPP1B  = Instance.new("TextButton")
local LocationPP1T  = Instance.new("TextButton")
local LocationPP1Qa = Instance.new("TextButton")
local LocationPP1Qi = Instance.new("TextButton")
local LocationPP1Sx = Instance.new("TextButton")
local LocationPP1Sp = Instance.new("TextButton")
local LocationPP1Oc = Instance.new("TextButton")
local LocationPP1No = Instance.new("TextButton")
local LocationPP1Dc = Instance.new("TextButton")
local FarmAll = Instance.new("TextButton")
local FarmFist = Instance.new("TextButton")
local FarmBody = Instance.new("TextButton")
local FarmSpeed = Instance.new("TextButton")
local FarmJump = Instance.new("TextButton")
local SavePosition = Instance.new("TextLabel")
local FarmPsychic = Instance.new("TextButton")
local FarmBodyLabel = Instance.new("TextLabel")
local FarmSpeedLabel = Instance.new("TextLabel")
local esptrack = Instance.new("TextButton")
local ESPLength = Instance.new("TextBox")
local Extras = Instance.new("TextButton")
local ExtrasFrame = Instance.new("Frame")
local PlayerInfo = Instance.new("TextButton")
local PlayerInfoFrame = Instance.new("Frame")
local ShowTopPlayers = Instance.new("TextButton")
local ShowBetterFS = Instance.new("TextButton")
local ShowBetterBT = Instance.new("TextButton")
local ShowBetterPP = Instance.new("TextButton")
local ShowWorseFS = Instance.new("TextButton")
local ShowWorseBT = Instance.new("TextButton")
local ShowWorsePP = Instance.new("TextButton")
local PlayerInfoStatsFrame = Instance.new("Frame")
local PlayerInfoStatsClose = Instance.new("TextButton")
local StatBestFistText1 = Instance.new("TextLabel")
local StatBestBodyText1 = Instance.new("TextLabel")
local StatBestSpeedText1 = Instance.new("TextLabel")
local StatBestJumpText1 = Instance.new("TextLabel")
local StatBestPsychicText1 = Instance.new("TextLabel")
local PlayerInfoStatsText1 = Instance.new("TextLabel")
local ShowStatsFist1 = Instance.new("TextLabel")
local ShowStatsBody1 = Instance.new("TextLabel")
local ShowStatsSpeed1 = Instance.new("TextLabel")
local ShowStatsJump1 = Instance.new("TextLabel")
local ShowStatsPsychic1 = Instance.new("TextLabel")
local ShowStatsFist2 = Instance.new("TextLabel")
local ShowStatsBody2 = Instance.new("TextLabel")
local ShowStatsSpeed2 = Instance.new("TextLabel")
local ShowStatsJump2 = Instance.new("TextLabel")
local ShowStatsPsychic2 = Instance.new("TextLabel")
local AnnoyNameLabel = Instance.new("TextLabel")
local AnnoyName = Instance.new("TextBox")
local AnnoyStart = Instance.new("TextButton")
local KillPlayerStart = Instance.new("TextButton")
local TptoPlayer = Instance.new("TextButton")
local PanicToggleLabel = Instance.new("TextLabel")
local farmbtsafety = Instance.new("TextButton")
local farmbtsafetyText1 = Instance.new("TextLabel")
local farmbtsafetylevel = Instance.new("TextBox")
local farmbtsafety2 = Instance.new("TextButton")
local farmbtsafetylabel = Instance.new("TextLabel")
local PanicToggle = Instance.new("TextBox")
local ReJoinServer = Instance.new("TextButton")
local InfoScreen = Instance.new("TextButton")
local InfoFrame = Instance.new("Frame")
local InfoText1 = Instance.new("TextLabel")
local PlayerName = Instance.new("TextBox")
local StatsFrame = Instance.new("Frame")
local ShowStats1 = Instance.new("TextLabel")
local ShowStats2 = Instance.new("TextLabel")
local StatNameSet = Instance.new("TextButton")
local NoClip = Instance.new("TextButton")
local GodMode = Instance.new("TextButton")

-- Properties

MainGUI.Name = "MainGUI"
MainGUI.Parent = game.CoreGui
MainGUI.ResetOnSpawn = false
local MainCORE = game.CoreGui["MainGUI"]

TopFrame.Name = "TopFrame"
TopFrame.Parent = MainGUI
TopFrame.BackgroundColor3 = Color3.new(0, 0, 0)
TopFrame.BorderColor3 = Color3.new(0, 0, 0)
TopFrame.BackgroundTransparency = 1
TopFrame.Position = UDim2.new(0.5, -30, 0, -27)
TopFrame.Size = UDim2.new(0, 80, 0, 20)
TopFrame.Visible = false

cf.Name = "cf"
cf.Parent = MainGUI
cf.BackgroundColor3 = Color3.new(0, 0, 0)
cf.BorderColor3 = Color3.new(0.5, 0.5, 0.5)
cf.BackgroundTransparency = 0
cf.Position = UDim2.new(0.5, -195, 0.5, -110)
cf.Size = UDim2.new(0, 390, 0, 220)
cf.Visible = true

c1.Name = "c1"
c1.Parent = cf
c1.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
c1.BackgroundTransparency = 1
c1.Position = UDim2.new(0, 10, 0, 13)
c1.Size = UDim2.new(0, 370, 0, 160)
c1.Font = Enum.Font.Fantasy
c1.TextColor3 = Color3.new(1, 1, 1)
c1.Text = "SUPER POWERS TRAINING SIMULATOR GUI\nmade by _sora_5968 (discord)\n\nPress F9 to read more information about the GUI\n\nThis GUI is free, if you paid for it you were scammed\nand should report it.\n\nNo unauthorized use of this GUI without written\npermission from the creator."
c1.TextSize = 17

c.Name = "c"
c.Parent = cf
c.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
c.BorderColor3 = Color3.new(0.6, 0.6, 0.6)
c.Position = UDim2.new(0.5, -30, 0, 190)
c.Size = UDim2.new(0, 60, 0, 20)
c.Font = Enum.Font.Fantasy
c.Text = "CLOSE"
c.TextColor3 = Color3.new(1, 0, 0)
c.TextSize = 17
c.TextWrapped = true

Open.Name = "Open"
Open.Parent = TopFrame
Open.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
Open.BorderColor3 = Color3.new(0.6, 0.6, 0.6)
Open.Size = UDim2.new(0, 60, 0, 20)
Open.Font = Enum.Font.Fantasy
Open.Text = "Open"
Open.TextColor3 = Color3.new(1, 1, 1)
Open.TextSize = 18
Open.Selectable = true
Open.TextWrapped = true

MainFrame.Name = "MainFrame"
MainFrame.Parent = MainGUI
MainFrame.BackgroundColor3 = Color3.new(0, 0, 0)
MainFrame.BackgroundTransparency = 0.5
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.5, -382.5, 0, -32)
MainFrame.Size = UDim2.new(0, 765, 0, 30)
if not cf.Visible then MainGUI:Destroy() else MainFrame.Visible = true end

Close.Name = "Close"
Close.Parent = MainFrame
Close.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
Close.BorderColor3 = Color3.new(0.6, 0.6, 0.6)
Close.Position = UDim2.new(0, 10, 0, 5)
Close.Size = UDim2.new(0, 20, 0, 20)
Close.Font = Enum.Font.Fantasy
Close.Text = "X"
Close.TextColor3 = Color3.new(1, 0, 0)
Close.TextSize = 17
Close.TextScaled = true
Close.TextWrapped = true

Minimize.Name = "Minimize"
Minimize.Parent = MainFrame
Minimize.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
Minimize.BorderColor3 = Color3.new(0.6, 0.6, 0.6)
Minimize.Position = UDim2.new(0, 35, 0, 5)
Minimize.Size = UDim2.new(0, 20, 0, 20)
Minimize.Font = Enum.Font.Fantasy
Minimize.Text = "-"
Minimize.TextColor3 = Color3.new(1, 0, 1)
Minimize.TextSize = 17
Minimize.TextScaled = true
Minimize.TextWrapped = true

WayPoints.Name = "WayPoints"
WayPoints.Parent = MainFrame
WayPoints.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
WayPoints.BorderColor3 = Color3.new(0.6, 0.6, 0.6)
WayPoints.Position = UDim2.new(0, 60, 0, 5)
WayPoints.Size = UDim2.new(0, 65, 0, 20)
WayPoints.Font = Enum.Font.Fantasy
WayPoints.TextColor3 = Color3.new(1, 1, 1)
WayPoints.Text = "Teleport"
WayPoints.TextSize = 17
WayPoints.TextWrapped = true

WayPointsFrame.Name = "WayPointsFrame"
WayPointsFrame.Parent = MainFrame
WayPointsFrame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
WayPointsFrame.BorderColor3 = Color3.new(0, 0, 0)
WayPointsFrame.BackgroundTransparency = 0.2
WayPointsFrame.Position = UDim2.new(0, 1, 0, 33)
WayPointsFrame.Size = UDim2.new(0, 375, 0, 480)
WayPointsFrame.Visible = false

FarmExp.Name = "FarmExp"
FarmExp.Parent = MainFrame
FarmExp.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
FarmExp.BorderColor3 = Color3.new(0.6, 0.6, 0.6)
FarmExp.Position = UDim2.new(0, 130, 0, 5)
FarmExp.Size = UDim2.new(0, 75, 0, 20)
FarmExp.Font = Enum.Font.Fantasy
FarmExp.TextColor3 = Color3.new(1, 1, 1)
FarmExp.Text = "Farm Exp"
FarmExp.TextSize = 17
FarmExp.TextWrapped = true

FarmExpFrame.Name = "FarmExpFrame"
FarmExpFrame.Parent = MainFrame
FarmExpFrame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
FarmExpFrame.BorderColor3 = Color3.new(0, 0, 0)
FarmExpFrame.BackgroundTransparency = 0.2
FarmExpFrame.Position = UDim2.new(0, 62.5, 0, 33)
FarmExpFrame.Size = UDim2.new(0, 210, 0, 165)
FarmExpFrame.Visible = false

ShowLocation.Name = "ShowLocation"
ShowLocation.Parent = WayPointsFrame
ShowLocation.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
ShowLocation.TextColor3 = Color3.new(1, 1, 1)
ShowLocation.BorderColor3 = Color3.new(0, 0, 0)
ShowLocation.Position = UDim2.new(0, 5, 0, 5)
ShowLocation.Size = UDim2.new(0, 170, 0, 20)
ShowLocation.Font = Enum.Font.Fantasy
ShowLocation.Text = "Current Location"
ShowLocation.TextWrapped = true
ShowLocation.TextSize = 15

SetLocation.Name = "SetLocation"
SetLocation.Parent = WayPointsFrame
SetLocation.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
SetLocation.TextColor3 = Color3.new(1, 1, 1)
SetLocation.BorderColor3 = Color3.new(0.6, 0.6, 0.6)
SetLocation.Position = UDim2.new(0, 180, 0, 5)
SetLocation.Size = UDim2.new(0, 120, 0, 20)
SetLocation.Font = Enum.Font.Fantasy
SetLocation.Text = "Set Location"
SetLocation.TextWrapped = true
SetLocation.TextSize = 16

TPLocation.Name = "TPLocation"
TPLocation.Parent = WayPointsFrame
TPLocation.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
TPLocation.TextColor3 = Color3.new(1, 1, 1)
TPLocation.BorderColor3 = Color3.new(0.6, 0.6, 0.6)
TPLocation.Position = UDim2.new(0, 305, 0, 5)
TPLocation.Size = UDim2.new(0, 65, 0, 20)
TPLocation.Font = Enum.Font.Fantasy
TPLocation.Text = "Tp to"
TPLocation.TextWrapped = true
TPLocation.TextSize = 16

Location1.Name = "Location1"
Location1.Parent = WayPointsFrame
Location1.BackgroundColor3 = Color3.new(255/255, 94/255, 40/255)
Location1.TextColor3 = Color3.new(1, 1, 1)
Location1.BorderColor3 = Color3.new(0.6, 0.6, 0.6)
Location1.Position = UDim2.new(0, 5, 0, 30)
Location1.Size = UDim2.new(0, 365, 0, 20)
Location1.Font = Enum.Font.Fantasy
Location1.Text = "Save zone)))"
Location1.TextWrapped = true
Location1.TextSize = 16

Location2.Name = "Location2"
Location2.Parent = WayPointsFrame
Location2.BackgroundColor3 = Color3.new(70/255, 105/255, 0)
Location2.TextColor3 = Color3.new(1, 1, 1)
Location2.BorderColor3 = Color3.new(0.6, 0.6, 0.6)
Location2.Position = UDim2.new(0, 5, 0, 55)
Location2.Size = UDim2.new(0, 365, 0, 20)
Location2.Font = Enum.Font.Fantasy
Location2.Text = "Teleport to Rock "
Location2.TextWrapped = true
Location2.TextSize = 16

Location7.Name = "Location7"
Location7.Parent = WayPointsFrame
Location7.BackgroundColor3 = Color3.new(70/255, 105/255, 0)
Location7.TextColor3 = Color3.new(1, 1, 1)
Location7.BorderColor3 = Color3.new(0.6, 0.6, 0.6)
Location7.Position = UDim2.new(0, 5, 0, 80)
Location7.Size = UDim2.new(0, 365, 0, 20)
Location7.Font = Enum.Font.Fantasy
Location7.Text = "Teleport to Crystal"
Location7.TextWrapped = true
Location7.TextSize = 16

LocationFS1B.Name = "LocationFS1B"
LocationFS1B.Parent = WayPointsFrame
LocationFS1B.BackgroundColor3 = Color3.new(70/255, 105/255, 0)
LocationFS1B.TextColor3 = Color3.new(1, 1, 1)
LocationFS1B.BorderColor3 = Color3.new(0.6, 0.6, 0.6)
LocationFS1B.Position = UDim2.new(0, 5, 0, 105)
LocationFS1B.Size = UDim2.new(0, 365, 0, 20)
LocationFS1B.Font = Enum.Font.Fantasy
LocationFS1B.Text = "Teleport to 1B+ FS required"
LocationFS1B.TextWrapped = true
LocationFS1B.TextSize = 16

LocationFS100B.Name = "LocationFS100B"
LocationFS100B.Parent = WayPointsFrame
LocationFS100B.BackgroundColor3 = Color3.new(70/255, 105/255, 0)
LocationFS100B.TextColor3 = Color3.new(1, 1, 1)
LocationFS100B.BorderColor3 = Color3.new(0.6, 0.6, 0.6)
LocationFS100B.Position = UDim2.new(0, 5, 0, 130)
LocationFS100B.Size = UDim2.new(0, 365, 0, 20)
LocationFS100B.Font = Enum.Font.Fantasy
LocationFS100B.Text = "Teleport to 100B+ FS required"
LocationFS100B.TextWrapped = true
LocationFS100B.TextSize = 16

LocationFS10T.Name = "LocationFS10T"
LocationFS10T.Parent = WayPointsFrame
LocationFS10T.BackgroundColor3 = Color3.new(70/255, 105/255, 0)
LocationFS10T.TextColor3 = Color3.new(1, 1, 1)
LocationFS10T.BorderColor3 = Color3.new(0.6, 0.6, 0.6)
LocationFS10T.Position = UDim2.new(0, 5, 0, 155)
LocationFS10T.Size = UDim2.new(0, 365, 0, 20)
LocationFS10T.Font = Enum.Font.Fantasy
LocationFS10T.Text = "Teleport to 10T+ FS required"
LocationFS10T.TextWrapped = true
LocationFS10T.TextSize = 16

LocationFS1Qa.Name = "LocationFS1Qa"
LocationFS1Qa.Parent = WayPointsFrame
LocationFS1Qa.BackgroundColor3 = Color3.new(70/255, 105/255, 0)
LocationFS1Qa.TextColor3 = Color3.new(1, 1, 1)
LocationFS1Qa.BorderColor3 = Color3.new(0.6, 0.6, 0.6)
LocationFS1Qa.Position = UDim2.new(0, 5, 0, 180)
LocationFS1Qa.Size = UDim2.new(0, 365, 0, 20)
LocationFS1Qa.Font = Enum.Font.Fantasy
LocationFS1Qa.Text = "Teleport to 1Qa+ FS required"
LocationFS1Qa.TextWrapped = true
LocationFS1Qa.TextSize = 16

LocationFS1Qi.Name = "LocationFS1Qi"
LocationFS1Qi.Parent = WayPointsFrame
LocationFS1Qi.BackgroundColor3 = Color3.new(70/255, 105/255, 0)
LocationFS1Qi.TextColor3 = Color3.new(1, 1, 1)
LocationFS1Qi.BorderColor3 = Color3.new(0.6, 0.6, 0.6)
LocationFS1Qi.Position = UDim2.new(0, 5, 0, 205)
LocationFS1Qi.Size = UDim2.new(0, 365, 0, 20)
LocationFS1Qi.Font = Enum.Font.Fantasy
LocationFS1Qi.Text = "Teleport to 1Qi+ FS required"
LocationFS1Qi.TextWrapped = true
LocationFS1Qi.TextSize = 16

Location3.Name = "Location3"
Location3.Parent = WayPointsFrame
Location3.BackgroundColor3 = Color3.new(66/255, 0, 165/255)
Location3.TextColor3 = Color3.new(1, 1, 1)
Location3.BorderColor3 = Color3.new(0.6, 0.6, 0.6)
Location3.Position = UDim2.new(0, 5, 0, 330)
Location3.Size = UDim2.new(0, 365, 0, 20)
Location3.Font = Enum.Font.Fantasy
Location3.Text = "Tp to 500+ BT required"
Location3.TextWrapped = true
Location3.TextSize = 16

Location4.Name = "Location4"
Location4.Parent = WayPointsFrame
Location4.BackgroundColor3 = Color3.new(66/255, 0, 165/255)
Location4.TextColor3 = Color3.new(1, 1, 1)
Location4.BorderColor3 = Color3.new(0.6, 0.6, 0.6)
Location4.Position = UDim2.new(0, 5, 0, 355)
Location4.Size = UDim2.new(0, 365, 0, 20)
Location4.Font = Enum.Font.Fantasy
Location4.Text = "Tp to 50k+ BT required"
Location4.TextWrapped = true
Location4.TextSize = 16

Location5.Name = "Location5"
Location5.Parent = WayPointsFrame
Location5.BackgroundColor3 = Color3.new(66/255, 0, 165/255)
Location5.TextColor3 = Color3.new(1, 1, 1)
Location5.BorderColor3 = Color3.new(0.6, 0.6, 0.6)
Location5.Position = UDim2.new(0, 5, 0, 380)
Location5.Size = UDim2.new(0, 365, 0, 20)
Location5.Font = Enum.Font.Fantasy
Location5.Text = "Tp to 500k+ BT required"
Location5.TextWrapped = true
Location5.TextSize = 16

Location6.Name = "Location6"
Location6.Parent = WayPointsFrame
Location6.BackgroundColor3 = Color3.new(66/255, 0, 165/255)
Location6.TextColor3 = Color3.new(1, 1, 1)
Location6.BorderColor3 = Color3.new(0.6, 0.6, 0.6)
Location6.Position = UDim2.new(0, 5, 0, 405)
Location6.Size = UDim2.new(0, 365, 0, 20)
Location6.Font = Enum.Font.Fantasy
Location6.Text = "Tp to 5M+ BT required"
Location6.TextWrapped = true
Location6.TextSize = 16

Location8.Name = "Location8"
Location8.Parent = WayPointsFrame
Location8.BackgroundColor3 = Color3.new(66/255, 0, 165/255)
Location8.TextColor3 = Color3.new(1, 1, 1)
Location8.BorderColor3 = Color3.new(0.6, 0.6, 0.6)
Location8.Position = UDim2.new(0, 5, 0, 430)
Location8.Size = UDim2.new(0, 365, 0, 20)
Location8.Font = Enum.Font.Fantasy
Location8.Text = "Tp to 50M+ BT required"
Location8.TextWrapped = true
Location8.TextSize = 16

LocationBT1B.Name = "LocationBT1B"
LocationBT1B.Parent = WayPointsFrame
LocationBT1B.BackgroundColor3 = Color3.new(66/255, 0, 165/255)
LocationBT1B.TextColor3 = Color3.new(1, 1, 1)
LocationBT1B.BorderColor3 = Color3.new(0.6, 0.6, 0.6)
LocationBT1B.Position = UDim2.new(0, 5, 0, 455)
LocationBT1B.Size = UDim2.new(0, 365, 0, 20)
LocationBT1B.Font = Enum.Font.Fantasy
LocationBT1B.Text = "Tp to 5B+ BT required"
LocationBT1B.TextWrapped = true
LocationBT1B.TextSize = 16

LocationBT100B.Name = "LocationBT100B"
LocationBT100B.Parent = WayPointsFrame
LocationBT100B.BackgroundColor3 = Color3.new(66/255, 0, 165/255)
LocationBT100B.TextColor3 = Color3.new(1, 1, 1)
LocationBT100B.BorderColor3 = Color3.new(0.6, 0.6, 0.6)
LocationBT100B.Position = UDim2.new(0, 5, 0, 480)
LocationBT100B.Size = UDim2.new(0, 365, 0, 20)
LocationBT100B.Font = Enum.Font.Fantasy
LocationBT100B.Text = "Tp to 500B+ BT required"
LocationBT100B.TextWrapped = true
LocationBT100B.TextSize = 16

LocationBT10T.Name = "LocationBT10T"
LocationBT10T.Parent = WayPointsFrame
LocationBT10T.BackgroundColor3 = Color3.new(66/255, 0, 165/255)
LocationBT10T.TextColor3 = Color3.new(1, 1, 1)
LocationBT10T.BorderColor3 = Color3.new(0.6, 0.6, 0.6)
LocationBT10T.Position = UDim2.new(0, 5, 0, 505)
LocationBT10T.Size = UDim2.new(0, 365, 0, 20)
LocationBT10T.Font = Enum.Font.Fantasy
LocationBT10T.Text = "Tp to 50T+ BT required"
LocationBT10T.TextWrapped = true
LocationBT10T.TextSize = 16

LocationBT1Qa.Name = "LocationBT1Qa"
LocationBT1Qa.Parent = WayPointsFrame
LocationBT1Qa.BackgroundColor3 = Color3.new(66/255, 0, 165/255)
LocationBT1Qa.TextColor3 = Color3.new(1, 1, 1)
LocationBT1Qa.BorderColor3 = Color3.new(0.6, 0.6, 0.6)
LocationBT1Qa.Position = UDim2.new(0, 5, 0, 530)
LocationBT1Qa.Size = UDim2.new(0, 365, 0, 20)
LocationBT1Qa.Font = Enum.Font.Fantasy
LocationBT1Qa.Text = "Tp to 5Qa+ BT required"
LocationBT1Qa.TextWrapped = true
LocationBT1Qa.TextSize = 16

LocationBT1Qi.Name = "LocationBT1Qi"
LocationBT1Qi.Parent = WayPointsFrame
LocationBT1Qi.BackgroundColor3 = Color3.new(66/255, 0, 165/255)
LocationBT1Qi.TextColor3 = Color3.new(1, 1, 1)
LocationBT1Qi.BorderColor3 = Color3.new(0.6, 0.6, 0.6)
LocationBT1Qi.Position = UDim2.new(0, 5, 0, 555)
LocationBT1Qi.Size = UDim2.new(0, 365, 0, 20)
LocationBT1Qi.Font = Enum.Font.Fantasy
LocationBT1Qi.Text = "Tp to 5Qi+ BT required"
LocationBT1Qi.TextWrapped = true
LocationBT1Qi.TextSize = 16

LocationPP1M.Name = "LocationPP1M"
LocationPP1M.Parent = WayPointsFrame
LocationPP1M.BackgroundColor3 = Color3.new(195/255, 0, 39/255)
LocationPP1M.TextColor3 = Color3.new(1, 1, 1)
LocationPP1M.BorderColor3 = Color3.new(0.6, 0.6, 0.6)
LocationPP1M.Position = UDim2.new(0, 5, 0, 680)
LocationPP1M.Size = UDim2.new(0, 365, 0, 20)
LocationPP1M.Font = Enum.Font.Fantasy
LocationPP1M.Text = "Tp to 1M+ PP required"
LocationPP1M.TextWrapped = true
LocationPP1M.TextSize = 16

LocationPP1B.Name = "LocationPP1B"
LocationPP1B.Parent = WayPointsFrame
LocationPP1B.BackgroundColor3 = Color3.new(195/255, 0, 39/255)
LocationPP1B.TextColor3 = Color3.new(1, 1, 1)
LocationPP1B.BorderColor3 = Color3.new(0.6, 0.6, 0.6)
LocationPP1B.Position = UDim2.new(0, 5, 0, 705)
LocationPP1B.Size = UDim2.new(0, 365, 0, 20)
LocationPP1B.Font = Enum.Font.Fantasy
LocationPP1B.Text = "Tp to 1B+ PP required"
LocationPP1B.TextWrapped = true
LocationPP1B.TextSize = 16

LocationPP1T.Name = "LocationPP1T"
LocationPP1T.Parent = WayPointsFrame
LocationPP1T.BackgroundColor3 = Color3.new(195/255, 0, 39/255)
LocationPP1T.TextColor3 = Color3.new(1, 1, 1)
LocationPP1T.BorderColor3 = Color3.new(0.6, 0.6, 0.6)
LocationPP1T.Position = UDim2.new(0, 5, 0, 730)
LocationPP1T.Size = UDim2.new(0, 365, 0, 20)
LocationPP1T.Font = Enum.Font.Fantasy
LocationPP1T.Text = "Tp to 1T+ PP required"
LocationPP1T.TextWrapped = true
LocationPP1T.TextSize = 16

LocationPP1Qa.Name = "LocationPP1Qa"
LocationPP1Qa.Parent = WayPointsFrame
LocationPP1Qa.BackgroundColor3 = Color3.new(195/255, 0, 39/255)
LocationPP1Qa.TextColor3 = Color3.new(1, 1, 1)
LocationPP1Qa.BorderColor3 = Color3.new(0.6, 0.6, 0.6)
LocationPP1Qa.Position = UDim2.new(0, 5, 0, 755)
LocationPP1Qa.Size = UDim2.new(0, 365, 0, 20)
LocationPP1Qa.Font = Enum.Font.Fantasy
LocationPP1Qa.Text = "Tp to 1Qa+ PP required"
LocationPP1Qa.TextWrapped = true
LocationPP1Qa.TextSize = 16

LocationPP1Qi.Name = "LocationPP1Qi"
LocationPP1Qi.Parent = WayPointsFrame
LocationPP1Qi.BackgroundColor3 = Color3.new(195/255, 0, 39/255)
LocationPP1Qi.TextColor3 = Color3.new(1, 1, 1)
LocationPP1Qi.BorderColor3 = Color3.new(0.6, 0.6, 0.6)
LocationPP1Qi.Position = UDim2.new(0, 5, 0, 780)
LocationPP1Qi.Size = UDim2.new(0, 365, 0, 20)
LocationPP1Qi.Font = Enum.Font.Fantasy
LocationPP1Qi.Text = "Tp to 1Qi+ PP required"
LocationPP1Qi.TextWrapped = true
LocationPP1Qi.TextSize = 16

LocationPP1Sx.Name = "LocationPP1Sx"
LocationPP1Sx.Parent = WayPointsFrame
LocationPP1Sx.BackgroundColor3 = Color3.new(195/255, 0, 39/255)
LocationPP1Sx.TextColor3 = Color3.new(1, 1, 1)
LocationPP1Sx.BorderColor3 = Color3.new(0.6, 0.6, 0.6)
LocationPP1Sx.Position = UDim2.new(0, 5, 0, 805)
LocationPP1Sx.Size = UDim2.new(0, 365, 0, 20)
LocationPP1Sx.Font = Enum.Font.Fantasy
LocationPP1Sx.Text = "Tp to 1Sx+ PP required"
LocationPP1Sx.TextWrapped = true
LocationPP1Sx.TextSize = 16

FarmAll.Name = "FarmAll"
FarmAll.Parent = FarmExpFrame
FarmAll.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
FarmAll.TextColor3 = Color3.new(1, 1, 1)
FarmAll.BorderColor3 = Color3.new(0.6, 0.6, 0.6)
FarmAll.Position = UDim2.new(0, 5, 0, 5)
FarmAll.Size = UDim2.new(0, 200, 0, 20)
FarmAll.Font = Enum.Font.Fantasy
FarmAll.Text = "------"
FarmAll.TextWrapped = true
FarmAll.TextSize = 16

FarmFist.Name = "FarmFist"
FarmFist.Parent = FarmExpFrame
FarmFist.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
FarmFist.TextColor3 = Color3.new(1, 1, 1)
FarmFist.BorderColor3 = Color3.new(0.6, 0.6, 0.6)
FarmFist.Position = UDim2.new(0, 5, 0, 40)
FarmFist.Size = UDim2.new(0, 200, 0, 20)
FarmFist.Font = Enum.Font.Fantasy
FarmFist.Text = "Farm Fist Strength: OFF"
FarmFist.TextWrapped = true
FarmFist.TextSize = 16

FarmBody.Name = "FarmBody"
FarmBody.Parent = FarmExpFrame
FarmBody.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
FarmBody.TextColor3 = Color3.new(1, 1, 1)
FarmBody.BorderColor3 = Color3.new(0.6, 0.6, 0.6)
FarmBody.Position = UDim2.new(0, 5, 0, 65)
FarmBody.Size = UDim2.new(0, 200, 0, 20)
FarmBody.Font = Enum.Font.Fantasy
FarmBody.Text = "Farm Body Toughness: OFF"
FarmBody.TextWrapped = true
FarmBody.TextSize = 16

FarmSpeed.Name = "FarmSpeed"
FarmSpeed.Parent = FarmExpFrame
FarmSpeed.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
FarmSpeed.TextColor3 = Color3.new(1, 1, 1)
FarmSpeed.BorderColor3 = Color3.new(0.6, 0.6, 0.6)
FarmSpeed.Position = UDim2.new(0, 5, 0, 90)
FarmSpeed.Size = UDim2.new(0, 200, 0, 20)
FarmSpeed.Font = Enum.Font.Fantasy
FarmSpeed.Text = "-------"
FarmSpeed.TextWrapped = true
FarmSpeed.TextSize = 16

FarmJump.Name = "FarmJump"
FarmJump.Parent = FarmExpFrame
FarmJump.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
FarmJump.TextColor3 = Color3.new(1, 1, 1)
FarmJump.BorderColor3 = Color3.new(0.6, 0.6, 0.6)
FarmJump.Position = UDim2.new(0, 5, 0, 115)
FarmJump.Size = UDim2.new(0, 200, 0, 20)
FarmJump.Font = Enum.Font.Fantasy
FarmJump.Text = "Farm Jump Force: OFF"
FarmJump.TextWrapped = true
FarmJump.TextSize = 16

FarmPsychic.Name = "FarmPsychic"
FarmPsychic.Parent = FarmExpFrame
FarmPsychic.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
FarmPsychic.TextColor3 = Color3.new(1, 1, 1)
FarmPsychic.BorderColor3 = Color3.new(0.6, 0.6, 0.6)
FarmPsychic.Position = UDim2.new(0, 5, 0, 140)
FarmPsychic.Size = UDim2.new(0, 200, 0, 20)
FarmPsychic.Font = Enum.Font.Fantasy
FarmPsychic.Text = "Farm Psychic Power: OFF"
FarmPsychic.TextWrapped = true
FarmPsychic.TextSize = 16

FarmBodyLabel.Name = "FarmBodyLabel"
FarmBodyLabel.Parent = FarmExpFrame
FarmBodyLabel.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
FarmBodyLabel.TextColor3 = Color3.new(1, 1, 1)
FarmBodyLabel.BorderColor3 = Color3.new(0.1, 0.1, 0.1)
FarmBodyLabel.Position = UDim2.new(0, 213, 0, 65)
FarmBodyLabel.Size = UDim2.new(0, 200, 0, 100)
FarmBodyLabel.Font = Enum.Font.Fantasy
FarmBodyLabel.Text = "actually it’s a really cool feature, you just need to enable DeathReturn as well — then your character will teleport to the best locations for you and you’ll get maximum BT."
FarmBodyLabel.TextSize = 16
FarmBodyLabel.TextWrapped = true
FarmBodyLabel.Visible = false

FarmSpeedLabel.Name = "FarmSpeedLabel"
FarmSpeedLabel.Parent = FarmExpFrame
FarmSpeedLabel.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
FarmSpeedLabel.TextColor3 = Color3.new(1, 1, 1)
FarmSpeedLabel.BorderColor3 = Color3.new(0.1, 0.1, 0.1)
FarmSpeedLabel.Position = UDim2.new(0, 213, 0, 65)
FarmSpeedLabel.Size = UDim2.new(0, 200, 0, 100)
FarmSpeedLabel.Font = Enum.Font.Fantasy
FarmSpeedLabel.Text = "Only Jump"
FarmSpeedLabel.TextSize = 16
FarmSpeedLabel.TextWrapped = true
FarmSpeedLabel.Visible = false

DeathReturn.Name = "DeathReturn"
DeathReturn.Parent = MainFrame
DeathReturn.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
DeathReturn.BorderColor3 = Color3.new(0.6, 0.6, 0.6)
DeathReturn.Position = UDim2.new(0, 210, 0, 5)
DeathReturn.Size = UDim2.new(0, 160, 0, 20)
DeathReturn.Font = Enum.Font.Fantasy
DeathReturn.TextColor3 = Color3.new(1, 1, 1)
DeathReturn.Text = "OnDeath Return: OFF"
DeathReturn.TextSize = 17
DeathReturn.TextWrapped = true

esptrack.Name = "esptrack"
esptrack.Parent = MainFrame
esptrack.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
esptrack.BorderColor3 = Color3.new(0.6, 0.6, 0.6)
esptrack.Position = UDim2.new(0, 375, 0, 5)
esptrack.Size = UDim2.new(0, 35, 0, 20)
esptrack.TextColor3 = Color3.new(1, 1, 1)
esptrack.Font = Enum.Font.Fantasy
esptrack.Text = "ESP"
esptrack.TextSize = 16
esptrack.TextWrapped = true

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")

-- ==========================================
-- 🛠️ NETWORK FIX (ВИРІШЕННЯ ПРОБЛЕМИ)
-- ==========================================
-- Цей блок намагається розширити радіус, у якому ти можеш керувати NPC
task.spawn(function()
    while true do
        pcall(function()
            settings().Physics.AllowSleep = false
            local player = game.Players.LocalPlayer
            player.ReplicationFocus = Workspace
            
            -- Спроба встановити величезний радіус симуляції
            -- (Працює на більшості експлойтів)
            sethiddenproperty(player, "SimulationRadius", 10000)
            sethiddenproperty(player, "MaxSimulationRadius", 10000)
        end)
        RunService.Heartbeat:Wait()
    end
end)
-- ==========================================

-- 1. СТВОРЕННЯ ПОЛЯ ДЛЯ ВВОДУ ІМЕНІ (TargetInput)
local TargetInput = Instance.new("TextBox")
TargetInput.Name = "TargetInput"
TargetInput.Parent = MainFrame -- Переконайся, що MainFrame існує
TargetInput.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
TargetInput.BorderColor3 = Color3.new(0.6, 0.6, 0.6)
TargetInput.Position = UDim2.new(0, 415, 0, 30)
TargetInput.Size = UDim2.new(0, 85, 0, 20)
TargetInput.Font = Enum.Font.SourceSans
TargetInput.Text = ""
TargetInput.PlaceholderText = "Target (Me)"
TargetInput.TextColor3 = Color3.new(1, 1, 1)
TargetInput.PlaceholderColor3 = Color3.new(0.7, 0.7, 0.7)
TargetInput.TextSize = 14
TargetInput.ZIndex = 10

-- 2. СТВОРЕННЯ КНОПКИ LOOP (TPLoopBtn)
local TPLoopBtn = Instance.new("TextButton")
TPLoopBtn.Name = "TPLoop"
TPLoopBtn.Parent = MainFrame
TPLoopBtn.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
TPLoopBtn.BorderColor3 = Color3.new(0.6, 0.6, 0.6)
TPLoopBtn.Position = UDim2.new(0, 415, 0, 5)
TPLoopBtn.Size = UDim2.new(0, 85, 0, 20)
TPLoopBtn.TextColor3 = Color3.new(1, 1, 1)
TPLoopBtn.Font = Enum.Font.Fantasy
TPLoopBtn.Text = "TP NPC: OFF"
TPLoopBtn.TextSize = 14
TPLoopBtn.TextWrapped = true
TPLoopBtn.ZIndex = 10

-- Логіка телепортації
local npcNames = {"CJ", "Sath", "Thug", "Angel","Moltens"}
local tpActive = false
local rowWidth = 8
local spacing = 1
local isLoopRunning = false 

-- Функція для пошуку гравця за частковим іменем
local function getTargetPlayer()
    local text = TargetInput.Text
    
    if text == "" or text == " " then
        return LocalPlayer
    end

    for _, p in ipairs(Players:GetPlayers()) do
        if p.Name:lower():sub(1, #text) == text:lower() or p.DisplayName:lower():sub(1, #text) == text:lower() then
            return p
        end
    end
    
    return nil
end

local function teleportNPCs()
    local target = getTargetPlayer()
    
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        local targetRoot = target.Character.HumanoidRootPart
        local count = 0
        
        for _, object in ipairs(Workspace:GetChildren()) do
            if table.find(npcNames, object.Name) and object:IsA("Model") then
                local npcRoot = object:FindFirstChild("HumanoidRootPart")
                local humanoid = object:FindFirstChild("Humanoid")
                
                if npcRoot then
                    -- 1. Вимикаємо колізію
                    for _, part in ipairs(object:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                            -- Скидання швидкості допомагає серверу прийняти нову позицію
                            part.AssemblyLinearVelocity = Vector3.new(0, 0, 0) 
                            part.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                        end
                    end
                    
                    -- 2. Якщо є гуманоїд, змушуємо його змінити стан (іноді допомагає з синхронізацією)
                    if humanoid then
                        humanoid:ChangeState(Enum.HumanoidStateType.Physics)
                    end

                    -- 3. Розрахунок позиції
                    local column = count % rowWidth
                    local row = math.floor(count / rowWidth)
                    
                    local xOffset = (column - (rowWidth / 2)) * spacing
                    local zOffset = -3 - (row * spacing)
                    
                    -- 4. Телепортація
                    npcRoot.CFrame = targetRoot.CFrame * CFrame.new(xOffset, 0, zOffset)
                    count = count + 1
                end
            end
        end
    end
end

TPLoopBtn.MouseButton1Click:Connect(function()
    tpActive = not tpActive
    
    if tpActive then
        TPLoopBtn.Text = "TP NPC: ON"
        TPLoopBtn.TextColor3 = Color3.new(0, 1, 0)
        
        if not isLoopRunning then
            isLoopRunning = true
            task.spawn(function()
                while tpActive do
                    teleportNPCs()
                    -- Використовуємо Heartbeat для максимальної швидкості оновлення фізики
                    RunService.Heartbeat:Wait() 
                end
                isLoopRunning = false 
            end)
        end
    else
        TPLoopBtn.Text = "TP NPC: OFF"
        TPLoopBtn.TextColor3 = Color3.new(1, 0, 0)
    end
end)

-- 1. Поле для введення імені (TextBox)
local PlayerNameInput = Instance.new("TextBox")
PlayerNameInput.Name = "PlayerNameInput"
PlayerNameInput.Parent = ExtrasFrame
PlayerNameInput.BackgroundColor3 = Color3.new(0.05, 0.05, 0.05)
PlayerNameInput.BorderColor3 = Color3.new(0.4, 0.4, 0.4)
PlayerNameInput.Position = UDim2.new(0, 5, 0, 100)
PlayerNameInput.Size = UDim2.new (0, 150, 0, 20)
PlayerNameInput.Font = Enum.Font.SourceSans
PlayerNameInput.PlaceholderText = "Enter Name..."
PlayerNameInput.Text = ""
PlayerNameInput.TextColor3 = Color3.new(1, 1, 1)
PlayerNameInput.TextSize = 12
PlayerNameInput.ClearTextOnFocus = false -- Щоб текст не зникав, коли натискаєш на поле

-- 2. Кнопка циклічного ТП цілі
local TargetTPBtn = Instance.new("TextButton")
TargetTPBtn.Name = "TargetTPBtn"
TargetTPBtn.Parent = ExtrasFrame
TargetTPBtn.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
TargetTPBtn.BorderColor3 = Color3.new(0.6, 0.6, 0.6)
TargetTPBtn.Position = UDim2.new(0, 5, 0, 125)
TargetTPBtn.Size = UDim2.new(0, 150, 0, 20)
TargetTPBtn.TextColor3 = Color3.new(1, 1, 1)
TargetTPBtn.Font = Enum.Font.Fantasy
TargetTPBtn.Text = "Player TP: OFF"
TargetTPBtn.TextSize = 12
TargetTPBtn.ZIndex = 10

local targetTpActive = false
local isTargetTpRunning = false

-- Функція пошуку та ТП
local function teleportTarget()
    local text = PlayerNameInput.Text:lower()
    local me = game.Players.LocalPlayer
    
    if text == "" then return end
    if not me.Character or not me.Character:FindFirstChild("HumanoidRootPart") then return end
    
    local myRoot = me.Character.HumanoidRootPart
    
    for _, player in ipairs(game.Players:GetPlayers()) do
        -- ПЕРЕВІРКА: Не тепаємо себе (player ~= me)
        if player ~= me then 
            local pName = player.Name:lower()
            local pDisplayName = player.DisplayName:lower()
            
            -- Якщо нік починається з того, що введено в поле
            if pName:sub(1, #text) == text or pDisplayName:sub(1, #text) == text then
                if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    player.Character.HumanoidRootPart.CFrame = myRoot.CFrame * CFrame.new(0, 0, -2)
                end
            end
        end
    end
end

-- Логіка кнопки
TargetTPBtn.MouseButton1Click:Connect(function()
    targetTpActive = not targetTpActive
    
    if targetTpActive then
        TargetTPBtn.Text = "Player TP: ON"
        TargetTPBtn.TextColor3 = Color3.new(0, 1, 0)
        
        if not isTargetTpRunning then
            isTargetTpRunning = true
            task.spawn(function()
                while targetTpActive do
                    teleportTarget()
                    task.wait(0.1) -- 10 разів на секунду
                end
                isTargetTpRunning = false
            end)
        end
    else
        TargetTPBtn.Text = "Player TP: OFF"
        TargetTPBtn.TextColor3 = Color3.new(1, 0, 0)
    end
end)

local AdminCheckBtn = Instance.new("TextButton")
AdminCheckBtn.Name = "AdminCheckBtn"
AdminCheckBtn.Parent = ExtrasFrame
AdminCheckBtn.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
AdminCheckBtn.BorderColor3 = Color3.new(0.6, 0.6, 0.6)
AdminCheckBtn.Position = UDim2.new(0, 5, 0, 150) 
AdminCheckBtn.Size = UDim2.new(0, 150, 0, 20)
AdminCheckBtn.TextColor3 = Color3.new(1, 1, 1)
AdminCheckBtn.Font = Enum.Font.Fantasy
AdminCheckBtn.Text = "Admin Check: OFF"
AdminCheckBtn.TextSize = 12
AdminCheckBtn.ZIndex = 10

local DistanceKickBtn = Instance.new("TextButton")
DistanceKickBtn.Name = "DistanceKickBtn"
DistanceKickBtn.Parent = ExtrasFrame 
DistanceKickBtn.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
DistanceKickBtn.BorderColor3 = Color3.new(0.6, 0.6, 0.6)
DistanceKickBtn.Position = UDim2.new(0, 5, 0, 175) 
DistanceKickBtn.Size = UDim2.new(0, 150, 0, 20)
DistanceKickBtn.TextColor3 = Color3.new(1, 1, 1)
DistanceKickBtn.Font = Enum.Font.Fantasy
DistanceKickBtn.Text = "Distance Kick: OFF"
DistanceKickBtn.TextSize = 12
DistanceKickBtn.ZIndex = 10

Extras.Name = "Extras"
Extras.Parent = MainFrame
Extras.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
Extras.BorderColor3 = Color3.new(0.6, 0.6, 0.6)
Extras.Position = UDim2.new(0, 505, 0, 5)
Extras.Size = UDim2.new(0, 50, 0, 20)
Extras.TextColor3 = Color3.new(1, 1, 1)
Extras.Font = Enum.Font.Fantasy
Extras.Text = "Extras"
Extras.TextSize = 16
Extras.TextWrapped = true

ExtrasFrame.Name = "ExtrasFrame"
ExtrasFrame.Parent = MainFrame
ExtrasFrame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
ExtrasFrame.BorderColor3 = Color3.new(0, 0, 0)
ExtrasFrame.BackgroundTransparency = 0.2
ExtrasFrame.Position = UDim2.new(0, 435, 0, 33)
ExtrasFrame.Size = UDim2.new(0, 160, 0, 155)
ExtrasFrame.Visible = false

AnnoyName.Name = "AnnoyName"
AnnoyName.Parent = ExtrasFrame
AnnoyName.BackgroundColor3 = Color3.new(0.4, 0.4, 0.4)
AnnoyName.BorderColor3 = Color3.new(0.8, 0.8, 0.8)
AnnoyName.Position = UDim2.new(0, 5, 0, 5)
AnnoyName.Size = UDim2.new(0, 150, 0, 20)
AnnoyName.TextColor3 = Color3.new(1, 1, 1)
AnnoyName.Font = Enum.Font.Fantasy
AnnoyName.Text = tostring(MyPlr.Name)
AnnoyName.TextSize = 14
AnnoyName.TextScaled = false
AnnoyName.TextWrapped = true

TptoPlayer.Name = "TptoPlayer"
TptoPlayer.Parent = ExtrasFrame
TptoPlayer.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
TptoPlayer.BorderColor3 = Color3.new(0.6, 0.6, 0.6)
TptoPlayer.Position = UDim2.new(0, 5, 0, 26)
TptoPlayer.Size = UDim2.new(0, 150, 0, 20)
TptoPlayer.TextColor3 = Color3.new(1, 1, 1)
TptoPlayer.Font = Enum.Font.Fantasy
TptoPlayer.Text = "TP to Player"
TptoPlayer.TextSize = 16
TptoPlayer.TextWrapped = true

AnnoyStart.Name = "AnnoyStart"
AnnoyStart.Parent = ExtrasFrame
AnnoyStart.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
AnnoyStart.BorderColor3 = Color3.new(0.6, 0.6, 0.6)
AnnoyStart.Position = UDim2.new(0, 5, 0, 47)
AnnoyStart.Size = UDim2.new(0, 150, 0, 20)
AnnoyStart.TextColor3 = Color3.new(1, 1, 1)
AnnoyStart.Font = Enum.Font.Fantasy
AnnoyStart.Text = "TP Spam Player: OFF"
AnnoyStart.TextSize = 16
AnnoyStart.TextWrapped = true

PanicToggleLabel.Name = "PanicToggleLabel"
PanicToggleLabel.Parent = ExtrasFrame
PanicToggleLabel.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
PanicToggleLabel.BorderSizePixel = 0
PanicToggleLabel.Position = UDim2.new(0, 5, 0, 75)
PanicToggleLabel.Size = UDim2.new(0, 125, 0, 20)
PanicToggleLabel.TextColor3 = Color3.new(1, 1, 1)
PanicToggleLabel.Font = Enum.Font.Fantasy
PanicToggleLabel.Text = "Panic KeyBind"
PanicToggleLabel.TextSize = 16
PanicToggleLabel.TextWrapped = true

PanicToggle.Name = "PanicToggle"
PanicToggle.Parent = ExtrasFrame
PanicToggle.BackgroundColor3 = Color3.new(0.4, 0.4, 0.4)
PanicToggle.BorderColor3 = Color3.new(0.8, 0.8, 0.8)
PanicToggle.Position = UDim2.new(0, 130, 0, 75)
PanicToggle.Size = UDim2.new(0, 25, 0, 18)
PanicToggle.TextColor3 = Color3.new(1, 1, 1)
PanicToggle.Font = Enum.Font.Fantasy
PanicToggle.Text = "y"
PanicToggle.TextSize = 16
PanicToggle.TextWrapped = true

InfoScreen.Name = "InfoScreen"
InfoScreen.Parent = MainFrame
InfoScreen.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
InfoScreen.BorderColor3 = Color3.new(0.6, 0.6, 0.6)
InfoScreen.Position = UDim2.new(0, 560, 0, 5)
InfoScreen.Size = UDim2.new(0, 40, 0, 20)
InfoScreen.BackgroundTransparency = 0
InfoScreen.Font = Enum.Font.Fantasy
InfoScreen.TextColor3 = Color3.new(1, 1, 1)
InfoScreen.Text = "Info"
InfoScreen.TextSize = 17
InfoScreen.TextWrapped = true

InfoText1.Name = "InfoText1"
InfoText1.Parent = MainFrame
InfoText1.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
InfoText1.BorderColor3 = Color3.new(0, 0, 0)
InfoText1.BackgroundTransparency = 0
InfoText1.Position = UDim2.new(0, 405, 0, 32)
InfoText1.Size = UDim2.new(0, 190, 0, 90)
InfoText1.TextColor3 = Color3.new(1, 1, 1)
InfoText1.Font = Enum.Font.Fantasy
InfoText1.Text = "This GUI was created by Sora\nDiscord: _sora_5968\n\nSpecial thanks to LuckyMMB and Bispø for the motivation."
InfoText1.TextSize = 15
InfoText1.TextWrapped = true
InfoText1.Visible = false
InfoText1.ZIndex = 7
InfoText1.TextYAlignment = Enum.TextYAlignment.Top

PlayerName.Name = "PlayerName"
PlayerName.Parent = MainFrame
PlayerName.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
PlayerName.BorderColor3 = Color3.new(0.6, 0.6, 0.6)
PlayerName.Position = UDim2.new(0, 605, 0, 5)
PlayerName.Size = UDim2.new(0, 150, 0, 20)
PlayerName.Font = Enum.Font.Fantasy
PlayerName.TextColor3 = Color3.new(1, 1, 1)
PlayerName.Text = tostring(MyPlr.Name)
PlayerName.TextSize = 15
PlayerName.TextScaled = true
PlayerName.TextWrapped = false

StatsFrame.Name = "StatsFrame"
StatsFrame.Parent = MainFrame
StatsFrame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
StatsFrame.BorderColor3 = Color3.new(0.1, 0.1, 0.1)
StatsFrame.BackgroundTransparency = 0
StatsFrame.Position = UDim2.new(0, 600, 0, 33)
StatsFrame.Size = UDim2.new(0, 161, 0, 90)
StatsFrame.Visible = false

ShowStats1.Name = "ShowStats1"
ShowStats1.Parent = StatsFrame
ShowStats1.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
ShowStats1.BackgroundTransparency = 1
ShowStats1.Position = UDim2.new(0, 0, 0, 0)
ShowStats1.Size = UDim2.new(0, 50, 0, 90)
ShowStats1.Font = Enum.Font.Fantasy
ShowStats1.TextColor3 = Color3.new(1, 1, 1)
ShowStats1.Text = " "
ShowStats1.TextSize = 15
ShowStats1.TextXAlignment = Enum.TextXAlignment.Right

ShowStats2.Name = "ShowStats2"
ShowStats2.Parent = StatsFrame
ShowStats2.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
ShowStats2.BackgroundTransparency = 1
ShowStats2.Position = UDim2.new(0, 55, 0, 0)
ShowStats2.Size = UDim2.new(0, 103, 0, 90)
ShowStats2.Font = Enum.Font.Fantasy
ShowStats2.TextColor3 = Color3.new(1, 1, 1)
ShowStats2.Text = "Stats"
ShowStats2.TextSize = 15
ShowStats2.TextXAlignment = Enum.TextXAlignment.Right

-- Close --

Open.MouseButton1Down:connect(function()
	TopFrame.Visible = false
	MainFrame.Visible = true
end)

Minimize.MouseButton1Down:connect(function()
	TopFrame.Visible = true
	MainFrame.Visible = false
end)

Close.MouseButton1Down:connect(function()
MainGUI:Destroy()
end)

-- Menus --

local Menus = {
	[WayPoints] = WayPointsFrame;
	[FarmExp] = FarmExpFrame;
	[Extras] = ExtrasFrame;
}
for button,frame in pairs(Menus) do
	button.MouseButton1Click:connect(function()
		if frame.Visible then
			frame.Visible = false
			return
		end
		for k,v in pairs(Menus) do
			v.Visible = v == frame
		end
	end)
end

FarmBody.MouseEnter:connect(function()
	FarmBodyLabel.Visible = true
end)

FarmBody.MouseLeave:connect(function()
	FarmBodyLabel.Visible = false
end)

FarmSpeed.MouseEnter:connect(function()
	FarmSpeedLabel.Visible = true
end)

FarmSpeed.MouseLeave:connect(function()
	FarmSpeedLabel.Visible = false
end)

FarmJump.MouseEnter:connect(function()
	FarmSpeedLabel.Visible = true
end)

FarmJump.MouseLeave:connect(function()
	FarmSpeedLabel.Visible = false
end)

farmbtsafety.MouseEnter:connect(function()
	farmbtsafetyText1.Visible = true
end)

farmbtsafety.MouseLeave:connect(function()
	farmbtsafetyText1.Visible = false
end)

InfoScreen.MouseEnter:connect(function()
	InfoText1.Visible = true
end)

InfoScreen.MouseLeave:connect(function()
	InfoText1.Visible = false
end)

c.MouseButton1Down:connect(function()
	cf.Visible = false
end)

-- Round Number to decimal places and convert to letter value --

function round(num, numDecimalPlaces)
	local mult = 10^(numDecimalPlaces or 0)
	return math.floor(num * mult + 0.5) / mult
end
		
function converttoletter(num)
	if num / 1e33 >=1 then
		newnum = num / 1e33
		return round(newnum, 6).. "Dc"
	elseif num / 1e30 >=1 then
		newnum = num / 1e30
		return round(newnum, 6).. "No"
    elseif num / 1e27 >=1 then
		newnum = num / 1e27
		return round(newnum, 6).. "Oc"
    elseif num / 1e24 >=1 then
		newnum = num / 1e24
		return round(newnum, 6).. "Sp"
    elseif num / 1e21 >=1 then
		newnum = num / 1e21
		return round(newnum, 6).. "Sx"
    elseif num / 1e18 >=1 then
		newnum = num / 1e18
		return round(newnum, 6).. "Qi"
	elseif num / 1e15 >=1 then
		newnum = num / 1e15
		return round(newnum, 6).. "Qa"
	elseif num / 1e12 >=1 then
		newnum = num / 1e12
		return round(newnum, 6).. "T"
	elseif num / 1e09 >=1 then
		newnum = num / 1e09
		return round(newnum, 6).. "B"
	elseif num / 1e06 >=1 then
		newnum = num / 1e06
		return round(newnum, 6).. "M"
	elseif num / 1e03 >=1 then
		newnum = num / 1e03
		return round(newnum, 6).. "K"
	else return num
	end
end

--- NoClip ---

NoClip.MouseButton1Down:connect(function()
	noclip = not noclip
	if noclip then
		NoClip.Text = "NoClip Mode: ON"
		NoClip.BackgroundColor3 = Color3.new(0, 0.5, 0)
	else
		NoClip.Text = "NoClip Mode: OFF"
		NoClip.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
	end
end)
game:GetService('RunService').Stepped:connect(function()
	if noclip then
		game.Players.LocalPlayer.Character.Humanoid:ChangeState(11)
	end
end)

--- Farm BT Safety ---

farmbtsafety.MouseButton1Down:connect(function()
	farmbtsafetyactive = not farmbtsafetyactive
	if farmbtsafetyactive then
		farmbtsafety.Text = "Safety Net: ON"
		farmbtsafety.BackgroundColor3 = Color3.new(0, 0.5, 0)
	else
		farmbtsafety.Text = "Safety Net: OFF"
		farmbtsafety.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
	end
end)

spawn(function()
	while true do
		if farmbtsafetyactive then
			while farmbtsafetyactive do
				local FindHum = game.Players.LocalPlayer.Character:WaitForChild("Humanoid")
				local currenthealth = tonumber(string.format("%.0f", FindHum.Health))
				local minhealth = tonumber(string.format("%.0f", FindHum.MaxHealth))*tonumber(farmbtsafetylevel.Text)/100
				-- print("Current Health: " ..tostring(currenthealth).. ". Min Health: " ..tostring(minhealth))
				if currenthealth <= minhealth then
					game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(459, 248, 887)
				end
			wait(0.2)
			end
		end
		wait(0.5)
	end
end)

-- Show Location --

local curlocation = coroutine.wrap(function()
	while true do
		LocationX = round(game.Players.LocalPlayer.Character.HumanoidRootPart.Position.x, 0)
		LocationY = round(game.Players.LocalPlayer.Character.HumanoidRootPart.Position.y, 0)
		LocationZ = round(game.Players.LocalPlayer.Character.HumanoidRootPart.Position.z, 0)
		ShowLocation.Text = "Coords: "..LocationX..", "..LocationY..", "..LocationZ
		wait(0.5)
	end
end)

curlocation()

-- Set Locations --

SetLocation.MouseButton1Down:connect(function()
	function round(num, numDecimalPlaces)
		local mult = 10^(numDecimalPlaces or 0)
		return math.floor(num * mult + 0.5) / mult
	end
	setlocationx = round(game.Players.LocalPlayer.Character.HumanoidRootPart.Position.x, 0)
	setlocationy = round(game.Players.LocalPlayer.Character.HumanoidRootPart.Position.y, 0)
	setlocationz = round(game.Players.LocalPlayer.Character.HumanoidRootPart.Position.z, 0)
	print("Set Custom Location: "..setlocationx..", "..setlocationy..", "..setlocationz)
    SetLocation.Text = setlocationx..","..setlocationy..","..setlocationz
	CustomLocationSet = true
end)

--- TP to custom location ---

TPLocation.MouseButton1Down:connect(function()
	if CustomLocationSet == true then
		workspace:WaitForChild(game.Players.LocalPlayer.Name).HumanoidRootPart.CFrame = CFrame.new(setlocationx, setlocationy, setlocationz)
		WayPointsFrame.Visible = false
	end
end)

Location1.MouseButton1Click:connect(function()
	game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(70232, 9322338, 83263)
	WayPointsFrame.Visible = false
end)
	
Location2.MouseButton1Click:connect(function()
	game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(409, 271, 978)
	WayPointsFrame.Visible = false
end)

LocationFS1B.MouseButton1Click:connect(function()
	game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(1176, 4789, -2293)
	WayPointsFrame.Visible = false
end)

LocationFS10T.MouseButton1Click:connect(function()
	game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-369, 15735, -9)
	WayPointsFrame.Visible = false
end)

LocationFS1Qa.MouseButton1Click:connect(function()
	game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(133, 17095, -432)
	WayPointsFrame.Visible = false
end)

LocationFS1Qi.MouseButton1Click:connect(function()
	game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-3869, 375, -2278)
	WayPointsFrame.Visible = false
end)

LocationFS1Sx.MouseButton1Click:connect(function()
	game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-2482, 28455, -1525)
	WayPointsFrame.Visible = false
end)

LocationFS1Sp.MouseButton1Click:connect(function()
	game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-855, 30080, -1051)
	WayPointsFrame.Visible = false
end)

LocationFS1So.MouseButton1Click:connect(function()
	game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-2482, 29072, -1541)
	WayPointsFrame.Visible = false
end)

LocationFS1No.MouseButton1Click:connect(function()
	game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-2366, 29521, 2200)
	WayPointsFrame.Visible = false
end)

LocationFS1Dc.MouseButton1Click:connect(function()
	game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-651, 32326, -9)
	WayPointsFrame.Visible = false
end)

LocationFS100B.MouseButton1Click:connect(function()
	game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(1381, 9274, 1647)
	WayPointsFrame.Visible = false
end)

Location7.MouseButton1Click:connect(function()
	game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-2279, 1944, 1053)
	WayPointsFrame.Visible = false
end)

Location3.MouseButton1Click:connect(function()
	game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(365, 249, -445)
	settplocation = "BT100Area"
	WayPointsFrame.Visible = false
end)

Location4.MouseButton1Click:connect(function()
	game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(349, 263, -490)
	settplocation = "BT10KArea"
	WayPointsFrame.Visible = false
end)

Location5.MouseButton1Click:connect(function()
	game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(1640, 258, 2244)
	settplocation = "BT100KArea"
	WayPointsFrame.Visible = false
end)

Location6.MouseButton1Click:connect(function()
	game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-2307, 976, 1068)
	settplocation = "BT1MArea"
	WayPointsFrame.Visible = false
end)

Location8.MouseButton1Click:connect(function()
	game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-2024, 714, -1860)
	settplocation = "BT10MArea"
	WayPointsFrame.Visible = false
end)

LocationBT1B.MouseButton1Click:connect(function()
	game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-254, 286, 980)
	settplocation = "BT1BArea"
	WayPointsFrame.Visible = false
end)

LocationBT100B.MouseButton1Click:connect(function()
	game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-271, 279, 991)
	settplocation = "BT100BArea"
	WayPointsFrame.Visible = false
end)

LocationBT10T.MouseButton1Click:connect(function()
	game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-279, 279, 1007)
	settplocation = "BT10TArea"
	WayPointsFrame.Visible = false
end)

LocationBT1Qa.MouseButton1Click:connect(function()
	game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-373, 241, 1389)
	settplocation = "BT1QaArea"
	WayPointsFrame.Visible = false
end)

LocationBT1Qi.MouseButton1Click:connect(function()
	game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-5439, 2290, 1488)
	settplocation = "BT1QiArea"
	WayPointsFrame.Visible = false
end)

LocationBT1Sx.MouseButton1Click:connect(function()
	game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-6854, 15109, -2063)
	settplocation = "BT1SxArea"
	WayPointsFrame.Visible = false
end)

LocationBT1Sp.MouseButton1Click:connect(function()
	game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-2463, 27951, -1641)
	settplocation = "BT1SpArea"
	WayPointsFrame.Visible = false
end)

LocationBT1Oc.MouseButton1Click:connect(function()
	game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-2468, 27955, -1483)
	settplocation = "BT1OcArea"
	WayPointsFrame.Visible = false
end)

LocationBT1No.MouseButton1Click:connect(function()
	game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-2361, 29318, 1799)
	settplocation = "BT1NoArea"
	WayPointsFrame.Visible = false
end)

LocationBT1Dc.MouseButton1Click:connect(function()
	game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-2293, 29319, 2102)
	settplocation = "BT1NoArea"
	WayPointsFrame.Visible = false
end)

LocationPP1M.MouseButton1Click:connect(function()
	game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-2527, 5486, -532)
	settplocation = "PP1MArea"
	WayPointsFrame.Visible = false
end)

LocationPP1B.MouseButton1Click:connect(function()
	game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-2560, 5500, -439)
	settplocation = "PP1BArea"
	WayPointsFrame.Visible = false
end)

LocationPP1T.MouseButton1Click:connect(function()
	game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-2583, 5516, -501)
	settplocation = "PP1TArea"
	WayPointsFrame.Visible = false
end)

LocationPP1Qa.MouseButton1Click:connect(function()
	game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-2544, 5412, -495)
	settplocation = "PP1QaArea"
	WayPointsFrame.Visible = false
end)

LocationPP1Qi.MouseButton1Click:connect(function()
	game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-2639, 5576, -426)
	settplocation = "PP1QiArea"
	WayPointsFrame.Visible = false
end)

LocationPP1Sx.MouseButton1Click:connect(function()
	game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-2348, 239, -376)
	settplocation = "PP1SxArea"
	WayPointsFrame.Visible = false
end)

LocationPP1Sp.MouseButton1Click:connect(function()
	game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(2345, 24923, -1610)
	settplocation = "PP1SpArea"
	WayPointsFrame.Visible = false
end)

LocationPP1Oc.MouseButton1Click:connect(function()
	game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-2728, 27996, -1562)
	settplocation = "PP1OcArea"
	WayPointsFrame.Visible = false
end)

LocationPP1No.MouseButton1Click:connect(function()
	game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-5182, 28489, -5317)
	settplocation = "PP1NoArea"
	WayPointsFrame.Visible = false
end)

LocationPP1Dc.MouseButton1Click:connect(function()
	game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(284, 28697, 3588)
	settplocation = "PP1NoArea"
	WayPointsFrame.Visible = false
end)

-- ESP Кнопка (тепер керує новим ESP) --

esptrack.MouseButton1Click:connect(function()
    ESP_SETTINGS.Enabled = not ESP_SETTINGS.Enabled
    
    if ESP_SETTINGS.Enabled then
        esptrack.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
        esptrack.Text = "ESP: ON"
    else
        esptrack.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
        esptrack.Text = "ESP: OFF"
        
        -- Повне очищення всіх об'єктів ESP з пам'яті
        for _, v in pairs(game:GetService("Players"):GetPlayers()) do
            local find = game:GetService("CoreGui"):FindFirstChild("ESP_" .. v.Name)
            if find then 
                find:Destroy() 
            end
        end
    end
end)

-- Автоматичне оновлення ESP
spawn(function()
    while true do
        if ESP_SETTINGS.Enabled then
            UpdateESP()
        end
        wait(0.1)
    end
end)

-- Farm Exp --

FarmAll.MouseButton1Click:Connect(function()
	if farmallactive ~= true then
		farmallactive = true
		farmfistactive = true
		farmbodyactive = true
		farmspeedactive = true
		farmpsychicactive = true
		farmjumpactive = true
		FarmAll.BackgroundColor3 = Color3.new(0, 0.5, 0)
		FarmAll.Text = "Farm All: ON"
		FarmExp.BackgroundColor3 = Color3.new(0, 0.5, 0)
	else
		farmallactive = false
		farmfistactive = false
		farmbodyactive = false
		farmspeedactive = false
		farmpsychicactive = false
		farmjumpactive = false
		FarmFist.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
		FarmBody.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
		FarmSpeed.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
		FarmJump.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
		FarmPsychic.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
		FarmAll.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
		FarmAll.Text = "Farm All: OFF"
		FarmExp.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
	end
end)

FarmFist.MouseButton1Click:Connect(function()
	if farmfistactive ~= true then
		farmfistactive = true
		FarmFist.BackgroundColor3 = Color3.new(0, 0.5, 0)
		FarmFist.Text = "Farm Fist Strength: ON"
		FarmExp.BackgroundColor3 = Color3.new(0, 0.5, 0)
	else
		farmfistactive = false
		FarmFist.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
		FarmFist.Text = "Farm Fist Strength: OFF"
		FarmExp.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
	end
end)

FarmBody.MouseButton1Click:Connect(function()
	if farmbodyactive ~= true then
		farmbodyactive = true
		FarmBody.BackgroundColor3 = Color3.new(0, 0.5, 0)
		FarmBody.Text = "Farm Body Strength: ON"
		FarmExp.BackgroundColor3 = Color3.new(0, 0.5, 0)
	else
		farmbodyactive = false
		FarmBody.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
		FarmBody.Text = "Farm Body Strength: OFF"
		FarmExp.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
	end
end)

FarmSpeed.MouseButton1Click:Connect(function()
	if farmspeedactive ~= true then
		farmspeedactive = true
		FarmSpeed.BackgroundColor3 = Color3.new(0, 0.5, 0)
		FarmSpeed.Text = "Farm Speed Strength: ON"
		FarmExp.BackgroundColor3 = Color3.new(0, 0.5, 0)
	else
		farmspeedactive = false
		FarmSpeed.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
		FarmSpeed.Text = "Farm Speed Strength: OFF"
		FarmExp.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
	end
end)

FarmJump.MouseButton1Click:Connect(function()
	if farmjumpactive ~= true then
		farmjumpactive = true
		FarmJump.BackgroundColor3 = Color3.new(0, 0.5, 0)
		FarmJump.Text = "Farm Jump Strength: ON"
		FarmExp.BackgroundColor3 = Color3.new(0, 0.5, 0)
	else
		farmjumpactive = false
		FarmJump.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
		FarmJump.Text = "Farm Jump Strength: OFF"
		FarmExp.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
	end
end)

FarmPsychic.MouseButton1Click:Connect(function()
	if farmpsychicactive ~= true then
		farmpsychicactive = true
		FarmPsychic.BackgroundColor3 = Color3.new(0, 0.5, 0)
		FarmPsychic.Text = "Farm Psychic Strength: ON"
		FarmExp.BackgroundColor3 = Color3.new(0, 0.5, 0)
	else
		farmpsychicactive = false
		FarmPsychic.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
		FarmPsychic.Text = "Farm Psychic Strength: OFF"
		FarmExp.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
	end
end)

-- Авто-фарм кулаків (Fist Strength) --
spawn(function()
    local lastFSZone = "" -- Відстеження зони кулаків

    while true do
        if farmfistactive then
            local lp = game.Players.LocalPlayer
            local char = lp.Character
            local stats = lp:GetAttribute("FistStrength") or 0
            local remoteEvents = game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvents")

            if char and char:FindFirstChild("HumanoidRootPart") then
                local hrp = char.HumanoidRootPart
                local currentFSZone = ""

                -- Логіка ТП за твоїми координатами
                if stats >= 1e18 then
                    currentFSZone = "FS1Qi"
                    if lastFSZone ~= currentFSZone then hrp.CFrame = CFrame.new(-3869, 375, -2278) end
                elseif stats >= 1e15 then -- 10 T
                    currentFSZone = "FS1Qa"
                    if lastFSZone ~= currentFSZone then hrp.CFrame = CFrame.new(113, 17095, -419) end
                elseif stats >= 1e13 then -- 10 T
                    currentFSZone = "FS10T"
                    if lastFSZone ~= currentFSZone then hrp.CFrame = CFrame.new(-369, 15735, -9) end
                elseif stats >= 1e11 then -- 100 B
                    currentFSZone = "FS100B"
                    if lastFSZone ~= currentFSZone then hrp.CFrame = CFrame.new(1381, 9274, 1647) end
                elseif stats >= 1e09 then -- 1 B
                    currentFSZone = "FS1B"
                    if lastFSZone ~= currentFSZone then hrp.CFrame = CFrame.new(1176, 4789, -2293) end
                elseif stats >= 1000 then -- 1 K
                    currentFSZone = "FS1K"
                    if lastFSZone ~= currentFSZone then hrp.CFrame = CFrame.new(-2279, 1944, 1053) end
                else -- Локація 0
                    currentFSZone = "FS0"
                    if lastFSZone ~= currentFSZone then hrp.CFrame = CFrame.new(409, 271, 978) end
                end

                if currentFSZone ~= "" then lastFSZone = currentFSZone end

                -- НАДСИЛАЄМО СИГНАЛ ТРЕНУВАННЯ
                if remoteEvents and remoteEvents:FindFirstChild("FS_Train") then
                    remoteEvents.FS_Train:FireServer()
                end
            end
        else
            lastFSZone = "" -- Скидаємо зону
        end
        task.wait(0.1)
    end
end)

-- Авто-фарм тіла (Body Toughness) --
spawn(function()
    local lastBTZone = ""
    local lastTeleportTime = 0
    local TELEPORT_INTERVAL = 10 -- 2 хвилини

    while true do
        if farmbodyactive then
    local lp = game.Players.LocalPlayer
    local char = lp.Character
    local humanoid = char and char:FindFirstChildOfClass("Humanoid")
    local stats = humanoid and humanoid.Health or 0
    local remoteEvents = game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvents")

    if char and char:FindFirstChild("HumanoidRootPart") then
        local hrp = char.HumanoidRootPart
        local currentBTZone = ""
        local now = os.clock()


                -- 🔁 ТЕЛЕПОРТ ТІЛЬКИ РАЗ НА 2 ХВ
                if now - lastTeleportTime >= TELEPORT_INTERVAL then

                    if stats >= 5e17 then
                        currentBTZone = "BT1Qi"
                        hrp.CFrame = CFrame.new(-5439, 2290, 1488)
                    elseif stats >= 5e14 then
                        currentBTZone = "BT1Qa"
                        hrp.CFrame = CFrame.new(-373, 241, 1389)
                    elseif stats >= 5e12 then
                        currentBTZone = "BT10T"
                        hrp.CFrame = CFrame.new(-279, 279, 1007)
                    elseif stats >= 5e10 then
                        currentBTZone = "BT100B"
                        hrp.CFrame = CFrame.new(-271, 279, 991)
                    elseif stats >= 5e08 then
                        currentBTZone = "BT1B"
                        hrp.CFrame = CFrame.new(-254, 286, 980)
                    elseif stats >= 5e06 then
                        currentBTZone = "BT10M"
                        hrp.CFrame = CFrame.new(-2024, 714, -1860)
                    elseif stats >= 5e05 then
                        currentBTZone = "BT1M"
                        hrp.CFrame = CFrame.new(-2307, 976, 1068)
                    elseif stats >= 5e04 then
                        currentBTZone = "BT100K"
                        hrp.CFrame = CFrame.new(1640, 258, 2244)
                    elseif stats >= 5e03 then
                        currentBTZone = "BT10K"
                        hrp.CFrame = CFrame.new(349, 263, -490)
                    elseif stats >= 50 then
                        currentBTZone = "BT100"
                        hrp.CFrame = CFrame.new(365, 249, -445)
                    end

                    lastBTZone = currentBTZone
                    lastTeleportTime = now
                end

                -- 🏋️ ПОСТІЙНИЙ ФАРМ
                if remoteEvents and remoteEvents:FindFirstChild("BT_Train") then
                    remoteEvents.BT_Train:FireServer()
                end
            end
        else
            -- ❌ Кнопку вимкнули → повний скидон
            lastBTZone = ""
            lastTeleportTime = 0
        end

        task.wait(0.1)
    end
end)


spawn(function()
    while true do
        if farmspeedactive then
            local remoteEvents = game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvents")
            if remoteEvents and remoteEvents:FindFirstChild("MS_Train") then
                remoteEvents.MS_Train:FireServer()
            end
        end
        task.wait(0.1)
    end
end)

spawn(function()
    while true do
        if farmjumpactive then
            local lp = game.Players.LocalPlayer
            local char = lp.Character
            local hum = char and char:FindFirstChild("Humanoid")
            local remoteEvents = game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvents")
            
            if hum and remoteEvents and remoteEvents:FindFirstChild("JF_Train") then
                -- 1. ТИМЧАСОВО ВИМИКАЄМО ФІЗИКУ ПІДКИДАННЯ
                hum.PlatformStand = true 
                
                -- 2. ЗМІНЮЄМО СТАН (Гра думає, що ми в повітрі, але ми не летимо вгору)
                hum:ChangeState(Enum.HumanoidStateType.Freefall)
                
                -- 3. НАДСИЛАЄМО СИГНАЛ
                remoteEvents.JF_Train:FireServer()
                
                -- 4. ПОВЕРТАЄМО СТАН НА СЕКУНДУ (щоб сервер побачив "цикл" стрибка)
                task.wait(0.05)
                hum:ChangeState(Enum.HumanoidStateType.Landed)
                
                -- Повертаємо можливість ходити
                hum.PlatformStand = false
            end
        end
        
        -- Затримка між "уявними" стрибками
        task.wait(0.1)
    end
end)
-- Авто-фарм психіки (Тільки активація) --
-- Функція для безпечного використання предметів --
local function equipTool(toolName)
    local player = game.Players.LocalPlayer
    local tool = player.Backpack:FindFirstChild(toolName) or player.Character:FindFirstChild(toolName)
    if tool and not player.Character:FindFirstChild(toolName) then
        player.Character.Humanoid:EquipTool(tool)
    end
    return tool
end

-- ОБ'ЄДНАНИЙ ЦИКЛ ФАРМУ --
spawn(function()
    local isActive = false -- Локальна змінна для контролю одноразової дії

    while true do
        if farmpsychicactive then
            if not isActive then
                local lp = game.Players.LocalPlayer
                local char = lp.Character
                
                if char and char:FindFirstChild("HumanoidRootPart") then
                    local hrp = char.HumanoidRootPart
                    local stats = lp:GetAttribute("PsychicPower") or 0
                    
                    -- 1. ТЕЛЕПОРТ (ОДНОРАЗОВО)
                    if stats >= 1e330 then hrp.CFrame = CFrame.new(284, 28697, 3588)
                    elseif stats >= 1e330 then hrp.CFrame = CFrame.new(-5182, 28489, -5317)
                    elseif stats >= 1e330 then hrp.CFrame = CFrame.new(-2728, 27996, -1562)
                    elseif stats >= 1e330 then hrp.CFrame = CFrame.new(2345, 24923, -1610)
                    elseif stats >= 1e21 then hrp.CFrame = CFrame.new(-2348, 241, -376)  
                    elseif stats >= 1e18 then hrp.CFrame = CFrame.new(-2639, 5576, -426)
                    elseif stats >= 1e15 then hrp.CFrame = CFrame.new(-2544, 5412, -495)
                    elseif stats >= 1e12 then hrp.CFrame = CFrame.new(-2583, 5516, -501)
                    elseif stats >= 1e09 then hrp.CFrame = CFrame.new(-2560, 5500, -439)
                    elseif stats >= 1e06 then hrp.CFrame = CFrame.new(-2527, 5486, -532)
                    end
                    
                    -- 2. ВЗЯТИ ПРЕДМЕТ В РУКИ
                    -- (Використовуємо твою функцію equipTool)
                    equipTool("PsychicPower")
                    
                    isActive = true -- Позначаємо, що ТП і екіпірування виконано
                end
            end
        else
            -- Якщо вимкнули кнопку — скидаємо стан
            if isActive then
                isActive = false
            end
        end
        task.wait(0.5)
    end
end)

-- Return to position on Death --

DeathReturn.MouseButton1Click:Connect(function()
	if deathreturnactive ~= true then
		deathreturnactive = true
		DeathReturn.BackgroundColor3 = Color3.new(0, 0.5, 0)
		DeathReturn.Text = "OnDeath Return: ON"
	else
		deathreturnactive = false
		DeathReturn.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
		DeathReturn.Text = "OnDeath Return: OFF"
	end
end)

local lp = game.Players.LocalPlayer
local RS = game:GetService("ReplicatedStorage")
local RemoteEvents = RS:WaitForChild("RemoteEvents")

local lastPosBeforeDeath = nil

-- Функція для примусового телепорту (Force Teleport)
local function forceTeleport(character)
    if deathreturnactive and lastPosBeforeDeath then
        local hrp = character:WaitForChild("HumanoidRootPart", 10)
        if hrp then
            -- Циклічний телепорт для обходу захисту спавну
            -- Намагаємось телепортувати 10 разів протягом 2 секунд
            for i = 1, 10 do
                hrp.CFrame = lastPosBeforeDeath
                task.wait(0.2)
                -- Якщо ми вже далеко від спавну, можна зупинити цикл
                if (hrp.Position - lastPosBeforeDeath.Position).Magnitude < 5 then
                    break
                end
            end
            print("Телепортація завершена успішно!")
        end
    end
end

-- Слідкуємо за появою персонажа
lp.CharacterAdded:Connect(forceTeleport)

-- ... (ваш код з кнопкою залишається таким самим)

spawn(function()
    while true do
        -- Якщо скрипт вимкнено, просто чекаємо і нічого не робимо
        if not deathreturnactive then 
            task.wait(1) 
            continue 
        end

        local char = lp.Character
        local hum = char and char:FindFirstChild("Humanoid")
        local hrp = char and char:FindFirstChild("HumanoidRootPart")

        -- 1. ЛОГІКА ПІД ЧАС ЖИТТЯ
        if char and hum and hrp and hum.Health > 0 then
            -- Зберігаємо позицію
            lastPosBeforeDeath = hrp.CFrame
            
            if SavePosition then
                local p = hrp.Position
                SavePosition.Text = string.format("Last Place: %.1f, %.1f, %.1f", p.X, p.Y, p.Z)
            end
            
            -- Авто-респавн на 50% HP (тільки якщо включено)
            if hum.Health < (hum.MaxHealth * 0.5) then
                RemoteEvents.RefreshCharacter:FireServer()
                task.wait(1) -- Збільшив затримку, щоб не спамити
            end
        end
        
        -- 2. АВТО-КЛІК КНОПКИ SPAWN (тепер тільки якщо deathreturnactive == true)
        local playerGui = lp:WaitForChild("PlayerGui")
        local intro = playerGui:FindFirstChild("IntroGui") or playerGui:FindFirstChild("ChristmasIntroGui")
        
        if intro and intro.Enabled then
            -- Викликаємо івент спавну
            RemoteEvents.RefreshCharacter:FireServer()
            
            -- Очищаємо екран
            intro.Enabled = false
            if game.Lighting:FindFirstChild("Blur") then
                game.Lighting.Blur.Size = 0
            end
            workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
            
            -- Вмикаємо ігрові інтерфейси
            for _, v in pairs({"MainGui", "QuestsGui", "SkillCooldowns", "ScreenGui",}) do
                local g = playerGui:FindFirstChild(v)
                if g then g.Enabled = true end
            end
        end

        task.wait(0.3)
    end
end)

-- Annoy Player --

AnnoyStart.MouseButton1Click:Connect(function()
	if annoyplayeractive ~= true then
		annoyplayeractive = true
		AnnoyStart.BackgroundColor3 = Color3.new(0, 0.5, 0)
		AnnoyStart.Text = "TP Spam Player: ON"
	else
		annoyplayeractive = false
		AnnoyStart.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
		AnnoyStart.Text = "TP Spam Player: OFF"
	end
end)

spawn(function()
	while true do
		wait(0.5)
		if annoyplayeractive then
			for i,v in pairs(game:GetService("Players"):GetChildren()) do
				if v.Name:lower():find(AnnoyName.Text:lower()) then
					player = game.Players.LocalPlayer.Character
					local startpos = player.HumanoidRootPart.CFrame
					v.Character.Humanoid.Died:connect(function()
						annoyplayeractive = false
						AnnoyStart.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
						AnnoyStart.Text = "TP Spam Player: OFF"
					end)
					player.Humanoid.Died:connect(function()
						annoyplayeractive = false
						AnnoyStart.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
						AnnoyStart.Text = "TP Spam Player: OFF"
					end)
					while annoyplayeractive == true do
						player.HumanoidRootPart.CFrame = v.Character.HumanoidRootPart.CFrame
						wait(.005)
					end
					player.HumanoidRootPart.CFrame = startpos
				end
			end
		end
	end
end)

TptoPlayer.MouseButton1Click:Connect(function()
	for i,v in pairs(game:GetService("Players"):GetChildren()) do
		if v.Name:lower():find(AnnoyName.Text:lower()) then
			if v.Name ~= tostring(MyPlr.Name) then
				player = game.Players.LocalPlayer.Character
				player.HumanoidRootPart.CFrame = v.Character.HumanoidRootPart.CFrame * CFrame.new(3, 0, 3)
			end
		end
	end
end)

mouse.KeyDown:connect(function(key)
	if key == tostring(PanicToggle.Text) then
		game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(459, 248, 887)
	end
end)

-- Server Player Stats --

PlayerInfo.MouseButton1Click:connect(function()
	if not showtopplayersactive then
		showtopplayersactive = true
		showtopplayersfistactive = true
		showtopplayersbodyactive = true
		showtopplayersspeedactive = true
		showtopplayersjumpactive = true
		showtopplayerspsychicactive = true
		PlayerInfoStatsFrame.Visible = true
	else
		showtopplayersactive = false
		PlayerInfoStatsFrame.Visible = false
		showtopplayersfistactive = false
		showtopplayersbodyactive = false
		showtopplayersspeedactive = false
		showtopplayersjumpactive = false
		showtopplayerspsychicactive = false
	end
end)

PlayerInfoStatsClose.MouseButton1Click:connect(function()
	showtopplayersactive = false
	PlayerInfoStatsFrame.Visible = false
	showtopplayersfistactive = false
	showtopplayersbodyactive = false
	showtopplayersspeedactive = false
	showtopplayersjumpactive = false
	showtopplayerspsychicactive = false
end)

spawn(function()
	while true do
		if showtopplayersfistactive then
			BestPlayerFist = 1
			PlayerFistName = false
			for i,v in pairs(game:GetService("Players"):GetChildren()) do
				local PlayerFist = tonumber(game.Players[v.Name].PrivateStats.FistStrength.Value)
				if PlayerFist > tonumber(BestPlayerFist) then 
					BestPlayerFist = PlayerFist
					PlayerFistName = tostring(v.Name)
				end
			end
			StatBestFistText1.Text = "Fist: " ..tostring(PlayerFistName)
			local fistplrStatus = game.Players[PlayerFistName].leaderstats.Status
			if fistplrStatus.Value == "Criminal" then
				StatBestFistText1.TextColor3 = Color3.new(1, 0.1, 1)
			elseif fistplrStatus.Value == "Lawbreaker" then
				StatBestFistText1.TextColor3 = Color3.new(1, 0.1, 0.1)
			elseif fistplrStatus.Value == "Guardian" then
				StatBestFistText1.TextColor3 = Color3.new(0.1, 0.8, 1)
			elseif fistplrStatus.Value == "Protector" then
				StatBestFistText1.TextColor3 = Color3.new(0.1, 0.1, 1)
			elseif fistplrStatus.Value == "Supervillain" then
				StatBestFistText1.TextColor3 = Color3.new(0.3, 0.1, 0.1)
			elseif fistplrStatus.Value == "Superhero" then
				StatBestFistText1.TextColor3 = Color3.new(0.8, 0.8, 0)
			else
				StatBestFistText1.TextColor3 = Color3.new(1, 1, 1)
			end
			local FindHum = game.Players[PlayerFistName].Character.Humanoid
			local FistPlayerHealth = converttoletter(string.format("%.0f", FindHum.Health))
			local FistPlayerFist = converttoletter(string.format("%.0f", game.Players[PlayerFistName].PrivateStats.FistStrength.Value))
			local FistPlayerBody = converttoletter(string.format("%.0f", game.Players[PlayerFistName].PrivateStats.BodyToughness.Value))
			local FistPlayerSpeed = converttoletter(string.format("%.0f", game.Players[PlayerFistName].PrivateStats.MovementSpeed.Value))
			local FistPlayerJump = converttoletter(string.format("%.0f", game.Players[PlayerFistName].PrivateStats.JumpForce.Value))
			local FistPlayerPsychic = converttoletter(string.format("%.0f", game.Players[PlayerFistName].PrivateStats.PsychicPower.Value))
			ShowStatsFist2.Text = tostring(FistPlayerHealth.. "\n" ..FistPlayerFist.. "\n" ..FistPlayerBody.. "\n" ..FistPlayerSpeed.. "\n" ..FistPlayerJump.. "\n" ..FistPlayerPsychic)
		end
		wait(0.3)
	end
end)

spawn(function()
	while true do
		if showtopplayersbodyactive then
			BestPlayerBody = 1
			PlayerBodyName = false
			for i,v in pairs(game:GetService("Players"):GetChildren()) do
				local PlayerBody = tonumber(game.Players[v.Name].PrivateStats.BodyToughness.Value)
				if PlayerBody > tonumber(BestPlayerBody) then 
					BestPlayerBody = PlayerBody
					PlayerBodyName = tostring(v.Name)
				end
			end
			StatBestBodyText1.Text = "Body: " ..tostring(PlayerBodyName)
			local bodyplrStatus = game.Players[PlayerBodyName].leaderstats.Status
			if bodyplrStatus.Value == "Criminal" then
				StatBestBodyText1.TextColor3 = Color3.new(1, 0.1, 1)
			elseif bodyplrStatus.Value == "Lawbreaker" then
				StatBestBodyText1.TextColor3 = Color3.new(1, 0.1, 0.1)
			elseif bodyplrStatus.Value == "Guardian" then
				StatBestBodyText1.TextColor3 = Color3.new(0.1, 0.8, 1)
			elseif bodyplrStatus.Value == "Protector" then
				StatBestBodyText1.TextColor3 = Color3.new(0.1, 0.1, 1)
			elseif bodyplrStatus.Value == "Supervillain" then
				StatBestBodyText1.TextColor3 = Color3.new(0.3, 0.1, 0.1)
			elseif bodyplrStatus.Value == "Superhero" then
				StatBestBodyText1.TextColor3 = Color3.new(0.8, 0.8, 0)
			else
				StatBestBodyText1.TextColor3 = Color3.new(1, 1, 1)
			end
			local FindHum = game.Players[PlayerBodyName].Character.Humanoid
			local BodyPlayerHealth = converttoletter(string.format("%.0f", FindHum.Health))
			local BodyPlayerFist = converttoletter(string.format("%.0f", game.Players[PlayerBodyName].PrivateStats.FistStrength.Value))
			local BodyPlayerBody = converttoletter(string.format("%.0f", game.Players[PlayerBodyName].PrivateStats.BodyToughness.Value))
			local BodyPlayerSpeed = converttoletter(string.format("%.0f", game.Players[PlayerBodyName].PrivateStats.MovementSpeed.Value))
			local BodyPlayerJump = converttoletter(string.format("%.0f", game.Players[PlayerBodyName].PrivateStats.JumpForce.Value))
			local BodyPlayerPsychic = converttoletter(string.format("%.0f", game.Players[PlayerBodyName].PrivateStats.PsychicPower.Value))
			ShowStatsBody2.Text = tostring(BodyPlayerHealth.. "\n" ..BodyPlayerFist.. "\n" ..BodyPlayerBody.. "\n" ..BodyPlayerSpeed.. "\n" ..BodyPlayerJump.. "\n" ..BodyPlayerPsychic)
		end
		wait(0.3)
	end
end)

spawn(function()
	while true do
		if showtopplayersspeedactive then
			BestPlayerSpeed = 1
			PlayerSpeedName = false
			for i,v in pairs(game:GetService("Players"):GetChildren()) do
				local PlayerSpeed = tonumber(game.Players[v.Name].PrivateStats.MovementSpeed.Value)
				if PlayerSpeed > tonumber(BestPlayerSpeed) then 
					BestPlayerSpeed = PlayerSpeed
					PlayerSpeedName = tostring(v.Name)
				end
			end
			StatBestSpeedText1.Text = "Speed: " ..tostring(PlayerSpeedName)
			local speedplrStatus = game.Players[PlayerSpeedName].leaderstats.Status
			if speedplrStatus.Value == "Criminal" then
				StatBestSpeedText1.TextColor3 = Color3.new(1, 0.1, 1)
			elseif speedplrStatus.Value == "Lawbreaker" then
				StatBestSpeedText1.TextColor3 = Color3.new(1, 0.1, 0.1)
			elseif speedplrStatus.Value == "Guardian" then
				StatBestSpeedText1.TextColor3 = Color3.new(0.1, 0.8, 1)
			elseif speedplrStatus.Value == "Protector" then
				StatBestSpeedText1.TextColor3 = Color3.new(0.1, 0.1, 1)
			elseif speedplrStatus.Value == "Supervillain" then
				StatBestSpeedText1.TextColor3 = Color3.new(0.3, 0.1, 0.1)
			elseif speedplrStatus.Value == "Superhero" then
				StatBestSpeedText1.TextColor3 = Color3.new(0.8, 0.8, 0)
			else
				StatBestSpeedText1.TextColor3 = Color3.new(1, 1, 1)
			end
			local FindHum = game.Players[PlayerSpeedName].Character.Humanoid
			local SpeedPlayerHealth = converttoletter(string.format("%.0f", FindHum.Health))
			local SpeedPlayerFist = converttoletter(string.format("%.0f", game.Players[PlayerSpeedName].PrivateStats.FistStrength.Value))
			local SpeedPlayerBody = converttoletter(string.format("%.0f", game.Players[PlayerSpeedName].PrivateStats.BodyToughness.Value))
			local SpeedPlayerSpeed = converttoletter(string.format("%.0f", game.Players[PlayerSpeedName].PrivateStats.MovementSpeed.Value))
			local SpeedPlayerJump = converttoletter(string.format("%.0f", game.Players[PlayerSpeedName].PrivateStats.JumpForce.Value))
			local SpeedPlayerPsychic = converttoletter(string.format("%.0f", game.Players[PlayerSpeedName].PrivateStats.PsychicPower.Value))
			ShowStatsSpeed2.Text = tostring(SpeedPlayerHealth.. "\n" ..SpeedPlayerFist.. "\n" ..SpeedPlayerBody.. "\n" ..SpeedPlayerSpeed.. "\n" ..SpeedPlayerJump.. "\n" ..SpeedPlayerPsychic)
		end
		wait(0.3)
	end
end)

spawn(function()
	while true do
		if showtopplayersjumpactive then
			BestPlayerJump = 1
			PlayerJumpName = false
			for i,v in pairs(game:GetService("Players"):GetChildren()) do
				local PlayerJump = tonumber(game.Players[v.Name].PrivateStats.JumpForce.Value)
				if PlayerJump > tonumber(BestPlayerJump) then 
					BestPlayerJump = PlayerJump
					PlayerJumpName = tostring(v.Name)
				end
			end
			StatBestJumpText1.Text = "Jump: " ..tostring(PlayerJumpName)
			local JumpplrStatus = game.Players[PlayerJumpName].leaderstats.Status
			if JumpplrStatus.Value == "Criminal" then
				StatBestJumpText1.TextColor3 = Color3.new(1, 0.1, 1)
			elseif JumpplrStatus.Value == "Lawbreaker" then
				StatBestJumpText1.TextColor3 = Color3.new(1, 0.1, 0.1)
			elseif JumpplrStatus.Value == "Guardian" then
				StatBestJumpText1.TextColor3 = Color3.new(0.1, 0.8, 1)
			elseif JumpplrStatus.Value == "Protector" then
				StatBestJumpText1.TextColor3 = Color3.new(0.1, 0.1, 1)
			elseif JumpplrStatus.Value == "Supervillain" then
				StatBestJumpText1.TextColor3 = Color3.new(0.3, 0.1, 0.1)
			elseif JumpplrStatus.Value == "Superhero" then
				StatBestJumpText1.TextColor3 = Color3.new(0.8, 0.8, 0)
			else
				StatBestJumpText1.TextColor3 = Color3.new(1, 1, 1)
			end
			local FindHum = game.Players[PlayerJumpName].Character.Humanoid
			local JumpPlayerHealth = converttoletter(string.format("%.0f", FindHum.Health))
			local JumpPlayerFist = converttoletter(string.format("%.0f", game.Players[PlayerJumpName].PrivateStats.FistStrength.Value))
			local JumpPlayerBody = converttoletter(string.format("%.0f", game.Players[PlayerJumpName].PrivateStats.BodyToughness.Value))
			local JumpPlayerSpeed = converttoletter(string.format("%.0f", game.Players[PlayerJumpName].PrivateStats.MovementSpeed.Value))
			local JumpPlayerJump = converttoletter(string.format("%.0f", game.Players[PlayerJumpName].PrivateStats.JumpForce.Value))
			local JumpPlayerPsychic = converttoletter(string.format("%.0f", game.Players[PlayerJumpName].PrivateStats.PsychicPower.Value))
			ShowStatsJump2.Text = tostring(JumpPlayerHealth.. "\n" ..JumpPlayerFist.. "\n" ..JumpPlayerBody.. "\n" ..JumpPlayerSpeed.. "\n" ..JumpPlayerJump.. "\n" ..JumpPlayerPsychic)
		end
		wait(0.3)
	end
end)

spawn(function()
	while true do
		if showtopplayerspsychicactive then
			BestPlayerPsychic = 1
			PlayerPsychicName = false
			for i,v in pairs(game:GetService("Players"):GetChildren()) do
				local PlayerPsychic = tonumber(game.Players[v.Name].PrivateStats.PsychicPower.Value)
				if PlayerPsychic > tonumber(BestPlayerPsychic) then 
					BestPlayerPsychic = PlayerPsychic
					PlayerPsychicName = tostring(v.Name)
				end
			end
			StatBestPsychicText1.Text = "Psy: " ..tostring(PlayerPsychicName)
			local PsychicplrStatus = game.Players[PlayerPsychicName].leaderstats.Status
			if PsychicplrStatus.Value == "Criminal" then
				StatBestPsychicText1.TextColor3 = Color3.new(1, 0.1, 1)
			elseif PsychicplrStatus.Value == "Lawbreaker" then
				StatBestPsychicText1.TextColor3 = Color3.new(1, 0.1, 0.1)
			elseif PsychicplrStatus.Value == "Guardian" then
				StatBestPsychicText1.TextColor3 = Color3.new(0.1, 0.8, 1)
			elseif PsychicplrStatus.Value == "Protector" then
				StatBestPsychicText1.TextColor3 = Color3.new(0.1, 0.1, 1)
			elseif PsychicplrStatus.Value == "Supervillain" then
				StatBestPsychicText1.TextColor3 = Color3.new(0.3, 0.1, 0.1)
			elseif PsychicplrStatus.Value == "Superhero" then
				StatBestPsychicText1.TextColor3 = Color3.new(0.8, 0.8, 0)
			else
				StatBestPsychicText1.TextColor3 = Color3.new(1, 1, 1)
			end
			local FindHum = game.Players[PlayerPsychicName].Character.Humanoid
			local PsychicPlayerHealth = converttoletter(string.format("%.0f", FindHum.Health))
			local PsychicPlayerFist = converttoletter(string.format("%.0f", game.Players[PlayerPsychicName].PrivateStats.FistStrength.Value))
			local PsychicPlayerBody = converttoletter(string.format("%.0f", game.Players[PlayerPsychicName].PrivateStats.BodyToughness.Value))
			local PsychicPlayerSpeed = converttoletter(string.format("%.0f", game.Players[PlayerPsychicName].PrivateStats.MovementSpeed.Value))
			local PsychicPlayerJump = converttoletter(string.format("%.0f", game.Players[PlayerPsychicName].PrivateStats.JumpForce.Value))
			local PsychicPlayerPsychic = converttoletter(string.format("%.0f", game.Players[PlayerPsychicName].PrivateStats.PsychicPower.Value))
			ShowStatsPsychic2.Text = tostring(PsychicPlayerHealth.. "\n" ..PsychicPlayerFist.. "\n" ..PsychicPlayerBody.. "\n" ..PsychicPlayerSpeed.. "\n" ..PsychicPlayerJump.. "\n" ..PsychicPlayerPsychic)
		end
		wait(0.3)
	end
end)

-- Функція для конвертації секунд у часові проміжки
local function formatTime(seconds)
    if seconds <= 0 then return "0s" end
    
    local years = math.floor(seconds / (365 * 24 * 3600))
    seconds = seconds % (365 * 24 * 3600)
    
    local days = math.floor(seconds / (24 * 3600))
    seconds = seconds % (24 * 3600)
    
    local hours = math.floor(seconds / 3600)
    seconds = seconds % 3600
    
    local minutes = math.floor(seconds / 60)
    local secs = seconds % 60
    
    local result = ""
    if years > 0 then result = result .. years .. "y" end
    if days > 0 then result = result .. days .. "d" end
    if hours > 0 then result = result .. hours .. "h" end
    if minutes > 0 then result = result .. minutes .. "m" end
    if result == "" or (years == 0 and days == 0 and hours == 0) then
        result = result .. secs .. "s"
    end
    
    return result
end
-- Display Player Info --
spawn(function()
    -- Розширюємо вікно для нових статів
    if StatsFrame then
        StatsFrame.Size = UDim2.new(0, 161, 0, 140)
        ShowStats1.Size = UDim2.new(0, 50, 0, 140)
        ShowStats2.Size = UDim2.new(0, 103, 0, 140)
    end

    while true do
        statplayer = tostring(PlayerName.Text)
        StatsFrame.Visible = false
        
        if playerdied == true then repeat wait(0.5) until playerdied == false end
        
        -- Перевіряємо, чи введено хоча б щось у поле (щоб не шукало всіх підряд, коли пусто)
        if statplayer ~= "" then
            for i, v in pairs(game:GetService("Players"):GetChildren()) do
                -- [ЗМІНА] string.find шукає частину тексту в імені (ігноруючи регістр)
                if string.find(string.lower(v.Name), string.lower(statplayer), 1, true) then
                    
                    StatsFrame.Visible = true
                    
                    if v.Character and v.Character:FindFirstChild("Humanoid") then
                        local FindHum = v.Character.Humanoid
                        
                        -- Отримання статів
                        local rawFist = v:GetAttribute("FistStrength") or 0
                        local rawBody = v:GetAttribute("BodyToughness") or 0
                        local rawSpeed = v:GetAttribute("MovementSpeed") or 0
                        local rawJump = v:GetAttribute("JumpForce") or 0
                        local rawPsychic = v:GetAttribute("PsychicPower") or 0
                        local rawTPM = v:GetAttribute("TPM") or 0
                        local rawVIPTIME = v:GetAttribute("VIPTIME") or 0
                        
                        -- Рахуємо Total (без TPM)
                        local rawTotal = rawFist + rawBody + rawSpeed + rawJump + rawPsychic

                        -- Конвертація
                        local PlayerHealth = converttoletter(FindHum.Health)
                        local PlayerFist = converttoletter(rawFist)
                        local PlayerBody = converttoletter(rawBody)
                        local PlayerSpeed = converttoletter(rawSpeed)
                        local PlayerJump = converttoletter(rawJump)
                        local PlayerPsychic = converttoletter(rawPsychic)
                        local PlayerTPM = converttoletter(rawTPM)
                        local PlayerVIPTIME = formatTime(rawVIPTIME)
                        local PlayerTotal = converttoletter(rawTotal)

                        -- Вивід
                        ShowStats1.Text = "Health:\nFist:\nBody:\nSpeed:\nJump:\nPsy:\nTPM:\nVIP:\nTotal:"
                        ShowStats2.Text = PlayerHealth.. "\n" ..PlayerFist.. "\n" ..PlayerBody.. "\n" ..PlayerSpeed.. "\n" ..PlayerJump.. "\n" ..PlayerPsychic.. "\n" ..PlayerTPM.. "\n" ..PlayerVIPTIME.. "\n" ..PlayerTotal
                    end
                    break 
                end
            end
        end
        wait(0.25)
    end
end)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Налаштування
local OWNER_IDS = {10435914167, 585191969, 10196614277}
local Sora_ID = 0
local ADMIN_GROUP_ID = 0
local MIN_ADMIN_RANK = 240

local AdminCheckEnabled = false -- Стан перемикача
local PlayerAddedConnection = nil -- Змінна для підключення

-- Функція перевірки
local function checkPlayer(player)
    if not AdminCheckEnabled then return end
    if player == LocalPlayer then return end

    -- Перевірка власників через цикл
    for _, id in ipairs(OWNER_IDS) do
        if player.UserId == id then
            LocalPlayer:Kick("The owner just joined. Abort mission! 🚨")
            return
        end
    end

    if player.UserId == Sora_ID and Sora_ID ~= 0 then
        LocalPlayer:Kick("Script owner joined. Abort mission! 🚨")
        return
    end

    if ADMIN_GROUP_ID > 0 then
        if player:GetRankInGroup(ADMIN_GROUP_ID) >= MIN_ADMIN_RANK then
            LocalPlayer:Kick("Admin (" .. player.Name .. ") has joined the game.")
        end
    end
end

-- Логіка перемикання
AdminCheckBtn.MouseButton1Click:Connect(function()
    AdminCheckEnabled = not AdminCheckEnabled
    
    if AdminCheckEnabled then
        AdminCheckBtn.Text = "Admin Check: ON"
        AdminCheckBtn.TextColor3 = Color3.new(0, 1, 0) -- Зелений при включенні
        
        -- Перевіряємо тих, хто вже на сервері
        for _, player in ipairs(Players:GetPlayers()) do
            checkPlayer(player)
        end
        
        -- Включаємо відстеження нових гравців
        if not PlayerAddedConnection then
            PlayerAddedConnection = Players.PlayerAdded:Connect(checkPlayer)
        end
    else
        AdminCheckBtn.Text = "Admin Check: OFF"
        AdminCheckBtn.TextColor3 = Color3.new(1, 1, 1) -- Повертаємо білий
        
        -- Вимикаємо відстеження
        if PlayerAddedConnection then
            PlayerAddedConnection:Disconnect()
            PlayerAddedConnection = nil
        end
    end
end)
-- Distanse Kick
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local localPlayer = Players.LocalPlayer
local SAFE_DISTANCE = 1000 
local isActive = false -- Стан функції (вимкнено за замовчуванням)
-- Логіка перемикання кнопки
DistanceKickBtn.MouseButton1Click:Connect(function()
    isActive = not isActive
    if isActive then
        DistanceKickBtn.Text = "Distance Kick: ON"
        DistanceKickBtn.TextColor3 = Color3.new(0, 1, 0) -- Зелений при ввімкненні
    else
        DistanceKickBtn.Text = "Distance Kick: OFF"
        DistanceKickBtn.TextColor3 = Color3.new(1, 0, 0) -- Червоний при вимкненні
    end
end)
-- Основний цикл перевірки
RunService.Heartbeat:Connect(function()
    if not isActive then return end -- Якщо вимкнено, нічого не робимо

    local character = localPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end
    
    local myPos = character.HumanoidRootPart.Position

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= localPlayer then
            local otherChar = player.Character
            if otherChar and otherChar:FindFirstChild("HumanoidRootPart") then
                local otherPos = otherChar.HumanoidRootPart.Position
                local distance = (myPos - otherPos).Magnitude

                if distance < SAFE_DISTANCE then
                    localPlayer:Kick("\n[Safe Zone]\nPlayer " .. player.Name .. " got too close!")
                end
            end
        end
    end
end)
