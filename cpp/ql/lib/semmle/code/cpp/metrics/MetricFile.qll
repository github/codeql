import cpp

/**
 * A wrapper that provides metrics for a C/C++ file.
 */
class MetricFile extends File {
  /** Gets the number of functions defined in this file. */
  int getNumberOfTopLevelFunctions() {
    result = count(Function f | f.isTopLevel() and f.getFile() = this)
  }

  /** Gets the number of classes defined in this file. */
  int getNumberOfClasses() { result = count(Class c | c.getFile() = this) }

  /** Gets the number of user-defined types defined in this file. */
  int getNumberOfUserTypes() { result = count(UserType t | t.getFile() = this) }

  /** Gets the number of lines in this file. */
  int getNumberOfLines() { numlines(underlyingElement(this), result, _, _) }

  /** Gets the number of lines of code in this file. */
  int getNumberOfLinesOfCode() { numlines(underlyingElement(this), _, result, _) }

  /** Gets the number of lines of comments in this file. */
  int getNumberOfLinesOfComments() { numlines(underlyingElement(this), _, _, result) }

  /** Gets the number of incoming file dependencies. */
  int getAfferentCoupling() { result = count(MetricFile that | that.getAFileDependency() = this) }

  /** Gets the number of outgoing file dependencies. */
  int getEfferentCoupling() { result = count(MetricFile that | this.getAFileDependency() = that) }

  /*
   * HALSTEAD METRICS
   */

  /**
   * Gets the Halstead "N1" metric for this file. This is the total number of
   * operators in the file. Operators are taken to be all operators in
   * expressions (`+`, `*`, `&`, `->`, `=`, ...) as well as most statements.
   */
  int getHalsteadN1() {
    result =
      sum(MetricFunction mf, int toSum | mf.getFile() = this and toSum = mf.getHalsteadN1() | toSum)
        +
        // Each class counts once as an operator
        count(Class c | c.getFile() = this) +
        // Each variable declaration that is not in a function counts once as an operator
        count(GlobalVariable gv | gv.getFile() = this) +
        count(MemberVariable mv | mv.getFile() = this) +
        // Type declarations - to count the definition tokens
        count(TypeDeclarationEntry decl | decl.getFile() = this) +
        // Friend declarations
        count(FriendDecl f | f.getFile() = this)
  }

  /**
   * Gets the Halstead "N2" metric for this file: this is the total number of operands.
   * An operand is either a variable, constant, type name, class name, or function name.
   */
  int getHalsteadN2() {
    result =
      sum(MetricFunction mf, int toSum | mf.getFile() = this and toSum = mf.getHalsteadN2() | toSum)
        +
        // Each class counts once as an operand
        count(Class c | c.getFile() = this) +
        // Each variable declaration that is not in a function counts once as an operand
        count(GlobalVariable gv | gv.getFile() = this) +
        count(MemberVariable mv | mv.getFile() = this) +
        // Type declarations - to count the type names
        count(TypeDeclarationEntry decl | decl.getFile() = this) +
        // Enum constant declarations to count the name
        count(EnumConstant ec | ec.getFile() = this)
  }

  private string getAUsedHalsteadN1Operator() {
    exists(CommaExpr e | e.getFile() = this) and result = "comma"
    or
    exists(ReferenceToExpr e | e.getFile() = this) and result = "refTo"
    or
    exists(PointerDereferenceExpr e | e.getFile() = this) and result = "dereference"
    or
    exists(CStyleCast e | e.getFile() = this) and result = "cCast"
    or
    exists(StaticCast e | e.getFile() = this) and result = "staticCast"
    or
    exists(ConstCast e | e.getFile() = this) and result = "constCast"
    or
    exists(ReinterpretCast e | e.getFile() = this) and result = "reinterpretCast"
    or
    exists(DynamicCast e | e.getFile() = this) and result = "dynamicCast"
    or
    exists(SizeofExprOperator e | e.getFile() = this) and result = "sizeofExpr"
    or
    exists(SizeofTypeOperator e | e.getFile() = this) and result = "sizeofType"
    or
    exists(IfStmt e | e.getFile() = this) and result = "ifVal"
    or
    exists(SwitchStmt e | e.getFile() = this) and result = "switchVal"
    or
    exists(ForStmt e | e.getFile() = this) and result = "forVal"
    or
    exists(DoStmt e | e.getFile() = this) and result = "doVal"
    or
    exists(WhileStmt e | e.getFile() = this) and result = "whileVal"
    or
    exists(GotoStmt e | e.getFile() = this) and result = "gotoVal"
    or
    exists(ContinueStmt e | e.getFile() = this) and result = "continueVal"
    or
    exists(BreakStmt e | e.getFile() = this) and result = "breakVal"
    or
    exists(ReturnStmt e | e.getFile() = this) and result = "returnVal"
    or
    exists(SwitchCase e | e.getFile() = this) and result = "caseVal"
    or
    exists(IfStmt s | s.getFile() = this and s.hasElse()) and
    result = "elseVal"
    or
    exists(Function f | f.getFile() = this) and result = "function"
    or
    exists(Class c | c.getFile() = this) and result = "classDef"
    or
    exists(TypeDeclarationEntry e | e.getFile() = this) and result = "typeDecl"
    or
    exists(FriendDecl e | e.getFile() = this) and result = "friendDecl"
  }

  /**
   * Gets the Halstead "n1" metric: this is the total number of distinct operators
   * in this file. Operators are defined as in the "N1" metric (`getHalsteadN1`).
   */
  int getHalsteadN1Distinct() {
    result =
      // avoid 0 values
      1 + count(string s | exists(Operation op | op.getFile() = this and s = op.getOperator())) +
        count(string s | s = this.getAUsedHalsteadN1Operator())
  }

  /**
   * Gets the Halstead "n2" metric: this is the number of distinct operands in this
   * file. An operand is either a variable, constant, type name, or function name.
   */
  int getHalsteadN2Distinct() {
    result =
      // avoid 0 values
      1 + count(string s | exists(Access a | a.getFile() = this and s = a.getTarget().getName())) +
        count(Function f | exists(FunctionCall fc | fc.getFile() = this and f = fc.getTarget())) +
        // Approximate: count declarations once more to account for the type name
        count(Declaration d | d.getFile() = this)
  }

  /**
   * Gets the Halstead length of this file. This is the sum of the N1 and N2 Halstead metrics.
   */
  int getHalsteadLength() { result = this.getHalsteadN1() + this.getHalsteadN2() }

  /**
   * Gets the Halstead vocabulary size of this file. This is the sum of the n1 and n2 Halstead metrics.
   */
  int getHalsteadVocabulary() {
    result = this.getHalsteadN1Distinct() + this.getHalsteadN2Distinct()
  }

  /**
   * Gets the Halstead volume of this file. This is the Halstead size multiplied by the log of the
   * Halstead vocabulary. It represents the information content of the file.
   */
  float getHalsteadVolume() {
    result = this.getHalsteadLength().(float) * this.getHalsteadVocabulary().log2()
  }

  /**
   * Gets the Halstead difficulty value of this file. This is proportional to the number of unique
   * operators, and further proportional to the ratio of total operands to unique operands.
   */
  float getHalsteadDifficulty() {
    result =
      (this.getHalsteadN1Distinct() * this.getHalsteadN2()).(float) /
        (2 * this.getHalsteadN2Distinct()).(float)
  }

  /**
   * Gets the Halstead level of this file. This is the inverse of the difficulty of the file.
   */
  float getHalsteadLevel() {
    exists(float difficulty |
      difficulty = this.getHalsteadDifficulty() and
      if difficulty != 0.0 then result = 1.0 / difficulty else result = 0.0
    )
  }

  /**
   * Gets the Halstead implementation effort for this file. This is the product of the volume and difficulty.
   */
  float getHalsteadEffort() { result = this.getHalsteadVolume() * this.getHalsteadDifficulty() }

  /**
   * Gets the Halstead 'delivered bugs' metric for this file. This metric correlates with the complexity of
   * the software, but is known to be an underestimate of bug counts.
   */
  float getHalsteadDeliveredBugs() { result = this.getHalsteadEffort().pow(2.0 / 3.0) / 3000.0 }

  /** Gets a file dependency of this file. */
  File getAFileDependency() { dependsOnFileSimple(this, result.getMetrics()) }
}

private predicate aClassFile(Class c, File file) { c.getDefinitionLocation().getFile() = file }

pragma[noopt]
private predicate dependsOnFileSimple(MetricFile source, MetricFile dest) {
  // class derives from classs
  exists(Class fromClass, Class toClass |
    aClassFile(fromClass, source) and
    fromClass.derivesFrom(toClass) and
    aClassFile(toClass, dest)
  )
  or
  // class nested in another class
  exists(Class fromClass, Class toClass |
    aClassFile(fromClass, source) and
    fromClass.getDeclaringType() = toClass and
    toClass.getFile() = dest
  )
  or
  // class has friend class
  exists(Class fromClass, Class toClass, FriendDecl fd |
    aClassFile(fromClass, source) and
    fromClass.getAFriendDecl() = fd and
    fd.getFriend() = toClass and
    toClass instanceof Class and
    dest = toClass.getFile()
  )
  or
  exists(FunctionCall ca, Function f |
    ca instanceof FunctionCall and
    ca.getFile() = source and
    ca.getTarget() = f and
    f.getFile() = dest and
    not f.isMultiplyDefined() and
    not exists(Function ef | ef = ca.getEnclosingFunction() and ef.isMultiplyDefined())
  )
  or
  exists(Access a, Declaration d |
    a instanceof Access and
    a.getFile() = source and
    a.getTarget() = d and
    d.getFile() = dest and
    not exists(Function ef | ef = a.getEnclosingFunction() and ef.isMultiplyDefined())
  )
  or
  exists(Variable v, VariableDeclarationEntry e, Type vt, UserType t |
    e instanceof VariableDeclarationEntry and
    e.getFile() = source and
    v.getADeclarationEntry() = e and
    vt = v.getType() and
    vt.refersTo(t) and
    t instanceof UserType and
    t.getFile() = dest
  )
  or
  exists(Function f, FunctionDeclarationEntry e, Type ft, UserType t |
    e instanceof FunctionDeclarationEntry and
    e.getFile() = source and
    f.getADeclarationEntry() = e and
    ft = f.getType() and
    ft.refersTo(t) and
    t instanceof UserType and
    t.getFile() = dest
  )
  or
  exists(MacroInvocation mi, Macro m |
    mi instanceof MacroInvocation and
    mi.getFile() = source and
    mi.getMacro() = m and
    m.getFile() = dest
  )
  or
  exists(TypedefType t, TypeDeclarationEntry e, Type bt, UserType u |
    e instanceof TypeDeclarationEntry and
    e.getFile() = source and
    t.getADeclarationEntry() = e and
    bt = t.getBaseType() and
    bt.refersTo(u) and
    u instanceof UserType and
    u.getFile() = dest
  )
  or
  exists(Cast c, Type t, UserType u |
    c instanceof Cast and
    c.getFile() = source and
    c.getType() = t and
    t.refersTo(u) and
    u instanceof UserType and
    u.getFile() = dest and
    not exists(Function ef | ef = c.getEnclosingFunction() and ef.isMultiplyDefined())
  )
}
