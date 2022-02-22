/**
 * @name Wrapped error is always nil
 * @description Finds calls to `Wrap` from `pkg/errors` where the error argument is always nil.
 * @kind problem
 * @problem.severity warning
 * @id go/unexpected-nil-value
 * @tags reliability
 *       correctness
 *       logic
 * @precision high
 */

import go

/** Gets package for `github.com/pkg/errors`. */
string packagePath() { result = package("github.com/pkg/errors", "") }

/**
 * An equality test which guarantees that an expression is always `nil`.
 */
class NilTestGuard extends DataFlow::BarrierGuard, DataFlow::EqualityTestNode {
  DataFlow::Node otherNode;

  NilTestGuard() {
    this.getAnOperand() = Builtin::nil().getARead() and
    otherNode = this.getAnOperand() and
    not otherNode = Builtin::nil().getARead()
  }

  override predicate checks(Expr e, boolean outcome) {
    e = otherNode.asExpr() and
    outcome = this.getPolarity()
  }
}

/** Gets a use of a local variable that has the value `nil`. */
DataFlow::ExprNode getNilFromLocalVariable() {
  exists(SsaVariable ssa, Write w |
    w.definesSsaVariable(ssa, Builtin::nil().getARead()) and
    result.asInstruction() = ssa.getAUse()
  )
}

from DataFlow::Node n
where
  n = any(Function f | f.hasQualifiedName(packagePath(), "Wrap")).getACall().getArgument(0) and
  (
    // ```go
    // errors.Wrap(nil, "")
    // ```
    n = Builtin::nil().getARead()
    or
    // ```go
    // var localVar error = nil
    // errors.Wrap(localVar, "")
    // ```
    n = getNilFromLocalVariable()
    or
    // ```go
    // if err != nil {
    // 	return ...
    // }
    // if ok2, _ := f2(input); !ok2 {
    // 	return errors.Wrap(err, "")
    // }
    n = any(NilTestGuard ntg).getAGuardedNode()
  )
select n, "The first argument to 'errors.Wrap' is always nil"
