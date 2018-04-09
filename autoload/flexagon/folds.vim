" Public Folding calls for flexagon

" HELPER_FUNCTIONS =======================================================
"
" test vim syntax notions of comment
function! flexagon#folds#iscomment(lnum) abort
    let l:start = match(getline(a:lnum), '\v\s*\zs\S') + 1
    let l:syn_id = synID( a:lnum, l:start, 0)
    let l:syn_name = synIDattr( l:syn_id, 'name')
    if l:syn_name =~? 'comment'
        return 1
    else
        return 0
    endif
endfunction

" return aproximate comment string
function! flexagon#folds#comment_regex() abort
    let l:ftype = &filetype
    let l:commentstring = &commentstring
    if l:ftype ==# 'php'
        return '(//|#)'
    elseif l:ftype ==# 'c'
        return '(/\*|\*/)'
    elseif l:ftype ==# 'markdown' || l:ftype ==# 'pandoc'
        return ''
    endif
    if l:commentstring !=# '/*%s*/'
        return  substitute(l:commentstring, '%s', '', '')
    else
        return '#'
    endif
endfunction

" MAIN FOLDS ================================================================
" Fold by mediawiki header
" http://www.reddit.com/r/vim/comments/1hnh8v/question_what_foldmethod_are_you_guys_using_and/
function!  flexagon#folds#wiki(lnum) abort
    return flexagon#folds#comment_marker(a:lnum, '=')
endfunction

" similar idea with markdown headers in comments
function!  flexagon#folds#markdown(lnum) abort
    if &filetype =~# '\vmarkdown|pandoc'
        return flexagon#folds#markdown_filetype(a:lnum)
    else
        return flexagon#folds#comment_marker(a:lnum, '#')
    endif
endfunction

function! flexagon#folds#markdown_filetype(lnum) abort
    if flexagon#folds#iscomment(a:lnum)
        return '='
    endif
    let l:cline = getline(a:lnum)
    for l:i in [1, 2, 3, 4]
        if match( l:cline, '\v^[#]{' . l:i . '}[^#]' ) != -1
            return '>' . l:i
        endif
    endfor
    return '='
endfunction

" factor out comment style
function!  flexagon#folds#comment_marker(lnum, leader_char ) abort
    if ! flexagon#folds#iscomment(a:lnum)
        return '='
    endif
    let l:cline = strpart( getline(a:lnum), 0, 8)
    for l:i in [ 1, 2, 3, 4]
        if match( l:cline, '\v^[^' . a:leader_char . ']*[' . a:leader_char . ']{' . l:i . '}[^' . a:leader_char . ']' ) != -1
            if a:leader_char ==# '#' && &commentstring =~# '#'
                if l:i == 1
                    continue
                else
                    return '>' . ( l:i - 1 )
                endif
            else
                return '>' . l:i
            endif
        endif
    endfor
    return '='
endfunction

" Fold non-space
function! flexagon#folds#space(lnum) abort
    let l:cline = getline(a:lnum )
    if l:cline =~# '^\s*$'
        return '<1'
    else
        return '1'
    endif
endfunction

" fold non-comment
function! flexagon#folds#comment(lnum) abort
    let l:cline = getline(a:lnum)
    if flexagon#folds#iscomment(a:lnum)
        return '0'
    elseif l:cline =~# '^\w*$'
        return '='
    else
        return '1'
    endif
endfunction

" fold non code
function! flexagon#folds#code(lnum) abort
    let l:cline = getline(a:lnum)
    if flexagon#folds#iscomment(a:lnum)
        return '1'
    elseif l:cline =~# '^\w*$'
        return '='
    else
        return '0'
    endif
endfunction

" basic folding ini files
function! flexagon#folds#ini(lnum) abort
    if flexagon#folds#iscomment(a:lnum)
        return '='
    endif
    let l:line = getline(a:lnum)
    let l:prev_line = getline(a:lnum - 1)
    if l:line =~# '^\s*\[[^]]\+\]'
        return '>1'
    elseif l:line =~# '^\s*;'
            return '>2'
    elseif l:prev_line =~# '^\s*$'
            return '>2'
    endif
    return '='
endfunction
    
" flowerpot style headers
function! flexagon#folds#header(lnum) abort
    if ! flexagon#folds#iscomment(a:lnum)
        return '='
    endif
    " has some content
    if  getline(a:lnum) =~# '\v\S{2,}'
        " if before or after is flowerpot
        if getline( a:lnum - 1 ) =~# '\v[*+=_-]{5,}'
                    \ ||  getline( a:lnum + 1 ) =~# '\v[*+=_-]{5,}'
            return '>1'
        else
            return '='
        endif
    endif
    return '='
endfunction

" FIXME partially working HTML structuring folds
function! flexagon#folds#html(lnum) abort
    if getline( a:lnum ) =~# '.*<h[0-9].*'
        return '>1'
    elseif getline( a:lnum +1 ) =~# '.*<h[0-9].*'
        return '<1'
    elseif getline( a:lnum ) =~# '.*<head\>>.*'
        return '>1'
    elseif getline( a:lnum ) =~# '.*</head>.*'
        return '<1'
    elseif getline( a:lnum ) =~# '.*<script\>.*>.*</script>.*'
        return '='
    elseif getline( a:lnum ) =~# '.*<script\>.*>.*'
        return 'a1'
    elseif getline( a:lnum ) =~# '.*</script\>.*>.*'
        return 's1'
    elseif getline( a:lnum ) =~# '.*</script\>.*>.*'
        return 's1'
    elseif getline( a:lnum ) =~# '.*<div.*>.*</div>.*'
        return '='
    elseif getline( a:lnum ) =~# '.*<div.*>.*'
        return 'a1'
    elseif getline( a:lnum ) =~# '.*</div>.*'
        return 's1'
    elseif getline( a:lnum ) =~# '.*<style.*>.*</style>.*'
        return '='
    elseif getline( a:lnum ) =~# '.*<style.*>.*'
        return 'a1'
    elseif getline( a:lnum ) =~# '.*</style>.*'
        return 's1'
    elseif getline( a:lnum ) =~# '.*<table.*>.*</table>.*'
        return '='
    elseif getline( a:lnum ) =~# '.*<table.*>.*'
        return 'a1'
    elseif getline( a:lnum ) =~# '.*</table>.*'
        return 's1'
    elseif getline( a:lnum ) =~# '.*<[ou]l\>.*'
        return 'a1'
    elseif getline( a:lnum ) =~# '.*<\/[ou]\>.*'
        return 's1'
    elseif getline( a:lnum ) =~# '.*<p\>.*>.*</p\>.*>.*'
        return '='
    elseif getline( a:lnum ) =~# '.*<p\>.*>.*'
        return 'a1'
    elseif getline( a:lnum ) =~# '.*</p\>.*>.*'
        return 's1'
    else
        return '='
    endif
endfunction

