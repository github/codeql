private import java
private import semmle.code.java.dataflow.DataFlow
private import codeql.util.Unit

/**
 * An extension point to allow a query to detect only the regular expressions
 * it needs in diff-informed incremental mode. The data-flow analysis that's
 * modified by this class has its sources as (certain) string literals and its
 * sinks as regular-expression matches.
 */
class RegexDiffInformedConfig instanceof Unit {
  /**
   * Holds if discovery of regular expressions should be diff-informed, which
   * is possible when there cannot be any elements selected by the query in the
   * diff range except the regular expressions and (locations derived from) the
   * places where they are matched against.
   */
  abstract predicate observeDiffInformedIncrementalMode();

  /**
   * Gets a location of a regex match that will be part of the query results.
   * If the query does not select the match locations, this predicate can be
   * `none()` for performance.
   */
  abstract Location getASelectedSinkLocation(DataFlow::Node sink);

  string toString() { result = "RegexDiffInformedConfig" }
}
