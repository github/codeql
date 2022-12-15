import javascript
import semmle.javascript.dataflow.InferredTypes

/** Holds if `node` may evaluate to `value` */
predicate mayHaveStringValue(DataFlow::Node node, string value) { node.mayHaveStringValue(value) }

import semmle.javascript.security.regexp.HostnameRegexp as HostnameRegexp
