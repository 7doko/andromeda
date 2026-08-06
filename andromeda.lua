-- andromedaLib 2.0
-- Compact two-column Roblox UI library by @7doko.

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")

local Andromeda = {
	Version = "2.1.2",
	Flags = {},
	Windows = {},
	CacheIcons = true,
	IconBaseUrl = "https://raw.githubusercontent.com/7doko/andromeda/main/assets/icons/",
	IconFolder = "andromedaLib/icons",
	ThemeFile = "andromedaLib/themes.json",
	BackgroundFolder = "andromedaLib/backgrounds",
	IconFiles = {
		Search = "search.png", Resize = "resize.png", Move = "move.png",
		Minimize = "minimize.png", Maximize = "maximize.png", Close = "close.png",
		Arrow = "arrow.png", Reset = "reset.png",
	},
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
		aurora = {
			Background=Color3.fromRGB(5,17,23),Panel=Color3.fromRGB(8,28,33),Element=Color3.fromRGB(14,43,46),
			Accent=Color3.fromRGB(94,242,181),Text=Color3.fromRGB(231,255,249),Muted=Color3.fromRGB(116,171,164),Stroke=Color3.fromRGB(29,76,75),
		},
		paper = {
			Background=Color3.fromRGB(241,238,244),Panel=Color3.fromRGB(229,224,234),Element=Color3.fromRGB(214,207,222),
			Accent=Color3.fromRGB(112,78,196),Text=Color3.fromRGB(48,42,57),Muted=Color3.fromRGB(112,101,124),Stroke=Color3.fromRGB(186,177,198),
		},
	},
}

local builtInThemeNames={}
for name in pairs(Andromeda.Themes) do builtInThemeNames[name]=true end

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

local function executorEnvironment()
	local environment
	if type(getgenv)=="function" then
		local ok,result=pcall(getgenv)
		if ok and type(result)=="le" then environment=result end
	end
	return environment or _G
end

local function executorFunction(name)
	local environment=executorEnvironment()
	local value=rawget(environment,name) or rawget(_G,name)
	return type(value)=="function" and value or nil
end

local function ensureExecutorFolder(path)
	local createFolder=executorFunction("makefolder")
	if not createFolder then return false end
	local isFolder=executorFunction("isfolder")
	local current=""
	for part in string.gmatch(path,"[^/\\]+") do
		current=current=="" and part or current.."/"..part
		local exists=false
		if isFolder then
			local ok,result=pcall(isFolder,current)
			exists=ok and result==true
		end
		if not exists then pcall(createFolder,current) end
	end
	return true
end

local executorIconCache={}
local executorIconFailures={}

local function executorIconSource(name,library)
	if library.CacheIcons==false then return "" end
	local assetLoader=executorFunction("getcustomasset") or executorFunction("getsynasset")
	local writeFile=executorFunction("writefile")
	if not assetLoader or not writeFile then return "" end

	local fileName=library.IconFiles[name]
	if not fileName then return "" end
	local folder=tostring(library.IconFolder):gsub("[\\/]+$","")
	local path=folder.."/"..fileName
	if executorIconCache[path] then return executorIconCache[path] end
	if executorIconFailures[path] then return "" end

	local isFile=executorFunction("isfile")
	local exists=false
	if isFile then
		local ok,result=pcall(isFile,path)
		exists=ok and result==true
	end

	if not exists then
		ensureExecutorFolder(folder)
		local baseUrl=tostring(library.IconBaseUrl):gsub("/*$","").."/"
		local ok,data=pcall(function() return game:HttpGet(baseUrl..fileName) end)
		if not ok or type(data)~="string" or #data<8 then
			executorIconFailures[path]=true
			warn("[andromedaLib] could not download icon:",name)
			return ""
		end
		local wrote=pcall(writeFile,path,data)
		if not wrote then
			executorIconFailures[path]=true
			warn("[andromedaLib] could not cache icon:",name)
			return ""
		end
	end

	local ok,asset=pcall(assetLoader,path)
	if ok and type(asset)=="string" and asset~="" then
		executorIconCache[path]=asset
		return asset
	end
	executorIconFailures[path]=true
	return ""
end

local function executorGuiParent()
	local getHiddenUi=executorFunction("gethui")
	if getHiddenUi then
		local ok,parent=pcall(getHiddenUi)
		if ok and typeof(parent)=="Instance" then return parent end
	end
	local ok,coreGui=pcall(game.GetService,game,"CoreGui")
	if ok then return coreGui end
end

local function protectExecutorGui(gui)
	local protect=executorFunction("protect_gui")
	if not protect then
		local environment=executorEnvironment()
		local synapse=rawget(environment,"syn") or rawget(_G,"syn")
		if type(synapse)=="table" and type(synapse.protect_gui)=="function" then protect=synapse.protect_gui end
	end
	if protect then pcall(protect,gui) end
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

local themeColorKeys={"Background","Panel","Element","Accent","Text","Muted","Stroke"}

local function colorToHex(color)
	return string.format("#%02X%02X%02X",math.floor(color.R*255+.5),math.floor(color.G*255+.5),math.floor(color.B*255+.5))
end

local function hexToColor(value)
	local hex=tostring(value or ""):gsub("#",""):gsub("%s","")
	if #hex==3 then hex=hex:sub(1,1):rep(2)..hex:sub(2,2):rep(2)..hex:sub(3,3):rep(2) end
	if #hex~=6 then return nil end
	local number=tonumber(hex,16)
	if not number then return nil end
	return Color3.fromRGB(math.floor(number/65536)%256,math.floor(number/256)%256,number%256)
end

local function serializeTheme(source)
	local result={}
	for _,key in ipairs(themeColorKeys) do
		if typeof(source[key])=="Color3" then result[key]=colorToHex(source[key]) end
	end
	result.BackgroundImage=tostring(source.BackgroundImage or "")
	result.BackgroundImageTransparency=math.clamp(tonumber(source.BackgroundImageTransparency) or .18,0,1)
	return result
end

local function deserializeTheme(source)
	if type(source)~="table" then return nil end
	local result={}
	for _,key in ipairs(themeColorKeys) do
		local color=hexToColor(source[key])
		if color then result[key]=color end
	end
	result.BackgroundImage=tostring(source.BackgroundImage or "")
	result.BackgroundImageTransparency=math.clamp(tonumber(source.BackgroundImageTransparency) or .18,0,1)
	return result
end

local function loadThemeStore(path)
	local readFile,isFile=executorFunction("readfile"),executorFunction("isfile")
	if not readFile then return {themes={}} end
	if isFile then
		local ok,exists=pcall(isFile,path)
		if not ok or not exists then return {themes={}} end
	end
	local ok,data=pcall(readFile,path)
	if not ok or type(data)~="string" then return {themes={}} end
	local decodedOk,decoded=pcall(HttpService.JSONDecode,HttpService,data)
	if not decodedOk or type(decoded)~="table" then return {themes={}} end
	decoded.themes=type(decoded.themes)=="table" and decoded.themes or {}
	return decoded
end

local function saveThemeStore(path,store)
	local writeFile=executorFunction("writefile")
	if not writeFile then return false,"executor does not support writefile" end
	local folder=path:match("^(.*)[/\\][^/\\]+$")
	if folder and folder~="" then ensureExecutorFolder(folder) end
	local ok,data=pcall(HttpService.JSONEncode,HttpService,store)
	if not ok then return false,tostring(data) end
	local wrote,err=pcall(writeFile,path,data)
	return wrote,wrote and nil or tostring(err)
end

local function resolveCustomImage(value,folder)
	if type(value)=="number" then return imageId(value) end
	local source=tostring(value or ""):match("^%s*(.-)%s*$")
	if source=="" then return "" end
	if source:match("^%d+$") then return "rbxassetid://"..source end
	if source:match("^rbxasset") or source:match("^rbxthumb") then return source end
	local assetLoader=executorFunction("getcustomasset") or executorFunction("getsynasset")
	local isFile=executorFunction("isfile")
	if assetLoader and isFile then
		local ok,exists=pcall(isFile,source)
		if ok and exists then
			local loaded,asset=pcall(assetLoader,source)
			if loaded then return asset end
		end
	end
	if not source:match("^https?://") then return source end
	local writeFile=executorFunction("writefile")
	if not writeFile or not assetLoader then return source end
	local hash=7
	for index=1,#source do hash=(hash*31+source:byte(index))%2147483647 end
	local extension=source:lower():match("%.(png)") or source:lower():match("%.(jpe?g)") or source:lower():match("%.(webp)") or "png"
	local path=tostring(folder):gsub("[\\/]+$","").."/"..tostring(hash).."."..extension
	local exists=false
	if isFile then local ok,result=pcall(isFile,path);exists=ok and result==true end
	if not exists then
		ensureExecutorFolder(folder)
		local downloaded,data=pcall(function() return game:HttpGet(source) end)
		if not downloaded or type(data)~="string" then return source end
		if not pcall(writeFile,path,data) then return source end
	end
	local loaded,asset=pcall(assetLoader,path)
	return loaded and asset or source
end

function Andromeda:CreateWindow(config)
	config=config or {}
	local player=Players.LocalPlayer
	assert(player,"andromedaLib must run on the client")

	local themeFile=tostring(config.ThemeFile or self.ThemeFile)
	local themeStore=loadThemeStore(themeFile)
	local customThemeNames={}
	for name,data in pairs(themeStore.themes) do
		local decoded=deserializeTheme(data)
		if decoded and not builtInThemeNames[name] then self.Themes[name]=decoded;customThemeNames[name]=true end
	end
	local themeName=config.ThemeName or (config.Theme==nil and themeStore.default) or "andromeda"
	if not self.Themes[themeName] then themeName="andromeda" end
	local theme=merge(self.Themes[themeName] or self.Themes.andromeda,config.Theme)
	local icons=self.Icons
	local shadowConfig=type(config.Shadow)=="table" and config.Shadow or {}
	local connections,tabs,keybinds={},{},{}
	local selectedTab,listeningBind
	local savedMouseBehavior,savedMouseIconEnabled,savedOverrideMouseIconBehavior
	local settings={Notifications=true,Tooltips=true,Muted=false,NotificationScale=1}
	local guiName=config.GuiName or "andromedaLib"
	local guiParent=config.UseExecutorGui==false and player.PlayerGui or executorGuiParent() or player.PlayerGui
	local old=guiParent:FindFirstChild(guiName)
	if old then old:Destroy() end
	if guiParent~=player.PlayerGui then
		old=player.PlayerGui:FindFirstChild(guiName)
		if old then old:Destroy() end
	end

	local function iconSource(name)
		local configured=imageId(icons[name])
		if configured~="" then return configured end
		return executorIconSource(name,self)
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
		Name=guiName,ResetOnSpawn=false,IgnoreGuiInset=true,DisplayOrder=2147483647,
		ZIndexBehavior=Enum.ZIndexBehavior.Sibling,
	})
	pcall(function() gui.ScreenInsets=Enum.ScreenInsets.None end)
	pcall(function() gui.OnTopOfCoreBlur=true end)
	protectExecutorGui(gui)
	local parented=pcall(function() gui.Parent=guiParent end)
	if not parented then gui.Parent=player.PlayerGui end
	local modalCatcher=make("TextButton",{
		Name="MenuInputUnlock",Size=UDim2.fromOffset(1,1),Position=UDim2.fromOffset(-100,-100),
		BackgroundTransparency=1,BorderSizePixel=0,AutoButtonColor=false,Text="",Active=false,
		Selectable=false,Modal=true,Visible=false,Parent=gui,
	})
	local windowSize=config.Size or UDim2.fromOffset(720,600)
	local root=role(make("ImageLabel",{
		Name="Window",Size=windowSize,Position=config.Position or UDim2.fromScale(.5,.5),
		AnchorPoint=Vector2.new(.5,.5),BackgroundColor3=theme.Background,BorderSizePixel=0,
		Image="",ImageTransparency=1,ScaleType=Enum.ScaleType.Crop,
		ClipsDescendants=false,ZIndex=2,Parent=gui,
	}),"Background")
	corner(root,4)
	role(make("UIStroke",{Color=theme.Stroke,Thickness=1,Transparency=.1,Parent=root}),"Stroke","Color")
	local requestedScale=math.clamp(tonumber(config.Scale) or 1,.55,1.4)
	local uiScale=make("UIScale",{Scale=requestedScale,Parent=root})
	local function fitWindowToViewport()
		if config.AutoFit==false then uiScale.Scale=requestedScale return end
		local camera=workspace.CurrentCamera
		local viewport=camera and camera.ViewportSize or Vector2.new(1920,1080)
		local baseWidth=root.AbsoluteSize.X/math.max(uiScale.Scale,.001)
		if baseWidth<1 then baseWidth=math.max(windowSize.X.Offset,720) end
		local fitPadding=math.max(tonumber(config.FitPadding) or 12,0)
		local horizontalFit=(viewport.X-fitPadding*2)/baseWidth
		uiScale.Scale=math.clamp(math.min(requestedScale,horizontalFit),.55,1.4)
	end
	task.defer(fitWindowToViewport)
	if workspace.CurrentCamera then
		table.insert(connections,workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(fitWindowToViewport))
	end
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
	local searchStroke=role(make("UIStroke",{Color=theme.Stroke,Transparency=.35,Parent=search}),"Stroke","Color")
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
		BorderSizePixel=0,ScrollBarThickness=0,VerticalScrollBarInset=Enum.ScrollBarInset.None,CanvasSize=UDim2.new(),Parent=root,
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
	local footerText=textRole(label(footer,"andromedaLib | v"..Andromeda.Version.." | @7doko",UDim2.fromScale(1,1),theme.Muted),"Muted")
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
		DragButton=dragButton,MinimizeButton=minimizeButton,CloseButton=closeButton,ThemeName=themeName,
		ThemeStore=themeStore,ThemeFile=themeFile,ThemePickers={},
	}

	local function play(sound)
		if not settings.Muted then sound:Play() end
	end

	local function bindHover(target,onEnter,onLeave,withSound)
		target.Active=true
		table.insert(connections,target.MouseEnter:Connect(function()
			if withSound~=false then play(hoverSound) end
			if onEnter then onEnter() end
		end))
		table.insert(connections,target.MouseLeave:Connect(function() if onLeave then onLeave() end end))
	end

	local function tweenVisual(object,color,duration)
		if object:IsA("ImageLabel") or object:IsA("ImageButton") then
			tween(object,{ImageColor3=color},duration)
		else
			tween(object,{TextColor3=color},duration)
		end
	end

	bindHover(search,function()
		tween(searchStroke,{Color=theme.Accent,Transparency=.05},.12)
		tween(searchBox,{TextColor3=theme.Text,PlaceholderColor3=theme.Text},.12)
	end,function()
		tween(searchStroke,{Color=theme.Stroke,Transparency=.35},.12)
		tween(searchBox,{TextColor3=theme.Text,PlaceholderColor3=theme.Muted},.12)
	end)

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

	local function forceMouseUnlocked()
		UserInputService.MouseBehavior=Enum.MouseBehavior.Default
		UserInputService.MouseIconEnabled=true
		pcall(function() UserInputService.OverrideMouseIconBehavior=Enum.OverrideMouseIconBehavior.ForceShow end)
	end
	table.insert(connections,RunService.RenderStepped:Connect(function()
		if not window.Visible then return end
		if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
			pcall(function()
				UserInputService.OverrideMouseIconBehavior=savedOverrideMouseIconBehavior or Enum.OverrideMouseIconBehavior.None
			end)
		else
			forceMouseUnlocked()
		end
	end))

	function window:SetVisible(value)
		local visible=value==true
		if visible and not self.Visible then
			savedMouseBehavior=UserInputService.MouseBehavior
			savedMouseIconEnabled=UserInputService.MouseIconEnabled
			pcall(function() savedOverrideMouseIconBehavior=UserInputService.OverrideMouseIconBehavior end)
		elseif not visible and self.Visible then
			if savedMouseBehavior then UserInputService.MouseBehavior=savedMouseBehavior end
			if savedMouseIconEnabled~=nil then UserInputService.MouseIconEnabled=savedMouseIconEnabled end
			if savedOverrideMouseIconBehavior~=nil then pcall(function() UserInputService.OverrideMouseIconBehavior=savedOverrideMouseIconBehavior end) end
		end
		self.Visible=visible;root.Visible=visible;modalCatcher.Visible=visible;if not visible then tooltip.Visible=false end
		if visible then forceMouseUnlocked() end
	end
	function window:Toggle() self:SetVisible(not self.Visible) end
	function window:Close() self:SetVisible(false) end
	function window:SetScale(value) requestedScale=math.clamp(tonumber(value) or 1,.55,1.4);fitWindowToViewport() end
	function window:SetShadow(values)
		if type(values)=="boolean" then shadow.Enabled=values return end
		local allowed={Enabled=true,BlurRadius=true,Color=true,Offset=true,Spread=true,Transparency=true,ZIndex=true}
		for property,value in pairs(values or {}) do if allowed[property] then pcall(function() shadow[property]=value end) end end
	end
	function window:SetBackgroundImage(source,options)
		if type(source)=="table" then options=source;source=options.Image or options.Source or options.Url end
		options=options or {}
		source=tostring(source or "")
		local transparency=math.clamp(tonumber(options.Transparency or options.ImageTransparency or theme.BackgroundImageTransparency) or .18,0,1)
		local resolved=resolveCustomImage(source,Andromeda.BackgroundFolder)
		root.Image=resolved
		root.ImageTransparency=resolved=="" and 1 or transparency
		for _,surface in ipairs({topbar,sidebar,content,footer}) do surface.BackgroundTransparency=resolved=="" and 0 or .12 end
		self.BackgroundImageSource=source;self.BackgroundImageTransparency=transparency
		theme.BackgroundImage=source;theme.BackgroundImageTransparency=transparency
		return resolved
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
			self.ThemeName=Andromeda.Themes[nextTheme] and nextTheme or "andromeda"
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
		for key,picker in pairs(self.ThemePickers or {}) do
			if theme[key] and picker:Get()~=theme[key] then picker:Set(theme[key],true) end
		end
		if type(nextTheme)=="string" or (type(nextTheme)=="table" and (nextTheme.BackgroundImage~=nil or nextTheme.BackgroundImageTransparency~=nil)) then
			self:SetBackgroundImage(theme.BackgroundImage or "",{Transparency=theme.BackgroundImageTransparency})
		end
	end
	function window:GetTheme()
		return merge(theme)
	end
	function window:GetCustomThemes()
		local names={}
		for name in pairs(customThemeNames) do table.insert(names,name) end
		table.sort(names);return names
	end
	function window:SaveCustomTheme(name,overwrite)
		name=tostring(name or ""):match("^%s*(.-)%s*$")
		if name=="" then return false,"enter a theme name" end
		if builtInThemeNames[name] then return false,"built-in themes cannot be overwritten" end
		if customThemeNames[name] and not overwrite then return false,"theme already exists" end
		local previous=themeStore.themes[name]
		themeStore.themes[name]=serializeTheme(theme)
		local saved,err=saveThemeStore(themeFile,themeStore)
		if not saved then themeStore.themes[name]=previous;return false,err end
		customThemeNames[name]=true;Andromeda.Themes[name]=deserializeTheme(themeStore.themes[name]);return true
	end
	function window:DeleteCustomTheme(name)
		name=tostring(name or "")
		if not customThemeNames[name] then return false,"select a custom theme" end
		local previous=themeStore.themes[name];local previousDefault=themeStore.default
		themeStore.themes[name]=nil;if themeStore.default==name then themeStore.default=nil end
		local saved,err=saveThemeStore(themeFile,themeStore)
		if not saved then themeStore.themes[name]=previous;themeStore.default=previousDefault;return false,err end
		customThemeNames[name]=nil;if not builtInThemeNames[name] then Andromeda.Themes[name]=nil end
		if self.ThemeName==name then self:SetTheme("andromeda") end
		return true
	end
	function window:SetDefaultTheme(name)
		if name~=nil and not Andromeda.Themes[name] then return false,"select a valid theme" end
		local previous=themeStore.default;themeStore.default=name
		local saved,err=saveThemeStore(themeFile,themeStore)
		if not saved then themeStore.default=previous;return false,err end
		return true
	end
	function window:RefreshCustomThemes()
		local fresh=loadThemeStore(themeFile)
		for name in pairs(customThemeNames) do if not builtInThemeNames[name] then Andromeda.Themes[name]=nil end end
		table.clear(customThemeNames);themeStore=fresh;self.ThemeStore=themeStore
		for name,data in pairs(themeStore.themes) do
			local decoded=deserializeTheme(data)
			if decoded and not builtInThemeNames[name] then customThemeNames[name]=true;Andromeda.Themes[name]=decoded end
		end
		if self.ThemeName and not Andromeda.Themes[self.ThemeName] then self:SetTheme("andromeda") end
		return self:GetCustomThemes()
	end
	window:SetBackgroundImage(config.BackgroundImage or theme.BackgroundImage or "",{
		Transparency=config.BackgroundImageTransparency or theme.BackgroundImageTransparency,
	})
	function window:ClearKeybinds(includeLocked)
		for _,bind in ipairs(keybinds) do if includeLocked or not bind.Locked then bind:SetKey(nil) end end
	end
	function window:Destroy()
		if self.Visible then self:SetVisible(false) end
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

	local function addKeybind(parent,handler,options,position)
		local bind={Key=toKeyCode(options.CurrentKeybind or options.Keybind),Locked=options.LockKeybind==true,
			Rebindable=options.Rebindable==true or options.LockKeybind~=true,AllowProcessed=options.AllowProcessed==true}
		local button=textRole(role(make("TextButton",{
			Name="KeybindButton",Size=UDim2.fromOffset(46,20),Position=position or UDim2.new(1,-52,.5,-10),BackgroundColor3=theme.Panel,
			BorderSizePixel=0,AutoButtonColor=false,Text=bind.Key and bind.Key.Name or "...",TextColor3=theme.Text,
			TextSize=11,Font=Enum.Font.Code,ZIndex=4,Parent=parent,
		}),"Panel"),"Text")
		corner(button,3);local buttonStroke=role(make("UIStroke",{Color=theme.Accent,Thickness=1,Transparency=.4,Parent=button}),"Accent","Color")
		local buttonScale=make("UIScale",{Scale=1,Parent=button})
		fitSingleLine(button,8,11)
		bindHover(button,function()
			tween(button,{BackgroundColor3=theme.Element,TextColor3=theme.Text},.12)
			tween(buttonStroke,{Transparency=0},.12);tween(buttonScale,{Scale=1.06},.12)
		end,function()
			tween(button,{BackgroundColor3=theme.Panel,TextColor3=theme.Text},.12)
			if listeningBind~=bind then tween(buttonStroke,{Transparency=.4},.12) end
			tween(buttonScale,{Scale=1},.12)
		end)
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
			options=options or {};local object=row(options.Name or "Button",34);local hasKeybind=(options.KeybindEnabled~=false and options.ShowKeybind~=false) or options.CurrentKeybind~=nil or options.Keybind~=nil
			local hovering=false
			local button=textRole(role(make("TextButton",{
				Size=UDim2.new(1,hasKeybind and -64 or -12,0,26),Position=UDim2.fromOffset(6,4),BackgroundColor3=theme.Element,BorderSizePixel=0,
				AutoButtonColor=false,Text=options.Name or "Button",TextColor3=theme.Muted,TextSize=13,Font=Enum.Font.Code,Parent=object,
			}),"Element"),"Muted")
			corner(button,3);local buttonStroke=role(make("UIStroke",{Color=theme.Stroke,Thickness=1,Transparency=.15,Parent=button}),"Stroke","Color");fitSingleLine(button,9,13)
			bindHover(button,function()
				hovering=true;tween(button,{TextColor3=theme.Text},.12);tween(buttonStroke,{Color=theme.Accent,Transparency=.25},.12)
			end,function()
				hovering=false;tween(button,{TextColor3=theme.Muted},.12);tween(buttonStroke,{Color=theme.Stroke,Transparency=.15},.12)
			end)
			local function press() play(clickSound);tween(button,{TextColor3=theme.Text,BackgroundColor3=theme.Accent},.08);task.delay(.1,function() if button.Parent then tween(button,{TextColor3=hovering and theme.Text or theme.Muted,BackgroundColor3=theme.Element},.12) end end);fire(options) end
			table.insert(connections,button.MouseButton1Click:Connect(press));attachTooltip(button,options.Description or options.Tooltip)
			local control={Instance=object,Fire=press,Set=function(_,value) button.Text=tostring(value) end}
			if hasKeybind then local bind=addKeybind(object,press,options);control.SetKey=function(_,v) bind:SetKey(v) end;control.GetKey=function() return bind:GetKey() end;control.ClearKey=function() bind:ClearKey() end end
			registerControl(api,object,options);return control
		end

		function api:CreateToggle(options)
			options=options or {};local value=options.CurrentValue==true or options.Default==true;local object=row(options.Name or "Toggle",28)
			local hasKeybind=(options.KeybindEnabled~=false and options.ShowKeybind~=false) or options.CurrentKeybind~=nil or options.Keybind~=nil
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
			function control:Toggle(silent) if not silent then play(clickSound) end;control:Set(not value,silent) end
			local function toggle() control:Toggle(false) end
			local hit=make("TextButton",{Size=UDim2.new(1,-95,1,0),BackgroundTransparency=1,Text="",Parent=object});table.insert(connections,hit.MouseButton1Click:Connect(toggle))
			local switchHit=make("TextButton",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Text="",ZIndex=2,Parent=track});table.insert(connections,switchHit.MouseButton1Click:Connect(toggle))
			bindHover(object,function() tween(name,{TextColor3=theme.Accent},.12) end,function() tween(name,{TextColor3=theme.Text},.12) end)
			if hasKeybind then local bind=addKeybind(object,toggle,options,UDim2.new(1,-94,.5,-10));control.Keybind=bind;control.SetKey=function(_,v) bind:SetKey(v) end;control.GetKey=function() return bind:GetKey() end;control.ClearKey=function() bind:ClearKey() end;hit.Size=UDim2.new(1,-102,1,0);name.Size=UDim2.new(1,-108,1,0) end
			if options.Flag then Andromeda.Flags[options.Flag]=value end;attachTooltip(object,options.Description or options.Tooltip);registerControl(api,object,options);return control
		end

		function api:CreateSlider(options)
			options=options or {};local range=options.Range or {options.Min or 0,options.Max or 100};local minimum,maximum=range[1] or 0,range[2] or 100
			local increment=options.Increment or options.Step or 1;local initialValue=math.clamp(tonumber(options.CurrentValue or options.Default) or minimum,minimum,maximum);local value=initialValue
			local object=row(options.Name or "Slider",50)
			local name=textRole(label(object,options.Name or "Slider",UDim2.new(1,-38,0,24),theme.Text),"Text");name.Position=UDim2.fromOffset(7,0);name.TextSize=13;fitSingleLine(name,9,13)
			local bar=role(make("Frame",{Size=UDim2.new(1,-14,0,16),Position=UDim2.fromOffset(7,27),BackgroundColor3=theme.Element,BorderSizePixel=0,Active=true,ClipsDescendants=true,Parent=object}),"Element");corner(bar,2)
			local fill=role(make("Frame",{Size=UDim2.new(0,0,1,0),BackgroundColor3=theme.Accent,BorderSizePixel=0,ZIndex=1,Parent=bar}),"Accent");corner(fill,2)
			local valueLabel=textRole(label(bar,"",UDim2.fromScale(1,1),theme.Text),"Text");valueLabel.TextXAlignment=Enum.TextXAlignment.Center;valueLabel.TextSize=11;valueLabel.TextStrokeColor3=Color3.new(0,0,0);valueLabel.TextStrokeTransparency=.55;valueLabel.ZIndex=3;fitSingleLine(valueLabel,8,11)
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
				bindHover(resetButton,function()
					tweenIcon(resetButton,theme.Text);tween(resetButton,{BackgroundColor3=theme.Element},.12)
				end,function()
					tweenIcon(resetButton,theme.Muted);tween(resetButton,{BackgroundColor3=theme.Panel},.12)
				end)
				table.insert(connections,resetButton.MouseButton1Click:Connect(function() play(clickSound);control:Reset() end))
				attachTooltip(resetButton,"Reset "..tostring(options.Name or "slider").." to its default value")
			end
			local sliding=false
			bindHover(object,function() tween(name,{TextColor3=theme.Accent},.12) end,function() tween(name,{TextColor3=theme.Text},.12) end)
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
			corner(box,2);padding(box,0,7,0,7);local boxStroke=role(make("UIStroke",{Color=theme.Stroke,Transparency=.4,Parent=box}),"Stroke","Color")
			bindHover(box,function()
				tween(name,{TextColor3=theme.Accent},.12);tween(boxStroke,{Color=theme.Accent,Transparency=.1},.12)
			end,function()
				tween(name,{TextColor3=theme.Text},.12);tween(boxStroke,{Color=theme.Stroke,Transparency=.4},.12)
			end)
			if options.Flag then Andromeda.Flags[options.Flag]=box.Text end
			table.insert(connections,box.FocusLost:Connect(function(enter) if options.Flag then Andromeda.Flags[options.Flag]=box.Text end;fire(options,box.Text,enter);if options.RemoveTextAfterFocusLost then box.Text="" end end))
			local control={Instance=object,Get=function() return box.Text end,Set=function(_,nextValue) box.Text=tostring(nextValue) end};attachTooltip(object,options.Description or options.Tooltip);registerControl(api,object,options);return control
		end

		local function dropdown(options,multiple)
			options=options or {};local choices=clone(options.Options or {});local selected={};local current=options.CurrentOption or options.Default
			if multiple then for _,choice in ipairs(type(current)=="table" and current or {}) do selected[choice]=true end elseif type(current)=="table" then current=current[1] end
			current=current or choices[1];local object=row(options.Name or (multiple and "Multi dropdown" or "Dropdown"),54);object.ClipsDescendants=true
			local name=textRole(label(object,options.Name or "Dropdown",UDim2.new(1,-14,0,22),theme.Text),"Text");name.Position=UDim2.fromOffset(7,0);name.TextSize=13;fitSingleLine(name,9,13)
			local selector=role(make("Frame",{Size=UDim2.new(1,-14,0,24),Position=UDim2.fromOffset(7,24),BackgroundColor3=theme.Element,BorderSizePixel=0,Parent=object}),"Element");corner(selector,2);local selectorStroke=role(make("UIStroke",{Color=theme.Stroke,Transparency=.4,Parent=selector}),"Stroke","Color")
			local valueLabel=textRole(label(selector,"",UDim2.new(1,-34,1,0),theme.Muted),"Muted");valueLabel.Position=UDim2.fromOffset(7,0);valueLabel.TextSize=12;fitSingleLine(valueLabel,8,12)
			local arrow=arrowVisual(selector,UDim2.fromOffset(16,16),UDim2.new(1,-23,0,4))
			local holder=role(make("ScrollingFrame",{Size=UDim2.new(1,-14,0,0),Position=UDim2.fromOffset(7,51),BackgroundColor3=theme.Panel,BorderSizePixel=0,
				ScrollBarThickness=0,VerticalScrollBarInset=Enum.ScrollBarInset.None,CanvasSize=UDim2.new(),Visible=false,ZIndex=20,Parent=object}),"Panel")
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
					padding(button,0,5,0,5);table.insert(buttons,button);local hovering=false
					local function refresh(animated) local active=multiple and selected[choice]==true;button:SetAttribute("AndromedaRole",active and "Accent" or "Panel");button:SetAttribute("AndromedaTextRole",active and "Text" or "Muted");local background=active and theme.Accent or (hovering and theme.Element or theme.Panel);local textColor=(active or hovering) and theme.Text or theme.Muted;if animated then tween(button,{BackgroundColor3=background,TextColor3=textColor},.12) else button.BackgroundColor3=background;button.TextColor3=textColor end end
					bindHover(button,function() hovering=true;refresh(true) end,function() hovering=false;refresh(true) end)
					table.insert(connections,button.MouseButton1Click:Connect(function() play(clickSound);if multiple then selected[choice]=not selected[choice] or nil;refresh();updateLabel();if options.Flag then Andromeda.Flags[options.Flag]=values() end;fire(options,values()) else current=choice;updateLabel();if options.Flag then Andromeda.Flags[options.Flag]=current end;fire(options,current);close() end end));refresh()
				end
				holder.CanvasSize=UDim2.fromOffset(0,#choices*25+6)
			end
			function control:Get() return multiple and values() or current end
			function control:Set(nextValue,silent) if multiple then table.clear(selected);for _,choice in ipairs(type(nextValue)=="table" and nextValue or {nextValue}) do if table.find(choices,choice) then selected[choice]=true end end elseif table.find(choices,nextValue) then current=nextValue end;rebuild();updateLabel();if options.Flag then Andromeda.Flags[options.Flag]=control:Get() end;if not silent then fire(options,control:Get()) end end
			function control:Refresh(nextChoices,keep) choices=clone(nextChoices or {});if not keep then current=choices[1];table.clear(selected) end;rebuild();updateLabel() end
			local hit=make("TextButton",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Text="",Parent=selector,ZIndex=4})
			bindHover(hit,function()
				tween(valueLabel,{TextColor3=theme.Text},.12);tween(selectorStroke,{Color=theme.Accent,Transparency=.1},.12);tweenVisual(arrow,theme.Accent,.12)
			end,function()
				tween(valueLabel,{TextColor3=theme.Muted},.12);tween(selectorStroke,{Color=theme.Stroke,Transparency=.4},.12);tweenVisual(arrow,theme.Text,.12)
			end)
			table.insert(connections,hit.MouseButton1Click:Connect(function() play(clickSound);opened=not opened;holder.Visible=opened;setArrow(arrow,opened and "up" or "down");local height=math.min(#choices*25+6,170);holder.Size=UDim2.new(1,-14,0,opened and height or 0);object.Size=UDim2.new(1,0,0,opened and 55+height or 54) end))
			rebuild();updateLabel();if options.Flag then Andromeda.Flags[options.Flag]=control:Get() end;attachTooltip(object,options.Description or options.Tooltip);registerControl(api,object,options);return control
		end
		function api:CreateDropdown(options) return dropdown(options,options and options.MultipleOptions==true) end
		function api:CreateMultiDropdown(options) return dropdown(options,true) end

		function api:CreateColorPicker(options)
			options=options or {}
			local initial=options.Color or options.CurrentColor or options.Default or Color3.new(1,1,1)
			local value=initial;local h,s,v=Color3.toHSV(value);local opened=false;local dragging
			local object=row(options.Name or "Color picker",30);object.ClipsDescendants=true
			local name=textRole(label(object,options.Name or "Color picker",UDim2.new(1,-44,0,30),theme.Text),"Text")
			name.Position=UDim2.fromOffset(7,0);name.TextSize=13;fitSingleLine(name,9,13)
			local preview=make("TextButton",{Size=UDim2.fromOffset(22,22),Position=UDim2.new(1,-29,0,4),BackgroundColor3=value,
				BorderSizePixel=0,AutoButtonColor=false,Text="",Parent=object});corner(preview,3)
			local previewStroke=role(make("UIStroke",{Color=theme.Stroke,Thickness=1,Parent=preview}),"Stroke","Color")
			local picker=role(make("Frame",{Size=UDim2.new(1,-14,0,178),Position=UDim2.fromOffset(7,32),BackgroundColor3=theme.Panel,
				BorderSizePixel=0,Visible=false,Parent=object}),"Panel");corner(picker,3);role(make("UIStroke",{Color=theme.Stroke,Parent=picker}),"Stroke","Color")

			local sv=make("Frame",{Size=UDim2.new(1,-48,0,136),Position=UDim2.fromOffset(7,7),BackgroundColor3=Color3.fromHSV(h,1,1),
				BorderSizePixel=0,Active=true,ClipsDescendants=true,Parent=picker});corner(sv,2)
			local white=make("Frame",{Size=UDim2.fromScale(1,1),BackgroundColor3=Color3.new(1,1,1),BorderSizePixel=0,Parent=sv})
			make("UIGradient",{Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,0),NumberSequenceKeypoint.new(1,1)}),Parent=white})
			local black=make("Frame",{Size=UDim2.fromScale(1,1),BackgroundColor3=Color3.new(0,0,0),BorderSizePixel=0,Parent=sv})
			make("UIGradient",{Rotation=90,Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,1),NumberSequenceKeypoint.new(1,0)}),Parent=black})
			local svCursor=make("Frame",{Size=UDim2.fromOffset(10,10),AnchorPoint=Vector2.new(.5,.5),BackgroundTransparency=1,ZIndex=4,Parent=sv})
			corner(svCursor,6);make("UIStroke",{Color=Color3.new(1,1,1),Thickness=2,Parent=svCursor})

			local hue=make("Frame",{Size=UDim2.fromOffset(18,136),Position=UDim2.new(1,-25,0,7),BackgroundColor3=Color3.new(1,1,1),
				BorderSizePixel=0,Active=true,ClipsDescendants=false,Parent=picker});corner(hue,2)
			make("UIGradient",{Rotation=90,Color=ColorSequence.new({
				ColorSequenceKeypoint.new(0,Color3.fromRGB(255,0,0)),ColorSequenceKeypoint.new(1/6,Color3.fromRGB(255,255,0)),
				ColorSequenceKeypoint.new(2/6,Color3.fromRGB(0,255,0)),ColorSequenceKeypoint.new(3/6,Color3.fromRGB(0,255,255)),
				ColorSequenceKeypoint.new(4/6,Color3.fromRGB(0,0,255)),ColorSequenceKeypoint.new(5/6,Color3.fromRGB(255,0,255)),
				ColorSequenceKeypoint.new(1,Color3.fromRGB(255,0,0)),
			}),Parent=hue})
			local hueCursor=make("Frame",{Size=UDim2.new(1,6,0,4),Position=UDim2.new(0,-3,h,0),AnchorPoint=Vector2.new(0,.5),
				BackgroundColor3=Color3.new(1,1,1),BorderSizePixel=0,ZIndex=4,Parent=hue});corner(hueCursor,2);make("UIStroke",{Color=Color3.new(0,0,0),Transparency=.25,Parent=hueCursor})

			local function inputBox(size,position,text)
				local box=textRole(role(make("TextBox",{Size=size,Position=position,BackgroundColor3=theme.Element,BorderSizePixel=0,
					ClearTextOnFocus=false,Text=text,TextColor3=theme.Text,PlaceholderColor3=theme.Muted,TextSize=11,Font=Enum.Font.Code,
					TextXAlignment=Enum.TextXAlignment.Center,Parent=picker}),"Element"),"Text")
				corner(box,2);role(make("UIStroke",{Color=theme.Stroke,Transparency=.35,Parent=box}),"Stroke","Color");return box
			end
			local hexBox=inputBox(UDim2.new(.47,-9,0,24),UDim2.fromOffset(7,148),colorToHex(value))
			local rgbBox=inputBox(UDim2.new(.53,-9,0,24),UDim2.new(.47,2,0,148),"")
			local control={Instance=object}

			local function refreshVisuals()
				value=Color3.fromHSV(h,s,v);preview.BackgroundColor3=value;sv.BackgroundColor3=Color3.fromHSV(h,1,1)
				svCursor.Position=UDim2.fromScale(s,1-v);hueCursor.Position=UDim2.new(0,-3,h,0)
				hexBox.Text=colorToHex(value);rgbBox.Text=string.format("%d, %d, %d",math.floor(value.R*255+.5),math.floor(value.G*255+.5),math.floor(value.B*255+.5))
			end
			local function changed(silent)
				refreshVisuals();if options.Flag then Andromeda.Flags[options.Flag]=value end;if not silent then fire(options,value) end
			end
			local function setOpen(nextValue)
				opened=nextValue==true;picker.Visible=opened;object.Size=UDim2.new(1,0,0,opened and 214 or 30)
			end
			local function updateSV(position)
				s=math.clamp((position.X-sv.AbsolutePosition.X)/math.max(sv.AbsoluteSize.X,1),0,1)
				v=1-math.clamp((position.Y-sv.AbsolutePosition.Y)/math.max(sv.AbsoluteSize.Y,1),0,1);changed()
			end
			local function updateHue(position)
				h=math.clamp((position.Y-hue.AbsolutePosition.Y)/math.max(hue.AbsoluteSize.Y,1),0,1);changed()
			end
			function control:Get() return value end
			function control:Set(color,silent)
				if typeof(color)~="Color3" then return end
				value=color;h,s,v=Color3.toHSV(color);changed(silent==true)
			end
			function control:Reset() control:Set(initial) end
			function control:SetOpen(nextValue) setOpen(nextValue) end
			function control:IsOpen() return opened end

			bindHover(preview,function() tween(previewStroke,{Color=theme.Accent},.12) end,function() tween(previewStroke,{Color=theme.Stroke},.12) end)
			table.insert(connections,preview.MouseButton1Click:Connect(function() play(clickSound);setOpen(not opened) end))
			table.insert(connections,sv.InputBegan:Connect(function(input) if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then dragging="sv";updateSV(input.Position) end end))
			table.insert(connections,hue.InputBegan:Connect(function(input) if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then dragging="hue";updateHue(input.Position) end end))
			table.insert(connections,UserInputService.InputChanged:Connect(function(input)
				if input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch then
					if dragging=="sv" then updateSV(input.Position) elseif dragging=="hue" then updateHue(input.Position) end
				end
			end))
			table.insert(connections,UserInputService.InputEnded:Connect(function(input) if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then dragging=nil end end))
			table.insert(connections,hexBox.FocusLost:Connect(function()
				local color=hexToColor(hexBox.Text);if color then control:Set(color) else refreshVisuals() end
			end))
			table.insert(connections,rgbBox.FocusLost:Connect(function()
				local red,green,blue=rgbBox.Text:match("(%d+)%D+(%d+)%D+(%d+)")
				if red then control:Set(Color3.fromRGB(math.clamp(tonumber(red),0,255),math.clamp(tonumber(green),0,255),math.clamp(tonumber(blue),0,255))) else refreshVisuals() end
			end))
			refreshVisuals();if options.Flag then Andromeda.Flags[options.Flag]=value end
			attachTooltip(object,options.Description or options.Tooltip);registerControl(api,object,options);return control
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
		local buttonText=textRole(label(button,tab.Name,UDim2.new(1,-48,1,0),theme.Muted),"Muted");buttonText.Position=UDim2.fromOffset(42,0);buttonText.TextSize=18;fitSingleLine(buttonText,9,14)
		tab.Button=button;tab.ButtonText=buttonText

		local page=make("Frame",{
			Name=tab.Name,Size=UDim2.fromScale(1,1),BackgroundTransparency=1,BorderSizePixel=0,Visible=false,Parent=content,
		})
		local left=make("ScrollingFrame",{
			Name="Left",Size=UDim2.new(.5,-12,1,-16),Position=UDim2.fromOffset(8,8),BackgroundTransparency=1,BorderSizePixel=0,
			ScrollBarThickness=0,VerticalScrollBarInset=Enum.ScrollBarInset.None,CanvasSize=UDim2.new(),Parent=page,
		})
		local right=make("ScrollingFrame",{
			Name="Right",Size=UDim2.new(.5,-12,1,-16),Position=UDim2.new(.5,4,0,8),BackgroundTransparency=1,BorderSizePixel=0,
			ScrollBarThickness=0,VerticalScrollBarInset=Enum.ScrollBarInset.None,CanvasSize=UDim2.new(),Parent=page,
		})
		local leftLayout=make("UIListLayout",{Padding=UDim.new(0,8),SortOrder=Enum.SortOrder.LayoutOrder,Parent=left})
		local rightLayout=make("UIListLayout",{Padding=UDim.new(0,8),SortOrder=Enum.SortOrder.LayoutOrder,Parent=right})
		padding(left,2,4,4,4);padding(right,2,4,4,4)
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
			bindHover(header,function()
				tween(heading,{TextColor3=theme.Accent},.12);tweenVisual(arrow,theme.Accent,.12)
			end,function()
				tween(heading,{TextColor3=theme.Text},.12);tweenVisual(arrow,theme.Text,.12)
			end)
			table.insert(connections,header.MouseButton1Click:Connect(function() play(clickSound);sectionApi:Toggle() end))
			sectionApi:SetCollapsed(sectionApi.Collapsed);return sectionApi
		end
		function tab:CreateLeftSection(name) return self:CreateSection({Name=name,Side="Left"}) end
		function tab:CreateRightSection(name) return self:CreateSection({Name=name,Side="Right"}) end
		buildControls(tab,left)
		tab.AddSection=tab.CreateSection
		table.insert(connections,button.MouseButton1Click:Connect(function() play(clickSound);select() end))
		table.insert(connections,button.MouseEnter:Connect(function()
			if selectedTab~=tab then play(hoverSound);tween(button,{BackgroundColor3=theme.Element},.12);tween(buttonText,{TextColor3=theme.Text},.12) end
		end))
		table.insert(connections,button.MouseLeave:Connect(function()
			if selectedTab~=tab then tween(button,{BackgroundColor3=theme.Background},.12);tween(buttonText,{TextColor3=theme.Muted},.12) end
		end))
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
		local settingsTab=window:CreateTab({Name="UI Settings",IconText="*",Internal=true})
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
		local function allThemeNames() local names={} for name in pairs(Andromeda.Themes) do table.insert(names,name) end table.sort(names);return names end
		local backgroundInput,backgroundTransparency,themeDropdown
		themeDropdown=appearance:CreateDropdown({Name="Theme list",Options=allThemeNames(),CurrentOption=themeName,Callback=function(value)
			window:SetTheme(value)
			if backgroundInput then backgroundInput:Set(window.BackgroundImageSource or "") end
			if backgroundTransparency then backgroundTransparency:Set((window.BackgroundImageTransparency or .18)*100,true) end
		end})
		appearance:CreateButton({Name="Set selected as default",Callback=function()
			local selected=themeDropdown:Get();local ok,err=window:SetDefaultTheme(selected)
			if window.DefaultThemeStatus then window.DefaultThemeStatus:Set("Current default theme: "..tostring(themeStore.default or "none")) end
			window:Notify({Title="Themes",Content=ok and ("Default theme: "..tostring(selected)) or tostring(err)})
		end})
		local colorLabels={Background="Background color",Panel="Panel color",Element="Element color",Accent="Accent color",Text="Font color",Muted="Muted font color",Stroke="Outline color"}
		for _,key in ipairs(themeColorKeys) do
			local themeKey=key
			local picker=appearance:CreateColorPicker({Name=colorLabels[key],Color=theme[key],Callback=function(value) window:SetTheme({[themeKey]=value}) end})
			window.ThemePickers[key]=picker
			if key=="Accent" then window.AccentPicker=picker end
		end
		backgroundInput=appearance:CreateInput({Name="Background image",PlaceholderText="Asset ID, URL, or local path",CurrentValue=window.BackgroundImageSource or "",Callback=function(value)
			window:SetBackgroundImage(value,{Transparency=(backgroundTransparency and backgroundTransparency:Get() or 18)/100})
		end})
		backgroundTransparency=appearance:CreateSlider({Name="Image transparency",Range={0,100},Increment=1,CurrentValue=(window.BackgroundImageTransparency or .18)*100,Suffix="%",Callback=function(value)
			window:SetBackgroundImage(backgroundInput:Get(),{Transparency=value/100})
		end})

		local customThemes=settingsTab:CreateSection({Name="Custom themes",Side="Right"})
		local customName=customThemes:CreateInput({Name="Custom theme name",PlaceholderText="My theme"})
		local customDropdown=customThemes:CreateDropdown({Name="Custom themes",Options=window:GetCustomThemes(),CurrentOption=window:GetCustomThemes()[1]})
		local defaultStatus=customThemes:CreateLabel("Current default theme: "..tostring(themeStore.default or "none"))
		window.DefaultThemeStatus=defaultStatus
		local function refreshThemeControls(preferred)
			local all=allThemeNames();themeDropdown:Refresh(all,false)
			local active=table.find(all,preferred) and preferred or (table.find(all,window.ThemeName) and window.ThemeName or all[1])
			if active then themeDropdown:Set(active,true) end
			local custom=window:GetCustomThemes();customDropdown:Refresh(custom,false)
			if preferred and table.find(custom,preferred) then customDropdown:Set(preferred,true) end
			defaultStatus:Set("Current default theme: "..tostring(themeStore.default or "none"))
		end
		local function themeResult(ok,message)
			window:Notify({Title="Themes",Content=ok and message or ("Could not update theme: "..tostring(message)),Duration=3})
		end
		customThemes:CreateButton({Name="Create theme",Callback=function()
			local name=customName:Get();local ok,err=window:SaveCustomTheme(name,false);themeResult(ok,ok and ("Created "..name) or err);if ok then refreshThemeControls(name) end
		end})
		customThemes:CreateButton({Name="Load theme",Callback=function()
			local name=customDropdown:Get();if not name or not customThemeNames[name] then themeResult(false,"select a custom theme") return end
			window:SetTheme(name);themeDropdown:Set(name,true);backgroundInput:Set(window.BackgroundImageSource or "");backgroundTransparency:Set((window.BackgroundImageTransparency or .18)*100,true)
			themeResult(true,"Loaded "..name)
		end})
		customThemes:CreateButton({Name="Overwrite theme",Callback=function()
			local name=customDropdown:Get();local ok,err=window:SaveCustomTheme(name,true);themeResult(ok,ok and ("Overwrote "..tostring(name)) or err);if ok then refreshThemeControls(name) end
		end})
		customThemes:CreateButton({Name="Delete theme",Callback=function()
			local name=customDropdown:Get();local ok,err=window:DeleteCustomTheme(name);themeResult(ok,ok and ("Deleted "..tostring(name)) or err);if ok then refreshThemeControls() end
		end})
		customThemes:CreateButton({Name="Refresh list",Callback=function() window:RefreshCustomThemes();refreshThemeControls();themeResult(true,"Theme list refreshed") end})
		customThemes:CreateButton({Name="Set as default",Callback=function()
			local name=customDropdown:Get();local ok,err=window:SetDefaultTheme(name);themeResult(ok,ok and ("Default theme: "..tostring(name)) or err);refreshThemeControls(name)
		end})
		customThemes:CreateButton({Name="Reset default",Callback=function()
			local ok,err=window:SetDefaultTheme(nil);themeResult(ok,ok and "Default theme reset" or err);refreshThemeControls()
		end})
		local shadowSettings=settingsTab:CreateSection({Name="Shadow",Side="Right"})
		shadowSettings:CreateToggle({Name="Shadow enabled",CurrentValue=shadow.Enabled,Callback=function(value) window:SetShadow(value) end})
		shadowSettings:CreateColorPicker({Name="Shadow color",Color=shadow.Color,Callback=function(value) window:SetShadow({Color=value}) end})

		local information=settingsTab:CreateSection({Name="Library",Side="Right"})
		information:CreateLabel("Reusable Andromeda UI library")
		information:CreateLabel("Version: "..Andromeda.Version)

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
