-- andromedaLib

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local Andromeda = {
	Version = "1.0.2",
	Flags = {},
	Windows = {},
	Themes = {
		andromeda = {
			Background = Color3.fromRGB(15,15,18), Panel = Color3.fromRGB(22,22,27),
			Element = Color3.fromRGB(32,32,38), Accent = Color3.fromRGB(120,90,255),
			Text = Color3.fromRGB(235,235,235), Muted = Color3.fromRGB(150,138,150),
			Stroke = Color3.fromRGB(54,51,65),
		},
		amber = {
			Background = Color3.fromRGB(21,20,18), Panel = Color3.fromRGB(30,28,24),
			Element = Color3.fromRGB(40,37,31), Accent = Color3.fromRGB(255,184,66),
			Text = Color3.fromRGB(248,247,242), Muted = Color3.fromRGB(157,151,139),
			Stroke = Color3.fromRGB(67,59,44),
		},
		azure = {
			Background = Color3.fromRGB(17,20,24), Panel = Color3.fromRGB(24,30,36),
			Element = Color3.fromRGB(31,39,47), Accent = Color3.fromRGB(86,195,255),
			Text = Color3.fromRGB(244,247,250), Muted = Color3.fromRGB(140,149,158),
			Stroke = Color3.fromRGB(47,61,73),
		},
		crimson = {
			Background = Color3.fromRGB(20,18,19), Panel = Color3.fromRGB(29,23,24),
			Element = Color3.fromRGB(38,30,31), Accent = Color3.fromRGB(235,74,74),
			Text = Color3.fromRGB(247,244,244), Muted = Color3.fromRGB(157,143,143),
			Stroke = Color3.fromRGB(65,46,48),
		},
		rose = {
			Background = Color3.fromRGB(22,18,21), Panel = Color3.fromRGB(30,23,28),
			Element = Color3.fromRGB(39,31,37), Accent = Color3.fromRGB(255,122,170),
			Text = Color3.fromRGB(248,243,246), Muted = Color3.fromRGB(162,142,151),
			Stroke = Color3.fromRGB(67,48,60),
		},
		mint = {
			Background = Color3.fromRGB(18,22,21), Panel = Color3.fromRGB(24,31,29),
			Element = Color3.fromRGB(32,40,38), Accent = Color3.fromRGB(91,224,176),
			Text = Color3.fromRGB(246,248,247), Muted = Color3.fromRGB(140,150,140),
			Stroke = Color3.fromRGB(47,65,60),
		},
		pearl = {
			Background = Color3.fromRGB(15,15,15), Panel = Color3.fromRGB(28,28,28),
			Element = Color3.fromRGB(45,45,45), Accent = Color3.fromRGB(140,140,140),
			Text = Color3.fromRGB(245,245,245), Muted = Color3.fromRGB(170,170,170),
			Stroke = Color3.fromRGB(67,67,67),
		},
	},
}

local function clone(source)
	local result = {}
	for key, value in pairs(source or {}) do result[key] = value end
	return result
end

local function merge(base, overrides)
	local result = clone(base)
	for key, value in pairs(overrides or {}) do result[key] = value end
	return result
end

local function make(className, properties)
	local object = Instance.new(className)
	local parent = properties and properties.Parent
	for property, value in pairs(properties or {}) do
		if property ~= "Parent" then object[property] = value end
	end
	object.Parent = parent
	return object
end

local function round(parent, radius)
	return make("UICorner", {CornerRadius = UDim.new(0, radius or 8), Parent = parent})
end

local function pad(parent, top, right, bottom, left)
	return make("UIPadding", {
		PaddingTop = UDim.new(0, top or 0), PaddingRight = UDim.new(0, right or 0),
		PaddingBottom = UDim.new(0, bottom or 0), PaddingLeft = UDim.new(0, left or 0),
		Parent = parent,
	})
end

local function tween(object, properties, duration)
	local animation = TweenService:Create(
		object,
		TweenInfo.new(duration or .18, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
		properties
	)
	animation:Play()
	return animation
end

local function role(object, name, property)
	object:SetAttribute("AndromedaRole", name)
	object:SetAttribute("AndromedaProperty", property or "BackgroundColor3")
	return object
end

local function textRole(object, name)
	object:SetAttribute("AndromedaTextRole", name or "Text")
	return object
end

local function text(parent, value, size, color)
	return make("TextLabel", {
		BackgroundTransparency = 1, Size = size or UDim2.fromScale(1,1),
		Font = Enum.Font.Gotham, Text = value or "", TextColor3 = color, TextSize = 13,
		TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd,
		Parent = parent,
	})
end

local function callback(fn, ...)
	if type(fn) ~= "function" then return end
	local ok, err = pcall(fn, ...)
	if not ok then warn("[andromedaLib] callback error:", err) end
end

local function keyCode(value)
	if typeof(value) == "EnumItem" then return value end
	if type(value) == "string" then return Enum.KeyCode[value] end
end

function Andromeda:CreateWindow(config)
	config = config or {}
	local player = Players.LocalPlayer
	assert(player, "andromedaLib must run on the client")

	local themeName = config.ThemeName or "andromeda"
	local theme = merge(self.Themes[themeName] or self.Themes.andromeda, config.Theme)
	local shadowConfig = type(config.Shadow) == "table" and config.Shadow or {}
	local connections, tabs, keybinds = {}, {}, {}
	local selectedTab, listeningBind
	local savedMouseBehavior, savedMouseIconEnabled
	local settings = {
		Notifications = true, NotificationScale = 1, Tooltips = true, Muted = false,
	}
	local guiName = config.GuiName or "andromedaLib"
	local old = player.PlayerGui:FindFirstChild(guiName)
	if old then old:Destroy() end

	local gui = make("ScreenGui", {
		Name = guiName, ResetOnSpawn = false, IgnoreGuiInset = true,
		DisplayOrder = config.DisplayOrder or 9999, ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		Parent = player.PlayerGui,
	})
	local windowSize = config.Size or UDim2.fromOffset(560,360)
	local root = role(make("Frame", {
		Name = "Window", Size = windowSize,
		Position = config.Position or UDim2.fromScale(.5,.5), AnchorPoint = Vector2.new(.5,.5),
		BackgroundColor3 = theme.Background, BorderSizePixel = 0, ClipsDescendants = false, Active = true,
		Parent = gui,
	}), "Background")
	round(root, 14)
	role(make("UIStroke", {Color = theme.Stroke, Transparency = .25, Parent = root}), "Stroke", "Color")
	local uiScale = make("UIScale", {Scale = config.Scale or 1, Parent = root})

	local shadow = make("UIShadow", {
		Name = "Shadow",
		Enabled = config.Shadow ~= false and shadowConfig.Enabled ~= false,
		BlurRadius = shadowConfig.BlurRadius or UDim.new(0,18),
		Color = shadowConfig.Color or Color3.new(0,0,0),
		Offset = shadowConfig.Offset or UDim2.fromOffset(0,7),
		Spread = shadowConfig.Spread or UDim2.fromOffset(8,8),
		Transparency = math.clamp(tonumber(shadowConfig.Transparency) or .5,0,1),
		ZIndex = math.min(math.floor(tonumber(shadowConfig.ZIndex) or -1),-1),
		Parent = root,
	})

	local header = role(make("Frame", {
		Size = UDim2.new(1,0,0,58), BackgroundColor3 = theme.Background,
		BorderSizePixel = 0, Parent = root,
	}), "Background")
	round(header,16)
	local title = textRole(text(header, config.Name or config.Title or ("andromeda v"..Andromeda.Version),
		UDim2.fromOffset(300,30), theme.Text), "Text")
	title.Position, title.Font, title.TextSize = UDim2.fromOffset(20,8), Enum.Font.GothamBold, 26
	local subtitle = textRole(text(header, config.Subtitle or "UI library",
		UDim2.fromOffset(300,20), theme.Muted), "Muted")
	subtitle.Position, subtitle.TextSize = UDim2.fromOffset(20,34), 14

	local searchBox = textRole(role(make("TextBox", {
		Name = "feature search", Size = UDim2.fromOffset(150,30),
		Position = UDim2.new(1,-225,0,12), BackgroundColor3 = theme.Element,
		BorderSizePixel = 0, ClearTextOnFocus = false, PlaceholderText = "search features...",
		PlaceholderColor3 = theme.Muted, Text = "", TextColor3 = theme.Text,
		TextSize = 13, Font = Enum.Font.Gotham, TextXAlignment = Enum.TextXAlignment.Left,
		Parent = header,
	}), "Element"), "Text")
	round(searchBox,8)
	pad(searchBox,0,10,0,10)
	local watermarkLabel = textRole(text(
		header,
		"made with andromedaLib | @7doko",
		UDim2.fromOffset(210,12),
		theme.Muted
	), "Muted")
	watermarkLabel.Name = "Watermark"
	watermarkLabel.Position = UDim2.new(1,-285,0,44)
	watermarkLabel.Font = Enum.Font.GothamBold
	watermarkLabel.TextSize = 9
	watermarkLabel.TextXAlignment = Enum.TextXAlignment.Right
	watermarkLabel.ZIndex = 5
	local minimizeButton = textRole(role(make("TextButton", {
		Name = "Minimize", Size = UDim2.fromOffset(24,24), Position = UDim2.new(1,-64,0,15),
		BackgroundColor3 = theme.Element, BorderSizePixel = 0, AutoButtonColor = false,
		Text = "—", TextColor3 = theme.Text, TextSize = 14, Font = Enum.Font.GothamBold,
		Parent = header,
	}), "Element"), "Text")
	round(minimizeButton,7)
	local closeButton = textRole(role(make("TextButton", {
		Name = "Close", Size = UDim2.fromOffset(24,24), Position = UDim2.new(1,-34,0,15),
		BackgroundColor3 = theme.Element, BorderSizePixel = 0, AutoButtonColor = false,
		Text = "×", TextColor3 = theme.Text, TextSize = 16, Font = Enum.Font.GothamBold,
		Parent = header,
	}), "Element"), "Text")
	round(closeButton,7)

	local sidebar = role(make("ScrollingFrame", {
		Size = UDim2.fromOffset(125,275), Position = UDim2.fromOffset(12,70),
		BackgroundColor3 = theme.Panel, BorderSizePixel = 0, ScrollBarThickness = 2,
		ScrollBarImageColor3 = theme.Accent, CanvasSize = UDim2.new(), Parent = root,
	}), "Panel")
	round(sidebar, 10)
	pad(sidebar, 5,8,5,8)
	local sidebarLayout = make("UIListLayout", {
		Padding = UDim.new(0,6), SortOrder = Enum.SortOrder.LayoutOrder, Parent = sidebar,
	})

	local content = role(make("Frame", {
		Size = UDim2.fromOffset(395,275), Position = UDim2.fromOffset(150,70),
		BackgroundColor3 = theme.Panel, BorderSizePixel = 0, ClipsDescendants = true,
		Parent = root,
	}), "Panel")
	round(content, 10)

	local notifications = make("Frame", {
		Size = UDim2.fromOffset(280,500), Position = UDim2.new(1,-20,1,-20),
		AnchorPoint = Vector2.new(1,1), BackgroundTransparency = 1, Parent = gui,
	})
	make("UIListLayout", {
		Padding = UDim.new(0,8), SortOrder = Enum.SortOrder.LayoutOrder,
		VerticalAlignment = Enum.VerticalAlignment.Bottom,
		HorizontalAlignment = Enum.HorizontalAlignment.Right, Parent = notifications,
	})
	local notificationScale = make("UIScale", {Scale = 1, Parent = notifications})

	local tooltip = role(make("Frame", {
		Size = UDim2.fromOffset(220,34), BackgroundColor3 = theme.Background,
		BackgroundTransparency = .15, BorderSizePixel = 0, Visible = false,
		ZIndex = 10000, Parent = gui,
	}), "Background")
	round(tooltip, 8)
	local tooltipLabel = textRole(text(tooltip, "", UDim2.new(1,-16,1,0), theme.Text), "Text")
	tooltipLabel.Position, tooltipLabel.TextSize = UDim2.fromOffset(8,0), 11
	tooltipLabel.TextWrapped, tooltipLabel.ZIndex = true, 10001

	local clickSound = make("Sound", {
		SoundId = "rbxassetid://6895079853", Volume = .3, Parent = gui,
	})
	local hoverSound = make("Sound", {
		SoundId = "rbxassetid://107511012621133", Volume = .85, Parent = gui,
	})
	local sliderSound = make("Sound", {
		SoundId = "rbxassetid://93076868992220", Volume = .05, PlaybackSpeed = 1.1, Parent = gui,
	})

	local window = {
		Gui = gui, Main = root, Theme = theme, Tabs = tabs, Connections = connections,
		Keybinds = keybinds, Visible = false, Minimized = false, Settings = settings, Shadow = shadow,
		MinimizeButton = minimizeButton, CloseButton = closeButton,
	}

	local function play(sound)
		if not settings.Muted then sound:Play() end
	end

	local function refreshCanvas(scroller, layout, extra)
		local function update()
			scroller.CanvasSize = UDim2.fromOffset(0, layout.AbsoluteContentSize.Y + (extra or 0))
		end
		update()
		table.insert(connections, layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(update))
	end
	refreshCanvas(sidebar, sidebarLayout, 20)

	local function attachTooltip(object, description)
		if not description then return end
		table.insert(connections, object.MouseEnter:Connect(function()
			play(hoverSound)
			if settings.Tooltips then
				tooltipLabel.Text = tostring(description)
				tooltip.Visible = true
			end
		end))
		table.insert(connections, object.MouseLeave:Connect(function()
			tooltip.Visible = false
		end))
	end
	for _, buttonData in ipairs({
		{Button=minimizeButton, Tooltip="collapses or restores the window"},
		{Button=closeButton, Tooltip="hides the window; press the menu keybind to reopen it"},
	}) do
		local button = buttonData.Button
		attachTooltip(button,buttonData.Tooltip)
		table.insert(connections,button.MouseEnter:Connect(function() tween(button,{BackgroundColor3=theme.Accent},.15) end))
		table.insert(connections,button.MouseLeave:Connect(function() tween(button,{BackgroundColor3=theme.Element},.15) end))
	end
	table.insert(connections,minimizeButton.MouseButton1Click:Connect(function()
		play(clickSound);window:ToggleMinimized()
	end))
	table.insert(connections,closeButton.MouseButton1Click:Connect(function()
		play(clickSound);window:Close()
	end))
	table.insert(connections, UserInputService.InputChanged:Connect(function(input)
		if tooltip.Visible and input.UserInputType == Enum.UserInputType.MouseMovement then
			tooltip.Position = UDim2.fromOffset(input.Position.X + 15, input.Position.Y + 15)
		end
	end))

	function window:Notify(options, duration)
		if not settings.Notifications then return end
		options = type(options) == "table" and options or {Content = tostring(options), Duration = duration}
		local box = role(make("Frame", {
			Size = UDim2.fromOffset(220,45), Position = UDim2.fromOffset(40,0),
			BackgroundColor3 = theme.Element, BackgroundTransparency = 1,
			BorderSizePixel = 0, Parent = notifications,
		}), "Element")
		round(box, 10)
		local noticeText = textRole(text(box,
			options.Content or options.Text or options.Title or "notification",
			UDim2.new(1,-20,1,0), theme.Text), "Text")
		noticeText.Position, noticeText.Font = UDim2.fromOffset(10,0), Enum.Font.GothamBold
		noticeText.TextTransparency = 1
		tween(box, {Position = UDim2.new(), BackgroundTransparency = .15}, .25)
		tween(noticeText, {TextTransparency = 0}, .25)
		task.delay(options.Duration or duration or 3, function()
			if not box.Parent then return end
			tween(box, {Position = UDim2.fromOffset(40,0), BackgroundTransparency = 1}, .25)
			tween(noticeText, {TextTransparency = 1}, .25)
			task.wait(.25)
			box:Destroy()
		end)
	end

	local function fire(options, ...)
		callback(options and options.Callback, ...)
		local notice = options and (options.Notification or options.Notify)
		if notice then
			if type(notice) == "table" then window:Notify(notice)
			else window:Notify({Content = tostring(notice), Duration = 2}) end
		end
	end

	function window:SetVisible(value)
		local visible = value == true

		if visible and not self.Visible then
			savedMouseBehavior = UserInputService.MouseBehavior
			savedMouseIconEnabled = UserInputService.MouseIconEnabled
		elseif not visible and self.Visible then
			if savedMouseBehavior then
				UserInputService.MouseBehavior = savedMouseBehavior
			end
			if savedMouseIconEnabled ~= nil then
				UserInputService.MouseIconEnabled = savedMouseIconEnabled
			end
		end

		self.Visible = visible
		root.Visible = visible

		if visible then
			UserInputService.MouseBehavior = Enum.MouseBehavior.Default
			UserInputService.MouseIconEnabled = true
		end
	end
	function window:Toggle() self:SetVisible(not self.Visible) end
	function window:SetMinimized(value)
		local minimized = value == true
		self.Minimized = minimized
		sidebar.Visible = not minimized
		content.Visible = not minimized
		root.Size = minimized and UDim2.new(windowSize.X.Scale,windowSize.X.Offset,0,58) or windowSize
		minimizeButton.Text = minimized and "+" or "—"
	end
	function window:ToggleMinimized() self:SetMinimized(not self.Minimized) end
	function window:Close() self:SetVisible(false) end
	function window:SetScale(value) uiScale.Scale = math.clamp(tonumber(value) or 1, .5, 1.5) end
	function window:SetShadow(values)
		if type(values) == "boolean" then shadow.Enabled = values return end
		local allowed = {
			Enabled=true,BlurRadius=true,Color=true,Offset=true,Spread=true,
			Transparency=true,ZIndex=true,
		}
		for property,value in pairs(values or {}) do
			if allowed[property] then pcall(function() shadow[property]=value end) end
		end
	end
	function window:SetTheme(nextTheme)
		if type(nextTheme) == "string" then
			theme = merge(Andromeda.Themes[nextTheme] or Andromeda.Themes.andromeda)
		else
			for key, value in pairs(nextTheme or {}) do theme[key] = value end
		end
		self.Theme = theme
		for _, object in ipairs(gui:GetDescendants()) do
			local themeRole, property = object:GetAttribute("AndromedaRole"), object:GetAttribute("AndromedaProperty")
			if themeRole and property and theme[themeRole] then
				pcall(function() object[property] = theme[themeRole] end)
			end
			local tr = object:GetAttribute("AndromedaTextRole")
			if tr and theme[tr] then pcall(function() object.TextColor3 = theme[tr] end) end
			if object:IsA("ScrollingFrame") then object.ScrollBarImageColor3 = theme.Accent end
		end
	end
	function window:ClearKeybinds(includeLocked)
		for _, bind in ipairs(keybinds) do
			if includeLocked or not bind.Locked then bind:SetKey(nil) end
		end
	end
	function window:Destroy()
		for _, connection in ipairs(connections) do connection:Disconnect() end
		table.clear(connections)
		gui:Destroy()
		for index, item in ipairs(Andromeda.Windows) do
			if item == self then table.remove(Andromeda.Windows,index) break end
		end
	end

	local function addBindWidget(row, handler, options, offset)
		local bind = {
			Key = keyCode(options.CurrentKeybind or options.Keybind),
			Locked = options.LockKeybind == true,
			Rebindable = options.Rebindable == true or options.LockKeybind ~= true,
			AllowProcessed = options.AllowProcessed == true,
		}
		local button = textRole(role(make("TextButton", {
			Size = UDim2.fromOffset(38,20), Position = UDim2.new(1,offset or -55,.5,-10),
			BackgroundColor3 = theme.Panel, BorderSizePixel = 0, AutoButtonColor = false,
			Text = bind.Key and bind.Key.Name or "...", TextColor3 = theme.Text,
			TextSize = 10, Font = Enum.Font.GothamBold, Parent = row,
		}), "Panel"), "Text")
		round(button, 6)
		function bind:SetKey(nextKey)
			self.Key = keyCode(nextKey)
			button.Text = self.Key and self.Key.Name or "..."
			if options.Flag then Andromeda.Flags[options.Flag.."_Keybind"] = self.Key end
		end
		function bind:GetKey() return self.Key end
		function bind:ClearKey() self:SetKey(nil) end
		bind.Handler = handler
		table.insert(keybinds, bind)
		table.insert(connections, button.MouseButton1Click:Connect(function()
			if not bind.Rebindable then return end
			listeningBind = bind
			button.Text = "..."
			play(clickSound)
		end))
		table.insert(connections, button.MouseButton2Click:Connect(function()
			if not bind.Locked then bind:SetKey(nil) end
		end))
		table.insert(connections,button.MouseEnter:Connect(function()
			if listeningBind~=bind then tween(button,{BackgroundColor3=theme.Accent},.15) end
		end))
		table.insert(connections,button.MouseLeave:Connect(function()
			if listeningBind~=bind then tween(button,{BackgroundColor3=theme.Panel},.15) end
		end))
		return bind
	end

	local function buildControls(api, parent)
		local function row(name, height)
			local object = role(make("Frame", {
				Name = name, Size = UDim2.new(1,-30,0,height or 45),
				BackgroundColor3 = theme.Element, BorderSizePixel = 0, Parent = parent,
			}), "Element")
			round(object, 10)
			return object
		end

		function api:CreateLabel(value)
			value = type(value) == "table" and (value.Text or value.Content) or value
			local object = textRole(text(parent, tostring(value or ""), UDim2.new(1,0,0,28), theme.Muted), "Muted")
			object.TextWrapped = true
			return {Set = function(_,nextValue) object.Text = tostring(nextValue) end, Instance = object}
		end

		function api:CreateParagraph(options)
			options = options or {}
			local object = row(options.Title or "Paragraph", 64)
			local heading = textRole(text(object, options.Title or "Paragraph", UDim2.new(1,-24,0,20), theme.Text), "Text")
			heading.Position, heading.Font = UDim2.fromOffset(12,8), Enum.Font.GothamBold
			local body = textRole(text(object, options.Content or "", UDim2.new(1,-24,0,28), theme.Muted), "Muted")
			body.Position, body.TextWrapped, body.TextYAlignment = UDim2.fromOffset(12,29), true, Enum.TextYAlignment.Top
			return {Set = function(_,data)
				if type(data)=="table" then heading.Text=data.Title or heading.Text; body.Text=data.Content or body.Text
				else body.Text=tostring(data) end
			end}
		end

		function api:CreateButton(options)
			options = options or {}
			local object = row(options.Name or "Button")
			local name = textRole(text(object, options.Name or "Button", UDim2.new(1,-125,1,0), theme.Text), "Text")
			name.Position = UDim2.fromOffset(15,0)
			local control = {}
			local function press()
				play(clickSound)
				tween(object,{Size=UDim2.new(1,-34,0,43)},.08)
				task.delay(.08,function() if object.Parent then tween(object,{Size=UDim2.new(1,-30,0,45)},.08) end end)
				fire(options)
			end
			local bind = addBindWidget(object, press, options, -55)
			for key, value in pairs(bind) do control[key] = value end
			function control:Fire() press() end
			function control:Set(value) name.Text=tostring(value) end
			local hit = make("TextButton",{Size=UDim2.new(1,-65,1,0),BackgroundTransparency=1,Text="",Parent=object})
			table.insert(connections,hit.MouseButton1Click:Connect(press))
			table.insert(connections,hit.MouseEnter:Connect(function() tween(object,{BackgroundColor3=theme.Accent},.15) end))
			table.insert(connections,hit.MouseLeave:Connect(function() tween(object,{BackgroundColor3=theme.Element},.15) end))
			attachTooltip(object, options.Description or options.Tooltip)
			return setmetatable(control,{__index=bind})
		end

		function api:CreateToggle(options)
			options = options or {}
			local value = options.CurrentValue == true or options.Default == true
			local object = row(options.Name or "Toggle")
			local name = textRole(text(object,options.Name or "Toggle",UDim2.new(1,-165,1,0),theme.Text),"Text")
			name.Position=UDim2.fromOffset(15,0)
			local switch = make("Frame",{Size=UDim2.fromOffset(42,20),Position=UDim2.new(1,-58,.5,-10),
				BackgroundColor3=value and theme.Accent or Color3.fromRGB(55,58,65),BorderSizePixel=0,Parent=object})
			round(switch,20)
			local knob=make("Frame",{Size=UDim2.fromOffset(16,16),Position=value and UDim2.fromOffset(24,2) or UDim2.fromOffset(2,2),
				BackgroundColor3=Color3.new(1,1,1),BorderSizePixel=0,Parent=switch})
			round(knob,20)
			local switchHit=make("TextButton",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,
				BorderSizePixel=0,Text="",AutoButtonColor=false,ZIndex=2,Parent=switch})
			local control={}
			function control:Set(nextValue,silent)
				value=nextValue==true
				if options.Flag then Andromeda.Flags[options.Flag]=value end
				tween(switch,{BackgroundColor3=value and theme.Accent or Color3.fromRGB(55,58,65)},.22)
				tween(knob,{Position=value and UDim2.fromOffset(24,2) or UDim2.fromOffset(2,2)},.22)
				if not silent then fire(options,value) end
			end
			function control:Get() return value end
			local function toggle() play(clickSound); control:Set(not value) end
			local bind=addBindWidget(object,toggle,options,-105)
			control.SetKey=function(_,v) bind:SetKey(v) end
			control.GetKey=function() return bind:GetKey() end
			control.ClearKey=function() bind:ClearKey() end
			local hit=make("TextButton",{Size=UDim2.new(1,-55,1,0),BackgroundTransparency=1,Text="",Parent=object})
			table.insert(connections,hit.MouseButton1Click:Connect(toggle))
			table.insert(connections,switchHit.MouseButton1Click:Connect(toggle))
			if options.Flag then Andromeda.Flags[options.Flag]=value end
			attachTooltip(object,options.Description or options.Tooltip)
			return control
		end

		local function sliderControl(options, host, compact)
			options=options or {}
			local range=options.Range or {options.Min or 0,options.Max or 100}
			local minimum,maximum=range[1] or 0,range[2] or 100
			local increment=options.Increment or options.Step or 1
			local default=math.clamp(tonumber(options.CurrentValue or options.Default) or minimum,minimum,maximum)
			default=math.floor(default/increment+.5)*increment
			local value=default
			local object=host or row(options.Name or "Slider",compact and 50 or 55)
			local name=textRole(text(object,"",UDim2.new(1,-55,0,22),theme.Text),"Text")
			name.Position=UDim2.fromOffset(15,5)
			local reset=role(make("ImageButton",{Size=UDim2.fromOffset(22,22),Position=UDim2.new(1,-30,0,5),
				BackgroundColor3=theme.Panel,BorderSizePixel=0,Image="rbxassetid://122692941570456",
				ImageColor3=theme.Text,AutoButtonColor=false,Visible=false,Parent=object}),"Panel")
			round(reset,8)
			local bar=make("Frame",{Size=UDim2.new(1,-30,0,6),Position=UDim2.fromOffset(15,37),
				BackgroundColor3=Color3.fromRGB(55,58,65),BorderSizePixel=0,Parent=object})
			round(bar,20)
			local fill=role(make("Frame",{BackgroundColor3=theme.Accent,BorderSizePixel=0,Parent=bar}),"Accent")
			round(fill,20)
			local knob=make("Frame",{Size=UDim2.fromOffset(14,14),AnchorPoint=Vector2.new(.5,.5),
				BackgroundColor3=Color3.new(1,1,1),BorderSizePixel=0,Parent=bar})
			round(knob,20)
			local control={}
			local function format(v)
				local decimals=math.max(0,math.floor(math.log10(1/increment)+.5))
				return string.format("%."..decimals.."f",v)..(options.Suffix or "")
			end
			function control:Set(nextValue,silent)
				value=math.clamp(tonumber(nextValue) or minimum,minimum,maximum)
				value=math.floor(value/increment+.5)*increment
				local span=maximum-minimum
				local ratio=span~=0 and (value-minimum)/span or 0
				name.Text=(options.Name or "Slider").."   "..format(value)
				fill.Size=UDim2.fromScale(ratio,1); knob.Position=UDim2.new(ratio,0,.5,0)
				reset.Visible=value~=default
				if options.Flag then Andromeda.Flags[options.Flag]=value end
				if not silent then fire(options,value) end
			end
			function control:Get() return value end
			function control:Reset() control:Set(default) end
			control:Set(value,true)
			local dragging=false
			local function update(input)
				local ratio=math.clamp((input.Position.X-bar.AbsolutePosition.X)/bar.AbsoluteSize.X,0,1)
				play(sliderSound); control:Set(minimum+(maximum-minimum)*ratio)
			end
			table.insert(connections,bar.InputBegan:Connect(function(input)
				if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then dragging=true;update(input) end
			end))
			table.insert(connections,UserInputService.InputChanged:Connect(function(input)
				if dragging and (input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch) then update(input) end
			end))
			table.insert(connections,UserInputService.InputEnded:Connect(function(input)
				if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then dragging=false end
			end))
			table.insert(connections,reset.MouseButton1Click:Connect(function() play(clickSound);control:Reset() end))
			table.insert(connections,reset.MouseEnter:Connect(function() tween(reset,{BackgroundColor3=theme.Accent},.15) end))
			table.insert(connections,reset.MouseLeave:Connect(function() tween(reset,{BackgroundColor3=theme.Panel},.15) end))
			attachTooltip(object,options.Description or options.Tooltip)
			return control
		end
		function api:CreateSlider(options) return sliderControl(options) end

		function api:CreateColorPicker(options)
			options=options or {}
			local default=options.Color or options.CurrentColor or options.Default or Color3.new(1,1,1)
			local h,s,v=Color3.toHSV(default)
			local object=row(options.Name or "Color Picker",205)
			local name=textRole(text(object,options.Name or "Color Picker",UDim2.new(1,-70,0,28),theme.Text),"Text")
			name.Position=UDim2.fromOffset(15,5)
			local preview=make("Frame",{Size=UDim2.fromOffset(35,35),Position=UDim2.new(1,-50,0,5),
				BackgroundColor3=default,BorderSizePixel=0,Parent=object})
			round(preview,8)
			local control={}
			local updating=false
			local function changed()
				if updating then return end
				local color=Color3.fromHSV(h,s,v)
				preview.BackgroundColor3=color
				if options.Flag then Andromeda.Flags[options.Flag]=color end
				fire(options,color)
			end
			local hs=sliderControl({Name="hue",Range={0,360},Increment=1,CurrentValue=h*360,
				Callback=function(x) h=x/360;changed() end},make("Frame",{Size=UDim2.new(1,-30,0,48),Position=UDim2.fromOffset(15,48),BackgroundTransparency=1,Parent=object}),true)
			local ss=sliderControl({Name="saturation",Range={0,100},Increment=1,CurrentValue=s*100,
				Callback=function(x) s=x/100;changed() end},make("Frame",{Size=UDim2.new(1,-30,0,48),Position=UDim2.fromOffset(15,98),BackgroundTransparency=1,Parent=object}),true)
			local vs=sliderControl({Name="brightness",Range={0,100},Increment=1,CurrentValue=v*100,
				Callback=function(x) v=x/100;changed() end},make("Frame",{Size=UDim2.new(1,-30,0,48),Position=UDim2.fromOffset(15,148),BackgroundTransparency=1,Parent=object}),true)
			function control:Get() return Color3.fromHSV(h,s,v) end
			function control:Set(color,silent)
				updating=true; h,s,v=Color3.toHSV(color); hs:Set(h*360,true);ss:Set(s*100,true);vs:Set(v*100,true);updating=false
				preview.BackgroundColor3=color
				if options.Flag then Andromeda.Flags[options.Flag]=color end
				if not silent then fire(options,color) end
			end
			function control:Reset() control:Set(default) end
			if options.Flag then Andromeda.Flags[options.Flag]=default end
			attachTooltip(object,options.Description or options.Tooltip)
			return control
		end

		local function dropdown(options,multiple)
			options=options or {}
			local choices=options.Options or {}
			local selected={}
			local current=options.CurrentOption or options.Default
			if multiple then
				for _,choice in ipairs(type(current)=="table" and current or {}) do selected[choice]=true end
			elseif type(current)=="table" then current=current[1] end
			current=current or choices[1]
			local object=row(options.Name or (multiple and "Multi Dropdown" or "Dropdown"),45)
			object.ClipsDescendants=true; object.ZIndex=5
			local name=textRole(text(object,options.Name or "Dropdown",UDim2.new(.5,-10,0,45),theme.Text),"Text")
			name.Position=UDim2.fromOffset(15,0)
			local valueLabel=textRole(text(object,"",UDim2.new(.5,-65,0,45),theme.Muted),"Muted")
			valueLabel.Position=UDim2.new(.5,0,0,0);valueLabel.TextXAlignment=Enum.TextXAlignment.Right
			local arrow=role(make("ImageLabel",{Size=UDim2.fromOffset(20,20),Position=UDim2.new(1,-30,0,12),
				BackgroundTransparency=1,Image="rbxassetid://116302930717338",
				ImageColor3=theme.Text,ZIndex=6,Parent=object}),"Text","ImageColor3")
			local holder=role(make("ScrollingFrame",{Size=UDim2.new(1,-20,0,0),Position=UDim2.fromOffset(10,48),
				BackgroundColor3=theme.Panel,BorderSizePixel=0,ScrollBarThickness=3,
				ScrollBarImageColor3=theme.Accent,CanvasSize=UDim2.new(),
				Visible=false,ZIndex=10,Parent=object}),"Panel")
			round(holder,8)
			local layout=make("UIListLayout",{Padding=UDim.new(0,4),Parent=holder})
			refreshCanvas(holder,layout,8)
			local opened,buttons=false,{}
			local control={}
			local function values()
				local result={};for _,choice in ipairs(choices) do if selected[choice] then table.insert(result,choice) end end;return result
			end
			local function updateLabel()
				if multiple then
					local list=values()
					valueLabel.Text=#list==0 and "none" or (#list==1 and tostring(list[1]) or (#list.." selected"))
				else valueLabel.Text=tostring(current or "none") end
			end
			local function rebuild()
				for _,button in ipairs(buttons) do button:Destroy() end;table.clear(buttons)
				for _,choice in ipairs(choices) do
					local option=textRole(role(make("TextButton",{Size=UDim2.new(1,-8,0,26),BackgroundColor3=theme.Panel,
						BorderSizePixel=0,AutoButtonColor=false,Text=tostring(choice),TextColor3=theme.Text,
						TextSize=12,Font=Enum.Font.Gotham,Parent=holder,ZIndex=11}),"Panel"),"Text")
					round(option,6);table.insert(buttons,option)
					local function refreshOption()
						local active=multiple and selected[choice]==true
						option.Text=tostring(choice)
						option:SetAttribute("AndromedaRole",active and "Accent" or "Panel")
						tween(option,{BackgroundColor3=active and theme.Accent or theme.Panel},.15)
					end
					table.insert(connections,option.MouseEnter:Connect(function() tween(option,{BackgroundColor3=theme.Accent},.15) end))
					table.insert(connections,option.MouseLeave:Connect(refreshOption))
					table.insert(connections,option.MouseButton1Click:Connect(function()
						play(clickSound)
						if multiple then
							selected[choice]=not selected[choice] or nil
							refreshOption()
							if options.Flag then Andromeda.Flags[options.Flag]=values() end
							updateLabel()
							fire(options,values())
						else current=choice;if options.Flag then Andromeda.Flags[options.Flag]=current end;updateLabel();fire(options,current)
							opened=false;tween(object,{Size=UDim2.new(1,-30,0,45)});tween(arrow,{Rotation=0});holder.Visible=false end
					end))
					refreshOption()
				end
			end
			function control:Get() return multiple and values() or current end
			function control:Set(nextValue,silent)
				if multiple then
					table.clear(selected);for _,choice in ipairs(type(nextValue)=="table" and nextValue or {nextValue}) do if table.find(choices,choice) then selected[choice]=true end end
				elseif table.find(choices,nextValue) then current=nextValue end
				rebuild();updateLabel()
				if options.Flag then Andromeda.Flags[options.Flag]=control:Get() end
				if not silent then fire(options,control:Get()) end
			end
			function control:Refresh(nextChoices,keep)
				choices=nextChoices or {};if not keep then current=choices[1];table.clear(selected) end;rebuild();updateLabel()
			end
			rebuild();updateLabel()
			if options.Flag then Andromeda.Flags[options.Flag]=control:Get() end
			local hit=make("TextButton",{Size=UDim2.new(1,0,0,45),BackgroundTransparency=1,Text="",Parent=object,ZIndex=6})
			table.insert(connections,hit.MouseButton1Click:Connect(function()
				play(clickSound);opened=not opened;holder.Visible=opened
				local height=math.min(#choices*30+8,180)
				tween(object,{Size=UDim2.new(1,-30,0,opened and (53+height) or 45)})
				tween(holder,{Size=UDim2.new(1,-20,0,opened and height or 0)})
				tween(arrow,{Rotation=opened and 180 or 0})
			end))
			attachTooltip(object,options.Description or options.Tooltip)
			return control
		end
		function api:CreateDropdown(options)
			return dropdown(options,options and options.MultipleOptions==true)
		end
		function api:CreateMultiDropdown(options) return dropdown(options,true) end

		function api:CreateInput(options)
			options=options or {}
			local object=row(options.Name or "Input",45)
			local box=textRole(role(make("TextBox",{Size=UDim2.new(1,-20,1,-10),Position=UDim2.fromOffset(10,5),
				BackgroundColor3=theme.Panel,BorderSizePixel=0,ClearTextOnFocus=false,
				PlaceholderText=options.PlaceholderText or options.Name or "Enter text",
				PlaceholderColor3=theme.Muted,Text=options.CurrentValue or options.Default or "",
				TextColor3=theme.Text,TextSize=12,TextXAlignment=Enum.TextXAlignment.Left,
				Font=Enum.Font.Gotham,Parent=object}),"Panel"),"Text")
			round(box,7);pad(box,0,10,0,10)
			if options.Flag then Andromeda.Flags[options.Flag]=box.Text end
			table.insert(connections,box.FocusLost:Connect(function(enter)
				if options.Flag then Andromeda.Flags[options.Flag]=box.Text end
				fire(options,box.Text,enter)
				if options.RemoveTextAfterFocusLost then box.Text="" end
			end))
			attachTooltip(object,options.Description or options.Tooltip)
			return {Get=function() return box.Text end,Set=function(_,v) box.Text=tostring(v) end,Instance=box}
		end

		function api:CreateKeybind(options)
			options=options or {}
			local object=row(options.Name or "Keybind")
			local name=textRole(text(object,options.Name or "Keybind",UDim2.new(1,-105,1,0),theme.Text),"Text")
			name.Position=UDim2.fromOffset(15,0)
			local bind=addBindWidget(object,function() fire(options) end,options,-55)
			attachTooltip(object,options.Description or options.Tooltip)
			return bind
		end

		api.AddButton=api.CreateButton;api.AddToggle=api.CreateToggle;api.AddSlider=api.CreateSlider
		api.AddColorPicker=api.CreateColorPicker;api.AddDropdown=api.CreateDropdown
		api.AddMultiDropdown=api.CreateMultiDropdown;api.AddInput=api.CreateInput
		api.AddTextbox=api.CreateInput;api.AddKeybind=api.CreateKeybind
		api.AddLabel=api.CreateLabel;api.AddParagraph=api.CreateParagraph
	end

	function window:CreateTab(tabConfig,icon)
		tabConfig=type(tabConfig)=="table" and tabConfig or {Name=tostring(tabConfig or "Tab"),Icon=icon}
		local tab={Name=tabConfig.Name or "Tab",Internal=tabConfig.Internal==true}
		local button=textRole(role(make("TextButton",{Size=UDim2.new(1,0,0,38),BackgroundColor3=theme.Element,
			BackgroundTransparency=0,BorderSizePixel=0,AutoButtonColor=false,Text=tab.Name,
			TextColor3=theme.Text,TextSize=16,TextXAlignment=Enum.TextXAlignment.Center,
			Font=Enum.Font.GothamBold,Parent=sidebar}),"Element"),"Text")
		round(button,8);tab.Button=button
		local page=make("ScrollingFrame",{Name=tab.Name,Size=UDim2.fromScale(1,1),BackgroundTransparency=1,
			BorderSizePixel=0,ScrollBarThickness=3,ScrollBarImageColor3=theme.Accent,
			CanvasSize=UDim2.new(),Visible=false,Parent=content})
		pad(page,5,5,5,5)
		local layout=make("UIListLayout",{Padding=UDim.new(0,9),SortOrder=Enum.SortOrder.LayoutOrder,Parent=page})
		refreshCanvas(page,layout,20);tab.Page=page
		local function select()
			selectedTab=tab
			for _,other in ipairs(tabs) do
				local on=other==tab;other.Page.Visible=on
				other.Button:SetAttribute("AndromedaTextRole","Text")
				other.Button:SetAttribute("AndromedaRole",on and "Accent" or "Element")
				tween(other.Button,{BackgroundTransparency=0,BackgroundColor3=on and theme.Accent or theme.Element,TextColor3=theme.Text})
			end
		end
		function tab:Select() select() end
		function tab:CreateSection(sectionConfig)
			sectionConfig=type(sectionConfig)=="table" and sectionConfig or {Name=tostring(sectionConfig or "Section")}
			local hidden=sectionConfig.Hidden==true or sectionConfig.ShowTitle==false
			local section=make("Frame",{
				Name=sectionConfig.Name or "Section",Size=UDim2.new(1,0,0,0),
				AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1,BorderSizePixel=0,Parent=page,
			})
			section:SetAttribute("AndromedaSection",true)
			make("UIListLayout",{Padding=UDim.new(0,10),SortOrder=Enum.SortOrder.LayoutOrder,Parent=section})
			if not hidden then
				local heading=textRole(text(section,sectionConfig.Name or "Section",UDim2.new(1,-30,0,24),theme.Muted),"Muted")
				heading.Font,heading.TextSize,heading.LayoutOrder=Enum.Font.GothamBold,12,-1000
				heading:SetAttribute("AndromedaSectionHeading",true)
			end
			local sectionApi={Instance=section}
			buildControls(sectionApi,section)
			return sectionApi
		end
		buildControls(tab,page)
		tab.AddSection=tab.CreateSection
		table.insert(connections,button.MouseButton1Click:Connect(function() play(clickSound);select() end))
		table.insert(connections,button.MouseEnter:Connect(function()
			play(hoverSound)
			if selectedTab~=tab then tween(button,{BackgroundColor3=theme.Accent},.15) end
		end))
		table.insert(connections,button.MouseLeave:Connect(function()
			if selectedTab~=tab then tween(button,{BackgroundColor3=theme.Element},.15) end
		end))
		table.insert(tabs,tab)
		if not selectedTab or (selectedTab.Internal and not tab.Internal) then select() end
		return tab
	end

	table.insert(connections,UserInputService.InputBegan:Connect(function(input,processed)
		if listeningBind then
			if input.UserInputType==Enum.UserInputType.Keyboard then listeningBind:SetKey(input.KeyCode);listeningBind=nil end
			return
		end
		for _,bind in ipairs(keybinds) do
			if bind.Key and bind.Key==input.KeyCode and (not processed or bind.AllowProcessed) then
				callback(bind.Handler)
			end
		end
	end))

	local dragging=false;local dragStart;local startPosition
	local function beginDrag(input)
		if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
			dragging=true;dragStart=input.Position;startPosition=root.Position
		end
	end
	table.insert(connections,header.InputBegan:Connect(beginDrag))
	table.insert(connections,root.InputBegan:Connect(beginDrag))
	table.insert(connections,UserInputService.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch) then
			local delta=input.Position-dragStart
			root.Position=UDim2.new(startPosition.X.Scale,startPosition.X.Offset+delta.X,startPosition.Y.Scale,startPosition.Y.Offset+delta.Y)
		end
	end))
	table.insert(connections,UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then dragging=false end
	end))
	local function featureMatches(object,query)
		if query=="" then return true end
		if string.find(string.lower(object.Name),query,1,true) then return true end
		for _,descendant in ipairs(object:GetDescendants()) do
			if (descendant:IsA("TextLabel") or descendant:IsA("TextButton") or descendant:IsA("TextBox"))
				and string.find(string.lower(descendant.Text),query,1,true) then return true end
		end
		return false
	end
	local function applySearch()
		local query=string.lower(searchBox.Text):match("^%s*(.-)%s*$")
		if not selectedTab then return end
		for _,child in ipairs(selectedTab.Page:GetChildren()) do
			if child:IsA("GuiObject") then
				if child:GetAttribute("AndromedaSection") then
					local anyVisible=false
					for _,control in ipairs(child:GetChildren()) do
						if control:IsA("GuiObject") and not control:GetAttribute("AndromedaSectionHeading") then
							local visible=featureMatches(control,query)
							control.Visible=visible
							if visible then anyVisible=true end
						end
					end
					child.Visible=query=="" or anyVisible
				else
					child.Visible=featureMatches(child,query)
				end
			end
		end
	end
	table.insert(connections,searchBox:GetPropertyChangedSignal("Text"):Connect(applySearch))

	table.insert(Andromeda.Windows,window);Andromeda.LastWindow=window

	if config.SettingsTab ~= false then
		local settingsTab=window:CreateTab({Name=config.SettingsTabName or "Settings",Internal=true})
		window.SettingsTab=settingsTab

		local appearance=settingsTab:CreateSection("Appearance")
		local themeNames={}
		for name in pairs(Andromeda.Themes) do table.insert(themeNames,name) end
		table.sort(themeNames)

		appearance:CreateDropdown({
			Name="Theme",Options=themeNames,CurrentOption=themeName,
			Description="changes every themed element in the current window",
			Callback=function(value) window:SetTheme(value) end,
		})
		appearance:CreateSlider({
			Name="Window scale",Range={.5,1.5},Increment=.05,CurrentValue=config.Scale or 1,
			Description="changes the scale of the full Andromeda window",
			Callback=function(value) window:SetScale(value) end,
		})

		local shadowSettings=settingsTab:CreateSection("Shadow")
		shadowSettings:CreateToggle({
			Name="Shadow enabled",CurrentValue=shadow.Enabled,
			Description="shows or hides the native window shadow",
			Callback=function(enabled) window:SetShadow(enabled) end,
		})
		shadowSettings:CreateColorPicker({
			Name="Shadow color",Color=shadow.Color,
			Description="changes the native shadow color",
			Callback=function(value) window:SetShadow({Color=value}) end,
		})
		local behavior=settingsTab:CreateSection("Behavior")
		behavior:CreateToggle({
			Name="Notifications",CurrentValue=true,
			Description="enables or disables interface notifications",
			Callback=function(enabled)
				settings.Notifications=enabled
				if enabled then window:Notify("notifications enabled",1) end
			end,
		})
		behavior:CreateSlider({
			Name="Notification scale",Range={.5,1.2},Increment=.01,CurrentValue=1,
			Description="changes the size of interface notifications",
			Callback=function(value)
				settings.NotificationScale=value
				notificationScale.Scale=value
			end,
		})
		behavior:CreateToggle({
			Name="Tooltips",CurrentValue=true,
			Description="enables or disables control descriptions on hover",
			Callback=function(enabled)
				settings.Tooltips=enabled
				if not enabled then tooltip.Visible=false end
			end,
		})
		behavior:CreateToggle({
			Name="Mute interface sounds",CurrentValue=false,
			Description="mutes click, hover, and slider sounds",
			Callback=function(enabled)
				settings.Muted=enabled
				clickSound.Volume=enabled and 0 or .3
				hoverSound.Volume=enabled and 0 or .85
				sliderSound.Volume=enabled and 0 or .05
			end,
		})
		behavior:CreateButton({
			Name="Hide window",LockKeybind=true,
			Description="use the menu keybind to open the window again",
			Callback=function() window:SetVisible(false) end,
		})

		local menu=settingsTab:CreateSection("Menu")
		local menuBind=menu:CreateKeybind({
			Name="Toggle menu",CurrentKeybind=config.ToggleKey or Enum.KeyCode.K,
			LockKeybind=true,Rebindable=true,AllowProcessed=true,Description="shows or hides the menu",
			Callback=function() window:Toggle() end,
		})
		window.MenuKeybind=menuBind
		menu:CreateButton({
			Name="Clear editable keybinds",LockKeybind=true,
			Description="clears feature keybinds while keeping the menu hotkey",
			Callback=function()
				window:ClearKeybinds(false)
				window:Notify("editable keybinds cleared",1)
			end,
		})
	end

	window:SetVisible(true)
	return window
end

function Andromeda:Notify(options,duration)
	if self.LastWindow then self.LastWindow:Notify(options,duration) end
end
function Andromeda:SetTheme(theme)
	for _,window in ipairs(self.Windows) do window:SetTheme(theme) end
end
function Andromeda:Destroy()
	local windows=clone(self.Windows)
	for _,window in ipairs(windows) do window:Destroy() end
	table.clear(self.Flags);self.LastWindow=nil
end

return Andromeda
