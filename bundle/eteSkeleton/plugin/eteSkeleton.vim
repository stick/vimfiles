" eteSkeleton
" Autor: ellethee <ellethee@altervista.org> 
" Version: 1.0.1
" License: MIT
" Last change: 2010 Dec 14
" Copyright (c) 2010 ellethee <ellethee@altervista.org>
" License: MIT license {{{
" Permission is hereby granted, free of charge, to any person obtaining a copy
" of this software and associated documentation files (the "Software"), to deal
" in the Software without restriction, including without limitation the rights
" to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
" copies of the Software, and to permit persons to whom the Software is
" furnished to do so, subject to the following conditions:
"
" The above copyright notice and this permission notice shall be included in
" all copies or substantial portions of the Software.

" THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
" IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
" FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
" AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
" LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
" OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
" THE SOFTWARE.
"}}}
if exists("g:loaded_eteSkeleton") || &cp
    finish
endif
let g:loaded_eteSkeleton = 101  
let s:save_cpo = &cpo
let s:ETES_SKELETONS = "skeleton"
let s:ETES_TAGS = globpath(&rtp,"plugin/eteSkeleton.tags")
set cpo&vim

command! -nargs=0 EteSkeleton call s:eteSkeleton_get()
command! -nargs=0 EteSkelList call s:eteSkeleton_list()
command! -nargs=1 EteSkelAdd call s:eteSkeleton_add(<q-args>)
command! -nargs=0 EteSkelAddTag call s:eteSkeleton_addtag()
command! -nargs=1 EteSkelDel call s:eteSkeleton_del(<q-args>)
command! -nargs=? EteSkelMake call s:eteSkeleton_makeskel(<q-args>)

nmap <silent> <Leader>st    :EteSkelAddTag<Enter>

fu! s:eteSkeleton_makeskel(...)
    let l:path = globpath(&rtp,"skeleton")
    if len(a:1)
        let l:name = a:1
    else
        let l:name = substitute(expand("%:r"),"type",&l:filetype,"")
    endif
    echo "Creo lo skeletro: ".l:path."/".l:name
    exec ":w! ".l:path."/".l:name
    exec ":e! ".l:path."/".l:name
endfu 
fu! s:msort(l1, l2)
    return len(a:l2) - len(a:l1)
endfu
fu! s:eteSkeleton_list()
    for riga in readfile(s:ETES_TAGS)
        echo riga
    endfor
endfu
fu! s:eteSkeleton_addtag()
    let l:cword = expand("<cWORD>")
    if len(l:cword)
        call s:eteSkeleton_add(l:cword)
    else
        echoerr "Posizionarsi su di una parola"
    endif
endfu
fu! s:eteSkeleton_add(tag)
    let l:vals = split(a:tag, "=")
    let l:vals[0]= substitute(substitute(l:vals[0],"<","",""),">","","")
    if len(l:vals) < 2
        let l:vtag =  input ("Insert value for tag ".l:vals[0].": ")
        if len(l:vtag)
            call add(l:vals, l:vtag)
        else
            echoerr "Manca un valore per il tag: operazione annullata"
            return
        endif
    endif
    echo l:vals
    let l:lista = readfile(s:ETES_TAGS)
    call filter(l:lista,'v:val !~ "^' .l:vals[0].'="')
    call add(l:lista, l:vals[0]."=".l:vals[1] )
    call writefile(l:lista, s:ETES_TAGS)
endfu
fu! s:eteSkeleton_del(tag)
    let l:tag = substitute(substitute(a:tag,"<","",""),">","","")
    let l:lista = readfile(s:ETES_TAGS)
    call filter(l:lista,'v:val !~ "^'.l:tag.'="')
    call writefile(l:lista, s:ETES_TAGS)
endfu
fu! s:eteSkeleton_replace()
    for l:riga in readfile(s:ETES_TAGS)
        if l:riga[0] != '"' && len(l:riga[0]) != 0
            let l:vals = split(l:riga, "=") 
            for l:idx in range(1,line("$"))
                if getline(l:idx) =~ "<".l:vals[0].">"
                    exec l:idx."s#<".l:vals[0].">#".eval(l:vals[1])."#g"
                    " echo l:idx."s#<".l:vals[0].">#".eval(l:vals[1])."#g"
                    " sleep 
               endif
            endfor
        endif
    endfor
endfu
fu! s:eteSkeleton_get()
    let l:fname = expand("%:r")
    let l:rlist = sort(map(split(globpath(&rtp, s:ETES_SKELETONS."/*".
                \&l:filetype."*"),"\n"),'fnamemodify(v:val,":t")'), "s:msort")
    for l:item in l:rlist
        if l:fname =~ substitute(l:item, &l:filetype,"\\\\w\\\\+", "")
            let l:pfile = split(globpath(&rtp, s:ETES_SKELETONS."/".
                        \l:item))
            if len(l:pfile)
                silent keepalt 0 read `=join(l:pfile)`
                call s:eteSkeleton_replace()
            endif
            break
        endif
    endfor
    return 
endfu 
fu! s:eteSkeleton_check()
    if &l:filetype != ""
        execute "EteSkeleton" 
    endif
    return
endfu
augroup plugin-eteSkeleton
    autocmd BufNewFile * call s:eteSkeleton_check()
    autocmd BufNewFile,BufRead eteSkeleton.tags :set ft=vim
augroup END

let &cpo= s:save_cpo
unlet s:save_cpo

" vim:fdm=marker:
