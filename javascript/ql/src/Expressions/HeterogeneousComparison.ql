/**
 * @name Comparison between inconvertible types
 * @description An equality comparison between two values that cannot be meaningfully converted to
 *              the same type will always yield 'false', and an inequality comparison will always
 *              yield 'true'.
 * @kind problem
 * @problem.severity warning
 * @id js/comparison-between-incompatible-types
 * @tags reliability
 *       correctness
 *       external/cwe/cwe-570
 *       external/cwe/cwe-571
 * @precision high
 */

import javascript
private import semmle.javascript.dataflow.InferredTypes
private import semmle.javascript.DefensiveProgramming

/**
 * Holds if `left` and `right` are the left and right operands, respectively, of `nd`, which is
 * a comparison.
 *
 * Besides the usual comparison operators, `switch` statements are also considered to be comparisons,
 * with the switched-on expression being the right operand and all case labels the left operands.
 */
predicate comparisonOperands(AstNode nd, Expr left, Expr right) {
  exists(Comparison cmp | cmp = nd | left = cmp.getLeftOperand() and right = cmp.getRightOperand())
  or
  exists(SwitchStmt switch | switch = nd |
    right = switch.getExpr() and left = switch.getACase().getExpr()
  )
}

/**
 * Holds if `av` may have a `toString` or `valueOf` method.
 */
predicate hasImplicitConversionMethod(DefiniteAbstractValue av) {
  // look for assignments to `toString` or `valueOf` on `av` or its prototypes
  exists(AnalyzedPropertyWrite apw, string p | p = "toString" or p = "valueOf" |
    apw.writes(av.getAPrototype*(), p, _)
  )
}

/**
 * Gets a type of `operand`, which is an operand of the strict equality test `eq`.
 */
InferredType strictEqualityOperandType(AstNode eq, DataFlow::AnalyzedNode operand) {
  // strict equality tests do no conversion at all
  operand.asExpr() = eq.(StrictEqualityTest).getAChildExpr() and result = operand.getAType()
  or
  // switch behaves like a strict equality test
  exists(SwitchStmt switch | switch = eq |
    (operand.asExpr() = switch.getExpr() or operand.asExpr() = switch.getACase().getExpr()) and
    result = operand.getAType()
  )
}

/**
 * Holds if `operand` is an operand of the non-strict equality test or relational
 * operator `parent`, and may have a `toString` or `valueOf` method.
 */
predicate implicitlyConvertedOperand(AstNode parent, DataFlow::AnalyzedNode operand) {
  (parent instanceof NonStrictEqualityTest or parent instanceof RelationalComparison) and
  operand.asExpr() = parent.getAChildExpr() and
  hasImplicitConversionMethod(operand.getAValue())
}

/**
 * Gets a type of `operand`, which is an operand of the non-strict equality test or
 * relational operator `parent`.
 */
InferredType nonStrictOperandType(AstNode parent, DataFlow::AnalyzedNode operand) {
  // non-strict equality tests perform conversions
  operand.asExpr() = parent.(NonStrictEqualityTest).getAChildExpr() and
  exists(InferredType tp | tp = operand.getAValue().getType() |
    result = tp
    or
    // Booleans are converted to numbers
    tp = TTBoolean() and result = TTNumber()
    or
    // and so are strings
    tp = TTString() and
    // exclude cases where the string is guaranteed to coerce to NaN
    not exists(ConstantString l | l = operand.asExpr() | not exists(l.getStringValue().toFloat())) and
    result = TTNumber()
    or
    // Dates are converted to strings (which are guaranteed to coerce to NaN)
    tp = TTDate() and result = TTString()
    or
    // other objects are converted to strings, numbers or Booleans
    (tp = TTObject() or tp = TTFunction() or tp = TTClass() or tp = TTRegExp()) and
    (result = TTBoolean() or result = TTNumber() or result = TTString())
    or
    // `undefined` and `null` are equated
    tp = TTUndefined() and result = TTNull()
  )
  or
  // relational operators convert their operands to numbers or strings
  operand.asExpr() = parent.(RelationalComparison).getAChildExpr() and
  exists(AbstractValue v | v = operand.getAValue() |
    result = v.getType()
    or
    v.isCoercibleToNumber() and result = TTNumber()
  )
}

/**
 * Gets a type that `operand`, which is an operand of comparison `parent`,
 * could be converted to at runtime.
 */
InferredType convertedOperandType(AstNode parent, DataFlow::AnalyzedNode operand) {
  result = strictEqualityOperandType(parent, operand)
  or
  // if `operand` might have `toString`/`valueOf`, just assume it could
  // convert to any type at all
  implicitlyConvertedOperand(parent, operand)
  or
  result = nonStrictOperandType(parent, operand)
}

/**
 * Holds if `left` and `right` are operands of comparison `cmp` having types
 * `leftTypes` and `rightTypes`, respectively, but there is no
 * common type they coerce to.
 */
predicate isHeterogeneousComparison(
  AstNode cmp, DataFlow::AnalyzedNode left, DataFlow::AnalyzedNode right, string leftTypes,
  string rightTypes
) {
  comparisonOperands(cmp, left.asExpr(), right.asExpr()) and
  not convertedOperandType(cmp, left) = convertedOperandType(cmp, right) and
  leftTypes = left.ppTypes() and
  rightTypes = right.ppTypes()
}

/**
 * Holds if `name` is a variable name that programmers consider a keyword.
 */
predicate isPseudoKeyword(string name) {
  name = "Infinity" or
  name = "NaN" or
  name = "undefined"
}

/**
 * Gets a user friendly description of `e`, if such a description exists.
 */
string getDescription(VarAccess e) {
  exists(string name | name = e.getName() |
    if isPseudoKeyword(name) then result = "'" + name + "'" else result = "variable '" + name + "'"
  )
}

/**
 * Gets a user friendly description of `e`, `default` is the result if no such description exists.
 */
bindingset[default]
string getDescription(Expr e, string default) {
  if exists(getDescription(e)) then result = getDescription(e) else result = default
}

/**
 * Gets the simpler message of `message1` and `message2` guided by the corresponding `complexity1` and `complexity2`.
 */
bindingset[message1, message2, complexity1, complexity2]
string getTypeDescription(string message1, string message2, int complexity1, int complexity2) {
  if complexity1 > 4 and complexity2 <= 2 then result = message2 else result = message1
}

/**
 * Holds if `e` directly uses a parameter's initial value as passed in from the caller.
 */
predicate isInitialParameterUse(Expr e) {
  // unlike `SimpleParameter.getAnInitialUse` this will not include uses we have refinement information for
  exists(SimpleParameter p, SsaExplicitDefinition ssa |
    ssa.getDef() = p and
    ssa.getVariable().getAUse() = e and
    not p.isRestParameter()
  )
}

/**
 * Holds if `e` is an expression that should not be considered in a heterogeneous comparison.
 *
 * We currently whitelist expressions that rely on inter-procedural parameter information.
 */
predicate whitelist(Expr e) { isInitialParameterUse(e) }

from
  AstNode cmp, DataFlow::AnalyzedNode left, DataFlow::AnalyzedNode right, string leftTypes,
  string rightTypes, string leftExprDescription, string rightExprDescription, int leftTypeCount,
  int rightTypeCount, string leftTypeDescription, string rightTypeDescription
where
  isHeterogeneousComparison(cmp, left, right, leftTypes, rightTypes) and
  not exists(cmp.(Expr).flow().(DefensiveExpressionTest).getTheTestResult()) and
  not whitelist(left.asExpr()) and
  not whitelist(right.asExpr()) and
  leftExprDescription = capitalize(getDescription(left.asExpr(), "this expression")) and
  rightExprDescription = getDescription(right.asExpr(), "an expression") and
  leftTypeCount = strictcount(left.getAType()) and
  rightTypeCount = strictcount(right.getAType()) and
  leftTypeDescription =
    getTypeDescription("is of type " + leftTypes, "cannot be of type " + rightTypes, leftTypeCount,
      rightTypeCount) and
  rightTypeDescription =
    getTypeDescription("of type " + rightTypes, ", which cannot be of type " + leftTypes,
      rightTypeCount, leftTypeCount)
select left,
  leftExprDescription + " " + leftTypeDescription + ", but it is compared to $@ " +
    rightTypeDescription + ".", right, rightExprDescription
