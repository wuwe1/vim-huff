fu! evm#lookup#Lookup(op)
  if !exists('g:evm_asm_table.' . a:op)
    echom a:op . ' not found'
  else
    let l:v = get(g:evm_asm_table, a:op)
    let l:winnr = bufwinnr('EVM_LOOKUP')
    if l:winnr ==# -1
      split EVM_LOOKUP
      normal! ggdG
      setlocal filetype=evmlookup
      setlocal buftype=nofile
      setlocal bufhidden=delete
      setlocal noswapfile
      setlocal nobuflisted
      setlocal nocursorline nocursorcolumn
      syn match evmLookupOpcode '\v^\[\zs0x[A-Fa-f0-9]+\ze\]' 
            \ nextgroup=evmLookupName
      syn match evmLookupName '\v\s+\zs\i+\ze\(' 
            \ nextgroup=evmLookupInput
      syn match evmLookupInput '\v\(\zs.*\ze\)$'
      syn match evmlookupOutput '\v^\s+-\>\zs.*\ze$'
      hi link evmLookupOpcode Number
      hi link evmLookupName Define
      hi link evmLookupInput Identifier
      hi link evmLookupOutput Type
    else
      execute l:winnr . 'wincmd w'
    endif

    let l:winw = winwidth('.')

    setlocal modifiable
    let l:content = []
    call add(l:content,
          \ '[0x' . l:v.opcode . '] ' 
          \ . a:op 
          \ . '(' . l:v.input . ')')
    call add(l:content, '  -> ' . l:v.output)
    call add(l:content, l:v.desc)
    normal! ggdG
    call append(0, l:content)
    silent $delete
    setlocal nomodifiable
    execute 'resize 3'
    silent normal! gg
    " close easily with enter and q
    noremap <buffer> <silent> <CR> :<C-U>close<CR>
    noremap <buffer> <silent> q :<C-U>close<CR>
  endif
endfu

let g:evm_asm_table = {
\  "lt": {
\    "opcode": "10",
\    "desc": "Less-than comparison",
\    "input": "a | b",
\    "output": "a < b"
\  },
\  "gt": {
\    "opcode": "11",
\    "desc": "Greater-than comparison",
\    "input": "a | b",
\    "output": "a > b"
\  },
\  "slt": {
\    "opcode": "12",
\    "desc": "Signed less-than comparison",
\    "input": "a | b",
\    "output": "a < b"
\  },
\  "sgt": {
\    "opcode": "13",
\    "desc": "Signed greater-than comparison",
\    "input": "a | b",
\    "output": "a > b"
\  },
\  "eq": {
\    "opcode": "14",
\    "desc": "Equality comparison",
\    "input": "a | b",
\    "output": "a == b"
\  },
\  "iszero": {
\    "opcode": "15",
\    "desc": "Simple not operator",
\    "input": "a",
\    "output": "a == 0"
\  },
\  "and": {
\    "opcode": "16",
\    "desc": "Bitwise AND operation",
\    "input": "a | b",
\    "output": "a & b"
\  },
\  "origin": {
\    "opcode": "32",
\    "desc": "Get execution origination address",
\    "input": "",
\    "output": "address"
\  },
\  "or": {
\    "opcode": "17",
\    "desc": "Bitwise OR operation",
\    "input": "a | b",
\    "output": "a \\| b"
\  },
\  "xor": {
\    "opcode": "18",
\    "desc": "Bitwise XOR operation",
\    "input": "a | b",
\    "output": "a ^ b"
\  },
\  "not": {
\    "opcode": "19",
\    "desc": "Bitwise NOT operation",
\    "input": "a",
\    "output": "~a"
\  },
\  "sha3": {
\    "opcode": "20",
\    "desc": "Compute Keccak-256 hash",
\    "input": "offset | size",
\    "output": "hash"
\  },
\  "address": {
\    "opcode": "30",
\    "desc": "Get address of currently executing account",
\    "input": "",
\    "output": "address"
\  },
\  "balance": {
\    "opcode": "31",
\    "desc": "Get balance of the given account",
\    "input": "address",
\    "output": "balance"
\  },
\  "caller": {
\    "opcode": "33",
\    "desc": "Get caller address",
\    "input": "",
\    "output": "address"
\  },
\  "callvalue": {
\    "opcode": "34",
\    "desc": "Get deposited value by the instruction/transaction responsible for this execution",
\    "input": "",
\    "output": "value"
\  },
\  "calldataload": {
\    "opcode": "35",
\    "desc": "Get input data of current environment",
\    "input": "i",
\    "output": "data[i]"
\  },
\  "calldatasize": {
\    "opcode": "36",
\    "desc": "Get size of input data in current environment",
\    "input": "",
\    "output": "size"
\  },
\  "calldatacopy": {
\    "opcode": "37",
\    "desc": "Copy input data in current environment to memory",
\    "input": "destOffset | offset | size",
\    "output": ""
\  },
\  "codesize": {
\    "opcode": "38",
\    "desc": "Get size of code running in current environment",
\    "input": "",
\    "output": "size"
\  },
\  "codecopy": {
\    "opcode": "39",
\    "desc": "Copy code running in current environment to memory",
\    "input": "destOffset | offset | size",
\    "output": ""
\  },
\  "basefee": {
\    "opcode": "48",
\    "desc": "Get the base fee",
\    "input": "",
\    "output": "baseFee"
\  },
\  "blockhash": {
\    "opcode": "40",
\    "desc": "Get the hash of one of the 256 most recent complete blocks",
\    "input": "blockNumber",
\    "output": "hash"
\  },
\  "coinbase": {
\    "opcode": "41",
\    "desc": "Get the block’s beneficiary address",
\    "input": "",
\    "output": "address"
\  },
\  "timestamp": {
\    "opcode": "42",
\    "desc": "Get the block’s timestamp",
\    "input": "",
\    "output": "timestamp"
\  },
\  "number": {
\    "opcode": "43",
\    "desc": "Get the block’s number",
\    "input": "",
\    "output": "blockNumber"
\  },
\  "difficulty": {
\    "opcode": "44",
\    "desc": "Get the block’s difficulty",
\    "input": "",
\    "output": "difficulty"
\  },
\  "prevrandao": {
\    "opcode": "44",
\    "desc": "Get the block’s difficulty",
\    "input": "",
\    "output": "difficulty"
\  },
\  "gaslimit": {
\    "opcode": "45",
\    "desc": "Get the block’s gas limit",
\    "input": "",
\    "output": "gasLimit"
\  },
\  "chainid": {
\    "opcode": "46",
\    "desc": "Get the chain ID",
\    "input": "",
\    "output": "chainId"
\  },
\  "selfbalance": {
\    "opcode": "47",
\    "desc": "Get balance of currently executing account",
\    "input": "",
\    "output": "balance"
\  },
\  "pop": {
\    "opcode": "50",
\    "desc": "Remove item from stack",
\    "input": "y",
\    "output": ""
\  },
\  "mload": {
\    "opcode": "51",
\    "desc": "Load word from memory",
\    "input": "offset",
\    "output": "value"
\  },
\  "mstore8": {
\    "opcode": "53",
\    "desc": "Save byte to memory",
\    "input": "offset | value",
\    "output": ""
\  },
\  "mstore": {
\    "opcode": "52",
\    "desc": "Save word to memory",
\    "input": "offset | value",
\    "output": ""
\  },
\  "sload": {
\    "opcode": "54",
\    "desc": "Load word from storage",
\    "input": "key",
\    "output": "value"
\  },
\  "sstore": {
\    "opcode": "55",
\    "desc": "Save word to storage",
\    "input": "key | value",
\    "output": ""
\  },
\  "jumpdest": {
\    "opcode": "5b",
\    "desc": "Mark a valid destination for jumps",
\    "input": "",
\    "output": ""
\  },
\  "jumpi": {
\    "opcode": "57",
\    "desc": "Conditionally alter the program counter",
\    "input": "counter | b",
\    "output": ""
\  },
\  "jump": {
\    "opcode": "56",
\    "desc": "Alter the program counter",
\    "input": "counter",
\    "output": ""
\  },
\  "pc": {
\    "opcode": "58",
\    "desc": "Get the value of the program counter prior to the increment corresponding to this instruction",
\    "input": "",
\    "output": "counter"
\  },
\  "msize": {
\    "opcode": "59",
\    "desc": "Get the size of active memory in bytes",
\    "input": "",
\    "output": "size"
\  },
\  "stop": {
\    "opcode": "00",
\    "desc": "Halts execution",
\    "input": "",
\    "output": ""
\  },
\  "addmod": {
\    "opcode": "08",
\    "desc": "Modulo addition operation",
\    "input": "a | b | N",
\    "output": "(a + b) % N"
\  },
\  "add": {
\    "opcode": "01",
\    "desc": "Addition operation",
\    "input": "a | b",
\    "output": "a + b"
\  },
\  "mulmod": {
\    "opcode": "09",
\    "desc": "Modulo multiplication operation",
\    "input": "a | b | N",
\    "output": "(a * b) % N"
\  },
\  "mul": {
\    "opcode": "02",
\    "desc": "Multiplication operation",
\    "input": "a | b",
\    "output": "a * b"
\  },
\  "sub": {
\    "opcode": "03",
\    "desc": "Subtraction operation",
\    "input": "a | b",
\    "output": "a - b"
\  },
\  "div": {
\    "opcode": "04",
\    "desc": "Integer division operation",
\    "input": "a | b",
\    "output": "a // b"
\  },
\  "sdiv": {
\    "opcode": "05",
\    "desc": "Signed integer division operation (truncated)",
\    "input": "a | b",
\    "output": "a // b"
\  },
\  "mod": {
\    "opcode": "06",
\    "desc": "Modulo remainder operation",
\    "input": "a | b",
\    "output": "a % b"
\  },
\  "smod": {
\    "opcode": "07",
\    "desc": "Signed modulo remainder operation",
\    "input": "a | b",
\    "output": "a % b"
\  },
\  "exp": {
\    "opcode": "0a",
\    "desc": "Exponential operation",
\    "input": "a | exponent",
\    "output": "a ** exponent"
\  },
\  "signextend": {
\    "opcode": "0b",
\    "desc": "Extend length of two’s complement signed integer",
\    "input": "b | x",
\    "output": "y"
\  },
\  "byte": {
\    "opcode": "1a",
\    "desc": "Retrieve single byte from word",
\    "input": "i | x",
\    "output": "y"
\  },
\  "shl": {
\    "opcode": "1b",
\    "desc": "Left shift operation",
\    "input": "shift | value",
\    "output": "value << shift"
\  },
\  "shr": {
\    "opcode": "1c",
\    "desc": "Logical right shift operation",
\    "input": "shift | value",
\    "output": "value >> shift"
\  },
\  "sar": {
\    "opcode": "1d",
\    "desc": "Arithmetic (signed) right shift operation",
\    "input": "shift | value",
\    "output": "value >> shift"
\  },
\  "gasprice": {
\    "opcode": "3a",
\    "desc": "Get price of gas in current environment",
\    "input": "",
\    "output": "price"
\  },
\  "extcodesize": {
\    "opcode": "3b",
\    "desc": "Get size of an account’s code",
\    "input": "address",
\    "output": "size"
\  },
\  "extcodecopy": {
\    "opcode": "3c",
\    "desc": "Copy an account’s code to memory",
\    "input": "address | destOffset | offset | size",
\    "output": ""
\  },
\  "returndatasize": {
\    "opcode": "3d",
\    "desc": "Get size of output data from the previous call from the current environment",
\    "input": "",
\    "output": "size"
\  },
\  "returndatacopy": {
\    "opcode": "3e",
\    "desc": "Copy output data from the previous call to memory",
\    "input": "destOffset | offset | size",
\    "output": ""
\  },
\  "extcodehash": {
\    "opcode": "3f",
\    "desc": "Get hash of an account’s code",
\    "input": "address",
\    "output": "hash"
\  },
\  "gas": {
\    "opcode": "5a",
\    "desc": "Get the amount of available gas, including the corresponding reduction for the cost of this instruction",
\    "input": "",
\    "output": "gas"
\  },
\  "log0": {
\    "opcode": "a0",
\    "desc": "Append log record with no topics",
\    "input": "offset | size",
\    "output": ""
\  },
\  "log1": {
\    "opcode": "a1",
\    "desc": "Append log record with one topic",
\    "input": "offset | size | topic",
\    "output": ""
\  },
\  "log2": {
\    "opcode": "a2",
\    "desc": "Append log record with two topics",
\    "input": "offset | size | topic1 | topic2",
\    "output": ""
\  },
\  "log3": {
\    "opcode": "a3",
\    "desc": "Append log record with three topics",
\    "input": "offset | size | topic1 | topic2 | topic3",
\    "output": ""
\  },
\  "log4": {
\    "opcode": "a4",
\    "desc": "Append log record with four topics",
\    "input": "offset | size | topic1 | topic2 | topic3 | topic4",
\    "output": ""
\  },
\  "create2": {
\    "opcode": "f5",
\    "desc": "Create a new account with associated code at a predictable address",
\    "input": "value | offset | size | salt",
\    "output": "address"
\  },
\  "create": {
\    "opcode": "f0",
\    "desc": "Create a new account with associated code",
\    "input": "value | offset | size",
\    "output": "address"
\  },
\  "callcode": {
\    "opcode": "f2",
\    "desc": "Message-call into this account with alternative account’s code",
\    "input": "gas | address | value | argsOffset | argsSize | retOffset | retSize",
\    "output": "success"
\  },
\  "call": {
\    "opcode": "f1",
\    "desc": "Message-call into an account",
\    "input": "gas | address | value | argsOffset | argsSize | retOffset | retSize",
\    "output": "success"
\  },
\  "return": {
\    "opcode": "f3",
\    "desc": "Halt execution returning output data",
\    "input": "offset | size",
\    "output": ""
\  },
\  "delegatecall": {
\    "opcode": "f4",
\    "desc": "Message-call into this account with an alternative account’s code, but persisting the current values for sender and value",
\    "input": "gas | address | argsOffset | argsSize | retOffset | retSize",
\    "output": "success"
\  },
\  "staticcall": {
\    "opcode": "fa",
\    "desc": "Static message-call into an account",
\    "input": "gas | address | argsOffset | argsSize | retOffset | retSize",
\    "output": "success"
\  },
\  "revert": {
\    "opcode": "fd",
\    "desc": "Halt execution reverting state changes but returning data and remaining gas",
\    "input": "offset | size",
\    "output": ""
\  },
\  "invalid": {
\    "opcode": "fe",
\    "desc": "Designated invalid instruction",
\    "input": "",
\    "output": ""
\  },
\  "selfdestruct": {
\    "opcode": "ff",
\    "desc": "Halt execution and register account for later deletion",
\    "input": "address",
\    "output": ""
\  },
\  "push32": {
\    "opcode": "7f",
\    "desc": "Place 32 byte (full word) item on stack",
\    "input": "",
\    "output": "value"
\  },
\  "push31": {
\    "opcode": "7e",
\    "desc": "Place 31 byte item on stack",
\    "input": "",
\    "output": "value"
\  },
\  "push30": {
\    "opcode": "7d",
\    "desc": "Place 30 byte item on stack",
\    "input": "",
\    "output": "value"
\  },
\  "push29": {
\    "opcode": "7c",
\    "desc": "Place 29 byte item on stack",
\    "input": "",
\    "output": "value"
\  },
\  "push28": {
\    "opcode": "7b",
\    "desc": "Place 28 byte item on stack",
\    "input": "",
\    "output": "value"
\  },
\  "push27": {
\    "opcode": "7a",
\    "desc": "Place 27 byte item on stack",
\    "input": "",
\    "output": "value"
\  },
\  "push26": {
\    "opcode": "79",
\    "desc": "Place 26 byte item on stack",
\    "input": "",
\    "output": "value"
\  },
\  "push25": {
\    "opcode": "78",
\    "desc": "Place 25 byte item on stack",
\    "input": "",
\    "output": "value"
\  },
\  "push24": {
\    "opcode": "77",
\    "desc": "Place 24 byte item on stack",
\    "input": "",
\    "output": "value"
\  },
\  "push23": {
\    "opcode": "76",
\    "desc": "Place 23 byte item on stack",
\    "input": "",
\    "output": "value"
\  },
\  "push22": {
\    "opcode": "75",
\    "desc": "Place 22 byte item on stack",
\    "input": "",
\    "output": "value"
\  },
\  "push21": {
\    "opcode": "74",
\    "desc": "Place 21 byte item on stack",
\    "input": "",
\    "output": "value"
\  },
\  "push20": {
\    "opcode": "73",
\    "desc": "Place 20 byte item on stack",
\    "input": "",
\    "output": "value"
\  },
\  "push19": {
\    "opcode": "72",
\    "desc": "Place 19 byte item on stack",
\    "input": "",
\    "output": "value"
\  },
\  "push18": {
\    "opcode": "71",
\    "desc": "Place 18 byte item on stack",
\    "input": "",
\    "output": "value"
\  },
\  "push17": {
\    "opcode": "70",
\    "desc": "Place 17 byte item on stack",
\    "input": "",
\    "output": "value"
\  },
\  "push16": {
\    "opcode": "6f",
\    "desc": "Place 16 byte item on stack",
\    "input": "",
\    "output": "value"
\  },
\  "push15": {
\    "opcode": "6e",
\    "desc": "Place 15 byte item on stack",
\    "input": "",
\    "output": "value"
\  },
\  "push14": {
\    "opcode": "6d",
\    "desc": "Place 14 byte item on stack",
\    "input": "",
\    "output": "value"
\  },
\  "push13": {
\    "opcode": "6c",
\    "desc": "Place 13 byte item on stack",
\    "input": "",
\    "output": "value"
\  },
\  "push12": {
\    "opcode": "6b",
\    "desc": "Place 12 byte item on stack",
\    "input": "",
\    "output": "value"
\  },
\  "push11": {
\    "opcode": "6a",
\    "desc": "Place 11 byte item on stack",
\    "input": "",
\    "output": "value"
\  },
\  "push10": {
\    "opcode": "69",
\    "desc": "Place 10 byte item on stack",
\    "input": "",
\    "output": "value"
\  },
\  "push9": {
\    "opcode": "68",
\    "desc": "Place 9 byte item on stack",
\    "input": "",
\    "output": "value"
\  },
\  "push8": {
\    "opcode": "67",
\    "desc": "Place 8 byte item on stack",
\    "input": "",
\    "output": "value"
\  },
\  "push7": {
\    "opcode": "66",
\    "desc": "Place 7 byte item on stack",
\    "input": "",
\    "output": "value"
\  },
\  "push6": {
\    "opcode": "65",
\    "desc": "Place 6 byte item on stack",
\    "input": "",
\    "output": "value"
\  },
\  "push5": {
\    "opcode": "64",
\    "desc": "Place 5 byte item on stack",
\    "input": "",
\    "output": "value"
\  },
\  "push4": {
\    "opcode": "63",
\    "desc": "Place 4 byte item on stack",
\    "input": "",
\    "output": "value"
\  },
\  "push3": {
\    "opcode": "62",
\    "desc": "Place 3 byte item on stack",
\    "input": "",
\    "output": "value"
\  },
\  "push2": {
\    "opcode": "61",
\    "desc": "Place 2 byte item on stack",
\    "input": "",
\    "output": "value"
\  },
\  "push1": {
\    "opcode": "60",
\    "desc": "Place 1 byte item on stack",
\    "input": "",
\    "output": "value"
\  },
\  "swap16": {
\    "opcode": "9f",
\    "desc": "Exchange 1st and 17th stack items",
\    "input": "a | ... | b",
\    "output": "b | ... | a"
\  },
\  "swap15": {
\    "opcode": "9e",
\    "desc": "Exchange 1st and 16th stack items",
\    "input": "a | ... | b",
\    "output": "b | ... | a"
\  },
\  "swap14": {
\    "opcode": "9d",
\    "desc": "Exchange 1st and 15th stack items",
\    "input": "a | ... | b",
\    "output": "b | ... | a"
\  },
\  "swap13": {
\    "opcode": "9c",
\    "desc": "Exchange 1st and 14th stack items",
\    "input": "a | ... | b",
\    "output": "b | ... | a"
\  },
\  "swap12": {
\    "opcode": "9b",
\    "desc": "Exchange 1st and 13th stack items",
\    "input": "a | ... | b",
\    "output": "b | ... | a"
\  },
\  "swap11": {
\    "opcode": "9a",
\    "desc": "Exchange 1st and 12th stack items",
\    "input": "a | ... | b",
\    "output": "b | ... | a"
\  },
\  "swap10": {
\    "opcode": "99",
\    "desc": "Exchange 1st and 11th stack items",
\    "input": "a | ... | b",
\    "output": "b | ... | a"
\  },
\  "swap9": {
\    "opcode": "98",
\    "desc": "Exchange 1st and 10th stack items",
\    "input": "a | ... | b",
\    "output": "b | ... | a"
\  },
\  "swap8": {
\    "opcode": "97",
\    "desc": "Exchange 1st and 9th stack items",
\    "input": "a | ... | b",
\    "output": "b | ... | a"
\  },
\  "swap7": {
\    "opcode": "96",
\    "desc": "Exchange 1st and 8th stack items",
\    "input": "a | ... | b",
\    "output": "b | ... | a"
\  },
\  "swap6": {
\    "opcode": "95",
\    "desc": "Exchange 1st and 7th stack items",
\    "input": "a | ... | b",
\    "output": "b | ... | a"
\  },
\  "swap5": {
\    "opcode": "94",
\    "desc": "Exchange 1st and 6th stack items",
\    "input": "a | ... | b",
\    "output": "b | ... | a"
\  },
\  "swap4": {
\    "opcode": "93",
\    "desc": "Exchange 1st and 5th stack items",
\    "input": "a | ... | b",
\    "output": "b | ... | a"
\  },
\  "swap3": {
\    "opcode": "92",
\    "desc": "Exchange 1st and 4th stack items",
\    "input": "a | ... | b",
\    "output": "b | ... | a"
\  },
\  "swap2": {
\    "opcode": "91",
\    "desc": "Exchange 1st and 3rd stack items",
\    "input": "a | b | c",
\    "output": "c | b | a"
\  },
\  "swap1": {
\    "opcode": "90",
\    "desc": "Exchange 1st and 2nd stack items",
\    "input": "a | b",
\    "output": "b | a"
\  },
\  "dup16": {
\    "opcode": "8f",
\    "desc": "Duplicate 16th stack item",
\    "input": "... | value",
\    "output": "value | ... | value"
\  },
\  "dup15": {
\    "opcode": "8e",
\    "desc": "Duplicate 15th stack item",
\    "input": "... | value",
\    "output": "value | ... | value"
\  },
\  "dup14": {
\    "opcode": "8d",
\    "desc": "Duplicate 14th stack item",
\    "input": "... | value",
\    "output": "value | ... | value"
\  },
\  "dup13": {
\    "opcode": "8c",
\    "desc": "Duplicate 13th stack item",
\    "input": "... | value",
\    "output": "value | ... | value"
\  },
\  "dup12": {
\    "opcode": "8b",
\    "desc": "Duplicate 12th stack item",
\    "input": "... | value",
\    "output": "value | ... | value"
\  },
\  "dup11": {
\    "opcode": "8a",
\    "desc": "Duplicate 11th stack item",
\    "input": "... | value",
\    "output": "value | ... | value"
\  },
\  "dup10": {
\    "opcode": "89",
\    "desc": "Duplicate 10th stack item",
\    "input": "... | value",
\    "output": "value | ... | value"
\  },
\  "dup9": {
\    "opcode": "88",
\    "desc": "Duplicate 9th stack item",
\    "input": "... | value",
\    "output": "value | ... | value"
\  },
\  "dup8": {
\    "opcode": "87",
\    "desc": "Duplicate 8th stack item",
\    "input": "... | value",
\    "output": "value | ... | value"
\  },
\  "dup7": {
\    "opcode": "86",
\    "desc": "Duplicate 7th stack item",
\    "input": "... | value",
\    "output": "value | ... | value"
\  },
\  "dup6": {
\    "opcode": "85",
\    "desc": "Duplicate 6th stack item",
\    "input": "... | value",
\    "output": "value | ... | value"
\  },
\  "dup5": {
\    "opcode": "84",
\    "desc": "Duplicate 5th stack item",
\    "input": "... | value",
\    "output": "value | ... | value"
\  },
\  "dup4": {
\    "opcode": "83",
\    "desc": "Duplicate 4th stack item",
\    "input": "... | value",
\    "output": "value | ... | value"
\  },
\  "dup3": {
\    "opcode": "82",
\    "desc": "Duplicate 3rd stack item",
\    "input": "a | b | c",
\    "output": "c | a | b | c"
\  },
\  "dup2": {
\    "opcode": "81",
\    "desc": "Duplicate 2nd stack item",
\    "input": "a | b",
\    "output": "b | a | b"
\  },
\  "dup1": {
\    "opcode": "80",
\    "desc": "Duplicate 1st stack item",
\    "input": "value",
\    "output": "value | value"
\  }
\}
