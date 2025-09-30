return {
  'rmagatti/auto-session',
  lazy = false,

  config = function()
    require('auto-session').setup {
      suppressed_dirs = { '~/', '~/Downloads', '/' },
    }
    vim.keymap.set('n', '<leader>ss', '<cmd>AutoSession save<CR>', { desc = '[S]ession [S]ave' })
    vim.keymap.set('n', '<leader>sr', '<cmd>AutoSession delete<CR>', { desc = '[S]ession [R]emove' })
    vim.o.sessionoptions = 'blank,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions'
  end,
}
