/** Provides a taint tracking configuration to reason about unvalidated user input that is used to construct LDAP queries. */

import java
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.security.LdapInjection

/**
 * A taint-tracking configuration for unvalidated user input that is used to construct LDAP queries.
 */
module LdapInjectionFlowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof ActiveThreatModelSource }

  predicate isSink(DataFlow::Node sink) { sink instanceof LdapInjectionSink }

  predicate isBarrier(DataFlow::Node node) { node instanceof LdapInjectionSanitizer }

  predicate isAdditionalFlowStep(DataFlow::Node pred, DataFlow::Node succ) {
    any(LdapInjectionAdditionalTaintStep a).step(pred, succ)
  }

  predicate observeDiffInformedIncrementalMode() { any() }
}

/** Tracks flow from remote sources to LDAP injection vulnerabilities. */
module LdapInjectionFlow = TaintTracking::Global<LdapInjectionFlowConfig>;
