private import codeql.swift.printast.PrintAstNode

from PrintAstNode parent1, PrintAstNode parent2, PrintAstNode child
where
  parent1 != parent2 and
  parent1.hasChild(child, _, _) and
  parent2.hasChild(child, _, _)
select parent1, parent2, child
