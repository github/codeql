/** Provides class and predicates to track external data that
 * may represent malicious Python code.
 *
 * This module is intended to be imported into a taint-tracking query
 * to extend `TaintKind` and `TaintSink`.
 *
 */
import python

import semmle.python.security.TaintTracking
import semmle.python.security.strings.Untrusted


private FunctionObject exec_or_eval() {
    result = Object::builtin("exec")
    or
    result = Object::builtin("eval")
}

/** A taint sink that represents an argument to exec or eval that is vulnerable to malicious input.
 * The `vuln` in `exec(vuln)` or similar.
 */
class StringEvaluationNode extends TaintSink {

    override string toString() { result = "exec or eval" }

    StringEvaluationNode() {
        exists(Exec exec |
            exec.getASubExpression().getAFlowNode() = this
        )
        or
        exists(CallNode call |
            exec_or_eval().getACall() = call and
            call.getAnArg() = this
        )
    }

    override predicate sinks(TaintKind kind) {
        kind instanceof ExternalStringKind
    }

}
