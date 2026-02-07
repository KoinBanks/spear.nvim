# spear.nvim

A lightweight Neovim plugin for quickly bookmarking and navigating to your favorite files. Similar to [harpoon2.nvim](https://github.com/ThePrimeagen/harpoon), but stores file paths with absolute paths for better reliability.

## Features

- **File Bookmarking**: Store up to 9 file paths as bookmarks
- **Absolute Path Storage**: Stores files with absolute paths, preventing issues with relative path changes
- **Floating UI**: View and manage your bookmarks in a centered floating window
- **Quick Navigation**: Open bookmarked files by index (1-9)
- **Data Persistence**: Bookmarks are saved to your Neovim data directory
- **Automatic Pruning**: Optionally remove bookmarks to files that no longer exist

## Installation

Using [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
  "KoinBanks/spear.nvim",
  config = function()
    require("spear").setup()
  end
}
```

Using [packer.nvim](https://github.com/wbthomason/packer.nvim):

```lua
use {
  "KoinBanks/spear.nvim",
  config = function()
    require("spear").setup()
  end
}
```

## Configuration

Default configuration:

```lua
require("spear").setup({
  save_path = vim.fn.stdpath("data") .. "/spear.list",  -- Where to save bookmarks
  prune_missing = false,                                   -- Remove missing files on startup
  ui = {
    border = "rounded",    -- Border style: "rounded" | "double" | "single" | "shadow"
    width_ratio = 0.5,     -- Width as ratio of editor width
    height_ratio = 0.2,    -- Height as ratio of editor height
    title = " Spear ",     -- Window title
  }
})
```

## Usage

### API Functions

#### `M.setup(opts?)`

Initialize the plugin with optional configuration. Automatically creates the data directory if it doesn't exist.

```lua
require("spear").setup()
```

#### `M.add_file()`

Add the current file to your bookmarks list.

```lua
vim.keymap.set("n", "<leader>ha", require("spear").add_file)
```

#### `M.toggle()`

Open/close the floating window displaying your bookmarks. You can edit the list directly in the window.

```lua
vim.keymap.set("n", "<leader>ho", require("spear").toggle)
```

#### `M.open_file(index)`

Open the bookmarked file at the given index (1-9). Returns an error if the index is out of range or the file doesn't exist.

```lua
vim.keymap.set("n", "<leader>h1", function() require("spear").open_file(1) end)
vim.keymap.set("n", "<leader>h2", function() require("spear").open_file(2) end)
-- ... and so on for indices 3-9
```

### Floating Window Controls

When the floating window is open:

| Key        | Action                         |
| ---------- | ------------------------------ |
| `q`        | Close the window               |
| `<Esc>`    | Close the window               |
| `<CR>`     | Open the file at cursor        |
| Edit lines | Directly modify your bookmarks |

## Example Keybindings

Here's a suggested configuration with [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
  "yourusername/spear.nvim",
  config = function()
    require("spear").setup({
      ui = {
        border = "rounded",
        width_ratio = 0.6,
        height_ratio = 0.25,
      }
    })
  end,
  keys = {
    { "<leader>ha", function() require("spear").add_file() end, desc = "Spear: Add file" },
    { "<leader>ho", function() require("spear").toggle() end, desc = "Spear: Toggle menu" },
    { "<leader>h1", function() require("spear").open_file(1) end, desc = "Spear: Open file 1" },
    { "<leader>h2", function() require("spear").open_file(2) end, desc = "Spear: Open file 2" },
    { "<leader>h3", function() require("spear").open_file(3) end, desc = "Spear: Open file 3" },
    { "<leader>h4", function() require("spear").open_file(4) end, desc = "Spear: Open file 4" },
    { "<leader>h5", function() require("spear").open_file(5) end, desc = "Spear: Open file 5" },
    { "<leader>h6", function() require("spear").open_file(6) end, desc = "Spear: Open file 6" },
    { "<leader>h7", function() require("spear").open_file(7) end, desc = "Spear: Open file 7" },
    { "<leader>h8", function() require("spear").open_file(8) end, desc = "Spear: Open file 8" },
    { "<leader>h9", function() require("spear").open_file(9) end, desc = "Spear: Open file 9" },
  }
}
```

## How It Works

1. **Storing Bookmarks**: When you call `add_file()`, the absolute path of the current file is appended to the bookmarks list stored in your Neovim data directory.

2. **Viewing Bookmarks**: `toggle()` opens a centered floating window showing all your bookmarks with line numbers. You can directly edit this list.

3. **Opening Files**: `open_file(index)` reads the bookmarks file and opens the file at the specified row (1-9).

4. **File Validation**: When opening a file, the plugin checks if the file exists before attempting to open it.

## Requirements

- Neovim 0.10 or higher

## License

MIT
