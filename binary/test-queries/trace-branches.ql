/**
 * @name Control flow with branches
 * @description Shows all branch instructions and their targets
 * @kind table
 * @id csharp-il/test-branches
 */

from
  @il_instruction branch_insn, string opcode, int offset, @method method, string method_name,
  int target_offset
where
  il_instructions(branch_insn, _, opcode, offset, method) and
  il_branch_target(branch_insn, target_offset) and
  methods(method, method_name, _, _)
select method_name, opcode, offset, target_offset
