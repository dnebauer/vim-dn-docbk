" Title:   Vim library for vim-dn-docbk filetype plugin
" Author:  DavidNebauer <davidnebauer[AT]hotkey[DOT]net[DOT]au>
" Licence: Public domain
" URL:     https://github.com/dnebauer/vim-dn-docbk

" CONTROL STATEMENTS:

" load only once                                                       {{{1
if exists('g:loaded_dn_docbk_util_autoload') | finish | endif
let g:loaded_dn_docbk_util_autoload = 1

" disable user's cpoptions                                             {{{1
let s:save_cpo = &cpo
set cpo&vim  "                                                         }}}1

" FUNCTIONS:

" dndocbk#util#schemaLocation(type)                                    {{{1
" does:   get location of relaxng or schematron schema
" params: type - schema type [required, must be 'rng'|'sch']
" return: string (path)
function! dndocbk#util#schemaLocation(type) abort
    " first, get schema's user location (if available) and default location
    if a:type == 'rng'
        if exists('g:dn_docbk_relaxng_schema')
            let l:user_schema = g:dn_docbk_relaxng_schema
        endif
        let l:web_schema = 'http://www.docbook.org/xml/5.0/rng/docbook.rng'
    elseif a:type == 'sch'
        if exists('g:dn_docbk_schematron_schema')
            let l:user_schema = g:dn_docbk_schematron_schema
        endif
        let l:web_schema = 'http://www.docbook.org/xml/5.0/sch/docbook.sch'
    else
        echoerr "dn-docbk: invalid schema type: '" . a:type . "'"
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
    if exists('g:dn_docbk_xml_catalog')
        return g:dn_docbk_xml_catalog
    endif
endfunction

" dndocbk#util#selectElementWithCompletion()                           {{{1
" does:   use word completion to assist user to select docbk element
" params: nil
" return: string (element name) or '' if none selected
function! dndocbk#util#selectElementWithCompletion()
    " check for required functions                                   " {{{2
    let l:fns = ['*DNU_SelectWithCompletion']
    let l:err = 0  " false
    for l:fn in l:fns
        if ! exists(l:fn)
            let l:name = strpart(l:fn, 1)
            echoerr "dn-docbk: cannot locate function '" . l:name . "'"
            let l:err = 1  " true
        endif
    endfor
    " get list of docbook elements                                     {{{2
    let l:elements = []
    if exists('g:dn_docbk_element_data')
        let l:elements = keys(g:dn_docbk_element_data)
        if empty(l:elements)
            echoerr "dn-docbk: variable 'g:dn_docbk_element_data' is empty"
            return
        endif
    else
        echoerr "dn-docbk: could not find 'g:dn_docbk_element_data'"
    endif
    " select element                                                   {{{2
    let l:element = DNU_SelectWithCompletion(
                \ 'element name', 'element names', l:elements)
    return l:element
endfunction  "                                                         }}}1

" CONTROL STATEMENTS:

" restore user's cpoptions                                             {{{1
let &cpo = s:save_cpo

" vim:fdm=marker:
