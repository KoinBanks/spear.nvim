local M = {}

---@type SpearConfig
M.defaults = {
	-- Path to save spear list file
	save_path = vim.fn.stdpath("data") .. "/spear.list",
	-- Auto-remove files that no longer exist
	prune_missing = false,
	ui = {
		-- Border style: "single", "double", "rounded", "solid", "shadow"
		border = "rounded",
		-- Window width ratio
		width_ratio = 0.5,
		-- Window height ratio
		height_ratio = 0.2,
		-- Window title
		title = " Spear ",
	},
}

M.options = {}

---@param options SpearConfig
function M.setup(options)
	M.options = vim.tbl_deep_extend("force", M.defaults, options or {})
end

return M
