import ModableDirectoryCreation

class DirectoryModeFromLiteral extends EntryModeFromLiteral {
  DirectoryModeFromLiteral() { this = "EntryModeFromLiteral" }

  override predicate isSink(DataFlow::Node node) {
    exists(ModableDirectoryCreation creation |
      creation.getSpecifier() = node.asExpr()
    )
  }
}

class ExcludedDirectoryCreationCorruption extends
  ExcludedEntryCreationCorruption
{
  ExcludedDirectoryCreationCorruption() { this = "EntryCreationCorruption" }

  override predicate isSink(DataFlow::Node node, DataFlow::FlowLabel label) {
    exists(ModableDirectoryCreation creation |
      creation.getSpecifier() = node.asExpr()
    ) and
    label instanceof CorruptLabel
  }
}

class WorldWriteExcludedDirectoryCreation extends
  WorldWriteExcludedEntryCreation
{
  WorldWriteExcludedDirectoryCreation() {
    this = "WorldWriteExcludedEntryCreation"
  }

  override predicate isSink(DataFlow::Node node) {
    exists(ModableDirectoryCreation creation |
      creation.getSpecifier() = node.asExpr()
    )
  }
}

from
  DirectoryModeFromLiteral fromLiteral,
  ExcludedDirectoryCreationCorruption corruption,
  WorldWriteExcludedDirectoryCreation worldWriteExclusion,
  DataFlow::Node source,
  DataFlow::Node sink
where
  fromLiteral.hasFlow(source, sink) and
  not corruption.hasFlow(_, sink) and
  not worldWriteExclusion.hasFlow(_, sink)
select
  source.toString(),
  sink.toString(),
  source.getStartLine(),
  source.getStartColumn(),
  sink.getStartLine(),
  sink.getStartColumn()
