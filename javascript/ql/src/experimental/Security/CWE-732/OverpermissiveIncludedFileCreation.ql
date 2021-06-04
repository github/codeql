/**
 * @name Overpermissive included file creation
 * @description Creating program files world writable may allow an attacker to control program
 *              behavior by modifying them.
 * @kind path-problem
 * @id js/insecure-fs/overpermissive-included-file-creation
 * @tags security
 *       external/cwe/cwe-732
 */

import ModableFileCreation
import DataFlow::PathGraph

/**
 * A taint tracking configuration for file creation
 * with an overpermissive mode computed by including mode constants.
 *
 * For example:
 * ```js
 * fs.open('/tmp/file', 'r', fs.constants.S_IRWXU | fs.constants.S_IRWXG | fs.constants.S_IRWXO)
 * ```
 */
class OverpermissiveIncludedFileCreation extends OverpermissiveIncludedEntryCreation {
  OverpermissiveIncludedFileCreation() { this = "OverpermissiveIncludedEntryCreation" }

  override predicate isSource(DataFlow::Node node) {
    node = NodeJSLib::FS::moduleMember("constants").getAPropertyRead() and
    node.(DataFlow::PropRead).getPropertyName() = getAnOverpermissiveFileConstant()
  }

  override predicate isSink(DataFlow::Node node) {
    exists(ModableFileCreation creation | creation.getSpecifier() = node.asExpr())
  }
}

/**
 * A data flow configuration for corruption of a file creation mode
 * computed by including mode constants.
 *
 * For example:
 * ```js
 * const mode = fs.constants.S_IRWXU | fs.constants.S_IRWXG
 * fs.open('/tmp/file', 'r', mode + 1)
 * ```
 */
class IncludedFileModeCorruption extends IncludedEntryModeCorruption {
  IncludedFileModeCorruption() { this = "EntryModeCorruption" }

  override predicate isSink(DataFlow::Node node, DataFlow::FlowLabel label) {
    exists(ModableFileCreation creation | creation.getSpecifier() = node.asExpr()) and
    label instanceof CorruptLabel
  }
}

from
  OverpermissiveIncludedFileCreation construction,
  IncludedFileModeCorruption corruption,
  DataFlow::PathNode source,
  DataFlow::PathNode sink
where
  construction.hasFlowPath(source, sink) and
  not corruption.hasFlowPath(_, sink)
select
  sink.getNode(),
  source,
  sink,
  "This call uses an overpermissive mode constant from $@ that creates world writable files.",
  source.getNode(),
  "here"
