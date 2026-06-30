package com.github.codeql

import com.intellij.mock.MockProject
import org.jetbrains.kotlin.backend.common.extensions.IrGenerationExtension
import org.jetbrains.kotlin.compiler.plugin.CompilerPluginRegistrar
import org.jetbrains.kotlin.compiler.plugin.ExperimentalCompilerApi
import org.jetbrains.kotlin.config.CompilerConfiguration

@OptIn(ExperimentalCompilerApi::class)
@Suppress("DEPRECATION", "DEPRECATION_ERROR")
abstract class Kotlin2ComponentRegistrar :
    CompilerPluginRegistrar(),
    org.jetbrains.kotlin.compiler.plugin.ComponentRegistrar {
    override val supportsK2: Boolean
        get() = true

    override val pluginId: String
        get() = "kotlin-extractor"

    // ComponentRegistrar implementation (legacy path, still called by Kotlin compiler)
    override fun registerProjectComponents(
        project: MockProject,
        configuration: CompilerConfiguration
    ) {
        // Registration is done via ExtensionStorage in Kotlin 2.4+.
        // This legacy entry point remains for compatibility with service discovery.
    }

    private var extensionStorage: CompilerPluginRegistrar.ExtensionStorage? = null

    override fun ExtensionStorage.registerExtensions(configuration: CompilerConfiguration) {
        this@Kotlin2ComponentRegistrar.extensionStorage = this
        doRegisterExtensions(configuration)
    }

    abstract fun doRegisterExtensions(configuration: CompilerConfiguration)

    protected fun registerExtractorExtension(extension: IrGenerationExtension) {
        val storage = extensionStorage
            ?: throw IllegalStateException("registerExtractorExtension called before registerExtensions")
        with(storage) {
            IrGenerationExtension.registerExtension(extension)
        }
    }
}
