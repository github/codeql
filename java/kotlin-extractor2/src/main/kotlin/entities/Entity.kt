package com.github.codeql.entities

import com.github.codeql.AnyDbType
import com.github.codeql.Label
import org.jetbrains.kotlin.analysis.api.KaSession
import org.jetbrains.kotlin.analysis.api.symbols.KaSymbol

abstract class Entity<out TSymbol : KaSymbol, out TDbType : AnyDbType> protected constructor(
    val symbol: TSymbol,
    val context: Context
) {

    val label: Label<out TDbType> = context.trapWriter.lm.getFreshLabel()

    context(KaSession)
    abstract fun extract()

    context(KaSession)
    abstract val key: String
}