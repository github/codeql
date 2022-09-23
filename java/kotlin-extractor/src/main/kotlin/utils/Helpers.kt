package com.github.codeql.utils

import org.jetbrains.kotlin.descriptors.DescriptorVisibilities
import org.jetbrains.kotlin.ir.declarations.IrFunction

fun IrFunction.isLocalFunction(): Boolean {
    return this.visibility == DescriptorVisibilities.LOCAL
}