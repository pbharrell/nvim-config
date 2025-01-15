-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
  },
  cmd = 'Neotree',
  keys = {
    { '<leader>tt', ':Neotree toggle<CR>', desc = 'Neotree [T]oggle', silent = true },
    { '<leader>tg', ':Neotree git_status toggle<CR>', desc = 'Git status [v]iew', silent = true },
    { '<leader>p', ':Neotree toggle position=current reveal<CR>', desc = 'Neotree [E]xplore', silent = true },
  },
  opts = {
    filesystem = {
      window = {
        mappings = {
          ['P'] = { 'toggle_preview', config = { use_float = false, use_image_nvim = true } },
          ['v'] = 'open_vsplit',
          ['s'] = 'none',
          ['/'] = 'none',
          ['<C-f>'] = 'fuzzy_finder',
          ['Y'] = 'copy_to_clipboard',
          ['y'] = 'copy_filename_to_clipboard',
        },
      },
      commands = {
        copy_filename_to_clipboard = function(state)
          local name = state.tree:get_node().name
          vim.fn.setreg(vim.v.register, name, '')
        end,
      },
      follow_current_file = {
        enabled = true, -- This will find and focus the file in the active buffer every time
        --               -- the current file is changed while the tree is open.
        leave_dirs_open = true, -- `false` closes auto expanded dirs, such as with `:Neotree reveal`
      },
    },
  },
  hijack_netrw_behavior = 'open_default', -- This ensures Neo-tree opens in place of netrw
  use_libuv_file_watcher = true, -- Optional: Automatically updates Neo-tree when files change
}
