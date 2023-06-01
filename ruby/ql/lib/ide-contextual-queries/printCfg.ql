/**
 * @name Print CFG
 * @description Produces a representation of a file's Control Flow Graph.
 *              This query is used by the VS Code extension.
 * @id rb/print-cfg
 * @kind graph
 * @tags ide-contextual-queries/print-cfg
 */

private import codeql.ruby.controlflow.internal.ControlFlowGraphImplShared::TestOutput
private import codeql.IDEContextual

/**
 * Gets the source file to generate a CFG from.
 */
external string selectedSourceFile();

class MyRelevantNode extends RelevantNode {
  MyRelevantNode() {
    this.getScope().getLocation().getFile() = getFileBySourceArchiveName(selectedSourceFile())
  }
}
