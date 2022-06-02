/** DEPRECATED. Import `LdapInjectionQuery` instead. */

import python
import semmle.python.Concepts
import semmle.python.dataflow.new.DataFlow
import semmle.python.dataflow.new.TaintTracking
import semmle.python.dataflow.new.RemoteFlowSources

/** DEPRECATED. Import `LdapInjectionQuery` instead. */
deprecated module LdapInjection {
  import LdapInjectionQuery // ignore-query-import
}
