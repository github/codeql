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

/** Provides classes for modeling Regular Expression-related APIs. */
module RegexExecution {
  /**
   * A data-flow node that works with regular expressions immediately executing an expression.
   *
   * Extend this class to model new APIs. If you want to refine existing API models,
   * extend `RegexExecution` instead.
   */
  abstract class Range extends DataFlow::Node {
    abstract DataFlow::Node getRegexNode();

    abstract Attribute getRegexMethod();
  }
}

/**
 * A data-flow node that works with regular expressions immediately executing an expression.
 *
 * Extend this class to refine existing API models. If you want to model new APIs,
 * extend `RegexExecution::Range` instead.
 */
class RegexExecution extends DataFlow::Node {
  RegexExecution::Range range;

  RegexExecution() { this = range }

  DataFlow::Node getRegexNode() { result = range.getRegexNode() }

  Attribute getRegexMethod() { result = range.getRegexMethod() }
}

/** Provides classes for modeling Regular Expression escape-related APIs. */
module RegexEscape {
  /**
   * A data-flow node that collects functions escaping regular expressions.
   *
   * Extend this class to model new APIs. If you want to refine existing API models,
   * extend `RegexEscape` instead.
   */
  abstract class Range extends DataFlow::Node {
    abstract DataFlow::Node getRegexNode();

    abstract Attribute getEscapeMethod();
  }
}

/**
 * A data-flow node that collects functions escaping regular expressions.
 *
 * Extend this class to refine existing API models. If you want to model new APIs,
 * extend `RegexEscape::Range` instead.
 */
class RegexEscape extends DataFlow::Node {
  RegexEscape::Range range;

  RegexEscape() { this = range }

  DataFlow::Node getRegexNode() { result = range.getRegexNode() }

  Attribute getEscapeMethod() { result = range.getEscapeMethod() }
}
