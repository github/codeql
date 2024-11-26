package com.github.codeql.utils

import org.jetbrains.kotlin.analysis.api.symbols.*
import org.jetbrains.kotlin.analysis.api.types.KaType

val KaClassSymbol.isInterfaceLike
    get() = classKind == KaClassKind.INTERFACE || classKind == KaClassKind.ANNOTATION_CLASS

val KaParameterSymbol.type: KaType
    get() {
        return when (this) {
            is KaValueParameterSymbol -> this.returnType
            is KaReceiverParameterSymbol -> this.type
        }
    }