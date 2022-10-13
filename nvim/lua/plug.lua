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
		cmd = "HopChar2",
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

	-- use {'akinsho/flutter-tools.nvim', requires = 'nvim-lua/plenary.nvim'}
	use {
		'nvim-lualine/lualine.nvim',
		requires = { 'kyazdani42/nvim-web-devicons', opt = true }
	}

	use { 'ibhagwan/fzf-lua',
		requires = { 'kyazdani42/nvim-web-devicons' },
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
				highlight = {enable = true}
			}
		end
	}
	use {'dracula/vim', as = 'dracula'}
	use {
	 'simrat39/symbols-outline.nvim',
      config = function()
			require("plugins.symbols-outline")
      end
	}
	use {
		'chipsenkbeil/distant.nvim',
		branch = 'PrepareForDistant16',
		config = function()
			require('distant').setup {
				-- Applies Chip's personal settings to every machine you connect to
				--
				-- 1. Ensures that distant servers terminate with no connections
				-- 2. Provides navigation bindings for remote directories
				-- 3. Provides keybinding to jump into a remote file's parent directory
				['*'] = require('distant.settings').chip_default()
			}
		end
	}
	-- use {
		-- 	 "nvim-neorg/neorg",
		-- 	 -- tag = "*",
		-- 	 -- ft = "norg",
		-- 	 -- after = "nvim-treesitter", -- You may want to specify Telescope here as well
		-- 	 requires = "nvim-lua/plenary.nvim",
		-- 	 run = ":Neorg sync-parsers",
		-- 	 config = function()
			-- 		  require('neorg').setup {
				-- 			  load = {
					-- 				  ["core.defaults"] = {}
					-- 			 }
					-- 		  }
					-- 	 end
					-- }	
				end)


