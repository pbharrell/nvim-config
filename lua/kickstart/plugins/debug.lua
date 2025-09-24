-- debug.lua
--
-- Shows how to use the DAP plugin to debug your code.
--
-- Primarily focused on configuring the debugger for Go, but can
-- be extended to other languages as well. That's why it's called
-- kickstart.nvim and not kitchen-sink.nvim ;)

return {
  -- NOTE: Yes, you can install new plugins here!
  'mfussenegger/nvim-dap',
  -- NOTE: And you can specify dependencies as well
  dependencies = {
    -- Creates a beautiful debugger UI
    'igorlfs/nvim-dap-view',

    -- Required dependency for nvim-dap-ui
    'nvim-neotest/nvim-nio',

    -- Required dependency for neotest (redundant but ensures proper order)
    'nvim-treesitter/nvim-treesitter',

    -- Dependency for Neotest
    'antoinemadec/FixCursorHold.nvim',

    -- Gtest adapter for neotest
    'alfaix/neotest-gtest',

    -- Neotest
    'nvim-neotest/neotest',

    -- Installs the debug adapters for you
    'williamboman/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',

    -- Add your own debuggers here
    'leoluz/nvim-dap-go',
  },
  keys = function(_, keys)
    local dap = require 'dap'
    return {
      -- Basic debugging keymaps, feel free to change to your liking!
      { '<F5>', dap.continue, desc = 'Debug: Start/Continue' },
      { '<F1>', dap.step_into, desc = 'Debug: Step Into' },
      { '<F2>', dap.step_over, desc = 'Debug: Step Over' },
      { '<F3>', dap.step_out, desc = 'Debug: Step Out' },
      { '<leader>b', dap.toggle_breakpoint, desc = 'Debug: Toggle Breakpoint' },
      {
        '<leader>B',
        function()
          dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
        end,
        desc = 'Debug: Set Breakpoint',
      },
      -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
      { '<F7>', require('dap-view').toggle, desc = 'Debug: See last session result.' },
      unpack(keys),
    }
  end,
  config = function()
    local dap = require 'dap'
    local neotest = require 'neotest'

    require('mason-nvim-dap').setup {
      -- Makes a best effort to setup the various debuggers with
      -- reasonable debug configurations
      automatic_installation = true,

      -- You can provide additional configuration to the handlers,
      -- see mason-nvim-dap README for more information
      handlers = {},

      -- You'll need to check that you have the required things installed
      -- online, please don't ask me how to install them :)
      ensure_installed = {
        -- Update this to ensure that you have the debuggers for the langs you want
        'delve',
      },
    }

    require('dap-view').setup {}

    -- Install golang specific config (Kickstart.nvim default)
    require('dap-go').setup {
      delve = {
        -- On Windows delve must be run attached or it crashes.
        -- See https://github.com/leoluz/nvim-dap-go/blob/main/README.md#configuring
        detached = vim.fn.has 'win32' == 0,
      },
    }

    neotest.setup {
      adapters = {
        require('neotest-gtest').setup {
          debug_adapter = 'cppdbg',
          dap = { justMyCode = false },
          is_test_file = function(file)
            return string.find(file, '_test.cpp') or string.find(file, '_tests.cpp') or string.find(file, 'Test.cpp') or string.find(file, 'Tests.cpp')
          end,
        },
      },
    }

    vim.keymap.set('n', '<leader>r', neotest.summary.toggle, { desc = 'Toggle test summary panel' })
    vim.keymap.set('n', '<leader>rc', '<cmd>ConfigureGtest<CR>', { desc = 'Configure tests' })
    vim.keymap.set('n', '<leader>ro', neotest.output_panel.toggle, { desc = 'Toggle test output panel' })
    vim.keymap.set('n', '<leader>rr', neotest.run.run, { desc = 'Run current test' })
    vim.keymap.set('n', '<leader>rf', function()
      neotest.run.run(vim.fn.expand '%')
    end, { desc = 'Run current test file' })
    vim.keymap.set('n', '<leader>rd', function()
      neotest.run.run { strategy = 'dap' }
    end, { desc = 'Debug current test' })
    vim.keymap.set('n', '<leader>rs', neotest.run.stop, { desc = 'Stop running tests' })

    -- C/C++ debugger setup
    -- Source: https://github.com/mfussenegger/nvim-dap/wiki/C-C---Rust-(gdb-via--vscode-cpptools)
    -- I have found poor debug speed when using this one in WSL, using gdb instead
    -- https://alighorab.github.io/neovim/nvim-dap/ <-- this explains the process for installing OpenDebugAD7
    dap.adapters.cppdbg = {
      id = 'cppdbg',
      type = 'executable',
      command = '/home/harrellpresto/cpptools/extension/debugAdapters/bin/OpenDebugAD7',
    }
    dap.adapters.gdb = {
      type = 'executable',
      command = 'gdb',
      args = { '--interpreter=dap', '--eval-command', 'set print pretty on' },
    }
    dap.configurations.cpp = {
      {
        name = 'Launch file',
        type = 'gdb',
        request = 'launch',
        program = function()
          return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
        cwd = '${workspaceFolder}',
        -- stopAtEntry = true,
        stopAtBeginningOfMainSubprogram = false,
        args = {},
      },
    }
    dap.configurations.c = dap.configurations.cpp
  end,
}
