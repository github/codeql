import swift
private import codeql.swift.generated.ParentChild

from AstNode parent, int index1, int index2, AstNode child
where
  index1 != index2 and
  child = getImmediateChildAndAccessor(parent, index1, _) and
  child = getImmediateChildAndAccessor(parent, index2, _)
select parent, parent.getPrimaryQlClasses(), child, child.getPrimaryQlClasses(), index1, index2
