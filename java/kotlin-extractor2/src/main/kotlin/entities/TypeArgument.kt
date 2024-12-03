package com.github.codeql.entities

import com.github.codeql.*
import org.jetbrains.kotlin.analysis.api.KaSession
import org.jetbrains.kotlin.analysis.api.types.KaStarTypeProjection
import org.jetbrains.kotlin.analysis.api.types.KaTypeArgumentWithVariance
import org.jetbrains.kotlin.analysis.api.types.KaTypeProjection
import org.jetbrains.kotlin.types.Variance

context(KaSession)
fun KotlinUsesExtractor.getTypeArgumentLabel(arg: KaTypeProjection): TypeResultWithoutSignature<DbReftype> {

    fun extractBoundedWildcard(
        wildcardKind: Int,
        wildcardLabelStr: String,
        wildcardShortName: String,
        boundLabel: Label<out DbReftype>
    ): Label<DbWildcard> =
        tw.getLabelFor(wildcardLabelStr) { wildcardLabel ->
            tw.writeWildcards(wildcardLabel, wildcardShortName, wildcardKind)
            tw.writeHasLocation(wildcardLabel, tw.unknownLocation)
            tw.getLabelFor<DbTypebound>("@\"bound;0;{$wildcardLabel}\"") {
                tw.writeTypeBounds(it, boundLabel, 0, wildcardLabel)
            }
        }

    // Note this function doesn't return a signature because type arguments are never
    // incorporated into function signatures.
    return when (arg) {
        is KaStarTypeProjection -> {
            val anyTypeLabel =
                useType(builtinTypes.any).javaResult.id.cast<DbReftype>()
            TypeResultWithoutSignature(
                extractBoundedWildcard(1, "@\"wildcard;\"", "?", anyTypeLabel),
                /* OLD: KE1
                Unit, */
                "?"
            )
        }
        is KaTypeArgumentWithVariance -> {
            val boundResults = useType(arg.type, TypeContext.GENERIC_ARGUMENT)
            val boundLabel = boundResults.javaResult.id.cast<DbReftype>()

            if (arg.variance == Variance.INVARIANT)
                boundResults.javaResult.cast<DbReftype>().forgetSignature()
            else {
                val keyPrefix = if (arg.variance == Variance.IN_VARIANCE) "super" else "extends"
                val wildcardKind = if (arg.variance == Variance.IN_VARIANCE) 2 else 1
                val wildcardShortName = "? $keyPrefix ${boundResults.javaResult.shortName}"
                TypeResultWithoutSignature(
                    extractBoundedWildcard(
                        wildcardKind,
                        "@\"wildcard;$keyPrefix{$boundLabel}\"",
                        wildcardShortName,
                        boundLabel
                    ),
                    /* OLD: KE1
                    Unit,
                    */
                    wildcardShortName
                )
            }
        }
        else -> {
            logger.error("Unexpected type argument.")
            extractJavaErrorType().forgetSignature()
        }
    }
}