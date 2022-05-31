import swift
import codeql.swift.generated.Children

from AstNode parent1, AstNode parent2, AstNode child
where
  parent1 != parent2 and
  child = getAChild(parent1) and
  child = getAChild(parent2)
select parent1.getPrimaryQlClasses(), parent2.getPrimaryQlClasses(), child.getPrimaryQlClasses()
