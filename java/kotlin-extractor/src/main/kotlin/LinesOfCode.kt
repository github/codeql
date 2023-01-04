package com.github.codeql

import com.github.codeql.utils.versions.getPsi2Ir
import com.intellij.psi.PsiComment
import com.intellij.psi.PsiElement
import com.intellij.psi.PsiWhiteSpace
import org.jetbrains.kotlin.config.KotlinCompilerVersion
import org.jetbrains.kotlin.ir.IrElement
import org.jetbrains.kotlin.ir.declarations.*
import org.jetbrains.kotlin.kdoc.psi.api.KDocElement
import org.jetbrains.kotlin.psi.KtCodeFragment
import org.jetbrains.kotlin.psi.KtVisitor

class LinesOfCode(
    val logger: FileLogger,
    val tw: FileTrapWriter,
    val file: IrFile
) {
    val psi2Ir = getPsi2Ir().also {
        if (it == null) {
            logger.warn("Lines of code will not be populated as Kotlin version is too old (${KotlinCompilerVersion.getVersion()})")
        }
    }

    fun linesOfCodeInFile(id: Label<DbFile>) {
        if (psi2Ir == null) {
            return
        }
        val ktFile = psi2Ir.getKtFile(file)
        if (ktFile == null) {
            return
        }
        linesOfCodeInPsi(id, ktFile, file)
    }

    fun linesOfCodeInDeclaration(d: IrDeclaration, id: Label<out DbSourceline>) {
        if (psi2Ir == null) {
            return
        }
        val p = psi2Ir.findPsiElement(d, file)
        if (p == null) {
            return
        }
        linesOfCodeInPsi(id, p, d)
    }

    private fun linesOfCodeInPsi(id: Label<out DbSourceline>, root: PsiElement, e: IrElement) {
        val document = root.getContainingFile().getViewProvider().getDocument()
        if (document == null) {
            logger.errorElement("Cannot find document for PSI", e)
            tw.writeNumlines(id, 0, 0, 0)
            return
        }

        val rootRange = root.getTextRange()
        val rootFirstLine = document.getLineNumber(rootRange.getStartOffset())
        val rootLastLine = document.getLineNumber(rootRange.getEndOffset())
        if (rootLastLine < rootFirstLine) {
            logger.errorElement("PSI ends before it starts", e)
            tw.writeNumlines(id, 0, 0, 0)
            return
        }
        val numLines = 1 + rootLastLine - rootFirstLine
        val lineContents = Array(numLines) { LineContent() }

        val visitor =
            object : KtVisitor<Unit, Unit>() {
                override fun visitElement(element: PsiElement) {
                    val isComment = element is PsiComment
                    // Comments may include nodes that aren't PsiComments,
                    // so we don't want to visit them or we'll think they
                    // are code.
                    if (!isComment) {
                        element.acceptChildren(this)
                    }

                    if (element is PsiWhiteSpace) {
                        return
                    }
                    // Leaf nodes are assumed to be tokens, and
                    // therefore we count any lines that they are on.
                    // For comments, we actually need to look at the
                    // outermost node, as the leaves of KDocs don't
                    // necessarily cover all lines.
                    if (isComment || element.getChildren().size == 0) {
                        val range = element.getTextRange()
                        val startOffset = range.getStartOffset()
                        val endOffset = range.getEndOffset()
                        // The PSI doesn't seem to have anything like
                        // the IR's UNDEFINED_OFFSET and SYNTHETIC_OFFSET,
                        // but < 0 still seem to represent bad/unknown
                        // locations.
                        if (startOffset < 0 || endOffset < 0) {
                            logger.errorElement("PSI has negative offset", e)
                            return
                        }
                        if (startOffset > endOffset) {
                            return
                        }
                        // We might get e.g. an import list for a file
                        // with no imports, which claims to have start
                        // and end offsets of 0. Anything of 0 width
                        // we therefore just skip.
                        if (startOffset == endOffset) {
                            return
                        }
                        val firstLine = document.getLineNumber(startOffset)
                        val lastLine = document.getLineNumber(endOffset)
                        if (firstLine < rootFirstLine) {
                            logger.errorElement("PSI element starts before root", e)
                            return
                        } else if (lastLine > rootLastLine) {
                            logger.errorElement("PSI element ends after root", e)
                            return
                        }
                        for (line in firstLine..lastLine) {
                            val lineContent = lineContents[line - rootFirstLine]
                            if (isComment) {
                                lineContent.containsComment = true
                            } else {
                                lineContent.containsCode = true
                            }
                        }
                    }
                }
            }
        root.accept(visitor)
        val total = lineContents.size
        val code = lineContents.count { it.containsCode }
        val comment = lineContents.count { it.containsComment }
        tw.writeNumlines(id, total, code, comment)
    }

    private class LineContent {
        var containsComment = false
        var containsCode = false
    }
}
