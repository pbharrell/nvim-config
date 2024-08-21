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
    { '<leader>t', ':Neotree toggle<CR>', desc = 'Neotree toggle' },
    { '<leader>tb', ':Neotree buffers toggle<CR>', desc = 'Neotree open buffers toggle' },
    {
      '<leader>tr',
      ':Neotree dir=',
      -- function()
      --   vim.ui.input({ prompt = 'Enter new Neotree root directory: ' }, function(input)
      --     if input then
      --       -- Run the Neotree command with the specified directory
      --       vim.cmd('Neotree dir=' .. input)
      --     end
      --   end)
      -- end,
      desc = 'Neotree change root directory',
    },

    { '<leader>gv', ':Neotree float git_status toggle<CR>', desc = 'Git status [v]iew' },
  },
  opts = {
    filesystem = {
      window = {
        mappings = {
          ['P'] = { 'toggle_preview', config = { use_float = false, use_image_nvim = true } },
        },
      },
      follow_current_file = {
        enabled = true, -- This will find and focus the file in the active buffer every time
        --               -- the current file is changed while the tree is open.
        leave_dirs_open = false, -- `false` closes auto expanded dirs, such as with `:Neotree reveal`
        hijack_netrw_behavior = 'open_default', -- This ensures Neo-tree opens in place of netrw
        use_libuv_file_watcher = true, -- Optional: Automatically updates Neo-tree when files change
      },
    },
  },
}
