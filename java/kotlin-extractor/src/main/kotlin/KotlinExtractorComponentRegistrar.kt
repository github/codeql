// For ComponentRegistrar
@file:Suppress("DEPRECATION")

package com.github.codeql

import org.jetbrains.kotlin.backend.common.extensions.IrGenerationExtension
import org.jetbrains.kotlin.compiler.plugin.ExperimentalCompilerApi
import com.intellij.mock.MockProject
import org.jetbrains.kotlin.compiler.plugin.ComponentRegistrar
import org.jetbrains.kotlin.config.CompilerConfiguration

@OptIn(ExperimentalCompilerApi::class)
class KotlinExtractorComponentRegistrar : ComponentRegistrar {
    override fun registerProjectComponents(
        project: MockProject,
        configuration: CompilerConfiguration
    ) {
        val invocationTrapFile = configuration[KEY_INVOCATION_TRAP_FILE]
        if (invocationTrapFile == null) {
            throw Exception("Required argument for TRAP invocation file not given")
        }
        IrGenerationExtension.registerExtension(project, KotlinExtractorExtension(
            invocationTrapFile,
            configuration[KEY_CHECK_TRAP_IDENTICAL] ?: false,
            configuration[KEY_COMPILATION_STARTTIME],
            configuration[KEY_EXIT_AFTER_EXTRACTION] ?: false))
    }
}
