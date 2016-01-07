" Vim syntastic plugin
" Language:   Docbook
" Checker:    Jing checking against docbook5 schema
" Schema:     Docbook5 Schematron
" Maintainer: David Nebauer <david@nebauer.org>
"
" See for details on how to add an external Syntastic checker:
" https://github.com/scrooloose/syntastic/wiki/Syntax-Checker-Guide#external

if exists("g:loaded_syntastic_docbk_jingsch_checker")
    finish
endif
let g:loaded_syntastic_docbk_jingsch_checker = 1

let s:save_cpo = &cpo
set cpo&vim

" set schema-dependent settings
let s:schema_type = 'sch'
let s:schema_location = dndocbk#util#schemaLocation(s:schema_type)
if ! s:schema_location
    echoerr "dn-docbk ftplugin: unable to determine '" . 
                \ s:schema_type . "' location"
    finish
let s:check_name = 'jing' . s:schema_type

" jing command structure is: 'jing [-C *catalog_path*] *schema_path* *xml_path*'

function! SyntaxCheckers_docbk_jingsch_GetLocList() dict
    let s:args = []
    " use user catalog if found
    let s:user_catalog = dndocbk#util#userCatalog()
    if s:user_catalog
        call extend(s:args, ['-C', s:user_catalog])
        unlet s:catalog
    endif
    " add schema
    call add(s:args, s:schema_location)

    let makeprg = self.makeprgBuild({ 
                \ 'args': s:args,
                \ })
    unlet s:args

    " jing message structure is
    "   /path/to/file.xml:43:21: TYPE: ...
    " where TYPE can be 'fatal', 'error' or 'warning'
    " tokens: f=file name,  l=line no., c=col no., t=error type, m=message
    let errorformat  =
                \ '%f:%l:%c: %tarning: %m,' .
                \ '%f:%l:%c: fatal: %m,'    .
                \ '%f:%l:%c: %trror: %m,'   .
                \ '%f:%l:%c: %m,'

    return SyntasticMake({
                \ 'makeprg': makeprg,
                \ 'errorformat': errorformat,
                \ })
endfunction

call g:SyntasticRegistry.CreateAndRegisterChecker({
            \ 'filetype': 'docbk',
            \ 'name': s:check_name,
            \ 'exec': 'jing',
            \ })
unlet s:check_name

let &cpo = s:save_cpo
unlet s:save_cpo
