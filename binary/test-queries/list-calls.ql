/**
 * @name List all method calls
 * @description Lists all call instructions and their targets
 * @kind table
 * @id csharp-il/test-calls
 */

from
  @il_instruction call_insn, string opcode, @method caller, string target_method, string caller_name
where
  il_instructions(call_insn, _, opcode, _, caller) and
  opcode = "call" and
  il_call_target_unresolved(call_insn, target_method) and
  methods(caller, caller_name, _, _)
select caller_name, target_method
