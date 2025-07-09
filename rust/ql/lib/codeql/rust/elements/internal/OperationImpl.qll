/**
 * Provides classes for operations.
 *
 * INTERNAL: Do not use.
 */

private import rust
private import codeql.rust.elements.internal.ExprImpl::Impl as ExprImpl

/**
 * Holds if the operator `op` with arity `arity` is overloaded to a trait with
 * the canonical path `path` and the method name `method`, and if it borrows its
 * first `borrows` arguments.
 */
private predicate isOverloaded(string op, int arity, string path, string method, int borrows) {
  arity = 1 and
  (
    // Negation
    op = "-" and path = "core::ops::arith::Neg" and method = "neg" and borrows = 0
    or
    // Not
    op = "!" and path = "core::ops::bit::Not" and method = "not" and borrows = 0
    or
    // Dereference
    op = "*" and path = "core::ops::deref::Deref" and method = "deref" and borrows = 1
  )
  or
  arity = 2 and
  (
    // Comparison operators
    op = "==" and path = "core::cmp::PartialEq" and method = "eq" and borrows = 2
    or
    op = "!=" and path = "core::cmp::PartialEq" and method = "ne" and borrows = 2
    or
    op = "<" and path = "core::cmp::PartialOrd" and method = "lt" and borrows = 2
    or
    op = "<=" and path = "core::cmp::PartialOrd" and method = "le" and borrows = 2
    or
    op = ">" and path = "core::cmp::PartialOrd" and method = "gt" and borrows = 2
    or
    op = ">=" and path = "core::cmp::PartialOrd" and method = "ge" and borrows = 2
    or
    // Arithmetic operators
    op = "+" and path = "core::ops::arith::Add" and method = "add" and borrows = 0
    or
    op = "-" and path = "core::ops::arith::Sub" and method = "sub" and borrows = 0
    or
    op = "*" and path = "core::ops::arith::Mul" and method = "mul" and borrows = 0
    or
    op = "/" and path = "core::ops::arith::Div" and method = "div" and borrows = 0
    or
    op = "%" and path = "core::ops::arith::Rem" and method = "rem" and borrows = 0
    or
    // Arithmetic assignment expressions
    op = "+=" and path = "core::ops::arith::AddAssign" and method = "add_assign" and borrows = 1
    or
    op = "-=" and path = "core::ops::arith::SubAssign" and method = "sub_assign" and borrows = 1
    or
    op = "*=" and path = "core::ops::arith::MulAssign" and method = "mul_assign" and borrows = 1
    or
    op = "/=" and path = "core::ops::arith::DivAssign" and method = "div_assign" and borrows = 1
    or
    op = "%=" and path = "core::ops::arith::RemAssign" and method = "rem_assign" and borrows = 1
    or
    // Bitwise operators
    op = "&" and path = "core::ops::bit::BitAnd" and method = "bitand" and borrows = 0
    or
    op = "|" and path = "core::ops::bit::BitOr" and method = "bitor" and borrows = 0
    or
    op = "^" and path = "core::ops::bit::BitXor" and method = "bitxor" and borrows = 0
    or
    op = "<<" and path = "core::ops::bit::Shl" and method = "shl" and borrows = 0
    or
    op = ">>" and path = "core::ops::bit::Shr" and method = "shr" and borrows = 0
    or
    // Bitwise assignment operators
    op = "&=" and path = "core::ops::bit::BitAndAssign" and method = "bitand_assign" and borrows = 1
    or
    op = "|=" and path = "core::ops::bit::BitOrAssign" and method = "bitor_assign" and borrows = 1
    or
    op = "^=" and path = "core::ops::bit::BitXorAssign" and method = "bitxor_assign" and borrows = 1
    or
    op = "<<=" and path = "core::ops::bit::ShlAssign" and method = "shl_assign" and borrows = 1
    or
    op = ">>=" and path = "core::ops::bit::ShrAssign" and method = "shr_assign" and borrows = 1
  )
}

/**
 * INTERNAL: This module contains the customizable definition of `Operation` and should not
 * be referenced directly.
 */
module Impl {
  /**
   * An operation, for example `&&`, `+=`, `!` or `*`.
   */
  abstract class Operation extends ExprImpl::Expr {
    /** Gets the operator name of this operation, if it exists. */
    abstract string getOperatorName();

    /** Gets the `n`th operand of this operation, if any. */
    abstract Expr getOperand(int n);

    /**
     * Gets the number of operands of this operation.
     *
     * This is either 1 for prefix operations, or 2 for binary operations.
     */
    final int getNumberOfOperands() { result = strictcount(this.getAnOperand()) }

    /** Gets an operand of this operation. */
    Expr getAnOperand() { result = this.getOperand(_) }

    /**
     * Holds if this operation is overloaded to the method `methodName` of the
     * trait `trait`.
     */
    predicate isOverloaded(Trait trait, string methodName, int borrows) {
      isOverloaded(this.getOperatorName(), this.getNumberOfOperands(), trait.getCanonicalPath(),
        methodName, borrows)
    }
  }
}
