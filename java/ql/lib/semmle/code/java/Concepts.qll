/**
 * Provides abstract classes representing generic concepts such as file system
 * access or system command execution, for which individual framework libraries
 * provide concrete subclasses.
 */
overlay[local?]
module;

import java
private import semmle.code.java.dataflow.DataFlow
private import semmle.code.java.frameworks.JavaxAnnotations

/**
 * A data-flow node that executes a regular expression.
 *
 * Extend this class to refine existing API models. If you want to model new APIs,
 * extend `RegexExecution::Range` instead.
 */
class RegexExecution extends DataFlow::Node instanceof RegexExecution::Range {
  /** Gets the data flow node for the regex being executed by this node. */
  DataFlow::Node getRegex() { result = super.getRegex() }

  /** Gets a data flow node for the string to be searched or matched against. */
  DataFlow::Node getString() { result = super.getString() }

  /**
   * Gets the name of this regex execution, typically the name of an executing method.
   * This is used for nice alert messages and should include the module if possible.
   */
  string getName() { result = super.getName() }
}

/** Provides classes for modeling new regular-expression execution APIs. */
module RegexExecution {
  /**
   * A data flow node that executes a regular expression.
   *
   * Extend this class to model new APIs. If you want to refine existing API models,
   * extend `RegexExecution` instead.
   */
  abstract class Range extends DataFlow::Node {
    /** Gets the data flow node for the regex being executed by this node. */
    abstract DataFlow::Node getRegex();

    /** Gets a data flow node for the string to be searched or matched against. */
    abstract DataFlow::Node getString();

    /**
     * Gets the name of this regex execution, typically the name of an executing method.
     * This is used for nice alert messages and should include the module if possible.
     */
    abstract string getName();
  }

  private class RangeFromExpr extends Range {
    private RegexExecutionExpr::Range ree;

    RangeFromExpr() { this.asExpr() = ree }

    override DataFlow::Node getRegex() { result.asExpr() = ree.getRegex() }

    override DataFlow::Node getString() { result.asExpr() = ree.getString() }

    override string getName() { result = ree.getName() }
  }
}

/** Provides classes for modeling new regular-expression execution APIs. */
module RegexExecutionExpr {
  /**
   * An expression that executes a regular expression.
   *
   * Extend this class to model new APIs. If you want to refine existing API models,
   * extend `RegexExecution` instead.
   */
  abstract class Range extends Expr {
    /** Gets the expression for the regex being executed by this node. */
    abstract Expr getRegex();

    /** Gets a expression for the string to be searched or matched against. */
    abstract Expr getString();

    /**
     * Gets the name of this regex execution, typically the name of an executing method.
     * This is used for nice alert messages and should include the module if possible.
     */
    abstract string getName();
  }
}
