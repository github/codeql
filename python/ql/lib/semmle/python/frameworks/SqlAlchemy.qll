/**
 * Provides classes modeling security-relevant aspects of the `SQLAlchemy` PyPI package.
 * See
 *  - https://pypi.org/project/SQLAlchemy/
 *  - https://docs.sqlalchemy.org/en/14/index.html
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.dataflow.new.TaintTracking
private import semmle.python.ApiGraphs
private import semmle.python.Concepts
// This import is done like this to avoid importing the deprecated top-level things that
// would pollute the namespace
private import semmle.python.frameworks.PEP249::PEP249 as PEP249
private import semmle.python.frameworks.data.ModelsAsData

/**
 * INTERNAL: Do not use.
 *
 * Provides models for the `SQLAlchemy` PyPI package.
 * See
 *  - https://pypi.org/project/SQLAlchemy/
 *  - https://docs.sqlalchemy.org/en/14/index.html
 */
module SqlAlchemy {
  /**
   * Provides models for the `sqlalchemy.engine.Engine` and `sqlalchemy.future.Engine` classes.
   *
   * These are so similar that we model both in the same way.
   *
   * See
   *  - https://docs.sqlalchemy.org/en/14/core/connections.html#sqlalchemy.engine.Engine
   *  - https://docs.sqlalchemy.org/en/14/core/future.html#sqlalchemy.future.Engine
   */
  module Engine {
    /** Gets a reference to a SQLAlchemy Engine class. */
    API::Node classRef() {
      result = API::moduleImport("sqlalchemy").getMember("engine").getMember("Engine")
      or
      result = API::moduleImport("sqlalchemy").getMember("future").getMember("Engine")
      or
      result = ModelOutput::getATypeNode("sqlalchemy.engine.Engine~Subclass").getASubclass*()
    }

    /**
     * A source of instances of a SQLAlchemy Engine, extend this class to model new instances.
     *
     * This can include instantiations of the class, return values from function
     * calls, or a special parameter that will be set when functions are called by an external
     * library.
     *
     * Use the predicate `Engine::instance()` to get references to instances of a SQLAlchemy Engine.
     */
    abstract class InstanceSource extends DataFlow::LocalSourceNode { }

    private class EngineConstruction extends InstanceSource, DataFlow::CallCfgNode {
      EngineConstruction() {
        this = classRef().getACall()
        or
        this = API::moduleImport("sqlalchemy").getMember("create_engine").getACall()
        or
        this =
          API::moduleImport("sqlalchemy").getMember("future").getMember("create_engine").getACall()
        or
        this.(DataFlow::MethodCallNode).calls(instance(), "execution_options")
      }
    }

    /** Gets a reference to an instance of a SQLAlchemy Engine. */
    private DataFlow::TypeTrackingNode instance(DataFlow::TypeTracker t) {
      t.start() and
      result instanceof InstanceSource
      or
      exists(DataFlow::TypeTracker t2 | result = instance(t2).track(t2, t))
    }

    /** Gets a reference to an instance of a SQLAlchemy Engine. */
    DataFlow::Node instance() { instance(DataFlow::TypeTracker::end()).flowsTo(result) }
  }

  /**
   * Provides models for the `sqlalchemy.engine.base.Connection` and `sqlalchemy.future.Connection` classes.
   *
   * These are so similar that we model both in the same way.
   *
   * See
   * - https://docs.sqlalchemy.org/en/14/core/connections.html#sqlalchemy.engine.Connection
   * - https://docs.sqlalchemy.org/en/14/core/future.html#sqlalchemy.future.Connection
   */
  module Connection {
    /** Gets a reference to a SQLAlchemy Connection class. */
    API::Node classRef() {
      result =
        API::moduleImport("sqlalchemy")
            .getMember("engine")
            .getMember("base")
            .getMember("Connection")
      or
      result = API::moduleImport("sqlalchemy").getMember("future").getMember("Connection")
      or
      result = ModelOutput::getATypeNode("sqlalchemy.engine.Connection~Subclass").getASubclass*()
    }

    /**
     * A source of instances of a SQLAlchemy Connection, extend this class to model new instances.
     *
     * This can include instantiations of the class, return values from function
     * calls, or a special parameter that will be set when functions are called by an external
     * library.
     *
     * Use the predicate `Connection::instance()` to get references to instances of a SQLAlchemy Connection.
     */
    abstract class InstanceSource extends DataFlow::LocalSourceNode { }

    /**
     * join-ordering helper for ConnectionConstruction char-pred -- without this would
     * start with _all_ `CallCfgNode` and join those with `MethodCallNode` .. which is
     * silly
     */
    pragma[noinline]
    private DataFlow::MethodCallNode connectionConstruction_helper() {
      result.calls(Engine::instance(), ["begin", "connect"])
      or
      result.calls(instance(), ["connect", "execution_options"])
    }

    private class ConnectionConstruction extends InstanceSource, DataFlow::CallCfgNode {
      ConnectionConstruction() {
        // without the `pragma[only_bind_out]` we would start with joining
        // `API::Node.getACall` with `CallCfgNode` which is not optimal
        this = pragma[only_bind_out](classRef()).getACall()
        or
        this = connectionConstruction_helper()
      }
    }

    /** Gets a reference to an instance of a SQLAlchemy Connection. */
    private DataFlow::TypeTrackingNode instance(DataFlow::TypeTracker t) {
      t.start() and
      result instanceof InstanceSource
      or
      exists(DataFlow::TypeTracker t2 | result = instance(t2).track(t2, t))
    }

    /** Gets a reference to an instance of a SQLAlchemy Connection. */
    DataFlow::Node instance() { instance(DataFlow::TypeTracker::end()).flowsTo(result) }
  }

  /**
   * Provides models for the underlying DB-API Connection of a SQLAlchemy Connection.
   *
   * See https://docs.sqlalchemy.org/en/14/core/connections.html#dbapi-connections.
   */
  module DBApiConnection {
    /**
     * A source of instances of DB-API Connections, extend this class to model new instances.
     *
     * This can include instantiations of the class, return values from function
     * calls, or a special parameter that will be set when functions are called by an external
     * library.
     *
     * Use the predicate `DBAPIConnection::instance()` to get references to instances of DB-API Connections.
     */
    abstract class InstanceSource extends DataFlow::LocalSourceNode { }

    private class DBApiConnectionSources extends InstanceSource, PEP249::Connection::InstanceSource {
      DBApiConnectionSources() {
        this.(DataFlow::MethodCallNode).calls(Engine::instance(), "raw_connection")
        or
        this.(DataFlow::AttrRead).accesses(Connection::instance(), "connection")
      }
    }

    /** Gets a reference to an instance of DB-API Connections. */
    private DataFlow::TypeTrackingNode instance(DataFlow::TypeTracker t) {
      t.start() and
      result instanceof InstanceSource
      or
      exists(DataFlow::TypeTracker t2 | result = instance(t2).track(t2, t))
    }

    /** Gets a reference to an instance of DB-API Connections. */
    DataFlow::Node instance() { instance(DataFlow::TypeTracker::end()).flowsTo(result) }
  }

  /**
   * Provides models for the `sqlalchemy.orm.Session` class
   *
   * See
   * - https://docs.sqlalchemy.org/en/14/orm/session_api.html#sqlalchemy.orm.Session
   * - https://docs.sqlalchemy.org/en/14/orm/session_basics.html
   */
  module Session {
    /** Gets a reference to the `sqlalchemy.orm.Session` class. */
    API::Node classRef() {
      result = API::moduleImport("sqlalchemy").getMember("orm").getMember("Session")
      or
      result = ModelOutput::getATypeNode("sqlalchemy.orm.Session~Subclass").getASubclass*()
    }

    /**
     * A source of instances of `sqlalchemy.orm.Session`, extend this class to model new instances.
     *
     * This can include instantiations of the class, return values from function
     * calls, or a special parameter that will be set when functions are called by an external
     * library.
     *
     * Use the predicate `Session::instance()` to get references to instances of `sqlalchemy.orm.Session`.
     */
    abstract class InstanceSource extends DataFlow::LocalSourceNode { }

    private class SessionConstruction extends InstanceSource, DataFlow::CallCfgNode {
      SessionConstruction() {
        this = classRef().getACall()
        or
        this =
          API::moduleImport("sqlalchemy")
              .getMember("orm")
              .getMember("sessionmaker")
              .getReturn()
              .getACall()
        or
        this =
          API::moduleImport("sqlalchemy")
              .getMember("orm")
              .getMember("sessionmaker")
              .getReturn()
              .getMember("begin")
              .getACall()
        or
        this =
          API::moduleImport("sqlalchemy")
              .getMember("orm")
              .getMember("scoped_session")
              .getReturn()
              .getACall()
      }
    }

    /** Gets a reference to an instance of `sqlalchemy.orm.Session`. */
    private DataFlow::TypeTrackingNode instance(DataFlow::TypeTracker t) {
      t.start() and
      result instanceof InstanceSource
      or
      exists(DataFlow::TypeTracker t2 | result = instance(t2).track(t2, t))
    }

    /** Gets a reference to an instance of `sqlalchemy.orm.Session`. */
    DataFlow::Node instance() { instance(DataFlow::TypeTracker::end()).flowsTo(result) }
  }

  /**
   * A call to `execute` on a SQLAlchemy Engine, Connection, or Session.
   * See
   *  - https://docs.sqlalchemy.org/en/14/core/connections.html#sqlalchemy.engine.Engine.execute
   *  - https://docs.sqlalchemy.org/en/14/core/connections.html#sqlalchemy.engine.Connection.execute
   *  - https://docs.sqlalchemy.org/en/14/core/future.html#sqlalchemy.future.Connection.execute
   *  - https://docs.sqlalchemy.org/en/14/orm/session_api.html#sqlalchemy.orm.Session.execute
   */
  private class SqlAlchemyExecuteCall extends DataFlow::MethodCallNode, SqlExecution::Range {
    SqlAlchemyExecuteCall() {
      this.calls(Engine::instance(), "execute")
      or
      this.calls(Connection::instance(), "execute")
      or
      this.calls(Session::instance(), "execute")
    }

    override DataFlow::Node getSql() { result in [this.getArg(0), this.getArgByName("statement")] }
  }

  /**
   * A call to `exec_driver_sql` on a SQLAlchemy Connection.
   * See
   *  - https://docs.sqlalchemy.org/en/14/core/connections.html#sqlalchemy.engine.Connection.exec_driver_sql
   *  - https://docs.sqlalchemy.org/en/14/core/future.html#sqlalchemy.future.Connection.exec_driver_sql
   */
  private class SqlAlchemyExecDriverSqlCall extends DataFlow::MethodCallNode, SqlExecution::Range {
    SqlAlchemyExecDriverSqlCall() { this.calls(Connection::instance(), "exec_driver_sql") }

    override DataFlow::Node getSql() { result in [this.getArg(0), this.getArgByName("statement")] }
  }

  /**
   * A call to `scalar` on a SQLAlchemy Engine, Connection, or Session.
   * See
   *  - https://docs.sqlalchemy.org/en/14/core/connections.html#sqlalchemy.engine.Engine.scalar
   *  - https://docs.sqlalchemy.org/en/14/core/connections.html#sqlalchemy.engine.Connection.scalar
   *  - https://docs.sqlalchemy.org/en/14/core/future.html#sqlalchemy.future.Connection.scalar
   *  - https://docs.sqlalchemy.org/en/14/orm/session_api.html#sqlalchemy.orm.Session.scalar
   */
  private class SqlAlchemyScalarCall extends DataFlow::MethodCallNode, SqlExecution::Range {
    SqlAlchemyScalarCall() {
      this.calls(Engine::instance(), "scalar")
      or
      this.calls(Connection::instance(), "scalar")
      or
      this.calls(Session::instance(), "scalar")
    }

    override DataFlow::Node getSql() {
      result in [this.getArg(0), this.getArgByName("statement"), this.getArgByName("object_")]
    }
  }

  /**
   * Provides models for the `sqlalchemy.sql.expression.TextClause` class,
   * which represents a textual SQL string directly.
   *
   * ```py
   * session.query(For14).filter_by(description=sqlalchemy.text(f"'{user_input}'")).all()
   * ```
   *
   * Initially I wanted to add lots of additional taint steps for such that the normal
   * SQL injection query would be able to find cases as the one above where an ORM query
   * includes a TextClause that includes user-input directly... But that presented 2
   * problems:
   *
   * - which part of the query construction above should be marked as SQL to fit our
   *   `SqlExecution` concept. Nothing really fits this well, since all the SQL
   *   execution happens under the hood.
   * - This would require a LOT of modeling for these additional taint steps, since
   *   there are many many constructs we would need to have models for. (see the 2
   *   examples below)
   *
   * So instead we extended the SQL injection query to include TextClause construction
   * as a sink. And so we don't highlight any parts of an ORM constructed query such as
   * these as containing SQL, and don't need the additional taint steps either.
   *
   * See
   * - https://docs.sqlalchemy.org/en/14/core/sqlelement.html#sqlalchemy.sql.expression.TextClause.
   * - https://docs.sqlalchemy.org/en/14/core/sqlelement.html#sqlalchemy.sql.expression.text
   */
  module TextClause {
    /**
     * A construction of a `sqlalchemy.sql.expression.TextClause`, which represents a
     * textual SQL string directly.
     */
    abstract class TextClauseConstruction extends SqlConstruction::Range, DataFlow::CallCfgNode {
      /** Gets the argument that specifies the SQL text. */
      override DataFlow::Node getSql() { result in [this.getArg(0), this.getArgByName("text")] }
    }

    /** `TextClause` constructions from the `sqlalchemy` package. */
    private class DefaultTextClauseConstruction extends TextClauseConstruction {
      DefaultTextClauseConstruction() {
        this = API::moduleImport("sqlalchemy").getMember("text").getACall()
        or
        this = API::moduleImport("sqlalchemy").getMember("sql").getMember("text").getACall()
        or
        this =
          API::moduleImport("sqlalchemy")
              .getMember("sql")
              .getMember("expression")
              .getMember("text")
              .getACall()
        or
        this =
          API::moduleImport("sqlalchemy")
              .getMember("sql")
              .getMember("expression")
              .getMember("TextClause")
              .getACall()
      }
    }
  }
}
