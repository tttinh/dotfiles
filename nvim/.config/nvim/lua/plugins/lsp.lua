return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      -- JSON lsp.
      jsonls = {
        -- lazy-load schemastore when needed
        before_init = function(_, new_config)
          new_config.settings.json.schemas = new_config.settings.json.schemas or {}
          vim.list_extend(new_config.settings.json.schemas, require("schemastore").json.schemas())

          -- Extra schemas (not in the catalog, or overrides)
          vim.list_extend(new_config.settings.json.schemas, {
            {
              name = "devcontainer-feature.json",
              description = "dev container feature configuration files",
              fileMatch = { "devcontainer-feature.json", ".devcontainer-feature.json" },
              url = "https://raw.githubusercontent.com/devcontainers/spec/main/schemas/devContainerFeature.schema.json",
            },
          })
        end,
        settings = {
          json = {
            format = {
              enable = true,
            },
            validate = { enable = true },
          },
        },
      },
      -- YAML lsp.
      yamlls = {
        settings = {
          yaml = {
            format = {
              printWidth = 120,
            },
          },
        },
      },

      -- Proto lsp.
      buf_ls = {},

      -- templ lsp.
      templ = {
        filetypes = { "templ" },
        settings = {
          templ = {
            enable_snippets = true,
          },
        },
      },

      -- Go lsp.
      gopls = {
        settings = {
          gopls = {
            -- Example: Disable specific analyses or features
            analyses = {
              ST1000 = false, -- Disable package comment warnings
              errcheck = false,
            },
            -- You can explore more options in the gopls documentation
          },
        },
      },
    },
  },
}
