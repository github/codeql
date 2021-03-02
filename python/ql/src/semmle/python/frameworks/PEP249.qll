/**
 * Provides classes modeling PEP 249.
 * See https://www.python.org/dev/peps/pep-0249/.
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.dataflow.new.RemoteFlowSources
private import semmle.python.Concepts

/** A module implementing PEP 249. Extend this class for implementations. */
abstract class PEP249Module extends DataFlow::Node { }

/** Gets a reference to a connect call. */
private DataFlow::Node connect(DataFlow::TypeTracker t) {
  t.startInAttr("connect") and
  result instanceof PEP249Module
  or
  exists(DataFlow::TypeTracker t2 | result = connect(t2).track(t2, t))
}

/** Gets a reference to a connect call. */
DataFlow::Node connect() { result = connect(DataFlow::TypeTracker::end()) }

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
  private class ClassInstantiation extends InstanceSource, DataFlow::CfgNode {
    override CallNode node;

    ClassInstantiation() { node.getFunction() = connect().asCfgNode() }
  }

  /** Gets a reference to an instance of `db.Connection`. */
  private DataFlow::Node instance(DataFlow::TypeTracker t) {
    t.start() and
    result instanceof InstanceSource
    or
    exists(DataFlow::TypeTracker t2 | result = instance(t2).track(t2, t))
  }

  /** Gets a reference to an instance of `db.Connection`. */
  DataFlow::Node instance() { result = instance(DataFlow::TypeTracker::end()) }
}

/**
 * Provides models for the `cursor` method on a connection.
 * See https://www.python.org/dev/peps/pep-0249/#cursor.
 */
module cursor {
  /** Gets a reference to the `cursor` method on a connection. */
  private DataFlow::Node methodRef(DataFlow::TypeTracker t) {
    t.startInAttr("cursor") and
    result = Connection::instance()
    or
    exists(DataFlow::TypeTracker t2 | result = methodRef(t2).track(t2, t))
  }

  /** Gets a reference to the `cursor` method on a connection. */
  DataFlow::Node methodRef() { result = methodRef(DataFlow::TypeTracker::end()) }

  /** Gets a reference to a result of calling the `cursor` method on a connection. */
  private DataFlow::Node methodResult(DataFlow::TypeTracker t) {
    t.start() and
    result.asCfgNode().(CallNode).getFunction() = methodRef().asCfgNode()
    or
    exists(DataFlow::TypeTracker t2 | result = methodResult(t2).track(t2, t))
  }

  /** Gets a reference to a result of calling the `cursor` method on a connection. */
  DataFlow::Node methodResult() { result = methodResult(DataFlow::TypeTracker::end()) }
}

/**
 * Gets a reference to the `execute` method on a cursor (or on a connection).
 *
 * Note: while `execute` method on a connection is not part of PEP249, if it is used, we
 * recognize it as an alias for constructing a cursor and calling `execute` on it.
 *
 * See https://www.python.org/dev/peps/pep-0249/#id15.
 */
private DataFlow::Node execute(DataFlow::TypeTracker t) {
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
DataFlow::Node execute() { result = execute(DataFlow::TypeTracker::end()) }

/** A call to the `execute` method on a cursor (or on a connection). */
private class ExecuteCall extends SqlExecution::Range, DataFlow::CfgNode {
  override CallNode node;

  ExecuteCall() { node.getFunction() = execute().asCfgNode() }

  override DataFlow::Node getSql() {
    result.asCfgNode() in [node.getArg(0), node.getArgByName("sql")]
  }
}
