package com.github.codeql.utils.versions

import org.jetbrains.kotlin.backend.common.ir.allOverridden
import org.jetbrains.kotlin.ir.declarations.IrSimpleFunction

fun IrSimpleFunction.allOverriddenIncludingSelf() = this.allOverridden(includeSelf = true)
