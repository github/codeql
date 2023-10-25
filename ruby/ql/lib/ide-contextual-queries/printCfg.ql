/**
 * @name Print CFG
 * @description Produces a representation of a file's Control Flow Graph.
 *              This query is used by the VS Code extension.
 * @id rb/print-cfg
 * @kind graph
 * @tags ide-contextual-queries/print-cfg
 */

private import codeql.ruby.controlflow.internal.ControlFlowGraphImpl::TestOutput
private import codeql.IDEContextual
private import codeql.Locations
private import codeql.ruby.controlflow.ControlFlowGraph

/**
 * Gets the source file to generate a CFG from.
 */
external string selectedSourceFile();

external string selectedSourceLine();

external string selectedSourceColumn();

bindingset[file, line, column]
private CfgScope smallestEnclosingScope(File file, int line, int column) {
  result =
    min(Location loc, CfgScope scope |
      loc = scope.getLocation() and
      (
        loc.getStartLine() < line
        or
        loc.getStartLine() = line and loc.getStartColumn() <= column
      ) and
      (
        loc.getEndLine() > line
        or
        loc.getEndLine() = line and loc.getEndColumn() >= column
      ) and
      loc.getFile() = file
    |
      scope
      order by
        loc.getStartLine() desc, loc.getStartColumn() desc, loc.getEndLine(), loc.getEndColumn()
    )
}

class MyRelevantNode extends RelevantNode {
  MyRelevantNode() {
    this.getScope() =
      smallestEnclosingScope(getFileBySourceArchiveName(selectedSourceFile()),
        selectedSourceLine().toInt(), selectedSourceColumn().toInt())
  }
}
