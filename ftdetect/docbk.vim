" detect docbook5 files and set filetype to 'docbk'
" - not very robust as it relies on the root element tag
"   and its attribute xmlns are on the same line
function! s:DocbkCheck()
    let l:n = 1
    if line("$") > 500
        let l:nmax = 500
    else
        let l:nmax = line("$")
    endif
    let l:tags  = '\(book\|article\|bibliography\|chapter\|index\|part\)'
    let l:xmlns = 'xmlns="http://docbook.org/ns/docbook"'
    let l:match = '\<' . l:tags . '[\s\S]\+' . l:xmlns
    while l:n <= l:nmax
        if getline(l:n) =~ l:match
            setfiletype docbk
            break
        endif
        let l:n = l:n + 1
    endwhile
endfunction
au BufRead,BufNewFile *.xml call s:DocbkCheck()
