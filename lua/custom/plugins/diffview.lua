return {
  {
    'sindrets/diffview.nvim', -- optional - Diff integration
    config = function()
      require('diffview').setup {}
      vim.keymap.set('n', '<leader>gd', ':DiffviewOpen', { desc = '[G]it [D]iffview' })
      vim.keymap.set('n', '<leader>go', '<cmd>DiffviewFileHistory<CR>', { desc = '[G]it L[O]g Diffview', silent = true })
      vim.keymap.set('n', '<leader>gh', '<cmd>DiffviewFileHistory %<CR>', { desc = '[G]it File [H]istory', silent = true })
    end,
  },
}
