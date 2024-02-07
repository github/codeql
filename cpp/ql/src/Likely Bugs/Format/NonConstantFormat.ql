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
import semmle.code.cpp.security.FlowSources

class UncalledFunction extends Function {
  UncalledFunction() { 
    not exists(Call c | c.getTarget() = this)
   }
}

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


predicate isNonConst(DataFlow::Node node){
    exists(Call fc | fc = [node.asExpr(), node.asIndirectExpr()] |
      not (
        whitelistFunction(fc.getTarget(), _) or
        fc.getTarget().hasDefinition()
      )
    )
    or
    exists(UncalledFunction f | f.getAParameter() = node.asParameter())
    or
    (
      node instanceof DataFlow::DefinitionByReferenceNode and
      not exists(FormattingFunctionCall fc | node.asDefiningArgument() = fc.getOutputArgument(_)) and
      not exists(Call c | c.getAnArgument() = node.asDefiningArgument() and c.getTarget().hasDefinition())
    )
    or node instanceof FlowSource
}



predicate isSinkImpl(DataFlow::Node sink, Expr formatString) {
  [sink.asExpr(), sink.asIndirectExpr()] = formatString and
  exists(FormattingFunctionCall fc | formatString = fc.getArgument(fc.getFormatParameterIndex()))
}


module NonConstFlowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    isNonConst(source)
  }

  predicate isSink(DataFlow::Node sink) { isSinkImpl(sink, _) }

  predicate isAdditionalFlowStep(DataFlow::Node n1, DataFlow::Node n2){
    exists(Call c, int ind |
      whitelistFunction(c.getTarget(), ind)
      and c.getArgument(ind) = [n1.asExpr(), n1.asIndirectExpr()]
      and n2.asIndirectExpr() = c
      )

  }

}

module NonConstFlow = TaintTracking::Global<NonConstFlowConfig>;


from FormattingFunctionCall call, Expr formatString
where
  call.getArgument(call.getFormatParameterIndex()) = formatString and
  exists(DataFlow::Node sink |
    NonConstFlow::flowTo(sink) and
    isSinkImpl(sink, formatString)
  )
select formatString,
  "The format string argument to " + call.getTarget().getName() +
    " should be constant to prevent security issues and other potential errors."

