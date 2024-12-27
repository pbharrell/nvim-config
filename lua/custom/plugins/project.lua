return {
  'ahmedkhalf/project.nvim',
  event = 'VeryLazy',
  config = function()
    require('project_nvim').setup { manual_mode = true }
    require('telescope').load_extension 'projects'

    vim.keymap.set('n', '<leader>sp', '<cmd>:Telescope projects<CR>', {
      silent = true,
      desc = '[S]earch [P]rojects',
    })
  end,
}
