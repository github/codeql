package com.github.codeql.utils.versions

import org.jetbrains.kotlin.backend.common.ir.copyTo
import org.jetbrains.kotlin.ir.declarations.IrFunction
import org.jetbrains.kotlin.ir.declarations.IrValueParameter

fun copyParameterToFunction(p: IrValueParameter, f: IrFunction) = p.copyTo(f)
