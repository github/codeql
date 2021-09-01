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

/**
 * Provides models for the `SQLAlchemy` PyPI package.
 * See
 *  - https://pypi.org/project/SQLAlchemy/
 *  - https://docs.sqlalchemy.org/en/14/index.html
 */
private module SqlAlchemy {
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
    private API::Node classRef() {
      result = API::moduleImport("sqlalchemy").getMember("engine").getMember("Engine")
      or
      result = API::moduleImport("sqlalchemy").getMember("future").getMember("Engine")
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
    private API::Node classRef() {
      result =
        API::moduleImport("sqlalchemy")
            .getMember("engine")
            .getMember("base")
            .getMember("Connection")
      or
      result = API::moduleImport("sqlalchemy").getMember("future").getMember("Connection")
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

    private class ConnectionConstruction extends InstanceSource, DataFlow::CallCfgNode {
      ConnectionConstruction() {
        this = classRef().getACall()
        or
        this.(DataFlow::MethodCallNode).calls(Engine::instance(), ["begin", "connect"])
        or
        this.(DataFlow::MethodCallNode).calls(instance(), "connect")
        or
        this.(DataFlow::MethodCallNode).calls(instance(), "execution_options")
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
  module DBAPIConnection {
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

    private class DBAPIConnectionSources extends InstanceSource, PEP249::Connection::InstanceSource {
      DBAPIConnectionSources() {
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
    private API::Node classRef() {
      result = API::moduleImport("sqlalchemy").getMember("orm").getMember("Session")
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
   * Additional taint-steps for `sqlalchemy.text()`
   *
   * See https://docs.sqlalchemy.org/en/14/core/sqlelement.html#sqlalchemy.sql.expression.text
   * See https://docs.sqlalchemy.org/en/14/core/sqlelement.html#sqlalchemy.sql.expression.TextClause
   */
  class SqlAlchemyTextAdditionalTaintSteps extends TaintTracking::AdditionalTaintStep {
    override predicate step(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
      exists(DataFlow::CallCfgNode call |
        (
          call = API::moduleImport("sqlalchemy").getMember("text").getACall()
          or
          call = API::moduleImport("sqlalchemy").getMember("sql").getMember("text").getACall()
          or
          call =
            API::moduleImport("sqlalchemy")
                .getMember("sql")
                .getMember("expression")
                .getMember("text")
                .getACall()
          or
          call =
            API::moduleImport("sqlalchemy")
                .getMember("sql")
                .getMember("expression")
                .getMember("TextClause")
                .getACall()
        ) and
        nodeFrom in [call.getArg(0), call.getArgByName("text")] and
        nodeTo = call
      )
    }
  }
}

private module OldModeling {
  /**
   * Returns an instantization of a SqlAlchemy Session object.
   * See https://docs.sqlalchemy.org/en/14/orm/session_api.html#sqlalchemy.orm.Session and
   * https://docs.sqlalchemy.org/en/14/orm/session_api.html#sqlalchemy.orm.sessionmaker
   */
  private API::Node getSqlAlchemySessionInstance() {
    result = API::moduleImport("sqlalchemy.orm").getMember("Session").getReturn() or
    result = API::moduleImport("sqlalchemy.orm").getMember("sessionmaker").getReturn().getReturn()
  }

  /**
   * Returns an instantization of a SqlAlchemy Query object.
   * See https://docs.sqlalchemy.org/en/14/orm/query.html?highlight=query#sqlalchemy.orm.Query
   */
  private API::Node getSqlAlchemyQueryInstance() {
    result = getSqlAlchemySessionInstance().getMember("query").getReturn()
  }

  /**
   * A call on a Query object
   * See https://docs.sqlalchemy.org/en/14/orm/query.html?highlight=query#sqlalchemy.orm.Query
   */
  private class SqlAlchemyQueryCall extends DataFlow::CallCfgNode, SqlExecution::Range {
    SqlAlchemyQueryCall() {
      this =
        getSqlAlchemyQueryInstance()
            .getMember(any(SqlAlchemyVulnerableMethodNames methodName))
            .getACall()
    }

    override DataFlow::Node getSql() { result = this.getArg(0) }
  }

  /**
   * This class represents a list of methods vulnerable to sql injection.
   *
   * See https://github.com/jty-team/codeql/pull/2#issue-611592361
   */
  private class SqlAlchemyVulnerableMethodNames extends string {
    SqlAlchemyVulnerableMethodNames() { this in ["filter", "filter_by", "group_by", "order_by"] }
  }
}
