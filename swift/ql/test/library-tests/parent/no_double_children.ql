import swift
private import codeql.swift.generated.ParentChild

from AstNode parent, int index, AstNode child1, AstNode child2
where
  child1 != child2 and
  child1 = getImmediateChildAndAccessor(parent, index, _) and
  child2 = getImmediateChildAndAccessor(parent, index, _)
select parent, parent.getPrimaryQlClasses(), index, child1, child1.getPrimaryQlClasses(), child2,
  child2.getPrimaryQlClasses()
