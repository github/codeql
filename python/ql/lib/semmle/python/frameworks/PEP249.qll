/**
 * Provides classes modeling PEP 249.
 * See https://www.python.org/dev/peps/pep-0249/.
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.dataflow.new.RemoteFlowSources
private import semmle.python.Concepts
private import semmle.python.ApiGraphs

/**
 * A module implementing PEP 249. Extend this class for implementations.
 *
 * DEPRECATED: Extend `PEP249ModuleApiNode` instead.
 */
abstract deprecated class PEP249Module extends DataFlow::Node { }

/**
 * An abstract class encompassing API graph nodes that implement PEP 249.
 * Extend this class for implementations.
 */
abstract class PEP249ModuleApiNode extends API::Node {
  /** Gets a string representation of this element. */
  override string toString() { result = this.(API::Node).toString() }
}

/** Gets a reference to a connect call. */
DataFlow::Node connect() { result = any(PEP249ModuleApiNode a).getMember("connect").getAUse() }

/**
 * Provides models for the `db.Connection` class
 *
 * See https://www.python.org/dev/peps/pep-0249/#connection-objects.
 */
module Connection {
  /**
   * A source of instances of `db.Connection`, extend this class to model new instances.
   *
   * This can include instantiations of the class, return values from function
   * calls, or a special parameter that will be set when functions are called by external
   * libraries.
   *
   * Use the predicate `Connection::instance()` to get references to instances of `db.Connection`.
   *
   * Extend this class if the module implementing PEP 249 offers more direct ways to obtain
   * a connection than going through `connect`.
   */
  abstract class InstanceSource extends DataFlow::Node { }

  /** A direct instantiation of `db.Connection`. */
  private class ClassInstantiation extends InstanceSource, DataFlow::CallCfgNode {
    ClassInstantiation() { this.getFunction() = connect() }
  }

  /** Gets a reference to an instance of `db.Connection`. */
  private DataFlow::TypeTrackingNode instance(DataFlow::TypeTracker t) {
    t.start() and
    result instanceof InstanceSource
    or
    exists(DataFlow::TypeTracker t2 | result = instance(t2).track(t2, t))
  }

  /** Gets a reference to an instance of `db.Connection`. */
  DataFlow::Node instance() { instance(DataFlow::TypeTracker::end()).flowsTo(result) }
}

/**
 * Provides models for the `cursor` method on a connection.
 * See https://www.python.org/dev/peps/pep-0249/#cursor.
 */
module cursor {
  /** Gets a reference to the `cursor` method on a connection. */
  private DataFlow::TypeTrackingNode methodRef(DataFlow::TypeTracker t) {
    t.startInAttr("cursor") and
    result = Connection::instance()
    or
    exists(DataFlow::TypeTracker t2 | result = methodRef(t2).track(t2, t))
  }

  /** Gets a reference to the `cursor` method on a connection. */
  DataFlow::Node methodRef() { methodRef(DataFlow::TypeTracker::end()).flowsTo(result) }

  /** Gets a reference to a result of calling the `cursor` method on a connection. */
  private DataFlow::TypeTrackingNode methodResult(DataFlow::TypeTracker t) {
    t.start() and
    result.asCfgNode().(CallNode).getFunction() = methodRef().asCfgNode()
    or
    exists(DataFlow::TypeTracker t2 | result = methodResult(t2).track(t2, t))
  }

  /** Gets a reference to a result of calling the `cursor` method on a connection. */
  DataFlow::Node methodResult() { methodResult(DataFlow::TypeTracker::end()).flowsTo(result) }
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
  result in [cursor::methodResult(), Connection::instance()]
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
