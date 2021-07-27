package com.github.codeql

import org.jetbrains.kotlin.compiler.plugin.AbstractCliOption
import org.jetbrains.kotlin.compiler.plugin.CliOption
import org.jetbrains.kotlin.compiler.plugin.CommandLineProcessor
import org.jetbrains.kotlin.config.CompilerConfiguration
import org.jetbrains.kotlin.config.CompilerConfigurationKey

class KotlinExtractorCommandLineProcessor : CommandLineProcessor {
    override val pluginId = "kotlin-extractor"

    override val pluginOptions = listOf(
        CliOption(
            optionName = "testOption",
            valueDescription = "A test option",
            description = "For testing options",
            required = false,
            allowMultipleOccurrences = true
        )
    )

    override fun processOption(
        option: AbstractCliOption,
        value: String,
        configuration: CompilerConfiguration
    ) = when (option.optionName) {
        "testOption" -> configuration.appendList(KEY_TEST, value)
        else -> error("kotlin extractor: Bad option: ${option.optionName}")
    }
}

val KEY_TEST = CompilerConfigurationKey<List<String>>("kotlin extractor test")
