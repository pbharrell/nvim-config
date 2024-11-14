return {
  'rmagatti/auto-session',
  lazy = false,

  config = function()
    require('auto-session').setup {
      suppressed_dirs = { '~/', '~/Downloads', '/' },
    }
    vim.o.sessionoptions = 'blank,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions'
  end,
}
