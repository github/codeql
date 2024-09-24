package com.github.codeql.entities

import com.github.codeql.DbFile
import org.jetbrains.kotlin.analysis.api.KaSession
import org.jetbrains.kotlin.analysis.api.symbols.KaFileSymbol
import org.jetbrains.kotlin.analysis.api.symbols.psi
import org.jetbrains.kotlin.psi.KtFile

context(KaSession)
class File private constructor(symbol: KaFileSymbol, context: Context) : Entity<KaFileSymbol, DbFile>(symbol, context) {

    override fun extract() {
        println("file: " + symbol.psi<KtFile>().name)
        val declarations = symbol.fileScope.declarations.map { getEntity(context, it) }.toList()
    }

    override val key: String
        get() = "${symbol.psi<KtFile>().virtualFilePath};sourcefile"


    companion object {
        context(KaSession)
        fun create(context: Context, symbol: KaFileSymbol) = Factory.create(context, symbol)
    }

    private object Factory : CachedEntityFactory<KaFileSymbol, File>() {
        context(KaSession)
        override fun createEntity(context: Context, symbol: KaFileSymbol) = File(symbol, context)
    }
}