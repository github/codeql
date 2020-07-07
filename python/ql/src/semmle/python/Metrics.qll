import python

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

  /**
   * Cyclomatic complexity:
   * The number of linearly independent paths through the source code.
   * Computed as     E - N + 2P,
   * where
   *  E = the number of edges of the graph.
   *  N = the number of nodes of the graph.
   *  P = the number of connected components, which for a single function is 1.
   */
  int getCyclomaticComplexity() {
    exists(int E, int N |
      N = count(BasicBlock b | b = this.getABasicBlock() and b.likelyReachable()) and
      E =
        count(BasicBlock b1, BasicBlock b2 |
          b1 = this.getABasicBlock() and
          b1.likelyReachable() and
          b2 = this.getABasicBlock() and
          b2.likelyReachable() and
          b2 = b1.getASuccessor() and
          not b1.unlikelySuccessor(b2)
        )
    |
      result = E - N + 2
    )
  }

  private BasicBlock getABasicBlock() {
    result = this.getEntryNode().getBasicBlock()
    or
    exists(BasicBlock mid | mid = this.getABasicBlock() and result = mid.getASuccessor())
  }

  /**
   * Dependency of Callables
   * One callable "this" depends on another callable "result"
   * if "this" makes some call to a method that may end up being "result".
   */
  FunctionMetrics getADependency() {
    result != this and
    not non_coupling_method(result) and
    exists(Call call | call.getScope() = this |
      exists(FunctionObject callee | callee.getFunction() = result |
        call.getAFlowNode().getFunction().refersTo(callee)
      )
      or
      exists(Attribute a | call.getFunc() = a |
        unique_root_method(result, a.getName())
        or
        exists(Name n | a.getObject() = n and n.getId() = "self" |
          result.getScope() = this.getScope() and
          result.getName() = a.getName()
        )
      )
    )
  }

  /**
   * Afferent Coupling
   * the number of callables that depend on this method.
   * This is sometimes called the "fan-in" of a method.
   */
  int getAfferentCoupling() { result = count(FunctionMetrics m | m.getADependency() = this) }

  /**
   * Efferent Coupling
   * the number of methods that this method depends on
   * This is sometimes called the "fan-out" of a method.
   */
  int getEfferentCoupling() { result = count(FunctionMetrics m | this.getADependency() = m) }

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

  private predicate dependsOn(Class other) {
    other != this and
    (
      exists(FunctionMetrics f1, FunctionMetrics f2 | f1.getADependency() = f2 |
        f1.getScope() = this and f2.getScope() = other
      )
      or
      exists(Function f, Call c, ClassObject cls | c.getScope() = f and f.getScope() = this |
        c.getFunc().refersTo(cls) and
        cls.getPyClass() = other
      )
    )
  }

  /**
   * The afferent coupling of a class is the number of classes that
   * directly depend on it.
   */
  int getAfferentCoupling() { result = count(ClassMetrics t | t.dependsOn(this)) }

  /**
   * The efferent coupling of a class is the number of classes that
   * it directly depends on.
   */
  int getEfferentCoupling() { result = count(ClassMetrics t | this.dependsOn(t)) }

  int getInheritanceDepth() {
    exists(ClassObject cls | cls.getPyClass() = this | result = max(classInheritanceDepth(cls)))
  }

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

private int classInheritanceDepth(ClassObject cls) {
  /* Prevent run-away recursion in case of circular inheritance */
  not cls.getASuperType() = cls and
  (
    exists(ClassObject sup | cls.getABaseType() = sup | result = classInheritanceDepth(sup) + 1)
    or
    not exists(cls.getABaseType()) and
    (
      major_version() = 2 and result = 0
      or
      major_version() > 2 and result = 1
    )
  )
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

  /**
   * The afferent coupling of a class is the number of classes that
   *  directly depend on it.
   */
  int getAfferentCoupling() { result = count(ModuleMetrics t | t.dependsOn(this)) }

  /**
   * The efferent coupling of a class is the number of classes that
   *  it directly depends on.
   */
  int getEfferentCoupling() { result = count(ModuleMetrics t | this.dependsOn(t)) }

  private predicate dependsOn(Module other) {
    other != this and
    (
      exists(FunctionMetrics f1, FunctionMetrics f2 | f1.getADependency() = f2 |
        f1.getEnclosingModule() = this and f2.getEnclosingModule() = other
      )
      or
      exists(Function f, Call c, ClassObject cls | c.getScope() = f and f.getScope() = this |
        c.getFunc().refersTo(cls) and
        cls.getPyClass().getEnclosingModule() = other
      )
    )
  }
}

/** Helpers for coupling */
predicate unique_root_method(Function func, string name) {
  name = func.getName() and
  not exists(FunctionObject f, FunctionObject other |
    f.getFunction() = func and
    other.getName() = name
  |
    not other.overrides(f)
  )
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
