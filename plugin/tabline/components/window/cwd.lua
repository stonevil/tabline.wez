local apcwd = ''

return {
  default_opts = { max_length = 0 },
  update = function(tab, opts)
    local apcwd_uri = tab.active_pane.current_working_dir
    if apcwd_uri then
      local file_path = apcwd_uri.file_path
      apcwd = file_path:match('([^/]+)/?$')
      if opts.max_length ~= 0 then
        if apcwd and #apcwd > opts.max_length then
          apcwd = apcwd:sub(1, opts.max_length - 1) .. '…'
        end
      end
    end
    return apcwd or ''
  end,
}
