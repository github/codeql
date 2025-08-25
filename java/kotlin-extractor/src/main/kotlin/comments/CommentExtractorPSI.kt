package com.github.codeql.comments

import com.github.codeql.*
import com.github.codeql.utils.IrVisitorLookup
import com.github.codeql.utils.Psi2IrFacade
import com.github.codeql.utils.versions.getPsi2Ir
import com.intellij.psi.PsiComment
import com.intellij.psi.PsiElement
import org.jetbrains.kotlin.config.KotlinCompilerVersion
import org.jetbrains.kotlin.ir.IrElement
import org.jetbrains.kotlin.ir.declarations.*
import org.jetbrains.kotlin.kdoc.psi.api.KDoc
import org.jetbrains.kotlin.lexer.KtTokens
import org.jetbrains.kotlin.psi.KtVisitor
import org.jetbrains.kotlin.psi.psiUtil.endOffset
import org.jetbrains.kotlin.psi.psiUtil.startOffset

class CommentExtractorPSI(
    fileExtractor: KotlinFileExtractor,
    file: IrFile,
    fileLabel: Label<out DbFile>
) : CommentExtractor(fileExtractor, file, fileLabel) {
    // Returns true if it extracted the comments; false otherwise.
    fun extract(): Boolean {
        val psi2Ir = getPsi2Ir()
        if (psi2Ir == null) {
            logger.warn(
                "Comments will not be extracted as Kotlin version is too old (${KotlinCompilerVersion.getVersion()})"
            )
            return false
        }
        val ktFile = psi2Ir.getKtFile(file)
        if (ktFile == null) {
            return false
        }
        val commentVisitor = mkCommentVisitor(psi2Ir)
        ktFile.accept(commentVisitor)
        return true
    }

    private fun mkCommentVisitor(psi2Ir: Psi2IrFacade): KtVisitor<Unit, Unit> =
        object : KtVisitor<Unit, Unit>() {
            override fun visitElement(element: PsiElement) {
                element.acceptChildren(this)

                // Slightly hacky, but `visitComment` doesn't seem to visit comments with
                // `tokenType` `KtTokens.DOC_COMMENT`
                if (element is PsiComment) {
                    visitCommentElement(element)
                }
            }

            private fun visitCommentElement(comment: PsiComment) {
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
                    val ownerLabel = getLabel(ownerIr)
                    if (ownerLabel != null) {
                        tw.writeKtCommentOwners(commentLabel, ownerLabel)
                    }
                }
            }

            private fun getKDocOwner(comment: KDoc): PsiElement? {
                val owner = comment.owner
                if (owner == null) {
                    logger.warn(
                        "Couldn't get owner of KDoc. The comment is extracted without an owner."
                    )
                }
                return owner
            }
        }
}
