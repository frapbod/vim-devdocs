" devdocs.vim - Look up keywords on https://devdocs.io from Vim.
" Maintainer:	romainl <romainlafourcade@gmail.com>
" Version:	0.0.1
" License:	MIT
" Location:	plugin/devdocs.vim
" Website:	https://github.com/romainl/vim-devdocs

if exists("g:loaded_devdocs") || v:version < 704 || &compatible
  finish
endif
let g:loaded_devdocs = 1

let s:save_cpo = &cpo
set cpo&vim

" What command to use
function! s:Cmd() abort
    " Linux/BSD
    if executable("xdg-open")
        return "xdg-open"
    endif
    " MacOS
    if executable("open")
        return "open"
    endif
    " Windows
    return "explorer"
endfunction

" Build the URL stub
let s:stub = get(g:, "devdocs_open_command", <SID>Cmd()) . " 'https://devdocs.io/#q="

" Build the full URL
function! s:DD(args, ...) abort
    let query = ""

    if len(split(a:args, " ")) == 0
        let query = s:stub . (a:1 == "!" || get(g:, "devdocs_enable_scoping", 0) == 1 ? '' : &filetype . "%20") . expand("<cword>") . "'"
    elseif len(split(a:args, " ")) == 1
        let query = s:stub . (a:1 == "!" || get(g:, "devdocs_enable_scoping", 0) == 1 ? '' : &filetype . "%20") . a:args . "'"
    else
        let query = s:stub . substitute(a:args, '\s\+', '%20', 'g') . "'"
    endif

    return query
endfunction

" Build the command
command! -bang -nargs=* DD call system(<SID>DD(<q-args>, expand("<bang>")))

let &cpo = s:save_cpo
