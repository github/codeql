/**
 * Java-spscific predicates used by the implementation of `SemanticType`.
 */

private import java as J

class Type = J::Type;

class OpaqueTypeTag = J::ClassOrInterface;

private int pointerSize() { result = 8 }

predicate voidType(Type type) { type instanceof J::VoidType }

predicate addressType(Type type, int byteSize) {
  type instanceof J::ClassOrInterface and
  byteSize = pointerSize()
}

predicate functionAddressType(Type type, int byteSize) { none() }

predicate errorType(Type type) { none() }

predicate unknownType(Type type) { none() }

predicate booleanType(Type type, int byteSize) {
  type.(J::PrimitiveType).hasName("boolean") and byteSize = 1
}

predicate floatingPointType(Type type, int byteSize) {
  exists(J::PrimitiveType primType | primType = type |
    primType.hasName("float") and byteSize = 4
    or
    primType.hasName("double") and byteSize = 8
  )
}

predicate integerType(Type type, int byteSize, boolean signed) {
  exists(J::PrimitiveType primType | primType = type |
    primType.hasName("byte") and byteSize = 1 and signed = false
    or
    primType.hasName("char") and byteSize = 2 and signed = false
    or
    primType.hasName("short") and byteSize = 2 and signed = true
    or
    primType.hasName("int") and byteSize = 4 and signed = true
    or
    primType.hasName("long") and byteSize = 8 and signed = true
  )
}

predicate opaqueType(Type type, int byteSize, OpaqueTypeTag taq) { none() }

string getOpaqueTagIdentityString(OpaqueTypeTag tag) { none() }
