def obfuscated_id(x): #$ step="ControlFlowNode for FunctionExpr -> GSSA Variable obfuscated_id"
  y = x #$ step="ControlFlowNode for x -> SSA variable y" step="SSA variable x, l:1 -> ControlFlowNode for x"
  z = y #$ step="ControlFlowNode for y -> SSA variable z" step="SSA variable y, l:2 -> ControlFlowNode for y"
  return z #$ flow="ControlFlowNode for IntegerLiteral, l:6 -> ControlFlowNode for z" step="SSA variable z, l:3 -> ControlFlowNode for z"

a = 42 #$ step="ControlFlowNode for IntegerLiteral -> GSSA Variable a"
b = obfuscated_id(a) #$ flow="ControlFlowNode for IntegerLiteral, l:6 -> GSSA Variable b" flow="ControlFlowNode for FunctionExpr, l:1 -> ControlFlowNode for obfuscated_id" step="ControlFlowNode for obfuscated_id() -> GSSA Variable b" step="GSSA Variable obfuscated_id, l:1 -> ControlFlowNode for obfuscated_id" step="GSSA Variable a, l:6 -> ControlFlowNode for a"
