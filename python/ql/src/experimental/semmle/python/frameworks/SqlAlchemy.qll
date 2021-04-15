/**
 * Provides classes modeling security-relevant aspects of the 'SqlAlchemy' package.
 * See https://pypi.org/project/SQLAlchemy/.
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.dataflow.new.TaintTracking
private import semmle.python.ApiGraphs


private module SqlAlchemy {
  private class SqlAlchemySessionInstance extends API::Node {
    SqlAlchemySessionInstance() {
      this in [
          API::moduleImport("sqlalchemy.orm").getMember("Session").getReturn(),
          API::moduleImport("sqlalchemy.orm").getMember("sessionmaker").getReturn().getReturn()
        ]
    }

    override string toString() { result = "Use of SqlAlchemy Session instance method" }
  }

  private class SqlAlchemyEngineInstance extends API::Node {
    SqlAlchemyEngineInstance() {
      this = API::moduleImport("sqlalchemy").getMember("create_engine").getReturn()
    }

    override string toString() { result = "Use of SqlAlchemy Engine instance method" }
  }

  private class SqlAlchemyQueryInstance extends API::Node {
    SqlAlchemyQueryInstance() {
      this instanceof SqlAlchemySessionInstance and
      this = this.getMember("query").getReturn()
    }

    override string toString() { result = "Use of SqlAlchemy Query instance method" }
  }

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

  private class SqlAlchemyScalarCall extends DataFlow::CallCfgNode, SqlExecution::Range {
    SqlAlchemyScalarCall() {
      exists(SqlAlchemySessionInstance sessionInstance |
        this = sessionInstance.getMember("scalar").getACall()
      )
    }

    override DataFlow::Node getSql() { result = this.getArg(0) }
  }

  private class SqlAlchemyQueryCall extends DataFlow::CallCfgNode, SqlExecution::Range {
    SqlAlchemyQueryCall() {
      exists(SqlAlchemyQueryInstance queryInstance | this = queryInstance.getAMember().getACall())
    }

    override DataFlow::Node getSql() { result = this.getArg(0) }
  }
}
