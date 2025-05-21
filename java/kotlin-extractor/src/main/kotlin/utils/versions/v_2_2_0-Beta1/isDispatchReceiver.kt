package com.github.codeql.utils.versions

import org.jetbrains.kotlin.ir.declarations.IrValueParameter
import org.jetbrains.kotlin.ir.declarations.IrParameterKind

fun isDispatchReceiver(p: IrValueParameter) = p.kind == IrParameterKind.DispatchReceiver