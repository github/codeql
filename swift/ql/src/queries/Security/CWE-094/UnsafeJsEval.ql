/**
 * @name JavaScript Injection
 * @description Evaluating JavaScript code containing a substring from a remote source may lead to remote code execution.
 * @kind path-problem
 * @problem.severity warning
 * @security-severity 9.3
 * @precision high
 * @id swift/unsafe-js-eval
 * @tags security
 *       external/cwe/cwe-094
 *       external/cwe/cwe-095
 *       external/cwe/cwe-749
 */

import swift
import codeql.swift.dataflow.DataFlow
import codeql.swift.security.UnsafeJsEvalQuery
import DataFlow::PathGraph

from
  UnsafeJsEvalConfig config, DataFlow::PathNode sourceNode, DataFlow::PathNode sinkNode,
  UnsafeJsEvalSink sink
where
  config.hasFlowPath(sourceNode, sinkNode) and
  sink = sinkNode.getNode()
select sink, sourceNode, sinkNode, "Evaluation of uncontrolled JavaScript from a remote source."
