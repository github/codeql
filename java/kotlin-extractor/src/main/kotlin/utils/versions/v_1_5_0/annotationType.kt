package com.github.codeql.utils.versions

import org.jetbrains.kotlin.backend.common.extensions.IrPluginContext
import org.jetbrains.kotlin.ir.ObsoleteDescriptorBasedAPI

@OptIn(ObsoleteDescriptorBasedAPI::class)
fun getAnnotationType(context: IrPluginContext) =
    context.typeTranslator.translateType(context.builtIns.annotationType)
