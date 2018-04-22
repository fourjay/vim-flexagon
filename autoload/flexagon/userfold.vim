
let s:user_folds = { }
function! flexagon#userfold#register(name, function) abort
    let s:user_folds[a:name] =  a:function
endfunction

function! flexagon#userfold#list() abort
    return s:user_folds
endfunction
function! flexagon#userfold#keys() abort
    return keys(s:user_folds)
endfunction

function! flexagon#userfold#defined(name) abort
    return has_key( s:user_folds, a:name )
endfunction

let s:selected_user_fold = ''
function! flexagon#userfold#set_user_fold( fold ) abort
    let s:selected_user_fold = a:fold
endfunction
function! flexagon#userfold#get_user_fold( ) abort
    return s:selected_user_fold
endfunction

function! flexagon#userfold#user_fold(lnum) abort
    let l:falias = flexagon#userfold#get_user_fold()
    if len(l:falias) == 0
        echo "no fold alias defined"
        return
    endif
    let l:fname = s:user_folds[l:falias]
    let l:Func = function(l:fname)
    return l:Func( a:lnum )
endfunction
