return {
  {
    "catppuccin/nvim",
    lazy = false,
    name = "catppuccin",
    priority = 1000,
    opts = {
    term_colors = true,
    transparent_background = true,
    dim_inactive = {
      enabled = false, -- dims the background color of inactive window
      shade = "dark",
      percentage = 0.15, -- percentage of the shade to apply to the inactive window
    },
    config = function()
      vim.cmd.colorscheme "catppuccin-frappe"
     -- vim.cmd[[hi Normal guibg=NONE ctermbg=NONE]]
    end
  }
  }
  }
