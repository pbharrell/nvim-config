return {
  'otavioschwanck/arrow.nvim',
  dependencies = 'nvim-tree/nvim-web-devicons',
  -- opts = {
  --   show_icons = true,
  --   leader_key = '<leader>e', -- Recommended to be a single key
  --   buffer_leader_key = '<leader>eb', -- Per Buffer Mappings
  -- },
  config = function()
    local arrow = require 'arrow'
    arrow.setup {
      show_icons = true,
      leader_key = '<leader>e', -- Recommended to be a single key
      buffer_leader_key = '<leader>be', -- Per Buffer Mappings
    }
    local arrow_persist = require 'arrow.persist'
    vim.keymap.set({ 'n', 'i' }, '<C-h>', function()
      arrow_persist.go_to(1)
    end)
    vim.keymap.set({ 'n', 'i' }, '<C-j>', function()
      arrow_persist.go_to(2)
    end)
    vim.keymap.set({ 'n', 'i' }, '<C-k>', function()
      arrow_persist.go_to(3)
    end)
    vim.keymap.set({ 'n', 'i' }, '<C-l>', function()
      arrow_persist.go_to(4)
    end)
  end,
}
