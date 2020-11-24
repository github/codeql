def obfuscated_id(x): #$ step="FunctionExpr -> GSSA Variable obfuscated_id"
  y = x #$ step="x -> SSA variable y" step="SSA variable x, l:1 -> x"
  z = y #$ step="y -> SSA variable z" step="SSA variable y, l:2 -> y"
  return z #$ flow="42, l:6 -> z" step="SSA variable z, l:3 -> z"

a = 42 #$ step="42 -> GSSA Variable a"
b = obfuscated_id(a) #$ flow="42, l:6 -> GSSA Variable b" flow="FunctionExpr, l:1 -> obfuscated_id" step="obfuscated_id(..) -> GSSA Variable b" step="GSSA Variable obfuscated_id, l:1 -> obfuscated_id" step="GSSA Variable a, l:6 -> a"
