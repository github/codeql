import cpp

/**
 * A wrapper that provides metrics for a C++ class.
 */
class MetricClass extends Class {
  /**
   * Gets the nesting level of this class. A class that is _not_ nested
   * directly inside another class has nesting level 0.
   */
  int getNestingLevel() {
    if not this instanceof NestedClass
    then result = 0
    else result = this.(NestedClass).getDeclaringType().(MetricClass).getNestingLevel() + 1
  }

  /**
   * Gets the length of *some* path to a root of the hierarchy. A class with no
   * base class has depth 0.
   */
  int getADepth() {
    not this.getABaseClass+() = this and
    if not exists(this.getABaseClass())
    then result = 0
    else result = this.getABaseClass().(MetricClass).getADepth() + 1
  }

  /**
   * Gets the maximum depth of inheritance of this class. A class with no base
   * class has depth 0.
   */
  int getInheritanceDepth() { result = max(this.getADepth()) }

  /** Gets the number of member functions in this class. */
  int getNumberOfMemberFunctions() {
    result = count(MemberFunction mf | mf.getDeclaringType() = this)
  }

  /** Gets the number of nested classes defined in this class. */
  int getNumberOfNestedClasses() { result = count(NestedClass nc | nc.getDeclaringType() = this) }

  /** Gets the number of non-static data members defined in this class. */
  int getNumberOfFields() { result = count(Field f | f.getDeclaringType() = this) }

  /** Gets the total number of members defined in this class. */
  int getNumberOfMembers() { result = count(Declaration m | m.getDeclaringType() = this) }

  /** Gets the number of incoming class dependencies. */
  int getAfferentCoupling() { result = count(MetricClass that | that.getAClassDependency() = this) }

  /** Gets the number of outgoing class dependencies. */
  int getEfferentCoupling() { result = count(MetricClass that | this.getAClassDependency() = that) }

  /** Gets the number of outgoing source class dependencies. */
  int getEfferentSourceCoupling() {
    result = count(MetricClass that | this.getAClassDependency() = that and that.fromSource())
  }

  /** Gets a class dependency of this element. */
  Class getAClassDependency() { dependsOnClassSimple(this, result) }

  /*
   * -------- HENDERSON-SELLERS LACK OF COHESION IN METHODS --------
   *
   * The aim of this metric is to try and determine whether a class
   * represents one abstraction (good) or multiple abstractions (bad).
   * If a class represents multiple abstractions, it should be split
   * up into multiple classes.
   *
   * In the Henderson-Sellers method, this is measured as follows:
   *    M = set of methods in class
   *    F = set of fields in class
   *    r(f) = number of methods that access field f
   *    <r> = mean of r(f) over f in F
   * The lack of cohesion is then given by
   *
   *    <r> - |M|
   *    ---------
   *      1 - |M|
   *
   * We follow the Eclipse metrics plugin by restricting M to methods
   * that access some field in the same class, and restrict F to
   * fields that are read by methods in the same class.
   *
   * Classes where the value of this metric is higher than 0.9 ought
   * to be scrutinised for possible splitting. Here is a query
   * to find such classes:
   *
   *        from MetricRefType t, float loc
   *        where loc = t.getLackOfCohesionHS() and loc > 0.9
   *        select t, loc order by loc desc
   */

  /** Holds if `func` accesses field `f` defined in the same type. */
  predicate accessesLocalField(Function func, Field f) {
    func.accesses(f) and
    this.getAMemberFunction() = func and
    f.getDeclaringType() = this
  }

  /** Gets any method that accesses some local field. */
  Function getAccessingMethod() { exists(Field f | this.accessesLocalField(result, f)) }

  /** Gets any field that is accessed by a local method. */
  Field getAccessedField() { exists(Function func | this.accessesLocalField(func, result)) }

  /** Gets the Henderson-Sellers lack-of-cohesion metric. */
  float getLackOfCohesionHS() {
    exists(int m, float r |
      // m = number of methods that access some field
      m = count(this.getAccessingMethod()) and
      // r = average (over f) of number of methods that access field f
      r =
        avg(Field f |
          f = this.getAccessedField()
        |
          count(Function x | this.accessesLocalField(x, f))
        ) and
      // avoid division by zero
      m != 1 and
      // compute LCOM
      result = ((r - m) / (1 - m))
    )
  }

  /*
   * -------- CHIDAMBER AND KEMERER LACK OF COHESION IN METHODS ------------
   *
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

  /** Holds if `f` should be excluded from the CK cohesion computation. */
  predicate ignoreLackOfCohesionCK(Function f) {
    none() // by default, nothing is ignored
  }

  /** Holds if `m1` and `m2` are distinct member functions of this class. */
  predicate distinctMembers(MemberFunction m1, MemberFunction m2) {
    m1.getDeclaringType() = this and
    m2.getDeclaringType() = this and
    m1 != m2
  }

  /**
   * Holds if `m1` and `m2` are distinct member functions of this class that
   * both access a common field.
   */
  predicate shareField(MemberFunction m1, MemberFunction m2) {
    exists(Field f |
      m1.accesses(f) and
      m1.getDeclaringType() = this and
      m2.accesses(f) and
      m2.getDeclaringType() = this
    ) and
    m1 != m2
  }

  /** Gets the Chidamber and Kemerer lack-of-cohesion metric. */
  float getLackOfCohesionCK() {
    exists(int n1, int n2, float n |
      n1 =
        count(MemberFunction m1, MemberFunction m2 |
          not this.ignoreLackOfCohesionCK(m1) and
          not this.ignoreLackOfCohesionCK(m2) and
          this.distinctMembers(m1, m2) and
          not this.shareField(m1, m2)
        ) and
      n2 = count(MemberFunction m1, MemberFunction m2 | this.shareField(m1, m2)) and
      n = (n1 - n2) / 2.0 and
      (
        n < 0 and result = 0
        or
        n >= 0 and result = n
      )
    )
  }

  /*
   * ----------------- RESPONSE FOR A CLASS ---------------------------------
   */

  /**
   * Gets the _response_ for this class. This estimates the number of
   * different functions that can be executed when a function is invoked on
   * this class.
   */
  int getResponse() {
    result =
      sum(MemberFunction f |
        f.getDeclaringType() = this
      |
        count(Call call | call.getEnclosingFunction() = f)
      )
  }

  /*
   * ----------------- SPECIALIZATION INDEX --------------------------------
   */

  /**
   * Gets a function that should be excluded when reporting the number of
   * overriding methods. By default, no functions are excluded.
   */
  predicate ignoreOverride(MemberFunction m) { none() }

  /** Gets some method that overrides a non-abstract method in a base class. */
  MemberFunction getOverrides() {
    this.getAMemberFunction() = result and
    exists(MemberFunction c |
      result.overrides(c) and
      not c instanceof PureVirtualFunction
    ) and
    not this.ignoreOverride(result)
  }

  /** Gets the number of methods that are overridden by this class (NORM). */
  int getNumberOverridden() { result = count(this.getOverrides()) }

  /**
   * Gets the _specialization index_ of this class.
   *
   * The specialization index metric measures the extent to which derived
   * classes override (replace) the behavior of their base classes. If they
   * override many methods, it is an indication that the original abstraction
   * in the base classes may have been inappropriate. On the whole, derived
   * classes should add behavior to their base classes, but not alter that
   * behavior dramatically.
   */
  float getSpecialisationIndex() {
    this.getNumberOfMemberFunctions() != 0 and
    result =
      (this.getNumberOverridden() * this.getInheritanceDepth()) /
        this.getNumberOfMemberFunctions().(float)
  }

  /*
   * ----------------- HALSTEAD METRICS ------------------------------------
   */

  /**
   * Gets the Halstead "N1" metric for this class. This is the total number of
   * operators in the class. Operators are taken to be all operators in
   * expressions (`+`, `*`, `&`, `->`, `=`, ...) as well as most statements.
   */
  int getHalsteadN1() {
    result =
      // account for the class itself
      1 +
        sum(MetricFunction mf, int toSum |
          mf.(MemberFunction).getDeclaringType() = this and toSum = mf.getHalsteadN1()
        |
          toSum
        ) +
        // Each member variable declaration counts once as an operator
        count(MemberVariable mv | mv.getDeclaringType() = this) +
        // Friend declarations
        count(FriendDecl f | f.getDeclaringClass() = this)
  }

  /**
   * Gets the Halstead "N2" metric for this class: this is the total number of operands.
   * An operand is either a variable, constant, type name, class name, or function name.
   */
  int getHalsteadN2() {
    result =
      // the class itself
      1 +
        sum(MetricFunction mf, int toSum |
          mf.(MemberFunction).getDeclaringType() = this and toSum = mf.getHalsteadN2()
        |
          toSum
        ) +
        // Each variable declaration that is not in a function counts once as an operand
        count(MemberVariable mv | mv.getDeclaringType() = this)
  }

  /**
   * Gets an expression contained anywhere in this class: member functions (including
   * constructors, destructors and operators), initializers...
   */
  Expr getAnEnclosedExpression() {
    exists(MemberFunction mf |
      mf.getDeclaringType() = this and
      result.getEnclosingFunction() = mf
    )
    or
    exists(MemberVariable mv |
      mv.getDeclaringType() = this and
      mv.getInitializer().getExpr().getAChild*() = result
    )
  }

  /** Gets a statement in a member function of this class. */
  Stmt getAnEnclosedStmt() {
    result.getEnclosingFunction().(MemberFunction).getDeclaringType() = this
  }

  private string getAUsedHalsteadN1Operator() {
    exists(CommaExpr e | e = this.getAnEnclosedExpression()) and result = "comma"
    or
    exists(ReferenceToExpr e | e = this.getAnEnclosedExpression()) and result = "refTo"
    or
    exists(PointerDereferenceExpr e | e = this.getAnEnclosedExpression()) and result = "dereference"
    or
    exists(CStyleCast e | e = this.getAnEnclosedExpression()) and result = "cCast"
    or
    exists(StaticCast e | e = this.getAnEnclosedExpression()) and result = "staticCast"
    or
    exists(ConstCast e | e = this.getAnEnclosedExpression()) and result = "constCast"
    or
    exists(ReinterpretCast e | e = this.getAnEnclosedExpression()) and result = "reinterpretCast"
    or
    exists(DynamicCast e | e = this.getAnEnclosedExpression()) and result = "dynamicCast"
    or
    exists(SizeofExprOperator e | e = this.getAnEnclosedExpression()) and result = "sizeofExpr"
    or
    exists(SizeofTypeOperator e | e = this.getAnEnclosedExpression()) and result = "sizeofType"
    or
    exists(IfStmt e | e = this.getAnEnclosedStmt()) and result = "ifVal"
    or
    exists(SwitchStmt e | e = this.getAnEnclosedStmt()) and result = "switchVal"
    or
    exists(ForStmt e | e = this.getAnEnclosedStmt()) and result = "forVal"
    or
    exists(DoStmt e | e = this.getAnEnclosedStmt()) and result = "doVal"
    or
    exists(WhileStmt e | e = this.getAnEnclosedStmt()) and result = "whileVal"
    or
    exists(GotoStmt e | e = this.getAnEnclosedStmt()) and result = "gotoVal"
    or
    exists(ContinueStmt e | e = this.getAnEnclosedStmt()) and result = "continueVal"
    or
    exists(BreakStmt e | e = this.getAnEnclosedStmt()) and result = "breakVal"
    or
    exists(ReturnStmt e | e = this.getAnEnclosedStmt()) and result = "returnVal"
    or
    exists(SwitchCase e | e = this.getAnEnclosedStmt()) and result = "caseVal"
    or
    exists(IfStmt s | s = this.getAnEnclosedStmt() and s.hasElse()) and
    result = "elseVal"
    or
    exists(MemberFunction f | f.getDeclaringType() = this) and result = "function"
    or
    exists(FriendDecl e | e.getDeclaringClass() = this) and result = "friendDecl"
  }

  /**
   * Gets the Halstead "n1" metric: this is the total number of distinct operators
   * in this class. Operators are defined as in the "N1" metric (`getHalsteadN1`).
   */
  int getHalsteadN1Distinct() {
    result =
      // avoid 0 values
      1 +
        count(string s |
          exists(Operation op | op = this.getAnEnclosedExpression() and s = op.getOperator())
        ) + count(string s | s = getAUsedHalsteadN1Operator())
  }

  /**
   * Gets the Halstead "n2" metric: this is the number of distinct operands in this
   * class. An operand is either a variable, constant, type name, or function name.
   */
  int getHalsteadN2Distinct() {
    result =
      // avoid 0 values
      1 +
        count(string s |
          exists(Access a | a = this.getAnEnclosedExpression() and s = a.getTarget().getName())
        ) +
        count(Function f |
          exists(FunctionCall fc | fc = this.getAnEnclosedExpression() and f = fc.getTarget())
        ) +
        // Approximate: count declarations once more to account for the type name
        count(Declaration d | d.getParentScope*() = this)
  }

  /**
   * Gets the Halstead length of this class. This is the sum of the N1 and N2 Halstead metrics.
   */
  int getHalsteadLength() { result = this.getHalsteadN1() + this.getHalsteadN2() }

  /**
   * Gets the Halstead vocabulary size of this class. This is the sum of the n1 and n2 Halstead metrics.
   */
  int getHalsteadVocabulary() {
    result = this.getHalsteadN1Distinct() + this.getHalsteadN2Distinct()
  }

  /**
   * Gets the Halstead volume of this class. This is the Halstead size multiplied by the log of the
   * Halstead vocabulary. It represents the information content of the class.
   */
  float getHalsteadVolume() {
    result = this.getHalsteadLength().(float) * this.getHalsteadVocabulary().log2()
  }

  /**
   * Gets the Halstead difficulty value of this class. This is proportional to the number of unique
   * operators, and further proportional to the ratio of total operands to unique operands.
   */
  float getHalsteadDifficulty() {
    result =
      (this.getHalsteadN1Distinct() * this.getHalsteadN2()).(float) /
        (2 * this.getHalsteadN2Distinct()).(float)
  }

  /**
   * Gets the Halstead level of this class. This is the inverse of the _difficulty_ of the class.
   */
  float getHalsteadLevel() {
    exists(float difficulty |
      difficulty = this.getHalsteadDifficulty() and
      if difficulty != 0.0 then result = 1.0 / difficulty else result = 0.0
    )
  }

  /**
   * Gets the Halstead implementation effort for this class. This is the product of the volume and difficulty.
   */
  float getHalsteadEffort() { result = this.getHalsteadVolume() * this.getHalsteadDifficulty() }

  /**
   * Gets the Halstead _delivered bugs_ metric for this class. This metric correlates with the complexity of
   * the software but is known to be an underestimate of bug counts.
   */
  float getHalsteadDeliveredBugs() { result = this.getHalsteadEffort().pow(2.0 / 3.0) / 3000.0 }
}

pragma[noopt]
private predicate dependsOnClassSimple(Class source, Class dest) {
  (
    // a class depends on the classes it inherits from
    source.derivesFrom(dest)
    or
    // a nested class depends on its enclosing class
    source.getDeclaringType() = dest and source instanceof Class
    or
    // a class depends on its friend classes
    exists(FriendDecl fd | source.getAFriendDecl() = fd and fd.getFriend() = dest)
    or
    // a friend functions return type
    exists(FriendDecl fd, Function f, Type t |
      source.getAFriendDecl() = fd and fd.getFriend() = f and f.getType() = t and t.refersTo(dest)
    )
    or
    // the type of the arguments to a friend function
    exists(FriendDecl fd, Function f, Parameter p, Type t |
      source.getAFriendDecl() = fd and
      fd.getFriend() = f and
      f.getAParameter() = p and
      p.getType() = t and
      t.refersTo(dest)
    )
    or
    // a class depends on the types of its member variables
    exists(MemberVariable v, Type t |
      v.getDeclaringType() = source and
      v.getType() = t and
      t.refersTo(dest) and
      v instanceof MemberVariable
    )
    or
    // a class depends on the return types of its member functions
    exists(MemberFunction f, Type t |
      f.getDeclaringType() = source and
      f instanceof MemberFunction and
      f.getType() = t and
      t.refersTo(dest)
    )
    or
    // a class depends on the argument types of its member functions
    exists(MemberFunction f, Parameter p, Type t |
      f.getDeclaringType() = source and
      f instanceof MemberFunction and
      f.getAParameter() = p and
      p.getType() = t and
      t.refersTo(dest)
    )
    or
    // a class depends on the base types of type def types nested in it
    exists(NestedTypedefType t, Type td |
      t.getDeclaringType() = source and
      t.getBaseType() = td and
      t instanceof NestedTypedefType and
      td.refersTo(dest)
    )
    or
    // a class depends on the type names used in a casts in functions nested in it
    exists(Cast c, Function m, Type t |
      m.getDeclaringType() = source and
      m = c.getEnclosingFunction() and
      c instanceof Cast and
      c.getType() = t and
      t.refersTo(dest)
    )
    or
    // a class depends on the type names used in casts in initialization of member variables
    exists(Cast c, Variable m, Type t |
      m.getDeclaringType() = source and
      m = c.getEnclosingVariable() and
      c instanceof Cast and
      c.getType() = t and
      t.refersTo(dest)
    )
    or
    // a class depends on classes for which a call to its member function is done from a function
    exists(MemberFunction target, MemberFunction f, Locatable l |
      f.getDeclaringType() = source and
      f instanceof MemberFunction and
      f.calls(target, l) and
      target instanceof MemberFunction and
      target.getDeclaringType() = dest
    )
    or
    // a class depends on classes for which a call to its member function is done from a member variable initializer
    exists(MemberFunction target, FunctionCall c, MemberVariable v |
      v.getDeclaringType() = source and
      v instanceof MemberVariable and
      c.getEnclosingVariable() = v and
      c instanceof FunctionCall and
      c.getTarget() = target and
      target instanceof MemberFunction and
      target.getDeclaringType() = dest
    )
    or
    // a class(source) depends on classes(dest) for which its member functions(mf) are accessed(fa) from a member function(f)
    exists(MemberFunction f, FunctionAccess fa, MemberFunction mf |
      f.getDeclaringType() = source and
      f instanceof MemberFunction and
      fa.getEnclosingFunction() = f and
      fa.getTarget() = mf and
      mf.getDeclaringType() = dest and
      mf instanceof MemberFunction and
      fa instanceof FunctionAccess
    )
    or
    // a class depends on classes for which its member functions are accessed from a member variable initializer
    exists(MemberVariable v, FunctionAccess fa, MemberFunction mf |
      v.getDeclaringType() = source and
      v instanceof MemberVariable and
      fa.getEnclosingVariable() = v and
      fa.getTarget() = mf and
      mf.getDeclaringType() = dest and
      fa instanceof FunctionAccess and
      mf instanceof MemberFunction
    )
    or
    // a class depends on classes for which its member variables are accessed from a member function
    exists(MemberFunction f, VariableAccess va, MemberVariable mv |
      f.getDeclaringType() = source and
      f instanceof MemberFunction and
      va.getEnclosingFunction() = f and
      va instanceof VariableAccess and
      va.getTarget() = mv and
      mv.getDeclaringType() = dest and
      mv instanceof MemberVariable
    )
    or
    // a class depends on classes for which its member variables are accessed from a member variable initializer
    exists(MemberVariable v, VariableAccess va, MemberVariable mv |
      v.getDeclaringType() = source and
      v instanceof MemberVariable and
      va.getEnclosingVariable() = v and
      va instanceof VariableAccess and
      va.getTarget() = mv and
      mv.getDeclaringType() = dest and
      mv instanceof MemberVariable
    )
    or
    // a class depends on enums for which its enum constants are accessed from a member function
    exists(MemberFunction f, EnumConstantAccess ea, EnumConstant e |
      f.getDeclaringType() = source and
      f instanceof MemberFunction and
      ea.getEnclosingFunction() = f and
      ea.getTarget() = e and
      e.getDeclaringEnum() = dest and
      ea instanceof EnumConstantAccess
    )
    or
    // a class depends on enums for which its enum constants are accessed from a member variable initializer
    exists(MemberVariable v, EnumConstantAccess ea, EnumConstant e |
      v.getDeclaringType() = source and
      v instanceof MemberVariable and
      ea.getEnclosingVariable() = v and
      ea instanceof EnumConstantAccess and
      ea.getTarget() = e and
      e.getDeclaringEnum() = dest
    )
  ) and
  dest instanceof Class
}
