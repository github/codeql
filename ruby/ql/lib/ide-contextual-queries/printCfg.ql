/**
 * @name Print CFG
 * @description Produces a representation of a file's Control Flow Graph.
 *              This query is used by the VS Code extension.
 * @id rb/print-cfg
 * @kind graph
 * @tags ide-contextual-queries/print-cfg
 */

private import codeql.IDEContextual
private import codeql.ruby.CFG
private import codeql.ruby.controlflow.internal.ControlFlowGraphImpl::TestOutput

/**
 * The source file to generate a CFG from.
 */
external string selectedSourceFile();

class MyRelevantNode extends RelevantNode {
  MyRelevantNode() {
    this.getLocation().getFile() = getFileBySourceArchiveName(selectedSourceFile())
  }
}
