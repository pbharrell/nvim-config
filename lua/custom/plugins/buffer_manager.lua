return {
  'j-morano/buffer_manager.nvim',
  config = function()
    local buffer_manager_ui = require 'buffer_manager.ui'

    vim.keymap.set('n', '<leader>bo', function()
      buffer_manager_ui.toggle_quick_menu()
    end, { desc = '[O]pen [B]uffer list' })

    vim.keymap.set('n', '<leader>bn', function()
      buffer_manager_ui.nav_next()
    end, { desc = '[B]uffer [N]ext' })

    vim.keymap.set('n', '<leader>bp', function()
      buffer_manager_ui.nav_prev()
    end, { desc = '[B]uffer [P]ext' })
  end,
}
