/**
 * @name Non-constant format string
 * @description Passing a value that is not a string literal 'format' string to a printf-like function can lead
 *              to a mismatch between the number of arguments defined by the 'format' and the number
 *              of arguments actually passed to the function. If the format string ultimately stems
 *              from an untrusted source, this can be used for exploits.
 *              This query finds all sources leading to a format string that cannot be verified to be literal.
 *              Even if the format string type is `const char*` it is still considered non-constant if the
 *              value is not a string literal. For example, a parameter to a function that is never observed to be called
 *              that takes in a `const char*` and uses it as a format string, there is no way to verify the originating
 *              value was a string literal. This is especially problematic with conversion of c strings to char *,
 *              via `c_str()`, which returns a `const char*`, regardless if the original string was a string literal or not.
 *              The query does not consider uninitialized variables as non-constant sources. Uninitialized
 *              variables are a separate vulnerability concern and should be addressed by a separate query.
 * @kind path-problem
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
import semmle.code.cpp.security.FlowSources
import semmle.code.cpp.ir.dataflow.internal.ModelUtil
import semmle.code.cpp.models.interfaces.DataFlow
import semmle.code.cpp.models.interfaces.Taint
import semmle.code.cpp.ir.IR
import NonConstFlow::PathGraph

class UncalledFunction extends Function {
  UncalledFunction() {
    not exists(Call c | c.getTarget() = this) and
    // Ignore functions that appear to be function pointers
    // function pointers may be seen as uncalled statically
    not exists(FunctionAccess fa | fa.getTarget() = this)
  }
}

/**
 * Holds if `node` is a non-constant source of data flow for non-const format string detection.
 * This is defined as either:
 * 1) a `FlowSource`
 * 2) a parameter of an 'uncalled' function
 * 3) an argument to a function with no definition that is not known to define the output through its input
 * 4) an out arg of a function with no definition that is not known to define the output through its input
 *
 * The latter two cases address identifying standard string manipulation libraries as input sources
 * e.g., strcpy. More simply, functions without definitions that are known to manipulate the
 * input to produce an output are not sources. Instead the ultimate source of input to these functions
 * should be considered as the source.
 *
 * False Negative Implication: This approach has false negatives (fails to identify non-const sources)
 * when the source is a field of a struct or object and the initialization is not observed statically.
 * There are 3 general cases where this can occur:
 * 1) Parameters of uncalled functions that are structs/objects and a field is accessed for a format string.
 * 2) A local variable that is a struct/object and initialization of the field occurs in code that is unseen statically.
 *    e.g., an object constructor isn't known statically, or a function sets fields
 *    of a struct, but the function is not known statically.
 * 3) A function meeting cases (3) and (4) above returns (through an out argument or return value)
 *    a struct or object where a field containing a format string has been initialized.
 *
 * Note, uninitialized variables used as format strings are never detected by design.
 * Uninitialized variables are a separate vulnerability concern and should be addressed by a separate query.
 */
predicate isNonConst(DataFlow::Node node) {
  node instanceof FlowSource
  or
  // Parameters of uncalled functions that aren't const
  exists(UncalledFunction f, Parameter p |
    f.getAParameter() = p and
    p = node.asParameter() and 
    // Exclude main in this instance since that should have its own defined FlowSource
    // and including main would likely result in redundancy. 
    // Note, argc is not a flow source, so only filter out argv
    (p.getFunction().getName() = "main" implies not p.getName() = "argv")
  )
  or
  // Consider as an input any out arg of a function or a function's return where the function is not:
  // 1. a function with a known dataflow or taintflow from input to output and the `node` is the output
  // 2. a function where there is a known definition
  // i.e., functions that with unknown bodies and are not known to define the output through its input
  //       are considered as possible non-const sources
  // The function's output must also not be const to be considered a non-const source
  exists(Call c |
    exists(Expr arg | c.getAnArgument() = arg | arg = node.asDefiningArgument())
    or
    c = node.asIndirectExpr()
  ) and
  not exists(FunctionInput input, FunctionOutput output, CallInstruction call |
    // NOTE: we must include dataflow and taintflow. e.g., including only dataflow we will find sprintf
    // variant function's output are now possible non-const sources
    (
      pragma[only_bind_out](call.getStaticCallTarget())
          .(DataFlowFunction)
          .hasDataFlow(input, output) or
      pragma[only_bind_out](call.getStaticCallTarget()).(TaintFunction).hasTaintFlow(input, output)
    ) and
    node = callOutput(call, output)
  ) and
  not exists(Call c |
    c.getTarget().hasDefinition() and
    if node instanceof DataFlow::DefinitionByReferenceNode
    then c.getAnArgument() = node.asDefiningArgument()
    else c = [node.asExpr(), node.asIndirectExpr()]
  )
}

/**
 * Holds if `sink` is a sink is a format string of any
 * `FormattingFunctionCall`.
 */
predicate isSinkImpl(DataFlow::Node sink, Expr formatString) {
  [sink.asExpr(), sink.asIndirectExpr()] = formatString and
  exists(FormattingFunctionCall fc | formatString = fc.getArgument(fc.getFormatParameterIndex()))
}

module NonConstFlowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { isNonConst(source) }

  predicate isSink(DataFlow::Node sink) { isSinkImpl(sink, _) }

  predicate isBarrier(DataFlow::Node node) {
    // Ignore tracing non-const through array indices
    exists(ArrayExpr a | a.getArrayOffset() = node.asExpr())
  }
}

module NonConstFlow = TaintTracking::Global<NonConstFlowConfig>;

from
  FormattingFunctionCall call, Expr formatString, NonConstFlow::PathNode sink,
  NonConstFlow::PathNode source
where
  isSinkImpl(sink.getNode(), formatString) and
  call.getArgument(call.getFormatParameterIndex()) = formatString and
  NonConstFlow::flowPath(source, sink)
select sink.getNode(), source, sink,
  "The format string argument to $@ has a source which cannot be " +
    "verified to originate from a string literal.", call, call.getTarget().getName()
