" Automatically create dir to write file to if it doesn't exist
function! AutoMkDir()
  let required_dir = expand("<afile>:p:h")
  if !isdirectory(required_dir)
    if confirm("Directory '" . required_dir . "' doesn't exist.", "&Abort\n&Create it") != 2
      bdelete
      return
    endif

    try
      call mkdir(required_dir, 'p')
    catch
      if confirm("Can't create '" . required_dir . "'", "&Abort\n&Continue anyway") != 2
        bdelete
        return
      endif
    endtry
  endif
endfunction

autocmd BufNewFile,BufWritePre * call AutoMkDir()
