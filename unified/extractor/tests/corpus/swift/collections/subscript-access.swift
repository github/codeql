// TODO: tree-sitter-swift parses `xs[0]` as a call_expression (same shape
// as `xs(0)`), so the mapping currently produces a call_expr. Update the
// parser / add a separate subscript_expr node and remap when fixed.
let first = xs[0]
