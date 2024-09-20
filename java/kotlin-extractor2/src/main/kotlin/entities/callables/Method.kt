package com.github.codeql.entities.callables

import com.github.codeql.DbMethod
import com.github.codeql.entities.CachedEntityFactory
import com.github.codeql.entities.Context
import com.github.codeql.entities.MissingLabel
import com.github.codeql.writeMethods
import org.jetbrains.kotlin.analysis.api.KaSession
import org.jetbrains.kotlin.analysis.api.symbols.KaNamedFunctionSymbol

context(KaSession)
class Method private constructor(symbol: KaNamedFunctionSymbol, context: Context) :
    Callable<KaNamedFunctionSymbol, DbMethod>(symbol, context) {

    override fun writeCallable() {
        context.trapWriter.writeMethods(
            this.label,
            symbol.name.asString(),
            "()",
            MissingLabel(),
            getDeclaringClass().label,
            label
        )
    }

    override val key: String
        get() = "callable;{${getDeclaringClass().label}}.${symbol.name.asString()}()"

    companion object {
        context(KaSession)
        fun create(context: Context, symbol: KaNamedFunctionSymbol) = Factory.create(context, symbol)
    }

    private object Factory : CachedEntityFactory<KaNamedFunctionSymbol, Method>() {
        context(KaSession)
        override fun createEntity(context: Context, symbol: KaNamedFunctionSymbol) = Method(symbol, context)
    }
}