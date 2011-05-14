" Vim filetype plugin
" Language:     Puppet
" Original Maintainer:   Todd Zullinger <tmz@pobox.com>
" Modifications: Chris MacLeod <stick at miscellaneousnet dot net>
" Last Change:  2011-04-03
" vim: set sw=4 sts=4:

if exists("b:did_ftplugin")
    finish
endif
let b:did_ftplugin = 1

" set keyword program
setlocal keywordprg=pi

" The assumption is that each module is a repo
" if it's not you'll get some extra pathings
" Exported vars
"   classname
"   modulename
"   classpath

function! s:SetModuleVars(rcs)

  if a:rcs == "git"   " when we use git we need to move dirs to figure out the relative tree
    " full path of top of module
    let l:module_path = fnamemodify(system("git rev-parse --show-toplevel")[:-2], ":p")
    " name of module, no path
    let b:module_name = fnamemodify(system("git rev-parse --show-toplevel")[:-2], ":t")
    " path from top of repo to cwd
    let l:top_to_cwd = system("git rev-parse --show-prefix")[:-2]
  else " we rely on the cwd being at the top of the module
    " full path of top of module
    let l:module_path = fnamemodify(getcwd(), ":p")
    " name of module, no path
    let b:module_name = fnamemodify(l:module_path, ":t")
    " path from top of repo to cwd
    let l:top_to_cwd = ""
  endif
  
  " relative path to file being edited
  let l:cwd_to_file = expand("%:r")
  " dump each thing into an array
  let b:loader_array = []
  " add compoonents in order split on / if needed
  call add(b:loader_array, b:module_name)
  let b:loader_array += split(l:top_to_cwd, '/')
  let b:loader_array += split(l:cwd_to_file, '/')
  call remove(b:loader_array, index(b:loader_array, "manifests"))

  " if we can find a manifests directory we are in a module
  let l:manifests_path = '**;' . l:module_path
  let l:manifests = finddir("manifests", l:manifests_path) " look for a manifests dir
  if exists("l:manifests")
    let b:classpath = join(b:loader_array, "::")
  else
    let b:classpath = ""
  endif
endfunction

" check for various rcs's
call system("git rev-parse")
if ! v:shell_error
  call s:SetModuleVars("git")
else
  call s:SetModuleVars("")
endif


" Alignment functions and maps
" ----------------------------

if !exists("no_plugin_maps") && !exists("no_puppet_maps")
    if !hasmapto("<Plug>AlignRange")
        map <buffer> <LocalLeader>= <Plug>AlignRange
    endif
endif

noremap <buffer> <unique> <script> <Plug>AlignArrows :call <SID>AlignArrows()<CR>
noremap <buffer> <unique> <script> <Plug>AlignRange :call <SID>AlignRange()<CR>

iabbrev => =><C-R>=<SID>AlignArrows('=>')<CR>
iabbrev +> +><C-R>=<SID>AlignArrows('+>')<CR>

if exists('*s:AlignArrows')
    finish
endif

let s:arrow_re = '[=+]>'
let s:selector_re = '[=+]>\s*\$.*\s*?\s*{\s*$'

function! s:AlignArrows(op)
    let cursor_pos = getpos('.')
    let lnum = line('.')
    let line = getline(lnum)
    if line !~ s:arrow_re
        return
    endif
    let pos = stridx(line, a:op)
    let start = lnum
    let end = lnum
    let pnum = lnum - 1
    while 1
        let pline = getline(pnum)
        if pline !~ s:arrow_re || pline =~ s:selector_re
            break
        endif
        let start = pnum
        let pnum -= 1
    endwhile
    let cnum = end
    while 1
        let cline = getline(cnum)
        if cline !~ s:arrow_re ||
                \ (indent(cnum) != indent(cnum+1) && getline(cnum+1) !~ '\s*}')
            break
        endif
        let end = cnum
        let cnum += 1
    endwhile
    call s:AlignSection(start, end)
    let cursor_pos[2] = stridx(getline('.'), a:op) + strlen(a:op) + 1
    call setpos('.', cursor_pos)
    return ''
endfunction

function! s:AlignRange() range
    call s:AlignSection(a:firstline, a:lastline)
endfunction

" AlignSection and AlignLine are from the vim wiki:
" http://vim.wikia.com/wiki/Regex-based_text_alignment
function! s:AlignSection(start, end)
    let extra = 1
    let sep = s:arrow_re
    let maxpos = 0
    let section = getline(a:start, a:end)
    for line in section
        let pos = match(line, ' *'.sep)
        if maxpos < pos
            let maxpos = pos
        endif
    endfor
    call map(section, 's:AlignLine(v:val, sep, maxpos, extra)')
    call setline(a:start, section)
endfunction

function! s:AlignLine(line, sep, maxpos, extra)
    let m = matchlist(a:line, '\(.\{-}\) \{-}\('.a:sep.'.*\)')
    if empty(m)
        return a:line
    endif
    let spaces = repeat(' ', a:maxpos - strlen(m[1]) + a:extra)
    return m[1] . spaces . m[2]
endfunction
