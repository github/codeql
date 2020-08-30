/**
 * Provides class and predicates to track external data that
 * may represent malicious marshals.
 *
 * This module is intended to be imported into a taint-tracking query
 * to extend `TaintKind` and `TaintSink`.
 */

import python
import semmle.python.dataflow.TaintTracking
import semmle.python.security.strings.Untrusted
import semmle.python.security.injection.Deserialization

private FunctionObject marshalLoads() { result = ModuleObject::named("marshal").attr("loads") }

/**
 * A taint sink that is potentially vulnerable to malicious marshaled objects.
 * The `vuln` in `marshal.loads(vuln)`.
 */
class UnmarshalingNode extends DeserializationSink {
  override string toString() { result = "unmarshaling vulnerability" }

  UnmarshalingNode() {
    exists(CallNode call |
      marshalLoads().getACall() = call and
      call.getAnArg() = this
    )
  }

  override predicate sinks(TaintKind kind) { kind instanceof ExternalStringKind }
}
