package com.github.codeql.utils

import org.jetbrains.kotlin.ir.declarations.IrClass
import org.jetbrains.kotlin.ir.declarations.IrDeclaration
import org.jetbrains.kotlin.ir.declarations.IrDeclarationOrigin
import org.jetbrains.kotlin.ir.declarations.IrExternalPackageFragment
import org.jetbrains.kotlin.ir.util.isFileClass

fun isExternalDeclaration(d: IrDeclaration): Boolean {
    /*
    With Kotlin 1 we get things like (from .dump()):
        PROPERTY IR_EXTERNAL_JAVA_DECLARATION_STUB name:MIN_VALUE visibility:public modality:FINAL [const,val]
          FIELD IR_EXTERNAL_JAVA_DECLARATION_STUB name:MIN_VALUE type:kotlin.Int visibility:public [final,static]
            EXPRESSION_BODY
              CONST Int type=kotlin.Int value=-2147483648
    */
    if (
        d.origin == IrDeclarationOrigin.IR_EXTERNAL_DECLARATION_STUB ||
            d.origin == IrDeclarationOrigin.IR_EXTERNAL_JAVA_DECLARATION_STUB ||
            d.origin.toString() == "FUNCTION_INTERFACE_CLASS"
    ) { // Treat kotlin.coroutines.* like ordinary library classes
        return true
    }
    /*
    With Kotlin 2, the property itself is not marked as an external stub, but it parent is:
        CLASS IR_EXTERNAL_DECLARATION_STUB OBJECT name:Companion modality:OPEN visibility:public [companion] superTypes:[]
          PROPERTY name:MIN_VALUE visibility:public modality:FINAL [const,val]
            FIELD PROPERTY_BACKING_FIELD name:MIN_VALUE type:kotlin.Int visibility:public [final]
              EXPRESSION_BODY
                CONST Int type=kotlin.Int value=-2147483648
    */
    val p = d.parent
    if (p is IrExternalPackageFragment) {
        // This is an external declaration in a (multi)file class
        return true
    }
    if (p is IrDeclaration) {
        return isExternalDeclaration(p)
    }
    return false
}

/** Returns true if `d` is not itself a class, but is a member of an external file class. */
fun isExternalFileClassMember(d: IrDeclaration): Boolean {
    if (d is IrClass) {
        return false
    }
    val p = d.parent
    when (p) {
        is IrClass -> return p.isFileClass
        is IrExternalPackageFragment ->
            // This is an external declaration in a (multi)file class
            return true
    }
    return false
}
