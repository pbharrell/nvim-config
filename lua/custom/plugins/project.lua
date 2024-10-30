return {
  'ahmedkhalf/project.nvim',
  config = function()
    require('project_nvim').setup {}
    require('telescope').load_extension 'projects'

    vim.keymap.set('n', '<leader>sp', '<cmd>:Telescope projects<CR>', {
      silent = true,
      desc = '[S]earch [P]rojects',
    })
  end,
}
