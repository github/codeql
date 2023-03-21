/**
 * @name Non-constant format string
 * @description Passing a non-constant 'format' string to a printf-like function can lead
 *              to a mismatch between the number of arguments defined by the 'format' and the number
 *              of arguments actually passed to the function. If the format string ultimately stems
 *              from an untrusted source, this can be used for exploits.
 * @kind problem
 * @problem.severity recommendation
 * @security-severity 9.3
 * @precision high
 * @id cpp/non-constant-format
 * @tags maintainability
 *       correctness
 *       security
 *       external/cwe/cwe-134
 */

import semmle.code.cpp.ir.dataflow.TaintTracking
import semmle.code.cpp.commons.Printf

// For the following `...gettext` functions, we assume that
// all translations preserve the type and order of `%` specifiers
// (and hence are safe to use as format strings).  This
// assumption is hard-coded into the query.
predicate whitelistFunction(Function f, int arg) {
  // basic variations of gettext
  f.getName() = "_" and arg = 0
  or
  f.getName() = "gettext" and arg = 0
  or
  f.getName() = "dgettext" and arg = 1
  or
  f.getName() = "dcgettext" and arg = 1
  or
  // plural variations of gettext that take one format string for singular and another for plural form
  f.getName() = "ngettext" and
  (arg = 0 or arg = 1)
  or
  f.getName() = "dngettext" and
  (arg = 1 or arg = 2)
  or
  f.getName() = "dcngettext" and
  (arg = 1 or arg = 2)
}

// we assume that ALL uses of the `_` macro
// return constant string literals
predicate underscoreMacro(Expr e) {
  exists(MacroInvocation mi |
    mi.getMacroName() = "_" and
    mi.getExpr() = e
  )
}

/**
 * Holds if `t` cannot hold a character array, directly or indirectly.
 */
predicate cannotContainString(Type t, boolean isIndirect) {
  isIndirect = false and
  exists(Type unspecified |
    unspecified = t.getUnspecifiedType() and
    not unspecified instanceof UnknownType
  |
    unspecified instanceof BuiltInType or
    unspecified instanceof IntegralOrEnumType
  )
}

predicate isNonConst(DataFlow::Node node, boolean isIndirect) {
  exists(Expr e |
    e = node.asExpr() and isIndirect = false
    or
    e = node.asIndirectExpr() and isIndirect = true
  |
    exists(FunctionCall fc | fc = e |
      not (
        whitelistFunction(fc.getTarget(), _) or
        fc.getTarget().hasDefinition()
      )
    )
    or
    exists(Parameter p | p = e.(VariableAccess).getTarget() |
      p.getFunction().getName() = "main" and p.getType() instanceof PointerType
    )
    or
    e instanceof CrementOperation
    or
    e instanceof AddressOfExpr
    or
    e instanceof ReferenceToExpr
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
    e instanceof NewArrayExpr
    or
    e instanceof AssignExpr
    or
    exists(Variable v | v = e.(VariableAccess).getTarget() |
      v.getType().(ArrayType).getBaseType() instanceof CharType and
      exists(AssignExpr ae |
        ae.getLValue().(ArrayExpr).getArrayBase().(VariableAccess).getTarget() = v
      )
    )
  )
  or
  node instanceof DataFlow::DefinitionByReferenceNode and
  isIndirect = true
}

pragma[noinline]
predicate isBarrierNode(DataFlow::Node node) {
  underscoreMacro([node.asExpr(), node.asIndirectExpr()])
  or
  exists(node.asExpr()) and
  cannotContainString(node.getType(), false)
}

predicate isSinkImpl(DataFlow::Node sink, Expr formatString) {
  [sink.asExpr(), sink.asIndirectExpr()] = formatString and
  exists(FormattingFunctionCall fc | formatString = fc.getArgument(fc.getFormatParameterIndex()))
}

module NonConstFlowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    exists(boolean isIndirect, Type t |
      isNonConst(source, isIndirect) and
      t = source.getType() and
      not cannotContainString(t, isIndirect)
    )
  }

  predicate isSink(DataFlow::Node sink) { isSinkImpl(sink, _) }

  predicate isBarrier(DataFlow::Node node) { isBarrierNode(node) }
}

module NonConstFlow = TaintTracking::Make<NonConstFlowConfig>;

from FormattingFunctionCall call, Expr formatString
where
  call.getArgument(call.getFormatParameterIndex()) = formatString and
  exists(DataFlow::Node sink |
    NonConstFlow::hasFlowTo(sink) and
    isSinkImpl(sink, formatString)
  )
select formatString,
  "The format string argument to " + call.getTarget().getName() +
    " should be constant to prevent security issues and other potential errors."
