local M = {}

M.defaults = {
	save_path = vim.fn.stdpath("data") .. "/spear.list",
	prune_missing = false, -- Auto-remove files that no longer exist
	ui = {
		border = "rounded", -- "single", "double", "rounded", "solid", "shadow"
		width_ratio = 0.5,
		height_ratio = 0.2,
		title = " Spear ",
	},
}

M.options = {}

function M.setup(options)
	M.options = vim.tbl_deep_extend("force", M.defaults, options or {})
end

return M
