/** Provides a taint-tracking model to reason about Data-Source name injection vulnerabilities. */

import go
import semmle.go.dataflow.barrierguardutil.RegexpCheck

/** A source for `DsnInjection` taint-flow configuration. */
abstract class Source extends DataFlow::Node { }

/**
 * DEPRECATED: Use `DsnInjectionFlow` instead.
 *
 *  A taint-tracking configuration to reason about Data Source Name injection vulnerabilities.
 */
deprecated class DsnInjection extends TaintTracking::Configuration {
  DsnInjection() { this = "DsnInjection" }

  override predicate isSource(DataFlow::Node node) { node instanceof Source }

  override predicate isSink(DataFlow::Node node) {
    exists(DataFlow::CallNode c |
      c.getTarget().hasQualifiedName("database/sql", "Open") and
      c.getArgument(0).getStringValue() = "mysql"
    |
      node = c.getArgument(1)
    )
  }

  override predicate isSanitizer(DataFlow::Node node) { node instanceof RegexpCheckBarrier }
}

private module DsnInjectionConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof Source }

  predicate isSink(DataFlow::Node sink) {
    exists(DataFlow::CallNode c |
      c.getTarget().hasQualifiedName("database/sql", "Open") and
      c.getArgument(0).getStringValue() = "mysql"
    |
      sink = c.getArgument(1)
    )
  }

  predicate isBarrier(DataFlow::Node node) { node instanceof RegexpCheckBarrier }
}

/**
 * Tracks taint flow for reasoning about Data Source Name injection
 * vulnerabilities.
 */
module DsnInjectionFlow = TaintTracking::Global<DsnInjectionConfig>;

/** A model of a function which decodes or unmarshals a tainted input, propagating taint from any argument to either the method receiver or return value. */
private class DecodeFunctionModel extends TaintTracking::FunctionModel {
  DecodeFunctionModel() {
    // This matches any function with a name like `Decode`,`Unmarshal` or `Parse`.
    // This is done to allow taints stored in encoded forms, such as in toml or json to flow freely.
    this.getName().regexpMatch("(?i).*(parse|decode|unmarshal).*")
  }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    input.isParameter(_) and
    (output.isResult(0) or output.isReceiver())
  }
}

/** A model of `flag.Parse`, propagating tainted input passed via CLI flags to `Parse`'s result. */
private class FlagSetFunctionModel extends TaintTracking::FunctionModel {
  FlagSetFunctionModel() { this.hasQualifiedName("flag", "Parse") }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    input.isParameter(0) and output.isResult()
  }
}
