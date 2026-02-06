---@class SpearUI
---@field border? ('single'|'double'|'rounded'|'solid'|'shadow') Border style: "single", "double", "rounded", "solid", "shadow"
---@field width_ratio? number Window width ratio
---@field height_ratio? number Window height ratio
---@field title? string Window title

---@class SpearConfig
---@field save_path? string Path to save spear list file
---@field prune_missing? boolean Auto-remove files that no longer exist
---@field ui? SpearUI UI configuration
