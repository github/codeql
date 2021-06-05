/**
 * @name Overpermissive transported file creation
 * @description Creating program files world writable may allow an attacker to control program
 *              behavior by modifying them.
 * @kind path-problem
 * @problem.severity warning
 * @id js/insecure-fs/overpermissive-transported-file-creation
 * @tags security
 *       external/cwe/cwe-732
 */

import ModableFileCreation
import DataFlow::PathGraph

/**
 * A data flow configuration for file creation with a mode
 * transported through expressions and variables.
 *
 * For example:
 * ```js
 * function getMode() {
 *   const mode = 0o700
 *   return mode
 * }
 * fs.open('/tmp/file', 'r', getMode())
 * ```
 */
class OverpermissiveTransportedFileCreation extends DataFlow::Configuration {
  OverpermissiveTransportedFileCreation() { this = "OverpermissiveTransportedFileCreation" }

  override predicate isSource(DataFlow::Node node) {
    node.asExpr() instanceof LiteralSpecifier and
    specifierOverpermissive(node.asExpr(), getOverpermissiveFileMask())
  }

  override predicate isSink(DataFlow::Node node) {
    exists(ModableFileCreation creation | creation.getSpecifier() = node.asExpr())
  }
}

from
  OverpermissiveTransportedFileCreation transport,
  DataFlow::PathNode source,
  DataFlow::PathNode sink
where
  transport.hasFlowPath(source, sink) and
  source.getNode() != sink.getNode()
select
  sink.getNode(),
  source,
  sink,
  "This call uses an overpermissive mode from $@ that creates world writable files.",
  source.getNode(),
  "here"
