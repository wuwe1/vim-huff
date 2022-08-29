function! huff#Compile()
  let l:huff = get(g:, 'huff_command', 'huffc')
  execute "!" . l:huff . " -b " . bufname('%')
endfunction

function! huff#ShowBytecode()
  let l:huff = get(g:, 'huff_command', 'huffc')
  let l:bytecode = system(l:huff . " -b " . bufname('%'))
  let l:winnr = bufwinnr('EVM_BYTECODE')
  if l:winnr ==# -1
    vsplit EVM_BYTECODE
  else 
    execute l:winnr . ' wincmd w' 
  endif
  normal! ggdG
  setlocal filetype=evm
  setlocal buftype=nofile

  call append(0, l:bytecode)
endfunction
