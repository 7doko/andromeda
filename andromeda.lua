-- andromedaLib 2.0
-- Compact two-column Roblox UI library by @7doko.

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local Andromeda = {
	Version = "2.0.0",
	Flags = {},
	Windows = {},
	Icons = {
		Search = "", Resize = "", Move = "", Minimize = "", Maximize = "",
		Close = "", Arrow = "", Reset = "",
	},
	Themes = {
		andromeda = {
			Background = Color3.fromRGB(15,15,18),
			Panel = Color3.fromRGB(18,18,21),
			Element = Color3.fromRGB(27,27,31),
			Accent = Color3.fromRGB(120,90,255),
			Text = Color3.fromRGB(235,235,235),
			Muted = Color3.fromRGB(150,138,150),
			Stroke = Color3.fromRGB(54,51,65),
		},
		midnight = {
			Background=Color3.fromRGB(8,12,22),Panel=Color3.fromRGB(13,18,31),Element=Color3.fromRGB(20,28,45),
			Accent=Color3.fromRGB(72,119,255),Text=Color3.fromRGB(235,240,255),Muted=Color3.fromRGB(133,148,180),Stroke=Color3.fromRGB(45,59,87),
		},
		amethyst = {
			Background=Color3.fromRGB(17,11,24),Panel=Color3.fromRGB(25,17,34),Element=Color3.fromRGB(38,26,49),
			Accent=Color3.fromRGB(178,91,255),Text=Color3.fromRGB(244,235,255),Muted=Color3.fromRGB(168,143,181),Stroke=Color3.fromRGB(69,48,82),
		},
		crimson = {
			Background=Color3.fromRGB(20,10,13),Panel=Color3.fromRGB(31,15,20),Element=Color3.fromRGB(46,23,29),
			Accent=Color3.fromRGB(239,68,98),Text=Color3.fromRGB(255,237,241),Muted=Color3.fromRGB(186,137,147),Stroke=Color3.fromRGB(83,43,52),
		},
		emerald = {
			Background=Color3.fromRGB(8,18,15),Panel=Color3.fromRGB(12,28,23),Element=Color3.fromRGB(19,42,34),
			Accent=Color3.fromRGB(47,211,142),Text=Color3.fromRGB(232,255,246),Muted=Color3.fromRGB(126,177,157),Stroke=Color3.fromRGB(38,76,63),
		},
		ocean = {
			Background=Color3.fromRGB(7,16,23),Panel=Color3.fromRGB(10,26,37),Element=Color3.fromRGB(16,39,54),
			Accent=Color3.fromRGB(40,190,235),Text=Color3.fromRGB(230,249,255),Muted=Color3.fromRGB(124,169,184),Stroke=Color3.fromRGB(35,71,88),
		},
		sunset = {
			Background=Color3.fromRGB(23,13,10),Panel=Color3.fromRGB(35,20,15),Element=Color3.fromRGB(52,30,22),
			Accent=Color3.fromRGB(255,139,76),Text=Color3.fromRGB(255,242,232),Muted=Color3.fromRGB(191,151,130),Stroke=Color3.fromRGB(91,54,40),
		},
		rose = {
			Background=Color3.fromRGB(23,11,18),Panel=Color3.fromRGB(35,17,28),Element=Color3.fromRGB(51,25,41),
			Accent=Color3.fromRGB(244,103,173),Text=Color3.fromRGB(255,237,247),Muted=Color3.fromRGB(190,141,169),Stroke=Color3.fromRGB(88,46,69),
		},
		cyber = {
			Background=Color3.fromRGB(7,12,13),Panel=Color3.fromRGB(10,21,22),Element=Color3.fromRGB(15,32,34),
			Accent=Color3.fromRGB(0,238,196),Text=Color3.fromRGB(224,255,251),Muted=Color3.fromRGB(104,175,166),Stroke=Color3.fromRGB(28,70,67),
		},
		monochrome = {
			Background=Color3.fromRGB(12,12,12),Panel=Color3.fromRGB(20,20,20),Element=Color3.fromRGB(31,31,31),
			Accent=Color3.fromRGB(220,220,220),Text=Color3.fromRGB(245,245,245),Muted=Color3.fromRGB(155,155,155),Stroke=Color3.fromRGB(63,63,63),
		},
		coffee = {
			Background=Color3.fromRGB(21,16,13),Panel=Color3.fromRGB(32,24,19),Element=Color3.fromRGB(47,35,28),
			Accent=Color3.fromRGB(206,150,98),Text=Color3.fromRGB(250,239,226),Muted=Color3.fromRGB(177,151,127),Stroke=Color3.fromRGB(82,62,49),
		},
	},
}

local function clone(source)
	local result = {}
	for key,value in pairs(source or {}) do result[key]=value end
	return result
end

local function merge(base,overrides)
	local result=clone(base)
	for key,value in pairs(overrides or {}) do result[key]=value end
	return result
end

local function make(className,properties)
	local object=Instance.new(className)
	local parent=properties and properties.Parent
	for property,value in pairs(properties or {}) do
		if property~="Parent" then object[property]=value end
	end
	object.Parent=parent
	return object
end

local function corner(parent,radius)
	return make("UICorner",{CornerRadius=UDim.new(0,radius or 4),Parent=parent})
end

local function padding(parent,top,right,bottom,left)
	return make("UIPadding",{
		PaddingTop=UDim.new(0,top or 0),PaddingRight=UDim.new(0,right or 0),
		PaddingBottom=UDim.new(0,bottom or 0),PaddingLeft=UDim.new(0,left or 0),Parent=parent,
	})
end

local function tween(object,properties,duration)
	local animation=TweenService:Create(object,TweenInfo.new(duration or .16,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),properties)
	animation:Play()
	return animation
end

local function role(object,name,property)
	object:SetAttribute("AndromedaRole",name)
	object:SetAttribute("AndromedaProperty",property or "BackgroundColor3")
	return object
end

local function textRole(object,name)
	object:SetAttribute("AndromedaTextRole",name or "Text")
	return object
end

local function label(parent,value,size,color)
	return make("TextLabel",{
		BackgroundTransparency=1,Size=size or UDim2.fromScale(1,1),
		Font=Enum.Font.Code,Text=value or "",TextColor3=color,TextSize=14,
		TextXAlignment=Enum.TextXAlignment.Left,TextTruncate=Enum.TextTruncate.None,
		Parent=parent,
	})
end

local function fitSingleLine(object,minimum,maximum)
	object.TextScaled=true
	object.TextWrapped=false
	object.TextTruncate=Enum.TextTruncate.None
	make("UITextSizeConstraint",{MinTextSize=minimum or 9,MaxTextSize=maximum or object.TextSize,Parent=object})
	return object
end

local function imageId(value)
	if type(value)=="number" then return "rbxassetid://"..tostring(value) end
	return tostring(value or "")
end

local function safeCallback(callback,...)
	if type(callback)~="function" then return end
	local ok,err=pcall(callback,...)
	if not ok then warn("[andromedaLib] callback error:",err) end
end

local function toKeyCode(value)
	if typeof(value)=="EnumItem" then return value end
	if type(value)=="string" then return Enum.KeyCode[value] end
end

local function formatNumber(value)
	if math.abs(value-math.floor(value))<.0001 then return tostring(math.floor(value)) end
	return string.format("%.2f",value):gsub("0+$",""):gsub("%.$","")
end

function Andromeda:CreateWindow(config)
	config=config or {}
	local player=Players.LocalPlayer
	assert(player,"andromedaLib must run on the client")

	local themeName=config.ThemeName or "andromeda"
	local theme=merge(self.Themes[themeName] or self.Themes.andromeda,config.Theme)
	local icons=merge(self.Icons,config.Icons)
	local shadowConfig=type(config.Shadow)=="table" and config.Shadow or {}
	local connections,tabs,keybinds={},{},{}
	local selectedTab,listeningBind
	local savedMouseBehavior,savedMouseIconEnabled
	local settings={Notifications=true,Tooltips=true,Muted=false,NotificationScale=1}
	local guiName=config.GuiName or "andromedaLib"
	local old=player.PlayerGui:FindFirstChild(guiName)
	if old then old:Destroy() end

	local function iconSource(name)
		return imageId(icons[name])
	end

	local function iconButton(parent,name,size,position,fallback)
		local source=iconSource(name)
		if source~="" then
			return role(make("ImageButton",{
				Name=name,Size=size,Position=position,BackgroundTransparency=1,AutoButtonColor=false,
				Image=source,ImageColor3=theme.Muted,ScaleType=Enum.ScaleType.Fit,Parent=parent,
			}),"Muted","ImageColor3")
		end
		return textRole(make("TextButton",{
			Name=name,Size=size,Position=position,BackgroundTransparency=1,AutoButtonColor=false,
			Text=fallback or "",TextColor3=theme.Muted,TextSize=16,Font=Enum.Font.Code,Parent=parent,
		}),"Muted")
	end

	local function setIcon(button,name,fallback)
		if button:IsA("ImageButton") then
			local source=iconSource(name)
			if source~="" then button.Image=source end
		else
			button.Text=fallback or ""
		end
	end

	local function tweenIcon(button,color)
		if button:IsA("ImageButton") then tween(button,{ImageColor3=color},.12) else tween(button,{TextColor3=color},.12) end
	end

	local function arrowVisual(parent,size,position)
		if iconSource("Arrow")~="" then
			return role(make("ImageLabel",{
				Name="Arrow",Size=size,Position=position,BackgroundTransparency=1,Image=iconSource("Arrow"),
				ImageColor3=theme.Text,ScaleType=Enum.ScaleType.Fit,Parent=parent,
			}),"Text","ImageColor3")
		end
		local arrow=textRole(label(parent,"v",size,theme.Text),"Text");arrow.Name="Arrow";arrow.Position=position;arrow.TextXAlignment=Enum.TextXAlignment.Center;arrow.TextSize=18
		return arrow
	end

	local function setArrow(arrow,direction)
		if arrow:IsA("ImageLabel") then
			arrow.Rotation=direction=="up" and 180 or direction=="right" and -90 or 0
		else
			arrow.Text=direction=="up" and "^" or direction=="right" and ">" or "v"
		end
	end

	local gui=make("ScreenGui",{
		Name=guiName,ResetOnSpawn=false,IgnoreGuiInset=true,DisplayOrder=config.DisplayOrder or 9999,
		ZIndexBehavior=Enum.ZIndexBehavior.Sibling,Parent=player.PlayerGui,
	})
	local windowSize=config.Size or UDim2.fromOffset(720,600)
	local root=role(make("Frame",{
		Name="Window",Size=windowSize,Position=config.Position or UDim2.fromScale(.5,.5),
		AnchorPoint=Vector2.new(.5,.5),BackgroundColor3=theme.Background,BorderSizePixel=0,
		ClipsDescendants=false,Parent=gui,
	}),"Background")
	corner(root,4)
	role(make("UIStroke",{Color=theme.Stroke,Thickness=1,Transparency=.1,Parent=root}),"Stroke","Color")
	local uiScale=make("UIScale",{Scale=config.Scale or 1,Parent=root})
	local shadow=make("UIShadow",{
		Name="Shadow",Enabled=config.Shadow~=false and shadowConfig.Enabled~=false,
		BlurRadius=shadowConfig.BlurRadius or UDim.new(0,16),Color=shadowConfig.Color or Color3.new(0,0,0),
		Offset=shadowConfig.Offset or UDim2.fromOffset(0,6),Spread=shadowConfig.Spread or UDim2.fromOffset(5,5),
		Transparency=math.clamp(tonumber(shadowConfig.Transparency) or .45,0,1),ZIndex=-1,Parent=root,
	})

	local topbar=role(make("Frame",{
		Name="Topbar",Size=UDim2.new(1,0,0,52),BackgroundColor3=theme.Background,BorderSizePixel=0,Parent=root,
	}),"Background")
	make("Frame",{Size=UDim2.new(1,0,0,1),Position=UDim2.new(0,0,1,-1),BackgroundColor3=theme.Stroke,BorderSizePixel=0,Parent=topbar})

	local title=textRole(label(topbar,config.Name or config.Title or "ANDROMEDA",UDim2.fromOffset(190,52),theme.Text),"Text")
	title.Position=UDim2.fromOffset(16,0);title.TextSize=17;fitSingleLine(title,11,17)

	local search=role(make("Frame",{
		Name="Search",Size=UDim2.new(1,-312,0,34),Position=UDim2.fromOffset(212,8),
		BackgroundColor3=theme.Element,BorderSizePixel=0,Parent=topbar,
	}),"Element")
	corner(search,4)
	role(make("UIStroke",{Color=theme.Stroke,Transparency=.35,Parent=search}),"Stroke","Color")
	if iconSource("Search")~="" then
		role(make("ImageLabel",{
			Name="SearchIcon",Size=UDim2.fromOffset(18,18),Position=UDim2.fromOffset(8,8),BackgroundTransparency=1,
			Image=iconSource("Search"),ImageColor3=theme.Muted,ScaleType=Enum.ScaleType.Fit,Parent=search,
		}),"Muted","ImageColor3")
	else
		local searchIcon=make("Frame",{
			Name="SearchIcon",Size=UDim2.fromOffset(13,13),Position=UDim2.fromOffset(10,9),
			BackgroundTransparency=1,BorderSizePixel=0,Parent=search,
		})
		corner(searchIcon,7)
		role(make("UIStroke",{Color=theme.Muted,Thickness=2,Parent=searchIcon}),"Muted","Color")
		role(make("Frame",{
			Name="Handle",Size=UDim2.fromOffset(6,2),Position=UDim2.fromOffset(10,11),Rotation=45,
			BackgroundColor3=theme.Muted,BorderSizePixel=0,Parent=searchIcon,
		}),"Muted")
	end
	local searchBox=textRole(make("TextBox",{
		Name="SearchBox",Size=UDim2.new(1,-34,1,0),Position=UDim2.fromOffset(32,0),BackgroundTransparency=1,
		ClearTextOnFocus=false,PlaceholderText="Search",PlaceholderColor3=theme.Muted,Text="",TextColor3=theme.Text,
		Font=Enum.Font.Code,TextSize=14,TextXAlignment=Enum.TextXAlignment.Center,Parent=search,
	}),"Text")

	local dragButton=iconButton(topbar,"Move",UDim2.fromOffset(30,30),UDim2.new(1,-32,0,11),"+")
	dragButton.Name="Drag";if dragButton:IsA("TextButton") then dragButton.TextSize=26 end
	local closeButton=iconButton(topbar,"Close",UDim2.fromOffset(20,20),UDim2.new(1,-59,0,16),"x")
	local minimizeButton=iconButton(topbar,"Minimize",UDim2.fromOffset(20,20),UDim2.new(1,-85,0,16),"-")

	local sidebar=role(make("ScrollingFrame",{
		Name="Sidebar",Size=UDim2.new(0,205,1,-72),Position=UDim2.fromOffset(0,52),BackgroundColor3=theme.Background,
		BorderSizePixel=0,ScrollBarThickness=2,ScrollBarImageColor3=theme.Accent,CanvasSize=UDim2.new(),Parent=root,
	}),"Background")
	padding(sidebar,4,0,4,0)
	local sidebarLayout=make("UIListLayout",{SortOrder=Enum.SortOrder.LayoutOrder,Padding=UDim.new(0,1),Parent=sidebar})
	make("Frame",{Size=UDim2.new(0,1,1,-72),Position=UDim2.fromOffset(205,52),BackgroundColor3=theme.Stroke,BorderSizePixel=0,Parent=root})

	local content=role(make("Frame",{
		Name="Content",Size=UDim2.new(1,-206,1,-72),Position=UDim2.fromOffset(206,52),
		BackgroundColor3=theme.Background,BorderSizePixel=0,ClipsDescendants=true,Parent=root,
	}),"Background")

	local footer=role(make("Frame",{
		Name="Footer",Size=UDim2.new(1,0,0,20),Position=UDim2.new(0,0,1,-20),
		BackgroundColor3=theme.Background,BorderSizePixel=0,Parent=root,
	}),"Background")
	make("Frame",{Size=UDim2.new(1,0,0,1),BackgroundColor3=theme.Stroke,BorderSizePixel=0,Parent=footer})
	local footerText=textRole(label(footer,config.Footer or ("andromedaLib | v"..Andromeda.Version.." | @7doko"),UDim2.fromScale(1,1),theme.Muted),"Muted")
	footerText.TextXAlignment=Enum.TextXAlignment.Center;footerText.TextSize=11

	local resizeGrip=iconButton(footer,"Resize",UDim2.fromOffset(18,18),UDim2.new(1,-20,0,1),"//")
	resizeGrip.Name="ResizeGrip";if resizeGrip:IsA("TextButton") then resizeGrip.TextSize=12 end

	local notifications=make("Frame",{
		Name="Notifications",Size=UDim2.fromOffset(250,560),Position=UDim2.new(1,-20,1,-20),
		AnchorPoint=Vector2.new(1,1),BackgroundTransparency=1,Parent=gui,
	})
	make("UIListLayout",{Padding=UDim.new(0,7),VerticalAlignment=Enum.VerticalAlignment.Bottom,SortOrder=Enum.SortOrder.LayoutOrder,Parent=notifications})
	local notificationScale=make("UIScale",{Scale=1,Parent=notifications})

	local tooltip=role(make("Frame",{
		Name="Tooltip",Size=UDim2.fromOffset(230,36),BackgroundColor3=theme.Panel,BackgroundTransparency=.04,
		BorderSizePixel=0,Visible=false,ZIndex=200,Parent=gui,
	}),"Panel")
	corner(tooltip,4)
	role(make("UIStroke",{Color=theme.Stroke,Parent=tooltip}),"Stroke","Color")
	local tooltipText=textRole(label(tooltip,"",UDim2.new(1,-14,1,0),theme.Text),"Text")
	tooltipText.Position=UDim2.fromOffset(7,0);tooltipText.TextSize=12;tooltipText.TextWrapped=true;tooltipText.ZIndex=201

	local clickSound=make("Sound",{SoundId="rbxassetid://6895079853",Volume=.25,Parent=gui})
	local hoverSound=make("Sound",{SoundId="rbxassetid://107511012621133",Volume=.7,Parent=gui})
	local sliderSound=make("Sound",{SoundId="rbxassetid://93076868992220",Volume=.04,Parent=gui})

	local window={
		Gui=gui,Main=root,Theme=theme,Tabs=tabs,Connections=connections,Keybinds=keybinds,
		Visible=false,Minimized=false,Settings=settings,SearchBox=searchBox,Shadow=shadow,Icons=icons,
		DragButton=dragButton,MinimizeButton=minimizeButton,CloseButton=closeButton,
	}

	local function play(sound)
		if not settings.Muted then sound:Play() end
	end

	local function fire(options,...)
		safeCallback(options and options.Callback,...)
		local notice=options and (options.Notification or options.Notify)
		if notice then window:Notify(type(notice)=="table" and notice or tostring(notice)) end
	end

	local function attachTooltip(object,description)
		if not description then return end
		object.Active=true
		local function placeTooltip(position)
			local viewport=workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(1920,1080)
			local x=math.clamp(position.X+14,8,math.max(8,viewport.X-238))
			local y=math.clamp(position.Y+14,8,math.max(8,viewport.Y-44))
			tooltip.Position=UDim2.fromOffset(x,y)
		end
		table.insert(connections,object.MouseEnter:Connect(function()
			play(hoverSound)
			if settings.Tooltips then
				tooltipText.Text=tostring(description);placeTooltip(UserInputService:GetMouseLocation());tooltip.Visible=true
			end
		end))
		table.insert(connections,object.MouseLeave:Connect(function() tooltip.Visible=false end))
		return placeTooltip
	end

	table.insert(connections,UserInputService.InputChanged:Connect(function(input)
		if tooltip.Visible and input.UserInputType==Enum.UserInputType.MouseMovement then
			local viewport=workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(1920,1080)
			tooltip.Position=UDim2.fromOffset(
				math.clamp(input.Position.X+14,8,math.max(8,viewport.X-238)),
				math.clamp(input.Position.Y+14,8,math.max(8,viewport.Y-44))
			)
		end
	end))

	function window:Notify(options,duration)
		if not settings.Notifications then return end
		options=type(options)=="table" and options or {Title="Andromeda",Content=tostring(options),Duration=duration}
		local box=role(make("Frame",{
			Size=UDim2.fromOffset(230,64),BackgroundColor3=theme.Panel,BackgroundTransparency=.02,BorderSizePixel=0,Parent=notifications,
		}),"Panel")
		corner(box,4);role(make("UIStroke",{Color=theme.Stroke,Parent=box}),"Stroke","Color")
		local heading=textRole(label(box,options.Title or "Andromeda",UDim2.new(1,-16,0,24),theme.Text),"Text")
		heading.Position=UDim2.fromOffset(8,4);heading.TextSize=14
		local body=textRole(label(box,options.Content or options.Text or "notification",UDim2.new(1,-16,0,25),theme.Text),"Text")
		body.Position=UDim2.fromOffset(8,25);body.TextSize=13;body.TextWrapped=true
		local track=role(make("Frame",{Size=UDim2.new(1,-16,0,2),Position=UDim2.new(0,8,1,-7),BackgroundColor3=theme.Stroke,BorderSizePixel=0,Parent=box}),"Stroke")
		local progress=role(make("Frame",{Size=UDim2.fromScale(1,1),BackgroundColor3=theme.Accent,BorderSizePixel=0,Parent=track}),"Accent")
		local lifetime=math.max(tonumber(options.Duration or duration) or 3,.05)
		tween(progress,{Size=UDim2.new(0,0,1,0)},lifetime)
		task.delay(lifetime,function()
			if box.Parent then box:Destroy() end
		end)
		return box
	end

	function window:SetVisible(value)
		local visible=value==true
		if visible and not self.Visible then
			savedMouseBehavior=UserInputService.MouseBehavior
			savedMouseIconEnabled=UserInputService.MouseIconEnabled
		elseif not visible and self.Visible then
			if savedMouseBehavior then UserInputService.MouseBehavior=savedMouseBehavior end
			if savedMouseIconEnabled~=nil then UserInputService.MouseIconEnabled=savedMouseIconEnabled end
		end
		self.Visible=visible;root.Visible=visible;if not visible then tooltip.Visible=false end
		if visible then UserInputService.MouseBehavior=Enum.MouseBehavior.Default;UserInputService.MouseIconEnabled=true end
	end
	function window:Toggle() self:SetVisible(not self.Visible) end
	function window:Close() self:SetVisible(false) end
	function window:SetScale(value) uiScale.Scale=math.clamp(tonumber(value) or 1,.55,1.4) end
	function window:SetShadow(values)
		if type(values)=="boolean" then shadow.Enabled=values return end
		local allowed={Enabled=true,BlurRadius=true,Color=true,Offset=true,Spread=true,Transparency=true,ZIndex=true}
		for property,value in pairs(values or {}) do if allowed[property] then pcall(function() shadow[property]=value end) end end
	end
	function window:SetMinimized(value)
		local minimized=value==true
		if minimized==self.Minimized then return end
		if minimized then
			self.ExpandedSize=root.Size;self.ExpandedPosition=root.Position
			local shift=math.max((root.AbsoluteSize.Y-72)/2,0)
			root.Position=UDim2.new(root.Position.X.Scale,root.Position.X.Offset,root.Position.Y.Scale,root.Position.Y.Offset-shift)
			root.Size=UDim2.new(root.Size.X.Scale,root.Size.X.Offset,0,72)
		else
			root.Size=self.ExpandedSize or windowSize;root.Position=self.ExpandedPosition or root.Position
		end
		self.Minimized=minimized;sidebar.Visible=not minimized;content.Visible=not minimized
		setIcon(minimizeButton,minimized and "Maximize" or "Minimize",minimized and "[]" or "-")
	end
	function window:ToggleMinimized() self:SetMinimized(not self.Minimized) end
	table.insert(connections,minimizeButton.MouseButton1Click:Connect(function() play(clickSound);window:ToggleMinimized() end))
	table.insert(connections,closeButton.MouseButton1Click:Connect(function() play(clickSound);window:Close() end))
	for _,button in ipairs({minimizeButton,closeButton}) do
		table.insert(connections,button.MouseEnter:Connect(function() play(hoverSound);tweenIcon(button,theme.Accent) end))
		table.insert(connections,button.MouseLeave:Connect(function() tweenIcon(button,theme.Muted) end))
	end
	function window:SetTheme(nextTheme)
		if type(nextTheme)=="string" then
			theme=merge(Andromeda.Themes[nextTheme] or Andromeda.Themes.andromeda)
		else
			for key,value in pairs(nextTheme or {}) do theme[key]=value end
		end
		self.Theme=theme
		for _,object in ipairs(gui:GetDescendants()) do
			local themeRole,property=object:GetAttribute("AndromedaRole"),object:GetAttribute("AndromedaProperty")
			if themeRole and property and theme[themeRole] then pcall(function() object[property]=theme[themeRole] end) end
			local textTheme=object:GetAttribute("AndromedaTextRole")
			if textTheme and theme[textTheme] then pcall(function() object.TextColor3=theme[textTheme] end) end
			if object:IsA("ScrollingFrame") then object.ScrollBarImageColor3=theme.Accent end
		end
	end
	function window:ClearKeybinds(includeLocked)
		for _,bind in ipairs(keybinds) do if includeLocked or not bind.Locked then bind:SetKey(nil) end end
	end
	function window:Destroy()
		for _,connection in ipairs(connections) do connection:Disconnect() end
		table.clear(connections);gui:Destroy()
		for index,item in ipairs(Andromeda.Windows) do if item==self then table.remove(Andromeda.Windows,index) break end end
		if Andromeda.LastWindow==self then Andromeda.LastWindow=Andromeda.Windows[#Andromeda.Windows] end
	end

	local dragging,dragStart,startPosition=false,nil,nil
	local function beginDrag(input)
		if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
			dragging=true;dragStart=input.Position;startPosition=root.Position
		end
	end
	table.insert(connections,dragButton.InputBegan:Connect(beginDrag))
	table.insert(connections,title.InputBegan:Connect(beginDrag))
	table.insert(connections,UserInputService.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch) then
			local delta=input.Position-dragStart
			root.Position=UDim2.new(startPosition.X.Scale,startPosition.X.Offset+delta.X,startPosition.Y.Scale,startPosition.Y.Offset+delta.Y)
		end
	end))
	table.insert(connections,UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then dragging=false end
	end))

	local resizing,resizeStart,startSize,resizePosition=false,nil,nil,nil
	table.insert(connections,resizeGrip.InputBegan:Connect(function(input)
		if input.UserInputType==Enum.UserInputType.MouseButton1 then resizing=true;resizeStart=input.Position;startSize=root.AbsoluteSize;resizePosition=root.Position end
	end))
	table.insert(connections,UserInputService.InputChanged:Connect(function(input)
		if resizing and input.UserInputType==Enum.UserInputType.MouseMovement then
			local delta=input.Position-resizeStart;local width=math.max(620,startSize.X+delta.X);local height=math.max(420,startSize.Y+delta.Y)
			local applied=Vector2.new(width-startSize.X,height-startSize.Y);root.Size=UDim2.fromOffset(width,height)
			root.Position=UDim2.new(resizePosition.X.Scale,resizePosition.X.Offset+applied.X/2,resizePosition.Y.Scale,resizePosition.Y.Offset+applied.Y/2)
		end
	end))
	table.insert(connections,UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType==Enum.UserInputType.MouseButton1 then resizing=false end
	end))

	local function addKeybind(parent,handler,options)
		local bind={Key=toKeyCode(options.CurrentKeybind or options.Keybind),Locked=options.LockKeybind==true,
			Rebindable=options.Rebindable==true or options.LockKeybind~=true,AllowProcessed=options.AllowProcessed==true}
		local button=textRole(role(make("TextButton",{
			Name="KeybindButton",Size=UDim2.fromOffset(46,20),Position=UDim2.new(1,-52,.5,-10),BackgroundColor3=theme.Panel,
			BorderSizePixel=0,AutoButtonColor=false,Text=bind.Key and bind.Key.Name or "...",TextColor3=theme.Text,
			TextSize=11,Font=Enum.Font.Code,ZIndex=4,Parent=parent,
		}),"Panel"),"Text")
		corner(button,3);local buttonStroke=role(make("UIStroke",{Color=theme.Accent,Thickness=1,Transparency=.4,Parent=button}),"Accent","Color")
		fitSingleLine(button,8,11)
		function bind:SetKey(nextKey)
			self.Key=toKeyCode(nextKey);button.Text=self.Key and self.Key.Name or "..."
			buttonStroke:SetAttribute("AndromedaRole","Accent");buttonStroke.Color=theme.Accent;buttonStroke.Transparency=.4
			if options.Flag then Andromeda.Flags[options.Flag.."_Keybind"]=self.Key end
		end
		function bind:GetKey() return self.Key end
		function bind:ClearKey() if not self.Locked then self:SetKey(nil) end end
		bind.Handler=handler;bind.Button=button;table.insert(keybinds,bind)
		table.insert(connections,button.MouseButton1Click:Connect(function()
			if not bind.Rebindable then return end
				listeningBind=bind;button.Text="...";buttonStroke:SetAttribute("AndromedaRole","Accent");buttonStroke.Color=theme.Accent;buttonStroke.Transparency=0;play(clickSound)
		end))
		table.insert(connections,button.MouseButton2Click:Connect(function() bind:ClearKey() end))
		return bind
	end

	local function registerControl(api,instance,options)
		local entry={Instance=instance,SearchText=string.lower(tostring((options and (options.Name or options.Title)) or instance.Name))}
		table.insert(api.Controls,entry);instance:SetAttribute("AndromedaControl",true)
		return entry
	end

	local function buildControls(api,parent)
		api.Controls=api.Controls or {}
		local function row(name,height)
			local object=make("Frame",{Name=name,Size=UDim2.new(1,0,0,height or 30),BackgroundTransparency=1,BorderSizePixel=0,Parent=parent})
			return object
		end

		function api:CreateLabel(value)
			local options=type(value)=="table" and value or {Text=tostring(value or "")}
			local object=textRole(label(parent,options.Text or options.Content or "",UDim2.new(1,0,0,27),theme.Muted),"Muted")
			object.Name=options.Name or "Label";object.AutomaticSize=Enum.AutomaticSize.Y;object.TextWrapped=options.TextWrapped~=false
			object.TextYAlignment=Enum.TextYAlignment.Top;object.TextTruncate=Enum.TextTruncate.None
			if options.TextWrapped==false then fitSingleLine(object,9,14) end
			registerControl(api,object,{Name=object.Text})
			return {Instance=object,Set=function(_,nextValue) object.Text=tostring(nextValue) end}
		end

		function api:CreateParagraph(options)
			options=options or {};local object=row(options.Title or "Paragraph",58)
			local heading=textRole(label(object,options.Title or "Paragraph",UDim2.new(1,-16,0,22),theme.Text),"Text")
			heading.Position=UDim2.fromOffset(8,3);fitSingleLine(heading,9,14)
			local body=textRole(label(object,options.Content or "",UDim2.new(1,-16,0,31),theme.Muted),"Muted")
			body.Position=UDim2.fromOffset(8,23);body.TextSize=12;body.TextWrapped=true;body.TextYAlignment=Enum.TextYAlignment.Top
			registerControl(api,object,options)
			return {Instance=object,Set=function(_,data) if type(data)=="table" then heading.Text=data.Title or heading.Text;body.Text=data.Content or body.Text else body.Text=tostring(data) end end}
		end

		function api:CreateButton(options)
			options=options or {};local object=row(options.Name or "Button",34);local hasKeybind=options.CurrentKeybind~=nil or options.Keybind~=nil
			local button=textRole(role(make("TextButton",{
				Size=UDim2.new(1,hasKeybind and -64 or -12,0,26),Position=UDim2.fromOffset(6,4),BackgroundColor3=theme.Element,BorderSizePixel=0,
				AutoButtonColor=false,Text=options.Name or "Button",TextColor3=theme.Muted,TextSize=13,Font=Enum.Font.Code,Parent=object,
			}),"Element"),"Muted")
			corner(button,3);role(make("UIStroke",{Color=theme.Stroke,Thickness=1,Transparency=.15,Parent=button}),"Stroke","Color");fitSingleLine(button,9,13)
			local function press() play(clickSound);tween(button,{TextColor3=theme.Text,BackgroundColor3=theme.Accent},.08);task.delay(.1,function() if button.Parent then tween(button,{TextColor3=theme.Muted,BackgroundColor3=theme.Element},.12) end end);fire(options) end
			table.insert(connections,button.MouseButton1Click:Connect(press));attachTooltip(button,options.Description or options.Tooltip)
			local control={Instance=object,Fire=press,Set=function(_,value) button.Text=tostring(value) end}
			if hasKeybind then local bind=addKeybind(object,press,options);control.SetKey=function(_,v) bind:SetKey(v) end;control.GetKey=function() return bind:GetKey() end;control.ClearKey=function() bind:ClearKey() end end
			registerControl(api,object,options);return control
		end

		function api:CreateToggle(options)
			options=options or {};local value=options.CurrentValue==true or options.Default==true;local object=row(options.Name or "Toggle",28)
			local name=textRole(label(object,options.Name or "Toggle",UDim2.new(1,-58,1,0),theme.Text),"Text");name.Position=UDim2.fromOffset(7,0);name.TextSize=13;fitSingleLine(name,9,13)
			local track=role(make("Frame",{Size=UDim2.fromOffset(34,20),Position=UDim2.new(1,-41,.5,-10),BackgroundColor3=value and theme.Accent or theme.Stroke,BorderSizePixel=0,Parent=object}),value and "Accent" or "Stroke")
			corner(track,10);local knob=make("Frame",{Size=UDim2.fromOffset(14,14),Position=value and UDim2.fromOffset(17,3) or UDim2.fromOffset(3,3),BackgroundColor3=Color3.new(1,1,1),BorderSizePixel=0,Parent=track});corner(knob,8)
			local control={Instance=object}
			function control:Set(nextValue,silent)
				value=nextValue==true;track:SetAttribute("AndromedaRole",value and "Accent" or "Stroke")
				tween(track,{BackgroundColor3=value and theme.Accent or theme.Stroke},.18);tween(knob,{Position=value and UDim2.fromOffset(17,3) or UDim2.fromOffset(3,3)},.18)
				if options.Flag then Andromeda.Flags[options.Flag]=value end;if not silent then fire(options,value) end
			end
			function control:Get() return value end
			local function toggle() play(clickSound);control:Set(not value) end
			local hit=make("TextButton",{Size=UDim2.new(1,-95,1,0),BackgroundTransparency=1,Text="",Parent=object});table.insert(connections,hit.MouseButton1Click:Connect(toggle))
			local switchHit=make("TextButton",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Text="",ZIndex=2,Parent=track});table.insert(connections,switchHit.MouseButton1Click:Connect(toggle))
			if options.CurrentKeybind or options.Keybind then local bind=addKeybind(object,toggle,options);control.SetKey=function(_,v) bind:SetKey(v) end;control.GetKey=function() return bind:GetKey() end;control.ClearKey=function() bind:ClearKey() end;track.Position=UDim2.new(1,-94,.5,-10);hit.Size=UDim2.new(1,-102,1,0);name.Size=UDim2.new(1,-108,1,0) end
			if options.Flag then Andromeda.Flags[options.Flag]=value end;attachTooltip(object,options.Description or options.Tooltip);registerControl(api,object,options);return control
		end

		function api:CreateSlider(options)
			options=options or {};local range=options.Range or {options.Min or 0,options.Max or 100};local minimum,maximum=range[1] or 0,range[2] or 100
			local increment=options.Increment or options.Step or 1;local initialValue=math.clamp(tonumber(options.CurrentValue or options.Default) or minimum,minimum,maximum);local value=initialValue
			local object=row(options.Name or "Slider",50)
			local name=textRole(label(object,options.Name or "Slider",UDim2.new(.5,-4,0,24),theme.Text),"Text");name.Position=UDim2.fromOffset(7,0);name.TextSize=13;fitSingleLine(name,9,13)
			local valueLabel=textRole(label(object,"",UDim2.new(.5,-35,0,24),theme.Text),"Text");valueLabel.Position=UDim2.new(.5,0,0,0);valueLabel.TextXAlignment=Enum.TextXAlignment.Right;valueLabel.TextSize=12;fitSingleLine(valueLabel,8,12)
			local bar=role(make("Frame",{Size=UDim2.new(1,-14,0,14),Position=UDim2.fromOffset(7,27),BackgroundColor3=theme.Element,BorderSizePixel=0,Active=true,Parent=object}),"Element");corner(bar,2)
			local fill=role(make("Frame",{Size=UDim2.new(0,0,1,0),BackgroundColor3=theme.Accent,BorderSizePixel=0,Parent=bar}),"Accent");corner(fill,2)
			local control={Instance=object}
			local function snap(number) return math.clamp(math.floor(number/increment+.5)*increment,minimum,maximum) end
			function control:Set(nextValue,silent)
				value=snap(tonumber(nextValue) or minimum);local ratio=maximum~=minimum and (value-minimum)/(maximum-minimum) or 0
				local suffix=options.Suffix or "";fill.Size=UDim2.fromScale(ratio,1)
				valueLabel.Text=formatNumber(value)..suffix.." / "..formatNumber(maximum)..suffix
				if options.Flag then Andromeda.Flags[options.Flag]=value end;if not silent then fire(options,value) end
			end
			function control:Get() return value end
			function control:Reset() control:Set(initialValue) end
			if options.ResetButton~=false then
				local resetButton=iconButton(object,"Reset",UDim2.fromOffset(18,18),UDim2.new(1,-23,0,3),"R")
				resetButton.Name="ResetButton";resetButton.BackgroundTransparency=0;resetButton.BackgroundColor3=theme.Panel;role(resetButton,"Panel")
				corner(resetButton,3);role(make("UIStroke",{Color=theme.Stroke,Thickness=1,Transparency=.25,Parent=resetButton}),"Stroke","Color")
				if resetButton:IsA("TextButton") then resetButton.TextSize=10 end
				table.insert(connections,resetButton.MouseButton1Click:Connect(function() play(clickSound);control:Reset() end))
				attachTooltip(resetButton,"Reset "..tostring(options.Name or "slider").." to its default value")
			end
			local sliding=false
			local function update(input)
				local ratio=math.clamp((input.Position.X-bar.AbsolutePosition.X)/math.max(bar.AbsoluteSize.X,1),0,1);play(sliderSound);control:Set(minimum+(maximum-minimum)*ratio)
			end
			table.insert(connections,bar.InputBegan:Connect(function(input) if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then sliding=true;update(input) end end))
			table.insert(connections,UserInputService.InputChanged:Connect(function(input) if sliding and (input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch) then update(input) end end))
			table.insert(connections,UserInputService.InputEnded:Connect(function(input) if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then sliding=false end end))
			control:Set(value,true);attachTooltip(object,options.Description or options.Tooltip);registerControl(api,object,options);return control
		end

		function api:CreateInput(options)
			options=options or {};local object=row(options.Name or "Input",52)
			local name=textRole(label(object,options.Name or "Input",UDim2.new(1,-14,0,22),theme.Text),"Text");name.Position=UDim2.fromOffset(7,0);name.TextSize=13;fitSingleLine(name,9,13)
			local box=textRole(role(make("TextBox",{Size=UDim2.new(1,-14,0,24),Position=UDim2.fromOffset(7,24),BackgroundColor3=theme.Element,BorderSizePixel=0,
				ClearTextOnFocus=false,PlaceholderText=options.PlaceholderText or "Enter text",PlaceholderColor3=theme.Muted,Text=options.CurrentValue or options.Default or "",
				TextColor3=theme.Text,TextSize=12,Font=Enum.Font.Code,TextXAlignment=Enum.TextXAlignment.Left,Parent=object}),"Element"),"Text")
			corner(box,2);padding(box,0,7,0,7);role(make("UIStroke",{Color=theme.Stroke,Transparency=.4,Parent=box}),"Stroke","Color")
			if options.Flag then Andromeda.Flags[options.Flag]=box.Text end
			table.insert(connections,box.FocusLost:Connect(function(enter) if options.Flag then Andromeda.Flags[options.Flag]=box.Text end;fire(options,box.Text,enter);if options.RemoveTextAfterFocusLost then box.Text="" end end))
			local control={Instance=object,Get=function() return box.Text end,Set=function(_,nextValue) box.Text=tostring(nextValue) end};attachTooltip(object,options.Description or options.Tooltip);registerControl(api,object,options);return control
		end

		local function dropdown(options,multiple)
			options=options or {};local choices=clone(options.Options or {});local selected={};local current=options.CurrentOption or options.Default
			if multiple then for _,choice in ipairs(type(current)=="table" and current or {}) do selected[choice]=true end elseif type(current)=="table" then current=current[1] end
			current=current or choices[1];local object=row(options.Name or (multiple and "Multi dropdown" or "Dropdown"),54);object.ClipsDescendants=true
			local name=textRole(label(object,options.Name or "Dropdown",UDim2.new(1,-14,0,22),theme.Text),"Text");name.Position=UDim2.fromOffset(7,0);name.TextSize=13;fitSingleLine(name,9,13)
			local selector=role(make("Frame",{Size=UDim2.new(1,-14,0,24),Position=UDim2.fromOffset(7,24),BackgroundColor3=theme.Element,BorderSizePixel=0,Parent=object}),"Element");corner(selector,2);role(make("UIStroke",{Color=theme.Stroke,Transparency=.4,Parent=selector}),"Stroke","Color")
			local valueLabel=textRole(label(selector,"",UDim2.new(1,-34,1,0),theme.Muted),"Muted");valueLabel.Position=UDim2.fromOffset(7,0);valueLabel.TextSize=12;fitSingleLine(valueLabel,8,12)
			local arrow=arrowVisual(selector,UDim2.fromOffset(16,16),UDim2.new(1,-23,0,4))
			local holder=role(make("ScrollingFrame",{Size=UDim2.new(1,-14,0,0),Position=UDim2.fromOffset(7,51),BackgroundColor3=theme.Panel,BorderSizePixel=0,
				ScrollBarThickness=2,ScrollBarImageColor3=theme.Accent,CanvasSize=UDim2.new(),Visible=false,ZIndex=20,Parent=object}),"Panel")
			corner(holder,2);role(make("UIStroke",{Color=theme.Stroke,Parent=holder}),"Stroke","Color");padding(holder,3,3,3,3)
			local holderLayout=make("UIListLayout",{Padding=UDim.new(0,1),Parent=holder});local opened=false;local buttons={};local control={Instance=object}
			local function values() local result={} for _,choice in ipairs(choices) do if selected[choice] then table.insert(result,choice) end end return result end
			local function updateLabel() if multiple then local list=values();valueLabel.Text=#list==0 and "---" or (#list==1 and tostring(list[1]) or (#list.." selected")) else valueLabel.Text=tostring(current or "---") end end
			local function close() opened=false;holder.Visible=false;setArrow(arrow,"down");object.Size=UDim2.new(1,0,0,54) end
			local function rebuild()
				for _,button in ipairs(buttons) do button:Destroy() end;table.clear(buttons)
				for _,choice in ipairs(choices) do
					local button=textRole(role(make("TextButton",{Size=UDim2.new(1,-2,0,24),BackgroundColor3=theme.Panel,BorderSizePixel=0,AutoButtonColor=false,
						Text=tostring(choice),TextColor3=theme.Muted,TextSize=12,TextXAlignment=Enum.TextXAlignment.Left,Font=Enum.Font.Code,ZIndex=21,Parent=holder}),"Panel"),"Muted")
					padding(button,0,5,0,5);table.insert(buttons,button)
					local function refresh() local active=multiple and selected[choice]==true;button:SetAttribute("AndromedaRole",active and "Accent" or "Panel");button:SetAttribute("AndromedaTextRole",active and "Text" or "Muted");button.BackgroundColor3=active and theme.Accent or theme.Panel;button.TextColor3=active and theme.Text or theme.Muted end
					table.insert(connections,button.MouseButton1Click:Connect(function() play(clickSound);if multiple then selected[choice]=not selected[choice] or nil;refresh();updateLabel();if options.Flag then Andromeda.Flags[options.Flag]=values() end;fire(options,values()) else current=choice;updateLabel();if options.Flag then Andromeda.Flags[options.Flag]=current end;fire(options,current);close() end end));refresh()
				end
				holder.CanvasSize=UDim2.fromOffset(0,#choices*25+6)
			end
			function control:Get() return multiple and values() or current end
			function control:Set(nextValue,silent) if multiple then table.clear(selected);for _,choice in ipairs(type(nextValue)=="table" and nextValue or {nextValue}) do if table.find(choices,choice) then selected[choice]=true end end elseif table.find(choices,nextValue) then current=nextValue end;rebuild();updateLabel();if options.Flag then Andromeda.Flags[options.Flag]=control:Get() end;if not silent then fire(options,control:Get()) end end
			function control:Refresh(nextChoices,keep) choices=clone(nextChoices or {});if not keep then current=choices[1];table.clear(selected) end;rebuild();updateLabel() end
			local hit=make("TextButton",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Text="",Parent=selector,ZIndex=4})
			table.insert(connections,hit.MouseButton1Click:Connect(function() play(clickSound);opened=not opened;holder.Visible=opened;setArrow(arrow,opened and "up" or "down");local height=math.min(#choices*25+6,170);holder.Size=UDim2.new(1,-14,0,opened and height or 0);object.Size=UDim2.new(1,0,0,opened and 55+height or 54) end))
			rebuild();updateLabel();if options.Flag then Andromeda.Flags[options.Flag]=control:Get() end;attachTooltip(object,options.Description or options.Tooltip);registerControl(api,object,options);return control
		end
		function api:CreateDropdown(options) return dropdown(options,options and options.MultipleOptions==true) end
		function api:CreateMultiDropdown(options) return dropdown(options,true) end

		function api:CreateColorPicker(options)
			options=options or {};local value=options.Color or options.CurrentColor or options.Default or Color3.new(1,1,1);local h,s,v=Color3.toHSV(value)
			local object=row(options.Name or "Color picker",174);local name=textRole(label(object,options.Name or "Color picker",UDim2.new(1,-44,0,28),theme.Text),"Text");name.Position=UDim2.fromOffset(7,0);name.TextSize=13;fitSingleLine(name,9,13)
			local preview=make("Frame",{Size=UDim2.fromOffset(20,20),Position=UDim2.new(1,-28,0,4),BackgroundColor3=value,BorderSizePixel=0,Parent=object});corner(preview,2);role(make("UIStroke",{Color=theme.Stroke,Parent=preview}),"Stroke","Color")
			local control={Instance=object};local updating=false
			local function changed() if updating then return end;value=Color3.fromHSV(h,s,v);preview.BackgroundColor3=value;if options.Flag then Andromeda.Flags[options.Flag]=value end;fire(options,value) end
			local hue=api:CreateSlider({Name="Hue",Range={0,360},Increment=1,CurrentValue=h*360,Callback=function(x) h=x/360;changed() end});hue.Instance.Parent=object;hue.Instance.Position=UDim2.fromOffset(0,28);hue.Instance.Size=UDim2.new(1,0,0,44)
			local sat=api:CreateSlider({Name="Saturation",Range={0,100},Increment=1,CurrentValue=s*100,Callback=function(x) s=x/100;changed() end});sat.Instance.Parent=object;sat.Instance.Position=UDim2.fromOffset(0,74);sat.Instance.Size=UDim2.new(1,0,0,44)
			local bright=api:CreateSlider({Name="Brightness",Range={0,100},Increment=1,CurrentValue=v*100,Callback=function(x) v=x/100;changed() end});bright.Instance.Parent=object;bright.Instance.Position=UDim2.fromOffset(0,120);bright.Instance.Size=UDim2.new(1,0,0,44)
			function control:Get() return value end
			function control:Set(color,silent) value=color;h,s,v=Color3.toHSV(color);updating=true;hue:Set(h*360,true);sat:Set(s*100,true);bright:Set(v*100,true);updating=false;preview.BackgroundColor3=color;if options.Flag then Andromeda.Flags[options.Flag]=color end;if not silent then fire(options,color) end end
			function control:Reset() control:Set(options.Color or options.CurrentColor or options.Default or Color3.new(1,1,1)) end
			registerControl(api,object,options);return control
		end

		function api:CreateKeybind(options)
			options=options or {};local object=row(options.Name or "Keybind",30);local name=textRole(label(object,options.Name or "Keybind",UDim2.new(1,-62,1,0),theme.Text),"Text");name.Position=UDim2.fromOffset(7,0);name.TextSize=13;fitSingleLine(name,9,13)
			local bind=addKeybind(object,function() fire(options) end,options);bind.Instance=object;attachTooltip(object,options.Description or options.Tooltip);registerControl(api,object,options);return bind
		end

		api.AddButton=api.CreateButton;api.AddToggle=api.CreateToggle;api.AddSlider=api.CreateSlider
		api.AddDropdown=api.CreateDropdown;api.AddMultiDropdown=api.CreateMultiDropdown;api.AddColorPicker=api.CreateColorPicker
		api.AddInput=api.CreateInput;api.AddTextbox=api.CreateInput;api.AddKeybind=api.CreateKeybind;api.AddLabel=api.CreateLabel;api.AddParagraph=api.CreateParagraph
	end

	function window:CreateTab(tabConfig,icon)
		tabConfig=type(tabConfig)=="table" and tabConfig or {Name=tostring(tabConfig or "Tab"),Icon=icon}
		local tab={Name=tabConfig.Name or "Tab",Internal=tabConfig.Internal==true,Sections={},Controls={},NextSide="Left"}
		local button=role(make("TextButton",{
			Name=tab.Name,Size=UDim2.new(1,0,0,40),BackgroundColor3=theme.Background,BackgroundTransparency=0,
			BorderSizePixel=0,AutoButtonColor=false,Text="",LayoutOrder=tab.Internal and 10000 or #tabs,Parent=sidebar,
		}),"Background")
		local iconHolder
		if tabConfig.Icon and tostring(tabConfig.Icon)~="" then
			iconHolder=role(make("ImageLabel",{Size=UDim2.fromOffset(20,20),Position=UDim2.fromOffset(14,10),BackgroundTransparency=1,
				Image=tostring(tabConfig.Icon),ImageColor3=theme.Accent,Parent=button}),"Accent","ImageColor3")
		else
				iconHolder=textRole(label(button,tabConfig.IconText or string.upper(string.sub(tab.Name,1,1)),UDim2.fromOffset(30,40),theme.Accent),"Accent");iconHolder.Position=UDim2.fromOffset(5,0);iconHolder.TextXAlignment=Enum.TextXAlignment.Center;iconHolder.TextSize=14
		end
		local buttonText=textRole(label(button,tab.Name,UDim2.new(1,-48,1,0),theme.Muted),"Muted");buttonText.Position=UDim2.fromOffset(42,0);buttonText.TextSize=14;fitSingleLine(buttonText,9,14)
		tab.Button=button;tab.ButtonText=buttonText

		local page=make("Frame",{
			Name=tab.Name,Size=UDim2.fromScale(1,1),BackgroundTransparency=1,BorderSizePixel=0,Visible=false,Parent=content,
		})
		local left=make("ScrollingFrame",{
			Name="Left",Size=UDim2.new(.5,-12,1,-16),Position=UDim2.fromOffset(8,8),BackgroundTransparency=1,BorderSizePixel=0,
			ScrollBarThickness=2,ScrollBarImageColor3=theme.Accent,VerticalScrollBarInset=Enum.ScrollBarInset.ScrollBar,CanvasSize=UDim2.new(),Parent=page,
		})
		local right=make("ScrollingFrame",{
			Name="Right",Size=UDim2.new(.5,-12,1,-16),Position=UDim2.new(.5,4,0,8),BackgroundTransparency=1,BorderSizePixel=0,
			ScrollBarThickness=2,ScrollBarImageColor3=theme.Accent,VerticalScrollBarInset=Enum.ScrollBarInset.ScrollBar,CanvasSize=UDim2.new(),Parent=page,
		})
		local leftLayout=make("UIListLayout",{Padding=UDim.new(0,8),SortOrder=Enum.SortOrder.LayoutOrder,Parent=left})
		local rightLayout=make("UIListLayout",{Padding=UDim.new(0,8),SortOrder=Enum.SortOrder.LayoutOrder,Parent=right})
		padding(left,2,4,4,0);padding(right,2,4,4,0)
		tab.Page=page;tab.Left=left;tab.Right=right
		local function refreshLeftCanvas() left.CanvasSize=UDim2.fromOffset(0,leftLayout.AbsoluteContentSize.Y+8) end
		local function refreshRightCanvas() right.CanvasSize=UDim2.fromOffset(0,rightLayout.AbsoluteContentSize.Y+8) end
		table.insert(connections,leftLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(refreshLeftCanvas))
		table.insert(connections,rightLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(refreshRightCanvas));refreshLeftCanvas();refreshRightCanvas()

		local function select()
			selectedTab=tab
			for _,other in ipairs(tabs) do
				local active=other==tab;other.Page.Visible=active
				other.Button:SetAttribute("AndromedaRole",active and "Element" or "Background")
				other.ButtonText:SetAttribute("AndromedaTextRole",active and "Text" or "Muted")
				tween(other.Button,{BackgroundColor3=active and theme.Element or theme.Background},.12)
				tween(other.ButtonText,{TextColor3=active and theme.Text or theme.Muted},.12)
			end
			searchBox.Text=""
		end
		function tab:Select() select() end
		function tab:CreateSection(sectionConfig)
			sectionConfig=type(sectionConfig)=="table" and sectionConfig or {Name=tostring(sectionConfig or "Section")}
			local requested=string.lower(tostring(sectionConfig.Side or tab.NextSide))
			local host=requested=="right" and right or left
			if not sectionConfig.Side then tab.NextSide=tab.NextSide=="Left" and "Right" or "Left" end
			local section=role(make("Frame",{Name=sectionConfig.Name or "Section",Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,
				BackgroundColor3=theme.Background,BorderSizePixel=0,ClipsDescendants=true,Parent=host}),"Background")
			corner(section,4);role(make("UIStroke",{Color=theme.Stroke,Transparency=.15,Parent=section}),"Stroke","Color")
			local sectionLayout=make("UIListLayout",{SortOrder=Enum.SortOrder.LayoutOrder,Parent=section})
			local header=make("TextButton",{Name="Header",Size=UDim2.new(1,0,0,36),BackgroundTransparency=1,Text="",AutoButtonColor=false,LayoutOrder=-1000,Parent=section})
			local heading=textRole(label(header,sectionConfig.Name or "Section",UDim2.new(1,-42,1,0),theme.Text),"Text");heading.Position=UDim2.fromOffset(10,0);heading.TextSize=14;fitSingleLine(heading,9,14)
			local arrow=arrowVisual(header,UDim2.fromOffset(18,18),UDim2.new(1,-28,0,9))
			make("Frame",{Size=UDim2.new(1,0,0,1),Position=UDim2.new(0,0,1,-1),BackgroundColor3=theme.Stroke,BorderSizePixel=0,Parent=header})
			local body=make("Frame",{Name="Body",Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1,LayoutOrder=0,Parent=section})
			padding(body,3,5,5,5);make("UIListLayout",{SortOrder=Enum.SortOrder.LayoutOrder,Padding=UDim.new(0,1),Parent=body})
			local sectionApi={Instance=section,Body=body,Controls={},Collapsed=sectionConfig.Collapsed==true,Tab=tab}
			buildControls(sectionApi,body);table.insert(tab.Sections,sectionApi)
			function sectionApi:SetCollapsed(value) self.Collapsed=value==true;body.Visible=not self.Collapsed;setArrow(arrow,self.Collapsed and "right" or "down") end
			function sectionApi:Toggle() self:SetCollapsed(not self.Collapsed) end
			table.insert(connections,header.MouseButton1Click:Connect(function() play(clickSound);sectionApi:Toggle() end))
			sectionApi:SetCollapsed(sectionApi.Collapsed);return sectionApi
		end
		function tab:CreateLeftSection(name) return self:CreateSection({Name=name,Side="Left"}) end
		function tab:CreateRightSection(name) return self:CreateSection({Name=name,Side="Right"}) end
		buildControls(tab,left)
		tab.AddSection=tab.CreateSection
		table.insert(connections,button.MouseButton1Click:Connect(function() play(clickSound);select() end))
		table.insert(connections,button.MouseEnter:Connect(function() if selectedTab~=tab then play(hoverSound);tween(button,{BackgroundColor3=theme.Element},.12) end end))
		table.insert(connections,button.MouseLeave:Connect(function() if selectedTab~=tab then tween(button,{BackgroundColor3=theme.Background},.12) end end))
		table.insert(tabs,tab);sidebar.CanvasSize=UDim2.fromOffset(0,sidebarLayout.AbsoluteContentSize.Y+10)
		if not selectedTab or (selectedTab.Internal and not tab.Internal) then select() end
		return tab
	end

	local function featureMatches(entry,query)
		if query=="" then return true end
		if string.find(entry.SearchText,query,1,true) then return true end
		for _,descendant in ipairs(entry.Instance:GetDescendants()) do
			if (descendant:IsA("TextLabel") or descendant:IsA("TextButton") or descendant:IsA("TextBox")) and string.find(string.lower(descendant.Text),query,1,true) then return true end
		end
		return false
	end
	local function applySearch()
		if not selectedTab then return end
		local query=string.lower(searchBox.Text):match("^%s*(.-)%s*$")
		for _,section in ipairs(selectedTab.Sections) do
			local any=false
			for _,entry in ipairs(section.Controls) do local visible=featureMatches(entry,query);entry.Instance.Visible=visible;if visible then any=true end end
			section.Instance.Visible=query=="" or any
			if query~="" and any then section:SetCollapsed(false) end
		end
		for _,entry in ipairs(selectedTab.Controls) do entry.Instance.Visible=featureMatches(entry,query) end
	end
	table.insert(connections,searchBox:GetPropertyChangedSignal("Text"):Connect(applySearch))

	table.insert(connections,UserInputService.InputBegan:Connect(function(input,processed)
		if listeningBind then
			if input.UserInputType==Enum.UserInputType.Keyboard and input.KeyCode~=Enum.KeyCode.Unknown then listeningBind:SetKey(input.KeyCode);listeningBind=nil end
			return
		end
		for _,bind in ipairs(keybinds) do if bind.Key==input.KeyCode and (not processed or bind.AllowProcessed) then safeCallback(bind.Handler) end end
	end))

	table.insert(Andromeda.Windows,window);Andromeda.LastWindow=window
	if config.SettingsTab~=false then
		local settingsTab=window:CreateTab({Name=config.SettingsTabName or "UI Settings",IconText="*",Internal=true})
		window.SettingsTab=settingsTab
		local menu=settingsTab:CreateSection({Name="Menu",Side="Left"})
		menu:CreateToggle({Name="Notifications",CurrentValue=true,Callback=function(value) settings.Notifications=value end})
		menu:CreateToggle({Name="Tooltips",CurrentValue=true,Callback=function(value) settings.Tooltips=value;if not value then tooltip.Visible=false end end})
		menu:CreateToggle({Name="Mute sounds",CurrentValue=false,Callback=function(value) settings.Muted=value end})
		menu:CreateSlider({Name="UI scale",Range={.55,1.4},Increment=.05,CurrentValue=config.Scale or 1,Callback=function(value) window:SetScale(value) end})
		local menuBind=menu:CreateKeybind({Name="Menu bind",CurrentKeybind=config.ToggleKey or Enum.KeyCode.K,LockKeybind=true,Rebindable=true,AllowProcessed=true,Callback=function() window:Toggle() end})
		window.MenuKeybind=menuBind
		menu:CreateButton({Name="Unload",Callback=function() window:Destroy() end})

		local appearance=settingsTab:CreateSection({Name="Themes",Side="Left"})
		local themeNames={} for name in pairs(Andromeda.Themes) do table.insert(themeNames,name) end table.sort(themeNames)
		appearance:CreateDropdown({Name="Theme",Options=themeNames,CurrentOption=themeName,Callback=function(value) window:SetTheme(value) end})
		appearance:CreateColorPicker({Name="Accent color",Color=theme.Accent,Callback=function(value) window:SetTheme({Accent=value}) end})
		local shadowSettings=settingsTab:CreateSection({Name="Shadow",Side="Right"})
		shadowSettings:CreateToggle({Name="Shadow enabled",CurrentValue=shadow.Enabled,Callback=function(value) window:SetShadow(value) end})
		shadowSettings:CreateColorPicker({Name="Shadow color",Color=shadow.Color,Callback=function(value) window:SetShadow({Color=value}) end})

		local information=settingsTab:CreateSection({Name="Library",Side="Right"})
		information:CreateLabel("Reusable Andromeda UI library")
		information:CreateLabel("Version: "..Andromeda.Version)
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
	local windows=clone(self.Windows);for _,window in ipairs(windows) do window:Destroy() end;table.clear(self.Flags);self.LastWindow=nil
end

return Andromeda
