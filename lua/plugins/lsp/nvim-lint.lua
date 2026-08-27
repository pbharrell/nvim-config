return {
  'mfussenegger/nvim-lint',
  event = { 'BufReadPre', 'BufNewFile' },
  config = function()
    local lint = require 'lint'
    lint.linters_by_ft = {
      cpp = { 'codespell', 'cppcheck'},
      c = { 'codespell', 'cppcheck'},
    }

    local cppcheck_build_dir = vim.fn.stdpath 'cache' .. '/cppcheck'
    vim.fn.mkdir(cppcheck_build_dir, 'p')
    table.insert(lint.linters.cppcheck.args, '--cppcheck-build-dir=' .. cppcheck_build_dir)

    local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })

    vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
      group = lint_augroup,
      callback = function()
        lint.try_lint()
      end,
    })
  end,
}
