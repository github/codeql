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
            optionName = OPTION_INVOCATION_TRAP_FILE,
            valueDescription = "Invocation TRAP file",
            description = "Extractor will append invocation-related TRAP to this file",
            required = true,
            allowMultipleOccurrences = false
        )
    )

    override fun processOption(
        option: AbstractCliOption,
        value: String,
        configuration: CompilerConfiguration
    ) = when (option.optionName) {
        "invocationTrapFile" -> configuration.put(KEY_INVOCATION_TRAP_FILE, value)
        else -> error("kotlin extractor: Bad option: ${option.optionName}")
    }
}

private val OPTION_INVOCATION_TRAP_FILE = "invocationTrapFile"
val KEY_INVOCATION_TRAP_FILE = CompilerConfigurationKey<String>(OPTION_INVOCATION_TRAP_FILE)
