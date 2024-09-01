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

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("lazy").setup({
  spec = {
	"folke/tokyonight.nvim", opts = {}, priority = 1000, 
	"nvim-treesitter/nvim-treesitter", opts = {}, run = 'TSUpdate',
  "hrsh7th/nvim-cmp", opts = {},
  "hrsh7th/cmp-buffer", opts = {},
  "hrsh7th/cmp-path", opts = {},
  "hrsh7th/cmp-nvim-lsp", opts = {},
  "L3MON4D3/LuaSnip", opts = {},
  "rafamadriz/friendly-snippets", opts = {},
  "saadparwaiz1/cmp_luasnip", opts = {},
  "williamboman/mason.nvim", opts = {},
  "williamboman/mason-lspconfig.nvim", opts = {},
  "neovim/nvim-lspconfig", opts = {},
  "nvim-tree/nvim-web-devicons",
  "romgrk/barbar.nvim", requires = 'nvim-web-devicons',
  "nvim-telescope/telescope.nvim", requires = 'sharkdp/fd', 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons',
  "nvim-lualine/lualine.nvim", requires = 'nvim-tree/nvim-web-devicons',
  "windwp/nvim-autopairs", event = "InsertEnter", config = true,
  "nvim-tree/nvim-tree.lua",
  "windwp/nvim-ts-autotag",
      "ngtuonghy/live-server-nvim", event = "VeryLazy", build = ":LiveServerInstall",
},
  install = { colorscheme = { "tokyonight-storm" } },
  checker = { enabled = true },
})

-- mason.nvim 
require('mason').setup()
require('mason-lspconfig').setup({
  ensure_installed = { 'lua_ls', 'pyright', 'bashls','csharp_ls', }, 
  automatic_installation = true,
})

--  lspconfig
local lspconfig = require('lspconfig')
local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()

--  nvim-cmp
vim.opt.completeopt = {'menu', 'menuone', 'noselect'}

require('luasnip.loaders.from_vscode').lazy_load()

local cmp = require('cmp')
local luasnip = require('luasnip')

local select_opts = { behavior = cmp.SelectBehavior.Select }

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end
  },
  sources = {

    { name = 'nvim_lsp', keyword_length = 1 },
    { name = 'luasnip', keyword_length = 2 },
  },
  window = {
    documentation = cmp.config.window.bordered(),
    completion = cmp.config.window.bordered(),
  },
  formatting = {
    fields = { 'menu', 'abbr', 'kind' },
    format = function(entry, item)
      local menu_icon = {
        luasnip = '',
        buffer = '',
      }

      item.menu = menu_icon[entry.source.name]
      return item
    end,
  },
  mapping = {
    ['<Up>'] = cmp.mapping.select_prev_item(select_opts),
    ['<Down>'] = cmp.mapping.select_next_item(select_opts),
    ['<C-p>'] = cmp.mapping.select_prev_item(select_opts),
    ['<C-n>'] = cmp.mapping.select_next_item(select_opts),
    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
    ['<C-d>'] = cmp.mapping.scroll_docs(4),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<C-y>'] = cmp.mapping.confirm({ select = true }),
    ['<CR>'] = cmp.mapping.confirm({ select = false }),
    ['<C-f>'] = cmp.mapping(function(fallback)
      if luasnip.jumpable(1) then
        luasnip.jump(1)
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<C-b>'] = cmp.mapping(function(fallback)
      if luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<Tab>'] = cmp.mapping(function(fallback)
      local col = vim.fn.col('.') - 1

      if cmp.visible() then
        cmp.select_next_item(select_opts)
      elseif col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
        fallback()
      else
        cmp.complete()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item(select_opts)
      else
        fallback()
      end
    end, { 'i', 's' }),
  },
})

-- lsp
require('mason-lspconfig').setup_handlers({
  function(server_name)
    lspconfig[server_name].setup {
      capabilities = lsp_capabilities,
    }
  end,
})

-- lualine
require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'auto',
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {
      statusline = {},
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = true,
    globalstatus = false,
    refresh = {
      statusline = 1000,
      tabline = 1000,
      winbar = 1000,
    }
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {'filename'},
    lualine_x = {'', '', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = {}
}

-- Ntree
require("nvim-tree").setup()

-- Nvim-ts
require('nvim-ts-autotag').setup({
  opts = {
    -- Defaults
    enable_close = true, -- Auto close tags
    enable_rename = true, -- Auto rename pairs of tags
    enable_close_on_slash = false -- Auto close on trailing </
  },
  -- Also override individual filetype configs, these take priority.
  -- Empty by default, useful if one of the "opts" global settings
  -- doesn't work well in a specific filetype
  per_filetype = {
    ["html"] = {
      enable_close = true 
    }
  }
})

-- nvim autopairs
require('nvim-autopairs').setup({
  disable_filetype = { "TelescopePrompt" , "vim" },
})
local cmp_autopairs = require('nvim-autopairs.completion.cmp')
local cmp = require('cmp')
cmp.event:on(
  'confirm_done',
  cmp_autopairs.on_confirm_done()
)

require('live-server-nvim').setup {
    custom = {
        "--port=8080",
        "--no-css-inject",
    },
 serverPath = vim.fn.stdpath("data") .. "/live-server/", --default
 open = "folder", -- folder|cwd     --default
}

