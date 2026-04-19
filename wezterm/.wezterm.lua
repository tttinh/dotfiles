local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- Table to map OS patterns to font sizes
local font_sizes = {
	windows = 10.0,
	apple = 16.0,
	linux = 12.0, -- Optional: added for completeness
}

-- Default size if no match is found
config.font_size = 12.0

-- Loop through the table to find a match in the target_triple
for platform, size in pairs(font_sizes) do
	if wezterm.target_triple:find(platform) then
		config.font_size = size
		break
	end
end

config.color_scheme = "Tokyo Night"
config.font = wezterm.font("FiraMono Nerd Font")

config.hide_tab_bar_if_only_one_tab = true

config.window_decorations = "RESIZE"
config.window_background_opacity = 0.9
config.macos_window_background_blur = 10
config.default_cursor_style = "BlinkingBlock"

config.keys = {
	-- SPLITTING
	-- Vertical split (creates pane below)
	{
		key = '"',
		mods = "ALT|SHIFT",
		action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
	},
	-- Horizontal split (creates pane to the right)
	{
		key = "%",
		mods = "ALT|SHIFT",
		action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},

	-- NAVIGATING
	{ key = "h", mods = "ALT|SHIFT", action = wezterm.action.ActivatePaneDirection("Left") },
	{ key = "l", mods = "ALT|SHIFT", action = wezterm.action.ActivatePaneDirection("Right") },
	{ key = "k", mods = "ALT|SHIFT", action = wezterm.action.ActivatePaneDirection("Up") },
	{ key = "j", mods = "ALT|SHIFT", action = wezterm.action.ActivatePaneDirection("Down") },

	-- RESIZING
	{ key = "LeftArrow", mods = "ALT|SHIFT", action = wezterm.action.AdjustPaneSize({ "Left", 5 }) },
	{ key = "RightArrow", mods = "ALT|SHIFT", action = wezterm.action.AdjustPaneSize({ "Right", 5 }) },
	{ key = "UpArrow", mods = "ALT|SHIFT", action = wezterm.action.AdjustPaneSize({ "Up", 5 }) },
	{ key = "DownArrow", mods = "ALT|SHIFT", action = wezterm.action.AdjustPaneSize({ "Down", 5 }) },

	-- Close the current pane
	{
		key = "w",
		mods = "ALT|SHIFT",
		action = wezterm.action.CloseCurrentPane({ confirm = true }),
	},
}

return config
