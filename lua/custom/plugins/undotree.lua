return {
  'mbbill/undotree',
  config = function()
    vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle, { desc = 'Open [U]ndotree' })
    vim.g.undotree_WindowLayout = 1
    vim.undotree_ShortIndicators = true
    vim.g.undotree_SetFocusWhenToggle = true
  end,
}
