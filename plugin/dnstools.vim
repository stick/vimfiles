" DNS Serial Incrementer
" Author: Folke Ashberg <folke@ashberg.de>
" Copyright: 2001 by Folke Ashberg
" LAST MODIFICATION: Fri Aug 15 2003
" MODIFIED BY: Chris MacLeod <stick@miscellaneous.net>
" Usage:
"         Serial Updater:
"         Just execute the command DNSserial and this tiny script
"         will increment the serial number, preserving that style you use :)



function DNS_getnum(oldnum)
    let oldnum = a:oldnum
    if oldnum < 19700101
	" 1, 2, 3 style
	let retval = oldnum + 1
    elseif oldnum < 1970010100
	" YYYYMMDD style
	let dateser = strftime("%Y%m%d")
	if dateser > oldnum
	    let retval = dateser
	else
	    let retval = oldnum + 1
	endif
    else
	" YYYYMMDDNN style
	let dateser = strftime("%Y%m%d00")
	if dateser > oldnum
	    let retval = dateser
	else
	    let retval = oldnum + 1
	endif
    endif
    return retval
endfun

function DNSserial()
    let restore_position_excmd = line('.').'normal! '.virtcol('.').'|'
    let oldignorecase = &ignorecase
    set ignorecase
    " substitute now ( there's a bug in VIM's vi Syntax :(   )
    silent! %s/\([[:space:]]\)\([0-9]\+\)\([[:space:]]\+\;[[:space:]]Serial.*\)$/\=submatch(1) . DNS_getnum( submatch(2) ) . submatch(3)/
    " restore position 
    exe restore_position_excmd
    " disable hls
    if 1 == &hls
	noh
    else
	set hls
    endif
    " restore old case behave
    let &ignorecase=oldignorecase
endfun

command DNSserial :call DNSserial()

command DNSzone :cal DNSzone()


function DNSzone()
    let zone = input("Name of Zone: ")
    let ip   = input("IP: " , "127.0.0.1")
    let ins=""
    let ins = ins . ";       File: \"db." . zone . "\"\n"
    let ins = ins . ";       FQDN: \"" . zone . "\"\n"
    let ins = ins . "@       3600 IN SOA ns.miscellaneous.net. hostmaster.miscellaneous.net. (\n"
    let ins = ins . "                " . strftime("%Y%m%d00") . "      ; Serial number\n"
    let ins = ins . "                3H              ; refresh\n"
    let ins = ins . "                1H              ; retry\n"
    let ins = ins . "                1W              ; expiry\n"
    let ins = ins . "                1D )            ; minimum\n"
    let ins = ins . "\n"
    let ins = ins . ";        Zone NS records\n"
    let ins = ins . "\n"
    let ins = ins . "@                               IN      NS      ns1.miscellaneous.net.\n"
    let ins = ins . "@                               IN      NS      ns2.miscellaneous.net.\n"
    let ins = ins . "\n"
    let ins = ins . ";        Zone MX records\n"
    let ins = ins . "\n"
    let ins = ins . "@                               IN      MX      30      mail\n"
    let ins = ins . "@                               IN      MX      60      mail.webjack.net.\n"
    let ins = ins . "\n"
    let ins = ins . ";        Zone records\n"
    let ins = ins . "\n"
    let ins = ins . "                                IN      A       " . ip ."\n"
    let ins = ins . "mail                            IN      A       " . ip ."\n"
    let ins = ins . "www                             IN      CNAME   " . zone . ".\n"
    let ins = ins . "ftp                             IN      CNAME   " . zone . ".\n"
    let ins = ins . "smtp                            IN      CNAME   " . zone . ".\n"
    let ins = ins . "\n"
    put!=ins
endfun
