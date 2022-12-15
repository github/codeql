import codeql.ruby.DataFlow
import codeql.ruby.StringOps

/** Holds if `node` may evaluate to `value` */
predicate mayHaveStringValue(DataFlow::Node node, string value) {
  node.asExpr().getConstantValue().getString() = value
}

import codeql.ruby.security.regexp.HostnameRegexp as HostnameRegexp
