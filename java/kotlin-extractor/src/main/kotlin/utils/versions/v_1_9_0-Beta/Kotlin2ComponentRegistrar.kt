// For ComponentRegistrar
@file:Suppress("DEPRECATION", "DEPRECATION_ERROR")

package com.github.codeql

import com.intellij.mock.MockProject
import com.intellij.openapi.extensions.LoadingOrder
import org.jetbrains.kotlin.backend.common.extensions.IrGenerationExtension
import org.jetbrains.kotlin.compiler.plugin.ComponentRegistrar
import org.jetbrains.kotlin.compiler.plugin.ExperimentalCompilerApi
import org.jetbrains.kotlin.config.CompilerConfiguration

@OptIn(ExperimentalCompilerApi::class)
abstract class Kotlin2ComponentRegistrar : ComponentRegistrar {
    override val supportsK2: Boolean
        get() = true

    private var project: MockProject? = null

    override fun registerProjectComponents(
        project: MockProject,
        configuration: CompilerConfiguration
    ) {
        this.project = project
        doRegisterExtensions(configuration)
    }

    abstract fun doRegisterExtensions(configuration: CompilerConfiguration)

    fun registerExtractorExtension(extension: IrGenerationExtension) {
        val p = project ?: throw IllegalStateException("registerExtractorExtension called before registerProjectComponents")
        // Register with LoadingOrder.LAST to ensure the extractor runs after other
        // IR generation plugins (like kotlinx.serialization) have generated their code.
        val extensionPoint = p.extensionArea.getExtensionPoint(IrGenerationExtension.extensionPointName)
        extensionPoint.registerExtension(extension, LoadingOrder.LAST, p)
    }
}
