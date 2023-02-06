private import codeql.swift.printast.PrintAstNode

from PrintAstNode parent, int index, PrintAstNode child1, PrintAstNode child2
where
  child1 != child2 and
  parent.hasChild(child1, index, _) and
  parent.hasChild(child2, index, _)
select parent, index, child1, child2
