import cpp

/**
 * An assertion, that is, a condition that is only false if there is a bug in
 * the program. To add support for more, define additional subclasses. A
 * typical subclass will extend extend either `MacroInvocation` (for assertion
 * macros) or `FunctionCall` (for assertion functions).
 */
abstract class Assertion extends Locatable {
  /** Gets the expression whose truth is being asserted. */
  abstract Expr getAsserted();
}

/**
 * A libc assert, as defined in assert.h. A macro with a head
 * that matches the prefix "assert(", and expands to a conditional
 * expression which may terminate the program.
 */
class LibcAssert extends MacroInvocation, Assertion {
  LibcAssert() { this.getMacro().getHead().matches("assert(%") }

  override Expr getAsserted() {
    exists(ConditionalExpr ce | this.getAGeneratedElement() = ce | result = ce.getCondition())
  }
}

/**
 * A macro assert that expands to an if statement; the head is taken
 * to be "Assert(x, y)", but further alternatives could be added.
 */
class MacroAssert extends MacroInvocation, Assertion {
  MacroAssert() { this.getMacro().getHead() = "Assert(x, y)" }

  override Expr getAsserted() {
    exists(IfStmt i | this.getAGeneratedElement() = i | result = i.getCondition())
  }
}

/**
 * An assertion that is not completely disabled in release builds but returns a
 * Boolean value to enable recovery from unexpected anomalous behavior. This
 * style of assert is advocated by the _Power of 10_ rules and the _NASA JPL
 * Coding Standard_.
 */
class RecoverableAssert extends MacroInvocation, Assertion {
  RecoverableAssert() { this.getMacro().getHead().matches("c\\_assert(%") }

  private Expr getAnAssertedExpr() {
    result = this.getAGeneratedElement() and
    not result.getLocation().getStartColumn() = this.getLocation().getStartColumn()
  }

  override Expr getAsserted() {
    result = this.getAnAssertedExpr() and
    not result.getParent() = this.getAnAssertedExpr() and
    // Remove spurious "string literals" that arise when the macro
    // uses #stringification
    not result.(Literal).getUnspecifiedType().(ArrayType).getBaseType() instanceof CharType
  }
}
