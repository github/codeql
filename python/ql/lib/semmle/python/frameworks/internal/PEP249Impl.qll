/**
 * INTERNAL: Do not use.
 *
 * Provides internal implementation of PEP249. This currently resides in a different
 * file than `python/ql/src/semmle/python/frameworks/PEP249.qll`, since we used to
 * export everything without being encapsulated in a module, and shadowing rules means
 * that we can't just add the module directly to that file :(
 *
 * So once we can remove those deprecated things (Start of July 2022), we can also move
 * the core implementation into its' proper place.
 *
 * Provides classes modeling PEP 249.
 * See https://www.python.org/dev/peps/pep-0249/.
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.dataflow.new.RemoteFlowSources
private import semmle.python.Concepts
private import semmle.python.ApiGraphs

/**
 * Provides classes modeling database interfaces following PEP 249.
 * See https://www.python.org/dev/peps/pep-0249/.
 */
module PEP249 {
  /**
   * An API graph node representing a module that implements PEP 249.
   */
  abstract class PEP249ModuleApiNode extends API::Node {
    /** Gets a string representation of this element. */
    override string toString() { result = this.(API::Node).toString() }
  }

  /** Gets a reference to the `connect` function of a module that implements PEP 249. */
  DataFlow::Node connect() { result = any(PEP249ModuleApiNode a).getMember("connect").getAUse() }

  /**
   * Provides models for database connections (following PEP 249).
   *
   * See https://www.python.org/dev/peps/pep-0249/#connection-objects.
   */
  module Connection {
    /**
     * A source of database connections (following PEP 249), extend this class to model new instances.
     *
     * This can include instantiations of the class, return values from function
     * calls, or a special parameter that will be set when functions are called by external
     * libraries.
     *
     * Use the predicate `Connection::instance()` to get references to database connections (following PEP 249).
     *
     * Extend this class if the module implementing PEP 249 offers more direct ways to obtain
     * a connection than going through `connect`.
     */
    abstract class InstanceSource extends DataFlow::Node { }

    /** A call to the `connect` function of a module that implements PEP 249. */
    private class ConnectCall extends InstanceSource, DataFlow::CallCfgNode {
      ConnectCall() { this.getFunction() = connect() }
    }

    /** Gets a reference to a database connection (following PEP 249). */
    private DataFlow::TypeTrackingNode instance(DataFlow::TypeTracker t) {
      t.start() and
      result instanceof InstanceSource
      or
      exists(DataFlow::TypeTracker t2 | result = instance(t2).track(t2, t))
    }

    /** Gets a reference to a database connection (following PEP 249). */
    DataFlow::Node instance() { instance(DataFlow::TypeTracker::end()).flowsTo(result) }
  }

  /**
   * Provides models for database cursors (following PEP 249).
   *
   * These are returned by the `cursor` method on a database connection.
   * See https://www.python.org/dev/peps/pep-0249/#cursor.
   */
  module Cursor {
    /**
     * A source of database cursors (following PEP 249), extend this class to model new instances.
     *
     * This can include instantiations of the class, return values from function
     * calls, or a special parameter that will be set when functions are called by external
     * libraries.
     *
     * Use the predicate `Cursor::instance()` to get references to database cursors (following PEP 249).
     *
     * Extend this class if the module implementing PEP 249 offers more direct ways to obtain
     * a connection than going through `connect`.
     */
    abstract class InstanceSource extends DataFlow::LocalSourceNode { }

    /** Gets a reference to a database cursor. */
    private DataFlow::TypeTrackingNode instance(DataFlow::TypeTracker t) {
      t.start() and
      result instanceof InstanceSource
      or
      exists(DataFlow::TypeTracker t2 | result = instance(t2).track(t2, t))
    }

    /** Gets a reference to a database cursor. */
    DataFlow::Node instance() { instance(DataFlow::TypeTracker::end()).flowsTo(result) }

    /** Gets a reference to the `cursor` method on a database connection. */
    private DataFlow::TypeTrackingNode methodRef(DataFlow::TypeTracker t) {
      t.startInAttr("cursor") and
      result = Connection::instance()
      or
      exists(DataFlow::TypeTracker t2 | result = methodRef(t2).track(t2, t))
    }

    /** Gets a reference to the `cursor` method on a database connection. */
    DataFlow::Node methodRef() { methodRef(DataFlow::TypeTracker::end()).flowsTo(result) }

    /** A call to the `cursor` method on a database connection */
    private class CursorCall extends InstanceSource, DataFlow::CallCfgNode {
      CursorCall() { this.getFunction() = methodRef() }
    }

    /** Gets a reference to a result of calling the `cursor` method on a database connection. */
    private DataFlow::TypeTrackingNode methodResult(DataFlow::TypeTracker t) {
      t.start() and
      result.asCfgNode().(CallNode).getFunction() = methodRef().asCfgNode()
      or
      exists(DataFlow::TypeTracker t2 | result = methodResult(t2).track(t2, t))
    }

    /**
     * DEPRECATED: Use `Cursor::instance()` to get references to database cursors instead.
     *
     * Gets a reference to a result of calling the `cursor` method on a database connection.
     */
    deprecated DataFlow::Node methodResult() {
      methodResult(DataFlow::TypeTracker::end()).flowsTo(result)
    }
  }

  /**
   * Gets a reference to the `execute` method on a cursor (or on a connection).
   *
   * Note: while `execute` method on a connection is not part of PEP249, if it is used, we
   * recognize it as an alias for constructing a cursor and calling `execute` on it.
   *
   * See https://www.python.org/dev/peps/pep-0249/#id15.
   */
  private DataFlow::TypeTrackingNode execute(DataFlow::TypeTracker t) {
    t.startInAttr("execute") and
    result in [Cursor::instance(), Connection::instance()]
    or
    exists(DataFlow::TypeTracker t2 | result = execute(t2).track(t2, t))
  }

  /**
   * Gets a reference to the `execute` method on a cursor (or on a connection).
   *
   * Note: while `execute` method on a connection is not part of PEP249, if it is used, we
   * recognize it as an alias for constructing a cursor and calling `execute` on it.
   *
   * See https://www.python.org/dev/peps/pep-0249/#id15.
   */
  DataFlow::Node execute() { execute(DataFlow::TypeTracker::end()).flowsTo(result) }

  /** A call to the `execute` method on a cursor (or on a connection). */
  private class ExecuteCall extends SqlExecution::Range, DataFlow::CallCfgNode {
    ExecuteCall() { this.getFunction() = execute() }

    override DataFlow::Node getSql() { result in [this.getArg(0), this.getArgByName("sql")] }
  }
}
