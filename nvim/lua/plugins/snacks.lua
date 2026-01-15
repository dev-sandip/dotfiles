return {
  -- Configure snacks.nvim file explorer to show all hidden files and folders
  {
    "folke/snacks.nvim",
    opts = {
      explorer = {
        enabled = true,
        show_hidden = true,
      },
    },
  },
}
