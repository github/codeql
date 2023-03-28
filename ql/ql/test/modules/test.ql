import ql

query Type getTarget(TypeRef me) { result = me.getResolvedModule().toType() }

query Type getTargetType(TypeRef me) { result = me.getResolvedType() }
