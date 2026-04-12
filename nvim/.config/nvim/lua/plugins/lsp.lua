return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      -- Proto lsp.
      buf_ls = {},

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
