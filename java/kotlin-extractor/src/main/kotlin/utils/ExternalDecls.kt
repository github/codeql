package com.github.codeql.utils

import org.jetbrains.kotlin.ir.declarations.IrClass
import org.jetbrains.kotlin.ir.declarations.IrDeclaration
import org.jetbrains.kotlin.ir.declarations.IrDeclarationOrigin
import org.jetbrains.kotlin.ir.util.isFileClass
import org.jetbrains.kotlin.ir.util.parentClassOrNull

fun isExternalDeclaration(d: IrDeclaration): Boolean {
    return d.origin == IrDeclarationOrigin.IR_EXTERNAL_DECLARATION_STUB ||
           d.origin == IrDeclarationOrigin.IR_EXTERNAL_JAVA_DECLARATION_STUB ||
           d.origin.toString() == "FUNCTION_INTERFACE_CLASS" // Treat kotlin.coroutines.* like ordinary library classes
}

/**
 * Returns true if `d` is not itself a class, but is a member of an external file class.
 */
fun isExternalFileClassMember(d: IrDeclaration) = d !is IrClass && (d.parentClassOrNull?.let { it.isFileClass } ?: false)

