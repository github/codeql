package com.github.codeql.utils.versions

import org.jetbrains.kotlin.ir.expressions.IrConstructorCall
import org.jetbrains.kotlin.ir.symbols.IrClassifierSymbol
import org.jetbrains.kotlin.ir.types.IrSimpleType
import org.jetbrains.kotlin.ir.types.IrTypeArgument
import org.jetbrains.kotlin.ir.types.SimpleTypeNullability
import org.jetbrains.kotlin.ir.types.impl.IrSimpleTypeImpl

fun codeqlIrSimpleTypeImpl(
    classifier: IrClassifierSymbol,
    isNullable: Boolean,
    arguments: List<IrTypeArgument>,
    annotations: List<IrConstructorCall>
): IrSimpleType = IrSimpleTypeImpl(
    classifier,
    SimpleTypeNullability.fromHasQuestionMark(isNullable),
    arguments,
    annotations,
    null  // originalKotlinType - explicitly pass null to avoid default parameter issues
)
