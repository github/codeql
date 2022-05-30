import swift

from AstNode parent, AstNode child
where
  parent = child.getParent() and parent.getLocation().getFile().getName().matches("%swift/ql/test%")
select parent, parent.getPrimaryQlClasses(), child, child.getPrimaryQlClasses()
