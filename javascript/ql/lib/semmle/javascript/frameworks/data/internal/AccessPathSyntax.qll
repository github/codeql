/**
 * Module for parsing access paths from CSV models, both the identifying access path used
 * by dynamic languages, and the input/output specifications for summary steps.
 *
 * This file is used by shared data flow library and by the JavaScript libraries
 * (which does not use the shared data flow libraries).
 */

/** Companion module to the `AccessPath` class. */
module AccessPath {
  /** A string that should be parsed as an access path. */
  abstract class Range extends string {
    bindingset[this]
    Range() { any() }
  }
}

/**
 * A string that occurs as an access path (either identifying or input/output spec)
 * which might be relevant for this database.
 */
class AccessPath extends string instanceof AccessPath::Range {
  /** Gets the `n`th token on the access path as a string. */
  string getRawToken(int n) {
    this != "" and // The empty path should have zero tokens, not a single empty token
    result = this.splitAt(".", n)
  }

  /** Gets the `n`th token on the access path. */
  AccessPathToken getToken(int n) { result = this.getRawToken(n) }

  /** Gets the number of tokens on the path. */
  int getNumToken() { result = count(int n | exists(this.getRawToken(n))) }
}

/**
 * An access part token such as `Argument[1]` or `ReturnValue`, appearing in one or more access paths.
 */
class AccessPathToken extends string {
  AccessPathToken() { this = any(AccessPath path).getRawToken(_) }

  private string getPart(int part) {
    result = this.regexpCapture("([^\\[]+)(?:\\[([^\\]]*)\\])?", part)
  }

  /** Gets the name of the token, such as `Member` from `Member[x]` */
  string getName() { result = this.getPart(1) }

  /**
   * Gets the argument list, such as `1,2` from `Member[1,2]`,
   * or has no result if there are no arguments.
   */
  string getArgumentList() { result = this.getPart(2) }

  /** Gets the `n`th argument to this token, such as `x` or `y` from `Member[x,y]`. */
  string getArgument(int n) { result = this.getArgumentList().splitAt(",", n) }

  /** Gets an argument to this token, such as `x` or `y` from `Member[x,y]`. */
  string getAnArgument() { result = this.getArgument(_) }

  /** Gets the number of arguments to this token, such as 2 for `Member[x,y]` or zero for `ReturnValue`. */
  int getNumArgument() { result = count(int n | exists(this.getArgument(n))) }
}
