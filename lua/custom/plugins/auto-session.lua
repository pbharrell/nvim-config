return {
  'rmagatti/auto-session',
  lazy = false,

  config = function()
    require('auto-session').setup {
      suppressed_dirs = { '~/', '~/Downloads', '/' },
    }
    vim.keymap.set('n', '<leader>ss', '<cmd>SessionSearch<CR>', { desc = '[S]earch [S]essions Telescope' })
    vim.o.sessionoptions = 'blank,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions'
  end,
}
