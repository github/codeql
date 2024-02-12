package com.github.codeql.comments

import com.github.codeql.*
import com.github.codeql.utils.isLocalFunction
import org.jetbrains.kotlin.ir.IrElement
import org.jetbrains.kotlin.ir.declarations.*
import org.jetbrains.kotlin.ir.expressions.IrBody
import org.jetbrains.kotlin.ir.expressions.IrExpression
import org.jetbrains.kotlin.ir.util.parentClassOrNull

open class CommentExtractor(
    protected val fileExtractor: KotlinFileExtractor,
    protected val file: IrFile,
    protected val fileLabel: Label<out DbFile>
) {
    protected val tw = fileExtractor.tw
    protected val logger = fileExtractor.logger

    protected fun getLabel(element: IrElement): Label<out DbTop>? {
        if (element == file) return fileLabel

        if (element is IrValueParameter && element.index == -1) {
            // Don't attribute comments to the implicit `this` parameter of a function.
            return null
        }

        val label: String
        val existingLabel =
            if (element is IrVariable) {
                // local variables are not named globally, so we need to get them from the variable
                // label cache
                label = "variable ${element.name.asString()}"
                tw.getExistingVariableLabelFor(element)
            } else if (element is IrFunction && element.isLocalFunction()) {
                // local functions are not named globally, so we need to get them from the local
                // function label cache
                label = "local function ${element.name.asString()}"
                fileExtractor.getExistingLocallyVisibleFunctionLabel(element)
            } else {
                label = getLabelForNamedElement(element) ?: return null
                tw.getExistingLabelFor<DbTop>(label)
            }
        if (existingLabel == null) {
            // Sometimes we don't extract elements.
            // The actual extractor logic is a bit more nuanced than
            // just "isFake", but just checking isFake is good enough
            // to not bother with a warning.
            if (element !is IrDeclarationWithVisibility || !fileExtractor.isFake(element)) {
                logger.warn("Couldn't get existing label for $label")
            }
            return null
        }
        return existingLabel
    }

    private fun getLabelForNamedElement(element: IrElement): String? {
        when (element) {
            is IrClass -> return fileExtractor.getClassLabel(element, listOf()).classLabel
            is IrTypeParameter -> return fileExtractor.getTypeParameterLabel(element)
            is IrFunction -> {
                return if (element.isLocalFunction()) {
                    null
                } else {
                    fileExtractor.getFunctionLabel(element, null)
                }
            }
            is IrValueParameter -> return fileExtractor.getValueParameterLabel(element, null)
            is IrProperty -> return fileExtractor.getPropertyLabel(element)
            is IrField -> return fileExtractor.getFieldLabel(element)
            is IrEnumEntry -> return fileExtractor.getEnumEntryLabel(element)
            is IrTypeAlias -> return fileExtractor.getTypeAliasLabel(element)
            is IrAnonymousInitializer -> {
                val parentClass = element.parentClassOrNull
                if (parentClass == null) {
                    logger.warnElement("Parent of anonymous initializer is not a class", element)
                    return null
                }
                // Assign the comment to the class. The content of the `init` blocks might be
                // extracted in multiple constructors.
                return getLabelForNamedElement(parentClass)
            }

            // Fresh entities, not named elements:
            is IrBody -> return null
            is IrExpression -> return null

            // todo add others:
            else -> {
                logger.warnElement(
                    "Unhandled element type found during comment extraction: ${element::class}",
                    element
                )
                return null
            }
        }
    }
}
