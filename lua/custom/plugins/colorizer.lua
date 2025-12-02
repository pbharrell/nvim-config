return {
  'norcalli/nvim-colorizer.lua',
  lazy = false,
  config = function()
    require('auto-session').setup()

    vim.keymap.set('n', '<leader>ct', '<cmd>ColorizerToggle<CR>', { desc = '[C]olorizer [T]oggle', silent = true })
  end,
}
