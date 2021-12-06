package com.github.codeql.utils

import org.jetbrains.kotlin.ir.declarations.IrTypeParameter
import org.jetbrains.kotlin.ir.symbols.IrTypeParameterSymbol
import org.jetbrains.kotlin.ir.types.*
import org.jetbrains.kotlin.ir.types.impl.IrSimpleTypeImpl
import org.jetbrains.kotlin.ir.types.impl.IrStarProjectionImpl
import org.jetbrains.kotlin.ir.types.impl.makeTypeProjection
import org.jetbrains.kotlin.types.Variance

fun IrType.substituteTypeArguments(params: List<IrTypeParameter>, arguments: List<IrTypeArgument>) =
    when(this) {
        is IrSimpleType -> substituteTypeArguments(params.map { it.symbol }.zip(arguments).toMap())
        else -> this
    }

/**
 * Returns true if substituting `innerVariance T` into the context `outerVariance []` discards all knowledge about
 * what T could be.
 *
 * Note this throws away slightly more information than it could: for example, the projection "in (out List)" can refer to
 * any superclass of anything that implements List, which specifically excludes e.g. String, but can't be represented as
 * a type projection. The projection "out (in List)" on the other hand really is equivalent to "out Any?", which is to
 * say no bound at all.
 */
private fun conflictingVariance(outerVariance: Variance, innerVariance: Variance) =
    (outerVariance == Variance.IN_VARIANCE && innerVariance == Variance.OUT_VARIANCE) ||
            (outerVariance == Variance.OUT_VARIANCE && innerVariance == Variance.IN_VARIANCE)

/**
 * When substituting `innerVariance T` into the context `outerVariance []`, returns the variance part of the result
 * `resultVariance T`. We already know they don't conflict.
 */
private fun combineVariance(outerVariance: Variance, innerVariance: Variance) =
    when {
        outerVariance != Variance.INVARIANT -> outerVariance
        innerVariance != Variance.INVARIANT -> innerVariance
        else -> Variance.INVARIANT
    }

private fun subProjectedType(substitutionMap: Map<IrTypeParameterSymbol, IrTypeArgument>, t: IrSimpleType, outerVariance: Variance): IrTypeArgument =
    substitutionMap[t.classifier]?.let { substitutedTypeArg ->
        if (substitutedTypeArg is IrTypeProjection) {
            if (conflictingVariance(outerVariance, substitutedTypeArg.variance))
                IrStarProjectionImpl
            else {
                val newProjectedType = substitutedTypeArg.type.let { if (t.hasQuestionMark) it.withHasQuestionMark(true) else it }
                val newVariance = combineVariance(outerVariance, substitutedTypeArg.variance)
                makeTypeProjection(newProjectedType, newVariance)
            }
        } else {
            substitutedTypeArg
        }
    } ?: makeTypeProjection(t.substituteTypeArguments(substitutionMap), outerVariance)

fun IrSimpleType.substituteTypeArguments(substitutionMap: Map<IrTypeParameterSymbol, IrTypeArgument>): IrSimpleType {
    if (substitutionMap.isEmpty()) return this

    val newArguments = arguments.map {
        if (it is IrTypeProjection) {
            val itType = it.type
            if (itType is IrSimpleType) {
                subProjectedType(substitutionMap, itType, it.variance)
            } else {
                it
            }
        } else {
            it
        }
    }

    return IrSimpleTypeImpl(
        classifier,
        hasQuestionMark,
        newArguments,
        annotations
    )
}
