package com.github.codeql.comments

import com.github.codeql.*
import com.github.codeql.utils.IrVisitorLookup
import com.intellij.psi.PsiComment
import com.intellij.psi.PsiElement
import org.jetbrains.kotlin.backend.jvm.ir.getKtFile
import org.jetbrains.kotlin.ir.IrElement
import org.jetbrains.kotlin.ir.declarations.IrFile
import org.jetbrains.kotlin.ir.declarations.path
import org.jetbrains.kotlin.kdoc.psi.api.KDoc
import org.jetbrains.kotlin.lexer.KtTokens
import org.jetbrains.kotlin.psi.KtVisitor
import org.jetbrains.kotlin.psi.psiUtil.endOffset
import org.jetbrains.kotlin.psi.psiUtil.startOffset
import org.jetbrains.kotlin.utils.addToStdlib.cast

class CommentExtractor(private val logger: FileLogger, private val tw: FileTrapWriter, private val file: IrFile, private val fileExtractor: KotlinFileExtractor) {
    private val ktFile = file.getKtFile()

    init {
        if (ktFile == null) {
            logger.warn(Severity.Warn, "Comments are not being processed in ${file.path}.")
        }
    }

    fun extract() {
        ktFile?.accept(
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
                            logger.warn(Severity.Warn, "Unhandled comment token type: ${comment.tokenType}")
                            return
                        }
                    }

                    val commentLabel = tw.getFreshIdLabel<Label<*>>()
                    tw.writeTrap("// kt_comment($commentLabel,${type.value},${escapeTrapString(comment.text)})\n")
                    val locId = tw.getLocation(comment.startOffset, comment.endOffset)
                    tw.writeHasLocation(commentLabel as Label<out DbLocatable>, locId)

                    if (comment.tokenType == KtTokens.DOC_COMMENT) {
                        val kdoc = comment.cast<KDoc>()
                        for (sec in kdoc.getAllSections()) {
                            val commentSectionLabel = tw.getFreshIdLabel<Label<*>>()
                            tw.writeTrap("// kt_comment_section($commentSectionLabel,$commentLabel,${escapeTrapString(sec.getContent())})\n")
                            if (sec.name != null) {
                                tw.writeTrap("// kt_comment_section_name($commentSectionLabel,${sec.name}})\n")
                            }
                            if (sec.getSubjectName() != null) {
                                tw.writeTrap("// kt_comment_section_subject_name($commentSectionLabel,${sec.getSubjectName()}})\n")
                            }
                        }
                    }

                    val owner = getCommentOwner(comment)
                    val elements = mutableListOf<IrElement>()
                    file.accept(IrVisitorLookup(owner, file), elements)

                    for (owner in elements) {
                        val label = fileExtractor.getLabel(owner)
                        if (label == null) {
                            logger.warn(Severity.Warn, "Couldn't get label for element: $owner")
                            continue
                        }
                        if (label == "*") {
                            logger.info("Skipping fresh entity label for element: $owner")
                            continue
                        }
                        val existingLabel = tw.getExistingLabelFor<Label<*>>(label)
                        if (existingLabel == null) {
                            logger.warn(Severity.Warn, "Couldn't get existing label for $label")
                            continue
                        }

                        tw.writeTrap("// kt_comment_owner($commentLabel,$existingLabel)\n")
                    }
                }

                private fun getCommentOwner(comment: PsiComment) : PsiElement {
                    if (comment.tokenType == KtTokens.DOC_COMMENT) {
                        if (comment is KDoc) {
                            if (comment.owner == null) {
                                logger.warn(Severity.Warn, "Couldn't get owner of KDoc, using parent instead")
                                return comment.parent
                            } else {
                                return comment.owner!!
                            }
                        } else {
                            logger.warn(Severity.Warn, "Unexpected comment type with DocComment token type")
                            return comment.parent
                        }
                    } else {
                        return comment.parent
                    }
                }
            })
    }
}

