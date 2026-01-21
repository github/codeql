/**
 * @name Complete control flow analysis
 * @description Shows instructions, branches, and calls for all methods
 * @kind table
 * @id csharp-il/complete-flow
 */

from @method method, string method_name, string signature
where methods(method, method_name, signature, _)
select method_name, count(@il_instruction insn | il_instruction_parent(insn, _, method)),
  count(@il_instruction br | il_instructions(br, _, _, _, method) and il_branch_target(br, _)),
  count(@il_instruction call | il_instructions(call, _, "call", _, method))
