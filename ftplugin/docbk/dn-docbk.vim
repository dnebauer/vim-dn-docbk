" Function:    Vim ftplugin for docbk
" Last Change: 2015-12-22
" Maintainer:  David Nebauer <david@nebauer.org>
" License:     Public domain

" 1.  CONTROL STATEMENTS                                               {{{1

" only load once                                                       {{{2
if exists('b:loaded_dn_docbk_ftplugin') | finish | endif
let b:loaded_dn_docbk_ftplugin = 1

" ignore user cpoptions                                                {{{2
let s:save_cpo = &cpo
set cpo&vim    "                                                       }}}2

" 2.  SYNTASTIC                                                        {{{1

" ensure filetype is set to 'docbk'                                    {{{2
if exists('g:syntastic_extra_filetypes')
    if ! count(g:syntastic_extra_filetypes, 'docbk')
        call add(g:syntastic_extra_filetypes, 'docbk')
    endif
else
    let g:syntastic_extra_filetypes = ['docbk']
endif

" select checkers to use                                               {{{2
" - available checkers are 'xmllintdbk', 'jingrng' and 'jingsch'
let g:syntastic_docbk_checkers = ['jingrng', 'jingsch']    "           }}}2

" 3.  VARIABLES                                                        {{{1

" help                                                                 {{{2
" - add to plugins list (b:dn_help_plugins)                            {{{3
if !exists('b:dn_help_plugins')
    let b:dn_help_plugins = {}
endif
if ! count(b:dn_help_plugins, 'docbook')
    call add(b:dn_help_plugins, 'docbook')
endif                                                                " }}}3
" - add help topics (b:dn_help_topics)                                 {{{3
if !exists('b:dn_help_topics')
    let b:dn_help_topics = {}
endif
let b:dn_help_topics['docbook'] = { 
            \ 'syntastic' : 'docbk_syntastic', 
            \ 'snippets'  : 'docbk_snippets', 
            \ 'output'    : 'docbk_output',
            \ }                                                      " }}}3
" - add help data for help topics (b:dn_help_data)                     {{{3
if !exists('b:dn_help_data')
    let b:dn_help_data = {}
endif
let b:dn_help_data['docbk_snippets'] = [ 
            \ 'Snippets:', 
            \ '', 
            \ ' ', '', 
            \ 'Stub',
            \ ]
let b:dn_help_data['docbk_output'] = [ 
            \ 'Output:', 
            \ '', 
            \ ' ', '', 
            \ 'Stub',
            \ ]                                                      " }}}3

" os-dependent (os, vim_home, vimrc)                                   {{{2
if has('win32') || has ('win64')
    let s:os = 'win'
    let s:vim_home = $HOME . '/vimfiles'
elseif has('unix')
    let s:os = 'nix'
    let s:vim_home = $HOME . '/.vim'
endif    "                                                             }}}2

" 4.  FUNCTIONS                                                        {{{1

" s:dn_utils_missing()                                                 {{{2
" does:   execute shell command
" params: nil
" insert: nil
" return: whether vim-dn-utils plugin is loaded [boolean]
function! s:dn_utils_missing()
    return !exists('b:loaded_dn_utils')
endfunction

" s:ensureSnippetsAreAvailable(vimhome)                                {{{2
" does:   ensure uptodate snippet files from jhradilek/vim-docbk
"         are available in ~/.vim/repos/jhradilek/vim-snippets
" params: vimhome - vim home directory [required]
" insert: nil
" return: nil
function! s:ensureSnippetsAreAvailable(vimhome)
    " ensure up to date snippet files from jhradilek/vim-docbk
    " are available in ~/.vim/repos/jhradilek/vim-snippets
    " check for repo directory
    let l:root = a:vimhome . '/repos/jhradilek'
    let l:dir = l:root . '/vim-snippets'
    let l:git = l:dir . '/.git'
    let l:snippets = l:dir . '/snippets'
    " try to add repo if not found
    let l:repo = 'https://github.com/jhradilek/vim-snippets.git'
    if ! isdirectory(l:git)
        if ! executable('git')
            echoerr 'Cannot find docbook snippets'
            echoerr 'Cannot find git - unable to install them'
            return
        endif
        echo 'Installing docbook and rng snippets...'
        let l:cmd = 'git clone ' . l:repo . ' ' . l:dir
        let l:err = systemlist(l:cmd)
        if v:shell_error
            echoerr 'Cannot find docbook snippets'
            echoerr 'Unable to install docbook snippets'
            if len(l:err) > 0
                echoerr 'Error message:'
                for l:line in l:err | echoerr '  ' . l:line | endfor
            endif
            return
        endif  " v:shell_error
        " perform initial fetch operation to ensure existence
        " of '.git/FETCH_HEAD'
        if s:localRepoFetch(l:git) | echo 'Done' | endif
    endif  " ! isdirectory(l:git)
    " add snippets directory
    if isdirectory(l:snippets)
        call add(g:neosnippet#snippets_directory, l:snippets)
    else
        echoerr 'Unable to find docbook snippets directory'
    endif
    " exit if can't find local repo
    "  - must have been error message generated above
    if ! isdirectory(l:git) | return | endif
    " decide whether need to update
    if s:localRepoUpdatedRecently(l:dir, 604800)  " try to update
        if ! executable('git')  " need git to update
            echoerr 'Cannot find git - unable to ensure'
            echoerr 'docbook snippets are up to date'
            return
        endif
        if ! s:localRepoFetch(l:git) | return | endif
    endif  " l:do_fetch
    " presume success if haven't exited yet
    return 1
endfunction

" s:localRepoFetch(dir)                                                {{{2
" does:   perform a fetch on a local git repository
" params: path to '.git' subdirectory in repository
" prints: error messages if fails
" return: boolean, whether fetch successful
function! s:localRepoFetch(dir)
    " check directory
    let l:dir = resolve(expand(a:dir))
    if ! isdirectory(l:dir)
        echoerr "Invalid repository '.git' directory ('" . a:dir . "')"
        return
    endif
    " need git
    if ! executable('git')  " need git to update
        echoerr 'Cannot find git - unable to perform fetch operation'
        return
    endif
    " do fetch
    let l:cmd = "git --git-dir='" . l:dir . "' fetch"
    if exists('l:err') | unlet l:err | endif
    let l:err = systemlist(l:cmd)
    if v:shell_error
        echoerr "Unable to perform fetch operation on '" . a:dir . "'"
        if len(l:err) > 0
            echoerr 'Error message:'
            for l:line in l:err | echoerr '  ' . l:line | endfor
        endif
        return
    endif  " v:shell_error
    " success if still here
    return 1
endfunction

" s:localRepoUpdatedRecently(dir, time)                                {{{2
" does:   check that a local repository has been updated
"         within a given time period
" params: dir  - directory containing local repository
"         time - time in seconds
" prints: error messages if setup fails
" return: boolean
" note:   determines time of last 'fetch' operation
"         (so also 'pull' operations)
" note:   uses python and python modules 'os' and 'time'
" note:   designed to determine whether repo needs to be
"         updated, so if it fails it returns false,
"         presumably triggering an update
" note:   a week is 604800 seconds
" note:   will display error message if:
"         - cannot find '.git/FETCH_HEAD' file in directory
"         - time value is invalid
" note:   will fail silently if:
"         - python is absent
function! s:localRepoUpdatedRecently(dir, time)
    " need python
    if ! executable('python') | return | endif
    " check parameters
    let l:dir = resolve(expand(a:dir))
    if ! isdirectory(l:dir)
        echoerr "Not a valid directory ('" . l:dir . "')"
        return
    endif
    let l:fetch = l:dir . '/.git/FETCH_HEAD'
    if ! filereadable(l:fetch)
        echoerr "Not a valid git repository ('" . l:dir . "')"
        return
    endif
    if a:time !~ '^0$\|^[1-9][0-9]*$'
        echoerr "Not a valid time ('" . a:time . "')"
    endif
    " get time of last fetch (in seconds since epoch)
    let l:cmd = "python -c \"import os;print os.stat('"
                \ . l:fetch . "').st_mtime\""
    let l:last_fetch_list = systemlist(l:cmd)
    if v:shell_error | return | endif
    if type(l:last_fetch_list) != type([])
                \ || len(l:last_fetch_list) != 1
                \ || len(l:last_fetch_list[0]) == 0
        " expected single-item list
        return
    endif
    let l:last_fetch = l:last_fetch_list[0]
    " get current time (in seconds since epoch)
    let l:cmd = "python -c \"import time;print int(time.time())\""
    let l:now_list = systemlist(l:cmd)
    if v:shell_error | return | endif
    if type(l:now_list) != type([])
                \ || len(l:now_list) != 1
                \ || len(l:now_list[0]) == 0
        " expected single-item list
        return
    endif
    let l:now = l:now_list[0]
    " have both time values
    " - if less than the supplied time then return true
    let l:diff = l:now - l:last_fetch
    if l:diff < a:time | return 1 | else | return | endif
endfunction                                                          " }}}2

" 5.  SNIPPETS                                                         {{{1

" install jhradilek docbook snippets                                   {{{2
call s:ensureSnippetsAreAvailable(s:vim_home)                        " }}}2

" 6.  MAPPINGS AND COMMANDS                                            {{{1

" Mappings:                                                            {{{2

" Commands:                                                            {{{2

" vim: set foldmethod=marker :
" 7.  CONTROL STATEMENTS                                               {{{1

" restore user's cpoptions                                             {{{2
let &cpo = s:save_cpo    "                                             }}}2

