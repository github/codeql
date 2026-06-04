package com.github.codeql.utils.versions

import org.jetbrains.kotlin.ir.declarations.IrFunction
import org.jetbrains.kotlin.ir.declarations.IrValueParameter
import org.jetbrains.kotlin.ir.expressions.IrConstructorCall
import org.jetbrains.kotlin.ir.expressions.IrExpression
import org.jetbrains.kotlin.ir.expressions.IrMemberAccessExpression
import org.jetbrains.kotlin.ir.types.IrType
import org.jetbrains.kotlin.ir.types.addAnnotations

/**
 * Compatibility accessors for pre-2.4.0 API patterns.
 * In pre-2.4.0 versions, these delegate directly to the existing APIs.
 */

// IrFunction: valueParameters
val IrFunction.codeQlValueParameters: List<IrValueParameter>
    get() = valueParameters

// IrFunction: extensionReceiverParameter
val IrFunction.codeQlExtensionReceiverParameter: IrValueParameter?
    get() = extensionReceiverParameter

// IrMemberAccessExpression: valueArgumentsCount
val IrMemberAccessExpression<*>.codeQlValueArgumentsCount: Int
    get() = valueArgumentsCount

// IrMemberAccessExpression: getValueArgument
fun IrMemberAccessExpression<*>.codeQlGetValueArgument(index: Int): IrExpression? = getValueArgument(index)

// IrMemberAccessExpression: putValueArgument
fun IrMemberAccessExpression<*>.codeQlPutValueArgument(index: Int, value: IrExpression?) {
    putValueArgument(index, value)
}

// IrMemberAccessExpression: extensionReceiver
var IrMemberAccessExpression<*>.codeQlExtensionReceiver: IrExpression?
    get() = extensionReceiver
    set(value) { extensionReceiver = value }

// IrMemberAccessExpression: typeArgumentsCount
val IrMemberAccessExpression<*>.codeQlTypeArgumentsCount: Int
    get() = typeArgumentsCount

// IrMemberAccessExpression: getTypeArgument
fun IrMemberAccessExpression<*>.codeQlGetTypeArgument(index: Int): IrType? = getTypeArgument(index)

// addAnnotations compat: in pre-2.4.0, addAnnotations expects List<IrConstructorCall>
fun IrType.codeQlAddAnnotations(annotations: List<IrConstructorCall>): IrType =
    addAnnotations(annotations)

// IrMutableAnnotationContainer.annotations setter: in pre-2.4.0, annotations is var with List<IrConstructorCall>
fun codeQlSetAnnotations(container: org.jetbrains.kotlin.ir.declarations.IrMutableAnnotationContainer, annotations: List<IrConstructorCall>) {
    container.annotations = annotations
}

// IrFunction: set dispatch receiver parameter (pre-2.4.0 it's a var)
fun IrFunction.codeQlSetDispatchReceiverParameter(param: IrValueParameter?) {
    dispatchReceiverParameter = param
}
