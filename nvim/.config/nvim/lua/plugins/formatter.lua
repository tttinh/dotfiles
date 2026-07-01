return {
  "stevearc/conform.nvim",
  opts = {
    -- Define your formatters
    formatters_by_ft = {
      -- lua = { "stylua" },
      -- python = { "isort", "black" },
      -- javascript = { "prettierd", "prettier", stop_after_first = true },
      sql = { "pg_format" },
      yaml = { "prettier" },
      templ = { "templ" },
      go = { "goimports", "gofumpt", "golines" },
      ["markdown"] = { "prettier", "markdownlint-cli2", "markdown-toc" },
      ["markdown.mdx"] = { "prettier", "markdownlint-cli2", "markdown-toc" },
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
        prepend_args = { "--max-len=120", "--shorten-comments", "--base-formatter=gofumpt" },
      },
    },
  },
}
