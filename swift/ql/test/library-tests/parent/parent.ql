import swift
import codeql.swift.generated.GetImmediateParent

from AstNode parent, AstNode child
where
  parent = getImmediateParent(child) and
  parent.getLocation().getFile().getName().matches("%swift/ql/test%")
select parent, parent.getPrimaryQlClasses(), child, child.getPrimaryQlClasses()
