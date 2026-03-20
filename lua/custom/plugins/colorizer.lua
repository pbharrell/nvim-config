return {
  'norcalli/nvim-colorizer.lua',
  lazy = false,
  config = function()
    vim.keymap.set('n', '<leader>ct', '<cmd>ColorizerToggle<CR>', { desc = '[C]olorizer [T]oggle', silent = true })
  end,
}
