package com.github.codeql.utils.versions

import org.jetbrains.kotlin.ir.declarations.IrFunction
import org.jetbrains.kotlin.ir.declarations.IrValueParameter

fun isDispatchReceiver(p: IrValueParameter) = p.index == -1 && p != (p.parent as? IrFunction)?.extensionReceiverParameter