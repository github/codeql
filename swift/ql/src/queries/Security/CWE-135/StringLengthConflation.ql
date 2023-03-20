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
import DataFlow::PathGraph

from
  StringLengthConflationConfiguration config, DataFlow::PathNode source, DataFlow::PathNode sink,
  StringType sourceType, StringType sinkType, string message
where
  config.hasFlowPath(source, sink) and
  config.isSource(source.getNode(), sourceType) and
  sinkType = sink.getNode().(StringLengthConflationSink).getCorrectStringType() and
  message =
    "This " + sourceType + " length is used in " + sinkType.getSingular() +
      ", but it may not be equivalent."
select sink.getNode(), source, sink, message
