vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

vim.g.have_nerd_font = true


require("config.options")

require("config.lazy")
require("config.keymaps")

require("luasnip.loaders.from_vscode").lazy_load({ paths = "~/.config/nvim/snippets" })

require("lualine").setup()
-- require("mini.sessions").setup()

vim.cmd.colorscheme "catppuccin"
