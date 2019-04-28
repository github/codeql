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

import semmle.code.cpp.dataflow.TaintTracking
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

<<<<<<< HEAD
predicate whitelisted(FunctionCall fc) {
  exists(Function f, int arg | f = fc.getTarget() | whitelistFunction(f, arg))
=======
predicate underscoreMacro(Expr e) {
  exists(MacroInvocation mi |
    mi.getMacroName() = "_" and
    mi.getExpr() = e
  )
>>>>>>> [CPP-370] First attempt at isAdditionalFlowStep().
}

predicate isNonConst(DataFlow::Node node) {
  exists(Expr e | e = node.asExpr() |
    exists(FunctionCall fc | fc = e.(FunctionCall) |
      not whitelisted(fc) and not fc.getTarget().hasDefinition()
    )
    or
    exists(Parameter p | p = e.(VariableAccess).getTarget().(Parameter) |
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
<<<<<<< HEAD
  node instanceof DataFlow::DefinitionByReferenceNode
}

class NonConstFlow extends TaintTracking::Configuration {
  NonConstFlow() { this = "NonConstFlow" }
=======
  // we let the '_' macro through regardless of what it points at
  underscoreMacro(e)
}

predicate isConst(Expr e) {
  e instanceof StringLiteral
  or
  whitelisted(e)
}

class ConstFlow extends DataFlow::Configuration {
  ConstFlow() { this = "ConstFlow" }
>>>>>>> [CPP-370] First attempt at isAdditionalFlowStep().

  override predicate isSource(DataFlow::Node source) { isNonConst(source) }

  override predicate isSink(DataFlow::Node sink) {
    exists(FormattingFunctionCall fc |
      sink.asExpr() = fc.getArgument(fc.getFormatParameterIndex())
    )
  }

  override predicate isAdditionalFlowStep(DataFlow::Node source, DataFlow::Node sink) {
  	none()
  	or
    // an element picked from an array of string literals is a string literal
    exists(Variable v, int a |
      a = sink.asExpr().(ArrayExpr).getArrayOffset().getValue().toInt() and
      v = sink.asExpr().(ArrayExpr).getArrayBase().(VariableAccess).getTarget()
    |
    // we disallow parameters, since they may be bound to unsafe arguments
    // at various call sites.
      not v instanceof Parameter and source.asExpr() instanceof StringLiteral
      )
  }
}

from FormattingFunctionCall call, Expr formatString
where
  call.getArgument(call.getFormatParameterIndex()) = formatString and
  exists(NonConstFlow cf, DataFlow::Node source, DataFlow::Node sink |
    cf.hasFlow(source, sink) and
    sink.asExpr() = formatString
  )
select formatString,
  "The format string argument to " + call.getTarget().getName() +
    " should be constant to prevent security issues and other potential errors."
