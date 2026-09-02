package com.github.codeql.utils.versions

import org.jetbrains.kotlin.ir.declarations.IrFunction
import org.jetbrains.kotlin.ir.declarations.IrMutableAnnotationContainer
import org.jetbrains.kotlin.ir.declarations.IrParameterKind
import org.jetbrains.kotlin.ir.declarations.IrValueParameter
import org.jetbrains.kotlin.ir.expressions.IrConstructorCall
import org.jetbrains.kotlin.ir.expressions.IrExpression
import org.jetbrains.kotlin.ir.expressions.IrMemberAccessExpression
import org.jetbrains.kotlin.ir.expressions.impl.IrConstructorCallImpl
import org.jetbrains.kotlin.ir.expressions.impl.fromSymbolOwner
import org.jetbrains.kotlin.ir.symbols.IrConstructorSymbol
import org.jetbrains.kotlin.ir.types.IrType
import org.jetbrains.kotlin.ir.types.addAnnotations

private fun IrParameterKind.isCodeQlValueParameter() =
    this == IrParameterKind.Context || this == IrParameterKind.Regular

val IrFunction.codeQlValueParameters: List<IrValueParameter>
    get() = parameters.filter { it.kind.isCodeQlValueParameter() }

val IrFunction.codeQlExtensionReceiverParameter: IrValueParameter?
    get() = extensionReceiverParameter

private fun IrMemberAccessExpression<*>.valueArgumentIndices(): List<Int> {
    val owner = symbol.owner as? IrFunction ?: return arguments.indices.toList()
    return owner.parameters.mapIndexedNotNull { index, parameter ->
        index.takeIf { parameter.kind.isCodeQlValueParameter() }
    }
}

val IrMemberAccessExpression<*>.codeQlValueArgumentsCount: Int
    get() = valueArgumentIndices().size

fun IrMemberAccessExpression<*>.codeQlGetValueArgument(index: Int): IrExpression? =
    arguments[valueArgumentIndices()[index]]

fun IrMemberAccessExpression<*>.codeQlPutValueArgument(index: Int, value: IrExpression?) {
    arguments[valueArgumentIndices()[index]] = value
}

val IrMemberAccessExpression<*>.codeQlExtensionReceiver: IrExpression?
    get() = extensionReceiver

val IrMemberAccessExpression<*>.codeQlTypeArgumentsCount: Int
    get() = typeArgumentsCount

fun IrMemberAccessExpression<*>.codeQlGetTypeArgument(index: Int): IrType? = getTypeArgument(index)

fun IrType.codeQlAddAnnotations(annotations: List<IrConstructorCall>): IrType =
    addAnnotations(annotations)

fun codeQlSetAnnotations(
    container: IrMutableAnnotationContainer,
    annotations: List<IrConstructorCall>
) {
    container.annotations = annotations
}

fun IrFunction.codeQlSetDispatchReceiverParameter(param: IrValueParameter?) {
    dispatchReceiverParameter = param
}

fun codeQlAnnotationFromSymbolOwner(
    startOffset: Int,
    endOffset: Int,
    type: IrType,
    symbol: IrConstructorSymbol,
    typeArgumentsCount: Int
): IrConstructorCall =
    IrConstructorCallImpl.fromSymbolOwner(
        startOffset,
        endOffset,
        type,
        symbol,
        typeArgumentsCount
    )

fun codeQlAnnotationFromSymbolOwner(
    type: IrType,
    symbol: IrConstructorSymbol
): IrConstructorCall = IrConstructorCallImpl.fromSymbolOwner(type, symbol)
