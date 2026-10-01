/**
 * @name Pretty print AST as graph
 * @description Debug the AST by printing it as a graph.
 * @id unified/debug-ast
 * @kind graph
 */

import unified

private predicate skip(AstNode e) { e instanceof Modifier }

AstNode getChild(AstNode n, int index) {
  result.getParent() = n and
  result.getParentIndex() = index and
  not skip(n) and
  not skip(result)
}

predicate relevant(AstNode n) {
  n.getLocation().getFile().getBaseName() = "CLI.swift" and
  n.getLocation().getStartLine() = [98 .. 120] and
  not skip(n)
}

// Add additional node info here
string tag(AstNode n) { none() }

query predicate nodes(AstNode n, string key, string val) {
  key = "semmle.label" and
  relevant(n) and
  val = concat(string t | t = tag(n)) + " " + n.toString()
}

// Add additional edge info here
string etag(AstNode child, AstNode parent) {
  exists(string name, int i, string arg |
    PrintAst::getChild(parent, name, i) = child and
    result = name + arg and
    if i = -1 then arg = "()" else arg = "(" + i.toString() + ")"
  )
}

query predicate edges(AstNode pred, AstNode succ, string attr, string val) {
  attr = "semmle.label" and
  relevant(succ) and
  exists(int i |
    pred = getChild(succ, i) and
    val = i + " " + concat(string t | t = etag(pred, succ) | t, ", ")
  )
}
