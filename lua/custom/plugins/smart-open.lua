return {
  'danielfalk/smart-open.nvim',
  branch = '0.2.x',
  config = function()
    require('telescope').load_extension 'smart_open'

    vim.keymap.set('n', '<leader>so', '<cmd>:Telescope smart_open<CR>', {
      silent = true,
      desc = '[S]mart [O]pen',
    })
  end,
  dependencies = {
    'kkharji/sqlite.lua',
    -- Only required if using match_algorithm fzf
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    -- Optional.  If installed, native fzy will be used when match_algorithm is fzy
    { 'nvim-telescope/telescope-fzy-native.nvim' },
  },
}
