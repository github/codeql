package com.github.codeql.entities

import com.github.codeql.AnyDbType
import com.github.codeql.Label
import org.jetbrains.kotlin.analysis.api.KaSession
import org.jetbrains.kotlin.analysis.api.symbols.KaSymbol

context(KaSession)
abstract class Entity<out TSymbol : KaSymbol, out TDbType : AnyDbType> protected constructor(
    val symbol: TSymbol,
    val context: Context
) {

    val label: Label<out TDbType> = context.trapWriter.lm.getFreshLabel()

    abstract fun extract()

    abstract val key: String
}