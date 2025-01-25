lmap('bd', 'bdelete')
map('n', 's', ':HopChar2<cr>', {})

map('i', 'jk', '<Esc>', {})
map('i', '<C-s>', '<Esc> :w<cr>i', {}) 
map('n', '<C-s>', '<Esc> :w<cr>', {}) 

map('n', ',', '`', {})
--mapeamentos de terminal 
map('t', '<Esc>', '<c-\\><c-n>', {})
