/**
 * Provides class and predicates to track external data that
 * may represent malicious Python code.
 *
 * This module is intended to be imported into a taint-tracking query
 * to extend `TaintKind` and `TaintSink`.
 */

import python
import semmle.python.dataflow.TaintTracking
import semmle.python.security.strings.Untrusted

/**
 * A taint sink that represents an argument to exec or eval that is vulnerable to malicious input.
 * The `vuln` in `exec(vuln)` or similar.
 */
class StringEvaluationNode extends TaintSink {
  override string toString() { result = "exec or eval" }

  StringEvaluationNode() {
    exists(Exec exec | exec.getASubExpression().getAFlowNode() = this)
    or
    Value::named("exec").getACall().getAnArg() = this
    or
    Value::named("eval").getACall().getAnArg() = this
  }

  override predicate sinks(TaintKind kind) { kind instanceof ExternalStringKind }
}
