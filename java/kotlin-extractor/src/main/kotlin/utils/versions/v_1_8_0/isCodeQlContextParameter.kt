package com.github.codeql.utils.versions

import org.jetbrains.kotlin.ir.declarations.IrValueParameter

fun IrValueParameter.isCodeQlContextParameter() = false
