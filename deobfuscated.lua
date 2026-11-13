-- discord.gg/syncrypt

local function v1(p1)
	return bit32.band(bit32.lshift(p1, 24) + bit32.lshift(p1, 8) + bit32.lshift(p1, 7) + bit32.lshift(p1, 4) + bit32.lshift(p1, 1) + p1, 4294967295)
end
local function v2()
	local v3 = tostring(game.GameId) .. "|decccea7f2935992838410ec77539c40005c7d9e4f51845e"
	local n1 = 2166136261

	for i = 1, #v3 do
		local v6 = bit32.bxor(n1, string.byte(v3, i))

		n1 = v1(v6)
	end

	return string.format("%08x", n1)
end
local function v7(p2)
	return type(p2) == "string" and (p2 == v2(0) or p2 == v2(-1) or p2 == v2(1))
end

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CenzDonateRobuxBoot

repeat
	CenzDonateRobuxBoot = ReplicatedStorage:WaitForChild("CenzDonateRobuxBoot", 30)
until CenzDonateRobuxBoot

local n2 = 0

while true do
	local ok, result = pcall(function()
		return CenzDonateRobuxBoot:InvokeServer()
	end)

	if ok and v7(result) then
		break
	end

	n2 += 1
	task.wait(n2 < 15 and 0.5 or 2)
end

local t1 = {
	CameraShaker = {
		name = "CameraShaker"
	},
	CameraShakeInstance = {
		name = "CameraShakeInstance"
	},
	CameraShakePresets = {
		name = "CameraShakePresets"
	}
}
local t2 = {}
local t3 = {}
local t4 = {}
local t5 = {}
local obj = setmetatable({}, {
	__mode = "k"
})
local v19

local function v20(p3)
	local v21 = t5[p3]

	if v21 then
		return v21
	end

	local v22 = t1[p3]

	if not v22 then
		return nil
	end

	local obj2 = setmetatable({}, {
		__tostring = function()
			return v22.name
		end,
		__index = function(p4, p5)
			if p5 == "Name" then
				return v22.name
			end

			if p5 == "ClassName" then
				return "ModuleScript"
			end

			if p5 == "IsA" then
				return function(p6, p7)
					return p7 == "ModuleScript" or p7 == "LuaSourceContainer" or p7 == "Instance"
				end
			end

			return nil
		end
	})

	t5[p3] = obj2
	obj[obj2] = p3

	return obj2
end
local function v24(p8)
	local v25 = obj[p8]

	if v25 == nil then
		return require(p8)
	end

	return v19(v25)
end

v19 = function(p9)
	local v26 = t3[p9]

	if v26 ~= nil then
		if v26 == t4 then
			return nil
		end

		return v26
	end

	local v27 = t2[p9]

	if not v27 then
		error("[CENZ] unknown virtual module: " .. tostring(p9))
	end

	local v28 = v27(v20(p9), v24)

	t3[p9] = v28 == nil and t4 or v28

	return v28
end

local function v29(p10)
	return setmetatable({}, {
		__index = function(p11, p12)
			if p12 == "WaitForChild" then
				return function(p13, p14, p15)
					if t1[p14] then
						return v20(p14)
					end

					return p10 and p10:WaitForChild(p14, p15) or nil
				end
			end

			if p12 == "FindFirstChild" then
				return function(p16, p17, p18)
					if t1[p17] then
						return v20(p17)
					end

					return p10 and p10:FindFirstChild(p17, p18) or nil
				end
			end

			if p12 == "Parent" then
				return p10 and p10.Parent or nil
			end

			if not p10 then
				return nil
			end

			local v30 = p10[p12]

			if type(v30) == "function" then
				return function(...)
					return v30(p10, select(2, ...))
				end
			end

			return v30
		end
	})
end

t2.CameraShaker = function(p19, p20)
	local t6 = {}

	t6.__index = t6

	local vector3 = Vector3.new()
	local v33 = p20(v20("CameraShakeInstance"))
	local CameraShakeState = v33.CameraShakeState
	local vector32 = Vector3.new(0.15, 0.15, 0.15)
	local vector33 = Vector3.new(1, 1, 1)

	t6.CameraShakeInstance = v33
	t6.Presets = p20(v20("CameraShakePresets"))
	t6.new = function(p21, p22)
		assert(type(p21) == "number", "RenderPriority must be a number (e.g.: Enum.RenderPriority.Camera.Value)")
		assert(type(p22) == "function", "Callback must be a function")

		return (setmetatable({
			_running = false,
			_renderName = "CameraShaker_" .. game:GetService("HttpService"):GenerateGUID(false),
			_renderPriority = p21,
			_posAddShake = vector3,
			_rotAddShake = vector3,
			_camShakeInstances = {},
			_removeInstances = {},
			_callback = p22
		}, t6))
	end
	t6.Start = function(p23)
		if p23._running then
			return
		end

		p23._running = true

		local _callback = p23._callback

		game:GetService("RunService"):BindToRenderStep(p23._renderName, p23._renderPriority, function(p24)
			debug.profilebegin("CameraShakerUpdate")

			local v38 = p23:Update(p24)

			debug.profileend()
			_callback(v38)
		end)
	end
	t6.Stop = function(p25)
		if not p25._running then
			return
		end

		game:GetService("RunService"):UnbindFromRenderStep(p25._renderName)
		p25._running = false
	end
	t6.StopSustained = function(p26, p27)
		for _, camShakeInstance in pairs(p26._camShakeInstances) do
			if camShakeInstance.fadeOutDuration == 0 then
				camShakeInstance:StartFadeOut(p27 or camShakeInstance.fadeInDuration)
			end
		end
	end
	t6.Update = function(p28, p29)
		local v41 = vector3
		local v42 = vector3
		local _camShakeInstances = p28._camShakeInstances

		for i = 1, #_camShakeInstances do
			local v45 = _camShakeInstances[i]
			local state = v45:GetState()

			if state == CameraShakeState.Inactive and v45.DeleteOnInactive then
				p28._removeInstances[#p28._removeInstances + 1] = i
			elseif state ~= CameraShakeState.Inactive then
				local v47 = v45:UpdateShake(p29)

				v41 += v47 * v45.PositionInfluence
				v42 += v47 * v45.RotationInfluence
			end
		end

		for i = #p28._removeInstances, 1, -1 do
			table.remove(_camShakeInstances, p28._removeInstances[i])
			p28._removeInstances[i] = nil
		end

		return CFrame.new(v41) * CFrame.Angles(0, math.rad(v42.Y), 0) * CFrame.Angles(math.rad(v42.X), 0, math.rad(v42.Z))
	end
	t6.Shake = function(p30, p31)
		assert(type(p31) == "table" and p31._camShakeInstance, "ShakeInstance must be of type CameraShakeInstance")
		p30._camShakeInstances[#p30._camShakeInstances + 1] = p31

		return p31
	end
	t6.ShakeSustain = function(p32, p33)
		assert(type(p33) == "table" and p33._camShakeInstance, "ShakeInstance must be of type CameraShakeInstance")
		p32._camShakeInstances[#p32._camShakeInstances + 1] = p33
		p33:StartFadeIn(p33.fadeInDuration)

		return p33
	end
	t6.ShakeOnce = function(p34, p35, p36, p37, p38, p39, p40)
		local v49 = v33.new(p35, p36, p37, p38)

		v49.PositionInfluence = typeof(p39) == "Vector3" and p39 or vector32
		v49.RotationInfluence = typeof(p40) == "Vector3" and p40 or vector33
		p34._camShakeInstances[#p34._camShakeInstances + 1] = v49

		return v49
	end
	t6.StartShake = function(p41, p42, p43, p44, p45, p46)
		local v50 = v33.new(p42, p43, p44)

		v50.PositionInfluence = typeof(p45) == "Vector3" and p45 or vector32
		v50.RotationInfluence = typeof(p46) == "Vector3" and p46 or vector33
		v50:StartFadeIn(p44)
		p41._camShakeInstances[#p41._camShakeInstances + 1] = v50

		return v50
	end

	return t6
end
t2.CameraShakeInstance = function()
	local t7 = {}

	t7.__index = t7
	t7.CameraShakeState = {
		FadingIn = 0,
		FadingOut = 1,
		Sustained = 2,
		Inactive = 3
	}

	local function new(p47, p48, p49, p50)
		if p49 == nil then
			p49 = 0
		end

		if p50 == nil then
			p50 = 0
		end

		assert(type(p47) == "number", "Magnitude must be a number")
		assert(type(p48) == "number", "Roughness must be a number")
		assert(type(p49) == "number", "FadeInTime must be a number")
		assert(type(p50) == "number", "FadeOutTime must be a number")

		return (setmetatable({
			Magnitude = p47,
			Roughness = p48,
			PositionInfluence = Vector3.new(),
			RotationInfluence = Vector3.new(),
			DeleteOnInactive = true,
			roughMod = 1,
			magnMod = 1,
			fadeOutDuration = p50,
			fadeInDuration = p49,
			sustain = p49 > 0,
			currentFadeTime = p49 > 0 and 0 or 1,
			tick = Random.new():NextNumber(-100, 100),
			_camShakeInstance = true
		}, t7))
	end

	t7.new = new
	t7.UpdateShake = function(p51, p52)
		local tick = p51.tick
		local currentFadeTime = p51.currentFadeTime
		local vector3 = Vector3.new(math.noise(tick, 0) * 0.5, math.noise(0, tick) * 0.5, math.noise(tick, tick) * 0.5)

		if p51.fadeInDuration > 0 and p51.sustain then
			if currentFadeTime < 1 then
				currentFadeTime += p52 / p51.fadeInDuration
			elseif p51.fadeOutDuration > 0 then
				p51.sustain = false
			end
		end

		if not p51.sustain then
			currentFadeTime -= p52 / p51.fadeOutDuration
		end

		if p51.sustain then
			p51.tick = tick + p52 * p51.Roughness * p51.roughMod
		else
			p51.tick = tick + p52 * p51.Roughness * p51.roughMod * currentFadeTime
		end

		p51.currentFadeTime = currentFadeTime

		return vector3 * p51.Magnitude * p51.magnMod * currentFadeTime
	end
	t7.StartFadeOut = function(p53, p54)
		if p54 == 0 then
			p53.currentFadeTime = 0
		end

		p53.fadeOutDuration = p54
		p53.fadeInDuration = 0
		p53.sustain = false
	end
	t7.StartFadeIn = function(p55, p56)
		if p56 == 0 then
			p55.currentFadeTime = 1
		end

		p55.fadeInDuration = p56 or p55.fadeInDuration
		p55.fadeOutDuration = 0
		p55.sustain = true
	end
	t7.GetScaleRoughness = function(p57)
		return p57.roughMod
	end
	t7.SetScaleRoughness = function(p58, p59)
		p58.roughMod = p59
	end
	t7.GetScaleMagnitude = function(p60)
		return p60.magnMod
	end
	t7.SetScaleMagnitude = function(p61, p62)
		p61.magnMod = p62
	end
	t7.GetNormalizedFadeTime = function(p63)
		return p63.currentFadeTime
	end
	t7.IsShaking = function(p64)
		return p64.currentFadeTime > 0 or p64.sustain
	end

	local function isFadingOut(p65)
		return not p65.sustain and p65.currentFadeTime > 0
	end

	t7.IsFadingOut = isFadingOut
	t7.IsFadingIn = function(p66)
		return p66.currentFadeTime < 1 and p66.sustain and p66.fadeInDuration > 0
	end
	t7.GetState = function(p67)
		if p67:IsFadingIn() then
			return t7.CameraShakeState.FadingIn
		end

		if p67:IsFadingOut() then
			return t7.CameraShakeState.FadingOut
		end

		if p67:IsShaking() then
			return t7.CameraShakeState.Sustained
		end

		return t7.CameraShakeState.Inactive
	end

	return t7
end
t2.CameraShakePresets = function(p68, p69)
	p69(v20("CameraShakeInstance"))

	return setmetatable({}, {
		__index = function(p70, p71)
			local v57 = (nil)[p71]

			if type(v57) == "function" then
				return v57()
			end

			error("No preset found with index \"" .. p71 .. "\"")
		end
	})
end
task.spawn(function()
	local function v58(p72, p73)
		local v59 = p73(game:GetService("ReplicatedStorage").CenzDonateRobuxRS.CenzDonateRobuxConfig)
		local TweenService = game:GetService("TweenService")
		local UIAccentColor = v59.UIAccentColor or Color3.fromRGB(255, 200, 80)

		local function v62(p74, p75, p76)
			return Color3.new(p74.R + (p75.R - p74.R) * p76, p74.G + (p75.G - p74.G) * p76, p74.B + (p75.B - p74.B) * p76)
		end

		local v63 = v62(UIAccentColor, Color3.fromRGB(255, 255, 255), 0.5)
		local colorSequence = ColorSequence.new({
			ColorSequenceKeypoint.new(0, UIAccentColor),
			ColorSequenceKeypoint.new(0.3, UIAccentColor),
			ColorSequenceKeypoint.new(0.43, v63),
			ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
			ColorSequenceKeypoint.new(0.57, v63),
			ColorSequenceKeypoint.new(0.7, UIAccentColor),
			ColorSequenceKeypoint.new(1, UIAccentColor)
		})

		local function createUIGradient(p77, p78)
			local rotation = p78 or 0

			if p77:IsA("UIStroke") then
				p77.Color = Color3.fromRGB(255, 255, 255)

				local UIGradient = Instance.new("UIGradient")

				UIGradient.Color = colorSequence
				UIGradient.Rotation = 0
				UIGradient.Parent = p77
				TweenService:Create(UIGradient, TweenInfo.new(3, Enum.EasingStyle.Linear, Enum.EasingDirection.In, -1, false), {
					Rotation = 360
				}):Play()

				return UIGradient
			end

			p77.BackgroundColor3 = Color3.fromRGB(255, 255, 255)

			local UIGradient = Instance.new("UIGradient")

			UIGradient.Color = colorSequence
			UIGradient.Rotation = rotation

			local vector2, vector22

			if rotation == 90 or rotation == 270 then
				vector2 = Vector2.new(0, -0.5)
				vector22 = Vector2.new(0, 0.5)
			else
				vector2 = Vector2.new(-0.5, 0)
				vector22 = Vector2.new(0.5, 0)
			end

			UIGradient.Offset = vector2
			UIGradient.Parent = p77
			TweenService:Create(UIGradient, TweenInfo.new(1.5, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1, true), {
				Offset = vector22
			}):Play()

			return UIGradient
		end

		local ReplicatedStorage2 = game:GetService("ReplicatedStorage")
		local TweenService2 = game:GetService("TweenService")
		local SoundService = game:GetService("SoundService")
		local Players = game:GetService("Players")
		local CenzRobuxAnnounce = ReplicatedStorage2:WaitForChild("CenzDonateRobuxRS"):WaitForChild("CenzDonateRobuxRemotes"):WaitForChild("CenzRobuxAnnounce")
		local LocalPlayer = Players.LocalPlayer
		local t8 = {}
		local u78 = false

		local function v79()
			local UserInputService = game:GetService("UserInputService")

			return UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
		end
		local function v81()
			local CenzDonateRobuxArea = workspace:FindFirstChild("CenzDonateRobuxArea")

			if not CenzDonateRobuxArea then
				return nil
			end

			local CenzDonateRobuxSounds = CenzDonateRobuxArea:FindFirstChild("CenzDonateRobuxSounds")

			if not CenzDonateRobuxSounds then
				return nil
			end

			local Donation = CenzDonateRobuxSounds:FindFirstChild("Donation")

			if Donation and Donation:IsA("Sound") then
				return Donation
			end

			for _, child in ipairs(CenzDonateRobuxSounds:GetChildren()) do
				if child:IsA("Sound") then
					return child
				end
			end

			return nil
		end
		local function v87()
			local v88 = v81()

			if not v88 then
				return
			end

			local clone = v88:Clone()

			clone.Parent = SoundService
			clone:Play()
			game:GetService("Debris"):AddItem(clone, (clone.TimeLength > 0 and clone.TimeLength or 4) + 1)
		end
		local function v90(p79)
			return tostring(math.floor(tonumber(p79 or 0) or 0)):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")
		end
		local function v91(p80, p81)
			if not p81 then
				return
			end

			local ok, image = pcall(Players.GetUserThumbnailAsync, Players, p81, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size180x180)

			if ok and image then
				p80.Image = image
			end
		end
		local function v94(p82)
			local v95 = p82.message and tostring(p82.message) ~= ""
			local v96 = v79()
			local v97 = v95 and (v96 and 0.3 or 0.25) or v96 and 0.22 or 0.18
			local v98 = v96 and 0.42 or 0.38

			if v96 then
				v97 *= 0.65
				v98 *= 0.65
			end

			local ScreenGui = Instance.new("ScreenGui")

			ScreenGui.IgnoreGuiInset = true
			ScreenGui.ResetOnSpawn = false
			ScreenGui.DisplayOrder = 1000
			ScreenGui.Name = "DonationPopup"
			ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

			local Frame = Instance.new("Frame")

			Frame.AnchorPoint = Vector2.new(0.5, 0)
			Frame.Position = UDim2.fromScale(0.5, 0.05)
			Frame.Size = UDim2.fromScale(v98, v97)
			Frame.BackgroundColor3 = Color3.fromRGB(8, 8, 14)
			Frame.BackgroundTransparency = 0.05
			Frame.ClipsDescendants = true
			Frame.Parent = ScreenGui

			local UICorner = Instance.new("UICorner")

			UICorner.CornerRadius = UDim.new(0.035, 0)
			UICorner.Parent = Frame

			local UIStroke = Instance.new("UIStroke")

			UIStroke.Thickness = 2
			UIStroke.Transparency = 0.1
			UIStroke.Color = UIAccentColor
			UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
			UIStroke.Parent = Frame
			createUIGradient(UIStroke)

			local UIGradient = Instance.new("UIGradient")

			UIGradient.Rotation = 90
			UIGradient.Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, Color3.fromRGB(8, 8, 14)),
				ColorSequenceKeypoint.new(0.5, Color3.fromRGB(16, 10, 28)),
				ColorSequenceKeypoint.new(1, Color3.fromRGB(8, 8, 14))
			})
			UIGradient.Parent = Frame

			local UIPadding = Instance.new("UIPadding")

			UIPadding.PaddingTop = UDim.new(0.03, 0)
			UIPadding.PaddingBottom = UDim.new(0.04, 0)
			UIPadding.PaddingLeft = UDim.new(0.03, 0)
			UIPadding.PaddingRight = UDim.new(0.03, 0)
			UIPadding.Parent = Frame

			local Frame2 = Instance.new("Frame")

			Frame2.Size = UDim2.fromScale(1, 0.18)
			Frame2.BackgroundTransparency = 1
			Frame2.Parent = Frame

			local UIListLayout = Instance.new("UIListLayout")

			UIListLayout.FillDirection = Enum.FillDirection.Horizontal
			UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
			UIListLayout.Padding = UDim.new(0.015, 0)
			UIListLayout.Parent = Frame2

			local TextLabel = Instance.new("TextLabel")

			TextLabel.Size = UDim2.fromScale(1, 1)
			TextLabel.BackgroundTransparency = 1
			TextLabel.Text = "NEW DONATION"
			TextLabel.TextScaled = true
			TextLabel.Font = Enum.Font.GothamBlack
			TextLabel.TextXAlignment = Enum.TextXAlignment.Center
			TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
			TextLabel.Parent = Frame2
			Instance.new("UITextSizeConstraint", TextLabel).MaxTextSize = 40

			local UIGradient2 = Instance.new("UIGradient")

			UIGradient2.Color = colorSequence
			UIGradient2.Rotation = 90
			UIGradient2.Parent = TextLabel

			local TweenService3 = game:GetService("TweenService")

			UIGradient2.Offset = Vector2.new(0, 0.3)
			TweenService3:Create(UIGradient2, TweenInfo.new(1.5, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1, true), {
				Offset = Vector2.new(0, -0.3)
			}):Play()

			local Frame3 = Instance.new("Frame")

			Frame3.Size = UDim2.fromScale(1, 0.01)
			Frame3.Position = UDim2.fromScale(0, 0.19)
			Frame3.BackgroundColor3 = UIAccentColor
			createUIGradient(Frame3)
			Frame3.BorderSizePixel = 0
			Frame3.Parent = Frame

			local Frame4 = Instance.new("Frame")

			Frame4.Size = UDim2.fromScale(1, 0.76)
			Frame4.Position = UDim2.fromScale(0, 0.21)
			Frame4.BackgroundTransparency = 1
			Frame4.Parent = Frame

			local Frame5 = Instance.new("Frame")

			Frame5.Size = UDim2.fromScale(0.24, 1)
			Frame5.BackgroundTransparency = 1
			Frame5.Parent = Frame4

			local Frame6 = Instance.new("Frame")

			Frame6.Size = UDim2.fromScale(0.8, 0.5)
			Frame6.AnchorPoint = Vector2.new(0.5, 0)
			Frame6.Position = UDim2.fromScale(0.5, 0.08)
			Frame6.BackgroundTransparency = 1
			Frame6.Parent = Frame5

			local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")

			UIAspectRatioConstraint.AspectRatio = 1
			UIAspectRatioConstraint.DominantAxis = Enum.DominantAxis.Height
			UIAspectRatioConstraint.Parent = Frame6

			local ImageLabel = Instance.new("ImageLabel")

			ImageLabel.Size = UDim2.fromScale(1, 1)
			ImageLabel.BackgroundColor3 = Color3.fromRGB(20, 14, 30)
			ImageLabel.Parent = Frame6

			local UICorner2 = Instance.new("UICorner")

			UICorner2.CornerRadius = UDim.new(1, 0)
			UICorner2.Parent = ImageLabel

			local UIStroke2 = Instance.new("UIStroke")

			UIStroke2.Thickness = 2
			UIStroke2.Color = v63
			UIStroke2.Parent = ImageLabel
			createUIGradient(UIStroke2)

			local TextLabel2 = Instance.new("TextLabel")

			TextLabel2.Size = UDim2.fromScale(1, 0.16)
			TextLabel2.Position = UDim2.fromScale(0, 0.6)
			TextLabel2.BackgroundTransparency = 1
			TextLabel2.Text = tostring(p82.displayName or "Unknown")
			TextLabel2.TextScaled = true
			TextLabel2.Font = Enum.Font.GothamBlack
			TextLabel2.TextXAlignment = Enum.TextXAlignment.Center
			TextLabel2.TextColor3 = Color3.fromRGB(255, 255, 255)
			TextLabel2.Parent = Frame5

			local TextLabel3 = Instance.new("TextLabel")

			TextLabel3.Size = UDim2.fromScale(1, 0.12)
			TextLabel3.Position = UDim2.fromScale(0, 0.76)
			TextLabel3.BackgroundTransparency = 1
			TextLabel3.Text = "@" .. tostring(p82.username or "")
			TextLabel3.TextScaled = true
			TextLabel3.Font = Enum.Font.GothamSemibold
			TextLabel3.TextXAlignment = Enum.TextXAlignment.Center
			TextLabel3.TextColor3 = Color3.fromRGB(160, 150, 190)
			TextLabel3.Parent = Frame5

			local Frame7 = Instance.new("Frame")

			Frame7.Size = UDim2.fromScale(0.005, 0.9)
			Frame7.Position = UDim2.fromScale(0.26, 0.05)
			Frame7.BackgroundColor3 = UIAccentColor
			createUIGradient(Frame7, 90)
			Frame7.BackgroundTransparency = 0.3
			Frame7.BorderSizePixel = 0
			Frame7.Parent = Frame4

			local Frame8 = Instance.new("Frame")

			Frame8.Size = UDim2.fromScale(0.69, 1)
			Frame8.Position = UDim2.fromScale(0.29, 0)
			Frame8.BackgroundTransparency = 1
			Frame8.Parent = Frame4

			local UIListLayout2 = Instance.new("UIListLayout")

			UIListLayout2.FillDirection = Enum.FillDirection.Vertical
			UIListLayout2.HorizontalAlignment = Enum.HorizontalAlignment.Center
			UIListLayout2.VerticalAlignment = Enum.VerticalAlignment.Center
			UIListLayout2.Padding = UDim.new(0.03, 0)
			UIListLayout2.SortOrder = Enum.SortOrder.LayoutOrder
			UIListLayout2.Parent = Frame8

			if v95 then
				local Frame9 = Instance.new("Frame")

				Frame9.Size = UDim2.fromScale(0.95, 0.42)
				Frame9.BackgroundColor3 = Color3.fromRGB(14, 14, 26)
				Frame9.BackgroundTransparency = 0.2
				Frame9.LayoutOrder = 1
				Frame9.Parent = Frame8

				local UICorner3 = Instance.new("UICorner")

				UICorner3.CornerRadius = UDim.new(0.06, 0)
				UICorner3.Parent = Frame9

				local UIStroke3 = Instance.new("UIStroke")

				UIStroke3.Thickness = 1.5
				UIStroke3.Transparency = 0.3
				UIStroke3.Color = UIAccentColor
				UIStroke3.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
				UIStroke3.Parent = Frame9
				createUIGradient(UIStroke3)

				local UIPadding2 = Instance.new("UIPadding")

				UIPadding2.PaddingLeft = UDim.new(0.05, 0)
				UIPadding2.PaddingRight = UDim.new(0.05, 0)
				UIPadding2.PaddingTop = UDim.new(0.06, 0)
				UIPadding2.PaddingBottom = UDim.new(0.06, 0)
				UIPadding2.Parent = Frame9

				local TextLabel4 = Instance.new("TextLabel")

				TextLabel4.Size = UDim2.fromScale(1, 1)
				TextLabel4.BackgroundTransparency = 1
				TextLabel4.Text = tostring(p82.message)
				TextLabel4.TextScaled = true
				TextLabel4.TextWrapped = true
				TextLabel4.Font = Enum.Font.GothamSemibold
				TextLabel4.TextColor3 = Color3.fromRGB(255, 255, 255)
				TextLabel4.Parent = Frame9

				local UITextSizeConstraint = Instance.new("UITextSizeConstraint")

				UITextSizeConstraint.MinTextSize = 12
				UITextSizeConstraint.MaxTextSize = 28
				UITextSizeConstraint.Parent = TextLabel4
			end

			local Frame9 = Instance.new("Frame")

			Frame9.Size = UDim2.fromScale(0.95, v95 and 0.35 or 0.55)
			Frame9.BackgroundTransparency = 1
			Frame9.LayoutOrder = 2
			Frame9.Parent = Frame8

			local TextLabel4 = Instance.new("TextLabel")

			TextLabel4.Size = UDim2.fromScale(0.46, 0.45)
			TextLabel4.Position = UDim2.fromScale(0, 0.02)
			TextLabel4.BackgroundTransparency = 1
			TextLabel4.Text = "DONATED"
			TextLabel4.TextScaled = true
			TextLabel4.Font = Enum.Font.GothamBold
			TextLabel4.TextXAlignment = Enum.TextXAlignment.Left
			TextLabel4.TextColor3 = Color3.fromRGB(150, 150, 180)
			TextLabel4.Parent = Frame9

			local TextLabel5 = Instance.new("TextLabel")

			TextLabel5.Size = UDim2.fromScale(0.46, 0.48)
			TextLabel5.Position = UDim2.fromScale(0, 0.48)
			TextLabel5.BackgroundTransparency = 1
			TextLabel5.Text = v90(p82.amount) .. " Robux"
			TextLabel5.TextScaled = true
			TextLabel5.Font = Enum.Font.GothamBlack
			TextLabel5.TextXAlignment = Enum.TextXAlignment.Left
			TextLabel5.TextColor3 = Color3.fromRGB(0, 255, 220)
			TextLabel5.Parent = Frame9

			local TextLabel6 = Instance.new("TextLabel")

			TextLabel6.Size = UDim2.fromScale(0.48, 0.45)
			TextLabel6.Position = UDim2.fromScale(0.5, 0.02)
			TextLabel6.BackgroundTransparency = 1
			TextLabel6.Text = "TOTAL"
			TextLabel6.TextScaled = true
			TextLabel6.Font = Enum.Font.GothamBold
			TextLabel6.TextXAlignment = Enum.TextXAlignment.Left
			TextLabel6.TextColor3 = Color3.fromRGB(150, 150, 180)
			TextLabel6.Parent = Frame9

			local TextLabel7 = Instance.new("TextLabel")

			TextLabel7.Size = UDim2.fromScale(0.48, 0.48)
			TextLabel7.Position = UDim2.fromScale(0.5, 0.48)
			TextLabel7.BackgroundTransparency = 1
			TextLabel7.Text = v90(p82.total) .. " Robux"
			TextLabel7.TextScaled = true
			TextLabel7.Font = Enum.Font.GothamBlack
			TextLabel7.TextXAlignment = Enum.TextXAlignment.Left
			TextLabel7.TextColor3 = Color3.fromRGB(255, 120, 255)
			TextLabel7.Parent = Frame9

			local uDim2 = UDim2.fromScale(v98, v97)

			Frame.Size = UDim2.fromScale(v98, 0)
			Frame.BackgroundTransparency = 1
			UIStroke.Transparency = 1
			TweenService2:Create(Frame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
				Size = uDim2,
				BackgroundTransparency = 0.05
			}):Play()
			TweenService2:Create(UIStroke, TweenInfo.new(0.3), {
				Transparency = 0.1
			}):Play()
			v91(ImageLabel, tonumber(p82.userId))
			v87()
			task.wait(v59.PopupRobuxDisplayDuration)
			TweenService2:Create(Frame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
				Size = UDim2.fromScale(v98, 0),
				BackgroundTransparency = 1
			}):Play()
			TweenService2:Create(UIStroke, TweenInfo.new(0.3), {
				Transparency = 1
			}):Play()
			task.wait(0.35)
			ScreenGui:Destroy()
		end
		local function v135()
			if u78 then
				return
			end

			u78 = true

			while #t8 > 0 do
				v94(table.remove(t8, 1))
			end

			u78 = false
		end

		CenzRobuxAnnounce.OnClientEvent:Connect(function(p83)
			if _G.CenzRobuxCinematicWillShow then
				local ok, result = pcall(_G.CenzRobuxCinematicWillShow, p83)

				if ok and result then
					return
				end
			end

			table.insert(t8, p83 or {})
			v135()
		end)
		print("CENZ STUDIO DONATE ROBUX ANNOUNCE CLIENT ACTIVE")
	end

	v58(script, v24)
end)
task.spawn(function()
	local function v138(p84, p85)
		local v139 = p85(game:GetService("ReplicatedStorage").CenzDonateRobuxRS.CenzDonateRobuxConfig)
		local TweenService = game:GetService("TweenService")
		local UIAccentColor = v139.UIAccentColor or Color3.fromRGB(255, 200, 80)

		local function v142(p86, p87, p88)
			return Color3.new(p86.R + (p87.R - p86.R) * p88, p86.G + (p87.G - p86.G) * p88, p86.B + (p87.B - p86.B) * p88)
		end

		local v143 = v142(UIAccentColor, Color3.fromRGB(255, 255, 255), 0.5)
		local colorSequence = ColorSequence.new({
			ColorSequenceKeypoint.new(0, UIAccentColor),
			ColorSequenceKeypoint.new(0.3, UIAccentColor),
			ColorSequenceKeypoint.new(0.43, v143),
			ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
			ColorSequenceKeypoint.new(0.57, v143),
			ColorSequenceKeypoint.new(0.7, UIAccentColor),
			ColorSequenceKeypoint.new(1, UIAccentColor)
		})

		local function createUIGradient(p89, p90)
			local rotation = p90 or 0

			if p89:IsA("UIStroke") then
				p89.Color = Color3.fromRGB(255, 255, 255)

				local UIGradient = Instance.new("UIGradient")

				UIGradient.Color = colorSequence
				UIGradient.Rotation = 0
				UIGradient.Parent = p89
				TweenService:Create(UIGradient, TweenInfo.new(3, Enum.EasingStyle.Linear, Enum.EasingDirection.In, -1, false), {
					Rotation = 360
				}):Play()

				return UIGradient
			end

			p89.BackgroundColor3 = Color3.fromRGB(255, 255, 255)

			local UIGradient = Instance.new("UIGradient")

			UIGradient.Color = colorSequence
			UIGradient.Rotation = rotation

			local vector2, vector22

			if rotation == 90 or rotation == 270 then
				vector2 = Vector2.new(0, -0.5)
				vector22 = Vector2.new(0, 0.5)
			else
				vector2 = Vector2.new(-0.5, 0)
				vector22 = Vector2.new(0.5, 0)
			end

			UIGradient.Offset = vector2
			UIGradient.Parent = p89
			TweenService:Create(UIGradient, TweenInfo.new(1.5, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1, true), {
				Offset = vector22
			}):Play()

			return UIGradient
		end
		local function createUIGradient2(p91)
			local UIGradient = Instance.new("UIGradient")

			UIGradient.Color = colorSequence
			UIGradient.Rotation = 90
			UIGradient.Offset = Vector2.new(0, 0.3)
			UIGradient.Parent = p91
			TweenService:Create(UIGradient, TweenInfo.new(1.5, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1, true), {
				Offset = Vector2.new(0, -0.3)
			}):Play()

			return UIGradient
		end

		local Players = game:GetService("Players")
		local TweenService2 = game:GetService("TweenService")
		local StarterGui = game:GetService("StarterGui")
		local ReplicatedStorage2 = game:GetService("ReplicatedStorage")
		local LocalPlayer = Players.LocalPlayer
		local CenzDonateRobuxRemotes = ReplicatedStorage2:WaitForChild("CenzDonateRobuxRS"):WaitForChild("CenzDonateRobuxRemotes")
		local CenzRobuxAdminCommand = CenzDonateRobuxRemotes:WaitForChild("CenzRobuxAdminCommand")
		local CenzRobuxAdminNotify = CenzDonateRobuxRemotes:WaitForChild("CenzRobuxAdminNotify")

		if not (function()
			for _, adminRobuxUserId in ipairs(v139.AdminRobuxUserIds) do
				if LocalPlayer.UserId == adminRobuxUserId then
					return true
				end
			end

			return false
		end)() then
			CenzRobuxAdminNotify.OnClientEvent:Connect(function(p92, p93)
				pcall(function()
					StarterGui:SetCore("ChatMakeSystemMessage", {
						Text = "[ADMIN] " .. p92,
						Color = p93 or Color3.new(1, 1, 1)
					})
				end)
			end)

			return
		end

		local function v163()
			local UserInputService = game:GetService("UserInputService")

			return UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
		end
		local function v165(p94)
			return tostring(math.floor(tonumber(p94) or 0)):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")
		end
		local function v166(p95)
			local ok, result = pcall(Players.GetUserThumbnailAsync, Players, p95, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)

			ok = ok and result

			return ok or ""
		end

		local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
		local u170 = false
		local ScreenGui
		local Frame
		local ScrollingFrame
		local TextBox
		local TextLabel
		local ImageLabel
		local TextLabel2
		local TextLabel3
		local TextLabel4
		local t9 = {}
		local u181
		local v182
		local TextBox2
		local TextBox3

		local function v185(p96, p97)
			if not TextLabel then
				return
			end

			TextLabel.Text = p96
			TextLabel.TextColor3 = p97 or Color3.fromRGB(0, 255, 100)
			task.delay(4, function()
				if TextLabel and TextLabel.Text == p96 then
					TextLabel.Text = ""
				end
			end)
		end
		local function v186()
			if not u181 then
				if ImageLabel then
					ImageLabel.Image = ""
				end

				if TextLabel2 then
					TextLabel2.Text = "No Player Selected"
				end

				if TextLabel3 then
					TextLabel3.Text = ""
				end

				if TextLabel4 then
					TextLabel4.Text = "—"
				end

				return
			end

			local v187 = u181

			task.spawn(function()
				if ImageLabel then
					ImageLabel.Image = v166(v187.userId)
				end
			end)

			if TextLabel2 then
				TextLabel2.Text = v187.displayName or "Unknown"
			end

			if TextLabel3 then
				TextLabel3.Text = "@" .. (v187.username or "")
			end

			if TextLabel4 then
				TextLabel4.Text = v165(v187.total or 0) .. " Robux"
			end

			task.spawn(function()
				local ok, result = pcall(function()
					return CenzRobuxAdminCommand:InvokeServer("getPlayerTotal", {
						userId = v187.userId
					})
				end)

				if ok and result and result.success then
					v187.total = result.total or 0

					if TextLabel4 and u181 and u181.userId == v187.userId then
						TextLabel4.Text = v165(result.total or 0) .. " Robux"
					end
				end
			end)
		end
		local function createFrame(p98)
			local v191 = u181 and u181.userId == p98.userId
			local Frame2 = Instance.new("Frame")

			Frame2.Size = UDim2.new(1, 0, 0.16, 0)
			Frame2.BackgroundColor3 = v191 and Color3.fromRGB(75, 55, 100) or Color3.fromRGB(14, 14, 26)
			Frame2.BackgroundTransparency = 0.2
			Frame2.Parent = ScrollingFrame
			Instance.new("UICorner", Frame2).CornerRadius = UDim.new(0.12, 0)

			local UIStroke = Instance.new("UIStroke")

			UIStroke.Color = UIAccentColor
			UIStroke.Thickness = 1
			UIStroke.Transparency = v191 and 0.1 or 0.4
			UIStroke.Parent = Frame2
			createUIGradient(UIStroke)

			local TextButton = Instance.new("TextButton")

			TextButton.Size = UDim2.fromScale(1, 1)
			TextButton.BackgroundTransparency = 1
			TextButton.BorderSizePixel = 0
			TextButton.Text = ""
			TextButton.AutoButtonColor = false
			TextButton.Parent = Frame2

			local ImageLabel2 = Instance.new("ImageLabel")

			ImageLabel2.Size = UDim2.fromScale(0.15, 0.8)
			ImageLabel2.Position = UDim2.fromScale(0.03, 0.5)
			ImageLabel2.AnchorPoint = Vector2.new(0, 0.5)
			ImageLabel2.BackgroundColor3 = Color3.fromRGB(30, 28, 38)
			ImageLabel2.BorderSizePixel = 0
			ImageLabel2.Parent = Frame2
			Instance.new("UICorner", ImageLabel2).CornerRadius = UDim.new(1, 0)
			Instance.new("UIAspectRatioConstraint", ImageLabel2).AspectRatio = 1

			local UIStroke2 = Instance.new("UIStroke")

			UIStroke2.Color = UIAccentColor
			UIStroke2.Thickness = 1.5
			UIStroke2.Transparency = 0.4
			UIStroke2.Parent = ImageLabel2
			createUIGradient(UIStroke2)
			task.spawn(function()
				ImageLabel2.Image = v166(p98.userId)
			end)

			local TextLabel5 = Instance.new("TextLabel")

			TextLabel5.Size = UDim2.fromScale(0.78, 0.38)
			TextLabel5.Position = UDim2.fromScale(0.2, 0.12)
			TextLabel5.BackgroundTransparency = 1
			TextLabel5.Text = p98.displayName or ""
			TextLabel5.TextScaled = true
			TextLabel5.Font = Enum.Font.GothamBold
			TextLabel5.TextColor3 = Color3.fromRGB(255, 255, 255)
			TextLabel5.TextXAlignment = Enum.TextXAlignment.Left
			TextLabel5.TextYAlignment = Enum.TextYAlignment.Bottom
			TextLabel5.TextTruncate = Enum.TextTruncate.AtEnd
			TextLabel5.Parent = Frame2
			Instance.new("UITextSizeConstraint", TextLabel5).MaxTextSize = 14

			local TextLabel6 = Instance.new("TextLabel")

			TextLabel6.Name = "Info"
			TextLabel6.Size = UDim2.fromScale(0.78, 0.33)
			TextLabel6.Position = UDim2.fromScale(0.2, 0.5)
			TextLabel6.BackgroundTransparency = 1
			TextLabel6.Text = "@" .. (p98.username or "") .. " | " .. v165(p98.total or 0) .. " R$"
			TextLabel6.TextScaled = true
			TextLabel6.Font = Enum.Font.Gotham
			TextLabel6.TextColor3 = v191 and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(160, 150, 190)
			TextLabel6.TextXAlignment = Enum.TextXAlignment.Left
			TextLabel6.TextYAlignment = Enum.TextYAlignment.Top
			TextLabel6.Parent = Frame2
			Instance.new("UITextSizeConstraint", TextLabel6).MaxTextSize = 11
			TextButton.MouseButton1Click:Connect(function()
				for _, v in pairs(t9) do
					if v and v.Parent then
						TweenService2:Create(v, TweenInfo.new(0.12), {
							BackgroundColor3 = Color3.fromRGB(14, 14, 26)
						}):Play()

						local UIStroke3 = v:FindFirstChildOfClass("UIStroke")

						if UIStroke3 then
							TweenService2:Create(UIStroke3, TweenInfo.new(0.12), {
								Transparency = 0.4
							}):Play()
						end

						local Info = v:FindFirstChild("Info")

						if Info then
							TweenService2:Create(Info, TweenInfo.new(0.12), {
								TextColor3 = Color3.fromRGB(160, 150, 190)
							}):Play()
						end
					end
				end

				TweenService2:Create(Frame2, TweenInfo.new(0.12), {
					BackgroundColor3 = Color3.fromRGB(75, 55, 100)
				}):Play()
				TweenService2:Create(UIStroke, TweenInfo.new(0.12), {
					Transparency = 0.1
				}):Play()
				TweenService2:Create(TextLabel6, TweenInfo.new(0.12), {
					TextColor3 = Color3.fromRGB(255, 255, 255)
				}):Play()
				u181 = p98
				v186()
			end)
			TextButton.MouseEnter:Connect(function()
				if not u181 or u181.userId ~= p98.userId then
					TweenService2:Create(Frame2, TweenInfo.new(0.08), {
						BackgroundColor3 = Color3.fromRGB(42, 38, 55)
					}):Play()
					TweenService2:Create(UIStroke, TweenInfo.new(0.08), {
						Transparency = 0.2
					}):Play()
				end
			end)
			TextButton.MouseLeave:Connect(function()
				if not u181 or u181.userId ~= p98.userId then
					TweenService2:Create(Frame2, TweenInfo.new(0.08), {
						BackgroundColor3 = Color3.fromRGB(14, 14, 26)
					}):Play()
					TweenService2:Create(UIStroke, TweenInfo.new(0.08), {
						Transparency = 0.4
					}):Play()
				end
			end)

			return Frame2
		end
		local function v203()
			local v204 = v163()

			ScreenGui = Instance.new("ScreenGui")
			ScreenGui.Name = "CenzDonateAdminPanel"
			ScreenGui.DisplayOrder = 1500
			ScreenGui.Enabled = false
			ScreenGui.ResetOnSpawn = false
			ScreenGui.IgnoreGuiInset = true
			ScreenGui.Parent = nil

			local Frame2 = Instance.new("Frame")

			Frame2.Name = "Dim"
			Frame2.Size = UDim2.fromScale(1, 1)
			Frame2.BackgroundColor3 = Color3.new(0, 0, 0)
			Frame2.BackgroundTransparency = 0.4
			Frame2.Parent = ScreenGui
			Frame = Instance.new("Frame")
			Frame.Name = "MainFrame"
			Frame.AnchorPoint = Vector2.new(0.5, 0.5)
			Frame.Position = UDim2.fromScale(0.5, 0.5)
			Frame.Size = v204 and UDim2.fromScale(0.6, 0.65) or UDim2.fromScale(0.55, 0.6)
			Frame.BackgroundColor3 = Color3.fromRGB(8, 8, 14)
			Frame.BackgroundTransparency = 0.1
			Frame.ClipsDescendants = true
			Frame.Parent = ScreenGui
			Instance.new("UICorner", Frame).CornerRadius = UDim.new(0.03, 0)

			local UIStroke = Instance.new("UIStroke")

			UIStroke.Thickness = 2
			UIStroke.Transparency = 0.1
			UIStroke.Color = UIAccentColor
			UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
			UIStroke.Parent = Frame
			createUIGradient(UIStroke)

			local UIGradient = Instance.new("UIGradient")

			UIGradient.Rotation = 90
			UIGradient.Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, Color3.fromRGB(8, 8, 14)),
				ColorSequenceKeypoint.new(0.5, Color3.fromRGB(16, 10, 28)),
				ColorSequenceKeypoint.new(1, Color3.fromRGB(8, 8, 14))
			})
			UIGradient.Parent = Frame

			local TextButton = Instance.new("TextButton")

			TextButton.Name = "CloseBtn"
			TextButton.Size = UDim2.fromScale(0.03, 0.055)
			TextButton.Position = UDim2.fromScale(0.975, 0.08)
			TextButton.AnchorPoint = Vector2.new(1, 0.5)
			TextButton.BackgroundColor3 = Color3.fromRGB(60, 30, 80)
			TextButton.BackgroundTransparency = 0.3
			TextButton.Text = "X"
			TextButton.TextScaled = true
			TextButton.Font = Enum.Font.GothamBlack
			TextButton.TextColor3 = Color3.fromRGB(255, 255, 255)
			TextButton.ZIndex = 10
			TextButton.Parent = Frame
			Instance.new("UICorner", TextButton).CornerRadius = UDim.new(0.2, 0)
			TextButton.MouseButton1Click:Connect(function()
				if u170 then
					_G.CenzRobuxAdminToggle()
				end
			end)

			local Frame3 = Instance.new("Frame")

			Frame3.Name = "LeftPanel"
			Frame3.Size = UDim2.fromScale(0.3, 0.94)
			Frame3.BackgroundTransparency = 1
			Frame3.Position = UDim2.fromScale(0.025, 0.03)
			Frame3.Parent = Frame

			local Frame4 = Instance.new("Frame")

			Frame4.Size = UDim2.fromScale(1, 0.1)
			Frame4.BackgroundTransparency = 1
			Frame4.Parent = Frame3

			local TextLabel5 = Instance.new("TextLabel")

			TextLabel5.Size = UDim2.fromScale(1, 1)
			TextLabel5.BackgroundTransparency = 1
			TextLabel5.Text = "CENZ STUDIO"
			TextLabel5.TextScaled = true
			TextLabel5.Font = Enum.Font.GothamBlack
			TextLabel5.TextXAlignment = Enum.TextXAlignment.Center
			TextLabel5.TextColor3 = Color3.fromRGB(255, 255, 255)
			TextLabel5.Parent = Frame4

			local UITextSizeConstraint = Instance.new("UITextSizeConstraint")

			UITextSizeConstraint.MinTextSize = 10
			UITextSizeConstraint.MaxTextSize = 40
			UITextSizeConstraint.Parent = TextLabel5

			local UIGradient2 = Instance.new("UIGradient")

			UIGradient2.Color = colorSequence
			UIGradient2.Rotation = 90
			UIGradient2.Parent = TextLabel5

			local TweenService3 = game:GetService("TweenService")

			UIGradient2.Offset = Vector2.new(0, 0.3)
			TweenService3:Create(UIGradient2, TweenInfo.new(1.5, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1, true), {
				Offset = Vector2.new(0, -0.3)
			}):Play()

			local Frame5 = Instance.new("Frame")

			Frame5.Size = UDim2.fromScale(1, 0.003)
			Frame5.Position = UDim2.fromScale(0, 0.11)
			Frame5.BackgroundColor3 = UIAccentColor
			createUIGradient(Frame5)
			Frame5.BorderSizePixel = 0
			Frame5.Parent = Frame3

			local TextLabel6 = Instance.new("TextLabel")

			TextLabel6.Size = UDim2.fromScale(1, 0.045)
			TextLabel6.Position = UDim2.fromScale(0, 0.13)
			TextLabel6.BackgroundTransparency = 1
			TextLabel6.Text = "SEARCH PLAYER"
			TextLabel6.TextScaled = true
			TextLabel6.Font = Enum.Font.GothamBold
			TextLabel6.TextColor3 = Color3.fromRGB(160, 150, 190)
			TextLabel6.TextXAlignment = Enum.TextXAlignment.Left
			TextLabel6.Parent = Frame3
			Instance.new("UITextSizeConstraint", TextLabel6).MaxTextSize = 11

			local Frame6 = Instance.new("Frame")

			Frame6.Size = UDim2.fromScale(1, 0.075)
			Frame6.Position = UDim2.fromScale(0, 0.18)
			Frame6.BackgroundColor3 = Color3.fromRGB(14, 14, 26)
			Frame6.BackgroundTransparency = 0.2
			Frame6.Parent = Frame3
			Instance.new("UICorner", Frame6).CornerRadius = UDim.new(0.15, 0)

			local UIStroke2 = Instance.new("UIStroke")

			UIStroke2.Color = UIAccentColor
			UIStroke2.Thickness = 1
			UIStroke2.Transparency = 0.3
			UIStroke2.Parent = Frame6
			createUIGradient(UIStroke2)

			local UIPadding = Instance.new("UIPadding")

			UIPadding.PaddingLeft = UDim.new(0.04, 0)
			UIPadding.PaddingRight = UDim.new(0.04, 0)
			UIPadding.Parent = Frame6
			TextBox = Instance.new("TextBox")
			TextBox.Size = UDim2.fromScale(1, 1)
			TextBox.BackgroundTransparency = 1
			TextBox.PlaceholderText = "Type player name.."
			TextBox.Text = ""
			TextBox.TextScaled = true
			TextBox.Font = Enum.Font.Gotham
			TextBox.TextColor3 = Color3.fromRGB(240, 240, 255)
			TextBox.PlaceholderColor3 = Color3.fromRGB(100, 90, 130)
			TextBox.TextXAlignment = Enum.TextXAlignment.Left
			TextBox.ClearTextOnFocus = false
			TextBox.Parent = Frame6
			Instance.new("UITextSizeConstraint", TextBox).MaxTextSize = 13

			local TextLabel7 = Instance.new("TextLabel")

			TextLabel7.Size = UDim2.fromScale(1, 0.045)
			TextLabel7.Position = UDim2.fromScale(0, 0.27)
			TextLabel7.BackgroundTransparency = 1
			TextLabel7.Text = "PLAYERS"
			TextLabel7.TextScaled = true
			TextLabel7.Font = Enum.Font.GothamBold
			TextLabel7.TextColor3 = Color3.fromRGB(160, 150, 190)
			TextLabel7.TextXAlignment = Enum.TextXAlignment.Left
			TextLabel7.Parent = Frame3
			Instance.new("UITextSizeConstraint", TextLabel7).MaxTextSize = 11

			local Frame7 = Instance.new("Frame")

			Frame7.Size = UDim2.fromScale(1, 0.66)
			Frame7.Position = UDim2.fromScale(0, 0.325)
			Frame7.BackgroundColor3 = Color3.fromRGB(14, 14, 26)
			Frame7.BackgroundTransparency = 0.3
			Frame7.ClipsDescendants = true
			Frame7.Parent = Frame3
			Instance.new("UICorner", Frame7).CornerRadius = UDim.new(0.02, 0)

			local UIStroke3 = Instance.new("UIStroke")

			UIStroke3.Color = UIAccentColor
			UIStroke3.Thickness = 1
			UIStroke3.Transparency = 0.3
			UIStroke3.Parent = Frame7
			createUIGradient(UIStroke3)
			ScrollingFrame = Instance.new("ScrollingFrame")
			ScrollingFrame.Size = UDim2.fromScale(1, 1)
			ScrollingFrame.Position = UDim2.fromScale(0, 0)
			ScrollingFrame.BackgroundTransparency = 1
			ScrollingFrame.ScrollBarThickness = 3
			ScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
			ScrollingFrame.ScrollBarImageColor3 = UIAccentColor
			ScrollingFrame.CanvasSize = UDim2.fromScale(0, 0)
			ScrollingFrame.BorderSizePixel = 0
			ScrollingFrame.Parent = Frame7

			local UIPadding2 = Instance.new("UIPadding")

			UIPadding2.PaddingTop = UDim.new(0.02, 0)
			UIPadding2.PaddingBottom = UDim.new(0.02, 0)
			UIPadding2.PaddingLeft = UDim.new(0.03, 0)
			UIPadding2.PaddingRight = UDim.new(0.03, 0)
			UIPadding2.Parent = ScrollingFrame

			local UIListLayout = Instance.new("UIListLayout")

			UIListLayout.Padding = UDim.new(0.015, 0)
			UIListLayout.Parent = ScrollingFrame

			local Frame8 = Instance.new("Frame")

			Frame8.Size = UDim2.fromScale(0.002, 0.94)
			Frame8.Position = UDim2.fromScale(0.3425, 0.03)
			Frame8.BackgroundColor3 = UIAccentColor
			Frame8.BackgroundTransparency = 0.3
			createUIGradient(Frame8, 90)
			Frame8.BorderSizePixel = 0
			Frame8.Parent = Frame

			local Frame9 = Instance.new("Frame")

			Frame9.Name = "RightPanel"
			Frame9.Size = UDim2.fromScale(0.613, 0.94)
			Frame9.Position = UDim2.fromScale(0.362, 0.03)
			Frame9.BackgroundTransparency = 1
			Frame9.Parent = Frame

			local TextLabel8 = Instance.new("TextLabel")

			TextLabel8.Size = UDim2.fromScale(1, 0.1)
			TextLabel8.BackgroundTransparency = 1
			TextLabel8.Text = "DONATE ROBUX PANEL"
			TextLabel8.TextScaled = true
			TextLabel8.Font = Enum.Font.GothamBlack
			TextLabel8.TextXAlignment = Enum.TextXAlignment.Center
			TextLabel8.TextColor3 = Color3.fromRGB(255, 255, 255)
			TextLabel8.Parent = Frame9
			createUIGradient2(TextLabel8)

			local UITextSizeConstraint2 = Instance.new("UITextSizeConstraint")

			UITextSizeConstraint2.MinTextSize = 10
			UITextSizeConstraint2.MaxTextSize = 40
			UITextSizeConstraint2.Parent = TextLabel8

			local Frame10 = Instance.new("Frame")

			Frame10.Size = UDim2.fromScale(1, 0.003)
			Frame10.Position = UDim2.fromScale(0, 0.11)
			Frame10.BackgroundColor3 = UIAccentColor
			createUIGradient(Frame10)
			Frame10.BorderSizePixel = 0
			Frame10.Parent = Frame9

			local Frame11 = Instance.new("Frame")

			Frame11.Size = UDim2.fromScale(1, 0.17)
			Frame11.Position = UDim2.fromScale(0, 0.135)
			Frame11.BackgroundColor3 = Color3.fromRGB(14, 14, 26)
			Frame11.BackgroundTransparency = 0.2
			Frame11.Parent = Frame9
			Instance.new("UICorner", Frame11).CornerRadius = UDim.new(0.08, 0)

			local UIStroke4 = Instance.new("UIStroke")

			UIStroke4.Color = UIAccentColor
			UIStroke4.Thickness = 1
			UIStroke4.Transparency = 0.3
			UIStroke4.Parent = Frame11
			createUIGradient(UIStroke4)
			ImageLabel = Instance.new("ImageLabel")
			ImageLabel.Size = UDim2.fromScale(0.14, 0.8)
			ImageLabel.Position = UDim2.fromScale(0.03, 0.5)
			ImageLabel.AnchorPoint = Vector2.new(0, 0.5)
			ImageLabel.BackgroundColor3 = Color3.fromRGB(30, 28, 38)
			ImageLabel.BorderSizePixel = 0
			ImageLabel.Parent = Frame11
			Instance.new("UICorner", ImageLabel).CornerRadius = UDim.new(1, 0)

			local UIStroke5 = Instance.new("UIStroke")

			UIStroke5.Color = UIAccentColor
			UIStroke5.Thickness = 1.5
			UIStroke5.Transparency = 0.4
			UIStroke5.Parent = ImageLabel
			createUIGradient(UIStroke5)
			Instance.new("UIAspectRatioConstraint", ImageLabel).AspectRatio = 1
			TextLabel2 = Instance.new("TextLabel")
			TextLabel2.Size = UDim2.fromScale(0.4, 0.36)
			TextLabel2.Position = UDim2.fromScale(0.2, 0.14)
			TextLabel2.BackgroundTransparency = 1
			TextLabel2.Text = "No Player Selected"
			TextLabel2.TextScaled = true
			TextLabel2.Font = Enum.Font.GothamBold
			TextLabel2.TextColor3 = Color3.fromRGB(255, 255, 255)
			TextLabel2.TextXAlignment = Enum.TextXAlignment.Left
			TextLabel2.TextYAlignment = Enum.TextYAlignment.Bottom
			TextLabel2.TextTruncate = Enum.TextTruncate.AtEnd
			TextLabel2.Parent = Frame11
			Instance.new("UITextSizeConstraint", TextLabel2).MaxTextSize = 18
			TextLabel3 = Instance.new("TextLabel")
			TextLabel3.Size = UDim2.fromScale(0.4, 0.32)
			TextLabel3.Position = UDim2.fromScale(0.2, 0.5)
			TextLabel3.BackgroundTransparency = 1
			TextLabel3.Text = ""
			TextLabel3.TextScaled = true
			TextLabel3.Font = Enum.Font.GothamSemibold
			TextLabel3.TextColor3 = Color3.fromRGB(160, 150, 190)
			TextLabel3.TextXAlignment = Enum.TextXAlignment.Left
			TextLabel3.TextYAlignment = Enum.TextYAlignment.Top
			TextLabel3.Parent = Frame11
			Instance.new("UITextSizeConstraint", TextLabel3).MaxTextSize = 14

			local Frame12 = Instance.new("Frame")

			Frame12.Size = UDim2.fromScale(0.003, 0.65)
			Frame12.Position = UDim2.fromScale(0.62, 0.15)
			Frame12.BackgroundColor3 = UIAccentColor
			Frame12.BackgroundTransparency = 0.5
			createUIGradient(Frame12, 90)
			Frame12.BorderSizePixel = 0
			Frame12.Parent = Frame11

			local TextLabel9 = Instance.new("TextLabel")

			TextLabel9.Size = UDim2.fromScale(0.34, 0.32)
			TextLabel9.Position = UDim2.fromScale(0.65, 0.14)
			TextLabel9.BackgroundTransparency = 1
			TextLabel9.Text = "Total Donated:"
			TextLabel9.TextScaled = true
			TextLabel9.Font = Enum.Font.GothamSemibold
			TextLabel9.TextColor3 = Color3.fromRGB(160, 150, 190)
			TextLabel9.TextXAlignment = Enum.TextXAlignment.Left
			TextLabel9.TextYAlignment = Enum.TextYAlignment.Bottom
			TextLabel9.Parent = Frame11
			Instance.new("UITextSizeConstraint", TextLabel9).MaxTextSize = 13
			TextLabel4 = Instance.new("TextLabel")
			TextLabel4.Size = UDim2.fromScale(0.34, 0.38)
			TextLabel4.Position = UDim2.fromScale(0.65, 0.48)
			TextLabel4.BackgroundTransparency = 1
			TextLabel4.Text = "—"
			TextLabel4.TextScaled = true
			TextLabel4.Font = Enum.Font.GothamBlack
			TextLabel4.TextColor3 = Color3.fromRGB(0, 255, 220)
			TextLabel4.TextXAlignment = Enum.TextXAlignment.Left
			TextLabel4.TextYAlignment = Enum.TextYAlignment.Top
			TextLabel4.Parent = Frame11
			Instance.new("UITextSizeConstraint", TextLabel4).MaxTextSize = 20

			local ScrollingFrame2 = Instance.new("ScrollingFrame")

			ScrollingFrame2.Size = UDim2.fromScale(1, 0.66)
			ScrollingFrame2.Position = UDim2.fromScale(0, 0.325)
			ScrollingFrame2.BackgroundColor3 = Color3.fromRGB(14, 14, 26)
			ScrollingFrame2.BackgroundTransparency = 0.3
			ScrollingFrame2.ScrollBarThickness = 3
			ScrollingFrame2.ScrollBarImageColor3 = UIAccentColor
			ScrollingFrame2.AutomaticCanvasSize = Enum.AutomaticSize.Y
			ScrollingFrame2.CanvasSize = UDim2.fromScale(0, 0)
			ScrollingFrame2.BorderSizePixel = 0
			ScrollingFrame2.Parent = Frame9
			Instance.new("UICorner", ScrollingFrame2).CornerRadius = UDim.new(0.02, 0)

			local UIStroke6 = Instance.new("UIStroke")

			UIStroke6.Color = UIAccentColor
			UIStroke6.Thickness = 1
			UIStroke6.Transparency = 0.3
			UIStroke6.Parent = ScrollingFrame2
			createUIGradient(UIStroke6)

			local UIListLayout2 = Instance.new("UIListLayout")

			UIListLayout2.Padding = UDim.new(0.018, 0)
			UIListLayout2.SortOrder = Enum.SortOrder.LayoutOrder
			UIListLayout2.HorizontalAlignment = Enum.HorizontalAlignment.Center
			UIListLayout2.Parent = ScrollingFrame2

			local UIPadding3 = Instance.new("UIPadding")

			UIPadding3.PaddingTop = UDim.new(0.025, 0)
			UIPadding3.PaddingBottom = UDim.new(0.025, 0)
			UIPadding3.PaddingLeft = UDim.new(0.025, 0)
			UIPadding3.PaddingRight = UDim.new(0.025, 0)
			UIPadding3.Parent = ScrollingFrame2

			local TextLabel10 = Instance.new("TextLabel")

			TextLabel10.Size = UDim2.fromScale(1, 0.04)
			TextLabel10.BackgroundTransparency = 1
			TextLabel10.Text = "Message"
			TextLabel10.TextScaled = true
			TextLabel10.Font = Enum.Font.GothamBold
			TextLabel10.TextColor3 = Color3.fromRGB(220, 215, 240)
			TextLabel10.TextXAlignment = Enum.TextXAlignment.Left
			TextLabel10.LayoutOrder = 2
			TextLabel10.Parent = ScrollingFrame2
			Instance.new("UITextSizeConstraint", TextLabel10).MaxTextSize = 12

			local Frame13 = Instance.new("Frame")

			Frame13.Size = UDim2.fromScale(1, 0.28)
			Frame13.BackgroundColor3 = Color3.fromRGB(42, 38, 55)
			Frame13.LayoutOrder = 3
			Frame13.Parent = ScrollingFrame2
			Instance.new("UICorner", Frame13).CornerRadius = UDim.new(0.08, 0)

			local UIPadding4 = Instance.new("UIPadding")

			UIPadding4.PaddingLeft = UDim.new(0.03, 0)
			UIPadding4.PaddingRight = UDim.new(0.03, 0)
			UIPadding4.PaddingTop = UDim.new(0.08, 0)
			UIPadding4.PaddingBottom = UDim.new(0.08, 0)
			UIPadding4.Parent = Frame13
			TextBox2 = Instance.new("TextBox")
			TextBox2.Size = UDim2.fromScale(1, 1)
			TextBox2.BackgroundTransparency = 1
			TextBox2.PlaceholderText = "Write a donation message..."
			TextBox2.Text = ""
			TextBox2.TextScaled = true
			TextBox2.Font = Enum.Font.Gotham
			TextBox2.TextColor3 = Color3.fromRGB(240, 240, 255)
			TextBox2.PlaceholderColor3 = Color3.fromRGB(100, 90, 130)
			TextBox2.TextXAlignment = Enum.TextXAlignment.Left
			TextBox2.TextYAlignment = Enum.TextYAlignment.Top
			TextBox2.TextWrapped = true
			TextBox2.MultiLine = true
			TextBox2.ClearTextOnFocus = false
			TextBox2.Parent = Frame13

			local UITextSizeConstraint3 = Instance.new("UITextSizeConstraint")

			UITextSizeConstraint3.MinTextSize = 8
			UITextSizeConstraint3.MaxTextSize = 14
			UITextSizeConstraint3.Parent = TextBox2

			local TextLabel11 = Instance.new("TextLabel")

			TextLabel11.Size = UDim2.fromScale(1, 0.04)
			TextLabel11.BackgroundTransparency = 1
			TextLabel11.Text = "Donation Amount"
			TextLabel11.TextScaled = true
			TextLabel11.Font = Enum.Font.GothamBold
			TextLabel11.TextColor3 = Color3.fromRGB(220, 215, 240)
			TextLabel11.TextXAlignment = Enum.TextXAlignment.Left
			TextLabel11.TextWrapped = true
			TextLabel11.LayoutOrder = 4
			TextLabel11.Parent = ScrollingFrame2
			Instance.new("UITextSizeConstraint", TextLabel11).MaxTextSize = 11

			local Frame14 = Instance.new("Frame")

			Frame14.Size = UDim2.fromScale(1, 0.12)
			Frame14.BackgroundColor3 = Color3.fromRGB(42, 38, 55)
			Frame14.LayoutOrder = 5
			Frame14.Parent = ScrollingFrame2
			Instance.new("UICorner", Frame14).CornerRadius = UDim.new(0.12, 0)

			local UIPadding5 = Instance.new("UIPadding")

			UIPadding5.PaddingLeft = UDim.new(0.03, 0)
			UIPadding5.PaddingRight = UDim.new(0.03, 0)
			UIPadding5.Parent = Frame14
			TextBox3 = Instance.new("TextBox")
			TextBox3.Size = UDim2.fromScale(1, 1)
			TextBox3.BackgroundTransparency = 1
			TextBox3.PlaceholderText = "Enter amount (numbers only)..."
			TextBox3.Text = ""
			TextBox3.TextScaled = true
			TextBox3.Font = Enum.Font.Gotham
			TextBox3.TextColor3 = Color3.fromRGB(240, 240, 255)
			TextBox3.PlaceholderColor3 = Color3.fromRGB(100, 90, 130)
			TextBox3.TextXAlignment = Enum.TextXAlignment.Left
			TextBox3.ClearTextOnFocus = false
			TextBox3.Parent = Frame14

			local UITextSizeConstraint4 = Instance.new("UITextSizeConstraint")

			UITextSizeConstraint4.MinTextSize = 8
			UITextSizeConstraint4.MaxTextSize = 13
			UITextSizeConstraint4.Parent = TextBox3

			local TextLabel12 = Instance.new("TextLabel")

			TextLabel12.Size = UDim2.fromScale(1, 0.04)
			TextLabel12.BackgroundTransparency = 1
			TextLabel12.Text = "Quick Amount"
			TextLabel12.TextScaled = true
			TextLabel12.Font = Enum.Font.GothamBold
			TextLabel12.TextColor3 = Color3.fromRGB(160, 150, 190)
			TextLabel12.TextXAlignment = Enum.TextXAlignment.Left
			TextLabel12.LayoutOrder = 6
			TextLabel12.Parent = ScrollingFrame2
			Instance.new("UITextSizeConstraint", TextLabel12).MaxTextSize = 11

			local Frame15 = Instance.new("Frame")

			Frame15.Size = UDim2.fromScale(1, 0.11)
			Frame15.BackgroundTransparency = 1
			Frame15.LayoutOrder = 7
			Frame15.Parent = ScrollingFrame2

			local UIListLayout3 = Instance.new("UIListLayout")

			UIListLayout3.FillDirection = Enum.FillDirection.Horizontal
			UIListLayout3.Padding = UDim.new(0.015, 0)
			UIListLayout3.VerticalAlignment = Enum.VerticalAlignment.Center
			UIListLayout3.Parent = Frame15

			local AdminQuickAmounts = v139.AdminQuickAmounts or {
				100,
				500,
				1000,
				5000,
				10000
			}

			for i, AdminQuickAmount in ipairs(AdminQuickAmounts) do
				local TextButton2 = Instance.new("TextButton")

				TextButton2.Size = UDim2.new(0.15, 0, 1, 0)
				TextButton2.BackgroundColor3 = Color3.fromRGB(42, 38, 55)
				TextButton2.Text = v165(AdminQuickAmount)
				TextButton2.TextScaled = true
				TextButton2.Font = Enum.Font.GothamBold
				TextButton2.TextColor3 = Color3.fromRGB(220, 215, 240)
				TextButton2.AutoButtonColor = false
				TextButton2.LayoutOrder = i
				TextButton2.Parent = Frame15
				Instance.new("UITextSizeConstraint", TextButton2).MaxTextSize = 12
				Instance.new("UICorner", TextButton2).CornerRadius = UDim.new(0.15, 0)

				local UIStroke7 = Instance.new("UIStroke")

				UIStroke7.Color = UIAccentColor
				UIStroke7.Thickness = 1
				UIStroke7.Transparency = 0.4
				UIStroke7.Parent = TextButton2
				createUIGradient(UIStroke7)
				TextButton2.MouseEnter:Connect(function()
					TweenService2:Create(TextButton2, TweenInfo.new(0.1), {
						BackgroundColor3 = Color3.fromRGB(75, 55, 100)
					}):Play()
					TweenService2:Create(UIStroke7, TweenInfo.new(0.1), {
						Transparency = 0.1
					}):Play()
				end)
				TextButton2.MouseLeave:Connect(function()
					TweenService2:Create(TextButton2, TweenInfo.new(0.1), {
						BackgroundColor3 = Color3.fromRGB(42, 38, 55)
					}):Play()
					TweenService2:Create(UIStroke7, TweenInfo.new(0.1), {
						Transparency = 0.4
					}):Play()
				end)
				TextButton2.MouseButton1Click:Connect(function()
					if TextBox3 then
						TextBox3.Text = tostring(AdminQuickAmount)
					end
				end)
			end

			local Frame16 = Instance.new("Frame")

			Frame16.Size = UDim2.fromScale(1, 0.14)
			Frame16.BackgroundTransparency = 1
			Frame16.LayoutOrder = 10
			Frame16.Parent = ScrollingFrame2

			local Frame17 = Instance.new("Frame")

			Frame17.Size = UDim2.fromScale(1, 0.02)
			Frame17.BackgroundTransparency = 1
			Frame17.LayoutOrder = 9
			Frame17.Parent = ScrollingFrame2

			local UIListLayout4 = Instance.new("UIListLayout")

			UIListLayout4.FillDirection = Enum.FillDirection.Horizontal
			UIListLayout4.Padding = UDim.new(0.02, 0)
			UIListLayout4.VerticalAlignment = Enum.VerticalAlignment.Center
			UIListLayout4.Parent = Frame16

			local TextButton2 = Instance.new("TextButton")

			TextButton2.Size = UDim2.fromScale(0.28, 1)
			TextButton2.BackgroundColor3 = UIAccentColor
			TextButton2.Text = "Send"
			TextButton2.TextScaled = true
			TextButton2.Font = Enum.Font.GothamBold
			TextButton2.TextColor3 = Color3.fromRGB(255, 255, 255)
			TextButton2.AutoButtonColor = false
			TextButton2.Parent = Frame16
			Instance.new("UITextSizeConstraint", TextButton2).MaxTextSize = 14
			Instance.new("UICorner", TextButton2).CornerRadius = UDim.new(0.15, 0)

			local UIStroke7 = Instance.new("UIStroke")

			UIStroke7.Thickness = 2
			UIStroke7.Transparency = 0.3
			UIStroke7.Color = v143
			UIStroke7.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
			UIStroke7.Parent = TextButton2
			createUIGradient(UIStroke7)
			TextButton2.MouseEnter:Connect(function()
				local t10 = {
					BackgroundColor3 = v143
				}

				TweenService2:Create(TextButton2, TweenInfo.new(0.1), t10):Play()
			end)
			TextButton2.MouseLeave:Connect(function()
				local t11 = {
					BackgroundColor3 = UIAccentColor
				}

				TweenService2:Create(TextButton2, TweenInfo.new(0.1), t11):Play()
			end)

			local TextButton3 = Instance.new("TextButton")

			TextButton3.Size = UDim2.fromScale(0.28, 1)
			TextButton3.BackgroundColor3 = Color3.fromRGB(180, 30, 30)
			TextButton3.Text = "Reset"
			TextButton3.TextScaled = true
			TextButton3.Font = Enum.Font.GothamBold
			TextButton3.TextColor3 = Color3.fromRGB(255, 255, 255)
			TextButton3.AutoButtonColor = false
			TextButton3.Parent = Frame16
			Instance.new("UITextSizeConstraint", TextButton3).MaxTextSize = 14
			Instance.new("UICorner", TextButton3).CornerRadius = UDim.new(0.15, 0)

			local UIStroke8 = Instance.new("UIStroke")

			UIStroke8.Thickness = 2
			UIStroke8.Transparency = 0.3
			UIStroke8.Color = Color3.fromRGB(255, 80, 80)
			UIStroke8.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
			UIStroke8.Parent = TextButton3
			TextButton3.MouseEnter:Connect(function()
				TweenService2:Create(TextButton3, TweenInfo.new(0.1), {
					BackgroundColor3 = Color3.fromRGB(210, 50, 50)
				}):Play()
			end)
			TextButton3.MouseLeave:Connect(function()
				TweenService2:Create(TextButton3, TweenInfo.new(0.1), {
					BackgroundColor3 = Color3.fromRGB(180, 30, 30)
				}):Play()
			end)
			TextLabel = Instance.new("TextLabel")
			TextLabel.Size = UDim2.fromScale(0.4, 1)
			TextLabel.BackgroundTransparency = 1
			TextLabel.Text = ""
			TextLabel.TextScaled = true
			TextLabel.Font = Enum.Font.GothamBold
			TextLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
			TextLabel.TextXAlignment = Enum.TextXAlignment.Left
			Instance.new("UITextSizeConstraint", TextLabel).MaxTextSize = 12
			TextLabel.TextYAlignment = Enum.TextYAlignment.Center
			TextLabel.Parent = Frame16
			TextButton2.MouseButton1Click:Connect(function()
				if not u181 then
					v185("Select a player first!", Color3.fromRGB(255, 50, 50))

					return
				end

				local userId = u181.userId
				local Text = TextBox2 and TextBox2.Text or ""
				local v266 = tonumber(TextBox3 and TextBox3.Text or "")

				if v266 then
					if not (v266 <= 0) then
						v185("Sending...", Color3.fromRGB(255, 200, 50))

						local ok, result = pcall(function()
							local v269 = CenzRobuxAdminCommand
							local InvokeServer = CenzRobuxAdminCommand.InvokeServer
							local s1 = "adminAnnounce"

							return InvokeServer(v269, s1, {
								userId = userId,
								message = Text,
								amount = v266 or 0
							})
						end)

						if ok and result and result.success then
							v185("Sent!", Color3.fromRGB(0, 255, 100))

							if TextBox2 then
								TextBox2.Text = ""
							end

							if TextBox3 then
								TextBox3.Text = ""
							end

							v182()
						else
							v185("Failed to send", Color3.fromRGB(255, 50, 50))
						end

						return
					end
				end

				v185("Donation amount is required (numbers only)!", Color3.fromRGB(255, 50, 50))
			end)
			TextButton3.MouseButton1Click:Connect(function()
				if not u181 then
					v185("Select a player first!", Color3.fromRGB(255, 50, 50))

					return
				end

				local userId = u181.userId

				v185("Resetting " .. (u181.displayName or u181.username or "Unknown") .. "...", Color3.fromRGB(255, 200, 50))

				local ok, result = pcall(function()
					return CenzRobuxAdminCommand:InvokeServer("resetDonor", {
						userId = userId
					})
				end)

				if ok and result and result.success then
					v185("Reset done!", Color3.fromRGB(0, 255, 100))
					v182()
				else
					v185("Failed to reset", Color3.fromRGB(255, 50, 50))
				end
			end)
		end

		local u275 = false

		v182 = function()
			if u275 then
				return
			end

			u275 = true
			task.spawn(function()
				local t12 = {}
				local ok, result = pcall(function()
					return CenzRobuxAdminCommand:InvokeServer("getTopDonors", {
						limit = 100
					})
				end)

				if ok and result and result.success then
					if result.data then
						for _, v in ipairs(result.data) do
							t12[v.userId] = v.total
						end
					end
				end

				for _, v in pairs(t9) do
					if v and v.Parent then
						v:Destroy()
					end
				end

				t9 = {}

				local v283 = TextBox and string.lower(TextBox.Text) or ""

				for _, player in ipairs(Players:GetPlayers()) do
					if v283 == "" or string.find(string.lower(player.Name), v283, 1, true) or string.find(string.lower(player.DisplayName), v283, 1, true) then
						local v286 = t12[player.UserId] or 0

						if v286 == 0 then
							local ok2, result2 = pcall(function()
								return CenzRobuxAdminCommand:InvokeServer("getPlayerTotal", {
									userId = player.UserId
								})
							end)

							if ok2 and result2 and result2.success then
								v286 = result2.total or 0
							end
						end

						table.insert(t9, createFrame({
							userId = player.UserId,
							username = player.Name,
							displayName = player.DisplayName,
							total = v286
						}))
					end
				end

				if u181 then
					v186()
				end

				u275 = false
			end)
		end

		local function v289()
			if not ScreenGui then
				v203()
			end

			local uDim2 = v163() and UDim2.fromScale(0.6, 0.65) or UDim2.fromScale(0.55, 0.6)

			ScreenGui.Parent = PlayerGui
			ScreenGui.Enabled = true
			Frame.Size = UDim2.fromScale(uDim2.X.Scale, 0)
			Frame.BackgroundTransparency = 1

			local UIStroke = Frame:FindFirstChildOfClass("UIStroke")

			if UIStroke then
				UIStroke.Transparency = 1
			end

			TweenService2:Create(Frame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
				Size = uDim2,
				BackgroundTransparency = 0.1
			}):Play()

			if UIStroke then
				TweenService2:Create(UIStroke, TweenInfo.new(0.3), {
					Transparency = 0.1
				}):Play()
			end

			local Dim = ScreenGui:FindFirstChild("Dim")

			if Dim then
				Dim.BackgroundTransparency = 1
				TweenService2:Create(Dim, TweenInfo.new(0.2), {
					BackgroundTransparency = 0.4
				}):Play()
			end

			if _G.CenzDonateRobuxClose then
				_G.CenzDonateRobuxClose()
			end

			local PlayerGui2 = LocalPlayer:FindFirstChild("PlayerGui")

			if PlayerGui2 then
				local DonorMessageModal = PlayerGui2:FindFirstChild("DonorMessageModal")

				if DonorMessageModal then
					DonorMessageModal:Destroy()
				end
			end

			u170 = true
			v182()
		end
		local function v295()
			local v296 = v163() and 0.6 or 0.55
			local Dim = ScreenGui and ScreenGui:FindFirstChild("Dim")

			if Dim then
				TweenService2:Create(Dim, TweenInfo.new(0.2), {
					BackgroundTransparency = 1
				}):Play()
			end

			local UIStroke = Frame and Frame:FindFirstChildOfClass("UIStroke")

			TweenService2:Create(Frame, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
				Size = UDim2.fromScale(v296, 0),
				BackgroundTransparency = 1
			}):Play()

			if UIStroke then
				TweenService2:Create(UIStroke, TweenInfo.new(0.25), {
					Transparency = 1
				}):Play()
			end

			task.delay(0.3, function()
				if ScreenGui then
					ScreenGui.Enabled = false
					ScreenGui.Parent = nil
				end
			end)
			u170 = false
		end

		_G.CenzRobuxAdminToggle = function()
			if u170 then
				v295()
			else
				v289()
			end
		end
		_G.CenzRobuxAdminClose = function()
			if u170 then
				v295()
			end
		end
		task.spawn(function()
			while not TextBox do
				task.wait(0.1)
			end

			local thread

			TextBox:GetPropertyChangedSignal("Text"):Connect(function()
				if thread then
					task.cancel(thread)
				end

				thread = task.delay(0.3, function()
					thread = nil
					v182()
				end)
			end)
		end)
		CenzRobuxAdminNotify.OnClientEvent:Connect(function(p99, p100)
			pcall(function()
				StarterGui:SetCore("ChatMakeSystemMessage", {
					Text = "[ADMIN] " .. p99,
					Color = p100 or Color3.new(1, 1, 1)
				})
			end)
		end)
		v203()
		print("CENZ STUDIO DONATE ROBUX ADMIN CLIENT ACTIVE")
	end

	v138(script, v24)
end)
task.spawn(function()
	local function v300(p101, p102)
		local v301 = p102(game:GetService("ReplicatedStorage").CenzDonateRobuxRS.CenzDonateRobuxConfig)
		local TweenService = game:GetService("TweenService")
		local UIAccentColor = v301.UIAccentColor or Color3.fromRGB(255, 200, 80)

		local function v304(p103, p104, p105)
			return Color3.new(p103.R + (p104.R - p103.R) * p105, p103.G + (p104.G - p103.G) * p105, p103.B + (p104.B - p103.B) * p105)
		end

		local v305 = v304(UIAccentColor, Color3.fromRGB(255, 255, 255), 0.5)
		local colorSequence = ColorSequence.new({
			ColorSequenceKeypoint.new(0, UIAccentColor),
			ColorSequenceKeypoint.new(0.3, UIAccentColor),
			ColorSequenceKeypoint.new(0.43, v305),
			ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
			ColorSequenceKeypoint.new(0.57, v305),
			ColorSequenceKeypoint.new(0.7, UIAccentColor),
			ColorSequenceKeypoint.new(1, UIAccentColor)
		})

		local function createUIGradient(p106, p107)
			local rotation = p107 or 0

			if p106:IsA("UIStroke") then
				p106.Color = Color3.fromRGB(255, 255, 255)

				local UIGradient = Instance.new("UIGradient")

				UIGradient.Color = colorSequence
				UIGradient.Rotation = 0
				UIGradient.Parent = p106
				TweenService:Create(UIGradient, TweenInfo.new(3, Enum.EasingStyle.Linear, Enum.EasingDirection.In, -1, false), {
					Rotation = 360
				}):Play()

				return UIGradient
			end

			p106.BackgroundColor3 = Color3.fromRGB(255, 255, 255)

			local UIGradient = Instance.new("UIGradient")

			UIGradient.Color = colorSequence
			UIGradient.Rotation = rotation

			local vector2, vector22

			if rotation == 90 or rotation == 270 then
				vector2 = Vector2.new(0, -0.5)
				vector22 = Vector2.new(0, 0.5)
			else
				vector2 = Vector2.new(-0.5, 0)
				vector22 = Vector2.new(0.5, 0)
			end

			UIGradient.Offset = vector2
			UIGradient.Parent = p106
			TweenService:Create(UIGradient, TweenInfo.new(1.5, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1, true), {
				Offset = vector22
			}):Play()

			return UIGradient
		end
		local function createUIGradient2(p108)
			local UIGradient = Instance.new("UIGradient")

			UIGradient.Color = colorSequence
			UIGradient.Rotation = 90
			UIGradient.Offset = Vector2.new(0, 0.3)
			UIGradient.Parent = p108
			TweenService:Create(UIGradient, TweenInfo.new(1.5, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1, true), {
				Offset = Vector2.new(0, -0.3)
			}):Play()

			return UIGradient
		end

		local Players = game:GetService("Players")
		local MarketplaceService = game:GetService("MarketplaceService")
		local TweenService2 = game:GetService("TweenService")

		game:GetService("RunService")

		local LocalPlayer = Players.LocalPlayer
		local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
		local u320
		local u321
		local u322
		local u323
		local u324 = false

		local function v325()
			local UserInputService = game:GetService("UserInputService")

			return UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
		end
		local function v327(p109)
			if p109 then
				return tostring(math.floor(p109)):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")
			end

			return ""
		end
		local function v328(p110)
			local v329 = "Product " .. p110
			local PriceInRobux
			local ok, result = pcall(MarketplaceService.GetProductInfo, MarketplaceService, p110, Enum.InfoType.Product)

			if ok and type(result) == "table" then
				if typeof(result.Name) == "string" then
					v329 = result.Name
				end

				if typeof(result.PriceInRobux) == "number" then
					PriceInRobux = result.PriceInRobux
				end
			end

			return {
				id = p110,
				name = v329,
				price = PriceInRobux
			}
		end
		local function v333()
			local t13 = {}
			local DonateProductIds = v301.DonateProductIds or {}

			for _, DonateProductId in ipairs(DonateProductIds) do
				table.insert(t13, v328(DonateProductId))
			end

			table.sort(t13, function(p111, p112)
				local v338 = tonumber(p111.price or math.huge)
				local v339 = tonumber(p112.price or math.huge)

				if v338 == v339 then
					return p111.id < p112.id
				end

				return v338 < v339
			end)

			return t13
		end
		local function createBlurEffect()
			local BlurEffect = Instance.new("BlurEffect")

			BlurEffect.Name = "DonationBlur"
			BlurEffect.Size = 0
			BlurEffect.Enabled = false
			BlurEffect.Parent = game:GetService("Lighting")

			return BlurEffect
		end
		local function createScreenGui()
			local ScreenGui = Instance.new("ScreenGui")

			ScreenGui.Name = "DonationBoard"
			ScreenGui.ResetOnSpawn = false
			ScreenGui.IgnoreGuiInset = true
			ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
			ScreenGui.DisplayOrder = 100
			ScreenGui.Parent = nil

			return ScreenGui
		end
		local function createFrame(p113)
			local Frame = Instance.new("Frame")

			Frame.Name = "BackgroundFrame"
			Frame.Size = UDim2.fromScale(1, 1)
			Frame.BackgroundColor3 = Color3.new(0, 0, 0)
			Frame.BackgroundTransparency = 0.4
			Frame.BorderSizePixel = 0
			Frame.Visible = false
			Frame.ZIndex = 1
			Frame.Parent = p113

			return Frame
		end
		local function v346(p114)
			local v347 = v325()
			local Frame = Instance.new("Frame")

			Frame.Name = "MainFrame"
			Frame.Size = v347 and UDim2.fromScale(0.6, 0.65) or UDim2.fromScale(0.55, 0.6)
			Frame.Position = UDim2.fromScale(0.5, 0.5)
			Frame.AnchorPoint = Vector2.new(0.5, 0.5)
			Frame.BackgroundColor3 = Color3.fromRGB(8, 8, 14)
			Frame.BackgroundTransparency = 0.1
			Frame.BorderSizePixel = 0
			Frame.Visible = false
			Frame.ClipsDescendants = true
			Frame.ZIndex = 2
			Frame.Parent = p114

			local UICorner = Instance.new("UICorner")

			UICorner.CornerRadius = UDim.new(0.03, 0)
			UICorner.Parent = Frame

			local UIStroke = Instance.new("UIStroke")

			UIStroke.Thickness = 2
			UIStroke.Transparency = 0.1
			UIStroke.Color = UIAccentColor
			UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
			UIStroke.Parent = Frame
			createUIGradient(UIStroke)

			local UIGradient = Instance.new("UIGradient")

			UIGradient.Rotation = 90
			UIGradient.Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, Color3.fromRGB(8, 8, 14)),
				ColorSequenceKeypoint.new(0.5, Color3.fromRGB(16, 10, 28)),
				ColorSequenceKeypoint.new(1, Color3.fromRGB(8, 8, 14))
			})
			UIGradient.Parent = Frame

			local UIPadding = Instance.new("UIPadding")

			UIPadding.PaddingTop = UDim.new(0.02, 0)
			UIPadding.PaddingLeft = UDim.new(0.02, 0)
			UIPadding.PaddingRight = UDim.new(0.02, 0)
			UIPadding.PaddingBottom = UDim.new(0.02, 0)
			UIPadding.Parent = Frame

			local TextButton = Instance.new("TextButton")

			TextButton.Name = "CloseBtn"
			TextButton.Size = UDim2.fromScale(0.04, 0.06)
			TextButton.Position = UDim2.fromScale(0.99, 0.005)
			TextButton.AnchorPoint = Vector2.new(1, 0)
			TextButton.BackgroundColor3 = Color3.fromRGB(60, 30, 80)
			TextButton.BackgroundTransparency = 0.3
			TextButton.Text = "X"
			TextButton.TextScaled = true
			TextButton.Font = Enum.Font.GothamBlack
			TextButton.TextColor3 = Color3.fromRGB(255, 255, 255)
			TextButton.ZIndex = 10
			TextButton.Parent = Frame

			local UICorner2 = Instance.new("UICorner")

			UICorner2.CornerRadius = UDim.new(0.2, 0)
			UICorner2.Parent = TextButton
			TextButton.MouseButton1Click:Connect(function()
				if _G.CenzDonateRobuxToggle then
					_G.CenzDonateRobuxToggle()
				end
			end)

			local Frame2 = Instance.new("Frame")

			Frame2.Name = "LeftPanel"
			Frame2.Size = UDim2.fromScale(0.33, 1)
			Frame2.BackgroundTransparency = 1
			Frame2.Parent = Frame

			local Frame3 = Instance.new("Frame")

			Frame3.Size = UDim2.fromScale(1, 0.08)
			Frame3.BackgroundTransparency = 1
			Frame3.Parent = Frame2

			local UIListLayout = Instance.new("UIListLayout")

			UIListLayout.FillDirection = Enum.FillDirection.Horizontal
			UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
			UIListLayout.Padding = UDim.new(0.02, 0)
			UIListLayout.Parent = Frame3

			local TextLabel = Instance.new("TextLabel")

			TextLabel.Size = UDim2.fromScale(1, 1)
			TextLabel.BackgroundTransparency = 1
			TextLabel.Text = "DONATIONS"
			TextLabel.TextScaled = true
			TextLabel.Font = Enum.Font.GothamBlack
			TextLabel.TextXAlignment = Enum.TextXAlignment.Center
			TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
			TextLabel.Parent = Frame3

			local UITextSizeConstraint = Instance.new("UITextSizeConstraint")

			UITextSizeConstraint.MinTextSize = 14
			UITextSizeConstraint.MaxTextSize = 40
			UITextSizeConstraint.Parent = TextLabel

			local UIGradient2 = Instance.new("UIGradient")

			UIGradient2.Color = colorSequence
			UIGradient2.Rotation = 90
			UIGradient2.Parent = TextLabel

			local TweenService3 = game:GetService("TweenService")

			UIGradient2.Offset = Vector2.new(0, 0.3)
			TweenService3:Create(UIGradient2, TweenInfo.new(1.5, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1, true), {
				Offset = Vector2.new(0, -0.3)
			}):Play()

			local Frame4 = Instance.new("Frame")

			Frame4.Size = UDim2.new(1, 0, 0.006, 0)
			Frame4.Position = UDim2.fromScale(0, 0.09)
			Frame4.BackgroundColor3 = UIAccentColor
			createUIGradient(Frame4)
			Frame4.BorderSizePixel = 0
			Frame4.Parent = Frame2

			local Frame5 = Instance.new("Frame")

			Frame5.Size = UDim2.fromScale(0.5, 0.25)
			Frame5.AnchorPoint = Vector2.new(0.5, 0)
			Frame5.Position = UDim2.fromScale(0.5, 0.14)
			Frame5.BackgroundTransparency = 1
			Frame5.Parent = Frame2

			local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")

			UIAspectRatioConstraint.AspectRatio = 1
			UIAspectRatioConstraint.Parent = Frame5

			local ImageLabel = Instance.new("ImageLabel")

			ImageLabel.Size = UDim2.fromScale(1, 1)
			ImageLabel.BackgroundTransparency = 1
			ImageLabel.Image = v301.ShopRobuxLogo or "rbxassetid://11560341132"
			ImageLabel.ScaleType = Enum.ScaleType.Fit
			ImageLabel.Parent = Frame5

			local TextLabel2 = Instance.new("TextLabel")

			TextLabel2.Size = UDim2.fromScale(0.9, 0.1)
			TextLabel2.Position = UDim2.fromScale(0.05, 0.41)
			TextLabel2.BackgroundTransparency = 1
			TextLabel2.Text = v301.GameName or "DONATE"
			TextLabel2.TextScaled = true
			TextLabel2.Font = Enum.Font.GothamBlack
			TextLabel2.TextColor3 = Color3.fromRGB(255, 255, 255)
			TextLabel2.Parent = Frame2

			local TextLabel3 = Instance.new("TextLabel")

			TextLabel3.Size = UDim2.fromScale(0.9, 0.12)
			TextLabel3.Position = UDim2.fromScale(0.05, 0.52)
			TextLabel3.BackgroundTransparency = 1
			TextLabel3.Text = v301.ShopRobuxSubtitle or "Support us by donating Robux!"
			TextLabel3.TextScaled = true
			TextLabel3.Font = Enum.Font.GothamSemibold
			TextLabel3.TextColor3 = Color3.fromRGB(255, 255, 255)
			TextLabel3.Parent = Frame2
			Instance.new("UITextSizeConstraint", TextLabel3).MaxTextSize = 22

			local Frame6 = Instance.new("Frame")

			Frame6.Size = UDim2.fromScale(0.6, 0.005)
			Frame6.Position = UDim2.fromScale(0.2, 0.66)
			Frame6.BackgroundColor3 = UIAccentColor
			createUIGradient(Frame6)
			Frame6.BackgroundTransparency = 0.4
			Frame6.BorderSizePixel = 0
			Frame6.Parent = Frame2

			local TextLabel4 = Instance.new("TextLabel")

			TextLabel4.Size = UDim2.fromScale(0.9, 0.25)
			TextLabel4.Position = UDim2.fromScale(0.05, 0.69)
			TextLabel4.BackgroundTransparency = 1
			TextLabel4.Text = v301.ShopRobuxHint or "Choose amount on the right"
			TextLabel4.TextScaled = true
			TextLabel4.TextWrapped = true
			TextLabel4.Font = Enum.Font.GothamSemibold
			TextLabel4.TextColor3 = Color3.fromRGB(255, 255, 255)
			TextLabel4.Parent = Frame2
			Instance.new("UITextSizeConstraint", TextLabel4).MaxTextSize = 28

			local Frame7 = Instance.new("Frame")

			Frame7.Size = UDim2.new(0.005, 0, 0.92, 0)
			Frame7.Position = UDim2.fromScale(0.345, 0.04)
			Frame7.BackgroundColor3 = UIAccentColor
			createUIGradient(Frame7, 90)
			Frame7.BackgroundTransparency = 0.3
			Frame7.BorderSizePixel = 0
			Frame7.Parent = Frame

			local Frame8 = Instance.new("Frame")

			Frame8.Name = "RightPanel"
			Frame8.Size = UDim2.fromScale(0.635, 1)
			Frame8.Position = UDim2.fromScale(0.36, 0)
			Frame8.BackgroundTransparency = 1
			Frame8.Parent = Frame

			local TextLabel5 = Instance.new("TextLabel")

			TextLabel5.Size = UDim2.fromScale(1, 0.08)
			TextLabel5.BackgroundTransparency = 1
			TextLabel5.Text = "CHOOSE AMOUNT"
			TextLabel5.TextScaled = true
			TextLabel5.Font = Enum.Font.GothamBlack
			TextLabel5.TextXAlignment = Enum.TextXAlignment.Center
			TextLabel5.TextColor3 = Color3.fromRGB(255, 255, 255)
			TextLabel5.Parent = Frame8
			createUIGradient2(TextLabel5)

			local UITextSizeConstraint2 = Instance.new("UITextSizeConstraint")

			UITextSizeConstraint2.MinTextSize = 14
			UITextSizeConstraint2.MaxTextSize = 40
			UITextSizeConstraint2.Parent = TextLabel5

			local Frame9 = Instance.new("Frame")

			Frame9.Size = UDim2.new(1, 0, 0.006, 0)
			Frame9.Position = UDim2.fromScale(0, 0.09)
			Frame9.BackgroundColor3 = UIAccentColor
			createUIGradient(Frame9)
			Frame9.BorderSizePixel = 0
			Frame9.Parent = Frame8

			local ScrollingFrame = Instance.new("ScrollingFrame")

			ScrollingFrame.Name = "ProductGrid"
			ScrollingFrame.Size = UDim2.fromScale(1, 0.88)
			ScrollingFrame.Position = UDim2.fromScale(0, 0.11)
			ScrollingFrame.BackgroundTransparency = 1
			ScrollingFrame.BorderSizePixel = 0
			ScrollingFrame.ScrollBarThickness = 3
			ScrollingFrame.ScrollBarImageColor3 = UIAccentColor
			ScrollingFrame.ScrollingDirection = Enum.ScrollingDirection.Y
			ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
			ScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
			ScrollingFrame.ScrollBarImageTransparency = 0.2
			ScrollingFrame.Parent = Frame8

			local UIPadding2 = Instance.new("UIPadding")

			UIPadding2.PaddingTop = UDim.new(0.01, 0)
			UIPadding2.PaddingLeft = UDim.new(0.01, 0)
			UIPadding2.PaddingRight = UDim.new(0.02, 0)
			UIPadding2.Parent = ScrollingFrame

			local UIGridLayout = Instance.new("UIGridLayout")

			UIGridLayout.CellSize = UDim2.new(0.48, 0, 0.28, 0)
			UIGridLayout.CellPadding = UDim2.new(0.02, 0, 0.02, 0)
			UIGridLayout.SortOrder = Enum.SortOrder.LayoutOrder
			UIGridLayout.FillDirectionMaxCells = 2
			UIGridLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
			UIGridLayout.VerticalAlignment = Enum.VerticalAlignment.Top
			UIGridLayout.Parent = ScrollingFrame

			return Frame, ScrollingFrame
		end
		local function v378(p115, p116)
			local Frame = Instance.new("Frame")

			Frame.Name = "Product_" .. p116.id
			Frame.BackgroundColor3 = Color3.fromRGB(14, 14, 26)
			Frame.BackgroundTransparency = 0.15
			Frame.Parent = p115

			local UICorner = Instance.new("UICorner")

			UICorner.CornerRadius = UDim.new(0.08, 0)
			UICorner.Parent = Frame

			local UIStroke = Instance.new("UIStroke")

			UIStroke.Thickness = 1.5
			UIStroke.Transparency = 0.15
			UIStroke.Color = UIAccentColor
			UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
			UIStroke.Parent = Frame
			createUIGradient(UIStroke)

			local UIPadding = Instance.new("UIPadding")

			UIPadding.PaddingTop = UDim.new(0.06, 0)
			UIPadding.PaddingBottom = UDim.new(0.06, 0)
			UIPadding.PaddingLeft = UDim.new(0.06, 0)
			UIPadding.PaddingRight = UDim.new(0.06, 0)
			UIPadding.Parent = Frame

			local TextLabel = Instance.new("TextLabel")

			TextLabel.Size = UDim2.fromScale(1, 0.28)
			TextLabel.BackgroundTransparency = 1
			TextLabel.Text = p116.name
			TextLabel.TextXAlignment = Enum.TextXAlignment.Left
			TextLabel.TextScaled = true
			TextLabel.Font = Enum.Font.GothamBold
			TextLabel.TextColor3 = Color3.fromRGB(235, 235, 255)
			TextLabel.TextTruncate = Enum.TextTruncate.AtEnd
			TextLabel.Parent = Frame
			Instance.new("UITextSizeConstraint", TextLabel).MaxTextSize = v325() and 16 or 24

			local Frame2 = Instance.new("Frame")

			Frame2.Size = UDim2.fromScale(0.6, 0.25)
			Frame2.Position = UDim2.fromScale(0, 0.3)
			Frame2.BackgroundTransparency = 1
			Frame2.Parent = Frame

			local UIListLayout = Instance.new("UIListLayout")

			UIListLayout.FillDirection = Enum.FillDirection.Horizontal
			UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
			UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
			UIListLayout.Padding = UDim.new(0.05, 0)
			UIListLayout.Parent = Frame2

			local ImageLabel = Instance.new("ImageLabel")

			ImageLabel.Size = UDim2.fromScale(0.22, 0.85)
			ImageLabel.BackgroundTransparency = 1
			ImageLabel.Image = "rbxassetid://11560341132"
			ImageLabel.LayoutOrder = 1
			ImageLabel.Parent = Frame2

			local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")

			UIAspectRatioConstraint.AspectRatio = 1
			UIAspectRatioConstraint.Parent = ImageLabel

			local TextLabel2 = Instance.new("TextLabel")

			TextLabel2.Size = UDim2.fromScale(0.7, 1)
			TextLabel2.BackgroundTransparency = 1
			TextLabel2.Text = v327(p116.price)
			TextLabel2.TextScaled = true
			TextLabel2.Font = Enum.Font.GothamBold
			TextLabel2.TextXAlignment = Enum.TextXAlignment.Left
			TextLabel2.TextColor3 = Color3.fromRGB(200, 200, 230)
			Instance.new("UITextSizeConstraint", TextLabel2).MaxTextSize = v325() and 14 or 20
			TextLabel2.LayoutOrder = 2
			TextLabel2.Parent = Frame2

			local TextButton = Instance.new("TextButton")

			TextButton.Name = "Buy"
			TextButton.Size = UDim2.fromScale(1, 0.3)
			TextButton.Position = UDim2.fromScale(0, 0.65)
			TextButton.BackgroundColor3 = UIAccentColor
			TextButton.AutoButtonColor = true
			TextButton.Text = "BUY"
			TextButton.TextScaled = true
			TextButton.Font = Enum.Font.GothamBlack
			TextButton.TextColor3 = Color3.fromRGB(255, 255, 255)
			TextButton.Parent = Frame
			Instance.new("UITextSizeConstraint", TextButton).MaxTextSize = v325() and 16 or 24

			local UICorner2 = Instance.new("UICorner")

			UICorner2.CornerRadius = UDim.new(0.15, 0)
			UICorner2.Parent = TextButton

			local UIStroke2 = Instance.new("UIStroke")

			UIStroke2.Thickness = 2
			UIStroke2.Transparency = 0.3
			UIStroke2.Color = v305
			UIStroke2.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
			UIStroke2.Parent = TextButton
			createUIGradient(UIStroke2)
			TextButton.MouseButton1Click:Connect(function()
				if _G.CenzRobuxShowMessageModal then
					_G.CenzRobuxShowMessageModal(p116.id)
				else
					MarketplaceService:PromptProductPurchase(LocalPlayer, p116.id)
				end
			end)
		end
		local function v392(p117)
			for _, child in ipairs(p117:GetChildren()) do
				if child:IsA("Frame") then
					if not child.Name:match("^Product_") then
						if not child.Name:match("^Spacer_") then
							continue
						end
					end

					child:Destroy()
				end
			end

			for _, v in ipairs(v333()) do
				v378(p117, v)
			end

			for i = 1, 2 do
				local Frame = Instance.new("Frame")

				Frame.Name = "Spacer_" .. i
				Frame.BackgroundTransparency = 1
				Frame.BorderSizePixel = 0
				Frame.LayoutOrder = 9999 + i
				Frame.Parent = p117
			end
		end
		local function v399()
			if u324 then
				return
			end

			u324 = true

			if _G.CenzRobuxAdminClose then
				_G.CenzRobuxAdminClose()
			end

			u320.Parent = PlayerGui
			u322.Visible = true
			u322.BackgroundTransparency = 1
			u321.Visible = true
			u321.Size = UDim2.fromScale(0, 0)
			u321.BackgroundTransparency = 1
			u323.Enabled = true
			TweenService2:Create(u323, TweenInfo.new(0.4), {
				Size = 24
			}):Play()
			TweenService2:Create(u322, TweenInfo.new(0.4), {
				BackgroundTransparency = 0.4
			}):Play()

			local uDim2 = v325() and UDim2.fromScale(0.6, 0.65) or UDim2.fromScale(0.55, 0.6)

			TweenService2:Create(u321, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
				Size = uDim2,
				BackgroundTransparency = 0.1
			}):Play()
		end
		local function v401()
			if not u324 then
				return
			end

			u324 = false
			TweenService2:Create(u323, TweenInfo.new(0.4), {
				Size = 0
			}):Play()
			TweenService2:Create(u322, TweenInfo.new(0.4), {
				BackgroundTransparency = 1
			}):Play()

			local tween = TweenService2:Create(u321, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
				Size = UDim2.fromScale(0, 0),
				BackgroundTransparency = 1
			})

			tween:Play()
			tween.Completed:Connect(function()
				u321.Visible = false
				u322.Visible = false
				u323.Enabled = false
				u320.Parent = nil
			end)
		end
		local function v403()
			u323 = createBlurEffect()
			u320 = createScreenGui()
			u322 = createFrame(u320)

			local v404, v405 = v346(u320)

			u321 = v404
			v392(v405)
			_G.CenzDonateRobuxToggle = function()
				if u324 then
					v401()
				else
					v399()
				end
			end
			_G.CenzDonateRobuxClose = function()
				if u324 then
					v401()
				end
			end
		end

		v403()
		print("CENZ STUDIO DONATE ROBUX UI CLIENT ACTIVE")
	end

	v300(script, v24)
end)
task.spawn(function()
	local function v406(p118, p119)
		local v407 = p119(game:GetService("ReplicatedStorage").CenzDonateRobuxRS.CenzDonateRobuxConfig)
		local Players = game:GetService("Players")
		local ReplicatedStorage2 = game:GetService("ReplicatedStorage")
		local Workspace = game:GetService("Workspace")
		local LocalPlayer = Players.LocalPlayer
		local CenzDonateRobuxRemotes = ReplicatedStorage2:WaitForChild("CenzDonateRobuxRS"):WaitForChild("CenzDonateRobuxRemotes")
		local CenzRobuxAnnounce = CenzDonateRobuxRemotes:WaitForChild("CenzRobuxAnnounce")
		local CenzRobuxOpenMessage = CenzDonateRobuxRemotes:WaitForChild("CenzRobuxOpenMessage")
		local CenzRobuxFireworksReq = CenzDonateRobuxRemotes:WaitForChild("CenzRobuxFireworksReq")

		local function v416()
			local SpawnFireworks = p118:FindFirstChild("SpawnFireworks")

			if SpawnFireworks and SpawnFireworks:IsA("LocalScript") then
				return SpawnFireworks
			end

			local PlayerScripts = LocalPlayer:FindFirstChildOfClass("PlayerScripts")

			if PlayerScripts then
				local CenzDonateRobuxArea = PlayerScripts:FindFirstChild("CenzDonateRobuxArea")

				if CenzDonateRobuxArea then
					local SpawnFireworks2 = CenzDonateRobuxArea:FindFirstChild("SpawnFireworks")

					if SpawnFireworks2 and SpawnFireworks2:IsA("LocalScript") then
						return SpawnFireworks2
					end
				end

				for _, descendant in ipairs(PlayerScripts:GetDescendants()) do
					if descendant:IsA("LocalScript") and descendant.Name == "SpawnFireworks" then
						return descendant
					end
				end
			end

			return nil
		end
		local function v423()
			local n3 = 0
			local n4 = 0

			for _, descendant in ipairs(Workspace:GetDescendants()) do
				if descendant:IsA("BasePart") then
					if descendant.Name == "FireworkFlare" then
						descendant:Destroy()
						n3 += 1
					elseif descendant.Name == "FireworksRocket" then
						descendant:Destroy()
						n4 += 1
					end
				end
			end

			if n3 > 0 or n4 > 0 then
				print(string.format("[Fireworks] Cleanup: %d Flares + %d Rockets dihapus", n3, n4))
			end
		end

		local u428 = false

		local function v429(p120)
			if u428 then
				return
			end

			u428 = true

			local v430 = v416()

			if v430 then
				v430.Enabled = true
			end

			task.delay(p120, function()
				local v431 = v416()

				if v431 then
					v431.Enabled = false
				end

				task.delay(p120 * 0.3, function()
					v423()
				end)
				task.delay(0.5, function()
					u428 = false
				end)
			end)
		end

		CenzDonateRobuxRemotes:WaitForChild("CenzRobuxFireworksBcast").OnClientEvent:Connect(function(p121)
			if typeof(p121) ~= "table" then
				return
			end

			local v432 = tonumber(p121.duration) or 25

			task.delay(math.max(0, (tonumber(p121.startAt) or 0) - Workspace:GetServerTimeNow()), function()
				v429(v432)
			end)
		end)
		CenzRobuxOpenMessage.OnClientEvent:Connect(function()
		end)
		CenzRobuxAnnounce.OnClientEvent:Connect(function(p122)
			if typeof(p122) ~= "table" then
				return
			end

			if tonumber(p122.userId) ~= LocalPlayer.UserId then
				return
			end

			task.delay(3, function()
				CenzRobuxFireworksReq:FireServer(v407.FireworksRobuxDuration)
			end)
		end)
		print("CENZ STUDIO DONATE ROBUX FIREWORKS CLIENT ACTIVE")
	end

	v406(script, v24)
end)
task.spawn(function()
	local function v433(p123, p124)
		local ReplicatedStorage2 = game:GetService("ReplicatedStorage")
		local MarketplaceService = game:GetService("MarketplaceService")
		local Players = game:GetService("Players")
		local TweenService = game:GetService("TweenService")
		local v438 = p124(ReplicatedStorage2:WaitForChild("CenzDonateRobuxRS"):WaitForChild("CenzDonateRobuxConfig"))
		local TweenService2 = game:GetService("TweenService")
		local UIAccentColor = v438.UIAccentColor or Color3.fromRGB(255, 200, 80)

		local function v441(p125, p126, p127)
			return Color3.new(p125.R + (p126.R - p125.R) * p127, p125.G + (p126.G - p125.G) * p127, p125.B + (p126.B - p125.B) * p127)
		end

		local v442 = v441(UIAccentColor, Color3.fromRGB(255, 255, 255), 0.5)
		local colorSequence = ColorSequence.new({
			ColorSequenceKeypoint.new(0, UIAccentColor),
			ColorSequenceKeypoint.new(0.3, UIAccentColor),
			ColorSequenceKeypoint.new(0.43, v442),
			ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
			ColorSequenceKeypoint.new(0.57, v442),
			ColorSequenceKeypoint.new(0.7, UIAccentColor),
			ColorSequenceKeypoint.new(1, UIAccentColor)
		})

		local function createUIGradient(p128, p129)
			local rotation = p129 or 0

			if p128:IsA("UIStroke") then
				p128.Color = Color3.fromRGB(255, 255, 255)

				local UIGradient = Instance.new("UIGradient")

				UIGradient.Color = colorSequence
				UIGradient.Rotation = 0
				UIGradient.Parent = p128
				TweenService2:Create(UIGradient, TweenInfo.new(3, Enum.EasingStyle.Linear, Enum.EasingDirection.In, -1, false), {
					Rotation = 360
				}):Play()

				return UIGradient
			end

			p128.BackgroundColor3 = Color3.fromRGB(255, 255, 255)

			local UIGradient = Instance.new("UIGradient")

			UIGradient.Color = colorSequence
			UIGradient.Rotation = rotation

			local vector2, vector22

			if rotation == 90 or rotation == 270 then
				vector2 = Vector2.new(0, -0.5)
				vector22 = Vector2.new(0, 0.5)
			else
				vector2 = Vector2.new(-0.5, 0)
				vector22 = Vector2.new(0.5, 0)
			end

			UIGradient.Offset = vector2
			UIGradient.Parent = p128
			TweenService2:Create(UIGradient, TweenInfo.new(1.5, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1, true), {
				Offset = vector22
			}):Play()

			return UIGradient
		end
		local function createUIGradient2(p130)
			local UIGradient = Instance.new("UIGradient")

			UIGradient.Color = colorSequence
			UIGradient.Rotation = 90
			UIGradient.Offset = Vector2.new(0, 0.3)
			UIGradient.Parent = p130
			TweenService2:Create(UIGradient, TweenInfo.new(1.5, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1, true), {
				Offset = Vector2.new(0, -0.3)
			}):Play()

			return UIGradient
		end

		local LocalPlayer = Players.LocalPlayer
		local CenzDonateRobuxRemotes = ReplicatedStorage2:WaitForChild("CenzDonateRobuxRS"):WaitForChild("CenzDonateRobuxRemotes")
		local CenzRobuxSubmitMessage = CenzDonateRobuxRemotes:WaitForChild("CenzRobuxSubmitMessage")
		local CenzRobuxGetTotal = CenzDonateRobuxRemotes:WaitForChild("CenzRobuxGetTotal")

		_G.CenzRobuxShowMessageModal = function(p131)
			local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
			local DonorMessageModal = PlayerGui:FindFirstChild("DonorMessageModal")

			if DonorMessageModal then
				DonorMessageModal:Destroy()
			end

			local ScreenGui = Instance.new("ScreenGui")

			ScreenGui.ResetOnSpawn = false
			ScreenGui.IgnoreGuiInset = true
			ScreenGui.DisplayOrder = 1200
			ScreenGui.Name = "DonorMessageModal"
			ScreenGui.Parent = PlayerGui

			if _G.CenzDonateRobuxClose then
				_G.CenzDonateRobuxClose()
			end

			local Frame = Instance.new("Frame")

			Frame.BackgroundColor3 = Color3.new(0, 0, 0)
			Frame.BackgroundTransparency = 0.4
			Frame.Size = UDim2.fromScale(1, 1)
			Frame.Parent = ScreenGui

			local Frame2 = Instance.new("Frame")

			Frame2.AnchorPoint = Vector2.new(0.5, 0.5)
			Frame2.Position = UDim2.fromScale(0.5, 0.45)
			Frame2.Size = UDim2.fromScale(0.45, 0.4)
			Frame2.BackgroundColor3 = Color3.fromRGB(8, 8, 14)
			Frame2.BackgroundTransparency = 0.1
			Frame2.ClipsDescendants = true
			Frame2.Parent = ScreenGui

			local UICorner = Instance.new("UICorner")

			UICorner.CornerRadius = UDim.new(0.03, 0)
			UICorner.Parent = Frame2

			local UIStroke = Instance.new("UIStroke")

			UIStroke.Thickness = 2
			UIStroke.Transparency = 0.1
			UIStroke.Color = UIAccentColor
			UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
			UIStroke.Parent = Frame2
			createUIGradient(UIStroke)

			local UIGradient = Instance.new("UIGradient")

			UIGradient.Rotation = 90
			UIGradient.Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, Color3.fromRGB(8, 8, 14)),
				ColorSequenceKeypoint.new(0.5, Color3.fromRGB(16, 10, 28)),
				ColorSequenceKeypoint.new(1, Color3.fromRGB(8, 8, 14))
			})
			UIGradient.Parent = Frame2

			local UIPadding = Instance.new("UIPadding")

			UIPadding.PaddingTop = UDim.new(0.03, 0)
			UIPadding.PaddingBottom = UDim.new(0.03, 0)
			UIPadding.PaddingLeft = UDim.new(0.03, 0)
			UIPadding.PaddingRight = UDim.new(0.03, 0)
			UIPadding.Parent = Frame2

			local TextButton = Instance.new("TextButton")

			TextButton.Name = "CloseBtn"
			TextButton.Size = UDim2.fromScale(0.12, 0.12)
			TextButton.Position = UDim2.fromScale(0.98, 0.06)
			TextButton.AnchorPoint = Vector2.new(1, 0.5)
			TextButton.BackgroundColor3 = Color3.fromRGB(60, 30, 80)
			TextButton.BackgroundTransparency = 0.3
			TextButton.Text = "X"
			TextButton.TextScaled = true
			TextButton.Font = Enum.Font.GothamBlack
			TextButton.TextColor3 = Color3.fromRGB(255, 255, 255)
			TextButton.ZIndex = 10
			TextButton.Parent = Frame2

			local UICorner2 = Instance.new("UICorner")

			UICorner2.CornerRadius = UDim.new(0.2, 0)
			UICorner2.Parent = TextButton

			local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")

			UIAspectRatioConstraint.AspectRatio = 1
			UIAspectRatioConstraint.Parent = TextButton

			local Frame3 = Instance.new("Frame")

			Frame3.Size = UDim2.fromScale(0.33, 1)
			Frame3.BackgroundTransparency = 1
			Frame3.Parent = Frame2

			local Frame4 = Instance.new("Frame")

			Frame4.Size = UDim2.fromScale(1, 0.12)
			Frame4.BackgroundTransparency = 1
			Frame4.Parent = Frame3

			local TextLabel = Instance.new("TextLabel")

			TextLabel.Size = UDim2.fromScale(1, 1)
			TextLabel.BackgroundTransparency = 1
			TextLabel.Text = v438.GameName or "CENZ STUDIO"
			TextLabel.TextScaled = true
			TextLabel.Font = Enum.Font.GothamBlack
			TextLabel.TextXAlignment = Enum.TextXAlignment.Center
			TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
			TextLabel.Parent = Frame4

			local UIGradient2 = Instance.new("UIGradient")

			UIGradient2.Color = colorSequence
			UIGradient2.Rotation = 90
			UIGradient2.Parent = TextLabel

			local TweenService3 = game:GetService("TweenService")

			UIGradient2.Offset = Vector2.new(0, 0.3)
			TweenService3:Create(UIGradient2, TweenInfo.new(1.5, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1, true), {
				Offset = Vector2.new(0, -0.3)
			}):Play()

			local Frame5 = Instance.new("Frame")

			Frame5.Size = UDim2.fromScale(1, 0.003)
			Frame5.Position = UDim2.fromScale(0, 0.14)
			Frame5.BackgroundColor3 = UIAccentColor
			createUIGradient(Frame5)
			Frame5.BorderSizePixel = 0
			Frame5.Parent = Frame3

			local Frame6 = Instance.new("Frame")

			Frame6.Size = UDim2.fromScale(0.5, 0.32)
			Frame6.AnchorPoint = Vector2.new(0.5, 0)
			Frame6.Position = UDim2.fromScale(0.5, 0.18)
			Frame6.BackgroundTransparency = 1
			Frame6.Parent = Frame3

			local UIAspectRatioConstraint2 = Instance.new("UIAspectRatioConstraint")

			UIAspectRatioConstraint2.AspectRatio = 1
			UIAspectRatioConstraint2.DominantAxis = Enum.DominantAxis.Height
			UIAspectRatioConstraint2.Parent = Frame6

			local ImageLabel = Instance.new("ImageLabel")

			ImageLabel.Size = UDim2.fromScale(1, 1)
			ImageLabel.BackgroundColor3 = Color3.fromRGB(20, 14, 30)
			ImageLabel.Parent = Frame6

			local UICorner3 = Instance.new("UICorner")

			UICorner3.CornerRadius = UDim.new(1, 0)
			UICorner3.Parent = ImageLabel

			local UIStroke2 = Instance.new("UIStroke")

			UIStroke2.Thickness = 2
			UIStroke2.Color = v442
			UIStroke2.Parent = ImageLabel
			createUIGradient(UIStroke2)

			local TextLabel2 = Instance.new("TextLabel")

			TextLabel2.Size = UDim2.fromScale(1, 0.12)
			TextLabel2.Position = UDim2.fromScale(0, 0.53)
			TextLabel2.BackgroundTransparency = 1
			TextLabel2.Text = LocalPlayer.DisplayName
			TextLabel2.TextScaled = true
			TextLabel2.Font = Enum.Font.GothamBlack
			TextLabel2.TextXAlignment = Enum.TextXAlignment.Center
			TextLabel2.TextColor3 = Color3.fromRGB(255, 255, 255)
			TextLabel2.Parent = Frame3

			local TextLabel3 = Instance.new("TextLabel")

			TextLabel3.Size = UDim2.fromScale(1, 0.09)
			TextLabel3.Position = UDim2.fromScale(0, 0.66)
			TextLabel3.BackgroundTransparency = 1
			TextLabel3.Text = "@" .. LocalPlayer.Name
			TextLabel3.TextScaled = true
			TextLabel3.Font = Enum.Font.GothamSemibold
			TextLabel3.TextXAlignment = Enum.TextXAlignment.Center
			TextLabel3.TextColor3 = Color3.fromRGB(160, 150, 190)
			TextLabel3.Parent = Frame3

			local Frame7 = Instance.new("Frame")

			Frame7.Size = UDim2.fromScale(0.6, 0.003)
			Frame7.Position = UDim2.fromScale(0.2, 0.78)
			Frame7.BackgroundColor3 = UIAccentColor
			createUIGradient(Frame7)
			Frame7.BackgroundTransparency = 0.4
			Frame7.BorderSizePixel = 0
			Frame7.Parent = Frame3

			local TextLabel4 = Instance.new("TextLabel")

			TextLabel4.Size = UDim2.fromScale(0.9, 0.07)
			TextLabel4.Position = UDim2.fromScale(0.05, 0.81)
			TextLabel4.BackgroundTransparency = 1
			TextLabel4.Text = "TOTAL DONATED"
			TextLabel4.TextScaled = true
			TextLabel4.Font = Enum.Font.GothamBold
			TextLabel4.TextColor3 = Color3.fromRGB(150, 150, 180)
			TextLabel4.TextXAlignment = Enum.TextXAlignment.Center
			TextLabel4.Parent = Frame3

			local TextLabel5 = Instance.new("TextLabel")

			TextLabel5.Size = UDim2.fromScale(0.9, 0.1)
			TextLabel5.Position = UDim2.fromScale(0.05, 0.88)
			TextLabel5.BackgroundTransparency = 1
			TextLabel5.Text = "Total Donated: —"
			TextLabel5.TextScaled = true
			TextLabel5.TextWrapped = true
			TextLabel5.Font = Enum.Font.GothamSemibold
			TextLabel5.TextColor3 = Color3.fromRGB(0, 255, 220)
			TextLabel5.Parent = Frame3
			task.spawn(function()
				local ok, image = pcall(Players.GetUserThumbnailAsync, Players, LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size180x180)

				if ok and image then
					ImageLabel.Image = image
				end

				local ok2, result = pcall(function()
					return CenzRobuxGetTotal:InvokeServer()
				end)

				if ok2 and result then
					TextLabel5.Text = tostring(math.floor(tonumber(result) or 0)):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "") .. " Robux"
				else
					TextLabel5.Text = "0 Robux"
				end
			end)

			local Frame8 = Instance.new("Frame")

			Frame8.Size = UDim2.fromScale(0.003, 0.92)
			Frame8.Position = UDim2.fromScale(0.345, 0.04)
			Frame8.BackgroundColor3 = UIAccentColor
			createUIGradient(Frame8, 90)
			Frame8.BackgroundTransparency = 0.3
			Frame8.BorderSizePixel = 0
			Frame8.Parent = Frame2

			local Frame9 = Instance.new("Frame")

			Frame9.Size = UDim2.fromScale(0.635, 1)
			Frame9.Position = UDim2.fromScale(0.36, 0)
			Frame9.BackgroundTransparency = 1
			Frame9.Parent = Frame2

			local TextLabel6 = Instance.new("TextLabel")

			TextLabel6.Size = UDim2.fromScale(1, 0.12)
			TextLabel6.BackgroundTransparency = 1
			TextLabel6.Text = "YOUR MESSAGE"
			TextLabel6.TextScaled = true
			TextLabel6.Font = Enum.Font.GothamBlack
			TextLabel6.TextXAlignment = Enum.TextXAlignment.Center
			TextLabel6.TextColor3 = Color3.fromRGB(255, 255, 255)
			TextLabel6.Parent = Frame9
			createUIGradient2(TextLabel6)

			local Frame10 = Instance.new("Frame")

			Frame10.Size = UDim2.fromScale(1, 0.003)
			Frame10.Position = UDim2.fromScale(0, 0.14)
			Frame10.BackgroundColor3 = UIAccentColor
			createUIGradient(Frame10)
			Frame10.BorderSizePixel = 0
			Frame10.Parent = Frame9

			local Frame11 = Instance.new("Frame")

			Frame11.Size = UDim2.fromScale(0.95, 0.45)
			Frame11.AnchorPoint = Vector2.new(0.5, 0)
			Frame11.Position = UDim2.fromScale(0.5, 0.18)
			Frame11.BackgroundColor3 = Color3.fromRGB(14, 14, 26)
			Frame11.BackgroundTransparency = 0.15
			Frame11.Parent = Frame9

			local UICorner4 = Instance.new("UICorner")

			UICorner4.CornerRadius = UDim.new(0.05, 0)
			UICorner4.Parent = Frame11

			local UIStroke3 = Instance.new("UIStroke")

			UIStroke3.Thickness = 2
			UIStroke3.Transparency = 0.2
			UIStroke3.Color = UIAccentColor
			UIStroke3.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
			UIStroke3.Parent = Frame11
			createUIGradient(UIStroke3)

			local UIPadding2 = Instance.new("UIPadding")

			UIPadding2.PaddingTop = UDim.new(0.05, 0)
			UIPadding2.PaddingBottom = UDim.new(0.05, 0)
			UIPadding2.PaddingLeft = UDim.new(0.04, 0)
			UIPadding2.PaddingRight = UDim.new(0.04, 0)
			UIPadding2.Parent = Frame11

			local TextBox = Instance.new("TextBox")

			TextBox.Size = UDim2.fromScale(1, 1)
			TextBox.BackgroundTransparency = 1
			TextBox.ClearTextOnFocus = false
			TextBox.PlaceholderText = "Your message..."
			TextBox.Text = ""
			TextBox.TextColor3 = Color3.fromRGB(240, 240, 255)
			TextBox.PlaceholderColor3 = Color3.fromRGB(100, 90, 130)
			TextBox.Font = Enum.Font.GothamSemibold
			TextBox.TextScaled = true
			TextBox.TextWrapped = true
			TextBox.TextXAlignment = Enum.TextXAlignment.Left
			TextBox.TextYAlignment = Enum.TextYAlignment.Top
			TextBox.MultiLine = true
			TextBox.Parent = Frame11

			local UITextSizeConstraint = Instance.new("UITextSizeConstraint")

			UITextSizeConstraint.MinTextSize = 14
			UITextSizeConstraint.MaxTextSize = 24
			UITextSizeConstraint.Parent = TextBox

			local Frame12 = Instance.new("Frame")

			Frame12.Size = UDim2.fromScale(0.95, 0.18)
			Frame12.AnchorPoint = Vector2.new(0.5, 0)
			Frame12.Position = UDim2.fromScale(0.5, 0.7)
			Frame12.BackgroundTransparency = 1
			Frame12.Parent = Frame9

			local UIListLayout = Instance.new("UIListLayout")

			UIListLayout.FillDirection = Enum.FillDirection.Horizontal
			UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
			UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
			UIListLayout.Padding = UDim.new(0.03, 0)
			UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
			UIListLayout.Parent = Frame12

			local TextButton2 = Instance.new("TextButton")

			TextButton2.Text = "Cancel"
			TextButton2.Size = UDim2.fromScale(0.42, 0.85)
			TextButton2.BackgroundColor3 = Color3.fromRGB(14, 14, 26)
			TextButton2.BackgroundTransparency = 0.15
			TextButton2.TextColor3 = Color3.fromRGB(200, 200, 220)
			TextButton2.Font = Enum.Font.GothamBold
			TextButton2.TextScaled = true
			TextButton2.LayoutOrder = 1
			TextButton2.Parent = Frame12

			local UICorner5 = Instance.new("UICorner")

			UICorner5.CornerRadius = UDim.new(0.15, 0)
			UICorner5.Parent = TextButton2

			local UIStroke4 = Instance.new("UIStroke")

			UIStroke4.Thickness = 2
			UIStroke4.Transparency = 0.2
			UIStroke4.Color = UIAccentColor
			UIStroke4.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
			UIStroke4.Parent = TextButton2
			createUIGradient(UIStroke4)

			local TextButton3 = Instance.new("TextButton")

			TextButton3.Text = "DONATE"
			TextButton3.Size = UDim2.fromScale(0.48, 0.85)
			TextButton3.BackgroundColor3 = UIAccentColor
			TextButton3.AutoButtonColor = true
			TextButton3.TextColor3 = Color3.fromRGB(255, 255, 255)
			TextButton3.Font = Enum.Font.GothamBlack
			TextButton3.TextScaled = true
			TextButton3.LayoutOrder = 2
			TextButton3.Parent = Frame12

			local UICorner6 = Instance.new("UICorner")

			UICorner6.CornerRadius = UDim.new(0.15, 0)
			UICorner6.Parent = TextButton3

			local UIStroke5 = Instance.new("UIStroke")

			UIStroke5.Thickness = 2
			UIStroke5.Transparency = 0.3
			UIStroke5.Color = v442
			UIStroke5.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
			UIStroke5.Parent = TextButton3
			createUIGradient(UIStroke5)

			local function v506()
				TweenService:Create(Frame2, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
					Size = UDim2.fromScale(0.45, 0),
					BackgroundTransparency = 1
				}):Play()
				TweenService:Create(UIStroke, TweenInfo.new(0.2), {
					Transparency = 1
				}):Play()
				TweenService:Create(Frame, TweenInfo.new(0.2), {
					BackgroundTransparency = 1
				}):Play()
				task.delay(0.25, function()
					ScreenGui:Destroy()
				end)
			end
			local function v507()
				local v508 = tostring(TextBox.Text or ""):gsub("\n", " "):gsub("%s+", " ")

				if #v508 > 200 then
					v508 = v508:sub(1, 200)
				end

				if v508 ~= "" then
					CenzRobuxSubmitMessage:FireServer({
						message = v508
					})
				end

				task.wait(0.1)
				MarketplaceService:PromptProductPurchase(LocalPlayer, p131)
				v506()

				if _G.CenzDonateRobuxClose then
					_G.CenzDonateRobuxClose()
				end
			end

			TextButton3.MouseButton1Click:Connect(v507)
			TextButton2.MouseButton1Click:Connect(v506)
			TextButton.MouseButton1Click:Connect(v506)
			TextBox.FocusLost:Connect(function(enterPressed)
				if enterPressed then
					v507()
				end
			end)

			local uDim2 = UDim2.fromScale(0.45, 0.4)

			Frame2.Size = UDim2.fromScale(0.45, 0)
			TweenService:Create(Frame2, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
				Size = uDim2
			}):Play()
		end
		print("CENZ STUDIO DONATE ROBUX MESSAGE CLIENT ACTIVE")
	end

	v433(script, v24)
end)
task.spawn(function()
	local function v510(p132, p133)
		local Players = game:GetService("Players")
		local ReplicatedStorage2 = game:GetService("ReplicatedStorage")
		local TextChatService = game:GetService("TextChatService")

		local function v514(p134, p135)
			local v515

			repeat
				v515 = p134:WaitForChild(p135, 30)
			until v515

			return v515
		end
		local function v516()
			return v514(v514(v514(ReplicatedStorage2, "CenzDonateRobuxRS"), "CenzDonateRobuxRemotes"), "CenzRobuxAnnounce")
		end
		local function v517()
			local TextChannels = TextChatService:WaitForChild("TextChannels", 30)

			if not TextChannels then
				return nil
			end

			local RBXGeneral = TextChannels:WaitForChild("RBXGeneral", 10)

			if RBXGeneral then
				return RBXGeneral
			end

			for _, child in ipairs(TextChannels:GetChildren()) do
				if child:IsA("TextChannel") then
					return child
				end
			end

			return nil
		end
		local function v522(p136)
			local v523 = tostring(math.floor(tonumber(p136) or 0))
			local s2 = ""
			local n5 = 0

			for i = #v523, 1, -1 do
				s2 = v523:sub(i, i) .. s2
				n5 += 1

				if n5 % 3 == 0 and i > 1 then
					s2 = "," .. s2
				end
			end

			return s2
		end
		local function v527(p137)
			return (tostring(p137 or ""):gsub("<", "&lt;"):gsub(">", "&gt;"):gsub("[\r\n]+", " "))
		end

		local v528 = p133(v514(v514(ReplicatedStorage2, "CenzDonateRobuxRS"), "CenzDonateRobuxConfig"))

		local function v529(p138, p139)
			local v530 = v528[p138]

			if v530 == nil then
				return p139
			end

			return v530
		end
		local function v531(p140)
			local v532 = tonumber(p140.userId) or 0

			if v532 <= 0 then
				return false
			end

			return Players:GetPlayerByUserId(v532) ~= nil
		end

		local v533 = v516()

		if v533 then
			v533.OnClientEvent:Connect(function(p141)
				if typeof(p141) ~= "table" then
					return
				end

				if v529("ChatBroadcastRobuxEnabled", true) == false then
					return
				end

				if not v531(p141) then
					return
				end

				local username = p141.username or "Player"
				local displayName = p141.displayName
				local v536 = tonumber(p141.amount) or 0
				local message = p141.message

				if v536 <= 0 then
					return
				end

				local v538 = table.concat({
					"<font color=\"rgb(85,170,255)\"><b>[SERVER]</b></font>",
					"<font color=\"rgb(255,170,0)\"><b>[ROBUX]</b></font>",
					"<font color=\"rgb(255,255,255)\"><b>" .. v527(typeof(displayName) == "string" and displayName ~= "" and displayName or username) .. "</b></font>",
					"<font color=\"rgb(220,220,220)\">Donate</font>",
					"<font color=\"rgb(85,255,127)\"><b>" .. v522(v536) .. "</b></font>"
				}, " ")

				if typeof(message) == "string" and message ~= "" then
					v538 ..= "<font color=\"rgb(220,220,220)\">:</font> " .. "<font color=\"rgb(255,255,255)\"><i>\"" .. v527(message) .. "\"</i></font>"
				end

				local v539 = v517()

				if v539 then
					v539:DisplaySystemMessage(v538)
				else
					warn("[DonateChatBroadcast] Channel chat tidak ditemukan")
				end
			end)
			print("CENZ STUDIO DONATE ROBUX CHAT BROADCAST CLIENT ACTIVE")

			return
		end

		warn("[DonateChatBroadcast] CenzRobuxAnnounce tidak ditemukan")
	end

	v510(script, v24)
end)
task.spawn(function()
	local function v540()
		local Players = game:GetService("Players")
		local MarketplaceService = game:GetService("MarketplaceService")

		game:GetService("UserInputService")
		game:GetService("RunService")

		local LocalPlayer = Players.LocalPlayer

		local function v544(p142)
			local attribute = p142:GetAttribute("ProductId")

			if typeof(attribute) ~= "number" then
				return
			end

			local v546 = os.clock() + 3

			while not _G.CenzRobuxShowMessageModal and os.clock() < v546 do
				task.wait(0.05)
			end

			if _G.CenzRobuxShowMessageModal then
				_G.CenzRobuxShowMessageModal(attribute)
			else
				MarketplaceService:PromptProductPurchase(LocalPlayer, attribute)
			end
		end
		local function v547(descendant)
			if not descendant:IsA("TextButton") or descendant.Name ~= "Buy" then
				return
			end

			if descendant:GetAttribute("__CenzBuyHooked") then
				return
			end

			descendant:SetAttribute("__CenzBuyHooked", true)
			descendant.MouseButton1Click:Connect(function()
				v544(descendant)
			end)
		end
		local function v548(p143)
			for _, descendant in ipairs(p143:GetDescendants()) do
				v547(descendant)
			end

			p143.DescendantAdded:Connect(v547)
		end
		local function v551(p144, p145)
			local huge = p145 or math.huge
			local v553 = os.clock() + huge

			while true do
				if not (os.clock() < v553) then
					return nil
				end

				for _, descendant in ipairs(p144:GetDescendants()) do
					if descendant:IsA("SurfaceGui") then
						if descendant.Name == "ProductRobuxBoard" then
							return descendant
						end
					end
				end

				task.wait(0.1)
			end
		end

		local t14 = {}

		local function v557(p146)
			task.spawn(function()
				local v558 = v551(p146, 30)

				if not v558 then
					return
				end

				if t14[v558] then
					return
				end

				t14[v558] = true
				v548(v558)
			end)
			p146.DescendantAdded:Connect(function(descendant)
				if descendant:IsA("SurfaceGui") and descendant.Name == "ProductRobuxBoard" then
					if t14[descendant] then
						return
					end

					t14[descendant] = true
					v548(descendant)
				end
			end)
		end
		local function v559()
			local CenzDonateRobuxArea = workspace:WaitForChild("CenzDonateRobuxArea", 60)

			if not CenzDonateRobuxArea then
				return
			end

			local CenzShopRobuxBoard = CenzDonateRobuxArea:WaitForChild("CenzShopRobuxBoard", 60)

			if CenzShopRobuxBoard then
				v557(CenzShopRobuxBoard)

				return
			end
		end

		task.spawn(v559)
		workspace.DescendantAdded:Connect(function(descendant)
			if descendant.Name == "CenzShopRobuxBoard" and descendant:IsA("BasePart") then
				v557(descendant)
			end
		end)
		print("CENZ STUDIO DONATE ROBUX BUY CLIENT ACTIVE")
	end

	v540(script, v24)
end)
task.spawn(function()
	local function v562()
		local TweenService = game:GetService("TweenService")
		local Workspace = game:GetService("Workspace")
		local t15 = {}

		local function v566(p147)
			if t15[p147] then
				return
			end

			if not p147:IsA("UIGradient") then
				return
			end

			local attribute = p147:GetAttribute("CenzShimmer")

			if not attribute then
				return
			end

			t15[p147] = true

			local attribute2 = p147:GetAttribute("CenzRotation") or 0

			if attribute == "stroke" then
				p147.Rotation = 0

				local tween = TweenService:Create(p147, TweenInfo.new(3, Enum.EasingStyle.Linear, Enum.EasingDirection.In, -1, false), {
					Rotation = 360
				})

				tween:Play()
				p147.Destroying:Connect(function()
					pcall(function()
						tween:Cancel()
					end)
					t15[p147] = nil
				end)

				return
			end

			if attribute ~= "bg" then
				if attribute ~= "title" then
					return
				end

				p147.Offset = Vector2.new(0, 0.3)

				local tween = TweenService:Create(p147, TweenInfo.new(1.5, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1, true), {
					Offset = Vector2.new(0, -0.3)
				})

				tween:Play()
				p147.Destroying:Connect(function()
					pcall(function()
						tween:Cancel()
					end)
					t15[p147] = nil
				end)

				return
			end

			local vector2, vector22

			if attribute2 == 90 or attribute2 == 270 then
				vector2 = Vector2.new(0, -0.5)
				vector22 = Vector2.new(0, 0.5)
			else
				vector2 = Vector2.new(-0.5, 0)
				vector22 = Vector2.new(0.5, 0)
			end

			p147.Offset = vector2

			local tween = TweenService:Create(p147, TweenInfo.new(1.5, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1, true), {
				Offset = vector22
			})

			tween:Play()
			p147.Destroying:Connect(function()
				pcall(function()
					tween:Cancel()
				end)
				t15[p147] = nil
			end)
		end
		local function v574(p148)
			for _, descendant in ipairs(p148:GetDescendants()) do
				if descendant:IsA("UIGradient") then
					v566(descendant)
				end
			end
		end

		v574(Workspace)

		local LocalPlayer = game:GetService("Players").LocalPlayer

		if LocalPlayer then
			local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

			v574(PlayerGui)
			PlayerGui.DescendantAdded:Connect(function(descendant)
				if descendant:IsA("UIGradient") then
					v566(descendant)
				end
			end)
		end

		Workspace.DescendantAdded:Connect(function(descendant)
			if descendant:IsA("UIGradient") then
				if descendant:GetAttribute("CenzShimmer") then
					v566(descendant)
				else
					local connection

					connection = descendant:GetAttributeChangedSignal("CenzShimmer"):Connect(function()
						v566(descendant)

						if connection then
							connection:Disconnect()
						end
					end)
					task.delay(5, function()
						if connection then
							pcall(function()
								connection:Disconnect()
							end)
						end
					end)
				end
			end
		end)
		print("CENZ STUDIO DONATE ROBUX CLIENT ACTIVE")
	end

	v562(script, v24)
end)
task.spawn(function()
	local function v580(p149, p150)
		local v581 = p150(game:GetService("ReplicatedStorage").CenzDonateRobuxRS.CenzDonateRobuxConfig)
		local Lighting = game:GetService("Lighting")
		local Players = game:GetService("Players")
		local ReplicatedStorage2 = game:GetService("ReplicatedStorage")
		local RunService = game:GetService("RunService")
		local TweenService = game:GetService("TweenService")
		local Workspace = game:GetService("Workspace")
		local LocalPlayer = Players.LocalPlayer
		local CenzRobuxAnnounce = ReplicatedStorage2:WaitForChild("CenzDonateRobuxRS"):WaitForChild("CenzDonateRobuxRemotes"):WaitForChild("CenzRobuxAnnounce")

		local function v590(p151, p152)
			local v591 = v581[p151]

			if v591 == nil then
				return p152
			end

			return v591
		end

		local u592 = false
		local u593
		local v594
		local t16 = {}
		local t17
		local u597
		local color3 = Color3.fromRGB(255, 248, 240)

		local function v599(p153)
			return 0.45454545454545459 + 0.54545454545454541 * p153
		end
		local function v600()
			if type(_G.CenzDonateCinematicLock) ~= "table" then
				return true
			end

			if _G.CenzDonateCinematicLock.tag == "robux" then
				return true
			end

			return os.clock() > (tonumber(_G.CenzDonateCinematicLock.expires) or 0)
		end
		local function v601()
			_G.CenzDonateCinematicLock = {
				tag = "robux",
				expires = os.clock() + 11.4
			}
		end
		local function v602()
			if type(_G.CenzDonateCinematicLock) == "table" and _G.CenzDonateCinematicLock.tag == "robux" then
				_G.CenzDonateCinematicLock = nil
			end
		end
		local function v603()
			if LocalPlayer:GetAttribute("CenzHideDonateVFX") == true then
				return true
			end

			if _G.CenzHideDonateVFX == true then
				return true
			end

			if LocalPlayer:GetAttribute("GlobalEffects") == false then
				return true
			end

			return false
		end
		local function v604(p154)
			local v605 = tonumber(p154.userId) or 0

			if v605 <= 0 then
				return nil
			end

			local playerByUserId = Players:GetPlayerByUserId(v605)
			local Character = playerByUserId and playerByUserId.Character

			return Character and (Character:FindFirstChild("HumanoidRootPart") or Character:FindFirstChild("Head"))
		end

		_G.CenzRobuxCinematicWillShow = function(p155)
			if type(p155) ~= "table" then
				return false
			end

			if v590("CinematicRobuxEnabled", true) == false then
				return false
			end

			if v603() then
				return false
			end

			if (tonumber(p155.amount) or 0) < (tonumber(v590("CinematicRobuxMinAmount", 1)) or 1) then
				return false
			end

			return v604(p155) ~= nil
		end

		local function v608(p156)
			return (tostring(math.floor(tonumber(p156) or 0)):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", ""))
		end
		local function v609()
			local ScreenGui = Instance.new("ScreenGui")

			ScreenGui.Name = "CenzRobuxCinematic"
			ScreenGui.IgnoreGuiInset = true
			ScreenGui.ResetOnSpawn = false
			ScreenGui.DisplayOrder = 999
			ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
			ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

			local t18 = {}

			local function createFrame(p157, p158, p159, p160)
				local Frame = Instance.new("Frame")

				Frame.BackgroundColor3 = Color3.new(0, 0, 0)
				Frame.BorderSizePixel = 0
				Frame.Size = p157
				Frame.Position = p158
				Frame.AnchorPoint = p159
				Frame.BackgroundTransparency = 1
				Frame.ZIndex = 1

				local UIGradient = Instance.new("UIGradient")

				UIGradient.Rotation = p160
				UIGradient.Transparency = NumberSequence.new({
					NumberSequenceKeypoint.new(0, 0.44999999999999996),
					NumberSequenceKeypoint.new(1, 1)
				})
				UIGradient.Parent = Frame
				Frame.Parent = ScreenGui
				table.insert(t18, Frame)

				return Frame
			end

			createFrame(UDim2.fromScale(0.18, 1), UDim2.fromScale(0, 0.5), Vector2.new(0, 0.5), 0)
			createFrame(UDim2.fromScale(0.18, 1), UDim2.fromScale(1, 0.5), Vector2.new(1, 0.5), 180)
			createFrame(UDim2.fromScale(1, 0.18), UDim2.fromScale(0.5, 0), Vector2.new(0.5, 0), 90)
			createFrame(UDim2.fromScale(1, 0.18), UDim2.fromScale(0.5, 1), Vector2.new(0.5, 1), 270)

			local function createFrame2(p161, p162)
				local Frame = Instance.new("Frame")

				Frame.BackgroundColor3 = Color3.new(0, 0, 0)
				Frame.BorderSizePixel = 0
				Frame.AnchorPoint = Vector2.new(0.5, p161)
				Frame.Position = UDim2.fromScale(0.5, p162)
				Frame.Size = UDim2.fromScale(1, 0)
				Frame.ZIndex = 2
				Frame.Parent = ScreenGui

				return Frame
			end

			local v617 = createFrame2(0, 0)
			local v618 = createFrame2(1, 1)
			local Frame = Instance.new("Frame")

			Frame.Name = "NameCard"
			Frame.BackgroundTransparency = 1
			Frame.BorderSizePixel = 0
			Frame.Size = UDim2.fromScale(1, 0.22)
			Frame.AnchorPoint = Vector2.new(0.5, 1)
			Frame.Position = UDim2.fromScale(0.5, 1.012)
			Frame.ZIndex = 3
			Frame.Parent = ScreenGui

			local function createTextLabel(p163, p164, p165, p166, p167)
				local TextLabel = Instance.new("TextLabel")

				TextLabel.BackgroundTransparency = 1
				TextLabel.Size = UDim2.fromScale(0.9, p163)
				TextLabel.Position = UDim2.fromScale(0.5, p164)
				TextLabel.AnchorPoint = Vector2.new(0.5, 0.5)
				TextLabel.Font = p165
				TextLabel.TextColor3 = p166
				TextLabel.TextScaled = true
				TextLabel.TextXAlignment = Enum.TextXAlignment.Center
				TextLabel.TextYAlignment = Enum.TextYAlignment.Center
				TextLabel.RichText = false
				TextLabel.TextTransparency = 1
				TextLabel.ZIndex = 4
				TextLabel.Parent = Frame

				local UITextSizeConstraint = Instance.new("UITextSizeConstraint")

				UITextSizeConstraint.MaxTextSize = p167
				UITextSizeConstraint.Parent = TextLabel

				return TextLabel
			end
			local function createUIStroke(p168, p169)
				local UIStroke = Instance.new("UIStroke")

				UIStroke.Color = Color3.new(0, 0, 0)
				UIStroke.Thickness = p169
				UIStroke.Transparency = 1
				UIStroke.Parent = p168

				return UIStroke
			end

			local v625 = createTextLabel(0.15, 0.1545454545454546, Enum.Font.GothamBlack, Color3.fromRGB(255, 255, 255), 26)
			local v626 = createUIStroke(v625, 2.5)
			local v627 = createTextLabel(0.16, 0.31454545454545457, Enum.Font.GothamMedium, Color3.fromRGB(245, 245, 250), 20)
			local v628 = createUIStroke(v627, 2.5)
			local v629 = createTextLabel(0.2, v599(0.34), Enum.Font.GothamBlack, Color3.fromRGB(255, 255, 255), 28)
			local v630 = createTextLabel(0.14, v599(0.74), Enum.Font.GothamMedium, Color3.fromRGB(200, 200, 215), 17)

			v630.RichText = true

			return {
				gui = ScreenGui,
				top = v617,
				bot = v618,
				vignette = t18,
				card = Frame,
				strokes = {
					v626,
					v628
				},
				texts = {
					v625,
					v627,
					v629,
					v630
				},
				lbl = {
					amt = v625,
					msg = v627,
					name = v629,
					info = v630
				}
			}
		end
		local function v631(p170)
			local tweenInfo = TweenInfo.new(1.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

			TweenService:Create(p170.top, tweenInfo, {
				Size = UDim2.fromScale(1, 0.12)
			}):Play()
			TweenService:Create(p170.bot, tweenInfo, {
				Size = UDim2.fromScale(1, 0.12)
			}):Play()

			for _, v in ipairs(p170.vignette) do
				TweenService:Create(v, tweenInfo, {
					BackgroundTransparency = 0
				}):Play()
			end

			task.delay(0.66, function()
				if not p170.gui.Parent then
					return
				end

				TweenService:Create(p170.card, TweenInfo.new(0.8, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
					Position = UDim2.fromScale(0.5, 1)
				}):Play()

				for i, text in ipairs(p170.texts) do
					TweenService:Create(text, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0.12 + i * 0.05), {
						TextTransparency = 0
					}):Play()
				end

				for _, stroke in ipairs(p170.strokes) do
					TweenService:Create(stroke, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0.17), {
						Transparency = 0
					}):Play()
				end
			end)
		end
		local function v639(p171)
			return (tostring(p171):gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;"))
		end
		local function v640(p172, p173)
			local lbl = p172.lbl

			lbl.name.Text = string.sub(tostring(p173.displayName or p173.username or "Someone"), 1, 24)
			lbl.amt.Text = v608(p173.amount) .. " ROBUX"
			lbl.info.Text = string.format("<font color=\"#8E8A99\">@%s</font>    <font color=\"#5E5A68\">·</font>    <font color=\"#A9A5B2\">TOTAL %s</font>", v639(string.sub(tostring(p173.username or "-"), 1, 24)), v608(p173.total))

			local message = p173.message
			local match = typeof(message) == "string" and message:gsub("%s+", " "):match("^%s*(.-)%s*$") or ""
			local msg = lbl.msg
			local text = match ~= "" and "\"" .. string.sub(match, 1, 80) .. "\""

			msg.Text = text or ""
			lbl.amt.Position = UDim2.fromScale(0.5, match ~= "" and 0.1545454545454546 or 0.31454545454545457)
		end
		local function v646(p174)
			local tweenInfo = TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.In)

			TweenService:Create(p174.top, tweenInfo, {
				Size = UDim2.fromScale(1, 0)
			}):Play()
			TweenService:Create(p174.bot, tweenInfo, {
				Size = UDim2.fromScale(1, 0)
			}):Play()
			TweenService:Create(p174.card, tweenInfo, {
				Position = UDim2.fromScale(0.5, 1.012)
			}):Play()

			for _, v in ipairs(p174.vignette) do
				TweenService:Create(v, tweenInfo, {
					BackgroundTransparency = 1
				}):Play()
			end

			for _, text in ipairs(p174.texts) do
				TweenService:Create(text, tweenInfo, {
					TextTransparency = 1
				}):Play()
			end

			for _, stroke in ipairs(p174.strokes) do
				TweenService:Create(stroke, tweenInfo, {
					Transparency = 1
				}):Play()
			end

			task.delay(0.5, function()
				p174.gui:Destroy()
			end)
		end
		local function v654()
			local DepthOfField = Lighting:FindFirstChild("DepthOfField")

			if not DepthOfField or not DepthOfField:IsA("DepthOfFieldEffect") then
				DepthOfField = Lighting:FindFirstChildOfClass("DepthOfFieldEffect")
			end

			if not DepthOfField then
				local function v656()
				end

				return v656
			end

			local t19 = {
				Enabled = DepthOfField.Enabled,
				FocusDistance = DepthOfField.FocusDistance,
				InFocusRadius = DepthOfField.InFocusRadius,
				NearIntensity = DepthOfField.NearIntensity,
				FarIntensity = DepthOfField.FarIntensity
			}

			DepthOfField.FocusDistance = math.sqrt(202.25)
			DepthOfField.InFocusRadius = 6
			DepthOfField.NearIntensity = 0
			DepthOfField.FarIntensity = 0
			DepthOfField.Enabled = true

			local tween = TweenService:Create(DepthOfField, TweenInfo.new(1.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				FarIntensity = 0.6
			})

			tween:Play()

			local function v659()
				pcall(function()
					tween:Cancel()
				end)

				for k, v in pairs(t19) do
					DepthOfField[k] = v
				end
			end

			return v659
		end
		local function v662()
			for _, child in ipairs(Lighting:GetChildren()) do
				if child.Name == "CenzRobuxCinematicGrade" then
					child:Destroy()
				end
			end

			local n6 = 0.12
			local n7 = 0.1
			local color32 = color3

			for _, child in ipairs(Lighting:GetChildren()) do
				if child:IsA("ColorCorrectionEffect") and child.Enabled and child.Name ~= "CenzRobuxCinematicGrade" then
					n6 = 0.06
					n7 = 0.05
					color32 = Color3.fromRGB(255, 252, 246)

					break
				end
			end

			local ColorCorrectionEffect = Instance.new("ColorCorrectionEffect")

			ColorCorrectionEffect.Name = "CenzRobuxCinematicGrade"
			ColorCorrectionEffect.Brightness = 0
			ColorCorrectionEffect.Contrast = 0
			ColorCorrectionEffect.Saturation = 0
			ColorCorrectionEffect.TintColor = Color3.new(1, 1, 1)
			ColorCorrectionEffect.Parent = Lighting

			local tween = TweenService:Create(ColorCorrectionEffect, TweenInfo.new(1.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				Contrast = n6,
				Saturation = n7,
				TintColor = color32
			})

			tween:Play()

			return function()
				pcall(function()
					tween:Cancel()
				end)

				if ColorCorrectionEffect.Parent then
					ColorCorrectionEffect:Destroy()
				end
			end
		end
		local function v672(p175)
			local t20 = {}

			local function v674(descendant)
				if descendant:IsA("ParticleEmitter") then
					if t20[descendant] == nil then
						t20[descendant] = descendant.ZOffset
						descendant.ZOffset -= 4
					end
				elseif descendant:IsA("Beam") and t20[descendant] == nil then
					t20[descendant] = descendant.ZOffset
					descendant.ZOffset -= 4
				end
			end

			for _, descendant in ipairs(p175:GetDescendants()) do
				v674(descendant)
			end

			local connection = p175.DescendantAdded:Connect(v674)

			return function()
				connection:Disconnect()

				for k, v in pairs(t20) do
					if k.Parent then
						k.ZOffset = v
					end
				end
			end
		end
		local function v680(p176)
			local playerByUserId = Players:GetPlayerByUserId(tonumber(p176.userId))
			local Character = playerByUserId and playerByUserId.Character
			local HumanoidRootPart = Character and (Character:FindFirstChild("HumanoidRootPart") or Character:FindFirstChild("Head"))

			if not HumanoidRootPart then
				return false
			end

			local CurrentCamera = Workspace.CurrentCamera

			if not CurrentCamera then
				return false
			end

			if not v600() then
				return false
			end

			v601()

			if type(_G.CenzDonateCinematicLock) ~= "table" or _G.CenzDonateCinematicLock.tag ~= "robux" then
				return false
			end

			local v685 = u597

			u597 = nil

			if not (CurrentCamera.CameraType ~= Enum.CameraType.Scriptable or v685) then
				return false
			end

			local savedType = v685 and v685.savedType or CurrentCamera.CameraType
			local savedSubject = v685 and v685.savedSubject or CurrentCamera.CameraSubject
			local homeOffset = v685 and v685.homeOffset or nil

			if not homeOffset then
				local Character2 = LocalPlayer.Character
				local HumanoidRootPart2 = Character2 and Character2:FindFirstChild("HumanoidRootPart")

				if HumanoidRootPart2 then
					homeOffset = HumanoidRootPart2.CFrame:ToObjectSpace(CurrentCamera.CFrame)
				end
			end

			local t21 = {}

			local function v692(p177)
				table.insert(t21, p177)
			end

			local v693 = v672(Character)

			v692(v693)

			if t17 then
				v640(t17.ov, p176)
			else
				local v694 = v609()

				v640(v694, p176)
				v631(v694)
				t17 = {
					ov = v694,
					restoreDOF = v654(),
					restoreGrade = v662()
				}
			end

			v692(function()
				if #t16 > 0 then
					return
				end

				local v695 = t17

				t17 = nil
				pcall(v695.restoreGrade)
				pcall(v695.restoreDOF)
				pcall(function()
					v646(v695.ov)
				end)
			end)

			local v696 = math.random() < 0.5 and -1 or 1
			local v697 = HumanoidRootPart.CFrame.LookVector * Vector3.new(1, 0, 1)
			local vector3 = v697.Magnitude < 0.01 and Vector3.new(0, 0, 1) or v697.Unit
			local u699

			local function v700(p178)
				if not HumanoidRootPart.Parent then
					return nil
				end

				local v701 = HumanoidRootPart.Position + Vector3.new(0, 1.5, 0)

				u699 = u699 and u699:Lerp(v701, 0.2) or v701

				local v702 = vector3 * 14

				return CFrame.lookAt(u699 + CFrame.Angles(0, math.rad(p178), 0) * v702 + Vector3.new(0, 2.5, 0), u699)
			end
			local function v703()
				return v696 * -35
			end
			local function v704()
				local Character2 = LocalPlayer.Character
				local HumanoidRootPart2 = Character2 and Character2:FindFirstChild("HumanoidRootPart")

				if HumanoidRootPart2 and homeOffset then
					return HumanoidRootPart2.CFrame * homeOffset
				end

				return nil
			end

			local s3 = "in"
			local now = os.clock()
			local CFrame_ = CurrentCamera.CFrame
			local CFrame_2 = CFrame_
			local u711 = false

			local function v712()
				if u711 then
					return
				end

				u711 = true

				for i = #t21, 1, -1 do
					pcall(t21[i])
				end

				u593 = nil
				u592 = false

				if v594 then
					task.defer(v594)
				end
			end

			v692(function()
				if #t16 > 0 then
					u597 = {
						savedType = savedType,
						savedSubject = savedSubject,
						homeOffset = homeOffset
					}

					return
				end

				CurrentCamera.CameraType = savedType

				if savedSubject then
					CurrentCamera.CameraSubject = savedSubject
				end
			end)
			CurrentCamera.CameraType = Enum.CameraType.Scriptable
			v692(function()
				RunService:UnbindFromRenderStep("CenzRobuxCameraFocus")
			end)
			u593 = v712
			task.delay(8.4, v712)
			RunService:BindToRenderStep("CenzRobuxCameraFocus", Enum.RenderPriority.Camera.Value - 1, function()
				local now2 = os.clock()

				if s3 == "in" then
					local v715 = v700(v703())

					if not v715 then
						s3 = "out"
						now = now2
						CFrame_2 = CurrentCamera.CFrame

						return
					end

					local v716 = math.clamp((now2 - now) / math.max(1.2, 0.01), 0, 1)

					CurrentCamera.CFrame = CFrame_:Lerp(v715, TweenService:GetValue(v716, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut))

					if v716 >= 1 then
						s3 = "hold"
						now = now2
					end
				elseif s3 == "hold" then
					local v717 = math.clamp((now2 - now) / math.max(3, 0.01), 0, 1)
					local v718 = v700(v696 * (-35 + 70 * TweenService:GetValue(v717, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)))

					if v718 then
						CurrentCamera.CFrame = v718
					end

					if not v718 or v717 >= 1 then
						s3 = "out"
						now = now2
						CFrame_2 = CurrentCamera.CFrame
					end
				else
					if #t16 > 0 then
						v712()

						return
					end

					local v719 = math.clamp((now2 - now) / math.max(1.2, 0.01), 0, 1)
					local v720 = v704()

					if v720 then
						CurrentCamera.CFrame = CFrame_2:Lerp(v720, TweenService:GetValue(v719, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut))
					end

					if v719 >= 1 or not v720 then
						v712()
					end
				end
			end)

			return true
		end

		v594 = function()
			if u592 then
				return
			end

			while #t16 > 0 do
				local v721 = table.remove(t16, 1)

				if os.clock() - v721.at <= 45 and not v603() then
					if v600() then
						u592 = true
						task.spawn(function()
							local ok, result = pcall(v680, v721.payload)

							if ok then
								if result == false then
									u592 = false
									task.defer(v594)
								end
							else
								if u593 then
									pcall(u593)
								end

								pcall(function()
									RunService:UnbindFromRenderStep("CenzRobuxCameraFocus")
								end)

								local CurrentCamera = Workspace.CurrentCamera

								if CurrentCamera and CurrentCamera.CameraType == Enum.CameraType.Scriptable then
									CurrentCamera.CameraType = Enum.CameraType.Custom
								end

								for _, child in ipairs(Lighting:GetChildren()) do
									if child.Name == "CenzRobuxCinematicGrade" then
										pcall(function()
											child:Destroy()
										end)
									end
								end

								u593 = nil
								u592 = false
								warn("CENZ STUDIO - camera focus failed: " .. tostring(result))
								task.defer(v594)
							end
						end)

						return
					end

					table.insert(t16, 1, v721)
					task.delay(0.5, v594)

					return
				end
			end

			if u597 then
				local v727 = u597

				u597 = nil

				local CurrentCamera = Workspace.CurrentCamera

				if CurrentCamera then
					CurrentCamera.CameraType = v727.savedType

					if v727.savedSubject then
						CurrentCamera.CameraSubject = v727.savedSubject
					end
				end
			end

			if t17 then
				local v729 = t17

				t17 = nil
				pcall(v729.restoreGrade)
				pcall(v729.restoreDOF)
				pcall(function()
					v646(v729.ov)
				end)
			end

			v602()
		end
		CenzRobuxAnnounce.OnClientEvent:Connect(function(p179)
			if type(p179) ~= "table" then
				return
			end

			if v590("CinematicRobuxEnabled", true) == false then
				return
			end

			if v603() then
				return
			end

			if (tonumber(p179.amount) or 0) < (tonumber(v590("CinematicRobuxMinAmount", 1)) or 1) then
				return
			end

			if not v604(p179) then
				return
			end

			table.insert(t16, {
				payload = p179,
				at = os.clock()
			})

			while #t16 > 4 do
				table.remove(t16, 1)
			end

			v594()
		end)
		print("CENZ STUDIO DONATE ROBUX CAMERA CLIENT ACTIVE")
	end

	v580(script, v24)
end)
task.spawn(function()
	local function v730(p180, p181)
		local Players = game:GetService("Players")

		local function v732(p182, p183)
			local v733

			repeat
				v733 = p182:WaitForChild(p183, 20)
			until v733

			return v733
		end

		local v734 = p181(v732(v732(game:GetService("ReplicatedStorage"), "CenzDonateRobuxRS"), "CenzDonateRobuxConfig"))

		local function v735(p184, p185)
			local v736 = v734[p184]

			if v736 == nil then
				return p185
			end

			return v736
		end
		local function v737(p186)
			local n8 = 0

			for _, descendant in ipairs(p186:GetDescendants()) do
				if descendant:IsA("AnimationConstraint") then
					local Attachment0 = descendant.Attachment0
					local Attachment1 = descendant.Attachment1

					if Attachment0 and Attachment1 and Attachment0.Parent and Attachment1.Parent then
						local Motor6D = Instance.new("Motor6D")

						Motor6D.Name = descendant.Name
						Motor6D.Part0 = Attachment0.Parent
						Motor6D.Part1 = Attachment1.Parent
						Motor6D.C0 = Attachment0.CFrame
						Motor6D.C1 = Attachment1.CFrame
						Motor6D.Parent = Attachment0.Parent
						n8 += 1
					end
				end
			end

			if n8 == 0 then
				return 0
			end

			for _, descendant in ipairs(p186:GetDescendants()) do
				if descendant:IsA("AnimationConstraint") or descendant:IsA("BallSocketConstraint") then
					descendant:Destroy()
				end
			end

			return n8
		end

		local t22 = {}

		local function v747(p187)
			local v748 = t22[p187]

			if v748 ~= nil then
				return v748 or nil
			end

			local ok, result = pcall(Players.GetHumanoidDescriptionFromUserId, Players, p187)

			t22[p187] = ok and result or false

			return ok and result or nil
		end

		local t23 = {}

		t23.__index = t23
		t23._clearRig = function(p188)
			if p188.rig then
				p188.rig:Destroy()
				p188.rig = nil
			end

			p188.vp.Visible = false

			if p188.img then
				p188.img.Visible = true
			end
		end
		t23._frame = function(p189, p190, p191, p192, p193)
			local huge = math.huge
			local v753 = -math.huge
			local v754 = -math.huge
			local now = os.clock()

			while os.clock() - now < p193 do
				local v756 = p192.Position.Y - p191.Position.Y

				if v756 < huge then
					huge = v756
				end

				if v753 < v756 then
					v753 = v756
				end

				local boundingBox, v758 = p190:GetBoundingBox()
				local v759 = boundingBox.Position.Y + v758.Y / 2 - p191.Position.Y

				if v754 < v759 then
					v754 = v759
				end

				task.wait()
			end

			if huge == math.huge then
				return
			end

			local v760 = math.clamp(v754 + 0.35, v753 + 1.2, v753 + 2.8)
			local v761 = (huge + v753) / 2 - 2.35
			local v762 = (v760 - v761) / math.max(1, 0.05)
			local v763 = v762 / (2 * math.tan(math.rad(20) / 2))
			local v764 = p191.Position + Vector3.new(0, (v760 + v761) / 2 - 0 * v762, 0)

			p189.cam.CFrame = CFrame.new(v764 + Vector3.new(0, 0, -v763), v764)
		end
		t23.Build = function(p194, p195)
			p194.token += 1

			local token = p194.token

			p194:_clearRig()

			local v766 = v747(p195)

			if not v766 or token ~= p194.token then
				return
			end

			local ok, rig = pcall(Players.CreateHumanoidModelFromDescription, Players, v766, Enum.HumanoidRigType.R15)

			if not ok or not rig or token ~= p194.token then
				if rig then
					rig:Destroy()
				end

				return
			end

			for _, descendant in ipairs(rig:GetDescendants()) do
				if descendant:IsA("LuaSourceContainer") then
					descendant:Destroy()
				end
			end

			v737(rig)

			local HumanoidRootPart = rig:FindFirstChild("HumanoidRootPart")
			local Head = rig:FindFirstChild("Head")
			local Humanoid = rig:FindFirstChildOfClass("Humanoid")

			if HumanoidRootPart and Head then
				if Humanoid then
					HumanoidRootPart.Anchored = true
					rig.Parent = p194.wm
					rig:PivotTo(CFrame.new(0, 0, 0))
					p194.rig = rig

					local Animator = Humanoid:FindFirstChildOfClass("Animator")

					if not Animator then
						Animator = Instance.new("Animator")
						Animator.Parent = Humanoid
					end

					for _, v in ipairs(Animator:GetPlayingAnimationTracks()) do
						pcall(function()
							v:Stop(0)
						end)
					end

					local Animation = Instance.new("Animation")

					Animation.AnimationId = tostring(v735("PodiumRobuxAnimationR15", "rbxassetid://83401591245918"))

					local ok2, result = pcall(function()
						return Animator:LoadAnimation(Animation)
					end)
					local n9 = 2.2

					if ok2 and result then
						local n10 = 0

						while result.Length <= 0 and n10 < 5 do
							task.wait(0.05)
							n10 += 0.05
						end

						if token ~= p194.token then
							return
						end

						result.Looped = true
						result.Priority = Enum.AnimationPriority.Action
						result:Play(0)

						if result.Length > 0 then
							n9 = math.min(result.Length + 0.2, 4)
						end
					end

					p194:_frame(rig, HumanoidRootPart, Head, n9)

					if token ~= p194.token then
						return
					end

					p194.vp.Visible = true

					if p194.img then
						p194.img.Visible = false
					end

					return
				end
			end

			rig:Destroy()
		end
		t23.Sync = function(p196)
			local uid = tonumber(p196.gui:GetAttribute("CenzUserId"))

			if uid == p196.uid then
				return
			end

			p196.uid = uid

			if uid and not (uid <= 0) then
				task.spawn(function()
					p196:Build(uid)
				end)

				return
			end

			p196:_clearRig()
		end

		local function v783(p197, p198, p199, p200)
			local LocalPlayer = Players.LocalPlayer
			local SurfaceGui = Instance.new("SurfaceGui")

			SurfaceGui.Name = "CenzRobuxTopAvatar_" .. p197.Name
			SurfaceGui.Adornee = p197
			SurfaceGui.Face = Enum.NormalId.Front
			SurfaceGui.SizingMode = Enum.SurfaceGuiSizingMode.FixedSize
			SurfaceGui.ClipsDescendants = true
			SurfaceGui.LightInfluence = 0
			SurfaceGui.MaxDistance = 360

			local function v786()
				local Size = p197.Size

				if Size.Y <= 0 then
					return
				end

				SurfaceGui.CanvasSize = Vector2.new(750 * (Size.X / Size.Y), 750)
			end

			v786()
			p197:GetPropertyChangedSignal("Size"):Connect(v786)
			SurfaceGui.ResetOnSpawn = false
			SurfaceGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
			p199.Parent = SurfaceGui

			local ViewportFrame = Instance.new("ViewportFrame")

			ViewportFrame.Name = "AvatarVP"
			ViewportFrame.BackgroundTransparency = 1
			ViewportFrame.Size = UDim2.fromScale(1, 1)
			ViewportFrame.Position = UDim2.fromScale(0.5, 0.5)
			ViewportFrame.AnchorPoint = Vector2.new(0.5, 0.5)
			ViewportFrame.ZIndex = 1
			ViewportFrame.Visible = false
			ViewportFrame.Ambient = Color3.fromRGB(190, 195, 210)
			ViewportFrame.LightColor = Color3.fromRGB(255, 252, 245)
			ViewportFrame.LightDirection = Vector3.new(-0.3, -0.6, -1)
			ViewportFrame.Parent = p199

			local WorldModel = Instance.new("WorldModel")

			WorldModel.Parent = ViewportFrame

			local Camera = Instance.new("Camera")

			Camera.FieldOfView = 20
			Camera.Parent = ViewportFrame
			ViewportFrame.CurrentCamera = Camera

			return setmetatable({
				part = p197,
				gui = p198,
				root = p199,
				img = p200,
				sg = SurfaceGui,
				vp = ViewportFrame,
				wm = WorldModel,
				cam = Camera,
				uid = nil,
				rig = nil,
				token = 0
			}, t23)
		end

		local cenzDonateRobuxArea = v732(workspace, "CenzDonateRobuxArea")

		if not cenzDonateRobuxArea then
			return
		end

		local t24 = {}

		Players.PlayerAdded:Connect(function(player)
			player.CharacterAppearanceLoaded:Once(function()
				local UserId = player.UserId

				t22[UserId] = nil

				for _, v in ipairs(t24) do
					if v.uid == UserId then
						v.uid = nil
						v:Sync()
					end
				end
			end)
		end)

		for i = 1, 3 do
			task.spawn(function()
				local v797 = cenzDonateRobuxArea:WaitForChild("CenzRobuxTop" .. i, 60)

				if v797 then
					if v797:IsA("BasePart") then
						local CenzRobuxTopSpotlight = v797:WaitForChild("CenzRobuxTopSpotlight", 90)

						if not CenzRobuxTopSpotlight then
							return
						end

						local Root = CenzRobuxTopSpotlight:WaitForChild("Root", 30)

						if not Root then
							return
						end

						local Avatar = Root:FindFirstChild("Avatar")

						task.wait(0.5 * (i - 1))

						local v801 = v783(v797, CenzRobuxTopSpotlight, Root, Avatar)

						table.insert(t24, v801)
						CenzRobuxTopSpotlight:GetAttributeChangedSignal("CenzUserId"):Connect(function()
							v801:Sync()
						end)
						v801:Sync()

						return
					end
				end
			end)
		end

		print("CENZ STUDIO DONATE ROBUX TOP AVATAR CLIENT ACTIVE")
	end

	v730(script, v24)
end)
task.spawn(function()
	local function v802(p201, p202)
		local v803 = p202(game:GetService("ReplicatedStorage").CenzDonateRobuxRS.CenzDonateRobuxConfig)
		local ReplicatedStorage2 = game:GetService("ReplicatedStorage")
		local LocalPlayer = game.Players.LocalPlayer
		local TweenService = game:GetService("TweenService")
		local v807 = p202(v20("CameraShaker"))
		local NukeRobuxTargetPosition = v803.NukeRobuxTargetPosition

		local function v809(p203, p204)
			p203.Speed = NumberRange.new(p203.Speed.Min * p204, p203.Speed.Max * p204)
			p203.Acceleration *= p204

			local Keypoints = p203.Size.Keypoints
			local t25 = {}

			for i = 1, #Keypoints do
				table.insert(t25, NumberSequenceKeypoint.new(Keypoints[i].Time, Keypoints[i].Value * p204, Keypoints[i].Envelope * p204))
			end

			p203.Size = NumberSequence.new(t25)
		end

		local RunService = game:GetService("RunService")

		local function v814(p205, p206, p207, p208)
			local clone = p205:Clone()
			local NukeCFrame = clone.NukeValues.NukeCFrame
			local Frame = clone.BillboardGuiAnimation.Frame

			Frame.TextLabels.TopText.Visible = true
			Frame.TextLabels.BottomText.Visible = true

			local CenterEmitPoint = clone.CenterEmitPoint
			local ThrustEmitPoint = clone.ThrustEmitPoint
			local BloomEffect = Instance.new("BloomEffect")

			BloomEffect.Enabled = true
			BloomEffect.Name = "NukeBloom"
			BloomEffect.Size = 15
			BloomEffect.Threshold = 0.25
			BloomEffect.Intensity = -1
			BloomEffect.Parent = game.Lighting

			local Objects = clone.Objects
			local clone2 = Objects.ConfettiBox:Clone()

			Objects.ConfettiBox:Destroy()
			Objects:Destroy()

			local v823 = v807.new(Enum.RenderPriority.Camera.Value, function(p209)
				workspace.CurrentCamera.CFrame *= p209
			end)

			v823:Start()
			clone.Position = NukeRobuxTargetPosition
			v809(ThrustEmitPoint.Flame, 5)
			v809(ThrustEmitPoint.Shockwave, 15)
			v809(ThrustEmitPoint.BigShockwave, 50)
			v809(ThrustEmitPoint.Flame2, 5)
			v809(ThrustEmitPoint.Flame3, 5)
			v809(ThrustEmitPoint.Flame4, 5)
			v809(ThrustEmitPoint.Flame5, 10)
			v809(ThrustEmitPoint.Smoke, 1.5)
			v809(ThrustEmitPoint.SmokePreLaunch, 3)
			v809(ThrustEmitPoint.SmokeLaunch, 4)
			v809(ThrustEmitPoint.SmokeRing, 4)
			v809(clone.Sparkles, 2.5)
			v809(clone.Sparks, 3)
			v809(CenterEmitPoint.Rays1, 25)
			v809(CenterEmitPoint.Rays2, 25)
			v809(CenterEmitPoint.Rays3, 25)
			v809(CenterEmitPoint.SmoothRaysBig, 7.5)
			v809(CenterEmitPoint.RaysBig, 8)
			v809(CenterEmitPoint.SparkleExplosion, 4)
			v809(CenterEmitPoint.Spark3, 25)
			clone.CFrame = CFrame.new(v803.NukeRobuxSpawnPosition)
			clone.AlignPosition.Position = clone.Position
			clone.AlignOrientation.CFrame = clone.CFrame
			NukeCFrame.Value = clone.CFrame
			clone.Anchored = false
			clone.Parent = workspace

			local connection = RunService.Heartbeat:Connect(function()
				clone.AlignPosition.Position = NukeCFrame.Value.Position
				clone.AlignOrientation.CFrame = NukeCFrame.Value
			end)

			wait(1)
			p201.Alarm:Play()
			clone.Sparkles.Enabled = false
			clone.ThrustEmitPoint.SmokePreLaunch.Enabled = true
			clone.ThrustEmitPoint.SmokePreLaunch.Rate = 0
			clone.PreThruster:Play()
			clone.PreThruster.Volume = 0
			clone.PreThruster.PlaybackSpeed = 0.1
			TweenService:Create(clone.PreThruster, TweenInfo.new(5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0), {
				Volume = 1,
				PlaybackSpeed = 0.5
			}):Play()
			TweenService:Create(clone.ThrustEmitPoint.SmokePreLaunch, TweenInfo.new(2.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0), {
				Rate = 100
			}):Play()
			wait(5)
			v823:ShakeSustain(v807.Presets.Earthquake)
			clone.Sparkles.Enabled = true
			clone.ThrustEmitPoint.SmokePreLaunch.Enabled = false
			ThrustEmitPoint.SmokeLaunch:Emit(50)
			clone.AlignPosition.Responsiveness = 25
			clone.AlignOrientation.Responsiveness = 25
			clone.PreLaunch:Play()
			clone.Thruster2:Play()
			TweenService:Create(clone.Thruster2, TweenInfo.new(4, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, 0, false, 0), {
				PlaybackSpeed = 1.5,
				Volume = 3
			}):Play()
			TweenService:Create(clone.PreThruster, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0), {
				Volume = 1,
				PlaybackSpeed = 1
			}):Play()

			for _, child in pairs(ThrustEmitPoint:GetChildren()) do
				if string.find(child.Name, "Flame") == nil then
					child.Enabled = true
				end
			end

			ThrustEmitPoint.SmokeRing.Enabled = false
			ThrustEmitPoint.SmokeLaunch.Enabled = false
			ThrustEmitPoint.Shockwave.Enabled = false
			ThrustEmitPoint.BigShockwave.Enabled = false
			ThrustEmitPoint.Flare.Enabled = false
			CenterEmitPoint.Rays1.Enabled = true
			CenterEmitPoint.Rays2.Enabled = true
			CenterEmitPoint.Rays3.Enabled = true

			for i = 1, 10 do
				NukeCFrame.Value = NukeCFrame.Value:ToWorldSpace(CFrame.Angles(0, 0, 0.17453292519943295))
				NukeCFrame.Value = NukeCFrame.Value:ToWorldSpace(CFrame.new(0, 25, 0))
				wait(i * 0.0125)
			end

			clone.AlignPosition.Responsiveness = 10
			clone.AlignOrientation.Responsiveness = 10
			NukeCFrame.Value = CFrame.new(NukeCFrame.Value.Position, NukeRobuxTargetPosition):ToWorldSpace(CFrame.Angles(-1.5707963267948966, 0, 0))
			wait(0.5)
			BloomEffect.Intensity = 1
			BloomEffect.Size = 20
			TweenService:Create(BloomEffect, TweenInfo.new(1, Enum.EasingStyle.Circular, Enum.EasingDirection.Out, 0, false, 0), {
				Intensity = -1,
				Size = 10
			}):Play()
			clone.AlignPosition.Responsiveness = 50
			clone.AlignOrientation.Responsiveness = 50
			ThrustEmitPoint.SmokeRing:Emit(50)
			ThrustEmitPoint.Flame:Emit(25)
			ThrustEmitPoint.Flame2:Emit(25)
			ThrustEmitPoint.Flame3:Emit(25)
			ThrustEmitPoint.Flame4:Emit(25)
			ThrustEmitPoint.Flame5:Emit(25)
			ThrustEmitPoint.Shockwave.Enabled = true
			ThrustEmitPoint.BigShockwave:Emit(1)
			clone.Launch:Play()
			clone.Thruster:Play()

			for _, child in pairs(ThrustEmitPoint:GetChildren()) do
				child.Enabled = true
			end

			ThrustEmitPoint.SmokeRing.Enabled = false
			ThrustEmitPoint.SmokeLaunch.Enabled = false
			ThrustEmitPoint.BigShockwave.Enabled = false
			ThrustEmitPoint.Flare:Emit(10)
			TweenService:Create(NukeCFrame, TweenInfo.new(2.5, Enum.EasingStyle.Back, Enum.EasingDirection.In, 0, false, 0), {
				Value = CFrame.new(NukeRobuxTargetPosition + Vector3.new(0, -1, 0), NukeRobuxTargetPosition):ToWorldSpace(CFrame.Angles(1.5707963267948966, 0, 0))
			}):Play()
			wait(2.6)
			v823:StopSustained(0)
			v823:ShakeOnce(4, 6, 0.25, 4)
			p201.Alarm:Stop()
			BloomEffect.Intensity = 1
			BloomEffect.Size = 30
			TweenService:Create(BloomEffect, TweenInfo.new(5, Enum.EasingStyle.Circular, Enum.EasingDirection.Out, 0, false, 0), {
				Intensity = -1,
				Size = 10
			}):Play()
			clone.Anchored = true
			clone.Transparency = 1
			clone.Size = Vector3.new(0, 0, 0)
			clone.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
			clone.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
			clone.CFrame = NukeCFrame.Value
			clone.PreThruster:Stop()
			clone.Thruster:Stop()
			clone.Thruster2:Stop()
			clone.Explosion.TimePosition = 0.75
			clone.Explosion:Play()
			clone.ChimeLoop:Play()
			clone.ApplauseLoop:Play()
			clone.CoinsLoop:Play()

			local function v830(p210)
				return p210
			end

			Frame.TextLabels.TopText.Text = "@" .. v830(p206) .. " DONATED"
			Frame.TextLabels.MiddleText.Text = "\u{E002}" .. tostring(p208):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")
			Frame.TextLabels.BottomText.Text = "TO @" .. v830(p207)
			Frame.RobuxLogo.Size = UDim2.fromScale(0, 0)
			Frame.RobuxLogo.Rotation = -180
			Frame.Star.Size = UDim2.fromScale(0, 0)
			Frame.TextLabels.BottomText.Size = UDim2.fromScale(0, 0)
			Frame.TextLabels.BottomText.Position = UDim2.fromScale(0.5, 0.5)
			Frame.TextLabels.MiddleText.Size = UDim2.fromScale(0, 0)
			Frame.TextLabels.TopText.Position = UDim2.fromScale(0.5, 0.5)
			Frame.TextLabels.TopText.Size = UDim2.fromScale(0, 0)
			Frame.Parent.Enabled = true
			TweenService:Create(clone, TweenInfo.new(20, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0), {
				Position = NukeRobuxTargetPosition + Vector3.new(0, 250, 0)
			}):Play()
			TweenService:Create(Frame.RobuxLogo, TweenInfo.new(10, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out, 0, false, 0), {
				Size = UDim2.fromScale(1, 1)
			}):Play()
			TweenService:Create(Frame.RobuxLogo, TweenInfo.new(15, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out, 0, false, 0), {
				Rotation = 0
			}):Play()
			TweenService:Create(Frame.Star, TweenInfo.new(5, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out, 0, false, 0), {
				Size = UDim2.fromScale(1.5, 1.5)
			}):Play()
			TweenService:Create(Frame.Star, TweenInfo.new(15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0), {
				Rotation = 360
			}):Play()
			TweenService:Create(Frame.Star, TweenInfo.new(10, Enum.EasingStyle.Quad, Enum.EasingDirection.In, 0, false, 5), {
				ImageTransparency = 1,
				ImageColor3 = Color3.fromRGB(255, 255, 0)
			}):Play()

			for _, child in pairs(ThrustEmitPoint:GetChildren()) do
				child.Enabled = false
			end

			clone.Sparkles.Enabled = false

			for _, child in pairs(CenterEmitPoint:GetChildren()) do
				child.Enabled = false
			end

			CenterEmitPoint.SparkleExplosion:Emit(100)
			CenterEmitPoint.Shockwave:Emit(15)
			CenterEmitPoint.FractalBurst:Emit(3)
			CenterEmitPoint.RaysBig:Emit(20)
			CenterEmitPoint.Spark1:Emit(100)
			CenterEmitPoint.Spark2:Emit(100)
			CenterEmitPoint.Spark3:Emit(50)

			local clone3 = clone2:Clone()

			clone3.Position = NukeRobuxTargetPosition + Vector3.new(0, 250, 0)
			clone3.Parent = workspace
			TweenService:Create(clone3, TweenInfo.new(10, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0), {
				Size = Vector3.new(1000, 100, 1000)
			}):Play()
			spawn(function()
				local children = clone3:GetChildren()

				for _, child in pairs(children) do
					if child:IsA("ParticleEmitter") then
						child.Enabled = true
					end
				end

				wait(60)

				for _, child in pairs(children) do
					if child:IsA("ParticleEmitter") then
						TweenService:Create(child, TweenInfo.new(60, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0), {
							Rate = 0
						}):Play()
					end
				end

				wait(60)
				clone3.Size = Vector3.new(0, 0, 0)
				wait(30)
				clone3:Destroy()
			end)
			clone.Sparks.Enabled = true
			CenterEmitPoint.SparkleExplosion.Enabled = true
			TweenService:Create(clone.Sparks, TweenInfo.new(45, Enum.EasingStyle.Quint, Enum.EasingDirection.In, 0, false, 0), {
				Rate = 0
			}):Play()
			TweenService:Create(CenterEmitPoint.SparkleExplosion, TweenInfo.new(45, Enum.EasingStyle.Quint, Enum.EasingDirection.In, 0, false, 0), {
				Rate = 0
			}):Play()
			TweenService:Create(clone.ChimeLoop, TweenInfo.new(55, Enum.EasingStyle.Quad, Enum.EasingDirection.In, 0, false, 0), {
				Volume = 0,
				PlaybackSpeed = 0.75
			}):Play()
			TweenService:Create(clone.ApplauseLoop, TweenInfo.new(60, Enum.EasingStyle.Quad, Enum.EasingDirection.In, 0, false, 0), {
				Volume = 0
			}):Play()
			TweenService:Create(clone.CoinsLoop, TweenInfo.new(50, Enum.EasingStyle.Quad, Enum.EasingDirection.In, 0, false, 0), {
				Volume = 0,
				PlaybackSpeed = 1
			}):Play()
			wait(30)
			TweenService:Create(Frame.UIScale, TweenInfo.new(15, Enum.EasingStyle.Quad, Enum.EasingDirection.In, 0, false, 0), {
				Scale = 0
			}):Play()
			wait(15)
			Frame.Parent.Enabled = false
			wait(30)
			v823:Stop()
			BloomEffect:Destroy()
			connection:Disconnect()
			clone:Destroy()
			clone3:Destroy()
		end
		local function v841()
			if LocalPlayer:GetAttribute("CenzHideDonateVFX") == true then
				return true
			end

			if _G.CenzHideDonateVFX == true then
				return true
			end

			if LocalPlayer:GetAttribute("GlobalEffects") == false then
				return true
			end

			return false
		end

		p202(ReplicatedStorage2.CenzDonateRobuxRS.CenzDonateRobuxModules.CenzDonateRobuxJPass).OnClientEvent("CenzFireNuke"):Connect(function(p211, p212, p213)
			if not v841() then
				v814(ReplicatedStorage2.CenzDonateRobuxRS.CenzDonateRobuxVFX.MoonVFXAssets.Nuke, p211, p212, p213)
			end
		end)
	end

	v802(script, v24)
end)
task.spawn(function()
	local function v842(p214, p215)
		local v843 = p215(game:GetService("ReplicatedStorage").CenzDonateRobuxRS.CenzDonateRobuxConfig)

		wait(5)

		local ReplicatedStorage2 = game:GetService("ReplicatedStorage")
		local Players = game:GetService("Players")
		local RunService = game:GetService("RunService")
		local TweenService = game:GetService("TweenService")

		local function v848(p216, p217)
			p216.Speed = NumberRange.new(p216.Speed.Min * p217, p216.Speed.Max * p217)
			p216.Acceleration *= p217

			local Keypoints = p216.Size.Keypoints
			local t26 = {}

			for i = 1, #Keypoints do
				table.insert(t26, NumberSequenceKeypoint.new(Keypoints[i].Time, Keypoints[i].Value * p217, Keypoints[i].Envelope * p217))
			end

			p216.Size = NumberSequence.new(t26)
		end

		local v852 = p215(v20("CameraShaker"))
		local GiantRobuxTargetPosition = v843.GiantRobuxTargetPosition

		local function v854(p218, p219, p220)
			if not p220 then
				local humanoidDescriptionFromUserId = game.Players:GetHumanoidDescriptionFromUserId(p218)

				humanoidDescriptionFromUserId.DepthScale *= 53
				humanoidDescriptionFromUserId.HeadScale *= 53
				humanoidDescriptionFromUserId.HeightScale *= 53
				humanoidDescriptionFromUserId.WidthScale *= 53
				p219.Humanoid:ApplyDescription(humanoidDescriptionFromUserId)
			end

			for _, descendant in pairs(p219:GetDescendants()) do
				if descendant:IsA("BasePart") then
					descendant.CanCollide = false
					descendant.CanQuery = false
					descendant.CanTouch = false
					descendant.Massless = true

					if descendant.Name ~= "HumanoidRootPart" then
						descendant.Transparency = 1
					end
				elseif descendant:IsA("Decal") and descendant.Name ~= "HumanoidRootPart" then
					descendant.Transparency = 1
				end
			end
		end

		local t27 = {
			HumanoidRootPart = true,
			Head = true,
			UpperTorso = true,
			LowerTorso = true,
			LeftUpperArm = true,
			LeftLowerArm = true,
			LeftHand = true,
			RightUpperArm = true,
			RightLowerArm = true,
			RightHand = true,
			LeftUpperLeg = true,
			LeftLowerLeg = true,
			LeftFoot = true,
			RightUpperLeg = true,
			RightLowerLeg = true,
			RightFoot = true
		}

		local function v859(p221)
			return t27[p221.Name] or p221:IsA("Humanoid") or p221:IsA("Accessory") or p221:IsA("Shirt") or p221:IsA("Pants") or p221:IsA("ShirtGraphic") or p221:IsA("BodyColors") or p221:IsA("CharacterMesh") or p221.Name == "Animate"
		end
		local function v860(p222)
			local ok, result = pcall(function()
				return Players:CreateHumanoidModelFromDescription(Players:GetHumanoidDescriptionFromUserId(p222), Enum.HumanoidRigType.R15)
			end)

			if ok then
				if result then
					return result
				end
			end

			local ok2, result2 = pcall(function()
				return Players:CreateHumanoidModelFromUserId(p222)
			end)

			if ok2 and result2 then
				local Humanoid = result2:FindFirstChildOfClass("Humanoid")

				if Humanoid and Humanoid.RigType == Enum.HumanoidRigType.R15 then
					return result2
				end

				result2:Destroy()
			end

			return nil
		end
		local function v866(p223)
			local n11 = 0

			for _, descendant in ipairs(p223:GetDescendants()) do
				if descendant:IsA("AnimationConstraint") then
					local Attachment0 = descendant.Attachment0
					local Attachment1 = descendant.Attachment1

					if Attachment0 and Attachment1 and Attachment0.Parent and Attachment1.Parent then
						local Motor6D = Instance.new("Motor6D")

						Motor6D.Name = descendant.Name
						Motor6D.Part0 = Attachment0.Parent
						Motor6D.Part1 = Attachment1.Parent
						Motor6D.C0 = Attachment0.CFrame
						Motor6D.C1 = Attachment1.CFrame
						Motor6D.Parent = Attachment0.Parent
						n11 += 1
					end
				end
			end

			if n11 == 0 then
				return 0
			end

			for _, descendant in ipairs(p223:GetDescendants()) do
				if descendant:IsA("AnimationConstraint") or descendant:IsA("BallSocketConstraint") then
					descendant:Destroy()
				end
			end

			return n11
		end
		local function v875(p224, p225)
			local v876 = v860(p225)

			if not v876 then
				warn("[CenzSmite] gagal membangun avatar asli, pakai ApplyDescription (pakaian klasik saja)")

				return nil
			end

			v866(v876)

			local ok = pcall(function()
				v876:ScaleTo(35)
			end)
			local HumanoidRootPart = v876:FindFirstChild("HumanoidRootPart")

			if not ok or not HumanoidRootPart then
				warn("[CenzSmite] avatar asli gagal diskalakan, pakai ApplyDescription")
				v876:Destroy()

				return nil
			end

			local HumanoidRootPart2 = p224:FindFirstChild("HumanoidRootPart")

			if HumanoidRootPart2 then
				HumanoidRootPart.Anchored = HumanoidRootPart2.Anchored
				HumanoidRootPart.CFrame = HumanoidRootPart2.CFrame
			else
				HumanoidRootPart.Anchored = true
			end

			local Head = p224:FindFirstChild("Head")
			local Head2 = v876:FindFirstChild("Head")

			if Head and Head2 then
				for _, v in ipairs({
					"LeftEyeAttachment",
					"RightEyeAttachment"
				}) do
					local v884 = Head:FindFirstChild(v)

					if v884 then
						v884.Parent = Head2
					end
				end
			end

			for _, child in ipairs(p224:GetChildren()) do
				if not v859(child) then
					child.Parent = v876
				end
			end

			v876.Name = p224.Name
			v876.PrimaryPart = HumanoidRootPart

			local Humanoid = v876:FindFirstChildOfClass("Humanoid")

			if Humanoid and not Humanoid:FindFirstChildOfClass("Animator") then
				Instance.new("Animator").Parent = Humanoid
			end

			local t28 = {}

			for _, descendant in ipairs(v876:GetDescendants()) do
				if descendant:IsA("Motor6D") then
					table.insert(t28, descendant)
				end
			end

			if #t28 > 0 then
				local scale = v876:GetScale()
				local connection

				connection = RunService.PreSimulation:Connect(function()
					if not v876.Parent then
						connection:Disconnect()

						return
					end

					for _, v in ipairs(t28) do
						local Transform = v.Transform
						local Position = Transform.Position

						if Position.Magnitude > 0 then
							v.Transform = Transform - Position + Position / scale
						end
					end
				end)
				v876.Destroying:Connect(function()
					connection:Disconnect()
				end)
			end

			p224:Destroy()

			return v876
		end

		local v897 = math.random(-180, 180)

		local function v898(p226, p227, p228, p229)
			local clone = game:GetService("ReplicatedStorage").CenzDonateRobuxRS.CenzDonateRobuxVFX.UltraHammerGiant:Clone()
			local v900 = false
			local v901 = v875(clone, p229)

			if v901 then
				clone = v901
				v900 = true
			end

			local function v902(p230)
				for _, descendant in ipairs(p230:GetDescendants()) do
					if descendant:IsA("BasePart") then
						descendant.CanCollide = false
						descendant.CanQuery = false
						descendant.CanTouch = false
						descendant.Massless = true
					end
				end
			end

			v902(clone)

			local Humanoid = clone:FindFirstChildOfClass("Humanoid")

			if Humanoid then
				Humanoid:SetStateEnabled(Enum.HumanoidStateType.Physics, false)
				Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
				Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
				Humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp, false)
				Humanoid.EvaluateStateMachine = false
				pcall(function()
					Humanoid.BreakJointsOnDeath = false
				end)
				pcall(function()
					Humanoid.RequiresNeck = false
				end)
			end

			clone.DescendantAdded:Connect(function(descendant)
				if descendant:IsA("BasePart") then
					descendant.CanCollide = false
					descendant.CanQuery = false
					descendant.CanTouch = false
					descendant.Massless = true
				end
			end)

			local DiamondHammer = clone.DiamondHammer

			for _, descendant in pairs(clone:GetDescendants()) do
				if (descendant:IsA("BasePart") or descendant:IsA("Decal")) and descendant.Name ~= "HumanoidRootPart" and (descendant:IsDescendantOf(DiamondHammer) == false or descendant:IsDescendantOf(clone.Objects) == false) then
					descendant.Transparency = 1
				end
			end

			v848(DiamondHammer.Handle.MainDiamondCenter.Shockwave, 60)
			v848(DiamondHammer.Handle.MainDiamondCenter.ChargeGlow, 50)
			v848(DiamondHammer.Handle.MainDiamondCenter.ChargeRays, 50)
			DiamondHammer.Handle.Transparency = 1
			DiamondHammer.Handle.Diamonds.Transparency = 1
			DiamondHammer.Handle.CanCollide = false
			clone.Parent = workspace
			v848(DiamondHammer.Handle.BaseFrontOffset.Shockwave, 10)

			local clone2 = clone.Objects.Meteor:Clone()
			local clone3 = clone.Objects.FloorAmbiance:Clone()
			local clone4 = clone.Objects.Ambiance:Clone()
			local clone5 = clone.Objects.ImpactVisuals:Clone()
			local clone6 = clone.Objects.Portal:Clone()

			clone.Objects:Destroy()

			local Sounds = clone.Sounds

			Sounds.Parent = workspace
			Sounds.Name = "1MDonationEffect_Sounds"

			local u915
			local ok, result = pcall(function()
				u915 = clone.Humanoid:LoadAnimation(clone.Animations.Giant_MainAnimation)
			end)

			if not ok then
				warn("Animation load failed: " .. tostring(result))
			end

			local ColorCorrectionEffect = Instance.new("ColorCorrectionEffect")

			ColorCorrectionEffect.Enabled = false
			ColorCorrectionEffect.Name = "SmiteColorCorrection_Disabled"

			local BloomEffect = Instance.new("BloomEffect")

			BloomEffect.Enabled = false
			BloomEffect.Name = "SmiteBloom_Disabled"
			BloomEffect.Size = 20
			BloomEffect.Threshold = 0.1
			BloomEffect.Intensity = 0

			local v920 = v852.new(Enum.RenderPriority.Camera.Value, function(p231)
				workspace.CurrentCamera.CFrame *= p231
			end)

			v920:Start()
			clone.PrimaryPart = clone.FloorLevel
			clone:SetPrimaryPartCFrame(CFrame.new(GiantRobuxTargetPosition.X, GiantRobuxTargetPosition.Y, GiantRobuxTargetPosition.Z))
			clone:SetPrimaryPartCFrame(clone.FloorLevel.CFrame:ToWorldSpace(CFrame.Angles(0, math.rad(math.random(-180, 180)), 0)))
			clone:SetPrimaryPartCFrame(clone.FloorLevel.CFrame:ToWorldSpace(CFrame.new(25, 0, 365)))
			clone.PrimaryPart = clone.HumanoidRootPart

			if v900 then
				local u921

				local function v922()
					local HumanoidRootPart = clone:FindFirstChild("HumanoidRootPart")

					if not HumanoidRootPart then
						return
					end

					local v924

					for _, v in ipairs({
						"LeftFoot",
						"RightFoot",
						"LeftLowerLeg",
						"RightLowerLeg"
					}) do
						local v927 = clone:FindFirstChild(v)

						if v927 and v927:IsA("BasePart") then
							local v928 = v927.Position.Y - v927.Size.Y / 2

							if v924 == nil or v928 < v924 then
								v924 = v928
							end
						end
					end

					if not v924 then
						return
					end

					local raycastParams = RaycastParams.new()

					raycastParams.FilterType = Enum.RaycastFilterType.Exclude

					local filterDescendantsInstances = { clone }

					for _, player in ipairs(Players:GetPlayers()) do
						if player.Character then
							table.insert(filterDescendantsInstances, player.Character)
						end
					end

					raycastParams.FilterDescendantsInstances = filterDescendantsInstances
					pcall(function()
						raycastParams.RespectCanCollide = true
					end)

					local hit = workspace:Raycast(HumanoidRootPart.Position, Vector3.new(0, -10000, 0), raycastParams)
					local Y

					if hit then
						Y = hit.Position.Y
						u921 = Y
					else
						local FloorLevel = clone:FindFirstChild("FloorLevel")

						Y = u921 or FloorLevel and FloorLevel.Position.Y or nil
					end

					if not Y then
						return
					end

					local v936 = Y - v924

					if math.abs(v936) > 0.01 then
						HumanoidRootPart.CFrame += Vector3.new(0, v936, 0)
					end
				end

				v922()

				local connection

				connection = RunService.PostSimulation:Connect(function()
					if clone.Parent then
						v922()

						return
					end

					connection:Disconnect()
				end)
				clone.Destroying:Connect(function()
					connection:Disconnect()
				end)
			end

			local clone7 = clone6:Clone()

			clone6.PortalAmbiance.Volume = 0
			clone6.PortalAmbiance.PlaybackSpeed = 0
			clone7.CFrame = clone.FloorLevel.CFrame
			clone7.Parent = workspace
			clone.FloorLevel:Destroy()

			local LeftEyeAttachment = clone.Head.LeftEyeAttachment
			local RightEyeAttachment = clone.Head.RightEyeAttachment

			LeftEyeAttachment.Parent = nil
			RightEyeAttachment.Parent = nil
			DiamondHammer.Parent = nil

			local ok2, result2 = pcall(function()
				v854(p229, clone, v900)

				if not v900 then
					clone.Humanoid.BodyDepthScale.Value = 50
					clone.Humanoid.HeadScale.Value = 50
					clone.Humanoid.BodyHeightScale.Value = 50
					clone.Humanoid.BodyWidthScale.Value = 50
				end
			end)

			if ok2 == false then
				warn("Unable to set giant's apperance to donator (" .. p226 .. ")  (" .. result2 .. ")")
			end

			DiamondHammer.Parent = clone
			DiamondHammer.Weld.Attachment0 = clone.RightHand.RightGripAttachment
			LeftEyeAttachment.Parent = clone.Head
			RightEyeAttachment.Parent = clone.Head
			LeftEyeAttachment.Position = Vector3.new(-6, 11, -32)
			RightEyeAttachment.Position = Vector3.new(6, 11, -32)
			Sounds.Summon:Play()
			clone7.Transparency = 0
			clone7.Sparks.Enabled = true
			clone7.Appearance.Enabled = true
			TweenService:Create(clone7.Sparks, TweenInfo.new(3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0, false, 0), {
				Rate = 150
			}):Play()
			TweenService:Create(clone7.Appearance, TweenInfo.new(3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0, false, 0), {
				Rate = 200
			}):Play()
			TweenService:Create(clone7, TweenInfo.new(3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0, false, 0), {
				Size = Vector3.new(400, 1, 400)
			}):Play()
			TweenService:Create(clone7.OuterLightBeam, TweenInfo.new(3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0, false, 0), {
				Width0 = 400,
				Width1 = 600
			}):Play()
			TweenService:Create(clone7.InnerLightBeam, TweenInfo.new(3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0, false, 0), {
				Width0 = 200,
				Width1 = 300
			}):Play()
			clone7.PortalAmbiance.Playing = true
			clone7.PortalOpen1:Play()
			clone7.PortalOpen2:Play()
			TweenService:Create(clone7.PortalAmbiance, TweenInfo.new(3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0, false, 0), {
				Volume = 1.5,
				PlaybackSpeed = 1.25
			}):Play()

			local u943 = true
			local n12 = 0.5

			spawn(function()
				while u943 == true do
					wait(n12)
					spawn(function()
						local v945 = math.random(100, 400) / 100
						local v946 = math.random(250, 400) / 100
						local v947 = math.random(500, 750)
						local clone8 = clone2:Clone()

						clone8.Parent = workspace
						clone8.Transparency = 1
						clone8.Position = GiantRobuxTargetPosition + Vector3.new(math.random(-750, 750), 0, math.random(-750, 750))
						clone8.Size *= v945
						clone8.CFrame = clone8.CFrame:ToWorldSpace(CFrame.Angles(math.rad(math.random(-10, 10)), math.rad(v897), 0.52359877559829882))
						clone8.Position += clone8.CFrame.UpVector * v947

						for _, descendant in pairs(clone8:GetDescendants()) do
							if descendant:IsA("ParticleEmitter") then
								v848(descendant, v945)

								if string.find(descendant.Name, "Meteor_") ~= nil then
									descendant.Enabled = true
								end
							end
						end

						clone8.Glow.Range *= v945
						clone8.Glow.Enabled = true
						clone8.Trail0.Position *= v945 / 2
						clone8.Trail1.Position *= v945 / 2
						clone8.Trail.Enabled = true
						clone8.Whoosh.Volume = 0
						clone8.Whoosh.TimePosition = math.random(0, clone8.Whoosh.TimeLength)
						clone8.Whoosh.PlaybackSpeed = 1.5 - v945 * 0.15
						clone8.Impact.PlaybackSpeed = 1.5 - v945 * 0.15
						clone8.Whoosh.Playing = true
						TweenService:Create(clone8, TweenInfo.new(v946, Enum.EasingStyle.Sine, Enum.EasingDirection.In, 0, false, 0), {
							Position = clone8.Position + clone8.CFrame.UpVector * -v947,
							Orientation = Vector3.new(math.random(-180, 180) * 3, math.random(-180, 180) * 3, math.random(-180, 180) * 3)
						}):Play()
						TweenService:Create(clone8, TweenInfo.new(v946 * 0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0), {
							Transparency = 0
						}):Play()
						TweenService:Create(clone8.Whoosh, TweenInfo.new(v946 * 0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0), {
							Volume = 1
						}):Play()
						wait(v946)
						clone8.Transparency = 1
						clone8.Orientation = Vector3.new(0, 0, 0)
						clone8.Glow.Range *= 1.5
						clone8.Glow.Brightness *= 3
						TweenService:Create(clone8.Glow, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.In, 0, false, 0), {
							Brightness = 0,
							Range = clone8.Glow.Range / 2
						}):Play()

						for _, descendant in pairs(clone8:GetDescendants()) do
							if descendant:IsA("ParticleEmitter") then
								if string.find(descendant.Name, "Meteor_") ~= nil then
									descendant.Enabled = false
								end

								if string.find(descendant.Name, "Explosion_") ~= nil then
									descendant:Emit(descendant:GetAttribute("EmitCount"))
								end
							end
						end

						clone8.Trail.Enabled = false
						clone8.Whoosh.Playing = false
						clone8.Impact:Play()
						wait(3)
						clone8:Destroy()
					end)
				end
			end)

			local clone8 = clone3:Clone()

			clone8.Position = GiantRobuxTargetPosition + Vector3.new(0, -0.5, 0)
			clone8.Parent = workspace
			TweenService:Create(clone8, TweenInfo.new(10, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0), {
				Size = Vector3.new(2048, 1, 2048)
			}):Play()

			local clone9 = clone4:Clone()

			clone9.Position = GiantRobuxTargetPosition + Vector3.new(0, 0, 0)
			clone9.Size = Vector3.new(1000, 1000, 1000)
			clone9.CFrame = clone9.CFrame:ToWorldSpace(CFrame.Angles(0, math.rad(v897), 0.52359877559829882))
			clone9.Position += clone9.CFrame.UpVector * 600
			clone9.Parent = workspace
			spawn(function()
				for _, child in pairs(clone8:GetChildren()) do
					if child:IsA("ParticleEmitter") then
						v848(child, 1.25)
						child.Enabled = true
					end
				end

				for _, child in pairs(clone9:GetChildren()) do
					if child:IsA("ParticleEmitter") then
						v848(child, 1.75)
						child.Enabled = true
					end
				end

				wait(30)
				TweenService:Create(Sounds.FireLoop, TweenInfo.new(30, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0), {
					Volume = 0,
					PlaybackSpeed = 0.5
				}):Play()
				u943 = false

				for _, child in pairs(clone8:GetChildren()) do
					if child:IsA("ParticleEmitter") then
						TweenService:Create(child, TweenInfo.new(60, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0), {
							Rate = 0
						}):Play()
					end
				end

				for _, child in pairs(clone9:GetChildren()) do
					if child:IsA("ParticleEmitter") then
						TweenService:Create(child, TweenInfo.new(30, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0), {
							Rate = 0
						}):Play()
					end
				end

				wait(30)
				clone8.Size = Vector3.new(0, 0, 0)
				clone9.Size = Vector3.new(0, 0, 0)
				wait(20)
				clone8:Destroy()
				clone9:Destroy()
			end)
			TweenService:Create(ColorCorrectionEffect, TweenInfo.new(10, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0), {
				TintColor = Color3.fromRGB(58, 58, 58),
				Brightness = 0.25,
				Saturation = 0.1,
				Contrast = 0.25
			}):Play()
			TweenService:Create(BloomEffect, TweenInfo.new(10, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0), {
				Intensity = -0.85
			}):Play()

			local function v963(p232)
				local numberSequence = NumberSequence.new({
					NumberSequenceKeypoint.new(0, p232),
					NumberSequenceKeypoint.new(1, 1)
				})

				for _, child in pairs(DiamondHammer.Effects.Beams:GetChildren()) do
					if child:IsA("Beam") and string.find(child.Name, "FlameEffect") ~= nil then
						child.Enabled = true
						child.Transparency = numberSequence
					end
				end
			end

			local connection = clone.Values.Hammer_FlameEffectTransparency.Changed:Connect(v963)

			v963(1)
			u915:GetMarkerReachedSignal("Eye lense flare"):Connect(function()
				Sounds.LenseFlareEyes:Play()
				clone.Head.LeftEyeAttachment.Flare.Enabled = true
				clone.Head.LeftEyeAttachment.FlareFlash:Emit(1)
				clone.Head.RightEyeAttachment.Flare.Enabled = true
				clone.Head.RightEyeAttachment.FlareFlash:Emit(1)
			end)
			u915:GetMarkerReachedSignal("HammerAppear"):Connect(function()
				DiamondHammer.Handle.AppearSound.Playing = true
				DiamondHammer.Handle.AppearSound.Volume = 0
				DiamondHammer.Handle.AppearSound.PlaybackSpeed = 0.75
				TweenService:Create(DiamondHammer.Handle.AppearSound, TweenInfo.new(1.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, true, 0), {
					Volume = 2
				}):Play()
				TweenService:Create(DiamondHammer.Handle.AppearSound, TweenInfo.new(3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, 0, false, 0), {
					PlaybackSpeed = 1.5
				}):Play()
				DiamondHammer.Handle.HammerBaseOutline.Sparkles.Enabled = true
				DiamondHammer.Handle.HammerBaseOutline.Appearance.Enabled = true
				DiamondHammer.Handle.HammerHandleBase.Appearance.Enabled = true
				TweenService:Create(DiamondHammer.Handle.HammerBaseOutline.Sparkles, TweenInfo.new(3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, 0, false, 0), {
					Rate = 25
				}):Play()
				TweenService:Create(DiamondHammer.Handle.HammerBaseOutline.Appearance, TweenInfo.new(1.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, true, 0), {
					Rate = 200
				}):Play()
				TweenService:Create(DiamondHammer.Handle.HammerHandleBase.Appearance, TweenInfo.new(1.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, true, 0), {
					Rate = 100
				}):Play()
				TweenService:Create(DiamondHammer.Handle, TweenInfo.new(3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, 0, false, 0), {
					Transparency = 0
				}):Play()
				TweenService:Create(DiamondHammer.Handle.Diamonds, TweenInfo.new(3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, 0, false, 0), {
					Transparency = 0.1
				}):Play()
			end)
			u915:GetMarkerReachedSignal("ChargeSwing"):Connect(function()
				DiamondHammer.Handle.ChargeSound1:Play()
				DiamondHammer.Handle.ChargeSound2:Play()
				DiamondHammer.Handle.ChargeSound3:Play()
				DiamondHammer.Handle.MainChargeSound:Play()

				for _, child in pairs(DiamondHammer.Handle:GetChildren()) do
					if child:IsA("Attachment") and string.find(child.Name, "DiamondCenter") ~= nil then
						child.Flare.Enabled = true
					end
				end

				DiamondHammer.Handle.MainDiamondCenter.Shockwave:Emit(1)
				DiamondHammer.Handle.MainDiamondCenter.ChargeGlow.Enabled = true
				DiamondHammer.Handle.MainDiamondCenter.ChargeRays.Enabled = true
				TweenService:Create(DiamondHammer.Handle.MainDiamondCenter.ChargeRays, TweenInfo.new(4, Enum.EasingStyle.Quad, Enum.EasingDirection.In, 0, false, 0), {
					TimeScale = 1
				}):Play()
				TweenService:Create(DiamondHammer.Handle.MainDiamondCenter.ChargeGlow, TweenInfo.new(4, Enum.EasingStyle.Quad, Enum.EasingDirection.In, 0, false, 0), {
					TimeScale = 1
				}):Play()
			end)
			u915:GetMarkerReachedSignal("SwingStart"):Connect(function()
				DiamondHammer.Handle.ChargeEndSound:Play()
				DiamondHammer.Handle.MainDiamondCenter.Shockwave:Emit(3)
				DiamondHammer.Handle.MainDiamondCenter.ChargeGlow.Enabled = false
				DiamondHammer.Handle.MainDiamondCenter.ChargeRays.Enabled = false
				TweenService:Create(DiamondHammer.Handle.MainChargeSound, TweenInfo.new(4, Enum.EasingStyle.Quart, Enum.EasingDirection.In, 0, false, 0), {
					Volume = 0.25
				}):Play()
				DiamondHammer.Handle.BaseCenter.Wind.Volume = 0
				DiamondHammer.Handle.BaseCenter.Wind.PlaybackSpeed = 0.5
				DiamondHammer.Handle.BaseCenter.Wind.Playing = true
				TweenService:Create(DiamondHammer.Handle.BaseCenter.Wind, TweenInfo.new(3.5, Enum.EasingStyle.Quart, Enum.EasingDirection.In, 0, false, 0), {
					Volume = 5,
					PlaybackSpeed = 2.5
				}):Play()
				TweenService:Create(clone.Values.Hammer_FlameEffectTransparency, TweenInfo.new(4, Enum.EasingStyle.Quart, Enum.EasingDirection.In, 0, false, 0), {
					Value = 0
				}):Play()
				DiamondHammer.Handle.HammerBase.Flames.Enabled = true
				DiamondHammer.Handle.BaseFrontOffset.Shockwave.Enabled = true
				TweenService:Create(DiamondHammer.Handle.HammerBase.Flames, TweenInfo.new(2.5, Enum.EasingStyle.Sine, Enum.EasingDirection.In, 0, false, 0), {
					Rate = 100
				}):Play()
				TweenService:Create(DiamondHammer.Handle.BaseFrontOffset.Shockwave, TweenInfo.new(3, Enum.EasingStyle.Sine, Enum.EasingDirection.In, 0, false, 0), {
					Rate = 15
				}):Play()

				for _, child in pairs(DiamondHammer.Effects.Trails:GetChildren()) do
					child.Enabled = true
				end
			end)
			u915:GetMarkerReachedSignal("SwingEnd"):Connect(function()
				n12 = 0.25
				DiamondHammer.Handle.MainChargeSound:Stop()
				Sounds.Rumble:Play()
				BloomEffect.Intensity = 0.75
				BloomEffect.Threshold = 0.05
				ColorCorrectionEffect.Contrast = 0
				TweenService:Create(BloomEffect, TweenInfo.new(10, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0), {
					Intensity = -0.9,
					Threshold = 0.1
				}):Play()
				TweenService:Create(ColorCorrectionEffect, TweenInfo.new(10, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0), {
					Contrast = 0.25
				}):Play()
				TweenService:Create(clone.Values.Hammer_FlameEffectTransparency, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0), {
					Value = 1
				}):Play()
				DiamondHammer.Handle.BaseFrontOffset.Shockwave.Enabled = false
				TweenService:Create(DiamondHammer.Handle.HammerBase.Flames, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0), {
					Rate = 0
				}):Play()

				for _, child in pairs(DiamondHammer.Effects.Trails:GetChildren()) do
					child.Enabled = false
				end

				DiamondHammer.Handle.BaseCenter.Wind.Playing = false

				for _, child in pairs(DiamondHammer.Handle.BaseCenter:GetChildren()) do
					if child:IsA("Sound") and string.find(child.Name, "Impact_") ~= nil then
						child:Play()
					end
				end

				for _, child in pairs(DiamondHammer.Handle:GetChildren()) do
					if child:IsA("Attachment") and string.find(child.Name, "DiamondCenter") ~= nil then
						child.Flare.Enabled = false
					end
				end

				v920:ShakeOnce(6, 6, 0.25, 5)

				local clone10 = clone5:Clone()

				clone10.Position = GiantRobuxTargetPosition
				clone10.Parent = workspace
				v848(clone10.EmitPoint.Impact_FractalBurst, 10)
				v848(clone10.EmitPoint.Impact_RaysBurst, 25)
				v848(clone10.EmitPoint.Impact_Shockwave, 30)
				v848(clone10.EmitPoint.Impact_Spark1, 10)
				v848(clone10.EmitPoint.Impact_Spark2, 10)
				v848(clone10.EmitPoint.Impact_Spark3, 10)
				v848(clone10.EmitPoint.Impact_SparkleExplosion, 10)
				v848(clone10.EmitPoint.SparkleExplosion, 7.5)
				v848(clone10.EmitPoint.Sparks, 5)

				for _, child in pairs(clone10.EmitPoint:GetChildren()) do
					if child:IsA("ParticleEmitter") and string.find(child.Name, "Impact_") ~= nil then
						child:Emit(child:GetAttribute("EmitCount"))
					end
				end

				local function v981(p233)
					return p233
				end

				clone10.ApplauseLoop.Playing = true
				clone10.ChimeLoop.Playing = true
				clone10.CoinsLoop.Playing = true

				local Frame = clone10.BillboardGuiAnimation.Frame

				Frame.TopText.Visible = true
				Frame.BottomText.Visible = true
				Frame.TopText.Text = "@" .. v981(p226) .. " DONATED"
				Frame.MiddleText.Text = "\u{E002}" .. tostring(p228):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")
				Frame.BottomText.Text = "TO @" .. v981(p227)
				Frame.RobuxLogo.Size = UDim2.fromScale(0, 0)
				Frame.RobuxLogo.Rotation = -180
				Frame.Star.Size = UDim2.fromScale(0, 0)
				Frame.BottomText.Size = UDim2.fromScale(0, 0)
				Frame.BottomText.Position = UDim2.fromScale(0.5, 0.5)
				Frame.MiddleText.Size = UDim2.fromScale(0, 0)
				Frame.TopText.Position = UDim2.fromScale(0.5, 0.5)
				Frame.TopText.Size = UDim2.fromScale(0, 0)
				Frame.Parent.Enabled = true
				TweenService:Create(clone10, TweenInfo.new(20, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0), {
					Position = GiantRobuxTargetPosition + Vector3.new(0, 400, 0)
				}):Play()
				TweenService:Create(Frame.RobuxLogo, TweenInfo.new(10, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out, 0, false, 0), {
					Size = UDim2.fromScale(1, 1)
				}):Play()
				TweenService:Create(Frame.RobuxLogo, TweenInfo.new(15, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out, 0, false, 0), {
					Rotation = 0
				}):Play()
				TweenService:Create(Frame.Star, TweenInfo.new(5, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out, 0, false, 0), {
					Size = UDim2.fromScale(1.5, 1.5)
				}):Play()
				TweenService:Create(Frame.Star, TweenInfo.new(15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0), {
					Rotation = 360
				}):Play()
				TweenService:Create(Frame.BottomText, TweenInfo.new(5, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out, 0, false, 0.6), {
					Size = UDim2.fromScale(1.5, 0.1),
					Position = UDim2.fromScale(0.5, 0.59)
				}):Play()
				TweenService:Create(Frame.MiddleText, TweenInfo.new(5, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out, 0, false, 0.4), {
					Size = UDim2.fromScale(1, 1)
				}):Play()
				TweenService:Create(Frame.TopText, TweenInfo.new(5, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out, 0, false, 0.2), {
					Size = UDim2.fromScale(1.5, 0.1),
					Position = UDim2.fromScale(0.5, 0.41)
				}):Play()
				TweenService:Create(Frame.Star, TweenInfo.new(10, Enum.EasingStyle.Quad, Enum.EasingDirection.In, 0, false, 5), {
					ImageTransparency = 1,
					ImageColor3 = Color3.fromRGB(0, 255, 255)
				}):Play()
				clone10.EmitPoint.Sparks.Enabled = true
				clone10.EmitPoint.SparkleExplosion.Enabled = true
				TweenService:Create(clone10.EmitPoint.Sparks, TweenInfo.new(45, Enum.EasingStyle.Quint, Enum.EasingDirection.In, 0, false, 0), {
					Rate = 0
				}):Play()
				TweenService:Create(clone10.EmitPoint.SparkleExplosion, TweenInfo.new(45, Enum.EasingStyle.Quint, Enum.EasingDirection.In, 0, false, 0), {
					Rate = 0
				}):Play()
				TweenService:Create(clone10.ChimeLoop, TweenInfo.new(55, Enum.EasingStyle.Quad, Enum.EasingDirection.In, 0, false, 0), {
					Volume = 0,
					PlaybackSpeed = 0.75
				}):Play()
				TweenService:Create(clone10.ApplauseLoop, TweenInfo.new(60, Enum.EasingStyle.Quad, Enum.EasingDirection.In, 0, false, 0), {
					Volume = 0
				}):Play()
				TweenService:Create(clone10.CoinsLoop, TweenInfo.new(50, Enum.EasingStyle.Quad, Enum.EasingDirection.In, 0, false, 0), {
					Volume = 0,
					PlaybackSpeed = 1
				}):Play()
				wait(30)
				TweenService:Create(Frame.UIScale, TweenInfo.new(15, Enum.EasingStyle.Quad, Enum.EasingDirection.In, 0, false, 0), {
					Scale = 0
				}):Play()
				wait(30)
				clone10:Destroy()
			end)
			u915:GetMarkerReachedSignal("Release"):Connect(function()
				clone.Head.LeftEyeAttachment.Flare.Enabled = false
				clone.Head.RightEyeAttachment.Flare.Enabled = false
			end)

			local Appearance = clone.Particles.Appearance

			u915:GetMarkerReachedSignal("Fade"):Connect(function()
				local clone10 = Sounds.GiantFade:Clone()

				clone10.Volume = 0
				clone10.PlaybackSpeed = 1.5
				clone10.Parent = clone.UpperTorso
				clone10.Playing = true
				TweenService:Create(clone10, TweenInfo.new(4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, true, 0), {
					Volume = 3
				}):Play()
				TweenService:Create(clone10, TweenInfo.new(8, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, 0, false, 0), {
					PlaybackSpeed = 0.5
				}):Play()

				for _, descendant in pairs(clone:GetDescendants()) do
					if (descendant:IsA("BasePart") or descendant:IsA("Decal")) and descendant.Name ~= "HumanoidRootPart" then
						if descendant:IsA("Decal") == false then
							local clone11 = Appearance:Clone()

							clone11.Parent = descendant
							clone11.Enabled = true
							TweenService:Create(clone11, TweenInfo.new(5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, true, 0), {
								Rate = 30
							}):Play()
						end

						TweenService:Create(descendant, TweenInfo.new(10, Enum.EasingStyle.Quad, Enum.EasingDirection.In, 0, false, 0), {
							Transparency = 1
						}):Play()
					end
				end

				TweenService:Create(DiamondHammer.Handle.HammerBaseOutline.Sparkles, TweenInfo.new(8, Enum.EasingStyle.Quad, Enum.EasingDirection.In, 0, false, 0), {
					Rate = 0
				}):Play()
				TweenService:Create(DiamondHammer.Handle.HammerBaseOutline.Appearance, TweenInfo.new(4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, true, 0), {
					Rate = 200
				}):Play()
				TweenService:Create(DiamondHammer.Handle.HammerHandleBase.Appearance, TweenInfo.new(4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, true, 0), {
					Rate = 100
				}):Play()
				TweenService:Create(DiamondHammer.Handle, TweenInfo.new(8, Enum.EasingStyle.Quad, Enum.EasingDirection.In, 0, false, 0), {
					Transparency = 1
				}):Play()
				TweenService:Create(DiamondHammer.Handle.Diamonds, TweenInfo.new(8, Enum.EasingStyle.Quad, Enum.EasingDirection.In, 0, false, 0), {
					Transparency = 1
				}):Play()
			end)
			u915:GetMarkerReachedSignal("FadeEnd"):Connect(function()
				connection:Disconnect()
				wait(5)
				clone:Destroy()
			end)
			wait(1)
			u915:Play()
			spawn(function()
				Sounds.Earthquake:Play()
				Sounds.CrumbleLoop.Volume = 0
				Sounds.CrumbleLoop.Playing = true
				TweenService:Create(Sounds.CrumbleLoop, TweenInfo.new(3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0), {
					Volume = 0.5
				}):Play()
				Sounds.FireLoop.Volume = 0
				Sounds.FireLoop.PlaybackSpeed = 0.5
				Sounds.FireLoop.Playing = true
				TweenService:Create(Sounds.FireLoop, TweenInfo.new(5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0), {
					Volume = 0.5,
					PlaybackSpeed = 1
				}):Play()
				v920:ShakeSustain(v852.Presets.Earthquake)

				for _, descendant in pairs(clone:GetDescendants()) do
					if (descendant:IsA("BasePart") or descendant:IsA("Decal")) and descendant.Name ~= "HumanoidRootPart" and descendant:IsDescendantOf(DiamondHammer) == false then
						TweenService:Create(descendant, TweenInfo.new(5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0), {
							Transparency = 0
						}):Play()
					end
				end

				wait(7)
				TweenService:Create(Sounds.CrumbleLoop, TweenInfo.new(10, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0), {
					Volume = 0
				}):Play()
				v920:StopSustained(6)
				TweenService:Create(clone7.Sparks, TweenInfo.new(5, Enum.EasingStyle.Sine, Enum.EasingDirection.In, 0, false, 0), {
					Rate = 0
				}):Play()
				TweenService:Create(clone7.Appearance, TweenInfo.new(5, Enum.EasingStyle.Sine, Enum.EasingDirection.In, 0, false, 0), {
					Rate = 0
				}):Play()
				TweenService:Create(clone7, TweenInfo.new(5, Enum.EasingStyle.Sine, Enum.EasingDirection.In, 0, false, 0), {
					Size = Vector3.new(0, 1, 0)
				}):Play()
				TweenService:Create(clone7.OuterLightBeam, TweenInfo.new(5, Enum.EasingStyle.Sine, Enum.EasingDirection.In, 0, false, 0), {
					Width0 = 0,
					Width1 = 0
				}):Play()
				TweenService:Create(clone7.InnerLightBeam, TweenInfo.new(5, Enum.EasingStyle.Sine, Enum.EasingDirection.In, 0, false, 0), {
					Width0 = 0,
					Width1 = 0
				}):Play()
				TweenService:Create(clone7.PortalAmbiance, TweenInfo.new(5, Enum.EasingStyle.Sine, Enum.EasingDirection.In, 0, false, 0), {
					Volume = 0,
					PlaybackSpeed = 0
				}):Play()
				clone7.PortalClose1.PlayOnRemove = true
				wait(5)
				clone7:Destroy()
			end)
			wait(30)
			v852:Stop()
			TweenService:Create(ColorCorrectionEffect, TweenInfo.new(30, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0), {
				TintColor = Color3.fromRGB(255, 255, 255),
				Brightness = 0,
				Saturation = 0,
				Contrast = 0
			}):Play()
			TweenService:Create(BloomEffect, TweenInfo.new(30, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0), {
				Intensity = -1
			}):Play()
			wait(30)
			ColorCorrectionEffect:Destroy()
			BloomEffect:Destroy()
			Sounds:Destroy()
			connection:Disconnect()
		end

		local LocalPlayer = game:GetService("Players").LocalPlayer

		local function v991()
			if LocalPlayer:GetAttribute("CenzHideDonateVFX") == true then
				return true
			end

			if _G.CenzHideDonateVFX == true then
				return true
			end

			if LocalPlayer:GetAttribute("GlobalEffects") == false then
				return true
			end

			return false
		end

		p215(ReplicatedStorage2.CenzDonateRobuxRS.CenzDonateRobuxModules.CenzDonateRobuxJPass).OnClientEvent("CenzFireSmite"):Connect(function(p234, p235, p236, p237)
			if v991() then
				return
			end

			v898(p234, p235, p236, p237)
		end)
	end

	v842(script, v24)
end)
task.spawn(function()
	local function v992(p238, p239)
		local v993 = p239(game:GetService("ReplicatedStorage").CenzDonateRobuxRS.CenzDonateRobuxConfig)
		local TweenService = game:GetService("TweenService")
		local Lighting = game:GetService("Lighting")
		local BlackHoleRobuxTargetPosition = v993.BlackHoleRobuxTargetPosition
		local n13 = 0
		local ClockTime
		local Brightness
		local FogColor

		comma = function(p240)
			local v1001

			repeat
				p240, v1001 = string.gsub(p240, "^(-?%d+)(%d%d%d)", "%1,%2")
			until v1001 == 0

			return p240
		end

		local function v1002(p241, p242, p243)
			if n13 == 0 then
				ClockTime = Lighting.ClockTime
				Brightness = Lighting.Brightness
				FogColor = Lighting.FogColor
			end

			n13 += 1

			local function v1003(p244, p245, p246)
				TweenService:Create(p244, TweenInfo.new(p245, Enum.EasingStyle.Quint), p246):Play()
			end
			local function v1004(p247, p248)
				p247.Speed = NumberRange.new(p247.Speed.Min * p248, p247.Speed.Max * p248)
				p247.Acceleration *= p248

				local Keypoints = p247.Size.Keypoints
				local t29 = {}

				for i = 1, #Keypoints do
					table.insert(t29, NumberSequenceKeypoint.new(Keypoints[i].Time, Keypoints[i].Value * p248, Keypoints[i].Envelope * p248))
				end

				p247.Size = NumberSequence.new(t29)
			end

			local ColorCorrectionEffect = Instance.new("ColorCorrectionEffect")

			ColorCorrectionEffect.Enabled = true
			ColorCorrectionEffect.Name = "EventColorCorrection"
			ColorCorrectionEffect.Parent = game.Lighting

			local BloomEffect = Instance.new("BloomEffect")

			BloomEffect.Enabled = true
			BloomEffect.Name = "SmiteBloom"
			BloomEffect.Size = 20
			BloomEffect.Threshold = 0.1
			BloomEffect.Intensity = -1
			BloomEffect.Parent = game.Lighting

			local v1010 = math.random(-180, 180)
			local clone = game:GetService("ReplicatedStorage").CenzDonateRobuxRS.CenzDonateRobuxVFX.Live:Clone()
			local clone2 = clone.Objects.FloorAmbiance:Clone()
			local clone3 = clone.Objects.Ambiance:Clone()
			local ImpactVisuals = clone.Objects.ImpactVisuals
			local clone4 = clone.Objects.Heavenball:Clone()
			local clone5 = clone.Objects.Whitehole:Clone()
			local clone6 = clone.Objects.Whitehole2:Clone()
			local clone7 = clone.Objects.Whitehole3:Clone()
			local clone8 = clone.Objects.Whitehole4:Clone()
			local clone9 = clone2:Clone()

			clone9.Position = BlackHoleRobuxTargetPosition + Vector3.new(0, -0.5, 0)
			clone9.Parent = workspace

			local clone10 = clone3:Clone()

			clone10.Position = BlackHoleRobuxTargetPosition + Vector3.new(0, 0, 0)
			clone10.Size = Vector3.new(1000, 1000, 1000)
			clone10.CFrame = clone10.CFrame:ToWorldSpace(CFrame.Angles(0, math.rad(v1010), 0.52359877559829882))
			clone10.Position += clone10.CFrame.UpVector * 600
			clone10.Parent = workspace
			TweenService:Create(clone9, TweenInfo.new(10, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0), {
				Size = Vector3.new(2048, 1, 2048)
			}):Play()

			local clone11 = clone.Objects.Orb:Clone()
			local clone12 = clone.Objects.Meteor:Clone()
			local v1024 = p239(v20("CameraShaker"))
			local clone13 = clone.Sounds:Clone()

			clone13.Parent = game.Workspace

			local v1026 = v1024.new(Enum.RenderPriority.Camera.Value, function(p249)
				workspace.CurrentCamera.CFrame *= p249
			end)

			TweenService:Create(ColorCorrectionEffect, TweenInfo.new(10, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0), {
				TintColor = Color3.fromRGB(255, 128, 255),
				Brightness = 0.25,
				Saturation = 0.1,
				Contrast = 0.25
			}):Play()

			local clone14 = clone11:Clone()

			clone14.Parent = workspace
			clone14.Position = v993.BlackHoleRobuxSpawnPosition
			v1026:Start()
			v1026:ShakeSustain(v1024.Presets.Earthquake)

			local clone15 = clone13.Ambiance:Clone()

			clone15.Parent = workspace
			clone15:Play()

			for _, child in pairs(clone14.Attachment:GetChildren()) do
				if child:IsA("ParticleEmitter") then
					v1004(child, 1.75)
					child.Enabled = true
				end
			end

			for _, child in pairs(clone9:GetChildren()) do
				if child:IsA("ParticleEmitter") then
					v1004(child, 1.75)
					child.Enabled = true
				end
			end

			for _, child in pairs(clone10:GetChildren()) do
				if child:IsA("ParticleEmitter") then
					v1004(child, 2.5)
					child.Enabled = true
				end
			end

			local v1035 = true

			spawn(function()
				while v1035 == true do
					wait(0.5)
					spawn(function()
						local v1036 = math.random(100, 400) / 100
						local v1037 = math.random(250, 400) / 100
						local v1038 = math.random(500, 750)
						local clone16 = clone12:Clone()

						clone16.Parent = workspace
						clone16.Transparency = 1
						clone16.Position = BlackHoleRobuxTargetPosition + Vector3.new(math.random(-750, 750), 0, math.random(-750, 750))
						clone16.Size *= v1036
						clone16.CFrame = clone16.CFrame:ToWorldSpace(CFrame.Angles(math.rad(math.random(-10, 10)), math.rad(v1010), 0.52359877559829882))
						clone16.Position += clone16.CFrame.UpVector * v1038

						for _, descendant in pairs(clone16:GetDescendants()) do
							if descendant:IsA("ParticleEmitter") then
								v1004(descendant, v1036)

								if string.find(descendant.Name, "Meteor_") ~= nil then
									descendant.Enabled = true
								end
							end
						end

						clone16.Glow.Range *= v1036
						clone16.Glow.Enabled = true
						clone16.Trail0.Position *= v1036 / 2
						clone16.Trail1.Position *= v1036 / 2
						clone16.Trail.Enabled = true
						clone16.Whoosh.Volume = 0
						clone16.Whoosh.TimePosition = math.random(0, clone16.Whoosh.TimeLength)
						clone16.Whoosh.PlaybackSpeed = 1.5 - v1036 * 0.15
						clone16.Impact.PlaybackSpeed = 1.5 - v1036 * 0.15
						clone16.Whoosh.Playing = true
						TweenService:Create(clone16, TweenInfo.new(v1037, Enum.EasingStyle.Sine, Enum.EasingDirection.In, 0, false, 0), {
							Position = clone16.Position + clone16.CFrame.UpVector * -v1038,
							Orientation = Vector3.new(math.random(-180, 180) * 3, math.random(-180, 180) * 3, math.random(-180, 180) * 3)
						}):Play()
						TweenService:Create(clone16, TweenInfo.new(v1037 * 0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0), {
							Transparency = 0
						}):Play()
						TweenService:Create(clone16.Whoosh, TweenInfo.new(v1037 * 0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0), {
							Volume = 1
						}):Play()
						wait(v1037)
						clone16.Transparency = 1
						clone16.Orientation = Vector3.new(0, 0, 0)
						clone16.Glow.Range *= 1.5
						clone16.Glow.Brightness *= 3
						TweenService:Create(clone16.Glow, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.In, 0, false, 0), {
							Brightness = 0,
							Range = clone16.Glow.Range / 2
						}):Play()

						for _, descendant in pairs(clone16:GetDescendants()) do
							if descendant:IsA("ParticleEmitter") then
								if string.find(descendant.Name, "Meteor_") ~= nil then
									descendant.Enabled = false
								end

								if string.find(descendant.Name, "Explosion_") ~= nil then
									descendant:Emit(descendant:GetAttribute("EmitCount"))
								end
							end
						end

						clone16.Trail.Enabled = false
						clone16.Whoosh.Playing = false
						clone16.Impact:Play()
						wait(3)
						clone16:Destroy()
					end)
				end
			end)
			spawn(function()
				clone13.Summon:Play()
				clone13.Earthquake:Play()
				clone14.PortalAmbiance.Playing = true
				clone14.PortalOpen1:Play()
				clone14.PortalOpen2:Play()
				TweenService:Create(clone14.PortalAmbiance, TweenInfo.new(3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0, false, 0), {
					Volume = 1.5,
					PlaybackSpeed = 1.25
				}):Play()
				TweenService:Create(clone14, TweenInfo.new(7, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0, false, 0), {
					Size = Vector3.new(50, 50, 50)
				}):Play()
				clone13.CrumbleLoop.Playing = true
				TweenService:Create(clone13.CrumbleLoop, TweenInfo.new(3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0), {
					Volume = 0.5
				}):Play()
				clone13.FireLoop.Playing = true
				TweenService:Create(clone13.FireLoop, TweenInfo.new(5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0), {
					Volume = 0.5,
					PlaybackSpeed = 1
				}):Play()
				v1026:ShakeSustain(v1024.Presets.Earthquake)
				wait(7)
				TweenService:Create(clone13.CrumbleLoop, TweenInfo.new(10, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0), {
					Volume = 0
				}):Play()
				v1026:StopSustained(6)
				TweenService:Create(clone14.PortalAmbiance, TweenInfo.new(5, Enum.EasingStyle.Sine, Enum.EasingDirection.In, 0, false, 0), {
					Volume = 0,
					PlaybackSpeed = 0
				}):Play()
			end)
			wait(math.random(14, 19))
			clone5.Parent = workspace
			clone6.Parent = workspace
			clone7.Parent = workspace
			clone8.Parent = workspace

			local clone16 = clone4:Clone()
			local clone17 = clone13.Charge_2:Clone()

			clone17.Parent = clone16
			clone16.Parent = workspace
			clone17:Play()
			wait(1.25)
			v1003(clone16, 6, {
				Transparency = 0
			})

			local clone18 = clone13.ChargeEndSound:Clone()

			clone18.Parent = clone16
			clone18:Play()
			wait(1.5)
			clone5:Destroy()
			clone6:Destroy()
			clone7:Destroy()
			clone8:Destroy()
			clone17:Destroy()
			clone18:Destroy()
			clone13.Twinkle:Play()
			TweenService:Create(clone16, TweenInfo.new(3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0, false, 0), {
				Position = v993.BlackHoleRobuxSpawnPosition
			}):Play()
			wait(1.25)
			TweenService:Create(clone16, TweenInfo.new(3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0, false, 0), {
				Size = Vector3.new(50, 50, 50)
			}):Play()
			clone13.CrumbleLoop.Playing = true
			TweenService:Create(clone13.CrumbleLoop, TweenInfo.new(3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0), {
				Volume = 0.5
			}):Play()
			clone13.Sparkle:Play()
			v1026:ShakeSustain(v1024.Presets.Earthquake)
			wait(3)

			local clone19 = clone13.Tick:Clone()

			clone19.Parent = workspace
			clone19.Playing = true
			Lighting.ClockTime = 10
			Lighting.FogColor = Color3.fromRGB(144, 228, 248)
			wait(1)
			Lighting.ClockTime = 0
			Lighting.FogColor = Color3.fromRGB(0, 0, 0)
			wait(1)
			Lighting.ClockTime = 10
			Lighting.FogColor = Color3.fromRGB(144, 228, 248)
			wait(1)
			Lighting.ClockTime = 0
			Lighting.FogColor = Color3.fromRGB(0, 0, 0)
			wait(1)
			Lighting.ClockTime = 10
			Lighting.FogColor = Color3.fromRGB(144, 228, 248)
			wait(1)
			Lighting.ClockTime = 0
			Lighting.FogColor = Color3.fromRGB(0, 0, 0)
			wait(1)
			Lighting.ClockTime = 10
			Lighting.FogColor = Color3.fromRGB(144, 228, 248)
			wait(1)
			Lighting.ClockTime = 0
			Lighting.FogColor = Color3.fromRGB(0, 0, 0)
			wait(1)
			Lighting.ClockTime = 10
			Lighting.FogColor = Color3.fromRGB(144, 228, 248)
			wait(1)
			Lighting.ClockTime = 0
			Lighting.FogColor = Color3.fromRGB(0, 0, 0)
			wait(1)
			Lighting.ClockTime = 10
			Lighting.FogColor = Color3.fromRGB(144, 228, 248)
			wait(1)
			Lighting.ClockTime = 0
			Lighting.FogColor = Color3.fromRGB(0, 0, 0)
			wait(1)
			Lighting.ClockTime = 10
			Lighting.FogColor = Color3.fromRGB(144, 228, 248)
			wait(1)
			Lighting.ClockTime = 0
			Lighting.FogColor = Color3.fromRGB(0, 0, 0)
			wait(1)
			Lighting.ClockTime = 10
			Lighting.FogColor = Color3.fromRGB(144, 228, 248)
			wait(1)
			Lighting.ClockTime = 0
			Lighting.FogColor = Color3.fromRGB(0, 0, 0)
			wait(1)
			clone19:Stop()
			clone19:Destroy()
			wait(5)
			v1026:StopSustained(6)
			TweenService:Create(clone13.CrumbleLoop, TweenInfo.new(10, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0), {
				Volume = 0
			}):Play()
			wait(1)
			TweenService:Create(clone14, TweenInfo.new(10, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0, false, 0), {
				Size = Vector3.new(75, 75, 75)
			}):Play()
			TweenService:Create(clone16, TweenInfo.new(10, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0, false, 0), {
				Size = Vector3.new(74, 74, 74)
			}):Play()

			for _, child in pairs(clone14.Attachment:GetChildren()) do
				if child:IsA("ParticleEmitter") then
					v1004(child, 2)
				end
			end

			wait(10)

			for _, child in pairs(clone14.Attachment:GetChildren()) do
				if child:IsA("ParticleEmitter") then
					child.Rate = 0
				end
			end

			v1026:ShakeOnce(8, 20, 1, 6)
			TweenService:Create(clone14.Beams.FlameEffect1, TweenInfo.new(1.7, Enum.EasingStyle.Linear), {
				Brightness = 1.57
			}):Play()
			TweenService:Create(clone14.Beams.FlameEffect2, TweenInfo.new(1.7, Enum.EasingStyle.Linear), {
				Brightness = 1.57
			}):Play()
			TweenService:Create(clone14.Beams.FlameEffect3, TweenInfo.new(1.7, Enum.EasingStyle.Linear), {
				Brightness = 1.57
			}):Play()
			TweenService:Create(clone14.Beams.FlameEffect4, TweenInfo.new(1.7, Enum.EasingStyle.Linear), {
				Brightness = 1.57
			}):Play()
			TweenService:Create(clone14.Beams.FlameEffect5, TweenInfo.new(1.7, Enum.EasingStyle.Linear), {
				Brightness = 1.57
			}):Play()
			TweenService:Create(clone14.Beams.FlameEffect6, TweenInfo.new(1.7, Enum.EasingStyle.Linear), {
				Brightness = 1.57
			}):Play()
			TweenService:Create(clone14.Beams.FlameEffect7, TweenInfo.new(1.7, Enum.EasingStyle.Linear), {
				Brightness = 1.57
			}):Play()
			TweenService:Create(clone14.Beams.FlameEffect8, TweenInfo.new(1.7, Enum.EasingStyle.Linear), {
				Brightness = 1.57
			}):Play()
			TweenService:Create(clone14.Beams.FlameEffect9, TweenInfo.new(1.7, Enum.EasingStyle.Linear), {
				Brightness = 1.57
			}):Play()
			TweenService:Create(clone14.Beams.FlameEffect10, TweenInfo.new(1.7, Enum.EasingStyle.Linear), {
				Brightness = 1.57
			}):Play()
			TweenService:Create(clone14.Beams.FlameEffect11, TweenInfo.new(1.7, Enum.EasingStyle.Linear), {
				Brightness = 1.57
			}):Play()
			TweenService:Create(clone14.Beams.FlameEffect12, TweenInfo.new(1.7, Enum.EasingStyle.Linear), {
				Brightness = 1.57
			}):Play()
			TweenService:Create(game.Lighting, TweenInfo.new(1.7), {
				Brightness = 5
			}):Play()
			TweenService:Create(clone14, TweenInfo.new(1.7, Enum.EasingStyle.Cubic, Enum.EasingDirection.In), {
				Position = v993.BlackHoleRobuxTargetPosition
			}):Play()
			TweenService:Create(clone16, TweenInfo.new(1.7, Enum.EasingStyle.Cubic, Enum.EasingDirection.In), {
				Position = v993.BlackHoleRobuxTargetPosition
			}):Play()
			clone14.FlameEffect1_0.BrightFlare.Enabled = true
			clone14.Flames.Enabled = true
			clone14.FlameEffect1_0.FlameRing.Enabled = true
			clone14.FlameEffect1_0.Flames1.Enabled = true
			clone14.FlameEffect1_0.Flames2.Enabled = true
			clone14.FlameEffect1_0.Flames3.Enabled = true
			clone13.Drop1:Play()
			clone13.Drop2:Play()
			clone14.LaunchSound:Play()
			wait(1.7)
			clone13.ExplosionSound:Play()
			clone13.Sparkle:Stop()
			clone15:Destroy()
			BloomEffect.Intensity = 0.75
			BloomEffect.Threshold = 0.05
			ColorCorrectionEffect.Contrast = 0
			TweenService:Create(BloomEffect, TweenInfo.new(10, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0), {
				Intensity = -0.9,
				Threshold = 0.1
			}):Play()
			TweenService:Create(ColorCorrectionEffect, TweenInfo.new(10, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0), {
				Contrast = 0.25
			}):Play()
			v1026:ShakeOnce(12, 4, 1, 6)
			clone14.SelectionSphere:Destroy()
			clone14.FlameEffect1_0.BrightFlare.Enabled = false
			clone14.Flames.Enabled = false
			clone14.FlameEffect1_0.FlameRing.Enabled = false
			clone14.FlameEffect1_0.Flames1.Enabled = false
			clone14.FlameEffect1_0.Flames2.Enabled = false
			clone14.FlameEffect1_0.Flames3.Enabled = false
			TweenService:Create(clone14.Beams.FlameEffect1, TweenInfo.new(0.01, Enum.EasingStyle.Linear), {
				Brightness = 0
			}):Play()
			TweenService:Create(clone14.Beams.FlameEffect2, TweenInfo.new(0.01, Enum.EasingStyle.Linear), {
				Brightness = 0
			}):Play()
			TweenService:Create(clone14.Beams.FlameEffect3, TweenInfo.new(0.01, Enum.EasingStyle.Linear), {
				Brightness = 0
			}):Play()
			TweenService:Create(clone14.Beams.FlameEffect4, TweenInfo.new(0.01, Enum.EasingStyle.Linear), {
				Brightness = 0
			}):Play()
			TweenService:Create(clone14.Beams.FlameEffect5, TweenInfo.new(0.01, Enum.EasingStyle.Linear), {
				Brightness = 0
			}):Play()
			TweenService:Create(clone14.Beams.FlameEffect6, TweenInfo.new(0.01, Enum.EasingStyle.Linear), {
				Brightness = 0
			}):Play()
			TweenService:Create(clone14.Beams.FlameEffect7, TweenInfo.new(0.01, Enum.EasingStyle.Linear), {
				Brightness = 0
			}):Play()
			TweenService:Create(clone14.Beams.FlameEffect8, TweenInfo.new(0.01, Enum.EasingStyle.Linear), {
				Brightness = 0
			}):Play()
			TweenService:Create(clone14.Beams.FlameEffect9, TweenInfo.new(0.01, Enum.EasingStyle.Linear), {
				Brightness = 0
			}):Play()
			TweenService:Create(clone14.Beams.FlameEffect10, TweenInfo.new(0.01, Enum.EasingStyle.Linear), {
				Brightness = 0
			}):Play()
			TweenService:Create(clone14.Beams.FlameEffect11, TweenInfo.new(0.01, Enum.EasingStyle.Linear), {
				Brightness = 0
			}):Play()
			TweenService:Create(clone14.Beams.FlameEffect12, TweenInfo.new(0.01, Enum.EasingStyle.Linear), {
				Brightness = 0
			}):Play()
			TweenService:Create(game.Lighting, TweenInfo.new(0.2), {
				Brightness = 150
			}):Play()
			TweenService:Create(ColorCorrectionEffect, TweenInfo.new(0.05), {
				Brightness = 1.2
			}):Play()
			wait(0.05)
			TweenService:Create(ColorCorrectionEffect, TweenInfo.new(3), {
				Brightness = 0.05
			}):Play()
			TweenService:Create(game.Lighting, TweenInfo.new(7), {
				Brightness = 2.66
			}):Play()
			ImpactVisuals.Parent = game.Workspace
			ImpactVisuals.Position = v993.BlackHoleRobuxTargetPosition
			TweenService:Create(ImpactVisuals, TweenInfo.new(30), {
				Position = Vector3.new(BlackHoleRobuxTargetPosition.X, 500, BlackHoleRobuxTargetPosition.Z)
			}):Play()
			ImpactVisuals.ApplauseLoop:Play()
			ImpactVisuals.CoinsLoop:Play()
			ImpactVisuals.ChimeLoop:Play()
			ImpactVisuals.EmitPoint.Impact_Spark1:Emit(45)
			ImpactVisuals.EmitPoint.Impact_Spark2:Emit(75)
			ImpactVisuals.EmitPoint.Impact_Spark3:Emit(35)
			ImpactVisuals.EmitPoint.Explosion_Glow:Emit(25)
			ImpactVisuals.EmitPoint.Explosion_Rays:Emit(45)
			ImpactVisuals.EmitPoint.Explosion_Ring:Emit(5)
			ImpactVisuals.EmitPoint.Explosion_Flare:Emit(50)
			ImpactVisuals.EmitPoint.Explosion_ThinRays:Emit(35)
			ImpactVisuals.EmitPoint.Explosion_Shockwave:Emit(15)

			local Frame = ImpactVisuals.BillboardGuiAnimation.Frame

			local function v1053(p250)
				return p250
			end

			Frame.RobuxLogo.Size = UDim2.fromScale(0, 0)
			Frame.Star.Size = UDim2.fromScale(0, 0)
			Frame.BottomText.Size = UDim2.fromScale(0, 0)
			Frame.MiddleText.Size = UDim2.fromScale(0, 0)
			Frame.TopText.Size = UDim2.fromScale(0, 0)
			Frame.RobuxLogo.Rotation = -180
			Frame.Star.Rotation = 0
			Frame.Star.ImageTransparency = 0.9
			Frame.TopText.Text = "@" .. v1053(p241) .. " DONATED"
			Frame.MiddleText.Text = "\u{E002}" .. tostring(p243):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")
			Frame.BottomText.Text = "TO @" .. v1053(p242)
			TweenService:Create(Frame.RobuxLogo, TweenInfo.new(15, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out, 0, false, 0), {
				Size = UDim2.fromScale(1, 1)
			}):Play()
			TweenService:Create(Frame.RobuxLogo, TweenInfo.new(10, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out, 0, false, 0), {
				Rotation = 0
			}):Play()
			TweenService:Create(Frame.Star, TweenInfo.new(10), {
				Rotation = 360
			}):Play()
			TweenService:Create(Frame.Star, TweenInfo.new(10), {
				ImageTransparency = 1
			}):Play()
			wait(0.25)
			TweenService:Create(Frame.TopText, TweenInfo.new(5, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out, 0, false, 0), {
				Size = UDim2.fromScale(1.5, 0.1)
			}):Play()
			wait(0.25)
			TweenService:Create(Frame.MiddleText, TweenInfo.new(5, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out, 0, false, 0), {
				Size = UDim2.fromScale(1, 1)
			}):Play()
			wait(0.25)
			TweenService:Create(Frame.BottomText, TweenInfo.new(5, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out, 0, false, 0), {
				Size = UDim2.fromScale(1.5, 0.1)
			}):Play()
			TweenService:Create(clone14, TweenInfo.new(0.4, Enum.EasingStyle.Cubic, Enum.EasingDirection.In), {
				Transparency = 1
			}):Play()
			TweenService:Create(clone16, TweenInfo.new(0.4, Enum.EasingStyle.Cubic, Enum.EasingDirection.In), {
				Transparency = 1
			}):Play()
			ImpactVisuals.EmitPoint.Sparks.Enabled = true
			ImpactVisuals.EmitPoint.SparkleExplosion.Enabled = true
			wait(5)
			TweenService:Create(ImpactVisuals.ChimeLoop, TweenInfo.new(60), {
				Volume = 0
			}):Play()
			TweenService:Create(ImpactVisuals.ApplauseLoop, TweenInfo.new(60), {
				Volume = 0
			}):Play()
			TweenService:Create(ImpactVisuals.CoinsLoop, TweenInfo.new(30), {
				Volume = 0
			}):Play()
			clone16:Remove()
			wait(5)
			clone14:Destroy()
			TweenService:Create(Frame, TweenInfo.new(14, Enum.EasingStyle.Quint, Enum.EasingDirection.In, 0, false, 0), {
				Size = UDim2.fromScale(0, 0)
			}):Play()

			for _, child in pairs(ImpactVisuals.EmitPoint:GetChildren()) do
				if child:IsA("ParticleEmitter") then
					TweenService:Create(child, TweenInfo.new(14), {
						Rate = 0
					}):Play()
				end
			end

			wait(5)
			Frame:Destroy()
			wait(10)
			ImpactVisuals.CoinsLoop:Stop()
			ImpactVisuals.ApplauseLoop:Stop()
			ImpactVisuals.ChimeLoop:Stop()
			v1035 = false
			TweenService:Create(clone13.FireLoop, TweenInfo.new(30, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0), {
				Volume = 0,
				PlaybackSpeed = 0.5
			}):Play()

			for _, child in pairs(clone9:GetChildren()) do
				if child:IsA("ParticleEmitter") then
					TweenService:Create(child, TweenInfo.new(60, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0), {
						Rate = 0
					}):Play()
				end
			end

			for _, child in pairs(clone10:GetChildren()) do
				if child:IsA("ParticleEmitter") then
					TweenService:Create(child, TweenInfo.new(30, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0), {
						Rate = 0
					}):Play()
				end
			end

			TweenService:Create(ColorCorrectionEffect, TweenInfo.new(30, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0), {
				TintColor = Color3.fromRGB(255, 255, 255),
				Brightness = 0,
				Saturation = 0,
				Contrast = 0
			}):Play()
			TweenService:Create(BloomEffect, TweenInfo.new(30, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0), {
				Intensity = -1
			}):Play()
			wait(10)
			ColorCorrectionEffect:Destroy()
			BloomEffect:Destroy()
			clone13:Destroy()
			clone9.Size = Vector3.new(0, 0, 0)
			clone10.Size = Vector3.new(0, 0, 0)
			wait(5)
			n13 -= 1

			if n13 <= 0 then
				n13 = 0
				Lighting.Brightness = Brightness
				Lighting.ClockTime = ClockTime
				Lighting.FogColor = FogColor
			end

			clone9:Destroy()
			clone10:Destroy()
		end

		local LocalPlayer = game:GetService("Players").LocalPlayer

		local function v1061()
			if LocalPlayer:GetAttribute("CenzHideDonateVFX") == true then
				return true
			end

			if _G.CenzHideDonateVFX == true then
				return true
			end

			if LocalPlayer:GetAttribute("GlobalEffects") == false then
				return true
			end

			return false
		end

		p239(game:GetService("ReplicatedStorage").CenzDonateRobuxRS.CenzDonateRobuxModules.CenzDonateRobuxJPass).OnClientEvent("CenzFireBlackHole"):Connect(function(p251, p252, p253)
			if v1061() then
				return
			end

			v1002(p251, p252, p253)
		end)
	end

	v992(script, v24)
end)
