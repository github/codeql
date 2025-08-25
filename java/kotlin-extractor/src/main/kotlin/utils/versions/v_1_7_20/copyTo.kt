package com.github.codeql.utils.versions

import org.jetbrains.kotlin.ir.declarations.IrFunction
import org.jetbrains.kotlin.ir.declarations.IrValueParameter
import org.jetbrains.kotlin.ir.util.copyTo

fun copyParameterToFunction(p: IrValueParameter, f: IrFunction) = p.copyTo(f)
