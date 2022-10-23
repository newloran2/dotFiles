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
   tools = {
      executor = {
         execute_command = function (command, args, cwd) 
            local utils = require("rust-tools.utils.utils")
            local ok, term = pcall(require, "toggleterm.terminal")
            if not ok then
               vim.schedule(function()
                  vim.notify("toggleterm not found.", vim.log.levels.ERROR)
               end)
               return
            end

            term.Terminal
               :new({
                  dir = cwd,
                  cmd = utils.make_command_from_args(command, args),
                  close_on_exit = false,
                  on_open = function(t)
                     -- enter normal mode
                     vim.api.nvim_feedkeys(
                        vim.api.nvim_replace_termcodes([[<C-\><C-n>]], true, true, true),
                        "",
                        true
                     )

                     -- set close keymap
                     vim.api.nvim_buf_set_keymap(
                        t.bufnr,
                        "n",
                        "q",
                        "<cmd>close<CR>",
                        { noremap = true, silent = true }
                     )
                  end,
               })
               :toggle()
         end
      },
   },
   server = {
      on_attach = function(_, bufnr) 
         lsp_keybind_config()
         vim.keymap.set("n", "<leader>K", ":FzfLua lsp_code_actions<cr>", { buffer = bufnr })
         vim.keymap.set("n", "<leader>cr", '<cmd>lua require("rust-tools").runnables.runnables()<cr>', {buffer = bufnr})
      end
   }
})
