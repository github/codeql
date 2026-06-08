@file:Suppress("DEPRECATION")

package com.github.codeql.utils.versions

import org.jetbrains.kotlin.ir.declarations.IrFunction
import org.jetbrains.kotlin.ir.declarations.IrValueParameter
import org.jetbrains.kotlin.ir.expressions.IrAnnotation
import org.jetbrains.kotlin.ir.expressions.IrConstructorCall
import org.jetbrains.kotlin.ir.expressions.IrExpression
import org.jetbrains.kotlin.ir.expressions.IrMemberAccessExpression
import org.jetbrains.kotlin.ir.expressions.impl.IrAnnotationImpl
import org.jetbrains.kotlin.ir.expressions.impl.fromSymbolOwner
import org.jetbrains.kotlin.ir.symbols.IrConstructorSymbol
import org.jetbrains.kotlin.ir.types.IrType
import org.jetbrains.kotlin.ir.types.addAnnotations

/**
 * Compatibility accessors for pre-2.4.0 API patterns.
 * In 2.4.0, valueParameters/extensionReceiverParameter/extensionReceiver/
 * getValueArgument/putValueArgument/valueArgumentsCount/typeArgumentsCount/getTypeArgument
 * have been removed. This file provides the 2.4.0 implementations.
 */

// IrFunction: valueParameters -> parameters filtered to Regular kind
val IrFunction.codeQlValueParameters: List<IrValueParameter>
    get() = parameters.filter { it.kind == org.jetbrains.kotlin.ir.declarations.IrParameterKind.Regular }

// IrFunction: extensionReceiverParameter
val IrFunction.codeQlExtensionReceiverParameter: IrValueParameter?
    get() = parameters.firstOrNull { it.kind == org.jetbrains.kotlin.ir.declarations.IrParameterKind.ExtensionReceiver }

// Helper: get the offset of value arguments in the arguments list
// In 2.4.0, arguments[] includes dispatch/extension receivers before regular params
private fun IrMemberAccessExpression<*>.valueArgumentOffset(): Int {
    val owner = symbol.owner as? IrFunction ?: return 0
    return owner.parameters.count { it.kind != org.jetbrains.kotlin.ir.declarations.IrParameterKind.Regular }
}

// IrMemberAccessExpression: valueArgumentsCount
val IrMemberAccessExpression<*>.codeQlValueArgumentsCount: Int
    get() = arguments.size - valueArgumentOffset()

// IrMemberAccessExpression: getValueArgument
fun IrMemberAccessExpression<*>.codeQlGetValueArgument(index: Int): IrExpression? = arguments[index + valueArgumentOffset()]

// IrMemberAccessExpression: putValueArgument
fun IrMemberAccessExpression<*>.codeQlPutValueArgument(index: Int, value: IrExpression?) {
    arguments[index + valueArgumentOffset()] = value
}

// IrMemberAccessExpression: extensionReceiver
// For IrCall/IrFunctionReference, look at symbol.owner (IrFunction) directly.
// For IrPropertyReference, symbol.owner is IrProperty; use the getter's parameters instead.
var IrMemberAccessExpression<*>.codeQlExtensionReceiver: IrExpression?
    get() {
        val erp = extensionReceiverParameterIndex() ?: return null
        return arguments[erp]
    }
    set(value) {
        val erp = extensionReceiverParameterIndex() ?: return
        arguments[erp] = value
    }

private fun IrMemberAccessExpression<*>.extensionReceiverParameterIndex(): Int? {
    // Direct function owner (IrCall, IrFunctionReference, etc.)
    (symbol.owner as? IrFunction)?.codeQlExtensionReceiverParameter?.let {
        return it.indexInParameters
    }
    // Property reference: look at getter or setter function
    (this as? org.jetbrains.kotlin.ir.expressions.IrPropertyReference)?.let { propRef ->
        propRef.getter?.owner?.codeQlExtensionReceiverParameter?.let {
            return it.indexInParameters
        }
        propRef.setter?.owner?.codeQlExtensionReceiverParameter?.let {
            return it.indexInParameters
        }
    }
    return null
}

// IrMemberAccessExpression: typeArgumentsCount
val IrMemberAccessExpression<*>.codeQlTypeArgumentsCount: Int
    get() = typeArguments.size

// IrMemberAccessExpression: getTypeArgument
fun IrMemberAccessExpression<*>.codeQlGetTypeArgument(index: Int): IrType? = typeArguments[index]

// addAnnotations compat: in 2.4.0, addAnnotations expects List<IrAnnotation>
// IrConstructorCall implements IrAnnotation in 2.4.0, so filterIsInstance is identity
fun IrType.codeQlAddAnnotations(annotations: List<IrConstructorCall>): IrType =
    addAnnotations(annotations.filterIsInstance<IrAnnotation>())

// IrMutableAnnotationContainer.annotations setter: in 2.4.0, expects List<IrAnnotation>
fun codeQlSetAnnotations(container: org.jetbrains.kotlin.ir.declarations.IrMutableAnnotationContainer, annotations: List<IrConstructorCall>) {
    container.annotations = annotations.filterIsInstance<IrAnnotation>()
}

// IrFunction: set dispatch receiver parameter
// In 2.4.0, dispatchReceiverParameter is val; modify the parameters list directly.
fun IrFunction.codeQlSetDispatchReceiverParameter(param: IrValueParameter?) {
    val existing = parameters.indexOfFirst { it.kind == org.jetbrains.kotlin.ir.declarations.IrParameterKind.DispatchReceiver }
    val mutableParams = parameters.toMutableList()
    if (existing >= 0) {
        if (param != null) {
            mutableParams[existing] = param
        } else {
            mutableParams.removeAt(existing)
        }
    } else if (param != null) {
        param.kind = org.jetbrains.kotlin.ir.declarations.IrParameterKind.DispatchReceiver
        mutableParams.add(0, param)
    }
    parameters = mutableParams
}

// In 2.4.0, annotation lists require IrAnnotation instances.
// Use IrAnnotationImpl.fromSymbolOwner instead of IrConstructorCallImpl.fromSymbolOwner.
fun codeQlAnnotationFromSymbolOwner(
    startOffset: Int, endOffset: Int, type: IrType, symbol: IrConstructorSymbol, typeArgumentsCount: Int
): IrConstructorCall =
    IrAnnotationImpl.fromSymbolOwner(startOffset, endOffset, type, symbol, typeArgumentsCount)

fun codeQlAnnotationFromSymbolOwner(type: IrType, symbol: IrConstructorSymbol): IrConstructorCall =
    IrAnnotationImpl.fromSymbolOwner(type, symbol)

