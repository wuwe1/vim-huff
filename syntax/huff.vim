if exists("b:current_syntax")
  finish
endif

syn match huffNumberDecimal "\v<\d+(\.\d+)?>"
syn match huffNumberHex "\v<0[xX][a-fA-F0-9]+>"
hi def link huffNumberDecimal Number
hi def link huffNumberHex Number

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

syn region huffComment start="//" end="$"
syn region huffComment start="/\*" end="\*/"
hi def link huffComment Comment

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

syn match huffDefine '#define' contained
syn keyword huffConstant constant contained
syn match huffConstantDef "\v#define\s+constant\s+[A-Za-z_]\w*" transparent contains=huffDefine,huffConstant
hi def link huffDefine Define
hi def link huffConstant Keyword

let b:current_syntax = "huff"
