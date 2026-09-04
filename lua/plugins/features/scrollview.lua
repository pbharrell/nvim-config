return {
  'dstein64/nvim-scrollview',
  event = 'VeryLazy',
  config = function()
    require('scrollview').setup {
      signs_on_startup = { 'diagnostics', 'conflicts' },
    }
    vim.g.scrollview_winblend_gui = 70
    local utils = require 'heirline.utils'
    local hl = utils.get_highlight('DiagnosticError').fg
    local fg_hex = string.format('#%06x', hl)
    local hl_str = 'guibg=' .. fg_hex
    vim.cmd.highlight { 'ScrollView', hl_str }
  end,
}
