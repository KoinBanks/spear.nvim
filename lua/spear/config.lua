local M = {}

---@class SpearConfig
M.defaults = {
	save_path = vim.fn.stdpath("data") .. "/spear.list",
	prune_missing = false,
	---@class SpearUIConfig
	ui = {
		---@type "rounded" | "double" | "single" | "shadow"
		border = "rounded",
		width_ratio = 0.5,
		height_ratio = 0.2,
		title = " Spear ",
	},
}

M.options = {}

---@param options SpearConfig
function M.setup(options)
	M.options = vim.tbl_deep_extend("force", M.defaults, options or {})
end

return M
