if exists('g:loaded_dn_docbk_util_autoload') || !exists('g:loaded_dn_docbk_ftplugin')
    finish
endif
let g:loaded_dn_docbk_util_autoload = 1

let s:save_cpo = &cpo
set cpo&vim

function! dn_docbk#util#isRunningWindows() abort
    return has('win16') || has('win32') || has('win64')
endfunction

function! dn_docbk#util#schemaLocation(type) abort
    " returns location of relaxng or schematron schema
    " - params: type - schema type [required, must be 'rng'|'sch']
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

function! dn_docbk#util#userCatalog() abort
    " returns location of user-supplied xml catalog if provided
    if g:dn_docbk_xml_catalog
        return g:dn_docbk_xml_catalog
    endif
endfunction
