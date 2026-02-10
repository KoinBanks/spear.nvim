local M = {}
local config = require("spear.config")
local ui = require("spear.ui")

local function get_data_path()
	return config.options.save_path
end

local function ensure_data_dir()
	local path = get_data_path()
	local dir = vim.fn.fnamemodify(path, ":h")
	if vim.fn.isdirectory(dir) == 0 then
		vim.fn.mkdir(dir, "p")
	end
end

---@param opts? SpearConfig
function M.setup(opts)
	config.setup(opts or {})
	ensure_data_dir()

	if config.options.prune_missing then
		local lines = M.get_list()
		local valid_lines = {}
		local changed = false
		for _, path in ipairs(lines) do
			if vim.fn.filereadable(path) == 1 then
				table.insert(valid_lines, path)
			else
				changed = true
			end
		end
		if changed then
			M.save_list(valid_lines)
			vim.notify("[[Spear]] Pruned missing files from list", vim.log.levels.INFO)
		end
	end
end

function M.get_list()
	local path = get_data_path()
	local f = io.open(path, "r")
	if not f then
		return {}
	end

	local lines = {}
	for line in f:lines() do
		if line and line ~= "" then
			table.insert(lines, line)
		end
	end
	f:close()
	return lines
end

function M.save_list(lines)
	local path = get_data_path()
	local f = io.open(path, "w")
	if not f then
		vim.notify("[[Spear]] Could not open file for writing at " .. path, vim.log.levels.ERROR)
		return
	end
	for _, line in ipairs(lines) do
		if line ~= "" then
			f:write(line .. "\n")
		end
	end
	f:close()
end

function M.add_file()
	local file_path = vim.fn.expand("%:p")
	if file_path == "" then
		return
	end

	-- Don't add special buffers (terminals, quickfix, etc)
	if vim.bo.buftype ~= "" then
		vim.notify("[[Spear]] Cannot add a special buffer", vim.log.levels.WARN)
		return
	end

	local lines = M.get_list()

	-- Check if already exists
	for _, line in ipairs(lines) do
		if line == file_path then
			vim.notify("[[Spear]] File already added", vim.log.levels.INFO)
			return
		end
	end

	table.insert(lines, file_path)
	M.save_list(lines)
	vim.notify("[[Spear]] Added " .. file_path, vim.log.levels.INFO)
end

function M.toggle()
	ui.toggle(M.get_list(), function(new_lines)
		M.save_list(new_lines)
	end)
end

function M.open_file(index)
	if type(index) ~= "number" then
		vim.notify("[[Spear]] Index must be a number", vim.log.levels.ERROR)
		return
	end

	if index < 1 or index > 9 then
		vim.notify("[[Spear]] Only rows 1-9 are allowed", vim.log.levels.WARN)
		return
	end

	local lines = M.get_list()
	local path = lines[index]

	if path and path ~= "" then
		-- Check if file exists
		if vim.fn.filereadable(path) == 1 then
			-- Check if current buffer is already the file
			local current_path = vim.api.nvim_buf_get_name(0)
			if vim.loop.fs_realpath(current_path) == vim.loop.fs_realpath(path) then
				return -- Do nothing if already editing the file
			end
			vim.cmd("edit " .. path)
		else
			vim.notify("[[Spear]] File not found at " .. path, vim.log.levels.WARN)
		end
	else
		vim.notify("[[Spear]] No file specificed at row " .. index, vim.log.levels.INFO)
	end
end

return M
