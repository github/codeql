package com.github.codeql.entities

import com.github.codeql.DbReftype
import org.jetbrains.kotlin.analysis.api.KaSession
import org.jetbrains.kotlin.analysis.api.symbols.KaNamedClassSymbol

context(KaSession)
class Class private constructor(symbol: KaNamedClassSymbol, context: Context) :
    Entity<KaNamedClassSymbol, DbReftype>(symbol, context) {

    override fun extract() {
        println("class: " + symbol.name.asString())
        val declarations = symbol.declaredMemberScope.declarations.map { getEntity(context, it) }.toList()
        // todo extract class-declaration pairs
    }

    override val key: String
        get() = "class;${symbol.name.asString()}"

    companion object {
        context(KaSession)
        fun create(context: Context, symbol: KaNamedClassSymbol) = Factory.create(context, symbol)
    }

    private object Factory : CachedEntityFactory<KaNamedClassSymbol, Class>() {
        context(KaSession)
        override fun createEntity(context: Context, symbol: KaNamedClassSymbol) = Class(symbol, context)
    }
}