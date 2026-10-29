class TypeVariable extends @typevariable {
  string toString() { none() }
}

class ClassOrInterfaceOrCallable extends @classorinterfaceorcallable {
  string toString() { none() }
}

from TypeVariable id, string nodeName, int pos, ClassOrInterfaceOrCallable parentid
where typeVars(id, nodeName, pos, parentid)
select id, nodeName, pos, 0, parentid
