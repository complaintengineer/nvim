-- Tabs 
vim.keymap.set('n', '<C-.>', '<Cmd>bn<CR>', {silent = true})
vim.keymap.set('n', '<C-,>', '<Cmd>bp<CR>', {silent = true})
vim.keymap.set('n', '<C-n>', '<Cmd>NvimTreeToggle<CR>', {silent = true})
vim.keymap.set('n', '<C-T>', '<Cmd>BufferRestore<CR>', {silent = true})
vim.keymap.set('n', '<C-w>', '<Cmd>BufferClose<CR>', {silent = false})
vim.keymap.set('n', '<C-S-w>', '<Cmd>quit!<CR>', {silent = false})

-- Telescope
vim.keymap.set('n', '<C-f>', '<Cmd>Telescope fd<CR>', {silent = false})
vim.keymap.set('n', '<C-S-t>', '<Cmd>Telescope buffers<CR>', {silent = false})
vim.keymap.set('n', '<C-g>', '<Cmd>Telescope git_bcommits<CR>', {silent = false})
vim.keymap.set('n', '<C-S-g>', '<Cmd>Telescope git_branches<CR>', {silent = false})


