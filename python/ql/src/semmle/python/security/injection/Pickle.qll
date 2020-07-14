/**
 * Provides class and predicates to track external data that
 * may represent malicious pickles.
 *
 * This module is intended to be imported into a taint-tracking query
 * to extend `TaintKind` and `TaintSink`.
 */

import python
import semmle.python.dataflow.TaintTracking
import semmle.python.security.strings.Untrusted
import semmle.python.security.injection.Deserialization

private ModuleObject pickleModule() {
  result.getName() = "pickle"
  or
  result.getName() = "cPickle"
  or
  result.getName() = "dill"
}

private FunctionObject pickleLoads() { result = pickleModule().attr("loads") }

/** `pickle.loads(untrusted)` vulnerability. */
class UnpicklingNode extends DeserializationSink {
  override string toString() { result = "unpickling untrusted data" }

  UnpicklingNode() {
    exists(CallNode call |
      pickleLoads().getACall() = call and
      call.getAnArg() = this
    )
  }

  override predicate sinks(TaintKind kind) { kind instanceof ExternalStringKind }
}
