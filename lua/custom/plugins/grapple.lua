return {
  'cbochs/grapple.nvim',
  event = 'VeryLazy',
  opts = {
    scope = 'git', -- also try out "git_branch"
    icons = false, -- setting to "true" requires "nvim-web-devicons"
    status = false,
  },
  keys = {
    { '<leader>a', '<cmd>Grapple toggle<cr>', desc = 'Tag a file' },
    { '<leader>e', '<cmd>Grapple toggle_tags<cr>', desc = 'Toggle tags menu' },

    { '<leader>o', '<cmd>Grapple cycle_tags next<cr>', desc = 'Cycle prev tag' },
    { '<leader>i', '<cmd>Grapple cycle_tags prev<cr>', desc = 'Cycle next tag' },

    { '<c-h>', '<cmd>Grapple select index=1<cr>', desc = 'Select first tag' },
    { '<c-j>', '<cmd>Grapple select index=2<cr>', desc = 'Select second tag' },
    { '<c-k>', '<cmd>Grapple select index=3<cr>', desc = 'Select third tag' },
    { '<c-l>', '<cmd>Grapple select index=4<cr>', desc = 'Select fourth tag' },
  },
}
