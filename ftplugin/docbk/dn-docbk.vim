" Function:    Vim ftplugin for docbk
" Last Change: 2015-12-22
" Maintainer:  David Nebauer <david@nebauer.org>
" License:     Public domain

" 1.  CONTROL STATEMENTS                                              {{{1

" Only do this when not done yet for this buffer
if exists('b:loaded_dn_docbk_ftplugin') | finish | endif
let b:did_docbk = 1

" Use default cpoptions to avoid unpleasantness from customised
" 'compatible' settings
let s:save_cpo = &cpo
set cpo&vim

" ========================================================================

" 2.  SYNTASTIC                                                       {{{1

" Ensure filetype 'docbk' is set                                      {{{2
if exists('g:syntastic_extra_filetypes')
    if ! count(g:syntastic_extra_filetypes, 'docbk')
        call add(g:syntastic_extra_filetypes, 'docbk')
    endif
else
    let g:syntastic_extra_filetypes = ['docbk']
endif

" Select checkers to use                                              {{{2
" Available checkers are 'xmllintdbk', 'jingrng' and 'jingsch'
let g:syntastic_docbk_checkers = ['jingrng', 'jingsch']

" ========================================================================

" 3.  VARIABLES                                                       {{{1

" help                                                                {{{2
" - add to plugins list (b:dn_help_plugins)                           {{{3
if !exists('b:dn_help_plugins')
    let b:dn_help_plugins = {}
endif
if ! count(b:dn_help_plugins, 'docbook')
    call add(b:dn_help_plugins, 'docbook')
endif                                                               " }}}3
" - add help topics (b:dn_help_topics)                                {{{3
if !exists('b:dn_help_topics')
    let b:dn_help_topics = {}
endif
let b:dn_help_topics['docbook'] = { 
            \ 'syntastic' : 'docbk_syntastic', 
            \ 'snippets'  : 'docbk_snippets', 
            \ 'output'    : 'docbk_output',
            \ }                                                     " }}}3
" - add help data for help topics (b:dn_help_data)                    {{{3
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
            \ ]                                                     " }}}3

" operating system                                                    {{{2
if has('win32') || has ('win64')
    let s:os = 'win'
elseif has('unix')
    let s:os = 'nix'
endif

" ========================================================================

" 4.  FUNCTIONS                                                       {{{1

" Function: s:execute_shell_command                                   {{{2
" Purpose:  execute shell command
" Params:   1 - shell command [required, string]
"           2 - error message [optional, List, default='Error occured:']
" Prints:   if error display user error message and shell feedback
" Return:   return status of command as vim boolean
function! s:execute_shell_command(cmd, ...)
	echo '' | " clear command line
    " variables
    if a:0 > 0
        let l:errmsg = a:1
    else
        let l:errmsg = ['Error occurred:']
    endif
    " run command
    let l:shell_feedback = system(a:cmd)
    " if failed display error message and shell feedback
    if v:shell_error
        echo ' ' |    " previous output was echon
        for l:line in l:errmsg
            call DNU_Error(l:line)
        endfor
        echo '--------------------------------------'
        echo l:shell_feedback
        echo '--------------------------------------'
        return b:dn_false
    else
        return b:dn_true
    endif
endfunction
" ------------------------------------------------------------------------
" Function: s:dn_utils_missing                                        {{{2
" Purpose:  execute shell command
" Params:   1 - shell command [required, string]
"           2 - error message [optional, List, default='Error occured:']
" Prints:   if error display user error message and shell feedback
" Return:   return status of command as vim boolean
function! s:dn_utils_missing()
    return !exists('b:do_not_load_dn_utils')
endfunction
" ------------------------------------------------------------------------
" 5.  CONTROL STATEMENTS                                              {{{1

" restore user's cpoptions
let &cpo = s:save_cpo

" ========================================================================

" 6.  MAPPINGS AND COMMANDS                                           {{{1

" Mappings:                                                           {{{2

" Commands:                                                           {{{2

                                                                    " }}}1

" vim: set foldmethod=marker :
