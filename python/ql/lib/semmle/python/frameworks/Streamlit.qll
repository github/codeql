/**
 * Provides classes modeling security-relevant aspects of the `streamlit` PyPI package.
 * See https://pypi.org/project/streamlit/.
 */

import python
import semmle.python.dataflow.new.RemoteFlowSources
import semmle.python.dataflow.new.TaintTracking
import semmle.python.ApiGraphs
import semmle.python.Concepts

/**
 * Provides models for the `gradio` PyPI package.
 * See https://pypi.org/project/gradio/.
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
   * The `query` call that can execute raw queries on a connection to a SQL/Sonwflake/Snowpark database.
   * https://docs.streamlit.io/develop/api-reference/connections/st.connection
   */
  private class QueryMethodCall extends DataFlow::CallCfgNode, SqlExecution::Range {
    QueryMethodCall() {
      this =
        API::moduleImport("streamlit")
            .getMember("connection")
            .getReturn()
            .getMember("query")
            .getACall()
    }

    override DataFlow::Node getSql() { result in [this.getArg(0), this.getArgByName("sql")] }
  }
}
