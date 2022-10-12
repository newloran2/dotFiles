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

	-- use {'akinsho/flutter-tools.nvim', requires = 'nvim-lua/plenary.nvim'}
	use {
		'nvim-lualine/lualine.nvim',
		requires = { 'kyazdani42/nvim-web-devicons', opt = true }
	}

	use { 'ibhagwan/fzf-lua',
		requires = { 'kyazdani42/nvim-web-devicons' },
		config = require("plugins.fzf-lua")
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
end)


