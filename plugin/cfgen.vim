" $Id: cfgen.vim,v 1.21 2003/09/10 20:15:10 damorep Exp $
"
" Vim syntax file
" Language:     CfGen Template
" Maintainer:   Phil D'Amore <damorep@redhat.com>
" Last Change:  2003 Jun  4
" Remark:       Provides useful coloring for CfGen templates
"
" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

" CfGen template elements are case sensitive
syn case match
syn sync minlines=100

syn keyword cfgenSingleTag contained STRUCTURAL EXPLODE_AS
syn keyword cfgenErrorControlTag contained WARN ERROR
syn keyword cfgenBlockTag  contained CZONE UZONE ZONE NOZONE CFGEN NOCFGEN
syn keyword cfgenTabooTag  contained FORK
syn keyword cfgenXXX       contained XXX
syn keyword cfgenFunction  contained host file get_fqdn get_outfilebase get_path net_gethostbyname net_gethostbyaddr net_calcnet net_calcbcast net_prefix2dotted net_dotted2prefix nextgroup=cfgenFuncArgRegion
" cfgenNOTE is for use in comments.  Needs match because of the ':'
syn match cfgenNOTE     "NOTE:"he=e-1  contained
syn match cfgenTODO     "TODO:"he=e-1  contained
"
" NOTE: The cfgenCondTag used to be defined here but is now done
" in a match below so we can single them out to have their args processed
" differently.
"
" Temporarily forget about case here because unlike most of cfgen,
" boolean tokens are not case sensitive
syn case ignore
syn keyword cfgenBool      contained and or not
syn case match

syn match cfgenBadTag   "\k\+"  contained
syn match cfgenTagArg   ".\+"  contained
" For some reason, the above match overrides the cfgenBool keywords in a
" CondArgRegion, but the pattern below does not, even though the characters
" in a cfgenBool would be matched by either of them.  Even wierder, since
" keywords are supposed to take precidence over matches. grrrrr...
syn match cfgenCondTagArg   "\i\+"  contained
syn match cfgenTagStart "^@@"   nextgroup=cfgenNormalTagCheck,cfgenCondTag,cfgenIncludeTag
syn match cfgenNormalTagCheck  "\k\+" contained contains=@cfgenTagGroup nextgroup=cfgenTagArgRegion
syn match cfgenCondTag    "IF " contained nextgroup=cfgenCondArgRegion skipwhite
syn match cfgenCondTag    "ELSIF " contained nextgroup=cfgenCondArgRegion skipwhite
syn match cfgenCondTag    "ELSE$" contained
syn match cfgenCondTag    "ENDIF$" contained
syn match cfgenIncludeTag "INCLUDE " contained nextgroup=cfgenVarTagArgRegion skipwhite
syn cluster cfgenTagGroup contains=cfgenBlockTag,cfgenSingleTag,cfgenErrorControlTag,cfgenTabooTag,cfgenBadTag

syn region cfgenTagArgRegion   start="."  end="$" contained contains=cfgenTagArg
syn region cfgenVarTagArgRegion   start="."  end="$" contained contains=cfgenVarStart

syn region cfgenCondArgRegion start="." end="$" contained contains=cfgenCondTagArg,cfgenBool,cfgenFunction

syn match cfgenVarStart /\${/ contains=cfgenVarRegion
syn region cfgenVarRegion start=/{/ end=/}/ contained contains=cfgenFunction,cfgenVarStart,cfgenVarRegion

syn region cfgenFuncArgRegion matchgroup=Ignore start=/(/ end=/)/ contained contains=cfgenVarStart


" EVAL blocks are always perl.  Make stuff inside a block highlight
" as if it was perl...because it is perl.
syn include @Perl $VIMRUNTIME/syntax/perl.vim
syn region cfgenEval matchgroup=cfgenBlockTag start=/^@@EVAL\>/ end=/^@@NOEVAL\>/ contains=@Perl
" Comments
syn region cfgenComment start=/^@@COMMENT/ end=/^@@NOCOMMENT/ contains=cfgenXXX,cfgenNOTE,cfgenTODO
syn region cfgenLineComment start=/^@@#/ end=/$/ contains=cfgenXXX,cfgenNOTE,cfgenTODO
" Hoghlight literal text as it was one big literal string.
syn region cfgenLiteral start=/^@@LITERAL/ end=/^@@NOLITERAL/

" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_cfgen_syn_inits")
    if version < 508
        let did_cfgen_syn_inits = 1
        command -nargs=+ HiLink hi link <args>
    else
        command -nargs=+ HiLink hi def link <args>
    endif

    HiLink cfgenTagStart        Identifier 
    HiLink cfgenSingleTag       Identifier
    HiLink cfgenErrorControlTag Exception
    HiLink cfgenBlockTag        Identifier
    HiLink cfgenVarRegion       Identifier
    HiLink cfgenVarStart        Identifier
    HiLink cfgenIncludeTag      Include
    HiLink cfgenCondTag         Conditional
    HiLink cfgenTabooTag        Todo
    HiLink cfgenXXX             Todo
    HiLink cfgenTODO            Todo
    HiLink cfgenNOTE            SpecialComment
    HiLink cfgenBool            Conditional
    HiLink cfgenTagArg          String
    HiLink cfgenCondTagArg      String
    HiLink cfgenBadTag          Error
    HiLink cfgenComment         Comment
    HiLink cfgenLineComment     Comment
    HiLink cfgenLiteral         String
    HiLink cfgenFunction        Type
    HiLink cfgenFuncArgRegion   String

    delcommand HiLink
endif

let b:current_syntax = "cfgen"

