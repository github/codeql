import ModableDirectoryCreation

class OverpermissiveIncludedDirectoryCreation extends
  OverpermissiveIncludedEntryCreation
{
  OverpermissiveIncludedDirectoryCreation() {
    this = "OverpermissiveIncludedEntryCreation"
  }

  override predicate isSource(DataFlow::Node node) {
    node = NodeJSLib::FS::moduleMember("constants").getAPropertyRead() and
    node.(DataFlow::PropRead).getPropertyName() = getAnOverpermissiveDirectoryConstant()
  }

  override predicate isSink(DataFlow::Node node) {
    exists(ModableDirectoryCreation creation |
      creation.getSpecifier() = node.asExpr()
    )
  }
}

class IncludedDirectoryCreationCorruption extends
  IncludedEntryCreationCorruption
{
  IncludedDirectoryCreationCorruption() { this = "EntryCreationCorruption" }

  override predicate isSink(DataFlow::Node node, DataFlow::FlowLabel label) {
    exists(ModableDirectoryCreation creation |
      creation.getSpecifier() = node.asExpr()
    ) and
    label instanceof CorruptLabel
  }
}

from
  OverpermissiveIncludedDirectoryCreation construction,
  IncludedDirectoryCreationCorruption corruption,
  DataFlow::Node source,
  DataFlow::Node sink
where
  construction.hasFlow(source, sink) and
  not corruption.hasFlow(_, sink)
select
  source.toString(),
  sink.toString(),
  source.getStartLine(),
  source.getStartColumn(),
  sink.getStartLine(),
  sink.getStartColumn()
