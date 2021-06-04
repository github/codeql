import ModableFileCreation

class FileModeFromLiteral extends EntryModeFromLiteral {
  FileModeFromLiteral() { this = "EntryModeFromLiteral" }

  override predicate isSink(DataFlow::Node node) {
    exists(ModableFileCreation creation | creation.getSpecifier() = node.asExpr())
  }
}

class ExcludedFileCreationCorruption extends ExcludedEntryCreationCorruption {
  ExcludedFileCreationCorruption() { this = "EntryCreationCorruption" }

  override predicate isSink(DataFlow::Node node, DataFlow::FlowLabel label) {
    exists(ModableFileCreation creation | creation.getSpecifier() = node.asExpr()) and
    label instanceof CorruptLabel
  }
}

class WorldWriteExcludedFileCreation extends WorldWriteExcludedEntryCreation {
  WorldWriteExcludedFileCreation() { this = "WorldWriteExcludedEntryCreation" }

  override predicate isSink(DataFlow::Node node) {
    exists(ModableFileCreation creation | creation.getSpecifier() = node.asExpr())
  }
}

class WorldExecuteExcludedFileCreation extends WorldExecuteExcludedEntryCreation {
  WorldExecuteExcludedFileCreation() { this = "WorldExecuteExcludedEntryCreation" }

  override predicate isSink(DataFlow::Node node) {
    exists(ModableFileCreation creation | creation.getSpecifier() = node.asExpr())
  }
}

from
  FileModeFromLiteral fromLiteral,
  ExcludedFileCreationCorruption corruption,
  WorldWriteExcludedFileCreation worldWriteExclusion,
  WorldExecuteExcludedFileCreation worldExecuteExclusion,
  DataFlow::Node source,
  DataFlow::Node sink
where
  fromLiteral.hasFlow(source, sink) and
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
