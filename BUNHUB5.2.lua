--// BUN HUB V5.2 🐧
--// By : BUN

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
	Name = "BUN HUB V5.2 🐧",
	LoadingTitle = "BUN HUB V5.2 🐧",
	LoadingSubtitle = "By BUN",
	ConfigurationSaving = {
		Enabled = false,
	},
	KeySystem = true,
	KeySettings = {
		Title = "BUN HUB KEY",
		Subtitle = "Key System",
		Note = "BUN HUB 5.2",
		FileName = "BUNKEY",
		SaveKey = true,
		GrabKeyFromSite = false,
		Key = {"BUNHUB"}
	}
})

--////////////////////////////////////////////////////
-- TAB 1
--////////////////////////////////////////////////////

local Tab1 = Window:CreateTab("Tổng Hợp Các Script", 4483362458)

Tab1:CreateButton({
	Name = "Fly",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/XNEOFF/FlyGuiV3/main/FlyGuiV3.txt"))()
	end
})

Tab1:CreateButton({
	Name = "Crouch ( Cúi Xuống )",
	Callback = function()
		 -- Fixed Crouch Script (Reversed Anim Logic for Crouch)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local localPlayer = Players.LocalPlayer
local playerGui = localPlayer:WaitForChild("PlayerGui")

-- GUI
local crouchGui = Instance.new("ScreenGui")
crouchGui.Name = "CrouchGui"
crouchGui.Parent = playerGui

local touchControlsFrame = Instance.new("Frame")
touchControlsFrame.Name = "TouchControls"
touchControlsFrame.Size = UDim2.new(1,0,1,0)
touchControlsFrame.BackgroundTransparency = 1
touchControlsFrame.Parent = crouchGui

-- Find Jump Button
local jumpButton = playerGui:FindFirstChild("JumpButton", true)
if not jumpButton then
    for _, obj in ipairs(playerGui:GetDescendants()) do
        if obj:IsA("ImageButton") and (obj.Name == "JumpButton" or string.find(string.lower(obj.Name),"jump")) then
            jumpButton = obj
            break
        end
    end
end

-- Assets
local crouchButtonImage = "rbxassetid://109660173469064"
local crouchButtonActiveImage = "rbxassetid://139705395031155"
local crouchWalkAnimId = "rbxassetid://137525751454426"
local crouchIdleAnimId = "rbxassetid://107078800928182"

-- Create crouch button
local crouchButton = Instance.new("ImageButton")
crouchButton.Name = "CrouchButton"
crouchButton.BackgroundTransparency = 1
crouchButton.Image = crouchButtonImage
crouchButton.Parent = touchControlsFrame

if jumpButton then
    crouchButton.Size = jumpButton.Size
    crouchButton.Position = UDim2.new(0, jumpButton.AbsolutePosition.X - jumpButton.AbsoluteSize.X - 10, 0, jumpButton.AbsolutePosition.Y)
else
    crouchButton.Size = UDim2.new(0,60,0,60)
    crouchButton.Position = UDim2.new(0,30,1,-150)
end

-- State
local isCrouching = false
local defaultWalkSpeed = 16
local defaultJumpPower = 50
local idleAnimId, walkAnimId
local crouchIdleAnim, crouchWalkAnim
local crouchAnimSpeed = 0.8
local crouchWalkSpeed = 5

-- Functions
local function updateCrouchButtonVisibility()
    crouchButton.Visible = UserInputService:GetLastInputType() == Enum.UserInputType.Touch
end

local function cacheAnimations()
    local char = localPlayer.Character
    if not char then return end
    local animate = char:FindFirstChild("Animate")
    if not animate then return end

    if not idleAnimId then
        local idleAnim = animate:FindFirstChild("idle")
        if idleAnim then
            local anim = idleAnim:FindFirstChild("Animation1")
            if anim then idleAnimId = anim.AnimationId end
        end
    end

    if not walkAnimId then
        local walkAnim = animate:FindFirstChild("walk")
        if walkAnim then
            local anim = walkAnim:FindFirstChild("WalkAnim")
            if anim then walkAnimId = anim.AnimationId end
        end
    end
end

local function activateCrouch()
    if isCrouching then return end
    local char = localPlayer.Character
    if not char then return end
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end

    isCrouching = true
    crouchButton.Image = crouchButtonActiveImage
    cacheAnimations()

    defaultWalkSpeed = humanoid.WalkSpeed
    defaultJumpPower = humanoid.JumpPower

    -- Load animations
    local idleAnimation = Instance.new("Animation")
    idleAnimation.AnimationId = crouchIdleAnimId
    local walkAnimation = Instance.new("Animation")
    walkAnimation.AnimationId = crouchWalkAnimId

    crouchIdleAnim = humanoid:LoadAnimation(idleAnimation)
    crouchWalkAnim = humanoid:LoadAnimation(walkAnimation)
    crouchWalkAnim:AdjustSpeed(crouchAnimSpeed)
    crouchWalkAnim:Play() -- Reversed: play walk animation by default while standing

    humanoid.JumpPower = 0

    -- Crouch heartbeat
    local heartbeatConn
    heartbeatConn = RunService.Heartbeat:Connect(function()
        if not isCrouching or humanoid.Health <= 0 then
            heartbeatConn:Disconnect()
            return
        end

        local isMoving = humanoid.MoveDirection.Magnitude > 0

        -- REVERSED ANIMATIONS LOGIC
        if isMoving then
            humanoid.WalkSpeed = crouchWalkSpeed
            if crouchWalkAnim and crouchWalkAnim.IsPlaying then
                crouchWalkAnim:Stop()
            end
            if crouchIdleAnim and not crouchIdleAnim.IsPlaying then
                crouchIdleAnim:Play()
            end
        else
            humanoid.WalkSpeed = crouchWalkSpeed
            if crouchIdleAnim and crouchIdleAnim.IsPlaying then
                crouchIdleAnim:Stop()
            end
            if crouchWalkAnim and not crouchWalkAnim.IsPlaying then
                crouchWalkAnim:Play()
            end
        end

        if humanoid:GetState() == Enum.HumanoidStateType.Jumping then
            humanoid:ChangeState(Enum.HumanoidStateType.Running)
        end
    end)

    if jumpButton then jumpButton.Visible = false end
end

local function deactivateCrouch()
    if not isCrouching then return end
    local char = localPlayer.Character
    if not char then return end
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end

    isCrouching = false
    crouchButton.Image = crouchButtonImage

    if crouchIdleAnim then crouchIdleAnim:Stop() end
    if crouchWalkAnim then crouchWalkAnim:Stop() end

    humanoid.WalkSpeed = defaultWalkSpeed
    humanoid.JumpPower = defaultJumpPower

    local animate = char:FindFirstChild("Animate")
    if animate then
        if idleAnimId then
            local idle = animate:FindFirstChild("idle")
            if idle then
                local anim = idle:FindFirstChild("Animation1")
                if anim then anim.AnimationId = idleAnimId end
            end
        end
        if walkAnimId then
            local walk = animate:FindFirstChild("walk")
            if walk then
                local anim = walk:FindFirstChild("WalkAnim")
                if anim then anim.AnimationId = walkAnimId end
            end
        end
    end

    if jumpButton then jumpButton.Visible = true end
end

local function toggleCrouch()
    if isCrouching then deactivateCrouch() else activateCrouch() end
end

-- Connections
crouchButton.MouseButton1Click:Connect(toggleCrouch)
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.LeftControl or input.KeyCode == Enum.KeyCode.C then
        toggleCrouch()
    end
end)
UserInputService.JumpRequest:Connect(function()
    if isCrouching then return end
end)
UserInputService.LastInputTypeChanged:Connect(updateCrouchButtonVisibility)
localPlayer.CharacterAdded:Connect(function(char)
    isCrouching = false
    crouchButton.Image = crouchButtonImage
    idleAnimId = nil
    walkAnimId = nil
    char:WaitForChild("Humanoid")
    cacheAnimations()
    if jumpButton then jumpButton.Visible = true end
    task.delay(0.5, updateCrouchButtonVisibility)
end)

-- Init
if localPlayer.Character then
    cacheAnimations()
end
crouchGui.ResetOnSpawn = false
updateCrouchButtonVisibility()
print("Crouch system loaded (reversed crouch animations active)")
	end
})

Tab1:CreateButton({
	Name = "Float",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/bunbunroblox41-sudo/Uuh/refs/heads/main/Float.txt", true))()
	end
})

Tab1:CreateButton({
	Name = "Sục",
	Callback = function()
		loadstring(game:HttpGet("https://pastefy.app/wa3v2Vgm/raw"))("Spider Script")
	end
})

Tab1:CreateButton({
	Name = "ESP",
	Callback = function()
		loadstring(game:HttpGet("https://obj.wearedevs.net/140060/scripts/Universal%20ESP.lua"))()
	end
})

Tab1:CreateButton({
	Name = "Hitbox",
	Callback = function()
		loadstring(game:HttpGet("https://pastefy.app/ItfO0tdg/raw"))()
	end
})

Tab1:CreateButton({
	Name = "Fake Dead",
	Callback = function()
		loadstring(game:HttpGet("https://pastefy.app/ssXUg0ng/raw", true))()
	end
})

Tab1:CreateButton({
	Name = "Dex",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/realredz/DEX-Explorer/refs/heads/main/Mobile.lua"))()
	end
})

Tab1:CreateButton({
	Name = "Bất tử",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/Rawbr10/Roblox-Scripts/refs/heads/main/God%20Mode%20Script%20Universal"))()
	end
})

Tab1:CreateButton({
	Name = "7yd7 Emote",
	Callback = function()
		loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-7yd7-Emote-Animation-Script-UGC-LAG-Fixed-Delta-Console-bug-72656"))()
	end
})

Tab1:CreateButton({
	Name = "Fix Lag ( Turbo Lite )",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/TurboLite/Script/main/FixLag.lua"))()
	end
})

Tab1:CreateButton({
	Name = "Lưu Vị Trí Và Dịch Chuyển",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/bunbunroblox41-sudo/Uuh/refs/heads/main/Script%20d%E1%BB%8Bch%20chuy%E1%BB%83n%20.txt", true))()
	end
})

Tab1:CreateButton({
	Name = "Execute BUN",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/bunbunroblox41-sudo/Uuh/refs/heads/main/Bun%20Execute%20.txt", true))()
	end
})

Tab1:CreateButton({
	Name = "Free Cam",
	Callback = function()
		loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-FREECAM-script-80365"))()
	end
})

Tab1:CreateButton({
	Name = "Flashback",
	Callback = function()
		loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Flashback-Script-26745"))()
	end
})

Tab1:CreateButton({
	Name = "No Clip",
	Callback = function()
		loadstring(game:HttpGet("https://obj.wearedevs.net/197981/scripts/roblox%20noclip%20GUI.lua"))()
	end
})

Tab1:CreateButton({
	Name = "Fling",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/long191910/all-my-roblox-script/refs/heads/main/touchfling.lua"))()
	end
})

Tab1:CreateButton({
	Name = "Fake Lag",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/Biem6ondo/FAKELAG/refs/heads/main/Fakelag"))()
	end
})

Tab1:CreateButton({
	Name = "Fake Dead",
	Callback = function()
		loadstring(game:HttpGet("https://pastefy.app/ssXUg0ng/raw", true))()
	end
})

Tab1:CreateButton({
	Name = "Phá Góc Nhìn Thứ Nhất",
	Callback = function()
		loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Unlock-First-Person-or-Third-Person-script-12176"))()
	end
})

Tab1:CreateButton({
	Name = "Auto Jump",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/nguyenphuc888999666-code/Auto-jump-Ph-c/main/Auto%20jump"))()
	end
})

Tab1:CreateButton({
	Name = "Shift lock",
	Callback = function()
		loadstring(game:HttpGet("https://scriptblox.com/raw/Universal-Script-Mobile-Shiftlock-12348"))()
	end
})

Tab1:CreateButton({
	Name = "Invisible",
	Callback = function()
		loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Awesome-Invisible-man-21074"))()
	end
})

Tab1:CreateButton({
	Name = "Aimbot",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/DanielHubll/DanielHubll/refs/heads/main/Aimbot%20Mobile"))()
	end
})

Tab1:CreateButton({
	Name = "Tele Đến Ng Chs",
	Callback = function()
		 --// Dịch Chuyển Đến Người Chơi
--// By BUN

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Xóa GUI cũ nếu có
pcall(function()
	game.CoreGui:FindFirstChild("DichChuyenHub"):Destroy()
end)

-- GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DichChuyenHub"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false

-- Nút mở/đóng
local Toggle = Instance.new("TextButton")
Toggle.Parent = ScreenGui
Toggle.Size = UDim2.new(0,50,0,50)
Toggle.Position = UDim2.new(0,20,0.4,0)
Toggle.BackgroundColor3 = Color3.fromRGB(0,0,0)
Toggle.TextColor3 = Color3.fromRGB(255,255,255)
Toggle.Text = "+"
Toggle.TextScaled = true
Toggle.Font = Enum.Font.GothamBold
Toggle.Active = true
Toggle.Draggable = true
Toggle.BorderSizePixel = 0

local UICorner1 = Instance.new("UICorner", Toggle)
UICorner1.CornerRadius = UDim.new(0,12)

-- Main Hub
local Main = Instance.new("Frame")
Main.Parent = ScreenGui
Main.Size = UDim2.new(0,260,0,300)
Main.Position = UDim2.new(0,80,0.3,0)
Main.BackgroundColor3 = Color3.fromRGB(255,255,255)
Main.Visible = false
Main.Active = true
Main.Draggable = true
Main.BorderSizePixel = 0

local UICorner2 = Instance.new("UICorner", Main)
UICorner2.CornerRadius = UDim.new(0,15)

-- Viền đen
local Stroke = Instance.new("UIStroke", Main)
Stroke.Color = Color3.fromRGB(0,0,0)
Stroke.Thickness = 2

-- Title
local Title = Instance.new("TextLabel")
Title.Parent = Main
Title.Size = UDim2.new(1,0,0,40)
Title.BackgroundColor3 = Color3.fromRGB(0,0,0)
Title.Text = "Dịch Chuyển Đến Người Chơi"
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.Font = Enum.Font.GothamBold
Title.TextScaled = true
Title.BorderSizePixel = 0

local UICorner3 = Instance.new("UICorner", Title)
UICorner3.CornerRadius = UDim.new(0,15)

-- Danh sách người chơi
local Scrolling = Instance.new("ScrollingFrame")
Scrolling.Parent = Main
Scrolling.Size = UDim2.new(1,-10,1,-50)
Scrolling.Position = UDim2.new(0,5,0,45)
Scrolling.CanvasSize = UDim2.new(0,0,0,0)
Scrolling.BackgroundTransparency = 1
Scrolling.BorderSizePixel = 0
Scrolling.ScrollBarThickness = 5

local UIList = Instance.new("UIListLayout", Scrolling)
UIList.Padding = UDim.new(0,5)

-- Mở/đóng hub
Toggle.MouseButton1Click:Connect(function()
	Main.Visible = not Main.Visible
	
	if Main.Visible then
		Toggle.Text = "-"
	else
		Toggle.Text = "+"
	end
end)

-- Tạo nút player
local function RefreshPlayers()
	for _,v in pairs(Scrolling:GetChildren()) do
		if v:IsA("TextButton") then
			v:Destroy()
		end
	end
	
	for _,plr in pairs(Players:GetPlayers()) do
		if plr ~= LocalPlayer then
			
			local Btn = Instance.new("TextButton")
			Btn.Parent = Scrolling
			Btn.Size = UDim2.new(1,-5,0,40)
			Btn.BackgroundColor3 = Color3.fromRGB(0,0,0)
			Btn.TextColor3 = Color3.fromRGB(255,255,255)
			Btn.Text = plr.Name
			Btn.Font = Enum.Font.GothamBold
			Btn.TextScaled = true
			Btn.BorderSizePixel = 0
			
			local UICorner = Instance.new("UICorner", Btn)
			UICorner.CornerRadius = UDim.new(0,10)
			
			Btn.MouseButton1Click:Connect(function()
				if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
					LocalPlayer.Character:MoveTo(
						plr.Character.HumanoidRootPart.Position + Vector3.new(2,0,2)
					)
				end
			end)
		end
	end
	
	wait()
	Scrolling.CanvasSize = UDim2.new(0,0,0,UIList.AbsoluteContentSize.Y + 10)
end

RefreshPlayers()

Players.PlayerAdded:Connect(RefreshPlayers)
Players.PlayerRemoving:Connect(RefreshPlayers)
	end
})

Tab1:CreateButton({
	Name = "Infinite Yield",
	Callback = function()
		loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
	end
})

--////////////////////////////////////////////////////
-- TAB 2
--////////////////////////////////////////////////////

local Tab2 = Window:CreateTab("Script Map", 4483362458)

Tab2:CreateButton({
	Name = "Fox Name ( Dead Rails )",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/caomod2077/Script/refs/heads/main/Foxname-Dr.lua"))()
	end
})

Tab2:CreateButton({
	Name = "Fox Name ( Survive Zombie Arena )",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/caomod2077/Script/refs/heads/main/Foxname_SZA.lua"))()
	end
})

Tab2:CreateButton({
	Name = "Sander XY ( Brookhaven )",
	Callback = function()
		loadstring(game:HttpGet("https://rawscripts.net/raw/Brookhaven-RP-Sander-XY-35845"))()
	end
})

Tab2:CreateButton({
	Name = "Tora Is Me ( Kick a Lucky Block )",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/gumanba/Scripts/main/KickaLuckyBlock"))()
	end
})

--////////////////////////////////////////////////////
-- TAB 3
--////////////////////////////////////////////////////

local Tab3 = Window:CreateTab("Hub", 4483362458)

Tab3:CreateButton({
	Name = "Téo Hub",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/teoscrvn/T-ng-h-p-/refs/heads/main/teovip.txt", true))()
	end
})

Tab3:CreateButton({
	Name = "Biến Hình Hub",
	Callback = function()
		loadstring(game:HttpGet("https://pastefy.app/2OWyTovg/raw"))()
	end
})

Tab3:CreateButton({
	Name = "System Broken Hub",
	Callback = function()
		loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-System-Broken-94677"))()
	end
})

Tab3:CreateButton({
	Name = "DiscoHacker Script",
	Callback = function()
		loadstring(game:HttpGet("https://pastefy.app/7gEmEv5W/raw"))()
	end
})

Tab3:CreateButton({
	Name = "Script Fe ( script hay độc lạ )",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/alifSTARZ/HERMAN-KONTOL-ANIMATION/refs/heads/main/Animation%20script%20by%20xploit%20force"))()
	end
})

--////////////////////////////////////////////////////
-- TAB 4
--////////////////////////////////////////////////////

local Tab4 = Window:CreateTab("Linh Tinh", 4483362458)

Tab4:CreateButton({
    Name = "Nghe Nhạc ( Visual )",
	Callback = function()
        -- (Creator = locducatine0)
-- 💟 Boombox - Ẩn/Hiện Menu (Nhạc không tắt) 💟
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
-- Tạo Giao diện
local ScreenGui = Instance.new("ScreenGui", PlayerGui)
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 250, 0, 220)
MainFrame.Position = UDim2.new(0.5, -125, 0.4, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)
-- Nút ẨN MENU (Thay vì nút X xóa)
local HideBtn = Instance.new("TextButton", MainFrame)
HideBtn.Size = UDim2.new(0, 30, 0, 30)
HideBtn.Position = UDim2.new(0.85, 0, 0.05, 0)
HideBtn.Text = "-"
HideBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
Instance.new("UICorner", HideBtn)
HideBtn.MouseButton1Click:Connect(function()
MainFrame.Visible = false -- Chỉ ẩn menu đi
end)
-- Tạo Nút Hiện Menu (Nằm ở góc màn hình khi menu bị ẩn)
local OpenBtn = Instance.new("TextButton", ScreenGui)
OpenBtn.Size = UDim2.new(0, 50, 0, 50)
OpenBtn.Position = UDim2.new(0, 10, 0.5, 0)
OpenBtn.Text = "🎵"
OpenBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
Instance.new("UICorner", OpenBtn)
OpenBtn.MouseButton1Click:Connect(function()
MainFrame.Visible = true -- Hiện lại menu
end)
-- [Các phần khác giữ nguyên như cũ...]
local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(0.8, 0, 0, 30)
Title.Position = UDim2.new(0.05, 0, 0.05, 0)
Title.Text = "🎵 TÌM KIẾM NHẠC"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.BackgroundTransparency = 1
local InputBox = Instance.new("TextBox", MainFrame)
InputBox.Size = UDim2.new(0.9, 0, 0, 40)
InputBox.Position = UDim2.new(0.05, 0, 0.25, 0)
InputBox.PlaceholderText = "Nhập ID nhạc..."
InputBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
InputBox.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", InputBox)
local PlayBtn = Instance.new("TextButton", MainFrame)
PlayBtn.Size = UDim2.new(0.4, 0, 0, 40)
PlayBtn.Position = UDim2.new(0.05, 0, 0.55, 0)
PlayBtn.Text = "PHÁT"
PlayBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
Instance.new("UI
	end
})

Tab4:CreateButton({
	Name = "YouTube",
	Callback = function()
        loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-YouTube-music-Player-110035"))() 
	end
})

--////////////////////////////////////////////////////
-- TAB 5
--////////////////////////////////////////////////////

local Tab5 = Window:CreateTab("Info", 4483362458

Tab5:CreateParagraph({
	Title = "Youtube",
	Content = "IamComback36"
})

Tab5:CreateParagraph({
	Title = "Tiktok",
	Content = "bun_vn_12419"
})

Rayfield:Notify({
	Title = "BUN HUB V5.2 🐧",
	Content = "Script Đã Mở",
	Duration = 6.5,
	Image = 4483362458,
})