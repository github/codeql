class Import extends @import {
  string toString() { none() }
}

class ClassOrInterface extends @classorinterface  {
  string toString() { none() }
}

from Import imp, ClassOrInterface holder, string name, int kind
where
  imports(imp, holder, name, kind) and kind != 6
select imp, holder, name, kind
