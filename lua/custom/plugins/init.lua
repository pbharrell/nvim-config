-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  'debugloop/telescope-undo.nvim',
  'EdenEast/nightfox.nvim',
  'max397574/better-escape.nvim',
  -- Using default mappings for this - https://github.com/max397574/better-escape.nvim
  config = function () 
    require('better_escape').setup()
    end,
}
