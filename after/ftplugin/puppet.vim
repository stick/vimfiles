" Puppet filetype plugin
" Language:     Puppet
" Maintainer:   Chris MacLeod <stick@miscellaneous.net>
" Last Change:  2011 10 18
" vim: set sw=4 sts=4:

if exists("b:did_ftplugin")
    finish
endif
let b:did_ftplugin = 1

" detect if we are in a module and set variables for classpath (autoloader),
" modulename, modulepath, and classname
" useful to use in templates
function! s:SetModuleVars()

  " set these to any dirs you want to stop searching on
  " useful to stop vim from spinning disk looking all over for init.pp
  " probably only a macosx problem with /tmp since it's really /private/tmp
  " but it's here if you find vim spinning on new files in certain places
  if !exists("g:puppet_stop_dirs")
    let g:puppet_stop_dirs = '/tmp;/private/tmp'
  endif

  " check if we are actually trying to create init.pp
  let b:buffername = expand("%:t")
  if b:buffername == 'init.pp'
    let b:initpp = expand("%:p")
  else
    " search path for init.pp
    let b:search_path = './**'
    let b:search_path = b:search_path . ';' . getcwd() . ';' . g:puppet_stop_dirs
    let b:initpp = findfile("init.pp", b:search_path) " find an init.pp up or down
  endif 
  
  " find what we assume to be our module dir
  let b:module_path = fnamemodify(b:initpp, ":p:h:h") " full path to module name
  let b:module_name = fnamemodify(b:module_path, ":t") " just the module name

  " sub out the full path to the module with the name and replace slashes with ::
  let b:classpath = fnamemodify(expand("%:p:r"), ':s#' . b:module_path . '/manifests#' . b:module_name . '#'. ":gs?/?::?")

  " have to do this check twice so we have module_name defined
  if b:buffername == 'init.pp'
    let b:classname = b:module_name
    let b:classpath = b:module_name
  else
    let b:classname = expand("%:t:r")
  endif

  " if we don't start with a word we didn't replace the module_path 
  " probably b/c we couldn't find an init.pp / not a module
  " so we assume that root of the filename is the class (sane for throwaway
  " manifests
  if b:classpath =~ '^::'
    let b:classpath = b:classname
  endif
endfunction

if exists("g:puppet_module_detect")
  call s:SetModuleVars()
endif
