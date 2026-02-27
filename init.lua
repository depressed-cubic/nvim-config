vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

vim.g.have_nerd_font = true


require("config.options")

require("config.lazy")
require("config.keymaps")

require("luasnip.loaders.from_vscode").lazy_load({ paths = vim.fn.stdpath("config") .. "/snippets"})

require("lualine").setup()

vim.api.nvim_create_autocmd('User', { pattern = 'TSUpdate',
callback = function()
  require('nvim-treesitter.parsers').amy = {
    install_info = {
      url = 'https://github.com/tree-sitter/tree-sitter-scala',
      -- optional entries:
      queries = 'queries/neovim', -- also install queries from given directory
    },
  }
end})

vim.treesitter.language.register("scala", { 'amy' })
-- require("mini.sessions").setup()

