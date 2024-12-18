package com.github.codeql.utils

import com.intellij.psi.PsiElement
import org.jetbrains.kotlin.ir.IrElement
import org.jetbrains.kotlin.ir.declarations.IrDeclaration
import org.jetbrains.kotlin.ir.declarations.IrFile
import org.jetbrains.kotlin.ir.util.isFakeOverride
import org.jetbrains.kotlin.ir.visitors.IrElementVisitor

class IrVisitorLookup(
    private val psi2Ir: Psi2IrFacade,
    private val psi: PsiElement,
    private val file: IrFile
) : IrElementVisitor<Unit, MutableCollection<IrElement>> {
    private val location = psi.getLocation()

    override fun visitElement(element: IrElement, data: MutableCollection<IrElement>): Unit {
        val elementLocation = element.getLocation()

        if (!location.intersects(elementLocation)) {
            // No need to visit children.
            return
        }

        if (element is IrDeclaration && element.isFakeOverride) {
            // These aren't extracted, so we don't expect anything to exist
            // to which we could ascribe a comment.
            return
        }

        if (location.contains(elementLocation)) {
            val psiElement = psi2Ir.findPsiElement(element, file)
            if (psiElement == psi) {
                // There can be multiple IrElements that match the same PSI element.
                data.add(element)
            }
        }
        element.acceptChildren(this, data)
    }
}
