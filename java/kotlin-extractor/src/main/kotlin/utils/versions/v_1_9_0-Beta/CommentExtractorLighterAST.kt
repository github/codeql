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

    // KDoc section structure (the default section plus `@property`, `@constructor`,
    // ... tag sections) is not represented in the FIR lighter AST: the KDOC node is
    // a leaf there. The PSI-based extractor writes these sections, so to produce the
    // same output under K2 we re-parse the KDoc text into PSI using the compiler's
    // `Project` and read its sections. Returns null if no project was captured (in
    // which case sections are omitted, matching the previous behaviour).
    private val ktPsiFactory: org.jetbrains.kotlin.psi.KtPsiFactory? by lazy {
        KDocProjectHolder.project?.let {
            org.jetbrains.kotlin.psi.KtPsiFactory(it, markGenerated = false)
        }
    }

    private fun parseKDocSections(
        commentText: String
    ): List<org.jetbrains.kotlin.kdoc.psi.impl.KDocSection>? {
        val factory = ktPsiFactory ?: return null
        return try {
            // A KDoc is only recognised as a doc comment when it precedes a
            // declaration, so we append a throwaway declaration before parsing.
            val ktFile = factory.createFile("$commentText\nval __codeql_kdoc__ = 0")
            val kdoc =
                com.intellij.psi.util.PsiTreeUtil.findChildOfType(
                    ktFile,
                    org.jetbrains.kotlin.kdoc.psi.api.KDoc::class.java
                )
            kdoc?.getAllSections()
        } catch (e: com.intellij.openapi.progress.ProcessCanceledException) {
            throw e
        } catch (e: Exception) {
            logger.warn("Couldn't parse KDoc sections: ${e}")
            null
        }
    }

    private fun findKDocOwners(file: IrFile): Map<Int, List<IrElement>> {
        fun LighterASTNode.isKDocComment() = this.tokenType == KDocTokens.KDOC

        val kDocOwners = mutableMapOf<Int, MutableList<IrElement>>()
        val visitor =
            object : IrVisitorVoid() {
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

        // Mirror the PSI extractor: write a row per KDoc section (default section
        // and each `@tag` section) with its content, name, and subject name.
        parseKDocSections(comment.toString())?.forEach { sec ->
            val commentSectionLabel = tw.getFreshIdLabel<DbKtcommentsection>()
            tw.writeKtCommentSections(commentSectionLabel, commentLabel, sec.getContent())
            val name = sec.name
            if (name != null) {
                tw.writeKtCommentSectionNames(commentSectionLabel, name)
            }
            val subjectName = sec.getSubjectName()
            if (subjectName != null) {
                tw.writeKtCommentSectionSubjectNames(commentSectionLabel, subjectName)
            }
        }

        for (owner in owners.getOrDefault(comment.startOffset, listOf())) {
            val ownerLabel = getLabel(owner)
            if (ownerLabel != null) {
                tw.writeKtCommentOwners(commentLabel, ownerLabel)
            }
        }
    }
}
