import swift

string describe(Type t) {
  t instanceof FloatingPointType and result = "FloatingPointType"
  or
  t instanceof CharacterType and result = "CharacterType"
  or
  t instanceof IntegralType and result = "IntegralType"
  or
  t instanceof BoolType and result = "BoolType"
  or
  t instanceof NumericType and result = "NumericType"
}

from VarDecl v, Type t
where
  v.getLocation().getFile().getBaseName() != "" and
  t = v.getType()
select v, t.toString(), concat(describe(t), ", ")
