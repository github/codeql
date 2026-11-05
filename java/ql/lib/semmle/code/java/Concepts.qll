/**
 * Provides abstract classes representing generic concepts such as file system
 * access or system command execution, for which individual framework libraries
 * provide concrete subclasses.
 */
overlay[local?]
module;

import java

/**
 * A module importing the frameworks that implement string matches,
 * ensuring that they are visible to the concepts library.
 */
private module Frameworks {
  private import semmle.code.java.JDK
  private import semmle.code.java.frameworks.apache.Lang
  private import semmle.code.java.frameworks.guava.Guava
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
 *
 * To use a `RegexMatch` as a barrier or sanitizer, instantiate
 * `DataFlow::BarrierGuard`. Method-call matches act as ordinary control-flow
 * barrier guards, while annotation matches are treated as direct barriers,
 * since an annotation does not dominate the expression it constrains;
 * `DataFlow::BarrierGuard` handles both, so callers need not distinguish the two.
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

/**
 * An expression that tests whether an input string contains a substring.
 *
 * Extend this class to refine existing API models. If you want to model new APIs,
 * extend `StringSubstringMatch::Range` instead.
 */
class StringSubstringMatch extends Expr instanceof StringSubstringMatch::Range {
  /** Gets the input string being tested. */
  Expr getInputString() { result = super.getInputString() }

  /** Gets the expression that specifies the substring. */
  Expr getMatchExpression() { result = super.getMatchExpression() }

  /** Gets an expression to be sanitized. */
  Expr getASanitizedExpr() { result = [this.getInputString(), super.getAdditionalSanitizedExpr()] }

  /** Holds if taking `branch` means that the input contains the substring. */
  predicate hasSubstringOnBranch(boolean branch) { super.hasSubstringOnBranch(branch) }

  /** Gets a descriptive name for this substring match. */
  string getName() { result = super.getName() }
}

/** Provides classes for modeling substring-matching APIs. */
module StringSubstringMatch {
  /** A range class for APIs that test whether an input contains a substring. */
  abstract class Range extends Expr {
    /** Gets the input string being tested. */
    abstract Expr getInputString();

    /** Gets the expression that specifies the substring. */
    abstract Expr getMatchExpression();

    /** Gets an additional expression to be sanitized, if any. */
    Expr getAdditionalSanitizedExpr() { none() }

    /** Holds if taking `branch` means that the input contains the substring. */
    abstract predicate hasSubstringOnBranch(boolean branch);

    /** Gets a descriptive name for this substring match. */
    abstract string getName();
  }
}

/**
 * An expression that tests whether an input string contains characters from a
 * character set.
 *
 * Extend this class to refine existing API models. If you want to model new APIs,
 * extend `StringCharacterSetMatch::Range` instead.
 */
class StringCharacterSetMatch extends Expr instanceof StringCharacterSetMatch::Range {
  /** Gets the input string being tested. */
  Expr getInputString() { result = super.getInputString() }

  /** Gets the expression that specifies the character set. */
  Expr getMatchExpression() { result = super.getMatchExpression() }

  /** Gets an expression to be sanitized. */
  Expr getASanitizedExpr() { result = [this.getInputString(), super.getAdditionalSanitizedExpr()] }

  /**
   * Holds if taking `branch` means that the input contains at least one
   * character from the match expression.
   */
  predicate hasMatchingCharacterOnBranch(boolean branch) {
    super.hasMatchingCharacterOnBranch(branch)
  }

  /** Gets a descriptive name for this character-set match. */
  string getName() { result = super.getName() }
}

/** Provides classes for modeling character-set matching APIs. */
module StringCharacterSetMatch {
  /**
   * A range class for APIs that test whether an input contains characters from
   * a character set.
   */
  abstract class Range extends Expr {
    /** Gets the input string being tested. */
    abstract Expr getInputString();

    /** Gets the expression that specifies the character set. */
    abstract Expr getMatchExpression();

    /** Gets an additional expression to be sanitized, if any. */
    Expr getAdditionalSanitizedExpr() { none() }

    /**
     * Holds if taking `branch` means that the input contains at least one
     * character from the match expression.
     */
    abstract predicate hasMatchingCharacterOnBranch(boolean branch);

    /** Gets a descriptive name for this character-set match. */
    abstract string getName();
  }
}

/**
 * An expression that replaces every occurrence of a target in a string.
 *
 * Extend this class to refine existing API models. If you want to model new APIs,
 * extend `StringReplacement::Range` instead.
 */
class StringReplacement extends Expr instanceof StringReplacement::Range {
  /** Gets the input string whose contents are replaced. */
  Expr getInputString() { result = super.getInputString() }

  /** Gets the expression that identifies the content to replace. */
  Expr getMatchExpression() { result = super.getMatchExpression() }

  /** Gets the replacement expression. */
  Expr getReplacement() { result = super.getReplacement() }

  /** Holds if the match expression is interpreted as a regular expression. */
  predicate matchExpressionIsRegex() { super.matchExpressionIsRegex() }

  /** Holds if each character in the match expression is matched independently. */
  predicate matchExpressionIsCharacterSet() { super.matchExpressionIsCharacterSet() }

  /** Gets a descriptive name for this replacement operation. */
  string getName() { result = super.getName() }
}

/** Provides classes for modeling string-replacement APIs. */
module StringReplacement {
  /**
   * An expression that replaces every occurrence of a target in a string.
   *
   * Extend this class to model new APIs. If you want to refine existing API models,
   * extend `StringReplacement` instead.
   */
  abstract class Range extends Expr {
    /** Gets the input string whose contents are replaced. */
    abstract Expr getInputString();

    /** Gets the expression that identifies the content to replace. */
    abstract Expr getMatchExpression();

    /** Gets the replacement expression. */
    abstract Expr getReplacement();

    /** Holds if the match expression is interpreted as a regular expression. */
    predicate matchExpressionIsRegex() { none() }

    /** Holds if each character in the match expression is matched independently. */
    predicate matchExpressionIsCharacterSet() { none() }

    /** Gets a descriptive name for this replacement operation. */
    abstract string getName();
  }
}

/**
 * An expression that removes every occurrence of a target from a string.
 *
 * Extend this class to refine existing API models. If you want to model new APIs,
 * extend `StringRemoval::Range` instead.
 */
class StringRemoval extends Expr instanceof StringRemoval::Range {
  /** Gets the input string whose contents are removed. */
  Expr getInputString() { result = super.getInputString() }

  /** Gets the expression that identifies the content to remove. */
  Expr getMatchExpression() { result = super.getMatchExpression() }

  /** Holds if the match expression is interpreted as a regular expression. */
  predicate matchExpressionIsRegex() { super.matchExpressionIsRegex() }

  /** Holds if each character in the match expression is matched independently. */
  predicate matchExpressionIsCharacterSet() { super.matchExpressionIsCharacterSet() }

  /** Gets a descriptive name for this removal operation. */
  string getName() { result = super.getName() }
}

/** Provides classes for modeling string-removal APIs. */
module StringRemoval {
  /**
   * An expression that removes every occurrence of a target from a string.
   *
   * Extend this class to model new APIs. If you want to refine existing API models,
   * extend `StringRemoval` instead.
   */
  abstract class Range extends Expr {
    /** Gets the input string whose contents are removed. */
    abstract Expr getInputString();

    /** Gets the expression that identifies the content to remove. */
    abstract Expr getMatchExpression();

    /** Holds if the match expression is interpreted as a regular expression. */
    predicate matchExpressionIsRegex() { none() }

    /** Holds if each character in the match expression is matched independently. */
    predicate matchExpressionIsCharacterSet() { none() }

    /** Gets a descriptive name for this removal operation. */
    abstract string getName();
  }
}
