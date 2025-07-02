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

  predicate observeDiffInformedIncrementalMode() {
    any() // TODO: Make sure that the location overrides match the query's select clause: Column 1 does not select a source or sink originating from the flow call on line 21 (/Users/d10c/src/semmle-code/ql/python/ql/src/Security/CWE-090/LdapInjection.ql@26:8:26:21), Column 5 does not select a source or sink originating from the flow call on line 21 (/Users/d10c/src/semmle-code/ql/python/ql/src/Security/CWE-090/LdapInjection.ql@27:68:27:83)
  }

  Location getASelectedSourceLocation(DataFlow::Node source) {
    none() // TODO: Make sure that this source location matches the query's select clause: Column 1 does not select a source or sink originating from the flow call on line 21 (/Users/d10c/src/semmle-code/ql/python/ql/src/Security/CWE-090/LdapInjection.ql@26:8:26:21), Column 5 does not select a source or sink originating from the flow call on line 21 (/Users/d10c/src/semmle-code/ql/python/ql/src/Security/CWE-090/LdapInjection.ql@27:68:27:83)
  }

  Location getASelectedSinkLocation(DataFlow::Node sink) {
    none() // TODO: Make sure that this sink location matches the query's select clause: Column 1 does not select a source or sink originating from the flow call on line 21 (/Users/d10c/src/semmle-code/ql/python/ql/src/Security/CWE-090/LdapInjection.ql@26:8:26:21), Column 5 does not select a source or sink originating from the flow call on line 21 (/Users/d10c/src/semmle-code/ql/python/ql/src/Security/CWE-090/LdapInjection.ql@27:68:27:83)
  }
}

/** Global taint-tracking for detecting "LDAP injection via the distinguished name (DN) parameter" vulnerabilities. */
module LdapInjectionDnFlow = TaintTracking::Global<LdapInjectionDnConfig>;

private module LdapInjectionFilterConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof Source }

  predicate isSink(DataFlow::Node sink) { sink instanceof FilterSink }

  predicate isBarrier(DataFlow::Node node) { node instanceof FilterSanitizer }

  predicate observeDiffInformedIncrementalMode() {
    any() // TODO: Make sure that the location overrides match the query's select clause: Column 1 does not select a source or sink originating from the flow call on line 24 (/Users/d10c/src/semmle-code/ql/python/ql/src/Security/CWE-090/LdapInjection.ql@26:8:26:21), Column 5 does not select a source or sink originating from the flow call on line 24 (/Users/d10c/src/semmle-code/ql/python/ql/src/Security/CWE-090/LdapInjection.ql@27:68:27:83)
  }

  Location getASelectedSourceLocation(DataFlow::Node source) {
    none() // TODO: Make sure that this source location matches the query's select clause: Column 1 does not select a source or sink originating from the flow call on line 24 (/Users/d10c/src/semmle-code/ql/python/ql/src/Security/CWE-090/LdapInjection.ql@26:8:26:21), Column 5 does not select a source or sink originating from the flow call on line 24 (/Users/d10c/src/semmle-code/ql/python/ql/src/Security/CWE-090/LdapInjection.ql@27:68:27:83)
  }

  Location getASelectedSinkLocation(DataFlow::Node sink) {
    none() // TODO: Make sure that this sink location matches the query's select clause: Column 1 does not select a source or sink originating from the flow call on line 24 (/Users/d10c/src/semmle-code/ql/python/ql/src/Security/CWE-090/LdapInjection.ql@26:8:26:21), Column 5 does not select a source or sink originating from the flow call on line 24 (/Users/d10c/src/semmle-code/ql/python/ql/src/Security/CWE-090/LdapInjection.ql@27:68:27:83)
  }
}

/** Global taint-tracking for detecting "LDAP injection via the filter parameter" vulnerabilities. */
module LdapInjectionFilterFlow = TaintTracking::Global<LdapInjectionFilterConfig>;

/** Global taint-tracking for detecting "LDAP injection" vulnerabilities. */
module LdapInjectionFlow =
  DataFlow::MergePathGraph<LdapInjectionDnFlow::PathNode, LdapInjectionFilterFlow::PathNode,
    LdapInjectionDnFlow::PathGraph, LdapInjectionFilterFlow::PathGraph>;
