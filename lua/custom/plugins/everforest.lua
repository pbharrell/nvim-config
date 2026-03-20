return { -- You can easily change to a different colorscheme.
  -- Change the name of the colorscheme plugin below, and then
  -- change the command in the config to whatever the name of that colorscheme is.
  --
  -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.

  -- ALTERNATIVES
  -- 'sainnhe/gruvbox-material',
  -- 'AlexvZyl/nordic.nvim',
  -- 'EdenEast/nightfox.nvim',
  -- END ALTERNATIVES

  'neanias/everforest-nvim',
  version = false,
  lazy = false,
  priority = 1000, -- make sure to load this before all the other start plugins
  -- Optional; default configuration will be used if setup isn't called.
  config = function()
    require('everforest').setup {
      background = 'soft',
    }
  end,
  init = function()
    vim.cmd.colorscheme 'everforest'
  end,
}
