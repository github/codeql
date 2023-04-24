/**
 * @name String length conflation
 * @description Using a length value from an `NSString` in a `String`, or a count from a `String` in an `NSString`, may cause unexpected behavior.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 7.8
 * @precision high
 * @id swift/string-length-conflation
 * @tags security
 *       external/cwe/cwe-135
 */

import swift
import codeql.swift.dataflow.DataFlow
import codeql.swift.security.StringLengthConflationQuery
import StringLengthConflationFlow::PathGraph

from
  StringLengthConflationFlow::PathNode source, StringLengthConflationFlow::PathNode sink,
  StringType sourceType, StringType sinkType, string message
where
  StringLengthConflationFlow::flowPath(source, sink) and
  StringLengthConflationConfig::isSource(source.getNode(), sourceType) and
  sinkType = sink.getNode().(StringLengthConflationSink).getCorrectStringType() and
  message =
    "This " + sourceType + " length is used in " + sinkType.getSingular() +
      ", but it may not be equivalent."
select sink.getNode(), source, sink, message
