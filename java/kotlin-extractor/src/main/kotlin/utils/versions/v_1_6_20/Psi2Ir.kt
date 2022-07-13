package com.github.codeql.utils.versions

import com.github.codeql.FileLogger
import com.intellij.psi.PsiElement
import org.jetbrains.kotlin.backend.common.psi.PsiSourceManager
import org.jetbrains.kotlin.backend.jvm.ir.getKtFile
import org.jetbrains.kotlin.ir.IrElement
import org.jetbrains.kotlin.ir.declarations.IrFile
import org.jetbrains.kotlin.psi.KtFile

class Psi2Ir(private val logger: FileLogger): Psi2IrFacade {
    override fun getKtFile(irFile: IrFile): KtFile? {
        return irFile.getKtFile()
    }

    override fun findPsiElement(irElement: IrElement, irFile: IrFile): PsiElement? {
        return PsiSourceManager.findPsiElement(irElement, irFile)
    }
}
