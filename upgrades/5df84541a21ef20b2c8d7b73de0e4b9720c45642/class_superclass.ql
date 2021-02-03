class Superclass extends @superclass {
  string toString() { result = "" }
}

class Class extends @class {
  string toString() { result = "" }
}

// Select the 0th child if it's a @superclass
from Class c, Superclass sc
where class_child(c, 0, sc)
select c, sc
