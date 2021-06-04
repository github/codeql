import ModableFileCreation

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
