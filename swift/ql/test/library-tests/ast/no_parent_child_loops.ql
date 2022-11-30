private import codeql.swift.printast.PrintAstNode

predicate isChildOf(PrintAstNode parent, PrintAstNode child) { parent.hasChild(child, _, _) }

from PrintAstNode parent, PrintAstNode child
where isChildOf(parent, child) and isChildOf*(child, parent)
select parent, child
