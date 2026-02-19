--// Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")
local player = Players.LocalPlayer

--// Remotes
local BuyRemote = ReplicatedStorage.Events.buy
local EggRemote = ReplicatedStorage.Events.RegularPet
local RollRemote = player.PlayerGui.Main.Dice.RollState
local SpinRemote = ReplicatedStorage.Events.spinrequest

--// State
local selectedDice = {}
local autoBuy = false
local dropdownOpen = false
local autoBuyEgg = false
local eggSpeed = 0.5
local autoRoll = false
local cashMethod = false
local autoWheel = false

--// GUI
local gui = Instance.new("ScreenGui")
gui.Name = "FuturisticAutoBuyGUI"
gui.ResetOnSpawn = false
gui.Parent = player.PlayerGui

-- OPEN BUTTON
local openBtn = Instance.new("TextButton", gui)
openBtn.Size = UDim2.new(0,180,0,50)
openBtn.Position = UDim2.new(0,80,0,150)
openBtn.Text = "Terrible Scripts"
openBtn.BackgroundColor3 = Color3.fromRGB(20,20,20)
openBtn.TextColor3 = Color3.new(1,1,1)
openBtn.Font = Enum.Font.GothamBold
openBtn.TextScaled = true

-- MAIN FRAME
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,340,0,620)
frame.Position = UDim2.new(0.05,0,0.25,0)
frame.BackgroundColor3 = Color3.fromRGB(10,10,10)
frame.BorderSizePixel = 0
frame.Visible = false
frame.Active = true
frame.Draggable = true

-- TITLE
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,50)
title.Text = "⚡ Terrible Scripts"
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundColor3 = Color3.fromRGB(0,0,0)
title.Font = Enum.Font.GothamBlack
title.TextScaled = true

-- PAGE BUTTONS
local page1Btn = Instance.new("TextButton", frame)
page1Btn.Size = UDim2.new(0.5,0,0,40)
page1Btn.Position = UDim2.new(0,0,0,50)
page1Btn.Text = "PAGE 1"
page1Btn.BackgroundColor3 = Color3.fromRGB(0,255,255)
page1Btn.Font = Enum.Font.GothamBold
page1Btn.TextScaled = true

local page2Btn = Instance.new("TextButton", frame)
page2Btn.Size = UDim2.new(0.5,0,0,40)
page2Btn.Position = UDim2.new(0.5,0,0,50)
page2Btn.Text = "PAGE 2"
page2Btn.BackgroundColor3 = Color3.fromRGB(25,25,25)
page2Btn.Font = Enum.Font.GothamBold
page2Btn.TextScaled = true

-- PAGES
local page1 = Instance.new("Frame", frame)
page1.Size = UDim2.new(1,0,1,-90)
page1.Position = UDim2.new(0,0,0,90)
page1.BackgroundTransparency = 1

local page2 = Instance.new("Frame", frame)
page2.Size = page1.Size
page2.Position = page1.Position
page2.BackgroundTransparency = 1
page2.Visible = false

-- ================= PAGE 1 =================

-- DROPDOWN BUTTON
local dropdownBtn = Instance.new("TextButton", page1)
dropdownBtn.Size = UDim2.new(1,-40,0,50)
dropdownBtn.Position = UDim2.new(0,20,0,0)
dropdownBtn.Text = "Select Dice ▼"
dropdownBtn.BackgroundColor3 = Color3.fromRGB(25,25,25)
dropdownBtn.TextColor3 = Color3.new(1,1,1)
dropdownBtn.Font = Enum.Font.Gotham
dropdownBtn.TextScaled = true

local dropdownFrame = Instance.new("ScrollingFrame", page1)
dropdownFrame.Size = UDim2.new(1,-40,0,0)
dropdownFrame.Position = UDim2.new(0,20,0,60)
dropdownFrame.CanvasSize = UDim2.new(0,0,0,0)
dropdownFrame.ScrollBarImageTransparency = 0.2
dropdownFrame.BackgroundColor3 = Color3.fromRGB(15,15,15)
dropdownFrame.BorderSizePixel = 0
dropdownFrame.ClipsDescendants = true

local layout = Instance.new("UIListLayout", dropdownFrame)
layout.Padding = UDim.new(0,6)

local diceList = {
	"Basic Dice","Seraphic Dice","Galactic Dice","Eldritch Dice",
	"Emperor Dice","Annihilation Dice","Disaster Dice",
	"Impossible Dice","Limbo Dice","Yinyang Dice","Chronos Dice"
}

for _,dice in ipairs(diceList) do
	local btn = Instance.new("TextButton", dropdownFrame)
	btn.Size = UDim2.new(1,-6,0,40)
	btn.Text = dice
	btn.BackgroundColor3 = Color3.fromRGB(35,35,35)
	btn.TextColor3 = Color3.new(1,1,1)
	btn.Font = Enum.Font.Gotham
	btn.TextScaled = true

	btn.MouseButton1Click:Connect(function()
		selectedDice[dice] = not selectedDice[dice]
		btn.BackgroundColor3 = selectedDice[dice] and Color3.fromRGB(0,200,255) or Color3.fromRGB(35,35,35)
	end)
end

layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	dropdownFrame.CanvasSize = UDim2.new(0,0,0,layout.AbsoluteContentSize.Y+6)
end)

dropdownBtn.MouseButton1Click:Connect(function()
	dropdownOpen = not dropdownOpen
	dropdownBtn.Text = dropdownOpen and "Select Dice ▲" or "Select Dice ▼"
	dropdownFrame:TweenSize(
		dropdownOpen and UDim2.new(1,-40,0,200) or UDim2.new(1,-40,0,0),
		Enum.EasingDirection.Out,Enum.EasingStyle.Quad,0.2,true
	)
end)

-- BUTTONS
local function makeToggle(text,y)
	local b = Instance.new("TextButton", page1)
	b.Size = UDim2.new(1,-40,0,50)
	b.Position = UDim2.new(0,20,0,y)
	b.Text = text
	b.BackgroundColor3 = Color3.fromRGB(25,25,25)
	b.TextColor3 = Color3.new(1,1,1)
	b.Font = Enum.Font.GothamBold
	b.TextScaled = true
	return b
end

local autoBtn = makeToggle("Auto Buy Dice: OFF",260)
local eggBtn = makeToggle("Auto Buy Best Egg: OFF",320)
local rollBtn = makeToggle("Auto Roll: OFF",380)
local cashBtn = makeToggle("CASH METHOD (COULD LAG GAME)",440)

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

-- ================= PAGE 2 =================
local wheelBtn = makeToggle("AUTO WHEEL: OFF",60)
wheelBtn.Parent = page2

wheelBtn.MouseButton1Click:Connect(function()
	autoWheel = not autoWheel
	wheelBtn.Text = autoWheel and "AUTO WHEEL: ON" or "AUTO WHEEL: OFF"
	wheelBtn.BackgroundColor3 = autoWheel and Color3.fromRGB(0,255,255) or Color3.fromRGB(25,25,25)
end)

-- PAGE SWITCH
page1Btn.MouseButton1Click:Connect(function()
	page1.Visible = true
	page2.Visible = false
	page1Btn.BackgroundColor3 = Color3.fromRGB(0,255,255)
	page2Btn.BackgroundColor3 = Color3.fromRGB(25,25,25)
end)

page2Btn.MouseButton1Click:Connect(function()
	page1.Visible = false
	page2.Visible = true
	page2Btn.BackgroundColor3 = Color3.fromRGB(0,255,255)
	page1Btn.BackgroundColor3 = Color3.fromRGB(25,25,25)
end)

openBtn.MouseButton1Click:Connect(function()
	frame.Visible = not frame.Visible
end)

-- ================= LOOPS =================
task.spawn(function()
	while true do
		if autoBuy then
			for dice in pairs(selectedDice) do
				BuyRemote:InvokeServer(dice,1,"dice")
			end
		end
		task.wait(0.5)
	end
end)

task.spawn(function()
	while true do
		if autoBuyEgg then
			for i = 1, 1 do -- 10 eggs per frame
				task.spawn(function()
					EggRemote:InvokeServer("MechEgg", 3)
				end)
			end
		end
		task.wait() -- yields to next frame (~60 FPS)
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
		if autoWheel then
			SpinRemote:InvokeServer()
		end
		task.wait(0.2)
	end
end)

task.spawn(function()
	while true do
		if cashMethod then
			for i=1,10000 do
				task.spawn(function()
					ReplicatedStorage.Events.PlaceBestBaddies:InvokeServer()
				end)
			end
		end
		task.wait(1)
	end
end)
