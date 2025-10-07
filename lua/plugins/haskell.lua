return {
    'mrcjkb/haskell-tools.nvim',
    version = '^6', -- Recommended
    lazy = false, -- This plugin is already lazy
    config = function ()
        vim.g.haskell_tools = {
          ---@type haskell-tools.tools.Opts
          tools = {
            -- ...
          },
          ---@type haskell-tools.lsp.ClientOpts
          ---You can also configure these via `:h vim.lsp.config`,
          --- with the "haskell-tools" key.
          hls = {
            -- ---@param client number The LSP client ID.
            -- ---@param bufnr number The buffer number
            -- ---@param ht HaskellTools = require('haskell-tools')
            -- on_attach = function(client, bufnr, ht)
              -- Set keybindings, etc. here.
            capabilities = require('blink.cmp').get_lsp_capabilities()
            -- ...
          },
          ---@type haskell-tools.dap.Opts
          dap = {
            -- ...
          },
        }
    end
}
