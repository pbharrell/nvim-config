return {
  'akinsho/bufferline.nvim',
  version = '4.7.0',
  dependencies = 'nvim-tree/nvim-web-devicons',
  config = function()
    local bufferline = require 'bufferline'
    bufferline.setup()
  end,
}
