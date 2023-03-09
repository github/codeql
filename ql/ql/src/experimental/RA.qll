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

  bindingset[str]
  private predicate parseScan(string str, int arity, int lhs, string rhs) {
    exists(string r, string trimmed |
      r = "\\{(\\d+)\\}\\s+r(\\d+)\\s+=\\s+SCAN\\s+([0-9a-zA-Z:#_]+)\\s.*" and
      trimmed = str.trim()
    |
      arity = trimmed.regexpCapture(r, 1).toInt() and
      lhs = trimmed.regexpCapture(r, 2).toInt() and
      rhs = trimmed.regexpCapture(r, 3)
    )
  }

  bindingset[str]
  private predicate parseJoin(string str, int arity, int lhs, string left, string right) {
    exists(string r, string trimmed |
      r =
        "\\{(\\d+)\\}\\s+r(\\d+)\\s+=\\s+JOIN\\s+([0-9a-zA-Z:#_]+)\\s+WITH\\s+([0-9a-zA-Z:#_]+)\\s.*" and
      trimmed = str.trim()
    |
      arity = trimmed.regexpCapture(r, 1).toInt() and
      lhs = trimmed.regexpCapture(r, 2).toInt() and
      left = trimmed.regexpCapture(r, 3) and
      right = trimmed.regexpCapture(r, 4)
    )
  }

  bindingset[str]
  private predicate parseSelect(string str, int arity, int lhs, string rhs) {
    exists(string r, string trimmed |
      r = "\\{(\\d+)\\}\\s+r(\\d+)\\s+=\\s+SELECT\\s+([0-9a-zA-Z:#_]+).*" and
      trimmed = str.trim()
    |
      arity = trimmed.regexpCapture(r, 1).toInt() and
      lhs = trimmed.regexpCapture(r, 2).toInt() and
      rhs = trimmed.regexpCapture(r, 3)
    )
  }

  bindingset[str]
  private predicate parseAntiJoin(string str, int arity, int lhs, string left, string right) {
    exists(string r, string trimmed |
      r = "\\{(\\d+)\\}\\s+r(\\d+)\\s+=\\s+([0-9a-zA-Z:#_]+)\\s+AND\\s+NOT\\s+([0-9a-zA-Z:#_]+).*" and
      trimmed = str.trim()
    |
      arity = trimmed.regexpCapture(r, 1).toInt() and
      lhs = trimmed.regexpCapture(r, 2).toInt() and
      left = trimmed.regexpCapture(r, 3) and
      right = trimmed.regexpCapture(r, 4)
    )
  }

  private newtype TRA =
    TReturn(Predicate p, int line, int v) { v = parseReturn(p.getLineOfRA(line)) } or
    TScan(Predicate p, int line, int arity, int lhs, string rhs) {
      parseScan(p.getLineOfRA(line), arity, lhs, rhs)
    } or
    TJoin(Predicate p, int line, int arity, int lhs, string left, string right) {
      parseJoin(p.getLineOfRA(line), arity, lhs, left, right)
    } or
    TSelect(Predicate p, int line, int arity, int lhs, string rhs) {
      parseSelect(p.getLineOfRA(line), arity, lhs, rhs)
    } or
    TAntiJoin(Predicate p, int line, int arity, int lhs, string left, string right) {
      parseAntiJoin(p.getLineOfRA(line), arity, lhs, left, right)
    } or
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

    final string toString() { result = this.getPredicate().getLineOfRA(this.getLine()) }

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
    Predicate p;
    int line;
    int res;

    RAReturnExpr() { this = TReturn(p, line, res) }

    override Predicate getPredicate() { result = p }

    override int getLine() { result = line }

    override int getLhs() { none() }

    override int getARhsVariable() { result = res }

    override int getArity() { none() }

    override string getARhsPredicate() { none() }
  }

  class RAScanExpr extends RAExpr, TScan {
    Predicate p;
    int line;
    int arity;
    int lhs;
    string rhs;

    RAScanExpr() { this = TScan(p, line, arity, lhs, rhs) }

    override Predicate getPredicate() { result = p }

    override int getLine() { result = line }

    override int getLhs() { result = lhs }

    override int getArity() { result = arity }

    override int getARhsVariable() { isVariable(rhs, result) }

    override string getARhsPredicate() {
      result = rhs and
      not isVariable(result, _)
    }
  }

  bindingset[s]
  private predicate isVariable(string s, int n) { n = s.regexpCapture("r(\\d+)", 1).toInt() }

  class RAJoinExpr extends RAExpr, TJoin {
    Predicate p;
    int line;
    int arity;
    int lhs;
    string left;
    string right;

    RAJoinExpr() { this = TJoin(p, line, arity, lhs, left, right) }

    override Predicate getPredicate() { result = p }

    override int getLine() { result = line }

    override int getLhs() { result = lhs }

    override int getArity() { result = arity }

    // Note: We could return reasonable values here sometimes.
    override int getARhsVariable() { isVariable([left, right], result) }

    // Note: We could return reasonable values here sometimes.
    override string getARhsPredicate() {
      result = [left, right] and
      not isVariable(result, _)
    }
  }

  class RaSelectExpr extends RAExpr, TSelect {
    Predicate p;
    int line;
    int arity;
    int lhs;
    string rhs;

    RaSelectExpr() { this = TSelect(p, line, arity, lhs, rhs) }

    override Predicate getPredicate() { result = p }

    override int getLine() { result = line }

    override int getLhs() { result = lhs }

    override int getArity() { result = arity }

    // Note: We could return reasonable values here sometimes.
    override int getARhsVariable() { isVariable(rhs, result) }

    // Note: We could return reasonable values here sometimes.
    override string getARhsPredicate() {
      result = rhs and
      not isVariable(result, _)
    }
  }

  class RaAntiJoinExpr extends RAExpr, TAntiJoin {
    Predicate p;
    int line;
    int arity;
    int lhs;
    string left;
    string right;

    RaAntiJoinExpr() { this = TAntiJoin(p, line, arity, lhs, left, right) }

    override Predicate getPredicate() { result = p }

    override int getLine() { result = line }

    override int getLhs() { result = lhs }

    override int getArity() { result = arity }

    // Note: We could return reasonable values here sometimes.
    override int getARhsVariable() { isVariable([left, right], result) }

    // Note: We could return reasonable values here sometimes.
    override string getARhsPredicate() {
      result = [left, right] and
      not isVariable(result, _)
    }
  }
}
