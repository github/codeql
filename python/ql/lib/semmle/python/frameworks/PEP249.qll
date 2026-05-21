/**
 * Provides classes modeling PEP 249.
 * See https://www.python.org/dev/peps/pep-0249/.
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.dataflow.new.RemoteFlowSources
private import semmle.python.Concepts
private import semmle.python.ApiGraphs
private import semmle.python.dataflow.new.internal.DataFlowDispatch as DataFlowDispatch

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

  /**
   * An API graph node representing a database connection.
   */
  abstract class DatabaseConnection extends API::Node {
    /** Gets a string representation of this element. */
    override string toString() { result = this.(API::Node).toString() }
  }

  private class DefaultDatabaseConnection extends DatabaseConnection {
    DefaultDatabaseConnection() {
      this = any(PEP249ModuleApiNode mod).getMember("connect").getReturn()
    }
  }

  /**
   * An API graph node representing a database cursor.
   */
  abstract class DatabaseCursor extends API::Node {
    /** Gets a string representation of this element. */
    override string toString() { result = this.(API::Node).toString() }
  }

  private class DefaultDatabaseCursor extends DatabaseCursor {
    DefaultDatabaseCursor() { this = any(DatabaseConnection conn).getMember("cursor").getReturn() }
  }

  private string getSqlKwargName() {
    result in ["sql", "statement", "operation", "query", "query_string", "sql_script"]
  }

  private string getExecuteMethodName() {
    result in ["execute", "executemany", "executescript", "execute_insert", "execute_fetchall"]
  }

  /**
   * A call to an execute method on a database cursor or a connection, such as `execute`
   * or `executemany`.
   *
   * See
   * - https://peps.python.org/pep-0249/#execute
   * - https://peps.python.org/pep-0249/#executemany
   *
   * Note: While `execute` method on a connection is not part of PEP249, if it is used, we
   * recognize it as an alias for constructing a cursor and calling `execute` on it.
   */
  private class ExecuteMethodCall extends SqlExecution::Range, API::CallNode {
    ExecuteMethodCall() {
      exists(API::Node start |
        start instanceof DatabaseCursor or start instanceof DatabaseConnection
      |
        this = start.getMember(getExecuteMethodName()).getACall()
      )
    }

    override DataFlow::Node getSql() {
      result in [this.getArg(0), this.getArgByName(getSqlKwargName()),]
    }
  }

  /** A call to a method that fetches rows from a previous execution. */
  private class FetchMethodCall extends ThreatModelSource::Range, API::CallNode {
    FetchMethodCall() {
      exists(API::Node start |
        start instanceof DatabaseCursor or start instanceof DatabaseConnection
      |
        // note: since we can't currently provide accesspaths for sources, these are all
        // lumped together, although clearly the fetchmany/fetchall returns a
        // list/iterable with rows.
        this = start.getMember(["fetchone", "fetchmany", "fetchall"]).getACall()
      )
    }

    override string getThreatModel() { result = "database" }

    override string getSourceType() { result = "cursor.fetch*()" }
  }

  // ---------------------------------------------------------------------------
  // asyncio implementations
  // ---------------------------------------------------------------------------
  //
  // we differentiate between normal and asyncio implementations, since we model the
  // `execute` call differently -- as a SqlExecution vs SqlConstruction, since the SQL
  // is only executed in asyncio after being awaited (which might happen in something
  // like `asyncio.gather`)
  /**
   * An API graph node representing a module that implements PEP 249 using asyncio.
   */
  abstract class AsyncPEP249ModuleApiNode extends API::Node {
    /** Gets a string representation of this element. */
    override string toString() { result = this.(API::Node).toString() }
  }

  /**
   * An API graph node representing a asyncio database connection (after being awaited).
   */
  abstract class AsyncDatabaseConnection extends API::Node {
    /** Gets a string representation of this element. */
    override string toString() { result = this.(API::Node).toString() }
  }

  private class DefaultAsyncDatabaseConnection extends AsyncDatabaseConnection {
    DefaultAsyncDatabaseConnection() {
      this = any(AsyncPEP249ModuleApiNode mod).getMember("connect").getReturn().getAwaited()
    }
  }

  /**
   * An API graph node representing a asyncio database cursor (after being awaited).
   */
  abstract class AsyncDatabaseCursor extends API::Node {
    /** Gets a string representation of this element. */
    override string toString() { result = this.(API::Node).toString() }
  }

  private class DefaultAsyncDatabaseCursor extends AsyncDatabaseCursor {
    DefaultAsyncDatabaseCursor() {
      this = any(AsyncDatabaseConnection conn).getMember("cursor").getReturn().getAwaited()
    }
  }

  /**
   * A call to an execute method on an asyncio database cursor or an asyncio connection,
   * such as `execute` or `executemany`.
   *
   * (This is not an SqlExecution, since that only happens when the coroutine is
   * awaited)
   *
   * See ExecuteMethodCall for more details.
   */
  private class AsyncExecuteMethodCall extends SqlConstruction::Range, API::CallNode {
    AsyncExecuteMethodCall() {
      exists(API::Node start |
        start instanceof AsyncDatabaseCursor or start instanceof AsyncDatabaseConnection
      |
        this = start.getMember(getExecuteMethodName()).getACall()
      )
    }

    override DataFlow::Node getSql() {
      result in [this.getArg(0), this.getArgByName(getSqlKwargName()),]
    }
  }

  /** Actual execution of the AsyncExecuteMethodCall coroutine. */
  private class AwaitedAsyncExecuteMethodCall extends SqlExecution::Range {
    AsyncExecuteMethodCall execute;

    AwaitedAsyncExecuteMethodCall() { this = execute.getReturn().getAwaited().asSource() }

    override DataFlow::Node getSql() { result = execute.getSql() }
  }

  // ---------------------------------------------------------------------------
  // old impl
  // ---------------------------------------------------------------------------
  // the goal is to deprecate it in favour of the API graph version, but currently this
  // requires a rewrite of the Peewee modeling, which depends on rewriting the
  // instance/instance-source stuff to use API graphs instead.
  // so is postponed for now.
  /** Gets a reference to the `connect` function of a module that implements PEP 249. */
  DataFlow::Node connect() {
    result = any(PEP249ModuleApiNode a).getMember("connect").getAValueReachableFromSource()
  }

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

    /**
     * Holds if class `cls` stores a PEP 249 database connection to `self.<attrName>`
     * in its `__init__` method, via a direct call to a `connect` function.
     */
    private predicate classStoresConnectionInInit(Class cls, string attrName) {
      exists(Function init, DataFlow::AttrWrite store |
        cls.getAMethod() = init and
        init.getName() = "__init__" and
        store.getAttributeName() = attrName and
        store.getObject().asCfgNode().getNode().(Name).getVariable() =
          init.getArg(0).asName().getVariable() and
        store.getValue() instanceof ConnectCall
      )
    }

    /**
     * A read of a connection-holding attribute within a method of a class whose
     * `__init__` stores a PEP 249 connection in that attribute.
     *
     * This recognizes patterns such as:
     * ```python
     * class Wrapper:
     *     def __init__(self):
     *         self._conn = dbapi.connect(...)
     *     def get_connection(self):
     *         return self._conn  # <-- recognized as a connection source
     * ```
     * Because the `AttrRead` node for `self._conn` inside `get_connection` is
     * also the `ExtractedReturnNode` for that statement, the existing TypeTracker
     * `returnStep` automatically propagates the connection type to all call sites
     * of `get_connection`.
     */
    private class ConnectionGetterAttributeRead extends InstanceSource, DataFlow::AttrRead {
      ConnectionGetterAttributeRead() {
        exists(Class cls, Function method, string attrName |
          classStoresConnectionInInit(cls, attrName) and
          cls.getAMethod() = method and
          method.getName() != "__init__" and
          this.getAttributeName() = attrName and
          this.getObject().asCfgNode().getNode().(Name).getVariable() =
            method.getArg(0).asName().getVariable()
        )
      }
    }

    /**
     * An attribute access on a constructor-call result that directly reads the
     * connection-holding attribute.
     *
     * This recognizes patterns such as:
     * ```python
     * class Wrapper:
     *     def __init__(self):
     *         self._conn = dbapi.connect(...)
     *
     * conn = Wrapper()._conn  # <-- recognized as a connection source
     * ```
     */
    private class ConnectionConstructorAttributeRead extends InstanceSource, DataFlow::AttrRead {
      ConnectionConstructorAttributeRead() {
        exists(Class cls, string attrName |
          classStoresConnectionInInit(cls, attrName) and
          this.getAttributeName() = attrName and
          DataFlowDispatch::resolveClassCall(this.getObject().asCfgNode().(CallNode), cls)
        )
      }
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
  }

  /**
   * Gets a reference to the `execute` method on a cursor (or on a connection).
   *
   * Note: while `execute` method on a connection is not part of PEP249, if it is used, we
   * recognize it as an alias for constructing a cursor and calling `execute` on it.
   *
   * See https://peps.python.org/pep-0249/#execute.
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
   * See https://peps.python.org/pep-0249/#execute.
   */
  DataFlow::Node execute() { execute(DataFlow::TypeTracker::end()).flowsTo(result) }

  /**
   * A call to the `execute` method on a cursor or a connection.
   *
   * See https://peps.python.org/pep-0249/#execute
   *
   * Note: While `execute` method on a connection is not part of PEP249, if it is used, we
   * recognize it as an alias for constructing a cursor and calling `execute` on it.
   */
  private class ExecuteCall extends SqlExecution::Range, DataFlow::CallCfgNode {
    ExecuteCall() {
      this.getFunction() = execute() and
      not this instanceof ExecuteMethodCall
    }

    override DataFlow::Node getSql() { result in [this.getArg(0), this.getArgByName("sql")] }
  }

  private DataFlow::TypeTrackingNode executemany(DataFlow::TypeTracker t) {
    t.startInAttr("executemany") and
    result in [Cursor::instance(), Connection::instance()]
    or
    exists(DataFlow::TypeTracker t2 | result = executemany(t2).track(t2, t))
  }

  private DataFlow::Node executemany() { executemany(DataFlow::TypeTracker::end()).flowsTo(result) }

  /**
   * A call to the `executemany` method on a cursor or a connection.
   *
   * See https://peps.python.org/pep-0249/#executemany
   *
   * Note: While `executemany` method on a connection is not part of PEP249, if it is used, we
   * recognize it as an alias for constructing a cursor and calling `executemany` on it.
   */
  private class ExecutemanyCall extends SqlExecution::Range, DataFlow::CallCfgNode {
    ExecutemanyCall() {
      this.getFunction() = executemany() and
      not this instanceof ExecuteMethodCall
    }

    override DataFlow::Node getSql() {
      result in [this.getArg(0), this.getArgByName(getSqlKwargName())]
    }
  }
}
