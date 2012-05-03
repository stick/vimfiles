" map leader (defaults to \)
let mapleader = ','

" set colorscheme
if &t_Co >= 256 || has('gui_running')
  colorscheme ir_black
endif

" Variables for template interpolation
let email_address = "cmacleod@airdat.com"
let fullname = "Chris MacLeod"
let company_name = "Airdat LLC"
let template_date_format_string = "%a %b %d %Y"

" pathogen is a plugin for managing plugins as bundles
filetype off
call pathogen#runtime_append_all_bundles()
call pathogen#helptags()  " generate helptag documentation for any existing bundles

" enable filetype and plugins
filetype on
filetype indent on
filetype plugin on

" set options here
set ai           " auto indend
set si           " smart indent
set ff=unix      " file format unix dammit
set nocompatible " nocompatible mode
set ruler        " ruler the bottom

set expandtab     " expand tabs to spaces
set tabstop=2     " define what our tabs are
set softtabstop=2 " soft tabstop
set shiftwidth=2  " # of spaces for auto indent
set smarttab      " smart tab (shiftwidth v tabstop)
set tw=0          " no textwidth set by default
set modeline      " enable modelines
set modelines=1   " number of modelines to read
set tildeop       " case change with movement rather than single char

set showmatch       " show matching brackets
set matchtime=5     " how many tenths of a second to blink matching brackets for

set hlsearch    " highlight search on by default

set noincsearch   " move curser as you type search terms
set autoread            " auto read in files that have changed underneath
set shellcmdflag=-lc  " set the ! shell to be a login shell to get at functions and aliases

" settings requiring the latest vim
if version >= 703
  set colorcolumn=80    " highlight the 80th column
  set listchars=nbsp:¶,eol:¬,tab:>-,extends:»,precedes:«,trail:• " characters to use for 'specical' characters and non-printables
endif


" don't remove indents for comments
"inoremap # X#

" new stuff
" add \v to all searches to support regular perl style regex
nnoremap / /\v
vnoremap / /\v
cnoremap %s/ %s/\v

" map <space> to disable highlight easily
nnoremap <silent><leader><space> :noh<cr>

" window settings and maps
nnoremap <leader>w :vnew<CR><C-w>l
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
set nomousefocus        " focus does not follow mouse
" set wh=1    " minimal number of lines used for the current window
" set wmh=1     " minimal number of lines used for any window
" set equalalways   " make all windows the same size when adding/removing windows
set splitbelow    " a new window is put below the current one
set splitright    " a new vertical window is right of the current one

" unmap F1 - stupid help key
inoremap <F1> <ESC>
nnoremap <F1> <ESC>
vnoremap <F1> <ESC>

" map to remove trailing whitespace from lines
nnoremap <silent><leader>l :%s/\v\s+$//g<cr>
nnoremap <silent><Leader>i :set invlist<CR>

" reformats entire file based on current indent/syntax settings, then resets
" cursor to last position
noremap <silent><leader>k gg=G``

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  " Also don't do it when the mark is in the first line, that is the default
  " position when opening a file.
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  augroup END

else

  set autoindent    " always set autoindenting on

endif " has("autocmd")

" gui vs console settings
" gui settings go in ~/.gvimrc
if has("gui_running")
else
    "set bg=dark
endif

" turn on syntax if we are in a color terminal
if &t_Co > 1
    syntax on
endif

" allow the . to execute once for each line of a visual selection
vnoremap . :normal .<CR>

" xterm specifics
if &term =~ "xterm"
    set title
    set t_kb=
    fixdel
endif

" set title for screen use iconstring to set it correctly for tmux as well
if &term =~ "screen"
  set t_ts=]2;
  set t_fs=
  set title
  set t_IS=k
  set t_IE=\
  set icon
endif

set titlestring=%t%(\ %M%)%(\ (%{expand(\"%:~:.:h\")})%)%(\ %a%)
set iconstring=%t%(\ %M%)%(\ (%{expand(\"%:~:.:h\")})%)%(\ %a%)
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
nnoremap <C-E>  :silent! set invpaste<CR>
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

" set statusline to always be present see plugin/statusline.vim for actual
" setting of the statusline
set laststatus=2

" ctags
set tags=./tags;   " allows recursing upwards to project roots

" open vimrc in new vsplit for quick config changes
nmap <leader>v :tabnew ~/.vimrc<cr>:lcd ~/.vim<cr>
" auto source it on save
autocmd! bufwritepost .vimrc source %

" enable matchit which ships with vim but isn't turned on
source $VIMRUNTIME/macros/matchit.vim

" settings for taglist
let tlist_puppet_settings='puppet;c:class;d:define;s:site'
nnoremap <silent><leader>t :TlistToggle<CR>

" set supertab to do context based completion
let g:SuperTabDefaultCompletionType = "context"

" map the align command to align fat comma's, do need to visual select first
vmap <LEADER>= :Align =><CR>

" lazy git commit
nmap <LEADER>g :Gcommit<CR>

" map for syntastic errors window
nnoremap <LEADER>e :Errors<CR>

" autoclose syntastic's error windown when no errors
let g:syntastic_auto_loc_list=2

" enable puppet module detection
let g:puppet_module_detect=1

" split window movement mappings
nmap <silent> <A-Up> :wincmd k<CR>
nmap <silent> <A-Down> :wincmd j<CR>
nmap <silen> <A-Left> :wincmd h<CR>
nmap <silent> <A-Right> :wincmd l<CR>
