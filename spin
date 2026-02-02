--// Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

--// Remote
local BuyRemote = ReplicatedStorage.Events.buy

--// State
local selectedDice = {}
local autoBuy = false
local dropdownOpen = false

--// GUI
local gui = Instance.new("ScreenGui")
gui.Name = "AutoBuyDiceGUI"
gui.ResetOnSpawn = false
gui.Parent = player.PlayerGui

-- 🔘 OPEN / CLOSE BUTTON
local openBtn = Instance.new("TextButton")
openBtn.Size = UDim2.new(0, 150, 0, 40)
openBtn.Position = UDim2.new(0, 20, 0, 200)
openBtn.Text = "Dice Auto Buy"
openBtn.BackgroundColor3 = Color3.fromRGB(90, 0, 120)
openBtn.TextColor3 = Color3.new(1,1,1)
openBtn.Parent = gui

-- Main Frame (BIGGER)
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 320, 0, 330)
frame.Position = UDim2.new(0.05, 0, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BorderSizePixel = 0
frame.Visible = false
frame.Active = true
frame.Draggable = true
frame.Parent = gui

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = "Auto Buy Dice"
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundColor3 = Color3.fromRGB(90, 0, 120)
title.Parent = frame

-- Dropdown Button
local dropdownBtn = Instance.new("TextButton")
dropdownBtn.Size = UDim2.new(1, -20, 0, 40)
dropdownBtn.Position = UDim2.new(0, 10, 0, 50)
dropdownBtn.Text = "Select Dice ▼"
dropdownBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
dropdownBtn.TextColor3 = Color3.new(1,1,1)
dropdownBtn.Parent = frame

-- 🔽 DROPDOWN SCROLLING FRAME
local dropdownFrame = Instance.new("ScrollingFrame")
dropdownFrame.Size = UDim2.new(1, -20, 0, 0)
dropdownFrame.Position = UDim2.new(0, 10, 0, 95)
dropdownFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
dropdownFrame.ScrollBarImageTransparency = 0.2
dropdownFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
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
}

-- Dice Buttons
for _,diceName in ipairs(diceList) do
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, -6, 0, 36)
	btn.Text = diceName
	btn.BackgroundColor3 = Color3.fromRGB(120, 120, 120)
	btn.TextColor3 = Color3.new(0,0,0)
	btn.Parent = dropdownFrame

	btn.MouseButton1Click:Connect(function()
		if selectedDice[diceName] then
			selectedDice[diceName] = nil
			btn.BackgroundColor3 = Color3.fromRGB(120, 120, 120)
		else
			selectedDice[diceName] = true
			btn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
		end
	end)
end

-- Resize Canvas Automatically
layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	dropdownFrame.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 6)
end)

-- Auto Buy Button
local autoBtn = Instance.new("TextButton")
autoBtn.Size = UDim2.new(1, -20, 0, 40)
autoBtn.Position = UDim2.new(0, 10, 1, -50)
autoBtn.Text = "Auto Buy: OFF"
autoBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
autoBtn.TextColor3 = Color3.new(1,1,1)
autoBtn.Parent = frame

-- OPEN / CLOSE GUI
openBtn.MouseButton1Click:Connect(function()
	frame.Visible = not frame.Visible
end)

-- Dropdown Toggle (LIMITED HEIGHT)
dropdownBtn.MouseButton1Click:Connect(function()
	dropdownOpen = not dropdownOpen
	dropdownBtn.Text = dropdownOpen and "Select Dice ▲" or "Select Dice ▼"

	dropdownFrame:TweenSize(
		dropdownOpen and UDim2.new(1, -20, 0, 150) or UDim2.new(1, -20, 0, 0),
		Enum.EasingDirection.Out,
		Enum.EasingStyle.Quad,
		0.2,
		true
	)
end)

-- Auto Buy Toggle
autoBtn.MouseButton1Click:Connect(function()
	autoBuy = not autoBuy
	autoBtn.Text = autoBuy and "Auto Buy: ON" or "Auto Buy: OFF"
	autoBtn.BackgroundColor3 = autoBuy and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)
end)

-- Auto Buy Loop
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
