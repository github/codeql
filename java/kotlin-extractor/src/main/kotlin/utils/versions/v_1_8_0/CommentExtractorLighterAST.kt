package com.github.codeql.comments

import com.github.codeql.*
import org.jetbrains.kotlin.ir.declarations.*

class CommentExtractorLighterAST(
    fileExtractor: KotlinFileExtractor,
    file: IrFile,
    fileLabel: Label<out DbFile>
) : CommentExtractor(fileExtractor, file, fileLabel) {
    // We don't support LighterAST with old Kotlin versions
    fun extract(): Boolean {
        return false
    }
}
