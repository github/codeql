package com.github.codeql.entities

import com.github.codeql.AnyDbType
import com.github.codeql.entities.callables.Callable
import org.jetbrains.kotlin.analysis.api.KaSession
import org.jetbrains.kotlin.analysis.api.symbols.KaCallableSymbol
import org.jetbrains.kotlin.analysis.api.symbols.KaFileSymbol
import org.jetbrains.kotlin.analysis.api.symbols.KaNamedClassSymbol
import org.jetbrains.kotlin.analysis.api.symbols.KaSymbol


context(KaSession)
fun getEntity(context: Context, declaration: KaSymbol): Entity<KaSymbol, AnyDbType>? {
    return when (declaration) {
        is KaCallableSymbol -> Callable.create(context, declaration)
        is KaNamedClassSymbol -> Class.create(context, declaration)
        is KaFileSymbol -> File.create(context, declaration)

        else -> null // Todo: we should handle all cases, and throw instead
    }
}