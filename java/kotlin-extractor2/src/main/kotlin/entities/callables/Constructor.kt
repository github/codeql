package com.github.codeql.entities.callables

import com.github.codeql.DbConstructor
import com.github.codeql.entities.CachedEntityFactory
import com.github.codeql.entities.Context
import com.github.codeql.entities.MissingLabel
import com.github.codeql.writeConstrs
import org.jetbrains.kotlin.analysis.api.KaSession
import org.jetbrains.kotlin.analysis.api.symbols.KaConstructorSymbol

context(KaSession)
class Constructor private constructor(symbol: KaConstructorSymbol, context: Context) :
    Callable<KaConstructorSymbol, DbConstructor>(symbol, context) {

    override fun writeCallable() {
        context.trapWriter.writeConstrs(
            this.label,
            "<ctor>",
            "()",
            MissingLabel(),
            getDeclaringClass().label,
            label
        )
    }

    override val key: String
        get() = "callable;{${getDeclaringClass().label}}.<ctor>()"

    companion object {
        context(KaSession)
        fun create(context: Context, symbol: KaConstructorSymbol) = Factory.create(context, symbol)
    }

    private object Factory : CachedEntityFactory<KaConstructorSymbol, Constructor>() {
        context(KaSession)
        override fun createEntity(context: Context, symbol: KaConstructorSymbol) = Constructor(symbol, context)
    }
}