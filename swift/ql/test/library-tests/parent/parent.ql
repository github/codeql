import swift
import codeql.swift.generated.ParentChild
import TestUtils

from AstNode parent, AstNode child
where
  toBeTested(parent) and
  parent = getImmediateParent(child)
select parent, parent.getPrimaryQlClasses(), child, child.getPrimaryQlClasses()
