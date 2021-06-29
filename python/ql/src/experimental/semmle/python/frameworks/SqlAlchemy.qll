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
   * Returns an instantization of a SqlAlchemy Session object.
   * See https://docs.sqlalchemy.org/en/14/orm/session_api.html#sqlalchemy.orm.Session and
   * https://docs.sqlalchemy.org/en/14/orm/session_api.html#sqlalchemy.orm.sessionmaker
   */
  private API::Node getSqlAlchemySessionInstance() {
    result = API::moduleImport("sqlalchemy.orm").getMember("Session").getReturn() or
    result = API::moduleImport("sqlalchemy.orm").getMember("sessionmaker").getReturn().getReturn()
  }

  /**
   * Returns an instantization of a SqlAlchemy Engine object.
   * See https://docs.sqlalchemy.org/en/14/core/engines.html#sqlalchemy.create_engine
   */
  private API::Node getSqlAlchemyEngineInstance() {
    result = API::moduleImport("sqlalchemy").getMember("create_engine").getReturn()
  }

  /**
   * Returns an instantization of a SqlAlchemy Query object.
   * See https://docs.sqlalchemy.org/en/14/orm/query.html?highlight=query#sqlalchemy.orm.Query
   */
  private API::Node getSqlAlchemyQueryInstance() {
    result = getSqlAlchemySessionInstance().getMember("query").getReturn()
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
      // new way
      this = getSqlAlchemySessionInstance().getMember("execute").getACall() or
      this =
        getSqlAlchemyEngineInstance()
            .getMember(["connect", "begin"])
            .getReturn()
            .getMember("execute")
            .getACall()
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
      this =
        [getSqlAlchemySessionInstance(), getSqlAlchemyEngineInstance()]
            .getMember("scalar")
            .getACall()
    }

    override DataFlow::Node getSql() { result = this.getArg(0) }
  }

  /**
   * A call on a Query object
   * See https://docs.sqlalchemy.org/en/14/orm/query.html?highlight=query#sqlalchemy.orm.Query
   */
  private class SqlAlchemyQueryCall extends DataFlow::CallCfgNode, SqlExecution::Range {
    SqlAlchemyQueryCall() { this = getSqlAlchemyQueryInstance().getAMember().getACall() }

    override DataFlow::Node getSql() { result = this.getArg(0) }
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
