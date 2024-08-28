package com.github.codeql

/*
OLD: KE1
import com.intellij.openapi.editor.Document
import com.intellij.psi.PsiFile
import com.semmle.util.files.FileUtil
import com.semmle.util.trap.pathtransformers.PathTransformer
*/
import java.io.File
/*
OLD: KE1
import java.io.FileOutputStream
import java.nio.file.Files
import java.nio.file.Paths
import org.jetbrains.kotlin.analysis.api.KaAnalysisApiInternals
import org.jetbrains.kotlin.analysis.api.KaSession
import org.jetbrains.kotlin.analysis.api.analyze
import org.jetbrains.kotlin.analysis.api.platform.lifetime.KotlinAlwaysAccessibleLifetimeTokenProvider
import org.jetbrains.kotlin.analysis.api.platform.lifetime.KotlinLifetimeTokenProvider
import org.jetbrains.kotlin.analysis.api.projectStructure.KaSourceModule
import org.jetbrains.kotlin.analysis.api.standalone.buildStandaloneAnalysisAPISession
import org.jetbrains.kotlin.analysis.project.structure.builder.buildKtLibraryModule
import org.jetbrains.kotlin.analysis.project.structure.builder.buildKtSdkModule
import org.jetbrains.kotlin.analysis.project.structure.builder.buildKtSourceModule
import org.jetbrains.kotlin.cli.common.arguments.parseCommandLineArguments
import org.jetbrains.kotlin.cli.common.arguments.K2JVMCompilerArguments
import org.jetbrains.kotlin.platform.jvm.JvmPlatforms
import org.jetbrains.kotlin.psi.*

import com.github.codeql.utils.versions.usesK2
import java.io.BufferedInputStream
import java.io.BufferedOutputStream
import java.io.BufferedReader
*/
import java.io.BufferedWriter
/*
OLD: KE1
import java.io.File
import java.io.FileInputStream
import java.io.InputStreamReader
import java.io.OutputStreamWriter
import java.lang.management.*
import java.util.zip.GZIPInputStream
*/
import java.util.zip.GZIPOutputStream
/*
OLD: KE1
import kotlin.system.exitProcess
import org.jetbrains.kotlin.backend.common.extensions.IrGenerationExtension
import org.jetbrains.kotlin.backend.common.extensions.IrPluginContext
import org.jetbrains.kotlin.config.KotlinCompilerVersion
import org.jetbrains.kotlin.ir.declarations.*
import org.jetbrains.kotlin.ir.util.*
*/

enum class Compression(val extension: String) {
    NONE("") {
        override fun bufferedWriter(file: File): BufferedWriter {
            return file.bufferedWriter()
        }
    },
    GZIP(".gz") {
        override fun bufferedWriter(file: File): BufferedWriter {
            return GZIPOutputStream(file.outputStream()).bufferedWriter()
        }
    };

    abstract fun bufferedWriter(file: File): BufferedWriter
}

fun getCompression(logger: Logger): Compression {
    val compression_env_var = "CODEQL_EXTRACTOR_JAVA_OPTION_TRAP_COMPRESSION"
    val compression_option = System.getenv(compression_env_var)
    val defaultCompression = Compression.GZIP
    if (compression_option == null) {
        return defaultCompression
    } else {
        try {
            val compression_option_upper = compression_option.uppercase()
            if (compression_option_upper == "BROTLI") {
                logger.warn(
                    "Kotlin extractor doesn't support Brotli compression. Using GZip instead."
                )
                return Compression.GZIP
            } else {
                return Compression.valueOf(compression_option_upper)
            }
        } catch (e: IllegalArgumentException) {
            logger.warn(
                "Unsupported compression type (\$$compression_env_var) \"$compression_option\". Supported values are ${Compression.values().joinToString()}."
            )
            return defaultCompression
        }
    }
}

fun getTrapFileWriter(
    compression: Compression,
    logger: FileLogger,
    trapFileName: String
): TrapFileWriter {
    return when (compression) {
        Compression.NONE -> NonCompressedTrapFileWriter(logger, trapFileName)
        Compression.GZIP -> GZipCompressedTrapFileWriter(logger, trapFileName)
    }
}

abstract class TrapFileWriter(
    val logger: FileLogger,
    trapName: String,
    val extension: String
) {
/*
OLD: KE1
    private val realFile = File(trapName + extension)
    private val parentDir = realFile.parentFile
    lateinit private var tempFile: File

    fun debugInfo(): String {
        if (this::tempFile.isInitialized) {
            return "Partial TRAP file location is $tempFile"
        } else {
            return "Temporary file not yet created."
        }
    }

    fun makeParentDirectory() {
        parentDir.mkdirs()
    }

    fun exists(): Boolean {
        return realFile.exists()
    }

    abstract protected fun getReader(file: File): BufferedReader

    abstract protected fun getWriter(file: File): BufferedWriter

    fun getRealReader(): BufferedReader {
        return getReader(realFile)
    }

    fun getTempReader(): BufferedReader {
        return getReader(tempFile)
    }

    fun getTempWriter(): BufferedWriter {
        logger.info("Will write TRAP file $realFile")
        if (this::tempFile.isInitialized) {
            logger.error("Temp writer reinitialized for $realFile")
        }
        tempFile = File.createTempFile(realFile.getName() + ".", ".trap.tmp" + extension, parentDir)
        logger.debug("Writing temporary TRAP file $tempFile")
        return getWriter(tempFile)
    }

    fun deleteTemp() {
        if (!tempFile.delete()) {
            logger.warn("Failed to delete $tempFile")
        }
    }

    fun renameTempToDifferent() {
        val trapDifferentFile =
            File.createTempFile(realFile.getName() + ".", ".trap.different" + extension, parentDir)
        if (tempFile.renameTo(trapDifferentFile)) {
            logger.warn("TRAP difference: $realFile vs $trapDifferentFile")
        } else {
            logger.warn("Failed to rename $tempFile to $realFile")
        }
    }

    fun renameTempToReal() {
        if (!tempFile.renameTo(realFile)) {
            logger.warn("Failed to rename $tempFile to $realFile")
        }
        logger.info("Finished writing TRAP file $realFile")
    }
*/
}

private class NonCompressedTrapFileWriter(logger: FileLogger, trapName: String) :
    TrapFileWriter(logger, trapName, "") {
/*
OLD: KE1
    override protected fun getReader(file: File): BufferedReader {
        return file.bufferedReader()
    }

    override protected fun getWriter(file: File): BufferedWriter {
        return file.bufferedWriter()
    }
*/
}

private class GZipCompressedTrapFileWriter(logger: FileLogger, trapName: String) :
    TrapFileWriter(logger, trapName, ".gz") {
/*
OLD: KE1
    override protected fun getReader(file: File): BufferedReader {
        return BufferedReader(
            InputStreamReader(GZIPInputStream(BufferedInputStream(FileInputStream(file))))
        )
    }

    override protected fun getWriter(file: File): BufferedWriter {
        return BufferedWriter(
            OutputStreamWriter(GZIPOutputStream(BufferedOutputStream(FileOutputStream(file))))
        )
    }
*/
}
