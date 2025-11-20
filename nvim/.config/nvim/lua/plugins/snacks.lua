return {
  {
    "folke/snacks.nvim",
    opts = {
      -- Set 'hidden' at the top-level 'explorer' table
      explorer = {
        hidden = true,

        -- Although less common now, you may also need to explicitly
        -- set it in the nested 'files' table for full coverage.
        files = {
          hidden = true,
        },
      },

      -- It's also a good idea to set this for the file picker (e.g., <leader>ff)
      picker = {
        hidden = true,
        sources = {
          files = {
            hidden = true,
          },
        },
      },
    },
  },
}
