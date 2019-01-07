/** Provides classes for working with functions. */

import javascript

/** A function as defined either by a function declaration or a function expression. */
class Function extends @function, Parameterized, TypeParameterized, StmtContainer, Documentable,
  AST::ValueNode {
  /** Gets the `i`th parameter of this function. */
  Parameter getParameter(int i) { result = getChildExpr(i) }

  /** Gets a parameter of this function. */
  override Parameter getAParameter() { exists(int idx | result = getParameter(idx)) }

  /** Gets the parameter named `name` of this function, if any. */
  SimpleParameter getParameterByName(string name) {
    result = getAParameter() and
    result.getName() = name
  }

  /** Gets the `n`th type parameter declared on this function. */
  override TypeParameter getTypeParameter(int i) {
    // Type parameters are at indices -7, -10, -13, ...
    exists(int astIndex | typeexprs(result, _, this, astIndex, _) |
      astIndex <= -7 and astIndex % 4 = -3 and i = -(astIndex + 7) / 4
    )
  }

  /**
   * Gets the type annotation for the special `this` parameter, if it is present.
   *
   * For example, this would be `void` for the following function:
   * ```
   * function f(this: void, x: number, y: string) {}
   * ```
   *
   * The `this` parameter is not counted as an ordinary parameter.
   * The `x` parameter above is thus considered the first parameter of the function `f`.
   *
   * `this` parameter types are specific to TypeScript.
   */
  TypeExpr getThisTypeAnnotation() { result = getChildTypeExpr(-4) }

  /** Gets the identifier specifying the name of this function, if any. */
  VarDecl getId() { result = getChildExpr(-1) }

  /** Gets the name of this function, if any. */
  string getName() { result = getId().getName() }

  /** Gets the variable holding this function. */
  Variable getVariable() { result = getId().getVariable() }

  /** Gets the `arguments` variable of this function, if any. */
  ArgumentsVariable getArgumentsVariable() { result.getFunction() = this }

  /** Holds if the body of this function refers to the function's `arguments` variable. */
  predicate usesArgumentsObject() { exists(getArgumentsVariable().getAnAccess()) }

  /**
   * Holds if this function declares a parameter or local variable named `arguments`.
   */
  predicate declaresArguments() { exists(getScope().getVariable("arguments").getADeclaration()) }

  /** Gets the statement enclosing this function, if any. */
  Stmt getEnclosingStmt() { none() }

  /** Gets the body of this function. */
  override ExprOrStmt getBody() { result = getChild(-2) }

  /** Gets the `i`th statement in the body of this function. */
  Stmt getBodyStmt(int i) { result = getBody().(BlockStmt).getStmt(i) }

  /** Gets a statement in the body of this function. */
  Stmt getABodyStmt() { result = getBodyStmt(_) }

  /** Gets the number of statements in the body of this function. */
  int getNumBodyStmt() { result = count(getABodyStmt()) }

  /** Gets the return type annotation on this function, if any. */
  TypeExpr getReturnTypeAnnotation() { typeexprs(result, _, this, -3, _) }

  /** Holds if this function is a generator function. */
  predicate isGenerator() { isGenerator(this) }

  /** Holds if the last parameter of this function is a rest parameter. */
  predicate hasRestParameter() { hasRestParameter(this) }

  /**
   * Gets the last token of this function's parameter list, not including
   * the closing parenthesis, if any.
   */
  private Token lastTokenOfParameterList() {
    // if there are any parameters, it's the last token of the last parameter
    exists(Parameter lastParam | lastParam = getParameter(getNumParameter() - 1) |
      result = lastParam.getDefault().getLastToken()
      or
      not exists(lastParam.getDefault()) and result = lastParam.getLastToken()
    )
    or
    // otherwise we have an empty parameter list `()`, and
    // we want to return the opening parenthesis
    not exists(getAParameter()) and
    (
      // if the function has a name, the opening parenthesis comes right after it
      result = getId().getLastToken().getNextToken()
      or
      // otherwise this must be an arrow function with no parameters, so the opening
      // parenthesis is the very first token of the function
      not exists(getId()) and result = getFirstToken()
    )
  }

  /** Holds if the parameter list of this function has a trailing comma. */
  predicate hasTrailingComma() { lastTokenOfParameterList().getNextToken().getValue() = "," }

  /** Holds if this function is an asynchronous function. */
  predicate isAsync() { isAsync(this) }

  /** Gets the enclosing function or toplevel of this function. */
  override StmtContainer getEnclosingContainer() { result = getEnclosingStmt().getContainer() }

  /** Gets the number of lines in this function. */
  int getNumberOfLines() { numlines(this, result, _, _) }

  /** Gets the number of lines containing code in this function. */
  int getNumberOfLinesOfCode() { numlines(this, _, result, _) }

  /** Gets the number of lines containing comments in this function. */
  int getNumberOfLinesOfComments() { numlines(this, _, _, result) }

  /** Gets the cyclomatic complexity of this function. */
  int getCyclomaticComplexity() {
    result = 2 +
        sum(Expr nd |
          nd.getContainer() = this and nd.isBranch()
        |
          strictcount(nd.getASuccessor()) - 1
        )
  }

  override predicate isStrict() {
    // check for explicit strict mode directive
    exists(StrictModeDecl smd | this = smd.getContainer()) or
    // check for enclosing strict function
    StmtContainer.super.isStrict() or
    // all parts of a class definition are strict code
    this.getParent*() = any(ClassDefinition cd).getSuperClass() or
    this = any(MethodDeclaration md).getBody()
  }

  /** Gets a return statement in the body of this function, if any. */
  ReturnStmt getAReturnStmt() { result.getContainer() = this }

  /** Gets an expression that could be returned by this function, if any. */
  Expr getAReturnedExpr() {
    result = getBody() or
    result = getAReturnStmt().getExpr()
  }

  /**
   * Gets the function whose `this` binding a `this` expression in this function refers to,
   * which is the nearest enclosing non-arrow function.
   */
  Function getThisBinder() { result = this }

  /**
   * Gets the function or top-level whose `this` binding a `this` expression in this function refers to,
   * which is the nearest enclosing non-arrow function or top-level.
   */
  StmtContainer getThisBindingContainer() {
    result = getThisBinder()
    or
    not exists(getThisBinder()) and
    result = getTopLevel()
  }

  /**
   * Holds if this function has a mapped `arguments` variable whose indices are aliased
   * with the function's parameters.
   *
   * A function has a mapped `arguments` variable if it is non-strict, and has no rest
   * parameter, no parameter default values, and no destructuring parameters.
   */
  predicate hasMappedArgumentsVariable() {
    exists(getArgumentsVariable()) and
    not isStrict() and
    forall(Parameter p | p = getAParameter() |
      p instanceof SimpleParameter and not exists(p.getDefault())
    ) and
    not hasRestParameter()
  }

  /**
   * Gets a description of this function.
   *
   * For named functions such as `function f() { ... }`, this is just the declared
   * name. For functions assigned to variables or properties (including class
   * members), this is the name of the variable or property. If no meaningful name
   * can be inferred, the result is "anonymous function".
   */
  override string describe() {
    if exists(inferNameFromVarDef())
    then result = inferNameFromVarDef()
    else
      if exists(inferNameFromProp())
      then result = inferNameFromProp()
      else
        if exists(inferNameFromMemberDef())
        then result = inferNameFromMemberDef()
        else
          if exists(inferNameFromCallSig())
          then result = inferNameFromCallSig()
          else
            if exists(inferNameFromIndexSig())
            then result = inferNameFromIndexSig()
            else
              if exists(inferNameFromFunctionType())
              then result = inferNameFromFunctionType()
              else result = "anonymous function"
  }

  /**
   * Gets a description of this function, based on its declared name or the name
   * of the variable it is assigned to, if any.
   */
  private string inferNameFromVarDef() {
    // in ambiguous cases like `var f = function g() {}`, prefer `g` to `f`
    if exists(getName())
    then result = "function " + getName()
    else
      exists(VarDef vd | this = vd.getSource() |
        result = "function " + vd.getTarget().(VarRef).getName()
      )
  }

  /**
   * Gets a description of this function, based on the name of the property
   * it is assigned to, if any.
   */
  private string inferNameFromProp() {
    exists(Property p, string n | this = p.getInit() and n = p.getName() |
      p instanceof PropertyGetter and result = "getter for property " + n
      or
      p instanceof PropertySetter and result = "setter for property " + n
      or
      p instanceof ValueProperty and result = "method " + n
    )
  }

  /**
   * Gets a description of this function, based on the name of the class
   * member it is assigned to, if any.
   */
  private string inferNameFromMemberDef() {
    exists(ClassOrInterface c, string n, MemberDeclaration m, string classpp |
      m = c.getMember(n) and this = m.getInit() and classpp = c.describe()
    |
      if m instanceof ConstructorDeclaration
      then
        if m.(ConstructorDeclaration).isSynthetic()
        then result = "default constructor of " + classpp
        else result = "constructor of " + classpp
      else
        if m instanceof GetterMethodDeclaration
        then result = "getter method for property " + n + " of " + classpp
        else
          if m instanceof SetterMethodDeclaration
          then result = "setter method for property " + n + " of " + classpp
          else result = "method " + n + " of " + classpp
    )
  }

  /**
   * Gets a description of this function if it is part of a call signature.
   */
  private string inferNameFromCallSig() {
    exists(InterfaceDefinition c, CallSignature sig |
      sig = c.getACallSignature() and
      sig.getBody() = this and
      if sig instanceof FunctionCallSignature
      then result = "call signature of " + c.describe()
      else result = "construct signature of " + c.describe()
    )
  }

  /**
   * Gets a description of this function if it is part of a call signature.
   */
  private string inferNameFromIndexSig() {
    exists(InterfaceDefinition c | c.getAnIndexSignature().getBody() = this |
      result = "index signature of " + c.describe()
    )
  }

  /**
   * Gets a description of this function if it is part of a function type.
   */
  private string inferNameFromFunctionType() {
    exists(FunctionTypeExpr type | type.getFunction() = this | result = "anonymous function type")
  }

  /**
   * Holds if this function has a body.
   *
   * A TypeScript function has no body if it is ambient, abstract, or an overload signature.
   *
   * A JavaScript function always has a body.
   */
  predicate hasBody() { exists(getBody()) }

  /**
   * Holds if this function is part of an abstract class member.
   */
  predicate isAbstract() { exists(MethodDeclaration md | this = md.getBody() | md.isAbstract()) }

  override predicate isAmbient() { getParent().isAmbient() or not hasBody() }

  /**
   * Holds if this function cannot be invoked using `new` because it
   * is of the given `kind`.
   */
  predicate isNonConstructible(string kind) {
    this instanceof Method and
    not this instanceof Constructor and
    kind = "a method"
    or
    this instanceof ArrowFunctionExpr and
    kind = "an arrow function"
    or
    isGenerator() and
    kind = "a generator function"
    or
    isAsync() and
    kind = "an async function"
  }

  /**
   * Gets the canonical name for this function, as determined by the TypeScript compiler.
   *
   * This predicate is only populated for files extracted with full TypeScript extraction.
   */
  CanonicalFunctionName getCanonicalName() { ast_node_symbol(this, result) }
}

/**
 * A method defined in a class or object expression.
 */
class Method extends FunctionExpr {
  Method() {
    exists(MethodDeclaration md | this = md.getBody())
    or
    exists(ValueProperty p | p.isMethod() | this = p.getInit())
  }
}

/**
 * A constructor defined in a class.
 */
class Constructor extends FunctionExpr {
  Constructor() { exists(ConstructorDeclaration cd | this = cd.getBody()) }
}
