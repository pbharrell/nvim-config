return {
  'nvim-treesitter/nvim-treesitter',
  branch = 'main',
  lazy = false,
  build = ':TSUpdate',
  config = function()
    require('nvim-treesitter').setup()
    require('nvim-treesitter.configs').setup {
      ensure_installed = { 'c', 'cpp', 'go', 'lua', 'python' },
      auto_install = true,
      highlight = { enable = true },
    }
  end,
}
