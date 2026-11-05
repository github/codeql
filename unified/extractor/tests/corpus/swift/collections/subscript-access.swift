// TODO: `xs[0]` is mapped to a call_expr, even though swift-syntax reports a
// distinct subscriptCallExpr. Giving subscripts their own shape needs only a
// subscript_expr node in ast_types.yml and a remap.
let first = xs[0]
