" Function:    Vim ftplugin for docbk
" Last Change: 2016-04-27
" Maintainer:  David Nebauer <david@nebauer.org>

" 1.  CONTROL STATEMENTS                                               {{{1

" only load once                                                       {{{2
if exists('b:loaded_dn_docbk_ftplugin') | finish | endif
let b:loaded_dn_docbk_ftplugin = 1

" ignore user cpoptions                                                {{{2
let s:save_cpo = &cpoptions
set cpoptions&vim  "                                                   }}}2

" 2.  SYNTASTIC                                                        {{{1

" select checkers to use                                               {{{2
" - available checkers are 'xmllintdbk', 'jingrng' and 'jingsch'
let g:syntastic_docbk_checkers = ['jingrng', 'jingsch']  "             }}}2

" 3.  VARIABLES                                                        {{{1

" help                                                                 {{{2
" - add to plugins list (g:dn_help_plugins)                            {{{3
if !exists('g:dn_help_plugins')
    let g:dn_help_plugins = {}
endif
if ! count(g:dn_help_plugins, 'docbook')
    call add(g:dn_help_plugins, 'docbook')
endif  "                                                               }}}3
" - add help topics (g:dn_help_topics)                                 {{{3
if !exists('g:dn_help_topics')
    let g:dn_help_topics = {}
endif
let g:dn_help_topics['docbook'] = {
            \ 'syntastic' : 'docbk_syntastic',
            \ 'snippets'  : 'docbk_snippets',
            \ 'output'    : 'docbk_output',
            \ }  "                                                     }}}3
" - add help data for help topics (g:dn_help_data)                     {{{3
if !exists('g:dn_help_data')
    let g:dn_help_data = {}
endif
let g:dn_help_data['docbk_snippets'] = [
            \ 'Snippets:',
            \ '',
            \ ' ', '',
            \ 'Stub',
            \ ]
let g:dn_help_data['docbk_output'] = [
            \ 'Output:',
            \ '',
            \ ' ', '',
            \ 'Stub',
            \ ]

" os-dependent (os, vim_home, vimrc)                                   {{{2
if has('win32') || has ('win64')
    let s:os = 'win'
    let s:vim_home = $HOME . '/vimfiles'
elseif has('unix')
    let s:os = 'nix'
    let s:vim_home = $HOME . '/.vim'
endif

" docbk element data ('g:dn_docbk_element_data')                       {{{2
" s:loadElementData()                                                  {{{3
" does:   load variable 'g:dn_docbk_element_data' from
"         ftplugin data file 'dn-docbk-element-data.vim'
" params: nil
" prints: error message if unable to find single copy of data file
" insert: nil
" return: whether successfully loaded data [boolean]
" note:   searches for data file under &runtimepath directories
function! s:loadElementData()
    " look for data file
    let l:file = 'dn-docbk-element-data.vim'
    let l:search_term = '**/' . l:file
    let l:found_raw = globpath(&runtimepath, l:search_term, 1, 1)
    " globpath can produce duplicates
    let l:found = filter(
                \ copy(l:found_raw),
                \ 'index(l:found_raw, v:val, v:key+1) == -1'
                \ )
    " load data file if only one found
    if     len(l:found) == 0  " found no matching files
        echoerr "dn-docbk: cannot locate data file '" . l:file . "'"
    elseif len(l:found) == 1  " found one matching file
        execute 'source ' . fnameescape(l:found[0])
    else  " found multiple matching files
        echoerr "dn-docbk: found multiple '" . l:file . "' data files"
    endif
    " check for loaded variable
    if exists('g:dn_docbk_element_data') && !empty(g:dn_docbk_element_data)
        return 1
    else
        echoerr 'dn-docbk: unable to load docbook element data'
        return
    endif
endfunction  "                                                         }}}3
call s:loadElementData()  "                                            }}}2

" 4.  MAPPINGS AND COMMANDS                                            {{{1

" Mappings: \                                                          {{{2

" Commands: \                                                          {{{2
                                                                     " }}}2

" 5.  CONTROL STATEMENTS                                               {{{1

" restore user's cpoptions                                             {{{2
let &cpoptions = s:save_cpo
unlet s:save_cpo                                                     " }}}2
                                                                     " }}}1
" vim:fdm=marker:
