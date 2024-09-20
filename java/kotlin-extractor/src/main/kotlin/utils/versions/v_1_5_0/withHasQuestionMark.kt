package com.github.codeql.utils.versions

import org.jetbrains.kotlin.ir.types.IrType
import org.jetbrains.kotlin.ir.types.withHasQuestionMark

fun IrType.codeQlWithHasQuestionMark(b: Boolean): IrType {
    return this.withHasQuestionMark(b)
}
