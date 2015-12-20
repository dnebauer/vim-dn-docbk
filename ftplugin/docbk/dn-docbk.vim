" Function:    Vim ftplugin for docbk
" Last Change: 2015-12-22
" Maintainer:  David Nebauer <david@nebauer.org>
" License:     Public domain

" 1.  CONTROL STATEMENTS                                              {{{1

" Only do this when not done yet for this buffer
if exists('b:did_docbk') | finish | endif
let b:did_docbk = 1

" Use default cpoptions to avoid unpleasantness from customised
" 'compatible' settings
let s:save_cpo = &cpo
set cpo&vim

" ========================================================================

" 2.  VARIABLES                                                       {{{1

" help                                                                {{{2
if !exists('b:dn_help_plugins')
    let b:dn_help_plugins = []
endif
if !exists('b:dn_help_topics')
    let b:dn_help_topics = {}
endif
if !exists('b:dn_help_data')
    let b:dn_help_data = {}
endif
if count(b:dn_help_plugins, 'dn-docbk') == 0
    call add(b:dn_help_plugins, 'dn-docbk')
    if !has_key(b:dn_help_topics, 'vim')
        let b:dn_help_topics['vim'] = {}
    endif
    let b:dn_help_topics['vim']['docbk ftplugin'] 
                \ = 'vim_docbk_ftplugin'
    let b:dn_help_data['vim_docbk_ftplugin'] = [ 
        \ 'This docbook ftplugin automates the following tasks:',
        \ '',
        \ '',
        \ '',
        \ 'Task                   Mapping  Command',
        \ '',
        \ '--------------------   -------  ------------',
        \ '',
        \ 'generate html output   \gh      GenerateHTML',
        \ '',
        \ 'generate pdf output    \gp      GeneratePDF',
        \ '',
        \ 'display html output    \vh      ViewHTML',
        \ '',
        \ 'display pdf output     \vp      ViewPDF',
        \ ]
endif

" operating system                                                    {{{2
if has('win32') || has ('win64')
    let s:os = 'win'
elseif has('unix')
    let s:os = 'nix'
endif

" ========================================================================

" 3.  FUNCTIONS                                                       {{{1

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
" 4.  CONTROL STATEMENTS                                              {{{1

" restore user's cpoptions
let &cpo = s:save_cpo

" ========================================================================

" 5.  MAPPINGS AND COMMANDS                                           {{{1

" Mappings:                                                           {{{2

" Commands:                                                           {{{2

                                                                    " }}}1

" vim: set foldmethod=marker :
