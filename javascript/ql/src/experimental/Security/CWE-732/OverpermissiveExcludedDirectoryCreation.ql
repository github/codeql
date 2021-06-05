/**
 * @name Overpermissive excluded directory creation
 * @description Creating program directories world writable may allow an attacker to control
 *              program behavior by creating files in them.
 * @kind path-problem
 * @problem.severity warning
 * @id js/insecure-fs/overpermissive-excluded-directory-creation
 * @tags security
 *       external/cwe/cwe-732
 */

import ModableDirectoryCreation
import DataFlow::PathGraph

/**
 * A data flow configuration for a directory creation mode
 * computed by excluding mode constants.
 *
 * For example:
 * ```js
 * const mode = 0o777
 *   & ~fs.constants.S_IWGRP
 *   & ~fs.constants.S_IWOTH
 * fs.mkdir('/tmp/dir', mode)
 * ```
 */
class ExcludedDirectoryModeConstruction extends ExcludedEntryModeConstruction {
  ExcludedDirectoryModeConstruction() { this = "ExcludedEntryModeConstruction" }

  override predicate isSink(DataFlow::Node node) {
    exists(ModableDirectoryCreation creation | creation.getSpecifier() = node.asExpr())
  }
}

/**
 * A data flow configuration for corruption of a directory creation mode
 * computed by excluding mode constants.
 *
 * For example:
 * ```js
 * const mode = 0o777 & ~fs.constants.S_IRWXO
 * fs.mkdir('/tmp/dir', mode - 1)
 * ```
 */
class ExcludedDirectoryModeCorruption extends ExcludedEntryModeCorruption {
  ExcludedDirectoryModeCorruption() { this = "EntryModeCorruption" }

  override predicate isSink(DataFlow::Node node, DataFlow::FlowLabel label) {
    exists(ModableDirectoryCreation creation | creation.getSpecifier() = node.asExpr()) and
    label instanceof CorruptLabel
  }
}

/**
 * A data flow configuration for directory creation with a computed mode
 * from which some permission has been excluded.
 */
class ExcludedDirectoryCreation extends ExcludedEntryCreation {
  ExcludedDirectoryCreation() { this = "ExcludedEntryCreation" }

  override predicate isSink(DataFlow::Node node) {
    exists(ModableDirectoryCreation creation | creation.getSpecifier() = node.asExpr())
  }
}

/**
 * A data flow configuration for directory creation with a computed mode
 * from which world write permission has been excluded.
 *
 * For example:
 * ```js
 * const mode = 0o777 & ~fs.constants.S_IWOTH
 * fs.open('/tmp/dir', mode)
 * ```
 */
class WorldWriteExcludedDirectoryCreation extends WorldWriteExcludedEntryCreation {
  WorldWriteExcludedDirectoryCreation() { this = "WorldWriteExcludedEntryCreation" }

  override predicate isSink(DataFlow::Node node) {
    exists(ModableDirectoryCreation creation | creation.getSpecifier() = node.asExpr())
  }
}

from
  ExcludedDirectoryModeConstruction construction, ExcludedDirectoryModeCorruption corruption,
  ExcludedDirectoryCreation exclusion, WorldWriteExcludedDirectoryCreation worldWriteExclusion,
  DataFlow::PathNode source, DataFlow::PathNode sink
where
  construction.hasFlowPath(source, sink) and
  source.getNode() != sink.getNode() and
  not corruption.hasFlow(_, sink.getNode()) and
  exclusion.hasFlow(_, sink.getNode()) and
  not worldWriteExclusion.hasFlow(_, sink.getNode())
select sink.getNode(), source, sink,
  "This call uses an overpermissive mode from $@ that creates world writable directories.",
  source.getNode(), "here"
