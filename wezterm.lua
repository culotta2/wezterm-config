local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- Settings
config.term = "xterm-256-color"
config.send_composed_key_when_left_alt_is_pressed = false
config.send_composed_key_when_right_alt_is_pressed = false

-- Key tables
local key_tables = {
	resize_font = {
		{ key = "k", action = wezterm.action.IncreaseFontSize },
		{ key = "j", action = wezterm.action.DecreaseFontSize },
		{ key = "r", action = wezterm.action.ResetFontSize },
		{ key = "Escape", action = "PopKeyTable" },
		{ key = "q", action = "PopKeyTable" },
	},
	copy_mode = {
		{key="c", mods="CTRL", action=wezterm.action.CopyMode("Close")},
		{key="q", mods="NONE", action=wezterm.action.CopyMode("Close")},
		{key="Escape", mods="NONE", action=wezterm.action.CopyMode("Close")},

		{key="h", mods="NONE", action=wezterm.action.CopyMode("MoveLeft")},
		{key="j", mods="NONE", action=wezterm.action.CopyMode("MoveDown")},
		{key="k", mods="NONE", action=wezterm.action.CopyMode("MoveUp")},
		{key="l", mods="NONE", action=wezterm.action.CopyMode("MoveRight")},

		{key="Enter", mods="NONE", action=wezterm.action.CopyMode("MoveToStartOfNextLine")},
		{key="w", mods="NONE", action=wezterm.action.CopyMode("MoveForwardWord")},
		{key="b", mods="NONE", action=wezterm.action.CopyMode("MoveBackwardWord")},
		{key="0", mods="NONE", action=wezterm.action.CopyMode("MoveToStartOfLine")},
		{key="$", mods="NONE", action=wezterm.action.CopyMode("MoveToEndOfLineContent")},
		{key="$", mods="SHIFT", action=wezterm.action.CopyMode("MoveToEndOfLineContent")},
		{key="^", mods="NONE", action=wezterm.action.CopyMode("MoveToStartOfLineContent")},
		{key="^", mods="SHIFT", action=wezterm.action.CopyMode("MoveToStartOfLineContent")},

		{key="v", mods="NONE",  action=wezterm.action.CopyMode{SetSelectionMode="Cell"}},
		{key="V", mods="NONE",  action=wezterm.action.CopyMode{SetSelectionMode="Line"}},
		{key="V", mods="SHIFT", action=wezterm.action.CopyMode{SetSelectionMode="Line"}},
		{key="v", mods="CTRL",  action=wezterm.action.CopyMode{SetSelectionMode="Block"}},

		{key="G", mods="NONE",  action=wezterm.action.CopyMode("MoveToScrollbackBottom")},
		{key="G", mods="SHIFT", action=wezterm.action.CopyMode("MoveToScrollbackBottom")},
		{key="g", mods="NONE",  action=wezterm.action.CopyMode("MoveToScrollbackTop")},

		{key="H", mods="NONE",  action=wezterm.action.CopyMode("MoveToViewportTop")},
		{key="H", mods="SHIFT", action=wezterm.action.CopyMode("MoveToViewportTop")},
		{key="M", mods="NONE",  action=wezterm.action.CopyMode("MoveToViewportMiddle")},
		{key="M", mods="SHIFT", action=wezterm.action.CopyMode("MoveToViewportMiddle")},
		{key="L", mods="NONE",  action=wezterm.action.CopyMode("MoveToViewportBottom")},
		{key="L", mods="SHIFT", action=wezterm.action.CopyMode("MoveToViewportBottom")},

		{key="o", mods="NONE",  action=wezterm.action.CopyMode("MoveToSelectionOtherEnd")},
		{key="O", mods="NONE",  action=wezterm.action.CopyMode("MoveToSelectionOtherEndHoriz")},
		{key="O", mods="SHIFT", action=wezterm.action.CopyMode("MoveToSelectionOtherEndHoriz")},

		{key="PageUp",   mods="NONE", action=wezterm.action.CopyMode("PageUp")},
		{key="PageDown", mods="NONE", action=wezterm.action.CopyMode("PageDown")},

		{key="b", mods="CTRL", action=wezterm.action.CopyMode("PageUp")},
		{key="f", mods="CTRL", action=wezterm.action.CopyMode("PageDown")},

		-- Enter y to copy and quit the copy mode.
		{key="y", mods="NONE", action=wezterm.action.Multiple{
			wezterm.action.CopyTo("ClipboardAndPrimarySelection"),
			wezterm.action.CopyMode("Close"),
		}},
		-- Enter search mode to edit the pattern.
		-- When the search pattern is an empty string the existing pattern is preserved
		{key="/", mods="NONE", action=wezterm.action{Search={CaseSensitiveString=""}}},
		{key="?", mods="NONE", action=wezterm.action{Search={CaseInSensitiveString=""}}},
		{key="n", mods="CTRL", action=wezterm.action{CopyMode="NextMatch"}},
		{key="p", mods="CTRL", action=wezterm.action{CopyMode="PriorMatch"}},
	},
	search_mode = {
		{key="Escape", mods="NONE", action=wezterm.action{CopyMode="Close"}},
		-- Go back to copy mode when pressing enter, so that we can use unmodified keys like "n"
		-- to navigate search results without conflicting with typing into the search area.
		{key="Enter", mods="NONE", action="ActivateCopyMode"},
		{key="c", mods="CTRL", action="ActivateCopyMode"},
		{key="n", mods="CTRL", action=wezterm.action{CopyMode="NextMatch"}},
		{key="p", mods="CTRL", action=wezterm.action{CopyMode="PriorMatch"}},
		{key="r", mods="CTRL", action=wezterm.action.CopyMode("CycleMatchType")},
		{key="u", mods="CTRL", action=wezterm.action.CopyMode("ClearPattern")},
	},
}

config.key_tables = key_tables

-- Appearance
config.color_scheme = "Catppuccin Mocha"
config.font = wezterm.font("FiraCode Nerd Font Mono")
config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true
config.window_padding = {
	left = 3,
	right = 3,
	top = 3,
	bottom = 3,
}
config.inactive_pane_hsb = {
	saturation = 0.9,
	brightness = 0.5,
}

-- Mappings
config.leader = { key = "b", mods = "CTRL", timeout_miliseconds = 1000 }
config.disable_default_key_bindings = true

-- Create unix muxer
config.unix_domains = {
	{
		name = "unix",
	},
}

config.keys = {
	-- {
	-- 	key="P",
	-- 	mods="SUPER",
	-- 	action=wezterm.action.ActivateCommandPalette,
	-- },
	{
		key="U",
		mods="SHIFT|CTRL",
		action=wezterm.action.CharSelect {
			copy_on_select=true,
			copy_to="ClipboardAndPrimarySelection",
		},
	},
	{
		key="R",
		mods="SHIFT|CTRL",
		action=wezterm.action.ReloadConfiguration,
	},
	{
		key="F",
		mods="SHIFT|CTRL",
		action=wezterm.action.Search {
			CaseSensitiveString = "",
		}
	},
	-- Copy Mode
	{key="[", mods="LEADER", action=wezterm.action.ActivateCopyMode},
	{key="]", mods="LEADER", action=wezterm.action.PasteFrom("PrimarySelection")},
	-- Terminal multiplex keys
	{
		mods="LEADER",
		key="c",
		action = wezterm.action({SpawnTab = "CurrentPaneDomain" })
	},
	{
		mods="LEADER|CTRL",
		key="c",
		action = wezterm.action({SpawnTab = "CurrentPaneDomain" })
	},
	{
		mods="LEADER",
		key="n",
		action = wezterm.action.ActivateTabRelative(1)
	},
	{
		mods="LEADER|CTRL",
		key="n",
		action = wezterm.action.ActivateTabRelative(1)
	},
	{
		mods="LEADER",
		key="x",
		action = wezterm.action({CloseCurrentPane={confirm=true}}),
	},
	{
		mods="LEADER",
		key="p",
		action = wezterm.action.ActivateTabRelative(-1)
	},
	{
		key = "r",
		mods = "LEADER",
		action = wezterm.action.PromptInputLine({
			description = "Enter new name for tab",
			action = wezterm.action_callback(
				---@diagnostic disable-next-line: unused-local
				function (window, pane, line)
					if line then
						window:active_tab():set_title(line)
					end
				end
			)
		}),
	},
	{
		mods="LEADER",
		key="z",
		action = wezterm.action.TogglePaneZoomState,
	},
	{
		mods="LEADER",
		key="s",
		action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" })
	},
	{
		mods="LEADER",
		key="c",
		action = wezterm.action{SpawnTab="CurrentPaneDomain"}
	},
	{
		mods="LEADER",
		key="v",
		action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" })
	},
	{
		mods="LEADER",
		key="h",
		action = wezterm.action.ActivatePaneDirection("Left")
	},
	{
		mods="LEADER",
		key="j",
		action = wezterm.action.ActivatePaneDirection("Down")
	},
	{
		mods="LEADER",
		key="k",
		action = wezterm.action.ActivatePaneDirection("Up")
	},
	{
		mods="LEADER",
		key="l",
		action = wezterm.action.ActivatePaneDirection("Right")
	},
	{
		mods="LEADER",
		key="0",
		action = wezterm.action({ActivateTab=0})
	},
	{
		mods="LEADER",
		key="1",
		action = wezterm.action({ActivateTab=1})
	},
	{
		mods="LEADER",
		key="2",
		action = wezterm.action({ActivateTab=2})
	},
	{
		mods="LEADER",
		key="3",
		action = wezterm.action({ActivateTab=3})
	},
	{
		mods="LEADER",
		key="4",
		action = wezterm.action({ActivateTab=4})
	},
	{
		mods="LEADER",
		key="5",
		action = wezterm.action({ActivateTab=5})
	},
	{
		mods="LEADER",
		key="6",
		action = wezterm.action({ActivateTab=6})
	},
	{
		mods="LEADER",
		key="7",
		action = wezterm.action({ActivateTab=7})
	},
	{
		mods="LEADER",
		key="8",
		action = wezterm.action({ActivateTab=8})
	},
	{
		mods="LEADER",
		key="9",
		action = wezterm.action({ActivateTab=9})
	},
	-- Sessionizer
	{
		key = "a",
		mods = "LEADER",
		action = wezterm.action.AttachDomain("unix"),
	},
	{
		key = "d",
		mods = "LEADER",
		action = wezterm.action.DetachDomain({ DomainName = "unix" }),
	},
	{
		key = "$",
		mods = "LEADER|SHIFT",
		action = wezterm.action.PromptInputLine({
			description = "Enter a new name for the session",
			---@diagnostic disable-next-line: unused-local
			action = wezterm.action_callback(function(window, pane, line)
				if line then
					---@diagnostic disable-next-line: undefined-global
					mux.rename_workspace(window:mux_window():get_workspace(), line)
				end
			end)
		}),
	},
	{
		key = 's',
		mods = 'LEADER',
		action = wezterm.action.ShowLauncherArgs({ flags = "WORKSPACES" }),
	},
}

return config
