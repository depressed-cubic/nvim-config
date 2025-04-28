return {
    "scalameta/nvim-metals",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "j-hui/fidget.nvim",
        opts = {},
      },
      {
        "mfussenegger/nvim-dap",
        config = function(self, opts)
          -- Debug settings if you're using nvim-dap
          local dap = require("dap")

          dap.configurations.scala = {
            {
              type = "scala",
              request = "launch",
              name = "RunOrTest",
              metals = {
                runType = "runOrTestFile",
                --args = { "firstArg", "secondArg", "thirdArg" }, -- here just as an example
              },
            },
            {
              type = "scala",
              request = "launch",
              name = "Test Target",
              metals = {
                runType = "testTarget",
              },
            },
          }
        end,
      },
    },
    ft = { "scala", "sbt", "java" },
    opts = function()
	local metals_config = require("metals").bare_config()

      	metals_config.settings = {
      	  showImplicitArguments = true,
      	  excludedPackages = { "akka.actor.typed.javadsl", "com.github.swagger.akka.javadsl" },
      	}

      	metals_config.init_options.statusBarProvider = "off"

      	metals_config.capabilities = require("blink.cmp").get_lsp_capabilities()

        metals_config.on_attach = function(client, bufnr)
	    require("metals").setup_dap()

	    vim.keymap.set("n", "<leader>cl", vim.lsp.codelens.run)
            vim.keymap.set("n", "grf", vim.lsp.buf.format, { desc = "[F]ormat" } )
            vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action)
	    vim.keymap.set("n", "<leader>ws", function()
              require("metals").hover_worksheet()
            end)

	    vim.keymap.set("n", "<leader>dc", function()
              require("dap").continue()
            end)

            vim.keymap.set("n", "<leader>dr", function()
              require("dap").repl.toggle()
            end)

            vim.keymap.set("n", "<leader>dK", function()
              require("dap.ui.widgets").hover()
            end)

            vim.keymap.set("n", "<leader>dt", function()
              require("dap").toggle_breakpoint()
            end)

            vim.keymap.set("n", "<leader>dso", function()
              require("dap").step_over()
            end)

            vim.keymap.set("n", "<leader>dsi", function()
              require("dap").step_into()
            end)

            vim.keymap.set("n", "<leader>dl", function()
              require("dap").run_last()
            end)
	end

	return metals_config
    end,
    config = function(self, metals_config)
      local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
      vim.api.nvim_create_autocmd("FileType", {
        pattern = self.ft,
        callback = function()
          require("metals").initialize_or_attach(metals_config)
        end,
        group = nvim_metals_group,
      })
    end
}
