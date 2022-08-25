if exists("b:current_syntax")
  finish
endif

" comment
syn region huffComment start="//" end="$"
syn region huffComment start="/\*" end="\*/"
hi def link huffComment Comment

" natspec
syn match huffNatspecTag "\v\@title>" contained
syn match huffNatspecTag "\v\@author>" contained
syn match huffNatspecTag "\v\@notice>" contained
syn match huffNatspecTag "\v\@dev>" contained
syn match huffNatspecTag "\v\@param>" contained
syn match huffNatspecTag "\v\@return>" contained
syn region huffNatspec start="/\*\*" end="\*/" contains=huffNatspecTag
syn region huffNatspec start="///" end="$" contains=huffNatspecTag
hi def link huffNatspec Comment
hi def link huffNatspecTag Keyword

" import
syn match huffInclude "\v#include>"
hi def link huffInclude Include

" number literal
syn match huffNumberDecimal "\v<\d+(\.\d+)?>"
syn match huffNumberHex "\v<0[xX][a-fA-F0-9]+>"
hi def link huffNumberDecimal Number
hi def link huffNumberHex Number

" define
syn match huffDefine '#define' contained
syn keyword huffMacro macro contained
syn keyword huffFn fn contained
syn keyword huffJumptable jumptable contained
syn keyword huffJumptablePacked jumptable__packed contained
syn keyword huffError error contained
syn keyword huffFunction function contained
syn keyword huffEvent event contained
syn keyword huffConstant constant contained
syn keyword huffTakes takes contained
syn keyword huffReturns returns contained
hi def link huffDefine Define
hi def link huffMacro Keyword
hi def link huffFn Keyword
hi def link huffJumptable Keyword
hi def link huffJumptablePacked Keyword
hi def link huffError Keyword
hi def link huffFunction Keyword
hi def link huffEvent Keyword
hi def link huffConstant Keyword
hi def link huffTakes Keyword
hi def link huffReturns Keyword

syn match huffIdentifier "\v\i" contained
hi def link huffIdentifier Identifier

syn match huffInterfacePrimitives "\v<(address|string\d*|bytes\d*|int\d*|uint\d*|bool|hash\d*)>" contained
hi def link huffInterfacePrimitives Type

syn match huffDeclMacro "\v#define\s+macro\s+\i+\s*\((\i+(,\s*\i+)*)?\)\s*\=\s*takes\s*\(\d+\)\s*returns\s*\(\d+\)" transparent contains=huffDefine,huffMacro,huffIdentifier,huffTakes,huffReturns
syn match huffDeclFn "\v#define\s+fn\s+\i+\s*\((\i+(,\s*\i+)*)?\)\s*\=\s*takes\s*\(\d+\)\s*returns\s*\(\d+\)" transparent contains=huffDefine,huffFn,huffIdentifier,huffTakes,huffReturns
syn match huffDeclJumptable "\v#define\s+jumptable(__packed)?\s+\i+>" transparent contains=huffDefine,huffJumtable,huffJumptablePacked,huffIdentifier
syn match huffConstantDef "\v#define\s+constant\s+[A-Za-z_]\w*" transparent contains=huffDefine,huffConstant,huffIdentifier,huffTakes,huffReturns
syn match huffDefError "\v#define\s+error\s+\i+>" transparent contains=huffDefine,huffError,huffIdentifier
syn match huffInterfaceFunction "\v#define\s+function\s+\i+\(.*\)" transparent contains=huffDefine,huffFunction,huffIdentifier,huffInterfacePrimitives
syn match huffInterfaceEvent "\v#define\s+event\s+\i+\(.*\)" transparent contains=huffDefine,huffEvent,huffIdentifier,huffInterfacePrimitives

" opcodes
syn keyword huffOpcodesIO sstore sload mstore8 mstore mload pop msize balance address returndatacopy returndatasize extcodecopy extcodesize gasprice caller origin gaslimit difficulty number timestamp coinbase blockhash codecopy codesize calldatacopy calldatasize calldataload callvalue gas 
syn keyword huffOpcodesSideEffects log4 log3 log2 log1 log0 jumpdest getpc jumpi jump create2 staticcall delegatecall callcode call create 
syn keyword huffOpcodesCalculation not xor or and ror rol sar shr shl keccak sha3 byte iszero eq sgt slt gt lt signextend exp mulmod addmod smod mod sdiv div sub mul add 
syn keyword huffOpcodesStop selfdestruct invalid revert return stop 
syn match huffOpcodesStack "\v(swap1|dup1)[0-6]" 
syn match huffOpcodesStack "\v(swap|dup)[1-9]" 
syn match huffOpcodesStack "\vpush3[0-2]|push[1-2][0-9]|push[1-9]" 
hi def link huffOpcodesIO Keyword
hi def link huffOpcodesSideEffects Keyword
hi def link huffOpcodesCalculation Keyword
hi def link huffOpcodesStop Keyword
hi def link huffOpcodesStack Keyword

syn match huffTemplateCall "\v\<\s*\i+\s*\>" transparent contains=huffIdentifier
syn match huffConstantRef "\v\[[A-Z_]+\]" transparent contains=huffIdentifier

let b:current_syntax = "huff"
