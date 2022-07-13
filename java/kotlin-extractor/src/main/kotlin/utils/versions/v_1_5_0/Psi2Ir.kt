package com.github.codeql.utils.versions

import com.github.codeql.FileLogger
import com.intellij.psi.PsiElement
import org.jetbrains.kotlin.ir.IrElement
import org.jetbrains.kotlin.ir.declarations.IrFile
import org.jetbrains.kotlin.psi.KtFile

class Psi2Ir(private val logger: FileLogger) : Psi2IrFacade {
    override fun getKtFile(irFile: IrFile): KtFile? {
        logger.warn("Comment extraction is not supported for Kotlin < 1.5.20")
        return null
    }

    override fun findPsiElement(irElement: IrElement, irFile: IrFile): PsiElement? {
        logger.error("Attempted comment extraction for Kotlin < 1.5.20")
        return null
    }
}
