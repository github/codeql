import swift
private import codeql.swift.generated.ParentChild

from AstNode parent1, AstNode parent2, AstNode child
where
  parent1 != parent2 and
  child = getImmediateChildAndAccessor(parent1, _, _) and
  child = getImmediateChildAndAccessor(parent2, _, _)
select parent1, parent1.getPrimaryQlClasses(), parent2, parent2.getPrimaryQlClasses(), child,
  child.getPrimaryQlClasses()
