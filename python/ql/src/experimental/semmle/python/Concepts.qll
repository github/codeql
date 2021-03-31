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
private import semmle.python.ApiGraphs

module LDAPQuery {
  abstract class Range extends DataFlow::Node {
    abstract DataFlow::Node getLDAPNode();

    abstract string getLDAPPart();
  }
}

class LDAPQuery extends DataFlow::Node {
  LDAPQuery::Range range;

  LDAPQuery() { this = range }

  DataFlow::Node getLDAPNode() { result = range.getLDAPNode() }

  string getLDAPPart() { result = range.getLDAPPart() }
}

module LDAPEscape {
  abstract class Range extends DataFlow::Node {
    abstract DataFlow::Node getEscapeNode();
  }
}

class LDAPEscape extends DataFlow::Node {
  LDAPEscape::Range range;

  LDAPEscape() { this = range }

  DataFlow::Node getEscapeNode() { result = range.getEscapeNode() }
}
