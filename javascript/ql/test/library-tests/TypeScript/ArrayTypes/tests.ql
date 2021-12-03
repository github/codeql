import javascript

query predicate arrayTypes(ArrayType array, string elem) {
  elem = "`" + array.getArrayElementType() + "`"
}

query predicate numberIndexTypes(Type type, Type numType) { type.getNumberIndexType() = numType }

query predicate stringIndexTypes(Type type, Type strType) { type.getStringIndexType() = strType }

query predicate tupleTypes(TupleType type, Type arrType) { arrType = type.getUnderlyingArrayType() }
