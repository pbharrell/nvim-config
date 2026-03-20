return {
  'folke/persistence.nvim',
  event = 'BufReadPre', -- this will only start session saving when an actual file was opened
  opts = {},
  config = function(_, opts)
    require('persistence').setup(opts)

    local function bp_file()
      return require('persistence').current() .. '.bps.json'
    end

    vim.api.nvim_create_autocmd('User', {
      pattern = 'PersistenceSavePre',
      callback = function()
        local ok, dap_bps = pcall(require, 'dap.breakpoints')
        if not ok then
          return
        end
        local bps = {}
        for buf, buf_bps in pairs(dap_bps.get()) do
          bps[vim.api.nvim_buf_get_name(buf)] = buf_bps
        end
        if vim.tbl_isempty(bps) then
          vim.fn.delete(bp_file())
          return
        end
        local f = io.open(bp_file(), 'w')
        if f then
          f:write(vim.fn.json_encode(bps))
          f:close()
        end
      end,
    })

    vim.api.nvim_create_autocmd('User', {
      pattern = 'PersistenceLoadPost',
      callback = function()
        vim.schedule(function()
          local f = io.open(bp_file(), 'r')
          if not f then
            return
          end
          local content = f:read '*a'
          f:close()
          local ok, bps = pcall(vim.fn.json_decode, content)
          if not ok or type(bps) ~= 'table' then
            return
          end
          pcall(require, 'dap')
          local ok2, dap_bps = pcall(require, 'dap.breakpoints')
          if not ok2 then
            return
          end

          local function restore_buf_bps(bufnr, buf_bps)
            for _, bp in pairs(buf_bps) do
              dap_bps.set({
                condition = bp.condition,
                log_message = bp.logMessage,
                hit_condition = bp.hitCondition,
              }, bufnr, bp.line)
            end
          end

          local count = 0
          for buf_name, buf_bps in pairs(bps) do
            count = count + #buf_bps
            local bufnr = vim.fn.bufadd(buf_name)
            -- Load the buffer into memory so signs land on the correct line
            vim.fn.bufload(bufnr)
            restore_buf_bps(bufnr, buf_bps)
          end
          if count > 0 then
            vim.notify(('Restored %d breakpoint(s)'):format(count), vim.log.levels.INFO)
          end
        end)
      end,
    })
  end,
}
