/**
 * Provides classes for operations.
 */

private import rust
private import codeql.rust.elements.internal.ExprImpl::Impl as ExprImpl

/**
 * INTERNAL: This module contains the customizable definition of `Operation` and should not
 * be referenced directly.
 */
module OperationImpl {
    /**
     * An operation, for example `&&`, `+=`, `!` or `*`.
     */
    abstract class Operation extends ExprImpl::Expr { }
}

final class Operation = OperationImpl::Operation;
