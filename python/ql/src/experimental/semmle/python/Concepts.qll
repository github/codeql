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

/**
 * To-Do:
 *
 * NoSQLExecution: Collects functions that execute nosql queries
 *  getNoSQLNode - get (Sink) argument holding the query
 * NoSQLEscape: Collects functions that escape nosql queries
 *  getNoSQLEscapeNode - get argument holding the query to-sanitize
 */
module NoSQLExecution { }
