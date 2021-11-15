package com.github.codeql.utils

import com.github.codeql.utils.versions.Psi2Ir
import com.intellij.psi.PsiElement
import org.jetbrains.kotlin.ir.IrElement
import org.jetbrains.kotlin.ir.declarations.IrFile
import org.jetbrains.kotlin.ir.visitors.IrElementVisitor

class IrVisitorLookup(private val psi: PsiElement, private val file: IrFile) :
    IrElementVisitor<Unit, MutableCollection<IrElement>> {
    private val location = psi.getLocation()

    override fun visitElement(element: IrElement, data: MutableCollection<IrElement>): Unit {
        val elementLocation = element.getLocation()

        if (!location.intersects(elementLocation)) {
            // No need to visit children.
            return
        }

        if (location.contains(elementLocation)) {
            val psiElement = Psi2Ir().findPsiElement(element, file)
            if (psiElement == psi) {
                // There can be multiple IrElements that match the same PSI element.
                data.add(element)
            }
        }
        element.acceptChildren(this, data)
    }
}