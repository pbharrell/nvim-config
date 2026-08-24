return {
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
  config = function()
    local treesitter = require 'nvim-treesitter'

    treesitter.setup()
    treesitter.install { 'c', 'cpp', 'go', 'lua', 'python' }

    vim.api.nvim_create_autocmd('FileType', {
      pattern = { 'c', 'cpp', 'go', 'lua', 'python' },
      callback = function()
        vim.treesitter.start()
      end,
    })
  end,
}
