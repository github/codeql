package com.github.codeql.utils.versions

import org.jetbrains.kotlin.backend.common.extensions.IrPluginContext

fun usesK2(pluginContext: IrPluginContext): Boolean {
    return pluginContext.languageVersionSettings.languageVersion.usesK2
}
