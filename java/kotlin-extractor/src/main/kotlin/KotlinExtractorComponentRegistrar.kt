package com.github.codeql

import org.jetbrains.kotlin.backend.common.extensions.IrGenerationExtension
import com.intellij.mock.MockProject
import org.jetbrains.kotlin.compiler.plugin.ComponentRegistrar
import org.jetbrains.kotlin.config.CompilerConfiguration

class KotlinExtractorComponentRegistrar : ComponentRegistrar {
    override fun registerProjectComponents(
        project: MockProject,
        configuration: CompilerConfiguration
    ) {
        val tests = configuration[KEY_TEST] ?: emptyList()
        IrGenerationExtension.registerExtension(project, KotlinExtractorExtension(tests))
    }
}
