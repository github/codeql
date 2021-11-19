package com.github.codeql

import org.jetbrains.kotlin.ir.types.IdSignatureValues

data class PrimitiveTypeInfo(
    val primitiveName: String?,
    val javaPackageName: String, val javaClassName: String,
    val kotlinPackageName: String, val kotlinClassName: String
)

val primitiveTypeMapping = mapOf(
    IdSignatureValues._byte to PrimitiveTypeInfo("byte", "java.lang", "Byte", "kotlin", "Byte"),
    IdSignatureValues._short to PrimitiveTypeInfo("short", "java.lang", "Short", "kotlin", "Short"),
    IdSignatureValues._int to PrimitiveTypeInfo("int", "java.lang", "Integer", "kotlin", "Int"),
    IdSignatureValues._long to PrimitiveTypeInfo("long", "java.lang", "Long", "kotlin", "Long"),

    IdSignatureValues.uByte to PrimitiveTypeInfo("byte", "kotlin", "UByte", "kotlin", "UByte"),
    IdSignatureValues.uShort to PrimitiveTypeInfo("short", "kotlin", "UShort", "kotlin", "UShort"),
    IdSignatureValues.uInt to PrimitiveTypeInfo("int", "kotlin", "UInt", "kotlin", "UInt"),
    IdSignatureValues.uLong to PrimitiveTypeInfo("long", "kotlin", "ULong", "kotlin", "ULong"),

    IdSignatureValues._double to PrimitiveTypeInfo("double", "java.lang", "Double", "kotlin", "Double"),
    IdSignatureValues._float to PrimitiveTypeInfo("float", "java.lang", "Float", "kotlin", "Float"),

    IdSignatureValues._boolean to PrimitiveTypeInfo("boolean", "java.lang", "Boolean", "kotlin", "Boolean"),

    IdSignatureValues._char to PrimitiveTypeInfo("char", "java.lang", "Character", "kotlin", "Char"),

    IdSignatureValues.unit to PrimitiveTypeInfo("void", "java.lang", "Void", "kotlin", "Nothing"), // TODO: Is this right?
    IdSignatureValues.nothing to PrimitiveTypeInfo(null, "java.lang", "Void", "kotlin", "Nothing"), // TODO: Is this right?
)
