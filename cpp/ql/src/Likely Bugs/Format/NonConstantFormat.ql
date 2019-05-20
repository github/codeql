/**
 * @name Non-constant format string
 * @description Passing a non-constant 'format' string to a printf-like function can lead
 *              to a mismatch between the number of arguments defined by the 'format' and the number
 *              of arguments actually passed to the function. If the format string ultimately stems
 *              from an untrusted source, this can be used for exploits.
 * @kind problem
 * @problem.severity recommendation
 * @precision high
 * @id cpp/non-constant-format
 * @tags maintainability
 *       correctness
 *       security
 *       external/cwe/cwe-134
 */
import cpp

/**
 * Holds if `t` is a character array or pointer, where `charType` is the type of
 * characters in `t`.
 */
predicate stringType(Type t, Type charType) {
  (
    ( charType = t.(PointerType).getBaseType() or
      charType = t.(ArrayType).getBaseType()
    ) and (
      charType.getUnspecifiedType() instanceof CharType or
      charType.getUnspecifiedType() instanceof Wchar_t
    )
  )
  or
  stringType(t.getUnderlyingType(), charType)
  or
  stringType(t.(SpecifiedType).getBaseType(), charType)
}

predicate gettextFunction(Function f, int arg) {
  // basic variations of gettext
  (f.getName() =          "_" and arg = 0) or
  (f.getName() =    "gettext" and arg = 0) or
  (f.getName() =   "dgettext" and arg = 1) or
  (f.getName() =  "dcgettext" and arg = 1) or
  // plural variations of gettext that take one format string for singular and another for plural form
  (f.getName() =   "ngettext" and (arg = 0 or arg = 1)) or
  (f.getName() =  "dngettext" and (arg = 1 or arg = 2)) or
  (f.getName() = "dcngettext" and (arg = 1 or arg = 2))
}

predicate stringArray(Variable arr, AggregateLiteral init) {
  arr.getInitializer().getExpr() = init and
  stringType(arr.getUnspecifiedType().(ArrayType).getBaseType(), _)
  // Ideally, this predicate should also check that no item of `arr` is ever
  // reassigned, but such an analysis could get fairly complicated. Instead, we
  // just hope that nobody would initialize an array of constants and then
  // overwrite some of them with untrusted data.
}

predicate underscoreMacro(Expr e) {
  exists(MacroInvocation mi |
    mi.getMacroName() = "_" and
    mi.getExpr() = e
  )
}

/**
 * Holds if a value of character pointer type may flow _directly_ from `src` to
 * `dst`.
 */
predicate stringFlowStep(Expr src, Expr dst) {
  not underscoreMacro(dst)
  and
  stringType(dst.getType(), _)
  and
  (
    src = dst.(VariableAccess).getTarget().getAnAssignedValue()
    or
    src = dst.(ConditionalExpr).getThen()
    or
    src = dst.(ConditionalExpr).getElse()
    or
    src = dst.(AssignExpr).getRValue()
    or
    src = dst.(CommaExpr).getRightOperand()
    or
    src = dst.(UnaryPlusExpr).getOperand()
    or
    stringArray(dst.(ArrayExpr).getArrayBase().(VariableAccess).getTarget(),
                src.getParent())
    or
    // Follow a parameter to its arguments in all callers.
    exists(Parameter p | p = dst.(VariableAccess).getTarget() |
      src = p.getFunction().getACallToThisFunction().getArgument(p.getIndex())
    )
    or
    // Follow a call to a gettext function without looking at its body even if
    // the body is known. This ensures that we report the error in the relevant
    // location rather than inside the body of some `_` function.
    exists(Function gettext, FunctionCall call, int idx |
      gettextFunction(gettext, idx) and
      dst = call and
      gettext = call.getTarget()
    | src = call.getArgument(idx)
    )
    or
    // Follow a call to a non-gettext function through its return statements.
    exists(Function f, ReturnStmt retStmt |
      f = dst.(FunctionCall).getTarget() and
      f = retStmt.getEnclosingFunction() and
      not gettextFunction(f, _)
    | src = retStmt.getExpr()
    )
  )
}

/** Holds if `v` may be written to, other than through `AssignExpr`. */
predicate nonConstVariable(Variable v) {
  exists(Type charType |
    stringType(v.getType(), charType) and not charType.isConst()
  )
  or
  exists(AssignPointerAddExpr e |
    e.getLValue().(VariableAccess).getTarget() = v
  )
  or
  exists(AssignPointerSubExpr e |
    e.getLValue().(VariableAccess).getTarget() = v
  )
  or
  exists(CrementOperation e | e.getOperand().(VariableAccess).getTarget() = v)
  or
  exists(AddressOfExpr e | e.getOperand().(VariableAccess).getTarget() = v)
  or
  exists(ReferenceToExpr e | e.getExpr().(VariableAccess).getTarget() = v)
}

/**
 * Holds if this expression is _directly_ considered non-constant for the
 * purpose of this query.
 *
 * Each case of `Expr` that may have string type should be listed either in
 * `nonConst` or `stringFlowStep`. Omitting a case leads to false negatives.
 * Having a case in both places leads to unnecessary computation.
 */
predicate nonConst(Expr e) {
  nonConstVariable(e.(VariableAccess).getTarget())
  or
  e instanceof CrementOperation
  or
  e instanceof AssignPointerAddExpr
  or
  e instanceof AssignPointerSubExpr
  or
  e instanceof PointerArithmeticOperation
  or
  e instanceof FieldAccess
  or
  e instanceof PointerDereferenceExpr
  or
  e instanceof AddressOfExpr
  or
  e instanceof ExprCall
  or
  exists(ArrayExpr ae | ae = e |
    not stringArray(ae.getArrayBase().(VariableAccess).getTarget(), _)
  )
  or
  e instanceof NewArrayExpr
  or
  // e is a call to a function whose definition we cannot see. We assume it is
  // not constant.
  exists(Function f | f = e.(FunctionCall).getTarget() |
    not f.hasDefinition()
  )
  or
  // e is a parameter of a function that's never called. If it were called, we
  // would instead have followed the call graph in `stringFlowStep`.
  exists(Function f
  | f = e.(VariableAccess).getTarget().(Parameter).getFunction()
  | not exists(f.getACallToThisFunction())
  )
}

predicate formattingFunctionArgument(
    FormattingFunction ff, FormattingFunctionCall fc, Expr arg)
{
  fc.getTarget() = ff and
  fc.getArgument(ff.getFormatParameterIndex()) = arg and
  // Don't look for errors inside functions that are themselves formatting
  // functions. We expect that the interesting errors will be in their callers.
  not fc.getEnclosingFunction() instanceof FormattingFunction
}

// Reflexive-transitive closure of `stringFlow`, restricting the base case to
// only consider destination expressions that are arguments to formatting
// functions.
predicate stringFlow(Expr src, Expr dst) {
  formattingFunctionArgument(_, _, dst) and src = dst
  or
  exists(Expr mid | stringFlowStep(src, mid) and stringFlow(mid, dst))
}

predicate whitelisted(Expr e) {
  gettextFunction(e.(FunctionCall).getTarget(), _)
  or
  underscoreMacro(e)
}

predicate flowFromNonConst(Expr src, Expr dst) {
  stringFlow(src, dst) and
  nonConst(src) and
  not whitelisted(src)
}

from FormattingFunctionCall fc, FormattingFunction ff, Expr format
where formattingFunctionArgument(ff, fc, format) and
      flowFromNonConst(_, format) and
      not fc.isInMacroExpansion()
select format, "The format string argument to " + ff.getName() + " should be constant to prevent security issues and other potential errors."
