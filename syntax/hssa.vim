" Vim syntax file
" Language:    HSSA (Hybrid Static Single Assignment) — a reversible-computing IR
" Maintainer:  drop-in plugin
" Filenames:   *.hssa
"
" Grammar reference: the HSSA reference parser
"   (de.thm.mni.hybridcomputing.hssa.parsing.{Lexing,Parsing} + Syntax).
" A program is a sequence of relations:
"   rel name param1 param2:
"     <outputs> := <block-label> <-            " block entry
"       <outputs> := <op> <params> =: <inputs>   " assignment / call
"       -> <block-label> =: <inputs>           " block exit / jump
" The four multi-char operators := =: -> <- are the backbone of the language.
" A leading ~ inverts an operation; begin/end are the distinguished entry/exit
" block labels.
"
" NOTE on ordering: when two `syn match` items match at the same column, Vim
" uses the one defined LATER (higher priority), regardless of match length.
" We therefore define the generic/short patterns first (identifiers, single-char
" punctuation) and the specific, multi-char overrides afterwards so they win.

if exists("b:current_syntax")
  finish
endif

let s:cpo_save = &cpo
set cpo&vim

" --- Keywords (syn keyword always beats syn match, order-independent) ---------
syn keyword hssaKeyword rel import
syn keyword hssaSpecialLabel begin end

syn keyword hssaBuiltin add sub subfrom mul euclidiv
syn keyword hssaBuiltin dup id discard
syn keyword hssaBuiltin less greater lessequal greaterequal equal notequal
syn keyword hssaBuiltin and or xor

" --- Generic matches (defined FIRST, so specific overrides below win) ---------
" HSSA identifiers are [a-zA-Z_.][a-zA-Z_0-9.]* — SSA suffixes like v.1, _m.0,
" heap.2 are a single identifier token with a dotted numeric suffix.
syn match hssaIdentifier "\<[a-zA-Z_][a-zA-Z_0-9]*\%(\.[0-9]\+\)*\>"

syn match hssaDelimiter "[,:]"
syn match hssaParen     "[()\[\]]"

" --- Specific overrides (defined LATER, so they take precedence) --------------

" Dotted builtins: memory / tests / arrays. '.' is not a keyword char, so match.
syn match hssaBuiltin "\<mmem\.\%(new\|allocate\|readwrite\|read\)\>"
syn match hssaBuiltin "\<tests\.\%(fail\|assert\)\>"
syn match hssaBuiltin "\<array\.\w\+\>"

" The empty unit value () — override the two parens.
syn match hssaUnit "()"

" The four backbone operators.  := assign/output, =: input (distinct, must not
" clobber each other), -> block exit / jump, <- block entry.  None of the
" characters :=-<> are regex metacharacters here.
syn match hssaAssign ":="
syn match hssaAssign "=:"
syn match hssaArrow  "->"
syn match hssaArrow  "<-"

" Special prefix operators.
"   ~  inversion prefix  (~euclidiv, ~dup, ~mmem.new, ~buddy_alloc)
"   '  experimental inline-duplicate expression prefix ('x)
syn match hssaInvert    "\~"
syn match hssaDuplicate "'\ze\w"

" Integer literals (optional leading minus) and 'c' character literals.
syn match hssaNumber "-\?\<[0-9]\+\>"
syn match hssaChar   "'.'"

" Comments.  Only // line comments (defined last — comments always win).  In the
" real language only full-line comments are legal, but for editing convenience
" we highlight //... to end-of-line anywhere.
syn match hssaComment "//.*$" contains=@Spell

" Relation definition: highlight the name right after `rel` as a function.
syn match hssaRelationName "\%(\<rel\s\+\)\@<=\~\?[A-Za-z_][A-Za-z_0-9]*"

" --- Default highlight links -------------------------------------------------
hi def link hssaComment       Comment
hi def link hssaKeyword       Keyword
hi def link hssaSpecialLabel  Special
hi def link hssaBuiltin       Function
hi def link hssaAssign        Operator
hi def link hssaArrow         Operator
hi def link hssaInvert        Special
hi def link hssaDuplicate     Special
hi def link hssaNumber        Number
hi def link hssaChar          Character
hi def link hssaUnit          Constant
hi def link hssaDelimiter     Delimiter
hi def link hssaParen         Delimiter
hi def link hssaIdentifier    Identifier
hi def link hssaRelationName  Function

let b:current_syntax = "hssa"

let &cpo = s:cpo_save
unlet s:cpo_save
