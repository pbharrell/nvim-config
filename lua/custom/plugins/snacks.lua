return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
    bigfile = { enabled = true },
    dashboard = { enabled = true },
    explorer = { enabled = true },
    image = { enabled = true },
    indent = { enabled = true, animate = { style = 'out', duration = { total = 200 } } },
    input = { enabled = true },
    picker = {
      enabled = true,
      win = {
        input = {
          keys = {
            ['s'] = {
              mode = { 'n' },
              function()
                require('flash').jump()
              end,
            },
          },
        },
      },
    },
    notifier = { enabled = true },
    quickfile = { enabled = true },
    scope = { enabled = false },
    scroll = { enabled = false },
    statuscolumn = { enabled = true },
    words = { enabled = true },
    zen = { enabled = true },

    actions = {
      flash = function(picker)
        require('flash').jump {
          pattern = '^',
          label = { after = { 0, 0 } },
          search = {
            mode = 'search',
            exclude = {
              function(win)
                return vim.bo[vim.api.nvim_win_get_buf(win)].filetype ~= 'snacks_picker_list'
              end,
            },
          },
          action = function(match)
            local idx = picker.list:row2idx(match.pos[1])
            picker.list:_move(idx, true, true)
          end,
        }
      end,
    },

    styles = {
      notification_history = { width = 0.9, height = 0.9 },
      zen = { width = 0.8, keys = { q = 'close' } },
    },
  },

  keys = {
    {
      '<leader>w',
      mode = { 'n', 'x', 'o' },
      function()
        require('snacks').notifier.show_history()
      end,
      desc = 'Notification Hisotry',
    },
    {
      '<leader>z',
      mode = { 'n', 'x', 'o' },
      function()
        require('snacks').zen()
      end,
      desc = 'Open Buffer in Zen',
    },
    {
      '<leader>p',
      mode = { 'n', 'x', 'o' },
      function()
        require('snacks').explorer { auto_close = true, layout = { preset = 'default', preview = true }, matcher = { fuzzy = true } }
      end,
      desc = 'Explorer',
    },
    {
      '<leader>sf',
      mode = { 'n' },
      function()
        require('snacks').picker.smart()
      end,
      desc = '[S]earch [F]iles',
    },
    {
      '<leader>sg',
      mode = { 'n' },
      function()
        require('snacks').picker.grep()
      end,
      desc = '[S]earch by [G]rep',
    },
    {
      '<leader>sw',
      mode = { 'n' },
      function()
        require('snacks').picker.grep_word {
          search = function()
            return vim.fn.getreg()
          end,
        }
      end,
      desc = '[S]earch current [W]ord',
    },
    {
      '<leader>sh',
      mode = { 'n' },
      function()
        require('snacks').picker.command_history()
      end,
      desc = '[S]earch command [H]istory',
    },
    {
      '<leader>sk',
      mode = { 'n' },
      function()
        require('snacks').picker.keymaps()
      end,
      desc = '[S]earch [K]eymaps',
    },
    {
      '<leader>sn',
      mode = { 'n' },
      function()
        require('snacks').picker.files { cwd = vim.fn.stdpath 'config' }
      end,
      desc = '[S]earch [N]eovim files',
    },
    {
      '<leader>snc',
      mode = { 'n' },
      function()
        require('snacks').picker.commands()
      end,
      desc = '[S]earch [N]eovim [C]ommands',
    },
    {
      '<leader>sl',
      mode = { 'n' },
      function()
        require('snacks').picker.git_log()
      end,
      desc = '[S]earch Git [L]og',
    },
    {
      '<leader>sc',
      mode = { 'n' },
      function()
        require('snacks').picker.git_diff()
      end,
      desc = '[S]earch Git [C]hanges',
    },
    {
      '<leader>sd',
      mode = { 'n' },
      function()
        local cwd = vim.fn.getcwd()

        -- Build directory list: cwd itself plus all subdirectories via fd (fallback: find)
        local items = { { text = '.', _abs = cwd } }
        local raw = vim.fn.systemlist('fd --type d --hidden --exclude .git . ' .. vim.fn.shellescape(cwd))
        if vim.v.shell_error ~= 0 then
          raw = vim.fn.systemlist('find ' .. vim.fn.shellescape(cwd) .. ' -mindepth 1 -type d -not -path "*/.git/*"')
        end
        for _, dir in ipairs(raw) do
          -- Strip cwd prefix so paths are relative to neovim's cwd
          local rel = vim.fn.fnamemodify(dir, ':.')
          table.insert(items, { text = rel, _abs = dir })
        end

        Snacks.picker.pick {
          title = 'Pick Directory to Grep',
          items = items,
          format = 'text',
          confirm = function(picker, item)
            picker:close()
            if item then
              -- Keep cwd as neovim's cwd so grep results show paths relative to it,
              -- but restrict the search to the chosen subdirectory via dirs.
              Snacks.picker.grep { cwd = cwd, dirs = { item._abs } }
            end
          end,
        }
      end,
      desc = '[S]earch [D]irectory',
    },
    {
      '<leader><leader>',
      mode = { 'n' },
      function()
        require('snacks').picker.resume()
      end,
      desc = 'Resume previous picker',
    },
    {
      '<leader>/',
      mode = { 'n' },
      function()
        require('snacks').picker.lines()
      end,
      desc = 'Current buffer fuzzy',
    },

    -- LSP integration
    {
      'gd',
      function()
        Snacks.picker.lsp_definitions()
      end,
      desc = 'Goto Definition',
    },
    {
      'gD',
      function()
        Snacks.picker.lsp_declarations()
      end,
      desc = 'Goto Declaration',
    },
    {
      'gr',
      function()
        Snacks.picker.lsp_references()
      end,
      nowait = true,
      desc = 'References',
    },
    {
      'gI',
      function()
        Snacks.picker.lsp_implementations()
      end,
      desc = 'Goto Implementation',
    },
    {
      'gy',
      function()
        Snacks.picker.lsp_type_definitions()
      end,
      desc = 'Goto T[y]pe Definition',
    },
    {
      'gai',
      function()
        Snacks.picker.lsp_incoming_calls()
      end,
      desc = 'C[a]lls Incoming',
    },
    {
      'gao',
      function()
        Snacks.picker.lsp_outgoing_calls()
      end,
      desc = 'C[a]lls Outgoing',
    },
  },
}
