return {
  'folke/todo-comments.nvim',
  lazy = false,
  dependencies = { 'nvim-lua/plenary.nvim' },
  opts = { signs = false },
  keys = {
    {
      '<leader>st',
      function()
        Snacks.picker.todo_comments { keywords = { 'todo', 'TODO', 'fixme', 'FIXME' } }
      end,
      desc = 'Todo/Fix/Fixme',
    },
  },
}
