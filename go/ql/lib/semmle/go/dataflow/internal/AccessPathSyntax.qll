/**
 * Module for parsing access paths from CSV models, both the identifying access path used
 * by dynamic languages, and the input/output specifications for summary steps.
 *
 * This file is used by the shared data flow library and by the JavaScript libraries
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

/** Gets the `n`th token on the access path as a string. */
private string getRawToken(AccessPath path, int n) {
  // Avoid splitting by '.' since tokens may contain dots, e.g. `Field[foo.Bar.x]`.
  // Instead use regexpFind to match valid tokens, and supplement with a final length
  // check (in `AccessPath.hasSyntaxError`) to ensure all characters were included in a token.
  result = path.regexpFind("\\w+(?:\\[[^\\]]*\\])?(?=\\.|$)", n, _)
}

/**
 * A string that occurs as an access path (either identifying or input/output spec)
 * which might be relevant for this database.
 */
class AccessPath extends string instanceof AccessPath::Range {
  /** Holds if this string is not a syntactically valid access path. */
  predicate hasSyntaxError() {
    // If the lengths match, all characters must haven been included in a token
    // or seen by the `.` lookahead pattern.
    this != "" and
    not this.length() = sum(int n | | getRawToken(this, n).length() + 1) - 1
  }

  /** Gets the `n`th token on the access path (if there are no syntax errors). */
  AccessPathToken getToken(int n) {
    result = getRawToken(this, n) and
    not this.hasSyntaxError()
  }

  /** Gets the number of tokens on the path (if there are no syntax errors). */
  int getNumToken() {
    result = count(int n | exists(getRawToken(this, n))) and
    not this.hasSyntaxError()
  }
}

/**
 * An access part token such as `Argument[1]` or `ReturnValue`, appearing in one or more access paths.
 */
class AccessPathToken extends string {
  AccessPathToken() { this = getRawToken(any(AccessPath path), _) }

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
  string getArgument(int n) { result = this.getArgumentList().splitAt(",", n).trim() }

  /** Gets an argument to this token, such as `x` or `y` from `Member[x,y]`. */
  string getAnArgument() { result = this.getArgument(_) }

  /** Gets the number of arguments to this token, such as 2 for `Member[x,y]` or zero for `ReturnValue`. */
  int getNumArgument() { result = count(int n | exists(this.getArgument(n))) }
}
