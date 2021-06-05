/**
 * @name Overpermissive transported directory creation
 * @description Creating program directories world writable may allow an attacker to control
 *              program behavior by creating files in them.
 * @kind path-problem
 * @problem.severity warning
 * @id js/insecure-fs/overpermissive-transported-directory-creation
 * @tags security
 *       external/cwe/cwe-732
 */

import ModableDirectoryCreation
import DataFlow::PathGraph

/**
 * A data flow configuration for directory creation with a mode
 * transported through expressions and variables.
 *
 * For example:
 * ```js
 * function getMode() {
 *   const mode = 0o700
 *   return mode
 * }
 * fs.mkdir('/tmp/dir', getMode())
 * ```
 */
class OverpermissiveTransportedDirectoryCreation extends DataFlow::Configuration {
  OverpermissiveTransportedDirectoryCreation() {
    this = "OverpermissiveTransportedDirectoryCreation"
  }

  override predicate isSource(DataFlow::Node node) {
    node.asExpr() instanceof LiteralSpecifier and
    specifierOverpermissive(node.asExpr(), getOverpermissiveDirectoryMask())
  }

  override predicate isSink(DataFlow::Node node) {
    exists(ModableDirectoryCreation creation | creation.getSpecifier() = node.asExpr())
  }
}

from
  OverpermissiveTransportedDirectoryCreation transport, DataFlow::PathNode source,
  DataFlow::PathNode sink
where
  transport.hasFlowPath(source, sink) and
  source.getNode() != sink.getNode()
select sink.getNode(), source, sink,
  "This call uses an overpermissive mode from $@ that creates world writable directories.",
  source.getNode(), "here"
