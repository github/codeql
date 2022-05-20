class Type extends @type {
  string toString() { none() }

  string getNewName() {
    not this instanceof Generic and
    types(this, _, result)
    or
    result = this.(Generic).getUndecoratedName()
  }
}

class Generic extends Type {
  Generic() {
    type_parameters(_, _, this, _) or
    type_arguments(_, _, this)
  }

  string getUndecoratedName() {
    exists(string oldName |
      types(this, _, oldName) and result = oldName.prefix(min(int i | i = oldName.indexOf("<")))
    )
  }
}

from Type type, int kind
where types(type, kind, _)
select type, kind, type.getNewName()
