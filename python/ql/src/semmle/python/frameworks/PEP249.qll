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
   * A source of an instance of `db.Connection`.
   *
   * This can include instantiation of the class, return value from function
   * calls, or a special parameter that will be set when functions are called by external
   * libraries.
   *
   * Use `Connection::instance()` predicate to get references to instances of `db.Connection`.
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
 * Provides models for the `db.Connection.cursor` method.
 * See https://www.python.org/dev/peps/pep-0249/#cursor.
 */
module cursor {
  /** Gets a reference to the `db.connection.cursor` method. */
  private DataFlow::Node methodRef(DataFlow::TypeTracker t) {
    t.startInAttr("cursor") and
    result = Connection::instance()
    or
    exists(DataFlow::TypeTracker t2 | result = methodRef(t2).track(t2, t))
  }

  /** Gets a reference to the `db.connection.cursor` metod. */
  DataFlow::Node methodRef() { result = methodRef(DataFlow::TypeTracker::end()) }

  /** Gets a reference to a result of calling `db.connection.cursor`. */
  private DataFlow::Node methodResult(DataFlow::TypeTracker t) {
    t.start() and
    result.asCfgNode().(CallNode).getFunction() = methodRef().asCfgNode()
    or
    exists(DataFlow::TypeTracker t2 | result = methodResult(t2).track(t2, t))
  }

  /** Gets a reference to a result of calling `db.connection.cursor`. */
  DataFlow::Node methodResult() { result = methodResult(DataFlow::TypeTracker::end()) }
}

/**
 * Gets a reference to the `db.Connection.Cursor.execute` function.
 * See https://www.python.org/dev/peps/pep-0249/#id15.
 */
private DataFlow::Node execute(DataFlow::TypeTracker t) {
  t.startInAttr("execute") and
  result = cursor::methodResult()
  or
  exists(DataFlow::TypeTracker t2 | result = execute(t2).track(t2, t))
}

/**
 * Gets a reference to the `db.Connection.Cursor.execute` function.
 * See https://www.python.org/dev/peps/pep-0249/#id15.
 */
DataFlow::Node execute() { result = execute(DataFlow::TypeTracker::end()) }

private class DbConnectionExecute extends SqlExecution::Range, DataFlow::CfgNode {
  override CallNode node;

  DbConnectionExecute() { node.getFunction() = execute().asCfgNode() }

  override DataFlow::Node getSql() {
    result.asCfgNode() in [node.getArg(0), node.getArgByName("sql")]
  }
}
