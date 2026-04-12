return {
  "stevearc/conform.nvim",
  opts = {
    -- Define your formatters
    formatters_by_ft = {
      -- lua = { "stylua" },
      -- python = { "isort", "black" },
      -- javascript = { "prettierd", "prettier", stop_after_first = true },
      -- go = { "goimports", "gofumpt", "gci", "golines" },
      go = { "goimports", "gofumpt", "golines" },
    },
    -- Customize formatters
    formatters = {
      -- gci = {
      --   prepend_args = {
      --     "-s",
      --     "standard",
      --     "-s",
      --     "default",
      --     "-s",
      --     "blank",
      --     "-s",
      --     "dot",
      --     "-s",
      --     "alias",
      --     "-s",
      --     "localmodule",
      --   },
      -- },
      golines = {
        prepend_args = { "--max-len=110", "--shorten-comments", "--base-formatter=gofumpt" },
      },
    },
  },
}
