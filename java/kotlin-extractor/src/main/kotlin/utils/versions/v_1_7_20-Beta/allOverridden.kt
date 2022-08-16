package com.github.codeql.utils.versions

import org.jetbrains.kotlin.ir.declarations.IrSimpleFunction
import org.jetbrains.kotlin.ir.util.allOverridden

fun IrSimpleFunction.allOverridden(includeSelf: Boolean = false) = this.allOverridden(includeSelf)