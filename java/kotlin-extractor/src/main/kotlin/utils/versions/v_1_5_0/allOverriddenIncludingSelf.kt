package com.github.codeql.utils.versions

import org.jetbrains.kotlin.ir.declarations.IrSimpleFunction
import org.jetbrains.kotlin.backend.common.ir.allOverridden

fun IrSimpleFunction.allOverriddenIncludingSelf() = this.allOverridden(includeSelf = true)