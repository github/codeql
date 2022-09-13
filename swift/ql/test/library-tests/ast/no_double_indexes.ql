private import codeql.swift.printast.PrintAstNode

from PrintAstNode parent, int index1, int index2, PrintAstNode child
where
  index1 != index2 and
  parent.hasChild(child, index1, _) and
  parent.hasChild(child, index2, _)
select parent, child, index1, index2
