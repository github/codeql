/**
 * Provides an implementation of Global Value Numbering.
 * See https://en.wikipedia.org/wiki/Global_value_numbering
 *
 * The predicate `globalValueNumber` converts an expression into a `GVN`,
 * which is an abstract type representing the value of the expression. If
 * two expressions have the same `GVN` then they compute the same value.
 * For example:
 *
 * ```
 * void f(int x, int y) {
 *   g(x+y, x+y);
 * }
 * ```
 *
 * In this example, both arguments in the call to `g` compute the same value,
 * so both arguments have the same `GVN`. In other words, we can find
 * this call with the following query:
 *
 * ```
 * from FunctionCall call, GVN v
 * where v = globalValueNumber(call.getArgument(0))
 *   and v = globalValueNumber(call.getArgument(1))
 * select call
 * ```
 *
 * The analysis is conservative, so two expressions might have different
 * `GVN`s even though the actually always compute the same value. The most
 * common reason for this is that the analysis cannot prove that there
 * are no side-effects that might cause the computed value to change.
 */

import cpp
private import semmle.code.cpp.ir.implementation.aliased_ssa.gvn.internal.ValueNumberingInternal
private import semmle.code.cpp.ir.IR

/**
 * A Global Value Number. A GVN is an abstract representation of the value
 * computed by an expression. The relationship between `Expr` and `GVN` is
 * many-to-one: every `Expr` has exactly one `GVN`, but multiple
 * expressions can have the same `GVN`. If two expressions have the same
 * `GVN`, it means that they compute the same value at run time. The `GVN`
 * is an opaque value, so you cannot deduce what the run-time value of an
 * expression will be from its `GVN`. The only use for the `GVN` of an
 * expression is to find other expressions that compute the same value.
 * Use the predicate `globalValueNumber` to get the `GVN` for an `Expr`.
 *
 * Note: `GVN` has `toString` and `getLocation` methods, so that it can be
 * displayed in a results list. These work by picking an arbitrary
 * expression with this `GVN` and using its `toString` and `getLocation`
 * methods.
 */
class GVN extends TValueNumber {
  pragma[noinline]
  GVN() {
    exists(Instruction instr |
      this = tvalueNumber(instr) and exists(instr.getUnconvertedResultExpression())
    )
  }

  private Instruction getAnInstruction() { this = tvalueNumber(result) }

  final string toString() { result = "GVN" }

  final string getDebugString() { result = strictconcat(getAnExpr().toString(), ", ") }

  final Location getLocation() {
    if exists(Expr e | e = getAnExpr() and not e.getLocation() instanceof UnknownLocation)
    then
      result =
        min(Location l |
          l = getAnExpr().getLocation() and not l instanceof UnknownLocation
        |
          l
          order by
            l.getFile().getAbsolutePath(), l.getStartLine(), l.getStartColumn(), l.getEndLine(),
            l.getEndColumn()
        )
    else result instanceof UnknownDefaultLocation
  }

  final string getKind() {
    this instanceof TVariableAddressValueNumber and result = "VariableAddress"
    or
    this instanceof TInitializeParameterValueNumber and result = "InitializeParameter"
    or
    this instanceof TStringConstantValueNumber and result = "StringConstant"
    or
    this instanceof TFieldAddressValueNumber and result = "FieldAddress"
    or
    this instanceof TBinaryValueNumber and result = "Binary"
    or
    this instanceof TPointerArithmeticValueNumber and result = "PointerArithmetic"
    or
    this instanceof TUnaryValueNumber and result = "Unary"
    or
    this instanceof TInheritanceConversionValueNumber and result = "InheritanceConversion"
    or
    this instanceof TLoadTotalOverlapValueNumber and result = "LoadTotalOverlap"
    or
    this instanceof TUniqueValueNumber and result = "Unique"
  }

  /** Gets an expression that has this GVN. */
  Expr getAnExpr() { result = getAnUnconvertedExpr() }

  /** Gets an expression that has this GVN. */
  Expr getAnUnconvertedExpr() { result = getAnInstruction().getUnconvertedResultExpression() }

  /** Gets an expression that has this GVN. */
  Expr getAConvertedExpr() { result = getAnInstruction().getConvertedResultExpression() }
}

/** Gets the global value number of expression `e`. */
GVN globalValueNumber(Expr e) { e = result.getAnExpr() }
