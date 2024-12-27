return {
  { -- Collection of various small independent plugins/modules
    'echasnovski/mini.nvim',
    config = function()
      -- Better Around/Inside textobjects
      --
      -- Examples:
      --  - va)  - [V]isually select [A]round [)]paren
      --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
      --  - ci'  - [C]hange [I]nside [']quote
      require('mini.ai').setup { n_lines = 500 }

      -- Simple and easy statusline.
      --  You could remove this setup call if you don't like it,
      --  and try some other statusline plugin
      -- local statusline = require 'mini.statusline'
      -- -- set use_icons to true if you have a Nerd Font
      -- statusline.setup { use_icons = vim.g.have_nerd_font }

      -- You can configure sections in the statusline by overriding their
      -- default behavior. For example, here we set the section for
      -- cursor location to LINE:COLUMN
      -- ---@diagnostic disable-next-line: duplicate-set-field
      -- statusline.section_location = function()
      --   return '%2l:%-2v'
      -- end

      -- ... and there is more!
      --  Check out: https://github.com/echasnovski/mini.nvim

      require('mini.starter').setup()
      require('mini.misc').setup()

      -- Ran into some issues with `MiniMisc.setup_auto_root()`, so implementing it here
      -- Disable conflicting option
      vim.o.autochdir = false
      local set_root = function()
        local root = MiniMisc.find_root(vim.api.get_current_buf)
        if root == nil then
          return
        end
        local new_cwd = root .. '/' .. vim.fn.input('Change working directory to - starting from ' .. root .. '/')
        vim.fn.chdir(new_cwd)
      end
      vim.keymap.set('n', '<leader>wr', set_root)
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
