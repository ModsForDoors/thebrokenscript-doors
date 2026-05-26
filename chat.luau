local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local FakePlayerName = "Null" 

local RandomSoundIDs = {
	"3999390679", 
	"112340300746045",  
	"3231984721",  
	"3231980820",  
	"3173577378",
	"3767336937",
	"3999387143",
	"3196341435",
	"3419187043"
}

local LoadedMessageSounds = {}

Instance.new
for _, soundId in ipairs(RandomSoundIDs) do
	local snd = Instance.new("Sound")
	snd.SoundId = "rbxassetid://" .. soundId
	snd.Volume = 0.6
	snd.Parent = Workspace
	
	table.insert(LoadedMessageSounds, snd)
end

local AutoResponses = {
	["hello"] = "err.type=hello",
    ["hi?"] = "err.type=hello",
	["who are you?"] = "err.type=null",
	["what do you want?"] = "err.type=null.freedom",
	["herobrine"] = " ",
	["null"] = "The end is null",
	["circuit"] = "It was all his fault.",
	["revuxor"] = "Poor soul."
}

local targetGui = (pcall(function() return CoreGui.Name end) and CoreGui) or LocalPlayer:WaitForChild("PlayerGui")

if targetGui:FindFirstChild("FakeChatGUI") then
	targetGui.FakeChatGUI:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FakeChatGUI"
ScreenGui.Parent = targetGui

local MessageSound = Instance.new("Sound")
MessageSound.SoundId = "rbxassetid://3950462058"
MessageSound.Volume = 0.6
MessageSound.Parent = ScreenGui

local JoinSound = Instance.new("Sound")
JoinSound.SoundId = "rbxassetid://255045683" 
JoinSound.Volume = 0.7
JoinSound.Parent = ScreenGui
 
local ChatFrame = Instance.new("Frame")
ChatFrame.Size = UDim2.new(0, 450, 0, 250)
ChatFrame.Position = UDim2.new(-0.001, 0, 0.46, 0)
ChatFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
ChatFrame.BackgroundTransparency = 0.5 
ChatFrame.BorderSizePixel = 0
ChatFrame.Parent = ScreenGui

local ScrollingFrame = Instance.new("ScrollingFrame")
ScrollingFrame.Size = UDim2.new(1, -20, 1, -50) 
ScrollingFrame.Position = UDim2.new(0, 10, 0, 10)
ScrollingFrame.BackgroundTransparency = 1
ScrollingFrame.BorderSizePixel = 0
ScrollingFrame.ScrollBarThickness = 4
ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollingFrame.Parent = ChatFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom 
UIListLayout.Padding = UDim.new(0, 4)
UIListLayout.Parent = ScrollingFrame

UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	local contentHeight = UIListLayout.AbsoluteContentSize.Y
	ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, contentHeight)
	ScrollingFrame.CanvasPosition = Vector2.new(0, contentHeight)
end)

local TextBox = Instance.new("TextBox")
TextBox.Size = UDim2.new(1, -20, 0, 30)
TextBox.Position = UDim2.new(0, 10, 1, -35) 
TextBox.BackgroundTransparency = 1
TextBox.Text = ""
TextBox.PlaceholderText = 'Texting here (Press "/" or click here for type your message)'
TextBox.PlaceholderColor3 = Color3.fromRGB(180, 180, 180)
TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
TextBox.TextSize = 16
TextBox.Font = Enum.Font.SourceSansItalic
TextBox.TextXAlignment = Enum.TextXAlignment.Left
TextBox.Parent = ChatFrame

local function AddMessage(text, color, isBold)
	local MsgLabel = Instance.new("TextLabel")
	MsgLabel.Size = UDim2.new(1, 0, 0, 20)
	MsgLabel.BackgroundTransparency = 1
	MsgLabel.Text = text
	MsgLabel.TextColor3 = color
	MsgLabel.TextSize = 18
	MsgLabel.Font = isBold and Enum.Font.SourceSansBold or Enum.Font.SourceSans
	MsgLabel.TextXAlignment = Enum.TextXAlignment.Left
	MsgLabel.RichText = true
	MsgLabel.Parent = ScrollingFrame
end

local function FakePlayerSay(text)
	AddMessage("&lt;" .. FakePlayerName .. "&gt; " .. text, Color3.fromRGB(255, 255, 255), false)
	local randomSound = LoadedMessageSounds[math.random(1, #LoadedMessageSounds)]
	randomSound:Play()
end

local function FakePlayerjoined()
	AddMessage(FakePlayerName .. " joined the game", Color3.fromRGB(255, 255, 0), true)
	JoinSound:Play()
end

local function CheckForAutoResponse(msg)
	local lowerMsg = string.lower(msg)
	for trigger, response in pairs(AutoResponses) do
		if string.find(lowerMsg, trigger) then
			task.spawn(function()
				task.wait(math.random(15, 30) / 10)
				FakePlayerSay(response)
			end)
			return
		end
	end
end

if getgenv then
	getgenv().SendFakeMessage = function(text)
		FakePlayerSay(text)
	end
end

task.spawn(function()
	task.wait(1)
	AddMessage(LocalPlayer.Name .. " joined the game", Color3.fromRGB(255, 255, 0), true)
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if not gameProcessed and input.KeyCode == Enum.KeyCode.Slash then
		task.wait()
		TextBox:CaptureFocus()
	end
end)

TextBox.FocusLost:Connect(function(enterPressed)
	if enterPressed and TextBox.Text ~= "" then
		local msgText = TextBox.Text
		TextBox.Text = "" 

		if string.sub(msgText, 1, 4) == "/fs " then
			local customText = string.sub(msgText, 5) 
			FakePlayerSay(customText)
			return 
		end
		
		AddMessage("&lt;" .. LocalPlayer.Name .. "&gt; " .. msgText, Color3.fromRGB(255, 255, 255), false)
		
		CheckForAutoResponse(msgText)
	end
end)


return {
	FakePlayerjoined = FakePlayerjoined
}
