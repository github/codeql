/**
 * @name Overpermissive excluded file creation
 * @description Creating program files world writable may allow an attacker to control program
 *              behavior by modifying them.
 * @kind path-problem
 * @problem.severity warning
 * @id js/insecure-fs/overpermissive-excluded-file-creation
 * @tags security
 *       external/cwe/cwe-732
 */

import ModableFileCreation
import DataFlow::PathGraph

/**
 * A data flow configuration for a file creation mode
 * computed by excluding mode constants.
 *
 * For example:
 * ```js
 * const mode = 0o777
 *   & ~fs.constants.S_IWOTH
 *   & ~fs.constants.S_IXOTH
 * fs.open('/tmp/file', 'r', mode)
 * ```
 */
class ExcludedFileModeConstruction extends ExcludedEntryModeConstruction {
  ExcludedFileModeConstruction() { this = "ExcludedEntryModeConstruction" }

  override predicate isSink(DataFlow::Node node) {
    exists(ModableFileCreation creation | creation.getSpecifier() = node.asExpr())
  }
}

/**
 * A data flow configuration for corruption of a file creation mode
 * computed by excluding mode constants.
 *
 * For example:
 * ```js
 * const mode = 0o777 & ~fs.constants.S_IRWXO
 * fs.open('/tmp/file', 'r', mode - 1)
 * ```
 */
class ExcludedFileModeCorruption extends ExcludedEntryModeCorruption {
  ExcludedFileModeCorruption() { this = "EntryModeCorruption" }

  override predicate isSink(DataFlow::Node node, DataFlow::FlowLabel label) {
    exists(ModableFileCreation creation | creation.getSpecifier() = node.asExpr()) and
    label instanceof CorruptLabel
  }
}

/**
 * A data flow configuration for file creation with a computed mode
 * from which some permission has been excluded.
 */
class ExcludedFileCreation extends ExcludedEntryCreation {
  ExcludedFileCreation() { this = "ExcludedEntryCreation" }

  override predicate isSink(DataFlow::Node node) {
    exists(ModableFileCreation creation | creation.getSpecifier() = node.asExpr())
  }
}

/**
 * A data flow configuration for file creation with a computed mode
 * from which world write permission has been excluded.
 *
 * For example:
 * ```js
 * const mode = 0o777 & ~fs.constants.S_IWOTH
 * fs.open('/tmp/file', 'r', mode)
 * ```
 */
class WorldWriteExcludedFileCreation extends WorldWriteExcludedEntryCreation {
  WorldWriteExcludedFileCreation() { this = "WorldWriteExcludedEntryCreation" }

  override predicate isSink(DataFlow::Node node) {
    exists(ModableFileCreation creation | creation.getSpecifier() = node.asExpr())
  }
}

from
  ExcludedFileModeConstruction construction, ExcludedFileModeCorruption corruption,
  ExcludedFileCreation exclusion, WorldWriteExcludedFileCreation worldWriteExclusion,
  DataFlow::PathNode source, DataFlow::PathNode sink
where
  construction.hasFlowPath(source, sink) and
  source.getNode() != sink.getNode() and
  not corruption.hasFlow(_, sink.getNode()) and
  exclusion.hasFlow(_, sink.getNode()) and
  not worldWriteExclusion.hasFlow(_, sink.getNode())
select sink.getNode(), source, sink,
  "This call uses an overpermissive mode from $@ that creates world writable files.",
  source.getNode(), "here"
