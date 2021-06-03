import ModableFileCreation

class OverpermissiveIncludedFileCreation extends
  TaintTracking::Configuration
{
  OverpermissiveIncludedFileCreation() {
    this = "OverpermissiveIncludedFileCreation"
  }

  override predicate isSource(DataFlow::Node node) {
    node = NodeJSLib::FS::moduleMember("constants").getAPropertyRead() and
    node.(DataFlow::PropRead).getPropertyName() = getAnOverpermissiveFileConstant()
  }

  override predicate isSink(DataFlow::Node node) {
    exists(ModableFileCreation creation |
      creation.getSpecifier() = node.asExpr()
    )
  }

  override predicate isAdditionalTaintStep(
    DataFlow::Node predecessor,
    DataFlow::Node successor
  ) {
    exists(InclusiveDisjunction disjunction |
      predecessor.asExpr() = disjunction.getAFactor() and
      successor.asExpr() = disjunction
    )
  }
}

class Corruption extends DataFlow::Configuration {
  Corruption() { this = "Corruption" }

  override predicate isSource(DataFlow::Node node) { any() }

  override predicate isSink(DataFlow::Node node, DataFlow::FlowLabel label) {
    exists(ModableFileCreation creation |
      creation.getSpecifier() = node.asExpr()
    ) and
    label instanceof CorruptLabel
  }

  override predicate isAdditionalFlowStep(
    DataFlow::Node predecessor,
    DataFlow::Node successor,
    DataFlow::FlowLabel predLabel,
    DataFlow::FlowLabel succLabel
  ) {
    exists(ModifyExpr modification |
      predecessor.asExpr() = modification.getAFactor() and
      successor.asExpr() = modification and (
        (predLabel instanceof CorruptLabel and succLabel instanceof CorruptLabel) or
        (not modification instanceof InclusiveDisjunction and succLabel instanceof CorruptLabel) or
        not succLabel instanceof CorruptLabel
      )
    )
  }
}

class IncludedFileCreationCorruption extends
  IncludedEntryCreationCorruption
{
  IncludedFileCreationCorruption() { this = "EntryCreationCorruption" }

  override predicate isSink(DataFlow::Node node, DataFlow::FlowLabel label) {
    exists(ModableFileCreation creation |
      creation.getSpecifier() = node.asExpr()
    ) and
    label instanceof CorruptLabel
  }
}

from
  OverpermissiveIncludedFileCreation construction,
  IncludedFileCreationCorruption corruption,
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
