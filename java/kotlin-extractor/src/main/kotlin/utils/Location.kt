package com.github.codeql.utils

import com.intellij.psi.PsiElement
import org.jetbrains.kotlin.ir.IrElement
import org.jetbrains.kotlin.psi.psiUtil.endOffset
import org.jetbrains.kotlin.psi.psiUtil.startOffset

data class Location(val startOffset: Int, val endOffset: Int) {
    fun contains(location: Location): Boolean {
        return this.startOffset <= location.startOffset && this.endOffset >= location.endOffset
    }

    fun intersects(location: Location): Boolean {
        return this.endOffset >= location.startOffset && this.startOffset <= location.endOffset
    }
}

fun IrElement.getLocation(): Location {
    return Location(this.startOffset, this.endOffset)
}

fun PsiElement.getLocation(): Location {
    return Location(this.startOffset, this.endOffset)
}
