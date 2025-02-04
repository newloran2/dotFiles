vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function()
	use 'wbthomason/packer.nvim'

	use {
		"akinsho/toggleterm.nvim", 
		tag = '*', 
		config = function()
			require("plugins.toggleterm")
		end
	}
	use { 
		'phaazon/hop.nvim',
		cmd = {"HopChar2", "HopChar1CurrentLine"},
		config = function() 
			require 'hop'.setup() 
		end
	}										-- easy moviments

	-- lsp 
	use 'neovim/nvim-lspconfig'
	use 'williamboman/nvim-lsp-installer'
	use 'hrsh7th/nvim-cmp'
	use 'hrsh7th/cmp-nvim-lsp'
	use 'hrsh7th/cmp-buffer'
	use 'hrsh7th/cmp-path'
	use 'hrsh7th/cmp-nvim-lua'


	-- luasnip	
	use 'saadparwaiz1/cmp_luasnip'
	use 'L3MON4D3/LuaSnip'


	use {
		'chentoast/marks.nvim',
		config = function() 
			require('marks').setup() 
		end
	}

	use {
		"windwp/nvim-autopairs",
		config = function() require("nvim-autopairs").setup {} end
	}

	use {'akinsho/flutter-tools.nvim',
		requires = 'nvim-lua/plenary.nvim',
		config = function() 
			require("flutter-tools").setup{
				lsp = {
					color = { -- show the derived colours for dart variables
						enabled = false, -- whether or not to highlight color variables at all, only supported on flutter >= 2.10
						background = false, -- highlight the background
						foreground = false, -- highlight the foreground
						virtual_text = true, -- show the highlight using virtual text
						virtual_text_str = "■", -- the virtual text character to highlight
					},
					on_attach = function(c, b)
						default_lsp_key_bind(c, b)
					end
				}
			}
		end
	}
	use {
		'nvim-lualine/lualine.nvim',
		requires = { 'nvim-tree/nvim-web-devicons', opt = true}	
	}


	use {
		'nvim-telescope/telescope.nvim',
		requires = { {'nvim-lua/plenary.nvim'} }
	}
	use { 'ibhagwan/fzf-lua',
		requires = { 'nvim-tree/nvim-web-devicons' },
		config = function() 
			require("plugins.fzf-lua")
		end
	}
	use {
		'numToStr/Comment.nvim',
		config = function()
			require('Comment').setup()
		end
	}
	use {
		'nvim-treesitter/nvim-treesitter',
		config = function() 
			require'nvim-treesitter.configs'.setup {
				ensure_installed = {  "go", "lua", "rust", "kotlin", "swift" },
				sync_install = false,
				ignore_install = { "javascript" },
				highlight = {enable = true},
				indent = { enable = true },
				rainbow = {
					enable = true, 
					extended_mode = true, 
					max_file_lines = nil,
				}
			}
		end,
		incremental_selection = {
			enable = enable,
			keymaps = {
				-- mappings for incremental selection (visual mappings)
				init_selection = "gnn", -- maps in normal mode to init the node/scope selection
				node_incremental = "grn", -- increment to the upper named parent
				scope_incremental = "grc", -- increment to the upper scope (as defined in locals.scm)
				node_decremental = "grm" -- decrement to the previous node
			}
		},

		textobjects = {
			-- syntax-aware textobjects
			enable = enable,
			lsp_interop = {
				enable = enable,
				peek_definition_code = {
					["DF"] = "@function.outer",
					["DF"] = "@class.outer"
				}
			},
			keymaps = {
				["iL"] = {
					-- you can define your own textobjects directly here
					go = "(function_definition) @function",
				},
				-- or you use the queries from supported languages with textobjects.scm
				["af"] = "@function.outer",
				["if"] = "@function.inner",
				["aC"] = "@class.outer",
				["iC"] = "@class.inner",
				["ac"] = "@conditional.outer",
				["ic"] = "@conditional.inner",
				["ae"] = "@block.outer",
				["ie"] = "@block.inner",
				["al"] = "@loop.outer",
				["il"] = "@loop.inner",
				["is"] = "@statement.inner",
				["as"] = "@statement.outer",
				["ad"] = "@comment.outer",
				["am"] = "@call.outer",
				["im"] = "@call.inner"
			},
			move = {
				enable = enable,
				set_jumps = true, -- whether to set jumps in the jumplist
				goto_next_start = {
					["]m"] = "@function.outer",
					["]]"] = "@class.outer"
				},
				goto_next_end = {
					["]M"] = "@function.outer",
					["]["] = "@class.outer"
				},
				goto_previous_start = {
					["[m"] = "@function.outer",
					["[["] = "@class.outer"
},
goto_previous_end = {
	["[M"] = "@function.outer",
["[]"] = "@class.outer"
}
},
select = {
	enable = enable,
keymaps = {
	-- You can use the capture groups defined in textobjects.scm
["af"] = "@function.outer",
["if"] = "@function.inner",
["ac"] = "@class.outer",
["ic"] = "@class.inner",
-- Or you can define your own textobjects like this
["iF"] = {
	python = "(function_definition) @function",
cpp = "(function_definition) @function",
c = "(function_definition) @function",
java = "(method_declaration) @function",
go = "(method_declaration) @function"
}
}
},
swap = {
				enable = enable,
				swap_next = {
					["<leader>a"] = "@parameter.inner"
				},
swap_previous = {
					["<leader>A"] = "@parameter.inner"
				}
			}
		}
	}
	use {'dracula/vim', as = 'dracula'}
	use {
		'simrat39/symbols-outline.nvim',
		keys = "<leader>so",
		config = function()
			require("plugins.symbols-outline")
		end
	}
	use {
		'ray-x/go.nvim',
		ft='go',
		config = function() 
	-- require('go').setup()
local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
require('go').setup({
	-- other setups ....
lsp_cfg = {
	capabilities = capabilities,
-- other setups
				},
			})
		end
	}
	use 'ray-x/guihua.lua'
	use {
		'leoluz/nvim-dap-go', 
		requires = 'mfussenegger/nvim-dap', 
		config = function() 
			require('plugins.dap')
		end
	}
	use 'Pocco81/DAPInstall.nvim'
	use { 
		'rcarriga/nvim-dap-ui',
		config = function()
			require('dapui').setup()
		end
	}
	use {'stevearc/dressing.nvim'}
use { 
		'simrat39/rust-tools.nvim',
		-- ft = {'rs', 'toml'},
		requires = {'nvim-lua/plenary.nvim', 'saecki/crates.nvim'},
		config = function () 
			require('plugins/rust-tools')
		end
	}
   use {
      'chipsenkbeil/distant.nvim',
      branch = 'v0.2',
      config = function()
         require('distant').setup {
            -- Applies Chip's personal settings to every machine you connect to
            --
            -- 1. Ensures that distant servers terminate with no connections
            -- 2. Provides navigation bindings for remote directories
            -- 3. Provides keybinding to jump into a remote file's parent directory
            ['*'] = require('distant.settings').chip_default(),
            ['208.87.128.82'] = {
               lsp = {
                  ['crunchyroll-go'] = {
                     cmd = '/home/erik/go/bin/gopls',
                     root_dir = '/home/erik/projetos/crunchyroll-go',
                     filetypes = {'go'},
                     opts = { log_file = '/tmp/remote.dev.log', verbose=3},
                     on_attach = function()
                        nnoremap('gD', '<CMD>lua vim.lsp.buf.declaration()<CR>')
                        nnoremap('gd', '<CMD>lua vim.lsp.buf.definition()<CR>')
                        nnoremap('gh', '<CMD>lua vim.lsp.buf.hover()<CR>')
                        nnoremap('gi', '<CMD>lua vim.lsp.buf.implementation()<CR>')
                        nnoremap('gr', '<CMD>lua vim.lsp.buf.references()<CR>')
                     end
                  }
               }
            }
         }
      end
   }

   -- use {
   --     'goolord/alpha-nvim',
   --     requires = { 'nvim-tree/nvim-web-devicons' },
   --     config = function ()
   --         require'alpha'.setup(require'alpha.themes.startify'.config)
   --     end
   -- }
   use {
      'navarasu/onedark.nvim',
      config = function() 
         onedark = require('onedark')
         onedark.setup{
            style = 'dark',
            transparent = false,
            lualine = {
               transparent = false
            }
         }
         onedark.load()

      end
   }
   -- use {
   --    'Shatur/neovim-session-manager',
   --    config = function() 
   --       local Path = require('plenary.path')
   --       require('session_manager').setup({
   --          sessions_dir = Path:new(vim.fn.stdpath('data'), 'sessions'), -- The directory where the session files will be saved.
   --          path_replacer = '__', -- The character to which the path separator will be replaced for session files.
   --          colon_replacer = '++', -- The character to which the colon symbol will be replaced for session files.
   --          autoload_mode = require('session_manager.config').AutoloadMode.CurrentDir, -- Define what to do when Neovim is started without arguments. Possible values: Disabled, CurrentDir, LastSession
   --          autosave_last_session = false, -- Automatically save last session on exit and on session switch.
   --          autosave_ignore_not_normal = true, -- Plugin will not save a session when no buffers are opened, or all of them aren't writable or listed.
   --          autosave_ignore_filetypes = { -- All buffers of these file types will be closed before the session is saved.
   --             'gitcommit',
   --          },
   --          autosave_only_in_session = false, -- Always autosaves session. If true, only autosaves after a session is active.
   --          max_path_length = 80,  -- Shorten the display path if length exceeds this threshold. Use 0 if don't want to shorten the path at all.
   --       })
   --    end
   -- }

   use {
      'xbase-lab/xbase',
      run = 'make install', -- make free_space (not recommended, longer build time)
      requires = {
         "nvim-lua/plenary.nvim",
         "nvim-telescope/telescope.nvim",
         "neovim/nvim-lspconfig"
      },
      config = function()
         require'xbase'.setup({})  -- see default configuration bellow
      end
   }
   use 'nanotee/zoxide.vim'

   -- Database
   use { 'tpope/vim-dadbod' }
   use { 'kristijanhusak/vim-dadbod-ui' }

end)

