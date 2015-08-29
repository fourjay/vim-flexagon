if exists("g:loaded_flexagon")
    finish
endif
let g:loaded_flexagon = 1

let s:save_cpo = &cpo
set cpo&vim

function! s:fold_complete(...)
    return          "wiki\n"
                \ . "header\n"
                \ . "space\n"
                \ . "comment\n"
                \ . "braces\n"
                \ . "code\n"
                \ . "manual\n"
                \ . "indent\n"
endfunction
command! -nargs=1 -complete=custom,<SID>fold_complete Fold call <SID>custom_fold("<args>")

function! s:custom_fold(fold)
    if a:fold ==# "manual"
        call <SID>set_stock_fold('manual')
        return
    endif
    if a:fold ==# "indent"
        call <SID>set_stock_fold('indent')
        return
    endif
    if a:fold ==# "wiki"
        setlocal foldexpr=flexagon#folds#wiki(v:lnum)
    elseif a:fold ==# "header"
        setlocal foldexpr=flexagon#folds#header(v:lnum)
    elseif a:fold ==# "space"
        setlocal foldexpr=flexagon#folds#space(v:lnum)
    elseif a:fold ==# "comment"
        setlocal foldexpr=flexagon#folds#comment(v:lnum)
    elseif a:fold ==# "code"
        setlocal foldexpr=flexagon#folds#code(v:lnum)
    endif
    set foldmethod=expr
    if a:fold ==# "braces"
        setlocal foldmethod=marker
        setlocal foldmarker={,}
        setlocal foldnestmax=1
    endif
    call <SID>set_fold_settings()
    normal! zz
    if foldlevel(".") == 0
        normal! zj
    endif
    normal! zA
endfunction

function! s:set_stock_fold(method)
    execute "setlocal foldmethod=" . a:method
    call <SID>set_fold_settings()
endfunction

function! s:set_fold_settings()
    setlocal foldcolumn=3
    setlocal foldlevel=0
    setlocal foldenable
    setlocal foldtext=FoldText()
endfunction

function! FoldText()
    let foldsize = (v:foldend-v:foldstart)
    let line = getline(v:foldstart)
    let line = line[0:60]
    let line_leader = "+-" . repeat( '---', v:foldlevel - 1 )
    let text_length= strlen(line . line_leader)
    let fillerlength = winwidth(0) - text_length
    let line_count_text = repeat('+', v:foldlevel) . foldsize . ' lines  '
    let line_count_filler = repeat( ' ', 15 - len(line_count_text))
    let line_count_text = line_count_filler . line_count_text
    let fillerlength = fillerlength - 35
    return line_leader . '> ' . line . repeat( "-", fillerlength) . line_count_text
endfunction
set foldtext=FoldText()

function s:bubble_fold(direction)
    if foldlevel(".") != 0
        normal! zA
    endif
    if a:direction ==# "up"
        normal! zk
    else
        normal! zj
    endif
    normal! zz
    if foldlevel(".") != 0
        normal! zA
    endif
endfunction

" nnoremap zJ zA<bar>zj<bar>zz<bar>zA nnoremap zK zA<bar>zk<bar>zz<bar>zA
nnoremap zJ :call <SID>bubble_fold("down")<cr>
nnoremap ZJ :call <SID>bubble_fold("down")<cr>
nnoremap zK :call <SID>bubble_fold("up")<cr>
nnoremap ZK :call <SID>bubble_fold("up")<cr>
let &cpo = s:save_cpo 
unlet s:save_cpo
