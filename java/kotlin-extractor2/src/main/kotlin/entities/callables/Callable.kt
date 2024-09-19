package com.github.codeql.entities.callables

import com.github.codeql.DbCallable
import com.github.codeql.entities.Class
import com.github.codeql.entities.Context
import com.github.codeql.entities.Entity
import org.jetbrains.kotlin.analysis.api.KaSession
import org.jetbrains.kotlin.analysis.api.resolution.KaSimpleFunctionCall
import org.jetbrains.kotlin.analysis.api.resolution.calls
import org.jetbrains.kotlin.analysis.api.resolution.symbol
import org.jetbrains.kotlin.analysis.api.symbols.*
import org.jetbrains.kotlin.psi.KtCallExpression
import org.jetbrains.kotlin.psi.KtDeclarationWithBody

abstract class Callable<out TSymbol : KaCallableSymbol, out TDbType : DbCallable> protected constructor(
    symbol: TSymbol,
    context: Context
) :
    Entity<TSymbol, TDbType>(symbol, context) {

    context(KaSession)
    override fun extract() {
        println("callable: " + symbol.name?.asString())
        writeCallable()

        val methodSyntax = symbol.psi as? KtDeclarationWithBody
        if (methodSyntax != null) {

            val callSyntax = methodSyntax.bodyBlockExpression?.statements?.firstOrNull() as? KtCallExpression
            val callSymbol = callSyntax?.resolveToCall()?.calls?.firstOrNull() as? KaSimpleFunctionCall
            if (callSymbol != null) {
                var target = create(context, callSymbol.symbol)
            }
        }
    }

    context(KaSession)
    protected abstract fun writeCallable()

    context(KaSession)
    protected fun getDeclaringClass() = Class.create(context, symbol.containingSymbol as KaNamedClassSymbol)

    companion object {
        context(KaSession)
        fun create(context: Context, symbol: KaCallableSymbol) = when (symbol) {
            is KaNamedFunctionSymbol -> Method.create(context, symbol)
            is KaConstructorSymbol -> Constructor.create(context, symbol)

            else -> throw Exception("Missing callable type")
        }
    }
}

