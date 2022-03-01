/**
 * Provides class and predicates to track external data that
 * may represent malicious yaml-encoded objects.
 *
 * This module is intended to be imported into a taint-tracking query
 * to extend `TaintKind` and `TaintSink`.
 */

import python
import semmle.python.dataflow.TaintTracking
import semmle.python.security.strings.Untrusted
import semmle.python.security.injection.Deserialization

deprecated private FunctionObject yamlLoad() { result = ModuleObject::named("yaml").attr("load") }

/** `yaml.load(untrusted)` vulnerability. */
deprecated class YamlLoadNode extends DeserializationSink {
  override string toString() { result = "yaml.load vulnerability" }

  YamlLoadNode() {
    exists(CallNode call |
      yamlLoad().getACall() = call and
      call.getAnArg() = this
    )
  }

  override predicate sinks(TaintKind kind) { kind instanceof ExternalStringKind }
}
