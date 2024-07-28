/**
 * Module for parsing access paths from MaD models, both the identifying access path used
 * by dynamic languages, and the input/output specifications for summary steps.
 *
 * This file is used by the shared data flow library and by the JavaScript libraries
 * (which does not use the shared data flow libraries).
 */

/**
 * Convenience-predicate for extracting two capture groups at once.
 */
bindingset[input, regexp]
private predicate regexpCaptureTwo(string input, string regexp, string capture1, string capture2) {
  capture1 = input.regexpCapture(regexp, 1) and
  capture2 = input.regexpCapture(regexp, 2)
}

/**
 * Parses an integer constant `n` or interval `n1..n2` (inclusive) and gets the value
 * of the constant or any value contained in the interval.
 */
bindingset[arg]
int parseInt(string arg) {
  result = arg.toInt()
  or
  // Match "n1..n2"
  exists(string lo, string hi |
    regexpCaptureTwo(arg, "(-?\\d+)\\.\\.(-?\\d+)", lo, hi) and
    result = [lo.toInt() .. hi.toInt()]
  )
}

/**
 * Parses a lower-bounded interval `n..` and gets the lower bound.
 */
bindingset[arg]
int parseLowerBound(string arg) { result = arg.regexpCapture("(-?\\d+)\\.\\.", 1).toInt() }

/**
 * An access path token such as `Argument[1]` or `ReturnValue`.
 */
class AccessPathTokenBase extends string {
  bindingset[this]
  AccessPathTokenBase() { exists(this) }

  bindingset[this]
  private string getPart(int part) {
    result = this.regexpCapture("([^\\[]+)(?:\\[([^\\]]*)\\])?", part)
  }

  /** Gets the name of the token, such as `Member` from `Member[x]` */
  bindingset[this]
  string getName() { result = this.getPart(1) }

  /**
   * Gets the argument list, such as `1,2` from `Member[1,2]`,
   * or has no result if there are no arguments.
   */
  bindingset[this]
  string getArgumentList() { result = this.getPart(2) }

  /** Gets the `n`th argument to this token, such as `x` or `y` from `Member[x,y]`. */
  bindingset[this]
  string getArgument(int n) { result = this.getArgumentList().splitAt(",", n).trim() }

  /** Gets an argument to this token, such as `x` or `y` from `Member[x,y]`. */
  bindingset[this]
  string getAnArgument() { result = this.getArgument(_) }

  /** Gets the number of arguments to this token, such as 2 for `Member[x,y]` or zero for `ReturnValue`. */
  bindingset[this]
  int getNumArgument() { result = count(int n | exists(this.getArgument(n))) }
}

final private class AccessPathTokenBaseFinal = AccessPathTokenBase;

signature predicate accessPathRangeSig(string s);

/** Companion module to the `AccessPath` class. */
module AccessPath<accessPathRangeSig/1 accessPathRange> {
  /**
   * Parses an integer constant or interval (bounded or unbounded) that explicitly
   * references the arity, such as `N-1` or `N-3..N-1`.
   *
   * Note that expressions of form `N-x` will never resolve to a negative index,
   * even if `N` is zero (it will have no result in that case).
   */
  bindingset[arg, arity]
  private int parseIntWithExplicitArity(string arg, int arity) {
    result >= 0 and // do not allow N-1 to resolve to a negative index
    exists(string lo |
      // N-x
      lo = arg.regexpCapture("N-(\\d+)", 1) and
      result = arity - lo.toInt()
      or
      // N-x..
      lo = arg.regexpCapture("N-(\\d+)\\.\\.", 1) and
      result = [arity - lo.toInt(), arity - 1]
    )
    or
    exists(string lo, string hi |
      // x..N-y
      regexpCaptureTwo(arg, "(-?\\d+)\\.\\.N-(\\d+)", lo, hi) and
      result = [lo.toInt() .. arity - hi.toInt()]
      or
      // N-x..N-y
      regexpCaptureTwo(arg, "N-(\\d+)\\.\\.N-(\\d+)", lo, hi) and
      result = [arity - lo.toInt() .. arity - hi.toInt()] and
      result >= 0
      or
      // N-x..y
      regexpCaptureTwo(arg, "N-(\\d+)\\.\\.(\\d+)", lo, hi) and
      result = [arity - lo.toInt() .. hi.toInt()] and
      result >= 0
    )
  }

  /**
   * Parses an integer constant or interval (bounded or unbounded) and gets any
   * of the integers contained within (of which there may be infinitely many).
   *
   * Has no result for arguments involving an explicit arity, such as `N-1`.
   */
  bindingset[arg, result]
  int parseIntUnbounded(string arg) {
    result = parseInt(arg)
    or
    result >= parseLowerBound(arg)
  }

  /**
   * Parses an integer constant or interval (bounded or unbounded) that
   * may reference the arity of a call, such as `N-1` or `N-3..N-1`.
   *
   * Note that expressions of form `N-x` will never resolve to a negative index,
   * even if `N` is zero (it will have no result in that case).
   */
  bindingset[arg, arity]
  int parseIntWithArity(string arg, int arity) {
    result = parseInt(arg)
    or
    result in [parseLowerBound(arg) .. arity - 1]
    or
    result = parseIntWithExplicitArity(arg, arity)
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
  final class AccessPath extends string {
    AccessPath() { accessPathRange(this) }

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
   * An access path token such as `Argument[1]` or `ReturnValue`, appearing in one or more access paths.
   */
  class AccessPathToken extends AccessPathTokenBaseFinal {
    AccessPathToken() { this = getRawToken(_, _) }

    /** Gets the name of the token, such as `Member` from `Member[x]` */
    pragma[nomagic]
    string getName() { result = super.getName() }

    /**
     * Gets the argument list, such as `1,2` from `Member[1,2]`,
     * or has no result if there are no arguments.
     */
    pragma[nomagic]
    string getArgumentList() { result = super.getArgumentList() }

    /** Gets the `n`th argument to this token, such as `x` or `y` from `Member[x,y]`. */
    pragma[nomagic]
    string getArgument(int n) { result = super.getArgument(n) }

    /** Gets the `n`th argument to this `name` token, such as `x` or `y` from `Member[x,y]`. */
    pragma[nomagic]
    string getArgument(string name, int n) {
      name = this.getName() and result = this.getArgument(n)
    }

    /** Gets an argument to this token, such as `x` or `y` from `Member[x,y]`. */
    string getAnArgument() { result = this.getArgument(_) }

    /** Gets an argument to this `name` token, such as `x` or `y` from `Member[x,y]`. */
    string getAnArgument(string name) { result = this.getArgument(name, _) }

    /** Gets the number of arguments to this token, such as 2 for `Member[x,y]` or zero for `ReturnValue`. */
    pragma[nomagic]
    int getNumArgument() { result = count(int n | exists(this.getArgument(n))) }
  }
}
