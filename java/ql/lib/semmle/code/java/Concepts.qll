/**
 * Provides abstract classes representing generic concepts such as file system
 * access or system command execution, for which individual framework libraries
 * provide concrete subclasses.
 */
overlay[local?]
module;

import java
private import semmle.code.java.frameworks.JavaxAnnotations

/**
 * An expression that represents a regular expression match.
 *
 * Extend this class to refine existing API models. If you want to model new APIs,
 * extend `RegexMatch::Range` instead.
 */
class RegexMatch extends Expr instanceof RegexMatch::Range {
  /** Gets the expression for the regex being executed by this node. */
  Expr getRegex() { result = super.getRegex() }

  /** Gets an expression for the string to be searched or matched against. */
  Expr getString() { result = super.getString() }

  /**
   * Gets the name of this regex match, typically the name of an executing method.
   * This is used for nice alert messages and should include the module if possible.
   */
  string getName() { result = super.getName() }
}

/** Provides classes for modeling regular-expression execution APIs. */
module RegexMatch {
  /**
   * An expression that executes a regular expression.
   *
   * Extend this class to model new APIs. If you want to refine existing API models,
   * extend `RegexMatch` instead.
   */
  abstract class Range extends Expr {
    /** Gets the expression for the regex being executed by this node. */
    abstract Expr getRegex();

    /** Gets an expression for the string to be searched or matched against. */
    abstract Expr getString();

    /**
     * Gets the name of this regex match, typically the name of an executing method.
     * This is used for nice alert messages and should include the module if possible.
     */
    abstract string getName();
  }
}
