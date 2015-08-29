" Public Folding calls for flexagon
"
" Folds have to be publicly visible

" based on a reddit snippet
" http://www.reddit.com/r/vim/comments/1hnh8v/question_what_foldmethod_are_you_guys_using_and/
" Fold by mediawiki header
function!  flexagon#folds#wiki(lnum)
    let cline = getline(a:lnum)
    if cline !~# "="
        return "="
    elseif cline =~# '^[^=]*=\s*[^=]\+=[= ]*$'
        return ">1"
    elseif cline =~# '^[^=]*==\s*[^=]\+==[= ]*$'
        return ">2"
    elseif cline =~# '^[^=]*===\s*[^=]\+===[= ]*$'
        return ">3"
    else
        return "="
    endif
endfunction

function! flexagon#folds#space(lnum)
    let cline = getline(a:lnum)
    if cline =~# "^$"
        return '0'
    else
        return '1'
    endif
endfunction

function! flexagon#folds#comment(lnum)
    let cline = getline(a:lnum)
    if cline =~# '^["#;]'
        return '0'
    elseif cline =~# '^--'
        return '0'
    elseif cline =~# '^//'
        return '0'
    elseif cline =~# "^\w*$"
        return '='
    else
        return '2'
    endif
endfunction

function! flexagon#folds#code(lnum)
    let cline = getline(a:lnum)
    if cline =~# '^["#/;]'
        return '1'
    elseif cline =~# "^\w*$"
        return '='
    else
        return '0'
    endif
endfunction

function! flexagon#folds#header(lnum)
    if   getline( a:lnum - 1 ) =~ '^################'
                \ &&  getline(a:lnum) =~ '\v^# \w+'
                \ &&  getline( a:lnum + 1 ) =~ '^###################'
        return ">1"
    elseif   getline( a:lnum - 1 ) =~ '\v(\-|\=){5,}'
                \ &&  getline(a:lnum) =~ '.\+'
                \ &&  getline( a:lnum + 1 ) =~ '\v(\-|\=){5,}'
        return ">1"
    else
        return "="
    endif
endfunction
