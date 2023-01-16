/**
 * @name Cleartext logging of sensitive information
 * @description Logging sensitive information in plaintext can
 *              expose it to an attacker.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 7.5
 * @precision high
 * @id swift/clear-text-logging
 * @tags security
 *       external/cwe/cwe-312
 *       external/cwe/cwe-359
 *       external/cwe/cwe-532
 */

import swift
import codeql.swift.dataflow.DataFlow
import codeql.swift.security.CleartextLoggingQuery
import DataFlow::PathGraph

from DataFlow::PathNode src, DataFlow::PathNode sink
where any(CleartextLoggingConfiguration c).hasFlowPath(src, sink)
select sink.getNode(), src, sink, "This $@ is written to a log file.", src.getNode(),
  "potentially sensitive information"
