return {
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "prettier",
        "buf",
        "gopls",
        "templ",
        "goimports",
        "gofumpt",
        "golines",
        "golangci-lint",
        "html-lsp", -- Useful for templ
        "tailwindcss-language-server",
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      -- 1. Ensure parsers are installed
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "templ", "go", "html", "css" })
      end

      -- 2. Register the filetype so Neovim recognizes .templ files
      vim.filetype.add({
        extension = {
          templ = "templ",
        },
      })
    end,
  },
  {
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

        -- Tailwind support for Templ files
        tailwindcss = {
          filetypes_include = { "templ" },
          settings = {
            tailwindCSS = {
              includeLanguages = {
                templ = "html",
              },
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
              templateExtensions = { "templ" },
              completeUnimported = true,
              usePlaceholders = true,
            },
          },
        },
      },
    },
  },
}
