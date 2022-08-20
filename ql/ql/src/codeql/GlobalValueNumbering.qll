private import ql
private import codeql_ql.ast.internal.Predicate
private import codeql_ql.ast.internal.Type
private import codeql_ql.ast.internal.Builtins

private newtype TValueNumber =
  TVariableValueNumber(VarDecl var) { variableAccessValueNumber(_, var) } or
  TFieldValueNumber(FieldDecl var) { fieldAccessValueNumber(_, var) } or
  TThisValueNumber(Predicate pred) { thisAccessValueNumber(_, pred) } or
  TPredicateValueNumber(PredicateOrBuiltin pred, ValueNumberArgumentList args) {
    predicateCallValueNumber(_, pred, args)
  } or
  TClassPredicateValueNumber(PredicateOrBuiltin pred, ValueNumber base, ValueNumberArgumentList args) {
    classPredicateCallValueNumber(_, pred, base, args)
  } or
  TLiteralValueNumber(string value, Type t) { literalValueNumber(_, value, t) } or
  TBinaryOpValueNumber(FunctionSymbol symbol, ValueNumber leftOperand, ValueNumber rightOperand) {
    binaryOperandValueNumber(_, symbol, leftOperand, rightOperand)
  } or
  TUnaryOpValueNumber(FunctionSymbol symbol, ValueNumber operand) {
    unaryOperandValueNumber(_, symbol, operand)
  } or
  TInlineCastValueNumber(ValueNumber operand, Type t) { inlineCastValueNumber(_, operand, t) } or
  TDontCareValueNumber() or
  TRangeValueNumber(ValueNumber lower, ValueNumber high) { rangeValueNumber(_, lower, high) } or
  TSetValueNumber(ValueNumberElementList elements) { setValueNumber(_, elements) } or
  TUniqueValueNumber(Expr e) { uniqueValueNumber(e) }

private newtype ValueNumberArgumentList =
  MkArgsNil() or
  MkArgsCons(ValueNumber head, ValueNumberArgumentList tail) {
    argumentValueNumbers(_, _, head, tail)
  }

private newtype ValueNumberElementList =
  MkElementsNil() or
  MkElementsCons(ValueNumber head, ValueNumberElementList tail) {
    setValueNumbers(_, _, head, tail)
  }

private ValueNumberArgumentList argumentValueNumbers(Call call, int start) {
  start = call.getNumberOfArguments() and
  result = MkArgsNil()
  or
  exists(ValueNumber head, ValueNumberArgumentList tail |
    argumentValueNumbers(call, start, head, tail) and
    result = MkArgsCons(head, tail)
  )
}

private predicate argumentValueNumbers(
  Call call, int start, ValueNumber head, ValueNumberArgumentList tail
) {
  head = valueNumber(call.getArgument(start)) and
  tail = argumentValueNumbers(call, start + 1)
}

private ValueNumberElementList setValueNumbers(Set set, int start) {
  start = set.getNumberOfElements() and
  result = MkElementsNil()
  or
  exists(ValueNumber head, ValueNumberElementList tail |
    setValueNumbers(set, start, head, tail) and
    result = MkElementsCons(head, tail)
  )
}

private predicate setValueNumbers(Set set, int start, ValueNumber head, ValueNumberElementList tail) {
  head = valueNumber(set.getElement(start)) and
  tail = setValueNumbers(set, start + 1)
}

/**
 * A value number. A value number represents a collection of expressions that compute to the same value
 * at runtime.
 */
class ValueNumber extends TValueNumber {
  string toString() { result = "GVN" }

  /** Gets an expression that has this value number. */
  final Expr getAnExpr() { this = valueNumber(result) }
}

private predicate uniqueValueNumber(Expr e) { not numberable(e) }

private predicate numberable(Expr e) {
  e instanceof VarAccess or
  e instanceof FieldAccess or
  e instanceof ThisAccess or
  e instanceof Call or
  e instanceof Literal or
  e instanceof BinOpExpr or
  e instanceof UnaryExpr or
  e instanceof InlineCast or
  e instanceof ExprAnnotation or
  e instanceof DontCare or
  e instanceof Range or
  e instanceof Set or
  e instanceof AsExpr
}

private predicate variableAccessValueNumber(VarAccess access, VarDef var) {
  access.getDeclaration() = var
}

private predicate fieldAccessValueNumber(FieldAccess access, FieldDecl var) {
  access.getDeclaration() = var
}

private predicate thisAccessValueNumber(ThisAccess access, Predicate pred) {
  access.getEnclosingPredicate() = pred
}

private predicate predicateCallValueNumber(
  Call call, PredicateOrBuiltin pred, ValueNumberArgumentList args
) {
  call.getTarget() = pred and
  not exists(call.(MemberCall).getBase()) and
  args = argumentValueNumbers(call, 0)
}

private predicate classPredicateCallValueNumber(
  MemberCall call, PredicateOrBuiltin pred, ValueNumber base, ValueNumberArgumentList args
) {
  call.getTarget() = pred and
  valueNumber(call.getBase()) = base and
  args = argumentValueNumbers(call, 0)
}

private predicate literalValueNumber(Literal lit, string value, Type t) {
  lit.(String).getValue() = value and
  t instanceof StringClass
  or
  lit.(Integer).getValue().toString() = value and
  t instanceof IntClass
  or
  lit.(Float).getValue().toString() = value and
  t instanceof FloatClass
  or
  lit.(Boolean).isFalse() and
  value = "false" and
  t instanceof BooleanClass
  or
  lit.(Boolean).isTrue() and
  value = "true" and
  t instanceof BooleanClass
}

private predicate binaryOperandValueNumber(
  BinOpExpr e, FunctionSymbol symbol, ValueNumber leftOperand, ValueNumber rightOperand
) {
  e.getOperator() = symbol and
  valueNumber(e.getLeftOperand()) = leftOperand and
  valueNumber(e.getRightOperand()) = rightOperand
}

private predicate unaryOperandValueNumber(UnaryExpr e, FunctionSymbol symbol, ValueNumber operand) {
  e.getOperator() = symbol and
  valueNumber(e.getOperand()) = operand
}

private predicate inlineCastValueNumber(InlineCast cast, ValueNumber operand, Type t) {
  valueNumber(cast.getBase()) = operand and
  cast.getTypeExpr().getResolvedType() = t
}

private predicate rangeValueNumber(Range range, ValueNumber lower, ValueNumber high) {
  valueNumber(range.getLowEndpoint()) = lower and
  valueNumber(range.getHighEndpoint()) = high
}

private predicate setValueNumber(Set set, ValueNumberElementList elements) {
  elements = setValueNumbers(set, 0)
}

private TValueNumber nonUniqueValueNumber(Expr e) {
  exists(VarDecl var |
    variableAccessValueNumber(e, var) and
    result = TVariableValueNumber(var)
  )
  or
  exists(FieldDecl var |
    fieldAccessValueNumber(e, var) and
    result = TFieldValueNumber(var)
  )
  or
  exists(Predicate pred |
    thisAccessValueNumber(e, pred) and
    result = TThisValueNumber(pred)
  )
  or
  exists(PredicateOrBuiltin pred, ValueNumberArgumentList args |
    predicateCallValueNumber(e, pred, args) and
    result = TPredicateValueNumber(pred, args)
  )
  or
  exists(PredicateOrBuiltin pred, ValueNumber base, ValueNumberArgumentList args |
    classPredicateCallValueNumber(e, pred, base, args) and
    result = TClassPredicateValueNumber(pred, base, args)
  )
  or
  exists(string value, Type t |
    literalValueNumber(e, value, t) and
    result = TLiteralValueNumber(value, t)
  )
  or
  exists(FunctionSymbol symbol, ValueNumber leftOperand, ValueNumber rightOperand |
    binaryOperandValueNumber(e, symbol, leftOperand, rightOperand) and
    result = TBinaryOpValueNumber(symbol, leftOperand, rightOperand)
  )
  or
  exists(FunctionSymbol symbol, ValueNumber operand |
    unaryOperandValueNumber(e, symbol, operand) and
    result = TUnaryOpValueNumber(symbol, operand)
  )
  or
  exists(ValueNumber operand, Type t |
    inlineCastValueNumber(e, operand, t) and
    result = TInlineCastValueNumber(operand, t)
  )
  or
  result = valueNumber([e.(ExprAnnotation).getExpression(), e.(AsExpr).getInnerExpr()])
  or
  e instanceof DontCare and result = TDontCareValueNumber()
  or
  exists(ValueNumber lower, ValueNumber high |
    rangeValueNumber(e, lower, high) and
    result = TRangeValueNumber(lower, high)
  )
  or
  exists(ValueNumberElementList elements |
    setValueNumber(e, elements) and
    result = TSetValueNumber(elements)
  )
}

/** Gets the value number of an expression `e`. */
cached
TValueNumber valueNumber(Expr e) {
  result = nonUniqueValueNumber(e)
  or
  uniqueValueNumber(e) and
  result = TUniqueValueNumber(e)
}
