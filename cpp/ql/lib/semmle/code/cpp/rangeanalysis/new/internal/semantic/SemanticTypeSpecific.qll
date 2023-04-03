/**
 * C++-specific implementation of the semantic type system.
 */

private import semmle.code.cpp.ir.IR as IR
private import cpp as Cpp
private import semmle.code.cpp.ir.internal.IRCppLanguage as Language

class Type = IR::IRType;

class OpaqueTypeTag = Language::OpaqueTypeTag;

predicate voidType(Type type) { type instanceof IR::IRVoidType }

predicate errorType(Type type) { type instanceof IR::IRErrorType }

predicate unknownType(Type type) { type instanceof IR::IRUnknownType }

predicate booleanType(Type type, int byteSize) { byteSize = type.(IR::IRBooleanType).getByteSize() }

predicate integerType(Type type, int byteSize, boolean signed) {
  byteSize = type.(IR::IRSignedIntegerType).getByteSize() and signed = true
  or
  byteSize = type.(IR::IRUnsignedIntegerType).getByteSize() and signed = false
}

predicate floatingPointType(Type type, int byteSize) {
  byteSize = type.(IR::IRFloatingPointType).getByteSize()
}

predicate addressType(Type type, int byteSize) { byteSize = type.(IR::IRAddressType).getByteSize() }

predicate functionAddressType(Type type, int byteSize) {
  byteSize = type.(IR::IRFunctionAddressType).getByteSize()
}

predicate opaqueType(Type type, int byteSize, OpaqueTypeTag tag) {
  exists(IR::IROpaqueType opaque | opaque = type |
    byteSize = opaque.getByteSize() and tag = opaque.getTag()
  )
}

predicate getOpaqueTagIdentityString = Language::getOpaqueTagIdentityString/1;
