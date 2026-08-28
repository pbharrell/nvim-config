return {
  'ravsii/tree-sitter-d2',
  dependencies = { 'nvim-treesitter/nvim-treesitter' },
  lazy = false,
  version = '*', -- use the latest git tag instead of main
  build = 'make nvim-install',
  config = function()
    local d2_module = vim.api.nvim_get_runtime_file('lua/tree-sitter-d2/init.lua', false)[1]
    local d2_dir = vim.fn.fnamemodify(d2_module, ':p:h:h:h')
    local parsers = require('nvim-treesitter.parsers')

    -- Register D2 before asking nvim-treesitter to install it.
    parsers.d2 = { install_info = { path = d2_dir } }

    if #vim.api.nvim_get_runtime_file('parser/d2.so', false) == 0 then
      vim.schedule(function()
        vim.cmd('TSInstall d2')
      end)
    end
  end,
}
