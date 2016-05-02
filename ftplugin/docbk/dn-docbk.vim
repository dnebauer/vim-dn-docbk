" Function:    Vim ftplugin for docbk
" Last Change: 2016-04-27
" Maintainer:  David Nebauer <david@nebauer.org>
" License:     Public domain

" 1.  CONTROL STATEMENTS                                               {{{1

" only load once                                                       {{{2
if exists('b:loaded_dn_docbk_ftplugin') | finish | endif
let b:loaded_dn_docbk_ftplugin = 1

" ignore user cpoptions                                                {{{2
let s:save_cpo = &cpo
set cpo&vim  "                                                         }}}2

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
let g:syntastic_docbk_checkers = ['jingrng', 'jingsch']  "             }}}2

" 3.  VARIABLES                                                        {{{1

" help                                                                 {{{2
" - add to plugins list (b:dn_help_plugins)                            {{{3
if !exists('b:dn_help_plugins')
    let b:dn_help_plugins = {}
endif
if ! count(b:dn_help_plugins, 'docbook')
    call add(b:dn_help_plugins, 'docbook')
endif  "                                                               }}}3
" - add help topics (b:dn_help_topics)                                 {{{3
if !exists('b:dn_help_topics')
    let b:dn_help_topics = {}
endif
let b:dn_help_topics['docbook'] = { 
            \ 'syntastic' : 'docbk_syntastic', 
            \ 'snippets'  : 'docbk_snippets', 
            \ 'output'    : 'docbk_output',
            \ }  "                                                     }}}3
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
            \ ]

" os-dependent (os, vim_home, vimrc)                                   {{{2
if has('win32') || has ('win64')
    let s:os = 'win'
    let s:vim_home = $HOME . '/vimfiles'
elseif has('unix')
    let s:os = 'nix'
    let s:vim_home = $HOME . '/.vim'
endif

" vim-docbk (Jaromir Hradilek) snippet directories                     {{{2
let s:jhs_dir = s:vim_home . '/repos/jhradilek/vim-snippets'
let s:jhs_git = s:jhs_dir . '/.git'
let s:jhs_snippets = s:jhs_dir . '/snippets'  "                        }}}2

" 4.  FUNCTIONS                                                        {{{1

" s:haveDnuFunctions()                                                 {{{2
" does:   check for required dn-utils functions
" params: nil
" prints: error message listing missing functions
" insert: nil
" return: whether required vim-dn-utils functions are available [boolean]
" note:   DNU_LocalGitRepoFetch, DNU_LocalGitRepoUpdatedRecently
function! s:haveDnuFunctions()
    " functions to check
    let l:fns = [
                \ '*DNU_LocalGitRepoFetch', 
                \ '*DNU_LocalGitRepoUpdatedRecently'
                \ ]
    " check for functions
    let l:err = 0  " false
    for l:fn in l:fns
        if ! exists(l:fn)
            let l:name = strpart(l:fn, 1)
            echoerr "dn-docbk: cannot locate function '" . l:name . "'"
            let l:err = 1  " true
        endif
    endfor
    " report further errors and return
    if l:err
        echoerr "dn-docbk: is plugin 'dn-utils' loaded?"
        return
    endif
    return 1  " true
endfunction

" s:ensureJHSnippetsAreAvailable()                                     {{{2
" does:   ensure uptodate snippet files from jhradilek/vim-docbk
"         are available in ~/.vim/repos/jhradilek/vim-snippets
" params: nil
" insert: nil
" return: nil
function! s:ensureJHSnippetsAreAvailable()
    " try to add repo if not found
    let l:repo = 'https://github.com/jhradilek/vim-snippets.git'
    if ! isdirectory(s:jhs_git)
        if ! executable('git')
            echoerr 'dn-docbk: cannot find docbook snippets'
            echoerr 'dn-docbk: cannot find git - unable to install them'
            return
        endif
        echo 'dn-docbk: installing docbook and rng snippets...'
        let l:cmd = 'git clone ' . l:repo . ' ' . s:jhs_dir
        let l:err = systemlist(l:cmd)
        if v:shell_error
            echoerr 'dn-docbk: install failed'
            if len(l:err) > 0
                echoerr 'dn-docbk: error message:'
                for l:line in l:err | echoerr '  ' . l:line | endfor
            endif
            return
        endif  " v:shell_error
        " perform initial fetch operation to ensure existence
        " of '.git/FETCH_HEAD'
        if ! DNU_LocalGitRepoFetch(s:jhs_git)
            echoerr 'dn-docbk: post-install fetch failed'
            return
        endif
        " success
        echo 'dn-docbk: done'
        return b:dn_true
    endif  " ! isdirectory(s:jhs_git)
    " exit if can't find local repo
    "  - must have been error message generated above
    if ! isdirectory(s:jhs_git) | return | endif
    " decide whether need to update
    if DNU_LocalGitRepoUpdatedRecently(s:jhs_dir, 604800)  " try to update
        " even if fail to update will exit with success code
        " - user will have to use possibly outdated snippets
        if ! executable('git')  " need git to update
            echoerr 'dn-docbk: cannot find git'
            echoerr 'dn-docbk: unable to ensure dbk snippets are up to date'
            return b:dn_true
        endif
        if ! DNU_LocalGitRepoFetch(s:jhs_git, 'vim-docbk: ')
            return b:dn_true
        endif
    endif  " l:do_fetch
    " presume success if haven't exited yet
    return b:dn_true
endfunction

" s:useJHSnippets()                                                    {{{2
" does:   use snippet files in ~/.vim/repos/jhradilek/vim-snippets
" params: nil
" insert: nil
" return: nil
function! s:useJHSnippets()
    " add it to the neosnippets directory list
    if isdirectory(s:jhs_snippets)
        if ! exists('g:neosnippet#snippets_directory')
            let g:neosnippet#snippets_directory = []
        endif
        call add(g:neosnippet#snippets_directory, s:jhs_snippets)
    else
        echoerr 'dn-docbk: unable to find docbook snippets directory'
    endif
endfunction  "                                                         }}}2

" 5.  SNIPPETS                                                         {{{1

" use jhradilek docbook snippets                                       {{{2
if s:haveDnuFunctions()
    if s:ensureJHSnippetsAreAvailable()
        call s:useJHSnippets()
    endif
else
    echoerr "dn-docbk: unable to load jhradilek docbk plugin"
endif  "                                                               }}}2

" 6.  MAPPINGS AND COMMANDS                                            {{{1

" Mappings: \                                                          {{{2

" Commands: \                                                          {{{2
                                                                     " }}}2

" 7.  CONTROL STATEMENTS                                               {{{1

" restore user's cpoptions                                             {{{2
let &cpo = s:save_cpo    "                                             }}}2

" vim:fdm=marker:
