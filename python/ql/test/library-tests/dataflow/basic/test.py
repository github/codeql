def obfuscated_id(x): #$ step="FunctionExpr -> obfuscated_id"
  y = x #$ step="x -> y" step="x, l:-1 -> x"
  z = y #$ step="y -> z" step="y, l:-1 -> y"
  return z #$ flow="42, l:+2 -> z" step="z, l:-1 -> z"

a = 42 #$ step="42 -> a"
b = obfuscated_id(a) #$ flow="42, l:-1 -> b" flow="FunctionExpr, l:-6 -> obfuscated_id" step="obfuscated_id(..) -> b" step="obfuscated_id, l:-6 -> obfuscated_id" step="a, l:-1 -> a"
