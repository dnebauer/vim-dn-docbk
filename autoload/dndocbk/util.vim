" Title:   Vim library for vim-dn-docbk filetype plugin
" Author:  DavidNebauer <davidnebauer[AT]hotkey[DOT]net[DOT]au>
" Licence: Public domain
" URL:     https://github.com/dnebauer/vim-dn-docbk

" CONTROL STATEMENTS:

" load only once                                                       {{{1
if exists('g:loaded_dn_docbk_util_autoload') | finish | endif
let g:loaded_dn_docbk_util_autoload = 1

" requires plugin to be loaded                                         {{{1
if !exists('g:loaded_dn_docbk_ftplugin')
    echoerr "Haven't loaded vim-dn-docbk plugin - check runtimepath"
    finish
endif

" disable user's cpoptions                                             {{{1
let s:save_cpo = &cpo
set cpo&vim    "                                                       }}}1

" FUNCTIONS:

" dndocbk#util#schemaLocation(type)                                    {{{1
" does:   get location of relaxng or schematron schema
" params: type - schema type [required, must be 'rng'|'sch']
" return: string (path)
function! dndocbk#util#schemaLocation(type) abort
    " first, get schema's user location (if available) and default location
    if a:type == 'rng'
        if exists('g:dn_docbk_relaxng_schema')
            let l:user_schema = g:dbn_docbk_relaxng_schema
        endif
        let l:web_schema = 'http://www.docbook.org/xml/5.0/rng/docbook.rng'
    elseif a:type == 'sch'
        if exists('g:dn_docbk_schematron_schema')
            let l:user_schema = g:dn_docbk_schematron_schema
        endif
        let l:web_schema = 'http://www.docbook.org/xml/5.0/sch/docbook.sch'
    else
        echoerr "dn-docbk ftplugin: invalid schema type: '" . a:type . "'"
        finish
    endif
    " now return user-provided location, if available, otherwise default
    if exists('l:user_schema')
        return l:user_schema
    else
        return l:web_schema
    endif
endfunction

" dndocbk#util#userCatalog()                                           {{{1
" does:   get location of user-supplied xml catalog (if provided)
" params: nil
" return: string (path) or 0 if none provided
function! dndocbk#util#userCatalog() abort
    if g:dn_docbk_xml_catalog
        return g:dn_docbk_xml_catalog
    endif
endfunction    "                                                       }}}1

" CONTROL STATEMENTS:

" restore user's cpoptions                                             {{{1
let &cpo = s:save_cpo

" vim:fdm=marker:
