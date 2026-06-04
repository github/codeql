@file:Suppress("DEPRECATION", "DEPRECATION_ERROR")
@file:OptIn(ExperimentalCompilerApi::class)

package com.github.codeql

import com.intellij.mock.MockProject
import org.jetbrains.kotlin.backend.common.extensions.IrGenerationExtension
import org.jetbrains.kotlin.compiler.plugin.ComponentRegistrar
import org.jetbrains.kotlin.compiler.plugin.CompilerPluginRegistrar
import org.jetbrains.kotlin.compiler.plugin.ExperimentalCompilerApi
import org.jetbrains.kotlin.config.CompilerConfiguration

abstract class Kotlin2ComponentRegistrar : CompilerPluginRegistrar(), ComponentRegistrar {
    override val supportsK2: Boolean
        get() = true

    override val pluginId: String
        get() = "com.github.codeql.kotlin-extractor"

    // ComponentRegistrar implementation (legacy path, still called by Kotlin compiler)
    override fun registerProjectComponents(
        project: MockProject,
        configuration: CompilerConfiguration
    ) {
        // In 2.4.0, we use CompilerPluginRegistrar path instead.
        // This is only called if the compiler uses the ComponentRegistrar service file.
        // We do nothing here since registerExtensions will be called separately.
    }

    private var extensionStorage: CompilerPluginRegistrar.ExtensionStorage? = null
    private var registeredExtension: IrGenerationExtension? = null

    override fun ExtensionStorage.registerExtensions(configuration: CompilerConfiguration) {
        this@Kotlin2ComponentRegistrar.extensionStorage = this
        doRegisterExtensions(configuration)
    }

    abstract fun doRegisterExtensions(configuration: CompilerConfiguration)

    fun registerExtractorExtension(extension: IrGenerationExtension) {
        val storage = extensionStorage ?: throw IllegalStateException("registerExtractorExtension called before registerExtensions")
        with(storage) {
            IrGenerationExtension.registerExtension(extension)
        }
    }
}
