local function diff_source()
  local gitsigns = vim.b.gitsigns_status_dict
  if gitsigns then
    return {
      added = gitsigns.added,
      modified = gitsigns.changed,
      removed = gitsigns.removed
    }
  end
end

local function is_recording()
    local reg = vim.fn.reg_recording()
    if reg == "" then return "" end -- not recording
    return "recording @" .. reg
end

return {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {
        sections = {
            lualine_a = {
                { 'mode' },
            },
            lualine_b = {
                { is_recording },
                { 'branch' },
                { 'diff', source = diff_source }, 
                { 'diagnostics' }
            },
            lualine_c = {
              { 'filename' },
              {
                'searchcount',
                maxcount = 99999,
                timeout = 500,
              }
            },
            lualine_x = {'encoding', 'fileformat', 'filetype', 'lsp_status'},
        }
    }
}
