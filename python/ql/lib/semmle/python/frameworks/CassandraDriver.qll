/**
 * Provides classes modeling security-relevant aspects of the `cassandra-driver` PyPI package.
 * See https://pypi.org/project/cassandra-driver/
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.dataflow.new.RemoteFlowSources
private import semmle.python.Concepts
private import semmle.python.ApiGraphs
private import semmle.python.frameworks.PEP249

/**
 * Provides models for the `cassandra-driver` PyPI package.
 * See https://pypi.org/project/cassandra-driver/
 */
private module CassandraDriver {
  /**
   * A cassandra cluster session.
   *
   * see
   * - https://docs.datastax.com/en/developer/python-driver/3.25/api/cassandra/cluster/#cassandra.cluster.Cluster.connect
   * - https://docs.datastax.com/en/developer/python-driver/3.25/api/cassandra/cluster/#cassandra.cluster.Session
   */
  API::Node session() {
    result =
      API::moduleImport("cassandra")
          .getMember("cluster")
          .getMember("Cluster")
          .getReturn()
          .getMember("connect")
          .getReturn()
  }

  /**
   * see https://docs.datastax.com/en/developer/python-driver/3.25/api/cassandra/cluster/#cassandra.cluster.Session.execute
   */
  class CassandraSessionExecuteCall extends SqlExecution::Range, API::CallNode {
    CassandraSessionExecuteCall() { this = session().getMember("execute").getACall() }

    override DataFlow::Node getSql() { result = this.getParameter(0, "query").asSink() }
  }

  /**
   * see https://docs.datastax.com/en/developer/python-driver/3.25/api/cassandra/cluster/#cassandra.cluster.Session.execute_async
   */
  class CassandraSessionExecuteAsyncCall extends SqlConstruction::Range, API::CallNode {
    CassandraSessionExecuteAsyncCall() { this = session().getMember("execute_async").getACall() }

    override DataFlow::Node getSql() { result = this.getParameter(0, "query").asSink() }
  }

  /**
   * see https://docs.datastax.com/en/developer/python-driver/3.25/api/cassandra/cluster/#cassandra.cluster.Session.prepare
   */
  class CassandraSessionPrepareCall extends SqlConstruction::Range, API::CallNode {
    CassandraSessionPrepareCall() { this = session().getMember("prepare").getACall() }

    override DataFlow::Node getSql() { result = this.getParameter(0, "query").asSink() }
  }
}
