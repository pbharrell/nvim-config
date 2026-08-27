return {
  'pbharrell/neogen',
  config = function()
    require('neogen').setup { snippet_engine = 'luasnip' }
    vim.keymap.set('n', '<leader>d', function()
      require('neogen').generate()
    end)
  end,
}
