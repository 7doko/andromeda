# Andromeda UI Library

Andromeda is a clean Roblox client UI library with tabs, sections, search, themes, notifications, flags, keybinds, tooltips, and reusable controls.

The library does not include game detection or gameplay features. You create the window and add your own controls through its API.

## Loadstring

Load the newest version directly from GitHub:

```lua
local Andromeda = loadstring(game:HttpGet("https://raw.githubusercontent.com/7doko/andromeda/main/andromeda.lua"))()
```

## Features

- Multiple windows, tabs, and sections
- Search bar for the selected tab
- Buttons, toggles, sliders, dropdowns, and multi-dropdowns
- Color pickers, inputs, labels, paragraphs, and keybinds
- Built-in settings tab
- Runtime theme switching
- Flags for storing control values
- Notifications and tooltips
- Interface sounds and scaling
- Window dragging from the title or move control
- Independent left and right column scrolling
- Header minimize and close controls
- Bottom-right resize control
- Configurable menu keybind
- Mouse cursor unlocking while the window is open

## Quick start

```lua
local Andromeda = loadstring(game:HttpGet("https://raw.githubusercontent.com/7doko/andromeda/main/andromeda.lua"))()

local Window = Andromeda:CreateWindow({
	Name = "My Hub",
	ThemeName = "andromeda",
	ToggleKey = Enum.KeyCode.K,
})

local Main = Window:CreateTab("Main")
local Features = Main:CreateSection("Features")

Features:CreateToggle({
	Name = "Example toggle",
	CurrentValue = false,
	Flag = "ExampleToggle",
	Callback = function(enabled)
		print("Toggle:", enabled)
	end,
})
```

The loadstring returns the Andromeda API. The interface is created when you call `Andromeda:CreateWindow()`.

## Legacy version

Version 2.0 is now the main `andromeda.lua`. The previous v1.0.2 library remains available as:

```lua
local Andromeda = loadstring(game:HttpGet(
	"https://raw.githubusercontent.com/7doko/andromeda/main/andromeda-old.lua"
))()
```

The current library uses a compact two-column layout with icon-ready sidebar tabs, animated hover feedback, top search, collapsible sections, independent column scrolling, bottom-right notifications, and window controls.

```lua
local Window = Andromeda:CreateWindow({Name = "My Hub"})
local Main = Window:CreateTab({Name = "Main", IconText = "M"})

local Left = Main:CreateSection({Name = "Player", Side = "Left"})
local Right = Main:CreateSection({Name = "Visual", Side = "Right"})

Left:CreateToggle({Name = "Example toggle"})
Right:CreateSlider({Name = "Example slider", Range = {0, 100}})
```

If `Side` is omitted, new sections alternate between the left and right columns. `Icon` accepts a Roblox image URI, while `IconText` supplies a text fallback. Section headers can be clicked to collapse or expand them. See `andromeda-showcase.lua` for every control type.

## Creating a window

```lua
local Window = Andromeda:CreateWindow({
	Name = "My Hub",
	ThemeName = "andromeda",
	ToggleKey = Enum.KeyCode.K,
	Scale = 1,
	SettingsTab = true,
})
```

### Window configuration

| Option | Type | Default | Description |
| --- | --- | --- | --- |
| `Name` | string | `ANDROMEDA` | Main window title. `Title` can also be used. |
| `ThemeName` | string | `andromeda` | Name of a built-in theme. |
| `Theme` | table | nil | Theme values that override the selected built-in theme. |
| `GuiName` | string | `andromedaLib` | Name assigned to the generated ScreenGui. |
| `DisplayOrder` | number | `2147483647` | ScreenGui display order. The default keeps Andromeda above Roblox CoreGui. |
| `Size` | UDim2 | `UDim2.fromOffset(720, 600)` | Window size. |
| `Position` | UDim2 | `UDim2.fromScale(0.5, 0.5)` | Initial window position. |
| `Scale` | number | `1` | Initial UI scale. |
| `AutoFit` | boolean | `true` | Shrinks the window horizontally when needed so its left and right edges stay inside the viewport. |
| `FitPadding` | number | `12` | Minimum viewport padding used by automatic horizontal fitting. |
| `Shadow` | boolean or table | table | Set to `false` to disable the UIShadow, or provide custom shadow properties. |
| `Footer` | string | `andromedaLib ...` | Text displayed in the window footer. |
| `Icons` | table | empty IDs | Optional Roblox asset IDs that override the automatically cached icons. |
| `CacheIcons` | boolean | `true` | Downloads missing icons into the executor workspace and loads them as custom assets. |
| `IconFolder` | string | `andromedaLib/icons` | Executor workspace folder used for cached PNG icons. |
| `IconBaseUrl` | string | repository assets URL | Remote directory used to download missing icons. |
| `UseExecutorGui` | boolean | `true` | Parents the ScreenGui to `gethui()` when available so it renders above Roblox UI. |
| `ToggleKey` | Enum.KeyCode | `K` | Key used by the built-in settings tab to show or hide the menu. |
| `SettingsTab` | boolean | `true` | Whether the built-in settings tab is created. |
| `SettingsTabName` | string | `UI Settings` | Name of the built-in settings tab. |

Creating another window with the same `GuiName` destroys the previous ScreenGui with that name.

## Window methods

### CreateTab

Creates a new sidebar tab.

```lua
local Main = Window:CreateTab("Main")

local Visuals = Window:CreateTab({
	Name = "Visuals",
})
```

The first normal tab is selected automatically. The settings tab is considered internal, so the first user-created tab replaces it as the selected tab.

### Notify

Displays a notification in the bottom-right corner.

```lua
Window:Notify("Simple notification", 3)

Window:Notify({
	Content = "Settings saved",
	Duration = 3,
})
```

The library-level notification method sends the notification through the most recently created window:

```lua
Andromeda:Notify("Hello", 2)
```

### SetVisible and Toggle

```lua
Window:SetVisible(false)
Window:SetVisible(true)
Window:Toggle()
```

Opening a window unlocks and shows the mouse cursor. Closing it restores the previous mouse behavior.

### Minimize and close

The header includes minimize and close buttons. Close hides the window without destroying it, so the configured menu key can reopen it.

```lua
Window:SetMinimized(true)
Window:SetMinimized(false)
Window:ToggleMinimized()
Window:Close()
```

### SetScale

```lua
Window:SetScale(1.1)
```

The value is clamped between `0.55` and `1.4`.

### Shadow

Andromeda uses Roblox's native `UIShadow`. Customize it while creating the window:

```lua
local Window = Andromeda:CreateWindow({
	Name = "My Hub",
	Shadow = {
		Enabled = true,
		BlurRadius = UDim.new(0, 18),
		Color = Color3.fromRGB(0, 0, 0),
		Offset = UDim2.fromOffset(0, 7),
		Spread = UDim2.fromOffset(8, 8),
		Transparency = 0.5,
		ZIndex = -1,
	},
})
```

Update it later through the window API:

```lua
Window:SetShadow({
	Color = Color3.fromRGB(120, 90, 255),
	BlurRadius = UDim.new(0, 24),
	Transparency = 0.65,
})

Window:SetShadow(false)
Window:SetShadow(true)
```

The underlying instance is also available as `Window.Shadow`.

### SetTheme

```lua
Window:SetTheme("midnight")
```

You can also apply a custom theme table:

```lua
Window:SetTheme({
	Background = Color3.fromRGB(15, 15, 18),
	Panel = Color3.fromRGB(22, 22, 27),
	Element = Color3.fromRGB(32, 32, 38),
	Accent = Color3.fromRGB(120, 90, 255),
	Text = Color3.fromRGB(235, 235, 235),
	Muted = Color3.fromRGB(150, 138, 150),
	Stroke = Color3.fromRGB(54, 51, 65),
})
```

To change every open Andromeda window:

```lua
Andromeda:SetTheme("emerald")
```

### ClearKeybinds

```lua
Window:ClearKeybinds(false)
```

Passing `false` clears editable feature keybinds while preserving locked keybinds. Passing `true` also clears locked keybinds.

### Destroy

```lua
Window:Destroy()
```

Destroys the window and disconnects all connections created for it.

To destroy every window and clear all flags:

```lua
Andromeda:Destroy()
```

## Tabs and sections

Controls can be created directly on a tab:

```lua
local Main = Window:CreateTab("Main")

Main:CreateButton({
	Name = "Tab-level button",
	Callback = function()
		print("Clicked")
	end,
})
```

Sections group controls under a heading:

```lua
local PlayerSection = Main:CreateSection("Player")

PlayerSection:CreateToggle({
	Name = "Example",
	CurrentValue = false,
})
```

A section can also be created without a visible heading:

```lua
local HiddenHeading = Main:CreateSection({
	Name = "Internal section",
	Hidden = true,
})
```

`ShowTitle = false` has the same effect as `Hidden = true`.

## Common control options

Most interactive controls support these options:

| Option | Description |
| --- | --- |
| `Name` | Text displayed by the control. |
| `Description` | Tooltip displayed while hovering. `Tooltip` is an alias. |
| `Callback` | Function called when the control changes or activates. |
| `Flag` | Key used to store the control value in `Andromeda.Flags`. |
| `Notification` | Notification shown automatically after the callback. `Notify` is an alias. |
| `CurrentKeybind` | Optional Enum.KeyCode or key name string. `Keybind` is an alias. |
| `LockKeybind` | Prevents the keybind from being cleared by the user or `ClearKeybinds(false)`. |
| `Rebindable` | When used with a locked keybind, allows changing its key without allowing it to be cleared. |

Callbacks are protected with `pcall`. A callback error is reported as an Andromeda warning without stopping the rest of the interface.

### Automatic notifications

```lua
Main:CreateButton({
	Name = "Save",
	Notification = {
		Content = "Saved successfully",
		Duration = 2,
	},
	Callback = function()
		print("Saving...")
	end,
})
```

## Label

Labels display simple non-interactive text.

```lua
local Label = Main:CreateLabel("Waiting...")

Label:Set("Ready")
print(Label.Instance)
```

You can also pass a table:

```lua
Main:CreateLabel({
	Text = "Status: online",
})
```

`Content` can be used instead of `Text`.

## Paragraph

Paragraphs display a heading and wrapped content.

```lua
local Paragraph = Main:CreateParagraph({
	Title = "Information",
	Content = "This is a longer explanation displayed inside the UI.",
})
```

Update the paragraph later:

```lua
Paragraph:Set({
	Title = "Updated title",
	Content = "Updated content",
})

Paragraph:Set("Only replace the body text")
```

## Button

Buttons run a callback when clicked. They can also have a keybind.

```lua
local Button = Main:CreateButton({
	Name = "Run action",
	Description = "Runs an example action",
	CurrentKeybind = Enum.KeyCode.B,
	Callback = function()
		print("Action executed")
	end,
})
```

### Button controller

```lua
Button:Fire()                         -- run the button callback
Button:Set("Renamed button")         -- change its displayed name
Button:SetKey(Enum.KeyCode.G)         -- change its keybind
print(Button:GetKey())                -- get its keybind
Button:ClearKey()                     -- clear its keybind
```

## Toggle

Toggles store a boolean value.

```lua
local Toggle = Main:CreateToggle({
	Name = "Enabled",
	CurrentValue = false,
	CurrentKeybind = Enum.KeyCode.T,
	Flag = "Enabled",
	Callback = function(enabled)
		print("Enabled:", enabled)
	end,
})
```

`Default` can be used instead of `CurrentValue`.

### Toggle controller

```lua
Toggle:Set(true)
Toggle:Set(false, true) -- silent: update without calling the callback

print(Toggle:Get())

Toggle:SetKey(Enum.KeyCode.Y)
print(Toggle:GetKey())
Toggle:ClearKey()
```

## Slider

Sliders select a number within a range. Their value text uses `current / maximum`, and every slider includes a reset button by default.

```lua
local Slider = Main:CreateSlider({
	Name = "Walk speed",
	Range = {0, 200},
	Increment = 1,
	CurrentValue = 16,
	Suffix = " studs",
	ResetButton = true,
	Flag = "WalkSpeed",
	Callback = function(value)
		print("Speed:", value)
	end,
})
```

Alternative range names are supported:

```lua
Main:CreateSlider({
	Name = "Volume",
	Min = 0,
	Max = 1,
	Step = 0.05,
	Default = 0.5,
})
```

### Slider controller

```lua
Slider:Set(50)
Slider:Set(75, true) -- silent update

print(Slider:Get())
Slider:Reset()
```

The reset button inside the slider also restores its original value. Set `ResetButton = false` to hide it.

## Dropdown

Dropdowns select one option.

```lua
local Dropdown = Main:CreateDropdown({
	Name = "Aim part",
	Options = {"Head", "HumanoidRootPart", "Random"},
	CurrentOption = "Head",
	Flag = "AimPart",
	Callback = function(option)
		print("Selected:", option)
	end,
})
```

`Default` can be used instead of `CurrentOption`. If the current option is passed as a table, the first value is used.

### Dropdown controller

```lua
Dropdown:Set("HumanoidRootPart")
Dropdown:Set("Head", true) -- silent update

print(Dropdown:Get())

Dropdown:Refresh({"UpperTorso", "LowerTorso", "Head"})
Dropdown:Refresh({"One", "Two", "Three"}, true) -- try to keep the current selection
```

## Multi-dropdown

Multi-dropdowns allow multiple options to be selected. Selected options use the theme accent color.

```lua
local MultiDropdown = Main:CreateMultiDropdown({
	Name = "Enabled features",
	Options = {"ESP", "Tracers", "Chams", "Distance"},
	CurrentOption = {"ESP", "Distance"},
	Flag = "EnabledFeatures",
	Callback = function(options)
		for _, option in ipairs(options) do
			print(option)
		end
	end,
})
```

You can also create a multi-dropdown through `CreateDropdown`:

```lua
Main:CreateDropdown({
	Name = "Multiple",
	MultipleOptions = true,
	Options = {"One", "Two", "Three"},
	CurrentOption = {"One", "Three"},
})
```

### Multi-dropdown controller

```lua
MultiDropdown:Set({"Tracers", "Chams"})
MultiDropdown:Set({"ESP"}, true) -- silent update

local selectedOptions = MultiDropdown:Get()

MultiDropdown:Refresh({"Players", "World", "Camera"})
MultiDropdown:Refresh({"Players", "World", "Camera"}, true)
```

## Color picker

Color pickers expose hue, saturation, and brightness sliders.

```lua
local ColorPicker = Main:CreateColorPicker({
	Name = "ESP color",
	Color = Color3.fromRGB(120, 90, 255),
	Flag = "ESPColor",
	Callback = function(color)
		print(color)
	end,
})
```

`CurrentColor` and `Default` are aliases for `Color`.

### Color picker controller

```lua
ColorPicker:Set(Color3.fromRGB(255, 80, 120))
ColorPicker:Set(Color3.new(1, 1, 1), true) -- silent update

print(ColorPicker:Get())
ColorPicker:Reset()
```

## Input

Inputs collect text. The callback runs when the TextBox loses focus.

```lua
local Input = Main:CreateInput({
	Name = "Command",
	PlaceholderText = "Enter a command...",
	CurrentValue = "",
	RemoveTextAfterFocusLost = false,
	Flag = "Command",
	Callback = function(value, enterPressed)
		print("Text:", value)
		print("Submitted with Enter:", enterPressed)
	end,
})
```

`Default` can be used instead of `CurrentValue`.

### Input controller

```lua
Input:Set("hello")
print(Input:Get())
print(Input.Instance)
```

## Keybind

Keybind controls run their callback when the selected key is pressed.

```lua
local Keybind = Main:CreateKeybind({
	Name = "Open notification",
	CurrentKeybind = Enum.KeyCode.N,
	Flag = "NotificationKey",
	Callback = function()
		Window:Notify("Keybind pressed", 2)
	end,
})
```

Key names can also be passed as strings:

```lua
CurrentKeybind = "N"
```

Click the key box to listen for a new key. Right-click it to clear the key unless `LockKeybind` is enabled.

### Keybind controller

```lua
Keybind:SetKey(Enum.KeyCode.K)
print(Keybind:GetKey())
Keybind:ClearKey()
```

When a keybind has a flag, its key is stored under `Flag .. "_Keybind"`:

```lua
print(Andromeda.Flags.NotificationKey_Keybind)
```

## Flags

Controls with a `Flag` automatically write their current value to `Andromeda.Flags`.

```lua
local GodMode = Main:CreateToggle({
	Name = "God mode",
	CurrentValue = false,
	Flag = "GodMode",
})

print(Andromeda.Flags.GodMode)

GodMode:Set(true)
print(Andromeda.Flags.GodMode) -- true
```

Flag values use these types:

| Control | Stored value |
| --- | --- |
| Toggle | boolean |
| Slider | number |
| Dropdown | selected value |
| Multi-dropdown | array of selected values |
| Color picker | Color3 |
| Input | string |
| Keybind | Enum.KeyCode under `Flag_Keybind` |

## Themes

Built-in themes:

- `andromeda`
- `midnight`
- `amethyst`
- `crimson`
- `emerald`
- `ocean`
- `sunset`
- `rose`
- `cyber`
- `monochrome`
- `coffee`

Add your own named theme:

```lua
Andromeda.Themes.custom = {
	Background = Color3.fromRGB(10, 18, 26),
	Panel = Color3.fromRGB(15, 29, 40),
	Element = Color3.fromRGB(23, 42, 56),
	Accent = Color3.fromRGB(65, 180, 255),
	Text = Color3.fromRGB(240, 248, 255),
	Muted = Color3.fromRGB(135, 158, 176),
	Stroke = Color3.fromRGB(38, 68, 88),
}

Window:SetTheme("custom")
```

## PNG icons

The transparent 128×128 icons are stored in `assets/icons`: search, resize, move, minimize, maximize, close, arrow, and reset. By default, the library downloads missing files once into `andromedaLib/icons` inside the executor workspace and loads them with `getcustomasset` or `getsynasset`.

No icon setup is needed when the executor supports `writefile` and custom assets. You can change the cache location per window:

```lua
local Window = Andromeda:CreateWindow({
	IconFolder = "myHub/andromeda-icons",
})
```

Uploaded Roblox asset IDs are still supported as overrides:

```lua
Andromeda.Icons.Search = "rbxassetid://0"
Andromeda.Icons.Resize = "rbxassetid://0"
Andromeda.Icons.Move = "rbxassetid://0"
Andromeda.Icons.Minimize = "rbxassetid://0"
Andromeda.Icons.Maximize = "rbxassetid://0"
Andromeda.Icons.Close = "rbxassetid://0"
Andromeda.Icons.Arrow = "rbxassetid://0"
Andromeda.Icons.Reset = "rbxassetid://0"
```

You can also pass the same fields through the `Icons` table in `CreateWindow`. If executor file APIs are unavailable and no IDs are supplied, compact text or drawn fallbacks are used.

## Built-in settings tab

Unless `SettingsTab = false`, every window receives the built-in UI Settings tab:

- **Menu**
  - Notifications toggle
  - Tooltips toggle
  - Mute sounds toggle
  - UI scale slider
  - Menu keybind, using K by default
  - Unload button
- **Themes**
  - Theme dropdown
  - Accent color picker
- **Shadow**
  - Enabled toggle
  - Color picker
- **Library**
  - Library name and version

The menu keybind can be changed, but it cannot be cleared.

Create a window without the built-in settings tab:

```lua
local Window = Andromeda:CreateWindow({
	Name = "Minimal window",
	SettingsTab = false,
})
```

When `SettingsTab = false`, the library does not create the automatic menu keybind. You can still call `Window:SetVisible()` or `Window:Toggle()`, or create your own keybind control.

## Search

The search box is displayed in the window header. It filters controls in the currently selected tab by instance name or visible text.

Search only changes visibility. It does not delete or disable controls.

## Aliases

The following control aliases are available on tabs and sections. `AddSection` is available on tabs only:

```lua
CreateButton        AddButton
CreateToggle        AddToggle
CreateSlider        AddSlider
CreateColorPicker   AddColorPicker
CreateDropdown      AddDropdown
CreateMultiDropdown AddMultiDropdown
CreateInput         AddInput
CreateInput         AddTextbox
CreateKeybind       AddKeybind
CreateLabel         AddLabel
CreateParagraph     AddParagraph
CreateSection       AddSection
```

Example:

```lua
Main:AddButton({
	Name = "Alias example",
	Callback = function()
		print("Clicked")
	end,
})
```

## Complete example

```lua
local Andromeda = loadstring(game:HttpGet("https://raw.githubusercontent.com/7doko/andromeda/main/andromeda.lua"))()

local Window = Andromeda:CreateWindow({
	Name = "Example Hub",
	ThemeName = "andromeda",
	ToggleKey = Enum.KeyCode.K,
})

local Main = Window:CreateTab("Main")
local Controls = Main:CreateSection("Controls")

Controls:CreateLabel("Ready")

Controls:CreateParagraph({
	Title = "Welcome",
	Content = "This interface was created with Andromeda.",
})

Controls:CreateButton({
	Name = "Notify",
	Callback = function()
		Window:Notify("Hello from Andromeda", 2)
	end,
})

Controls:CreateToggle({
	Name = "Toggle",
	CurrentValue = false,
	Flag = "Toggle",
	Callback = function(value)
		print(value)
	end,
})

Controls:CreateSlider({
	Name = "Slider",
	Range = {0, 100},
	Increment = 1,
	CurrentValue = 50,
	Flag = "Slider",
	Callback = function(value)
		print(value)
	end,
})

Controls:CreateDropdown({
	Name = "Dropdown",
	Options = {"One", "Two", "Three"},
	CurrentOption = "One",
	Flag = "Dropdown",
	Callback = function(value)
		print(value)
	end,
})

Controls:CreateMultiDropdown({
	Name = "Multi-dropdown",
	Options = {"A", "B", "C"},
	CurrentOption = {"A", "C"},
	Flag = "MultiDropdown",
	Callback = function(values)
		print(table.concat(values, ", "))
	end,
})

Controls:CreateColorPicker({
	Name = "Color picker",
	Color = Color3.fromRGB(120, 90, 255),
	Flag = "Color",
	Callback = function(color)
		print(color)
	end,
})

Controls:CreateInput({
	Name = "Input",
	PlaceholderText = "Type here...",
	Flag = "Input",
	Callback = function(text, enterPressed)
		print(text, enterPressed)
	end,
})

Controls:CreateKeybind({
	Name = "Keybind",
	CurrentKeybind = Enum.KeyCode.K,
	Callback = function()
		Window:Notify("K was pressed", 2)
	end,
})
```

## Troubleshooting

### The loadstring ran but nothing appeared

Call `Andromeda:CreateWindow()`. Loading the source only returns the library API.

### A keybind will not clear

The keybind was probably created with `LockKeybind = true`. Locked keybinds cannot be cleared. They can only be changed when `Rebindable = true`.

### The menu disappeared

Press the configured `ToggleKey`. The default is K.

### A callback failed

Check the Output window for an `[andromedaLib] callback error` warning.

### Values are not present in `Andromeda.Flags`

Add a unique `Flag` option to the control.
