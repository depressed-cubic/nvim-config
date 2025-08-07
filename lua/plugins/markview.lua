-- For `plugins/markview.lua` users.
return 
{
    "OXY2DEV/markview.nvim",
    lazy = false,

    priority = 49,

    -- For blink.cmp's completion
    -- source
    dependencies = {
        "saghen/blink.cmp",
        -- -- requires icons
        -- 'nvim-tree/nvim-web-devicons',
        --
        -- -- ensure colorscheme loads properly
        -- "catppuccin/nvim",
    },

    opts = {
        preview = {
            icon_provider = "devicons", -- "mini" or "devicons"
        }
    }
};
