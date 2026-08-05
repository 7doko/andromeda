local Andromeda = loadstring(game:HttpGet(
	"https://raw.githubusercontent.com/7doko/andromeda/main/andromeda.lua"
))()

local Window = Andromeda:CreateWindow({
	Name = "ANDROMEDA | V2",
	ThemeName = "andromeda",
	Footer = "andromedaLib | v2.0.1 | @7doko",
})

local Controls = Window:CreateTab("Controls")
local Selection = Window:CreateTab("Selection")
local Inputs = Window:CreateTab("Inputs")
local Notifications = Window:CreateTab("Notifications")

local Basic = Controls:CreateSection({Name="Basic controls",Side="Left"})
Basic:CreateButton({
	Name="Example button",
	CurrentKeybind=Enum.KeyCode.B,
	Description="Runs the button callback. The B keybind does the same thing.",
	Callback=function() Window:Notify({Title="Button",Content="The example button was pressed"}) end,
})
Basic:CreateToggle({Name="Example toggle",CurrentValue=true,CurrentKeybind=Enum.KeyCode.T,Description="Click the row, switch, or press T."})
Basic:CreateSlider({Name="Example slider",Range={0,100},Increment=1,CurrentValue=50,Suffix="%",Description="Drag the bar or use the reset button."})

local Text = Controls:CreateSection({Name="Text content",Side="Right"})
local Status = Text:CreateLabel({Text="Status: ready - labels wrap instead of being replaced by an ellipsis.",TextWrapped=true})
Text:CreateParagraph({Title="Paragraph",Content="Longer explanatory content can be placed inside compact sections."})
Text:CreateButton({Name="Update label",Callback=function() Status:Set("Status: updated") end})

local States = Controls:CreateSection({Name="Compact states",Side="Left"})
States:CreateToggle({Name="Enabled state",CurrentValue=true})
States:CreateToggle({Name="Disabled state",CurrentValue=false})
States:CreateKeybind({Name="Standalone keybind",CurrentKeybind=Enum.KeyCode.G,Callback=function() Window:Notify("Keybind pressed") end})

local Single = Selection:CreateSection({Name="Dropdowns",Side="Left"})
local Dropdown = Single:CreateDropdown({
	Name="Single dropdown",Options={"Alpha","Beta","Gamma","Delta"},CurrentOption="Alpha",Description="Select one value from the list.",
})
Single:CreateButton({Name="Refresh dropdown",Callback=function() Dropdown:Refresh({"One","Two","Three"},false) end})

local Multiple = Selection:CreateSection({Name="Multiple selection",Side="Right"})
Multiple:CreateMultiDropdown({
	Name="Multi dropdown",Options={"ESP","Chams","Tracers","Distance","Health"},CurrentOption={"ESP","Distance"},Description="Selected values use the current accent color.",
})

local Colors = Selection:CreateSection({Name="Colors",Side="Left"})
Colors:CreateColorPicker({Name="Feature color",Color=Color3.fromRGB(120,90,255)})

local TextInputs = Inputs:CreateSection({Name="Text inputs",Side="Left"})
TextInputs:CreateInput({Name="Configuration name",PlaceholderText="Enter a name"})
TextInputs:CreateInput({Name="Numeric value",PlaceholderText="Ex: 75"})
TextInputs:CreateButton({Name="Create configuration"})

local Layout = Inputs:CreateSection({Name="Section layout",Side="Right",Collapsed=false})
Layout:CreateLabel("Sections can be placed left or right.")
Layout:CreateLabel("Click a section header to collapse it.")
Layout:CreateButton({Name="Collapse this section",Callback=function() Layout:SetCollapsed(true) end})

local Notice = Notifications:CreateSection({Name="Notifications",Side="Left"})
Notice:CreateButton({
	Name="Show notification",
	Callback=function()
		Window:Notify({Title="Andromeda",Content="This is a redesigned notification.",Duration=4})
	end,
})
Notice:CreateButton({
	Name="Stack notifications",
	Callback=function()
		for index=1,4 do
			Window:Notify({Title="Notification "..index,Content="Notifications stack vertically.",Duration=3+index*.25})
		end
	end,
})

local WindowApi = Notifications:CreateSection({Name="Window API",Side="Right"})
WindowApi:CreateButton({Name="Toggle window",Callback=function() Window:Toggle() end})
WindowApi:CreateButton({Name="Minimize window",Callback=function() Window:ToggleMinimized() end})
WindowApi:CreateButton({Name="Reset scale",Callback=function() Window:SetScale(1) end})

Window:Notify({Title="Andromeda 2.0",Content="Showcase loaded. Press K to toggle the menu.",Duration=4})
