package com.github.codeql.utils.versions

import org.jetbrains.kotlin.config.JvmDefaultMode

fun jvmDefaultModeEnabledIsEnabled(jdm: JvmDefaultMode): Boolean {
    return jdm.isEnabled
}
