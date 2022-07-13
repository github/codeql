package com.github.codeql.comments

import com.github.codeql.*
import com.github.codeql.utils.IrVisitorLookup
import com.github.codeql.utils.versions.Psi2Ir
import com.intellij.psi.PsiComment
import com.intellij.psi.PsiElement
import org.jetbrains.kotlin.ir.IrElement
import org.jetbrains.kotlin.ir.declarations.*
import org.jetbrains.kotlin.kdoc.psi.api.KDoc
import org.jetbrains.kotlin.lexer.KtTokens
import org.jetbrains.kotlin.psi.KtVisitor
import org.jetbrains.kotlin.psi.psiUtil.endOffset
import org.jetbrains.kotlin.psi.psiUtil.startOffset

class CommentExtractor(private val fileExtractor: KotlinFileExtractor, private val file: IrFile, private val fileLabel: Label<out DbFile>) {
    private val tw = fileExtractor.tw
    private val logger = fileExtractor.logger
    private val psi2Ir = Psi2Ir(logger)
    private val ktFile = psi2Ir.getKtFile(file)

    fun extract() {
        if (ktFile == null) {
            logger.warn("Comments are not being processed in ${file.path}.")
        } else {
            ktFile.accept(commentVisitor)
        }
    }

    private val commentVisitor =
        object : KtVisitor<Unit, Unit>() {
            override fun visitElement(element: PsiElement) {
                element.acceptChildren(this)

                // Slightly hacky, but `visitComment` doesn't seem to visit comments with `tokenType` `KtTokens.DOC_COMMENT`
                if (element is PsiComment){
                    visitCommentElement(element)
                }
            }

            private fun visitCommentElement(comment: PsiComment) {
                val type: CommentType = when (comment.tokenType) {
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
                tw.writeKtComments(commentLabel, type.value, comment.text)
                val locId = tw.getLocation(comment.startOffset, comment.endOffset)
                tw.writeHasLocation(commentLabel, locId)

                if (comment.tokenType != KtTokens.DOC_COMMENT) {
                    return
                }

                if (comment !is KDoc) {
                    logger.warn("Unexpected comment type with DocComment token type.")
                    return
                }

                for (sec in comment.getAllSections()) {
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

                // Only storing the owner of doc comments:
                val ownerPsi = getKDocOwner(comment) ?: return

                val owners = mutableListOf<IrElement>()
                file.accept(IrVisitorLookup(psi2Ir, ownerPsi, file), owners)

                for (ownerIr in owners) {
                    val ownerLabel =
                        if (ownerIr == file)
                            fileLabel
                        else {
                            if (ownerIr is IrValueParameter && ownerIr.index == -1) {
                                // Don't attribute comments to the implicit `this` parameter of a function.
                                continue
                            }
                            val label: String
                            val existingLabel = if (ownerIr is IrVariable) {
                                label = "variable ${ownerIr.name.asString()}"
                                tw.getExistingVariableLabelFor(ownerIr)
                            } else {
                                label = fileExtractor.getLabel(ownerIr) ?: continue
                                tw.getExistingLabelFor<DbTop>(label)
                            }
                            if (existingLabel == null) {
                                logger.warn("Couldn't get existing label for $label")
                                continue
                            }
                            existingLabel
                        }
                    tw.writeKtCommentOwners(commentLabel, ownerLabel)
                }
            }

            private fun getKDocOwner(comment: KDoc) : PsiElement? {
                val owner = comment.owner
                if (owner == null) {
                    logger.warn("Couldn't get owner of KDoc.")
                }
                return owner
            }
        }
}
