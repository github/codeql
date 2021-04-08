/**
 * This version resides in the experimental area and provides a space for
 * external contributors to place new concepts, keeping to our preferred
 * structure while remaining in the experimental area.
 *
 * Provides abstract classes representing generic concepts such as file system
 * access or system command execution, for which individual framework libraries
 * provide concrete subclasses.
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.dataflow.new.RemoteFlowSources
private import semmle.python.dataflow.new.TaintTracking
private import experimental.semmle.python.Frameworks

/** Provides classes for modeling LDAP bind-related APIs. */
module LDAPBind {
  /**
   * A data-flow node that collects methods binding a LDAP connection.
   *
   * Extend this class to model new APIs. If you want to refine existing API models,
   * extend `LDAPBind` instead.
   */
  abstract class Range extends DataFlow::Node {
    /**
     * Gets the argument containing the binding expression.
     */
    abstract DataFlow::Node getPasswordNode();

    /**
     * Gets the argument containing the executed query.
     */
    abstract DataFlow::Node getQueryNode();
  }
}

/**
 * A data-flow node that collects methods binding a LDAP connection.
 *
 * Extend this class to refine existing API models. If you want to model new APIs,
 * extend `LDAPBind::Range` instead.
 */
class LDAPBind extends DataFlow::Node {
  LDAPBind::Range range;

  LDAPBind() { this = range }

  DataFlow::Node getPasswordNode() { result = range.getPasswordNode() }

  DataFlow::Node getQueryNode() { result = range.getQueryNode() }
}
