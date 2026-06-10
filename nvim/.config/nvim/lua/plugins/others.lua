return {
  -- Make editor's background transparent.
  { "xiyaowong/transparent.nvim" },

  -- dbml files support.
  {
    "jidn/vim-dbml",
    ft = "dbml",
  },

  -- for oklch color highlight.
  {
    "eero-lehtinen/oklch-color-picker.nvim",
    event = "VeryLazy",
    version = "*",
    keys = {
      {
        "<leader>v",
        function()
          require("oklch-color-picker").pick_under_cursor()
        end,
        desc = "Color pick under cursor",
      },
    },
    ---@type oklch.Opts
    opts = {},
  },
}
