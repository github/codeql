package com.github.codeql.entities

import com.github.codeql.AnyDbType
import com.github.codeql.FileLogger
import com.github.codeql.SourceFileTrapWriter
import org.jetbrains.kotlin.analysis.api.KaSession
import org.jetbrains.kotlin.analysis.api.symbols.KaFileSymbol
import org.jetbrains.kotlin.analysis.api.symbols.KaSymbol
import org.jetbrains.kotlin.analysis.api.symbols.name
import org.jetbrains.kotlin.analysis.api.symbols.psi
import org.jetbrains.kotlin.psi.KtFile
import java.util.*

class Context(val logger: FileLogger, val trapWriter: SourceFileTrapWriter, val file: KaFileSymbol) {
    private val symbolEntityCache: MutableMap<KaSymbol, Entity<KaSymbol, AnyDbType>> = mutableMapOf()
    private val extractionQueue: Queue<() -> Unit> = LinkedList()

    context(KaSession)
    fun <TSymbol : KaSymbol, TEntity : Entity<TSymbol, AnyDbType>> createEntity(
        factory: CachedEntityFactory<TSymbol, TEntity>,
        symbol: TSymbol
    ): TEntity {
        val cachedEntity = symbolEntityCache[symbol]
        if (cachedEntity != null) {
            @Suppress("UNCHECKED_CAST")
            return cachedEntity as TEntity
        }

        val entity = factory.createEntity(this, symbol)
        
        trapWriter.writeTrap("${entity.label} = @\"${entity.key}\"\n")

        if (symbol.containingFile == file || symbol == file) {
            extractionQueue.add { entity.extract() }
        } else {
            println("Symbol belonging to other file: " + symbol.name?.asString() + ", current file: " + file.psi<KtFile>().virtualFilePath)
        }

        symbolEntityCache[symbol] = entity
        return entity
    }

    fun extractAll() {
        var extractionLambda = extractionQueue.poll()
        while (extractionLambda != null) {
            extractionLambda()

            extractionLambda = extractionQueue.poll()
        }
    }
}