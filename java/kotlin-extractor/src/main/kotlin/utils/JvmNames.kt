package com.github.codeql.utils

import com.github.codeql.utils.versions.allOverriddenIncludingSelf
import com.github.codeql.utils.versions.CodeQLIrConst
import org.jetbrains.kotlin.builtins.StandardNames
import org.jetbrains.kotlin.ir.declarations.IrAnnotationContainer
import org.jetbrains.kotlin.ir.declarations.IrClass
import org.jetbrains.kotlin.ir.declarations.IrFunction
import org.jetbrains.kotlin.ir.declarations.IrSimpleFunction
import org.jetbrains.kotlin.ir.expressions.IrConstructorCall
import org.jetbrains.kotlin.ir.types.IrSimpleType
import org.jetbrains.kotlin.ir.util.fqNameWhenAvailable
import org.jetbrains.kotlin.ir.util.packageFqName
import org.jetbrains.kotlin.ir.util.parentClassOrNull
import org.jetbrains.kotlin.name.FqName
import org.jetbrains.kotlin.name.Name

private data class MethodKey(val className: FqName, val functionName: Name)

private fun makeDescription(className: FqName, functionName: String) =
    MethodKey(className, Name.guessByFirstCharacter(functionName))

// This essentially mirrors SpecialBridgeMethods.kt, a backend pass which isn't easily available to
// our extractor.
private val specialFunctions =
    mapOf(
        makeDescription(StandardNames.FqNames.collection, "<get-size>") to "size",
        makeDescription(FqName("java.util.Collection"), "<get-size>") to "size",
        makeDescription(StandardNames.FqNames.map, "<get-size>") to "size",
        makeDescription(FqName("java.util.Map"), "<get-size>") to "size",
        makeDescription(StandardNames.FqNames.charSequence.toSafe(), "<get-length>") to "length",
        makeDescription(FqName("java.lang.CharSequence"), "<get-length>") to "length",
        makeDescription(StandardNames.FqNames.map, "<get-keys>") to "keySet",
        makeDescription(FqName("java.util.Map"), "<get-keys>") to "keySet",
        makeDescription(StandardNames.FqNames.map, "<get-values>") to "values",
        makeDescription(FqName("java.util.Map"), "<get-values>") to "values",
        makeDescription(StandardNames.FqNames.map, "<get-entries>") to "entrySet",
        makeDescription(FqName("java.util.Map"), "<get-entries>") to "entrySet",
        makeDescription(StandardNames.FqNames.mutableList, "removeAt") to "remove",
        makeDescription(FqName("java.util.List"), "removeAt") to "remove",
        makeDescription(StandardNames.FqNames._enum.toSafe(), "<get-ordinal>") to "ordinal",
        makeDescription(FqName("java.lang.Enum"), "<get-ordinal>") to "ordinal",
        makeDescription(StandardNames.FqNames._enum.toSafe(), "<get-name>") to "name",
        makeDescription(FqName("java.lang.Enum"), "<get-name>") to "name",
        makeDescription(StandardNames.FqNames.number.toSafe(), "toByte") to "byteValue",
        makeDescription(FqName("java.lang.Number"), "toByte") to "byteValue",
        makeDescription(StandardNames.FqNames.number.toSafe(), "toShort") to "shortValue",
        makeDescription(FqName("java.lang.Number"), "toShort") to "shortValue",
        makeDescription(StandardNames.FqNames.number.toSafe(), "toInt") to "intValue",
        makeDescription(FqName("java.lang.Number"), "toInt") to "intValue",
        makeDescription(StandardNames.FqNames.number.toSafe(), "toLong") to "longValue",
        makeDescription(FqName("java.lang.Number"), "toLong") to "longValue",
        makeDescription(StandardNames.FqNames.number.toSafe(), "toFloat") to "floatValue",
        makeDescription(FqName("java.lang.Number"), "toFloat") to "floatValue",
        makeDescription(StandardNames.FqNames.number.toSafe(), "toDouble") to "doubleValue",
        makeDescription(FqName("java.lang.Number"), "toDouble") to "doubleValue",
        makeDescription(StandardNames.FqNames.string.toSafe(), "get") to "charAt",
        makeDescription(FqName("java.lang.String"), "get") to "charAt",
    )

private val specialFunctionShortNames = specialFunctions.keys.map { it.functionName }.toSet()

private fun getSpecialJvmName(f: IrFunction): String? {
    if (specialFunctionShortNames.contains(f.name) && f is IrSimpleFunction) {
        f.allOverriddenIncludingSelf().forEach { overriddenFunc ->
            overriddenFunc.parentClassOrNull?.fqNameWhenAvailable?.let { parentFqName ->
                specialFunctions[MethodKey(parentFqName, f.name)]?.let {
                    return it
                }
            }
        }
    }
    return null
}

fun getJvmName(container: IrAnnotationContainer): String? {
    for (a: IrConstructorCall in container.annotations) {
        val t = a.type
        if (t is IrSimpleType && a.valueArgumentsCount == 1) {
            val owner = t.classifier.owner
            val v = a.getValueArgument(0)
            if (owner is IrClass) {
                val aPkg = owner.packageFqName?.asString()
                val name = owner.name.asString()
                if (aPkg == "kotlin.jvm" && name == "JvmName" && v is CodeQLIrConst<*>) {
                    val value = v.value
                    if (value is String) {
                        return value
                    }
                }
            }
        }
    }
    return (container as? IrFunction)?.let { getSpecialJvmName(container) }
}
