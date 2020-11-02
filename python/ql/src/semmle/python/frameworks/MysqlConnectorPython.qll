/**
 * Provides classes modeling security-relevant aspects of the `mysql-connector-python` package.
 * See
 * - https://dev.mysql.com/doc/connector-python/en/
 * - https://dev.mysql.com/doc/connector-python/en/connector-python-example-connecting.html
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.dataflow.new.RemoteFlowSources
private import semmle.python.Concepts
private import PEP249

/**
 * Provides models for the `mysql-connector-python` package.
 * See
 * - https://dev.mysql.com/doc/connector-python/en/
 * - https://dev.mysql.com/doc/connector-python/en/connector-python-example-connecting.html
 */
module MysqlConnectorPython {
  // ---------------------------------------------------------------------------
  // mysql
  // ---------------------------------------------------------------------------
  /** Gets a reference to the `mysql` module. */
  private DataFlow::Node mysql(DataFlow::TypeTracker t) {
    t.start() and
    result = DataFlow::importNode("mysql")
    or
    exists(DataFlow::TypeTracker t2 | result = mysql(t2).track(t2, t))
  }

  /** Gets a reference to the `mysql` module. */
  DataFlow::Node mysql() { result = mysql(DataFlow::TypeTracker::end()) }

  /**
   * Gets a reference to the attribute `attr_name` of the `mysql` module.
   * WARNING: Only holds for a few predefined attributes.
   */
  private DataFlow::Node mysql_attr(DataFlow::TypeTracker t, string attr_name) {
    attr_name in ["connector"] and
    (
      t.start() and
      result = DataFlow::importNode("mysql" + "." + attr_name)
      or
      t.startInAttr(attr_name) and
      result = mysql()
    )
    or
    // Due to bad performance when using normal setup with `mysql_attr(t2, attr_name).track(t2, t)`
    // we have inlined that code and forced a join
    exists(DataFlow::TypeTracker t2 |
      exists(DataFlow::StepSummary summary |
        mysql_attr_first_join(t2, attr_name, result, summary) and
        t = t2.append(summary)
      )
    )
  }

  pragma[nomagic]
  private predicate mysql_attr_first_join(
    DataFlow::TypeTracker t2, string attr_name, DataFlow::Node res, DataFlow::StepSummary summary
  ) {
    DataFlow::StepSummary::step(mysql_attr(t2, attr_name), res, summary)
  }

  /**
   * Gets a reference to the attribute `attr_name` of the `mysql` module.
   * WARNING: Only holds for a few predefined attributes.
   */
  private DataFlow::Node mysql_attr(string attr_name) {
    result = mysql_attr(DataFlow::TypeTracker::end(), attr_name)
  }

  /** Provides models for the `mysql` module. */
  module mysql {
    /**
     * The mysql.connector module
     * See https://dev.mysql.com/doc/connector-python/en/connector-python-example-connecting.html
     */
    class MysqlConnector extends PEP249Module {
      MysqlConnector() { this = mysql_attr("connector") }
    }
  }
}
