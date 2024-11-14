return {
  'akinsho/toggleterm.nvim',
  version = '*',
  config = function()
    require('toggleterm').setup {
      open_mapping = [[<c-\>]],
      start_in_insert = true,
      direction = 'float',
    }
    vim.keymap.set('n', 'th', ':ToggleTerm size=20 direction=horizontal<CR>', { desc = 'Toggle [H]orizontal terminal' })
    vim.keymap.set('n', 'tv', ':ToggleTerm size=60 direction=vertical<CR>', { desc = 'Toggle [V]ertical terminal' })
    vim.keymap.set('n', 'tf', ':ToggleTerm direction=float<CR>', { desc = 'Toggle [V]ertical terminal' })

    -- make inter-terminal navigation easier without leaving terminal mode
    vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]])
    vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]])
    vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]])
    vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]])

    -- pass through <Esc> to toggleterm when that is open
    vim.keymap.set('t', '<Esc>', function()
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'n', true)
    end, { noremap = true, silent = true })
  end,
}
