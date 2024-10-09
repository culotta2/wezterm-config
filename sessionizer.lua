local wezterm = require("wezterm")

local M = {}

local fd = "/usr/bin/fd"

M.open = function(window, pane)
	local projects = {}
	local home = os.getenv("HOME") .. "/"
	-- Directories to search
	local project_dir = home .. "Documents/Personal/Projects"

	local success, stdout, stderr = wezterm.run_child_process({
		fd,
		"-HI",
		".git$",
		"--max-depth=5",
		"--prune",
		project_dir
		-- add more paths here
	})

	if not success then
		wezterm.log_error("Failed to run fd: " .. stderr)
		return
	end

	for line in stdout:gmatch("([^\n]*)\n?") do
		-- create label from file path
		local project = line:gsub("/.git.*", "")
		project = project:gsub("/$", "")
		local label = project:gsub(home, "")

		-- extract id. Used for workspace name
		local _, _, id = string.find(project, ".*/(.+)")
		id = id:gsub(".git", "") -- bare repo dirs typically end in .git, remove if so.

		table.insert(projects, { label = tostring(label), id = tostring(id) })
	end

	-- update previous_workspace before changing to new workspace.
	wezterm.GLOBAL.previous_workspace = window:active_workspace()
	window:perform_action(
		wezterm.action.InputSelector({
			action = wezterm.action_callback(function(win, _, id, label)
				if not id and not label then
					wezterm.log_info("Cancelled")
				else
					wezterm.log_info("Selected " .. label)
					win:perform_action(
						wezterm.action.SwitchToWorkspace({
							name = id,
							spawn = { cwd = home .. label },
						}),
						pane
					)
				end
			end),
			fuzzy = true,
			title = "Select project",
			choices = projects,
		}),
		pane
	)
end

return M
