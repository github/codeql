private import Raw

class ErrorStmt extends @error_statement, PipelineBase {
  final override SourceLocation getLocation() { error_statement_location(this, result) }
}
