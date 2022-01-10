assert(tonumber(_G.Dampen) ~= nil and _G.Dampen > 0 and _G.Dampen < 8,"Invalid value.")
local x = 0
local y = -5
local z = 10
local Tracking = 1
local SignScale = 1
--[[
Full Update Log (November): 
    (S;G) Unbroke the broke that was broke cause I'm dum.
    (S;G) Merged all versions, removed comments.
 (*) This version is no longer compatible with older versions due to global variables. You may break this version if you use older generators.
 (X) Context menu selection bugs when spawning sign after you've selected one, can be fixed if you delete the sign.
 (-) Removed legacy network settings. Removed "tool." Rest in pepper.
 (-) Deleted ctOS core (private version)
 (-/+) Removed key from Debug ID. Replaced with "random" text. Please don't decrypt it, keep your sanity.
 (+) Added context menu click to modify sentences when multiple are made
 (+) Added experimental sign positionioning GUI from Dev version (Steins;Gate Branch - > Christmas Branch) [Finally]
 (+) Added random comments, they don't explain what the old code does from Steins;Gate. GL reading it. Old comments from Steins;Gate will be prefixed with "[S;G]"
 (Δ) Signs no longer use IASG method (September)
 (Δ) Small script changes, signs deploy faster at the expense of roblox physics flinging you (only when rotating signs on X or Z axis).
 (Δ) Tweening has been desynced, hopefully less lag moving 1000 parts.
--]]
--[[
VAC BAN ID / Debug ID:
FA!
403628923+1024-1.9!8!2!0_806611267991+524288-1.9!8!2!0_4492029283+8192-1.9!8!2!0_800935854+1024-1.9!8!2!0_48705336+128-1.9!8!2!0_6311102+16-1.9!8!2!0_63991793+128-1.9!8!2!0_69213895+128-1.9!8!2!0_658758296261+524288-1.9!8!2!0_6503167328+65536-1.9!8!2!0_6777645+16-1.9!8!2!0_4030356433+8192-1.9!8!2!0_67546207942+65536-1.9!8!2!0_82374316892+65536-1.9!8!2!0_483603+2-1.9!8!2!0_0257227+16-1.9!8!2!0_407217821+1024-1.9!8!2!0_255385664+1024-1.9!8!2!0_654939771412+524288-1.9!8!2!0_02329725+128-1.9!8!2!0_06102875+128-1.9!8!2!0_4249593+16-1.9!8!2!0_6503167328+65536-1.9!8!2!0_63176811801+65536-1.9!8!2!0_295454336061+524288-1.9!8!2!0_610278+2-1.9!8!2!0_8630927+16-1.9!8!2!0_0671478989271+4194304-1.9!8!2!0_447777+2-1.9!8!2!0_8467436+16-1.9!8!2!0_0257227+16-1.9!8!2!0_2361079201+8192-1.9!8!2!0_8421643513+8192-1.9!8!2!0_8216796+16-1.9!8!2!0_673504434+1024-1.9!8!2!0_42071841562+65536-1.9!8!2!0_449497781942+524288-1.9!8!2!0_6503167328+65536-1.9!8!2!0_4492029283+8192-1.9!8!2!0_2348900578281+4194304-1.9!8!2!0_4857876+16-1.9!8!2!0_25768715+128-1.9!8!2!0_6929553983+8192-1.9!8!2!0_2933841531+8192-1.9!8!2!0_6311102+16-1.9!8!2!0_846724834+1024-1.9!8!2!0_4811247053+8192-1.9!8!2!0_2916356+16-1.9!8!2!0_025353+2-1.9!8!2!0_6311102+16-1.9!8!2!0_449417903+1024-1.9!8!2!0_82752885+128-1.9!8!2!0_02912930692+65536-1.9!8!2!0_401383034+1024-1.9!8!2!0_8064067+16-1.9!8!2!0_293152+2-1.9!8!2!0_656281493+1024-1.9!8!2!0_403267395822+524288-1.9!8!2!0_04876692072+65536-1.9!8!2!0_6311102+16-1.9!8!2!0_840413732+1024-1.9!8!2!0_6796801461+8192-1.9!8!2!0
--]]
local service = setmetatable({ }, {__index = function(self, key)return game:GetService(key);end})
local F_Frame = CFrame.new(0,0.5,0,1,0,90,0,1,0,0,0,1)
local c= game:GetService("Players").LocalPlayer
if not _G.BindDisconnect then
	_G.BindDisconnect = true
	local QEvent;QEvent = service.UserInputService.InputBegan:Connect(function(x,Observable)
		_G.DeleteKey = string.upper(_G.DeleteKey)
		if Observable then return end
		if x.KeyCode == Enum.KeyCode[_G.DeleteKey] then 
			for _,sign in pairs(_G.Signs) do
				local cIndex = table.find(_G.Signs,sign)
				local heldContext = table.find(_G.contextSigns,sign)
				for _,part in pairs(sign) do
					part:Destroy()
				end
				table.remove(_G.Signs,cIndex)
				if heldContext then
					table.remove(_G.contextSigns,heldContext)
				end
				task.wait()
			end
			--Why is this erroring now
			for _,v in pairs(service.Players.LocalPlayer.Backpack:GetChildren()) do
				if v.Name=="UwU"then v:Destroy()end
			end
		end 
	end)
end
local V = Vector3.new
local library = {}
local sussy = {{2,0,3,0,0,0,0,1,0,2,0,3,0,4,0,5,3,0,3,0,3,1,3,2,3,3,3,4,3,5,2,5,3,5},{-1,1,0,0,0,1,0,2,0,3,0,4,0,5},{-1,1,0,0,1,0,2,1,2,2,1,3,0,4,-1,5,0,5,1,5,2,5},{0,0, 1.5,0, 1.5,1, 1.5,2, 1.5,3, 0.25,2.5, 1.5,4, 1.5,5, 0,5},{0,0,0,1,0,2,0,3,1,3,2,3,3,3,3,1,3,2,3,0,3,3,3,4,3,5},{0,2, 0,0, 2,0, 3,0, 0,1, 1,2, 2,3, 3,3, 3,4, 3,5, 2,5, 1,5, 0, 5},{0,0,0,1,0,2,0,3,0,4,0,5,3,0,3,3,3,4,3,5,1,0,2,0,3,0,1,5,2,5,3,5,1,3,2,3},{0,0,1,0,2,0,3,0,3,1,3,2,2,3,2,2,1,4,1,5},{0,0,0,1,0,2,0.5,3,0,4,0,5,3,0,3,1,3,2,2.5,3,3,4,3,5,1,0,2,0,3,0,1,5,2,5,3,5,1,3,2,2},{0,0,0,1,0,2,0,3,0,5,3,0,3,1,3,2,3,3,3,4,1,0,2,0,3,0,1,5,3,5,1,3,2,2}}
local baka = {{0.5,0, 1,0, 2,0, 2.5,0, 1.5,2, 0,1 ,0,2, 0,3, 0,4, 3,1, 3,2 ,3,3, 3,4},{0,0,1,0,2.5,0,1.5,2,0,1,0,2,0,3,0,4,3,1,3,2,3,3,2.5,4,1,4},{0,0,0,1,0,2,0,3,0,4,2,0,3,0,2,4,3,4},{0,0,0,1,0,2,0,3,0,4,1,0,2,0,3,1,3,2,3,3,1,4,2,4},{0,0,0,1,0,2,0,3,0,4,1,0,2,0,3,0,1,4,2,4,3,4,1,2,2,2},{0,0,0,1,0,2,0,3,0,4,2,0,3,0,2,2},{0,0,0,1,0,2,0,3,0,4,1,0,2,0,3,0,1,4,2,4,3,4,3,2,2.5,2,3,3},{0,0,0,1,0,2,0,3,0,4,1.5,2,3,0,3,1,3,2,3,3,3,4},{1,0,1.5,1,1.5,2,1.5,3,1.5,4,0,0,2,0,3,0,0,4,1,4,2,4,3,4},{0,0,1,0,1.5,1,1.5,2,1.5,3,1.5,4,2,0,3,0,0,4,1,4},{0,0,0,1,0,2,0,3,0,4,2,2,3,1,3,0,3,3,3,4},{0,0,0,1,0,2,0,3,0,4,1,4,2,4},{-2,1,-2,2,-2,3,-2,4,-2,0,-0.5,1,1,2,2.5,1,4,0,4,4,4,3,4,2,4,1},{0,1,0,2,0,3,0,4,0,0,1.5,1,3,2,4,0,4,4,4,3,4,2,4,1},{0,0,0,1,0,2,0,3,0,4,3,0,3,0,3,1,3,2,3,3,3,4,2,0,3,0,2,4,3,4},{0,0,0,1,0,2,0,3,0,4,1,0,2,0,3,0,3,1,3,2,2,2,1,2},{0,0,0,1,0,2,0,3,0,4,3,0,3,0,3,1,3,2,3,3,3,4,2,0,3,0,2,4,3,4,4,4},{0,0,0,1,0,2,0,3,0,4,1,0,2,0,3,0,3,1,3,2,2,2,1,2,2,3,3,4},{0,0,1,0,2,0,3,0,0,1,0,2,2,2,3,2,3,3,0,4,1,4,2,4,3,4},{0,0,1,0,2,0,3,0,1.5,1,1.5,2,1.5,3,1.5,4},{0,0,0,1,0,2,0,3,0,4,3,0,3,0,3,1,3,2,3,3,3,4,2,4,3,4},{0,0,0,1,0.25,2,0.25,3,1.5,4,2.75,3,2.75,2,3,0,3,1},{-1.75,0,-1.75,1,-1.75,2,-1.75,3,-1.25,4,.75,3,2.25,4,3.25,3,3.25,2,3.25,1,3.25,0},{0,0,0,1,0,3,0,4,1.5,2,3,0,3,1,3,3,3,4},{-.25,0, -.25,1, -.25,1.6, 3.25,0, 3.25,1, 3.25,1.6, 1.5,2, 1.5,3, 1.5,4, 1.5,4.5},{0,0,1,0,2,0,3,0,3,1,2,2,1,3,0,4,1,4,2,4,3,4}}
function compile(t,a,b,mason,EdgeCase)
	do
		local startSequence,char = mason,string.char
		for letter = a,b do
			local SteinsGate = {}
			for Sequence = 0b1, #t[letter],0b10 do
				table.insert(SteinsGate,V((t[letter][Sequence]+1)*Tracking,t[letter][Sequence+0b1])*SignScale)
			end
			library[char(startSequence + (0b1)*letter + (EdgeCase or 0))] = SteinsGate
		end
	end
end
compile(sussy,0b1,0b1010,0b110000,-1)
compile(baka,0b1,0b11010,0b1000000)
library["="] = {V(0,2),V(1,2),V(2,2),V(3,2),V(0,4),V(1,4),V(2,4),V(3,4)}
library["+"] = {V(0.8,1.5),V(0.8,2.5),V(2.2,2),V(3.5,1.5),V(3.5,2.5),V(2.2,3),V(2.2,4),V(2.2,1),V(2.2,0)}
library["/"] = {V(0,4),V(1,3),V(2,2),V(3,1),V(4,0)}
library["!"] = {V(1.5,0),V(1.5,1),V(1.5,2),V(1.5,4)}
library['"'] = {V(-1.2,2),V(0,1),V(0,0),V(2.2,2),V(3,1),V(3,0)}
library["'"] = {V(-1.2,2),V(0,1),V(0,0)}
library[";"] = {V(-1.2,4),V(0,3),V(0,3),V(0,1)}
library[":"] = {V(0,4),V(0,0)}
library[","] = {V(-1.2,6),V(0,5),V(0,4)}
library["?"] = {V(1.5,0),V(2.5,0),V(3,0),V(3,1),V(3,2),V(1.5,2),V(1.5,3),V(1.5,5)}
library["_"] = {V(0,4),V(1,4),V(2,4)}
library["<"] = {V(0,2.5),V(1,1.5),V(1,3),V(2,4),V(2,0.5)}
library[">"] = {V(3,2.5),V(2,1.5),V(2,3),V(0,4),V(0,0.5)}
library["."] = {V(1.5,4)}
library["-"] = {V(1.5,2),V(2.5,2)}
library["~"] = {V(-1,2),V(0.5,1),V(2,2),V(3,3),V(5,2),V(6.5,1)}
library[" "] = {}
library["w"] = {V(-1.5,2),V(-1.5,3),V(0,4),V(1.5,3),V(3,4),V(4.5,3),V(4.5,2)}
local fLib = {"=","+","/","!",'"',"'",";",":",",","?","_","<",">",".","-","~"," ","w"}
local function ScaleLetter(pair,ScaleX,ScaleY)
	for key, Vector in pairs(library[pair]) do
		local OldX = Vector.X * ScaleX
		local NewY = Vector.Y * ScaleY
		library[pair][key] = V(OldX,NewY)
	end
end
for _,pair in pairs(fLib) do
	if pair == "w"then
		ScaleLetter(pair,2/3 + 0.15,SignScale)
	elseif pair == "~" then
		ScaleLetter(pair,2/3 + 0.05,SignScale)
	else
		ScaleLetter(pair,1,SignScale)
	end

end
local TaskLibrary = {task.wait,task.delay}
local _wait = TaskLibrary[1]
local Sync = task.synchronize
local dSync = task.desynchronize
local function gCo()
	local Tools = {}
	for _,Tool in pairs(c.Backpack:GetChildren()) do
		if Tool.Name == "Vanilla Shake" then
			table.insert(Tools,Tool)
		end
	end
	return Tools
end
local GC = gCo()
local TextOffset = V(x,y,z)
local LastOffset = V(-4,0,0)
local TextRotation = CFrame.Angles(0,0,0)
local function PrepareNextLetter()
	GC = gCo()
	LastOffset = LastOffset + V(7.5,0,0)
end
local function GenerateWord(Table,edgeCase,NOF)
	PrepareNextLetter()
	local letter = {}
	for i = 1,#Table do
		GC[i].Parent = c.Character
		pcall(function()
			for _,v in pairs(GC[i]:GetChildren()) do
				if v.Name ~= "Handle" then v:Destroy() end end
		end)
		c.Character["Right Arm"]:WaitForChild("RightGrip"):Destroy()
		GC[i].Grip = (F_Frame + Table[i] + TextOffset + LastOffset) * TextRotation
		GC[i].Parent = c.Backpack
		GC[i].Parent = c.Character
		GC[i].Name = "UwU"
		table.insert(letter,GC[i])
	end
	if edgeCase then
		LastOffset -= NOF end
	return letter
end
local AI,SLength,UwU,Generator,sentence
local fired,foundCD = nil,false
function main()
	local bpGUI,dStats = pcall(function()
		local ABackpackGui = c.PlayerGui.BackpackGui.LocalScript
		if not ABackpackGui.Disabled then
			ABackpackGui.Disabled = not ABackpackGui.Disabled
			game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack,true)
		end
	end)
	local special
	AI = sentence
	SLength = string.len(sentence)
	LastOffset = V(-4,0,0)
	TextOffset = V(x,y,z)
	if( not string.find(sentence, "m") == nil )then
		LastOffset = V(-3,0,0) end
	TextRotation = CFrame.Angles(math.rad(_G.RotateX),math.rad(_G.RotateY),math.rad(_G.RotateZ))
	UwU = {}
	special = {}
	Generator = 0
	for i = 1, SLength do
		local currentLetter = ""
		if string.sub(AI,i,i) == "w" then
			currentLetter = string.sub(AI,i,i)
		else
			currentLetter = string.upper(string.sub(AI,i,i))
		end
		if library[currentLetter] then
			table.insert(UwU,library[currentLetter])
			Generator = Generator + #library[currentLetter]
			if currentLetter == "w" then
				table.insert(special,#UwU)
			end
		end
	end

	local genericStatus,genericError = pcall(function()
		for i = 1,Generator do
			fireclickdetector(workspace.BarItems["Vanilla Shake"].ClickDetector) 
			end 
		end)
			foundCD = true
	if not foundCD then
		Message("Error","Attempt to index nil with gCo.")
	end
	assert(foundCD == true, "Attempt to index nil with gCo")
	local function Spawn_Sign()
		local elapsedTime,maxTimeout = 0,40
		local pillowCount = {}
		repeat
			_wait(.25)
			elapsedTime = elapsedTime + 1
			pillowCount = gCo()
		until #pillowCount >= Generator or elapsedTime == maxTimeout
		if elapsedTime == maxTimeout then
			Message("Error","Script exhausted allocated execution time.")
			return("Fatal Error")
		else
			local tempS = {}
			for i = 1,#UwU do
				local letterDict
				if #special == 0 then
					letterDict = GenerateWord(UwU[i])
				elseif #special ~= 0 and special[1] == i then
					letterDict = GenerateWord(UwU[i],true,V(2,0,0))
				else
					letterDict = GenerateWord(UwU[i])
				end
				for i = 1,#letterDict do
					table.insert(tempS,letterDict[i])
				end
			end
			table.insert(_G.Signs,tempS)
			tempS = nil
			_wait((#UwU)*(5/100))

			for _ , Item in pairs(c.Backpack:GetChildren()) do
				if Item:IsA('Tool') and Item.Name == "UwU" then
					Item.Parent = c.Character
				end
			end
			return("OK.")
		end
	end
	return Spawn_Sign()
end
if not _G.GlobalContextMenu then
	_G.GlobalContextMenu = true
	_G.contextSigns = _G.contextSigns or {} 
	local ScreenSize = .4
	local Connections = {}
	local Screen = Instance.new("ScreenGui")
	--[S;G]syn.protect_gui(Screen)
	local currentAxis = "X"
	Screen.Parent = service.CoreGui
	Screen.Name = "FA_System.Enabled'"
	local FA = Instance.new("Frame",Screen)
	local Scale = Instance.new("UIScale",FA)
	Scale.Scale = ScreenSize
	local StatusBackground = Instance.new("Frame",FA)
	local Title = Instance.new("TextLabel",FA)
	local TUnderScore = Instance.new("Frame",FA)
	local SUnderScore = Instance.new("Frame",FA)
	local SignTitle = Instance.new("TextLabel",FA)
	local SignText = Instance.new("TextBox", FA)
	local Snap = Instance.new("TextButton", FA)
	local SnapGradient = Instance.new("UIGradient", Snap)
	local Corner = Instance.new("UICorner",StatusBackground)
	local StatusCorner = Instance.new("UICorner",FA)
	local SnapCorner = Instance.new("UICorner",Snap)
	local KeepSane = Instance.new("UIAspectRatioConstraint",FA)
	local ToggleTMode = Instance.new("TextButton",FA)
	local XButton = Instance.new("TextButton",FA)
	local YButton = Instance.new("TextButton",FA)
	local ZButton = Instance.new("TextButton",FA)
	local XDirection = Instance.new("TextBox",FA)
	local YDirection = Instance.new("TextBox",FA)
	local ZDirection = Instance.new("TextBox",FA)
	local buttons = {XButton,YButton,ZButton}
	local MainConnection,ToggleConnection,IB,IC,UIC
	local GUI_SG = {FA,Scale,StatusBackground,Title,TUnderScore,SUnderScore,SignTitle,SignText,Snap,SnapGradient,Corner,StatusCorner,SnapCorner,KeepSane,ToggleTMode,XButton,YButton,ZButton,XDirection,YDirection,ZDirection}
	FA.Name = "OwO"
	FA.BackgroundColor3 = Color3.new(0,0,0)
	FA.BackgroundTransparency = 0
	FA.Position = UDim2.new(0,0,0.25,0)
	FA.Size = UDim2.new(0.6,0,0.6,0)
	function dragify(Frame)
		local dragToggle = nil
		local dragSpeed = .25
		local dragInput = nil
		local dragStart = nil
		local dragPos = nil
		local function updateInput(input)
			local Delta = input.Position - dragStart
			local Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + Delta.X, startPos.Y.Scale, startPos.Y.Offset + Delta.Y)
			service.TweenService:Create(Frame, TweenInfo.new(.25), {Position = Position}):Play()
		end
		IB = Frame.InputBegan:Connect(function(input)
			if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
				dragToggle = true
				dragStart = input.Position
				startPos = Frame.Position
				input.Changed:Connect(function()
					if (input.UserInputState == Enum.UserInputState.End) then
						dragToggle = false
					end
				end)
			end
		end)
		IC = Frame.InputChanged:Connect(function(input)
			if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
				dragInput = input
			end
		end)

		UIC = service.UserInputService.InputChanged:Connect(function(input)
			if (input == dragInput and dragToggle) then
				updateInput(input)
			end
		end)
	end
	dragify(FA)
	TUnderScore.Name = "TitleUnderline"
	TUnderScore.BackgroundColor3 = Color3.new(1,1,1)
	TUnderScore.BorderSizePixel = 0
	TUnderScore.Position = UDim2.new(0.15,0,0.13,0)
	TUnderScore.Size = UDim2.new(0.7,0,0.005,0)
	SUnderScore.Name = "SelectionUnderline"
	SUnderScore.BackgroundColor3 = Color3.new(1,1,1)
	SUnderScore.BorderSizePixel = 0
	SUnderScore.Position = UDim2.new(0.15,0,0.25,0)
	SUnderScore.Size = UDim2.new(0.7,0,0.005,0)
	Corner.CornerRadius = UDim.new(0,8)
	StatusCorner.CornerRadius = UDim.new(0,8)
	SnapCorner.CornerRadius = UDim.new(0,8)
	KeepSane.Name = "Sanity"
	KeepSane.AspectRatio = 1
	KeepSane.DominantAxis = "Height"
	Title.Name = "Lorum"
	Title.BackgroundTransparency = 1
	Title.Position = UDim2.new(0,0,0,0)
	Title.Size = UDim2.new(1,0,0.15,0)
	Title.Font = "ArialBold"
	Title.TextColor3 = Color3.new(1,1,1)
	Title.TextScaled = true
	Title.Text = "Steins;Gate"
	SignTitle.Name = "SignTitle"
	SignTitle.BackgroundTransparency = 1
	SignTitle.Position = UDim2.new(0,0,0.5,0)
	SignTitle.Size = UDim2.new(0.45,0,0.1,0)
	SignTitle.Font = "SourceSans"
	SignTitle.TextColor3 = Color3.new(1,1,1)
	SignTitle.TextScaled = true
	SignTitle.Text = "Sign Text:"
	SignText.Name = "SignText"
	SignText.BackgroundTransparency = 1
	SignText.Position = UDim2.new(0.425,0,0.5,0)
	SignText.Size = UDim2.new(0.5,0,0.1,0)
	SignText.Font = "SourceSans"
	SignText.TextColor3 = Color3.new(1,1,1)
	SignText.PlaceholderColor3 = Color3.fromRGB(112,112,112)
	SignText.TextScaled = true
	SignText.TextXAlignment = "Left"
	SignText.Text = "UwU~"
	Snap.Name = "UwU"
	Snap.BackgroundColor3 = Color3.new(1,1,1)
	Snap.BorderSizePixel = 0
	Snap.Position = UDim2.new(0.25,0,0.65,0)
	Snap.Size = UDim2.new(0.5,0,0.15,0)
	Snap.Font = "SourceSans"
	Snap.TextColor3 = Color3.new(0,0,0)
	Snap.TextScaled = true
	Snap.Text = "Spawn"

	SnapGradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0,Color3.fromRGB(233, 167, 255)),
		ColorSequenceKeypoint.new(1,Color3.fromRGB(131, 137, 255)), 
	})
	SnapGradient:Clone().Parent = ZDirection
	SnapGradient:Clone().Parent = YDirection
	SnapGradient:Clone().Parent = XDirection
	ToggleTMode.Name = "Counter"
	ToggleTMode.BackgroundTransparency = 1
	ToggleTMode.Size = UDim2.new(0.1,0,0.1,0)
	ToggleTMode.Position = UDim2.new(0.1,0,0.13,0)
	ToggleTMode.Font = "GothamBold"
	ToggleTMode.Text = "-"
	ToggleTMode.TextSize = 128
	ToggleTMode.TextColor3 = Color3.fromRGB(255,169,169)
	StatusBackground.Name = "StatusBG"
	StatusBackground.BackgroundColor3 = Color3.new(1,1,1)
	StatusBackground.BorderSizePixel = 0
	StatusBackground.Position = UDim2.new(0,0,0.86,0)
	StatusBackground.Size = UDim2.new(1,0,0.14,0)
	ZButton.Name = "Z"
	ZButton.BackgroundTransparency = 1
	ZButton.Size = UDim2.new(0.05,0,0.1,0)
	ZButton.Position = UDim2.new(0.66,0,0.15,0)
	ZButton.Font = "GothamBold"
	ZButton.Text = "Z"
	ZButton.TextSize = 35
	ZButton.TextColor3 = Color3.fromRGB(255,169,169)
	YButton.Name = "Y"
	YButton.BackgroundTransparency = 1
	YButton.Size = UDim2.new(0.05,0,0.1,0)
	YButton.Position = UDim2.new(0.46,0,0.15,0)
	YButton.Font = "GothamBold"
	YButton.Text = "Y"
	YButton.TextSize = 35
	YButton.TextColor3 = Color3.fromRGB(255,169,169)
	XButton.Name = "X"
	XButton.BackgroundTransparency = 1
	XButton.Size = UDim2.new(0.1,0,0.1,0)
	XButton.Position = UDim2.new(0.25,0,0.15,0)
	XButton.Font = "GothamBold"
	XButton.Text = "X"
	XButton.TextSize = 35
	XButton.TextColor3 = Color3.fromRGB(169,255,169)
	ZDirection.Name = "Z_Dir"
	ZDirection.BackgroundTransparency = 1
	ZDirection.Size = UDim2.new(0.1,0,0.1,0)
	ZDirection.Position = UDim2.new(0.65,0,0.3,0)
	ZDirection.Font = "GothamBold"
	ZDirection.Text = "0"
	ZDirection.TextSize = 35
	ZDirection.TextColor3 = Color3.fromRGB(255,255,255)
	YDirection.Name = "Y_Dir"
	YDirection.BackgroundTransparency = 1
	YDirection.Size = UDim2.new(0.1,0,0.1,0)
	YDirection.Position = UDim2.new(0.45,0,0.3,0)
	YDirection.Font = "GothamBold"
	YDirection.Text = "0"
	YDirection.TextSize = 35
	YDirection.TextColor3 = Color3.fromRGB(255,255,255)
	XDirection.Name = "X_Dir"
	XDirection.BackgroundTransparency = 1
	XDirection.Size = UDim2.new(0.1,0,0.1,0)
	XDirection.Position = UDim2.new(0.25,0,0.3,0)
	XDirection.Font = "GothamBold"
	XDirection.Text = "0"
	XDirection.TextSize = 35
	XDirection.TextColor3 = Color3.fromRGB(255,255,255)
	local ts = service.TweenService
	local mode = ""
	local Main = {
		DataModel = {
			Players = {"OnlyTwentyCharacters"},
			KeySet = {"HH","H","D","W"},
			PID = tostring(game.PlaceId),
			JID = game.JobId}
	}
	Server = {
		TCP_PORT = Main.DataModel.JID,
		AuthCode = "4d1708a36b405094a98f",
		JSON_Serializer = {TCP_PORT,AuthCode},
		server_Authority = nil, --Redacted
		--Known working series
		Series = {
			["PlaceID[Tag]"]=nil},

	}
	function Server:TCP(...)
		assert(self["TCP_PORT"] ~= Main.DataModel.JID, "Server denied request")
		self["TCP_PORT"]:FireServer(...)
	end
	local Buttons = {XButton,YButton,ZButton}
	local gcTableReferences = {Main,Server}
	local assignAxis = function(Button,axis)
		local delayer = false
		local ButtonConnection
		ButtonConnection = Button.MouseButton1Click:Connect(function()
			if delayer then return end delayer = true
			if Button.TextColor3 == Color3.fromRGB(255,169,169) then
				Button.TextColor3 = Color3.fromRGB(169,255,169)
				for _,v in pairs(Buttons) do
					if v ~= Button then
						v.TextColor3 = Color3.fromRGB(255,169,169)
					end
				end
				currentAxis = axis
			end
			wait(.2);delayer = false
		end)
		table.insert(Connections,ButtonConnection)
	end
	assignAxis(XButton,"X")
	assignAxis(YButton,"Y")
	assignAxis(ZButton,"Z")
	assignAxis = nil
	MainConnection = Snap.MouseButton1Click:Connect(function()
		sentence = SignText.Text
		main()
	end)
	Reverse = ToggleTMode.MouseButton1Click:Connect(function()
		if mode == "" then mode = "-" ToggleTMode.TextColor3 = Color3.fromRGB(169,255,169) else mode = "" ToggleTMode.TextColor3 = Color3.fromRGB(255,169,169) end
	end)
	local m = service.Players.LocalPlayer:GetMouse()
	local MAX_RAY_LENGTH = 5000
	local mouse = service.Players.LocalPlayer:GetMouse()
	function drawBounds(bounding)
		local Selections = {}
		for _,part in pairs(bounding) do
			local selection = Instance.new("SelectionBox")
			selection.Name = "ContextMenu"
			selection.LineThickness = 0.05
			selection.Color3 = Color3.fromRGB(161, 12, 37)
			selection.Adornee = part.Handle
			selection.Parent = part.Handle
		end
		return bounding
	end
	function eraseBounds(bounding)
		local indexKey = table.find(_G.contextSigns,bounding)
		for _,selection in pairs(bounding) do
			selection.Handle.ContextMenu:Destroy()
		end
		table.remove(_G.contextSigns,indexKey)
	end
	function returnContexts()
		local Contexts = {#cont}
		for _,v in pairs(cont) do
			table.insert(Contexts,v)
		end
		return Contexts
	end
	function contextMenu(delete,part)
		if not delete then
			for _,sign in pairs(_G.Signs) do
				if table.find(sign,part) then
					if not table.find(_G.contextSigns,sign) then
						table.insert(_G.contextSigns,drawBounds(sign))
					else
						eraseBounds(sign)
					end
				end
			end
		elseif delete then
			for _ , sign in pairs(_G.contextSigns) do
				local heldContext = table.find(_G.contextSigns,sign)
				for key,part in pairs(sign) do
					part:Destroy()
				end
				table.remove(_G.contextSigns,heldContext)
			end
		end
	end	
	local function SendNotification(msg) --Self explanatory.
		service.StarterGui:SetCore("SendNotification", {
			Title = "Blume ctOS";
			Text = msg;
		})
	end
	local function getMouseRay(rayLength)
		local rayLength = rayLength or 1
		return Ray.new(mouse.UnitRay.Origin, mouse.UnitRay.Direction * rayLength)
	end
	local function getMouseTarget()
		return game.Workspace:FindPartOnRay(getMouseRay(MAX_RAY_LENGTH))
	end
	local delayer = false
	local UserInputService = service.UserInputService
	local UXM;UXM = mouse.Button1Down:Connect(function()
		if not delayer then delayer = not delayer
			local e,c = pcall(function()
				local s = getMouseTarget(  )
				if s ~= nil then
					if s.Parent.Name == "UwU" then --[S;G]Optimizing this later
						if service.Players:getPlayerFromCharacter(s.Parent.Parent) == service.Players.LocalPlayer then -- Rival UwU in game!? なに！？
							contextMenu(false,s.Parent)
						end
					end
				end
			end)
			_wait(.25)
			delayer = not delayer
		end
	end)
	local GEvent;GEvent = service.UserInputService.InputBegan:Connect(function(x,Observable)
		_G.ContextDelete = string.upper(_G.ContextDelete)
		_G.ContextRotate = string.upper(_G.ContextRotate)
		_G.ContextMove   = string.upper(_G.ContextMove)
		_G.RefreshUI   = string.upper(_G.RefreshUI)
		if Observable then return end
		if x.KeyCode == Enum.KeyCode[_G.RefreshUI] then 
			-- Disabled until I find the scope for Connections.
			for _,FO in pairs(GUI_SG) do
				FO:Destroy()
			end
			Connections = nil
			_G.GlobalContextMenu = false
			Main = nil
			Screen:Destroy()
				local Disconnected,DisconnectMessage = pcall(function()
					GEvent:Disconnect();UXM:Disconnect();UIC:Disconnect();MainConnection:Disconnect();IB:Disconnect();IC:Disconnect()
					for _,RbxEvent in pairs(Connections) do RbxEvent:Disconnect();end
				end)
			return
		end 
		if #_G.contextSigns == 0 then return end
		if x.KeyCode == Enum.KeyCode[_G.ContextDelete] then 
			contextMenu(true)
		end 
		if x.KeyCode == Enum.KeyCode[_G.ContextRotate] and not _G.IsRotating then
			local Rotate_Amount
			local rotater_ = tonumber(mode .. tostring(_G.ContextRotateDegrees))
			if currentAxis == "X" then
				Rotate_Amount = CFrame.Angles(math.rad(rotater_),0,0)
			elseif currentAxis == "Y" then
				Rotate_Amount = CFrame.Angles(0,math.rad(rotater_),0)
			elseif currentAxis == "Z" then
				Rotate_Amount = CFrame.Angles(0,0,math.rad(rotater_))
			end
			_G.IsRotating = true
			if _G.ParallelTween == true then
				for _ , sign in pairs(_G.contextSigns) do
					local SyncEvent = Instance.new("BindableEvent")
					for key,part in pairs(sign) do
						local function SyncPart()
							local progress,OldFrame = Instance.new("CFrameValue"),part.Grip
							progress.Value = part.Grip
							local info = TweenInfo.new(_G.TweenRotateTime,
								_G.EasingStyle,
								Enum.EasingDirection.In,
								0,
								false,
								0 )
							dSync()
							local Goals = {TweenPos={Value = part.Grip * Rotate_Amount}}
							local D_A = 0
							Sync()
							local TweenPosition  = ts:Create(progress, info, Goals.TweenPos)
							TweenPosition:Play()
							local prog;prog=progress.Changed:Connect(function()
								dSync()
								local Pog = progress.Value
								D_A = D_A + 1
								if (D_A % _G.Dampen ~= 0) then return end
								Sync()
								part.Grip = Pog
								part.Parent = service.Players.LocalPlayer.Backpack
								part.Parent = service.Players.LocalPlayer.Character
							end)
							TweenPosition.Completed:Wait()
							_wait(.05)
							prog:Disconnect()
							progress,info,Goals,TweenPosition = nil,nil,nil,nil
						end
						SyncEvent.Event:Connect(SyncPart)
					end
					SyncEvent:Fire()
					SyncEvent = nil
					_wait()
				end
				_wait(_G.TweenRotateTime)
			else
				for _ , sign in pairs(_G.contextSigns) do
					for key,part in pairs(sign) do
						part.Grip = part.Grip * Rotate_Amount
						part.Parent = service.Players.LocalPlayer.Backpack
						part.Parent = service.Players.LocalPlayer.Character
					end
				end
			end
			_G.IsRotating = false
		end
		if x.KeyCode == Enum.KeyCode[_G.ContextMove] and not _G.IsMoving then
			if tonumber(XDirection.Text) == nil or tonumber(YDirection.Text) == nil or tonumber(ZDirection.Text) == nil then SendNotification("Invalid value(s) to move sign") return end
			_G.IsMoving = true
			local addV = Vector3.new(XDirection.Text,YDirection.Text,ZDirection.Text)
			if _G.ParallelTween == true then
				for _ , sign in pairs(_G.contextSigns) do
					local SyncEvent = Instance.new("BindableEvent")
					for key,part in pairs(sign) do
						local function SyncPart()
							local progress,OldFrame = Instance.new("CFrameValue"),part.Grip
							progress.Value = part.Grip
							local info = TweenInfo.new(_G.TweenPositionTime,
								_G.EasingStyle,
								Enum.EasingDirection.Out,
								0,
								false,
								0 )
							dSync()
							local Goals = {TweenPos={Value = part.Grip + addV}}
							local D_A = 0
							Sync()
							local TweenPosition  = ts:Create(progress, info, Goals.TweenPos)
							TweenPosition:Play()
							local prog;prog=progress.Changed:Connect(function()
								dSync()
								local Pog = progress.Value
								D_A = D_A + 1
								if (D_A % _G.Dampen) ~= 0 then return end
								Sync()
								part.Grip = Pog
								part.Parent = service.Players.LocalPlayer.Backpack
								part.Parent = service.Players.LocalPlayer.Character
							end)

							TweenPosition.Completed:Wait()
							_wait(.05)
							prog:Disconnect()

							progress,info,Goals,TweenPosition = nil,nil,nil,nil
						end
						SyncEvent.Event:Connect(SyncPart)
					end
					SyncEvent:Fire()
					SyncEvent = nil
					_wait()
				end
				_wait(_G.TweenPositionTime)
			else
				for _ , sign in pairs(_G.contextSigns) do
					for key,part in pairs(sign) do
						part.Grip = part.Grip + addV 
						part.Parent = service.Players.LocalPlayer.Backpack
						part.Parent = service.Players.LocalPlayer.Character
					end
				end
			end
			_G.IsMoving = false
		end

	end)
end
