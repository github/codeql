package com.github.codeql.utils.versions

import org.jetbrains.kotlin.fir.backend.FirMetadataSource
import org.jetbrains.kotlin.fir.declarations.FirFile

val FirMetadataSource.File.firFile: FirFile?
    get() = this.files.elementAtOrNull(0)
