/**
 * Provides classes modeling security-relevant aspects of the 'SqlAlchemy' package.
 * See https://pypi.org/project/SQLAlchemy/.
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.dataflow.new.TaintTracking
private import semmle.python.ApiGraphs
private import semmle.python.Concepts

private module SqlAlchemy {
  /**
   * An instantization of a SqlAlchemy Session object.
   * See https://docs.sqlalchemy.org/en/14/orm/session_api.html#sqlalchemy.orm.Session and
   * https://docs.sqlalchemy.org/en/14/orm/session_api.html#sqlalchemy.orm.sessionmaker
   */
  private class SqlAlchemySessionInstance extends API::Node {
    SqlAlchemySessionInstance() {
      this in [
          API::moduleImport("sqlalchemy.orm").getMember("Session").getReturn(),
          API::moduleImport("sqlalchemy.orm").getMember("sessionmaker").getReturn().getReturn()
        ]
    }

    override string toString() { result = "Use of SqlAlchemy Session instantization" }
  }

  /**
   * An instantization of a SqlAlchemy Engine object.
   * See https://docs.sqlalchemy.org/en/14/core/engines.html#sqlalchemy.create_engine
   */
  private class SqlAlchemyEngineInstance extends API::Node {
    SqlAlchemyEngineInstance() {
      this = API::moduleImport("sqlalchemy").getMember("create_engine").getReturn()
    }

    override string toString() { result = "Use of SqlAlchemy create_engine member" }
  }

  /**
   * An instantization of a SqlAlchemy Query object.
   * See https://docs.sqlalchemy.org/en/14/orm/query.html?highlight=query#sqlalchemy.orm.Query
   */
  private class SqlAlchemyQueryInstance extends API::Node {
    SqlAlchemyQueryInstance() {
      this = any(SqlAlchemySessionInstance sessionInstance).getMember("query").getReturn()
    }

    override string toString() { result = "Use of SqlAlchemy Session Query member" }
  }

  /**
   * A call to `execute` meant to execute an SQL expression
   * See the following links:
   *   - https://docs.sqlalchemy.org/en/14/core/connections.html?highlight=execute#sqlalchemy.engine.Connection.execute
   *   - https://docs.sqlalchemy.org/en/14/core/connections.html?highlight=execute#sqlalchemy.engine.Engine.execute
   *   - https://docs.sqlalchemy.org/en/14/orm/session_api.html?highlight=execute#sqlalchemy.orm.Session.execute
   */
  private class SqlAlchemyExecuteCall extends DataFlow::CallCfgNode, SqlExecution::Range {
    SqlAlchemyExecuteCall() {
      exists(SqlAlchemySessionInstance sessionInstance, SqlAlchemyEngineInstance engineInstance |
        this = sessionInstance.getMember("execute").getACall() or
        this = engineInstance.getMember("connect").getReturn().getMember("execute").getACall() or
        this = engineInstance.getMember("begin").getReturn().getMember("execute").getACall()
      )
    }

    override DataFlow::Node getSql() { result = this.getArg(0) }
  }

  /**
   * A call to `scalar` meant to execute an SQL expression
   * See https://docs.sqlalchemy.org/en/14/orm/session_api.html#sqlalchemy.orm.Session.scalar and
   * https://docs.sqlalchemy.org/en/14/core/connections.html?highlight=scalar#sqlalchemy.engine.Engine.scalar
   */
  private class SqlAlchemyScalarCall extends DataFlow::CallCfgNode, SqlExecution::Range {
    SqlAlchemyScalarCall() {
      this = any(SqlAlchemySessionInstance sessionInstance).getMember("scalar").getACall() or
      this = any(SqlAlchemyEngineInstance engineInstance).getMember("scalar").getACall()
    }

    override DataFlow::Node getSql() { result = this.getArg(0) }
  }

  /**
   * A call on a Query object
   * See https://docs.sqlalchemy.org/en/14/orm/query.html?highlight=query#sqlalchemy.orm.Query
   */
  private class SqlAlchemyQueryCall extends DataFlow::CallCfgNode, SqlExecution::Range {
    SqlAlchemyQueryCall() {
      this = any(SqlAlchemyQueryInstance queryInstance).getAMember().getACall()
    }

    override DataFlow::Node getSql() { result = this.getArg(0) }
  }
}
