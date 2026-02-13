--// Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer
local UIS = game:GetService("UserInputService")

--// Remotes
local BuyRemote = ReplicatedStorage.Events.buy
local EggRemote = ReplicatedStorage.Events.RegularPet
local RollRemote = player.PlayerGui.Main.Dice.RollState

--// State
local selectedDice = {}
local autoBuy = false
local dropdownOpen = false
local autoBuyEgg = false
local eggSpeed = 0.5
local autoRoll = false
local cashMethod = false

--// GUI
local gui = Instance.new("ScreenGui")
gui.Name = "FuturisticAutoBuyGUI"
gui.ResetOnSpawn = false
gui.Parent = player.PlayerGui

-- 🔘 OPEN / CLOSE BUTTON
local openBtn = Instance.new("TextButton")
openBtn.Size = UDim2.new(0, 180, 0, 50)
openBtn.Position = UDim2.new(0, 80, 0, 150)
openBtn.Text = "Terrible Scripts"
openBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
openBtn.TextColor3 = Color3.fromRGB(255,255,255)
openBtn.Font = Enum.Font.GothamBold
openBtn.TextScaled = true
openBtn.Parent = gui

-- Main Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 340, 0, 620)
frame.Position = UDim2.new(0.05, 0, 0.25, 0)
frame.BackgroundColor3 = Color3.fromRGB(10,10,10)
frame.BorderSizePixel = 0
frame.Visible = false
frame.Active = true
frame.Draggable = true
frame.Parent = gui

-- Gradient for futuristic look
local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(255,255,255)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(100,100,100))
}
gradient.Rotation = 45
gradient.Parent = frame

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 50)
title.Text = "⚡ Terrible Scripts"
title.TextColor3 = Color3.fromRGB(255,255,255)
title.BackgroundColor3 = Color3.fromRGB(0,0,0)
title.Font = Enum.Font.GothamBlack
title.TextScaled = true
title.Parent = frame

-- Dropdown Button
local dropdownBtn = Instance.new("TextButton")
dropdownBtn.Size = UDim2.new(1, -40, 0, 50)
dropdownBtn.Position = UDim2.new(0, 20, 0, 70)
dropdownBtn.Text = "Select Dice ▼"
dropdownBtn.BackgroundColor3 = Color3.fromRGB(25,25,25)
dropdownBtn.TextColor3 = Color3.fromRGB(255,255,255)
dropdownBtn.Font = Enum.Font.Gotham
dropdownBtn.TextScaled = true
dropdownBtn.Parent = frame

-- Dropdown Scrolling Frame
local dropdownFrame = Instance.new("ScrollingFrame")
dropdownFrame.Size = UDim2.new(1, -40, 0, 0)
dropdownFrame.Position = UDim2.new(0, 20, 0, 130)
dropdownFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
dropdownFrame.ScrollBarImageTransparency = 0.2
dropdownFrame.BackgroundColor3 = Color3.fromRGB(15,15,15)
dropdownFrame.BorderSizePixel = 0
dropdownFrame.ClipsDescendants = true
dropdownFrame.Parent = frame

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 6)
layout.Parent = dropdownFrame

-- Dice List
local diceList = {
	"Basic Dice",
	"Seraphic Dice",
	"Galactic Dice",
	"Eldritch Dice",
	"Emperor Dice",
	"Annihilation Dice",
	"Disaster Dice",
	"Impossible Dice",
	"Limbo Dice",
	"Yinyang Dice",
	"Chronos Dice",
}

-- Dice Buttons
for _,diceName in ipairs(diceList) do
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, -6, 0, 40)
	btn.Text = diceName
	btn.BackgroundColor3 = Color3.fromRGB(35,35,35)
	btn.TextColor3 = Color3.fromRGB(255,255,255)
	btn.Font = Enum.Font.Gotham
	btn.TextScaled = true
	btn.Parent = dropdownFrame

	btn.MouseButton1Click:Connect(function()
		if selectedDice[diceName] then
			selectedDice[diceName] = nil
			btn.BackgroundColor3 = Color3.fromRGB(35,35,35)
		else
			selectedDice[diceName] = true
			btn.BackgroundColor3 = Color3.fromRGB(0,200,255)
		end
	end)
end

-- Resize Canvas Automatically
layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	dropdownFrame.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 6)
end)

-- Auto Buy Dice Button
local autoBtn = Instance.new("TextButton")
autoBtn.Size = UDim2.new(1, -40, 0, 50)
autoBtn.Position = UDim2.new(0, 20, 0, 320)
autoBtn.Text = "Auto Buy Dice: OFF"
autoBtn.BackgroundColor3 = Color3.fromRGB(25,25,25)
autoBtn.TextColor3 = Color3.fromRGB(255,255,255)
autoBtn.Font = Enum.Font.GothamBold
autoBtn.TextScaled = true
autoBtn.Parent = frame

-- Auto Buy Best Egg Button
local eggBtn = Instance.new("TextButton")
eggBtn.Size = UDim2.new(1, -40, 0, 50)
eggBtn.Position = UDim2.new(0, 20, 0, 380)
eggBtn.Text = "Auto Buy Best Egg: OFF"
eggBtn.BackgroundColor3 = Color3.fromRGB(25,25,25)
eggBtn.TextColor3 = Color3.fromRGB(255,255,255)
eggBtn.Font = Enum.Font.GothamBold
eggBtn.TextScaled = true
eggBtn.Parent = frame

-- Speed Slider (Egg)
local sliderFrame = Instance.new("Frame")
sliderFrame.Size = UDim2.new(1, -40, 0, 50)
sliderFrame.Position = UDim2.new(0, 20, 0, 440)
sliderFrame.BackgroundColor3 = Color3.fromRGB(15,15,15)
sliderFrame.Parent = frame

local sliderLabel = Instance.new("TextLabel")
sliderLabel.Size = UDim2.new(1, -20, 0, 20)
sliderLabel.Position = UDim2.new(0,10,0,0)
sliderLabel.Text = "Egg Buy Speed"
sliderLabel.TextColor3 = Color3.fromRGB(255,255,255)
sliderLabel.BackgroundTransparency = 1
sliderLabel.Font = Enum.Font.Gotham
sliderLabel.TextScaled = true
sliderLabel.Parent = sliderFrame

local sliderBar = Instance.new("Frame")
sliderBar.Size = UDim2.new(0, 250, 0, 6)
sliderBar.Position = UDim2.new(0, 10, 0, 30)
sliderBar.BackgroundColor3 = Color3.fromRGB(200,200,200)
sliderBar.Parent = sliderFrame

local sliderHandle = Instance.new("TextButton")
sliderHandle.Size = UDim2.new(0, 20, 0, 20)
sliderHandle.Position = UDim2.new(0, 0, 0, 21)
sliderHandle.BackgroundColor3 = Color3.fromRGB(0,255,255)
sliderHandle.Text = ""
sliderHandle.Parent = sliderFrame

-- Slider Dragging
local dragging = false
sliderHandle.MouseButton1Down:Connect(function()
	dragging = true
end)
UIS.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = false
	end
end)
UIS.InputChanged:Connect(function(input)
	if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
		local mouseX = math.clamp(input.Position.X - sliderBar.AbsolutePosition.X, 0, sliderBar.AbsoluteSize.X)
		sliderHandle.Position = UDim2.new(0, mouseX, 0, 21)
		eggSpeed = 2 - (mouseX / sliderBar.AbsoluteSize.X * 1.95)
	end
end)

-- Auto Roll Button
local rollBtn = Instance.new("TextButton")
rollBtn.Size = UDim2.new(1, -40, 0, 50)
rollBtn.Position = UDim2.new(0, 20, 0, 500)
rollBtn.Text = "Auto Roll: OFF"
rollBtn.BackgroundColor3 = Color3.fromRGB(25,25,25)
rollBtn.TextColor3 = Color3.fromRGB(255,255,255)
rollBtn.Font = Enum.Font.GothamBold
rollBtn.TextScaled = true
rollBtn.Parent = frame

-- Cash Method Button
local cashBtn = Instance.new("TextButton")
cashBtn.Size = UDim2.new(1, -40, 0, 50)
cashBtn.Position = UDim2.new(0, 20, 0, 560)
cashBtn.Text = "CASH METHOD (COULD LAG GAME)"
cashBtn.BackgroundColor3 = Color3.fromRGB(25,25,25)
cashBtn.TextColor3 = Color3.fromRGB(255,255,255)
cashBtn.Font = Enum.Font.GothamBold
cashBtn.TextScaled = true
cashBtn.Parent = frame

-- OPEN / CLOSE GUI
openBtn.MouseButton1Click:Connect(function()
	frame.Visible = not frame.Visible
end)

-- Dropdown Toggle
dropdownBtn.MouseButton1Click:Connect(function()
	dropdownOpen = not dropdownOpen
	dropdownBtn.Text = dropdownOpen and "Select Dice ▲" or "Select Dice ▼"
	dropdownFrame:TweenSize(
		dropdownOpen and UDim2.new(1, -40, 0, 200) or UDim2.new(1, -40, 0, 0),
		Enum.EasingDirection.Out,
		Enum.EasingStyle.Quad,
		0.2,
		true
	)
end)

-- Toggles
autoBtn.MouseButton1Click:Connect(function()
	autoBuy = not autoBuy
	autoBtn.Text = autoBuy and "Auto Buy Dice: ON" or "Auto Buy Dice: OFF"
	autoBtn.BackgroundColor3 = autoBuy and Color3.fromRGB(0,255,255) or Color3.fromRGB(25,25,25)
end)
eggBtn.MouseButton1Click:Connect(function()
	autoBuyEgg = not autoBuyEgg
	eggBtn.Text = autoBuyEgg and "Auto Buy Best Egg: ON" or "Auto Buy Best Egg: OFF"
	eggBtn.BackgroundColor3 = autoBuyEgg and Color3.fromRGB(0,255,255) or Color3.fromRGB(25,25,25)
end)
rollBtn.MouseButton1Click:Connect(function()
	autoRoll = not autoRoll
	rollBtn.Text = autoRoll and "Auto Roll: ON" or "Auto Roll: OFF"
	rollBtn.BackgroundColor3 = autoRoll and Color3.fromRGB(0,255,255) or Color3.fromRGB(25,25,25)
end)
cashBtn.MouseButton1Click:Connect(function()
	cashMethod = not cashMethod
	cashBtn.BackgroundColor3 = cashMethod and Color3.fromRGB(0,255,255) or Color3.fromRGB(25,25,25)
end)

-- Loops
task.spawn(function()
	while true do
		if autoBuy then
			for diceName,_ in pairs(selectedDice) do
				BuyRemote:InvokeServer(diceName, 1, "dice")
			end
		end
		task.wait(0.5)
	end
end)

task.spawn(function()
	while true do
		if autoBuyEgg then
			EggRemote:InvokeServer("AngelEgg",3)
		end
		task.wait(eggSpeed)
	end
end)

task.spawn(function()
	while true do
		if autoRoll then
			RollRemote:InvokeServer()
		end
		task.wait(0.2)
	end
end)

task.spawn(function()
	while true do
		if cashMethod then
			for i = 1,10000 do
				task.spawn(function()
					local remote = ReplicatedStorage.Events.PlaceBestBaddies
					local results = remote:InvokeServer()
				end)
			end
		end
		task.wait(1) -- small delay to avoid freezing the whole script
	end
end)
