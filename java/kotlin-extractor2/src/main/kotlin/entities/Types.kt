package com.github.codeql

import com.github.codeql.KotlinUsesExtractor.TypeContext
import org.jetbrains.kotlin.analysis.api.types.KaClassType
import org.jetbrains.kotlin.analysis.api.types.KaType

private fun KotlinUsesExtractor.useClassType(
    c: KaClassType
): TypeResults {
    val javaResult = addClassLabel(c)
    val kotlinResult = TypeResult(fakeKotlinType() /* , "TODO", "TODO" */)
    return TypeResults(javaResult, kotlinResult)
}

fun KotlinUsesExtractor.useType(t: KaType, context: TypeContext = TypeContext.OTHER): TypeResults {
    when (t) {
        is KaClassType -> return useClassType(t)
        else -> TODO()
    }
    /*
    OLD: KE1
            when (t) {
                is IrSimpleType -> return useSimpleType(t, context)
                else -> {
                    logger.error("Unrecognised IrType: " + t.javaClass)
                    return extractErrorType()
                }
            }
    */
}
