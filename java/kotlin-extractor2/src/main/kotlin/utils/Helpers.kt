package com.github.codeql.utils

import org.jetbrains.kotlin.analysis.api.symbols.*

val KaClassSymbol.isInterfaceLike
    get() = classKind == KaClassKind.INTERFACE || classKind == KaClassKind.ANNOTATION_CLASS

