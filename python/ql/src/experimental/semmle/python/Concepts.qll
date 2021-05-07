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

/** Provides classes for modeling LDAP query execution-related APIs. */
module LDAPQuery {
  /**
   * A data-flow node that collects methods executing a LDAP query.
   *
   * Extend this class to model new APIs. If you want to refine existing API models,
   * extend `LDAPQuery` instead.
   */
  abstract class Range extends DataFlow::Node {
    /**
     * Gets the argument containing the executed expression.
     */
    abstract DataFlow::Node getLDAPNode();
  }
}

/**
 * A data-flow node that collect methods executing a LDAP query.
 *
 * Extend this class to refine existing API models. If you want to model new APIs,
 * extend `LDAPQuery::Range` instead.
 */
class LDAPQuery extends DataFlow::Node {
  LDAPQuery::Range range;

  LDAPQuery() { this = range }

  /**
   * Gets the argument containing the executed expression.
   */
  DataFlow::Node getLDAPNode() { result = range.getLDAPNode() }
}

/** Provides classes for modeling LDAP components escape-related APIs. */
module LDAPEscape {
  /**
   * A data-flow node that collects functions escaping LDAP components.
   *
   * Extend this class to model new APIs. If you want to refine existing API models,
   * extend `LDAPEscape` instead.
   */
  abstract class Range extends DataFlow::Node {
    /**
     * Gets the argument containing the escaped expression.
     */
    abstract DataFlow::Node getEscapeNode();
  }
}

/**
 * A data-flow node that collects functions escaping LDAP components.
 *
 * Extend this class to refine existing API models. If you want to model new APIs,
 * extend `LDAPEscape::Range` instead.
 */
class LDAPEscape extends DataFlow::Node {
  LDAPEscape::Range range;

  LDAPEscape() { this = range }

  /**
   * Gets the argument containing the escaped expression.
   */
  DataFlow::Node getEscapeNode() { result = range.getEscapeNode() }
}
