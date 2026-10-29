class ClassOrInterface extends @classorinterface {
  string toString() { result = "class-or-interface" }
}

class Package extends @package {
  string toString() { result = "package" }
}

from ClassOrInterface id, string nodeName, Package parentId, ClassOrInterface sourceId
where classes_or_interfaces(id, nodeName, parentId, sourceId) and isInterface(id)
select id, nodeName, parentId, sourceId
