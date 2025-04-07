return {
  'rebelot/heirline.nvim',
  config = function()
    local left_slant = ''
    local right_slant = ''
    local conditions = require 'heirline.conditions'
    local utils = require 'heirline.utils'
    local colors = {
      normal_bg = utils.get_highlight('Normal').bg,
      bright_bg = utils.get_highlight('Folded').bg,
      bright_fg = utils.get_highlight('Folded').fg,
      red = utils.get_highlight('DiagnosticError').fg,
      dark_red = utils.get_highlight('DiffDelete').bg,
      light_green = utils.get_highlight('String').fg,
      light_blue = utils.get_highlight('blue').fg,
      gray = utils.get_highlight('NonText').fg,
      turquoise = utils.get_highlight('Constant').fg,
      yellow = utils.get_highlight('Special').fg,
      diag_warn = utils.get_highlight('DiagnosticWarn').fg,
      diag_error = utils.get_highlight('DiagnosticError').fg,
      diag_hint = utils.get_highlight('DiagnosticHint').fg,
      diag_info = utils.get_highlight('DiagnosticInfo').fg,
      git_del = utils.get_highlight('diffDeleted').fg,
      git_add = utils.get_highlight('diffAdded').fg,
      git_change = utils.get_highlight('diffChanged').fg,
    }
    require('heirline').load_colors(colors)

    local ViMode = {
      -- get vim current mode, this information will be required by the provider
      -- and the highlight functions, so we compute it only once per component
      -- evaluation and store it as a component attribute
      init = function(self)
        self.mode = vim.fn.mode(1) -- :h mode()
      end,
      -- Now we define some dictionaries to map the output of mode() to the
      -- corresponding string and color. We can put these into `static` to compute
      -- them at initialisation time.
      static = {
        mode_names = { -- change the strings if you like it vvvvverbose!
          n = 'N',
          no = 'N?',
          nov = 'N?',
          noV = 'N?',
          ['no\22'] = 'N?',
          niI = 'Ni',
          niR = 'Nr',
          niV = 'Nv',
          nt = 'Nt',
          v = 'V',
          vs = 'Vs',
          V = 'V_',
          Vs = 'Vs',
          ['\22'] = '^V',
          ['\22s'] = '^V',
          s = 'S',
          S = 'S_',
          ['\19'] = '^S',
          i = 'I',
          ic = 'Ic',
          ix = 'Ix',
          R = 'R',
          Rc = 'Rc',
          Rx = 'Rx',
          Rv = 'Rv',
          Rvc = 'Rv',
          Rvx = 'Rv',
          c = 'C',
          cv = 'Ex',
          r = '...',
          rm = 'M',
          ['r?'] = '?',
          ['!'] = '!',
          t = 'T',
        },
        mode_colors = {
          n = 'red',
          i = 'light_green',
          v = 'yellow',
          V = 'yellow',
          ['\22'] = 'yellow',
          c = 'turquoise',
          s = 'red',
          S = 'red',
          ['\19'] = 'red',
          R = 'turquoise',
          r = 'turquoise',
          ['!'] = 'red',
          t = 'red',
        },
      },
      -- We can now access the value of mode() that, by now, would have been
      -- computed by `init()` and use it to index our strings dictionary.
      -- note how `static` fields become just regular attributes once the
      -- component is instantiated.
      -- To be extra meticulous, we can also add some vim statusline syntax to
      -- control the padding and make sure our string is always at least 2
      -- characters long. Plus a nice Icon.
      provider = function(self)
        return '%2( 󰅬 ' .. self.mode_names[self.mode] .. '%)'
      end,
      -- Same goes for the highlight. Now the foreground will change according to the current mode.
      hl = function(self)
        local mode = self.mode:sub(1, 1) -- get only the first mode character
        return { bg = self.mode_colors[mode], fg = 'black', bold = true }
      end,
      -- Re-evaluate the component only on ModeChanged event!
      -- Also allows the statusline to be re-evaluated when entering operator-pending mode
      update = {
        'ModeChanged',
        pattern = '*:*',
        callback = vim.schedule_wrap(function()
          vim.cmd 'redrawstatus'
        end),
      },
      {
        provider = '█' .. right_slant,
        hl = function(self)
          local mode = self.mode:sub(1, 1) -- get only the first mode character
          return { fg = self.mode_colors[mode], bg = colors.bright_bg, bold = true }
        end,
      },
    }

    local FileNameBlock = {
      -- let's first set up some attributes needed by this component and its children
      init = function(self)
        self.filename = vim.api.nvim_buf_get_name(0)
      end,
    }
    -- We can now define some children separately and add them later

    local FileIcon = {
      init = function(self)
        local filename = self.filename
        local extension = vim.fn.fnamemodify(filename, ':e')
        self.icon, self.icon_color = require('nvim-web-devicons').get_icon_color(filename, extension, { default = true })
      end,
      provider = function(self)
        return self.icon and (self.icon .. ' ')
      end,
      hl = function(self)
        return { bg = colors.bright_bg, fg = self.icon_color }
      end,
    }

    local FileName = {
      init = function(self)
        self.lfilename = vim.fn.fnamemodify(self.filename, ':.')
        if self.lfilename == '' then
          self.lfilename = '[No Name]'
        end
      end,
      hl = { bg = colors.bright_bg, fg = utils.get_highlight('Directory').fg },

      flexible = 2,

      {
        provider = function(self)
          return self.lfilename
        end,
      },
      {
        provider = function(self)
          return vim.fn.pathshorten(self.lfilename)
        end,
      },
    }

    local FileFlags = {
      {
        condition = function()
          return vim.bo.modified
        end,
        provider = '[+]',
        hl = { bg = colors.bright_bg, fg = 'light_green' },
      },
      {
        condition = function()
          return not vim.bo.modifiable or vim.bo.readonly
        end,
        provider = ' ',
        hl = { bg = colors.bright_bg, fg = 'turquoise' },
      },
    }

    -- Now, let's say that we want the filename color to change if the buffer is
    -- modified. Of course, we could do that directly using the FileName.hl field,
    -- but we'll see how easy it is to alter existing components using a "modifier"
    -- component

    local FileNameModifer = {
      hl = function()
        if vim.bo.modified then
          -- use `force` because we need to override the child's hl foreground
          return { bg = colors.bright_bg, fg = 'yellow', bold = true, force = true }
        end
      end,
    }

    -- let's add the children to our FileNameBlock component
    FileNameBlock = utils.insert(
      FileNameBlock,
      FileIcon,
      utils.insert(FileNameModifer, FileName), -- a new table where FileName is a child of FileNameModifier
      FileFlags,
      { provider = '%<', hl = { bg = colors.bright_bg } } -- this means that the statusline is cut here when there's not enough space
    )

    local FileType = {
      provider = function()
        return string.upper(vim.bo.filetype)
      end,
      hl = { bg = colors.bright_bg, bold = true },
    }

    -- We're getting minimalist here!
    local Ruler = {
      -- %l = current line number
      -- %L = number of lines in the buffer
      -- %c = column number
      -- %P = percentage through file of displayed window
      provider = '%7(%l/%3L%):%2c',
      hl = { bg = colors.bright_bg, fg = utils.get_highlight('Type').fg, bold = true },
    }

    local Search = {
      condition = require('noice').api.status.search.has,
      provider = require('noice').api.status.search.get,
      hl = { bg = colors.bright_bg, fg = colors.red },
    }

    local Git = {
      condition = conditions.is_git_repo,

      init = function(self)
        self.status_dict = vim.b.gitsigns_status_dict
        self.has_changes = self.status_dict.added ~= 0 or self.status_dict.removed ~= 0 or self.status_dict.changed ~= 0
      end,

      hl = { bg = colors.bright_bg, fg = 'light_green' },

      { -- git branch name
        provider = function(self)
          return ' ' .. self.status_dict.head
        end,
        hl = { fg = colors.yellow, bold = true },
      },
      -- You could handle delimiters, icons and counts similar to Diagnostics
      {
        provider = function(self)
          local count = self.status_dict.added or 0
          return count > 0 and (' +' .. count)
        end,
      },
      {
        provider = function(self)
          local count = self.status_dict.changed or 0
          return count > 0 and (' ~' .. count)
        end,
        hl = { fg = 'git_change' },
      },
      {
        provider = function(self)
          local count = self.status_dict.removed or 0
          return count > 0 and (' -' .. count)
        end,
        hl = { fg = 'red' },
      },
    }

    local WorkDir = {
      init = function(self)
        self.icon = ' '
        local cwd = vim.fn.getcwd(0)
        self.cwd = vim.fn.fnamemodify(cwd, ':~')
      end,
      hl = { bg = colors.normal_bg, fg = 'light_blue', bold = true },

      flexible = 1,

      {
        -- evaluates to the full-lenth path
        provider = function(self)
          local trail = self.cwd:sub(-1) == '/' and '' or '/'
          return self.icon .. self.cwd .. trail .. ' '
        end,
      },
      {
        -- evaluates to the shortened path
        provider = function(self)
          local cwd = vim.fn.pathshorten(self.cwd)
          local trail = self.cwd:sub(-1) == '/' and '' or '/'
          return self.icon .. cwd .. trail .. ' '
        end,
      },
      {
        -- evaluates to "", hiding the component
        provider = '',
      },
    }

    local TerminalName = {
      -- we could add a condition to check that buftype == 'terminal'
      -- or we could do that later (see #conditional-statuslines below)
      provider = function()
        local tname, _ = vim.api.nvim_buf_get_name(0):gsub('.*:', '')
        return ' ' .. tname
      end,
      hl = { fg = 'light_blue', bold = true },
    }

    local HelpFileName = {
      condition = function()
        return vim.bo.filetype == 'help'
      end,
      provider = function()
        local filename = vim.api.nvim_buf_get_name(0)
        return vim.fn.fnamemodify(filename, ':t')
      end,
      hl = { fg = '#83C092' },
    }

    -- The easy way.
    local Navic = {
      condition = function()
        return require('nvim-navic').is_available()
      end,
      provider = function()
        return require('nvim-navic').get_location { highlight = true }
      end,
      update = 'CursorMoved',
    }

    local Diagnostics = {

      condition = conditions.has_diagnostics,

      static = {
        error_icon = ' ',
        warn_icon = ' ',
        info_icon = ' ',
        hint_icon = '󰌶 ',
      },

      init = function(self)
        self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
        self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
        self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
        self.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
      end,

      update = { 'DiagnosticChanged', 'BufEnter' },

      {
        provider = function(self)
          -- 0 is just another output, we can decide to print it or not!
          return self.errors > 0 and (self.error_icon .. self.errors .. ' ')
        end,
        hl = { fg = 'diag_error' },
      },
      {
        provider = function(self)
          return self.warnings > 0 and (self.warn_icon .. self.warnings .. ' ')
        end,
        hl = { fg = 'diag_warn' },
      },
      {
        provider = function(self)
          return self.info > 0 and (self.info_icon .. self.info .. ' ')
        end,
        hl = { fg = 'diag_info' },
      },
      {
        provider = function(self)
          return self.hints > 0 and (self.hint_icon .. self.hints)
        end,
        hl = { fg = 'diag_hint' },
      },
    }

    local GrappleTagged = {
      provider = function()
        return '󰛢[' .. require('grapple').name_or_index() .. ']'
      end,
      condition = function()
        return require('grapple').name_or_index() ~= nil
      end,
      hl = { bg = colors.bright_bg, fg = colors.light_blue },
    }

    local RecordingStatus = {
      provider = require('noice').api.statusline.mode.get,
      condition = require('noice').api.statusline.mode.has,
      hl = { bg = colors.bright_bg, fg = colors.red },
    }

    local Align = { provider = '%=', hl = { bg = colors.bright_bg } }
    local Space = { provider = ' ', hl = { bg = colors.bright_bg } }
    local SearchSpace = {
      condition = require('noice').api.status.search.has,
      provider = ' ',
      hl = { bg = colors.bright_bg },
    }
    local GrappleTaggedSpace = {
      condition = function()
        return require('grapple').name_or_index() ~= nil
      end,
      provider = ' ',
      hl = { bg = colors.bright_bg },
    }
    local RecordingSpace = {
      condition = require('noice').api.status.mode.has,
      provider = ' ',
      hl = { bg = colors.bright_bg },
    }
    local FocusEndcap = { provider = ' ', hl = { bg = colors.dark_red } }

    local WinBarSpace = { provider = ' ', hl = { bg = colors.normal_bg } }
    local WinBarAlign = { provider = '%=', hl = { bg = colors.normal_bg } }

    local StatusLine = {
      FocusEndcap,
      ViMode,
      Space,
      Git,
      Align,
      FileNameBlock,
      Align,
      RecordingStatus,
      RecordingSpace,
      FileType,
      Space,
      Ruler,
      Space,
      SearchSpace,
      Search,
      SearchSpace,
      FocusEndcap,
    }

    local ActiveWinBar = {
      GrappleTagged,
      GrappleTaggedSpace,
      Navic,
      WinBarAlign,
      WorkDir,
      hl = { bg = colors.normal_bg, force = true },
    }

    local InactiveWinBar = {
      GrappleTagged,
      WinBarAlign,
      FileNameBlock,
      WinBarAlign,
      hl = { bg = colors.normal_bg, force = true },
    }

    local EmptyWinBar = {
      WinBarAlign,
    }

    local normal_buffer = function()
      normal_buf = true
      for _, abnormal_buftype in pairs { 'acwrite', 'help', 'nofile', 'nowrite', 'quickfix', 'terminal', 'prompt' } do
        normal_buf = normal_buf and not (vim.bo.buftype == abnormal_buftype)
      end

      for _, abnormal_filetype in pairs { '^git.*', 'TELESCERESULTS', 'NEO-TREE' } do
        normal_buf = normal_buf and not (vim.bo.filetype == abnormal_filetype)
      end
      return normal_buf
    end

    local not_normal_buffer = function()
      return not normal_buffer
    end

    vim.api.nvim_set_hl(0, 'WinBar', { bg = 'NONE' })
    vim.o.laststatus = 3
    require('heirline').setup {
      statusline = StatusLine,
      winbar = {
        {
          condition = function()
            return conditions.is_not_active() and normal_buffer() -- vim.bo.buftype ~= 'nofile'
          end,
          InactiveWinBar,
        },
        {
          condition = function()
            return conditions.is_active() and normal_buffer()
          end,
          ActiveWinBar,
        },
      },
    }
  end,
}
