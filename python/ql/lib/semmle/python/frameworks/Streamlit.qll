/**
 * Provides classes modeling security-relevant aspects of the `streamlit` PyPI package.
 * See https://pypi.org/project/streamlit/.
 */

import python
import semmle.python.dataflow.new.RemoteFlowSources
import semmle.python.dataflow.new.TaintTracking
import semmle.python.ApiGraphs
import semmle.python.Concepts
private import semmle.python.frameworks.SqlAlchemy

/**
 * Provides models for the `streamlit` PyPI package.
 * See https://pypi.org/project/streamlit/.
 */
module Streamlit {
  /**
   * The calls to the interactive streamlit widgets, which take untrusted input.
   */
  private class StreamlitInput extends RemoteFlowSource::Range {
    StreamlitInput() {
      this =
        API::moduleImport("streamlit")
            .getMember(["text_input", "text_area", "chat_input"])
            .getACall()
    }

    override string getSourceType() { result = "Streamlit user input" }
  }

  /**
   * The Streamlit SQLConnection class, which is used to create a connection to a SQL Database.
   * Streamlit wraps around SQL Alchemy for most database functionality, and adds some on top of it, such as the `query` method.
   * Streamlit can also connect to Snowflake and Snowpark databases, but the modeling is not the same, so we need to limit the scope to SQL databases.
   * https://docs.streamlit.io/develop/api-reference/connections/st.connections.sqlconnection#:~:text=to%20data.-,st.connections.SQLConnection,-Streamlit%20Version
   * We can connect to SQL databases for example with `import streamlit as st; conn = st.connection('pets_db', type='sql')`
   */
  private class StreamlitSqlConnection extends API::CallNode {
    StreamlitSqlConnection() {
      exists(StringLiteral str, API::CallNode n |
        str.getText() = "sql" and
        n = API::moduleImport("streamlit").getMember("connection").getACall() and
        DataFlow::exprNode(str)
            .(DataFlow::LocalSourceNode)
            .flowsTo([n.getArg(1), n.getArgByName("type")]) and
        this = n
      )
    }
  }

  /**
   * The `query` call that can execute raw queries on a connection to a SQL database.
   * https://docs.streamlit.io/develop/api-reference/connections/st.connection
   */
  private class QueryMethodCall extends DataFlow::CallCfgNode, SqlExecution::Range {
    QueryMethodCall() {
      exists(StreamlitSqlConnection s | this = s.getReturn().getMember("query").getACall())
    }

    override DataFlow::Node getSql() { result in [this.getArg(0), this.getArgByName("sql")] }
  }

  /**
   * The Streamlit SQLConnection.connect() call, which returns a a new sqlalchemy.engine.Connection object.
   * Streamlit creates a connection to a SQL database basing off SQL Alchemy, so we can reuse the models that we already have.
   */
  private class StreamlitSqlAlchemyConnection extends SqlAlchemy::Connection::InstanceSource {
    StreamlitSqlAlchemyConnection() {
      exists(StreamlitSqlConnection s | this = s.getReturn().getMember("connect").getACall())
    }
  }

  /**
   * The underlying SQLAlchemy Engine, accessed via `st.connection().engine`.
   * Streamlit creates an engine to a SQL database basing off SQL Alchemy, so we can reuse the models that we already have.
   */
  private class StreamlitSqlAlchemyEngine extends SqlAlchemy::Engine::InstanceSource {
    StreamlitSqlAlchemyEngine() {
      exists(StreamlitSqlConnection s | this = s.getReturn().getMember("engine").asSource())
    }
  }

  /**
   * The SQLAlchemy Session, accessed via `st.connection().session`.
   * Streamlit can create a session to a SQL database basing off SQL Alchemy, so we can reuse the models that we already have.
   * For example, the modeling for `session` includes an `execute` method, which is used to execute raw SQL queries.
   * https://docs.streamlit.io/develop/api-reference/connections/st.connections.sqlconnection#:~:text=SQLConnection.engine-,SQLConnection.session,-Streamlit%20Version
   */
  private class StreamlitSqlSession extends SqlAlchemy::Session::InstanceSource {
    StreamlitSqlSession() {
      exists(StreamlitSqlConnection s | this = s.getReturn().getMember("session").asSource())
    }
  }
}
