package com.github.codeql.comments

import com.github.codeql.FileLogger
import com.github.codeql.Logger
import com.github.codeql.Severity
import com.github.codeql.TrapWriter
import com.intellij.psi.PsiComment
import com.intellij.psi.PsiElement
import org.jetbrains.kotlin.backend.common.psi.PsiSourceManager
import org.jetbrains.kotlin.backend.jvm.ir.getKtFile
import org.jetbrains.kotlin.ir.IrElement
import org.jetbrains.kotlin.ir.declarations.IrFile
import org.jetbrains.kotlin.ir.declarations.path
import org.jetbrains.kotlin.ir.util.dump
import org.jetbrains.kotlin.kdoc.psi.api.KDoc
import org.jetbrains.kotlin.lexer.KtTokens
import org.jetbrains.kotlin.psi.KtDeclaration
import org.jetbrains.kotlin.psi.KtVisitor
import org.jetbrains.kotlin.psi.findDocComment.findDocComment
import org.jetbrains.kotlin.psi.psiUtil.endOffset
import org.jetbrains.kotlin.psi.psiUtil.startOffset
import org.jetbrains.kotlin.utils.addToStdlib.cast

class CommentExtractor(private val logger: FileLogger, private val tw: TrapWriter, private val file: IrFile) {
    private val ktFile = file.getKtFile()

    private val comments = mutableListOf<Comment>()
    private val elements = mutableListOf<IrElement>()

    init {
        if (ktFile == null) {
            logger.warn(Severity.Warn, "Comments are not being processed in ${file.path}.")
        }
    }

    fun addPossibleCommentOwner(elem: IrElement) {
        if (ktFile == null) {
            return
        }

        if (elem.startOffset == -1 || elem.endOffset == -1) {
            logger.info("Skipping element with negative offsets: ${elem.dump()}")
            return
        }


        val psiElement = PsiSourceManager.findPsiElement(elem, file)
        if (psiElement != null) {
            println("PSI: $psiElement for ${elem.dump()}")
            if (psiElement is KtDeclaration) {
                val docComment = findDocComment(psiElement)
                if (docComment != null) {
                    println("doc comment: ${docComment.text}")
                }
            }
        }

        elements.add(elem)
    }

    /**
     * Match comments to program elements.
     */
    fun bindCommentsToElement() {
        if (comments.isEmpty()) {
            return
        }

        comments.sortBy { it.startOffset }
        elements.sortBy { it.startOffset }

        var commentIndex: Int = 0
        var elementIndex: Int = 0
        val elementStack: ElementStack = ElementStack()

        while (elementIndex < elements.size) {
            val nextElement = elements[elementIndex]
            val commentsForElement = mutableListOf<Comment>()
            while (commentIndex < comments.size &&
                    comments[commentIndex].endOffset < nextElement.startOffset) {

                commentsForElement.add(comments[commentIndex])
                commentIndex++
            }

            bindCommentsToElements(commentsForElement, elementStack, nextElement)

            elementStack.push(nextElement)

            elementIndex++
        }

        // Comments after last element
        val commentsForElement = mutableListOf<Comment>()
        while (commentIndex < comments.size) {

            commentsForElement.add(comments[commentIndex])
            commentIndex++
        }

        bindCommentsToElements(commentsForElement, elementStack, null)
    }

    /**
     * Bind selected comments to elements. Elements are selected from the element stack or from the next element.
     */
    private fun bindCommentsToElements(
        commentsForElement: Collection<Comment>,
        elementStack: ElementStack,
        nextElement: IrElement?
    ) {
        if (commentsForElement.any()) {
            for (comment in commentsForElement) {
                println("Comment: $comment")
                val parent = elementStack.findParent(comment.getLocation())
                println("parent: ${parent?.dump()}")
                val before = elementStack.findBefore(comment.getLocation())
                println("before: ${before?.dump()}")
                val after = elementStack.findAfter(comment.getLocation(), nextElement)
                println("after: ${after?.dump()}")
                // todo: best match
            }
        }

        // todo write matches to DB: tw.writeHasJavadoc()
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
                    // val loc = tw.getLocation(comment.startOffset, comment.endOffset)
                    // val id: Label<DbJavadoc> = tw.getLabelFor(";comment")
                    // tw.writeJavadoc(id)

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

                    if (comment.tokenType == KtTokens.DOC_COMMENT)
                    {
                        val kdoc = comment.cast<KDoc>()
                        for (sec in kdoc.getAllSections())
                            println("section content: ${sec.getContent()}")

                    }

                    comments.add(Comment(comment.text, comment.startOffset, comment.endOffset, type))
                    // todo:
                    // - store each comment in the DB
                    // - do further processing on Doc comments (extract @tag text, @tag name text, @tag[name] text)
                }
            })
    }
}