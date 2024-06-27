package com.github.codeql.utils

import com.intellij.psi.PsiElement
import org.jetbrains.kotlin.ir.IrElement
import org.jetbrains.kotlin.ir.declarations.IrFile
import org.jetbrains.kotlin.psi.KtFile

interface Psi2IrFacade {
    fun getKtFile(irFile: IrFile): KtFile?

    fun findPsiElement(irElement: IrElement, irFile: IrFile): PsiElement?
}
