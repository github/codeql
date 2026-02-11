class TypeVariable extends @typevariable {
  string toString() { none() }
}

class ClassOrInterfaceOrCallable extends @classorinterfaceorcallable {
  string toString() { none() }
}

from TypeVariable id, string nodeName, int pos, ClassOrInterfaceOrCallable parentid
where typeVars(id, nodeName, pos, _, parentid)
select id, nodeName, pos, parentid
