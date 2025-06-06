/**
 * Provides classes for operations.
 *
 * INTERNAL: Do not use.
 */

private import rust
private import codeql.rust.elements.internal.ExprImpl::Impl as ExprImpl

/**
 * Holds if the operator `op` with arity `arity` is overloaded to a trait with
 * the canonical path `path` and the method name `method`.
 */
private predicate isOverloaded(string op, int arity, string path, string method) {
  arity = 1 and
  (
    // Negation
    op = "-" and path = "core::ops::arith::Neg" and method = "neg"
    or
    // Not
    op = "!" and path = "core::ops::bit::Not" and method = "not"
    or
    // Dereference
    op = "*" and path = "core::ops::deref::Deref" and method = "deref"
  )
  or
  arity = 2 and
  (
    // Comparison operators
    op = "==" and path = "core::cmp::PartialEq" and method = "eq"
    or
    op = "!=" and path = "core::cmp::PartialEq" and method = "ne"
    or
    op = "<" and path = "core::cmp::PartialOrd" and method = "lt"
    or
    op = "<=" and path = "core::cmp::PartialOrd" and method = "le"
    or
    op = ">" and path = "core::cmp::PartialOrd" and method = "gt"
    or
    op = ">=" and path = "core::cmp::PartialOrd" and method = "ge"
    or
    // Arithmetic operators
    op = "+" and path = "core::ops::arith::Add" and method = "add"
    or
    op = "-" and path = "core::ops::arith::Sub" and method = "sub"
    or
    op = "*" and path = "core::ops::arith::Mul" and method = "mul"
    or
    op = "/" and path = "core::ops::arith::Div" and method = "div"
    or
    op = "%" and path = "core::ops::arith::Rem" and method = "rem"
    or
    // Arithmetic assignment expressions
    op = "+=" and path = "core::ops::arith::AddAssign" and method = "add_assign"
    or
    op = "-=" and path = "core::ops::arith::SubAssign" and method = "sub_assign"
    or
    op = "*=" and path = "core::ops::arith::MulAssign" and method = "mul_assign"
    or
    op = "/=" and path = "core::ops::arith::DivAssign" and method = "div_assign"
    or
    op = "%=" and path = "core::ops::arith::RemAssign" and method = "rem_assign"
    or
    // Bitwise operators
    op = "&" and path = "core::ops::bit::BitAnd" and method = "bitand"
    or
    op = "|" and path = "core::ops::bit::BitOr" and method = "bitor"
    or
    op = "^" and path = "core::ops::bit::BitXor" and method = "bitxor"
    or
    op = "<<" and path = "core::ops::bit::Shl" and method = "shl"
    or
    op = ">>" and path = "core::ops::bit::Shr" and method = "shr"
    or
    // Bitwise assignment operators
    op = "&=" and path = "core::ops::bit::BitAndAssign" and method = "bitand_assign"
    or
    op = "|=" and path = "core::ops::bit::BitOrAssign" and method = "bitor_assign"
    or
    op = "^=" and path = "core::ops::bit::BitXorAssign" and method = "bitxor_assign"
    or
    op = "<<=" and path = "core::ops::bit::ShlAssign" and method = "shl_assign"
    or
    op = ">>=" and path = "core::ops::bit::ShrAssign" and method = "shr_assign"
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
    predicate isOverloaded(Trait trait, string methodName) {
      isOverloaded(this.getOperatorName(), this.getNumberOfOperands(), trait.getCanonicalPath(),
        methodName)
    }
  }
}
