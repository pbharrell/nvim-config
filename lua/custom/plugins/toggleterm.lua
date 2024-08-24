return {
  'akinsho/toggleterm.nvim',
  version = '*',
  config = function()
    require('toggleterm').setup()
    vim.keymap.set('n', 'th', ':ToggleTerm size=20 direction=horizontal<CR>', { desc = 'Toggle [H]orizontal terminal' })
    vim.keymap.set('n', 'tv', ':ToggleTerm size=60 direction=vertical<CR>', { desc = 'Toggle [V]ertical terminal' })
    vim.keymap.set('n', 'tf', ':ToggleTerm direction=float<CR>', { desc = 'Toggle [V]ertical terminal' })
    -- pass through <Esc> to lazygit when that is open

    vim.keymap.set('t', '<Esc>', function()
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'n', true)
    end, { noremap = true, silent = true })
  end,
}
