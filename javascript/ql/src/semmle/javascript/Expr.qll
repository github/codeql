/**
 * Provides classes for working with expressions.
 */

import javascript

/**
 * A program element that is either an expression or a type annotation.
 *
 * Examples:
 *
 * ```
 * x + 1
 * string[]
 * ```
 */
class ExprOrType extends @expr_or_type, Documentable {
  /** Gets the statement in which this expression or type appears. */
  Stmt getEnclosingStmt() { enclosing_stmt(this, result) }

  /** Gets the function in which this expression or type appears, if any. */
  Function getEnclosingFunction() { result = getContainer() }

  /**
   * Gets the JSDoc comment associated with this expression or type or its parent statement, if any.
   */
  override JSDoc getDocumentation() {
    result = getOwnDocumentation()
    or
    // if there is no JSDoc for the expression itself, check the enclosing property or statement
    not exists(getOwnDocumentation()) and
    (
      exists(Property prop | prop = getParent() | result = prop.getDocumentation())
      or
      exists(MethodDeclaration decl | decl = getParent() | result = decl.getDocumentation())
      or
      exists(VariableDeclarator decl | decl = getParent() | result = decl.getDocumentation())
      or
      exists(DeclStmt stmt | this = stmt.getDecl(0) | result = stmt.getDocumentation())
      or
      exists(DotExpr dot | this = dot.getProperty() | result = dot.getDocumentation())
      or
      exists(AssignExpr e | this = e.getRhs() | result = e.getDocumentation())
      or
      exists(ParExpr p | this = p.getExpression() | result = p.getDocumentation())
    )
  }

  /** Gets a JSDoc comment that is immediately before this expression or type (ignoring parentheses). */
  private JSDoc getOwnDocumentation() {
    exists(Token tk | tk = result.getComment().getNextToken() |
      tk = this.getFirstToken()
      or
      exists(Expr p | p.getUnderlyingValue() = this | tk = p.getFirstToken())
    )
  }

  /**
   * Gets this expression or type, with any surrounding parentheses removed.
   *
   * Also see `getUnderlyingValue` and `getUnderlyingReference`.
   */
  ExprOrType stripParens() { result = this }

  /**
   * Gets the innermost reference that this expression evaluates to, if any.
   *
   * Examples:
   *
   * - a variable or property access: the access itself.
   * - a parenthesized expression `(e)`: the underlying reference of `e`.
   * - a TypeScript type assertion `e as T`: the underlying reference of `e`.
   *
   * Also see `getUnderlyingValue` and `stripParens`.
   */
  Expr getUnderlyingReference() { none() }

  /**
   * Gets the innermost expression that this expression evaluates to.
   *
   * Examples:
   *
   * - a parenthesised expression `(e)`: the underlying value of `e`.
   * - a sequence expression `e1, e2`: the underlying value of `e2`.
   * - an assignment expression `v = e`: the underlying value of `e`.
   * - a TypeScript type assertion `e as T`: the underlying value of `e`.
   * - any other expression: the expression itself.
   *
   * Also see `getUnderlyingReference` and `stripParens`.
   */
  Expr getUnderlyingValue() { result = this }
}

/**
 * An expression.
 *
 * Example:
 *
 * ```
 * Math.sqrt(x*x + y*y)
 * ```
 */
class Expr extends @expr, ExprOrStmt, ExprOrType, AST::ValueNode {
  /** Gets this expression, with any surrounding parentheses removed. */
  override Expr stripParens() { result = this }

  /** Gets the constant integer value this expression evaluates to, if any. */
  int getIntValue() { none() }

  /** Gets the constant string value this expression evaluates to, if any. */
  cached
  string getStringValue() { result = getStringValue(this) }

  /** Holds if this expression is impure, that is, its evaluation could have side effects. */
  predicate isImpure() { any() }

  /**
   * Holds if this expression is pure, that is, is its evaluation is guaranteed to be
   * side effect-free.
   */
  predicate isPure() { not isImpure() }

  /**
   * Gets the kind of this expression, which is an integer value representing the expression's
   * node type.
   *
   * _Note_: The mapping from node types to integers is considered an implementation detail
   * and may change between versions of the extractor.
   */
  int getKind() { exprs(this, result, _, _, _) }

  override string toString() { exprs(this, _, _, _, result) }

  /**
   * Gets the expression that is the parent of this expression in the AST, if any.
   *
   * Note that for property names and property values the associated object expression or pattern
   * is returned, skipping the property node itself (which is not an expression).
   */
  Expr getParentExpr() {
    this = result.getAChildExpr()
    or
    exists(Property prop |
      result = prop.getParent() and
      this = prop.getAChildExpr()
    )
  }

  /**
   * Holds if this expression accesses the global variable `g`, either directly
   * or through the `window` object.
   */
  predicate accessesGlobal(string g) { flow().accessesGlobal(g) }

  /**
   * Holds if this expression may evaluate to `s`.
   */
  predicate mayHaveStringValue(string s) { flow().mayHaveStringValue(s) }

  /**
   * Holds if this expression may evaluate to `b`.
   */
  predicate mayHaveBooleanValue(boolean b) { flow().mayHaveBooleanValue(b) }

  /**
   * Holds if this expression may refer to the initial value of parameter `p`.
   */
  predicate mayReferToParameter(Parameter p) { flow().mayReferToParameter(p) }

  /**
   * Gets the static type of this expression, as determined by the TypeScript type system.
   *
   * Has no result if the expression is in a JavaScript file or in a TypeScript
   * file that was extracted without type information.
   */
  Type getType() { ast_node_type(this, result) }

  /**
   * Holds if the syntactic context that the expression appears in relies on the expression
   * being non-null/non-undefined.
   *
   * A context relies on the subexpression being non-null/non-undefined if either...
   *
   *   * Using null or undefined would cause a runtime error
   *   * Using null or undefined would cause no error due to type conversion, but the
   *     behavior in the broader context is sufficiently non-obvious to warrant explicitly
   *     converting to ensure that readers understand the intent
   */
  predicate inNullSensitiveContext() {
    exists(ExprOrStmt ctx |
      // bases cases
      this = ctx.(PropAccess).getBase()
      or
      this = ctx.(IndexExpr).getPropertyNameExpr()
      or
      this = ctx.(InvokeExpr).getCallee()
      or
      this = ctx.(BinaryExpr).getAnOperand() and
      not ctx instanceof LogicalBinaryExpr and // x LOGOP y is fine because of implicit conversion
      not ctx instanceof EqualityTest and // x EQOP y is fine because of implicit conversion and lack thereof
      not ctx.(BitOrExpr).getAnOperand().(NumberLiteral).getIntValue() = 0 and // x | 0 is fine because it's used to convert to numbers
      not ctx.(RShiftExpr).getRightOperand().(NumberLiteral).getIntValue() = 0 and // x >> 0 is fine because it's used to convert to numbers
      not ctx.(URShiftExpr).getRightOperand().(NumberLiteral).getIntValue() = 0 // x >>> 0 is fine because it's used to convert to numbers
      or
      this = ctx.(UnaryExpr).getOperand() and
      not ctx instanceof LogNotExpr and // !x is fine because of implicit conversion
      not ctx instanceof PlusExpr and // +x is fine because of implicit conversion
      not ctx instanceof VoidExpr // void x is fine because it explicitly is for capturing void things
      or
      this = ctx.(UpdateExpr).getOperand()
      or
      this = ctx.(CompoundAssignExpr).getLhs()
      or
      this = ctx.(CompoundAssignExpr).getRhs()
      or
      this = ctx.(AssignExpr).getRhs() and
      ctx.(AssignExpr).getLhs() instanceof DestructuringPattern
      or
      this = ctx.(SpreadElement).getOperand()
      or
      this = ctx.(ForOfStmt).getIterationDomain()
      or
      // recursive cases
      this = ctx.(ParExpr).getExpression() and
      ctx.(ParExpr).inNullSensitiveContext()
      or
      this = ctx.(SeqExpr).getLastOperand() and
      ctx.(SeqExpr).inNullSensitiveContext()
      or
      this = ctx.(LogicalBinaryExpr).getRightOperand() and
      ctx.(LogicalBinaryExpr).inNullSensitiveContext()
      or
      this = ctx.(ConditionalExpr).getABranch() and
      ctx.(ConditionalExpr).inNullSensitiveContext()
    )
  }

  pragma[inline]
  private Stmt getRawEnclosingStmt(Expr e) {
    // For performance reasons, we need the enclosing statement without overrides
    enclosing_stmt(e, result)
  }

  /**
   * Gets the data-flow node where exceptions thrown by this expression will
   * propagate if this expression causes an exception to be thrown.
   */
  pragma[inline]
  DataFlow::Node getExceptionTarget() {
    result = getCatchParameterFromStmt(getRawEnclosingStmt(this))
    or
    not exists(getCatchParameterFromStmt(getRawEnclosingStmt(this))) and
    result =
      any(DataFlow::FunctionNode f | f.getFunction() = this.getContainer()).getExceptionalReturn()
  }
}

cached
private DataFlow::Node getCatchParameterFromStmt(Stmt stmt) {
  result =
    DataFlow::parameterNode(stmt.getEnclosingTryCatchStmt().getACatchClause().getAParameter())
}

/**
 * An identifier.
 *
 * Example:
 *
 * ```
 * x
 * ```
 */
class Identifier extends @identifier, ExprOrType {
  /** Gets the name of this identifier. */
  string getName() { literals(result, _, this) }

  override string getAPrimaryQlClass() { result = "Identifier" }
}

/**
 * A statement or property label, that is, an identifier that
 * does not refer to a variable.
 *
 * Examples:
 *
 * ```
 * outer:                       // `outer` is a statement label
 * for(i=0; i<a.length; ++i) {  // `length` is a property label
 *   // ...
 * }
 * ```
 */
class Label extends @label, Identifier, Expr {
  override predicate isImpure() { none() }

  override string getAPrimaryQlClass() { result = "Label" }
}

/**
 * A literal.
 *
 * Examples:
 *
 * ```
 * null      // null literal
 * true      // Boolean literal
 * 2         // number literal
 * 3n        // BigInt literal
 * "hello"   // string literal
 * /jsx?/    // regular-expression literal
 * ```
 */
class Literal extends @literal, Expr {
  /** Gets the value of this literal, as a string. */
  string getValue() { literals(result, _, this) }

  /**
   * Gets the raw source text of this literal, including quotes for
   * string literals.
   */
  string getRawValue() { literals(_, result, this) }

  override predicate isImpure() { none() }

  override string getAPrimaryQlClass() { result = "Literal" }
}

/**
 * A parenthesized expression.
 *
 * Example:
 *
 * ```
 * (function() { console.log("Hello, world!"); }())
 * ```
 */
class ParExpr extends @par_expr, Expr {
  /** Gets the expression within parentheses. */
  Expr getExpression() { result = this.getChildExpr(0) }

  override Expr stripParens() { result = getExpression().stripParens() }

  override int getIntValue() { result = getExpression().getIntValue() }

  override predicate isImpure() { getExpression().isImpure() }

  override Expr getUnderlyingValue() { result = getExpression().getUnderlyingValue() }

  override Expr getUnderlyingReference() { result = getExpression().getUnderlyingReference() }

  override string getAPrimaryQlClass() { result = "ParExpr" }
}

/**
 * A `null` literal.
 *
 * Example:
 *
 * ```
 * null
 * ```
 */
class NullLiteral extends @null_literal, Literal { }

/**
 * A Boolean literal, that is, either `true` or `false`.
 *
 * Examples:
 *
 * ```
 * true
 * false
 * ```
 */
class BooleanLiteral extends @boolean_literal, Literal { }

/**
 * A numeric literal.
 *
 * Examples:
 *
 * ```
 * 0b101
 * 0o31
 * 25
 * 0xffff
 * 6.626e-34
 * ```
 */
class NumberLiteral extends @number_literal, Literal {
  /** Gets the integer value of this literal. */
  override int getIntValue() { result = getValue().toInt() }

  /** Gets the floating point value of this literal. */
  float getFloatValue() { result = getValue().toFloat() }
}

/**
 * A BigInt literal.
 *
 * Example:
 *
 * ```
 * 9007199254740991n
 * ```
 */
class BigIntLiteral extends @bigint_literal, Literal {
  /**
   * Gets the integer value of this literal if it can be represented
   * as a QL integer value.
   */
  override int getIntValue() { result = getValue().toInt() }

  /**
   * Gets the floating point value of this literal if it can be represented
   * as a QL floating point value.
   */
  float getFloatValue() { result = getValue().toFloat() }
}

/**
 * A string literal, either single-quoted or double-quoted.
 *
 * Note that template literals are represented by a different class, `TemplateLiteral`.
 *
 * Examples:
 *
 * ```
 * "Hello, world!\n"
 * 'Hello, "world"!'
 * ```
 */
class StringLiteral extends @string_literal, Literal {
  /**
   * Gets the value of this string literal parsed as a regular expression, if possible.
   *
   * All string literals have an associated regular expression tree, provided they can
   * be parsed without syntax errors.
   */
  RegExpTerm asRegExp() { this = result.getParent() }
}

/**
 * A regular expression literal.
 *
 * Note that this class does not cover regular expressions constructed by calling the built-in
 * `RegExp` function.
 *
 * Example:
 *
 * ```
 * /(?i)ab*c(d|e)$/
 * ```
 */
class RegExpLiteral extends @regexp_literal, Literal, RegExpParent {
  /** Gets the root term of this regular expression literal. */
  RegExpTerm getRoot() { this = result.getParent() }

  /** Gets the flags of this regular expression. */
  string getFlags() { result = getValue().regexpCapture(".*/(\\w*)$", 1) }

  /** Holds if this regular expression has an `m` flag. */
  predicate isMultiline() { RegExp::isMultiline(getFlags()) }

  /** Holds if this regular expression has a `g` flag. */
  predicate isGlobal() { RegExp::isGlobal(getFlags()) }

  /** Holds if this regular expression has an `i` flag. */
  predicate isIgnoreCase() { RegExp::isIgnoreCase(getFlags()) }

  /** Holds if this regular expression has an `s` flag. */
  predicate isDotAll() { RegExp::isDotAll(getFlags()) }

  override string getAPrimaryQlClass() { result = "RegExpLiteral" }
}

/**
 * A `this` expression.
 *
 * Example:
 *
 * ```
 * this
 * ```
 */
class ThisExpr extends @this_expr, Expr {
  override predicate isImpure() { none() }

  /**
   * Gets the function whose `this` binding this expression refers to,
   * which is the nearest enclosing non-arrow function.
   */
  Function getBinder() { result = getEnclosingFunction().getThisBinder() }

  /**
   * Gets the function or top-level whose `this` binding this expression refers to,
   * which is the nearest enclosing non-arrow function or top-level.
   */
  StmtContainer getBindingContainer() {
    result = getContainer().(Function).getThisBindingContainer()
    or
    result = getContainer().(TopLevel)
  }

  override string getAPrimaryQlClass() { result = "ThisExpr" }
}

/**
 * An array literal.
 *
 * Examples:
 *
 * ```
 * [ 1, , [ 3, 4 ] ]
 * ```
 */
class ArrayExpr extends @array_expr, Expr {
  /** Gets the `i`th element of this array literal. */
  Expr getElement(int i) { result = this.getChildExpr(i) }

  /** Gets an element of this array literal. */
  Expr getAnElement() { result = this.getAChildExpr() }

  /** Gets the number of elements in this array literal. */
  int getSize() { array_size(this, result) }

  /**
   * Holds if this array literal includes a trailing comma after the
   * last element.
   */
  predicate hasTrailingComma() { this.getLastToken().getPreviousToken().getValue() = "," }

  /** Holds if the `i`th element of this array literal is omitted. */
  predicate elementIsOmitted(int i) {
    i in [0 .. getSize() - 1] and
    not exists(getElement(i))
  }

  /** Holds if this array literal has an omitted element. */
  predicate hasOmittedElement() { elementIsOmitted(_) }

  override predicate isImpure() { getAnElement().isImpure() }

  override string getAPrimaryQlClass() { result = "ArrayExpr" }
}

/**
 * An object literal, containing zero or more property definitions.
 *
 * Example:
 *
 * ```
 * var p = {  // object literal containing five property definitions
 *   x: 1,
 *   y: 1,
 *   diag: function() { return this.x - this.y; },
 *   get area() { return this.x * this.y; },
 *   set area(a) { this.x = Math.sqrt(a); this.y = Math.sqrt(a); }
 * };
 * ```
 */
class ObjectExpr extends @obj_expr, Expr {
  /** Gets the `i`th property in this object literal. */
  Property getProperty(int i) { properties(result, this, i, _, _) }

  /** Gets a property in this object literal. */
  Property getAProperty() { exists(int i | result = this.getProperty(i)) }

  /** Gets the number of properties in this object literal. */
  int getNumProperty() { result = count(this.getAProperty()) }

  /** Gets the property with the given name, if any. */
  Property getPropertyByName(string name) {
    result = this.getAProperty() and
    result.getName() = name
  }

  /**
   * Holds if this object literal includes a trailing comma after the
   * last property.
   */
  predicate hasTrailingComma() { this.getLastToken().getPreviousToken().getValue() = "," }

  override predicate isImpure() { getAProperty().isImpure() }

  override string getAPrimaryQlClass() { result = "ObjectExpr" }
}

/**
 * A property definition in an object literal, which may be either
 * a value property, a property getter, or a property setter.
 *
 * Note that property definitions are not expressions.
 *
 * Examples:
 *
 * ```
 * var p = {
 *   x: 1,                                                          // value property
 *   y: 1,                                                          // value property
 *   diag: function() { return this.x - this.y; },                  // value property
 *   get area() { return this.x * this.y; },                        // property getter
 *   set area(a) { this.x = Math.sqrt(a); this.y = Math.sqrt(a); }  // property setter
 * }
 * ```
 */
class Property extends @property, Documentable {
  Property() {
    // filter out property patterns and JSX attributes
    exists(ObjectExpr obj | properties(this, obj, _, _, _))
  }

  /**
   * Gets the expression specifying the name of this property.
   *
   * For normal properties, this is either an identifier, a string literal, or a
   * numeric literal; for computed properties it can be an arbitrary expression;
   * for spread properties, it is not defined.
   */
  Expr getNameExpr() { result = this.getChildExpr(0) }

  /** Gets the expression specifying the initial value of this property. */
  Expr getInit() { result = this.getChildExpr(1) }

  /** Gets the name of this property. */
  string getName() {
    not isComputed() and result = getNameExpr().(Identifier).getName()
    or
    result = getNameExpr().(Literal).getValue()
  }

  /** Holds if the name of this property is computed. */
  predicate isComputed() { is_computed(this) }

  /** Holds if this property is defined using method syntax. */
  predicate isMethod() { is_method(this) }

  /** Holds if this property is defined using shorthand syntax. */
  predicate isShorthand() { getNameExpr().getLocation() = getInit().getLocation() }

  /** Gets the object literal this property belongs to. */
  ObjectExpr getObjectExpr() { properties(this, result, _, _, _) }

  /** Gets the (0-based) index at which this property appears in its enclosing literal. */
  int getIndex() { this = getObjectExpr().getProperty(result) }

  /**
   * Holds if this property is impure, that is, the evaluation of its name or
   * its initializer expression could have side effects.
   */
  predicate isImpure() {
    isComputed() and getNameExpr().isImpure()
    or
    getInit().isImpure()
  }

  override string toString() { properties(this, _, _, _, result) }

  override ControlFlowNode getFirstControlFlowNode() {
    result = getNameExpr().getFirstControlFlowNode()
    or
    not exists(getNameExpr()) and result = getInit().getFirstControlFlowNode()
  }

  /**
   * Gets the kind of this property, which is an opaque integer
   * value indicating whether this property is a value property,
   * a property getter, or a property setter.
   */
  int getKind() { properties(this, _, _, result, _) }

  /**
   * Gets the `i`th decorator applied to this property.
   *
   * For example, the property `@A @B x: 42` has
   * `@A` as its 0th decorator, and `@B` as its first decorator.
   */
  Decorator getDecorator(int i) { result = getChildExpr(-(i + 1)) }

  /**
   * Gets a decorator applied to this property.
   *
   * For example, the property `@A @B x: 42` has
   * decorators `@A` and `@B`.
   */
  Decorator getADecorator() { result = getDecorator(_) }

  override string getAPrimaryQlClass() { result = "Property" }
}

/**
 * A value property definition in an object literal.
 *
 * Examples:
 *
 * ```
 * var p = {
 *   x: 1,                                                          // value property
 *   y: 1,                                                          // value property
 *   diag: function() { return this.x - this.y; },                  // value property
 * }
 * ```
 */
class ValueProperty extends Property, @value_property { }

/**
 * A property getter or setter in an object literal.
 *
 * Examples:
 *
 * ```
 * var p = {
 *   x: 1,
 *   y: 1,
 *   diag: function() { return this.x - this.y; },
 *   get area() { return this.x * this.y; },                        // property getter
 *   set area(a) { this.x = Math.sqrt(a); this.y = Math.sqrt(a); }  // property setter
 * }
 * ```
 */
class PropertyAccessor extends Property, @property_accessor {
  override FunctionExpr getInit() { result = Property.super.getInit() }
}

/**
 * A property getter in an object literal.
 *
 * Example:
 *
 * ```
 * var p = {
 *   x: 1,
 *   y: 1,
 *   diag: function() { return this.x - this.y; },
 *   get area() { return this.x * this.y; },                        // property getter
 *   set area(a) { this.x = Math.sqrt(a); this.y = Math.sqrt(a); }
 * }
 * ```
 */
class PropertyGetter extends PropertyAccessor, @property_getter { }

/**
 * A property setter in an object literal.
 *
 * Example:
 *
 * ```
 * var p = {
 *   x: 1,
 *   y: 1,
 *   diag: function() { return this.x - this.y; },
 *   get area() { return this.x * this.y; },
 *   set area(a) { this.x = Math.sqrt(a); this.y = Math.sqrt(a); }  // property setter
 * }
 * ```
 */
class PropertySetter extends PropertyAccessor, @property_setter { }

/**
 * A spread property in an object literal.
 *
 * The initializer of a spread property is always
 * a `SpreadElement`.
 *
 * Example:
 *
 * ```
 * var options = {
 *   ...defaultOptions,  // spread property
 *   password: pwd
 * }
 * ```
 */
class SpreadProperty extends Property {
  SpreadProperty() { not exists(getNameExpr()) }
}

/**
 * A (non-arrow) function expression.
 *
 * Examples:
 *
 * ```
 * var greet =
 *   function g() {          // function expression with name `g`
 *     console.log("Hi!");
 *   };
 *
 * class C {
 *   m() {                   // methods are (anonymous) function expressions
 *     return 1;
 *   }
 * }
 * ```
 */
class FunctionExpr extends @function_expr, Expr, Function {
  /** Holds if this function expression is a property setter. */
  predicate isSetter() { exists(PropertySetter s | s.getInit() = this) }

  /** Holds if this function expression is a property getter. */
  predicate isGetter() { exists(PropertyGetter g | g.getInit() = this) }

  /** Holds if this function expression is a property accessor. */
  predicate isAccessor() { exists(PropertyAccessor acc | acc.getInit() = this) }

  /** Gets the statement in which this function expression appears. */
  override Stmt getEnclosingStmt() { result = Expr.super.getEnclosingStmt() }

  override StmtContainer getEnclosingContainer() { result = Expr.super.getContainer() }

  override predicate isImpure() { none() }

  override string getAPrimaryQlClass() { result = "FunctionExpr" }
}

/**
 * An arrow function expression.
 *
 * Examples:
 *
 * ```
 * var greet =
 *   () => console.log("Hi!");  // arrow function expression
 */
class ArrowFunctionExpr extends @arrow_function_expr, Expr, Function {
  /** Gets the statement in which this expression appears. */
  override Stmt getEnclosingStmt() { result = Expr.super.getEnclosingStmt() }

  override StmtContainer getEnclosingContainer() { result = Expr.super.getContainer() }

  override predicate isImpure() { none() }

  override Function getThisBinder() { result = getEnclosingContainer().(Function).getThisBinder() }

  override string getAPrimaryQlClass() { result = "ArrowFunctionExpr" }
}

/**
 * A sequence expression (also known as comma expression).
 *
 * Example:
 *
 * ```
 * x++, y++
 * ```
 */
class SeqExpr extends @seq_expr, Expr {
  /** Gets the `i`th expression in this sequence. */
  Expr getOperand(int i) { result = getChildExpr(i) }

  /** Gets an expression in this sequence. */
  Expr getAnOperand() { result = getOperand(_) }

  /** Gets the number of expressions in this sequence. */
  int getNumOperands() { result = count(getOperand(_)) }

  /** Gets the last expression in this sequence. */
  Expr getLastOperand() { result = getOperand(getNumOperands() - 1) }

  override predicate isImpure() { getAnOperand().isImpure() }

  override Expr getUnderlyingValue() { result = getLastOperand().getUnderlyingValue() }

  override string getAPrimaryQlClass() { result = "SeqExpr" }
}

/**
 * A conditional expression.
 *
 * Example:
 *
 * ```
 * x == 0 ? 0 : 1/x
 * ```
 */
class ConditionalExpr extends @conditional_expr, Expr {
  /** Gets the condition expression of this conditional. */
  Expr getCondition() { result = getChildExpr(0) }

  /** Gets the 'then' expression of this conditional. */
  Expr getConsequent() { result = getChildExpr(1) }

  /** Gets the 'else' expression of this conditional. */
  Expr getAlternate() { result = getChildExpr(2) }

  /** Gets either the 'then' or the 'else' expression of this conditional. */
  Expr getABranch() { result = getConsequent() or result = getAlternate() }

  override predicate isImpure() {
    getCondition().isImpure() or
    getABranch().isImpure()
  }

  override string getAPrimaryQlClass() { result = "ConditionalExpr" }
}

/**
 * An invocation expression, that is, either a function call or
 * a `new` expression.
 *
 * Examples:
 *
 * ```
 * f(1)
 * x.f(1, ...args)
 * f.call(x, 1)
 * new Array(16)
 * ```
 */
class InvokeExpr extends @invokeexpr, Expr {
  /** Gets the expression specifying the function to be called. */
  Expr getCallee() { result = this.getChildExpr(-1) }

  /** Gets the name of the function or method being invoked, if it can be determined. */
  string getCalleeName() {
    exists(Expr callee | callee = getCallee().getUnderlyingValue() |
      result = callee.(Identifier).getName() or
      result = callee.(PropAccess).getPropertyName()
    )
  }

  /** Gets the `i`th argument of this invocation. */
  Expr getArgument(int i) { i >= 0 and result = this.getChildExpr(i) }

  /** Gets an argument of this invocation. */
  Expr getAnArgument() { result = getArgument(_) }

  /** Gets the last argument of this invocation, if any. */
  Expr getLastArgument() { result = getArgument(getNumArgument() - 1) }

  /** Gets the number of arguments of this invocation. */
  int getNumArgument() { result = count(getAnArgument()) }

  /** Gets the `i`th type argument of this invocation. */
  TypeExpr getTypeArgument(int i) { i >= 0 and result = this.getChildTypeExpr(-i - 2) }

  /** Gets a type argument of this invocation. */
  TypeExpr getATypeArgument() { result = getTypeArgument(_) }

  /** Gets the number of type arguments of this invocation. */
  int getNumTypeArgument() { result = count(getATypeArgument()) }

  override ControlFlowNode getFirstControlFlowNode() {
    result = getCallee().getFirstControlFlowNode()
  }

  /** Holds if the argument list of this function has a trailing comma. */
  predicate hasTrailingComma() {
    // check whether the last token of this invocation is a closing
    // parenthesis, which itself is preceded by a comma
    exists(PunctuatorToken rparen | rparen.getValue() = ")" |
      rparen = getLastToken() and
      rparen.getPreviousToken().getValue() = ","
    )
  }

  /**
   * Holds if the `i`th argument of this invocation is a spread element.
   */
  predicate isSpreadArgument(int i) { getArgument(i).stripParens() instanceof SpreadElement }

  /**
   * Holds if the `i`th argument of this invocation is an object literal whose property
   * `name` is set to `value`.
   *
   * This predicate is an approximation, computed using only local data flow.
   */
  predicate hasOptionArgument(int i, string name, Expr value) {
    value = flow().(DataFlow::InvokeNode).getOptionArgument(i, name).asExpr()
  }

  /**
   * Gets the call signature of the invoked function, as determined by the TypeScript
   * type system, with overloading resolved and type parameters substituted.
   *
   * This predicate is only populated for files extracted with full TypeScript extraction.
   */
  CallSignatureType getResolvedSignature() { invoke_expr_signature(this, result) }

  /**
   * Gets the index of the targeted call signature among the overload signatures
   * on the invoked function.
   *
   * This predicate is only populated for files extracted with full TypeScript extraction.
   */
  int getResolvedOverloadIndex() { invoke_expr_overload_index(this, result) }

  /**
   * Gets the canonical name of the static call target, as determined by the TypeScript type system.
   *
   * This predicate is only populated for files extracted with full TypeScript extraction.
   */
  CanonicalFunctionName getResolvedCalleeName() { ast_node_symbol(this, result) }

  /**
   * Gets the statically resolved target function, as determined by the TypeScript type system, if any.
   *
   * This predicate is only populated for files extracted with full TypeScript extraction.
   *
   * Note that the resolved function may be overridden in a subclass and thus is not
   * necessarily the actual target of this invocation at runtime.
   */
  Function getResolvedCallee() { result = getResolvedCalleeName().getImplementation() }
}

/**
 * A `new` expression.
 *
 * Example:
 *
 * ```
 * new Array(16)
 * ```
 */
class NewExpr extends @new_expr, InvokeExpr {
  override string getAPrimaryQlClass() { result = "NewExpr" }
}

/**
 * A function call expression.
 *
 * Examples:
 *
 * ```
 * f()
 * require('express')()
 * x.f()
 * ```
 */
class CallExpr extends @call_expr, InvokeExpr {
  /**
   * Gets the expression specifying the receiver on which the function
   * is invoked, if any.
   */
  Expr getReceiver() { result = getCallee().(PropAccess).getBase() }

  override string getAPrimaryQlClass() { result = "CallExpr" }
}

/**
 * A method call expression.
 *
 * Examples:
 *
 * ```
 * Object.create(null)
 * [1, 2, 3].forEach(alert);
 * ```
 */
class MethodCallExpr extends CallExpr {
  MethodCallExpr() { getCallee().stripParens() instanceof PropAccess }

  /**
   * Gets the property access referencing the method to be invoked.
   */
  private PropAccess getMethodRef() { result = getCallee().stripParens() }

  /**
   * Gets the receiver expression of this method call.
   */
  override Expr getReceiver() { result = getMethodRef().getBase() }

  /**
   * Gets the name of the invoked method, if it can be determined.
   */
  string getMethodName() { result = getMethodRef().getPropertyName() }

  /** Holds if this invocation calls method `m` on expression `base`. */
  predicate calls(Expr base, string m) { getMethodRef().accesses(base, m) }

  override string getAPrimaryQlClass() { result = "MethodCallExpr" }
}

/**
 * A property access, that is, either a dot expression of the form
 * `e.f` or an index expression of the form `e[p]`.
 *
 * Examples:
 *
 * ```
 * Math.PI
 * arguments[i]
 * ```
 */
class PropAccess extends @propaccess, Expr {
  /** Gets the base expression on which the property is accessed. */
  Expr getBase() { result = getChildExpr(0) }

  /**
   * Gets the expression specifying the name of the property being
   * read or written. For dot expressions, this is an identifier; for
   * index expressions it can be an arbitrary expression.
   */
  Expr getPropertyNameExpr() { result = getChildExpr(1) }

  /** Gets the name of the accessed property, if it can be determined. */
  string getPropertyName() { none() }

  /** Gets the qualified name of the accessed property, if it can be determined. */
  string getQualifiedName() {
    exists(string basename |
      basename = getBase().(Identifier).getName() or
      basename = getBase().(PropAccess).getQualifiedName()
    |
      result = basename + "." + getPropertyName()
    )
  }

  /** Holds if this property name accesses property `p` on expression `base`. */
  predicate accesses(Expr base, string p) {
    base = getBase() and
    p = getPropertyName()
  }

  override ControlFlowNode getFirstControlFlowNode() {
    result = getBase().getFirstControlFlowNode()
  }

  override Expr getUnderlyingReference() { result = this }
}

/**
 * A dot expression.
 *
 * Example:
 *
 * ```
 * Math.PI
 * ```
 */
class DotExpr extends @dot_expr, PropAccess {
  override string getPropertyName() { result = getProperty().getName() }

  /** Gets the identifier specifying the name of the accessed property. */
  Identifier getProperty() { result = getChildExpr(1) }

  override predicate isImpure() { getBase().isImpure() }

  override string getAPrimaryQlClass() { result = "DotExpr" }
}

/**
 * An index expression (also known as computed property access).
 *
 * Example:
 *
 * ```
 * arguments[i]
 * ```
 */
class IndexExpr extends @index_expr, PropAccess {
  /** Gets the expression specifying the name of the accessed property. */
  Expr getIndex() { result = getChildExpr(1) }

  override string getPropertyName() { result = getIndex().(Literal).getValue() }

  override predicate isImpure() {
    getBase().isImpure() or
    getIndex().isImpure()
  }

  override string getAPrimaryQlClass() { result = "IndexExpr" }
}

/**
 * An expression with a unary operator.
 *
 * Examples:
 *
 * ```
 * -x
 * !!done
 * ```
 */
class UnaryExpr extends @unaryexpr, Expr {
  /** Gets the operand of this unary operator. */
  Expr getOperand() { result = getChildExpr(0) }

  /** Gets the operator of this expression. */
  string getOperator() { none() }

  override predicate isImpure() { getOperand().isImpure() }

  override ControlFlowNode getFirstControlFlowNode() {
    result = getOperand().getFirstControlFlowNode()
  }

  override string getAPrimaryQlClass() { result = "UnaryExpr" }
}

/**
 * An arithmetic negation expression (also known as unary minus).
 *
 * Example:
 *
 * ```
 * -x
 * ```
 */
class NegExpr extends @neg_expr, UnaryExpr {
  override string getOperator() { result = "-" }

  override int getIntValue() { result = -getOperand().getIntValue() }
}

/**
 * A unary plus expression.
 *
 * Example:
 *
 * ```
 * +x
 * ```
 */
class PlusExpr extends @plus_expr, UnaryExpr {
  override string getOperator() { result = "+" }
}

/**
 * A logical negation expression.
 *
 * Example:
 *
 * ```
 * !done
 * ```
 */
class LogNotExpr extends @log_not_expr, UnaryExpr {
  override string getOperator() { result = "!" }
}

/**
 * A bitwise negation expression.
 *
 * Example:
 *
 * ```
 * ~bitmask
 * ```
 */
class BitNotExpr extends @bit_not_expr, UnaryExpr {
  override string getOperator() { result = "~" }
}

/**
 * A `typeof` expression.
 *
 * Example:
 *
 * ```
 * typeof A.prototype
 * ```
 */
class TypeofExpr extends @typeof_expr, UnaryExpr {
  override string getOperator() { result = "typeof" }
}

/**
 * A `void` expression.
 *
 * Example:
 *
 * ```
 * void(0)
 * ```
 */
class VoidExpr extends @void_expr, UnaryExpr {
  override string getOperator() { result = "void" }
}

/**
 * A `delete` expression.
 *
 * Example:
 *
 * ```
 * delete elt[_expando]
 * ```
 */
class DeleteExpr extends @delete_expr, UnaryExpr {
  override string getOperator() { result = "delete" }

  override predicate isImpure() { any() }
}

/**
 * A spread element.
 *
 * Example:
 *
 * ```
 * [].concat(
 *   ...lists  // a spread element
 * )
 * ```
 */
class SpreadElement extends @spread_element, UnaryExpr {
  override string getOperator() { result = "..." }

  override string getAPrimaryQlClass() { result = "SpreadElement" }
}

/**
 * An expression with a binary operator.
 *
 * Examples:
 *
 * ```
 * x + 1
 * a instanceof Array
 * ```
 */
class BinaryExpr extends @binaryexpr, Expr {
  /** Gets the left operand of this binary operator. */
  Expr getLeftOperand() { result = getChildExpr(0) }

  /** Gets the right operand of this binary operator. */
  Expr getRightOperand() { result = getChildExpr(1) }

  /** Gets an operand of this binary operator. */
  Expr getAnOperand() { result = getAChildExpr() }

  /** Holds if `e` and `f` (in either order) are the two operands of this expression. */
  predicate hasOperands(Expr e, Expr f) {
    e = getAnOperand() and
    f = getAnOperand() and
    e != f
  }

  /** Gets the operator of this expression. */
  string getOperator() { none() }

  override predicate isImpure() { getAnOperand().isImpure() }

  override ControlFlowNode getFirstControlFlowNode() {
    result = getLeftOperand().getFirstControlFlowNode()
  }

  /**
   * Gets the number of whitespace characters around the operator of this expression.
   *
   * This predicate is only defined if both operands are on the same line, and if the
   * amount of whitespace before and after the operator are the same.
   */
  int getWhitespaceAroundOperator() {
    exists(Token lastLeft, Token operator, Token firstRight, int l, int c1, int c2, int c3, int c4 |
      lastLeft = getLeftOperand().getLastToken() and
      operator = lastLeft.getNextToken() and
      firstRight = operator.getNextToken() and
      lastLeft.getLocation().hasLocationInfo(_, _, _, l, c1) and
      operator.getLocation().hasLocationInfo(_, l, c2, l, c3) and
      firstRight.getLocation().hasLocationInfo(_, l, c4, _, _) and
      result = c2 - c1 - 1 and
      result = c4 - c3 - 1
    )
  }

  override string getAPrimaryQlClass() { result = "BinaryExpr" }
}

/**
 * A comparison expression, that is, either an equality test
 * (`==`, `!=`, `===`, `!==`) or a relational expression
 * (`<`, `<=`, `>=`, `>`).
 *
 * Examples:
 *
 * ```
 * x !== y
 * y < 0
 * ```
 */
class Comparison extends @comparison, BinaryExpr { }

/**
 * An equality test using `==`, `!=`, `===` or `!==`.
 *
 * Examples:
 *
 * ```
 * "" == arg
 * x != null
 * recv === undefined
 * res !== res
 * ```
 */
class EqualityTest extends @equality_test, Comparison {
  /** Gets the polarity of this test: `true` for equalities, `false` for inequalities. */
  boolean getPolarity() {
    (this instanceof EqExpr or this instanceof StrictEqExpr) and
    result = true
    or
    (this instanceof NEqExpr or this instanceof StrictNEqExpr) and
    result = false
  }

  /**
   * Holds if the equality operator is strict (`===` or `!==`).
   */
  predicate isStrict() { this instanceof StrictEqExpr or this instanceof StrictNEqExpr }
}

/**
 * An equality test using `==`.
 *
 * Example:
 *
 * ```
 * "" == arg
 * ```
 */
class EqExpr extends @eq_expr, EqualityTest {
  override string getOperator() { result = "==" }
}

/**
 * An inequality test using `!=`.
 *
 * Example:
 *
 * ```
 * x != null
 * ```
 */
class NEqExpr extends @neq_expr, EqualityTest {
  override string getOperator() { result = "!=" }
}

/**
 * A strict equality test using `===`.
 *
 * Example:
 *
 * ```
 * recv === undefined
 * ```
 */
class StrictEqExpr extends @eqq_expr, EqualityTest {
  override string getOperator() { result = "===" }
}

/**
 * A strict inequality test using `!==`.
 *
 * Example:
 *
 * ```
 * res !== res
 * ```
 */
class StrictNEqExpr extends @neqq_expr, EqualityTest {
  override string getOperator() { result = "!==" }
}

/**
 * A less-than expression.
 *
 * Example:
 *
 * ```
 * i < 10
 * ```
 */
class LTExpr extends @lt_expr, Comparison {
  override string getOperator() { result = "<" }
}

/**
 * A less-than-or-equal expression.
 *
 * Example:
 *
 * ```
 * x+1 <= a.length
 * ```
 */
class LEExpr extends @le_expr, Comparison {
  override string getOperator() { result = "<=" }
}

/**
 * A greater-than expression.
 *
 * Example:
 *
 * ```
 * a[j] > a[k]
 * ```
 */
class GTExpr extends @gt_expr, Comparison {
  override string getOperator() { result = ">" }
}

/**
 * A greater-than-or-equal expression.
 *
 * Example:
 *
 * ```
 * x >= 0
 * ```
 */
class GEExpr extends @ge_expr, Comparison {
  override string getOperator() { result = ">=" }
}

/**
 * A left-shift expression using `<<`.
 *
 * Example:
 *
 * ```
 * 2 << i
 * ```
 */
class LShiftExpr extends @lshift_expr, BinaryExpr {
  override string getOperator() { result = "<<" }
}

/**
 * A right-shift expression using `>>`.
 *
 * Example:
 *
 * ```
 * r >> 8
 * ```
 */
class RShiftExpr extends @rshift_expr, BinaryExpr {
  override string getOperator() { result = ">>" }
}

/**
 * An unsigned right-shift expression using `>>>`.
 *
 * Example:
 *
 * ```
 * u >>> v
 * ```
 */
class URShiftExpr extends @urshift_expr, BinaryExpr {
  override string getOperator() { result = ">>>" }
}

/**
 * An addition or string-concatenation expression.
 *
 * Examples:
 *
 * ```
 * a + b
 * msg + "\n"
 * ```
 */
class AddExpr extends @add_expr, BinaryExpr {
  override string getOperator() { result = "+" }
}

/**
 * Gets the string value for the expression `e`.
 * This string-value is either a constant-string, or the result from a simple string-concatenation.
 */
private string getStringValue(Expr e) {
  result = getConstantString(e)
  or
  result = getConcatenatedString(e)
}

/**
 * Gets the constant string value for the expression `e`.
 */
private string getConstantString(Expr e) {
  result = getConstantString(e.getUnderlyingValue())
  or
  result = e.(StringLiteral).getValue()
  or
  exists(TemplateLiteral lit | lit = e |
    // fold singletons
    lit.getNumChildExpr() = 0 and
    result = ""
    or
    e.getNumChildExpr() = 1 and
    result = getConstantString(lit.getElement(0))
  )
  or
  result = e.(TemplateElement).getValue()
}

/**
 * Holds if `add` is a string-concatenation where all the transitive leafs have a constant string value.
 */
private predicate hasAllConstantLeafs(AddExpr add) {
  forex(Expr leaf | leaf = getAnAddOperand*(add) and not exists(getAnAddOperand(leaf)) |
    exists(getConstantString(leaf))
  )
}

/**
 * Gets the concatenated string for a string-concatenation `add`.
 * Only has a result if `add` is not itself an operand in another string-concatenation with all constant leafs.
 */
private string getConcatenatedString(Expr add) {
  result = getConcatenatedString(add.getUnderlyingValue())
  or
  result =
    strictconcat(Expr leaf |
      leaf = getAnAddOperand*(add.(SmallConcatRoot))
    |
      getConstantString(leaf)
      order by
        leaf.getLocation().getStartLine(), leaf.getLocation().getStartColumn()
    )
}

/**
 * An expr that is the root of a string concatenation of constant parts,
 * and the length of the resulting concatenation is less than 1 million chars.
 */
private class SmallConcatRoot extends Expr {
  SmallConcatRoot() {
    not this = getAnAddOperand(any(AddExpr parent | hasAllConstantLeafs(parent))) and
    hasAllConstantLeafs(this) and
    sum(Expr leaf | leaf = getAnAddOperand*(this) | getConstantString(leaf).length()) < 1000 * 1000
  }
}

/**
 * Gets an operand from `add`.
 * Is specialized to `AddExpr` such that `getAnAddOperand*(add)` can be used to get a leaf from a string-concatenation transitively.
 */
private Expr getAnAddOperand(AddExpr add) { result = add.getAnOperand().getUnderlyingValue() }

/**
 * A subtraction expression.
 *
 * Example:
 *
 * ```
 * w - len
 * ```
 */
class SubExpr extends @sub_expr, BinaryExpr {
  override string getOperator() { result = "-" }
}

/**
 * A multiplication expression.
 *
 * Example:
 *
 * ```
 * x * y
 * ```
 */
class MulExpr extends @mul_expr, BinaryExpr {
  override string getOperator() { result = "*" }
}

/**
 * A division expression.
 *
 * Example:
 *
 * ```
 * gg / ac
 * ```
 */
class DivExpr extends @div_expr, BinaryExpr {
  override string getOperator() { result = "/" }
}

/**
 * A modulo expression.
 *
 * Example:
 *
 * ```
 * n % 2
 * ```
 */
class ModExpr extends @mod_expr, BinaryExpr {
  override string getOperator() { result = "%" }
}

/**
 * An exponentiation expression.
 *
 * Example:
 *
 * ```
 * p ** 10
 * ```
 */
class ExpExpr extends @exp_expr, BinaryExpr {
  override string getOperator() { result = "**" }
}

/**
 * A bitwise 'or' expression.
 *
 * Example:
 *
 * ```
 * O_RDWR | O_APPEND
 * ```
 */
class BitOrExpr extends @bitor_expr, BinaryExpr {
  override string getOperator() { result = "|" }
}

/**
 * An exclusive 'or' expression.
 *
 * Example:
 *
 * ```
 * x ^ 1
 * ```
 */
class XOrExpr extends @xor_expr, BinaryExpr {
  override string getOperator() { result = "^" }
}

/**
 * A bitwise 'and' expression.
 *
 * Example:
 *
 * ```
 * flags & O_APPEND
 * ```
 */
class BitAndExpr extends @bitand_expr, BinaryExpr {
  override string getOperator() { result = "&" }
}

/**
 * An `in` expression.
 *
 * Example:
 *
 * ```
 * "leftpad" in String.prototype
 * ```
 */
class InExpr extends @in_expr, BinaryExpr {
  override string getOperator() { result = "in" }
}

/**
 * An `instanceof` expression.
 *
 * Example:
 *
 * ```
 * b instanceof Buffer
 * ```
 */
class InstanceofExpr extends @instanceof_expr, BinaryExpr {
  override string getOperator() { result = "instanceof" }
}

/**
 * A logical 'and' expression.
 *
 * Example:
 *
 * ```
 * x != null && x.f
 * ```
 */
class LogAndExpr extends @logand_expr, BinaryExpr {
  override string getOperator() { result = "&&" }

  override ControlFlowNode getFirstControlFlowNode() { result = this }
}

/**
 * A logical 'or' expression.
 *
 * Example:
 *
 * ```
 * x == null || x.f
 * ```
 */
class LogOrExpr extends @logor_expr, BinaryExpr {
  override string getOperator() { result = "||" }

  override ControlFlowNode getFirstControlFlowNode() { result = this }
}

/**
 * A nullish coalescing '??' expression.
 *
 * Example:
 *
 * ```
 * x ?? f
 * ```
 */
class NullishCoalescingExpr extends @nullishcoalescing_expr, BinaryExpr {
  override string getOperator() { result = "??" }

  override ControlFlowNode getFirstControlFlowNode() { result = this }
}

/**
 * A short-circuiting logical binary expression, that is, a logical 'or' expression,
 * a logical 'and' expression, or a nullish-coalescing expression.
 *
 * Examples:
 *
 * ```
 * x && x.f
 * !x || x.f
 * x ?? f
 * ```
 */
class LogicalBinaryExpr extends BinaryExpr {
  LogicalBinaryExpr() {
    this instanceof LogAndExpr or
    this instanceof LogOrExpr or
    this instanceof NullishCoalescingExpr
  }
}

/**
 * A bitwise binary expression, that is, either a bitwise
 * 'and', a bitwise 'or', or an exclusive 'or' expression.
 *
 * Examples:
 *
 * ```
 * qw & 0xffff
 * O_RDWR | O_APPEND
 * x ^ 1
 * ```
 */
class BitwiseBinaryExpr extends BinaryExpr {
  BitwiseBinaryExpr() {
    this instanceof BitAndExpr or
    this instanceof BitOrExpr or
    this instanceof XOrExpr
  }
}

/**
 * A shift expression.
 *
 * Examples:
 *
 * ```
 * 2 << i
 * r >> 8
 * u >>> v
 * ```
 */
class ShiftExpr extends BinaryExpr {
  ShiftExpr() {
    this instanceof LShiftExpr or
    this instanceof RShiftExpr or
    this instanceof URShiftExpr
  }
}

/**
 * An assignment expression, either compound or simple.
 *
 * Examples:
 *
 * ```
 * x = y
 * sum += element
 * ```
 */
class Assignment extends @assignment, Expr {
  /** Gets the left hand side of this assignment. */
  Expr getLhs() { result = getChildExpr(0) }

  /** Gets the right hand side of this assignment. */
  Expr getRhs() { result = getChildExpr(1) }

  /** Gets the variable or property this assignment writes to, if any. */
  Expr getTarget() { result = getLhs().stripParens() }

  override ControlFlowNode getFirstControlFlowNode() { result = getLhs().getFirstControlFlowNode() }
}

/**
 * A simple assignment expression.
 *
 * Example:
 *
 * ```
 * x = y
 * ```
 */
class AssignExpr extends @assign_expr, Assignment {
  override Expr getUnderlyingValue() { result = getRhs().getUnderlyingValue() }

  override string getAPrimaryQlClass() { result = "AssignExpr" }
}

private class TCompoundAssignExpr =
  @assign_add_expr or @assign_sub_expr or @assign_mul_expr or @assign_div_expr or
      @assign_mod_expr or @assign_exp_expr or @assign_lshift_expr or @assign_rshift_expr or
      @assign_urshift_expr or @assign_or_expr or @assign_xor_expr or @assign_and_expr or
      @assignlogandexpr or @assignlogorexpr or @assignnullishcoalescingexpr;

/**
 * A compound assign expression.
 *
 * Examples:
 *
 * ```
 * sum += element
 * x /= 2
 * ```
 */
class CompoundAssignExpr extends TCompoundAssignExpr, Assignment {
  override string getAPrimaryQlClass() { result = "CompoundAssignExpr" }
}

/**
 * A compound add-assign expression.
 *
 * Example:
 *
 * ```
 * sum += element
 * ```
 */
class AssignAddExpr extends @assign_add_expr, CompoundAssignExpr { }

/**
 * A compound subtract-assign expression.
 *
 * Example:
 *
 * ```
 * i -= 2
 * ```
 */
class AssignSubExpr extends @assign_sub_expr, CompoundAssignExpr { }

/**
 * A compound multiply-assign expression.
 *
 * Example:
 *
 * ```
 * x *= y
 * ```
 */
class AssignMulExpr extends @assign_mul_expr, CompoundAssignExpr { }

/**
 * A compound divide-assign expression.
 *
 * Example:
 *
 * ```
 * n /= 10
 * ```
 */
class AssignDivExpr extends @assign_div_expr, CompoundAssignExpr { }

/**
 * A compound modulo-assign expression.
 *
 * Example:
 *
 * ```
 * m %= 3
 * ```
 */
class AssignModExpr extends @assign_mod_expr, CompoundAssignExpr { }

/**
 * A compound exponentiate-assign expression.
 *
 * Example:
 *
 * ```
 * scale **= 10
 * ```
 */
class AssignExpExpr extends @assign_exp_expr, CompoundAssignExpr { }

/**
 * A compound left-shift-assign expression.
 *
 * Example:
 *
 * ```
 * exp <<= 2
 * ```
 */
class AssignLShiftExpr extends @assign_lshift_expr, CompoundAssignExpr { }

/**
 * A compound right-shift-assign expression.
 *
 * Example:
 *
 * ```
 * qw >>= 8
 * ```
 */
class AssignRShiftExpr extends @assign_rshift_expr, CompoundAssignExpr { }

/**
 * A compound unsigned-right-shift-assign expression.
 *
 * Example:
 *
 * ```
 * bits >>>= 16
 * ```
 */
class AssignURShiftExpr extends @assign_urshift_expr, CompoundAssignExpr { }

/**
 * A compound bitwise-'or'-assign expression.
 *
 * Example:
 *
 * ```
 * flags |= O_CREAT
 * ```
 */
class AssignOrExpr extends @assign_or_expr, CompoundAssignExpr { }

/**
 * A compound exclusive-'or'-assign expression.
 *
 * Example:
 *
 * ```
 * bits ^= mask
 * ```
 */
class AssignXOrExpr extends @assign_xor_expr, CompoundAssignExpr { }

/**
 * A compound bitwise-'and'-assign expression.
 *
 * Example:
 *
 * ```
 * data &= 0xffff
 * ```
 */
class AssignAndExpr extends @assign_and_expr, CompoundAssignExpr { }

/**
 * A logical-'or'-assign expression.
 *
 * Example:
 *
 * ```
 * x ||= y
 * ```
 */
class AssignLogOrExpr extends @assignlogorexpr, CompoundAssignExpr { }

/**
 * A logical-'and'-assign expression.
 *
 * Example:
 *
 * ```
 * x &&= y
 * ```
 */
class AssignLogAndExpr extends @assignlogandexpr, CompoundAssignExpr { }

/**
 * A 'nullish-coalescing'-assign expression.
 *
 * Example:
 *
 * ```
 * x ??= y
 * ```
 */
class AssignNullishCoalescingExpr extends @assignnullishcoalescingexpr, CompoundAssignExpr { }

/**
 * An update expression, that is, an increment or decrement expression.
 *
 * Examples:
 *
 * ```
 * ++i
 * --i
 * i++
 * i--
 * ```
 */
class UpdateExpr extends @updateexpr, Expr {
  /** Gets the operand of this update. */
  Expr getOperand() { result = getChildExpr(0) }

  /** Holds if this is a prefix increment or prefix decrement expression. */
  predicate isPrefix() { none() }

  /** Gets the operator of this update expression. */
  string getOperator() { none() }

  override ControlFlowNode getFirstControlFlowNode() {
    result = getOperand().getFirstControlFlowNode()
  }

  override string getAPrimaryQlClass() { result = "UpdateExpr" }
}

/**
 * A prefix increment expression.
 *
 * Example:
 *
 * ```
 * ++i
 * ```
 */
class PreIncExpr extends @preinc_expr, UpdateExpr {
  override predicate isPrefix() { any() }

  override string getOperator() { result = "++" }
}

/**
 * A postfix increment expression.
 *
 * Example:
 *
 * ```
 * i++
 * ```
 */
class PostIncExpr extends @postinc_expr, UpdateExpr {
  override string getOperator() { result = "++" }
}

/**
 * A prefix decrement expression.
 *
 * Example:
 *
 * ```
 * --i
 * ```
 */
class PreDecExpr extends @predec_expr, UpdateExpr {
  override predicate isPrefix() { any() }

  override string getOperator() { result = "--" }
}

/**
 * A postfix decrement expression.
 *
 * Example:
 *
 * ```
 * i--
 * ```
 */
class PostDecExpr extends @postdec_expr, UpdateExpr {
  override string getOperator() { result = "--" }
}

/**
 * A `yield` expression.
 *
 * Example:
 *
 * ```
 * yield next
 * ```
 */
class YieldExpr extends @yield_expr, Expr {
  /** Gets the operand of this `yield` expression. */
  Expr getOperand() { result = getChildExpr(0) }

  /** Holds if this is a `yield*` expression. */
  predicate isDelegating() { is_delegating(this) }

  override predicate isImpure() { any() }

  override ControlFlowNode getFirstControlFlowNode() {
    result = getOperand().getFirstControlFlowNode()
    or
    not exists(getOperand()) and result = this
  }

  override string getAPrimaryQlClass() { result = "YieldExpr" }
}

/**
 * A comprehension expression, that is, either an array comprehension
 * expression or a generator expression.
 *
 * Examples:
 *
 * ```
 * [for (x of xs) x*x]
 * (for (x of xs) x*x)
 * ```
 */
class ComprehensionExpr extends @comprehension_expr, Expr {
  /** Gets the `n`th comprehension block in this comprehension. */
  ComprehensionBlock getBlock(int n) {
    exists(int idx |
      result = getChildExpr(idx) and
      idx > 0 and
      n = idx - 1
    )
  }

  /** Gets a comprehension block in this comprehension. */
  ComprehensionBlock getABlock() { result = getBlock(_) }

  /** Gets the number of comprehension blocks in this comprehension. */
  int getNumBlock() { result = count(getABlock()) }

  /** Gets the `n`th filter expression in this comprehension. */
  Expr getFilter(int n) {
    exists(int idx |
      result = getChildExpr(idx) and
      idx < 0 and
      n = -idx - 1
    )
  }

  /** Gets a filter expression in this comprehension. */
  Expr getAFilter() { result = getFilter(_) }

  /** Gets the number of filter expressions in this comprehension. */
  int getNumFilter() { result = count(getAFilter()) }

  /** Gets the body expression of this comprehension. */
  Expr getBody() { result = getChildExpr(0) }

  override predicate isImpure() {
    getABlock().isImpure() or
    getAFilter().isImpure() or
    getBody().isImpure()
  }

  /** Holds if this is a legacy postfix comprehension expression. */
  predicate isPostfix() {
    exists(Token tk | tk = getFirstToken().getNextToken() | not tk.getValue().regexpMatch("if|for"))
  }

  override string getAPrimaryQlClass() { result = "ComprehensionExpr" }
}

/**
 * An array comprehension expression.
 *
 * Example:
 *
 * ```
 * [for (x of xs) x*x]
 * ```
 */
class ArrayComprehensionExpr extends @array_comprehension_expr, ComprehensionExpr { }

/**
 * A generator expression.
 *
 * Example:
 *
 * ```
 * (for (x of xs) x*x)
 * ```
 */
class GeneratorExpr extends @generator_expr, ComprehensionExpr { }

/**
 * A comprehension block in a comprehension expression.
 *
 * Examples:
 *
 * ```
 * [
 *   for (x of [1, 2 3])    // comprehension block
 *     x*x
 * ]
 *
 * [
 *   for (x in o)           // comprehension block
 *     "_" + x
 * ]
 * ```
 */
class ComprehensionBlock extends @comprehension_block, Expr {
  /** Gets the iterating variable or pattern of this comprehension block. */
  BindingPattern getIterator() { result = getChildExpr(0) }

  /** Gets the domain over which this comprehension block iterates. */
  Expr getDomain() { result = getChildExpr(1) }

  override predicate isImpure() {
    getIterator().isImpure() or
    getDomain().isImpure()
  }

  override string getAPrimaryQlClass() { result = "ComprehensionBlock" }
}

/**
 * A `for`-`in` comprehension block in a comprehension expression.
 *
 * Example:
 *
 * ```
 * [
 *   for (x in o)           // comprehension block
 *     "_" + x
 * ]
 * ```
 */
class ForInComprehensionBlock extends @for_in_comprehension_block, ComprehensionBlock { }

/**
 * A `for`-`of` comprehension block in a comprehension expression.
 *
 * Example:
 *
 * ```
 * [
 *   for (x of [1, 2 3])    // comprehension block
 *     x*x
 * ]
 * ```
 */
class ForOfComprehensionBlock extends @for_of_comprehension_block, ComprehensionBlock { }

/**
 * A binary arithmetic expression using `+`, `-`, `/`, `%` or `**`.
 *
 * Examples:
 *
 * ```
 * x + y
 * i - 1
 * dist / scale
 * k % 2
 * p ** 10
 * ```
 */
class ArithmeticExpr extends BinaryExpr {
  ArithmeticExpr() {
    this instanceof AddExpr or
    this instanceof SubExpr or
    this instanceof MulExpr or
    this instanceof DivExpr or
    this instanceof ModExpr or
    this instanceof ExpExpr
  }
}

/**
 * A logical expression using `&&`, `||`, or `!`.
 *
 * Examples:
 *
 * ```
 * x && x.f
 * x == null || x.f
 * !x
 * ```
 */
class LogicalExpr extends Expr {
  LogicalExpr() {
    this instanceof LogicalBinaryExpr or
    this instanceof LogNotExpr
  }
}

/**
 * A bitwise expression using `&`, `|`, `^`, `~`, `<<`, `>>`, or `>>>`.
 *
 * Examples:
 *
 * ```
 * qw & 0xffff
 * O_RDWR | O_APPEND
 * x ^ 1
 * ~bitmask
 * 2 << i
 * r >> 8
 * u >>> v
 * ```
 */
class BitwiseExpr extends Expr {
  BitwiseExpr() {
    this instanceof BitwiseBinaryExpr or
    this instanceof BitNotExpr or
    this instanceof ShiftExpr
  }
}

/**
 * A strict equality test using `!==` or `===`.
 *
 * Examples:
 *
 * ```
 * recv === undefined
 * res !== res
 * ```
 */
class StrictEqualityTest extends EqualityTest {
  StrictEqualityTest() {
    this instanceof StrictEqExpr or
    this instanceof StrictNEqExpr
  }
}

/**
 * A non-strict equality test using `!=` or `==`.
 *
 * Examples:
 *
 * ```
 * "" == arg
 * x != null
 * ```
 */
class NonStrictEqualityTest extends EqualityTest {
  NonStrictEqualityTest() {
    this instanceof EqExpr or
    this instanceof NEqExpr
  }
}

/**
 * A relational comparison using `<`, `<=`, `>=`, or `>`.
 *
 * Examples:
 *
 * ```
 * i < 10
 * x+1 <= a.length
 * x >= 0
 * a[j] > a[k]
 * ```
 */
class RelationalComparison extends Comparison {
  RelationalComparison() {
    this instanceof LTExpr or
    this instanceof LEExpr or
    this instanceof GEExpr or
    this instanceof GTExpr
  }

  /**
   * Gets the lesser operand of this comparison, that is, the left operand for
   * a `<` or `<=` comparison, and the right operand for `>=` or `>`.
   */
  Expr getLesserOperand() {
    (this instanceof LTExpr or this instanceof LEExpr) and
    result = getLeftOperand()
    or
    (this instanceof GTExpr or this instanceof GEExpr) and
    result = getRightOperand()
  }

  /**
   * Gets the greater operand of this comparison, that is, the right operand for
   * a `<` or `<=` comparison, and the left operand for `>=` or `>`.
   */
  Expr getGreaterOperand() { result = getAnOperand() and result != getLesserOperand() }

  /**
   * Holds if this is a comparison with `<=` or `>=`.
   */
  predicate isInclusive() {
    this instanceof LEExpr or
    this instanceof GEExpr
  }
}

/**
 * A (pre or post) increment expression.
 *
 * Examples:
 *
 * ```
 * ++i
 * i++
 * ```
 */
class IncExpr extends UpdateExpr {
  IncExpr() { this instanceof PreIncExpr or this instanceof PostIncExpr }
}

/**
 * A (pre or post) decrement expression.
 *
 * Examples:
 *
 * ```
 * --i
 * i--
 * ```
 */
class DecExpr extends UpdateExpr {
  DecExpr() { this instanceof PreDecExpr or this instanceof PostDecExpr }
}

/**
 * An old-style `let` expression of the form `let(vardecls) expr`.
 *
 * Example:
 *
 * ```
 * let (x = f()) x*x
 * ```
 */
class LegacyLetExpr extends Expr, @legacy_letexpr {
  /** Gets the `i`th declarator in this `let` expression. */
  VariableDeclarator getDecl(int i) { result = getChildExpr(i) and i >= 0 }

  /** Gets a declarator in this declaration expression. */
  VariableDeclarator getADecl() { result = getDecl(_) }

  /** Gets the expression this `let` expression scopes over. */
  Expr getBody() { result = getChildExpr(-1) }

  override string getAPrimaryQlClass() { result = "LegacyLetExpr" }
}

/**
 * An immediately invoked function expression (IIFE).
 *
 * Example:
 *
 * ```
 * (function() { return this; })()
 * ```
 */
class ImmediatelyInvokedFunctionExpr extends Function {
  /** The invocation expression of this IIFE. */
  InvokeExpr invk;
  /**
   * The kind of invocation by which this IIFE is invoked: `"call"`
   * for a direct function call, `"call"` or `"apply"` for a reflective
   * invocation through `call` or `apply`, respectively.
   */
  string kind;

  ImmediatelyInvokedFunctionExpr() {
    // direct call
    this = invk.getCallee().getUnderlyingValue() and kind = "direct"
    or
    // reflective call
    exists(MethodCallExpr mce | mce = invk |
      this = mce.getReceiver().getUnderlyingValue() and
      kind = mce.getMethodName() and
      (kind = "call" or kind = "apply")
    )
  }

  /** Gets the invocation of this IIFE. */
  InvokeExpr getInvocation() { result = invk }

  /**
   * Gets a string describing the way this IIFE is invoked
   * (one of `"direct"`, `"call"` or `"apply"`).
   */
  string getInvocationKind() { result = kind }

  /**
   * Gets the `i`th argument of this IIFE.
   */
  Expr getArgument(int i) { result = invk.getArgument(i) }

  /**
   * Holds if the `i`th argument of this IIFE is a spread element.
   */
  predicate isSpreadArgument(int i) { invk.isSpreadArgument(i) }

  /**
   * Gets the offset of argument positions relative to parameter
   * positions: for direct IIFEs the offset is zero, for IIFEs
   * using `Function.prototype.call` the offset is one, and for
   * IIFEs using `Function.prototype.apply` the offset is not defined.
   */
  int getArgumentOffset() {
    kind = "direct" and result = 0
    or
    kind = "call" and result = 1
  }

  /**
   * Holds if `p` is a parameter of this IIFE and `arg` is
   * the corresponding argument.
   *
   * Note that rest parameters do not have corresponding arguments;
   * conversely, arguments after a spread element do not have a corresponding
   * parameter.
   */
  predicate argumentPassing(Parameter p, Expr arg) {
    exists(int parmIdx, int argIdx |
      p = getParameter(parmIdx) and
      not p.isRestParameter() and
      argIdx = parmIdx + getArgumentOffset() and
      arg = getArgument(argIdx) and
      not isSpreadArgument([0 .. argIdx])
    )
  }
}

/**
 * An `await` expression.
 *
 * Example:
 *
 * ```
 * await p()
 * ```
 */
class AwaitExpr extends @await_expr, Expr {
  /** Gets the operand of this `await` expression. */
  Expr getOperand() { result = getChildExpr(0) }

  override predicate isImpure() { any() }

  override ControlFlowNode getFirstControlFlowNode() {
    result = getOperand().getFirstControlFlowNode()
  }

  override string getAPrimaryQlClass() { result = "AwaitExpr" }
}

/**
 * A `function.sent` expression.
 *
 * Inside a generator function, `function.sent` evaluates to the value passed
 * to the generator by the `next` method that most recently resumed execution
 * of the generator.
 *
 * Example:
 *
 * ```
 * function.sent
 * ```
 */
class FunctionSentExpr extends @function_sent_expr, Expr {
  override predicate isImpure() { none() }

  override string getAPrimaryQlClass() { result = "FunctionSentExpr" }
}

/**
 * A decorator applied to a class, property or member definition.
 *
 *
 * Example:
 *
 * ```
 * @A @testable(true) class C { // `@A` and `@testable(true)` are decorators
 *   @Test test1() {            // `@Test` is a decorator
 *   }
 * }
 * ```
 */
class Decorator extends @decorator, Expr {
  /**
   * Gets the element this decorator is applied to.
   *
   * For example, in the class declaration `@A class C { }`,
   * the element decorator `@A` is applied to is `C`.
   */
  Decoratable getElement() { this = result.getADecorator() }

  /**
   * Gets the expression of this decorator.
   *
   * For example, the decorator `@A` has expression `A`,
   * and `@testable(true)` has expression `testable(true)`.
   */
  Expr getExpression() { result = getChildExpr(0) }

  override ControlFlowNode getFirstControlFlowNode() {
    result = getExpression().getFirstControlFlowNode()
  }

  override string getAPrimaryQlClass() { result = "Decorator" }
}

/**
 * A program element to which decorators can be applied,
 * that is, a class, a property or a member definition.
 *
 * Examples:
 *
 * ```
 * @A @testable(true) class C { // class `C` is decoratable
 *   @Test test1() {            // method `test1` is decoratable
 *   }
 * }
 * ```
 */
class Decoratable extends ASTNode {
  Decoratable() {
    this instanceof ClassDefinition or
    this instanceof Property or
    this instanceof MemberDefinition or
    this instanceof EnumDeclaration or
    this instanceof Parameter
  }

  /**
   * Gets the `i`th decorator applied to this element.
   */
  Decorator getDecorator(int i) {
    result = this.(ClassDefinition).getDecorator(i) or
    result = this.(Property).getDecorator(i) or
    result = this.(MemberDefinition).getDecorator(i) or
    result = this.(EnumDeclaration).getDecorator(i) or
    result = this.(Parameter).getDecorator(i)
  }

  /**
   * Gets a decorator applied to this element, if any.
   */
  Decorator getADecorator() { result = this.getDecorator(_) }
}

/**
 * A function-bind expression.
 *
 * Examples:
 *
 * ```
 * b::f
 * ::b.f
 * ```
 */
class FunctionBindExpr extends @bind_expr, Expr {
  /**
   * Gets the object of this function bind expression; undefined for
   * expressions of the form `::b.f`.
   */
  Expr getObject() { result = getChildExpr(0) }

  /** Gets the callee of this function bind expression. */
  Expr getCallee() { result = getChildExpr(1) }

  override ControlFlowNode getFirstControlFlowNode() {
    result = getObject().getFirstControlFlowNode()
    or
    not exists(getObject()) and result = getCallee().getFirstControlFlowNode()
  }

  override string getAPrimaryQlClass() { result = "FunctionBindExpr" }
}

/**
 * A dynamic import expression.
 *
 * Example:
 *
 * ```
 * import("fs")
 * ```
 */
class DynamicImportExpr extends @dynamic_import, Expr, Import {
  /** Gets the expression specifying the path of the imported module. */
  Expr getSource() { result = getChildExpr(0) }

  override ControlFlowNode getFirstControlFlowNode() {
    result = getSource().getFirstControlFlowNode()
  }

  override PathExpr getImportedPath() { result = getSource() }

  override Module getEnclosingModule() { result = getTopLevel() }

  override DataFlow::Node getImportedModuleNode() { result = DataFlow::valueNode(this) }

  override string getAPrimaryQlClass() { result = "DynamicImportExpr" }
}

/** A literal path expression appearing in a dynamic import. */
private class LiteralDynamicImportPath extends PathExpr, ConstantString {
  LiteralDynamicImportPath() {
    exists(DynamicImportExpr di | this.getParentExpr*() = di.getSource())
  }

  override string getValue() { result = getStringValue() }
}

/**
 * A call or member access that evaluates to `undefined` if its base operand evaluates to
 * `undefined` or `null`.
 *
 * Examples:
 *
 * ```
 * x ?? f
 * ```
 */
class OptionalUse extends Expr, @optionalchainable {
  OptionalUse() { isOptionalChaining(this) }

  override string getAPrimaryQlClass() { result = "OptionalUse" }
}

private class ChainElem extends Expr, @optionalchainable {
  /**
   * Gets the base operand of this chainable element.
   */
  ChainElem getChainBase() {
    result = this.(CallExpr).getCallee() or
    result = this.(PropAccess).getBase()
  }
}

/**
 * INTERNAL: This class should not be used by queries.
 *
 * The root in a chain of calls or property accesses, where at least one call or property access is optional.
 */
class OptionalChainRoot extends ChainElem {
  OptionalUse optionalUse;

  OptionalChainRoot() {
    getChainBase*() = optionalUse and
    not exists(ChainElem other | this = other.getChainBase())
  }

  /**
   * Gets an optional call or property access in the chain of this root.
   */
  OptionalUse getAnOptionalUse() { result = optionalUse }
}

/**
 * An `import.meta` expression.
 *
 * Example:
 * ```js
 * let url = import.meta.url;
 * ```
 */
class ImportMetaExpr extends @import_meta_expr, Expr {
  override predicate isImpure() { none() }

  override string getAPrimaryQlClass() { result = "ImportMetaExpr" }
}
