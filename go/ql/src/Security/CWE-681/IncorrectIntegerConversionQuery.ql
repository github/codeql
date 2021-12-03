/**
 * @name Incorrect conversion between integer types
 * @description Converting the result of `strconv.Atoi`, `strconv.ParseInt`,
 *              and `strconv.ParseUint` to integer types of smaller bit size
 *              can produce unexpected values.
 * @kind path-problem
 * @problem.severity warning
 * @security-severity 8.1
 * @id go/incorrect-integer-conversion
 * @tags security
 *       external/cwe/cwe-190
 *       external/cwe/cwe-681
 * @precision very-high
 */

import go
import DataFlow::PathGraph
import semmle.go.security.IncorrectIntegerConversionLib

from
  DataFlow::PathNode source, DataFlow::PathNode sink, ConversionWithoutBoundsCheckConfig cfg,
  DataFlow::CallNode call
where cfg.hasFlowPath(source, sink) and call.getResult(0) = source.getNode()
select sink.getNode(), source, sink,
  "Incorrect conversion of " +
    describeBitSize(cfg.getSourceBitSize(), getIntTypeBitSize(source.getNode().getFile())) +
    " from $@ to a lower bit size type " + sink.getNode().getType().getUnderlyingType().getName() +
    " without an upper bound check.", source, call.getTarget().getQualifiedName()
