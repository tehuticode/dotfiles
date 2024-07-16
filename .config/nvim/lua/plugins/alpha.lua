
return {
  "goolord/alpha-nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },

  config = function()
    local alpha = require("alpha")
    local dashboard = require("alpha.themes.dashboard")



    -- Header
    dashboard.section.header.val= {
      [[=================     ===============     ===============   ========  ========]],
	[[\\ . . . . . . .\\   //. . . . . . .\\   //. . . . . . .\\  \\. . .\\// . . //]],
	[[||. . ._____. . .|| ||. . ._____. . .|| ||. . ._____. . .|| || . . .\/ . . .||]],
	[[|| . .||   ||. . || || . .||   ||. . || || . .||   ||. . || ||. . . . . . . ||]],
	[[||. . ||   || . .|| ||. . ||   || . .|| ||. . ||   || . .|| || . | . . . . .||]],
	[[|| . .||   ||. _-|| ||-_ .||   ||. . || || . .||   ||. _-|| ||-_.|\ . . . . ||]],
	[[||. . ||   ||-'  || ||  `-||   || . .|| ||. . ||   ||-'  || ||  `|\_ . .|. .||]],
	[[|| . _||   ||    || ||    ||   ||_ . || || . _||   ||    || ||   |\ `-_/| . ||]],
	[[||_-' ||  .|/    || ||    \|.  || `-_|| ||_-' ||  .|/    || ||   | \  / |-_.||]],
	[[||    ||_-'      || ||      `-_||    || ||    ||_-'      || ||   | \  / |  `||]],
	[[||    `'         || ||         `'    || ||    `'         || ||   | \  / |   ||]],
	[[||            .===' `===.         .==='.`===.         .===' /==. |  \/  |   ||]],
	[[||         .=='   \_|-_ `===. .==='   _|_   `===. .===' _-|/   `==  \/  |   ||]],
	[[||      .=='    _-'    `-_  `='    _-'   `-_    `='  _-'   `-_  /|  \/  |   ||]],
	[[||   .=='    _-'          '-__\._-'         '-_./__-'         `' |. /|  |   ||]],
	[[||.=='    _-'                                                     `' |  /==.||]],
	[[=='    _-'                        N E O V I M                         \/   `==]],
	[[\   _-'                                                                `-_   /]],
	[[ `''                                                                      ``' ]],
    }

         -- Buttons
    dashboard.section.buttons.val = {
      dashboard.button("e", "  New File", ":ene <BAR> startinsert <CR>"),
      dashboard.button("s", "  Settings", ":e $MYVIMRC<CR> | :cd %:p:h | split . | wincmd k | pwd<CR>"),
         }

     -- Footer
    local quote = "The greatest happiness is to scatter your enemy, to drive him before you, to see his cities reduced to ashes, to see those who love him shrouded in tears, and to gather into your bosom his wives and daughters. - Genghis Khan"
    local width = 80 -- Adjust based on your terminal width
    local padding = math.floor((width - #quote) / 2)
    local padded_quote = string.rep(" ", padding) .. quote
    dashboard.section.footer.val = { padded_quote }

      -- Center the text
    dashboard.opts.opts.noautocmd = true
    vim.cmd [[autocmd User AlphaReady echo 'm0xu']]
    alpha.setup(dashboard.opts)
  end,
}

