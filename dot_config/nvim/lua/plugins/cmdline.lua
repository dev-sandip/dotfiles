-- ~/.config/nvim/lua/plugins/cmdline.lua
return {
  {
    "folke/noice.nvim",
    opts = {
      cmdline = {
        view = "cmdline", -- Moves the ":" input to the bottom bar
      },
      presets = {
        command_palette = false, -- Disables the top-center floating popup layout
      },
    },
  },
}
