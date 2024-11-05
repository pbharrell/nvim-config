-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  {
    'max397574/better-escape.nvim',
    -- Using default mappings for this - https://github.com/max397574/better-escape.nvim
    config = true,
  },
  {
    'tamton-aquib/duck.nvim',
    config = function()
      vim.keymap.set('n', '<leader>dd', function()
        require('duck').hatch()
      end, { desc = '[D]uck hatch' })
      vim.keymap.set('n', '<leader>dc', function()
        require('duck').cook()
      end, { desc = 'Duck [C]ook' })
      vim.keymap.set('n', '<leader>da', function()
        require('duck').cook_all()
      end, { desc = 'Duck cook [A]ll' })
    end,
  },
}
