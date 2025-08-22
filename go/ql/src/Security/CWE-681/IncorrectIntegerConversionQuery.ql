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
 * @precision high
 */

import go
import semmle.go.security.IncorrectIntegerConversionLib
import Flow::PathGraph

from
  Flow::PathNode source, Flow::PathNode sink, DataFlow::CallNode call, DataFlow::Node sinkConverted
where
  Flow::flowPath(source, sink) and
  call.getResult(0) = source.getNode() and
  sinkConverted = sink.getNode().getASuccessor()
select sinkConverted, source, sink,
  "Incorrect conversion of " + describeBitSize2(source.getNode()) +
    " from $@ to a lower bit size type " + sinkConverted.getType().getUnderlyingType().getName() +
    " without an upper bound check.", source, call.getTarget().getQualifiedName()
