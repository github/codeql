private import unified
private import codeql.util.Unit

private module Plugins {
  private import ControlFlowGraphPluginSwift
}

class ControlFlowGraphPlugin extends Unit {
  predicate mayThrow(AstNode ast) { none() }
}
