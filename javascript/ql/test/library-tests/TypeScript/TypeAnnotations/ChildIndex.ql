import javascript

from ASTNode node, ASTNode child1, ASTNode child2, int index
where
  node.getChild(index) = child1 and
  node.getChild(index) = child2 and
  child1 != child2
select node, "There are two different children at index " + index
