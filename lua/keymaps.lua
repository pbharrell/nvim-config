-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', function()
  vim.cmd 'nohlsearch'
  vim.schedule(function()
    vim.cmd 'redrawstatus!'
  end)
end)

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', function()
  vim.diagnostic.setloclist { open = false }

  local loclist = vim.fn.getloclist(0, { items = true })
  local bufnr = vim.api.nvim_get_current_buf()
  local lnum = vim.api.nvim_win_get_cursor(0)[1]
  local index

  for i, item in ipairs(loclist.items) do
    if item.bufnr == bufnr and item.lnum == lnum then
      index = i
      break
    end
  end

  if index then
    vim.fn.setloclist(0, {}, 'r', { items = loclist.items, idx = index })
  end

  vim.cmd 'lopen'
end, { desc = 'Open diagnostic [Q]uickfix list' })

vim.api.nvim_create_autocmd('DiagnosticChanged', {
  callback = function(args)
    vim.schedule(function()
      for _, winid in ipairs(vim.api.nvim_list_wins()) do
        local winnr = vim.fn.win_id2win(winid)
        local loclist = vim.fn.getloclist(winnr, { filewinid = 0, winid = 0, idx = 0 })
        if
          loclist.winid ~= 0
          and vim.api.nvim_win_is_valid(loclist.winid)
          and vim.api.nvim_win_is_valid(loclist.filewinid)
          and vim.api.nvim_win_get_buf(loclist.filewinid) == args.buf
        then
          local previous_index = loclist.idx
          local previous_item = vim.fn.getloclist(winnr, { items = true }).items[previous_index]
          local items = vim.diagnostic.toqflist(vim.diagnostic.get(args.buf))
          local selected_index
          local best_distance
          for i, item in ipairs(items) do
            if
              previous_item
              and item.type == previous_item.type
              and item.text == previous_item.text
            then
              local distance = math.abs(item.lnum - previous_item.lnum) * 100000 + math.abs(item.col - previous_item.col)
              if not best_distance or distance < best_distance then
                best_distance = distance
                selected_index = i
              end
            end
          end

          if #items > 0 then
            local file_winnr = vim.fn.win_id2win(loclist.filewinid)
            vim.fn.setloclist(file_winnr, items, 'r')
            vim.fn.setloclist(file_winnr, {}, 'a', {
              idx = selected_index or math.min(previous_index, #items),
            })
          else
            vim.fn.setloclist(vim.fn.win_id2win(loclist.filewinid), items, 'r')
          end
          break
        end
      end
    end)
  end,
  desc = 'Update open diagnostic location list',
})

-- Keybinds to make split navigation easier.
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<leader>h', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<leader>l', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<leader>j', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<leader>k', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
-- vim.api.nvim_create_autocmd('TextYankPost', {
--   desc = 'Highlight when yanking (copying) text',
--   group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
--   callback = function()
--     local t = vim.uv.hrtime()
--     vim.highlight.on_yank()
--     print((vim.uv.hrtime() - t) / 1e9 .. 's')
--   end,
-- })

local yank_started

vim.keymap.set({ 'n', 'x' }, 'y', function()
  yank_started = vim.uv.hrtime()
  return 'y'
end, { expr = true, desc = 'Timed yank' })

vim.api.nvim_create_autocmd('TextYankPost', {
  group = vim.api.nvim_create_augroup('diagnose-yank', { clear = true }),
  callback = function()
    local event_time = vim.uv.hrtime()
    vim.highlight.on_yank()

    vim.schedule(function()
      local resumed_time = vim.uv.hrtime()
      print(('before event: %.3fs; after event: %.3fs'):format(yank_started and (event_time - yank_started) / 1e9 or -1, (resumed_time - event_time) / 1e9))
    end)
  end,
})

-- ** Start custom keymaps **
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv", { desc = 'Shift line down', silent = true })
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv", { desc = 'Shift line up', silent = true })

vim.keymap.set('n', 'n', 'nzzzv')
vim.keymap.set('n', 'N', 'Nzzzv')
vim.keymap.set('n', '*', function()
  local view = vim.fn.winsaveview()
  vim.cmd 'keepjumps normal! *'
  vim.fn.winrestview(view)
  vim.schedule(function()
    vim.cmd 'redrawstatus'
  end)
end, { desc = 'Highlight word under cursor' })

vim.keymap.set('n', 'Q', '@@', { desc = 'Repeat last macro' })

vim.keymap.set('n', '<leader>tc', '<cmd>tabclose<CR>', { desc = '[T]ab [C]lose' })
vim.keymap.set('n', '<leader>tn', '<cmd>tabnew<CR>', { desc = '[T]ab [N]ew' })

-- keep values of registers unchanged with x and X
vim.keymap.set({ 'n', 'x' }, 'x', '"_x')
vim.keymap.set({ 'n', 'x' }, 'X', '"_dd')

-- keep values of registers unchanged with c
vim.keymap.set({ 'n', 'x' }, 'c', '"_c')

vim.keymap.set('x', 'p', function()
  return 'pgv"' .. vim.v.register .. 'y'
end, { remap = false, expr = true })

vim.keymap.set({ 'n', 'x' }, '<leader>v', '<C-w>v')

vim.keymap.set('n', '<leader>go', function()
  local command = {
    'open-in-gitiles ',
    vim.api.nvim_buf_get_name(0),
    '#',
    vim.fn.line '.',
  }
  os.execute(table.concat(command))
end, { desc = '[O]pen in [G]itiltes' })

vim.keymap.set({ 'n', 'v', 'x' }, '<leader>2', '$')

vim.keymap.set('n', 'gn', 'gt', { desc = '[G]o to [N]ext tab' })
vim.keymap.set('n', 'gp', 'gT', { desc = '[G]o to [P]rev tab' })

vim.keymap.set('n', '<leader>ssw', ':set shiftwidth=', { desc = 'Set shiftwidth' })

vim.keymap.set('n', 'k', 'g<Up>', { desc = 'Move up one display line' })
vim.keymap.set('n', 'j', 'g<Down>', { desc = 'Move down one display line' })

-- vim: ts=2 sts=2 sw=2 et
