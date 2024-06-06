package com.github.codeql.utils.versions

import org.jetbrains.kotlin.backend.common.extensions.IrPluginContext

fun getAnnotationType(context: IrPluginContext) = context.irBuiltIns.annotationType
