package com.github.codeql.utils.versions

import org.jetbrains.kotlin.ir.declarations.IrValueParameter

fun parameterIndexExcludingReceivers(vp: IrValueParameter) = vp.index
