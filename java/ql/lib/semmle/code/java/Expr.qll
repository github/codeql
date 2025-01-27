/**
 * Provides classes for working with Java expressions.
 */

import java
private import semmle.code.java.frameworks.android.Compose
private import semmle.code.java.Constants

/** A common super-class that represents all kinds of expressions. */
class Expr extends ExprParent, @expr {
  /*abstract*/ override string toString() { result = "expr" }

  /**
   * Gets the callable in which this expression occurs, if any.
   */
  Callable getEnclosingCallable() { callableEnclosingExpr(this, result) }

  /** Gets the index of this expression as a child of its parent. */
  int getIndex() { exprs(this, _, _, _, result) }

  /** Gets the parent of this expression. */
  ExprParent getParent() { exprs(this, _, _, result, _) }

  /** Holds if this expression is the child of the specified parent at the specified (zero-based) position. */
  predicate isNthChildOf(ExprParent parent, int index) { exprs(this, _, _, parent, index) }

  /** Gets the type of this expression. */
  Type getType() { exprs(this, _, result, _, _) }

  /** Gets the Kotlin type of this expression. */
  KotlinType getKotlinType() { exprsKotlinType(this, result) }

  /** Gets the compilation unit in which this expression occurs. */
  CompilationUnit getCompilationUnit() { result = this.getFile() }

  /**
   * Gets the kind of this expression.
   *
   * Each kind of expression has a unique (integer) identifier.
   * This is an implementation detail that should not normally
   * be referred to by library users, since the kind of an expression
   * is also represented by its QL type.
   *
   * In a few rare situations, referring to the kind of an expression
   * via its unique identifier may be appropriate; for example, when
   * comparing whether two expressions have the same kind (as opposed
   * to checking whether an expression has a particular kind).
   */
  int getKind() { exprs(this, result, _, _, _) }

  /** Gets the statement containing this expression, if any. */
  Stmt getEnclosingStmt() { statementEnclosingExpr(this, result) }

  /**
   * Gets a statement that directly or transitively contains this expression, if any.
   * This is equivalent to `this.getEnclosingStmt().getEnclosingStmt*()`.
   */
  Stmt getAnEnclosingStmt() { result = this.getEnclosingStmt().getEnclosingStmt*() }

  /** Gets a child of this expression. */
  Expr getAChildExpr() { exprs(result, _, _, this, _) }

  /** Gets the basic block in which this expression occurs, if any. */
  BasicBlock getBasicBlock() { result.getANode().asExpr() = this }

  /** Gets the `ControlFlowNode` corresponding to this expression. */
  ControlFlowNode getControlFlowNode() { result.asExpr() = this }

  /** This statement's Halstead ID (used to compute Halstead metrics). */
  string getHalsteadID() { result = this.toString() }

  /**
   * Holds if this expression is a compile-time constant.
   *
   * See JLS v8, section 15.28 (Constant Expressions).
   */
  predicate isCompileTimeConstant() { this instanceof CompileTimeConstantExpr }

  /** Holds if this expression occurs in a static context. */
  predicate isInStaticContext() {
    /*
     * JLS 8.1.3 (Inner Classes and Enclosing Instances)
     * A statement or expression occurs in a static context if and only if the
     * innermost method, constructor, instance initializer, static initializer,
     * field initializer, or explicit constructor invocation statement
     * enclosing the statement or expression is a static method, a static
     * initializer, the variable initializer of a static variable, or an
     * explicit constructor invocation statement.
     */

    this.getEnclosingCallable().isStatic()
    or
    this.getParent+() instanceof ThisConstructorInvocationStmt
    or
    this.getParent+() instanceof SuperConstructorInvocationStmt
    or
    exists(LambdaExpr lam |
      lam.asMethod() = this.getEnclosingCallable() and lam.isInStaticContext()
    )
  }

  /** Holds if this expression is parenthesized. */
  predicate isParenthesized() { isParenthesized(this, _) }

  /**
   * Gets the underlying expression looking through casts and not-nulls, if any.
   * Otherwise just gets this expression.
   */
  Expr getUnderlyingExpr() {
    if this instanceof CastingExpr or this instanceof NotNullExpr
    then
      result = this.(CastingExpr).getExpr().getUnderlyingExpr() or
      result = this.(NotNullExpr).getExpr().getUnderlyingExpr()
    else result = this
  }
}

/**
 * Holds if the specified type is either a primitive type or type `String`.
 *
 * Auxiliary predicate used by `CompileTimeConstantExpr`.
 */
private predicate primitiveOrString(Type t) {
  t instanceof PrimitiveType or
  t instanceof TypeString
}

/**
 * A compile-time constant expression.
 *
 * See JLS v8, section 15.28 (Constant Expressions).
 */
class CompileTimeConstantExpr extends Expr {
  CompileTimeConstantExpr() {
    primitiveOrString(this.getType()) and
    (
      // Literals of primitive type and literals of type `String`.
      this instanceof Literal
      or
      // Casts to primitive types and casts to type `String`.
      this.(CastingExpr).getExpr().isCompileTimeConstant()
      or
      // The unary operators `+`, `-`, `~`, and `!` (but not `++` or `--`).
      this.(PlusExpr).getExpr().isCompileTimeConstant()
      or
      this.(MinusExpr).getExpr().isCompileTimeConstant()
      or
      this.(BitNotExpr).getExpr().isCompileTimeConstant()
      or
      this.(LogNotExpr).getExpr().isCompileTimeConstant()
      or
      // The multiplicative operators `*`, `/`, and `%`,
      // the additive operators `+` and `-`,
      // the shift operators `<<`, `>>`, and `>>>`,
      // the relational operators `<`, `<=`, `>`, and `>=` (but not `instanceof`),
      // the equality operators `==` and `!=`,
      // the bitwise and logical operators `&`, `^`, and `|`,
      // the conditional-and operator `&&` and the conditional-or operator `||`.
      // These are precisely the operators represented by `BinaryExpr`.
      this.(BinaryExpr).getLeftOperand().isCompileTimeConstant() and
      this.(BinaryExpr).getRightOperand().isCompileTimeConstant()
      or
      // The ternary conditional operator ` ? : `.
      exists(ConditionalExpr e | this = e |
        e.getCondition().isCompileTimeConstant() and
        e.getTrueExpr().isCompileTimeConstant() and
        e.getFalseExpr().isCompileTimeConstant()
      )
      or
      // Access to a final variable initialized by a compile-time constant.
      exists(Variable v | this = v.getAnAccess() |
        v.isFinal() and
        v.getInitializer().isCompileTimeConstant()
      )
      or
      this instanceof LiveLiteral
    )
  }

  /**
   * Gets the string value of this expression, where possible.
   */
  pragma[nomagic]
  string getStringValue() {
    result = this.(StringLiteral).getValue()
    or
    result =
      this.(AddExpr).getLeftOperand().(CompileTimeConstantExpr).getStringValue() +
        this.(AddExpr).getRightOperand().(CompileTimeConstantExpr).getStringValue()
    or
    // Ternary conditional, with compile-time constant condition.
    exists(ConditionalExpr ce, boolean condition |
      ce = this and
      condition = ce.getCondition().(CompileTimeConstantExpr).getBooleanValue() and
      result = ce.getBranchExpr(condition).(CompileTimeConstantExpr).getStringValue()
    )
    or
    exists(Variable v | this = v.getAnAccess() |
      result = v.getInitializer().(CompileTimeConstantExpr).getStringValue()
    )
    or
    result = this.(LiveLiteral).getValue().getStringValue()
  }

  /**
   * Gets the boolean value of this expression, where possible.
   */
  pragma[nomagic]
  boolean getBooleanValue() {
    // Literal value.
    result = this.(BooleanLiteral).getBooleanValue()
    or
    result = CalcCompileTimeConstants::calculateBooleanValue(this)
    or
    // Handle binary expressions that have `String` operands and a boolean result.
    exists(BinaryExpr b, string left, string right |
      b = this and
      left = b.getLeftOperand().(CompileTimeConstantExpr).getStringValue() and
      right = b.getRightOperand().(CompileTimeConstantExpr).getStringValue()
    |
      /*
       * JLS 15.28 specifies that compile-time `String` constants are interned. Therefore `==`
       * equality can be interpreted as equality over the constant values, not the references.
       *
       * Kotlin's `==` and `===` operators will return the same result for `String`s, so they
       * can be handled alike:
       */

      (
        b instanceof ValueOrReferenceEqualsExpr and
        if left = right then result = true else result = false
      )
      or
      (
        b instanceof ValueOrReferenceNotEqualsExpr and
        if left != right then result = true else result = false
      )
    )
    or
    // Note: no `getFloatValue()`, so we cannot support binary expressions with float or double operands.
    result = this.(LiveLiteral).getValue().getBooleanValue()
  }

  /**
   * Gets the integer value of this expression, where possible.
   *
   * Note that this does not handle the following cases:
   *
   * - values of type `long`.
   */
  cached
  int getIntValue() {
    exists(IntegralType t | this.getType() = t | t.getName().toLowerCase() != "long") and
    (
      result = this.(IntegerLiteral).getIntValue()
      or
      result = this.(CharacterLiteral).getCodePointValue()
    )
    or
    result = CalcCompileTimeConstants::calculateIntValue(this)
    or
    result = this.(LiveLiteral).getValue().getIntValue()
  }
}

private boolean getBoolValue(Expr e) { result = e.(CompileTimeConstantExpr).getBooleanValue() }

private int getIntValue(Expr e) { result = e.(CompileTimeConstantExpr).getIntValue() }

private module CalcCompileTimeConstants = CalculateConstants<getBoolValue/1, getIntValue/1>;

/** An expression parent is an element that may have an expression as its child. */
class ExprParent extends @exprparent, Top { }

/**
 * An error expression.
 *
 * These may be generated by upgrade or downgrade scripts when databases
 * cannot be fully converted, or generated by the extractor when extracting
 * source code containing errors.
 */
class ErrorExpr extends Expr, @errorexpr {
  override string toString() { result = "<error expr>" }

  override string getAPrimaryQlClass() { result = "ErrorExpr" }
}

/**
 * An array access.
 *
 * For example, `a[i++]` is an array access, where
 * `a` is the accessed array and `i++` is
 * the index expression of the array access.
 */
class ArrayAccess extends Expr, @arrayaccess {
  /** Gets the array that is accessed in this array access. */
  Expr getArray() { result.isNthChildOf(this, 0) }

  /** Gets the index expression of this array access. */
  Expr getIndexExpr() { result.isNthChildOf(this, 1) }

  override string toString() { result = "...[...]" }

  override string getAPrimaryQlClass() { result = "ArrayAccess" }
}

/**
 * An array creation expression.
 *
 * For example, an expression such as `new String[2][3]` or
 * `new String[][] { { "a", "b", "c" } , { "d", "e", "f" } }`.
 *
 * In both examples, `String` is the type name. In the first
 * example, `2` and `3` are the 0th and 1st dimensions,
 * respectively. In the second example,
 * `{ { "a", "b", "c" } , { "d", "e", "f" } }` is the initializer.
 */
class ArrayCreationExpr extends Expr, @arraycreationexpr {
  /** Gets a dimension of this array creation expression. */
  Expr getADimension() { result.getParent() = this and result.getIndex() >= 0 }

  /** Gets the dimension of this array creation expression at the specified (zero-based) position. */
  Expr getDimension(int index) {
    result = this.getADimension() and
    result.getIndex() = index
  }

  /** Gets the initializer of this array creation expression, if any. */
  ArrayInit getInit() { result.isNthChildOf(this, -2) }

  /**
   * Gets the size of the first dimension, if it can be statically determined.
   */
  int getFirstDimensionSize() {
    if exists(this.getInit())
    then result = this.getInit().getSize()
    else result = this.getDimension(0).(CompileTimeConstantExpr).getIntValue()
  }

  /** Gets a printable representation of this expression. */
  override string toString() { result = "new " + this.getType().toString() }

  override string getAPrimaryQlClass() { result = "ArrayCreationExpr" }
}

/**
 * An array initializer consisting of an opening and closing curly bracket and
 * optionally containing expressions (which themselves can be array initializers)
 * representing the elements of the array. For example: `{ 'a', 'b' }`.
 *
 * This expression type matches array initializers representing the values for
 * annotation elements as well, despite the Java Language Specification considering
 * them a separate type, `ElementValueArrayInitializer`. It does however not match
 * values for an array annotation element which consist of a single element
 * without enclosing curly brackets (as per JLS).
 */
class ArrayInit extends Expr, @arrayinit {
  /**
   * An expression occurring in this initializer.
   * This may either be an initializer itself or an
   * expression representing an element of the array,
   * depending on the level of nesting.
   */
  Expr getAnInit() { result.getParent() = this }

  /** Gets the initializer occurring at the specified (zero-based) position. */
  Expr getInit(int index) { result = this.getAnInit() and result.getIndex() = index }

  /**
   * Gets the number of expressions in this initializer, that is, the size the
   * created array will have.
   */
  int getSize() { result = count(this.getAnInit()) }

  /** Gets a printable representation of this expression. */
  override string toString() { result = "{...}" }

  override string getAPrimaryQlClass() { result = "ArrayInit" }
}

/**
 * A common super-class that represents many varieties of assignments.
 *
 * This does not cover unary assignments such as `i++`, and initialization of
 * local variables at their declaration such as `int i = 0;`.
 *
 * To cover more cases of variable updates, see the classes `VariableAssign`,
 * `VariableUpdate` and `VarWrite`. But consider that they don't cover array
 * element assignments since there the assignment destination is not directly
 * the array variable but instead an `ArrayAccess`.
 */
class Assignment extends Expr, @assignment {
  /** Gets the destination (left-hand side) of the assignment. */
  Expr getDest() { result.isNthChildOf(this, 0) }

  /**
   * Gets the source (right-hand side) of the assignment.
   *
   * For assignments with an implicit operator such as `x += 23`,
   * the left-hand side is also a source.
   */
  Expr getSource() { result.isNthChildOf(this, 1) }

  /** Gets the right-hand side of the assignment. */
  Expr getRhs() { result.isNthChildOf(this, 1) }

  /** Gets a printable representation of this expression. */
  override string toString() { result = "...=..." }
}

/**
 * A simple assignment expression using the `=` operator.
 *
 * For example, `x = 23`.
 */
class AssignExpr extends Assignment, @assignexpr {
  override string getAPrimaryQlClass() { result = "AssignExpr" }
}

/**
 * A Kotlin class member initializer assignment.
 *
 * For example, `class X { val y = 1 }`
 */
class KtInitializerAssignExpr extends AssignExpr {
  KtInitializerAssignExpr() { ktInitializerAssignment(this) }

  override string getAPrimaryQlClass() { result = "KtInitializerAssignExpr" }
}

/**
 * A common super-class to represent compound assignments, which include an implicit operator.
 *
 * For example, the compound assignment `x += 23`
 * uses `+` as the implicit operator.
 */
class AssignOp extends Assignment, @assignop {
  /**
   * Gets a source of the compound assignment, which includes both the right-hand side
   * and the left-hand side of the assignment.
   */
  override Expr getSource() { result.getParent() = this }

  /** Gets a string representation of the assignment operator of this compound assignment. */
  /*abstract*/ string getOp() { result = "??=" }

  /** Gets a printable representation of this expression. */
  override string toString() { result = "..." + this.getOp() + "..." }
}

/** A compound assignment expression using the `+=` operator. */
class AssignAddExpr extends AssignOp, @assignaddexpr {
  override string getOp() { result = "+=" }

  override string getAPrimaryQlClass() { result = "AssignAddExpr" }
}

/** A compound assignment expression using the `-=` operator. */
class AssignSubExpr extends AssignOp, @assignsubexpr {
  override string getOp() { result = "-=" }

  override string getAPrimaryQlClass() { result = "AssignSubExpr" }
}

/** A compound assignment expression using the `*=` operator. */
class AssignMulExpr extends AssignOp, @assignmulexpr {
  override string getOp() { result = "*=" }

  override string getAPrimaryQlClass() { result = "AssignMulExpr" }
}

/** A compound assignment expression using the `/=` operator. */
class AssignDivExpr extends AssignOp, @assigndivexpr {
  override string getOp() { result = "/=" }

  override string getAPrimaryQlClass() { result = "AssignDivExpr" }
}

/** A compound assignment expression using the `%=` operator. */
class AssignRemExpr extends AssignOp, @assignremexpr {
  override string getOp() { result = "%=" }

  override string getAPrimaryQlClass() { result = "AssignRemExpr" }
}

/** A compound assignment expression using the `&=` operator. */
class AssignAndExpr extends AssignOp, @assignandexpr {
  override string getOp() { result = "&=" }

  override string getAPrimaryQlClass() { result = "AssignAndExpr" }
}

/** A compound assignment expression using the `|=` operator. */
class AssignOrExpr extends AssignOp, @assignorexpr {
  override string getOp() { result = "|=" }

  override string getAPrimaryQlClass() { result = "AssignOrExpr" }
}

/** A compound assignment expression using the `^=` operator. */
class AssignXorExpr extends AssignOp, @assignxorexpr {
  override string getOp() { result = "^=" }

  override string getAPrimaryQlClass() { result = "AssignXorExpr" }
}

/** A compound assignment expression using the `<<=` operator. */
class AssignLeftShiftExpr extends AssignOp, @assignlshiftexpr {
  override string getOp() { result = "<<=" }

  override string getAPrimaryQlClass() { result = "AssignLeftShiftExpr" }
}

/** A compound assignment expression using the `>>=` operator. */
class AssignRightShiftExpr extends AssignOp, @assignrshiftexpr {
  override string getOp() { result = ">>=" }

  override string getAPrimaryQlClass() { result = "AssignRightShiftExpr" }
}

/** A compound assignment expression using the `>>>=` operator. */
class AssignUnsignedRightShiftExpr extends AssignOp, @assignurshiftexpr {
  override string getOp() { result = ">>>=" }

  override string getAPrimaryQlClass() { result = "AssignUnsignedRightShiftExpr" }
}

/** A common super-class to represent constant literals. */
class Literal extends Expr, @literal {
  /**
   * Gets a string representation of this literal as it appeared
   * in the source code.
   *
   * For Kotlin the result might not match the exact representation
   * used in the source code.
   *
   * **Important:** Unless a query explicitly wants to check how
   * a literal was written in the source code, the predicate
   * `getValue()` (or value predicates of subclasses) should be
   * used instead. For example for the integer literal `0x7fff_ffff`
   * the result of `getLiteral()` would be `0x7fff_ffff`, while
   * the result of `getValue()` would be `2147483647`.
   */
  string getLiteral() { namestrings(result, _, this) }

  /**
   * Gets a string representation of the value this literal
   * represents.
   */
  string getValue() { namestrings(_, result, this) }

  /** Gets a printable representation of this expression. */
  override string toString() { result = this.getLiteral() }

  /** Holds if this literal is a compile-time constant expression (as per JLS v8, section 15.28). */
  override predicate isCompileTimeConstant() {
    this.getType() instanceof PrimitiveType or
    this.getType() instanceof TypeString
  }
}

/** A boolean literal. Either `true` or `false`. */
class BooleanLiteral extends Literal, @booleanliteral {
  /** Gets the boolean representation of this literal. */
  boolean getBooleanValue() {
    result = true and this.getValue() = "true"
    or
    result = false and this.getValue() = "false"
  }

  override string getAPrimaryQlClass() { result = "BooleanLiteral" }
}

/**
 * An integer literal. For example, `23`.
 *
 * An integer literal can never be negative except when:
 * - It is written in binary, octal or hexadecimal notation
 * - It is written in decimal notation, has the value `2147483648` and is preceded
 *   by a minus; in this case the value of the IntegerLiteral is -2147483648 and
 *   the preceding minus will *not* be modeled as `MinusExpr`.
 *
 * In all other cases the preceding minus, if any, will be modeled as a separate
 * `MinusExpr`.
 *
 * The last exception is necessary because `2147483648` on its own would not be
 * a valid integer literal (and could also not be parsed as CodeQL `int`).
 */
class IntegerLiteral extends Literal, @integerliteral {
  /** Gets the int representation of this literal. */
  int getIntValue() { result = this.getValue().toInt() }

  override string getAPrimaryQlClass() { result = "IntegerLiteral" }
}

/**
 * A long literal. For example, `23L`.
 *
 * A long literal can never be negative except when:
 * - It is written in binary, octal or hexadecimal notation
 * - It is written in decimal notation, has the value `9223372036854775808` and
 *   is preceded by a minus; in this case the value of the LongLiteral is
 *   -9223372036854775808 and the preceding minus will *not* be modeled as
 *   `MinusExpr`.
 *
 * In all other cases the preceding minus, if any, will be modeled as a separate
 * `MinusExpr`.
 *
 * The last exception is necessary because `9223372036854775808` on its own
 * would not be a valid long literal.
 */
class LongLiteral extends Literal, @longliteral {
  override string getAPrimaryQlClass() { result = "LongLiteral" }
}

/**
 * A float literal. For example, `4.2f`.
 *
 * A float literal is never negative; a preceding minus, if any, will always
 * be modeled as separate `MinusExpr`.
 */
class FloatLiteral extends Literal, @floatingpointliteral {
  /**
   * Gets the value of this literal as CodeQL 64-bit `float`. The value will
   * be parsed as Java 32-bit `float` and then converted to a CodeQL `float`.
   */
  float getFloatValue() { result = this.getValue().toFloat() }

  override string getAPrimaryQlClass() { result = "FloatLiteral" }
}

/**
 * A double literal. For example, `4.2`.
 *
 * A double literal is never negative; a preceding minus, if any, will always
 * be modeled as separate `MinusExpr`.
 */
class DoubleLiteral extends Literal, @doubleliteral {
  /**
   * Gets the value of this literal as CodeQL 64-bit `float`. The result will
   * have the same effective value as the Java `double` literal.
   */
  float getDoubleValue() { result = this.getValue().toFloat() }

  override string getAPrimaryQlClass() { result = "DoubleLiteral" }
}

bindingset[s]
private int fromHex(string s) {
  exists(string digits | s.toUpperCase() = digits |
    result =
      sum(int i |
        |
        "0123456789ABCDEF".indexOf(digits.charAt(i)).bitShiftLeft((digits.length() - i - 1) * 4)
      )
  )
}

/** A character literal. For example, `'\n'`. */
class CharacterLiteral extends Literal, @characterliteral {
  override string getAPrimaryQlClass() { result = "CharacterLiteral" }

  /**
   * Gets a string which consists of the single character represented by
   * this literal.
   *
   * Unicode surrogate characters (U+D800 to U+DFFF) have the replacement character
   * U+FFFD as result instead.
   */
  override string getValue() { result = super.getValue() }

  /**
   * Gets the Unicode code point value of the character represented by
   * this literal. The result is the same as if the Java code had cast
   * the character to an `int`.
   */
  int getCodePointValue() {
    if this.getLiteral().matches("'\\u____'")
    then result = fromHex(this.getLiteral().substring(3, 7))
    else result.toUnicode() = this.getValue()
  }
}

/**
 * A string literal or text block (Java 15 feature). For example, `"hello world"`
 * or
 * ```java
 * """
 * Text with "quotes"
 * """
 * ```
 */
class StringLiteral extends Literal, @stringliteral {
  /**
   * Gets the string represented by this string literal, that is, the content
   * of the literal without enclosing quotes and with escape sequences translated.
   *
   * Unpaired Unicode surrogate characters (U+D800 to U+DFFF) are replaced with the
   * replacement character U+FFFD.
   */
  override string getValue() { result = super.getValue() }

  /** Holds if this string literal is a text block (`""" ... """`). */
  predicate isTextBlock() { this.getLiteral().matches("\"\"\"%") }

  override string getAPrimaryQlClass() { result = "StringLiteral" }
}

/** The null literal, written `null`. */
class NullLiteral extends Literal, @nullliteral {
  // Override these predicates because the inherited ones have no result
  override string getLiteral() { result = "null" }

  override string getValue() { result = "null" }

  override string getAPrimaryQlClass() { result = "NullLiteral" }
}

/** A common super-class to represent binary operator expressions. */
class BinaryExpr extends Expr, @binaryexpr {
  /** Gets the operand on the left-hand side of this binary expression. */
  Expr getLeftOperand() { result.isNthChildOf(this, 0) }

  /** Gets the operand on the right-hand side of this binary expression. */
  Expr getRightOperand() { result.isNthChildOf(this, 1) }

  /** Gets an operand (left or right). */
  Expr getAnOperand() { result = this.getLeftOperand() or result = this.getRightOperand() }

  /** The operands of this binary expression are `e` and `f`, in either order. */
  predicate hasOperands(Expr e, Expr f) {
    exists(int i | i in [0 .. 1] |
      e.isNthChildOf(this, i) and
      f.isNthChildOf(this, 1 - i)
    )
  }

  /** Gets a printable representation of this expression. */
  override string toString() { result = "..." + this.getOp() + "..." }

  /** Gets a string representation of the operator of this binary expression. */
  /*abstract*/ string getOp() { result = " ?? " }
}

/** A binary expression using the `*` operator. */
class MulExpr extends BinaryExpr, @mulexpr {
  override string getOp() { result = " * " }

  override string getAPrimaryQlClass() { result = "MulExpr" }
}

/** A binary expression using the `/` operator. */
class DivExpr extends BinaryExpr, @divexpr {
  override string getOp() { result = " / " }

  override string getAPrimaryQlClass() { result = "DivExpr" }
}

/** A binary expression using the `%` operator. */
class RemExpr extends BinaryExpr, @remexpr {
  override string getOp() { result = " % " }

  override string getAPrimaryQlClass() { result = "RemExpr" }
}

/** A binary expression using the `+` operator. */
class AddExpr extends BinaryExpr, @addexpr {
  override string getOp() { result = " + " }

  override string getAPrimaryQlClass() { result = "AddExpr" }
}

/** A binary expression using the `-` operator. */
class SubExpr extends BinaryExpr, @subexpr {
  override string getOp() { result = " - " }

  override string getAPrimaryQlClass() { result = "SubExpr" }
}

/** A binary expression using the `<<` operator. */
class LeftShiftExpr extends BinaryExpr, @lshiftexpr {
  override string getOp() { result = " << " }

  override string getAPrimaryQlClass() { result = "LeftShiftExpr" }
}

/** A binary expression using the `>>` operator. */
class RightShiftExpr extends BinaryExpr, @rshiftexpr {
  override string getOp() { result = " >> " }

  override string getAPrimaryQlClass() { result = "RightShiftExpr" }
}

/** A binary expression using the `>>>` operator. */
class UnsignedRightShiftExpr extends BinaryExpr, @urshiftexpr {
  override string getOp() { result = " >>> " }

  override string getAPrimaryQlClass() { result = "UnsignedRightShiftExpr" }
}

/** A binary expression using the `&` operator. */
class AndBitwiseExpr extends BinaryExpr, @andbitexpr {
  override string getOp() { result = " & " }

  override string getAPrimaryQlClass() { result = "AndBitwiseExpr" }
}

/** A binary expression using the `|` operator. */
class OrBitwiseExpr extends BinaryExpr, @orbitexpr {
  override string getOp() { result = " | " }

  override string getAPrimaryQlClass() { result = "OrBitwiseExpr" }
}

/** A binary expression using the `^` operator. */
class XorBitwiseExpr extends BinaryExpr, @xorbitexpr {
  override string getOp() { result = " ^ " }

  override string getAPrimaryQlClass() { result = "XorBitwiseExpr" }
}

/** A binary expression using the `&&` operator. */
class AndLogicalExpr extends BinaryExpr, @andlogicalexpr {
  override string getOp() { result = " && " }

  override string getAPrimaryQlClass() { result = "AndLogicalExpr" }
}

/** A binary expression using the `||` operator. */
class OrLogicalExpr extends BinaryExpr, @orlogicalexpr {
  override string getOp() { result = " || " }

  override string getAPrimaryQlClass() { result = "OrLogicalExpr" }
}

/** A binary expression using the `<` operator. */
class LTExpr extends BinaryExpr, @ltexpr {
  override string getOp() { result = " < " }

  override string getAPrimaryQlClass() { result = "LTExpr" }
}

/** A binary expression using the `>` operator. */
class GTExpr extends BinaryExpr, @gtexpr {
  override string getOp() { result = " > " }

  override string getAPrimaryQlClass() { result = "GTExpr" }
}

/** A binary expression using the `<=` operator. */
class LEExpr extends BinaryExpr, @leexpr {
  override string getOp() { result = " <= " }

  override string getAPrimaryQlClass() { result = "LEExpr" }
}

/** A binary expression using the `>=` operator. */
class GEExpr extends BinaryExpr, @geexpr {
  override string getOp() { result = " >= " }

  override string getAPrimaryQlClass() { result = "GEExpr" }
}

/** A binary expression using Java's `==` or Kotlin's `===` operator. */
class EQExpr extends BinaryExpr, @eqexpr {
  override string getOp() { result = " == " }

  override string getAPrimaryQlClass() { result = "EQExpr" }
}

/** A binary expression using the Kotlin `==` operator, semantically equivalent to `Objects.equals`. */
class ValueEQExpr extends BinaryExpr, @valueeqexpr {
  override string getOp() { result = " (value equals) " }

  override string getAPrimaryQlClass() { result = "ValueEQExpr" }
}

/** A binary expression using Java's `!=` or Kotlin's `!==` operator. */
class NEExpr extends BinaryExpr, @neexpr {
  override string getOp() { result = " != " }

  override string getAPrimaryQlClass() { result = "NEExpr" }
}

/** A binary expression using the Kotlin `!=` operator, semantically equivalent to `Objects.equals`. */
class ValueNEExpr extends BinaryExpr, @valueneexpr {
  override string getOp() { result = " (value not-equals) " }

  override string getAPrimaryQlClass() { result = "ValueNEExpr" }
}

/**
 * A binary expression using either Java or Kotlin's `==` operator.
 *
 * This might test for reference equality or might function like `Objects.equals`. If you
 * need to distinguish them, use `EQExpr` or `ValueEQExpr` instead.
 */
class ValueOrReferenceEqualsExpr extends BinaryExpr {
  ValueOrReferenceEqualsExpr() { this instanceof EQExpr or this instanceof ValueEQExpr }
}

/**
 * A binary expression using either Java or Kotlin's `!=` operator.
 *
 * This might test for reference equality or might function like `Objects.equals`. If you
 * need to distinguish them, use `NEExpr` or `ValueNEExpr` instead.
 */
class ValueOrReferenceNotEqualsExpr extends BinaryExpr {
  ValueOrReferenceNotEqualsExpr() { this instanceof NEExpr or this instanceof ValueNEExpr }
}

/**
 * A bitwise expression.
 *
 * This includes expressions involving the operators
 * `&`, `|`, `^`, or `~`.
 */
class BitwiseExpr extends Expr {
  BitwiseExpr() {
    this instanceof AndBitwiseExpr or
    this instanceof OrBitwiseExpr or
    this instanceof XorBitwiseExpr or
    this instanceof BitNotExpr
  }
}

/**
 * A logical expression.
 *
 * This includes expressions involving the operators
 * `&&`, `||`, or `!`.
 */
class LogicExpr extends Expr {
  LogicExpr() {
    this instanceof AndLogicalExpr or
    this instanceof OrLogicalExpr or
    this instanceof LogNotExpr
  }

  /** Gets an operand of this logical expression. */
  Expr getAnOperand() {
    this.(BinaryExpr).getAnOperand() = result or
    this.(UnaryExpr).getExpr() = result
  }
}

/**
 * A comparison expression.
 *
 * This includes expressions using the operators
 * `<=`, `>=`, `<` or `>`.
 */
abstract class ComparisonExpr extends BinaryExpr {
  /**
   * Gets the lesser operand of this comparison expression.
   *
   * For example, `x` is the lesser operand
   * in `x < 0`, and `0` is the
   * lesser operand in `x > 0`.
   */
  abstract Expr getLesserOperand();

  /**
   * Gets the greater operand of this comparison expression.
   *
   * For example, `x` is the greater operand
   * in `x > 0`, and `0` is the
   * greater operand in `x < 0`.
   */
  abstract Expr getGreaterOperand();

  /** Holds if this comparison is strict, i.e. `<` or `>`. */
  predicate isStrict() { this instanceof LTExpr or this instanceof GTExpr }
}

/** A comparison expression using the operator `<` or `<=`. */
class LessThanComparison extends ComparisonExpr {
  LessThanComparison() { this instanceof LTExpr or this instanceof LEExpr }

  /** Gets the lesser operand of this comparison expression. */
  override Expr getLesserOperand() { result = this.getLeftOperand() }

  /** Gets the greater operand of this comparison expression. */
  override Expr getGreaterOperand() { result = this.getRightOperand() }
}

/** A comparison expression using the operator `>` or `>=`. */
class GreaterThanComparison extends ComparisonExpr {
  GreaterThanComparison() { this instanceof GTExpr or this instanceof GEExpr }

  /** Gets the lesser operand of this comparison expression. */
  override Expr getLesserOperand() { result = this.getRightOperand() }

  /** Gets the greater operand of this comparison expression. */
  override Expr getGreaterOperand() { result = this.getLeftOperand() }
}

/**
 * An equality test is a binary expression using
 * Java's `==` or `!=` operators, or Kotlin's `==`, `!=`, `===` or `!==` operators.
 *
 * This could be a reference- or a value-(in)equality test.
 */
class EqualityTest extends BinaryExpr {
  EqualityTest() {
    this instanceof EQExpr or
    this instanceof NEExpr or
    this instanceof ValueEQExpr or
    this instanceof ValueNEExpr
  }

  /** Gets a boolean indicating whether this is `==` (true) or `!=` (false). */
  boolean polarity() {
    result = true and this instanceof EQExpr
    or
    result = false and this instanceof NEExpr
    or
    result = true and this instanceof ValueEQExpr
    or
    result = false and this instanceof ValueNEExpr
  }
}

/**
 * An equality test is a binary expression using
 * Java's `==` or `!=` operators or Kotlin's `===` or `!==` operators.
 *
 * If either operand is a reference type, this is a reference-in/equality test.
 */
class ReferenceEqualityTest extends EqualityTest {
  ReferenceEqualityTest() {
    this instanceof EQExpr or
    this instanceof NEExpr
  }
}

/** A common super-class that represents unary operator expressions. */
class UnaryExpr extends Expr, @unaryexpr {
  /** Gets the operand expression. */
  Expr getExpr() { result.getParent() = this }
}

/**
 * A unary assignment expression is a unary expression using the
 * prefix or postfix `++` or `--` operator.
 */
class UnaryAssignExpr extends UnaryExpr, @unaryassignment { }

/** A post-increment expression. For example, `i++`. */
class PostIncExpr extends UnaryAssignExpr, @postincexpr {
  override string toString() { result = "...++" }

  override string getAPrimaryQlClass() { result = "PostIncExpr" }
}

/** A post-decrement expression. For example, `i--`. */
class PostDecExpr extends UnaryAssignExpr, @postdecexpr {
  override string toString() { result = "...--" }

  override string getAPrimaryQlClass() { result = "PostDecExpr" }
}

/** A pre-increment expression. For example, `++i`. */
class PreIncExpr extends UnaryAssignExpr, @preincexpr {
  override string toString() { result = "++..." }

  override string getAPrimaryQlClass() { result = "PreIncExpr" }
}

/** A pre-decrement expression. For example, `--i`. */
class PreDecExpr extends UnaryAssignExpr, @predecexpr {
  override string toString() { result = "--..." }

  override string getAPrimaryQlClass() { result = "PreDecExpr" }
}

/** A unary minus expression. For example, `-i`. */
class MinusExpr extends UnaryExpr, @minusexpr {
  override string toString() { result = "-..." }

  override string getAPrimaryQlClass() { result = "MinusExpr" }
}

/** A unary plus expression. For example, `+i`. */
class PlusExpr extends UnaryExpr, @plusexpr {
  override string toString() { result = "+..." }

  override string getAPrimaryQlClass() { result = "PlusExpr" }
}

/** A bit negation expression. For example, `~x`. */
class BitNotExpr extends UnaryExpr, @bitnotexpr {
  override string toString() { result = "~..." }

  override string getAPrimaryQlClass() { result = "BitNotExpr" }
}

/** A logical negation expression. For example, `!b`. */
class LogNotExpr extends UnaryExpr, @lognotexpr {
  override string toString() { result = "!..." }

  override string getAPrimaryQlClass() { result = "LogNotExpr" }
}

/**
 * Any kind of expression that casts values from one type to another.
 *
 * For Java, this is only `CastExpr`, but for Kotlin it includes
 * various other explicit or implicit casting operators.
 */
class CastingExpr extends Expr {
  CastingExpr() {
    this instanceof @castexpr or
    this instanceof @safecastexpr or
    this instanceof @implicitcastexpr or
    this instanceof @implicitnotnullexpr or
    this instanceof @implicitcoerciontounitexpr or
    this instanceof @unsafecoerceexpr
  }

  /** Gets the target type of this casting expression. */
  Expr getTypeExpr() { result.isNthChildOf(this, 0) }

  /** Gets the expression to which the casting operator is applied. */
  Expr getExpr() { result.isNthChildOf(this, 1) }
}

/** A cast expression. */
class CastExpr extends CastingExpr, @castexpr {
  /** Gets a printable representation of this expression. */
  override string toString() { result = "(...)..." }

  override string getAPrimaryQlClass() { result = "CastExpr" }
}

/** A safe cast expression. */
class SafeCastExpr extends CastingExpr, @safecastexpr {
  /** Gets a printable representation of this expression. */
  override string toString() { result = "... as? ..." }

  override string getAPrimaryQlClass() { result = "SafeCastExpr" }
}

/** An implicit cast expression. */
class ImplicitCastExpr extends CastingExpr, @implicitcastexpr {
  /** Gets a printable representation of this expression. */
  override string toString() { result = "<implicit cast>" }

  override string getAPrimaryQlClass() { result = "ImplicitCastExpr" }
}

/** An implicit cast-to-non-null expression. */
class ImplicitNotNullExpr extends CastingExpr, @implicitnotnullexpr {
  /** Gets a printable representation of this expression. */
  override string toString() { result = "<implicit not null>" }

  override string getAPrimaryQlClass() { result = "ImplicitNotNullExpr" }
}

/** An implicit coercion-to-unit expression. */
class ImplicitCoercionToUnitExpr extends CastingExpr, @implicitcoerciontounitexpr {
  /** Gets a printable representation of this expression. */
  override string toString() { result = "<implicit coercion to unit>" }

  override string getAPrimaryQlClass() { result = "ImplicitCoercionToUnitExpr" }
}

/** An unsafe coerce expression. */
class UnsafeCoerceExpr extends CastingExpr, @unsafecoerceexpr {
  /** Gets a printable representation of this expression. */
  override string toString() { result = "<unsafe coerce>" }

  override string getAPrimaryQlClass() { result = "UnsafeCoerceExpr" }
}

/** A class instance creation expression. */
class ClassInstanceExpr extends Expr, ConstructorCall, @classinstancexpr {
  /** Gets the number of arguments provided to the constructor of the class instance creation expression. */
  override int getNumArgument() { count(this.getAnArgument()) = result }

  /** Gets an argument provided to the constructor of this class instance creation expression. */
  override Expr getAnArgument() { result.getIndex() >= 0 and result.getParent() = this }

  /**
   * Gets the argument provided to the constructor of this class instance creation expression
   * at the specified (zero-based) position.
   */
  override Expr getArgument(int index) {
    result.getIndex() = index and
    result = this.getAnArgument()
  }

  /**
   * Gets a type argument of the type of the created instance.
   *
   * This is used for instantiations of parameterized classes. For example for
   * `new ArrayList<String>()` the result would be the expression representing `String`.
   */
  Expr getATypeArgument() { result = this.getTypeName().(TypeAccess).getATypeArgument() }

  /**
   * Gets the type argument of the type of the created instance, at the specified (zero-based) position.
   */
  Expr getTypeArgument(int index) {
    result = this.getTypeName().(TypeAccess).getTypeArgument(index)
  }

  /** Gets the qualifier of this class instance creation expression, if any. */
  override Expr getQualifier() { result.isNthChildOf(this, -2) }

  /**
   * Gets the access to the type that is instantiated or subclassed by this
   * class instance creation expression.
   */
  Expr getTypeName() { result.isNthChildOf(this, -3) }

  /** Gets the constructor invoked by this class instance creation expression. */
  override Constructor getConstructor() { callableBinding(this, result) }

  /** Gets the anonymous class created by this class instance creation expression, if any. */
  AnonymousClass getAnonymousClass() { isAnonymClass(result, this) }

  /**
   * Holds if this class instance creation expression has an
   * empty type argument list of the form `<>`.
   */
  predicate isDiamond() {
    this.getType() instanceof ParameterizedClass and
    not exists(this.getATypeArgument())
  }

  /** Gets the immediately enclosing callable of this class instance creation expression. */
  override Callable getEnclosingCallable() { result = Expr.super.getEnclosingCallable() }

  /** Gets the immediately enclosing statement of this class instance creation expression. */
  override Stmt getEnclosingStmt() { result = Expr.super.getEnclosingStmt() }

  /** Gets a printable representation of this expression. */
  override string toString() {
    result = "new " + this.getConstructor().getName() + "(...)"
    or
    not exists(this.getConstructor()) and
    result = "<ClassInstanceExpr that calls a missing constructor>"
  }

  override string getAPrimaryQlClass() { result = "ClassInstanceExpr" }
}

/**
 * An explicit `new TypeName(...)` expression.
 *
 * Note this does not include implicit instance creation such as lambda expressions
 * or `instanceVar::methodName` references. To include those too, use `ClassInstanceExpr`.
 */
class NewClassExpr extends @newexpr, ClassInstanceExpr { }

/** A functional expression is either a lambda expression or a member reference expression. */
abstract class FunctionalExpr extends ClassInstanceExpr {
  /** Gets the implicit method corresponding to this functional expression. */
  abstract Method asMethod();
}

/**
 * Lambda expressions are represented by their implicit class instance creation expressions,
 * which instantiate an anonymous class that overrides the unique method designated by
 * their functional interface type. The parameters of the lambda expression correspond
 * to the parameters of the overriding method, and the lambda body corresponds to the
 * body of the overriding method (enclosed by a return statement and a block in the case
 * of lambda expressions whose body is an expression).
 *
 * For details, see JLS v8 section 15.27.4: Run-Time Evaluation of Lambda Expressions.
 */
class LambdaExpr extends FunctionalExpr, @lambdaexpr {
  /**
   * Gets the implicit method corresponding to this lambda expression.
   * The parameters of the lambda expression are the parameters of this method.
   */
  override Method asMethod() {
    not this.isKotlinFunctionN() and
    result = this.getAnonymousClass().getAMethod()
    or
    this.isKotlinFunctionN() and
    result = this.getAnonymousClass().getAMethod() and
    result.getNumberOfParameters() > 1
  }

  /**
   * Holds if this expression is a big-arity lambda expression in Kotlin.
   */
  predicate isKotlinFunctionN() {
    exists(RefType r |
      this.getAnonymousClass().extendsOrImplements(r) and
      r.getSourceDeclaration().hasQualifiedName("kotlin.jvm.functions", "FunctionN")
    )
  }

  /** Holds if the body of this lambda is an expression. */
  predicate hasExprBody() { lambdaKind(this, 0) }

  /** Holds if the body of this lambda is a statement. */
  predicate hasStmtBody() { lambdaKind(this, 1) }

  /** Gets the body of this lambda expression, if it is an expression. */
  Expr getExprBody() {
    this.hasExprBody() and result = this.asMethod().getBody().getAChild().(ReturnStmt).getResult()
  }

  /** Gets the body of this lambda expression, if it is a statement. */
  BlockStmt getStmtBody() { this.hasStmtBody() and result = this.asMethod().getBody() }

  /** Gets a printable representation of this expression. */
  override string toString() { result = "...->..." }

  override string getAPrimaryQlClass() { result = "LambdaExpr" }
}

/**
 * Member references are represented by their implicit class instance expressions,
 * which instantiate an anonymous class that overrides the unique method designated by
 * their functional interface type. The correspondence of the parameters of the overriding
 * method in the anonymous class with the parameters of the callable that is referenced
 * differs depending on the particular kind of member reference expression.
 *
 * For details, see JLS v8 section 15.13.3: Run-Time Evaluation of Method References.
 */
class MemberRefExpr extends FunctionalExpr, @memberref {
  /**
   * Gets the implicit method corresponding to this member reference expression.
   * The body of this method is a return statement (enclosed in a block) whose expression
   * is either a method access (if the reference is to a method), a class instance creation expression
   * (if the reference is to a constructor) or an array creation expression (if the reference
   * is to an array constructor).
   */
  override Method asMethod() { result = this.getAnonymousClass().getAMethod() }

  private Expr getResultExpr() {
    exists(Stmt stmt |
      stmt = this.asMethod().getBody().(SingletonBlock).getStmt() and
      (
        result = stmt.(ReturnStmt).getResult()
        or
        // Note: Currently never an ExprStmt, but might change once https://github.com/github/codeql/issues/3605 is fixed
        result = stmt.(ExprStmt).getExpr()
      )
    )
  }

  /**
   * Gets the expression whose member this member reference refers to, that is, the left
   * side of the `::`. For example, for the member reference `this::toString` the receiver
   * expression is the `this` expression.
   *
   * This predicate might not have a result in all cases where the receiver expression is
   * a type access, for example `MyClass::...`.
   */
  Expr getReceiverExpr() {
    exists(Expr resultExpr | resultExpr = this.getResultExpr() |
      result = resultExpr.(Call).getQualifier() and
      // Ignore if the qualifier is a parameter of the method of the synthetic anonymous class
      // (this is the case for method refs of instance methods which don't capture the instance, e.g. `Object::toString`)
      // Could try to use TypeAccess as result here from child of MemberRefExpr, but that complexity might not be worth it
      not this.asMethod().getAParameter().getAnAccess() = result
      or
      result = resultExpr.(ClassInstanceExpr).getTypeName()
      // Don't cover array creation because ArrayCreationExpr currently does not have a predicate
      // to easily get ArrayTypeAccess which should probably be the result here
    )
  }

  /**
   * Gets the receiver type whose member this expression refers to. The result might not be
   * the type which actually declares the member. For example, for the member reference `ArrayList::toString`,
   * this predicate has the result `java.util.ArrayList`, the type explicitly referred to, while
   * `getReferencedCallable` will have `java.util.AbstractCollection.toString` as result, which `ArrayList` inherits.
   */
  RefType getReceiverType() {
    exists(Expr resultExpr | resultExpr = this.getResultExpr() |
      result = resultExpr.(MethodCall).getReceiverType() or
      result = resultExpr.(ClassInstanceExpr).getConstructedType() or
      result = resultExpr.(ArrayCreationExpr).getType()
    )
  }

  /**
   * Gets the method or constructor referenced by this member reference expression.
   */
  Callable getReferencedCallable() { memberRefBinding(this, result) }

  /** Gets a printable representation of this expression. */
  override string toString() { result = "...::..." }

  override string getAPrimaryQlClass() { result = "MemberRefExpr" }
}

/**
 * Property references are represented by their implicit class instance expressions,
 * which instantiate an anonymous class that overrides the `get` and `set` methods designated by
 * their functional interface type.
 */
class PropertyRefExpr extends ClassInstanceExpr, @propertyref {
  /**
   * Gets the implicit `get` method corresponding to this property reference expression, if any.
   */
  Method asGetMethod() {
    result = this.getAnonymousClass().getAMethod() and result.getName() = "get"
  }

  /**
   * Gets the implicit `set` method corresponding to this property reference expression, if any.
   */
  Method asSetMethod() {
    result = this.getAnonymousClass().getAMethod() and result.getName() = "set"
  }

  /**
   * Gets the property getter referenced by this property reference expression, if any.
   */
  Callable getGetterCallable() { propertyRefGetBinding(this, result) }

  /**
   * Gets the field referenced by this property reference expression, if any.
   */
  Field getField() { propertyRefFieldBinding(this, result) }

  /**
   * Gets the property setter referenced by this property reference expression, if any.
   */
  Callable getSetterCallable() { propertyRefSetBinding(this, result) }

  /** Gets a printable representation of this expression. */
  override string toString() { result = "...::..." }

  override string getAPrimaryQlClass() { result = "PropertyRefExpr" }
}

/** A conditional expression or a `switch` expression. */
class ChooseExpr extends Expr {
  ChooseExpr() { this instanceof ConditionalExpr or this instanceof SwitchExpr }

  /** Gets a result expression of this `switch` or conditional expression. */
  Expr getAResultExpr() {
    result = this.(ConditionalExpr).getABranchExpr() or
    result = this.(SwitchExpr).getAResult()
  }
}

/**
 * A conditional expression of the form `a ? b : c`, where `a` is the condition,
 * `b` is the expression that is evaluated if the condition evaluates to `true`,
 * and `c` is the expression that is evaluated if the condition evaluates to `false`.
 */
class ConditionalExpr extends Expr, @conditionalexpr {
  /** Gets the condition of this conditional expression. */
  Expr getCondition() { result.isNthChildOf(this, 0) }

  /**
   * Gets the expression that is evaluated if the condition of this
   * conditional expression evaluates to `true`.
   */
  Expr getTrueExpr() { result.isNthChildOf(this, 1) }

  /**
   * Gets the expression that is evaluated if the condition of this
   * conditional expression evaluates to `false`.
   */
  Expr getFalseExpr() { result.isNthChildOf(this, 2) }

  /**
   * Gets the expression that is evaluated by the specific branch of this
   * conditional expression. If `true` that is `getTrueExpr()`, if `false`
   * it is `getFalseExpr()`.
   */
  Expr getBranchExpr(boolean branch) {
    branch = true and result = this.getTrueExpr()
    or
    branch = false and result = this.getFalseExpr()
  }

  /**
   * Gets the expressions that is evaluated by one of the branches (`true`
   * or `false` branch) of this conditional expression.
   */
  Expr getABranchExpr() { result = this.getBranchExpr(_) }

  /** Gets a printable representation of this expression. */
  override string toString() { result = "...?...:..." }

  override string getAPrimaryQlClass() { result = "ConditionalExpr" }
}

/**
 * A `switch` expression.
 */
class SwitchExpr extends Expr, StmtParent, @switchexpr {
  /** Gets an immediate child statement of this `switch` expression. */
  Stmt getAStmt() { result.getParent() = this }

  /**
   * Gets the immediate child statement of this `switch` expression
   * that occurs at the specified (zero-based) position.
   */
  Stmt getStmt(int index) { result = this.getAStmt() and result.getIndex() = index }

  /**
   * Gets the `i`th case of this `switch` expression,
   * which may be either a normal `case` or a `default`.
   */
  SwitchCase getCase(int i) {
    result =
      rank[i + 1](SwitchCase case, int idx | case.isNthChildOf(this, idx) | case order by idx)
  }

  /**
   * Gets a case of this `switch` expression,
   * which may be either a normal `case` or a `default`.
   */
  SwitchCase getACase() { result.getParent() = this }

  /** Gets a (non-default) `case` of this `switch` expression. */
  ConstCase getAConstCase() { result = this.getACase() }

  /** Gets a (non-default) pattern `case` of this `switch` expression. */
  PatternCase getAPatternCase() { result = this.getACase() }

  /**
   * Gets the `default` case of this switch statement, if any.
   *
   * Note this may be `default` or `case null, default`.
   */
  DefaultCase getDefaultCase() { result = this.getACase() }

  /** Gets the expression of this `switch` expression. */
  Expr getExpr() { result.getParent() = this }

  /** Gets a result expression of this `switch` expression. */
  Expr getAResult() {
    result = this.getACase().getRuleExpression()
    or
    exists(YieldStmt yield | yield.getTarget() = this and result = yield.getValue())
  }

  /** Holds if this switch has a case handling a null literal. */
  predicate hasNullCase() {
    this.getAConstCase().getValue(_) instanceof NullLiteral or
    this.getACase() instanceof NullDefaultCase
  }

  /** Gets a printable representation of this expression. */
  override string toString() { result = "switch (...)" }

  override string getAPrimaryQlClass() { result = "SwitchExpr" }
}

/** An `instanceof` expression. */
class InstanceOfExpr extends Expr, @instanceofexpr {
  /** Gets the expression on the left-hand side of the `instanceof` operator. */
  Expr getExpr() { result.isNthChildOf(this, 0) }

  /**
   * Gets the pattern of an `x instanceof T pattern` expression, if any.
   */
  PatternExpr getPattern() { result.isNthChildOf(this, 2) }

  /**
   * Holds if this `instanceof` expression uses pattern matching.
   */
  predicate isPattern() { exists(this.getPattern()) }

  /**
   * Gets the local variable declaration of this `instanceof` expression if simple pattern matching is used.
   *
   * Note that this won't get anything when record pattern matching is used-- for more general patterns,
   * use `getPattern`.
   */
  LocalVariableDeclExpr getLocalVariableDeclExpr() {
    result = this.getPattern().asBindingOrUnnamedPattern()
  }

  /**
   * Gets the access to the type on the right-hand side of the `instanceof` operator.
   *
   * This does not match record patterns, which have a record pattern (use `getPattern`) not a type access.
   */
  Expr getTypeName() { result.isNthChildOf(this, 1) }

  /**
   * Gets the type this `instanceof` expression checks for.
   *
   * For a match against a record pattern, this is the type of the outermost record type, and only holds if
   * the record pattern matches that type unconditionally, i.e. it does not restrict field types more tightly
   * than the fields' declared types and therefore match a subset of `rpe.getType()`.
   */
  RefType getCheckedType() {
    result = this.getTypeName().getType()
    or
    exists(RecordPatternExpr rpe | rpe = this.getPattern().asRecordPattern() |
      result = rpe.getType() and rpe.isUnrestricted()
    )
  }

  /**
   * Gets the type this `instanceof` expression checks for.
   *
   * For a match against a record pattern, this is the type of the outermost record type. Note that because
   * the record match might additionally constrain field or sub-record fields to have a more specific type,
   * and so while if the `instanceof` test passes we know that `this.getExpr()` has this type, if it fails
   * we do not know that it doesn't.
   */
  RefType getSyntacticCheckedType() {
    result = this.getTypeName().getType()
    or
    result = this.getPattern().asRecordPattern().getType()
  }

  /** Gets a printable representation of this expression. */
  override string toString() { result = "...instanceof..." }

  override string getAPrimaryQlClass() { result = "InstanceOfExpr" }
}

// TODO: Should this be desugared into instanceof.not()?
// Note expressions/IrTypeOperatorCall.kt says:
//     NOT_INSTANCEOF, // TODO drop and replace with `INSTANCEOF<T>(x).not()`?
/** An `instanceof` expression. */
class NotInstanceOfExpr extends Expr, @notinstanceofexpr {
  /** Gets the expression on the left-hand side of the `!is` operator. */
  Expr getExpr() { result.isNthChildOf(this, 0) }

  /** Gets the access to the type on the right-hand side of the `!is` operator. */
  Expr getTypeName() { result.isNthChildOf(this, 1) }

  /** Gets the type this `!is` expression checks for. */
  RefType getCheckedType() { result = this.getTypeName().getType() }

  /** Gets a printable representation of this expression. */
  override string toString() { result = "... !is ..." }

  override string getAPrimaryQlClass() { result = "NotInstanceOfExpr" }
}

/**
 * A local variable declaration expression.
 *
 * Contexts in which such expressions may occur include
 * local variable declaration statements, `for` loops,
 * and binding patterns such as `if (x instanceof T t)` and
 * `case String s:`.
 */
class LocalVariableDeclExpr extends Expr, @localvariabledeclexpr {
  /** Gets an access to the variable declared by this local variable declaration expression. */
  VarAccess getAnAccess() { variableBinding(result, this.getVariable()) }

  /** Gets the local variable declared by this local variable declaration expression. */
  LocalVariableDecl getVariable() { localvars(result, _, _, this) }

  /** Gets the type access of this local variable declaration expression. */
  Expr getTypeAccess() {
    exists(LocalVariableDeclStmt lvds | lvds.getAVariable() = this | result.isNthChildOf(lvds, 0))
    or
    exists(CatchClause cc | cc.getVariable() = this | result.isNthChildOf(cc, -1))
    or
    exists(ForStmt fs | fs.getAnInit() = this | result.isNthChildOf(fs, 0))
    or
    exists(EnhancedForStmt efs | efs.getVariable() = this | result.isNthChildOf(efs, -1))
    or
    exists(InstanceOfExpr ioe | this.getParent() = ioe | result.isNthChildOf(ioe, 1))
    or
    exists(PatternCase pc, int index, int typeAccessIdx | this.isNthChildOf(pc, index) |
      (if index = 0 then typeAccessIdx = -2 else typeAccessIdx = (-3 - index)) and
      result.isNthChildOf(pc, typeAccessIdx)
    )
    or
    exists(RecordPatternExpr rpe, int index |
      this.isNthChildOf(rpe, index) and result.isNthChildOf(rpe, -(index + 1))
    )
  }

  /** Gets the name of the variable declared by this local variable declaration expression. */
  string getName() { result = this.getVariable().getName() }

  /** Holds if this is an anonymous local variable, `_` */
  predicate isAnonymous() { this.getName() = "" }

  /**
   * Gets the switch statement or expression whose pattern declares this identifier, if any.
   */
  SwitchBlock getAssociatedSwitch() {
    exists(PatternCase pc |
      pc = result.(SwitchStmt).getAPatternCase()
      or
      pc = result.(SwitchExpr).getAPatternCase()
    |
      this = pc.getAPattern().getAChildExpr*()
    )
  }

  /** Holds if this is a declaration stemming from a pattern switch case. */
  predicate hasAssociatedSwitch() { exists(this.getAssociatedSwitch()) }

  /**
   * Gets the instanceof expression whose pattern declares this identifier, if any.
   */
  InstanceOfExpr getAssociatedInstanceOfExpr() { result.getPattern().getAChildExpr*() = this }

  /** Holds if this is a declaration stemming from a pattern instanceof expression. */
  predicate hasAssociatedInstanceOfExpr() { exists(this.getAssociatedInstanceOfExpr()) }

  /**
   * Gets the initializer expression of this local variable declaration expression, if any.
   *
   * Note this applies specifically to a syntactic initialization like `T varname = init`;
   * to include also `e instanceof T varname` and `switch(e) ... case T varname`, which both
   * have the effect of initializing `varname` to a known local expression without using
   * that syntax, use `getInitOrPatternSource`.
   */
  Expr getInit() { result.isNthChildOf(this, 0) }

  /**
   * Gets the local expression that initializes this variable declaration, if any.
   *
   * Note this includes explicit `T varname = init;`, as well as `e instanceof T varname`
   * and `switch(e) ... case T varname`. To get only explicit initializers, use `getInit`.
   *
   * Note that record pattern variables like `e instance of T Record(T varname)` do not have
   * either an explicit initializer or a pattern source.
   */
  Expr getInitOrPatternSource() {
    result = this.getInit()
    or
    exists(SwitchStmt switch |
      result = switch.getExpr() and
      this = switch.getAPatternCase().getAPattern().asBindingOrUnnamedPattern()
    )
    or
    exists(SwitchExpr switch |
      result = switch.getExpr() and
      this = switch.getAPatternCase().getAPattern().asBindingOrUnnamedPattern()
    )
    or
    exists(InstanceOfExpr ioe |
      result = ioe.getExpr() and
      this = ioe.getPattern().asBindingOrUnnamedPattern()
    )
  }

  /** Holds if this variable declaration implicitly initializes the variable. */
  predicate hasImplicitInit() {
    exists(CatchClause cc | cc.getVariable() = this)
    or
    exists(EnhancedForStmt efs | efs.getVariable() = this)
    or
    this.getParent() instanceof RecordPatternExpr
  }

  /** Gets a printable representation of this expression. */
  override string toString() {
    if this.getName() = "" then result = "<anonymous local variable>" else result = this.getName()
  }

  override string getAPrimaryQlClass() { result = "LocalVariableDeclExpr" }
}

/** A local variable declaration that occurs within a record pattern. */
class RecordBindingVariableExpr extends LocalVariableDeclExpr {
  RecordBindingVariableExpr() { this.getParent() instanceof RecordPatternExpr }
}

/** An update of a variable or an initialization of the variable. */
class VariableUpdate extends Expr {
  VariableUpdate() {
    this.(Assignment).getDest() instanceof VarAccess or
    this instanceof LocalVariableDeclExpr or
    this.(UnaryAssignExpr).getExpr() instanceof VarAccess
  }

  /** Gets the destination of this variable update. */
  Variable getDestVar() {
    result.getAnAccess() = this.(Assignment).getDest() or
    result = this.(LocalVariableDeclExpr).getVariable() or
    result.getAnAccess() = this.(UnaryAssignExpr).getExpr()
  }
}

/**
 * An assignment to a variable or an initialization of the variable.
 *
 * This does not cover compound assignments such as `i += 1`, or unary
 * assignments such as `i++`; use the class `VariableUpdate` for that.
 */
class VariableAssign extends VariableUpdate {
  VariableAssign() {
    this instanceof AssignExpr or
    this instanceof LocalVariableDeclExpr
  }

  /**
   * Gets the source (right-hand side) of this assignment, if any.
   *
   * An initialization in a `CatchClause`, `EnhancedForStmt` or `RecordPatternExpr`
   * is implicit and does not have a source.
   */
  Expr getSource() {
    result = this.(AssignExpr).getSource() or
    result = this.(LocalVariableDeclExpr).getInitOrPatternSource()
  }
}

/** A type literal. For example, `String.class`. */
class TypeLiteral extends Expr, @typeliteral {
  /** Gets the access to the type whose class is accessed. */
  Expr getTypeName() { result.getParent() = this }

  /**
   * Gets the type this type literal refers to. For example for `String.class` the
   * result is the type representing `String`.
   */
  Type getReferencedType() { result = this.getTypeName().getType() }

  /** Gets a printable representation of this expression. */
  override string toString() {
    result = pragma[only_bind_out](this.getTypeName()).toString() + ".class"
  }

  override string getAPrimaryQlClass() { result = "TypeLiteral" }
}

/**
 * A use of one of the keywords `this` or `super`, which may be qualified.
 */
abstract class InstanceAccess extends Expr {
  /**
   * Gets the qualifying expression, if any.
   *
   * For example, the qualifying expression of `A.this` is `A`.
   */
  Expr getQualifier() { result.getParent() = this }

  /**
   * Holds if this instance access gets the value of `this`. That is, it is not
   * an enclosing instance.
   * This never holds for accesses in lambda expressions as they cannot access
   * their own instance directly.
   */
  predicate isOwnInstanceAccess() { not this.isEnclosingInstanceAccess(_) }

  /** Holds if this instance access is to an enclosing instance of type `t`. */
  predicate isEnclosingInstanceAccess(RefType t) {
    t = this.getQualifier().getType().(RefType).getSourceDeclaration() and
    t != this.getEnclosingCallable().getDeclaringType() and
    not this.isSuperInterfaceAccess()
    or
    (not exists(this.getQualifier()) or this.isSuperInterfaceAccess()) and
    exists(LambdaExpr lam | lam.asMethod() = this.getEnclosingCallable() |
      t = lam.getAnonymousClass().getEnclosingType()
    )
  }

  // A default method on an interface, `I`, may be invoked using `I.super.m()`.
  // This always refers to the implemented interfaces of `this`. This form of
  // qualified `super` cannot be combined with accessing an enclosing instance.
  // JLS 15.11.2. "Accessing Superclass Members using super"
  // JLS 15.12. "Method Invocation Expressions"
  // JLS 15.12.1. "Compile-Time Step 1: Determine Type to Search"
  private predicate isSuperInterfaceAccess() {
    this instanceof SuperAccess and
    this.getQualifier().getType().(RefType).getSourceDeclaration() instanceof Interface
  }
}

/**
 * A use of the keyword `this`, which may be qualified.
 *
 * Such an expression allows access to an enclosing instance.
 * For example, `A.this` refers to the enclosing instance
 * of type `A`.
 */
class ThisAccess extends InstanceAccess, @thisaccess {
  /** Gets a printable representation of this expression. */
  override string toString() {
    if exists(this.getQualifier()) then result = this.getQualifier() + ".this" else result = "this"
  }

  override string getAPrimaryQlClass() { result = "ThisAccess" }
}

/**
 * A use of the keyword `super`, which may be qualified.
 *
 * Such an expression allows access to super-class members of an enclosing instance.
 * For example, `A.super.x`.
 */
class SuperAccess extends InstanceAccess, @superaccess {
  /** Gets a printable representation of this expression. */
  override string toString() {
    if exists(this.getQualifier())
    then result = this.getQualifier() + ".super"
    else result = "super"
  }

  override string getAPrimaryQlClass() { result = "SuperAccess" }
}

/**
 * A variable access is a (possibly qualified) reference to
 * a field, parameter or local variable.
 */
class VarAccess extends Expr, @varaccess {
  /** Gets the qualifier of this variable access, if any. */
  Expr getQualifier() { result.getParent() = this }

  /** Holds if this variable access has a qualifier. */
  predicate hasQualifier() { exists(this.getQualifier()) }

  /** Gets the variable accessed by this variable access. */
  Variable getVariable() { variableBinding(this, result) }

  /**
   * Holds if this variable access is a write access.
   *
   * That means the access is the destination of an assignment.
   */
  predicate isVarWrite() {
    exists(Assignment a | a.getDest() = this) or
    exists(UnaryAssignExpr e | e.getExpr() = this)
  }

  /**
   * Holds if this variable access is a read access.
   *
   * In other words, it is a variable access that does _not_ occur as the destination of
   * a simple assignment, but it may occur as the destination of a compound assignment
   * or a unary assignment.
   */
  predicate isVarRead() { not exists(AssignExpr a | a.getDest() = this) }

  /** Gets a printable representation of this expression. */
  override string toString() {
    exists(Expr q | q = this.getQualifier() |
      if q.isParenthesized()
      then result = "(...)." + this.getVariable().getName()
      else result = pragma[only_bind_out](q).toString() + "." + this.getVariable().getName()
    )
    or
    not this.hasQualifier() and result = this.getVariable().getName()
  }

  /**
   * Holds if this access refers to a local variable or a field of
   * the receiver of the enclosing method or constructor.
   */
  predicate isLocal() {
    // The access has no qualifier, or...
    not this.hasQualifier()
    or
    // the qualifier is either `this` or `A.this`, where `A` is the enclosing type, or
    // the qualifier is either `super` or `A.super`, where `A` is the enclosing type.
    this.getQualifier().(InstanceAccess).isOwnInstanceAccess()
  }

  override string getAPrimaryQlClass() { result = "VarAccess" }
}

/**
 * An access to an extension receiver parameter. This is a parameter access that takes the form of `this` in Kotlin.
 */
class ExtensionReceiverAccess extends VarAccess {
  ExtensionReceiverAccess() {
    exists(Parameter p |
      this.getVariable() = p and
      p.isExtensionParameter()
    )
  }

  override string getAPrimaryQlClass() { result = "ExtensionReceiverAccess" }

  override string toString() { result = "this" }
}

/**
 * A write access to a variable, which occurs as the destination of an assignment.
 *
 * This does not cover the initialization of local variables at their declaration,
 * use the class `VariableUpdate` if you want to cover that as well.
 */
class VarWrite extends VarAccess {
  VarWrite() { this.isVarWrite() }

  /**
   * Gets a source of the assignment that executes this variable write.
   *
   * For assignments using the `=` operator, the source expression
   * is simply the RHS of the assignment.
   *
   * Note that for writes occurring on the LHS of compound assignment operators
   * (such as (`+=`), both the RHS and the LHS of the compound assignment
   * are source expressions of the assignment.
   */
  Expr getASource() { exists(Assignment e | e.getDest() = this and e.getSource() = result) }
}

/**
 * A read access to a variable.
 *
 * In other words, it is a variable access that does _not_ occur as the destination of
 * a simple assignment, but it may occur as the destination of a compound assignment
 * or a unary assignment.
 */
class VarRead extends VarAccess {
  VarRead() { this.isVarRead() }
}

/** A method call is an invocation of a method with a list of arguments. */
class MethodCall extends Expr, Call, @methodaccess {
  /** Gets the qualifying expression of this method access, if any. */
  override Expr getQualifier() { result.isNthChildOf(this, -1) }

  /** Holds if this method access has a qualifier. */
  predicate hasQualifier() { exists(this.getQualifier()) }

  /** Gets an argument supplied to the method that is invoked using this method access. */
  override Expr getAnArgument() { result.getIndex() >= 0 and result.getParent() = this }

  /** Gets the argument at the specified (zero-based) position in this method access. */
  override Expr getArgument(int index) { exprs(result, _, _, this, index) and index >= 0 }

  /** Gets a type argument supplied as part of this method access, if any. */
  Expr getATypeArgument() { result.getIndex() <= -2 and result.getParent() = this }

  /** Gets the type argument at the specified (zero-based) position in this method access, if any. */
  Expr getTypeArgument(int index) {
    result = this.getATypeArgument() and
    (-2 - result.getIndex()) = index
  }

  /** Gets the method accessed by this method access. */
  Method getMethod() { callableBinding(this, result) }

  /** Gets the immediately enclosing callable that contains this method access. */
  override Callable getEnclosingCallable() { result = Expr.super.getEnclosingCallable() }

  /** Gets the immediately enclosing statement that contains this method access. */
  override Stmt getEnclosingStmt() { result = Expr.super.getEnclosingStmt() }

  /** Gets a printable representation of this expression. */
  override string toString() {
    if exists(this.getMethod())
    then result = this.printAccess()
    else result = "<Call to unknown method>"
  }

  /** Gets a printable representation of this expression. */
  string printAccess() { result = this.getMethod().getName() + "(...)" }

  /**
   * Gets the type of the qualifier on which this method is invoked, or
   * the enclosing type if there is no qualifier.
   */
  RefType getReceiverType() {
    result = this.getQualifier().getType()
    or
    not this.hasQualifier() and result = this.getEnclosingCallable().getDeclaringType()
  }

  /**
   * Holds if this is a method call to an instance method of `this`. That is,
   * the qualifier is either an explicit or implicit unqualified `this` or `super`.
   */
  predicate isOwnMethodCall() { Qualifier::ownMemberAccess(this) }

  /**
   * Holds if this is a method call to an instance method of the enclosing
   * class `t`. That is, the qualifier is either an explicit or implicit
   * `t`-qualified `this` or `super`.
   */
  predicate isEnclosingMethodCall(RefType t) { Qualifier::enclosingMemberAccess(this, t) }

  override string getAPrimaryQlClass() { result = "MethodCall" }
}

/** A type access is a (possibly qualified) reference to a type. */
class TypeAccess extends Expr, Annotatable, @typeaccess {
  /** Gets the qualifier of this type access, if any. */
  Expr getQualifier() { result.isNthChildOf(this, -1) }

  /** Holds if this type access has a qualifier. */
  predicate hasQualifier() { exists(this.getQualifier()) }

  /** Gets a type argument supplied to this type access. */
  Expr getATypeArgument() { result.getIndex() >= 0 and result.getParent() = this }

  /** Gets the type argument at the specified (zero-based) position in this type access. */
  Expr getTypeArgument(int index) {
    result = this.getATypeArgument() and
    result.getIndex() = index
  }

  /** Holds if this type access has a type argument. */
  predicate hasTypeArgument() { exists(this.getATypeArgument()) }

  /** Gets the compilation unit in which this type access occurs. */
  override CompilationUnit getCompilationUnit() { result = Expr.super.getCompilationUnit() }

  private string toNormalString() {
    result = this.getQualifier().toString() + "." + this.getType().toString()
    or
    not this.hasQualifier() and result = this.getType().toString()
  }

  /** Gets a printable representation of this expression. */
  override string toString() {
    if this.getType() instanceof ErrorType
    then result = "<TypeAccess of ErrorType>"
    else result = this.toNormalString()
  }

  override string getAPrimaryQlClass() { result = "TypeAccess" }
}

/** An array type access is a type access of the form `String[]`. */
class ArrayTypeAccess extends Expr, @arraytypeaccess {
  /**
   * Gets the expression representing the component type of this array type access.
   *
   * For example, in the array type access `String[][]`,
   * the component type is `String[]` and the
   * element type is `String`.
   */
  Expr getComponentName() { result.getParent() = this }

  /** Gets a printable representation of this expression. */
  override string toString() { result = "...[]" }

  override string getAPrimaryQlClass() { result = "ArrayTypeAccess" }
}

/**
 * A union type access is a type access of the form `T1 | T2`.
 *
 * Such a type access can only occur in a multi-catch clause.
 */
class UnionTypeAccess extends Expr, @uniontypeaccess {
  /** One of the alternatives in the union type access. */
  Expr getAnAlternative() { result.getParent() = this }

  /** Gets a printable representation of this expression. */
  override string toString() { result = "...|..." }

  override string getAPrimaryQlClass() { result = "UnionTypeAccess" }
}

/**
 * An intersection type access expression is a type access
 * of the form `T0 & T1 & ... & Tn`,
 * where `T0` is a class or interface type and
 * `T1, ..., Tn` are interface types.
 *
 * An intersection type access _expression_ can only
 * occur in a cast expression.
 *
 * Note that intersection types can also occur as the bound
 * of a bounded type, such as a type variable. Each component
 * of such a bound is represented by the QL class `TypeBound`.
 */
class IntersectionTypeAccess extends Expr, @intersectiontypeaccess {
  /**
   * One of the bounds of this intersection type access expression.
   *
   * For example, in the intersection type access expression
   * `Runnable & Cloneable`, both `Runnable`
   * and `Cloneable` are bounds.
   */
  Expr getABound() { result.getParent() = this }

  /**
   * Gets the bound at a specified (zero-based) position in this intersection type access expression.
   *
   * For example, in the intersection type access expression
   * `Runnable & Cloneable`, the bound at position 0 is
   * `Runnable` and the bound at position 1 is `Cloneable`.
   */
  Expr getBound(int index) { result.isNthChildOf(this, index) }

  /** Gets a printable representation of this expression. */
  override string toString() { result = "...&..." }

  override string getAPrimaryQlClass() { result = "IntersectionTypeAccess" }
}

/** A package access. */
class PackageAccess extends Expr, @packageaccess {
  /** Gets a printable representation of this expression. */
  override string toString() { result = "package" }

  override string getAPrimaryQlClass() { result = "PackageAccess" }
}

/** A wildcard type access, which may have either a lower or an upper bound. */
class WildcardTypeAccess extends Expr, @wildcardtypeaccess {
  /** Gets the upper bound of this wildcard type access, if any. */
  Expr getUpperBound() { result.isNthChildOf(this, 0) }

  /** Gets the lower bound of this wildcard type access, if any. */
  Expr getLowerBound() { result.isNthChildOf(this, 1) }

  /** Holds if this wildcard is not bounded by any type bounds. */
  predicate hasNoBound() { not exists(TypeAccess t | t.getParent() = this) }

  /** Gets a printable representation of this expression. */
  override string toString() { result = "? ..." }

  override string getAPrimaryQlClass() { result = "WildcardTypeAccess" }
}

/**
 * Any call to a callable.
 *
 * This includes method calls, constructor and super constructor invocations,
 * and constructors invoked through class instantiation.
 */
class Call extends ExprParent, @caller {
  /** Gets an argument supplied in this call. */
  /*abstract*/ Expr getAnArgument() { none() }

  /** Gets the argument specified at the (zero-based) position in this call. */
  /*abstract*/ Expr getArgument(int n) { none() }

  /** Gets the immediately enclosing callable that contains this call. */
  /*abstract*/ Callable getEnclosingCallable() { none() }

  /** Gets the qualifying expression of this call, if any. */
  /*abstract*/ Expr getQualifier() { none() }

  /** Gets the enclosing statement of this call. */
  /*abstract*/ Stmt getEnclosingStmt() { none() }

  /** Gets the number of arguments provided in this call. */
  int getNumArgument() { count(this.getAnArgument()) = result }

  /** Gets the target callable of this call. */
  Callable getCallee() { callableBinding(this, result) }

  /** Gets the callable invoking this call. */
  Callable getCaller() { result = this.getEnclosingCallable() }
}

/** A polymorphic call to an instance method. */
class VirtualMethodCall extends MethodCall {
  VirtualMethodCall() {
    this.getMethod().isVirtual() and
    not this.getQualifier() instanceof SuperAccess
  }
}

/** A static method call. */
class StaticMethodCall extends MethodCall {
  StaticMethodCall() { this.getMethod().isStatic() }
}

/** A call to a method in the superclass. */
class SuperMethodCall extends MethodCall {
  SuperMethodCall() { this.getQualifier() instanceof SuperAccess }
}

/**
 * A constructor call, which occurs either as a constructor invocation inside a
 * constructor, or as part of a class instance expression.
 */
abstract class ConstructorCall extends Call {
  /** Gets the target constructor of the class being instantiated. */
  abstract Constructor getConstructor();

  /** Holds if this constructor call is an explicit call to `this(...)`. */
  predicate callsThis() { this instanceof ThisConstructorInvocationStmt }

  /** Holds if this constructor call is an explicit call to `super(...)`. */
  predicate callsSuper() { this instanceof SuperConstructorInvocationStmt }

  /** Gets the type of the object instantiated by this constructor call. */
  RefType getConstructedType() { result = this.getConstructor().getDeclaringType() }
}

/** An expression that accesses a field. */
class FieldAccess extends VarAccess {
  FieldAccess() { this.getVariable() instanceof Field }

  /** Gets the field accessed by this field access expression. */
  Field getField() { this.getVariable() = result }

  /** Gets the immediately enclosing callable that contains this field access expression. */
  Callable getSite() { this.getEnclosingCallable() = result }

  /**
   * Holds if this is a field access to an instance field of `this`. That is,
   * the qualifier is either an explicit or implicit unqualified `this` or `super`.
   */
  predicate isOwnFieldAccess() { Qualifier::ownMemberAccess(this) }

  /**
   * Holds if this is a field access to an instance field of the enclosing
   * class `t`. That is, the qualifier is either an explicit or implicit
   * `t`-qualified `this` or `super`.
   */
  predicate isEnclosingFieldAccess(RefType t) { Qualifier::enclosingMemberAccess(this, t) }
}

private module Qualifier {
  /** A type qualifier for an `InstanceAccess`. */
  private newtype TThisQualifier =
    TThis() or
    TEnclosing(RefType t)

  /** An expression that accesses a member. That is, either a `FieldAccess` or a `MethodCall`. */
  class MemberAccess extends Expr {
    MemberAccess() {
      this instanceof FieldAccess or
      this instanceof MethodCall
    }

    /** Gets the member accessed by this member access. */
    Member getMember() {
      result = this.(FieldAccess).getField() or
      result = this.(MethodCall).getMethod()
    }

    /** Gets the qualifier of this member access, if any. */
    Expr getQualifier() {
      result = this.(FieldAccess).getQualifier() or
      result = this.(MethodCall).getQualifier()
    }
  }

  /**
   * Gets the implicit type qualifier of the implicit `ThisAccess` qualifier of
   * an access to `m` from within `ic`, which does not itself inherit `m`.
   */
  private RefType getImplicitEnclosingQualifier(InnerClass ic, Member m) {
    exists(RefType enclosing | enclosing = ic.getEnclosingType() |
      if enclosing.inherits(m)
      then result = enclosing
      else result = getImplicitEnclosingQualifier(enclosing, m)
    )
  }

  /**
   * Gets the implicit type qualifier of the implicit `ThisAccess` qualifier of `ma`.
   */
  private TThisQualifier getImplicitQualifier(MemberAccess ma) {
    exists(Member m | m = ma.getMember() |
      not m.isStatic() and
      not exists(ma.getQualifier()) and
      exists(RefType t | t = ma.getEnclosingCallable().getDeclaringType() |
        not t instanceof InnerClass and result = TThis()
        or
        exists(InnerClass ic | ic = t |
          if ic.inherits(m)
          then result = TThis()
          else result = TEnclosing(getImplicitEnclosingQualifier(ic, m))
        )
      )
    )
  }

  /**
   * Gets the type qualifier of the `InstanceAccess` qualifier of `ma`.
   */
  private TThisQualifier getThisQualifier(MemberAccess ma) {
    result = getImplicitQualifier(ma)
    or
    exists(Expr q |
      not ma.getMember().isStatic() and
      q = ma.getQualifier()
    |
      exists(InstanceAccess ia | ia = q and ia.isOwnInstanceAccess() and result = TThis())
      or
      exists(InstanceAccess ia, RefType qt |
        ia = q and ia.isEnclosingInstanceAccess(qt) and result = TEnclosing(qt)
      )
    )
  }

  /**
   * Holds if `ma` is a member access to an instance field or method of `this`. That is,
   * the qualifier is either an explicit or implicit unqualified `this` or `super`.
   */
  predicate ownMemberAccess(MemberAccess ma) { TThis() = getThisQualifier(ma) }

  /**
   * Holds if `ma` is a member access to an instance field or method of the enclosing
   * class `t`. That is, the qualifier is either an explicit or implicit
   * `t`-qualified `this` or `super`.
   */
  predicate enclosingMemberAccess(MemberAccess ma, RefType t) {
    TEnclosing(t) = getThisQualifier(ma)
  }
}

/** An expression that assigns a value to a field. */
class FieldWrite extends FieldAccess, VarWrite { }

/** An expression that reads a field. */
class FieldRead extends FieldAccess, VarRead { }

private predicate hasInstantiation(RefType t) {
  t instanceof TypeVariable or
  t instanceof Wildcard or
  hasInstantiation(t.(Array).getComponentType()) or
  hasInstantiation(t.(ParameterizedType).getATypeArgument())
}

/** An argument to a call. */
class Argument extends Expr {
  Call call;
  int pos;

  Argument() { call.getArgument(pos) = this }

  /** Gets the call that has this argument. */
  Call getCall() { result = call }

  /** Gets the position of this argument. */
  int getPosition() { result = pos }

  /**
   * Holds if this argument is an array of the appropriate type passed to a
   * varargs parameter.
   */
  predicate isExplicitVarargsArray() {
    exists(Array typ, Parameter p, Type ptyp |
      typ = this.getType() and
      call.getCallee().getParameter(pos) = p and
      p.isVarargs() and
      ptyp = p.getType() and
      (
        hasDescendant(ptyp, typ)
        or
        // If the types don't match then we'll guess based on whether there are type variables involved.
        hasInstantiation(ptyp.(Array).getComponentType())
      )
    )
  }

  /** Holds if this argument is part of an implicit varargs array. */
  predicate isVararg() { this.isNthVararg(_) }

  /**
   * Holds if this argument is part of an implicit varargs array at the
   * given array index.
   */
  predicate isNthVararg(int arrayindex) {
    not this.isExplicitVarargsArray() and
    exists(Callable tgt |
      call.getCallee() = tgt and
      arrayindex = pos - tgt.getVaragsParameterIndex() and
      arrayindex >= 0 and
      arrayindex <= call.getNumArgument() - tgt.getNumberOfParameters()
    )
  }

  /**
   * Gets the parameter position that will receive this argument.
   *
   * For all vararg arguments, this is the position of the vararg array parameter.
   */
  int getParameterPos() {
    exists(Callable c | c = call.getCallee() |
      if c.isVarargs()
      then
        if pos < c.getVaragsParameterIndex()
        then result = pos // Vararg method argument, before the vararg parameter
        else (
          if this.isVararg()
          then result = c.getVaragsParameterIndex() // Part of the implicit vararg array
          else result = pos - (call.getNumArgument() - c.getNumberOfParameters()) // Vararg method argument, after the vararg parameter (offset could be -1 in the zero-vararg case)
        )
      else result = pos // Not a vararg method
    )
  }
}

/**
 * An expression for which the value of the expression as a whole is discarded. Only cases
 * of discarded values at the language level (as described by the JLS) are considered;
 * data flow, for example to determine if an assigned variable value is ever read, is not
 * considered. Such expressions can for example appear as part of an `ExprStmt` or as
 * initializer of a `for` loop.
 *
 * For example, for the statement `i++;` the value of the increment expression, that is the
 * old value of variable `i`, is discarded. Whereas for the statement `println(i++);` the
 * value of the increment expression is not discarded but used as argument for the method call.
 */
class ValueDiscardingExpr extends Expr {
  ValueDiscardingExpr() {
    (
      this = any(ExprStmt s).getExpr()
      or
      this = any(ForStmt s).getAnInit() and not this instanceof LocalVariableDeclExpr
      or
      this = any(ForStmt s).getAnUpdate()
      or
      // Only applies to SwitchStmt, but not to SwitchExpr, see JLS 17 section 14.11.2
      this = any(SwitchStmt s).getACase().getRuleExpression()
      or
      // TODO: Workarounds for https://github.com/github/codeql/issues/3605
      exists(LambdaExpr lambda |
        this = lambda.getExprBody() and
        lambda.asMethod().getReturnType() instanceof VoidType
      )
      or
      exists(MemberRefExpr memberRef, Method implicitMethod, Method overridden |
        implicitMethod = memberRef.asMethod()
      |
        this.getParent().(ReturnStmt).getEnclosingCallable() = implicitMethod and
        // asMethod() has bogus method with wrong return type as result, e.g. `run(): String` (overriding `Runnable.run(): void`)
        // Therefore need to check the overridden method
        implicitMethod.getSourceDeclaration().overridesOrInstantiates*(overridden) and
        overridden.getReturnType() instanceof VoidType
      )
    ) and
    // Ignore if this expression is a method call with `void` as return type
    not this.getType() instanceof VoidType
  }
}

/** A Kotlin `when` expression. */
class WhenExpr extends Expr, StmtParent, @whenexpr {
  override string toString() { result = "when ..." }

  override string getHalsteadID() { result = "WhenExpr" }

  override string getAPrimaryQlClass() { result = "WhenExpr" }

  /** Gets the `i`th branch. */
  WhenBranch getBranch(int i) { result.isNthChildOf(this, i) }

  /** Holds if this was written as an `if` expression. */
  predicate isIf() { when_if(this) }
}

/** A Kotlin `when` branch. */
class WhenBranch extends Stmt, @whenbranch {
  /** Gets the condition of this branch. */
  Expr getCondition() { result.isNthChildOf(this, 0) }

  /** Gets the result of this branch. */
  Stmt getRhs() { result.isNthChildOf(this, 1) }

  /** Gets a result expression of this `when` branch. */
  Expr getAResult() { result = getAResult(this.getRhs()) }

  /** Holds if this is an `else` branch. */
  predicate isElseBranch() { when_branch_else(this) }

  /** Gets the `when` expression this is a branch of. */
  WhenExpr getWhenExpr() { this = result.getBranch(_) }

  override string toString() { result = "... -> ..." }

  override string getAPrimaryQlClass() { result = "WhenBranch" }
}

// TODO: This might need more cases. It might be better as a predicate
// on Stmt, overridden in each subclass.
private Expr getAResult(Stmt s) {
  result = s.(ExprStmt).getExpr() or
  result = getAResult(s.(BlockStmt).getLastStmt())
}

/** A Kotlin `::class` expression. */
class ClassExpr extends Expr, @getclassexpr {
  /** Gets the expression whose class is being returned. */
  Expr getExpr() { result.isNthChildOf(this, 0) }

  override string toString() { result = "::class" }

  override string getAPrimaryQlClass() { result = "ClassExpr" }
}

/**
 * A statement expression.
 *
 * In some contexts, a Kotlin expression can contain a statement.
 */
class StmtExpr extends Expr, @stmtexpr {
  /** Gets the statement of this statement expression. */
  Stmt getStmt() { result.getParent() = this }

  override string toString() { result = "<Stmt>" }

  override string getHalsteadID() { result = "StmtExpr" }

  override string getAPrimaryQlClass() { result = "StmtExpr" }

  /**
   * Gets the result expression of the enclosed statement.
   */
  Expr getResultExpr() { result = getStmtResultExpr(this.getStmt()) }
}

private Expr getStmtResultExpr(Stmt stmt) {
  result = stmt.(ExprStmt).getExpr() or
  result = getStmtResultExpr(stmt.(BlockStmt).getLastStmt())
}

/**
 * A Kotlin string template expression. For example, `"foo${bar}baz"`.
 */
class StringTemplateExpr extends Expr, @stringtemplateexpr {
  /**
   * Gets the `i`th component of this string template.
   *
   * For example, in the string template `"foo${bar}baz"`, the 0th
   * component is the string literal `"foo"`, the 1st component is
   * the variable access `bar`, and the 2nd component is the string
   * literal `"bar"`.
   */
  Expr getComponent(int i) { result.isNthChildOf(this, i) }

  override string toString() { result = "\"...\"" }

  override string getHalsteadID() { result = "StringTemplateExpr" }

  override string getAPrimaryQlClass() { result = "StringTemplateExpr" }
}

/** A Kotlin not-null expression. For example, `expr!!`. */
class NotNullExpr extends UnaryExpr, @notnullexpr {
  override string toString() { result = "...!!" }

  override string getAPrimaryQlClass() { result = "NotNullExpr" }
}

/**
 * A binding, unnamed or record pattern.
 *
 * Note binding and unnamed patterns are represented as `LocalVariableDeclExpr`s.
 */
class PatternExpr extends Expr {
  PatternExpr() {
    (
      this.getParent() instanceof SwitchCase or
      this.getParent() instanceof InstanceOfExpr or
      this.getParent() instanceof RecordPatternExpr
    ) and
    (this instanceof LocalVariableDeclExpr or this instanceof RecordPatternExpr)
  }

  /**
   * Gets this pattern cast to a binding or unnamed pattern.
   */
  LocalVariableDeclExpr asBindingOrUnnamedPattern() { result = this }

  /**
   * DEPRECATED: alias for `asBindingOrUnnamedPattern`.
   */
  deprecated LocalVariableDeclExpr asBindingPattern() { result = this.asBindingOrUnnamedPattern() }

  /**
   * Gets this pattern cast to a record pattern.
   */
  RecordPatternExpr asRecordPattern() { result = this }
}

/** A record pattern expr, as in `if (x instanceof SomeRecord(int field))`. */
class RecordPatternExpr extends Expr, @recordpatternexpr {
  override string toString() { result = this.getType().toString() + "(...)" }

  override string getAPrimaryQlClass() { result = "RecordPatternExpr" }

  /**
   * Gets the `i`th subpattern of this record pattern.
   */
  PatternExpr getSubPattern(int i) { result.isNthChildOf(this, i) }

  /**
   * Holds if this record pattern matches any record of its type.
   *
   * For example, for `record R(Object o) { }`, pattern `R(Object o)` is unrestricted, whereas
   * pattern `R(String s)` is not because it matches a subset of `R` instances, those containing `String`s.
   */
  predicate isUnrestricted() {
    forall(PatternExpr subPattern, int idx | subPattern = this.getSubPattern(idx) |
      subPattern.getType() =
        this.getType().(Record).getCanonicalConstructor().getParameter(idx).getType() and
      (
        subPattern instanceof LocalVariableDeclExpr
        or
        subPattern.(RecordPatternExpr).isUnrestricted()
      )
    )
  }

  /**
   * Holds if this record pattern declares any identifiers (i.e., at least one leaf declaration is named).
   */
  predicate declaresAnyIdentifiers() {
    exists(PatternExpr subPattern | subPattern = this.getSubPattern(_) |
      subPattern.asRecordPattern().declaresAnyIdentifiers() or
      not subPattern.asBindingOrUnnamedPattern().isAnonymous()
    )
  }
}
