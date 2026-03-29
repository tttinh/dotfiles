local wezterm = require("wezterm")
local config = wezterm.config_builder()
local act = wezterm.action

-- Table to map OS patterns to font sizes
local font_sizes = {
	windows = 10.0,
	apple = 14.0,
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
config.window_background_opacity = 0.8
config.macos_window_background_blur = 10

-- Set the leader key to Shift+Space (like tmux)
config.leader = { key = "Space", mods = "SHIFT", timeout_milliseconds = 2000 }
config.keys = {
	-- Move between WezTerm panes
	{ mods = "META", key = "h", action = act.ActivatePaneDirection("Left") },
	{ mods = "META", key = "j", action = act.ActivatePaneDirection("Down") },
	{ mods = "META", key = "k", action = act.ActivatePaneDirection("Up") },
	{ mods = "META", key = "l", action = act.ActivatePaneDirection("Right") },

	-- Splitting (Leader + - for horizontal, Leader + \ for vertical)
	{ mods = "META", key = "-", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
	{ mods = "META", key = "\\", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },

	-- Closing
	{ mods = "META", key = "d", action = act.CloseCurrentPane({ confirm = false }) },

	-- Enter copy mode
	{ mods = "LEADER", key = "[", action = act.ActivateCopyMode },
}

return config
