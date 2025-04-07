-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Keybinds to make split navigation easier.
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<leader>h', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<leader>l', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<leader>j', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<leader>k', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- vim: ts=2 sts=2 sw=2 et

-- ** Start custom keymaps **
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv", { desc = 'Shift line down', silent = true })
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv", { desc = 'Shift line up', silent = true })

vim.keymap.set('n', 'n', 'nzzzv')
vim.keymap.set('n', 'N', 'Nzzzv')

vim.keymap.set('n', 'Q', '@@', { desc = 'Repeat last macro' })

vim.keymap.set('n', '<leader>tc', '<cmd>tabclose<CR>', { desc = '[T]ab [C]lose' })
vim.keymap.set('n', '<leader>tn', '<cmd>tabnew<CR>', { desc = '[T]ab [N]ew' })

-- keep values of registers unchanged with x and X
vim.keymap.set({ 'n', 'x' }, 'x', '"_x')
vim.keymap.set({ 'n', 'x' }, 'X', '"_dd')

-- keep values of registers unchanged with c
vim.keymap.set({ 'n', 'x' }, 'c', '"_c')

vim.keymap.set('x', 'p', function()
  return 'pgv"' .. vim.v.register .. 'y'
end, { remap = false, expr = true })

vim.keymap.set({ 'n', 'x' }, '<leader>v', '<C-w>v')

vim.keymap.set('n', '<leader>og', function()
  local command = {
    'open-in-gitiles ',
    vim.api.nvim_buf_get_name(0),
    '#',
    vim.fn.line '.',
  }
  os.execute(table.concat(command))
end, { desc = '[O]pen in [G]itiltes' })

vim.keymap.set({ 'n', 'v', 'x' }, '<leader>2', '$')

-- Need to put smart-open keymap here since it lazy loads
vim.keymap.set('n', '<leader>so', '<cmd>:Telescope smart_open<CR>', {
  silent = true,
  desc = '[S]mart [O]pen',
})

vim.keymap.set('n', 'gn', 'gt', { desc = '[G]o to [N]ext tab' })
vim.keymap.set('n', 'gp', 'gT', { desc = '[G]o to [P]rev tab' })
