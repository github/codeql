private import AstImport

class AttributedExprBase extends Expr, TAttributedExprBase {
  Expr getExpr() { none() }

  AttributeBase getAttribute() { none() }
}
