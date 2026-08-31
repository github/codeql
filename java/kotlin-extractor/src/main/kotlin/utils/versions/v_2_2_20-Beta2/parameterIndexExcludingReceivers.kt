package com.github.codeql.utils.versions

import org.jetbrains.kotlin.ir.declarations.IrFunction
import org.jetbrains.kotlin.ir.declarations.IrParameterKind
import org.jetbrains.kotlin.ir.declarations.IrValueParameter

fun parameterIndexExcludingReceivers(vp: IrValueParameter): Int {
    if (
        vp.kind == IrParameterKind.DispatchReceiver ||
            vp.kind == IrParameterKind.ExtensionReceiver
    ) {
        return -1
    }
    return (vp.parent as? IrFunction)
        ?.parameters
        ?.take(vp.indexInParameters)
        ?.count { it.kind == IrParameterKind.Context || it.kind == IrParameterKind.Regular }
        ?: vp.indexInParameters
}
