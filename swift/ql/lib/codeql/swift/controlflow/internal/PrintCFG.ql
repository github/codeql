/**
 * @name Print CFG
 * @description Produces a representation of a file's Control Flow Graph.
 *              This query is used by the VS Code extension.
 * @id swift/print-cfg
 * @kind graph
 * @tags ide-contextual-queries/print-cfg
 */

private import codeql.swift.controlflow.ControlFlowGraph
private import codeql.swift.controlflow.internal.ControlFlowGraphImpl::TestOutput

class MyRelevantNode extends RelevantNode {
  MyRelevantNode() { any() }
}
