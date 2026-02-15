/**
 * Provides abstract classes representing generic concepts such as file system
 * access or system command execution, for which individual framework libraries
 * provide concrete subclasses.
 */
overlay[local?]
module;

import java

/**
 * A module importing the frameworks that implement `RegexMatch`es,
 * ensuring that they are visible to the concepts library.
 */
private module Frameworks {
  private import semmle.code.java.JDK
  private import semmle.code.java.frameworks.JavaxAnnotations
}

/**
 * An expression that represents a regular expression match.
 *
 * Extend this class to refine existing API models. If you want to model new APIs,
 * extend `RegexMatch::Range` instead.
 *
 * These are either method calls, which return `true` when there is a match, or
 * annotations, which are considered to match if they are present.
 */
class RegexMatch extends Expr instanceof RegexMatch::Range {
  /** Gets the expression for the regex being executed by this node. */
  Expr getRegex() { result = super.getRegex() }

  /** Gets an expression for the string to be searched or matched against. */
  Expr getString() { result = super.getString() }

  /** Gets an expression to be sanitized. */
  Expr getASanitizedExpr() { result = [this.getString(), super.getAdditionalSanitizedExpr()] }

  /**
   * Gets the name of this regex match, typically the name of an executing
   * method. This is used for nice alert messages and should include the
   * type-qualified name if possible.
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
   *
   * These are either method calls, which return `true` when there is a match, or
   * annotations, which are considered to match if they are present.
   */
  abstract class Range extends Expr {
    /** Gets the expression for the regex being executed by this node. */
    abstract Expr getRegex();

    /** Gets an expression for the string to be searched or matched against. */
    abstract Expr getString();

    /** Gets an additional expression to be sanitized, if any. */
    Expr getAdditionalSanitizedExpr() { none() }

    /**
     * Gets the name of this regex match, typically the name of an executing
     * method. This is used for nice alert messages and should include the
     * type-qualified name if possible.
     */
    abstract string getName();
  }
}
