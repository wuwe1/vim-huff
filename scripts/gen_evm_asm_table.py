import re
import json
import requests as rq
from typing import Any, List


def collect_matches_from_list_until_failed(
    pattern: str,
    lst: List[Any],
    start_idx=0,
    cond=lambda m: len(m) == 1,
    cons=lambda m: m[0],
):
    idx = start_idx
    pat = re.compile(pattern)
    collections = []
    matches = pat.findall(lst[idx])
    while cond(matches):
        collections.append(cons(matches))
        idx = idx + 1
        matches = pat.findall(lst[idx])
    return collections


def find_first_match(pattern: str, lst: List[Any]):
    pat = re.compile(pattern)
    for idx, i in enumerate(lst):
        if pat.match(i):
            return idx
    raise ValueError(f"pattern {pattern} dose not match any line")


def collect_opcodes(lines):
    idx = find_first_match(r"pub const OPCODES", lines)
    return collect_matches_from_list_until_failed(
        r'\s+"(\w+)"', lines, start_idx=idx + 1
    )


def collect_opcodes_map(lines):
    idx = find_first_match(r"pub static OPCODES_MAP", lines)
    opcodes_map = {}
    opcodes_map_list = collect_matches_from_list_until_failed(
        r'"(\w+)" => (Opcode::\w+)',
        lines,
        start_idx=idx + 1,
        cond=lambda m: len(m) == 1 and len(m[0]) == 2,
        cons=lambda m: m[0],
    )
    for i in opcodes_map_list:
        opcodes_map[i[0]] = i[1]
    return opcodes_map


def collect_opcodes_str(lines):
    idx = find_first_match(r"\s+let opcode_str = match self", lines)
    opcodes_str = {}
    opcodes_str_list = collect_matches_from_list_until_failed(
        r'(Opcode::\w+) => "(\w\w)"',
        lines,
        start_idx=idx + 1,
        cond=lambda m: len(m) == 1 and len(m[0]) == 2,
        cons=lambda m: m[0],
    )
    for i in opcodes_str_list:
        opcodes_str[i[0]] = i[1]
    return opcodes_str


def fetch_evm_rs():
    EVM_RS_URL = "https://raw.githubusercontent.com/huff-language/huff-rs/main/huff_utils/src/evm.rs"
    evm_rs = rq.get(EVM_RS_URL).text
    return evm_rs.split("\n")


def fetch_opcode_meta():
    META_URL = (
        "https://raw.githubusercontent.com/comitylabs/evm.codes/main/opcodes.json"
    )
    return rq.get(META_URL).json()


def gen_opcode_name_to_hex(evm_rs: List[str]):
    opcode_name_to_hex = {}
    opcodes = collect_opcodes(evm_rs)
    opcodes_map = collect_opcodes_map(evm_rs)
    opcodes_str = collect_opcodes_str(evm_rs)
    for op in opcodes:
        opcode_name_to_hex[op] = opcodes_str[opcodes_map[op]]
    return opcode_name_to_hex


if __name__ == "__main__":
    evm_asm_table = {}
    opcode_name_to_hex = gen_opcode_name_to_hex(fetch_evm_rs())
    meta = fetch_opcode_meta()
    for op in opcode_name_to_hex:
        hx = opcode_name_to_hex[op]
        desc = meta[hx]["description"]
        input = meta[hx]["input"]
        output = meta[hx]["output"]
        evm_asm_table[op] = {
            "opcode": hx,
            "desc": desc,
            "input": input,
            "output": output,
        }
    print(json.dumps(evm_asm_table))
