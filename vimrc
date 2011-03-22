" map leader (defaults to \)
let mapleader = ','

" Variables for template interpolation
let email_address = "cmacleod@airdat.com"
let fullname = "Chris MacLeod"
let template_date_format_string = "%a %b %d %Y"

" pathogen is a plugin for managing plugins as bundles
filetype off
call pathogen#runtime_append_all_bundles()
call pathogen#helptags()  " generate helptag documentation for any existing bundles

" enable filetype and plugins
filetype on
filetype indent on
filetype plugin on 
filetype plugin indent on

" set options here
set ai			" auto indend
set si			" smart indent
set ff=unix		" file format unix dammit
set nocompatible	" nocompatible mode
set ruler		" ruler the bottom

set tabstop=2		" define what our tabs are
set expandtab           " expand tabs to spaces
set shiftwidth=2	" # of spaces for auto indent
set smarttab		" smart tab (shiftwidth v tabstop)
set tw=0		" no textwidth set by default
set modeline            " enable modelines
set modelines=1         " number of modelines to read
set tildeop 		" case change with movement rather than single char

set showmatch 		" show matching brackets
set mat=5 		" how many tenths of a second to blink matching brackets for

set hlsearch		" highlight search on by default

set noincsearch		" move curser as you type search terms
set autoread            " auto read in files that have changed underneath

" don't remove indents for comments
"inoremap # X#

" new stuff
" add \v to all searches to support regular perl style regex
nnoremap / /\v
vnoremap / /\v
cnoremap %s/ %s/\v

" map <space> to disable highlight easily
nnoremap <leader><space> :noh<cr>

" window settings and maps
nnoremap <leader>w :vnew<CR><C-w>l
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
set nomousefocus        " focus does not follow mouse
set wh=1 		" minimal number of lines used for the current window
set wmh=1 		" minimal number of lines used for any window
set equalalways 	" make all windows the same size when adding/removing windows
set splitbelow 		" a new window is put below the current one
set splitright 		" a new vertical window is right of the current one

" unmap F1 - stupid help key
inoremap <F1> <ESC>
nnoremap <F1> <ESC>
vnoremap <F1> <ESC>


" use white background in GUI-Mode, black on console
if has("gui_running")
    set bg=light
    syntax on
" trying default colouring see if it isn't too dark
"else
    "set bg=dark
endif


" turn on syntax if we are in a color terminal
if &t_Co > 1
    syntax on
endif

" allow the . to execute once for each line of a visual selection
vnoremap . :normal .<CR>

" xterm specifics
if &term == "xterm"
    set title
    set t_kb=
    fixdel
endif

" xterm specifics
if &term == "xterm-color"
    set title
    set t_kb=
    fixdel
endif
"
" set title for screen
if &term == "screen"
  set t_ts=k
  set t_fs=\
  set title
endif
set titlestring=%t%(\ %M%)%(\ (%{expand(\"%:~:.:h\")})%)%(\ %a%)
let &titleold=getcwd()

" Appends / insert current date
nmap <Leader>_d "=strftime("%Y-%m-%d")<CR>p
nmap <Leader>_D "=strftime("%Y%m%d")<CR>P

" surround maps
nmap <Leader>{ ysiw{
nmap <Leader>} ysiw}
nmap <Leader>" ysiw"
nmap <Leader>' ysiw'

" Paste mode
nnoremap <C-E>  :set invpaste paste?<CR>
set pastetoggle=<C-E>

" current edge version stuff
if v:version >= 703
  set norelativenumber " number the file based on relative position, neat but distracting 
  set noundofile " this creates undo droppings 
endif


" -------------------------------------
" GNUPG plugin settings
" -------------------------------------
let g:GPGPreferArmor = 1

" Comment settings
let NERDSpaceDelims = 1
let g:NERDCustomDelimiters = {
      \ 'puppet': { 'left': '#', 'leftAlt': '/*', 'rightAlt': '*/' }
      \ }
let NERDAllowAnyVisualDelims = 1
let NERDCompactSexyComs = 0
let NERDSexyComMarker = ""

" -------------------------------------
" Twiki plugin settings
" -------------------------------------
let g:Twiki_FoldAtHeadings = '0'
let g:Twiki_SourceHTMLSyntax = '1'
let g:Twiki_Functions = '1'
let g:Twiki_Mapings = '1'

" allow loose skeleton matching for templates
" ie init.pp (a puppet filetype) will match init_puppet
let g:EteSkeleton_loosefiletype = 1

" DNSTools
let g:dnstools_prompt_replacement = 0
