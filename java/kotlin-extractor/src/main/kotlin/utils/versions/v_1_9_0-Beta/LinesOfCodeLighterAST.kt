package com.github.codeql

import com.github.codeql.utils.versions.*
import com.intellij.lang.LighterASTNode
import com.intellij.util.diff.FlyweightCapableTreeStructure
import org.jetbrains.kotlin.KtSourceElement
import org.jetbrains.kotlin.fir.backend.FirMetadataSource
import org.jetbrains.kotlin.ir.IrElement
import org.jetbrains.kotlin.ir.declarations.*
import org.jetbrains.kotlin.lexer.KtTokens
import org.jetbrains.kotlin.util.getChildren

class LinesOfCodeLighterAST(val logger: FileLogger, val tw: FileTrapWriter, val file: IrFile) {
    val fileEntry = file.fileEntry

    fun linesOfCodeInFile(id: Label<DbFile>): Boolean {
        val sourceElement =
            (file.metadata as? FirMetadataSource.File)?.firFile?.source
        if (sourceElement == null) {
            return false
        }
        linesOfCodeInLighterAST(id, file, sourceElement)
        // Even if linesOfCodeInLighterAST didn't manage to extract any
        // information, if we got as far as calling it then we have
        // LighterAST info for the file
        return true
    }

    fun linesOfCodeInDeclaration(d: IrDeclaration, id: Label<out DbSourceline>): Boolean {
        val metadata = (d as? IrMetadataSourceOwner)?.metadata
        val sourceElement = (metadata as? FirMetadataSource)?.fir?.source
        if (sourceElement == null) {
            return false
        }
        linesOfCodeInLighterAST(id, d, sourceElement)
        // Even if linesOfCodeInLighterAST didn't manage to extract any
        // information, if we got as far as calling it then we have
        // LighterAST info for the declaration
        return true
    }

    private fun linesOfCodeInLighterAST(
        id: Label<out DbSourceline>,
        e: IrElement,
        s: KtSourceElement
    ) {
        val rootStartOffset = s.startOffset
        val rootEndOffset = s.endOffset
        if (rootStartOffset < 0 || rootEndOffset < 0) {
            // This is synthetic, or has an invalid location
            tw.writeNumlines(id, 0, 0, 0)
            return
        }
        val rootFirstLine = fileEntry.getLineNumber(rootStartOffset)
        val rootLastLine = fileEntry.getLineNumber(rootEndOffset)
        if (rootLastLine < rootFirstLine) {
            logger.errorElement("Source element ends before it starts", e)
            tw.writeNumlines(id, 0, 0, 0)
            return
        }

        val numLines = 1 + rootLastLine - rootFirstLine
        val lineContents = Array(numLines) { LineContent() }

        val treeStructure = s.treeStructure

        processSubtree(
            e,
            treeStructure,
            rootFirstLine,
            rootLastLine,
            lineContents,
            s.lighterASTNode
        )

        val code = lineContents.count { it.containsCode }
        val comment = lineContents.count { it.containsComment }
        tw.writeNumlines(id, numLines, code, comment)
    }

    private fun processSubtree(
        e: IrElement,
        treeStructure: FlyweightCapableTreeStructure<LighterASTNode>,
        rootFirstLine: Int,
        rootLastLine: Int,
        lineContents: Array<LineContent>,
        node: LighterASTNode
    ) {
        if (KtTokens.WHITESPACES.contains(node.tokenType)) {
            return
        }

        val isComment = KtTokens.COMMENTS.contains(node.tokenType)
        val children = node.getChildren(treeStructure)

        // Leaf nodes are assumed to be tokens, and
        // therefore we count any lines that they are on.
        // For comments, we actually need to look at the
        // outermost node, as the leaves of KDocs don't
        // necessarily cover all lines.
        if (isComment || children.isEmpty()) {
            val startOffset = node.getStartOffset()
            val endOffset = node.getEndOffset()
            if (startOffset < 0 || endOffset < 0) {
                logger.errorElement("LighterAST node has negative offset", e)
                return
            }
            if (startOffset > endOffset) {
                logger.errorElement("LighterAST node has negative size", e)
                return
            }
            // This may not be possible with LighterAST, but:
            // We might get e.g. an import list for a file
            // with no imports, which claims to have start
            // and end offsets of 0. Anything of 0 width
            // we therefore just skip.
            if (startOffset == endOffset) {
                return
            }
            val firstLine = fileEntry.getLineNumber(startOffset)
            val lastLine = fileEntry.getLineNumber(endOffset)
            if (firstLine < rootFirstLine) {
                logger.errorElement("LighterAST element starts before root", e)
                return
            } else if (lastLine > rootLastLine) {
                logger.errorElement("LighterAST element ends after root", e)
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
        } else {
            for (child in children) {
                processSubtree(e, treeStructure, rootFirstLine, rootLastLine, lineContents, child)
            }
        }
    }

    private class LineContent {
        var containsComment = false
        var containsCode = false
    }
}
