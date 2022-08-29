const asm = await (await fetch(
  new URL(
    "https://raw.githubusercontent.com/huff-language/vscode-huff/master/src/features/hover/asm.json",
  ),
)).json();

const meta = await (await fetch(
  new URL(
    "https://raw.githubusercontent.com/comitylabs/evm.codes/main/opcodes.json",
  ),
)).json();

const opcodes: any = {};
for (const [k, v] of Object.entries(asm)) {
  const opcode = Number(v.instr_opcode).toString(16).padStart(2, "0");
  opcodes[k] = {
    opcode,
    desc: meta[opcode].description,
    input: meta[opcode].input,
    output: meta[opcode].output,
  };
}

console.log(JSON.stringify(opcodes, null, 2));
