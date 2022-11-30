import ql

query Type getTarget(TypeRef me) { result = me.getResolvedModule().toType() }
