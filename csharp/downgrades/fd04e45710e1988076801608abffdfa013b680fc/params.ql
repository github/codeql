class Parameter extends @parameter {
  string toString() { none() }
}

class TypeOrRef extends @type_or_ref {
  string toString() { none() }
}

class Parameterizable extends @parameterizable {
  string toString() { none() }
}

from
  Parameter p, string name, TypeOrRef typeId, int index, int mode, Parameterizable parentId,
  Parameter unboundId, int updatedMode
where
  params(p, name, typeId, index, mode, parentId, unboundId) and
  if mode = 6 then updatedMode = 0 else updatedMode = mode
select p, name, typeId, index, updatedMode, parentId, unboundId
