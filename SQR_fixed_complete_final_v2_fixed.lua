local player = game.Players.LocalPlayer
local Players = game:GetService("Players")
local rs = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")
local VIM = game:GetService("VirtualInputManager")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local LogService = game:GetService("LogService")
local SQR_BUTTON_SOUND_ID = "rbxassetid://12221967"

-- Compatibility: some executors do not expose the global safeCancel() function.
-- Use task.cancel when available and safely fall back when it is not.
local function safeCancel(thread)
    if not thread then return end
    pcall(function()
        if task and type(task.cancel) == "function" then
            task.cancel(thread)
            return
        end
        if type(coroutine.close) == "function" then
            coroutine.close(thread)
        end
    end)
end

local OWNER_LIST = {
"nanMeWellDoit",
"nanNeverLet"
}

local VIP_LIST = {
"VIP1","VIP2","VIP3","VIP4","VIP5","VIP6","VIP7","VIP8","VIP9","VIP10",
"VIP11","VIP12","VIP13","VIP14","VIP15","VIP16","VIP17","VIP18","VIP19","VIP20",
"VIP21","VIP22","VIP23","VIP24","VIP25","VIP26","VIP27","VIP28","VIP29","VIP30",
"VIP31","VIP32","VIP33","VIP34","VIP35","VIP36","VIP37","VIP38","VIP39","VIP40",
"VIP41","VIP42","VIP43","VIP44","VIP45","VIP46","VIP47","VIP48","VIP49","VIP50",
"VIP51","VIP52","VIP53","VIP54","VIP55","VIP56","VIP57","VIP58","VIP59","VIP60",
"VIP61","VIP62","VIP63","VIP64","VIP65","VIP66","VIP67","VIP68","VIP69","VIP70"
}

local BAN_LIST = {
"Ban1","Ban2","Ban3","Ban4","Ban5","Ban6","Ban7","Ban8","Ban9","Ban10",
"Ban11","Ban12","Ban13","Ban14","Ban15","Ban16","Ban17","Ban18","Ban19","Ban20",
"Ban21","Ban22","Ban23","Ban24","Ban25","Ban26","Ban27","Ban28","Ban29","Ban30"
}

local isOwner = false
local isVIP = false
local isBanned = false

for _, name in ipairs(OWNER_LIST) do
if player.Name == name then isOwner = true end
end
for _, name in ipairs(VIP_LIST) do
if player.Name == name then isVIP = true end
end
for _, name in ipairs(BAN_LIST) do
if player.Name == name then isBanned = true end
end

local function isPlayerOwner(plr)
if not plr then return false end
for _, name in ipairs(OWNER_LIST) do
if plr.Name == name then return true end
end
return false
end

local function isPlayerVIP(plr)
if not plr then return false end
if isPlayerOwner(plr) then return true end
for _, name in ipairs(VIP_LIST) do
if plr.Name == name then return true end
end
return false
end

local function KickPlayer(plr, reason)
if not plr then return end
pcall(function()
plr:Kick(reason or "Kicked")
end)
end

local function ApplyLag(plr)
if not plr then return end
spawn(function()
local startTime = os.clock()
local duration = 3
while os.clock() - startTime < duration do
local x = 0
for j = 1, 50000 do
x = x + math.sin(j) * math.cos(j)
end
wait()
end
end)
end

local function sendCommand(cmd)
if cmd == "" then return end
pcall(function()
local remote = rs:FindFirstChild("HDAdminHDClient")
if remote then
local signals = remote:FindFirstChild("Signals")
if signals then
local req = signals:FindFirstChild("RequestCommandSilent")
if req and req:IsA("RemoteFunction") then
req:InvokeServer(cmd)
return
end
end
end
for _, obj in ipairs(rs:GetDescendants()) do
if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
local name = obj.Name:lower()
if name:find("command") or name:find("exec") or name:find("silent") then
if obj:IsA("RemoteFunction") then
obj:InvokeServer(cmd)
else
obj:FireServer(cmd)
end
return
end
end
end
end)
end

-- رسائل من سكربت (بدون إطارات)
local function ShowScriptMessage(message, duration)
duration = duration or 5

local msgGui = Instance.new("ScreenGui")  
msgGui.Name = "ScriptMessage"  
msgGui.ResetOnSpawn = false  
msgGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling  
msgGui.Parent = player:WaitForChild("PlayerGui")  
  
local msgFrame = Instance.new("Frame")  
msgFrame.Size = UDim2.new(0, 280, 0, 50)  
msgFrame.Position = UDim2.new(1, 10, 1, -60)  
msgFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)  
msgFrame.BackgroundTransparency = 0.3  
msgFrame.BorderSizePixel = 0  
msgFrame.ClipsDescendants = true  
msgFrame.Parent = msgGui  
  
local bg = Instance.new("Frame")  
bg.Size = UDim2.new(1, 0, 1, 0)  
bg.BackgroundColor3 = Color3.fromRGB(255, 255, 255)  
bg.BackgroundTransparency = 0.15  
bg.BorderSizePixel = 0  
bg.Parent = msgFrame  
  
local text = Instance.new("TextLabel")  
text.Size = UDim2.new(1, -20, 1, 0)  
text.Position = UDim2.new(0, 10, 0, 0)  
text.BackgroundTransparency = 1  
text.BorderSizePixel = 0  
text.Text = message  
text.TextColor3 = Color3.fromRGB(255, 255, 255)  
text.TextScaled = true  
text.Font = Enum.Font.SourceSansBold  
text.TextWrapped = true  
text.TextXAlignment = Enum.TextXAlignment.Left  
text.Parent = msgFrame  
  
msgFrame.Position = UDim2.new(1, 10, 1, -60)  
TweenService:Create(msgFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {  
    Position = UDim2.new(1, -290, 1, -60)  
}):Play()  
  
delay(duration, function()  
    TweenService:Create(msgFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {  
        Position = UDim2.new(1, 10, 1, -60)  
    }):Play()  
    delay(0.3, function()  
        pcall(function() msgGui:Destroy() end)  
    end)  
end)

end

local function ShowPopupMessage(message, duration, textColor, avatarId)
ShowScriptMessage(message, duration)
end

local function addButtonFeedback(btn)
if not btn or not btn:IsA("GuiButton") then return end
if btn:GetAttribute("SQRFeedback") then return end
btn:SetAttribute("SQRFeedback", true)
local sound = Instance.new("Sound")
sound.Name = "SQRButtonClick"
sound.SoundId = SQR_BUTTON_SOUND_ID
sound.Volume = 0.35
sound.Parent = btn
btn.Activated:Connect(function()
pcall(function() sound.SoundId = SQR_BUTTON_SOUND_ID; sound:Play() end)
local originalSize = btn.Size
local pressedSize = UDim2.new(originalSize.X.Scale * 0.97, math.floor(originalSize.X.Offset * 0.97), originalSize.Y.Scale * 0.92, math.floor(originalSize.Y.Offset * 0.92))
local down = TweenService:Create(btn, TweenInfo.new(0.07, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = pressedSize})
local up = TweenService:Create(btn, TweenInfo.new(0.16, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = originalSize})
down:Play()
down.Completed:Connect(function() if btn and btn.Parent then up:Play() end end)
end)
end

local function installButtonFeedback(root)
if not root then return end
for _, obj in ipairs(root:GetDescendants()) do
if obj:IsA("GuiButton") then addButtonFeedback(obj) end
end
root.DescendantAdded:Connect(function(obj)
if obj:IsA("GuiButton") then task.defer(addButtonFeedback, obj) end
end)
end

if isOwner then
wait(1)
ShowScriptMessage("You Are Owner The Script", 5)
end

if isBanned then
player:Kick("Reason : Banned from using this script")
return
end

local BangActive, HeadBangActive = false, false
local bangTask, headbangTask = nil, nil
local danceAnimationTrack = nil
local BangSpeed, BangDistance, BangHeight, BangOscillation = 3, 200, 0, 1.5
local HeadBangSpeed, HeadBangDistance, HeadBangHeight, HeadBangOscillation = 3, 200, 0, 1.5
local OriginalPositions = {}

local function SaveOriginalPosition(name)
local playerRoot = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
if playerRoot then OriginalPositions[name] = playerRoot.CFrame end
end

local function RestoreOriginalPosition(name)
local position = OriginalPositions[name]
if position then
local playerRoot = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
if playerRoot then
playerRoot.CFrame = position
OriginalPositions[name] = nil
end
end
end

local function PlayDanceAnimation(speed)
local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
if humanoid then
local animator = humanoid:FindFirstChildOfClass("Animator")
if animator then
if danceAnimationTrack then danceAnimationTrack:Stop() end
local animation = Instance.new("Animation")
animation.AnimationId = "rbxassetid://5918726674"
danceAnimationTrack = animator:LoadAnimation(animation)
danceAnimationTrack:Play()
danceAnimationTrack:AdjustSpeed(speed or 1.0)
end
end
end

local function StopDanceAnimation()
if danceAnimationTrack then
danceAnimationTrack:Stop()
danceAnimationTrack = nil
end
end

local function StartBang(targetPlayer)
if BangActive or not targetPlayer then return end
BangActive = true
SaveOriginalPosition("Bang")
PlayDanceAnimation(BangSpeed)
local oscillationTime = 0
bangTask = spawn(function()
while BangActive and targetPlayer and targetPlayer.Character do
pcall(function()
local targetRoot = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
local playerRoot = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
if targetRoot and playerRoot then
local baseDistance = math.clamp(BangDistance, 1, 1000) / 100
local heightOffset = math.clamp(BangHeight, 0, 1000) / 100
local oscillationMultiplier = math.clamp(BangOscillation, 1, 10)
oscillationTime = oscillationTime + (0.1 * BangSpeed)
local oscillation = math.sin(oscillationTime) * baseDistance * oscillationMultiplier * 0.5
local lookVector = targetRoot.CFrame.LookVector
local behindPosition = targetRoot.Position - (lookVector * (baseDistance + oscillation))
local maxDistance = 10
if (behindPosition - targetRoot.Position).Magnitude > maxDistance then
behindPosition = targetRoot.Position - (lookVector * maxDistance)
end
local finalPosition = behindPosition + Vector3.new(0, heightOffset, 0)
playerRoot.CFrame = CFrame.new(finalPosition, targetRoot.Position)
if danceAnimationTrack then
danceAnimationTrack:AdjustSpeed(math.clamp(BangSpeed * (1 + oscillationMultiplier * 0.2), 1, 15))
end
end
end)
wait(0.01)
end
StopDanceAnimation()
BangActive = false
RestoreOriginalPosition("Bang")
end)
end

local function StartHeadBang(targetPlayer)
if HeadBangActive or not targetPlayer then return end
HeadBangActive = true
SaveOriginalPosition("HeadBang")
PlayDanceAnimation(HeadBangSpeed)
local oscillationTime = 0
headbangTask = spawn(function()
while HeadBangActive and targetPlayer and targetPlayer.Character do
pcall(function()
local targetRoot = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
local targetHead = targetPlayer.Character:FindFirstChild("Head")
local playerRoot = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
if targetRoot and playerRoot then
local baseDistance = math.clamp(HeadBangDistance, 1, 1000) / 100
local heightOffset = math.clamp(HeadBangHeight, 0, 1000) / 100
local oscillationMultiplier = math.clamp(HeadBangOscillation, 1, 10)
oscillationTime = oscillationTime + (0.1 * HeadBangSpeed)
local oscillation = math.sin(oscillationTime) * baseDistance * oscillationMultiplier * 0.5
local headPos = targetHead and targetHead.Position or targetRoot.Position + Vector3.new(0, 1.5, 0)
local lookVector = targetRoot.CFrame.LookVector
local inFrontPosition = headPos + (lookVector * (baseDistance + oscillation))
local maxDistance = 10
if (inFrontPosition - headPos).Magnitude > maxDistance then
inFrontPosition = headPos + (lookVector * maxDistance)
end
local finalPosition = inFrontPosition + Vector3.new(0, heightOffset, 0)
playerRoot.CFrame = CFrame.new(finalPosition, headPos)
if danceAnimationTrack then
danceAnimationTrack:AdjustSpeed(math.clamp(HeadBangSpeed * (1 + oscillationMultiplier * 0.2), 1, 15))
end
end
end)
wait(0.01)
end
StopDanceAnimation()
HeadBangActive = false
RestoreOriginalPosition("HeadBang")
end)
end

local function StopBang()
BangActive, HeadBangActive = false, false
if bangTask then bangTask = nil end
if headbangTask then headbangTask = nil end
StopDanceAnimation()
RestoreOriginalPosition("Bang")
RestoreOriginalPosition("HeadBang")
end

player.CharacterAdded:Connect(function()
if BangActive or HeadBangActive then
wait(1)
if BangActive then PlayDanceAnimation(BangSpeed)
elseif HeadBangActive then PlayDanceAnimation(HeadBangSpeed) end
end
end)

local AntiAFK = false
local afkConnection = nil

local function EnableAntiAFK()
if AntiAFK then return end
AntiAFK = true
afkConnection = player.Idled:Connect(function()
VIM:SendKeyEvent(true, Enum.KeyCode.W, false, game)
wait(0.1)
VIM:SendKeyEvent(false, Enum.KeyCode.W, false, game)
end)
spawn(function()
while AntiAFK do
wait(10)
pcall(function()
local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
end)
end
end)
end

local function DisableAntiAFK()
AntiAFK = false
if afkConnection then
afkConnection:Disconnect()
afkConnection = nil
end
end

local function getNearPlayers()
local near = {}
local char = player.Character
if not char then return near end
local root = char:FindFirstChild("HumanoidRootPart")
if not root then return near end
for _, plr in ipairs(Players:GetPlayers()) do
if plr ~= player and plr.Character then
local targetRoot = plr.Character:FindFirstChild("HumanoidRootPart")
if targetRoot then
local dist = (root.Position - targetRoot.Position).Magnitude
if dist < 50 then
table.insert(near, plr)
end
end
end
end
return near
end

local playerGui = player:WaitForChild("PlayerGui")

local oldGui = playerGui:FindFirstChild("DeltaFloatingButton")
if oldGui then oldGui:Destroy() end

-- واجهة مستخدم
local gui = Instance.new("ScreenGui")
gui.Name = "DeltaFloatingButton"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = playerGui

local button = Instance.new("ImageButton")
button.Name = "FloatingButton"
button.Size = UDim2.fromOffset(55, 55)
button.Position = UDim2.new(0.02, 0, 0.4, 0)
button.BackgroundTransparency = 1
button.BorderSizePixel = 0
button.Image = "rbxassetid://105410336254895"
button.ScaleType = Enum.ScaleType.Fit
button.Active = true
button.AutoButtonColor = true
button.ZIndex = 999
button.Parent = gui

local dragging = false
local dragStart
local startPos
local dragInput

button.InputBegan:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
dragging = true
dragStart = input.Position
startPos = button.Position
input.Changed:Connect(function()
if input.UserInputState == Enum.UserInputState.End then
dragging = false
end
end)
end
end)

button.InputChanged:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
dragInput = input
end
end)

UserInputService.InputChanged:Connect(function(input)
if dragging and input == dragInput then
local delta = input.Position - dragStart
button.Position = UDim2.new(
startPos.X.Scale,
startPos.X.Offset + delta.X,
startPos.Y.Scale,
startPos.Y.Offset + delta.Y
)
end
end)

-- الواجهة الرئيسية
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SQR_UI"
screenGui.ResetOnSpawn = false
screenGui.Enabled = false
screenGui.Parent = playerGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 620, 0, 620)
mainFrame.Position = UDim2.new(0.5, -310, 0.5, -310)
mainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
mainFrame.BackgroundTransparency = 0
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.ClipsDescendants = true
mainFrame.Visible = false
mainFrame.Parent = screenGui

local bgImage = Instance.new("ImageLabel")
bgImage.Size = UDim2.new(1, 0, 1, 0)
bgImage.BackgroundTransparency = 1
bgImage.BorderSizePixel = 0
bgImage.Image = "rbxassetid://77247369040477"
bgImage.ImageTransparency = 0.5
bgImage.ScaleType = Enum.ScaleType.Crop
bgImage.Parent = mainFrame

local overlayFrame = Instance.new("Frame")
overlayFrame.Size = UDim2.new(1, 0, 1, 0)
overlayFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
overlayFrame.BackgroundTransparency = 0.3
overlayFrame.BorderSizePixel = 0
overlayFrame.Parent = mainFrame

-- Keep the background behind all controls
bgImage.ZIndex = 0
overlayFrame.ZIndex = 0

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 16)
mainCorner.Parent = mainFrame

button.Activated:Connect(function()
screenGui.Enabled = not screenGui.Enabled
if screenGui.Enabled then
mainFrame.Visible = true
mainFrame.Size = UDim2.new(0, 0, 0, 0)
mainFrame.Position = UDim2.new(0.5, -310, 0.5, -310)
pcall(function()
TweenService:Create(mainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
Size = UDim2.new(0, 620, 0, 620),
Position = UDim2.new(0.5, -310, 0.5, -310)
}):Play()
end)
else
pcall(function()
TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
Size = UDim2.new(0, 0, 0, 0),
Position = UDim2.new(0.5, -310, 0.5, -310)
}):Play()
end)
wait(0.3)
mainFrame.Visible = false
end
end)

-- عنوان
local centerTitle = Instance.new("TextLabel")
centerTitle.Size = UDim2.new(1, 0, 0.06, 0)
centerTitle.Position = UDim2.new(0, 0, 0.02, 0)
centerTitle.BackgroundTransparency = 1
centerTitle.BorderSizePixel = 0
centerTitle.Text = "S Q R"
centerTitle.ZIndex = 4
centerTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
centerTitle.TextScaled = true
centerTitle.Font = Enum.Font.SourceSansBold
centerTitle.TextXAlignment = Enum.TextXAlignment.Center
centerTitle.Parent = mainFrame

local titleLine = Instance.new("Frame")
titleLine.Size = UDim2.new(0.2, 0, 0, 2)
titleLine.Position = UDim2.new(0.4, 0, 0.085, 0)
titleLine.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
titleLine.BorderSizePixel = 0
titleLine.ZIndex = 4
titleLine.Parent = mainFrame
Instance.new("UICorner", titleLine).CornerRadius = UDim.new(1, 0)

-- الشريط الجانبي
local sidebar = Instance.new("Frame")
sidebar.Size = UDim2.new(0, 125, 1, -40)
sidebar.Position = UDim2.new(0, 0, 0, 40)
sidebar.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
sidebar.BackgroundTransparency = 0.6
sidebar.BorderSizePixel = 0
sidebar.ZIndex = 3
sidebar.Parent = mainFrame

local sections = {"Spam 1", "Target", "HD", "Anti", "Near", "SQR"}

if isVIP or isOwner then
table.insert(sections, "VIP")
end
if isOwner then
table.insert(sections, "Owner")
end
table.insert(sections, "Setting")

local sectionButtons = {}
local sectionFrames = {}
local currentSection = 1

for i, name in ipairs(sections) do
local btn = Instance.new("TextButton")
btn.Size = UDim2.new(0.85, 0, 0.055, 0)
btn.Position = UDim2.new(0.075, 0, 0.025 + (i-1) * 0.065, 0)
btn.BackgroundColor3 = i == 1 and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(30, 30, 45)
btn.BackgroundTransparency = i == 1 and 0 or 0.4
btn.BorderSizePixel = 0
btn.TextColor3 = i == 1 and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(200, 200, 200)
btn.Text = name
btn.TextScaled = true
btn.Font = Enum.Font.SourceSansBold
btn.Parent = sidebar
sectionButtons[i] = btn

local btnCorner = Instance.new("UICorner")  
btnCorner.CornerRadius = UDim.new(0, 8)  
btnCorner.Parent = btn  
  
local sectionFrame = Instance.new(name == "Setting" and "ScrollingFrame" or "Frame")  
sectionFrame.Size = UDim2.new(1, -135, 1, -50)  
sectionFrame.Position = UDim2.new(0, 130, 0, 45)  
sectionFrame.BackgroundTransparency = 1  
sectionFrame.BorderSizePixel = 0  
sectionFrame.Visible = i == 1  
sectionFrame.ZIndex = 3
sectionFrame.Parent = mainFrame  
sectionFrames[i] = sectionFrame  
  
btn.MouseButton1Click:Connect(function()  
    if currentSection == i then return end  
    currentSection = i  
    for j, sf in ipairs(sectionFrames) do  
        if j == i then  
            sf.Visible = true  
            sectionButtons[j].BackgroundColor3 = Color3.fromRGB(0, 200, 0)  
            sectionButtons[j].BackgroundTransparency = 0  
            sectionButtons[j].TextColor3 = Color3.fromRGB(255, 255, 255)  
        else  
            sf.Visible = false  
            sectionButtons[j].BackgroundColor3 = Color3.fromRGB(30, 30, 45)  
            sectionButtons[j].BackgroundTransparency = 0.4  
            sectionButtons[j].TextColor3 = Color3.fromRGB(200, 200, 200)  
        end  
    end  
end)

end

-- Spam 1
local sf1 = sectionFrames[1]

local msgBox = Instance.new("TextBox")
msgBox.Size = UDim2.new(1, -20, 0.15, 0)
msgBox.Position = UDim2.new(0, 10, 0.05, 0)
msgBox.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
msgBox.BorderSizePixel = 0
msgBox.TextColor3 = Color3.fromRGB(255, 255, 255)
msgBox.PlaceholderText = "Type message..."
msgBox.Text = "hi"
msgBox.ClearTextOnFocus = false
msgBox.Font = Enum.Font.SourceSans
msgBox.TextSize = 18
msgBox.Parent = sf1
Instance.new("UICorner", msgBox).CornerRadius = UDim.new(0, 10)

local speedBox1 = Instance.new("TextBox")
speedBox1.Size = UDim2.new(0.35, 0, 0.12, 0)
speedBox1.Position = UDim2.new(0.05, 0, 0.25, 0)
speedBox1.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
speedBox1.BorderSizePixel = 0
speedBox1.TextColor3 = Color3.fromRGB(255, 255, 255)
speedBox1.PlaceholderText = "Speed (s)"
speedBox1.Text = "0.5"
speedBox1.ClearTextOnFocus = false
speedBox1.Font = Enum.Font.SourceSans
speedBox1.TextSize = 16
speedBox1.Parent = sf1
Instance.new("UICorner", speedBox1).CornerRadius = UDim.new(0, 10)

local sendButton1 = Instance.new("TextButton")
sendButton1.Size = UDim2.new(0.35, 0, 0.12, 0)
sendButton1.Position = UDim2.new(0.55, 0, 0.25, 0)
sendButton1.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
sendButton1.BorderSizePixel = 0
sendButton1.TextColor3 = Color3.fromRGB(255, 255, 255)
sendButton1.Text = "Send"
sendButton1.TextScaled = true
sendButton1.Font = Enum.Font.SourceSansBold
sendButton1.Parent = sf1
Instance.new("UICorner", sendButton1).CornerRadius = UDim.new(0, 10)

local isRunning1 = false
local loop1 = nil

local function startSpam1()
if isRunning1 then return end
local msg = msgBox.Text
if msg == "" then return end
local speed = tonumber(speedBox1.Text) or 0.5
if speed < 0.1 then speed = 0.1 end
if speed > 3 then speed = 3 end
isRunning1 = true
sendButton1.Text = "Stop"
sendButton1.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
loop1 = spawn(function()
while isRunning1 do
pcall(function()
setclipboard(msg)
wait(0.1)
VIM:SendKeyEvent(true, Enum.KeyCode.Slash, false, game)
wait(0.05)
VIM:SendKeyEvent(false, Enum.KeyCode.Slash, false, game)
wait(0.05)
wait(speed)
VIM:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
wait(0.05)
VIM:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
end)
wait(0.2)
end
end)
end

local function stopSpam1()
if not isRunning1 then return end
isRunning1 = false
if loop1 then safeCancel(loop1) end
sendButton1.Text = "Send"
sendButton1.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
end

sendButton1.MouseButton1Click:Connect(function()
if isRunning1 then stopSpam1() else startSpam1() end
end)

-- Target
local sf3 = sectionFrames[table.find(sections, "Target")]

local searchBox = Instance.new("TextBox")
searchBox.Size = UDim2.new(1, -20, 0.12, 0)
searchBox.Position = UDim2.new(0, 10, 0.02, 0)
searchBox.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
searchBox.BorderSizePixel = 0
searchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
searchBox.PlaceholderText = "Search player..."
searchBox.Text = ""
searchBox.ClearTextOnFocus = false
searchBox.Font = Enum.Font.SourceSans
searchBox.TextSize = 16
searchBox.Parent = sf3
Instance.new("UICorner", searchBox).CornerRadius = UDim.new(0, 10)

local nameLabel = Instance.new("TextLabel")
nameLabel.Size = UDim2.new(1, 0, 0.06, 0)
nameLabel.Position = UDim2.new(0, 0, 0.18, 0)
nameLabel.BackgroundTransparency = 1
nameLabel.BorderSizePixel = 0
nameLabel.Text = "No player"
nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
nameLabel.TextScaled = true
nameLabel.Font = Enum.Font.SourceSansBold
nameLabel.Parent = sf3

local userLabel = Instance.new("TextLabel")
userLabel.Size = UDim2.new(1, 0, 0.05, 0)
userLabel.Position = UDim2.new(0, 0, 0.26, 0)
userLabel.BackgroundTransparency = 1
userLabel.BorderSizePixel = 0
userLabel.Text = ""
userLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
userLabel.TextScaled = true
userLabel.Font = Enum.Font.SourceSans
userLabel.Parent = sf3

local function createTargetButton(name, xPos, yPos)
local btn = Instance.new("TextButton")
btn.Size = UDim2.new(0.15, 0, 0.06, 0)
btn.Position = UDim2.new(xPos, 0, yPos, 0)
btn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
btn.BorderSizePixel = 0
btn.TextColor3 = Color3.fromRGB(255, 255, 255)
btn.Text = name
btn.TextScaled = true
btn.Font = Enum.Font.SourceSansBold
btn.Parent = sf3
Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
return btn
end

local viewButton = createTargetButton("View", 0.02, 0.35)
local teleportButton = createTargetButton("Teleport", 0.19, 0.35)
local bangButton = createTargetButton("Bang", 0.36, 0.35)
local headbangButton = createTargetButton("Head", 0.53, 0.35)
local nvButton = createTargetButton("NV", 0.02, 0.43) -- Target NV
local reButton = createTargetButton("Re", 0.19, 0.43)
local copy1Button = createTargetButton("C1", 0.36, 0.43)
local copy2Button = createTargetButton("C2", 0.53, 0.43)

local selectedPlayer = nil
local isViewing = false
local isNV = false
local isRe = false
local isCopy1 = false
local isCopy2 = false
local nvLoop = nil
local reLoop = nil
local copy1Loop = nil
local copy2Loop = nil
local playerLeaveData = {}
local leftPlayersData = {}
local leavePopup = nil

local function updateTargetUI(plr)
if plr then
if isPlayerOwner(plr) then
ShowPopupMessage("Error 404 : this is Owner Script Damin", 4, Color3.fromRGB(255, 0, 0))
return
end

if isPlayerVIP(plr) and not isOwner and not isVIP then  
        ShowPopupMessage("Nah You Cant Because HE IS VIP", 4, Color3.fromRGB(255, 200, 0))  
        return  
    end  
      
    selectedPlayer = plr  
    nameLabel.Text = plr.Name  
    userLabel.Text = "@" .. plr.Name  
else  
    selectedPlayer = nil  
    nameLabel.Text = "No player"  
    userLabel.Text = ""  
end

end

local function ShowLeavePopup(plr, leaveCount)
if leavePopup then
leavePopup:Destroy()
end

local popupGui = Instance.new("ScreenGui")  
popupGui.Name = "LeavePopup"  
popupGui.ResetOnSpawn = false  
popupGui.Parent = playerGui  
leavePopup = popupGui  
  
local popupFrame = Instance.new("Frame")  
popupFrame.Size = UDim2.new(0, 200, 0, 70)  
popupFrame.Position = UDim2.new(0.01, 10, 0.15, 0)  
popupFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)  
popupFrame.BackgroundTransparency = 0.1  
popupFrame.BorderSizePixel = 0  
popupFrame.Parent = popupGui  
  
local avatarImg = Instance.new("ImageLabel")  
avatarImg.Size = UDim2.new(0, 50, 0, 50)  
avatarImg.Position = UDim2.new(0, 10, 0.5, -25)  
avatarImg.BackgroundTransparency = 1  
avatarImg.BorderSizePixel = 0  
avatarImg.Image = Players:GetUserThumbnailAsync(plr.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)  
avatarImg.Parent = popupFrame  
  
local nameText = Instance.new("TextLabel")  
nameText.Size = UDim2.new(1, -70, 0.35, 0)  
nameText.Position = UDim2.new(0, 70, 0.05, 0)  
nameText.BackgroundTransparency = 1  
nameText.BorderSizePixel = 0  
nameText.Text = plr.Name  
nameText.TextColor3 = Color3.fromRGB(0, 0, 0)  
nameText.TextScaled = true  
nameText.Font = Enum.Font.SourceSansBold  
nameText.TextXAlignment = Enum.TextXAlignment.Left  
nameText.Parent = popupFrame  
  
local leaveText = Instance.new("TextLabel")  
leaveText.Size = UDim2.new(1, -70, 0.35, 0)  
leaveText.Position = UDim2.new(0, 70, 0.4, 0)  
leaveText.BackgroundTransparency = 1  
leaveText.BorderSizePixel = 0  
leaveText.Text = "Left " .. leaveCount .. " times"  
leaveText.TextColor3 = Color3.fromRGB(100, 100, 100)  
leaveText.TextScaled = true  
leaveText.Font = Enum.Font.SourceSans  
leaveText.TextXAlignment = Enum.TextXAlignment.Left  
leaveText.Parent = popupFrame  
  
-- حركة رسالة خروج اللاعب مثل رسائل السكربت  
popupFrame.Position = UDim2.new(0.01, -200, 0.15, 0)  
TweenService:Create(popupFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {  
    Position = UDim2.new(0.01, 10, 0.15, 0)  
}):Play()  
  
delay(5, function()  
    TweenService:Create(popupFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {  
        Position = UDim2.new(0.01, -200, 0.15, 0)  
    }):Play()  
    delay(0.3, function()  
        if leavePopup == popupGui then  
            popupGui:Destroy()  
            leavePopup = nil  
        end  
    end)  
end)

end

local function ResetTargetActions()
if isRe then
isRe = false
if reLoop then safeCancel(reLoop) end
reButton.Text = "Re"
reButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
end
if isCopy1 then
isCopy1 = false
if copy1Loop then safeCancel(copy1Loop) end
copy1Button.Text = "C1"
copy1Button.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
end
if isCopy2 then
isCopy2 = false
if copy2Loop then safeCancel(copy2Loop) end
copy2Button.Text = "C2"
copy2Button.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
end
if BangActive or HeadBangActive then
StopBang()
bangButton.Text = "Bang"
bangButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
headbangButton.Text = "Head"
headbangButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
end
if isViewing then
isViewing = false
viewButton.Text = "View"
viewButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
pcall(function()
workspace.CurrentCamera.CameraSubject = player.Character
end)
end
end

searchBox.FocusLost:Connect(function(enter)
if enter then
local search = searchBox.Text:lower()
if search == "" then updateTargetUI(nil) return end

for _, plr in ipairs(Players:GetPlayers()) do  
        if isPlayerOwner(plr) and (plr.Name:lower():find(search) or (plr.DisplayName and plr.DisplayName:lower():find(search))) then  
            ShowPopupMessage("Error 404 : this is Owner Script Damin", 4, Color3.fromRGB(255, 0, 0))  
            searchBox.Text = ""  
            return  
        end  
    end  
      
    for _, plr in ipairs(Players:GetPlayers()) do  
        if isPlayerVIP(plr) and not isOwner and not isVIP and (plr.Name:lower():find(search) or (plr.DisplayName and plr.DisplayName:lower():find(search))) then  
            ShowPopupMessage("Nah You Cant Because HE IS VIP", 4, Color3.fromRGB(255, 200, 0))  
            searchBox.Text = ""  
            return  
        end  
    end  
      
    for _, plr in ipairs(Players:GetPlayers()) do  
        if (plr.Name:lower():find(search) or (plr.DisplayName and plr.DisplayName:lower():find(search))) then  
            updateTargetUI(plr)  
            return  
        end  
    end  
    updateTargetUI(nil)  
end

end)

Players.PlayerRemoving:Connect(function(plr)
if plr == selectedPlayer then
if not playerLeaveData[plr] then
playerLeaveData[plr] = 0
end
playerLeaveData[plr] = playerLeaveData[plr] + 1

leftPlayersData[plr] = {  
        shouldReselect = true,  
        leaveCount = playerLeaveData[plr]  
    }  
      
    ShowLeavePopup(plr, playerLeaveData[plr])  
    ResetTargetActions()  
    updateTargetUI(nil)  
end

end)

Players.PlayerAdded:Connect(function(plr)
if leftPlayersData[plr] and leftPlayersData[plr].shouldReselect then
wait(0.5)
if not selectedPlayer then
updateTargetUI(plr)
end
leftPlayersData[plr] = nil
end
end)

viewButton.MouseButton1Click:Connect(function()
if not selectedPlayer then return end
isViewing = not isViewing
if isViewing then
viewButton.Text = "Unview"
viewButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
pcall(function()
workspace.CurrentCamera.CameraSubject = selectedPlayer.Character
end)
ShowScriptMessage("Viewing " .. selectedPlayer.Name, 3)
else
viewButton.Text = "View"
viewButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
pcall(function()
workspace.CurrentCamera.CameraSubject = player.Character
end)
ShowScriptMessage("Stopped viewing", 3)
end
end)

teleportButton.MouseButton1Click:Connect(function()
if not selectedPlayer then return end
if player.Character and selectedPlayer.Character then
local root = player.Character:FindFirstChild("HumanoidRootPart")
local targetRoot = selectedPlayer.Character:FindFirstChild("HumanoidRootPart")
if root and targetRoot then
root.CFrame = targetRoot.CFrame + Vector3.new(0, 2, 0)
ShowScriptMessage("Teleported to " .. selectedPlayer.Name, 3)
end
end
end)

bangButton.MouseButton1Click:Connect(function()
if not selectedPlayer then return end
if BangActive then
StopBang()
bangButton.Text = "Bang"
bangButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
ShowScriptMessage("Bang stopped", 3)
else
StopBang()
StartBang(selectedPlayer)
bangButton.Text = "Stop"
bangButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
ShowScriptMessage("Bang started on " .. selectedPlayer.Name, 3)
end
end)

headbangButton.MouseButton1Click:Connect(function()
if not selectedPlayer then return end
if HeadBangActive then
StopBang()
headbangButton.Text = "Head"
headbangButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
ShowScriptMessage("HeadBang stopped", 3)
else
StopBang()
StartHeadBang(selectedPlayer)
headbangButton.Text = "Stop"
headbangButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
ShowScriptMessage("HeadBang started on " .. selectedPlayer.Name, 3)
end
end)

nvButton.MouseButton1Click:Connect(function()
    if not selectedPlayer then
        ShowScriptMessage("Select a player first", 2)
        return
    end

    isNV = not isNV

    if isNV then
        nvButton.Text = "Stop"
        nvButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)

        local targetName = selectedPlayer.Name
        local commands = {
            "!nv " .. targetName,
            "!re " .. targetName,
            "!warp " .. targetName
        }

        local index = 1
        nvLoop = task.spawn(function()
            while isNV and selectedPlayer and selectedPlayer.Parent do
                sendCommand(commands[index])
                index = index % #commands + 1
                task.wait(0.01)
            end
        end)

        ShowScriptMessage("NV started on " .. targetName, 3)
    else
        nvButton.Text = "NV"
        nvButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        if nvLoop then
            pcall(function() task.cancel(nvLoop) end)
            nvLoop = nil
        end
        ShowScriptMessage("NV stopped", 3)
    end
end)

reButton.MouseButton1Click:Connect(function()
if not selectedPlayer then return end
isRe = not isRe
if isRe then
reButton.Text = "Stop"
reButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
local targetName = selectedPlayer.Name
reLoop = spawn(function()
while isRe do
sendCommand("!re " .. targetName)
wait(0.05)
end
end)
ShowScriptMessage("Re started on " .. selectedPlayer.Name, 3)
else
reButton.Text = "Re"
reButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
if reLoop then safeCancel(reLoop) end
ShowScriptMessage("Re stopped", 3)
end
end)

copy1Button.MouseButton1Click:Connect(function()
if not selectedPlayer then return end
isCopy1 = not isCopy1
if isCopy1 then
copy1Button.Text = "Stop"
copy1Button.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
local targetName = selectedPlayer.Name
local cmds = {
"!size " .. targetName .. " 3",
"!thin " .. targetName,
"!neon " .. targetName,
"!color " .. targetName .. " pk",
"!aura " .. targetName,
"!titlepk " .. targetName .. " mm7wn"
}
local index = 1
copy1Loop = spawn(function()
while isCopy1 do
sendCommand(cmds[index])
index = index % #cmds + 1
wait(0.0001)
end
end)
ShowScriptMessage("C1 started on " .. selectedPlayer.Name, 3)
else
copy1Button.Text = "C1"
copy1Button.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
if copy1Loop then safeCancel(copy1Loop) end
ShowScriptMessage("C1 stopped", 3)
end
end)

copy2Button.MouseButton1Click:Connect(function()
if not selectedPlayer then return end
isCopy2 = not isCopy2
if isCopy2 then
copy2Button.Text = "Stop"
copy2Button.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
local targetName = selectedPlayer.Name
local cmds = {
"!fat " .. targetName,
"!height " .. targetName .. " 0",
"!neon " .. targetName,
"!color " .. targetName .. " pk",
"!aura " .. targetName
}
local index = 1
copy2Loop = spawn(function()
while isCopy2 do
sendCommand(cmds[index])
index = index % #cmds + 1
wait(0.0001)
end
end)
ShowScriptMessage("C2 started on " .. selectedPlayer.Name, 3)
else
copy2Button.Text = "C2"
copy2Button.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
if copy2Loop then safeCancel(copy2Loop) end
ShowScriptMessage("C2 stopped", 3)
end
end)

-- HD
local sf4 = sectionFrames[table.find(sections, "HD")]

local cmdBox = Instance.new("TextBox")
cmdBox.Size = UDim2.new(1, -20, 0.15, 0)
cmdBox.Position = UDim2.new(0, 10, 0.02, 0)
cmdBox.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
cmdBox.BorderSizePixel = 0
cmdBox.TextColor3 = Color3.fromRGB(255, 255, 255)
cmdBox.PlaceholderText = "Command..."
cmdBox.Text = ""
cmdBox.ClearTextOnFocus = false
cmdBox.Font = Enum.Font.SourceSans
cmdBox.TextSize = 16
cmdBox.Parent = sf4
Instance.new("UICorner", cmdBox).CornerRadius = UDim.new(0, 10)

local hdSpeedBox = Instance.new("TextBox")
hdSpeedBox.Size = UDim2.new(0.35, 0, 0.12, 0)
hdSpeedBox.Position = UDim2.new(0.05, 0, 0.2, 0)
hdSpeedBox.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
hdSpeedBox.BorderSizePixel = 0
hdSpeedBox.TextColor3 = Color3.fromRGB(255, 255, 255)
hdSpeedBox.PlaceholderText = "Speed (s)"
hdSpeedBox.Text = "0.01"
hdSpeedBox.ClearTextOnFocus = false
hdSpeedBox.Font = Enum.Font.SourceSans
hdSpeedBox.TextSize = 16
hdSpeedBox.Parent = sf4
Instance.new("UICorner", hdSpeedBox).CornerRadius = UDim.new(0, 10)

local hdSendButton = Instance.new("TextButton")
hdSendButton.Size = UDim2.new(0.25, 0, 0.12, 0)
hdSendButton.Position = UDim2.new(0.45, 0, 0.2, 0)
hdSendButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
hdSendButton.BorderSizePixel = 0
hdSendButton.TextColor3 = Color3.fromRGB(255, 255, 255)
hdSendButton.Text = "Send"
hdSendButton.TextScaled = true
hdSendButton.Font = Enum.Font.SourceSansBold
hdSendButton.Parent = sf4
Instance.new("UICorner", hdSendButton).CornerRadius = UDim.new(0, 10)

local hdSpamButton = Instance.new("TextButton")
hdSpamButton.Size = UDim2.new(0.25, 0, 0.12, 0)
hdSpamButton.Position = UDim2.new(0.72, 0, 0.2, 0)
hdSpamButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
hdSpamButton.BorderSizePixel = 0
hdSpamButton.TextColor3 = Color3.fromRGB(255, 255, 255)
hdSpamButton.Text = "Spam"
hdSpamButton.TextScaled = true
hdSpamButton.Font = Enum.Font.SourceSansBold
hdSpamButton.Parent = sf4
Instance.new("UICorner", hdSpamButton).CornerRadius = UDim.new(0, 10)

local isHdSpamming = false
local hdLoop = nil

hdSendButton.MouseButton1Click:Connect(function()
local cmd = cmdBox.Text
if cmd == "" then return end
sendCommand(cmd)
ShowScriptMessage("Command sent: " .. cmd, 3)
end)

hdSpamButton.MouseButton1Click:Connect(function()
if isHdSpamming then
isHdSpamming = false
if hdLoop then safeCancel(hdLoop) end
hdSpamButton.Text = "Spam"
hdSpamButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
ShowScriptMessage("HD Spam stopped", 3)
return
end
local cmd = cmdBox.Text
if cmd == "" then return end
local speed = tonumber(hdSpeedBox.Text) or 0.01
if speed < 0.001 then speed = 0.001 end
if speed > 3 then speed = 3 end
isHdSpamming = true
hdSpamButton.Text = "Stop"
hdSpamButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
hdLoop = spawn(function()
while isHdSpamming do
sendCommand(cmd)
wait(speed)
end
end)
ShowScriptMessage("HD Spam started", 3)
end)

local cmdBarButton = Instance.new("TextButton")
cmdBarButton.Size = UDim2.new(0.25, 0, 0.12, 0)
cmdBarButton.Position = UDim2.new(0.37, 0, 0.4, 0)
cmdBarButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
cmdBarButton.BorderSizePixel = 0
cmdBarButton.TextColor3 = Color3.fromRGB(255, 255, 255)
cmdBarButton.Text = "CmdBar"
cmdBarButton.TextScaled = true
cmdBarButton.Font = Enum.Font.SourceSansBold
cmdBarButton.Parent = sf4
Instance.new("UICorner", cmdBarButton).CornerRadius = UDim.new(0, 10)

local cmdBarInstances = {}

cmdBarButton.MouseButton1Click:Connect(function()
local cmdBarGui = Instance.new("ScreenGui")
cmdBarGui.Name = "CmdBarGUI"
cmdBarGui.ResetOnSpawn = false
cmdBarGui.Parent = player:WaitForChild("PlayerGui")
table.insert(cmdBarInstances, cmdBarGui)

local f = Instance.new("Frame")  
f.Size = UDim2.new(0, 320, 0, 150)  
f.Position = UDim2.new(0.5, -160, 0.5 + (#cmdBarInstances * 0.06), 0)  
f.BackgroundColor3 = Color3.fromRGB(0, 0, 0)  
f.BackgroundTransparency = 0.2  
f.BorderSizePixel = 0  
f.Active = true  
f.Draggable = true  
f.Parent = cmdBarGui  
Instance.new("UICorner", f).CornerRadius = UDim.new(0, 12)  
  
local titleCmd = Instance.new("TextLabel")  
titleCmd.Size = UDim2.new(1, 0, 0.12, 0)  
titleCmd.Position = UDim2.new(0, 0, 0, 0)  
titleCmd.BackgroundTransparency = 1  
titleCmd.BorderSizePixel = 0  
titleCmd.Text = "CMD BAR"  
titleCmd.TextColor3 = Color3.fromRGB(0, 200, 0)  
titleCmd.TextScaled = true  
titleCmd.Font = Enum.Font.SourceSansBold  
titleCmd.Parent = f  
  
local txt = Instance.new("TextBox")  
txt.Size = UDim2.new(1, -10, 0.3, 0)  
txt.Position = UDim2.new(0, 5, 0.14, 0)  
txt.BackgroundColor3 = Color3.fromRGB(40, 40, 55)  
txt.BorderSizePixel = 0  
txt.TextColor3 = Color3.fromRGB(255, 255, 255)  
txt.PlaceholderText = "Command (each line = command)"  
txt.Text = ""  
txt.ClearTextOnFocus = false  
txt.Font = Enum.Font.SourceSans  
txt.TextSize = 14  
txt.Parent = f  
Instance.new("UICorner", txt).CornerRadius = UDim.new(0, 8)  
  
local strengthBox = Instance.new("TextBox")  
strengthBox.Size = UDim2.new(0.3, 0, 0.18, 0)  
strengthBox.Position = UDim2.new(0.05, 0, 0.5, 0)  
strengthBox.BackgroundColor3 = Color3.fromRGB(40, 40, 55)  
strengthBox.BorderSizePixel = 0  
strengthBox.TextColor3 = Color3.fromRGB(255, 255, 255)  
strengthBox.PlaceholderText = "Strength"  
strengthBox.Text = "5"  
strengthBox.ClearTextOnFocus = false  
strengthBox.Font = Enum.Font.SourceSans  
strengthBox.TextSize = 14  
strengthBox.Parent = f  
Instance.new("UICorner", strengthBox).CornerRadius = UDim.new(0, 8)  
  
local cmdBarBtn = Instance.new("TextButton")  
cmdBarBtn.Size = UDim2.new(0.3, 0, 0.18, 0)  
cmdBarBtn.Position = UDim2.new(0.4, 0, 0.5, 0)  
cmdBarBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)  
cmdBarBtn.BorderSizePixel = 0  
cmdBarBtn.TextColor3 = Color3.fromRGB(255, 255, 255)  
cmdBarBtn.Text = "Send"  
cmdBarBtn.TextScaled = true  
cmdBarBtn.Font = Enum.Font.SourceSansBold  
cmdBarBtn.Parent = f  
Instance.new("UICorner", cmdBarBtn).CornerRadius = UDim.new(0, 8)  
  
local closeBtnCmd = Instance.new("TextButton")  
closeBtnCmd.Size = UDim2.new(0, 25, 0, 20)  
closeBtnCmd.Position = UDim2.new(1, -30, 0, 5)  
closeBtnCmd.BackgroundColor3 = Color3.fromRGB(200, 0, 0)  
closeBtnCmd.BorderSizePixel = 0  
closeBtnCmd.TextColor3 = Color3.fromRGB(255, 255, 255)  
closeBtnCmd.Text = "X"  
closeBtnCmd.TextScaled = true  
closeBtnCmd.Font = Enum.Font.SourceSansBold  
closeBtnCmd.Parent = f  
Instance.new("UICorner", closeBtnCmd).CornerRadius = UDim.new(0, 6)  
  
local isSending = false  
local loopTask = nil  
  
cmdBarBtn.MouseButton1Click:Connect(function()  
    local cmd = txt.Text  
    if cmd == "" then return end  
    local strength = tonumber(strengthBox.Text) or 5  
    if strength < 1 then strength = 1 end  
    if strength > 50 then strength = 50 end  
      
    isSending = not isSending  
    if isSending then  
        cmdBarBtn.Text = "Stop"  
        cmdBarBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)  
        loopTask = spawn(function()  
            while isSending do  
                for i = 1, strength do  
                    for line in cmd:gmatch("[^\r\n]+") do  
                        sendCommand(line)  
                        wait(0.01)  
                    end  
                end  
                wait(0.1)  
            end  
        end)  
        ShowScriptMessage("CmdBar started", 3)  
    else  
        cmdBarBtn.Text = "Send"  
        cmdBarBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)  
        if loopTask then safeCancel(loopTask) end  
        ShowScriptMessage("CmdBar stopped", 3)  
    end  
end)  
  
closeBtnCmd.MouseButton1Click:Connect(function()  
    isSending = false  
    if loopTask then safeCancel(loopTask) end  
    cmdBarGui:Destroy()  
    for i, inst in ipairs(cmdBarInstances) do  
        if inst == cmdBarGui then  
            table.remove(cmdBarInstances, i)  
            break  
        end  
    end  
end)

end)

-- Section navigation helper
local function switchSectionByName(sectionName)
    for i, name in ipairs(sections) do
        if name == sectionName then
            currentSection = i
            for j, sf in ipairs(sectionFrames) do
                local active = (j == i)
                sf.Visible = active
                sectionButtons[j].BackgroundColor3 = active and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(30, 30, 45)
                sectionButtons[j].BackgroundTransparency = active and 0 or 0.4
                sectionButtons[j].TextColor3 = active and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(200, 200, 200)
            end
            return true
        end
    end
    return false
end

-- Separate Protection Control Center. It is not a sidebar section.
local protectionGui = nil
local protectionFrame = nil
local protectionRenderConnection = nil
local antiNPEnabled = false
local antiWarpEnabled = false

local function nukeAndReplaceProtectionCamera()
local oldCam = Workspace.CurrentCamera
if not oldCam then return end
local newCam = Instance.new("Camera")
newCam.Name = "Camera"
newCam.CameraType = Enum.CameraType.Custom
newCam.FieldOfView = 70
if player.Character then
local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
if humanoid then newCam.CameraSubject = humanoid end
end
newCam.Parent = Workspace
Workspace.CurrentCamera = newCam
pcall(function() oldCam:Destroy() end)
end

local function checkAndFixProtectionWarp()
if not antiWarpEnabled then return end
local camera = Workspace.CurrentCamera
if not camera then return end
local needsReset = camera.FieldOfView > 75 or camera.FieldOfView < 65
if not needsReset then
for _, child in ipairs(camera:GetChildren()) do
if child:IsA("BlurEffect") or child:IsA("ColorCorrectionEffect") then needsReset = true break end
end
end
if needsReset then nukeAndReplaceProtectionCamera() end
for _, child in ipairs(Lighting:GetChildren()) do
local childName = string.lower(child.Name)
if childName:find("warp", 1, true) or child:IsA("PostEffect") then pcall(function() child:Destroy() end) end
end
end

local function reduceProtectionMapGraphics()
pcall(function()
Lighting.GlobalShadows = false
Lighting.FogEnd = 9e9
for _, obj in ipairs(Workspace:GetDescendants()) do
if obj:IsA("BasePart") then
obj.Material = Enum.Material.SmoothPlastic
obj.Reflectance = 0
elseif obj:IsA("PostEffect") or obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Smoke") or obj:IsA("Fire") then
obj.Enabled = false
end
end
end)
end

local function banishProtectionEntity(entity)
if not antiNPEnabled or entity == player.Character then return end
pcall(function()
for _, part in ipairs(entity:GetDescendants()) do
if part:IsA("BasePart") then
part.Transparency = 1
part.CanCollide = false
part.Anchored = true
part.CFrame = CFrame.new(0, -99999, 0)
elseif part:IsA("Decal") or part:IsA("Texture") then part.Transparency = 1 end
end
entity.Parent = nil
end)
end

local function createProtectionControlCenter()
if protectionGui and protectionGui.Parent then
protectionGui.Enabled = not protectionGui.Enabled
return
end
protectionGui = Instance.new("ScreenGui")
protectionGui.Name = "ProtectionControlCenter"
protectionGui.ResetOnSpawn = false
protectionGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
protectionGui.Parent = playerGui

protectionFrame = Instance.new("Frame")
protectionFrame.Size = UDim2.new(0, 190, 0, 115)
protectionFrame.Position = UDim2.new(0.05, 0, 0.2, 0)
protectionFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
protectionFrame.BorderSizePixel = 0
protectionFrame.Active = true
protectionFrame.Draggable = true
protectionFrame.Parent = protectionGui
Instance.new("UICorner", protectionFrame).CornerRadius = UDim.new(0, 8)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 25)
title.Text = "Control Panel"
title.TextColor3 = Color3.fromRGB(255, 215, 0)
title.BackgroundTransparency = 1
title.Font = Enum.Font.SourceSansBold
title.TextSize = 15
title.Parent = protectionFrame

local btnAntiNP = Instance.new("TextButton")
btnAntiNP.Name = "AntiNP"
btnAntiNP.Size = UDim2.new(0.9, 0, 0, 32)
btnAntiNP.Position = UDim2.new(0.05, 0, 0.28, 0)
btnAntiNP.BackgroundColor3 = Color3.fromRGB(185, 45, 45)
btnAntiNP.Text = "Anti-NP: OFF"
btnAntiNP.TextColor3 = Color3.fromRGB(255, 255, 255)
btnAntiNP.Font = Enum.Font.SourceSansBold
btnAntiNP.TextSize = 13
btnAntiNP.Parent = protectionFrame
Instance.new("UICorner", btnAntiNP).CornerRadius = UDim.new(0, 6)

local btnAntiWarp = Instance.new("TextButton")
btnAntiWarp.Name = "AntiWarp"
btnAntiWarp.Size = UDim2.new(0.9, 0, 0, 32)
btnAntiWarp.Position = UDim2.new(0.05, 0, 0.63, 0)
btnAntiWarp.BackgroundColor3 = Color3.fromRGB(185, 45, 45)
btnAntiWarp.Text = "Anti-Warp: OFF"
btnAntiWarp.TextColor3 = Color3.fromRGB(255, 255, 255)
btnAntiWarp.Font = Enum.Font.SourceSansBold
btnAntiWarp.TextSize = 13
btnAntiWarp.Parent = protectionFrame
Instance.new("UICorner", btnAntiWarp).CornerRadius = UDim.new(0, 6)
addButtonFeedback(btnAntiNP)
addButtonFeedback(btnAntiWarp)

btnAntiNP.MouseButton1Click:Connect(function()
antiNPEnabled = not antiNPEnabled
if antiNPEnabled then
btnAntiNP.Text = "Anti-NP: ON"
btnAntiNP.BackgroundColor3 = Color3.fromRGB(46, 139, 87)
reduceProtectionMapGraphics()
else
btnAntiNP.Text = "Anti-NP: OFF"
btnAntiNP.BackgroundColor3 = Color3.fromRGB(185, 45, 45)
end
end)

btnAntiWarp.MouseButton1Click:Connect(function()
antiWarpEnabled = not antiWarpEnabled
if antiWarpEnabled then
btnAntiWarp.Text = "Anti-Warp: ON"
btnAntiWarp.BackgroundColor3 = Color3.fromRGB(46, 139, 87)
nukeAndReplaceProtectionCamera()
else
btnAntiWarp.Text = "Anti-Warp: OFF"
btnAntiWarp.BackgroundColor3 = Color3.fromRGB(185, 45, 45)
end
end)

if not protectionRenderConnection then
protectionRenderConnection = RunService.RenderStepped:Connect(function()
checkAndFixProtectionWarp()
if antiNPEnabled then
for _, plr in ipairs(Players:GetPlayers()) do
if plr ~= player and plr.Character then banishProtectionEntity(plr.Character) end
end
for _, obj in ipairs(Workspace:GetChildren()) do
if obj:IsA("Model") and obj ~= player.Character and obj:FindFirstChildOfClass("Humanoid") then banishProtectionEntity(obj) end
end
end
end)
end
end

-- Anti
local sf5 = sectionFrames[table.find(sections, "Anti")]

local VoidOriginalPos = nil
local KillOriginalPos = nil
local WifiOriginalPos = nil
local AntiBangOriginalPos = nil

-- دوال مساعدة لإرسال الأوامر بنفس طريقة السكربت المرفق (في الخلفية)
local function clickButton(button)
if typeof(firesignal) == "function" then
local success = pcall(function()
firesignal(button.MouseButton1Click)
end)
if success then return true end
end

if typeof(getconnections) == "function" then  
    local success, connections = pcall(function()  
        return getconnections(button.MouseButton1Click)  
    end)  
    if success and connections then  
        for _, connection in ipairs(connections) do  
            if connection.Function then  
                pcall(function()  
                    connection.Function()  
                end)  
                return true  
            end  
        end  
    end  
end  
return false

end

local function sendSkinCommand(name)
pcall(function()
local ScreenGui = player.PlayerGui:FindFirstChild("ScreenGui")
if not ScreenGui then return end

local HiddenCommands = ScreenGui:FindFirstChild("HiddenCommands")  
    local InputFrame = ScreenGui:FindFirstChild("Input")  
      
    if HiddenCommands and InputFrame then  
        local ScrollingFrame = HiddenCommands:FindFirstChild("ScrollingFrame")  
        local Input = InputFrame:FindFirstChild("Input")  
        local Confirm = InputFrame:FindFirstChild("ChangeName")  
          
        if ScrollingFrame and Input and Confirm then  
            local ChangeSkin = ScrollingFrame:FindFirstChild("ChangeSkin")  
            if ChangeSkin then  
                clickButton(ChangeSkin)  
                wait()  
                Input.Text = name  
                wait()  
                clickButton(Confirm)  
                wait()  
                  
                pcall(function()  
                    HiddenCommands.Visible = false  
                    InputFrame.Visible = false  
                end)  
            end  
        end  
    end  
end)

end

local antiButtonsData = {
{"anticopy", 0.02, 0.45},
{"antiafk", 0.02, 0.30},
{"antivoid", 0.52, 0.30},
{"antilag", 0.02, 0.15},
{"antiBang", 0.52, 0.45},
{"Wifi", 0.02, 0.0},
{"Void", 0.52, 0.0},
{"Kill", 0.52, 0.15},
{"AntiNv", 0.28, 0.60}
}

local function createAntiButton(name, xPos, yPos)
local btn = Instance.new("TextButton")
btn.Size = UDim2.new(name == "AntiNv" and 0.9 or 0.45, 0, 0.09, 0)
btn.Position = UDim2.new(name == "AntiNv" and 0.05 or xPos, 0, name == "AntiNv" and 0.75 or yPos, 0)
btn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
btn.BorderSizePixel = 0
btn.TextColor3 = Color3.fromRGB(255, 255, 255)
btn.Text = name == "AntiNv" and "Anti-NV" or name
btn.TextScaled = true
btn.Font = Enum.Font.SourceSansBold
btn.Parent = sf5
Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)


local isActive = false
local loopTask = nil  
  
btn.MouseButton1Click:Connect(function()  
    isActive = not isActive  
    if isActive then  
        btn.Text = "Stop"  
        btn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)  
          
        if name == "anticopy" then
            -- AntiCopy: تغيير السكنات بالتناوب من دون إظهار قائمة تغيير السكن.
            -- نفس الأسماء الموجودة في الكود الذي أرسلته.
            local skinNames = {
                "nan_fm7",
                "nanmewelldoit"
            }

            local skinIndex = 1

            -- يحاول تنفيذ زر اللعبة الأصلي ثم يخفي واجهته فوراً.
            -- لا ينشئ أي قائمة إضافية للمستخدم.
            local function changeSkinSilently(skinName)
                if not isActive then return end

                pcall(function()
                    local pg = player:FindFirstChild("PlayerGui")
                    if not pg then return end

                    local originalGui = pg:FindFirstChild("ScreenGui")
                    if not originalGui then return end

                    local hiddenCommands = originalGui:FindFirstChild("HiddenCommands")
                    local inputFrame = originalGui:FindFirstChild("Input")
                    local scrollingFrame = hiddenCommands and hiddenCommands:FindFirstChild("ScrollingFrame")
                    local inputBox = inputFrame and inputFrame:FindFirstChild("Input")
                    local confirmButton = inputFrame and inputFrame:FindFirstChild("ChangeName")
                    local changeSkinButton = scrollingFrame and scrollingFrame:FindFirstChild("ChangeSkin")

                    if not (hiddenCommands and inputFrame and inputBox and confirmButton and changeSkinButton) then
                        return
                    end

                    -- نحفظ الحالة ثم نخفي الواجهات قبل التنفيذ حتى لا تظهر للمستخدم.
                    local oldHiddenVisible = hiddenCommands.Visible
                    local oldInputVisible = inputFrame.Visible

                    hiddenCommands.Visible = false
                    inputFrame.Visible = false

                    inputBox.Text = skinName

                    -- تنفيذ نفس زر ChangeSkin الأصلي.
                    clickButton(changeSkinButton)
                    task.wait(0.03)

                    -- إعادة كتابة الاسم بعد فتح الأمر، ثم التأكيد.
                    inputBox.Text = skinName
                    task.wait(0.03)
                    clickButton(confirmButton)

                    -- نضمن عدم ظهور القوائم الأصلية.
                    hiddenCommands.Visible = false
                    inputFrame.Visible = false

                    -- لا نعيد الواجهات تلقائياً أثناء AntiCopy.
                    -- إذا كانت اللعبة تعيد إظهارها، سيقوم هذا السكربت بإخفائها في الدورة التالية.
                    local _ = oldHiddenVisible
                    local _2 = oldInputVisible
                end)
            end

            loopTask = task.spawn(function()
                while isActive do
                    changeSkinSilently(skinNames[skinIndex])

                    skinIndex += 1
                    if skinIndex > #skinNames then
                        skinIndex = 1
                    end

                    task.wait(0.2)
                end
            end)

            ShowScriptMessage("AntiCopy started", 3)
        elseif name == "antiafk" then  
            loopTask = spawn(function()  
                while isActive do  
                    if isActive then EnableAntiAFK() else DisableAntiAFK() end  
                    wait(1)  
                end  
            end)  
            ShowScriptMessage("AntiAFK started", 3)  
        elseif name == "antivoid" then  
            local safePos = CFrame.new(1801, 21, 624)  
            loopTask = spawn(function()  
                while isActive do  
                    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then  
                        local root = player.Character.HumanoidRootPart  
                        if root.Position.Y < -50 or root.Position.Y > 1000 or root.Position.Magnitude > 5000 then  
                            root.CFrame = safePos  
                        end  
                    end  
                    wait(0.1)  
                end  
            end)  
            ShowScriptMessage("AntiVoid started", 3)  
        elseif name == "antilag" then  
            loopTask = spawn(function()  
                while isActive do  
                    pcall(function()  
                        Lighting.Brightness = 0  
                        Lighting.OutdoorAmbient = Color3.fromRGB(0, 0, 0)  
                        Lighting.Ambient = Color3.fromRGB(0, 0, 0)  
                    end)  
                    wait(5)  
                end  
            end)  
            ShowScriptMessage("AntiLag started", 3)  
        elseif name == "antiBang" then
            -- AntiBang: حماية محلية. إذا كان هناك لاعب محدد في Target يستخدم الحركة
            -- بالقرب منك، نحفظ مكانك ثم ننقلك مؤقتاً ونرجعك للمكان المحفوظ.
            -- عند الإيقاف نعيدك أيضاً إلى آخر مكان محفوظ.
            local function getRoot(plr)
                return plr and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
            end

            local myRoot = getRoot(player)
            if myRoot then
                AntiBangOriginalPos = myRoot.CFrame
            end

            local function looksLikeBang(plr)
                local char = plr and plr.Character
                if not char then return false end
                local humanoid = char:FindFirstChildOfClass("Humanoid")
                local animator = humanoid and humanoid:FindFirstChildOfClass("Animator")
                if animator then
                    for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
                        local anim = track.Animation
                        local id = anim and tostring(anim.AnimationId) or ""
                        if id:find("5918726674", 1, true) then
                            return true
                        end
                    end
                end
                return false
            end

            loopTask = task.spawn(function()
                while isActive do
                    pcall(function()
                        local root = getRoot(player)
                        if not root then return end

                        local targets = {}
                        if selectedPlayer and selectedPlayer ~= player and selectedPlayer.Parent then
                            table.insert(targets, selectedPlayer)
                        else
                            for _, plr in ipairs(Players:GetPlayers()) do
                                if plr ~= player then table.insert(targets, plr) end
                            end
                        end

                        for _, plr in ipairs(targets) do
                            local targetRoot = getRoot(plr)
                            if targetRoot then
                                local distance = (root.Position - targetRoot.Position).Magnitude
                                if distance < 6 and looksLikeBang(plr) then
                                    if not AntiBangOriginalPos then
                                        AntiBangOriginalPos = root.CFrame
                                    end

                                    -- إزالة القيود المحلية التي قد تكون مستخدمة للحركة.
                                    for _, child in ipairs(root:GetChildren()) do
                                        if child:IsA("Attachment") or child:IsA("AlignPosition") or child:IsA("AlignOrientation") then
                                            pcall(function() child:Destroy() end)
                                        end
                                    end

                                    -- خروج لحظي من موضع الاصطدام ثم الرجوع للمكان الأصلي.
                                    local safeCFrame = AntiBangOriginalPos + Vector3.new(0, 25, 0)
                                    root.CFrame = safeCFrame
                                    root.AssemblyLinearVelocity = Vector3.zero
                                    task.wait(0.08)
                                    if isActive and root.Parent then
                                        root.CFrame = AntiBangOriginalPos
                                        root.AssemblyLinearVelocity = Vector3.zero
                                    end
                                    break
                                end
                            end
                        end
                    end)
                    task.wait(0.03)
                end
            end)
            ShowScriptMessage("AntiBang started", 3)
        elseif name == "Wifi" then  
            local wifiPositions = {  
                CFrame.new(2147483648, 944401, -2),  
                CFrame.new(1134, -271, 408),  
                CFrame.new(1801, 21, 624),  
                CFrame.new(-5000, -5000, -5000),  
                CFrame.new(5000, 5000, 5000),  
                CFrame.new(0, 10000, 0),  
                CFrame.new(10000, 0, 10000),  
                CFrame.new(-10000, 0, -10000)  
            }  
            local wifiIndex = 1  
            loopTask = spawn(function()  
                while isActive do  
                    pcall(function()  
                        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then  
                            local root = player.Character.HumanoidRootPart  
                            if not WifiOriginalPos then WifiOriginalPos = root.CFrame end  
                              
                            root.CFrame = wifiPositions[wifiIndex]  
                              
                            wifiIndex = wifiIndex + 1  
                            if wifiIndex > #wifiPositions then  
                                wifiIndex = 1  
                            end  
                              
                            local near = getNearPlayers()  
                            for _, plr in ipairs(near) do  
                                sendCommand("!re " .. plr.Name)  
                                wait(0.05)  
                            end  
                        end  
                    end)  
                    wait(0.1)  
                end  
            end)  
            ShowScriptMessage("Wifi started", 3)  
        elseif name == "Void" then  
            local voidPos = CFrame.new(2147483648, 944401, -2)  
            loopTask = spawn(function()  
                while isActive do  
                    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then  
                        local root = player.Character.HumanoidRootPart  
                        if not VoidOriginalPos then VoidOriginalPos = root.CFrame end  
                        root.CFrame = voidPos  
                    end  
                    wait(0.1)  
                end  
            end)  
            ShowScriptMessage("Void started", 3)  
        elseif name == "Kill" then  
            local killPos = CFrame.new(1134, -271, 408)  
            loopTask = spawn(function()  
                while isActive do  
                    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then  
                        local root = player.Character.HumanoidRootPart  
                        if not KillOriginalPos then KillOriginalPos = root.CFrame end  
                        root.CFrame = killPos  
                    end  
                    wait(0.1)  
                end  
            end)  
            ShowScriptMessage("Kill started", 3)  
        elseif name == "AntiNv" then
            loopTask = spawn(function()
                while isActive do
                    sendCommand("!unnv")
                    wait(0.03)
                    sendCommand("!unwarp")
                    wait(0.03)
                end
            end)
            ShowScriptMessage("AntiNv started", 3)
        end  
    else  
        btn.Text = name == "AntiNv" and "Anti-NV" or name  
        btn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)  
        if loopTask then safeCancel(loopTask) end  
        if name == "antiafk" then DisableAntiAFK() end  
        if name == "Void" and VoidOriginalPos and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then  
            player.Character.HumanoidRootPart.CFrame = VoidOriginalPos  
            VoidOriginalPos = nil  
        end  
        if name == "Kill" and KillOriginalPos and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then  
            player.Character.HumanoidRootPart.CFrame = KillOriginalPos  
            KillOriginalPos = nil  
        end  
        if name == "Wifi" and WifiOriginalPos and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then  
            player.Character.HumanoidRootPart.CFrame = WifiOriginalPos  
            WifiOriginalPos = nil  
        end
        if name == "antiBang" and AntiBangOriginalPos and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            player.Character.HumanoidRootPart.CFrame = AntiBangOriginalPos
            player.Character.HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero
            AntiBangOriginalPos = nil
        end
        ShowScriptMessage(name .. " stopped", 3)  
    end  
end)

if name == "AntiNv" then
local openNvButton = Instance.new("TextButton")
openNvButton.Name = "OpenNVControlCenter"
openNvButton.Size = UDim2.new(0.9, 0, 0.08, 0)
openNvButton.Position = UDim2.new(0.05, 0, 0.85, 0)
openNvButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
openNvButton.BorderSizePixel = 0
openNvButton.TextColor3 = Color3.fromRGB(255, 255, 255)
openNvButton.Text = "NV"
openNvButton.TextScaled = true
openNvButton.Font = Enum.Font.SourceSansBold
openNvButton.Parent = sf5
Instance.new("UICorner", openNvButton).CornerRadius = UDim.new(0, 8)
addButtonFeedback(openNvButton)
openNvButton.MouseButton1Click:Connect(function()
createProtectionControlCenter()
ShowScriptMessage("Protection Control Center opened", 2)
end)
end

end

for _, data in ipairs(antiButtonsData) do
createAntiButton(data[1], data[2], data[3])
end

-- Near
local sf6 = sectionFrames[table.find(sections, "Near")]

local nearCmdBox = Instance.new("TextBox")
nearCmdBox.Size = UDim2.new(1, -20, 0.15, 0)
nearCmdBox.Position = UDim2.new(0, 10, 0.02, 0)
nearCmdBox.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
nearCmdBox.BorderSizePixel = 0
nearCmdBox.TextColor3 = Color3.fromRGB(255, 255, 255)
nearCmdBox.PlaceholderText = "Command (use 'user' for near players)..."
nearCmdBox.Text = ""
nearCmdBox.ClearTextOnFocus = false
nearCmdBox.Font = Enum.Font.SourceSans
nearCmdBox.TextSize = 16
nearCmdBox.Parent = sf6
Instance.new("UICorner", nearCmdBox).CornerRadius = UDim.new(0, 10)

local nearSpeedBox = Instance.new("TextBox")
nearSpeedBox.Size = UDim2.new(0.35, 0, 0.12, 0)
nearSpeedBox.Position = UDim2.new(0.05, 0, 0.2, 0)
nearSpeedBox.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
nearSpeedBox.BorderSizePixel = 0
nearSpeedBox.TextColor3 = Color3.fromRGB(255, 255, 255)
nearSpeedBox.PlaceholderText = "Speed (s)"
nearSpeedBox.Text = "0.5"
nearSpeedBox.ClearTextOnFocus = false
nearSpeedBox.Font = Enum.Font.SourceSans
nearSpeedBox.TextSize = 16
nearSpeedBox.Parent = sf6
Instance.new("UICorner", nearSpeedBox).CornerRadius = UDim.new(0, 10)

local nearSendButton = Instance.new("TextButton")
nearSendButton.Size = UDim2.new(0.25, 0, 0.12, 0)
nearSendButton.Position = UDim2.new(0.45, 0, 0.2, 0)
nearSendButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
nearSendButton.BorderSizePixel = 0
nearSendButton.TextColor3 = Color3.fromRGB(255, 255, 255)
nearSendButton.Text = "Send"
nearSendButton.TextScaled = true
nearSendButton.Font = Enum.Font.SourceSansBold
nearSendButton.Parent = sf6
Instance.new("UICorner", nearSendButton).CornerRadius = UDim.new(0, 10)

local nearSpamButton = Instance.new("TextButton")
nearSpamButton.Size = UDim2.new(0.25, 0, 0.12, 0)
nearSpamButton.Position = UDim2.new(0.72, 0, 0.2, 0)
nearSpamButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
nearSpamButton.BorderSizePixel = 0
nearSpamButton.TextColor3 = Color3.fromRGB(255, 255, 255)
nearSpamButton.Text = "Spam"
nearSpamButton.TextScaled = true
nearSpamButton.Font = Enum.Font.SourceSansBold
nearSpamButton.Parent = sf6
Instance.new("UICorner", nearSpamButton).CornerRadius = UDim.new(0, 10)

local nearAuraButton = Instance.new("TextButton")
nearAuraButton.Size = UDim2.new(0.25, 0, 0.12, 0)
nearAuraButton.Position = UDim2.new(0.02, 0, 0.38, 0)
nearAuraButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
nearAuraButton.BorderSizePixel = 0
nearAuraButton.TextColor3 = Color3.fromRGB(255, 255, 255)
nearAuraButton.Text = "Aura"
nearAuraButton.TextScaled = true
nearAuraButton.Font = Enum.Font.SourceSansBold
nearAuraButton.Parent = sf6
Instance.new("UICorner", nearAuraButton).CornerRadius = UDim.new(0, 10)

local nearReButton = Instance.new("TextButton")
nearReButton.Size = UDim2.new(0.25, 0, 0.12, 0)
nearReButton.Position = UDim2.new(0.3, 0, 0.38, 0)
nearReButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
nearReButton.BorderSizePixel = 0
nearReButton.TextColor3 = Color3.fromRGB(255, 255, 255)
nearReButton.Text = "Re"
nearReButton.TextScaled = true
nearReButton.Font = Enum.Font.SourceSansBold
nearReButton.Parent = sf6
Instance.new("UICorner", nearReButton).CornerRadius = UDim.new(0, 10)

local nearStatus = Instance.new("TextLabel")
nearStatus.Size = UDim2.new(1, 0, 0.08, 0)
nearStatus.Position = UDim2.new(0, 0, 0.55, 0)
nearStatus.BackgroundTransparency = 1
nearStatus.BorderSizePixel = 0
nearStatus.Text = "Stopped"
nearStatus.TextColor3 = Color3.fromRGB(255, 255, 0)
nearStatus.TextScaled = true
nearStatus.Font = Enum.Font.SourceSans
nearStatus.Parent = sf6

local nearSpamActive = false
local nearAuraActive = false
local nearReActive = false
local nearSpamLoop = nil
local nearAuraLoop = nil
local nearReLoop = nil

local function sendToNearPlayers(cmd)
local near = getNearPlayers()
if #near == 0 then
ShowPopupMessage("No near players found!", 2, Color3.fromRGB(255, 200, 0))
return
end
for _, plr in ipairs(near) do
local finalCmd = cmd:gsub("user", plr.Name)
sendCommand(finalCmd)
wait(0.05)
end
end

nearSendButton.MouseButton1Click:Connect(function()
local cmd = nearCmdBox.Text
if cmd == "" then return end
sendToNearPlayers(cmd)
nearStatus.Text = "Sent"
nearStatus.TextColor3 = Color3.fromRGB(0, 255, 0)
wait(0.5)
nearStatus.Text = "Stopped"
nearStatus.TextColor3 = Color3.fromRGB(255, 255, 0)
ShowScriptMessage("Command sent to near players", 3)
end)

nearSpamButton.MouseButton1Click:Connect(function()
nearSpamActive = not nearSpamActive
if nearSpamActive then
local cmd = nearCmdBox.Text
if cmd == "" then
nearSpamActive = false
return
end
local speed = tonumber(nearSpeedBox.Text) or 0.5
if speed < 0.1 then speed = 0.1 end
if speed > 3 then speed = 3 end
nearSpamButton.Text = "Stop"
nearSpamButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
nearStatus.Text = "Running..."
nearStatus.TextColor3 = Color3.fromRGB(0, 255, 0)
nearSpamLoop = spawn(function()
while nearSpamActive do
sendToNearPlayers(cmd)
wait(speed)
end
end)
ShowScriptMessage("Near Spam started", 3)
else
nearSpamButton.Text = "Spam"
nearSpamButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
nearStatus.Text = "Stopped"
nearStatus.TextColor3 = Color3.fromRGB(255, 255, 0)
if nearSpamLoop then safeCancel(nearSpamLoop) end
nearSpamLoop = nil
ShowScriptMessage("Near Spam stopped", 3)
end
end)

nearAuraButton.MouseButton1Click:Connect(function()
nearAuraActive = not nearAuraActive
if nearAuraActive then
nearAuraButton.Text = "Stop"
nearAuraButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
nearStatus.Text = "Running..."
nearStatus.TextColor3 = Color3.fromRGB(0, 255, 0)
nearAuraLoop = spawn(function()
while nearAuraActive do
sendToNearPlayers("!aura user")
wait(0.1)
end
end)
ShowScriptMessage("Near Aura started", 3)
else
nearAuraButton.Text = "Aura"
nearAuraButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
nearStatus.Text = "Stopped"
nearStatus.TextColor3 = Color3.fromRGB(255, 255, 0)
if nearAuraLoop then safeCancel(nearAuraLoop) end
nearAuraLoop = nil
ShowScriptMessage("Near Aura stopped", 3)
end
end)

nearReButton.MouseButton1Click:Connect(function()
nearReActive = not nearReActive
if nearReActive then
nearReButton.Text = "Stop"
nearReButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
nearStatus.Text = "Running..."
nearStatus.TextColor3 = Color3.fromRGB(0, 255, 0)
nearReLoop = spawn(function()
while nearReActive do
sendToNearPlayers("!re user")
wait(0.01)
end
end)
ShowScriptMessage("Near Re started", 3)
else
nearReButton.Text = "Re"
nearReButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
nearStatus.Text = "Stopped"
nearStatus.TextColor3 = Color3.fromRGB(255, 255, 0)
if nearReLoop then safeCancel(nearReLoop) end
nearReLoop = nil
ShowScriptMessage("Near Re stopped", 3)
end
end)

-- SQR
local sf8 = sectionFrames[table.find(sections, "SQR")]

local infoText = Instance.new("TextLabel")
infoText.Size = UDim2.new(1, -20, 0.85, 0)
infoText.Position = UDim2.new(0, 10, 0.01, 0)
infoText.BackgroundTransparency = 1
infoText.BorderSizePixel = 0
infoText.Text = [[Hello, I am Mr. The maker of this script completely, and all rights reserved for the group.

Number of Script Developers :

Mahdi Iraqi

Mr. Iraqi

Group S Q R


The script has many, many features that you can try and benefit from in your gameplay in many things from maps.. I hope you enjoy trying the script.

Dis SQR :
Rob Mr : nanMeWellDoit
Rob Mhdi : nanNeverLet

You can join, unlock loot, pay robux for ranks and activations, and many other features not available in the free script.. What are you waiting for? Unlock loot!]]
infoText.TextColor3 = Color3.fromRGB(200, 200, 255)
infoText.TextScaled = true
infoText.Font = Enum.Font.SourceSans
infoText.TextWrapped = true
infoText.TextXAlignment = Enum.TextXAlignment.Center
infoText.Parent = sf8

local discordBtn = Instance.new("TextButton")
discordBtn.Size = UDim2.new(0.3, 0, 0.06, 0)
discordBtn.Position = UDim2.new(0.35, 0, 0.92, 0)
discordBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
discordBtn.BorderSizePixel = 0
discordBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
discordBtn.Text = "Join Discord"
discordBtn.TextScaled = true
discordBtn.Font = Enum.Font.SourceSansBold
discordBtn.Parent = sf8
Instance.new("UICorner", discordBtn).CornerRadius = UDim.new(0, 10)

discordBtn.MouseButton1Click:Connect(function()
setclipboard("https://discord.gg/vmMyFudFd")
ShowScriptMessage("Discord link copied!", 3)
end)

--====================================================
-- SETTING
--====================================================
local sfSetting = sectionFrames[table.find(sections, "Setting")]

if sfSetting then
    sfSetting.ClipsDescendants = true
    sfSetting.ScrollBarThickness = 5
    sfSetting.CanvasSize = UDim2.new(0, 0, 0, 760)

    local settingsData = {
        {"ايتاشي", "108459072532413"}, {"ال", "76264922206194"},
        {"مايكل و سوكريه", "99042741738776"}, {"بنت انمي", "138417035920584"},
        {"ماكيما", "139118334057714"}, {"باتريك جين", "79497123255834"},
        {"كرت فضي", "131997057882632"}, {"ساسكي", "101118902102194"},
        {"مادارا", "131491969992301"}, {"تايلور", "93724754807413"},
        {"ال باتشينو", "128220812349566"}, {"جيسي", "82862976463067"},
        {"FBI", "84860336404228"}, {"اليوت", "79357712453854"},
        {"ميسي", "113200243925050"}, {"بسيط", "81751567772780"},
        {"ساموراي", "91708553471066"}, {"يوهان البرت", "87085350473257"},
        {"سول", "85257482355164"}, {"ماهون", "73520201667284"},
        {"تي باك", "106212842895961"}, {"والتر وايت", "137208889690869"},
        {"يورو", "113679705314612"}, {"يوكي", "82368191067474"},
        {"هيمينو", "97749880790314"}, {"ماكي", "113500113468926"},
    }

    local soundData = {
        {"Sound 1", "rbxassetid://12221967"},
        {"Sound 2", "rbxassetid://6026984224"},
        {"Sound 3", "rbxassetid://9118823101"},
        {"Sound 4", "rbxassetid://9120386436"},
    }

    local settingState = {
        version = 3,
        background = nil,
        sound = soundData[1][2],
        soundName = soundData[1][1],
        walkSpeed = 16,
        flySpeed = 50,
        frozen = false,
        flying = false,
        cameraFrozen = false,
        hidden = false,
        autoRespawn = false,
    }

    local HttpService = game:GetService("HttpService")

    local function saveSettings()
        pcall(function()
            if writefile and isfile then
                writefile("SQR_Settings.json", HttpService:JSONEncode(settingState))
            end
        end)
    end

    local function loadSettings()
        pcall(function()
            if readfile and isfile and isfile("SQR_Settings.json") then
                local data = HttpService:JSONDecode(readfile("SQR_Settings.json"))
                if type(data) == "table" then
                    for k,v in pairs(data) do
                        if settingState[k] ~= nil then settingState[k] = v end
                    end
                end
            end
        end)
    end

    loadSettings()
    if type(settingState.sound) == "string" and settingState.sound ~= "" then
        SQR_BUTTON_SOUND_ID = settingState.sound
    end

    -- خلفية كاملة للواجهة، بدون إطار، وخلف كل عناصر التحكم.
    local selectedBgImage = Instance.new("ImageLabel")
    selectedBgImage.Name = "SettingsBackground"
    selectedBgImage.Size = UDim2.new(1,0,1,0)
    selectedBgImage.Position = UDim2.fromOffset(0,0)
    selectedBgImage.BackgroundTransparency = 1
    selectedBgImage.BorderSizePixel = 0
    selectedBgImage.ScaleType = Enum.ScaleType.Crop
    selectedBgImage.ImageTransparency = 0.68
    selectedBgImage.ZIndex = 1
    selectedBgImage.Active = false
    selectedBgImage.Parent = mainFrame

    local settingTitle = Instance.new("TextLabel")
    settingTitle.Size = UDim2.new(1,-20,0,32)
    settingTitle.Position = UDim2.fromOffset(10,0)
    settingTitle.BackgroundTransparency = 1
    settingTitle.Text = "SETTINGS"
    settingTitle.TextColor3 = Color3.fromRGB(255,255,255)
    settingTitle.TextSize = 20
    settingTitle.Font = Enum.Font.GothamBold
    settingTitle.TextXAlignment = Enum.TextXAlignment.Center
    settingTitle.ZIndex = 5
    settingTitle.Parent = sfSetting

    local avatar = Instance.new("ImageLabel")
    avatar.Size = UDim2.fromOffset(70,70)
    avatar.Position = UDim2.fromOffset(10,38)
    avatar.BackgroundTransparency = 1
    avatar.BorderSizePixel = 0
    avatar.ScaleType = Enum.ScaleType.Fit
    avatar.ZIndex = 5
    avatar.Parent = sfSetting
    pcall(function()
        avatar.Image = Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.AvatarBust, Enum.ThumbnailSize.Size150x150)
    end)

    local playerInfo = Instance.new("TextLabel")
    playerInfo.Size = UDim2.new(1,-95,0,70)
    playerInfo.Position = UDim2.fromOffset(92,38)
    playerInfo.BackgroundTransparency = 1
    playerInfo.Text = player.DisplayName .. "\n@" .. player.Name .. "\nPlayers: " .. #Players:GetPlayers()
    playerInfo.TextColor3 = Color3.fromRGB(225,235,255)
    playerInfo.TextSize = 14
    playerInfo.Font = Enum.Font.GothamMedium
    playerInfo.TextXAlignment = Enum.TextXAlignment.Left
    playerInfo.TextYAlignment = Enum.TextYAlignment.Center
    playerInfo.ZIndex = 5
    playerInfo.Parent = sfSetting

    local function refreshPlayerInfo()
        playerInfo.Text = player.DisplayName .. "\n@" .. player.Name .. "\nPlayers: " .. #Players:GetPlayers()
    end
    Players.PlayerAdded:Connect(refreshPlayerInfo)
    Players.PlayerRemoving:Connect(refreshPlayerInfo)

    local function makeBox(text,x,y,w)
        local box=Instance.new("TextBox")
        box.Size=UDim2.fromOffset(w,38)
        box.Position=UDim2.fromOffset(x,y)
        box.BackgroundColor3=Color3.fromRGB(35,40,55)
        box.BackgroundTransparency=0.05
        box.BorderSizePixel=0
        box.TextColor3=Color3.fromRGB(255,255,255)
        box.PlaceholderText=text
        box.Text=""
        box.ClearTextOnFocus=false
        box.Font=Enum.Font.Gotham
        box.TextSize=14
        box.ZIndex=5
        box.Parent=sfSetting
        Instance.new("UICorner",box).CornerRadius=UDim.new(0,9)
        return box
    end

    local function makeButton(text,x,y,w)
        local b=Instance.new("TextButton")
        b.Size=UDim2.fromOffset(w,38)
        b.Position=UDim2.fromOffset(x,y)
        b.BackgroundColor3=Color3.fromRGB(35,40,55)
        b.BackgroundTransparency=0.05
        b.BorderSizePixel=0
        b.Text=text
        b.TextColor3=Color3.fromRGB(255,255,255)
        b.TextSize=13
        b.Font=Enum.Font.GothamBold
        b.ZIndex=5
        b.Parent=sfSetting
        Instance.new("UICorner",b).CornerRadius=UDim.new(0,9)
        addButtonFeedback(b)
        return b
    end

    -- سرعة اللاعب + تجميد
    local speedBox=makeBox("Player Speed 1-1000",10,120,210)
    speedBox.Text=tostring(settingState.walkSpeed)
    local freezeBtn=makeButton("Freeze",230,120,150)

    -- سرعة الطيران + طيران
    local flySpeedBox=makeBox("Fly Speed 1-1000",10,166,210)
    flySpeedBox.Text=tostring(settingState.flySpeed)
    local flyBtn=makeButton("Fly",230,166,150)

    local mobileFlyUp=makeButton("Fly Up",10,212,105)
    local mobileFlyDown=makeButton("Fly Down",125,212,105)
    mobileFlyUp.Visible=UIS.TouchEnabled
    mobileFlyDown.Visible=UIS.TouchEnabled

    local flyHint=Instance.new("TextLabel")
    flyHint.Size=UDim2.fromOffset(150,38)
    flyHint.Position=UDim2.fromOffset(230,212)
    flyHint.BackgroundTransparency=1
    flyHint.Text=UIS.TouchEnabled and "Touch: use Fly + movement" or "WASD + Space/Ctrl"
    flyHint.TextColor3=Color3.fromRGB(150,160,180)
    flyHint.TextSize=10
    flyHint.Font=Enum.Font.Gotham
    flyHint.TextXAlignment=Enum.TextXAlignment.Left
    flyHint.TextWrapped=true
    flyHint.ZIndex=5
    flyHint.Parent=sfSetting

    -- Freeze Camera + Hide Character
    local cameraBtn=makeButton("Freeze Camera",10,260,210)
    local hideBtn=makeButton("Hide Character",230,260,150)

    -- Auto Respawn عريض
    local respawnBtn=makeButton("Auto Respawn: OFF",10,306,370)

    local function sectionLabel(text,y)
        local label=Instance.new("TextLabel")
        label.Size=UDim2.fromOffset(370,24)
        label.Position=UDim2.fromOffset(10,y)
        label.BackgroundTransparency=1
        label.Text=text
        label.TextColor3=Color3.fromRGB(205,215,235)
        label.TextSize=13
        label.Font=Enum.Font.GothamBold
        label.TextXAlignment=Enum.TextXAlignment.Left
        label.ZIndex=5
        label.Parent=sfSetting
        return label
    end

    sectionLabel("Background",356)

    local bgButton=makeButton("Choose Background  ▼",10,384,370)
    local bgPreview=Instance.new("ImageLabel")
    bgPreview.Size=UDim2.fromOffset(30,30)
    bgPreview.Position=UDim2.new(1,-35,0.5,-15)
    bgPreview.BackgroundTransparency=1
    bgPreview.BorderSizePixel=0
    bgPreview.ScaleType=Enum.ScaleType.Crop
    bgPreview.ZIndex=7
    bgPreview.Parent=bgButton

    local bgList=Instance.new("ScrollingFrame")
    bgList.Name="BackgroundList"
    bgList.Size=UDim2.fromOffset(370,150)
    bgList.Position=UDim2.fromOffset(10,426)
    bgList.BackgroundColor3=Color3.fromRGB(18,21,30)
    bgList.BackgroundTransparency=0.05
    bgList.BorderSizePixel=0
    bgList.Visible=false
    bgList.ScrollBarThickness=4
    bgList.CanvasSize=UDim2.new(0,0,0,0)
    bgList.ZIndex=20
    bgList.Parent=sfSetting
    Instance.new("UICorner",bgList).CornerRadius=UDim.new(0,10)

    local bgLayout=Instance.new("UIListLayout")
    bgLayout.Padding=UDim.new(0,4)
    bgLayout.Parent=bgList

    local selectedBgName=nil
    local function applyBackground(id,displayName)
        settingState.background=tostring(id)
        selectedBgName=displayName
        selectedBgImage.Image="rbxassetid://"..tostring(id)
        selectedBgImage.Visible=true
        bgPreview.Image="rbxassetid://"..tostring(id)
        bgButton.Text="Background: "..displayName.."  ▼"
        saveSettings()
    end

    for _,item in ipairs(settingsData) do
        local row=Instance.new("TextButton")
        row.Size=UDim2.new(1,-8,0,42)
        row.BackgroundColor3=Color3.fromRGB(30,34,45)
        row.BackgroundTransparency=0.1
        row.BorderSizePixel=0
        row.Text=""
        row.AutoButtonColor=false
        row.ZIndex=21
        row.Parent=bgList
        Instance.new("UICorner",row).CornerRadius=UDim.new(0,8)

        local rowImage=Instance.new("ImageLabel")
        rowImage.Size=UDim2.new(1,0,1,0)
        rowImage.BackgroundTransparency=1
        rowImage.BorderSizePixel=0
        rowImage.ScaleType=Enum.ScaleType.Crop
        rowImage.Image="rbxassetid://"..item[2]
        rowImage.ImageTransparency=0.48
        rowImage.ZIndex=21
        rowImage.Parent=row

        local shade=Instance.new("Frame")
        shade.Size=UDim2.new(1,0,1,0)
        shade.BackgroundColor3=Color3.fromRGB(0,0,0)
        shade.BackgroundTransparency=0.35
        shade.BorderSizePixel=0
        shade.ZIndex=22
        shade.Parent=row

        local rowText=Instance.new("TextLabel")
        rowText.Size=UDim2.new(1,-16,1,0)
        rowText.Position=UDim2.fromOffset(8,0)
        rowText.BackgroundTransparency=1
        rowText.Text=item[1]
        rowText.TextColor3=Color3.fromRGB(255,255,255)
        rowText.TextSize=13
        rowText.Font=Enum.Font.GothamBold
        rowText.TextXAlignment=Enum.TextXAlignment.Left
        rowText.ZIndex=23
        rowText.Parent=row

        row.Activated:Connect(function()
            applyBackground(item[2],item[1])
            bgList.Visible=false
        end)
    end

    bgLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        bgList.CanvasSize=UDim2.new(0,0,0,bgLayout.AbsoluteContentSize.Y+8)
    end)

    local soundList=nil

    bgButton.Activated:Connect(function()
        bgList.Visible=not bgList.Visible
        if soundList then soundList.Visible=false end
        bgButton.Text="Background: "..(selectedBgName or "Choose")..(bgList.Visible and "  ▲" or "  ▼")
    end)

    sectionLabel("Button Sound",590)

    local selectedSoundName=settingState.soundName or soundData[1][1]
    local soundButton=makeButton("Sound: "..selectedSoundName.."  ▼",10,618,370)
    soundList=Instance.new("ScrollingFrame")
    soundList.Name="SoundList"
    soundList.Size=UDim2.fromOffset(370,145)
    soundList.Position=UDim2.fromOffset(10,660)
    soundList.BackgroundColor3=Color3.fromRGB(18,21,30)
    soundList.BackgroundTransparency=0.05
    soundList.BorderSizePixel=0
    soundList.Visible=false
    soundList.ScrollBarThickness=4
    soundList.CanvasSize=UDim2.new(0,0,0,0)
    soundList.ZIndex=20
    soundList.Parent=sfSetting
    Instance.new("UICorner",soundList).CornerRadius=UDim.new(0,10)

    local soundLayout=Instance.new("UIListLayout")
    soundLayout.Padding=UDim.new(0,4)
    soundLayout.Parent=soundList

    for _,item in ipairs(soundData) do
        local row=Instance.new("TextButton")
        row.Size=UDim2.new(1,-8,0,38)
        row.BackgroundColor3=Color3.fromRGB(35,40,55)
        row.BorderSizePixel=0
        row.Text=item[1]
        row.TextColor3=Color3.fromRGB(255,255,255)
        row.TextSize=13
        row.Font=Enum.Font.GothamBold
        row.ZIndex=21
        row.Parent=soundList
        Instance.new("UICorner",row).CornerRadius=UDim.new(0,8)
        row.Activated:Connect(function()
            settingState.sound=item[2]
            settingState.soundName=item[1]
            SQR_BUTTON_SOUND_ID=item[2]
            selectedSoundName=item[1]
            soundButton.Text="Sound: "..item[1].."  ▼"
            soundList.Visible=false
            pcall(function()
                local preview=Instance.new("Sound")
                preview.SoundId=item[2]
                preview.Volume=0.5
                preview.Parent=game:GetService("SoundService")
                preview:Play()
                task.delay(3,function() pcall(function() preview:Destroy() end) end)
            end)
            saveSettings()
        end)
    end

    soundLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        soundList.CanvasSize=UDim2.new(0,0,0,soundLayout.AbsoluteContentSize.Y+8)
    end)

    soundButton.Activated:Connect(function()
        soundList.Visible=not soundList.Visible
        bgList.Visible=false
        soundButton.Text="Sound: "..selectedSoundName..(soundList.Visible and "  ▲" or "  ▼")
    end)

    local function clampBox(box,default)
        local n=tonumber(box.Text) or default
        n=math.clamp(n,1,1000)
        box.Text=tostring(math.floor(n))
        return n
    end

    speedBox.FocusLost:Connect(function()
        settingState.walkSpeed=clampBox(speedBox,16)
        local hum=player.Character and player.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed=settingState.walkSpeed end
        saveSettings()
    end)

    flySpeedBox.FocusLost:Connect(function()
        settingState.flySpeed=clampBox(flySpeedBox,50)
        saveSettings()
    end)

    local function getHumanoid()
        return player.Character and player.Character:FindFirstChildOfClass("Humanoid")
    end

    local function applyWalkSpeed()
        local hum=getHumanoid()
        if hum then hum.WalkSpeed=math.clamp(tonumber(settingState.walkSpeed) or 16,1,1000) end
    end

    freezeBtn.Activated:Connect(function()
        local root=player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if not root then return end
        settingState.frozen=not settingState.frozen
        root.Anchored=settingState.frozen
        freezeBtn.Text=settingState.frozen and "Unfreeze" or "Freeze"
        freezeBtn.BackgroundColor3=settingState.frozen and Color3.fromRGB(180,60,60) or Color3.fromRGB(35,40,55)
        saveSettings()
    end)

    local flyConnection=nil
    local flyVelocity=nil
    local function stopFly()
        settingState.flying=false
        if flyConnection then flyConnection:Disconnect(); flyConnection=nil end
        if flyVelocity then flyVelocity:Destroy(); flyVelocity=nil end
        local root=player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if root then root.AssemblyLinearVelocity=Vector3.zero end
        flyBtn.Text="Fly"
        flyBtn.BackgroundColor3=Color3.fromRGB(35,40,55)
    end

    local function startFly()
        local root=player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if not root then return end
        settingState.flying=true
        flyVelocity=Instance.new("BodyVelocity")
        flyVelocity.MaxForce=Vector3.new(1e6,1e6,1e6)
        flyVelocity.Velocity=Vector3.zero
        flyVelocity.Parent=root
        flyConnection=RunService.RenderStepped:Connect(function()
            if not settingState.flying or not root.Parent then stopFly(); return end
            local cam=Workspace.CurrentCamera
            if not cam then return end
            local move=Vector3.zero
            if UIS:IsKeyDown(Enum.KeyCode.W) then move+=cam.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.S) then move-=cam.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.D) then move+=cam.CFrame.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.A) then move-=cam.CFrame.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.Space) then move+=Vector3.new(0,1,0) end
            if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then move-=Vector3.new(0,1,0) end
            local speed=math.clamp(tonumber(settingState.flySpeed) or 50,1,1000)
            flyVelocity.Velocity=move.Magnitude>0 and move.Unit*speed or Vector3.zero
        end)
        flyBtn.Text="Unfly"
        flyBtn.BackgroundColor3=Color3.fromRGB(40,150,90)
    end

    if UIS.TouchEnabled then
        mobileFlyUp.Activated:Connect(function()
            local root=player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            if root and settingState.flying then
                root.AssemblyLinearVelocity=Vector3.new(root.AssemblyLinearVelocity.X,settingState.flySpeed,root.AssemblyLinearVelocity.Z)
            end
        end)
        mobileFlyDown.Activated:Connect(function()
            local root=player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            if root and settingState.flying then
                root.AssemblyLinearVelocity=Vector3.new(root.AssemblyLinearVelocity.X,-settingState.flySpeed,root.AssemblyLinearVelocity.Z)
            end
        end)
    end

    flyBtn.Activated:Connect(function()
        if settingState.flying then stopFly() else startFly() end
        saveSettings()
    end)

    local cameraConnection=nil
    local savedCameraCFrame=nil
    cameraBtn.Activated:Connect(function()
        settingState.cameraFrozen=not settingState.cameraFrozen
        local cam=Workspace.CurrentCamera
        if settingState.cameraFrozen then
            if cam then savedCameraCFrame=cam.CFrame end
            if cameraConnection then cameraConnection:Disconnect() end
            cameraConnection=RunService.RenderStepped:Connect(function()
                if settingState.cameraFrozen and Workspace.CurrentCamera and savedCameraCFrame then
                    Workspace.CurrentCamera.CFrame=savedCameraCFrame
                end
            end)
            cameraBtn.Text="Camera Frozen"
            cameraBtn.BackgroundColor3=Color3.fromRGB(180,60,60)
        else
            if cameraConnection then cameraConnection:Disconnect(); cameraConnection=nil end
            if Workspace.CurrentCamera then
                local hum=getHumanoid()
                if hum then Workspace.CurrentCamera.CameraSubject=hum end
            end
            cameraBtn.Text="Freeze Camera"
            cameraBtn.BackgroundColor3=Color3.fromRGB(35,40,55)
        end
        saveSettings()
    end)

    local function setCharacterHidden(hidden)
        if not player.Character then return end
        for _,obj in ipairs(player.Character:GetDescendants()) do
            if obj:IsA("BasePart") or obj:IsA("Decal") or obj:IsA("Texture") then
                obj.LocalTransparencyModifier=hidden and 1 or 0
            elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") or obj:IsA("Smoke") or obj:IsA("Fire") or obj:IsA("Sparkles") then
                obj.Enabled=not hidden
            end
        end
    end

    hideBtn.Activated:Connect(function()
        settingState.hidden=not settingState.hidden
        setCharacterHidden(settingState.hidden)
        hideBtn.Text=settingState.hidden and "Show Character" or "Hide Character"
        hideBtn.BackgroundColor3=settingState.hidden and Color3.fromRGB(180,60,60) or Color3.fromRGB(35,40,55)
        saveSettings()
    end)

    local respawnConnection=nil
    local autoRespawnTask=nil
    local function startAutoRespawn()
        if respawnConnection then return end
        respawnConnection=player.CharacterAdded:Connect(function()
            task.wait(0.2)
            applyWalkSpeed()
            if settingState.hidden then setCharacterHidden(true) end
            if settingState.frozen then
                local root=player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                if root then root.Anchored=true end
            end
        end)
        autoRespawnTask=task.spawn(function()
            while settingState.autoRespawn do
                local hum=getHumanoid()
                if hum and hum.Health<=0 then
                    task.wait(0.1)
                    pcall(function() player:LoadCharacter() end)
                end
                task.wait(0.15)
            end
        end)
    end

    local function stopAutoRespawn()
        settingState.autoRespawn=false
        if respawnConnection then respawnConnection:Disconnect(); respawnConnection=nil end
        if autoRespawnTask then pcall(function() task.cancel(autoRespawnTask) end); autoRespawnTask=nil end
    end

    respawnBtn.Activated:Connect(function()
        if settingState.autoRespawn then
            stopAutoRespawn()
            respawnBtn.Text="Auto Respawn: OFF"
            respawnBtn.BackgroundColor3=Color3.fromRGB(35,40,55)
        else
            settingState.autoRespawn=true
            startAutoRespawn()
            respawnBtn.Text="Auto Respawn: ON"
            respawnBtn.BackgroundColor3=Color3.fromRGB(40,150,90)
        end
        saveSettings()
    end)

    player.CharacterAdded:Connect(function(char)
        task.wait(0.25)
        applyWalkSpeed()
        if settingState.frozen then
            local root=char:FindFirstChild("HumanoidRootPart")
            if root then root.Anchored=true end
        end
        if settingState.hidden then setCharacterHidden(true) end
    end)

    applyWalkSpeed()
    if settingState.background then
        for _,item in ipairs(settingsData) do
            if tostring(item[2])==tostring(settingState.background) then
                applyBackground(item[2],item[1])
                break
            end
        end
    end

    if settingState.frozen then
        local root=player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if root then root.Anchored=true end
        freezeBtn.Text="Unfreeze"
        freezeBtn.BackgroundColor3=Color3.fromRGB(180,60,60)
    end
    if settingState.hidden then
        setCharacterHidden(true)
        hideBtn.Text="Show Character"
        hideBtn.BackgroundColor3=Color3.fromRGB(180,60,60)
    end

    -- الحالات المؤقتة لا تعاد تلقائياً بعد إعادة التشغيل.
    settingState.flying=false
    settingState.cameraFrozen=false
    settingState.autoRespawn=false
    saveSettings()
end

-- VIP
local sfVip = nil
local vipIndex = nil

for i, name in ipairs(sections) do
if name == "VIP" then
vipIndex = i
sfVip = sectionFrames[i]
break
end
end

if sfVip and (isVIP or isOwner) then
local vipTitle = Instance.new("TextLabel")
vipTitle.Size = UDim2.new(1, 0, 0.06, 0)
vipTitle.Position = UDim2.new(0, 0, 0.01, 0)
vipTitle.BackgroundTransparency = 1
vipTitle.BorderSizePixel = 0
vipTitle.Text = "VIP CONTROL"
vipTitle.TextColor3 = Color3.fromRGB(255, 215, 0)
vipTitle.TextScaled = true
vipTitle.Font = Enum.Font.SourceSansBold
vipTitle.TextXAlignment = Enum.TextXAlignment.Center
vipTitle.Parent = sfVip

local vipCmdBox = Instance.new("TextBox")  
vipCmdBox.Size = UDim2.new(1, -20, 0.1, 0)  
vipCmdBox.Position = UDim2.new(0, 10, 0.08, 0)  
vipCmdBox.BackgroundColor3 = Color3.fromRGB(40, 40, 55)  
vipCmdBox.BorderSizePixel = 0  
vipCmdBox.TextColor3 = Color3.fromRGB(255, 255, 255)  
vipCmdBox.PlaceholderText = "Enter command (e.g., !kick user)"  
vipCmdBox.Text = ""  
vipCmdBox.ClearTextOnFocus = false  
vipCmdBox.Font = Enum.Font.SourceSans  
vipCmdBox.TextSize = 16  
vipCmdBox.Parent = sfVip  
Instance.new("UICorner", vipCmdBox).CornerRadius = UDim.new(0, 10)  
  
local vipExecBtn = Instance.new("TextButton")  
vipExecBtn.Size = UDim2.new(0.3, 0, 0.08, 0)  
vipExecBtn.Position = UDim2.new(0.35, 0, 0.2, 0)  
vipExecBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)  
vipExecBtn.BorderSizePixel = 0  
vipExecBtn.TextColor3 = Color3.fromRGB(255, 255, 255)  
vipExecBtn.Text = "Execute"  
vipExecBtn.TextScaled = true  
vipExecBtn.Font = Enum.Font.SourceSansBold  
vipExecBtn.Parent = sfVip  
Instance.new("UICorner", vipExecBtn).CornerRadius = UDim.new(0, 10)  
  
vipExecBtn.MouseButton1Click:Connect(function()  
    local cmd = vipCmdBox.Text  
    if cmd == "" then return end  
      
    local parts = {}  
    for word in cmd:gmatch("%S+") do  
        table.insert(parts, word)  
    end  
      
    if #parts < 2 then  
        ShowScriptMessage("Invalid command format!", 3)  
        return  
    end  
      
    local command = parts[1]  
    local targetName = parts[2]  
    local rest = ""  
    for i = 3, #parts do  
        rest = rest .. parts[i] .. " "  
    end  
    rest = rest:sub(1, -2)  
      
    local target = nil  
    for _, plr in ipairs(Players:GetPlayers()) do  
        if plr.Name:lower():find(targetName:lower()) then  
            target = plr  
            break  
        end  
    end  
      
    if not target then  
        ShowScriptMessage("Player not found!", 3)  
        return  
    end  
      
    if isPlayerVIP(target) and not isOwner then  
        ShowScriptMessage("He is VIP too!", 3)  
        return  
    end  
      
    if isPlayerOwner(target) and not isOwner then  
        ShowScriptMessage("Cannot target Owner!", 3)  
        return  
    end  
      
    if command == "!kick" then  
        KickPlayer(target, "Kicked by VIP user")  
        ShowScriptMessage(target.Name .. " has been kicked!", 3)  
    elseif command == "!freeze" then  
        pcall(function()  
            local root = target.Character and target.Character:FindFirstChild("HumanoidRootPart")  
            if root then  
                root.Anchored = true  
                delay(5, function()  
                    root.Anchored = false  
                end)  
            end  
        end)  
        ShowScriptMessage(target.Name .. " has been frozen!", 3)  
    elseif command == "!lag" then  
        ApplyLag(target)  
        ShowScriptMessage("Lag applied to " .. target.Name .. "!", 3)  
    elseif command == "!hd" and rest ~= "" then  
        sendCommand("!hd " .. target.Name .. " " .. rest)  
        ShowScriptMessage("HD command sent to " .. target.Name, 3)  
    else  
        ShowScriptMessage("Unknown command!", 3)  
    end  
      
    vipCmdBox.Text = ""  
end)  
  
local freeUsersLabel = Instance.new("TextLabel")  
freeUsersLabel.Size = UDim2.new(1, 0, 0.06, 0)  
freeUsersLabel.Position = UDim2.new(0, 0, 0.3, 0)  
freeUsersLabel.BackgroundTransparency = 1  
freeUsersLabel.BorderSizePixel = 0  
freeUsersLabel.Text = "Free Users in Server:"  
freeUsersLabel.TextColor3 = Color3.fromRGB(200, 200, 200)  
freeUsersLabel.TextScaled = true  
freeUsersLabel.Font = Enum.Font.SourceSansBold  
freeUsersLabel.TextXAlignment = Enum.TextXAlignment.Left  
freeUsersLabel.Parent = sfVip  
  
local freeScrollFrame = Instance.new("ScrollingFrame")  
freeScrollFrame.Size = UDim2.new(1, 0, 0.5, 0)  
freeScrollFrame.Position = UDim2.new(0, 0, 0.37, 0)  
freeScrollFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 45)  
freeScrollFrame.BackgroundTransparency = 0.1  
freeScrollFrame.BorderSizePixel = 0  
freeScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)  
freeScrollFrame.ScrollBarThickness = 6  
freeScrollFrame.Parent = sfVip  
Instance.new("UICorner", freeScrollFrame).CornerRadius = UDim.new(0, 10)  
  
local freeListContainer = Instance.new("Frame")  
freeListContainer.Size = UDim2.new(1, 0, 1, 0)  
freeListContainer.BackgroundTransparency = 1  
freeListContainer.Parent = freeScrollFrame  
  
local freeItems = {}  
  
local function updateFreeList()  
    for _, item in ipairs(freeItems) do  
        item:Destroy()  
    end  
    freeItems = {}  
      
    local yPos = 0.02  
    local count = 0  
      
    for _, plr in ipairs(Players:GetPlayers()) do  
        if plr ~= player and not isPlayerVIP(plr) and not isPlayerOwner(plr) then  
            local label = Instance.new("TextLabel")  
            label.Size = UDim2.new(1, -10, 0.08, 0)  
            label.Position = UDim2.new(0, 5, yPos, 0)  
            label.BackgroundTransparency = 1  
            label.BorderSizePixel = 0  
            label.Text = plr.Name .. " (@ " .. plr.Name .. ")"  
            label.TextColor3 = Color3.fromRGB(255, 255, 255)  
            label.TextScaled = true  
            label.Font = Enum.Font.SourceSans  
            label.TextXAlignment = Enum.TextXAlignment.Left  
            label.Parent = freeListContainer  
            table.insert(freeItems, label)  
              
            yPos = yPos + 0.09  
            count = count + 1  
        end  
    end  
      
    if count == 0 then  
        local label = Instance.new("TextLabel")  
        label.Size = UDim2.new(1, -10, 0.08, 0)  
        label.Position = UDim2.new(0, 5, 0.02, 0)  
        label.BackgroundTransparency = 1  
        label.BorderSizePixel = 0  
        label.Text = "No free users in server"  
        label.TextColor3 = Color3.fromRGB(150, 150, 150)  
        label.TextScaled = true  
        label.Font = Enum.Font.SourceSans  
        label.TextXAlignment = Enum.TextXAlignment.Center  
        label.Parent = freeListContainer  
        table.insert(freeItems, label)  
        count = 1  
    end  
      
    freeScrollFrame.CanvasSize = UDim2.new(0, 0, 0, count * 0.09 * 500)  
end  
  
updateFreeList()  
  
Players.PlayerAdded:Connect(updateFreeList)  
Players.PlayerRemoving:Connect(updateFreeList)

end

-- Owner
local sfOwner = nil
local ownerIndex = nil

for i, name in ipairs(sections) do
if name == "Owner" then
ownerIndex = i
sfOwner = sectionFrames[i]
break
end
end

if sfOwner and isOwner then
local ownerTitle = Instance.new("TextLabel")
ownerTitle.Size = UDim2.new(1, 0, 0.06, 0)
ownerTitle.Position = UDim2.new(0, 0, 0.01, 0)
ownerTitle.BackgroundTransparency = 1
ownerTitle.BorderSizePixel = 0
ownerTitle.Text = "OWNER PANEL"
ownerTitle.TextColor3 = Color3.fromRGB(255, 0, 0)
ownerTitle.TextScaled = true
ownerTitle.Font = Enum.Font.SourceSansBold
ownerTitle.TextXAlignment = Enum.TextXAlignment.Center
ownerTitle.Parent = sfOwner

local serverUsersLabel = Instance.new("TextLabel")  
serverUsersLabel.Size = UDim2.new(1, 0, 0.06, 0)  
serverUsersLabel.Position = UDim2.new(0, 0, 0.08, 0)  
serverUsersLabel.BackgroundTransparency = 1  
serverUsersLabel.BorderSizePixel = 0  
serverUsersLabel.Text = "Server Users: " .. #Players:GetPlayers()  
serverUsersLabel.TextColor3 = Color3.fromRGB(0, 255, 200)  
serverUsersLabel.TextScaled = true  
serverUsersLabel.Font = Enum.Font.SourceSansBold  
serverUsersLabel.TextXAlignment = Enum.TextXAlignment.Left  
serverUsersLabel.Parent = sfOwner  
  
local ownerCmdBox = Instance.new("TextBox")  
ownerCmdBox.Size = UDim2.new(1, -20, 0.1, 0)  
ownerCmdBox.Position = UDim2.new(0, 10, 0.22, 0)  
ownerCmdBox.BackgroundColor3 = Color3.fromRGB(40, 40, 55)  
ownerCmdBox.BorderSizePixel = 0  
ownerCmdBox.TextColor3 = Color3.fromRGB(255, 255, 255)  
ownerCmdBox.PlaceholderText = "Enter command (e.g., !ban user)"  
ownerCmdBox.Text = ""  
ownerCmdBox.ClearTextOnFocus = false  
ownerCmdBox.Font = Enum.Font.SourceSans  
ownerCmdBox.TextSize = 16  
ownerCmdBox.Parent = sfOwner  
Instance.new("UICorner", ownerCmdBox).CornerRadius = UDim.new(0, 10)  
  
local ownerExecBtn = Instance.new("TextButton")  
ownerExecBtn.Size = UDim2.new(0.3, 0, 0.08, 0)  
ownerExecBtn.Position = UDim2.new(0.35, 0, 0.34, 0)  
ownerExecBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)  
ownerExecBtn.BorderSizePixel = 0  
ownerExecBtn.TextColor3 = Color3.fromRGB(255, 255, 255)  
ownerExecBtn.Text = "Execute"  
ownerExecBtn.TextScaled = true  
ownerExecBtn.Font = Enum.Font.SourceSansBold  
ownerExecBtn.Parent = sfOwner  
Instance.new("UICorner", ownerExecBtn).CornerRadius = UDim.new(0, 10)  
  
ownerExecBtn.MouseButton1Click:Connect(function()  
    local cmd = ownerCmdBox.Text  
    if cmd == "" then return end  
      
    local parts = {}  
    for word in cmd:gmatch("%S+") do  
        table.insert(parts, word)  
    end  
      
    if #parts < 2 then  
        ShowScriptMessage("Invalid command format!", 3)  
        return  
    end  
      
    local command = parts[1]  
    local targetName = parts[2]  
    local rest = ""  
    for i = 3, #parts do  
        rest = rest .. parts[i] .. " "  
    end  
    rest = rest:sub(1, -2)  
      
    local target = nil  
    for _, plr in ipairs(Players:GetPlayers()) do  
        if plr.Name:lower():find(targetName:lower()) then  
            target = plr  
            break  
        end  
    end  
      
    if not target then  
        ShowScriptMessage("Player not found!", 3)  
        return  
    end  
      
    if command == "!ban" then  
        if not table.find(BAN_LIST, target.Name) then  
            table.insert(BAN_LIST, target.Name)  
        end  
        KickPlayer(target, "Man Your Ban From These Script")  
        ShowScriptMessage(target.Name .. " has been banned!", 3)  
          
    elseif command == "!kick" then  
        KickPlayer(target, "Kicked by Owner")  
        ShowScriptMessage(target.Name .. " has been kicked!", 3)  
          
    elseif command == "!freeze" then  
        pcall(function()  
            local root = target.Character and target.Character:FindFirstChild("HumanoidRootPart")  
            if root then  
                root.Anchored = true  
                delay(5, function()  
                    root.Anchored = false  
                end)  
            end  
        end)  
        ShowScriptMessage(target.Name .. " has been frozen!", 3)  
          
    elseif command == "!lag" then  
        ApplyLag(target)  
        ShowScriptMessage("Lag applied to " .. target.Name .. "!", 3)  
          
    elseif command == "!hd" and rest ~= "" then  
        sendCommand("!hd " .. target.Name .. " " .. rest)  
        ShowScriptMessage("HD command sent to " .. target.Name, 3)  
          
    elseif command == "!unban" then  
        for i, name in ipairs(BAN_LIST) do  
            if name:lower() == targetName:lower() then  
                table.remove(BAN_LIST, i)  
                ShowScriptMessage(targetName .. " has been unbanned!", 3)  
                break  
            end  
        end  
    else  
        ShowScriptMessage("Unknown command!", 3)  
    end  
      
    ownerCmdBox.Text = ""  
end)

end

-- Button feedback for all current and future buttons in the main interface.
installButtonFeedback(gui)
installButtonFeedback(screenGui)

-- زر إغلاق
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -40, 0, 2)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
closeBtn.BorderSizePixel = 0
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextScaled = true
closeBtn.Font = Enum.Font.SourceSansBold
closeBtn.Parent = mainFrame
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 8)

closeBtn.MouseButton1Click:Connect(function()
screenGui.Enabled = false
pcall(function()
TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
Size = UDim2.new(0, 0, 0, 0),
Position = UDim2.new(0.5, -310, 0.5, -310)
}):Play()
end)
wait(0.3)
mainFrame.Visible = false
end)

print("SQR UI loaded successfully for Delta Executor!")