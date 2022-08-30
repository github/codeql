import swift
import codeql.swift.generated.ParentChild
import TestUtils

from AstNode parent, AstNode child, int index, string accessor
where
  toBeTested(parent) and
  child = getImmediateChildAndAccessor(parent, index, accessor)
select parent, index, accessor, child
