" Vim ftplugin for markdown
" Last change: 2018 Aug 6
" Maintainer: David Nebauer
" License: GPL3

" Control statements    {{{1
set encoding=utf-8
scriptencoding utf-8

let s:save_cpo = &cpoptions
set cpoptions&vim

" Documentation    {{{1

""
" @section Introduction, intro
" @order vars
" An auxiliary filetype plugin for docbook xml files.
" 
" All public functions in this library are global. They have the prefix
" "dn#docbk#" to try and avoid namespace collisions.
" 
" This ftplugin requires the |dn-utils| plugin.
" 
" @subsection Filetype detection
"
" This plugin sets the filetype to "docbk" if the file has an ".xml" extension
" and a root element with a docbook5 xmlns attribute. Valid root elements are
" "book", "article", "bibliography", "chapter", "index" or "part". Imortantly,
" the element opening tag and xmlns attribute must be on the same line. This
" is an example:
" 
" <article xmlns="http://docbook.org/ns/docbook" version="5.0" xml:lang="en">
"
" @subsection Syntastic integration
"
" Three syntastic docbook syntax checkers are provided by the @plugin(name)
" ftplugin:
" 
" * xmllintdbk    docbook RelaxNG schema
" * jingrng       docbook RelaxNG schema
" * jingsch       docbook Schematron schema
"
" They are defined in the "syntax_checkers/docbk" directory of this plugin.
" 
" For each checker the user can use global variables to specify a schema
" and catalog to use:
" 
" * RelaxNG schema       g:dn_docbk_relaxng_schema
" * Schematron schema    g:dn_docbk_schematron_schema
" * xml catalog          g:dn_docbook_xml_catalog
" 
" If no schema is specified, the checker uses the following values:
" 
" * RelaxNG schema      http://www.docbook.org/xml/5.0/rng/docbook.rng
" * Schematron schema   http://www.docbook.org/xml/5.0/sch/docbook.sch
" * xml catalog         default catalog (see xmlcatalog man page)
"
" By default, this plugin sets syntastic to use the "jingrng" and "jingsch"
" checkers by setting the "g:syntastic_docbk_checkers" variable. This can be
" overridden by the user by setting the "b:syntastic_docbk_checkers" variable.
" See syntastic help for more details.

" }}}1

" Script variables

" Script functions

" Private functions

" Public functions

" dn#docbk#schemaLocation(type)    {{{1

""
" @ public
" Get location of relaxng or schematron schema. The schema {type} is either
" "rng" or "sch". Returns a |String| path.
function! dn#docbk#schemaLocation(type) abort
    " first, get schema's user location (if available) and default location
    if a:type ==# 'rng'
        if exists('g:dn_docbk_relaxng_schema')
            let l:user_schema = g:dn_docbk_relaxng_schema
        endif
        let l:web_schema = 'http://www.docbook.org/xml/5.0/rng/docbook.rng'
    elseif a:type ==# 'sch'
        if exists('g:dn_docbk_schematron_schema')
            let l:user_schema = g:dn_docbk_schematron_schema
        endif
        let l:web_schema = 'http://www.docbook.org/xml/5.0/sch/docbook.sch'
    else
        echoerr "dn-docbk: invalid schema type: '" . a:type . "'"
        finish
    endif
    " now return user-provided location, if available, otherwise default
    if exists('l:user_schema') | return l:user_schema
    else                       | return l:web_schema
    endif
endfunction

" dn#docbk#userCatalog()    {{{1

""
" @public
" Get location of user-supplied xml catalog (if provided). Returns |String|
" filepath, or "" if none supplied.
function! dn#docbk#userCatalog() abort
    return exists('g:dn_docbk_xml_catalog') ? g:dn_docbk_xml_catalog : ''
endfunction

" dn#docbk#selectElement([method])    {{{1

""
" @public
" User selects a docbk element. The selection [method] can be "filter" or
" "complete".
" @default method="filter"
"
" Returns a |String| element name, or "" if no element selected.
function! dn#docbk#selectElement(...) abort
    " check for required functions                                     {{{2
    let l:fns = ['*dn#util#consoleSelect']
    let l:err = 0  " false
    for l:fn in l:fns
        if ! exists(l:fn)
            let l:name = strpart(l:fn, 1)
            echoerr "dn-docbk: cannot locate function '" . l:name . "'"
            let l:err = 1  " true
        endif
    endfor
    if l:err | return '' | endif
    " check argument                                                   {{{2
    let l:method = 'filter'
    if a:0 >= 1
        if a:0 > 1
            echoerr 'Ignoring extra arguments: ' . join(a:000[1:], ', ')
        endif
        if a:1 =~# '^complete$\|^filter$'
            let l:method = a:1
        else
            echoerr "Invalid method: '" . a:1 . "'"
            return ''
        endif
    endif
    " get list of docbook elements                                     {{{2
    let l:elements = []
    if ! exists('g:dn_docbk_element_data')
        echoerr "dn-docbk: could not find 'g:dn_docbk_element_data'"
        return ''
    endif
    let l:elements = keys(g:dn_docbk_element_data)
    if empty(l:elements)
        echoerr "dn-docbk: variable 'g:dn_docbk_element_data' is empty"
        return ''
    endif
    " select element                                                   {{{2
    let l:element = dn#util#consoleSelect(
                \ 'element name',
                \ 'element names',
                \ l:elements,
                \ l:method
                \ )
    return l:element    " }}}2
endfunction
" }}}1

" Control statements    {{{1
let &cpoptions = s:save_cpo
unlet s:save_cpo
" }}}1

" vim:fdm=marker:
