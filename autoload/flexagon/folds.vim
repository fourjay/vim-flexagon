" Public Folding calls for flexagon
"
" Folds have to be publicly visible

" based on a reddit snippet
" http://www.reddit.com/r/vim/comments/1hnh8v/question_what_foldmethod_are_you_guys_using_and/
" Fold by mediawiki header
function!  flexagon#folds#wiki(lnum) abort
    let l:cline = getline(a:lnum)
    if l:cline !~# '='
        return '='
    elseif l:cline =~# '^[^=]*=\s*[^=]\+=[= ]*$'
        return '>1'
    elseif l:cline =~# '^[^=]*==\s*[^=]\+==[= ]*$'
        return '>2'
    elseif l:cline =~# '^[^=]*===\s*[^=]\+===[= ]*$'
        return '>3'
    else
        return '='
    endif
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
    if l:cline =~# '^["#;]'
        return '0'
    elseif l:cline =~# '^--'
        return '0'
    elseif l:cline =~# '^//'
        return '0'
    elseif l:cline =~# '^\w*$'
        return '='
    else
        return '2'
    endif
endfunction

function! flexagon#folds#code(lnum) abort
    let l:cline = getline(a:lnum)
    if l:cline =~# '^["#/;]'
        return '1'
    elseif l:cline =~# '^\w*$'
        return '='
    else
        return '0'
    endif
endfunction

function! flexagon#folds#ini(lnum) abort
    let l:line = getline(a:lnum)
    if l:line =~# '^\s*\[[^]]\+\]'
        return '>1'
    endif
    return '='
endfunction
    
function! flexagon#folds#header(lnum) abort
    if   getline( a:lnum - 1 ) =~# '^################'
                \ &&  getline(a:lnum) =~# '\v^# \w+'
                \ &&  getline( a:lnum + 1 ) =~# '^###################'
        return '>1'
    elseif   getline( a:lnum - 1 ) =~# '\v(\-|\=){5,}'
                \ &&  getline(a:lnum) =~# '.\+'
                \ &&  getline( a:lnum + 1 ) =~# '\v(\-|\=){5,}'
        return '>1'
    else
        return '='
    endif
endfunction

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
