# Andromeda UI Library

Andromeda is a clean Roblox client UI library with tabs, sections, search, themes, notifications, flags, keybinds, tooltips, and reusable controls.

The library does not include game detection or gameplay features. You create the window and add your own controls through its API.

## Latest version

Load the newest version directly from GitHub:

```lua
local Andromeda = loadstring(game:HttpGet("https://raw.githubusercontent.com/7doko/andromeda/main/andromeda.lua"))()
```

Then create your interface normally:

```lua
local Window = Andromeda:CreateWindow({
	Name = "My Hub",
	Subtitle = "made with Andromeda",
})
```

The raw loader works in environments that provide `game:HttpGet` and `loadstring`. For a normal Roblox Studio project, use the ModuleScript installation below.

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
- Draggable window
- Configurable menu keybind
- Mouse cursor unlocking while the window is open

## Installation in Roblox Studio

1. Put the `andromedaLib` ModuleScript inside `ReplicatedStorage`.
2. Create a LocalScript inside `StarterPlayerScripts`.
3. Require the module from the LocalScript.

```lua
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Andromeda = require(ReplicatedStorage:WaitForChild("andromedaLib"))
```

Andromeda must be required from the client. Calling `CreateWindow()` from a server Script produces an error because `Players.LocalPlayer` only exists on the client.

## Quick start

```lua
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Andromeda = require(ReplicatedStorage:WaitForChild("andromedaLib"))

local Window = Andromeda:CreateWindow({
	Name = "My Hub",
	Subtitle = "made with Andromeda",
	ThemeName = "andromeda",
	ToggleKey = Enum.KeyCode.RightShift,
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

Requiring the ModuleScript does not create a window. The interface is created when you call `Andromeda:CreateWindow()`.

## Creating a window

```lua
local Window = Andromeda:CreateWindow({
	Name = "My Hub",
	Subtitle = "Utility interface",
	ThemeName = "andromeda",
	ToggleKey = Enum.KeyCode.RightShift,
	Scale = 1,
	SettingsTab = true,
})
```

### Window configuration

| Option | Type | Default | Description |
| --- | --- | --- | --- |
| `Name` | string | `andromeda v1.0.2` | Main window title. `Title` can also be used. |
| `Subtitle` | string | `UI library` | Smaller text below the title. |
| `ThemeName` | string | `andromeda` | Name of a built-in theme. |
| `Theme` | table | nil | Theme values that override the selected built-in theme. |
| `GuiName` | string | `andromedaLib` | Name assigned to the generated ScreenGui. |
| `DisplayOrder` | number | `9999` | ScreenGui display order. |
| `Size` | UDim2 | `UDim2.fromOffset(560, 360)` | Window size. |
| `Position` | UDim2 | `UDim2.fromScale(0.5, 0.5)` | Initial window position. |
| `Scale` | number | `1` | Initial UI scale. |
| `ToggleKey` | Enum.KeyCode | `RightShift` | Key used by the built-in settings tab to show or hide the menu. |
| `SettingsTab` | boolean | `true` | Whether the built-in settings tab is created. |
| `SettingsTabName` | string | `Settings` | Name of the built-in settings tab. |

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

### SetScale

```lua
Window:SetScale(1.1)
```

The value is clamped between `0.5` and `1.5`.

### SetTheme

```lua
Window:SetTheme("azure")
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
Andromeda:SetTheme("mint")
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

Sliders select a number within a range.

```lua
local Slider = Main:CreateSlider({
	Name = "Walk speed",
	Range = {0, 200},
	Increment = 1,
	CurrentValue = 16,
	Suffix = " studs",
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

The reset button inside the slider also restores its original value.

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
- `amber`
- `azure`
- `crimson`
- `rose`
- `mint`
- `pearl`

Add your own named theme:

```lua
Andromeda.Themes.ocean = {
	Background = Color3.fromRGB(10, 18, 26),
	Panel = Color3.fromRGB(15, 29, 40),
	Element = Color3.fromRGB(23, 42, 56),
	Accent = Color3.fromRGB(65, 180, 255),
	Text = Color3.fromRGB(240, 248, 255),
	Muted = Color3.fromRGB(135, 158, 176),
	Stroke = Color3.fromRGB(38, 68, 88),
}

Window:SetTheme("ocean")
```

## Built-in settings tab

Unless `SettingsTab = false`, every window receives the clean built-in Settings tab:

- **Appearance**
  - Theme dropdown
  - Window scale slider
- **Behavior**
  - Notifications toggle
  - Notification scale slider
  - Tooltips toggle
  - Mute interface sounds toggle
  - Send test notification button
  - Hide window button
- **Menu**
  - Menu keybind, using Right Shift by default
  - Clear editable keybinds button

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
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Andromeda = require(ReplicatedStorage:WaitForChild("andromedaLib"))

local Window = Andromeda:CreateWindow({
	Name = "Example Hub",
	Subtitle = "Andromeda documentation example",
	ThemeName = "andromeda",
	ToggleKey = Enum.KeyCode.RightShift,
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

### `andromedaLib must run on the client`

Require the module from a LocalScript, not from a server Script.

### The module was required but nothing appeared

Call `Andromeda:CreateWindow()`. Requiring the module by itself only returns the library table.

### A keybind will not clear

The keybind was probably created with `LockKeybind = true`. Locked keybinds cannot be cleared. They can only be changed when `Rebindable = true`.

### The menu disappeared

Press the configured `ToggleKey`. The default is Right Shift.

### A callback failed

Check the Output window for an `[andromedaLib] callback error` warning.

### Values are not present in `Andromeda.Flags`

Add a unique `Flag` option to the control.

## Showcase

The Roblox Studio place also includes `StarterPlayerScripts.AndromedaShowcase`, a complete LocalScript demonstrating every feature in a working interface.
