import python

/**
 * A function, independent of defaults and binding.
 * It is the syntactic entity that is compiled to a code object.
 */
class Function extends Function_, Scope, AstNode {
  /** Gets the expression defining this function */
  CallableExpr getDefinition() { result = this.getParent() }

  /**
   * Gets the scope in which this function occurs. This will be a class for a method,
   * another function for nested functions, generator expressions or comprehensions,
   * or a module for a plain function.
   */
  override Scope getEnclosingScope() { result = this.getParent().(Expr).getScope() }

  override Scope getScope() { result = this.getEnclosingScope() }

  /** Whether this function is declared in a class */
  predicate isMethod() { this.getEnclosingScope() instanceof Class }

  /** Whether this is a special method, that is does its name have the form `__xxx__` (except `__init__`) */
  predicate isSpecialMethod() {
    this.isMethod() and
    exists(string name | this.getName() = name |
      name.matches("\\_\\_%\\_\\_") and
      name != "__init__"
    )
  }

  /**
   * Whether this function is a generator function,
   * that is whether it contains a yield or yield-from expression
   */
  predicate isGenerator() {
    exists(Yield y | y.getScope() = this)
    or
    exists(YieldFrom y | y.getScope() = this)
  }

  /**
   * Holds if this function represents a lambda.
   *
   * The extractor reifies each lambda expression as a (local) function with the name
   * "lambda". As `lambda` is a keyword in Python, it's impossible to create a function with this
   * name otherwise, and so it's impossible to get a non-lambda function accidentally
   * classified as a lambda.
   */
  predicate isLambda() { this.getName() = "lambda" }

  /** Whether this function is declared in a class and is named `__init__` */
  predicate isInitMethod() { this.isMethod() and this.getName() = "__init__" }

  /** Gets a decorator of this function */
  Expr getADecorator() { result = this.getDefinition().(FunctionExpr).getADecorator() }

  /** Gets the name of the nth argument (for simple arguments) */
  string getArgName(int index) { result = this.getArg(index).(Name).getId() }

  /** Gets the parameter of this function with the name `name`. */
  Parameter getArgByName(string name) {
    (
      result = this.getAnArg()
      or
      result = this.getAKeywordOnlyArg()
    ) and
    result.(Name).getId() = name
  }

  override Location getLocation() { py_scope_location(result, this) }

  override string toString() { result = "Function " + this.getName() }

  /** Gets the statements forming the body of this function */
  override StmtList getBody() { result = Function_.super.getBody() }

  /** Gets the nth statement in the function */
  override Stmt getStmt(int index) { result = Function_.super.getStmt(index) }

  /** Gets a statement in the function */
  override Stmt getAStmt() { result = Function_.super.getAStmt() }

  /** Gets the name used to define this function */
  override string getName() { result = Function_.super.getName() }

  /** Gets the metrics for this function */
  FunctionMetrics getMetrics() { result = this }

  /** Gets the FunctionObject corresponding to this function */
  FunctionObject getFunctionObject() { result.getOrigin() = this.getDefinition() }

  /**
   * Whether this function is a procedure, that is, it has no explicit return statement and always returns None.
   * Note that generator and async functions are not procedures as they return generators and coroutines respectively.
   */
  predicate isProcedure() {
    not exists(this.getReturnNode()) and
    exists(this.getFallthroughNode()) and
    not this.isGenerator() and
    not this.isAsync()
  }

  /** Gets the number of positional parameters */
  int getPositionalParameterCount() { result = count(this.getAnArg()) }

  /** Gets the number of keyword-only parameters */
  int getKeywordOnlyParameterCount() { result = count(this.getAKeywordOnlyArg()) }

  /** Whether this function accepts a variable number of arguments. That is, whether it has a starred (*arg) parameter. */
  predicate hasVarArg() { exists(this.getVararg()) }

  /** Whether this function accepts arbitrary keyword arguments. That is, whether it has a double-starred (**kwarg) parameter. */
  predicate hasKwArg() { exists(this.getKwarg()) }

  override AstNode getAChildNode() {
    result = this.getAStmt() or
    result = this.getAnArg() or
    result = this.getVararg() or
    result = this.getAKeywordOnlyArg() or
    result = this.getKwarg()
  }

  /**
   * Gets the qualified name for this function.
   * Should return the same name as the `__qualname__` attribute on functions in Python 3.
   */
  string getQualifiedName() {
    this.getEnclosingScope() instanceof Module and result = this.getName()
    or
    exists(string enclosing_name |
      enclosing_name = this.getEnclosingScope().(Function).getQualifiedName()
      or
      enclosing_name = this.getEnclosingScope().(Class).getQualifiedName()
    |
      result = enclosing_name + "." + this.getName()
    )
  }

  /** Gets the nth keyword-only parameter of this function. */
  Name getKeywordOnlyArg(int n) { result = Function_.super.getKwonlyarg(n) }

  /** Gets a keyword-only parameter of this function. */
  Name getAKeywordOnlyArg() { result = this.getKeywordOnlyArg(_) }

  override Scope getEvaluatingScope() {
    major_version() = 2 and
    exists(Comp comp | comp.getFunction() = this | result = comp.getEvaluatingScope())
    or
    not exists(Comp comp | comp.getFunction() = this) and result = this
    or
    major_version() = 3 and result = this
  }

  override predicate containsInScope(AstNode inner) { Scope.super.containsInScope(inner) }

  override predicate contains(AstNode inner) { Scope.super.contains(inner) }

  /** Gets a control flow node for a return value of this function */
  ControlFlowNode getAReturnValueFlowNode() {
    exists(Return ret |
      ret.getScope() = this and
      ret.getValue() = result.getNode()
    )
  }
}

/** A def statement. Note that FunctionDef extends Assign as a function definition binds the newly created function */
class FunctionDef extends Assign {
  FunctionExpr f;

  /* syntax: def name(...): ... */
  FunctionDef() {
    /* This is an artificial assignment the rhs of which is a (possibly decorated) FunctionExpr */
    this.getValue() = f or this.getValue() = f.getADecoratorCall()
  }

  override string toString() { result = "FunctionDef" }

  /** Gets the function for this statement */
  Function getDefinedFunction() { result = f.getInnerScope() }

  override Stmt getLastStatement() { result = this.getDefinedFunction().getLastStatement() }
}

/** A function that uses 'fast' locals, stored in the frame not in a dictionary. */
class FastLocalsFunction extends Function {
  FastLocalsFunction() {
    not exists(ImportStar i | i.getScope() = this) and
    not exists(Exec e | e.getScope() = this)
  }
}

/** A parameter. Either a Tuple or a Name (always a Name for Python 3) */
class Parameter extends Parameter_ {
  Parameter() {
    /* Parameter_ is just defined as a Name or Tuple, narrow to actual parameters */
    exists(ParameterList pl | py_exprs(this, _, pl, _))
    or
    exists(Function f |
      f.getVararg() = this
      or
      f.getKwarg() = this
      or
      f.getAKeywordOnlyArg() = this
    )
  }

  Location getLocation() {
    result = this.asName().getLocation()
    or
    result = this.asTuple().getLocation()
  }

  /** Gets this parameter if it is a Name (not a Tuple) */
  Name asName() { result = this }

  /** Gets this parameter if it is a Tuple (not a Name) */
  Tuple asTuple() { result = this }

  /** Gets the expression for the default value of this parameter */
  Expr getDefault() {
    exists(Function f, int i, Arguments args | args = f.getDefinition().getArgs() |
      // positional (normal)
      f.getArg(i) = this and
      result = args.getDefault(i)
    )
    or
    exists(Function f, int i, Arguments args | args = f.getDefinition().getArgs() |
      // keyword-only
      f.getKeywordOnlyArg(i) = this and
      result = args.getKwDefault(i)
    )
  }

  /** Gets the annotation expression of this parameter */
  Expr getAnnotation() {
    exists(Function f, int i, Arguments args | args = f.getDefinition().getArgs() |
      // positional (normal)
      f.getArg(i) = this and
      result = args.getAnnotation(i)
    )
    or
    exists(Function f, int i, Arguments args | args = f.getDefinition().getArgs() |
      // keyword-only
      f.getKeywordOnlyArg(i) = this and
      result = args.getKwAnnotation(i)
    )
    or
    exists(Function f, Arguments args | args = f.getDefinition().getArgs() |
      f.getKwarg() = this and
      result = args.getKwargannotation()
      or
      f.getVararg() = this and
      result = args.getVarargannotation()
    )
  }

  Variable getVariable() { result.getAnAccess() = this.asName() }

  /**
   * Gets the position of this parameter (if any).
   * No result if this is a "varargs", "kwargs", or keyword-only parameter.
   */
  int getPosition() { exists(Function f | f.getArg(result) = this) }

  /** Gets the name of this parameter */
  string getName() { result = this.asName().getId() }

  /** Holds if this parameter is the first parameter of a method. It is not necessarily called "self" */
  predicate isSelf() {
    exists(Function f |
      f.getArg(0) = this and
      f.isMethod()
    )
  }

  /**
   * Holds if this parameter is a "varargs" parameter.
   * The `varargs` in `f(a, b, *varargs)`.
   */
  predicate isVarargs() { exists(Function func | func.getVararg() = this) }

  /**
   * Holds if this parameter is a "kwargs" parameter.
   * The `kwargs` in `f(a, b, **kwargs)`.
   */
  predicate isKwargs() { exists(Function func | func.getKwarg() = this) }
}

/** An expression that generates a callable object, either a function expression or a lambda */
abstract class CallableExpr extends Expr {
  /**
   * Gets The default values and annotations (type-hints) for the arguments of this callable.
   *
   * This predicate is called getArgs(), rather than getParameters() for compatibility with Python's AST module.
   */
  abstract Arguments getArgs();

  /** Gets the function scope of this code expression. */
  abstract Function getInnerScope();
}

/** An (artificial) expression corresponding to a function definition. */
class FunctionExpr extends FunctionExpr_, CallableExpr {
  override Expr getASubExpression() {
    result = this.getArgs().getASubExpression() or
    result = this.getReturns()
  }

  override predicate hasSideEffects() { any() }

  Call getADecoratorCall() {
    result.getArg(0) = this or
    result.getArg(0) = this.getADecoratorCall()
  }

  /** Gets a decorator of this function expression */
  Expr getADecorator() { result = this.getADecoratorCall().getFunc() }

  override AstNode getAChildNode() {
    result = this.getASubExpression()
    or
    result = this.getInnerScope()
  }

  override Function getInnerScope() { result = FunctionExpr_.super.getInnerScope() }

  override Arguments getArgs() { result = FunctionExpr_.super.getArgs() }
}

/** A lambda expression, such as `lambda x: x+1` */
class Lambda extends Lambda_, CallableExpr {
  /** Gets the expression to the right of the colon in this lambda expression */
  Expr getExpression() {
    exists(Return ret | ret = this.getInnerScope().getStmt(0) | result = ret.getValue())
  }

  override Expr getASubExpression() { result = this.getArgs().getASubExpression() }

  override AstNode getAChildNode() {
    result = this.getASubExpression() or
    result = this.getInnerScope()
  }

  override Function getInnerScope() { result = Lambda_.super.getInnerScope() }

  override Arguments getArgs() { result = Lambda_.super.getArgs() }
}

/**
 * The default values and annotations (type hints) for the arguments in a function definition.
 *
 * Annotations (PEP 3107) is a general mechanism for providing annotations for a function,
 * that is generally only used for type hints today (PEP 484).
 */
class Arguments extends Arguments_ {
  Expr getASubExpression() {
    result = this.getADefault() or
    result = this.getAKwDefault() or
    //
    result = this.getAnAnnotation() or
    result = this.getVarargannotation() or
    result = this.getAKwAnnotation() or
    result = this.getKwargannotation()
  }

  // The following 4 methods are overwritten to provide better QLdoc. Since the
  // Arguments_ is auto-generated, we can't change the poor auto-generated docs there :(
  /** Gets the default value for the `index`'th positional parameter. */
  override Expr getDefault(int index) { result = super.getDefault(index) }

  /** Gets the default value for the `index`'th keyword-only parameter. */
  override Expr getKwDefault(int index) { result = super.getKwDefault(index) }

  /** Gets the annotation for the `index`'th positional parameter. */
  override Expr getAnnotation(int index) { result = super.getAnnotation(index) }

  /** Gets the annotation for the `index`'th keyword-only parameter. */
  override Expr getKwAnnotation(int index) { result = super.getKwAnnotation(index) }
}
