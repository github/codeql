class ClassOrInterface extends @classorinterface {
  string toString() { result = "class-or-interface" }
}

class Package extends @package {
  string toString() { result = "package" }
}

from ClassOrInterface id, string nodeName, Package parentId, ClassOrInterface sourceId
where classes(id, nodeName, parentId, sourceId) or interfaces(id, nodeName, parentId, sourceId)
select id, nodeName, parentId, sourceId
