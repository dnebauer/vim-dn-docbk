" Control statements    {{{1
set encoding=utf-8
scriptencoding utf-8

if exists('b:disable_dn_md_utils') && b:disable_dn_md_utils | finish | endif
if exists('s:loaded') | finish | endif
let s:loaded = 1

let s:save_cpo = &cpoptions
set cpoptions&vim

" Documentation    {{{1

""
" @section Variables, vars
" This ftplugin contributes to the |dn-utils| help system (see
" |dn#util#help()| for details). In the help system navigate to:
" vim -> docbook.
"
" This plugin stores the definition of the docbook specification in a very
" large variable called g:dn_docbk_element_data. Take care if viewing or
" manipulating this variable.

" Default syntastic checkers/linters are documented in @section(intro) rather
" than in @section(vars).

" Element data for loading into g:dn_docbk_element_data is stored in file
" element_data.vim in the ftplugin folder because it is large and because it
" is generated in place by a script. After regeneration make sure to add this
" to the top of the file:
" >
"   if exists('g:dn_docbk_element_data') && !empty(g:dn_docbk_element_data)
"       finish
"   endif
" <

" }}}1

" Variables

" Help variables   {{{1
" Plugin list    {{{2
if !exists('g:dn_help_plugins')
    let g:dn_help_plugins = {}
endif
if !count(g:dn_help_plugins, 'docbook')
    call add(g:dn_help_plugins, 'docbook')
endif

" Help topics    {{{2
if !exists('g:dn_help_topics')
    let g:dn_help_topics = {}
endif
let g:dn_help_topics['docbook'] = {
            \ 'syntastic' : 'docbk_syntastic',
            \ 'snippets'  : 'docbk_snippets',
            \ 'output'    : 'docbk_output',
            \ }

" Help data    {{{2
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

" Default syntastic checkers    {{{1
let g:syntastic_docbk_checkers = ['jingrng', 'jingsch']
" }}}1

" Control statements    {{{1
let &cpoptions = s:save_cpo
unlet s:save_cpo
" }}}1

" vim:fdm=marker:
