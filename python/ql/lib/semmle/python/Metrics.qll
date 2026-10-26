import python
private import semmle.python.SelfAttribute

/** The metrics for a function */
class FunctionMetrics extends Function {
  /**
   * Gets the total number of lines (including blank lines)
   * from the definition to the end of the function
   */
  int getNumberOfLines() { py_alllines(this, result) }

  /** Gets the number of lines of code in the function */
  int getNumberOfLinesOfCode() { py_codelines(this, result) }

  /** Gets the number of lines of comments in the function */
  int getNumberOfLinesOfComments() { py_commentlines(this, result) }

  /** Gets the number of lines of docstring in the function */
  int getNumberOfLinesOfDocStrings() { py_docstringlines(this, result) }

  int getNumberOfParametersWithoutDefault() {
    result =
      this.getPositionalParameterCount() -
        count(this.getDefinition().(FunctionExpr).getArgs().getADefault())
  }

  int getStatementNestingDepth() { result = max(Stmt s | s.getScope() = this | getNestingDepth(s)) }

  int getNumberOfCalls() { result = count(Call c | c.getScope() = this) }
}

/** The metrics for a class */
class ClassMetrics extends Class {
  /**
   * Gets the total number of lines (including blank lines)
   * from the definition to the end of the class
   */
  int getNumberOfLines() { py_alllines(this, result) }

  /** Gets the number of lines of code in the class */
  int getNumberOfLinesOfCode() { py_codelines(this, result) }

  /** Gets the number of lines of comments in the class */
  int getNumberOfLinesOfComments() { py_commentlines(this, result) }

  /** Gets the number of lines of docstrings in the class */
  int getNumberOfLinesOfDocStrings() { py_docstringlines(this, result) }

  /* -------- CHIDAMBER AND KEMERER LACK OF COHESION IN METHODS ------------ */
  /*
   * The aim of this metric is to try and determine whether a class
   * represents one abstraction (good) or multiple abstractions (bad).
   * If a class represents multiple abstractions, it should be split
   * up into multiple classes.
   *
   * In the Chidamber and Kemerer method, this is measured as follows:
   *    n1 = number of pairs of distinct methods in a class that do *not*
   *         have at least one commonly accessed field
   *    n2 = number of pairs of distinct methods in a class that do
   *         have at least one commonly accessed field
   *    lcom = ((n1 - n2)/2 max 0)
   *
   * We divide by 2 because each pair (m1,m2) is counted twice in n1 and n2.
   */

  /** should function f be excluded from the cohesion computation? */
  predicate ignoreLackOfCohesion(Function f) { f.isInitMethod() or f.isSpecialMethod() }

  private predicate methodPair(Function m1, Function m2) {
    m1.getScope() = this and
    m2.getScope() = this and
    not this.ignoreLackOfCohesion(m1) and
    not this.ignoreLackOfCohesion(m2) and
    m1 != m2
  }

  private predicate one_accesses_other(Function m1, Function m2) {
    this.methodPair(m1, m2) and
    (
      exists(SelfAttributeRead sa |
        sa.getName() = m1.getName() and
        sa.getScope() = m2
      )
      or
      exists(SelfAttributeRead sa |
        sa.getName() = m2.getName() and
        sa.getScope() = m1
      )
    )
  }

  /** do m1 and m2 access a common field or one calls the other? */
  private predicate shareField(Function m1, Function m2) {
    this.methodPair(m1, m2) and
    exists(string name |
      exists(SelfAttributeRead sa |
        sa.getName() = name and
        sa.getScope() = m1
      ) and
      exists(SelfAttributeRead sa |
        sa.getName() = name and
        sa.getScope() = m2
      )
    )
  }

  private int similarMethodPairs() {
    result =
      count(Function m1, Function m2 |
          this.methodPair(m1, m2) and
          (this.shareField(m1, m2) or this.one_accesses_other(m1, m2))
        ) / 2
  }

  private int methodPairs() {
    result = count(Function m1, Function m2 | this.methodPair(m1, m2)) / 2
  }

  /** return Chidamber and Kemerer Lack of Cohesion */
  int getLackOfCohesionCK() {
    exists(int n |
      n = this.methodPairs() - 2 * this.similarMethodPairs() and
      result = n.maximum(0)
    )
  }

  private predicate similarMethodPairDag(Function m1, Function m2, int line) {
    (this.shareField(m1, m2) or this.one_accesses_other(m1, m2)) and
    line = m1.getLocation().getStartLine() and
    line < m2.getLocation().getStartLine()
  }

  private predicate subgraph(Function m, int line) {
    this.similarMethodPairDag(m, _, line) and not this.similarMethodPairDag(_, m, _)
    or
    exists(Function other | this.subgraph(other, line) |
      this.similarMethodPairDag(other, m, _) or
      this.similarMethodPairDag(m, other, _)
    )
  }

  predicate unionSubgraph(Function m, int line) { line = min(int l | this.subgraph(m, l)) }

  /** return Hitz and Montazeri Lack of Cohesion */
  int getLackOfCohesionHM() { result = count(int line | this.unionSubgraph(_, line)) }
}

class ModuleMetrics extends Module {
  /** Gets the total number of lines (including blank lines) in the module */
  int getNumberOfLines() { py_alllines(this, result) }

  /** Gets the number of lines of code in the module */
  int getNumberOfLinesOfCode() { py_codelines(this, result) }

  /** Gets the number of lines of comments in the module */
  int getNumberOfLinesOfComments() { py_commentlines(this, result) }

  /** Gets the number of lines of docstrings in the module */
  int getNumberOfLinesOfDocStrings() { py_docstringlines(this, result) }
}

predicate non_coupling_method(Function f) {
  f.isSpecialMethod() or
  f.isInitMethod() or
  f.getName() = "close" or
  f.getName() = "write" or
  f.getName() = "read" or
  f.getName() = "get" or
  f.getName() = "set"
}

private int getNestingDepth(Stmt s) {
  not exists(Stmt outer | outer.getASubStatement() = s) and result = 1
  or
  exists(Stmt outer | outer.getASubStatement() = s |
    if s.(If).isElif() or s instanceof ExceptStmt
    then
      /* If statement is an `elif` or `except` then it is not indented relative to its parent */
      result = getNestingDepth(outer)
    else result = getNestingDepth(outer) + 1
  )
}
