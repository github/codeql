@file:Suppress("DEPRECATION")
@file:OptIn(ExperimentalCompilerApi::class)

package com.github.codeql

import org.jetbrains.kotlin.backend.common.extensions.IrGenerationExtension
import org.jetbrains.kotlin.compiler.plugin.CompilerPluginRegistrar
import org.jetbrains.kotlin.compiler.plugin.ExperimentalCompilerApi
import org.jetbrains.kotlin.config.CompilerConfiguration

abstract class Kotlin2ComponentRegistrar : CompilerPluginRegistrar() {
    override val supportsK2: Boolean
        get() = true

    override val pluginId: String
        get() = "com.github.codeql.kotlin-extractor"

    private var extensionStorage: CompilerPluginRegistrar.ExtensionStorage? = null

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
