local function nmap(key, cmd, desc)
    vim.api.nvim_set_keymap('n', key, cmd, { noremap = true, silent = true, desc = desc })
end

local function keymaps()
    nmap("<leader>oo", ":ObsidianOpen<CR>", "[O]bsidian [O]pen")
    nmap("<leader>ob", ":ObsidianBacklinks<CR>", "[O]bsidian [B]acklinks")
    nmap("<leader>otd", ":ObsidianToday<CR>", "[O]bsidian [T]o[d]ay")
    nmap("<leader>os", ":ObsidianSearch<CR>", "[O]bsidian [S]earch")
    nmap("<leader>on", ":ObsidianNew<CR>", "[O]bsidian [N]ew")
    nmap("<leader>it", ":ObsidianTemplate<CR>", "[O]bsidian [T]emplate")
   -- nmap("<leader>it", ":lua InsertTemplate()<CR>", "[I]nsert [T]emplate")
end

local opts = {
    default_workspace = "m0xu_vault",
    workspaces = {
        {
            name = "m0xu_vault",
            path = "/home/m0xu_p/1-Projects/vaults/m0xu_vault",
        },
        {
            name = "tsub0xdai_vault",
            path = "/home/m0xu_p/1-Projects/vaults/tsub0xdai_vault",
        },
    },
    new_notes_location = "current_dir",
    completion = {
        nvim_cmp = true,
        min_chars = 2,
    },
    templates = {
        subdir = "6-templates",
        date_format = "%Y-%m-%d",
        time_format = "%H:%M:%S",
    },
    ui = {
        enable = false,
    },
}

-- Custom function to browse and insert templates
function InsertTemplate()
    local telescope = require('telescope.builtin')
    local templates_dir = '/home/m0xu_p/1-Projects/vaults/m0xu_vault/templates'
    telescope.find_files({
        prompt_title = "Insert Template",
        cwd = templates_dir,
        attach_mappings = function(prompt_bufnr, map)
            local actions = require('telescope.actions')
            local actions_state = require('telescope.actions.state')

            map('i', '<CR>', function()
                local selected_entry = actions_state.get_selected_entry()
                local filename = selected_entry.value
                local file_content = vim.fn.readfile(templates_dir .. '/' .. filename)
                vim.api.nvim_put(file_content, '', true, true)
                actions.close(prompt_bufnr)
            end)

            return true
        end
    })
end

return {
    "epwalsh/obsidian.nvim",
    version = "*",
    keys = {
        { "<leader>otd", "<cmd>ObsidianToday<cr>", desc = "[O]bsidian [t]o[d]ay" },
        { "<leader>oo", "<cmd>ObsidianOpen<cr>", desc = "[O]bsidian [O]pen" },
        { "<leader>os", "<cmd>ObsidianSearch<cr>", desc = "[O]bsidian [S]earch" },
        { "<leader>on", "<cmd>ObsidianNew<cr>", desc = "[O]bsidian [N]ew" },
        { "<leader>ob", "<cmd>ObsidianBacklinks<cr>", desc = "[O]bsidian [B]acklinks" },
        { "<leader>ote", "<cmd>ObsidianTemplate<cr>", desc = "[O]bsidian [T]emplate" },
        { "<leader>at", "<cmd>lua InsertTemplate()<cr>", desc = "[A]lt [T]emplate" },
    },
    lazy = true,
    ft = "markdown",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
        "hrsh7th/nvim-cmp",
        "nvim-telescope/telescope.nvim",
    },
    config = function()
        local obsidian = require("obsidian")
        obsidian.setup(opts)
        keymaps()
    end
}
--Got the above from Obsidian Github
