package com.github.codeql

import org.jetbrains.kotlin.compiler.plugin.AbstractCliOption
import org.jetbrains.kotlin.compiler.plugin.CliOption
import org.jetbrains.kotlin.compiler.plugin.CommandLineProcessor
import org.jetbrains.kotlin.compiler.plugin.ExperimentalCompilerApi
import org.jetbrains.kotlin.config.CompilerConfiguration
import org.jetbrains.kotlin.config.CompilerConfigurationKey

@OptIn(ExperimentalCompilerApi::class)
class KotlinExtractorCommandLineProcessor : CommandLineProcessor {
    override val pluginId = "kotlin-extractor"

    override val pluginOptions =
        listOf(
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
            ),
            CliOption(
                optionName = OPTION_COMPILATION_STARTTIME,
                valueDescription = "The start time of the compilation as a Unix timestamp",
                description = "The start time of the compilation as a Unix timestamp",
                required = false,
                allowMultipleOccurrences = false
            ),
            CliOption(
                optionName = OPTION_EXIT_AFTER_EXTRACTION,
                valueDescription =
                    "Specify whether to call exitProcess after the extraction has completed",
                description =
                    "Specify whether to call exitProcess after the extraction has completed",
                required = false,
                allowMultipleOccurrences = false
            )
        )

    override fun processOption(
        option: AbstractCliOption,
        value: String,
        configuration: CompilerConfiguration
    ) =
        when (option.optionName) {
            OPTION_INVOCATION_TRAP_FILE -> configuration.put(KEY_INVOCATION_TRAP_FILE, value)
            OPTION_CHECK_TRAP_IDENTICAL ->
                processBooleanOption(
                    value,
                    OPTION_CHECK_TRAP_IDENTICAL,
                    KEY_CHECK_TRAP_IDENTICAL,
                    configuration
                )
            OPTION_EXIT_AFTER_EXTRACTION ->
                processBooleanOption(
                    value,
                    OPTION_EXIT_AFTER_EXTRACTION,
                    KEY_EXIT_AFTER_EXTRACTION,
                    configuration
                )
            OPTION_COMPILATION_STARTTIME ->
                when (val v = value.toLongOrNull()) {
                    is Long -> configuration.put(KEY_COMPILATION_STARTTIME, v)
                    else ->
                        error(
                            "kotlin extractor: Bad argument $value for $OPTION_COMPILATION_STARTTIME"
                        )
                }
            else -> error("kotlin extractor: Bad option: ${option.optionName}")
        }

    private fun processBooleanOption(
        value: String,
        optionName: String,
        configKey: CompilerConfigurationKey<Boolean>,
        configuration: CompilerConfiguration
    ) =
        when (value) {
            "true" -> configuration.put(configKey, true)
            "false" -> configuration.put(configKey, false)
            else -> error("kotlin extractor: Bad argument $value for $optionName")
        }
}

private val OPTION_INVOCATION_TRAP_FILE = "invocationTrapFile"
val KEY_INVOCATION_TRAP_FILE = CompilerConfigurationKey<String>(OPTION_INVOCATION_TRAP_FILE)
private val OPTION_CHECK_TRAP_IDENTICAL = "checkTrapIdentical"
val KEY_CHECK_TRAP_IDENTICAL = CompilerConfigurationKey<Boolean>(OPTION_CHECK_TRAP_IDENTICAL)
private val OPTION_COMPILATION_STARTTIME = "compilationStartTime"
val KEY_COMPILATION_STARTTIME = CompilerConfigurationKey<Long>(OPTION_COMPILATION_STARTTIME)
private val OPTION_EXIT_AFTER_EXTRACTION = "exitAfterExtraction"
val KEY_EXIT_AFTER_EXTRACTION = CompilerConfigurationKey<Boolean>(OPTION_EXIT_AFTER_EXTRACTION)
