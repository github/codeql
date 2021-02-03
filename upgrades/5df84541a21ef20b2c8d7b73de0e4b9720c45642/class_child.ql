class Superclass extends @superclass {
  string toString() { result = "" }
}

class Class extends @class {
  string toString() { result = "" }
}

class ClassChildType extends @class_child_type {
  string toString() { result = "" }
}

// Select all non-superclass children.
// If the 0th child is a superclass, shuffle all the indexes down one. (Having
// superclass children at other indexes is allowed in the old dbscheme, but
// doesn't happen in practice, given the tree-sitter grammar).
from Class c, int oldIndex, ClassChildType child, int newIndex
where
  class_child(c, oldIndex, child) and
  (
    if exists(Superclass sc | class_child(c, 0, sc))
    then newIndex = oldIndex - 1
    else newIndex = oldIndex
  ) and
  not child instanceof Superclass
select c, newIndex, child
