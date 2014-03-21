" VimCompletesMe.vim - For super simple tab completion
" Maintainer:          Akshay Hegde <http://github.com/ajh17>
" Version:             0.1
" Website:             <http://github.com/ajh17/VimCompletesMe>

" Vimscript Setup: {{{1
if exists("g:loaded_VimCompletesMe") || v:version < 703 || &compatible
    finish
endif
let g:loaded_VimCompletesMe = 1

" Options: {{{1
if !exists('g:VimCompletesMe_stab_deindent')
    let g:VimCompletesMe_stab_deindent = 0
endif

" Functions: {{{1
function! s:vimCompletesMe(direction)
    let dirs = ["\<c-p>", "\<c-n>"]
    let dir = a:direction =~? '[nf]'

    if exists('b:tab_complete')
        let map = b:tab_complete
    else
        let map = ''
    endif

    if pumvisible()
        return dirs[dir]
    endif

    let pos = getpos('.')
    let substr = matchstr(strpart(getline(pos[1]), 0, pos[2]-1), "[^ \t]*$")
    if (strlen(substr) == 0)
        return "\<tab>"
    endif

    let period = match(substr, '\.') != -1
    let file_pattern = match(substr, '\/') != -1

    if file_pattern
        return "\<C-x>\<C-f>"
    elseif period && (&omnifunc != '')
        if get(b:, 'tab_complete_pos', []) == pos
            let exp = "\<C-x>" . dirs[!dir]
        else
            let exp = "\<C-x>\<C-o>"
        endif
        let b:tab_complete_pos = pos
        return exp
    endif

    if map ==? "user"
        return "\<C-x>\<C-u>"
    elseif map ==? "tags"
        return "\<C-x>\<C-]>"
    elseif map ==? "dict"
        return "\<C-x>\<C-k>"
    else
        return "\<C-x>" . dirs[!dir]
    endif
endfunction

" Maps: {{{1
inoremap <expr> <Tab> <SID>vimCompletesMe('n')
inoremap <expr> <S-Tab> <SID>vimCompletesMe('p')
