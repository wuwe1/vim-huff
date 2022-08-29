setlocal keywordprg=:HuffLookup

if get(g:, 'huff_fold_enable', 1)
  setlocal foldmethod=syntax
endif
