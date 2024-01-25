package com.github.codeql.utils.versions

import org.jetbrains.kotlin.ir.declarations.IrClass
import org.jetbrains.kotlin.ir.util.createImplicitParameterDeclarationWithWrappedDescriptor

fun IrClass.createImplicitParameterDeclarationWithWrappedDescriptor() =
    this.createImplicitParameterDeclarationWithWrappedDescriptor()
