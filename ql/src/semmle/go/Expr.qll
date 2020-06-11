/**
 * Provides classes for working with expressions.
 */

import go

/**
 * An expression.
 *
 * Examples:
 *
 * ```go
 * x + 1
 * y < 0
 * ```
 */
class Expr extends @expr, ExprParent {
  /**
   * Gets the kind of this expression, which is an integer value representing the expression's
   * node type.
   *
   * Note that the mapping from node types to integer kinds is considered an implementation detail
   * and subject to change without notice.
   */
  int getKind() { exprs(this, result, _, _) }

  /** Gets this expression, with any surrounding parentheses removed. */
  Expr stripParens() { result = this }

  /**
   * Holds if this expression is constant, that is, if its value is determined at
   * compile-time.
   */
  predicate isConst() { constvalues(this, _, _) }

  /**
   * Gets the boolean value this expression evalutes to, if any.
   */
  boolean getBoolValue() {
    this.getType().getUnderlyingType() instanceof BoolType and
    exists(string val | constvalues(this, val, _) |
      val = "true" and result = true
      or
      val = "false" and result = false
    )
  }

  /** Gets the floating-point value this expression evaluates to, if any. */
  float getFloatValue() {
    this.getType().getUnderlyingType() instanceof FloatType and
    exists(string val | constvalues(this, val, _) | result = val.toFloat())
  }

  /**
   * Gets the integer value this expression evaluates to, if any.
   *
   * Note that this does not have a result if the value is too large to fit in a
   * 32-bit signed integer type.
   */
  int getIntValue() {
    this.getType().getUnderlyingType() instanceof IntegerType and
    exists(string val | constvalues(this, val, _) | result = val.toInt())
  }

  /** Gets either `getFloatValue` or `getIntValue`. */
  float getNumericValue() { result = this.getFloatValue() or result = this.getIntValue() }

  /**
   * Holds if the complex value this expression evaluates to has real part `real` and imaginary
   * part `imag`.
   */
  predicate hasComplexValue(float real, float imag) {
    this.getType().getUnderlyingType() instanceof ComplexType and
    exists(string val | constvalues(this, val, _) |
      exists(string cmplxre |
        cmplxre = "^\\((.+) \\+ (.+)i\\)$" and
        real = val.regexpCapture(cmplxre, 1).toFloat() and
        imag = val.regexpCapture(cmplxre, 2).toFloat()
      )
    )
  }

  /** Gets the string value this expression evaluates to, if any. */
  string getStringValue() {
    this.getType().getUnderlyingType() instanceof StringType and
    constvalues(this, result, _)
  }

  /**
   * Gets the string representation of the exact value this expression
   * evaluates to, if any.
   *
   * For example, for the constant 3.141592653589793238462, this will
   * result in 1570796326794896619231/500000000000000000000
   */
  string getExactValue() { constvalues(this, _, result) }

  /**
   * Holds if this expression has a constant value which is guaranteed not to depend on the
   * platform where it is evaluated.
   *
   * This is a conservative approximation, that is, the predicate may fail to hold for expressions
   * whose value is platform independent, but it will never hold for expressions whose value is not
   * platform independent.
   *
   * Examples of platform-dependent constants include constants declared in files with build
   * constraints, the value of `runtime.GOOS`, and the return value of `unsafe.Sizeof`.
   */
  predicate isPlatformIndependentConstant() { none() }

  /** Gets the type of this expression. */
  Type getType() {
    type_of(this, result)
    or
    not type_of(this, _) and
    result instanceof InvalidType
  }

  /**
   * Gets the global value number of this expression.
   *
   * Expressions with the same global value number are guaranteed to have the same value at runtime.
   * The converse does not hold in general, that is, expressions with different global value numbers
   * may still have the same value at runtime.
   */
  GVN getGlobalValueNumber() { result = globalValueNumber(DataFlow::exprNode(this)) }

  /**
   * Holds if this expression may have observable side effects of its own (that is, independent
   * of whether its sub-expressions may have side effects).
   *
   * Memory allocation is not considered an observable side effect.
   */
  predicate mayHaveOwnSideEffects() { none() }

  /**
   * Holds if the evaluation of this expression may produce observable side effects.
   *
   * Memory allocation is not considered an observable side effect.
   */
  predicate mayHaveSideEffects() { mayHaveOwnSideEffects() or getAChildExpr().mayHaveSideEffects() }

  override string toString() { result = "expression" }
}

/**
 * A bad expression, that is, an expression that could not be parsed.
 *
 * Examples:
 *
 * ```go
 * x +
 * y <
 * ```
 */
class BadExpr extends @badexpr, Expr {
  override string toString() { result = "bad expression" }
}

/**
 * An identifier.
 *
 * Examples:
 *
 * ```go
 * x
 * ```
 */
class Ident extends @ident, Expr {
  /** Gets the name of this identifier. */
  string getName() { literals(this, result, _) }

  /** Holds if this identifier is a use of `e`. */
  predicate uses(Entity e) { uses(this, e) }

  /** Holds if this identifier is a definition or declaration of `e` */
  predicate declares(Entity e) { defs(this, e) }

  /** Holds if this identifier refers to (that is, uses, defines or declares) `e`. */
  predicate refersTo(Entity e) { uses(e) or declares(e) }

  override string toString() { result = getName() }
}

/**
 * The blank identifier `_`.
 *
 * Examples:
 *
 * ```go
 * _
 * ```
 */
class BlankIdent extends Ident {
  BlankIdent() { getName() = "_" }
}

/**
 * An ellipsis expression, representing either the `...` type in a parameter list or
 * the `...` length in an array type.
 *
 * Examples:
 *
 * ```go
 * ...
 * ```
 */
class Ellipsis extends @ellipsis, Expr {
  /** Gets the operand of this ellipsis expression. */
  Expr getOperand() { result = getChildExpr(0) }

  override string toString() { result = "..." }
}

/**
 * A literal expression.
 *
 * Examples:
 *
 * ```go
 * "hello"
 * func(x, y int) int { return x + y }
 * map[string]int{"A": 1, "B": 2}
 * ```
 */
class Literal extends Expr {
  Literal() {
    this instanceof @basiclit or this instanceof @funclit or this instanceof @compositelit
  }
}

/**
 * A literal expression of basic type.
 *
 * Examples:
 *
 * ```go
 * 1
 * "hello"
 * ```
 */
class BasicLit extends @basiclit, Literal {
  /** Gets the value of this literal expressed as a string. */
  string getValue() { literals(this, result, _) }

  /** Gets the raw program text corresponding to this literal. */
  string getText() { literals(this, _, result) }

  override predicate isConst() {
    // override to make sure literals are always considered constants even if we did not get
    // information about constant values from the extractor (for example due to missing
    // type information)
    any()
  }

  override predicate isPlatformIndependentConstant() { any() }

  override string toString() { result = getText() }
}

/**
 * An integer literal.
 *
 * Examples:
 *
 * ```go
 * 256
 * ```
 */
class IntLit extends @intlit, BasicLit { }

/**
 * A floating-point literal.
 *
 * Examples:
 *
 * ```go
 * 2.71828
 * ```
 */
class FloatLit extends @floatlit, BasicLit { }

/**
 * An imaginary literal.
 *
 * Examples:
 *
 * ```go
 * 2i
 * 2.7i
 * ```
 */
class ImagLit extends @imaglit, BasicLit { }

/**
 * A rune literal.
 *
 * Examples:
 *
 * ```go
 * 'a'
 * 'ä'
 * '本'
 * '\377'
 * '\xff'
 * '\u12e4'
 * '\U00101234'
 * '\n'
 * ```
 */
class CharLit extends @charlit, BasicLit {
  // use the constant value of the literal as the string value, as the value we get from the
  // compiler is an integer, meaning we would not otherwise have a string value for rune literals
  override string getStringValue() { result = this.getValue() }
}

class RuneLit = CharLit;

/**
 * A string literal.
 *
 * Examples:
 *
 * ```go
 * "hello world"
 * ```
 */
class StringLit extends @stringlit, BasicLit { }

/**
 * A function literal.
 *
 * Examples:
 *
 * ```go
 * func(x, y int) int { return x + y }
 * ```
 */
class FuncLit extends @funclit, Literal, StmtParent, FuncDef {
  override FuncTypeExpr getTypeExpr() { result = getChildExpr(0) }

  override SignatureType getType() { result = Literal.super.getType() }

  /** Gets the body of this function literal. */
  override BlockStmt getBody() { result = getChildStmt(1) }

  override predicate isPlatformIndependentConstant() { any() }

  override string toString() { result = "function literal" }
}

/**
 * A composite literal
 *
 * Examples:
 *
 * ```go
 * Point3D{0.5, -0.5, 0.5}
 * map[string]int{"A": 1, "B": 2}
 * ```
 */
class CompositeLit extends @compositelit, Literal {
  /** Gets the expression representing the type of this composite literal. */
  Expr getTypeExpr() { result = getChildExpr(0) }

  /** Gets the `i`th element of this composite literal (0-based). */
  Expr getElement(int i) {
    i >= 0 and
    result = getChildExpr(i + 1)
  }

  /** Gets an element of this composite literal. */
  Expr getAnElement() { result = getElement(_) }

  /** Gets the number of elements in this composite literal. */
  int getNumElement() { result = count(getAnElement()) }

  /**
   * Gets the `i`th key expression in this literal.
   *
   * If the `i`th element of this literal has no key, this predicate is undefined for `i`.
   */
  Expr getKey(int i) { result = getElement(i).(KeyValueExpr).getKey() }

  /**
   * Gets the `i`th value expression in this literal.
   */
  Expr getValue(int i) {
    exists(Expr elt | elt = getElement(i) |
      result = elt.(KeyValueExpr).getValue()
      or
      not elt instanceof KeyValueExpr and result = elt
    )
  }

  override string toString() { result = "composite literal" }
}

/**
 * A map literal.
 *
 * Examples:
 *
 * ```go
 * map[string]int{"A": 1, "B": 2}
 * ```
 */
class MapLit extends CompositeLit {
  MapType mt;

  MapLit() { mt = getType().getUnderlyingType() }

  /** Gets the key type of this literal. */
  Type getKeyType() { result = mt.getKeyType() }

  /** Gets the value type of this literal. */
  Type getValueType() { result = mt.getValueType() }
}

/**
 * A struct literal.
 *
 * Examples:
 *
 * ```go
 * Point3D{0.5, -0.5, 0.5}
 * Point3D{y: 1}
 * Point3D{}
 * ```
 */
class StructLit extends CompositeLit {
  StructType st;

  StructLit() { st = getType().getUnderlyingType() }

  /** Gets the struct type underlying this literal. */
  StructType getStructType() { result = st }
}

/**
 * An array or slice literal.
 *
 * Examples:
 *
 * ```go
 * [10]string{}
 * [6]int{1, 2, 3, 5}
 * [...]string{"Sat", "Sun"}
 * []int{1, 2, 3, 5}
 * []string{"Sat", "Sun"}
 * ```
 */
class ArrayOrSliceLit extends CompositeLit {
  CompositeType type;

  ArrayOrSliceLit() {
    type = getType().getUnderlyingType() and
    (
      type instanceof ArrayType
      or
      type instanceof SliceType
    )
  }
}

/**
 * An array literal.
 *
 * Examples:
 *
 * ```go
 * [10]string{}
 * [6]int{1, 2, 3, 5}
 * [...]string{"Sat", "Sun"}
 * ```
 */
class ArrayLit extends ArrayOrSliceLit {
  override ArrayType type;

  /** Gets the array type underlying this literal. */
  ArrayType getArrayType() { result = type }

  override string toString() { result = "array literal" }
}

/**
 * A slice literal.
 *
 * Examples:
 *
 * ```go
 * []int{1, 2, 3, 5}
 * []string{"Sat", "Sun"}
 * ```
 */
class SliceLit extends ArrayOrSliceLit {
  override SliceType type;

  /** Gets the slice type underlying this literal. */
  SliceType getSliceType() { result = type }

  override string toString() { result = "slice literal" }
}

/**
 * A parenthesized expression.
 *
 * Examples:
 *
 * ```go
 * (x + y)
 * ```
 */
class ParenExpr extends @parenexpr, Expr {
  /** Gets the expression between parentheses. */
  Expr getExpr() { result = getChildExpr(0) }

  override Expr stripParens() { result = getExpr().stripParens() }

  override predicate isPlatformIndependentConstant() { getExpr().isPlatformIndependentConstant() }

  override string toString() { result = "(...)" }
}

/**
 * A selector expression, that is, a base expression followed by a selector.
 *
 * Examples:
 *
 * ```go
 * x.f
 * ```
 */
class SelectorExpr extends @selectorexpr, Expr {
  /** Gets the base of this selector expression. */
  Expr getBase() { result = getChildExpr(0) }

  /** Gets the selector of this selector expression. */
  Ident getSelector() { result = getChildExpr(1) }

  /** Holds if this selector is a use of `e`. */
  predicate uses(Entity e) { getSelector().uses(e) }

  /** Holds if this selector is a definition of `e` */
  predicate declares(Entity e) { getSelector().declares(e) }

  /** Holds if this selector refers to (that is, uses, defines or declares) `e`. */
  predicate refersTo(Entity e) { getSelector().refersTo(e) }

  override predicate mayHaveOwnSideEffects() { any() }

  override string toString() { result = "selection of " + getSelector() }
}

/**
 * An index expression, that is, a base expression followed by an index.
 *
 * Examples:
 *
 * ```go
 * a[i]
 * ```
 */
class IndexExpr extends @indexexpr, Expr {
  /** Gets the base of this index expression. */
  Expr getBase() { result = getChildExpr(0) }

  /** Gets the index of this index expression. */
  Expr getIndex() { result = getChildExpr(1) }

  override predicate mayHaveOwnSideEffects() { any() }

  override string toString() { result = "index expression" }
}

/**
 * A slice expression, that is, a base expression followed by slice indices.
 *
 * Examples:
 *
 * ```go
 * a[1:3]
 * a[1:3:5]
 * ```
 */
class SliceExpr extends @sliceexpr, Expr {
  /** Gets the base of this slice expression. */
  Expr getBase() { result = getChildExpr(0) }

  /** Gets the lower bound of this slice expression. */
  Expr getLow() { result = getChildExpr(1) }

  /** Gets the upper bound of this slice expression. */
  Expr getHigh() { result = getChildExpr(2) }

  /** Gets the maximum of this slice expression, if any. */
  Expr getMax() { result = getChildExpr(3) }

  override string toString() { result = "slice expression" }
}

/**
 * A type assertion expression.
 *
 * Examples:
 *
 * ```go
 * x.(T)
 * ```
 */
class TypeAssertExpr extends @typeassertexpr, Expr {
  /** Gets the base expression whose type is being asserted. */
  Expr getExpr() { result = getChildExpr(0) }

  /** Gets the expression representing the asserted type. */
  Expr getTypeExpr() { result = getChildExpr(1) }

  override predicate mayHaveOwnSideEffects() { any() }

  override predicate isPlatformIndependentConstant() { getExpr().isPlatformIndependentConstant() }

  override string toString() { result = "type assertion" }
}

/**
 * An expression that syntactically could either be a function call or a type
 * conversion expression.
 *
 * In most cases, the subclasses `CallExpr` and `ConversionExpr` should be used
 * instead.
 *
 * Examples:
 *
 * ```go
 * f(x)
 * g(a, b...)
 * []byte("x")
 * ```
 */
class CallOrConversionExpr extends @callorconversionexpr, Expr { }

/**
 * A type conversion expression.
 *
 * Examples:
 *
 * ```go
 * []byte("x")
 * ```
 */
class ConversionExpr extends CallOrConversionExpr {
  ConversionExpr() { isTypeExprBottomUp(getChildExpr(0)) }

  /** Gets the type expression representing the target type of the conversion. */
  Expr getTypeExpr() { result = getChildExpr(0) }

  /** Gets the operand of the type conversion. */
  Expr getOperand() { result = getChildExpr(1) }

  override predicate isPlatformIndependentConstant() {
    getOperand().isPlatformIndependentConstant()
  }

  override string toString() { result = "type conversion" }
}

/**
 * A function call expression.
 *
 * On snapshots with incomplete type information, type conversions may be misclassified
 * as function call expressions.
 *
 * Examples:
 *
 * ```go
 * f(x)
 * g(a, b...)
 * ```
 */
class CallExpr extends CallOrConversionExpr {
  CallExpr() { exists(Expr callee | callee = getChildExpr(0) | not isTypeExprBottomUp(callee)) }

  /** Gets the expression representing the function being called. */
  Expr getCalleeExpr() { result = getChildExpr(0) }

  /** Gets the `i`th argument expression of this call (0-based). */
  Expr getArgument(int i) {
    i >= 0 and
    result = getChildExpr(i + 1)
  }

  /** Gets an argument expression of this call. */
  Expr getAnArgument() { result = getArgument(_) }

  /** Gets the number of argument expressions of this call. */
  int getNumArgument() { result = count(getAnArgument()) }

  /** Gets the name of the invoked function or method if it can be determined syntactically. */
  string getCalleeName() {
    exists(Expr callee | callee = getCalleeExpr().stripParens() |
      result = callee.(Ident).getName()
      or
      result = callee.(SelectorExpr).getSelector().getName()
    )
  }

  /** Gets the declared target of this call. */
  Function getTarget() { getCalleeExpr() = result.getAReference() }

  override predicate mayHaveOwnSideEffects() {
    getTarget().mayHaveSideEffects() or
    not exists(getTarget())
  }

  override string toString() {
    result = "call to " + getCalleeName()
    or
    not exists(getCalleeName()) and
    result = "function call"
  }
}

/**
 * A star expression.
 *
 * Examples:
 *
 * ```go
 * *x
 * ```
 */
class StarExpr extends @starexpr, Expr {
  /** Gets the base expression of this star expression. */
  Expr getBase() { result = getChildExpr(0) }

  override predicate mayHaveOwnSideEffects() { any() }

  override string toString() { result = "star expression" }
}

/**
 * A key-value pair in a composite literal.
 *
 * Examples:
 *
 * ```go
 * "A": 1
 * ```
 */
class KeyValueExpr extends @keyvalueexpr, Expr {
  /** Gets the key expression of this key-value pair. */
  Expr getKey() { result = getChildExpr(0) }

  /** Gets the value expression of this key-value pair. */
  Expr getValue() { result = getChildExpr(1) }

  /** Gets the composite literal to which this key-value pair belongs. */
  CompositeLit getLiteral() { this = result.getElement(_) }

  override string toString() { result = "key-value pair" }
}

/**
 * An expression representing an array type.
 *
 * Examples:
 *
 * ```go
 * [5]int
 * ```
 */
class ArrayTypeExpr extends @arraytypeexpr, TypeExpr {
  /** Gets the length expression of this array type. */
  Expr getLength() { result = getChildExpr(0) }

  /** Gets the expression representing the element type of this array type. */
  Expr getElement() { result = getChildExpr(1) }

  override string toString() { result = "array type" }
}

/**
 * An expression representing a struct type.
 *
 * Examples:
 *
 * ```go
 * struct {x, y int; z float32}
 * ```
 */
class StructTypeExpr extends @structtypeexpr, TypeExpr {
  /** Gets the `i`th field declared in this struct type expression (0-based). */
  FieldDecl getField(int i) { fields(result, this, i) }

  /** Gets a field declared in this struct type expression. */
  FieldDecl getAField() { result = getField(_) }

  /** Gets the number of fields declared in this struct type expression. */
  int getNumField() { result = count(getAField()) }

  override string toString() { result = "struct type" }
}

/**
 * An expression representing a function type.
 *
 * Examples:
 *
 * ```go
 * func(a, b int, c float32) (float32, bool)
 * ```
 */
class FuncTypeExpr extends @functypeexpr, TypeExpr, ScopeNode {
  /** Gets the `i`th parameter of this function type (0-based). */
  ParameterDecl getParameterDecl(int i) {
    result.getFunctionTypeExpr() = this and
    result.getIndex() = i
  }

  /** Gets a parameter of this function type. */
  ParameterDecl getAParameterDecl() { result = getParameterDecl(_) }

  /** Gets the number of parameters of this function type. */
  int getNumParameter() { result = count(getAParameterDecl()) }

  /** Gets the `i`th result of this function type (0-based). */
  ResultVariableDecl getResultDecl(int i) {
    result.getFunctionTypeExpr() = this and
    result.getIndex() = i
  }

  /** Gets a result of this function type. */
  ResultVariableDecl getAResultDecl() { result = getResultDecl(_) }

  /** Gets the number of results of this function type. */
  int getNumResult() { result = count(getAResultDecl()) }

  /** Gets the result of this function type, if there is only one. */
  ResultVariableDecl getResultDecl() { getNumResult() = 1 and result = getAResultDecl() }

  override string toString() { result = "function type" }
}

/**
 * An expression representing an interface type.
 *
 * Examples:
 *
 * ```go
 * interface { Read(p []byte) (n int, err error); Close() error}
 * ```
 */
class InterfaceTypeExpr extends @interfacetypeexpr, TypeExpr {
  /** Gets the `i`th method specification of this interface type. */
  MethodSpec getMethod(int i) {
    result.getInterfaceTypeExpr() = this and
    result.getIndex() = i
  }

  /** Gets a method of this interface type. */
  MethodSpec getAMethod() { result = getMethod(_) }

  /** Gets the number of methods of this interface type. */
  int getNumMethod() { result = count(getAMethod()) }

  override string toString() { result = "interface type" }
}

/**
 * An expression representing a map type.
 *
 * Examples:
 *
 * ```go
 * map[string]int
 * ```
 */
class MapTypeExpr extends @maptypeexpr, TypeExpr {
  /** Gets the expression representing the key type of this map type. */
  Expr getKeyTypeExpr() { result = getChildExpr(0) }

  /** Gets the key type of this map type. */
  Type getKeyType() { result = getKeyTypeExpr().getType() }

  /** Gets the expression representing the value type of this map type. */
  Expr getValueTypeExpr() { result = getChildExpr(1) }

  /** Gets the value type of this map type. */
  Type getValueType() { result = getValueTypeExpr().getType() }

  override string toString() { result = "map type" }
}

/**
 * An expression with a (unary or binary) operator.
 *
 * Examples:
 *
 * ```go
 * a * b
 * -c
 * ```
 */
class OperatorExpr extends @operatorexpr, Expr {
  /** Gets the operator of this expression. */
  string getOperator() { none() }

  /** Gets an operand of this expression. */
  Expr getAnOperand() { none() }
}

/**
 * An expression with an arithmetic operator like `-` or `/`.
 *
 * Examples:
 *
 * ```go
 * x - y
 * u / v
 * ```
 */
class ArithmeticExpr extends @arithmeticexpr, OperatorExpr { }

/**
 * An expression with a logical operator like `!` or `&&`.
 *
 * Examples:
 *
 * ```go
 * !a
 * b && c
 * ```
 */
class LogicalExpr extends @logicalexpr, OperatorExpr { }

/**
 * An expression with a bitwise operator such as `^` or `|`.
 *
 * Examples:
 *
 * ```go
 * x ^ y
 * a | b
 * ```
 */
class BitwiseExpr extends @bitwiseexpr, OperatorExpr { }

/**
 * An expression with a unary operator.
 *
 * Examples:
 *
 * ```go
 * +7
 * -2.5i
 * !x
 * ```
 */
class UnaryExpr extends @unaryexpr, OperatorExpr {
  /** Gets the operand of this unary expression. */
  Expr getOperand() { result = getChildExpr(0) }

  override Expr getAnOperand() { result = this.getOperand() }

  override predicate isPlatformIndependentConstant() {
    getOperand().isPlatformIndependentConstant()
  }

  override string toString() { result = getOperator() + "..." }
}

/**
 * An expression with a unary arithmetic operator, that is, unary `-` or `+`.
 *
 * Examples:
 *
 * ```go
 * +7
 * -2.5i
 * ```
 */
class ArithmeticUnaryExpr extends @arithmeticunaryexpr, ArithmeticExpr, UnaryExpr { }

/**
 * An expression with a unary logical operator, that is, `!`.
 *
 * Examples:
 *
 * ```go
 * !x
 * ```
 */
class LogicalUnaryExpr extends @logicalunaryexpr, LogicalExpr, UnaryExpr { }

/**
 * An expression with a unary bitwise operator, that is, `^`.
 *
 * Examples:
 *
 * ```go
 * ^x
 * ```
 */
class BitwiseUnaryExpr extends @bitwiseunaryexpr, BitwiseExpr, UnaryExpr { }

/**
 * A unary plus expression using `+`.
 *
 * Examples:
 *
 * ```go
 * +7
 * ```
 */
class PlusExpr extends @plusexpr, ArithmeticUnaryExpr {
  override string getOperator() { result = "+" }
}

/**
 * A unary minus expression using `-`.
 *
 * Examples:
 *
 * ```go
 * -2.5i
 * ```
 */
class MinusExpr extends @minusexpr, ArithmeticUnaryExpr {
  override string getOperator() { result = "-" }
}

/**
 * A unary "not" expression using `!`.
 *
 * Examples:
 *
 * ```go
 * !x
 * ```
 */
class NotExpr extends @notexpr, LogicalUnaryExpr {
  override string getOperator() { result = "!" }
}

/**
 * A unary complement expression using `^`.
 *
 * Examples:
 *
 * ```go
 * ^x
 * ```
 */
class ComplementExpr extends @complementexpr, BitwiseUnaryExpr {
  override string getOperator() { result = "^" }
}

/**
 * A unary pointer-dereference expression.
 *
 * This class exists for compatibility reasons only and should not normally be used directly. Use `StarExpr` instead.
 */
class DerefExpr extends @derefexpr, UnaryExpr {
  override predicate mayHaveOwnSideEffects() { any() }

  override string getOperator() { result = "*" }
}

/**
 * A unary address-of expression using `&`.
 *
 * Examples:
 *
 * ```go
 * &x
 * ```
 */
class AddressExpr extends @addressexpr, UnaryExpr {
  override predicate mayHaveOwnSideEffects() { any() }

  override string getOperator() { result = "&" }
}

/**
 * A unary receive expression using `<-`.
 *
 * Examples:
 *
 * ```go
 * <-chan
 * ```
 */
class RecvExpr extends @arrowexpr, UnaryExpr {
  override predicate mayHaveOwnSideEffects() { any() }

  override string getOperator() { result = "<-" }
}

/**
 * A binary expression.
 *
 * Examples:
 *
 * ```go
 * a * b
 * a || b
 * b != c
 * ```
 */
class BinaryExpr extends @binaryexpr, OperatorExpr {
  /** Gets the left operand of this binary expression. */
  Expr getLeftOperand() { result = getChildExpr(0) }

  /** Gets the right operand of this binary expression. */
  Expr getRightOperand() { result = getChildExpr(1) }

  override Expr getAnOperand() { result = getChildExpr([0 .. 1]) }

  /** Holds if `e` and `f` (in either order) are the two operands of this binary expression. */
  predicate hasOperands(Expr e, Expr f) {
    e = getAnOperand() and
    f = getAnOperand() and
    e != f
  }

  override predicate isPlatformIndependentConstant() {
    getLeftOperand().isPlatformIndependentConstant() and
    getRightOperand().isPlatformIndependentConstant()
  }

  override string toString() { result = "..." + getOperator() + "..." }
}

/**
 * A binary arithmetic expression, that is, `+`, `-`, `*`, `/` or `%`.
 *
 * Examples:
 *
 * ```go
 * a * b
 * ```
 */
class ArithmeticBinaryExpr extends @arithmeticbinaryexpr, ArithmeticExpr, BinaryExpr { }

/**
 * A binary logical expression, that is, `&&` or `||`.
 *
 * Examples:
 *
 * ```go
 * a || b
 * ```
 */
class LogicalBinaryExpr extends @logicalbinaryexpr, LogicalExpr, BinaryExpr { }

/**
 * A binary bitwise expression, that is, `<<`, `>>`, `|`, `^`, `&` or `&^`.
 *
 * Examples:
 *
 * ```go
 * a << i
 * b ^ c
 * ```
 */
class BitwiseBinaryExpr extends @bitwisebinaryexpr, BitwiseExpr, BinaryExpr { }

/**
 * A shift expression, that is, `<<` or `>>`.
 *
 * Examples:
 *
 * ```go
 * a << i
 * ```
 */
class ShiftExpr extends @shiftexpr, BitwiseBinaryExpr { }

/**
 * A comparison expression, that is, `==`, `!=`, `<`, `<=`, `>=` or `>`.
 *
 * Examples:
 *
 * ```go
 * a != b
 * c > d
 * ```
 */
class ComparisonExpr extends @comparison, BinaryExpr { }

/**
 * An equality test, that is, `==` or `!=`.
 *
 * Examples:
 *
 * ```go
 * a != b
 * ```
 */
class EqualityTestExpr extends @equalitytest, ComparisonExpr {
  /** Gets the polarity of this equality test, that is, `true` for `==` and `false` for `!=`. */
  boolean getPolarity() { none() }
}

/**
 * A relational comparison, that is, `<`, `<=`, `>=` or `>`.
 *
 * Examples:
 *
 * ```go
 * c > d
 * ```
 */
class RelationalComparisonExpr extends @relationalcomparison, ComparisonExpr {
  /** Holds if this comparison is strict, that is, it implies inequality. */
  predicate isStrict() { none() }

  /**
   * Gets the greater operand of this comparison, that is, the right operand for
   * a `<` or `<=` comparison, and the left operand for `>=` or `>`.
   */
  Expr getGreaterOperand() { none() }

  /**
   * Gets the lesser operand of this comparison, that is, the left operand for
   * a `<` or `<=` comparison, and the right operand for `>=` or `>`.
   */
  Expr getLesserOperand() { none() }
}

/**
 * A logical-or expression using `||`.
 *
 * Examples:
 *
 * ```go
 * a || b
 * ```
 */
class LorExpr extends @lorexpr, LogicalBinaryExpr {
  override string getOperator() { result = "||" }
}

class LogOrExpr = LorExpr;

/**
 * A logical-and expression using `&&`.
 *
 * Examples:
 *
 * ```go
 * a && b
 * ```
 */
class LandExpr extends @landexpr, LogicalBinaryExpr {
  override string getOperator() { result = "&&" }
}

class LogAndExpr = LandExpr;

/**
 * An equality test using `==`.
 *
 * Examples:
 *
 * ```go
 * a == b
 * ```
 */
class EqlExpr extends @eqlexpr, EqualityTestExpr {
  override string getOperator() { result = "==" }

  override boolean getPolarity() { result = true }
}

class EqExpr = EqlExpr;

/**
 * An inequality test using `!=`.
 *
 * Examples:
 *
 * ```go
 * a != b
 * ```
 */
class NeqExpr extends @neqexpr, EqualityTestExpr {
  override string getOperator() { result = "!=" }

  override boolean getPolarity() { result = false }
}

/**
 * A less-than test using `<`.
 *
 * Examples:
 *
 * ```go
 * a < b
 * ```
 */
class LssExpr extends @lssexpr, RelationalComparisonExpr {
  override string getOperator() { result = "<" }

  override predicate isStrict() { any() }

  override Expr getLesserOperand() { result = getLeftOperand() }

  override Expr getGreaterOperand() { result = getRightOperand() }
}

class LTExpr = LssExpr;

/**
 * A less-than-or-equal test using `<=`.
 *
 * Examples:
 *
 * ```go
 * a <= b
 * ```
 */
class LeqExpr extends @leqexpr, RelationalComparisonExpr {
  override string getOperator() { result = "<=" }

  override Expr getLesserOperand() { result = getLeftOperand() }

  override Expr getGreaterOperand() { result = getRightOperand() }
}

class LEExpr = LeqExpr;

/**
 * A greater-than test using `>`.
 *
 * Examples:
 *
 * ```go
 * a > b
 * ```
 */
class GtrExpr extends @gtrexpr, RelationalComparisonExpr {
  override string getOperator() { result = ">" }

  override predicate isStrict() { any() }

  override Expr getLesserOperand() { result = getRightOperand() }

  override Expr getGreaterOperand() { result = getLeftOperand() }
}

class GTExpr = GtrExpr;

/**
 * A greater-than-or-equal test using `>=`.
 *
 * Examples:
 *
 * ```go
 * a >= b
 * ```
 */
class GeqExpr extends @geqexpr, RelationalComparisonExpr {
  override string getOperator() { result = ">=" }

  override Expr getLesserOperand() { result = getRightOperand() }

  override Expr getGreaterOperand() { result = getLeftOperand() }
}

class GEExpr = GeqExpr;

/**
 * An addition expression using `+`.
 *
 * Examples:
 *
 * ```go
 * a + b
 * ```
 */
class AddExpr extends @addexpr, ArithmeticBinaryExpr {
  override string getOperator() { result = "+" }
}

/**
 * A subtraction expression using `-`.
 *
 * Examples:
 *
 * ```go
 * a - b
 * ```
 */
class SubExpr extends @subexpr, ArithmeticBinaryExpr {
  override string getOperator() { result = "-" }
}

/**
 * A bitwise or expression using `|`.
 *
 * Examples:
 *
 * ```go
 * a | b
 * ```
 */
class OrExpr extends @orexpr, BitwiseBinaryExpr {
  override string getOperator() { result = "|" }
}

class BitOrExpr = OrExpr;

/**
 * An exclusive-or expression using `^`.
 *
 * Examples:
 *
 * ```go
 * a ^ b
 * ```
 */
class XorExpr extends @xorexpr, BitwiseBinaryExpr {
  override string getOperator() { result = "^" }
}

/**
 * A multiplication expression using `*`.
 *
 * Examples:
 *
 * ```go
 * a * b
 * ```
 */
class MulExpr extends @mulexpr, ArithmeticBinaryExpr {
  override string getOperator() { result = "*" }
}

/**
 * A divison or quotient expression using `/`.
 *
 * Examples:
 *
 * ```go
 * a / b
 * ```
 */
class QuoExpr extends @quoexpr, ArithmeticBinaryExpr {
  override predicate mayHaveOwnSideEffects() { any() }

  override string getOperator() { result = "/" }
}

class DivExpr = QuoExpr;

/**
 * A remainder or modulo expression using `%`.
 *
 * Examples:
 *
 * ```go
 * a % b
 * ```
 */
class RemExpr extends @remexpr, ArithmeticBinaryExpr {
  override string getOperator() { result = "%" }
}

class ModExpr = RemExpr;

/**
 * A left-shift expression using `<<`.
 *
 * Examples:
 *
 * ```go
 * a << i
 * ```
 */
class ShlExpr extends @shlexpr, ShiftExpr {
  override string getOperator() { result = "<<" }
}

class LShiftExpr = ShlExpr;

/**
 * A right-shift expression using `>>`.
 *
 * Examples:
 *
 * ```go
 * a >> i
 * ```
 */
class ShrExpr extends @shrexpr, ShiftExpr {
  override string getOperator() { result = ">>" }
}

class RShiftExpr = ShrExpr;

/**
 * A bitwise and-expression using `&`.
 *
 * Examples:
 *
 * ```go
 * a & b
 * ```
 */
class AndExpr extends @andexpr, BitwiseBinaryExpr {
  override string getOperator() { result = "&" }
}

class BitAndExpr = AndExpr;

/**
 * A bitwise and-not expression using `&^`.
 *
 * Examples:
 *
 * ```go
 * a &^ b
 * ```
 */
class AndNotExpr extends @andnotexpr, BitwiseBinaryExpr {
  override string getOperator() { result = "&^" }
}

/**
 * An expression representing a channel type.
 *
 * Examples:
 *
 * ```go
 * chan float64
 * chan<- bool
 * <-chan int
 * ```
 */
class ChanTypeExpr extends @chantypeexpr, TypeExpr {
  /**
   * Gets the expression representing the type of values flowing through the channel.
   */
  Expr getValueTypeExpr() { result = getChildExpr(0) }

  /** Holds if this channel can send data. */
  predicate canSend() { none() }

  /** Holds if this channel can receive data. */
  predicate canReceive() { none() }

  override string toString() { result = "channel type" }
}

/**
 * An expression representing a send-only channel type.
 *
 * Examples:
 *
 * ```go
 * chan<- bool
 * ```
 */
class SendChanTypeExpr extends @sendchantypeexpr, ChanTypeExpr {
  override predicate canSend() { any() }
}

/**
 * An expression representing a receive-only channel type.
 *
 * Examples:
 *
 * ```go
 * <-chan int
 * ```
 */
class RecvChanTypeExpr extends @recvchantypeexpr, ChanTypeExpr {
  override predicate canReceive() { any() }
}

/**
 * An expression representing a duplex channel type that can both send and receive data.
 *
 * Examples:
 *
 * ```go
 * chan float64
 * ```
 */
class SendRecvChanTypeExpr extends @sendrcvchantypeexpr, ChanTypeExpr {
  override predicate canSend() { any() }

  override predicate canReceive() { any() }
}

/**
 * A (possibly qualified) name referring to a package, type, constant, variable, function or label.
 *
 * Examples:
 *
 * ```go
 * Println
 * fmt.Println
 * fmt
 * int
 * T
 * x
 * Outerloop
 * ```
 */
class Name extends Expr {
  Entity target;

  Name() { this.(Ident).refersTo(target) or this.(SelectorExpr).refersTo(target) }

  /** Gets the entity this name refers to. */
  Entity getTarget() { result = target }
}

/**
 * A simple (that is, unqualified) name.
 *
 * Examples:
 *
 * ```go
 * Println
 * ```
 */
class SimpleName extends Name, Ident { }

/**
 * A qualified name.
 *
 * Examples:
 *
 * ```go
 * fmt.Println
 * ```
 */
class QualifiedName extends Name, SelectorExpr { }

/**
 * A name referring to an imported package.
 *
 * Examples:
 *
 * ```go
 * fmt
 * ```
 */
class PackageName extends Name {
  override PackageEntity target;

  /** Gets the package this name refers to. */
  override PackageEntity getTarget() { result = target }
}

/**
 * A name referring to a type.
 *
 * Examples:
 *
 * ```go
 * int
 * T
 * ```
 */
class TypeName extends Name {
  override TypeEntity target;

  /** Gets the type this name refers to. */
  override TypeEntity getTarget() { result = target }
}

/**
 * A name referring to a value, that is, a constant, variable or function.
 *
 * Examples:
 *
 * ```go
 * c
 * f
 * x
 * ```
 */
class ValueName extends Name {
  override ValueEntity target;

  /** Gets the constant, variable or function this name refers to. */
  override ValueEntity getTarget() { result = target }
}

/**
 * A name referring to a constant.
 *
 * Examples:
 *
 * ```go
 * c
 * ```
 */
class ConstantName extends ValueName {
  override Constant target;

  /** Gets the constant this name refers to. */
  override Constant getTarget() { result = target }

  override predicate isPlatformIndependentConstant() {
    target = Builtin::bool(_)
    or
    target = Builtin::iota()
    or
    target = Builtin::nil()
    or
    exists(DeclaredConstant c | c = target |
      not c.getSpec().getFile().hasBuildConstraints() and
      c.getInit().isPlatformIndependentConstant()
    )
  }
}

/**
 * A name referring to a variable.
 *
 * Examples:
 *
 * ```go
 * x
 * ```
 */
class VariableName extends ValueName {
  override Variable target;

  /** Gets the variable this name refers to. */
  override Variable getTarget() { result = target }
}

/**
 * A name referring to a function.
 *
 * Examples:
 *
 * ```go
 * f
 * ```
 */
class FunctionName extends ValueName {
  override Function target;

  /** Gets the function this name refers to. */
  override Function getTarget() { result = target }
}

/**
 * A name referring to a statement label.
 *
 * Examples:
 *
 * ```go
 * Outerloop
 * ```
 */
class LabelName extends Name {
  override Label target;

  /** Gets the label this name refers to. */
  override Label getTarget() { result = target }
}

/**
 * Holds if `e` is a type expression, as determined by a bottom-up syntactic
 * analysis starting with `TypeName`s.
 *
 * On a snapshot with full type information, this predicate covers all type
 * expressions. However, if type information is missing then not all type names
 * may be identified as such, so not all type expressions can be determined by
 * a bottom-up analysis. In such cases, `isTypeExprTopDown` below is useful.
 */
private predicate isTypeExprBottomUp(Expr e) {
  e instanceof TypeName or
  e instanceof @arraytypeexpr or
  e instanceof @structtypeexpr or
  e instanceof @functypeexpr or
  e instanceof @interfacetypeexpr or
  e instanceof @maptypeexpr or
  e instanceof @chantypeexpr or
  isTypeExprBottomUp(e.(ParenExpr).getExpr()) or
  isTypeExprBottomUp(e.(StarExpr).getBase()) or
  isTypeExprBottomUp(e.(Ellipsis).getOperand())
}

/**
 * Holds if `e` must be a type expression because it either occurs in a syntactic
 * position where a type is expected, or it is part of a larger type expression.
 *
 * This predicate is only needed on snapshots for which type information is
 * incomplete. It is an underapproximation; in cases where it is syntactically ambiguous
 * whether an expression refers to a type or a value, we conservatively assume that
 * it may be the latter and so this predicate does not consider the expression to be
 * a type expression.
 */
private predicate isTypeExprTopDown(Expr e) {
  e = any(CompositeLit cl).getTypeExpr()
  or
  e = any(TypeAssertExpr ta).getTypeExpr()
  or
  e = any(ArrayTypeExpr ae).getElement()
  or
  e = any(FieldDecl f).getTypeExpr()
  or
  e = any(ParameterDecl pd).getTypeExpr()
  or
  e = any(ReceiverDecl rd).getTypeExpr()
  or
  e = any(ResultVariableDecl rvd).getTypeExpr()
  or
  e = any(MethodSpec md).getTypeExpr()
  or
  e = any(MapTypeExpr mt).getKeyTypeExpr()
  or
  e = any(MapTypeExpr mt).getValueTypeExpr()
  or
  e = any(ChanTypeExpr ct).getValueTypeExpr()
  or
  e = any(ValueSpec s).getTypeExpr()
  or
  e = any(TypeSpec s).getTypeExpr()
  or
  e = any(TypeSwitchStmt s).getACase().getExpr(_) and
  // special case: `nil` is allowed in a type case but isn't a type
  not e = Builtin::nil().getAReference()
  or
  e = any(SelectorExpr sel | isTypeExprTopDown(sel)).getBase()
  or
  e = any(ParenExpr pe | isTypeExprTopDown(pe)).getExpr()
  or
  e = any(StarExpr se | isTypeExprTopDown(se)).getBase()
  or
  e = any(Ellipsis ell | isTypeExprTopDown(ell)).getOperand()
}

/**
 * An expression referring to a type.
 *
 * Examples:
 *
 * ```go
 * int
 * func
 * ```
 */
class TypeExpr extends Expr {
  TypeExpr() {
    isTypeExprBottomUp(this) or
    isTypeExprTopDown(this)
  }
}

/**
 * An expression referring to a memory location.
 *
 * Examples:
 *
 * ```go
 * a[i]
 * *p
 * ```
 */
class ReferenceExpr extends Expr {
  ReferenceExpr() {
    (this instanceof Ident or this instanceof SelectorExpr) and
    not (this instanceof PackageName or this instanceof TypeName or this instanceof LabelName) and
    not this instanceof TypeExpr and
    not this = any(ImportSpec is).getNameExpr() and
    not this = any(File f).getPackageNameExpr() and
    not this = any(LabeledStmt ls).getLabelExpr() and
    not this = any(BranchStmt bs).getLabelExpr() and
    not this = any(FieldDecl f).getNameExpr(_) and
    not this = any(ParameterDecl pd).getNameExpr(_) and
    not this = any(ReceiverDecl rd).getNameExpr() and
    not this = any(ResultVariableDecl rvd).getNameExpr(_) and
    not this = any(MethodSpec md).getNameExpr() and
    not this = any(StructLit sl).getKey(_)
    or
    this.(ParenExpr).getExpr() instanceof ReferenceExpr
    or
    this.(StarExpr).getBase() instanceof ReferenceExpr
    or
    this instanceof DerefExpr
    or
    this instanceof IndexExpr
  }

  /** Holds if this reference expression occurs in a position where it is being assigned to. */
  predicate isLvalue() {
    this = any(Assignment assgn).getLhs(_)
    or
    this = any(IncDecStmt ids).getOperand()
    or
    exists(RangeStmt rs |
      this = rs.getKey() or
      this = rs.getValue()
    )
    or
    exists(ValueSpec spec, int i | this = spec.getNameExpr(i))
    or
    exists(FuncDecl fd | this = fd.getNameExpr())
  }

  /** Holds if this reference expression occurs in a position where it is evaluated to a value. */
  predicate isRvalue() {
    not this.isLvalue()
    or
    this = any(CompoundAssignStmt cmp).getLhs(_)
    or
    this = any(IncDecStmt ids).getOperand()
  }
}

/**
 * An expression that refers to a value (as opposed to a package, a type or a statement label).
 *
 * Examples:
 *
 * ```go
 * x + y
 * f(x)
 * ```
 */
class ValueExpr extends Expr {
  ValueExpr() {
    this.(ReferenceExpr).isRvalue() or
    this instanceof BasicLit or
    this instanceof FuncLit or
    this instanceof CompositeLit or
    this.(ParenExpr).getExpr() instanceof ValueExpr or
    this instanceof SliceExpr or
    this instanceof TypeAssertExpr or
    this instanceof CallOrConversionExpr or
    this.(StarExpr).getBase() instanceof ValueExpr or
    this instanceof OperatorExpr
  }
}
