/**
 * DEPRECATED: we now use `semmle.code.cpp.ir.dataflow.DefaultTaintTracking`,
 * which is based on the IR but designed to behave similarly to this old
 * libarary.
 *
 * Provides the implementation of `semmle.code.cpp.security.TaintTracking`. Do
 * not import this file directly.
 */

import cpp
import Security

/** Expressions that change the value of a variable */
private predicate valueSource(Expr expr) {
  exists(AssignExpr ae | expr = ae.getLValue())
  or
  exists(FunctionCall fc, int i |
    userInputArgument(fc, i) and
    expr = fc.getArgument(i)
  )
  or
  exists(FunctionCall c, int arg |
    copyValueBetweenArguments(c.getTarget(), _, arg) and
    expr = c.getArgument(arg)
  )
  or
  exists(FunctionCall c, int arg |
    c.getTarget().getParameter(arg).getType() instanceof ReferenceType and
    expr = c.getArgument(arg)
  )
}

/** Expressions that are inside an expression that changes the value of a variable */
private predicate insideValueSource(Expr expr) {
  valueSource(expr)
  or
  insideValueSource(expr.getParent()) and
  // A modification of array[offset] does not modify offset
  not expr.getParent().(ArrayExpr).getArrayOffset() = expr
}

private predicate isPointer(Type type) {
  type instanceof PointerType or
  isPointer(type.(ReferenceType).getBaseType())
}

/**
 * Tracks data flow from src to dest.
 * If this is used in the left side of an assignment src and dest should be swapped
 */
private predicate moveToDependingOnSide(Expr src, Expr dest) {
  exists(ParenthesisExpr e |
    src = e.getAChild() and
    dest = e
  )
  or
  exists(ArrayExpr e |
    src = e.getArrayBase() and
    dest = e
  )
  or
  exists(PointerDereferenceExpr e |
    src = e.getOperand() and
    dest = e
  )
  or
  exists(AddressOfExpr e |
    src = e.getOperand() and
    dest = e
  )
  or
  // if var+offset is tainted, then so is var
  exists(VariableAccess base, BinaryOperation binop |
    dest = binop and
    (base = binop.getLeftOperand() or base = binop.getRightOperand()) and
    isPointer(base.getType()) and
    base.getTarget() instanceof LocalScopeVariable and
    src = base and
    // flow through pointer-pointer subtraction is dubious, the result should be
    // a number bounded by the size of the pointed-to thing.
    not binop instanceof PointerDiffExpr
  )
  or
  exists(UnaryOperation unop |
    dest = unop and
    unop.getAnOperand() = src
  )
  or
  exists(BinaryOperation binop |
    dest = binop and
    binop.getLeftOperand() = src and
    predictable(binop.getRightOperand())
  )
  or
  exists(BinaryOperation binop |
    dest = binop and
    binop.getRightOperand() = src and
    predictable(binop.getLeftOperand())
  )
  or
  exists(Cast cast |
    dest = cast and
    src = cast.getExpr()
  )
  or
  exists(ConditionalExpr cond |
    cond = dest and
    (
      cond.getThen() = src or
      cond.getElse() = src
    )
  )
}

/**
 * Track value flow between functions.
 * Handles the following cases:
 * - If an argument to a function is tainted, all the usages of the parameter inside the function are tainted
 * - If a function obtains input from the user internally and returns it, all calls to the function are tainted
 * - If an argument to a function is tainted and that parameter is returned, all calls to the function are not tainted
 *   (this is done to avoid false positives). Because of this we need to track if the tainted element came from an argument
 *   or not, and for that we use destFromArg
 */
private predicate betweenFunctionsValueMoveTo(Element src, Element dest, boolean destFromArg) {
  not unreachable(src) and
  not unreachable(dest) and
  (
    exists(Call call, Function called, int i |
      src = call.getArgument(i) and
      resolveCallWithParam(call, called, i, dest) and
      destFromArg = true
    )
    or
    // Only move the return of the function to the function itself if the value didn't came from an
    // argument, or else we would taint all the calls to one function if one argument is tainted
    // somewhere
    exists(Function f, ReturnStmt ret |
      ret.getEnclosingFunction() = f and
      src = ret.getExpr() and
      destFromArg = false and
      dest = f
    )
    or
    exists(Call call, Function f |
      f = resolveCall(call) and
      src = f and
      dest = call and
      destFromArg = false
    )
    or
    // If a parameter of type reference is tainted inside a function, taint the argument too
    exists(Call call, Function f, int pi, Parameter p |
      resolveCallWithParam(call, f, pi, p) and
      p.getType() instanceof ReferenceType and
      src = p and
      dest = call.getArgument(pi) and
      destFromArg = false
    )
  )
}

// predicate folding for proper join-order
// bad magic: pushes down predicate that ruins join-order
pragma[nomagic]
private predicate resolveCallWithParam(Call call, Function called, int i, Parameter p) {
  called = resolveCall(call) and
  p = called.getParameter(i)
}

/** A variable for which flow through is allowed. */
library class FlowVariable extends Variable {
  FlowVariable() {
    (
      this instanceof LocalScopeVariable or
      this instanceof GlobalOrNamespaceVariable
    ) and
    not argv(this)
  }
}

/** A local scope variable for which flow through is allowed. */
library class FlowLocalScopeVariable extends Variable {
  FlowLocalScopeVariable() { this instanceof LocalScopeVariable }
}

private predicate insideFunctionValueMoveTo(Element src, Element dest) {
  not unreachable(src) and
  not unreachable(dest) and
  (
    // Taint all variable usages when one is tainted
    // This function taints global variables but doesn't taint from a global variable (see globalVariableValueMoveTo)
    exists(FlowLocalScopeVariable v |
      src = v and
      dest = v.getAnAccess() and
      not insideValueSource(dest)
    )
    or
    exists(FlowVariable v |
      src = v.getAnAccess() and
      dest = v and
      insideValueSource(src)
    )
    or
    // Taint all union usages when one is tainted
    // This function taints global variables but doesn't taint from a global variable (see globalVariableValueMoveTo)
    exists(FlowLocalScopeVariable v, FieldAccess a |
      unionAccess(v, _, a) and
      src = v and
      dest = a and
      not insideValueSource(dest)
    )
    or
    exists(FlowVariable v, FieldAccess a |
      unionAccess(v, _, a) and
      src = a and
      dest = v and
      insideValueSource(src)
    )
    or
    // If a pointer is tainted, taint the original variable
    exists(FlowVariable p, FlowVariable v, AddressOfExpr e |
      p.getAnAssignedValue() = e and
      e.getOperand() = v.getAnAccess() and
      src = p and
      dest = v
    )
    or
    // If a reference is tainted, taint the original variable
    exists(FlowVariable r, FlowVariable v |
      r.getType() instanceof ReferenceType and
      r.getInitializer().getExpr() = v.getAnAccess() and
      src = r and
      dest = v
    )
    or
    exists(Variable var |
      var = dest and
      var.getInitializer().getExpr() = src
    )
    or
    exists(AssignExpr ae |
      src = ae.getRValue() and
      dest = ae.getLValue()
    )
    or
    exists(CommaExpr comma |
      comma = dest and
      comma.getRightOperand() = src
    )
    or
    exists(FunctionCall c, int sourceArg, int destArg |
      copyValueBetweenArguments(c.getTarget(), sourceArg, destArg) and
      // Only consider copies from `printf`-like functions if the format is a string
      (
        exists(FormattingFunctionCall ffc, FormatLiteral format |
          ffc = c and
          format = ffc.getFormat() and
          format.getConversionChar(sourceArg - ffc.getTarget().getNumberOfParameters()) = ["s", "S"]
        )
        or
        not exists(FormatLiteral fl | fl = c.(FormattingFunctionCall).getFormat())
        or
        not c instanceof FormattingFunctionCall
      ) and
      src = c.getArgument(sourceArg) and
      dest = c.getArgument(destArg)
    )
    or
    exists(FunctionCall c, int sourceArg |
      returnArgument(c.getTarget(), sourceArg) and
      src = c.getArgument(sourceArg) and
      dest = c
    )
    or
    exists(FormattingFunctionCall formattingSend, int arg, FormatLiteral format |
      dest = formattingSend and
      formattingSend.getArgument(arg) = src and
      format = formattingSend.getFormat() and
      format.getConversionChar(arg - formattingSend.getTarget().getNumberOfParameters()) =
        ["s", "S", "@"]
    )
    or
    // Expressions computed from tainted data are also tainted
    exists(FunctionCall call | dest = call and isPureFunction(call.getTarget().getName()) |
      call.getAnArgument() = src and
      forall(Expr arg | arg = call.getAnArgument() | arg = src or predictable(arg)) and
      // flow through `strlen` tends to cause dubious results, if the length is
      // bounded.
      not call.getTarget().getName() = "strlen"
    )
    or
    exists(Element a, Element b |
      moveToDependingOnSide(a, b) and
      if insideValueSource(a) then (src = b and dest = a) else (src = a and dest = b)
    )
  )
}

/**
 * Handles data flow from global variables to its usages.
 * The tainting for the global variable itself is done at insideFunctionValueMoveTo.
 */
private predicate globalVariableValueMoveTo(GlobalOrNamespaceVariable src, Expr dest) {
  not unreachable(dest) and
  (
    exists(GlobalOrNamespaceVariable v |
      src = v and
      dest = v.getAnAccess() and
      not insideValueSource(dest)
    )
    or
    exists(GlobalOrNamespaceVariable v, FieldAccess a |
      unionAccess(v, _, a) and
      src = v and
      dest = a and
      not insideValueSource(dest)
    )
  )
}

private predicate unionAccess(Variable v, Field f, FieldAccess a) {
  f.getDeclaringType() instanceof Union and
  a.getTarget() = f and
  a.getQualifier() = v.getAnAccess()
}

GlobalOrNamespaceVariable globalVarFromId(string id) {
  if result instanceof NamespaceVariable
  then id = result.getNamespace() + "::" + result.getName()
  else id = result.getName()
}

/**
 * A variable that has any kind of upper-bound check anywhere in the program.  This is
 * biased towards being inclusive because there are a lot of valid ways of doing an
 * upper bounds checks if we don't consider where it occurs, for example:
 * ```
 *   if (x < 10) { sink(x); }
 *
 *   if (10 > y) { sink(y); }
 *
 *   if (z > 10) { z = 10; }
 *   sink(z);
 * ```
 */
private predicate hasUpperBoundsCheck(Variable var) {
  exists(RelationalOperation oper, VariableAccess access |
    oper.getAnOperand() = access and
    access.getTarget() = var and
    // Comparing to 0 is not an upper bound check
    not oper.getAnOperand().getValue() = "0"
  )
}

cached
private predicate taintedWithArgsAndGlobalVars(
  Element src, Element dest, boolean destFromArg, string globalVar
) {
  isUserInput(src, _) and
  not unreachable(src) and
  dest = src and
  destFromArg = false and
  globalVar = ""
  or
  exists(Element other, boolean otherFromArg, string otherGlobalVar |
    taintedWithArgsAndGlobalVars(src, other, otherFromArg, otherGlobalVar)
  |
    not unreachable(dest) and
    not hasUpperBoundsCheck(dest) and
    (
      // Direct flow from one expression to another.
      betweenFunctionsValueMoveTo(other, dest, destFromArg) and
      (destFromArg = true or otherFromArg = false) and
      globalVar = otherGlobalVar
      or
      insideFunctionValueMoveTo(other, dest) and
      destFromArg = otherFromArg and
      globalVar = otherGlobalVar
      or
      exists(GlobalOrNamespaceVariable v |
        v = other and
        globalVariableValueMoveTo(v, dest) and
        destFromArg = false and
        v = globalVarFromId(globalVar)
      )
    )
  )
}

/**
 * A tainted expression is either directly user input, or is
 * computed from user input in a way that users can probably
 * control the exact output of the computation.
 *
 * This doesn't include data flow through global variables.
 * If you need that you must call taintedIncludingGlobalVars.
 */
predicate tainted(Expr source, Element tainted) {
  taintedWithArgsAndGlobalVars(source, tainted, _, "")
}

/**
 * A tainted expression is either directly user input, or is
 * computed from user input in a way that users can probably
 * control the exact output of the computation.
 *
 * This version gives the same results as tainted but also includes
 * data flow through global variables.
 *
 * The parameter `globalVar` is the name of the last global variable used to move the
 * value from source to tainted.
 */
predicate taintedIncludingGlobalVars(Expr source, Element tainted, string globalVar) {
  taintedWithArgsAndGlobalVars(source, tainted, _, globalVar)
}

/**
 * A predictable expression is one where an external user can predict
 * the value. For example, a literal in the source code is considered
 * predictable.
 */
private predicate predictable(Expr expr) {
  expr instanceof Literal
  or
  exists(BinaryOperation binop | binop = expr |
    predictable(binop.getLeftOperand()) and predictable(binop.getRightOperand())
  )
  or
  exists(UnaryOperation unop | unop = expr | predictable(unop.getOperand()))
}

private int maxArgIndex(Function f) {
  result =
    max(FunctionCall fc, int toMax |
      fc.getTarget() = f and toMax = fc.getNumberOfArguments() - 1
    |
      toMax
    )
}

/** Functions that copy the value of one argument to another */
private predicate copyValueBetweenArguments(Function f, int sourceArg, int destArg) {
  f.hasGlobalOrStdName("memcpy") and sourceArg = 1 and destArg = 0
  or
  f.hasGlobalName("__builtin___memcpy_chk") and sourceArg = 1 and destArg = 0
  or
  f.hasGlobalOrStdName("memmove") and sourceArg = 1 and destArg = 0
  or
  f.hasGlobalOrStdName("strcat") and sourceArg = 1 and destArg = 0
  or
  f.hasGlobalName("_mbscat") and sourceArg = 1 and destArg = 0
  or
  f.hasGlobalOrStdName("wcscat") and sourceArg = 1 and destArg = 0
  or
  f.hasGlobalOrStdName("strncat") and sourceArg = 1 and destArg = 0
  or
  f.hasGlobalName("_mbsncat") and sourceArg = 1 and destArg = 0
  or
  f.hasGlobalName("wcsncat") and sourceArg = 1 and destArg = 0
  or
  f.hasGlobalOrStdName("strcpy") and sourceArg = 1 and destArg = 0
  or
  f.hasGlobalName("_mbscpy") and sourceArg = 1 and destArg = 0
  or
  f.hasGlobalOrStdName("wcscpy") and sourceArg = 1 and destArg = 0
  or
  f.hasGlobalOrStdName("strncpy") and sourceArg = 1 and destArg = 0
  or
  f.hasGlobalName("_mbsncpy") and sourceArg = 1 and destArg = 0
  or
  f.hasGlobalOrStdName("wcsncpy") and sourceArg = 1 and destArg = 0
  or
  f.hasGlobalName("inet_aton") and sourceArg = 0 and destArg = 1
  or
  f.hasGlobalName("inet_pton") and sourceArg = 1 and destArg = 2
  or
  f.hasGlobalOrStdName("strftime") and sourceArg in [2 .. maxArgIndex(f)] and destArg = 0
  or
  exists(FormattingFunction ff | ff = f |
    sourceArg in [ff.getFormatParameterIndex() .. maxArgIndex(f)] and
    destArg = ff.getOutputParameterIndex()
  )
}

/** Functions where if one of the arguments is tainted, the result should be tainted */
private predicate returnArgument(Function f, int sourceArg) {
  f.hasGlobalName("memcpy") and sourceArg = 0
  or
  f.hasGlobalName("__builtin___memcpy_chk") and sourceArg = 0
  or
  f.hasGlobalOrStdName("memmove") and sourceArg = 0
  or
  f.hasGlobalOrStdName("strcat") and sourceArg = 0
  or
  f.hasGlobalName("_mbscat") and sourceArg = 0
  or
  f.hasGlobalOrStdName("wcsncat") and sourceArg = 0
  or
  f.hasGlobalOrStdName("strncat") and sourceArg = 0
  or
  f.hasGlobalName("_mbsncat") and sourceArg = 0
  or
  f.hasGlobalOrStdName("wcsncat") and sourceArg = 0
  or
  f.hasGlobalOrStdName("strcpy") and sourceArg = 0
  or
  f.hasGlobalName("_mbscpy") and sourceArg = 0
  or
  f.hasGlobalOrStdName("wcscpy") and sourceArg = 0
  or
  f.hasGlobalOrStdName("strncpy") and sourceArg = 0
  or
  f.hasGlobalName("_mbsncpy") and sourceArg = 0
  or
  f.hasGlobalOrStdName("wcsncpy") and sourceArg = 0
  or
  f.hasGlobalName("inet_ntoa") and sourceArg = 0
  or
  f.hasGlobalName("inet_addr") and sourceArg = 0
  or
  f.hasGlobalName("inet_network") and sourceArg = 0
  or
  f.hasGlobalName("inet_ntoa") and sourceArg = 0
  or
  f.hasGlobalName("inet_makeaddr") and
  (sourceArg = 0 or sourceArg = 1)
  or
  f.hasGlobalName("inet_lnaof") and sourceArg = 0
  or
  f.hasGlobalName("inet_netof") and sourceArg = 0
  or
  f.hasGlobalName("gethostbyname") and sourceArg = 0
  or
  f.hasGlobalName("gethostbyaddr") and sourceArg = 0
}

/**
 * Resolve potential target function(s) for `call`.
 *
 * If `call` is a call through a function pointer (`ExprCall`) or
 * targets a virtual method, simple data flow analysis is performed
 * in order to identify target(s).
 */
Function resolveCall(Call call) {
  result = call.getTarget()
  or
  result = call.(DataSensitiveCallExpr).resolve()
}

/** A data sensitive call expression. */
abstract library class DataSensitiveCallExpr extends Expr {
  DataSensitiveCallExpr() { not unreachable(this) }

  abstract Expr getSrc();

  cached
  abstract Function resolve();

  /**
   * Whether `src` can flow to this call expression.
   *
   * Searches backwards from `getSrc()` to `src`.
   */
  predicate flowsFrom(Element src, boolean allowFromArg) {
    src = getSrc() and allowFromArg = true
    or
    exists(Element other, boolean allowOtherFromArg | flowsFrom(other, allowOtherFromArg) |
      exists(boolean otherFromArg | betweenFunctionsValueMoveToStatic(src, other, otherFromArg) |
        otherFromArg = true and allowOtherFromArg = true and allowFromArg = true
        or
        otherFromArg = false and allowFromArg = false
      )
      or
      insideFunctionValueMoveTo(src, other) and allowFromArg = allowOtherFromArg
      or
      globalVariableValueMoveTo(src, other) and allowFromArg = true
    )
  }
}

/** Call through a function pointer. */
library class DataSensitiveExprCall extends DataSensitiveCallExpr, ExprCall {
  override Expr getSrc() { result = getExpr() }

  override Function resolve() {
    exists(FunctionAccess fa | flowsFrom(fa, true) | result = fa.getTarget())
  }
}

/** Call to a virtual function. */
library class DataSensitiveOverriddenFunctionCall extends DataSensitiveCallExpr, FunctionCall {
  DataSensitiveOverriddenFunctionCall() {
    exists(getTarget().(VirtualFunction).getAnOverridingFunction())
  }

  override Expr getSrc() { result = getQualifier() }

  override MemberFunction resolve() {
    exists(NewExpr new |
      flowsFrom(new, true) and
      memberFunctionFromNewExpr(new, result) and
      result.overrides*(getTarget().(VirtualFunction))
    )
  }
}

private predicate memberFunctionFromNewExpr(NewExpr new, MemberFunction f) {
  f = new.getAllocatedType().(Class).getAMemberFunction()
}

/** Same as `betweenFunctionsValueMoveTo`, but calls are resolved to their static target. */
private predicate betweenFunctionsValueMoveToStatic(Element src, Element dest, boolean destFromArg) {
  not unreachable(src) and
  not unreachable(dest) and
  (
    exists(FunctionCall call, Function called, int i |
      src = call.getArgument(i) and
      called = call.getTarget() and
      dest = called.getParameter(i) and
      destFromArg = true
    )
    or
    // Only move the return of the function to the function itself if the value didn't came from an
    // argument, or else we would taint all the calls to one function if one argument is tainted
    // somewhere
    exists(Function f, ReturnStmt ret |
      ret.getEnclosingFunction() = f and
      src = ret.getExpr() and
      destFromArg = false and
      dest = f
    )
    or
    exists(FunctionCall call, Function f |
      call.getTarget() = f and
      src = f and
      dest = call and
      destFromArg = false
    )
    or
    // If a parameter of type reference is tainted inside a function, taint the argument too
    exists(FunctionCall call, Function f, int pi, Parameter p |
      call.getTarget() = f and
      f.getParameter(pi) = p and
      p.getType() instanceof ReferenceType and
      src = p and
      dest = call.getArgument(pi) and
      destFromArg = false
    )
  )
}
