local lsp = require 'lspconfig'
require("nvim-lsp-installer").setup({
	automatic_installation = true, -- automatically detect which servers to install (based on which servers are set up via lspconfig)
	ui = {
		icons = {
			server_installed = "✓",
			server_pending = "➜",
			server_uninstalled = "✗"
		}
	}
})

function lsp_keybind_config()
	vim.keymap.set("n","K", vim.lsp.buf.hover, {buffer = 0})
	vim.keymap.set("n","gd", vim.lsp.buf.definition, {buffer = 0})
	vim.keymap.set("n","gt", vim.lsp.buf.type_definition, {buffer = 0})
	vim.keymap.set("n","<leader>r", vim.lsp.buf.rename, {buffer = 0})
	vim.keymap.set("n","<leader>dj", vim.diagnostic.goto_next, {buffer = 0})
	vim.keymap.set("n","<leader>dk", vim.diagnostic.goto_prev, {buffer = 0})
	vim.keymap.set("n","<leader>w", peek_definition,{buffer = 0})
end
local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
local servers = { 'gopls', 'jsonls','kotlin_language_server','rust_analyzer', 'sourcekit'}
for _, i in pairs(servers) do
	--gebnerar server configurations
	lsp[i].setup{
		capabilities = capabilities,
		on_attach = lsp_keybind_config,
	}
end
vim.opt.completeopt={"menu", "menuone", "noselect"} 

-- Setup nvim-cmp.
local cmp = require'cmp'

cmp.setup({
	snippet = {
		expand = function(args)
			--		vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
			require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
		end,
	},
	window = {
		completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered(),
	},
	mapping = cmp.mapping.preset.insert({
		['<C-b>'] = cmp.mapping.scroll_docs(-4),
		['<C-f>'] = cmp.mapping.scroll_docs(4),
		['<C-Space>'] = cmp.mapping.complete(),
		['<C-e>'] = cmp.mapping.abort(),
		['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
	}),
	sources = cmp.config.sources({
		{ name = 'nvim_lsp' },
		{ name = 'nvim_lua' },
		{ name = 'luasnip' }, -- For luasnip users.
	}, {
		{ name = 'buffer' },
	})
})

-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
	sources = cmp.config.sources({
		{ name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
	}, {
		{ name = 'buffer' },
	})
})

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline('/', {
	mapping = cmp.mapping.preset.cmdline(),
	sources = {
		{ name = 'buffer' }
	}
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({
		{ name = 'path' }
	}, {
		{ name = 'cmdline' }
	})
})





local function preview_location_callback(_, method, result)
  if result == nil or vim.tbl_isempty(result) then
    vim.lsp.log.info(method, 'No location found')
    return nil
  end
  if vim.tbl_islist(result) then
    vim.lsp.util.preview_location(result[1])
  else
    vim.lsp.util.preview_location(result)
  end
end

function peek_definition()
  local params = vim.lsp.util.make_position_params()
  return vim.lsp.buf_request(0, 'textDocument/definition', params, preview_location_callback)
end
