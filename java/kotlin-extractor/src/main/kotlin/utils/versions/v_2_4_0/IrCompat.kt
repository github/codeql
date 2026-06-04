@file:Suppress("DEPRECATION")

package com.github.codeql.utils.versions

import org.jetbrains.kotlin.ir.declarations.IrFunction
import org.jetbrains.kotlin.ir.declarations.IrValueParameter
import org.jetbrains.kotlin.ir.expressions.IrAnnotation
import org.jetbrains.kotlin.ir.expressions.IrConstructorCall
import org.jetbrains.kotlin.ir.expressions.IrExpression
import org.jetbrains.kotlin.ir.expressions.IrMemberAccessExpression
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
var IrMemberAccessExpression<*>.codeQlExtensionReceiver: IrExpression?
    get() {
        val erp = symbol.owner.let { it as? IrFunction }?.codeQlExtensionReceiverParameter ?: return null
        return arguments[erp.indexInParameters]
    }
    set(value) {
        val erp = symbol.owner.let { it as? IrFunction }?.codeQlExtensionReceiverParameter ?: return
        arguments[erp.indexInParameters] = value
    }

// IrMemberAccessExpression: typeArgumentsCount
val IrMemberAccessExpression<*>.codeQlTypeArgumentsCount: Int
    get() = typeArguments.size

// IrMemberAccessExpression: getTypeArgument
fun IrMemberAccessExpression<*>.codeQlGetTypeArgument(index: Int): IrType? = typeArguments[index]

// addAnnotations compat: in 2.4.0, addAnnotations expects List<IrAnnotation>
// IrAnnotation extends IrConstructorCall, so we cast
@Suppress("UNCHECKED_CAST")
fun IrType.codeQlAddAnnotations(annotations: List<IrConstructorCall>): IrType =
    addAnnotations(annotations as List<IrAnnotation>)

// IrMutableAnnotationContainer.annotations setter: in 2.4.0, expects List<IrAnnotation>
@Suppress("UNCHECKED_CAST")
fun codeQlSetAnnotations(container: org.jetbrains.kotlin.ir.declarations.IrMutableAnnotationContainer, annotations: List<IrConstructorCall>) {
    container.annotations = annotations as List<IrAnnotation>
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

