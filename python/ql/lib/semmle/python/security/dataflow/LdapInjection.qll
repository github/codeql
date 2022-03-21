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

/**
 * Provides aint-tracking configurations for detecting LDAP injection vulnerabilities.class
 *
 * Two configurations are provided. One is for detecting LDAP injection
 * via the distinguished name (DN). The other is for detecting LDAP injection
 * via the filter. These require different escapings.
 */
module LdapInjection {
  import LdapInjectionQuery // ignore-query-import
}
