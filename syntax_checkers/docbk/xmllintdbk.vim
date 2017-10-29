" Vim syntastic plugin
" Language:   Docbook
" Checker:    Xmllint checking against docbook5 schema
" Schema:     Docbook5 RelaxNG
" Maintainer: David Nebauer <david@nebauer.org>
" Credit:     Based on syntax checking plugin for syntastic.vim
"             by Sebastian Kusnier <sebastian at kusnier dot net>
"             in github repository scrooloose/syntastic
" Rationale:  Need to add user catalog to command line
"             It needs to be part of makeprg's 'exe_before' option
"             and this option cannot be set using global variable
"
" See for details on how to add an external Syntastic checker:
" https://github.com/scrooloose/syntastic/wiki/Syntax-Checker-Guide#external

if exists('g:loaded_syntastic_docbk_xmllintdbk_checker')
    finish
endif
let g:loaded_syntastic_docbk_xmllintdbk_checker = 1

let s:save_cpo = &cpoptions
set cpoptions&vim

" You can use a local installation of schemas to significantly speed up
" validation and allow you to validate XML data without network access,
" see xmlcatalog(1) and http://www.xmlsoft.org/catalog.html for more
" information.

" xmllint command:
"   [XML_CATALOG_FILES=*catalog_path*] xmllint --xinclude --postvalid \
"           --noout --relaxng *schema_path* *xml_file*

function! SyntaxCheckers_docbk_xmllintdbk_GetLocList() dict
    let l:makeprg_options = {}
    " - use standard options from original checker (part of 'args')
    let l:args = ['--xinclude', '--postvalid', '--noout']
    " - add schema if available (part of 'args')
    let l:schema = dndocbk#util#schemaLocation('rng')
    if l:schema
        call extend(l:args, ['--relaxng', l:schema])
    endif
    let l:makeprg_options.args = l:args
    " - add user catalog if available (part of 'exe_before')
    let l:catalog = dndocbk#util#userCatalog()
    if l:catalog
        let l:catalog = 'XML_CATALOG_FILES=' . l:catalog
        let l:makeprg_options.exe_before = l:catalog
    endif

    let makeprg = self.makeprgBuild(l:makeprg_options)

    let errorformat=
                \ '%E%f:%l: error : %m,' .
                \ '%-G%f:%l: validity error : '
                \ . 'Validation failed: no DTD found %m,' .
                \ '%W%f:%l: warning : %m,' .
                \ '%W%f:%l: validity warning : %m,' .
                \ '%E%f:%l: validity error : %m,' .
                \ '%E%f:%l: parser error : %m,' .
                \ '%E%f:%l: %m,' .
                \ '%-Z%p^,' .
                \ '%-G%.%#'

    return SyntasticMake({
                \ 'makeprg': makeprg,
                \ 'errorformat': errorformat,
                \ 'returns': [0, 1, 2, 3, 4, 5],
                \ })
endfunction

call g:SyntasticRegistry.CreateAndRegisterChecker({
            \ 'filetype': 'docbk',
            \ 'name': 'xmllintdbk',
            \ 'exec': 'xmllint',
            \ })

let &cpoptions = s:save_cpo
unlet s:save_cpo

" vim: set sw=4 sts=4 et fdm=marker:
