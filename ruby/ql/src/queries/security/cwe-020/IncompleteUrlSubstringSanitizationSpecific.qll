import codeql.ruby.DataFlow
import codeql.ruby.StringOps
import codeql.ruby.Regexp::RegExpPatterns as RegExpPatterns

/** Holds if `node` may evaluate to `value` */
predicate mayHaveStringValue(DataFlow::Node node, string value) {
  node.asExpr().getConstantValue().getString() = value
}
