package com.github.codeql.utils.versions

import org.jetbrains.kotlin.name.FqName
import org.jetbrains.kotlin.ir.declarations.IrDeclaration
import org.jetbrains.kotlin.ir.declarations.IrMemberWithContainerSource
import org.jetbrains.kotlin.load.kotlin.FacadeClassSource

fun getFileClassFqName(d: IrDeclaration): FqName? {
    // d is in a file class.
    // Get the name in a similar way to the compiler's ExternalPackageParentPatcherLowering
    // visitMemberAccess/generateOrGetFacadeClass.
    if (d is IrMemberWithContainerSource) {
        val containerSource = d.containerSource
        if (containerSource is FacadeClassSource) {
            val facadeClassName = containerSource.facadeClassName
            if (facadeClassName != null) {
                // TODO: This is really a multifile-class rather than a file-class,
                // but for now we treat them the same.
                return facadeClassName.fqNameForTopLevelClassMaybeWithDollars
            } else {
                return containerSource.className.fqNameForTopLevelClassMaybeWithDollars
            }
        } else {
            return null
        }
    } else {
        return null
    }
}
