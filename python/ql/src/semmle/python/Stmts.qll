import python

/** A statement */
class Stmt extends Stmt_, AstNode {
  /** Gets the scope immediately enclosing this statement */
  override Scope getScope() { py_scopes(this, result) }

  override string toString() { result = "Stmt" }

  /** Gets the module enclosing this statement */
  Module getEnclosingModule() { result = this.getScope().getEnclosingModule() }

  override Location getLocation() { result = Stmt_.super.getLocation() }

  /** Gets an immediate (non-nested) sub-expression of this statement */
  Expr getASubExpression() { none() }

  /** Gets an immediate (non-nested) sub-statement of this statement */
  Stmt getASubStatement() { none() }

  override AstNode getAChildNode() {
    result = this.getASubExpression()
    or
    result = this.getASubStatement()
  }

  private ControlFlowNode possibleEntryNode() {
    result.getNode() = this or
    this.containsInScope(result.getNode())
  }

  /**
   * Gets a control flow node for an entry into this statement.
   */
  ControlFlowNode getAnEntryNode() {
    result = this.possibleEntryNode() and
    exists(ControlFlowNode pred |
      pred.getASuccessor() = result and
      not pred = this.possibleEntryNode()
    )
  }

  /** Holds if this statement cannot be reached */
  predicate isUnreachable() {
    not exists(this.getAnEntryNode())
    or
    exists(If ifstmt |
      ifstmt.getTest().(ImmutableLiteral).booleanValue() = false and ifstmt.getBody().contains(this)
      or
      ifstmt.getTest().(ImmutableLiteral).booleanValue() = true and
      ifstmt.getOrelse().contains(this)
    )
    or
    exists(While whilestmt |
      whilestmt.getTest().(ImmutableLiteral).booleanValue() = false and
      whilestmt.getBody().contains(this)
    )
  }

  /**
   * Gets the final statement in this statement, ordered by location.
   * Will be this statement if not a compound statement.
   */
  Stmt getLastStatement() { result = this }
}

/** A statement that includes a binding (except imports) */
class Assign extends Assign_ {
  /** Use ControlFlowNodes and SsaVariables for data-flow analysis. */
  predicate defines(Variable v) { this.getATarget().defines(v) }

  override Expr getASubExpression() {
    result = this.getATarget() or
    result = this.getValue()
  }

  override Stmt getASubStatement() { none() }
}

/** An assignment statement */
class AssignStmt extends Assign {
  /* syntax: Expr, ... = Expr */
  AssignStmt() { not this instanceof FunctionDef and not this instanceof ClassDef }

  override string toString() { result = "AssignStmt" }
}

/** An augmented assignment statement, such as `x += y` */
class AugAssign extends AugAssign_ {
  /* syntax: Expr += Expr */
  override Expr getASubExpression() { result = this.getOperation() }

  /**
   * Gets the target of this augmented assignment statement.
   * That is, the `a` in `a += b`.
   */
  Expr getTarget() { result = this.getOperation().(BinaryExpr).getLeft() }

  /**
   * Gets the value of this augmented assignment statement.
   * That is, the `b` in `a += b`.
   */
  Expr getValue() { result = this.getOperation().(BinaryExpr).getRight() }

  override Stmt getASubStatement() { none() }
}

/** An annotated assignment statement, such as `x: int = 0` */
class AnnAssign extends AnnAssign_ {
  /* syntax: Expr: Expr = Expr */
  override Expr getASubExpression() {
    result = this.getAnnotation() or
    result = this.getTarget() or
    result = this.getValue()
  }

  override Stmt getASubStatement() { none() }

  /** Holds if the value of the annotation of this assignment is stored at runtime. */
  predicate isStored() {
    not this.getScope() instanceof Function and
    exists(Name n |
      n = this.getTarget() and
      not n.isParenthesized()
    )
  }
}

/** An exec statement */
class Exec extends Exec_ {
  /* syntax: exec Expr */
  override Expr getASubExpression() {
    result = this.getBody() or
    result = this.getGlobals() or
    result = this.getLocals()
  }

  override Stmt getASubStatement() { none() }
}

/** An except statement (part of a `try` statement), such as `except IOError as err:` */
class ExceptStmt extends ExceptStmt_ {
  /* syntax: except Expr [ as Expr ]: */
  /** Gets the immediately enclosing try statement */
  Try getTry() { result.getAHandler() = this }

  override Expr getASubExpression() {
    result = this.getName()
    or
    result = this.getType()
  }

  override Stmt getASubStatement() { result = this.getAStmt() }

  override Stmt getLastStatement() { result = this.getBody().getLastItem().getLastStatement() }
}

/** An assert statement, such as `assert a == b, "A is not equal to b"` */
class Assert extends Assert_ {
  /* syntax: assert Expr [, Expr] */
  override Expr getASubExpression() { result = this.getMsg() or result = this.getTest() }

  override Stmt getASubStatement() { none() }
}

/** A break statement */
class Break extends Break_ {
  /* syntax: assert Expr [, Expr] */
  override Expr getASubExpression() { none() }

  override Stmt getASubStatement() { none() }
}

/** A continue statement */
class Continue extends Continue_ {
  /* syntax: continue */
  override Expr getASubExpression() { none() }

  override Stmt getASubStatement() { none() }
}

/** A delete statement, such as `del x[-1]` */
class Delete extends Delete_ {
  /* syntax: del Expr, ... */
  override Expr getASubExpression() { result = this.getATarget() }

  override Stmt getASubStatement() { none() }
}

/** An expression statement, such as `len(x)` or `yield y` */
class ExprStmt extends ExprStmt_ {
  /* syntax: Expr */
  override Expr getASubExpression() { result = this.getValue() }

  override Stmt getASubStatement() { none() }
}

/** A for statement, such as `for x in y: print(x)` */
class For extends For_ {
  /* syntax: for varname in Expr: ... */
  override Stmt getASubStatement() {
    result = this.getAStmt() or
    result = this.getAnOrelse()
  }

  override Expr getASubExpression() {
    result = this.getTarget() or
    result = this.getIter()
  }

  override Stmt getLastStatement() { result = this.getBody().getLastItem().getLastStatement() }
}

/** A global statement, such as `global var` */
class Global extends Global_ {
  /* syntax: global varname */
  override Expr getASubExpression() { none() }

  override Stmt getASubStatement() { none() }
}

/** An if statement, such as `if eggs: print("spam")` */
class If extends If_ {
  /* syntax: if Expr: ... */
  override Stmt getASubStatement() {
    result = this.getAStmt() or
    result = this.getAnOrelse()
  }

  override Expr getASubExpression() { result = this.getTest() }

  /** Whether this if statement takes the form `if __name__ == "__main__":` */
  predicate isNameEqMain() {
    exists(StrConst m, Name n, Compare c |
      this.getTest() = c and
      c.getOp(0) instanceof Eq and
      (
        c.getLeft() = n and c.getComparator(0) = m
        or
        c.getLeft() = m and c.getComparator(0) = n
      ) and
      n.getId() = "__name__" and
      m.getText() = "__main__"
    )
  }

  /** Whether this if statement starts with the keyword `elif` */
  predicate isElif() {
    /*
     * The Python parser turns all elif chains into nested if-else statements.
     * An `elif` can be identified as it is the first statement in an `else` block
     * and it is not indented relative to its parent `if`.
     */

    exists(If i |
      i.getOrelse(0) = this and
      this.getLocation().getStartColumn() = i.getLocation().getStartColumn()
    )
  }

  /** Gets the `elif` branch of this `if`-statement, if present */
  If getElif() {
    result = this.getOrelse(0) and
    result.isElif()
  }

  override Stmt getLastStatement() {
    result = this.getOrelse().getLastItem().getLastStatement()
    or
    not exists(this.getOrelse()) and
    result = this.getBody().getLastItem().getLastStatement()
  }
}

/** A nonlocal statement, such as `nonlocal var` */
class Nonlocal extends Nonlocal_ {
  /* syntax: nonlocal varname */
  override Stmt getASubStatement() { none() }

  override Expr getASubExpression() { none() }

  Variable getAVariable() {
    result.getScope() = this.getScope() and
    result.getId() = this.getAName()
  }
}

/** A pass statement */
class Pass extends Pass_ {
  /* syntax: pass */
  override Stmt getASubStatement() { none() }

  override Expr getASubExpression() { none() }
}

/** A print statement (Python 2 only), such as `print 0` */
class Print extends Print_ {
  /* syntax: print Expr, ... */
  override Stmt getASubStatement() { none() }

  override Expr getASubExpression() {
    result = this.getAValue() or
    result = this.getDest()
  }
}

/** A raise statement, such as `raise CompletelyDifferentException()` */
class Raise extends Raise_ {
  /* syntax: raise Expr */
  override Stmt getASubStatement() { none() }

  override Expr getASubExpression() { py_exprs(result, _, this, _) }

  /**
   * The expression immediately following the `raise`, this is the
   * exception raised, but not accounting for tuples in Python 2.
   */
  Expr getException() {
    result = this.getType()
    or
    result = this.getExc()
  }

  /** The exception raised, accounting for tuples in Python 2. */
  Expr getRaised() {
    exists(Expr raw | raw = this.getException() |
      if not major_version() = 2 or not exists(raw.(Tuple).getAnElt())
      then result = raw
      else
        /* In Python 2 raising a tuple will result in the first element of the tuple being raised. */
        result = raw.(Tuple).getElt(0)
    )
  }
}

/** A return statement, such as return None */
class Return extends Return_ {
  /* syntax: return Expr */
  override Stmt getASubStatement() { none() }

  override Expr getASubExpression() { result = this.getValue() }
}

/** A try statement */
class Try extends Try_ {
  /* syntax: try: ... */
  override Expr getASubExpression() { none() }

  override Stmt getASubStatement() {
    result = this.getAHandler() or
    result = this.getAStmt() or
    result = this.getAFinalstmt() or
    result = this.getAnOrelse()
  }

  override ExceptStmt getHandler(int i) { result = Try_.super.getHandler(i) }

  /** Gets an exception handler of this try statement. */
  override ExceptStmt getAHandler() { result = Try_.super.getAHandler() }

  override Stmt getLastStatement() {
    result = this.getFinalbody().getLastItem().getLastStatement()
    or
    not exists(this.getFinalbody()) and
    result = this.getOrelse().getLastItem().getLastStatement()
    or
    not exists(this.getFinalbody()) and
    not exists(this.getOrelse()) and
    result = this.getHandlers().getLastItem().getLastStatement()
    or
    not exists(this.getFinalbody()) and
    not exists(this.getOrelse()) and
    not exists(this.getHandlers()) and
    result = this.getBody().getLastItem().getLastStatement()
  }
}

/** A while statement, such as `while parrot_resting():` */
class While extends While_ {
  /* syntax: while Expr: ... */
  override Expr getASubExpression() { result = this.getTest() }

  override Stmt getASubStatement() {
    result = this.getAStmt() or
    result = this.getAnOrelse()
  }

  override Stmt getLastStatement() {
    result = this.getOrelse().getLastItem().getLastStatement()
    or
    not exists(this.getOrelse()) and
    result = this.getBody().getLastItem().getLastStatement()
  }
}

/** A with statement such as `with f as open("file"): text = f.read()` */
class With extends With_ {
  /* syntax: with Expr as varname: ... */
  override Expr getASubExpression() {
    result = this.getContextExpr() or
    result = this.getOptionalVars()
  }

  override Stmt getASubStatement() { result = this.getAStmt() }

  override Stmt getLastStatement() { result = this.getBody().getLastItem().getLastStatement() }
}

/** A plain text used in a template is wrapped in a TemplateWrite statement */
class TemplateWrite extends TemplateWrite_ {
  override Expr getASubExpression() { result = this.getValue() }

  override Stmt getASubStatement() { none() }
}

/** An asynchronous `for` statement, such as `async for varname in Expr: ...` */
class AsyncFor extends For {
  /* syntax: async for varname in Expr: ... */
  AsyncFor() { this.isAsync() }
}

/** An asynchronous `with` statement, such as `async with varname as Expr: ...` */
class AsyncWith extends With {
  /* syntax: async with Expr as varname: ... */
  AsyncWith() { this.isAsync() }
}

/** A list of statements */
class StmtList extends StmtList_ {
  /** Holds if this list of statements contains the AST node `a` */
  predicate contains(AstNode a) {
    exists(Stmt item | item = this.getAnItem() | item = a or item.contains(a))
  }

  /** Gets the last item in this list of statements, if any. */
  Stmt getLastItem() { result = this.getItem(max(int i | exists(this.getItem(i)))) }
}
