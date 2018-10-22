/**
 * @name Copy function using source size
 * @description Calling a copy operation with a size derived from the source
 *              buffer instead of the destination buffer may result in a buffer overflow.
 * @kind problem
 * @id cpp/overflow-destination
 * @problem.severity warning
 * @precision low
 * @tags reliability
 *       security
 *       external/cwe/cwe-119
 *       external/cwe/cwe-131
 */
import cpp
import semmle.code.cpp.dataflow.TaintTracking
import semmle.code.cpp.security.Security

/**
 * Holds if `fc` is a call to a copy operation where the size argument contains
 * a reference to the source argument.  For example:
 * ```
 *   memcpy(dest, src, sizeof(src));
 * ```
 */
predicate sourceSized(FunctionCall fc, Expr src)
{
  exists(string name |
    (name = "strncpy" or name = "strncat" or name = "memcpy" or name = "memmove") and
    fc.getTarget().hasQualifiedName(name))
  and
  exists(Expr dest, Expr size, Variable v |
    fc.getArgument(0) = dest and fc.getArgument(1) = src and fc.getArgument(2) = size and
    src = v.getAnAccess() and size.getAChild+() = v.getAnAccess() and

    // exception: `dest` is also referenced in the size argument
    not exists(Variable other |
      dest = other.getAnAccess() and size.getAChild+() = other.getAnAccess())
    and

    // exception: `src` and `dest` are both arrays of the same type and size
    not exists(ArrayType srctype, ArrayType desttype |
      dest.getType().getUnderlyingType() = desttype and
      src.getType().getUnderlyingType() = srctype and
      desttype.getBaseType().getUnderlyingType() = srctype.getBaseType().getUnderlyingType() and
      desttype.getArraySize() = srctype.getArraySize()))
}

/**
 * Taint configuration.
 */
class TaintConfig extends TaintTracking::Configuration {
  TaintConfig() {
    this = "TaintConfig"
  }

  override predicate isSource(DataFlow::Node source) {
    isUserInput(source.asExpr(), _)
  }

  override predicate isSink(DataFlow::Node sink) {
    sourceSized(_, sink.asExpr())
  }
}

from FunctionCall fc, TaintConfig taintConfig, DataFlow::Node taintSource, DataFlow::Node taintSink
where sourceSized(fc, taintSink.asExpr())
  and taintConfig.hasFlow(taintSource, taintSink)
select fc, "To avoid overflow, this operation should be bounded by destination-buffer size, not source-buffer size."
