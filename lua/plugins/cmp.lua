return {
  'saghen/blink.cmp', -- optional: provides snippets for the snippet source
  -- dependencies = { 'rafamadriz/friendly-snippets' },

  -- use a release tag to download pre-built binaries
  -- version = '1.*',
  -- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
  build = function()
      require('blink.cmp').build():pwait()
  end ,
  -- If you use nix, you can build from source using latest nightly rust with:
  -- build = 'nix run .#build-plugin',

  ---@module 'blink.cmp'
  ---@type blink.cmp.Config

  dependencies = {
      { 'L3MON4D3/LuaSnip', version = 'v2.*', build = 'make install_jsregexp', lazy = true , opts = { enable_autosnippets = true } },
      'saghen/blink.lib'
  },

  event = "InsertEnter",

  opts = {

    enabled = function ()
        return not vim.tbl_contains({ "sql" }, vim.bo.filetype)
    end,
    -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
    -- 'super-tab' for mappings similar to vscode (tab to accept)
    -- 'enter' for enter to accept
    -- 'none' for no mappings
    --
    -- All presets have the following mappings:
    -- C-space: Open menu or open docs if already open
    -- C-n/C-p or Up/Down: Select next/previous item
    -- C-e: Hide menu
    -- C-k: Toggle signature help (if signature.enabled = true)
    --
    -- See :h blink-cmp-config-keymap for defining your own keymap
    keymap = { preset = 'super-tab' },

    appearance = {
      -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
      -- Adjusts spacing to ensure icons are aligned
      nerd_font_variant = 'mono'
    },

    -- (Default) Only show the documentation popup when manually triggered
    completion = { documentation = { auto_show = true } },

    -- Default list of enabled providers defined so that you can extend it
    -- elsewhere in your config, without redefining it, due to `opts_extend`
    snippets = { preset = 'luasnip' },
    sources = {
      default = { 'lsp', 'path', 'snippets',
        'buffer',
        'omni'},
      providers = {
        buffer = {
          module = 'blink.cmp.sources.buffer',
          score_offset = -3,
          min_keyword_length = 4,
          opts = {
            -- default to all visible buffers
            get_bufnrs = function()
              return vim
                .iter(vim.api.nvim_list_wins())
                :map(function(win) return vim.api.nvim_win_get_buf(win) end)
                :filter(function(buf) return vim.bo[buf].buftype ~= 'nofile' end)
                :totable()
            end,
            -- buffers when searching with `/` or `?`
            get_search_bufnrs = function() return { vim.api.nvim_get_current_buf() } end,
          },
        },
        snippets = {
          min_keyword_length = 2,
        },
        lsp = {
          min_keyword_length = function(ctx)
            if vim.bo[ctx.bufnr].filetype == "typst" then
              return 4
            end
            return 0
          end,
        }
      },
    },


    -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
    -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
    -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
    --
    -- See the fuzzy documentation for more information
    fuzzy = { implementation = "prefer_rust_with_warning" }
  },
  opts_extend = { "sources.default" }
}
