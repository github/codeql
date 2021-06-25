/**
 * Provides abstract classes representing generic concepts such as file system
 * access or system command execution, for which individual framework libraries
 * provide concrete subclasses.
 */

private import codeql_ruby.DataFlow
private import codeql_ruby.Frameworks

/**
 * A data-flow node that executes SQL statements.
 *
 * Extend this class to refine existing API models. If you want to model new APIs,
 * extend `SqlExecution::Range` instead.
 */
class SqlExecution extends DataFlow::Node {
  SqlExecution::Range range;

  SqlExecution() { this = range }

  /** Gets the argument that specifies the SQL statements to be executed. */
  DataFlow::Node getSql() { result = range.getSql() }
}

/** Provides a class for modeling new SQL execution APIs. */
module SqlExecution {
  /**
   * A data-flow node that executes SQL statements.
   *
   * Extend this class to model new APIs. If you want to refine existing API models,
   * extend `SqlExecution` instead.
   */
  abstract class Range extends DataFlow::Node {
    /** Gets the argument that specifies the SQL statements to be executed. */
    abstract DataFlow::Node getSql();
  }
}
