package com.github.codeql

import org.jetbrains.kotlin.ir.declarations.*

class LinesOfCodeLighterAST(val logger: FileLogger, val tw: FileTrapWriter, val file: IrFile) {
    // We don't support LighterAST with old Kotlin versions
    fun linesOfCodeInFile(@Suppress("UNUSED_PARAMETER") id: Label<DbFile>): Boolean {
        return false
    }

    // We don't support LighterAST with old Kotlin versions
    fun linesOfCodeInDeclaration(
        @Suppress("UNUSED_PARAMETER") d: IrDeclaration,
        @Suppress("UNUSED_PARAMETER") id: Label<out DbSourceline>
    ): Boolean {
        return false
    }
}
