/**
 * Provides taint-tracking configurations for detecting LDAP injection vulnerabilities
 *
 * Note, for performance reasons: only import this file if
 * `LdapInjection::Configuration` is needed, otherwise
 * `LdapInjectionCustomizations` should be imported instead.
 */

import python
import semmle.python.Concepts
import semmle.python.dataflow.new.DataFlow
import semmle.python.dataflow.new.TaintTracking
import semmle.python.dataflow.new.RemoteFlowSources
import LdapInjectionCustomizations::LdapInjection

private module LdapInjectionDnConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof Source }

  predicate isSink(DataFlow::Node sink) { sink instanceof DnSink }

  predicate isBarrier(DataFlow::Node node) { node instanceof DnSanitizer }
}

/** Global taint-tracking for detecting "LDAP injection via the distinguished name (DN) parameter" vulnerabilities. */
module LdapInjectionDnFlow = TaintTracking::Global<LdapInjectionDnConfig>;

private module LdapInjectionFilterConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof Source }

  predicate isSink(DataFlow::Node sink) { sink instanceof FilterSink }

  predicate isBarrier(DataFlow::Node node) { node instanceof FilterSanitizer }
}

/** Global taint-tracking for detecting "LDAP injection via the filter parameter" vulnerabilities. */
module LdapInjectionFilterFlow = TaintTracking::Global<LdapInjectionFilterConfig>;

/** Global taint-tracking for detecting "LDAP injection" vulnerabilities. */
module LdapInjectionFlow =
  DataFlow::MergePathGraph<LdapInjectionDnFlow::PathNode, LdapInjectionFilterFlow::PathNode,
    LdapInjectionDnFlow::PathGraph, LdapInjectionFilterFlow::PathGraph>;
