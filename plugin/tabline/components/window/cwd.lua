local cwd = ''

return {
  default_opts = { max_length = 0 },
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
    cwd = ' ' .. cwd
    return cwd or ''
  end,
}
