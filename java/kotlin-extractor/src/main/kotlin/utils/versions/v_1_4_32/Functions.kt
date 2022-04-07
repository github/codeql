package com.github.codeql.utils.versions

import org.jetbrains.kotlin.backend.common.extensions.IrPluginContext
import org.jetbrains.kotlin.ir.declarations.IrClass

fun functionN(pluginContext: IrPluginContext): (Int) -> IrClass {
    return { i -> pluginContext.irBuiltIns.functionFactory.functionN(i) }
}
