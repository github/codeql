package com.github.codeql

import org.jetbrains.kotlin.ir.declarations.*

class LinesOfCode(val logger: FileLogger, val tw: FileTrapWriter, val file: IrFile) {
    val linesOfCodePSI = LinesOfCodePSI(logger, tw, file)
    val linesOfCodeLighterAST = LinesOfCodeLighterAST(logger, tw, file)

    fun linesOfCodeInFile(id: Label<DbFile>) {
        val psiExtracted = linesOfCodePSI.linesOfCodeInFile(id)
        val lighterASTExtracted = linesOfCodeLighterAST.linesOfCodeInFile(id)
        if (psiExtracted && lighterASTExtracted) {
            logger.warnElement(
                "Both PSI and LighterAST number-of-lines-in-file information for ${file.path}.",
                file
            )
        }
    }

    fun linesOfCodeInDeclaration(d: IrDeclaration, id: Label<out DbSourceline>) {
        val psiExtracted = linesOfCodePSI.linesOfCodeInDeclaration(d, id)
        val lighterASTExtracted = linesOfCodeLighterAST.linesOfCodeInDeclaration(d, id)
        if (psiExtracted && lighterASTExtracted) {
            logger.warnElement(
                "Both PSI and LighterAST number-of-lines-in-file information for declaration.",
                d
            )
        }
    }
}
