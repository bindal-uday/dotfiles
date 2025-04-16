-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- config
config.font = wezterm.font("JetBrainsMono NF")
config.font_size = 10

config.enable_tab_bar = false
config.window_decorations = "NONE"
config.window_background_opacity = 0.95
config.macos_window_background_blur = 10

-- colorscheme
local catppuccin = require("themes/catppuccin").setup {
	-- whether or not to sync with the system's theme
	sync = true,
	-- the flavours to switch between when syncing
	-- available flavours: "latte" | "frappe" | "macchiato" | "mocha"
	sync_flavours = {
		light = "latte",
		dark = "mocha"
	},
	-- the default/fallback flavour, when syncing is disabled
	flavour = "mocha"
}

-- Set the color scheme based on current appearance
config.colors = catppuccin

-- Return the configuration to wezterm
return config
