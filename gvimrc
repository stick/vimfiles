" -----------------------------------------------------------------------------
" |                            VIM Settings                                   |
" |                              GUI stuff                                    |
" -----------------------------------------------------------------------------
set guioptions-=T  " remove toolbar
set guioptions-=r  " remove right side scroll bar


" OS Specific *****************************************************************
if has("gui_macvim")

  set fuoptions=maxvert,maxhorz " fullscreen options (MacVim only), resized window when changed to fullscreen
  set guifont=Menlo\ Bold:h12
  set stal=2 " turn on tabs by default


elseif has("gui_gtk2")

  set guifont=Monaco

elseif has("x11")
elseif has("gui_win32")
end

" General *********************************************************************
set anti " Antialias font

"set transparency=0

" Default size of window
set columns=179
set lines=50

" Tab headings
set gtl=%t gtt=%F

highlight Normal guifg=white guibg=black
