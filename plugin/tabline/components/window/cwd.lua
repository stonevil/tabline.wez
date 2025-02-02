local wezterm = require('wezterm')
local util = require('tabline.util')

local cwd = ''

return {
  default_opts = {
    max_length = 0,
    folder_to_icon = {
      default = wezterm.nerdfonts.cod_folder,
      git = wezterm.nerdfonts.custom_folder_git,
    },
  },
  update = function(window, opts)
    local cwd_uri = window:active_pane():get_current_working_dir()
    if cwd_uri then
      cwd = cwd_uri.file_path
      if opts.max_length ~= 0 then
        if cwd and #cwd > opts.max_length then
          cwd = cwd:sub(1, opts.max_length - 1) .. '…'
        end
      end
    end

    -- capture git status call
    local cmd = 'git -C ' .. cwd_uri.file_path .. ' status --porcelain -b 2> /dev/null'
    local handle = assert(io.popen(cmd, 'r'), '')
    -- output contains empty line at end (removed by iterlines)
    local output = assert(handle:read('*a'))
    -- close io
    handle:close()

    local folder_type = ''
    -- check if git repo
    if output ~= '' then
      folder_type = 'git'
    end

    if opts.icons_enabled and opts.folder_to_icon then
      local icon = opts.folder_to_icon[folder_type] or opts.folder_to_icon.default
      -- local icon = opts.folder_to_icon[(folder_type):lower()] or opts.folder_to_icon.default
      util.overwrite_icon(opts, icon)
    end
    return cwd
  end,
}
