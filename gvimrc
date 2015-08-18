set go=aAcig
let molokai_original = 1
colo twilight
nnoremap <expr> ZZ (getline(1) ==# '' && 1 == line('$') ? 'ZZ' : ':w<CR>:bdelete<CR>')
nnoremap <expr> ZQ (getline(1) ==# '' && 1 == line('$') ? 'ZZ' : ':bdelete<CR>')
