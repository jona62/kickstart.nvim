-- Define the Edit command in Lua
vim.cmd([[
  command! -bar -nargs=* -complete=file -bang Edit lua require('my_commands').edit_command(<f-args>)
]])

-- Create a Lua module to handle the command logic
vim.api.nvim_exec([[
  function! s:edit_command(args) abort
    execute 'edit ' . a:args
    execute 'cd ' fnameescape(expand('%:p:h'))
  endfunction
  command! -nargs=* -complete=file -bang Edit lua require('my_commands').edit_command(<f-args>)
]], false)

-- Optionally, create a mapping for convenience
vim.api.nvim_set_keymap('n', '<leader>ed', [[:Edit<CR>]], { noremap = true, silent = true })

