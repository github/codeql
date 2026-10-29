class Field extends @field {
  string toString() { none() }
}

class Type extends @type {
  string toString() { none() }
}

class RefType extends @reftype {
  string toString() { none() }
}

from Field f, string name, Type t, RefType parent
where fields(f, name, t, parent, _)
select f, name, t, parent
