local dap = require("dap")
local api = vim.api
local dlvPath = "/Users/erik/go/bin/dlv"



lmap('ds', ':DapContinue<cr>')
lmap('dut', '<cmd>DapUiToggle<cr>')
lmap('dv', '<cmd>lua require("dapui").eval()<cr>')
lmap('db', '<cmd>DapToggleBreakpoint<cr>')

-- dap.adapters.delve = {
--   type = 'server',
--   port = '${port}',
--   executable = {
--     command = dlvPath,
--     args = {'dap', '-l', '127.0.0.1:${port}', '--log', '--log-dest', '/tmp/dap.log'},
--   }
-- }
--
-- -- https://github.com/go-delve/delve/blob/master/Documentation/usage/dlv_dap.md
-- dap.configurations.go = {
--   {
--     type = "delve",
--     name = "Debug",
--     request = "launch",
--     program = "${file}"
--   },
--   {
--     type = "delve",
--     name = "Debug test", -- configuration for debugging test files
--     request = "launch",
--     mode = "test",
--     program = "${file}"
--   },
--   -- works with go.mod packages and sub packages 
--   {
--     type = "delve",
--     name = "Debug test (go.mod)",
--     request = "launch",
--     mode = "test",
--     program = "./${relativeFileDirname}"
--   } 
-- }
--
--
-- local keymap_restore = {}
-- dap.listeners.after['event_initialized']['me'] = function()
--   for _, buf in pairs(api.nvim_list_bufs()) do
--     local keymaps = api.nvim_buf_get_keymap(buf, 'n')
--     for _, keymap in pairs(keymaps) do
--       if keymap.lhs == "K" then
--         table.insert(keymap_restore, keymap)
--         api.nvim_buf_del_keymap(buf, 'n', 'K')
--       end
--     end
--   end
--   api.nvim_set_keymap(
--     'n', 'K', '<Cmd>lua require("dapui").eval()<CR>', { silent = true })
-- end
--
-- dap.listeners.after['event_terminated']['me'] = function()
--   for _, keymap in pairs(keymap_restore) do
--     api.nvim_buf_set_keymap(
--       keymap.buffer,
--       keymap.mode,
--       keymap.lhs,
--       keymap.rhs,
--       { silent = keymap.silent == 1 }
--     )
--   end
--   keymap_restore = {}
-- end
