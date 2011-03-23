"============================================================================
"File:        puppet.vim
"Description: Syntax checking plugin for syntastic.vim
"Maintainer:  Chris MacLeod <stick at miscellaneous dot net>
"License:     This program is free software. It comes without any warranty,
"             to the extent permitted by applicable law. You can redistribute
"             it and/or modify it under the terms of the Do What The Fuck You
"             Want To Public License, Version 2, as published by Sam Hocevar.
"             See http://sam.zoy.org/wtfpl/COPYING for more details.
"
"============================================================================
if exists("loaded_puppet_syntax_checker")
    finish
endif
let loaded_puppet_syntax_checker = 1

"bail if the user doesnt have puppet installed
if !executable("puppet")
    finish
endif

" make it work for: puppet apply /tmp/foo.pp --noop
" Duplicate definition: File[foo] is already defined in file /tmp/foo.pp at
" line 9; cannot redefine at /tmp/foo.pp:13 on node rdu-cmacleod.airdat.com


" this works for parseonly
function! SyntaxCheckers_puppet_GetLocList()
    let makeprg = 'puppet --color false --parseonly --loadclasses --ignoreimport '.shellescape(expand('%'))
    let errorformat  = 'err: Could not parse for environment %s:'
    let errorformat .= ' %m'
    let errorformat .= ' at %f:%l'

    return SyntasticMake({ 'makeprg': makeprg, 'errorformat': errorformat })
endfunction
