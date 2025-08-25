package com.github.codeql.utils.versions

import org.jetbrains.kotlin.ir.declarations.IrDeclarationOrigin
import org.jetbrains.kotlin.ir.declarations.IrValueParameter

fun isUnderscoreParameter(vp: IrValueParameter) =
    vp.origin == IrDeclarationOrigin.UNDERSCORE_PARAMETER
