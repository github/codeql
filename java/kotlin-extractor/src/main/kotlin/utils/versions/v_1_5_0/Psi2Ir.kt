package com.github.codeql.utils.versions

import com.github.codeql.FileLogger
import com.intellij.psi.PsiElement
import org.jetbrains.kotlin.ir.IrElement
import org.jetbrains.kotlin.ir.declarations.IrFile
import org.jetbrains.kotlin.psi.KtFile
import org.jetbrains.kotlin.psi2ir.PsiSourceManager

class Psi2Ir(private val logger: FileLogger) : Psi2IrFacade {
    companion object {
        val psiManager = PsiSourceManager()
    }

    override fun getKtFile(irFile: IrFile): KtFile? {
        return psiManager.getKtFile(irFile)
    }

    override fun findPsiElement(irElement: IrElement, irFile: IrFile): PsiElement? {
        return psiManager.findPsiElement(irElement, irFile)
    }
}
