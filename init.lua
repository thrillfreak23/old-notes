-- Bootstrap lazy.nvim  
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar() 
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

vim.opt.showtabline = 2
vim.opt.laststatus = 2
vim.opt.termguicolors = true

-- Set up both the traditional leader (for keymaps) as well as the local leader (for norg files)
vim.g.mapleader = " "
vim.g.maplocalleader = ","

-- Common Options
vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.expandtab = true
vim.opt.termguicolors = true
vim.o.shiftwidth = 4
vim.o.tabstop = 4
vim.o.termguicolors = true
vim.o.clipboard = "unnamedplus"  -- enable copy/paste with system clipboard
-- Briefy jump to the matching bracket when a closing one is typed
vim.opt.showmatch = true 
-- (Optional) Set the duration of the "flash" in tenths of a second (default is 5)
vim.opt.matchtime = 4 

--
-- Set textwidth for formatting
-- It's off because it fucks with neorg's folder headings
-- use <leader>tw to make textwidth = 70
vim.opt.textwidth = 0


vim.cmd("syntax on")
vim.cmd("filetype plugin indent on")
vim.cmd("inoremap ,a â")
vim.cmd("inoremap ,e ê")
vim.cmd("inoremap ,i î")
vim.cmd("inoremap ,o ô")
vim.cmd("inoremap ,u û")

vim.cmd("nnoremap <C-Left> :tabprevious<CR>")
vim.cmd("nnoremap <C-Right> :tabnext<CR>")

-- Setup lazy.nvim
-- plugins go here
-- PLUGINS GO HERE QQQ
require("lazy").setup({
  spec = {

{ "nvim-neorg/tree-sitter-norg-meta", lazy = false, priority = 1000 },
{ "nvim-neorg/tree-sitter-norg", lazy = false, priority = 1000 },



{ "calind/selenized.nvim" },
{
    'itchyny/lightline.vim',
    lazy = false, -- Load immediately to show statusline on startup
    config = function()
      -- Set the lightline theme to PaperColor
      vim.g.lightline = {
        -- colorscheme = 'selenized_black',
        -- colorscheme = 'srcery_drk',
        -- colorscheme = 'one',
        -- colorscheme = 'jellybeans',
        -- colorscheme = 'solarized',
        -- colorscheme = 'selenized_dark',
        -- colorscheme = 'molokai',
        -- colorscheme = 'rosepine',
        -- colorscheme = 'rosepine_moon',
        colorscheme = 'PaperColor_dark',
        -- colorscheme = 'Tomorrow',
        -- colorscheme = 'powerlineish',
        -- colorscheme = 'powerline',
        -- colorscheme = 'deus',
      }
      -- Optional: Ensure Neovim's main colorscheme also matches (requires PaperColor plugin)
      -- vim.cmd('colorscheme PaperColor')
    end
},



-- asdfasfasdfasdf
-- begin telescope section
-- ########
{ "BurntSushi/ripgrep", lazy = false, priority = 1000 }, 
{ "sharkdp/fd", lazy = false, priority = 1000 }, 
{ "nvim-telescope/telescope-fzf-native.nvim", lazy = false, priority = 1000 }, 


{
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      defaults = {
        vimgrep_arguments = {
          "rg",
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
          "--smart-case",
          "--hidden", -- Search hidden files
          "--follow", -- REQUIRED: follow symlinks
          "--glob", "!**/.git/*", "!**/.cache/*"-- Exclude git directory & hopefully cache dir
        },
      }, -- <-- Ensure there is a COMMA here before the next table
      pickers = {
        find_files = {
          hidden = true, -- Show hidden files in file finder
        },
      },
    },
  },



 -- 3. File Explorer (Optional: Neo-tree example)
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      filesystem = {
        filtered_items = {
          visible = true, -- Show hidden files by default
          hide_dotfiles = false,
          hide_gitignored = false,
        },
      },
    },
  },
-- asdfasfasdfasdf




{
  "webhooked/kanso.nvim",
  lazy = false,
  priority = 1000,
},


-- {
--     'crispgm/nvim-tabline',
--     dependencies = { 'nvim-tree/nvim-web-devicons' }, -- optional
--     config = true,
-- },
-- 
-- 
-- -- witch-line status line
--  {
--      "sontungexpt/witch-line",
--      dependencies = {
--          "nvim-tree/nvim-web-devicons",
--      },
--      lazy = false, -- Almost component is lazy load by default. So you can set lazy to false
--      opts = {},
--  },
-- 


      {
    "kamwitsta/vinyl.nvim",
    config = function()
        require("vinyl").setup({
            variant = "lighter",   -- the default is "lighter" (alternative: "darker")
            overrides = {
                ["@string"] = {fg="#00ff00"},
            },
        })
    end
},

      -- Using lazy.nvim
{
  'ribru17/bamboo.nvim',
  lazy = false,
  priority = 1000,
  config = function()
    require('bamboo').setup {
      -- optional configuration here
    }
    require('bamboo').load()
  end,
},

{ "bluz71/vim-moonfly-colors", name = "moonfly", lazy = false, priority = 1000 },
{ "nyoom-engineering/oxocarbon.nvim", name = "oxocarbon", lazy = false, priority = 1000 },
{ "sainnhe/edge", name = "edge", lazy = false, priority = 1000 },
{ "EdenEast/nightfox.nvim", name = "nightfox", lazy = false, priority = 1000 }, -- lazy
-- { "pappasam/papercolor-theme-slim", lazy = false, priority = 1000 },
-- the following line is there for papercolor-theme-slim
-- vim.cmd [[set winborder=rounded]]
{ "mhartington/oceanic-next", name = "oceanic-next", lazy = false, priority = 1000 },
{ "srcery-colors/srcery-vim", lazy = false, priority = 1000 },
{ 'NLKNguyen/papercolor-theme', lazy = false, priority = 1000 },

{ "vague-theme/vague.nvim", lazy = false, priority = 1000 },

-- {
--     -- Calls `require('slimline').setup({})`
--     "sschleemilch/slimline.nvim",
--     opts = {}
-- },



-- {
--    'nvim-lualine/lualine.nvim',
--    dependencies = { 'nvim-tree/nvim-web-devicons' },
--    config = function()
--      require('lualine').setup({
--        options = {
--            -- don't change the theme. it doesn't work right
--          theme = 'auto', -- Automatically matches your current colorscheme
--          icons_enabled = true,
--          -- previously was like this:
--          -- component_separators = { left = '', right = ''},
--          -- section_separators = { left = '', right = ''},
--          -- section_separators = { left = '', right = '' },
--          -- component_separators = { left = '', right = '' },   
--          refresh = {
--       statusline = 100,
--       tabline = 50,  -- Faster refresh for tabs
--       winbar = 100,
--     }
--        },
--        sections = {
--          lualine_a = {'mode'},
--          lualine_b = {'branch', 'diff', 'diagnostics'},
--          lualine_c = {'filename'},
--          lualine_x = {'encoding', 'fileformat', 'filetype'},
--          lualine_y = {'progress'},
--          lualine_z = {'location'}
--        },
-- 
--         tabline = {
--     lualine_a = { 'buffers' },
--     lualine_b = {},
--     lualine_c = {},
--     lualine_x = {},
--     lualine_y = {},
--     lualine_z = { 'tabs' }
--   },
--   options = {
--     -- Use rounded symbols for the tabline sections
--     -- component_separators = { left = '', right = '' },
--     -- section_separators = { left = '', right = '' },
--          component_separators = { left = '', right = ''},
--          section_separators = {  left = '', right = '' },
--   },
-- 
--      })
--    end
--  },
  

-- {
--    'beauwilliams/statusline.lua',
--    dependencies = {
--        'nvim-lua/lsp-status.nvim',
--    },
--    config = function()
--        require('statusline').setup({
--            match_colorscheme = true, -- Enable colorscheme inheritance (Default: false)
--            tabline = true, -- Enable the tabline (Default: true)
--            lsp_diagnostics = true, -- Enable Native LSP diagnostics (Default: true)
--            ale_diagnostics = false, -- Enable ALE diagnostics (Default: false)
--        })
--    end,
-- },

{
  "obsidian-nvim/obsidian.nvim",
  version = "*", -- use latest release, remove to use latest commit
  ---@module 'obsidian'
  ---@type obsidian.config
  opts = {
    legacy_commands = false, -- this will be removed in the next major release
    workspaces = {
      {
        name = "OBSIDIAN",
        -- path = "~/vaults/personal",
        path = "~/Documents/OBSIDIAN",
      },
      -- {
      --  name = "work",
      --  path = "~/vaults/work",
      -- },
      --
    },
      -- Configure Daily Notes here
  daily_notes = {
    folder = "DAILY NOTES", -- Path relative to vault root
    date_format = "%Y-%m-%d", -- Format used in Obsidian
    alias_format = "%B %-d, %Y",
  },
  },
},




{
  'maxmx03/solarized.nvim',
  lazy = false,
  priority = 1000,
  ---@type solarized.config
  opts = {},
  config = function(_, opts)
    vim.o.termguicolors = true
    vim.o.background = 'dark'
    require('solarized').setup(opts)
    -- vim.cmd.colorscheme 'solarized'
  end,
},

{
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  config = function()
    require("catppuccin").setup({
      flavour = "frappe", -- latte, frappe, macchiato, mocha
    })
        vim.o.background = "dark"
    -- vim.cmd.colorscheme "catppuccin"
  end
},


{
  "uloco/bluloco.nvim",
  lazy = false,
  priority = 1000,
  dependencies = { 'rktjmp/lush.nvim' }, -- Required dependency
  config = function()
    require("bluloco").setup({
      style = "dark", -- "auto" | "dark" | "light"
      transparent = false,
      italics = false,
    })
    vim.opt.termguicolors = false
    -- vim.cmd('colorscheme bluloco')
  end,
},



-- OneDark colorscheme
-- Style :: Choose between 'dark', 'darker', 'cool', 'deep', 'warm', 'warmer' and 'light'
{
  "navarasu/onedark.nvim",
  priority = 1000, -- make sure to load this before all the other start plugins
  config = function()
    require('onedark').setup {
      style = 'warmer'
    }
    require('onedark').load()
  end
},


    {
      "rebelot/kanagawa.nvim", -- neorg needs a colorscheme with treesitter support
      config = function()
          -- vim.cmd.colorscheme("kanagawa")
      end,
    },


  { "junegunn/fzf" },
  { "junegunn/fzf.vim" },
  { "junegunn/goyo.vim" },


      {
    'dhruvasagar/vim-table-mode',
    -- Optional: configure the plugin using the "config" key
    config = function()
      vim.g.table_mode_syntax = 0
      vim.g.table_mode_always_active = 1
      -- Set up keymaps within the config function
      -- vim.keymap.set('n', '<Leader>Tm', ':TableModeToggle<CR>', { silent = true, desc = 'Toggle Table Mode' })
      -- vim.keymap.set('v', '<Leader>Tt', ':Tableize<CR>', { silent = true, desc = 'Tableize visual selection' })
    end,
         },

     {
    "sainnhe/everforest",
    lazy = false,    -- Load immediately at startup
    priority = 1000, -- Load before all other plugins
    config = function()
      -- Optional: Configure Everforest options before loading
      vim.g.everforest_background = "hard" -- options: 'hard', 'medium', 'soft'
      vim.g.everforest_enable_italic = 1
      
      -- Load the colorscheme
      -- vim.cmd([[colorscheme everforest]])
    end,
  }, 


  {
  "eldritch-theme/eldritch.nvim",
  lazy = false,
  priority = 1000,
  opts = {},
},



{
  "loctvl842/monokai-pro.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    require("monokai-pro").setup()
    vim.cmd.colorscheme("monokai-pro")
  end,
},




{
  "Alligator/accent.vim",
  lazy = false,    -- Must load at startup
  priority = 1000, -- Ensure it loads before other plugins
  config = function()
    -- Set the accent color (options: 'red', 'green', 'blue', 'magenta', 'cyan', 'yellow')
    -- Default is 'yellow' if not set
    -- vim.g.accent_colour = 'yellow'
    vim.g.accent_background = "none" 
    vim.g.accent_no_bg = 1
    vim.g.accent_bold = 1
    vim.g.accent_italic = 1
    vim.g.accent_colour = 'green'
    vim.g.accent_darken = 1
    vim.g.accent_invert_status = 0
    -- Load the colorscheme
    -- vim.cmd([[colorscheme accent]])
  end,
},

    {
        "scottmckendry/cyberdream.nvim",
        lazy = false,
        priority = 1000,
    },

{
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  lazy = false,
  opts = {
    ensure_installed = { "lua", "vim", "vimdoc", "query", "norg", "norg_meta" },
    highlight = { enable = true },
  },
  config = function(_, opts)
    -- Fixes 'gzip' errors for some Linux users
    require("nvim-treesitter.install").prefer_git = true

    -- NEW API: Removed the 's' from 'configs'
    require("nvim-treesitter.config").setup(opts)
  end,
},








    
     -- 1. Load this FIRST and alone
  { "nvim-lua/plenary.nvim", lazy = false, priority = 1000 },

  {
  "ellisonleao/gruvbox.nvim",
  priority = 1000,
  lazy = false, -- Load immediately
  config = function()
    require("gruvbox").setup({
      -- Customize options here if needed, or leave empty for defaults
      contrast = "hard", -- Example: "hard", "soft", or ""
    })
    vim.o.background = "dark"
    -- vim.cmd("colorscheme gruvbox")
  end,
  },

    {
      "nvim-neorg/neorg",
      lazy = false,
      version = "*",
      config = function()
        require("neorg").setup {
          load = {
            ["core.defaults"] = {},
            ["core.concealer"] = {},
            ["core.dirman"] = {
              config = {
                workspaces = {
                  notes = "~/notes",
                },
                default_workspace = "notes",
              },
            },
          },
        }
  
        vim.wo.foldlevel = 99
        vim.wo.conceallevel = 2
      end,
    },
  },
})

-- ============================
-- Keymaps
-- ============================
-- toggle NERDTree with <leader>n
-- vim.keymap.set("n", "<leader>n", ":NERDTreeToggle<CR>", { silent = true })

-- Insert date in YYYY-MM-DD format
vim.keymap.set("n", "<leader>d", "i<C-R>=strftime('%a %Y-%m-%d %R')<CR><Esc>")

vim.keymap.set("n", "<leader>t", ":tabnew<CR>")

vim.keymap.set("n", "<leader>il", ":edit ~/.config/nvim/init.lua<CR>")

-- Open today's Neorg journal entry with <leader>j
vim.keymap.set("n", "<leader>j", ":Obsidian today<CR>", { noremap = true, silent = true })

-- Activate Neorg toc with <leader>c
vim.keymap.set("n", "<leader>tc", ":Neorg toc<CR>", { noremap = true, silent = true})

-- Execute :Neorg workspace notes<CR> with <leader>-n
vim.keymap.set("n", "<leader>i", ":Neorg workspace notes<CR>", { noremap = true, silent = true })

-- Activate Goyo with <leader>g
vim.keymap.set("n", "<leader>g", ":Goyo<CR>", { noremap = true, silent = true })

-- Activate Neorg (:Neorg<CR>)
vim.keymap.set("n", "<leader>N", ":Neorg<CR>", { noremap = true, silent = true })

-- Map :K to format the current paragraph
-- vim.keymap.set("n", "K", "gqap", { noremap = true, silent = true })
vim.keymap.set("n", "K", "gqap", { noremap = true, silent = true })

-- Map <leader>f to :Files<CR> for Fuzzy Finder 
vim.keymap.set("n", "<leader>f", ":Files<CR>", { noremap = true, silent = true })

vim.keymap.set("n", "<C-h>", "<C-w>h", { silent = true, desc = "Move to left window" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { silent = true, desc = "Move to left window" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { silent = true, desc = "Move to left window" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { silent = true, desc = "Move to left window" })

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })

-- Create an augroup to manage Goyo autocommands
local goyo_group = vim.api.nvim_create_augroup("GoyoSettings", { clear = true })

-- these next 2 sections set textwidth to 70 and only when Goyo is active
vim.api.nvim_create_autocmd("User", {
   pattern = "GoyoEnter",
    group = goyo_group,
    callback = function()
        -- Set your desired textwidth for writing (e.g., 80)
        vim.opt.textwidth = 70
    end,
})

vim.api.nvim_create_autocmd("User", {
    pattern = "GoyoLeave",
    group = goyo_group,
    callback = function()
        -- Reset it back to 0 (disabled) when you exit Goyo
        vim.opt.textwidth = 0
    end,
})

vim.api.nvim_create_user_command('ToggleTW', function()
  if vim.opt.textwidth:get() == 0 then
    vim.opt.textwidth = 70
    print("Textwidth: 70")
  else
    vim.opt.textwidth = 0
    print("Textwidth: Off")
  end
end, {})

vim.keymap.set("n", "<leader>tw", ":ToggleTW<CR>", { silent = true, desc = "Toggle textwidth on and off" })

vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.opt_local.textwidth = 80
  end,
})


-- set colorscheme
vim.cmd [[colorscheme PaperColor]]
-- vim.cmd [[Obsidian today]]
-- vim.o.conceallevel = 2
vim.wo.conceallevel = 2
vim.cmd [[set conceallevel=2]]

