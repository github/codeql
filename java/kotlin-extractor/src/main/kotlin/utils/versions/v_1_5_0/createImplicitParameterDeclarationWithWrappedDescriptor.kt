package com.github.codeql.utils.versions

import org.jetbrains.kotlin.backend.common.ir.createImplicitParameterDeclarationWithWrappedDescriptor
import org.jetbrains.kotlin.ir.declarations.IrClass

fun IrClass.createImplicitParameterDeclarationWithWrappedDescriptor() =
    this.createImplicitParameterDeclarationWithWrappedDescriptor()
