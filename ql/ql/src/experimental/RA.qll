/**
 * Parses RA expressions.
 */

/**
 * A predicate that contains RA.
 */
signature class RApredicate {
  string getLineOfRA(int n);
}

/**
 * Parses strings of RA provided by an RA predicate, and represented the
 */
module RAParser<RApredicate Predicate> {
  private string parseRaExpr(Predicate p, int line, int arity, int lhs) {
    exists(string str | str = p.getLineOfRA(line).trim() |
      arity = str.regexpCapture("\\{([0-9]+)\\} r([0-9]+) = (.+)", 1).toInt() and
      lhs = str.regexpCapture("\\{([0-9]+)\\} r([0-9]+) = (.+)", 2).toInt() and
      result = str.regexpCapture("\\{([0-9]+)\\} r([0-9]+) = (.+)", 3)
    )
  }

  bindingset[str]
  private int parseReturn(string str) {
    result = str.trim().regexpCapture("return r([0-9]+)", 1).toInt()
  }

  private newtype TRA =
    TReturn(Predicate p, int line, int v) { v = parseReturn(p.getLineOfRA(line)) } or
    TUnknown(Predicate p, int line, int lhs, int arity, string rhs) {
      rhs = parseRaExpr(p, line, arity, lhs)
    }

  /** An RA Expression. */
  abstract class RAExpr extends TRA {
    /** Gets the predicate this RA expression belongs to. */
    abstract Predicate getPredicate();

    /** Gets the line index of this RA expression. */
    abstract int getLine();

    /** Gets the LHS of the expression of the form `rNN = ...` */
    abstract int getLhs();

    /** Gets a variable of the form `rNN` in the RHS of the RA expression. */
    abstract int getARhsVariable();

    /** Gets the given arity of the RA expression. */
    abstract int getArity();

    /** Gets a predicate name referenced in the RHS of an RA expression. */
    abstract string getARhsPredicate();

    final string toString() { result = getPredicate().getLineOfRA(getLine()) }

    /** Gets a child of this RA expression - not by index yet. */
    RAExpr getAChild() {
      result.getPredicate() = this.getPredicate() and result.getLhs() = this.getARhsVariable()
    }
  }

  /**
   * A generic RA expression - where we haven't precisely parsed the RA expression type.
   * For Hackathon purposes, we probably don't need more than this.
   */
  class RAUnknownExpr extends RAExpr, TUnknown {
    Predicate p;
    int line;
    string rhs;
    int arity;
    int lhs;

    RAUnknownExpr() { this = TUnknown(p, line, lhs, arity, rhs) }

    override int getLine() { result = line }

    override Predicate getPredicate() { result = p }

    override int getLhs() { result = lhs }

    override int getARhsVariable() {
      result = rhs.splitAt(" ").regexpCapture("r([0-9]+)", 1).toInt()
    }

    // This is a dumb regex to find a predicate name - they always contain a `#` (TODO...)
    override string getARhsPredicate() { result = rhs.splitAt(" ") and result.indexOf("#") > 0 }

    override int getArity() { result = arity }
  }

  class RAReturnExpr extends RAExpr, TReturn {
    RAReturnExpr() { this = TReturn(p, line, res) }

    Predicate p;
    int line;
    int res;

    override Predicate getPredicate() { result = p }

    override int getLine() { result = line }

    override int getLhs() { none() }

    override int getARhsVariable() { result = res }

    override int getArity() { none() }

    override string getARhsPredicate() { none() }
  }
}
