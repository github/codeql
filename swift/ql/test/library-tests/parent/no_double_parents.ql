import swift

from AstNode parent1, AstNode parent2, AstNode child
where
  parent1 != parent2 and
  not exists(parent1.getResolveStep()) and
  not exists(parent2.getResolveStep()) and
  child = parent1.getAChild() and
  child = parent2.getAChild()
select parent1.getPrimaryQlClasses(), parent2.getPrimaryQlClasses(), child.getPrimaryQlClasses()
