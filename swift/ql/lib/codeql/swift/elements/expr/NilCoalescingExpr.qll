private import codeql.swift.elements.expr.Expr
private import codeql.swift.elements.expr.BinaryExpr

class NilCoalescingExpr extends BinaryExpr {
    NilCoalescingExpr() {
        this.getStaticTarget().getName() = "??(_:_:)"
    }
}