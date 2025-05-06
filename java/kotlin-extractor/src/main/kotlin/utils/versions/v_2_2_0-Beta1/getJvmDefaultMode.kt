package com.github.codeql.utils.versions

import org.jetbrains.kotlin.config.LanguageVersionSettings
import org.jetbrains.kotlin.config.jvmDefaultMode

fun getJvmDefaultMode(lvs: LanguageVersionSettings) =
    lvs.jvmDefaultMode
