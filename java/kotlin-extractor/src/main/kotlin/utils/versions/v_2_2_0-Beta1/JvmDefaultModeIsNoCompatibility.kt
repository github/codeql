package com.github.codeql.utils.versions

import org.jetbrains.kotlin.config.JvmDefaultMode

fun jvmDefaultModeIsNoCompatibility(jdm: JvmDefaultMode): Boolean {
    return jdm == JvmDefaultMode.NO_COMPATIBILITY
}
