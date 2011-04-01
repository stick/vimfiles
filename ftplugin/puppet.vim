" set keyword program
setlocal keywordprg=pi
" add : <colon> as a word keyword
" this affects w/W but importantly allows you tag jump off something like ssh::server::addkey 
" use += to add to the normal entry so we don't mess with defaults
setlocal iskeyword+=:
