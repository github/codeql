/** Provides classes for working with functions. */

import javascript

/**
 * A function as defined either by a function declaration or a function expression.
 *
 * Examples:
 *
 * ```
 * function greet() {         // function declaration
 *   console.log("Hi");
 * }
 *
 * var greet =
 *   function() {             // function expression
 *     console.log("Hi");
 *   };
 *
 * var greet2 =
 *   () => console.log("Hi")  // arrow function expression
 *
 * var o = {
 *   m() {                    // function expression in a method definition in an object literal
 *     return 0;
 *   },
 *   get x() {                // function expression in a getter method definition in an object literal
 *     return 1
 *   }
 * };
 *
 * class C {
 *   m() {                    // function expression in a method definition in a class
 *     return 0;
 *   }
 * }
 * ```
 */
class Function extends @function, Parameterized, TypeParameterized, StmtContainer, Documentable,
  AST::ValueNode {
  /** Gets the `i`th parameter of this function. */
  Parameter getParameter(int i) { result = this.getChildExpr(i) }

  /** Gets a parameter of this function. */
  override Parameter getAParameter() { exists(int idx | result = this.getParameter(idx)) }

  /** Gets the parameter named `name` of this function, if any. */
  SimpleParameter getParameterByName(string name) {
    result = this.getAParameter() and
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
  TypeAnnotation getThisTypeAnnotation() {
    result = this.getChildTypeExpr(-4)
    or
    result = this.getDocumentation().getATagByTitle("this").getType()
  }

  /**
   * DEPRECATED: Use `getIdentifier()` instead.
   *
   * Gets the identifier specifying the name of this function, if any.
   */
  deprecated VarDecl getId() { result = this.getIdentifier() }

  /** Gets the identifier specifying the name of this function, if any. */
  VarDecl getIdentifier() { result = this.getChildExpr(-1) }

  /**
   * Gets the name of this function if it has one, or a name inferred from its context.
   *
   * For named functions such as `function f() { ... }`, this is just the declared
   * name. For functions assigned to variables or properties (including class
   * members), this is the name of the variable or property. If no meaningful name
   * can be inferred, there is no result.
   */
  string getName() {
    result = this.getIdentifier().getName()
    or
    not exists(this.getIdentifier()) and
    (
      exists(VarDef vd | this = vd.getSource() | result = vd.getTarget().(VarRef).getName())
      or
      exists(Property p |
        this = p.getInit() and
        result = p.getName()
      )
      or
      exists(AssignExpr assign, PropAccess prop |
        this = assign.getRhs().getUnderlyingValue() and
        prop = assign.getLhs() and
        result = prop.getPropertyName()
      )
      or
      exists(ClassOrInterface c | this = c.getMember(result).getInit())
    )
  }

  /** Gets the variable holding this function. */
  Variable getVariable() { result = this.getIdentifier().getVariable() }

  /** Gets the `arguments` variable of this function, if any. */
  ArgumentsVariable getArgumentsVariable() { result.getFunction() = this }

  /** Holds if the body of this function refers to the function's `arguments` variable. */
  predicate usesArgumentsObject() {
    exists(this.getArgumentsVariable().getAnAccess())
    or
    exists(PropAccess read |
      read.getBase() = this.getVariable().getAnAccess() and
      read.getPropertyName() = "arguments"
    )
  }

  /**
   * Holds if this function declares a parameter or local variable named `arguments`.
   */
  predicate declaresArguments() {
    exists(this.getScope().getVariable("arguments").getADeclaration())
  }

  /** Gets the statement enclosing this function, if any. */
  Stmt getEnclosingStmt() { none() }

  /** Gets the body of this function. */
  override ExprOrStmt getBody() { result = this.getChild(-2) }

  /** Gets the `i`th statement in the body of this function. */
  Stmt getBodyStmt(int i) { result = this.getBody().(BlockStmt).getStmt(i) }

  /** Gets a statement in the body of this function. */
  Stmt getABodyStmt() { result = this.getBodyStmt(_) }

  /** Gets the number of statements in the body of this function. */
  int getNumBodyStmt() { result = count(this.getABodyStmt()) }

  /** Gets the return type annotation on this function, if any. */
  TypeAnnotation getReturnTypeAnnotation() {
    typeexprs(result, _, this, -3, _)
    or
    exists(string title | title = "return" or title = "returns" |
      result = this.getDocumentation().getATagByTitle(title).getType()
    )
  }

  /** Holds if this function is a generator function. */
  predicate isGenerator() {
    is_generator(this)
    or
    // we also support `yield` in non-generator functions
    exists(YieldExpr yield | this = yield.getEnclosingFunction())
  }

  /** Holds if the last parameter of this function is a rest parameter. */
  predicate hasRestParameter() { has_rest_parameter(this) }

  /**
   * Gets the last token of this function's parameter list, not including
   * the closing parenthesis, if any.
   */
  private Token lastTokenOfParameterList() {
    // if there are any parameters, it's the last token of the last parameter
    exists(Parameter lastParam | lastParam = this.getParameter(this.getNumParameter() - 1) |
      result = lastParam.getDefault().getLastToken()
      or
      not exists(lastParam.getDefault()) and result = lastParam.getLastToken()
    )
    or
    // otherwise we have an empty parameter list `()`, and
    // we want to return the opening parenthesis
    not exists(this.getAParameter()) and
    (
      // if the function has a name, the opening parenthesis comes right after it
      result = this.getIdentifier().getLastToken().getNextToken()
      or
      // otherwise this must be an arrow function with no parameters, so the opening
      // parenthesis is the very first token of the function
      not exists(this.getIdentifier()) and result = this.getFirstToken()
    )
  }

  /** Holds if the parameter list of this function has a trailing comma. */
  predicate hasTrailingComma() { this.lastTokenOfParameterList().getNextToken().getValue() = "," }

  /** Holds if this function is an asynchronous function. */
  predicate isAsync() { is_async(this) }

  /** Holds if this function is asynchronous or a generator. */
  predicate isAsyncOrGenerator() { this.isAsync() or this.isGenerator() }

  /** Gets the enclosing function or toplevel of this function. */
  override StmtContainer getEnclosingContainer() { result = this.getEnclosingStmt().getContainer() }

  /** Gets the number of lines in this function. */
  int getNumberOfLines() {
    exists(int sl, int el | this.getLocation().hasLocationInfo(_, sl, _, el, _) |
      result = el - sl + 1
    )
  }

  /** Gets the number of lines containing code in this function. */
  int getNumberOfLinesOfCode() { result = LinesOfCode::getNumCodeLines(this) }

  /** Gets the number of lines containing comments in this function. */
  int getNumberOfLinesOfComments() { result = LinesOfComments::getNumCommentLines(this) }

  /** Gets the cyclomatic complexity of this function. */
  int getCyclomaticComplexity() {
    result =
      2 +
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
    result = this.getBody() or
    result = this.getAReturnStmt().getExpr()
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
    result = this.getThisBinder()
    or
    not exists(this.getThisBinder()) and
    result = this.getTopLevel()
  }

  /**
   * Holds if this function has a mapped `arguments` variable whose indices are aliased
   * with the function's parameters.
   *
   * A function has a mapped `arguments` variable if it is non-strict, and has no rest
   * parameter, no parameter default values, and no destructuring parameters.
   */
  predicate hasMappedArgumentsVariable() {
    exists(this.getArgumentsVariable()) and
    not this.isStrict() and
    forall(Parameter p | p = this.getAParameter() |
      p instanceof SimpleParameter and not exists(p.getDefault())
    ) and
    not this.hasRestParameter()
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
    if exists(this.inferNameFromVarDef())
    then result = this.inferNameFromVarDef()
    else
      if exists(this.inferNameFromProp())
      then result = this.inferNameFromProp()
      else
        if exists(this.inferNameFromMemberDef())
        then result = this.inferNameFromMemberDef()
        else
          if exists(this.inferNameFromCallSig())
          then result = this.inferNameFromCallSig()
          else
            if exists(this.inferNameFromIndexSig())
            then result = this.inferNameFromIndexSig()
            else
              if exists(this.inferNameFromFunctionType())
              then result = this.inferNameFromFunctionType()
              else result = "anonymous function"
  }

  /**
   * Gets a description of this function, based on its declared name or the name
   * of the variable it is assigned to, if any.
   */
  private string inferNameFromVarDef() {
    // in ambiguous cases like `var f = function g() {}`, prefer `g` to `f`
    if exists(this.getIdentifier())
    then result = "function " + this.getIdentifier().getName()
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
  predicate hasBody() { exists(this.getBody()) }

  /**
   * Holds if this function is part of an abstract class member.
   */
  predicate isAbstract() { exists(MethodDeclaration md | this = md.getBody() | md.isAbstract()) }

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
    this.isGenerator() and
    kind = "a generator function"
    or
    this.isAsync() and
    kind = "an async function"
  }

  /**
   * Gets the canonical name for this function, as determined by the TypeScript compiler.
   *
   * This predicate is only populated for files extracted with full TypeScript extraction.
   */
  CanonicalFunctionName getCanonicalName() { ast_node_symbol(this, result) }

  /**
   * Gets the call signature of this function, as determined by the TypeScript compiler, if any.
   */
  CallSignatureType getCallSignature() { declared_function_signature(this, result) }
}

/**
 * Provides predicates for computing lines-of-code information for functions.
 */
private module LinesOfCode {
  /**
   * Holds if `tk` is interesting for the purposes of counting lines of code, that is, it might
   * contribute a line of code that isn't covered by any other token.
   *
   * A token is interesting if it is the first token on its line, or if it spans multiple lines.
   */
  private predicate isInteresting(Token tk) {
    exists(int sl, int el | tk.getLocation().hasLocationInfo(_, sl, _, el, _) |
      not tk.getPreviousToken().getLocation().getEndLine() = sl
      or
      sl != el
    )
  }

  /**
   * Gets the `i`th token in toplevel `tl`, but only if it is interesting.
   */
  pragma[noinline]
  private Token getInterestingToken(TopLevel tl, int i) {
    result.getTopLevel() = tl and
    result.getIndex() = i and
    isInteresting(result)
  }

  /**
   * Holds if `f` covers tokens between indices `start` and `end` (inclusive) in toplevel `tl`.
   */
  predicate tokenRange(Function f, TopLevel tl, int start, int end) {
    tl = f.getTopLevel() and
    start = f.getFirstToken().getIndex() and
    end = f.getLastToken().getIndex()
  }

  /**
   * Gets an interesting token belonging to `f`.
   */
  private Token getAnInterestingToken(Function f) {
    result = f.getFirstToken()
    or
    exists(TopLevel tl, int start, int end | tokenRange(f, tl, start, end) |
      result = getInterestingToken(tl, [start .. end])
    )
  }

  /**
   * Gets the line number of a line covered by `f` that contains at least one token.
   */
  private int getACodeLine(Function f) {
    exists(Location loc | loc = getAnInterestingToken(f).getLocation() |
      result in [loc.getStartLine() .. loc.getEndLine()]
    )
  }

  /**
   * Gets the number of lines of code of `f`.
   *
   * Note the special handling of empty locations; this is needed to correctly deal with
   * synthetic constructors.
   */
  int getNumCodeLines(Function f) {
    if f.getLocation().isEmpty() then result = 0 else result = count(getACodeLine(f))
  }
}

/**
 * Provides predicates for computing lines-of-comments information for functions.
 */
private module LinesOfComments {
  /**
   * Holds if `tk` is interesting for the purposes of counting comments, that is,
   * if it is preceded by a comment.
   */
  private predicate isInteresting(Token tk) { exists(Comment c | tk = c.getNextToken()) }

  /**
   * Gets the `i`th token in `tl`, if it is interesting.
   */
  pragma[noinline]
  private Token getToken(TopLevel tl, int i) {
    result.getTopLevel() = tl and
    result.getIndex() = i and
    isInteresting(result)
  }

  /**
   * Gets a comment inside function `f`.
   */
  private Comment getAComment(Function f) {
    exists(TopLevel tl, int start, int end | LinesOfCode::tokenRange(f, tl, start, end) |
      result.getNextToken() = getToken(tl, [start + 1 .. end])
    )
  }

  /**
   * Gets a line covered by `f` on which at least one comment appears.
   */
  private int getACommentLine(Function f) {
    exists(Location loc | loc = getAComment(f).getLocation() |
      result in [loc.getStartLine() .. loc.getEndLine()]
    )
  }

  /**
   * Gets the number of lines with at least one comment in `f`.
   */
  int getNumCommentLines(Function f) { result = count(getACommentLine(f)) }
}

/**
 * A method defined in a class or object expression.
 *
 * Examples:
 *
 * ```
 * var o = {
 *   m() {          // method defined in an object expression
 *     return 0;
 *   }
 * };
 *
 * class C {
 *   m() {          // method defined in a class
 *     return 0;
 *   }
 * }
 * ```
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
 *
 * Example:
 *
 * ```
 * class Point {
 *   constructor(x, y) {  // constructor
 *     this.x = x;
 *     this.y = y;
 *   }
 * }
 */
class Constructor extends FunctionExpr {
  Constructor() { exists(ConstructorDeclaration cd | this = cd.getBody()) }
}
