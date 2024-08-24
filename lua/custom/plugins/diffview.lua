return {
  {
    'sindrets/diffview.nvim', -- optional - Diff integration
    config = function()
      require('diffview').setup {}
      vim.keymap.set('n', '<leader>gd', '<cmd>DiffviewOpen<CR>', { desc = '[D]iffview open' })
      vim.keymap.set('n', '<leader>gh', '<cmd>DiffviewFileHistory<CR>', { desc = 'File [H]istory' })
    end,
  },
}
