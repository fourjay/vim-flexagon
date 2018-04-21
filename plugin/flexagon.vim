if exists('g:loaded_flexagon')
    finish
endif
let g:loaded_flexagon = 1

let s:save_cpo = &cpoptions
set cpoptions&vim


let s:folds_list = [  ]

function! Flexagon_register_fold( fold )
    call add( s:folds_list, a:fold )
endfunction

call Flexagon_register_fold( 'wiki'     )
call Flexagon_register_fold( 'header'   )
call Flexagon_register_fold( 'space'    )
call Flexagon_register_fold( 'comment'  )
call Flexagon_register_fold( 'braces'   )
call Flexagon_register_fold( 'code'     )
call Flexagon_register_fold( 'ini'      )
call Flexagon_register_fold( 'manual'   )
call Flexagon_register_fold( 'markdown' )
call Flexagon_register_fold( 'javadoc'  )
call Flexagon_register_fold( 'indent'   )
call Flexagon_register_fold( 'function' )
call Flexagon_register_fold( 'html'     )

function! s:fold_complete(...)
    return join( s:folds_list, "\n" )
endfunction
command! -nargs=1 -complete=custom,<SID>fold_complete Fold call <SID>custom_fold("<args>")

function! s:custom_fold(fold)
    if a:fold ==# 'manual'
        call <SID>set_stock_fold('manual')
        return
    endif
    if a:fold ==# 'indent'
        call <SID>set_stock_fold('indent')
        return
    endif
    setlocal foldmethod=expr
    execute 'setlocal foldexpr=flexagon#folds#' . a:fold . '(v:lnum)'
    if a:fold ==# 'braces'
        setlocal foldmethod=marker
        setlocal foldmarker={,}
        setlocal foldnestmax=1
    endif
    call <SID>set_fold_settings()
    normal! zz
    if foldlevel('.') == 0
        normal! zj
    endif
    normal! zA
endfunction

function! s:set_stock_fold(method)
    execute 'setlocal foldmethod=' . a:method
    call <SID>set_fold_settings()
endfunction

function! s:set_fold_settings()
    setlocal foldcolumn=3
    setlocal foldlevel=0
    setlocal foldenable
    setlocal foldtext=FoldText()
endfunction

function! FoldText()
    let l:foldsize = (v:foldend-v:foldstart)
    let l:line = getline(v:foldstart)
    " use a line with info
    if len(l:line) <= 4
        let l:next_line = getline(v:foldstart + 1)
        if len(l:next_line) > 4
            let l:line = l:next_line
        endif
    endif
    let l:line = l:line[0:60]
    let l:line_leader = '+-' . repeat( '---', v:foldlevel - 1 )
    let l:text_length= strlen(l:line . l:line_leader)
    let l:fillerlength = winwidth(0) - l:text_length
    let l:line_count_text = repeat('+', v:foldlevel) . l:foldsize . ' lines  '
    let l:line_count_filler = repeat( ' ', 15 - len(l:line_count_text))
    let l:line_count_text = l:line_count_filler . l:line_count_text
    let l:fillerlength = l:fillerlength - 35
    return l:line_leader . '> ' . l:line . repeat( '-', l:fillerlength) . l:line_count_text
endfunction

if ! exists('flexagon_disable_foldtext')
    set foldtext=FoldText()
endif

function s:bubble_fold(direction)
    if foldlevel('.') != 0
        normal! zC
    endif
    if a:direction ==# 'up'
        normal! zk
    else
        normal! zj
    endif
    normal! zO
    normal! [z
    normal! zt
endfunction

nmap <Plug>BubbleDown :call <SID>bubble_fold("down")<cr>
nmap <unique> <silent> ZJ <Plug>BubbleDown

nmap <Plug>BubbleUp :call <SID>bubble_fold("up")<cr>
nmap <unique> <silent> ZK <Plug>BubbleUp

let &cpoptions = s:save_cpo
unlet s:save_cpo
