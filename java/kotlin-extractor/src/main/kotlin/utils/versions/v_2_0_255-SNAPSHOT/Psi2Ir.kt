package com.github.codeql.utils.versions

import com.github.codeql.utils.Psi2IrFacade
import com.intellij.psi.PsiElement
import org.jetbrains.kotlin.ir.PsiSourceManager
import org.jetbrains.kotlin.backend.jvm.ir.getKtFile
import org.jetbrains.kotlin.ir.IrElement
import org.jetbrains.kotlin.ir.declarations.IrFile
import org.jetbrains.kotlin.psi.KtFile

fun getPsi2Ir(): Psi2IrFacade? = Psi2Ir()

private class Psi2Ir() : Psi2IrFacade {
    override fun getKtFile(irFile: IrFile): KtFile? {
        return irFile.getKtFile()
    }

    override fun findPsiElement(irElement: IrElement, irFile: IrFile): PsiElement? {
        return PsiSourceManager.findPsiElement(irElement, irFile)
    }
}
