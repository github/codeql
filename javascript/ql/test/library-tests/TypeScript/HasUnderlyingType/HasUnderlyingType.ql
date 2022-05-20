import javascript

from Expr e, TypeName typeName
where e.getType().hasUnderlyingTypeName(typeName)
select e, typeName

query API::Node underlyingTypeNode(string mod, string name) {
  result = API::Node::ofType(mod, name)
}
