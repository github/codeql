/**
 * @name Uncontrolled format string
 * @description Finds calls to ``String.init(format:_:)`` where the format
 *              string is not a hard-coded string literal.
 * @id swift/examples/simple-uncontrolled-format-string
 * @tags example
 */

import swift
import codeql.swift.dataflow.DataFlow

from CallExpr call, Method method, DataFlow::Node sinkNode
where
  call.getStaticTarget() = method and
  method.hasQualifiedName("String", "init(format:_:)") and
  sinkNode.asExpr() = call.getArgument(0).getExpr() and
  not exists(StringLiteralExpr sourceLiteral |
    DataFlow::localFlow(DataFlow::exprNode(sourceLiteral), sinkNode)
  )
select call, "Format argument to " + method.getName() + " isn't hard-coded."
