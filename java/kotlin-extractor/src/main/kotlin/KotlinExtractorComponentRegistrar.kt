// For ComponentRegistrar
@file:Suppress("DEPRECATION")

package com.github.codeql

import org.jetbrains.kotlin.config.CompilerConfiguration

class KotlinExtractorComponentRegistrar : Kotlin2ComponentRegistrar() {
    override fun doRegisterExtensions(configuration: CompilerConfiguration) {
        val invocationTrapFile = configuration[KEY_INVOCATION_TRAP_FILE]
        if (invocationTrapFile == null) {
            throw Exception("Required argument for TRAP invocation file not given")
        }
        registerExtractorExtension(
            KotlinExtractorExtension(
                invocationTrapFile,
                configuration[KEY_CHECK_TRAP_IDENTICAL] ?: false,
                configuration[KEY_COMPILATION_STARTTIME],
                configuration[KEY_EXIT_AFTER_EXTRACTION] ?: false
            )
        )
    }
}
