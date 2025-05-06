package com.github.codeql.utils.versions

import org.jetbrains.kotlin.ir.declarations.IrFunction
import org.jetbrains.kotlin.ir.declarations.IrValueParameter

fun parameterIndexExcludingReceivers(vp: IrValueParameter): Int {
    val offset =
        (vp.parent as? IrFunction)?.let {  (if (it.extensionReceiverParameter != null) 1 else 0) + (if (it.dispatchReceiverParameter != null) 1 else 0) } ?: 0
    return vp.indexInParameters - offset
}
