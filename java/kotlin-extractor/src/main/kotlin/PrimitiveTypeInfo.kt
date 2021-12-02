package com.github.codeql

import org.jetbrains.kotlin.backend.common.extensions.IrPluginContext
import org.jetbrains.kotlin.ir.declarations.IrClass
import org.jetbrains.kotlin.ir.types.IrSimpleType
import org.jetbrains.kotlin.ir.types.IdSignatureValues
import org.jetbrains.kotlin.ir.util.IdSignature
import org.jetbrains.kotlin.name.FqName

class PrimitiveTypeMapping(logger: Logger, pluginContext: IrPluginContext) {
    fun getPrimitiveInfo(s: IrSimpleType) = mapping[s.classifier.signature]

    data class PrimitiveTypeInfo(
        val primitiveName: String?,
        val otherIsPrimitive: Boolean,
        val javaClass: IrClass,
        val kotlinPackageName: String, val kotlinClassName: String
    )

    private fun findClass(fqName: String, fallback: IrClass, logger: Logger, pluginContext: IrPluginContext): IrClass {
        val symbol = pluginContext.referenceClass(FqName(fqName))
        if(symbol == null) {
            logger.warn("Can't find $fqName")
            // Do the best we can
            return fallback
        } else {
           return symbol.owner
        }
    }

    private val mapping = {
        val kotlinByte = pluginContext.irBuiltIns.byteClass.owner
        val javaLangByte = findClass("java.lang.Byte", kotlinByte, logger, pluginContext)
        val kotlinShort = pluginContext.irBuiltIns.shortClass.owner
        val javaLangShort = findClass("java.lang.Short", kotlinShort, logger, pluginContext)
        val kotlinInt = pluginContext.irBuiltIns.intClass.owner
        val javaLangInteger = findClass("java.lang.Integer", kotlinInt, logger, pluginContext)
        val kotlinLong = pluginContext.irBuiltIns.longClass.owner
        val javaLangLong = findClass("java.lang.Long", kotlinLong, logger, pluginContext)

        val kotlinUByte = findClass("kotlin.UByte", kotlinByte, logger, pluginContext)
        val kotlinUShort = findClass("kotlin.UShort", kotlinShort, logger, pluginContext)
        val kotlinUInt = findClass("kotlin.UInt", kotlinInt, logger, pluginContext)
        val kotlinULong = findClass("kotlin.ULong", kotlinLong, logger, pluginContext)

        val kotlinDouble = pluginContext.irBuiltIns.doubleClass.owner
        val javaLangDouble = findClass("java.lang.Double", kotlinDouble, logger, pluginContext)
        val kotlinFloat = pluginContext.irBuiltIns.floatClass.owner
        val javaLangFloat = findClass("java.lang.Float", kotlinFloat, logger, pluginContext)

        val kotlinBoolean = pluginContext.irBuiltIns.booleanClass.owner
        val javaLangBoolean = findClass("java.lang.Boolean", kotlinBoolean, logger, pluginContext)

        val kotlinChar = pluginContext.irBuiltIns.charClass.owner
        val javaLangCharacter = findClass("java.lang.Character", kotlinChar, logger, pluginContext)

        val kotlinUnit = pluginContext.irBuiltIns.unitClass.owner

        val kotlinNothing = pluginContext.irBuiltIns.nothingClass.owner
        val javaLangVoid = findClass("java.lang.Void", kotlinNothing, logger, pluginContext)

        mapOf(
            IdSignatureValues._byte to PrimitiveTypeInfo("byte", true, javaLangByte, "kotlin", "Byte"),
            IdSignatureValues._short to PrimitiveTypeInfo("short", true, javaLangShort, "kotlin", "Short"),
            IdSignatureValues._int to PrimitiveTypeInfo("int", true, javaLangInteger, "kotlin", "Int"),
            IdSignatureValues._long to PrimitiveTypeInfo("long", true, javaLangLong, "kotlin", "Long"),

            IdSignatureValues.uByte to PrimitiveTypeInfo("byte", true, kotlinUByte, "kotlin", "UByte"),
            IdSignatureValues.uShort to PrimitiveTypeInfo("short", true, kotlinUShort, "kotlin", "UShort"),
            IdSignatureValues.uInt to PrimitiveTypeInfo("int", true, kotlinUInt, "kotlin", "UInt"),
            IdSignatureValues.uLong to PrimitiveTypeInfo("long", true, kotlinULong, "kotlin", "ULong"),

            IdSignatureValues._double to PrimitiveTypeInfo("double", true, javaLangDouble, "kotlin", "Double"),
            IdSignatureValues._float to PrimitiveTypeInfo("float", true, javaLangFloat, "kotlin", "Float"),

            IdSignatureValues._boolean to PrimitiveTypeInfo("boolean", true, javaLangBoolean, "kotlin", "Boolean"),

            IdSignatureValues._char to PrimitiveTypeInfo("char", true, javaLangCharacter, "kotlin", "Char"),

            IdSignatureValues.unit to PrimitiveTypeInfo("void", false, kotlinUnit, "kotlin", "Unit"),
            IdSignatureValues.nothing to PrimitiveTypeInfo(null, true, javaLangVoid, "kotlin", "Nothing"),
        )
    }()
}
