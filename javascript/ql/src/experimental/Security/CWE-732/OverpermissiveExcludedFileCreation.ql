import ModableFileCreation

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

/**
 * A data flow configuration for file creation with a computed mode
 * from which world execute permission has been excluded.
 *
 * For example:
 * ```js
 * const mode = 0o777 & ~fs.constants.S_IXOTH
 * fs.open('/tmp/file', 'r', mode)
 * ```
 */
class WorldExecuteExcludedFileCreation extends WorldExecuteExcludedEntryCreation {
  WorldExecuteExcludedFileCreation() { this = "WorldExecuteExcludedEntryCreation" }

  override predicate isSink(DataFlow::Node node) {
    exists(ModableFileCreation creation | creation.getSpecifier() = node.asExpr())
  }
}

from
  ExcludedFileModeConstruction construction,
  ExcludedFileModeCorruption corruption,
  WorldWriteExcludedFileCreation worldWriteExclusion,
  WorldExecuteExcludedFileCreation worldExecuteExclusion,
  DataFlow::Node source,
  DataFlow::Node sink
where
  construction.hasFlow(source, sink) and
  not corruption.hasFlow(_, sink) and
  not (
    worldWriteExclusion.hasFlow(_, sink) and
    worldExecuteExclusion.hasFlow(_, sink)
  )
select
  source.toString(),
  sink.toString(),
  source.getStartLine(),
  source.getStartColumn(),
  sink.getStartLine(),
  sink.getStartColumn()
