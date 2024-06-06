package com.github.codeql.utils.versions

import org.jetbrains.kotlin.ir.types.IrType
import org.jetbrains.kotlin.ir.types.makeNotNull
import org.jetbrains.kotlin.ir.types.makeNullable

fun IrType.codeQlWithHasQuestionMark(b: Boolean): IrType {
    if (b) {
        return this.makeNullable()
    } else {
        return this.makeNotNull()
    }
}
