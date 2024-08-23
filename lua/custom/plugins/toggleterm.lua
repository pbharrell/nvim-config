return {
  'akinsho/toggleterm.nvim',
  version = '*',
  config = function()
    require('toggleterm').setup()
    vim.keymap.set('n', 'th', ':ToggleTerm size=20 direction=horizontal<CR>', { desc = 'Toggle [H]orizontal terminal' })
    vim.keymap.set('n', 'tv', ':ToggleTerm size=60 direction=vertical<CR>', { desc = 'Toggle [V]ertical terminal' })
    vim.keymap.set('n', 'tf', ':ToggleTerm direction=float<CR>', { desc = 'Toggle [V]ertical terminal' })
  end,
}
