/**
 * Provides classes for working with Java expressions.
 */

import Member
import Type
import Variable
import Statement

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

  /**
   * DEPRECATED: This is no longer necessary. See `Expr.isParenthesized()`.
   *
   * Gets this expression with any surrounding parentheses removed.
   */
  deprecated Expr getProperExpr() {
    result = this.(ParExpr).getExpr().getProperExpr()
    or
    result = this and not this instanceof ParExpr
  }

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
  BasicBlock getBasicBlock() { result.getANode() = this }

  /** Gets the `ControlFlowNode` corresponding to this expression. */
  ControlFlowNode getControlFlowNode() { result = this }

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

    getEnclosingCallable().isStatic()
    or
    getParent+() instanceof ThisConstructorInvocationStmt
    or
    getParent+() instanceof SuperConstructorInvocationStmt
    or
    exists(LambdaExpr lam | lam.asMethod() = getEnclosingCallable() and lam.isInStaticContext())
  }

  /** Holds if this expression is parenthesized. */
  predicate isParenthesized() { isParenthesized(this, _) }
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
    primitiveOrString(getType()) and
    (
      // Literals of primitive type and literals of type `String`.
      this instanceof Literal
      or
      // Casts to primitive types and casts to type `String`.
      this.(CastExpr).getExpr().isCompileTimeConstant()
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
    )
  }

  /**
   * Gets the string value of this expression, where possible.
   */
  pragma[nomagic]
  string getStringValue() {
    result = this.(StringLiteral).getRepresentedString()
    or
    result =
      this.(AddExpr).getLeftOperand().(CompileTimeConstantExpr).getStringValue() +
        this.(AddExpr).getRightOperand().(CompileTimeConstantExpr).getStringValue()
    or
    // Ternary conditional, with compile-time constant condition.
    exists(ConditionalExpr ce, boolean condition |
      ce = this and
      condition = ce.getCondition().(CompileTimeConstantExpr).getBooleanValue()
    |
      if condition = true
      then result = ce.getTrueExpr().(CompileTimeConstantExpr).getStringValue()
      else result = ce.getFalseExpr().(CompileTimeConstantExpr).getStringValue()
    )
    or
    exists(Variable v | this = v.getAnAccess() |
      result = v.getInitializer().(CompileTimeConstantExpr).getStringValue()
    )
  }

  /**
   * Gets the boolean value of this expression, where possible.
   */
  boolean getBooleanValue() {
    // Literal value.
    result = this.(BooleanLiteral).getBooleanValue()
    or
    // No casts relevant to booleans.
    // `!` is the only unary operator that evaluates to a boolean.
    result = this.(LogNotExpr).getExpr().(CompileTimeConstantExpr).getBooleanValue().booleanNot()
    or
    // Handle binary expressions that have integer operands and a boolean result.
    exists(BinaryExpr b, int left, int right |
      b = this and
      left = b.getLeftOperand().(CompileTimeConstantExpr).getIntValue() and
      right = b.getRightOperand().(CompileTimeConstantExpr).getIntValue()
    |
      (
        b instanceof LTExpr and
        if left < right then result = true else result = false
      )
      or
      (
        b instanceof LEExpr and
        if left <= right then result = true else result = false
      )
      or
      (
        b instanceof GTExpr and
        if left > right then result = true else result = false
      )
      or
      (
        b instanceof GEExpr and
        if left >= right then result = true else result = false
      )
      or
      (
        b instanceof EQExpr and
        if left = right then result = true else result = false
      )
      or
      (
        b instanceof NEExpr and
        if left != right then result = true else result = false
      )
    )
    or
    // Handle binary expressions that have boolean operands and a boolean result.
    exists(BinaryExpr b, boolean left, boolean right |
      b = this and
      left = b.getLeftOperand().(CompileTimeConstantExpr).getBooleanValue() and
      right = b.getRightOperand().(CompileTimeConstantExpr).getBooleanValue()
    |
      (
        b instanceof EQExpr and
        if left = right then result = true else result = false
      )
      or
      (
        b instanceof NEExpr and
        if left != right then result = true else result = false
      )
      or
      (b instanceof AndBitwiseExpr or b instanceof AndLogicalExpr) and
      result = left.booleanAnd(right)
      or
      (b instanceof OrBitwiseExpr or b instanceof OrLogicalExpr) and
      result = left.booleanOr(right)
      or
      b instanceof XorBitwiseExpr and result = left.booleanXor(right)
    )
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
       */

      (
        b instanceof EQExpr and
        if left = right then result = true else result = false
      )
      or
      (
        b instanceof NEExpr and
        if left != right then result = true else result = false
      )
    )
    or
    // Note: no `getFloatValue()`, so we cannot support binary expressions with float or double operands.
    // Ternary expressions, where the `true` and `false` expressions are boolean compile-time constants.
    exists(ConditionalExpr ce, boolean condition |
      ce = this and
      condition = ce.getCondition().(CompileTimeConstantExpr).getBooleanValue()
    |
      if condition = true
      then result = ce.getTrueExpr().(CompileTimeConstantExpr).getBooleanValue()
      else result = ce.getFalseExpr().(CompileTimeConstantExpr).getBooleanValue()
    )
    or
    // Simple or qualified names where the variable is final and the initializer is a constant.
    exists(Variable v | this = v.getAnAccess() |
      result = v.getInitializer().(CompileTimeConstantExpr).getBooleanValue()
    )
  }

  /**
   * Gets the integer value of this expression, where possible.
   *
   * Note that this does not handle the following cases:
   *
   * - values of type `long`,
   * - `char` literals.
   */
  cached
  int getIntValue() {
    exists(IntegralType t | this.getType() = t | t.getName().toLowerCase() != "long") and
    (
      exists(string lit | lit = this.(Literal).getValue() |
        // `char` literals may get parsed incorrectly, so disallow.
        not this instanceof CharacterLiteral and
        result = lit.toInt()
      )
      or
      exists(CastExpr cast, int val |
        cast = this and val = cast.getExpr().(CompileTimeConstantExpr).getIntValue()
      |
        if cast.getType().hasName("byte")
        then result = (val + 128).bitAnd(255) - 128
        else
          if cast.getType().hasName("short")
          then result = (val + 32768).bitAnd(65535) - 32768
          else
            if cast.getType().hasName("char")
            then result = val.bitAnd(65535)
            else result = val
      )
      or
      result = this.(PlusExpr).getExpr().(CompileTimeConstantExpr).getIntValue()
      or
      result = -this.(MinusExpr).getExpr().(CompileTimeConstantExpr).getIntValue()
      or
      result = this.(BitNotExpr).getExpr().(CompileTimeConstantExpr).getIntValue().bitNot()
      or
      // No `int` value for `LogNotExpr`.
      exists(BinaryExpr b, int v1, int v2 |
        b = this and
        v1 = b.getLeftOperand().(CompileTimeConstantExpr).getIntValue() and
        v2 = b.getRightOperand().(CompileTimeConstantExpr).getIntValue()
      |
        b instanceof MulExpr and result = v1 * v2
        or
        b instanceof DivExpr and result = v1 / v2
        or
        b instanceof RemExpr and result = v1 % v2
        or
        b instanceof AddExpr and result = v1 + v2
        or
        b instanceof SubExpr and result = v1 - v2
        or
        b instanceof LShiftExpr and result = v1.bitShiftLeft(v2)
        or
        b instanceof RShiftExpr and result = v1.bitShiftRightSigned(v2)
        or
        b instanceof URShiftExpr and result = v1.bitShiftRight(v2)
        or
        b instanceof AndBitwiseExpr and result = v1.bitAnd(v2)
        or
        b instanceof OrBitwiseExpr and result = v1.bitOr(v2)
        or
        b instanceof XorBitwiseExpr and result = v1.bitXor(v2)
        // No `int` value for `AndLogicalExpr` or `OrLogicalExpr`.
        // No `int` value for `LTExpr`, `GTExpr`, `LEExpr`, `GEExpr`, `EQExpr` or `NEExpr`.
      )
      or
      // Ternary conditional, with compile-time constant condition.
      exists(ConditionalExpr ce, boolean condition |
        ce = this and
        condition = ce.getCondition().(CompileTimeConstantExpr).getBooleanValue()
      |
        if condition = true
        then result = ce.getTrueExpr().(CompileTimeConstantExpr).getIntValue()
        else result = ce.getFalseExpr().(CompileTimeConstantExpr).getIntValue()
      )
      or
      // If a `Variable` is a `CompileTimeConstantExpr`, its value is its initializer.
      exists(Variable v | this = v.getAnAccess() |
        result = v.getInitializer().(CompileTimeConstantExpr).getIntValue()
      )
    )
  }
}

/** An expression parent is an element that may have an expression as its child. */
class ExprParent extends @exprparent, Top { }

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

  /** Gets the initializer of this array creation expression. */
  ArrayInit getInit() { result.isNthChildOf(this, -2) }

  /**
   * Gets the size of the first dimension, if it can be statically determined.
   */
  int getFirstDimensionSize() {
    if exists(getInit())
    then result = count(getInit().getAnInit())
    else result = getDimension(0).(CompileTimeConstantExpr).getIntValue()
  }

  /** Gets a printable representation of this expression. */
  override string toString() { result = "new " + this.getType().toString() }

  override string getAPrimaryQlClass() { result = "ArrayCreationExpr" }
}

/** An array initializer occurs in an array creation expression. */
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

  /** Gets a printable representation of this expression. */
  override string toString() { result = "{...}" }

  override string getAPrimaryQlClass() { result = "ArrayInit" }
}

/** A common super-class that represents all varieties of assignments. */
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
class AssignLShiftExpr extends AssignOp, @assignlshiftexpr {
  override string getOp() { result = "<<=" }

  override string getAPrimaryQlClass() { result = "AssignLShiftExpr" }
}

/** A compound assignment expression using the `>>=` operator. */
class AssignRShiftExpr extends AssignOp, @assignrshiftexpr {
  override string getOp() { result = ">>=" }

  override string getAPrimaryQlClass() { result = "AssignRShiftExpr" }
}

/** A compound assignment expression using the `>>>=` operator. */
class AssignURShiftExpr extends AssignOp, @assignurshiftexpr {
  override string getOp() { result = ">>>=" }

  override string getAPrimaryQlClass() { result = "AssignURShiftExpr" }
}

/** A common super-class to represent constant literals. */
class Literal extends Expr, @literal {
  /** Gets a string representation of this literal. */
  string getLiteral() { namestrings(result, _, this) }

  /** Gets a string representation of the value of this literal. */
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
    result = true and getLiteral() = "true"
    or
    result = false and getLiteral() = "false"
  }

  override string getAPrimaryQlClass() { result = "BooleanLiteral" }
}

/** An integer literal. For example, `23`. */
class IntegerLiteral extends Literal, @integerliteral {
  /** Gets the int representation of this literal. */
  int getIntValue() { result = getValue().toInt() }

  override string getAPrimaryQlClass() { result = "IntegerLiteral" }
}

/** A long literal. For example, `23l`. */
class LongLiteral extends Literal, @longliteral {
  override string getAPrimaryQlClass() { result = "LongLiteral" }
}

/** A floating point literal. For example, `4.2f`. */
class FloatingPointLiteral extends Literal, @floatingpointliteral {
  override string getAPrimaryQlClass() { result = "FloatingPointLiteral" }
}

/** A double literal. For example, `4.2`. */
class DoubleLiteral extends Literal, @doubleliteral {
  override string getAPrimaryQlClass() { result = "DoubleLiteral" }
}

/** A character literal. For example, `'\n'`. */
class CharacterLiteral extends Literal, @characterliteral {
  override string getAPrimaryQlClass() { result = "CharacterLiteral" }
}

/** A string literal. For example, `"hello world"`. */
class StringLiteral extends Literal, @stringliteral {
  /**
   * Gets the literal string without the quotes.
   */
  string getRepresentedString() { result = getValue() }

  override string getAPrimaryQlClass() { result = "StringLiteral" }
}

/** The null literal, written `null`. */
class NullLiteral extends Literal, @nullliteral {
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
class LShiftExpr extends BinaryExpr, @lshiftexpr {
  override string getOp() { result = " << " }

  override string getAPrimaryQlClass() { result = "LShiftExpr" }
}

/** A binary expression using the `>>` operator. */
class RShiftExpr extends BinaryExpr, @rshiftexpr {
  override string getOp() { result = " >> " }

  override string getAPrimaryQlClass() { result = "RShiftExpr" }
}

/** A binary expression using the `>>>` operator. */
class URShiftExpr extends BinaryExpr, @urshiftexpr {
  override string getOp() { result = " >>> " }

  override string getAPrimaryQlClass() { result = "URShiftExpr" }
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

/** A binary expression using the `==` operator. */
class EQExpr extends BinaryExpr, @eqexpr {
  override string getOp() { result = " == " }

  override string getAPrimaryQlClass() { result = "EQExpr" }
}

/** A binary expression using the `!=` operator. */
class NEExpr extends BinaryExpr, @neexpr {
  override string getOp() { result = " != " }

  override string getAPrimaryQlClass() { result = "NEExpr" }
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
 * the `==` or `!=` operator.
 */
class EqualityTest extends BinaryExpr {
  EqualityTest() {
    this instanceof EQExpr or
    this instanceof NEExpr
  }

  /** Gets a boolean indicating whether this is `==` (true) or `!=` (false). */
  boolean polarity() {
    result = true and this instanceof EQExpr
    or
    result = false and this instanceof NEExpr
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

/** A cast expression. */
class CastExpr extends Expr, @castexpr {
  /** Gets the target type of this cast expression. */
  Expr getTypeExpr() { result.isNthChildOf(this, 0) }

  /** Gets the expression to which the cast operator is applied. */
  Expr getExpr() { result.isNthChildOf(this, 1) }

  /** Gets a printable representation of this expression. */
  override string toString() { result = "(...)..." }

  override string getAPrimaryQlClass() { result = "CastExpr" }
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
   * Gets a type argument provided to the constructor of this class instance creation expression.
   *
   * This is used for instantiations of parameterized classes.
   */
  Expr getATypeArgument() { result = this.getTypeName().(TypeAccess).getATypeArgument() }

  /**
   * Gets the type argument provided to the constructor of this class instance creation expression
   * at the specified (zero-based) position.
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
  override string toString() { result = "new " + this.getConstructor().getName() + "(...)" }

  override string getAPrimaryQlClass() { result = "ClassInstanceExpr" }
}

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
  override Method asMethod() { result = getAnonymousClass().getAMethod() }

  /** Holds if the body of this lambda is an expression. */
  predicate hasExprBody() { lambdaKind(this, 0) }

  /** Holds if the body of this lambda is a statement. */
  predicate hasStmtBody() { lambdaKind(this, 1) }

  /** Gets the body of this lambda expression, if it is an expression. */
  Expr getExprBody() {
    hasExprBody() and result = asMethod().getBody().getAChild().(ReturnStmt).getResult()
  }

  /** Gets the body of this lambda expression, if it is a statement. */
  BlockStmt getStmtBody() { hasStmtBody() and result = asMethod().getBody() }

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
  override Method asMethod() { result = getAnonymousClass().getAMethod() }

  /**
   * Gets the method or constructor referenced by this member reference expression.
   */
  Callable getReferencedCallable() { memberRefBinding(this, result) }

  /** Gets a printable representation of this expression. */
  override string toString() { result = "...::..." }

  override string getAPrimaryQlClass() { result = "MemberRefExpr" }
}

/** A conditional expression or a `switch` expression. */
class ChooseExpr extends Expr {
  ChooseExpr() { this instanceof ConditionalExpr or this instanceof SwitchExpr }

  /** Gets a result expression of this `switch` or conditional expression. */
  Expr getAResultExpr() {
    result = this.(ConditionalExpr).getTrueExpr() or
    result = this.(ConditionalExpr).getFalseExpr() or
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

  /** Gets a printable representation of this expression. */
  override string toString() { result = "...?...:..." }

  override string getAPrimaryQlClass() { result = "ConditionalExpr" }
}

/**
 * A `switch` expression.
 */
class SwitchExpr extends Expr, @switchexpr {
  /** Gets an immediate child statement of this `switch` expression. */
  Stmt getAStmt() { result.getParent() = this }

  /**
   * Gets the immediate child statement of this `switch` expression
   * that occurs at the specified (zero-based) position.
   */
  Stmt getStmt(int index) { result = this.getAStmt() and result.getIndex() = index }

  /**
   * Gets a case of this `switch` expression,
   * which may be either a normal `case` or a `default`.
   */
  SwitchCase getACase() { result = getAConstCase() or result = getDefaultCase() }

  /** Gets a (non-default) `case` of this `switch` expression. */
  ConstCase getAConstCase() { result.getParent() = this }

  /** Gets the `default` case of this switch expression, if any. */
  DefaultCase getDefaultCase() { result.getParent() = this }

  /** Gets the expression of this `switch` expression. */
  Expr getExpr() { result.getParent() = this }

  /** Gets a result expression of this `switch` expression. */
  Expr getAResult() {
    result = getACase().getRuleExpression()
    or
    exists(YieldStmt yield | yield.(JumpStmt).getTarget() = this and result = yield.getValue())
  }

  /** Gets a printable representation of this expression. */
  override string toString() { result = "switch (...)" }

  override string getAPrimaryQlClass() { result = "SwitchExpr" }
}

/**
 * DEPRECATED: Use `Expr.isParenthesized()` instead.
 *
 * A parenthesised expression.
 */
deprecated class ParExpr extends Expr, @parexpr {
  /** Gets the expression inside the parentheses. */
  deprecated Expr getExpr() { result.getParent() = this }

  /** Gets a printable representation of this expression. */
  override string toString() { result = "(...)" }
}

/** An `instanceof` expression. */
class InstanceOfExpr extends Expr, @instanceofexpr {
  /** Gets the expression on the left-hand side of the `instanceof` operator. */
  Expr getExpr() {
    if isPattern()
    then result = getLocalVariableDeclExpr().getInit()
    else result.isNthChildOf(this, 0)
  }

  /**
   * PREVIEW FEATURE in Java 14. Subject to removal in a future release.
   *
   * Holds if this `instanceof` expression uses pattern matching.
   */
  predicate isPattern() { exists(getLocalVariableDeclExpr()) }

  /**
   * PREVIEW FEATURE in Java 14. Subject to removal in a future release.
   *
   * Gets the local variable declaration of this `instanceof` expression if pattern matching is used.
   */
  LocalVariableDeclExpr getLocalVariableDeclExpr() { result.isNthChildOf(this, 0) }

  /** Gets the access to the type on the right-hand side of the `instanceof` operator. */
  Expr getTypeName() { result.isNthChildOf(this, 1) }

  /** Gets a printable representation of this expression. */
  override string toString() { result = "...instanceof..." }

  override string getAPrimaryQlClass() { result = "InstanceOfExpr" }
}

/**
 * A local variable declaration expression.
 *
 * Contexts in which such expressions may occur include
 * local variable declaration statements and `for` loops.
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
  }

  /** Gets the name of the variable declared by this local variable declaration expression. */
  string getName() { result = this.getVariable().getName() }

  /** Gets the initializer expression of this local variable declaration expression, if any. */
  Expr getInit() { result.isNthChildOf(this, 0) }

  /** Holds if this variable declaration implicitly initializes the variable. */
  predicate hasImplicitInit() {
    exists(CatchClause cc | cc.getVariable() = this) or
    exists(EnhancedForStmt efs | efs.getVariable() = this)
  }

  /** Gets a printable representation of this expression. */
  override string toString() { result = this.getName() }

  override string getAPrimaryQlClass() { result = "LocalVariableDeclExpr" }
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
 */
class VariableAssign extends VariableUpdate {
  VariableAssign() {
    this instanceof AssignExpr or
    this instanceof LocalVariableDeclExpr
  }

  /**
   * Gets the source (right-hand side) of this assignment, if any.
   *
   * An initialization in a `CatchClause` or `EnhancedForStmt` is implicit and
   * does not have a source.
   */
  Expr getSource() {
    result = this.(AssignExpr).getSource() or
    result = this.(LocalVariableDeclExpr).getInit()
  }
}

/** A type literal. For example, `String.class`. */
class TypeLiteral extends Expr, @typeliteral {
  /** Gets the access to the type whose class is accessed. */
  Expr getTypeName() { result.getParent() = this }

  /** Gets a printable representation of this expression. */
  override string toString() { result = this.getTypeName().toString() + ".class" }

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
  predicate isOwnInstanceAccess() { not isEnclosingInstanceAccess(_) }

  /** Holds if this instance access is to an enclosing instance of type `t`. */
  predicate isEnclosingInstanceAccess(RefType t) {
    t = getQualifier().getType().(RefType).getSourceDeclaration() and
    t != getEnclosingCallable().getDeclaringType()
    or
    not exists(getQualifier()) and
    exists(LambdaExpr lam | lam.asMethod() = getEnclosingCallable() |
      t = lam.getAnonymousClass().getEnclosingType()
    )
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
  predicate hasQualifier() { exists(getQualifier()) }

  /** Gets the variable accessed by this variable access. */
  Variable getVariable() { variableBinding(this, result) }

  /**
   * Holds if this variable access is an l-value.
   *
   * An l-value is a write access to a variable, which occurs as the destination of an assignment.
   */
  predicate isLValue() {
    exists(Assignment a | a.getDest() = this) or
    exists(UnaryAssignExpr e | e.getExpr() = this)
  }

  /**
   * Holds if this variable access is an r-value.
   *
   * An r-value is a read access to a variable.
   * In other words, it is a variable access that does _not_ occur as the destination of
   * a simple assignment, but it may occur as the destination of a compound assignment
   * or a unary assignment.
   */
  predicate isRValue() { not exists(AssignExpr a | a.getDest() = this) }

  /** Gets a printable representation of this expression. */
  override string toString() {
    exists(Expr q | q = this.getQualifier() |
      if q.isParenthesized()
      then result = "(...)." + this.getVariable().getName()
      else result = q.toString() + "." + this.getVariable().getName()
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
    not hasQualifier()
    or
    // the qualifier is either `this` or `A.this`, where `A` is the enclosing type, or
    // the qualifier is either `super` or `A.super`, where `A` is the enclosing type.
    getQualifier().(InstanceAccess).isOwnInstanceAccess()
  }

  override string getAPrimaryQlClass() { result = "VarAccess" }
}

/**
 * An l-value is a write access to a variable, which occurs as the destination of an assignment.
 */
class LValue extends VarAccess {
  LValue() { this.isLValue() }

  /**
   * Gets a source expression used in an assignment to this l-value.
   *
   * For assignments using the `=` operator, the source expression
   * is simply the RHS of the assignment.
   *
   * Note that for l-values occurring on the LHS of compound assignment operators
   * (such as (`+=`), both the RHS and the LHS of the compound assignment
   * are source expressions of the assignment.
   */
  Expr getRHS() { exists(Assignment e | e.getDest() = this and e.getSource() = result) }
}

/**
 * An r-value is a read access to a variable.
 *
 * In other words, it is a variable access that does _not_ occur as the destination of
 * a simple assignment, but it may occur as the destination of a compound assignment
 * or a unary assignment.
 */
class RValue extends VarAccess {
  RValue() { this.isRValue() }
}

/** A method access is an invocation of a method with a list of arguments. */
class MethodAccess extends Expr, Call, @methodaccess {
  /** Gets the qualifying expression of this method access, if any. */
  override Expr getQualifier() { result.isNthChildOf(this, -1) }

  /** Holds if this method access has a qualifier. */
  predicate hasQualifier() { exists(getQualifier()) }

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
  override string toString() { result = this.printAccess() }

  /** Gets a printable representation of this expression. */
  string printAccess() { result = this.getMethod().getName() + "(...)" }

  /**
   * Gets the type of the qualifier on which this method is invoked, or
   * the enclosing type if there is no qualifier.
   */
  RefType getReceiverType() {
    result = getQualifier().getType()
    or
    not hasQualifier() and result = getEnclosingCallable().getDeclaringType()
  }

  /**
   * Holds if this is a method access to an instance method of `this`. That is,
   * the qualifier is either an explicit or implicit unqualified `this` or `super`.
   */
  predicate isOwnMethodAccess() { Qualifier::ownMemberAccess(this) }

  /**
   * Holds if this is a method access to an instance method of the enclosing
   * class `t`. That is, the qualifier is either an explicit or implicit
   * `t`-qualified `this` or `super`.
   */
  predicate isEnclosingMethodAccess(RefType t) { Qualifier::enclosingMemberAccess(this, t) }

  override string getAPrimaryQlClass() { result = "MethodAccess" }
}

/** A type access is a (possibly qualified) reference to a type. */
class TypeAccess extends Expr, Annotatable, @typeaccess {
  /** Gets the qualifier of this type access, if any. */
  Expr getQualifier() { result.isNthChildOf(this, -1) }

  /** Holds if this type access has a qualifier. */
  predicate hasQualifier() { exists(Expr e | e = this.getQualifier()) }

  /** Gets a type argument supplied to this type access. */
  Expr getATypeArgument() { result.getIndex() >= 0 and result.getParent() = this }

  /** Gets the type argument at the specified (zero-based) position in this type access. */
  Expr getTypeArgument(int index) {
    result = this.getATypeArgument() and
    result.getIndex() = index
  }

  /** Holds if this type access has a type argument. */
  predicate hasTypeArgument() { exists(Expr e | e = this.getATypeArgument()) }

  /** Gets the compilation unit in which this type access occurs. */
  override CompilationUnit getCompilationUnit() { result = Expr.super.getCompilationUnit() }

  /** Gets a printable representation of this expression. */
  override string toString() {
    result = this.getQualifier().toString() + "." + this.getType().toString()
    or
    not this.hasQualifier() and result = this.getType().toString()
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
class Call extends Top, @caller {
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
  Callable getCaller() { result = getEnclosingCallable() }
}

/** A polymorphic call to an instance method. */
class VirtualMethodAccess extends MethodAccess {
  VirtualMethodAccess() {
    this.getMethod().isVirtual() and
    not this.getQualifier() instanceof SuperAccess
  }
}

/** A static method call. */
class StaticMethodAccess extends MethodAccess {
  StaticMethodAccess() { this.getMethod().isStatic() }
}

/** A call to a method in the superclass. */
class SuperMethodAccess extends MethodAccess {
  SuperMethodAccess() { this.getQualifier() instanceof SuperAccess }
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

  /** An expression that accesses a member. That is, either a `FieldAccess` or a `MethodAccess`. */
  class MemberAccess extends Expr {
    MemberAccess() {
      this instanceof FieldAccess or
      this instanceof MethodAccess
    }

    /** Gets the member accessed by this member access. */
    Member getMember() {
      result = this.(FieldAccess).getField() or
      result = this.(MethodAccess).getMethod()
    }

    /** Gets the qualifier of this member access, if any. */
    Expr getQualifier() {
      result = this.(FieldAccess).getQualifier() or
      result = this.(MethodAccess).getQualifier()
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
class FieldWrite extends FieldAccess, LValue { }

/** An expression that reads a field. */
class FieldRead extends FieldAccess, RValue { }

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
      pos = call.getNumArgument() - 1 and
      call.getCallee().getParameter(pos) = p and
      p.isVarargs() and
      ptyp = p.getType() and
      (
        hasSubtype*(ptyp, typ)
        or
        // If the types don't match then we'll guess based on whether there are type variables involved.
        hasInstantiation(ptyp.(Array).getComponentType())
      )
    )
  }

  /** Holds if this argument is part of an implicit varargs array. */
  predicate isVararg() { isNthVararg(_) }

  /**
   * Holds if this argument is part of an implicit varargs array at the
   * given array index.
   */
  predicate isNthVararg(int arrayindex) {
    not isExplicitVarargsArray() and
    exists(Callable tgt |
      call.getCallee() = tgt and
      tgt.isVarargs() and
      arrayindex = pos - tgt.getNumberOfParameters() + 1 and
      arrayindex >= 0
    )
  }
}
