import cpp

predicate describe(UnaryOperation uo, string s) {
  uo instanceof UnaryArithmeticOperation and s = "UnaryArithmeticOperation"
  or
  uo instanceof UnaryMinusExpr and s = "UnaryMinusExpr"
  or
  uo instanceof UnaryPlusExpr and s = "UnaryPlusExpr"
  or
  uo instanceof ConjugationExpr and s = "ConjugationExpr"
  or
  uo instanceof CrementOperation and s = "CrementOperation"
  or
  uo instanceof IncrementOperation and s = "IncrementOperation"
  or
  uo instanceof DecrementOperation and s = "DecrementOperation"
  or
  uo instanceof PrefixCrementOperation and s = "PrefixCrementOperation"
  or
  uo instanceof PostfixCrementOperation and s = "PostfixCrementOperation"
  or
  uo instanceof AddressOfExpr and s = "AddressOfExpr"
  or
  s = "getAddressable() = " + uo.(AddressOfExpr).getAddressable().toString()
  or
  uo instanceof PointerDereferenceExpr and s = "PointerDereferenceExpr"
  or
  uo instanceof UnaryLogicalOperation and s = "UnaryLogicalOperation"
  or
  uo instanceof NotExpr and s = "NotExpr"
}

from UnaryOperation uo
select uo, uo.getOperator(), concat(string s | describe(uo, s) | s, ", ")
