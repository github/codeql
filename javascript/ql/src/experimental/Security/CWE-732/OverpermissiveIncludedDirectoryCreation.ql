/**
 * @name Overpermissive included directory creation
 * @description Creating program directories world writable may allow an attacker to control
 *              program behavior by creating files in them.
 * @kind path-problem
 * @problem.severity warning
 * @id js/insecure-fs/overpermissive-included-directory-creation
 * @tags security
 *       external/cwe/cwe-732
 */

import ModableDirectoryCreation
import DataFlow::PathGraph

/**
 * A taint tracking configuration for directory creation
 * with an overpermissive mode computed by excluding mode constants.
 *
 * For example:
 * ```js
 * fs.mkdir('/tmp/dir', fs.constants.S_IRWXU | fs.constants.S_IRWXG | fs.constants.S_IRWXO)
 * ```
 */
class OverpermissiveIncludedDirectoryCreation extends OverpermissiveIncludedEntryCreation {
  OverpermissiveIncludedDirectoryCreation() { this = "OverpermissiveIncludedEntryCreation" }

  override predicate isSource(DataFlow::Node node) {
    node = NodeJSLib::FS::moduleMember("constants").getAPropertyRead() and
    node.(DataFlow::PropRead).getPropertyName() = getAnOverpermissiveDirectoryConstant()
  }

  override predicate isSink(DataFlow::Node node) {
    exists(ModableDirectoryCreation creation | creation.getSpecifier() = node.asExpr())
  }
}

/**
 * A data flow configuration for corruption of a directory creation mode
 * computed by including mode constants.
 *
 * For example:
 * ```js
 * const mode = fs.constants.S_IRWXU | fs.constants.S_IRWXG
 * fs.mkdir('/tmp/dir', mode + 1)
 * ```
 */
class IncludedDirectoryModeCorruption extends IncludedEntryModeCorruption {
  IncludedDirectoryModeCorruption() { this = "EntryModeCorruption" }

  override predicate isSink(DataFlow::Node node, DataFlow::FlowLabel label) {
    exists(ModableDirectoryCreation creation | creation.getSpecifier() = node.asExpr()) and
    label instanceof CorruptLabel
  }
}

from
  OverpermissiveIncludedDirectoryCreation construction,
  IncludedDirectoryModeCorruption corruption,
  DataFlow::PathNode source,
  DataFlow::PathNode sink
where
  construction.hasFlowPath(source, sink) and
  not corruption.hasFlow(_, sink.getNode())
select
  sink.getNode(),
  source,
  sink,
  "This call uses an overpermissive mode constant from $@" +
    " that creates world writable directories.",
  source.getNode(),
  "here"
