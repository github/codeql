class ClassOrInterface extends @classorinterface {
  string toString() { none() }
}

from ClassOrInterface x, ClassOrInterface y
where
  classes_or_interfaces(x, _, _, y) and
  x != y
select x, y
