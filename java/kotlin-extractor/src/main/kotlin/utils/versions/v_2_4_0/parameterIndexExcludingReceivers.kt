package com.github.codeql.utils.versions

import org.jetbrains.kotlin.ir.declarations.IrFunction
import org.jetbrains.kotlin.ir.declarations.IrParameterKind
import org.jetbrains.kotlin.ir.declarations.IrValueParameter

fun parameterIndexExcludingReceivers(vp: IrValueParameter): Int {
    val offset =
        (vp.parent as? IrFunction)?.let { f ->
            f.parameters.count { it.kind == IrParameterKind.DispatchReceiver || it.kind == IrParameterKind.ExtensionReceiver || it.kind == IrParameterKind.Context }
        } ?: 0
    return vp.indexInParameters - offset
}
