/**
 * This version resides in the experimental area and provides a space for
 * external contributors to place new concepts, keeping to our preferred
 * structure while remaining in the experimental area.
 *
 * Provides abstract classes representing generic concepts such as file system
 * access or system command execution, for which individual framework libraries
 * provide concrete subclasses.
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.dataflow.new.RemoteFlowSources
private import semmle.python.dataflow.new.TaintTracking
private import experimental.semmle.python.Frameworks

module NoSQLQuery {
  abstract class Range extends DataFlow::Node {
    abstract DataFlow::Node getQuery();
  }
}

class NoSQLQuery extends DataFlow::Node {
  NoSQLQuery::Range range;

  NoSQLQuery() { this = range }

  DataFlow::Node getQuery() { result = range.getQuery() }
}

module NoSQLSanitizer {
  abstract class Range extends DataFlow::Node {
    abstract DataFlow::Node getSanitizerNode();
  }
}

class NoSQLSanitizer extends DataFlow::Node {
  NoSQLSanitizer::Range range;

  NoSQLSanitizer() { this = range }

  DataFlow::Node getSanitizerNode() { result = range.getSanitizerNode() }
}
