package com.github.codeql

import com.github.codeql.utils.*
import com.github.codeql.utils.versions.*
import org.jetbrains.kotlin.backend.common.extensions.IrPluginContext
import org.jetbrains.kotlin.builtins.StandardNames
import org.jetbrains.kotlin.ir.declarations.IrClass
import org.jetbrains.kotlin.ir.declarations.IrPackageFragment
import org.jetbrains.kotlin.ir.types.IrSimpleType
import org.jetbrains.kotlin.ir.types.classOrNull

class PrimitiveTypeMapping(val logger: Logger, val pluginContext: IrPluginContext) {
    fun getPrimitiveInfo(s: IrSimpleType) =
        s.classOrNull?.let {
            if (
                (it.owner.parent as? IrPackageFragment)?.packageFqName ==
                    StandardNames.BUILT_INS_PACKAGE_FQ_NAME
            )
                mapping[it.owner.name]
            else null
        }

    data class PrimitiveTypeInfo(
        val primitiveName: String?,
        val otherIsPrimitive: Boolean,
        val javaClass: IrClass,
        val kotlinPackageName: String,
        val kotlinClassName: String
    )

    private fun findClass(fqName: String, fallback: IrClass): IrClass {
        val symbol = getClassByFqName(pluginContext, fqName)
        if (symbol == null) {
            logger.warn("Can't find $fqName")
            // Do the best we can
            return fallback
        } else {
            return symbol.owner
        }
    }

    private val mapping =
        {
            val kotlinByte = pluginContext.irBuiltIns.byteClass.owner
            val javaLangByte = findClass("java.lang.Byte", kotlinByte)
            val kotlinShort = pluginContext.irBuiltIns.shortClass.owner
            val javaLangShort = findClass("java.lang.Short", kotlinShort)
            val kotlinInt = pluginContext.irBuiltIns.intClass.owner
            val javaLangInteger = findClass("java.lang.Integer", kotlinInt)
            val kotlinLong = pluginContext.irBuiltIns.longClass.owner
            val javaLangLong = findClass("java.lang.Long", kotlinLong)

            val kotlinUByte = findClass("kotlin.UByte", kotlinByte)
            val kotlinUShort = findClass("kotlin.UShort", kotlinShort)
            val kotlinUInt = findClass("kotlin.UInt", kotlinInt)
            val kotlinULong = findClass("kotlin.ULong", kotlinLong)

            val kotlinDouble = pluginContext.irBuiltIns.doubleClass.owner
            val javaLangDouble = findClass("java.lang.Double", kotlinDouble)
            val kotlinFloat = pluginContext.irBuiltIns.floatClass.owner
            val javaLangFloat = findClass("java.lang.Float", kotlinFloat)

            val kotlinBoolean = pluginContext.irBuiltIns.booleanClass.owner
            val javaLangBoolean = findClass("java.lang.Boolean", kotlinBoolean)

            val kotlinChar = pluginContext.irBuiltIns.charClass.owner
            val javaLangCharacter = findClass("java.lang.Character", kotlinChar)

            val kotlinUnit = pluginContext.irBuiltIns.unitClass.owner

            val kotlinNothing = pluginContext.irBuiltIns.nothingClass.owner
            val javaLangVoid = findClass("java.lang.Void", kotlinNothing)

            mapOf(
                StandardNames.FqNames._byte.shortName() to
                    PrimitiveTypeInfo("byte", true, javaLangByte, "kotlin", "Byte"),
                StandardNames.FqNames._short.shortName() to
                    PrimitiveTypeInfo("short", true, javaLangShort, "kotlin", "Short"),
                StandardNames.FqNames._int.shortName() to
                    PrimitiveTypeInfo("int", true, javaLangInteger, "kotlin", "Int"),
                StandardNames.FqNames._long.shortName() to
                    PrimitiveTypeInfo("long", true, javaLangLong, "kotlin", "Long"),
                StandardNames.FqNames.uByteFqName.shortName() to
                    PrimitiveTypeInfo("byte", true, kotlinUByte, "kotlin", "UByte"),
                StandardNames.FqNames.uShortFqName.shortName() to
                    PrimitiveTypeInfo("short", true, kotlinUShort, "kotlin", "UShort"),
                StandardNames.FqNames.uIntFqName.shortName() to
                    PrimitiveTypeInfo("int", true, kotlinUInt, "kotlin", "UInt"),
                StandardNames.FqNames.uLongFqName.shortName() to
                    PrimitiveTypeInfo("long", true, kotlinULong, "kotlin", "ULong"),
                StandardNames.FqNames._double.shortName() to
                    PrimitiveTypeInfo("double", true, javaLangDouble, "kotlin", "Double"),
                StandardNames.FqNames._float.shortName() to
                    PrimitiveTypeInfo("float", true, javaLangFloat, "kotlin", "Float"),
                StandardNames.FqNames._boolean.shortName() to
                    PrimitiveTypeInfo("boolean", true, javaLangBoolean, "kotlin", "Boolean"),
                StandardNames.FqNames._char.shortName() to
                    PrimitiveTypeInfo("char", true, javaLangCharacter, "kotlin", "Char"),
                StandardNames.FqNames.unit.shortName() to
                    PrimitiveTypeInfo("void", false, kotlinUnit, "kotlin", "Unit"),
                StandardNames.FqNames.nothing.shortName() to
                    PrimitiveTypeInfo(null, true, javaLangVoid, "kotlin", "Nothing"),
            )
        }()
}
