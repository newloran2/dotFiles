local rt = require("rust-tools")
require('crates').setup()

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
  properties = {
    'documentation',
    'detail',
    'additionalTextEdits',
  }
}
-- capabilities = vim.tbl_extend('keep', capabilities or {}, lsp_status.capabilities)

capabilities.experimental = {}
capabilities.experimental.hoverActions = true

rt.setup({
	server = {
		on_attach = function(_ , bufnr)
			-- vim.keymap.set("n", "<leader>K", rt.hover_actions.hover_actions, { buffer = bufnr })
			-- lmap("K", ":FzfLua ls_code_actions<cr>")
			lsp_keybind_config()
			vim.keymap.set("n", "<leader>K", ":FzfLua lsp_code_actions<cr>", { buffer = bufnr })
			-- vim.keymap.set("n","K", vim.lsp.buf.hover, {buffer = 0})
			-- vim.keymap.set("n","gd", vim.lsp.buf.definition, {buffer = 0})
			-- vim.keymap.set("n","gt", vim.lsp.buf.type_definition, {buffer = 0})
			-- vim.keymap.set("n","<leader>r", vim.lsp.buf.rename, {buffer = 0})
			-- vim.keymap.set("n","<leader>dj", vim.diagnostic.goto_next, {buffer = 0})
			-- vim.keymap.set("n","<leader>dk", vim.diagnostic.goto_prev, {buffer = 0})
		end,
		capabilities = capabilities
	}
})
