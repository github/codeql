/**
 * Provides a taint-tracking configuration for detecting LDAP injection vulnerabilities
 */

import python
import semmle.python.Concepts
import semmle.python.dataflow.new.DataFlow
import semmle.python.dataflow.new.TaintTracking
import semmle.python.dataflow.new.RemoteFlowSources

/**
 * A taint-tracking configuration for detecting LDAP injections.
 */
class LDAPInjectionFlowConfig extends TaintTracking::Configuration {
  LDAPInjectionFlowConfig() { this = "LDAPInjectionFlowConfig" }

  override predicate isSource(DataFlow::Node source, DataFlow::FlowState state) {
    source instanceof RemoteFlowSource and
    state instanceof Unsafe
  }

  override predicate isSink(DataFlow::Node sink, DataFlow::FlowState state) {
    sink = any(LdapExecution ldap).getBaseDn() and
    (state instanceof Unsafe or state instanceof UnsafeForDn)
    or
    sink = any(LdapExecution ldap).getFilter() and
    (state instanceof Unsafe or state instanceof UnsafeForFilter)
  }

  override predicate isBarrier(DataFlow::Node node, DataFlow::FlowState state) {
    // All additional flow steps signify a state change.
    //    (n, `state`) --> (`node`, s)
    // Thus, if a node in `state` transitions to `node` and a new state,
    // then `state` should be blocked at `node`.
    isAdditionalFlowStep(_, state, node, _)
  }

  override predicate isAdditionalFlowStep(
    DataFlow::Node node1, DataFlow::FlowState state1, DataFlow::Node node2,
    DataFlow::FlowState state2
  ) {
    exists(LdapDnEscaping ldapDnEsc |
      node1 = ldapDnEsc.getAnInput() and
      node2 = ldapDnEsc.getOutput()
    |
      state1 instanceof Unsafe and
      state2 instanceof UnsafeForFilter
      or
      state1 instanceof UnsafeForDn and
      state2 instanceof Safe
    )
    or
    exists(LdapFilterEscaping ldapFilterEsc |
      node1 = ldapFilterEsc.getAnInput() and
      node2 = ldapFilterEsc.getOutput()
    |
      state1 instanceof Unsafe and
      state2 instanceof UnsafeForDn
      or
      state1 instanceof UnsafeForFilter and
      state2 instanceof Safe
    )
  }
}

/** A flow satte signifying generally unsafe input. */
class Unsafe extends DataFlow::FlowState {
  Unsafe() { this = "Unsafe" }
}

/** A flow state signifying input that is only unsafe for DNs. */
class UnsafeForDn extends DataFlow::FlowState {
  UnsafeForDn() { this = "UnsafeForDn" }
}

/** A flow state signifying input that is only unsafe for filter strings. */
class UnsafeForFilter extends DataFlow::FlowState {
  UnsafeForFilter() { this = "UnsafeForFilter" }
}

/**
 * A flow state that signifies safe input.
 * Including this makes `isAdditionalFlowStep` and `isBarrier` simpler.
 */
class Safe extends DataFlow::FlowState {
  Safe() { this = "Safe" }
}
