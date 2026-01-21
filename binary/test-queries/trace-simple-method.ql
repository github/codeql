/**
 * @name Control flow trace for SimpleMethod
 * @description Shows the complete IL instruction sequence with control flow
 * @kind table
 * @id csharp-il/trace-simplemethod
 */

from
  @il_instruction insn, int idx, int opcode_num, string opcode, int offset, @method method,
  string method_name
where
  methods(method, method_name, _, _) and
  method_name = "SimpleMethod" and
  il_instruction_parent(insn, idx, method) and
  il_instructions(insn, opcode_num, opcode, offset, method)
select idx, offset, opcode, opcode_num order by idx
