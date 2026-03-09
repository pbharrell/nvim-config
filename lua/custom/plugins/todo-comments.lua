return {
  'folke/todo-comments.nvim',
  optional = true,
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
