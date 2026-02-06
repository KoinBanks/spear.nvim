local M = {}
local config = require("spear.config")

local buf_nr = nil
local win_nr = nil

function M.toggle(lines, on_save)
	if win_nr and vim.api.nvim_win_is_valid(win_nr) then
		vim.api.nvim_win_close(win_nr, true)
		win_nr = nil
		return
	end

	-- Create a reusable buffer if it doesn't exist or is invalid
	if not buf_nr or not vim.api.nvim_buf_is_valid(buf_nr) then
		buf_nr = vim.api.nvim_create_buf(false, true)
	end

	-- Set content
	vim.api.nvim_buf_set_lines(buf_nr, 0, -1, false, lines)

	-- Create floating window
	local ui_opts = config.options.ui or config.defaults.ui
	local width = math.floor(vim.o.columns * (ui_opts.width_ratio or 0.6))
	local height = math.floor(vim.o.lines * (ui_opts.height_ratio or 0.6))
	local col = math.floor((vim.o.columns - width) / 2)
	local row = math.floor((vim.o.lines - height) / 2)

	local opts = {
		relative = "editor",
		width = width,
		height = height,
		col = col,
		row = row,
		style = "minimal",
		border = ui_opts.border or "rounded",
		title = ui_opts.title or " Spear ",
		title_pos = "center",
	}

	win_nr = vim.api.nvim_open_win(buf_nr, true, opts)

	-- Set buffer options
	vim.bo[buf_nr].bufhidden = "wipe"
	vim.bo[buf_nr].filetype = "spear"

	-- Callback to save changes
	local function save_changes()
		if vim.api.nvim_buf_is_valid(buf_nr) then
			local new_lines = vim.api.nvim_buf_get_lines(buf_nr, 0, -1, false)
			-- Remove empty lines
			local clean_lines = {}
			for _, line in ipairs(new_lines) do
				if line and line ~= "" then
					table.insert(clean_lines, line)
				end
			end
			on_save(clean_lines)
		end
	end

	-- Save on closing the window or leaving the buffer
	vim.api.nvim_create_autocmd({ "BufLeave", "WinLeave" }, {
		buffer = buf_nr,
		callback = function()
			save_changes()
		end,
		once = true,
	})

	-- Keymaps to close
	vim.keymap.set("n", "q", function()
		if win_nr and vim.api.nvim_win_is_valid(win_nr) then
			vim.api.nvim_win_close(win_nr, true)
		end
	end, { buffer = buf_nr, silent = true })

	vim.keymap.set("n", "<Esc>", function()
		if win_nr and vim.api.nvim_win_is_valid(win_nr) then
			vim.api.nvim_win_close(win_nr, true)
		end
	end, { buffer = buf_nr, silent = true })

	-- Select file with CR
	vim.keymap.set("n", "<CR>", function()
		save_changes()
		local line = vim.api.nvim_get_current_line()
		if win_nr and vim.api.nvim_win_is_valid(win_nr) then
			vim.api.nvim_win_close(win_nr, true)
		end
		if line and line ~= "" then
			vim.cmd("edit " .. line)
		end
	end, { buffer = buf_nr, silent = true })
end

return M
