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
        ),
        CliOption(
            optionName = OPTION_CHECK_TRAP_IDENTICAL,
            valueDescription = "Check whether different invocations produce identical TRAP",
            description = "Check whether different invocations produce identical TRAP",
            required = false,
            allowMultipleOccurrences = false
        )
    )

    override fun processOption(
        option: AbstractCliOption,
        value: String,
        configuration: CompilerConfiguration
    ) = when (option.optionName) {
        "invocationTrapFile" -> configuration.put(KEY_INVOCATION_TRAP_FILE, value)
        "checkTrapIdentical" ->
            when (value) {
            "true" -> configuration.put(KEY_CHECK_TRAP_IDENTICAL, true)
            "false" -> configuration.put(KEY_CHECK_TRAP_IDENTICAL, false)
            else -> error("kotlin extractor: Bad argument $value for checkTrapIdentical")
        }
        else -> error("kotlin extractor: Bad option: ${option.optionName}")
    }
}

private val OPTION_INVOCATION_TRAP_FILE = "invocationTrapFile"
val KEY_INVOCATION_TRAP_FILE = CompilerConfigurationKey<String>(OPTION_INVOCATION_TRAP_FILE)
private val OPTION_CHECK_TRAP_IDENTICAL = "checkTrapIdentical"
val KEY_CHECK_TRAP_IDENTICAL= CompilerConfigurationKey<Boolean>(OPTION_CHECK_TRAP_IDENTICAL)
