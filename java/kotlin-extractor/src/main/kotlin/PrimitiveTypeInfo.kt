package com.github.codeql

import org.jetbrains.kotlin.ir.types.IdSignatureValues

data class PrimitiveTypeInfo(
    val primitiveName: String?,
    val otherIsPrimitive: Boolean,
    val javaPackageName: String, val javaClassName: String,
    val kotlinPackageName: String, val kotlinClassName: String
)

val primitiveTypeMapping = mapOf(
    IdSignatureValues._byte to PrimitiveTypeInfo("byte", true, "java.lang", "Byte", "kotlin", "Byte"),
    IdSignatureValues._short to PrimitiveTypeInfo("short", true, "java.lang", "Short", "kotlin", "Short"),
    IdSignatureValues._int to PrimitiveTypeInfo("int", true, "java.lang", "Integer", "kotlin", "Int"),
    IdSignatureValues._long to PrimitiveTypeInfo("long", true, "java.lang", "Long", "kotlin", "Long"),

    IdSignatureValues.uByte to PrimitiveTypeInfo("byte", true, "kotlin", "UByte", "kotlin", "UByte"),
    IdSignatureValues.uShort to PrimitiveTypeInfo("short", true, "kotlin", "UShort", "kotlin", "UShort"),
    IdSignatureValues.uInt to PrimitiveTypeInfo("int", true, "kotlin", "UInt", "kotlin", "UInt"),
    IdSignatureValues.uLong to PrimitiveTypeInfo("long", true, "kotlin", "ULong", "kotlin", "ULong"),

    IdSignatureValues._double to PrimitiveTypeInfo("double", true, "java.lang", "Double", "kotlin", "Double"),
    IdSignatureValues._float to PrimitiveTypeInfo("float", true, "java.lang", "Float", "kotlin", "Float"),

    IdSignatureValues._boolean to PrimitiveTypeInfo("boolean", true, "java.lang", "Boolean", "kotlin", "Boolean"),

    IdSignatureValues._char to PrimitiveTypeInfo("char", true, "java.lang", "Character", "kotlin", "Char"),

    IdSignatureValues.unit to PrimitiveTypeInfo("void", false, "kotlin", "Unit", "kotlin", "Unit"),
    IdSignatureValues.nothing to PrimitiveTypeInfo(null, true, "java.lang", "Void", "kotlin", "Nothing"),
)
