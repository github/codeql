def obfuscated_id(x): #$ step="FunctionExpr -> GSSA Variable obfuscated_id" step="x -> SSA variable x"
  y = x #$ step="x -> SSA variable y" step="SSA variable x, l:-1 -> x"
  z = y #$ step="y -> SSA variable z" step="SSA variable y, l:-1 -> y"
  return z #$ flow="42, l:+2 -> z" step="SSA variable z, l:-1 -> z"

a = 42 #$ step="42 -> GSSA Variable a"
b = obfuscated_id(a) #$ flow="42, l:-1 -> GSSA Variable b" flow="FunctionExpr, l:-6 -> obfuscated_id" step="obfuscated_id(..) -> GSSA Variable b" step="GSSA Variable obfuscated_id, l:-6 -> obfuscated_id" step="GSSA Variable a, l:-1 -> a"
