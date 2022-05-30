vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function()
	-- Packer can manage itself
	use 'wbthomason/packer.nvim'
	use { 'tpope/vim-fugitive' }                       -- git integration
	use { 'junegunn/gv.vim' }                          -- commit history

	use {"akinsho/toggleterm.nvim", tag = 'v1.*', config = function()
		require("toggleterm").setup()
	end}
	use { 
		'phaazon/hop.nvim',
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

	use {
		'nvim-telescope/telescope.nvim',
		requires = { {'nvim-lua/plenary.nvim'} }
	}
	use {
		'numToStr/Comment.nvim',
		config = function()
			require('Comment').setup()
		end
	}
	use { 'nvim-treesitter/nvim-treesitter'}
	-- You can alias plugin names
	use {'dracula/vim', as = 'dracula'}
end)


