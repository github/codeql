import ModableDirectoryCreation

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
  ExcludedDirectoryModeConstruction() { this = "ExcludedDirectoryModeConstruction" }

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
  ExcludedDirectoryModeConstruction construction,
  ExcludedDirectoryModeCorruption corruption,
  WorldWriteExcludedDirectoryCreation worldWriteExclusion,
  DataFlow::Node source,
  DataFlow::Node sink
where
  construction.hasFlow(source, sink) and
  not corruption.hasFlow(_, sink) and
  not worldWriteExclusion.hasFlow(_, sink)
select
  source.toString(),
  sink.toString(),
  source.getStartLine(),
  source.getStartColumn(),
  sink.getStartLine(),
  sink.getStartColumn()
