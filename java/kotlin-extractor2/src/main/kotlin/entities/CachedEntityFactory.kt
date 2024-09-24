package com.github.codeql.entities

import com.github.codeql.AnyDbType
import org.jetbrains.kotlin.analysis.api.KaSession
import org.jetbrains.kotlin.analysis.api.symbols.KaSymbol

abstract class CachedEntityFactory<TSymbol : KaSymbol, TEntity : Entity<TSymbol, AnyDbType>> {
    context(KaSession)
    fun create(context: Context, symbol: TSymbol): TEntity {
        return context.createEntity(this, symbol)
    }

    context(KaSession)
    abstract fun createEntity(context: Context, symbol: TSymbol): TEntity
}