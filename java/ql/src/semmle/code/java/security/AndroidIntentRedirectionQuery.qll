/** Provides taint tracking configurations to be used in Android Intent redirection queries. */

import java
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.security.AndroidIntentRedirection

/**
 * A taint tracking configuration for user-provided Intents being used to start Android components.
 */
class IntentRedirectionConfiguration extends TaintTracking::Configuration {
  IntentRedirectionConfiguration() { this = "IntentRedirectionConfiguration" }

  override predicate isSource(DataFlow::Node source) { source instanceof IntentRedirectionSource }

  override predicate isSink(DataFlow::Node sink) { sink instanceof IntentRedirectionSink }

  override predicate isSanitizer(DataFlow::Node sanitizer) {
    sanitizer instanceof IntentRedirectionSanitizer
  }

  override predicate isAdditionalTaintStep(DataFlow::Node node1, DataFlow::Node node2) {
    any(IntentRedirectionAdditionalTaintStep c).step(node1, node2)
  }
}

/** The method `getParcelableExtra` called on a tainted `Intent`. */
private class IntentRedirectionSource extends DataFlow::Node {
  IntentRedirectionSource() {
    exists(GetParcelableExtra ma | this.asExpr() = ma.getQualifier()) and
    exists(IntentToGetParcelableExtraConf conf | conf.hasFlowTo(this))
  }
}

/**
 * Data flow from a remote intent to the qualifier of a `getParcelableExtra` call.
 */
private class IntentToGetParcelableExtraConf extends DataFlow2::Configuration {
  IntentToGetParcelableExtraConf() { this = "IntentToGetParcelableExtraConf" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) {
    exists(GetParcelableExtra ma | sink.asExpr() = ma.getQualifier())
  }
}

/** A call to the method `Intent.getParcelableExtra`. */
private class GetParcelableExtra extends MethodAccess {
  GetParcelableExtra() {
    exists(Method m |
      this.getMethod() = m and
      m.getDeclaringType() instanceof TypeIntent and
      m.hasName("getParcelableExtra")
    )
  }
}
