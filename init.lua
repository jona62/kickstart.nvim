-- Latest change
-- set <space> as the leader key
-- see `:help mapleader`
--  note: must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- set help panel height 
vim.o.helpheight = vim.o.lines

-- remap terminal exit key-binding to esc
vim.api.nvim_exec([[tnoremap <esc> <c-\><c-n>]], true)

-- install package manager
--    https://github.com/folke/lazy.nvim
--    `:help lazy.nvim.txt` for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

-- [[ configure plugins ]]
-- note: here is where you install your plugins.
--  you can configure plugins using the `config` key.
--
--  you can also configure plugins after the setup call,
--    as they will be available in your neovim runtime.
require('lazy').setup({
  -- note: first, some plugins that don't require any configuration

  -- git related plugins
  'tpope/vim-fugitive',
  'tpope/vim-rhubarb',

  -- detect tabstop and shiftwidth automatically
  'tpope/vim-sleuth',

  -- note: this is where your plugins related to lsp can be installed.
  --  the configuration is done below. search for lspconfig to find it below.
  {
    -- lsp configuration & plugins
    'neovim/nvim-lspconfig',
    dependencies = {
      -- automatically install lsps to stdpath for neovim
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',

      -- useful status updates for lsp
      -- note: `opts = {}` is the same as calling `require('fidget').setup({})`
      { 'j-hui/fidget.nvim', opts = {} },

      -- additional lua configuration, makes nvim stuff amazing!
      'folke/neodev.nvim',
    },
  },

  {
    -- autocompletion
    'hrsh7th/nvim-cmp',
    dependencies = {
      -- snippet engine & its associated nvim-cmp source
      'l3mon4d3/luasnip',
      'saadparwaiz1/cmp_luasnip',

      -- adds lsp completion capabilities
      'hrsh7th/cmp-nvim-lsp',

      -- adds a number of user-friendly snippets
      'rafamadriz/friendly-snippets',
    },
  },

  -- useful plugin to show you pending keybinds.
  { 'folke/which-key.nvim', opts = {} },
  {
    -- adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      -- see `:help gitsigns.txt`
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
      on_attach = function(bufnr)
        vim.keymap.set('n', '<leader>hp', require('gitsigns').preview_hunk, { buffer = bufnr, desc = 'preview git hunk' })

        -- don't override the built-in and fugitive keymaps
        local gs = package.loaded.gitsigns
        vim.keymap.set({ 'n', 'v' }, ']c', function()
          if vim.wo.diff then
            return ']c'
          end
          vim.schedule(function()
            gs.next_hunk()
          end)
          return '<ignore>'
        end, { expr = true, buffer = bufnr, desc = 'jump to next hunk' })
        vim.keymap.set({ 'n', 'v' }, '[c', function()
          if vim.wo.diff then
            return '[c'
          end
          vim.schedule(function()
            gs.prev_hunk()
          end)
          return '<ignore>'
        end, { expr = true, buffer = bufnr, desc = 'jump to previous hunk' })
      end,
    },
  },

  {
    -- theme inspired by atom
    'navarasu/onedark.nvim',
    priority = 1000,
    config = function()
      vim.cmd.colorscheme 'onedark'
    end,
  },

  {
    -- set lualine as statusline
    'nvim-lualine/lualine.nvim',
    -- see `:help lualine.txt`
    opts = {
      options = {
        icons_enabled = false,
        theme = 'onedark',
        component_separators = '|',
        section_separators = '',
      },
    },
  },

  {
    -- add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    -- enable `lukas-reineke/indent-blankline.nvim`
    -- see `:help ibl`
    main = 'ibl',
    opts = {},
  },

  -- "gc" to comment visual regions/lines
  { 'numtostr/comment.nvim', opts = {} },

  -- fuzzy finder (files, lsp, etc)
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      -- fuzzy finder algorithm which requires local dependencies to be built.
      -- only load if `make` is available. make sure you have the system
      -- requirements installed.
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        -- note: if you are having trouble with this installation,
        --       refer to the readme for telescope-fzf-native for more instructions.
        build = 'make',
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
    },
  },

  {
    -- highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    build = ':tsupdate',
  },

  -- note: next step on your neovim journey: add/configure additional "plugins" for kickstart
  --       these are some example plugins that i've included in the kickstart repository.
  --       uncomment any of the lines below to enable them.
  -- require 'kickstart.plugins.autoformat',
  -- require 'kickstart.plugins.debug',

  -- note: the import below can automatically add your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
  --    you can use this folder to prevent any conflicts with this init.lua if you're interested in keeping
  --    up-to-date with whatever is in the kickstart repo.
  --    uncomment the following line and add your plugins to `lua/custom/plugins/*.lua` to get going.
  --
  --    for additional information see: https://github.com/folke/lazy.nvim#-structuring-your-plugins
  -- { import = 'custom.plugins' },
}, {})

-- [[ setting options ]]
-- see `:help vim.o`
-- note: you can change these options as you wish!

-- set relative line number
vim.wo.relativenumber = true

-- set highlight on search
vim.o.hlsearch = true

-- make line numbers default
vim.wo.number = true

-- enable mouse mode
vim.o.mouse = 'a'

-- sync clipboard between os and neovim.
--  remove this option if you want your os clipboard to remain independent.
--  see `:help 'clipboard'`
vim.o.clipboard = 'unnamedplus'

-- enable break indent
vim.o.breakindent = true

-- save undo history
vim.o.undofile = true

-- case-insensitive searching unless \c or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- keep signcolumn on by default
vim.wo.signcolumn = 'yes'

-- decrease update time
vim.o.updatetime = 250
vim.o.timeoutlen = 300

-- set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- note: you should make sure your terminal supports this
vim.o.termguicolors = true

-- [[ basic keymaps ]]

-- keymaps for better default experience
-- see `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<space>', '<nop>', { silent = true })

-- remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'go to next diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'open diagnostics list' })

-- [[ highlight on yank ]]
-- see `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('yankhighlight', { clear = true })
vim.api.nvim_create_autocmd('textyankpost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- [[ configure telescope ]]
-- see `:help telescope` and `:help telescope.setup()`
require('telescope').setup {
  defaults = {
    mappings = {
      i = {
        ['<c-u>'] = false,
        ['<c-d>'] = false,
      },
    },
  },
}

-- buffer settings
vim.keymap.set('n', '<leader>bc', ':enew<cr>', { desc = 'create new buffer', noremap = true, silent = true })
vim.keymap.set('n', '<leader>bd', ':bd!<cr>', { desc = 'delete current buffer', noremap = true, silent = true })
vim.keymap.set('n', '<leader>bl', ':ls<cr>', { desc = 'list all buffers', noremap = true, silent = true })
vim.keymap.set('n', '<leader>bn', ':bnext<cr>', { desc = 'next buffer', noremap = true, silent = true })
vim.keymap.set('n', '<leader>bp', ':bprev<cr>', { desc = 'previous buffer', noremap = true, silent = true })

vim.keymap.set('n', '<leader>noh', ':noh<cr>', { noremap = true, silent = true })

-- map <leader><space>b to create a new buffer
vim.keymap.set('n', '<leader>bb', function()
   local input = vim.fn.input('new buffer: ', '', 'customlist,expand')
    if #input > 0 then
        -- if user input is provided, try to open it as a file
        vim.cmd('edit ' .. input)
    else
        -- if no input is provided, create an empty buffer
        vim.cmd('enew')
    end
end, { noremap = true, silent = true, desc = 'create a new buffer with optional file or buffer-name' })

-- vim.keymap.set('n', '<leader><space>n', require('telescope.builtin').buffers, { desc = "buffers" }) 

-- set scrolloff to a high value
vim.o.scrolloff = 999

-- create an autocommand to trigger zz on cursormoved
vim.cmd([[autocmd cursormoved * norm! zz]])

-- toggle modifiable and startinsert for terminals in normal mode
vim.cmd([[
  command! toggleterminaledit call toggleterminaledit()

  function! toggleterminaledit()
    if &buftype ==# 'terminal'
      if &modifiable
        set nomodifiable
        echo "terminal edit: off"
      else
        set modifiable
        startinsert
        echo "terminal edit: on"
      endif
    else
      echo "not a terminal buffer"
    endif
  endfunction
]])

-- enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')

-- telescope live_grep in git root
-- function to find the git root directory based on the current buffer's path
local function find_git_root()
  -- use the current buffer's path as the starting point for the git search
  local current_file = vim.api.nvim_buf_get_name(0)
  local current_dir
  local cwd = vim.fn.getcwd()
  -- if the buffer is not associated with a file, return nil
  if current_file == "" then
    current_dir = cwd
  else
    -- extract the directory from the current file's path
    current_dir = vim.fn.fnamemodify(current_file, ":h")
  end

  -- find the git root directory from the current file's path
  local git_root = vim.fn.systemlist("git -c " .. vim.fn.escape(current_dir, " ") .. " rev-parse --show-toplevel")[1]
  if vim.v.shell_error ~= 0 then
    print("not a git repository. searching on current working directory")
    return cwd
  end
  return git_root
end

-- custom live_grep function to search in git root
local function live_grep_git_root()
  local git_root = find_git_root()
  if git_root then
    require('telescope.builtin').live_grep({
      search_dirs = {git_root},
    })
  end
end

vim.api.nvim_create_user_command('livegrepgitroot', live_grep_git_root, {})

-- see `:help telescope.builtin`
vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] find recently opened files' })
vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] find existing buffers' })
vim.keymap.set('n', '<leader>/', function()
  -- you can pass additional configuration to telescope to change theme, layout, etc.
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = '[/] fuzzily search in current buffer' })

vim.keymap.set('n', '<leader>gf', require('telescope.builtin').git_files, { desc = 'search [g]it [f]iles' })
vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, { desc = '[s]earch [f]iles' })
vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[s]earch [h]elp' })
vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[s]earch current [w]ord' })
vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[s]earch by [g]rep' })
vim.keymap.set('n', '<leader>sg', ':livegrepgitroot<cr>', { desc = '[s]earch by [g]rep on git root' })
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[s]earch [d]iagnostics' })
vim.keymap.set('n', '<leader>sr', require('telescope.builtin').resume, { desc = '[s]earch [r]esume' })

-- [[ configure treesitter ]]
-- see `:help nvim-treesitter`
-- defer treesitter setup after first render to improve startup time of 'nvim {filename}'
vim.defer_fn(function()
  require('nvim-treesitter.configs').setup {
    -- add languages to be installed here that you want installed for treesitter
    ensure_installed = { 'c', 'cpp', 'go', 'lua', 'python', 'rust', 'tsx', 'javascript', 'typescript', 'vimdoc', 'vim', 'bash' },

    -- autoinstall languages that are not installed. defaults to false (but you can change for yourself!)
    auto_install = false,

    highlight = { enable = true },
    indent = { enable = true },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = '<c-space>',
        node_incremental = '<c-space>',
        scope_incremental = '<c-s>',
        node_decremental = '<m-space>',
      },
    },
    textobjects = {
      select = {
        enable = true,
        lookahead = true, -- automatically jump forward to textobj, similar to targets.vim
        keymaps = {
          -- you can use the capture groups defined in textobjects.scm
          ['aa'] = '@parameter.outer',
          ['ia'] = '@parameter.inner',
          ['af'] = '@function.outer',
          ['if'] = '@function.inner',
          ['ac'] = '@class.outer',
          ['ic'] = '@class.inner',
        },
      },
      move = {
        enable = true,
        set_jumps = true, -- whether to set jumps in the jumplist
        goto_next_start = {
          [']m'] = '@function.outer',
          [']]'] = '@class.outer',
        },
        goto_next_end = {
          [']m'] = '@function.outer',
          [']['] = '@class.outer',
        },
        goto_previous_start = {
          ['[m'] = '@function.outer',
          ['[['] = '@class.outer',
        },
        goto_previous_end = {
          ['[m'] = '@function.outer',
          ['[]'] = '@class.outer',
        },
      },
      swap = {
        enable = true,
        swap_next = {
          ['<leader>a'] = '@parameter.inner',
        },
        swap_previous = {
          ['<leader>a'] = '@parameter.inner',
        },
      },
    },
  }
end, 0)

-- [[ configure lsp ]]
--  this function gets run when an lsp connects to a particular buffer.
local on_attach = function(_, bufnr)
  -- note: remember that lua is a real programming language, and as such it is possible
  -- to define small helper and utility functions so you don't have to repeat yourself
  -- many times.
  --
  -- in this case, we create a function that lets us more easily define mappings specific
  -- for lsp related items. it sets the mode, buffer and description for us each time.
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'lsp: ' .. desc
    end

    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  nmap('<leader>rn', vim.lsp.buf.rename, '[r]e[n]ame')
  nmap('<leader>ca', vim.lsp.buf.code_action, '[c]ode [a]ction')

  nmap('gd', require('telescope.builtin').lsp_definitions, '[g]oto [d]efinition')
  nmap('gr', require('telescope.builtin').lsp_references, '[g]oto [r]eferences')
  nmap('gi', require('telescope.builtin').lsp_implementations, '[g]oto [i]mplementation')
  nmap('<leader>d', require('telescope.builtin').lsp_type_definitions, 'type [d]efinition')
  nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[d]ocument [s]ymbols')
  nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[w]orkspace [s]ymbols')

  -- see `:help k` for why this keymap
  nmap('k', vim.lsp.buf.hover, 'hover documentation')
  nmap('<c-k>', vim.lsp.buf.signature_help, 'signature documentation')

  -- lesser used lsp functionality
  nmap('gd', vim.lsp.buf.declaration, '[g]oto [d]eclaration')
  nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[w]orkspace [a]dd folder')
  nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[w]orkspace [r]emove folder')
  nmap('<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, '[w]orkspace [l]ist folders')

  -- create a command `:format` local to the lsp buffer
  vim.api.nvim_buf_create_user_command(bufnr, 'format', function(_)
    vim.lsp.buf.format()
  end, { desc = 'format current buffer with lsp' })
end

-- document existing key chains
require('which-key').register {
  ['<leader>c'] = { name = '[c]ode', _ = 'which_key_ignore' },
  ['<leader>b'] = { name = '[b]uffer', _ = 'which_key_ignore' },
  ['<leader>d'] = { name = '[d]ocument', _ = 'which_key_ignore' },
  ['<leader>g'] = { name = '[g]it', _ = 'which_key_ignore' },
  ['<leader>h'] = { name = 'more git', _ = 'which_key_ignore' },
  ['<leader>r'] = { name = '[r]ename', _ = 'which_key_ignore' },
  ['<leader>s'] = { name = '[s]earch', _ = 'which_key_ignore' },
  ['<leader>w'] = { name = '[w]orkspace', _ = 'which_key_ignore' },
}

-- mason-lspconfig requires that these setup functions are called in this order
-- before setting up the servers.
require('mason').setup()
require('mason-lspconfig').setup()

-- enable the following language servers
--  feel free to add/remove any lsps that you want here. they will automatically be installed.
--
--  add any additional override configuration in the following tables. they will be passed to
--  the `settings` field of the server config. you must look up that documentation yourself.
--
--  if you want to override the default filetypes that your language server will attach to you can
--  define the property 'filetypes' to the map in question.
local servers = {
  -- clangd = {},
  -- gopls = {},
  -- pyright = {},
  -- rust_analyzer = {},
  -- tsserver = {},
  -- html = { filetypes = { 'html', 'twig', 'hbs'} },

  lua_ls = {
    lua = {
      workspace = { checkthirdparty = false },
      telemetry = { enable = false },
      -- note: toggle below to ignore lua_ls's noisy `missing-fields` warnings
      -- diagnostics = { disable = { 'missing-fields' } },
    },
  },
}

-- setup neovim lua configuration
require('neodev').setup()

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- ensure the servers above are installed
local mason_lspconfig = require 'mason-lspconfig'

mason_lspconfig.setup {
  ensure_installed = vim.tbl_keys(servers),
}

mason_lspconfig.setup_handlers {
  function(server_name)
    require('lspconfig')[server_name].setup {
      capabilities = capabilities,
      on_attach = on_attach,
      settings = servers[server_name],
      filetypes = (servers[server_name] or {}).filetypes,
    }
  end,
}

-- [[ configure nvim-cmp ]]
-- see `:help cmp`
local cmp = require 'cmp'
local luasnip = require 'luasnip'
require('luasnip.loaders.from_vscode').lazy_load()
luasnip.config.setup {}

cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  completion = {
    completeopt = 'menu,menuone,noinsert'
  },
  mapping = cmp.mapping.preset.insert {
    ['<c-n>'] = cmp.mapping.select_next_item(),
    ['<c-p>'] = cmp.mapping.select_prev_item(),
    ['<c-d>'] = cmp.mapping.scroll_docs(-4),
    ['<c-f>'] = cmp.mapping.scroll_docs(4),
    ['<c-space>'] = cmp.mapping.complete {},
    ['<cr>'] = cmp.mapping.confirm {
      behavior = cmp.confirmbehavior.replace,
      select = true,
    },
    ['<tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_locally_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.locally_jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  },
}

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
