package com.github.codeql.utils.versions

import org.jetbrains.kotlin.backend.common.extensions.IrPluginContext

fun usesK2(@Suppress("UNUSED_PARAMETER") pluginContext: IrPluginContext): Boolean {
    return false
}
