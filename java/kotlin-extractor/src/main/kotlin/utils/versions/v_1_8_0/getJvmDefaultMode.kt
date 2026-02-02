package com.github.codeql.utils.versions

import org.jetbrains.kotlin.config.JvmAnalysisFlags
import org.jetbrains.kotlin.config.LanguageVersionSettings

fun getJvmDefaultMode(lvs: LanguageVersionSettings) =
    lvs.getFlag(JvmAnalysisFlags.jvmDefaultMode)
