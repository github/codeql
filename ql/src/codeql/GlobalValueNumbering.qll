private import ql
private import codeql_ql.ast.internal.Predicate
private import codeql_ql.ast.internal.Type
private import codeql_ql.ast.internal.Builtins

private newtype TValueNumber =
  TVariableValueNumber(VarDecl var) { variableAccessValueNumber(_, var) } or
  TPredicateValueNumber(PredicateOrBuiltin pred, ValueNumberList args) {
    predicateCallValueNumber(_, pred, args)
  } or
  TLiteralValueNumber(string value, Type t) { literalValueNumber(_, value, t) } or
  TBinaryOpValueNumber(FunctionSymbol symbol, ValueNumber leftOperand, ValueNumber rightOperand) {
    binaryOperandValueNumber(_, symbol, leftOperand, rightOperand)
  } or
  TUnaryOpValueNumber(FunctionSymbol symbol, ValueNumber operand) {
    unaryOperandValueNumber(_, symbol, operand)
  } or
  TUniqueValueNumber(Expr e) { uniqueValueNumber(e) }

private newtype ValueNumberList =
  MkNil() or
  MkCons(ValueNumber head, ValueNumberList tail) { globalValueNumbers(_, _, head, tail) }

private ValueNumberList globalValueNumbers(Call call, int start) {
  start = call.getNumberOfArguments() and
  result = MkNil()
  or
  exists(ValueNumber head, ValueNumberList tail |
    globalValueNumbers(call, start, head, tail) and
    result = MkCons(head, tail)
  )
}

private predicate globalValueNumbers(Call call, int start, ValueNumber head, ValueNumberList tail) {
  head = valueNumber(call.getArgument(start)) and
  tail = globalValueNumbers(call, start + 1)
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
  e instanceof Call or
  e instanceof Literal or
  e instanceof BinOpExpr or
  e instanceof UnaryExpr
}

private predicate variableAccessValueNumber(VarAccess access, VarDecl var) {
  access.getDeclaration() = var
}

private predicate predicateCallValueNumber(Call call, PredicateOrBuiltin pred, ValueNumberList args) {
  exists(pred.getReturnType()) and
  call.getTarget() = pred and
  args = globalValueNumbers(call, 0)
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

private TValueNumber nonUniqueValueNumber(Expr e) {
  exists(VarDecl var |
    variableAccessValueNumber(e, var) and
    result = TVariableValueNumber(var)
  )
  or
  exists(PredicateOrBuiltin pred, ValueNumberList args |
    predicateCallValueNumber(e, pred, args) and
    result = TPredicateValueNumber(pred, args)
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
}

/** Gets the value number of an expression `e`. */
cached
TValueNumber valueNumber(Expr e) {
  result = nonUniqueValueNumber(e)
  or
  uniqueValueNumber(e) and
  result = TUniqueValueNumber(e)
}
