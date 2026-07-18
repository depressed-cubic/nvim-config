vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

vim.g.have_nerd_font = true


require("config.options")

require("config.lazy")
require("config.keymaps")

require("luasnip.loaders.from_vscode").lazy_load({ paths = vim.fn.stdpath("config") .. "/snippets"})

require("luasnip.loaders.from_lua").lazy_load({ paths = vim.fn.stdpath("config") .. "/snippets"})

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

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'typst', 'html', 'copilot-chat', 'scala', 'amy', 'javascript', 'rust', 'sql' },
  callback = function() vim.treesitter.start() end,
})

-- Python: treesitter for highlights AND a custom indentexpr that:
--   * uses treesitter indent as primary source (so brackets inside strings
--     like `a = "67["` are correctly ignored — TS knows the parse tree)
--   * falls back to text-based rules when TS returns -1 (e.g., on a blank
--     line right after `def main():`, where the block node doesn't exist yet
--     so the @indent.begin capture doesn't apply): handle colon-after-line
--     indenting and basic dedent-after-stop-statements.
_G._python_indent = function(lnum)
  lnum = tonumber(lnum) or vim.v.lnum
  if lnum <= 1 then return 0 end

  -- Try treesitter indent first.
  local ok, ts = pcall(vim.treesitter.indentexpr, lnum)
  if ok and ts >= 0 then return ts end

  -- Fallback for blank line / no applicable capture.
  local pl = vim.fn.prevnonblank(lnum - 1)
  if pl == 0 then return 0 end

  local plindent = vim.fn.indent(pl)
  local sw = vim.bo.shiftwidth

  -- Strip trailing comment (naive: assumes # not inside a string on that line).
  local text = vim.fn.getline(pl):gsub('%s*#.*$', '')

  -- Previous line ended with `:` -> indent one level (def/if/for/while/with/etc)
  if text:match(':%s*$') then
    return plindent + sw
  end

  -- Stop-execution statement on its own -> dedent one (unless user already did)
  if text:match('^%s*(break|continue|pass)%s*$')
     or text:match('^%s*return%s*$')
     or text:match('^%s*raise%s*$') then
    if vim.fn.indent(lnum) <= plindent - sw then
      return -1  -- trust the user's manual dedent
    end
    return plindent - sw
  end

  -- Default: keep previous line's indent.
  return plindent
end

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'python' },
  callback = function()
    vim.treesitter.start()
    vim.bo.indentexpr = 'v:lua._python_indent(v:lnum)'
    vim.bo.indentkeys = '0{,0},0),0],:,0#,!^F,o,O,e,=elif,=except'
    vim.bo.smartindent = false
    vim.bo.autoindent = true
  end,
})

local typst_watch_processes = {}

local typst_watch_counter = 1

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'typst' },
  callback = function() 
    vim.b.watching = false 
    vim.api.nvim_buf_create_user_command(
        0,
        "TypstToggleWatch",
        function ()
            if (vim.b.watching) then
                typst_watch_processes[vim.b.typst_watch_handle]:close()
                print("Stop watching this file")
                vim.b.watching = false
            else 
                vim.b.typst_watch_handle = typst_watch_counter
                typst_watch_counter = typst_watch_counter + 1
                typst_watch_processes[vim.b.typst_watch_handle] = vim.loop.spawn("typst", { 
                    args = { "watch", vim.fn.expand("%:p"), "--root", "../../" } ,
                }, function (a, b) 
                    -- print(a, b) 
                end)
                vim.b.watching = true

                print("Starts watching this file")
                print(vim.fn.expand("%:p"))

                vim.cmd[[ TypstView ]]
            end
        end,
        {}
    )
    vim.api.nvim_buf_create_user_command(
        0,
        "TypstView",
        function ()
            local cur_path = vim.fn.expand("%:p")
            local len = string.len(cur_path)
            local pdf_path = string.sub(cur_path, 1, len-4) .. ".pdf"
            typst_watch_processes[vim.b.typst_watch_handle] = vim.loop.spawn("sioyek", { 
                args = { "--new-window", pdf_path } ,
            }, function (a, b) 
                -- print(a, b) 
            end)
        end,
        {}
    )
    vim.keymap.set('n', '<localleader>ll', ':TypstToggleWatch<CR>', { desc = "toggle typst watch" })
    vim.keymap.set('n', '<localleader>lv', ':TypstView<CR>', { desc = "open sioyek to view" })
  end,
})

vim.diagnostic.config({
    severity_sort = true
})

-- local typst_watch = vim.api.nvim_create_augroup("typst-watch", {  })
--
-- vim.api.nvim_create_autocmd('FileType', {
--     group = typst_watch,
--     pattern = { 'typst' };
--     callback = function (ev)
--         for w in string.gmatch(ev.file, "%C+") do 
--             print(w)
--             print("fuck")
--         end
--         -- vim.uv.spawn("typst", {
--         --     args = { 'watch', ev.file }
--         -- })
--     end
-- })
-- require("mini.sessions").setup()

