package com.github.codeql.comments

import com.github.codeql.*
import com.github.codeql.utils.versions.*
import com.intellij.lang.LighterASTNode
import com.intellij.util.diff.FlyweightCapableTreeStructure
import org.jetbrains.kotlin.fir.backend.FirMetadataSource
import org.jetbrains.kotlin.ir.IrElement
import org.jetbrains.kotlin.ir.UNDEFINED_OFFSET
import org.jetbrains.kotlin.ir.declarations.*
import org.jetbrains.kotlin.ir.util.SYNTHETIC_OFFSET
import org.jetbrains.kotlin.ir.visitors.IrElementVisitorVoid
import org.jetbrains.kotlin.ir.visitors.acceptChildrenVoid
import org.jetbrains.kotlin.ir.visitors.acceptVoid
import org.jetbrains.kotlin.kdoc.lexer.KDocTokens
import org.jetbrains.kotlin.lexer.KtTokens
import org.jetbrains.kotlin.util.getChildren

// TODO: This doesn't give owners to as many comments as the PSI extractor does.
// See the library-tests/comments tests for details.

class CommentExtractorLighterAST(
    fileExtractor: KotlinFileExtractor,
    file: IrFile,
    fileLabel: Label<out DbFile>
) : CommentExtractor(fileExtractor, file, fileLabel) {
    // Returns true if it extracted the comments; false otherwise.
    fun extract(): Boolean {
        val sourceElement =
            (file.metadata as? FirMetadataSource.File)?.firFile?.source
        val treeStructure = sourceElement?.treeStructure
        if (treeStructure == null) {
            return false
        }

        val owners = findKDocOwners(file)
        extractComments(treeStructure.root, treeStructure, owners)
        return true
    }

    private fun findKDocOwners(file: IrFile): Map<Int, List<IrElement>> {
        fun LighterASTNode.isKDocComment() = this.tokenType == KDocTokens.KDOC

        val kDocOwners = mutableMapOf<Int, MutableList<IrElement>>()
        val visitor =
            object : IrElementVisitorVoid {
                override fun visitElement(element: IrElement) {
                    val metadata = (element as? IrMetadataSourceOwner)?.metadata
                    val sourceElement = (metadata as? FirMetadataSource)?.fir?.source
                    val treeStructure = sourceElement?.treeStructure

                    if (treeStructure != null) {
                        sourceElement.lighterASTNode
                            .getChildren(treeStructure)
                            .firstOrNull { it.isKDocComment() }
                            ?.let { kDoc ->
                                // LighterASTNodes are not stable, so we can't
                                // use the node itself as the key. But the
                                // startOffset should uniquely identify them
                                // anyway.
                                val startOffset = kDoc.startOffset
                                if (
                                    startOffset != UNDEFINED_OFFSET &&
                                        startOffset != SYNTHETIC_OFFSET
                                ) {
                                    kDocOwners
                                        .getOrPut(startOffset, { mutableListOf<IrElement>() })
                                        .add(element)
                                }
                            }
                    }

                    element.acceptChildrenVoid(this)
                }
            }
        file.acceptVoid(visitor)
        return kDocOwners
    }

    private fun extractComments(
        node: LighterASTNode,
        treeStructure: FlyweightCapableTreeStructure<LighterASTNode>,
        owners: Map<Int, List<IrElement>>
    ) {
        node.getChildren(treeStructure).forEach {
            if (KtTokens.COMMENTS.contains(it.tokenType)) {
                extractComment(it, owners)
            } else {
                extractComments(it, treeStructure, owners)
            }
        }
    }

    private fun extractComment(comment: LighterASTNode, owners: Map<Int, List<IrElement>>) {
        val type: CommentType =
            when (comment.tokenType) {
                KtTokens.EOL_COMMENT -> {
                    CommentType.SingleLine
                }
                KtTokens.BLOCK_COMMENT -> {
                    CommentType.Block
                }
                KtTokens.DOC_COMMENT -> {
                    CommentType.Doc
                }
                else -> {
                    logger.warn("Unhandled comment token type: ${comment.tokenType}")
                    return
                }
            }

        val commentLabel = tw.getFreshIdLabel<DbKtcomment>()
        tw.writeKtComments(commentLabel, type.value, comment.toString())
        val locId = tw.getLocation(comment.startOffset, comment.endOffset)
        tw.writeHasLocation(commentLabel, locId)

        if (comment.tokenType != KtTokens.DOC_COMMENT) {
            return
        }

        // TODO: The PSI comment extractor extracts comment.getAllSections()
        // here, so we should too

        for (owner in owners.getOrDefault(comment.startOffset, listOf())) {
            val ownerLabel = getLabel(owner)
            if (ownerLabel != null) {
                tw.writeKtCommentOwners(commentLabel, ownerLabel)
            }
        }
    }
}
