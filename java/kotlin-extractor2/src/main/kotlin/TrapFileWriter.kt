package com.github.codeql

import java.io.BufferedInputStream
import java.io.BufferedOutputStream
import java.io.BufferedReader
import java.io.BufferedWriter
import java.io.File
import java.io.FileInputStream
import java.io.FileOutputStream
import java.io.InputStreamReader
import java.io.OutputStreamWriter
import java.util.zip.GZIPInputStream
import java.util.zip.GZIPOutputStream

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
    checkTrapIdentical: Boolean,
    trapFileName: String
): TrapFileWriter {
    return when (compression) {
        Compression.NONE -> NonCompressedTrapFileWriter(logger, checkTrapIdentical, trapFileName)
        Compression.GZIP -> GZipCompressedTrapFileWriter(logger, checkTrapIdentical, trapFileName)
    }
}

abstract class TrapFileWriter(
    val logger: FileLogger,
    val checkTrapIdentical: Boolean,
    trapName: String,
    val extension: String
) {
    abstract protected fun getReader(file: File): BufferedReader
    abstract protected fun getWriter(file: File): BufferedWriter

    private val realFile = File(trapName + extension)
    private val parentDir = realFile.parentFile

    fun run(block: (bw: BufferedWriter) -> Unit) {
        if (checkTrapIdentical || !exists()) {
            parentDir.mkdirs()

            logger.info("Will write TRAP file $realFile")
            val tempFile = File.createTempFile(realFile.getName() + ".", ".trap.tmp" + extension, parentDir)
            logger.debug("Writing temporary TRAP file $tempFile")
            getWriter(tempFile).use { bw -> block(bw) }

            if (checkTrapIdentical && exists()) {
                if (equivalentTrap(getReader(tempFile), getReader(realFile))) {
                    deleteTemp(tempFile)
                } else {
                    renameTempToDifferent(tempFile)
                }
            } else {
                renameTempToReal(tempFile)
            }
        }
    }

/*
OLD: KE1
    fun debugInfo(): String {
        if (this::tempFile.isInitialized) {
            return "Partial TRAP file location is $tempFile"
        } else {
            return "Temporary file not yet created."
        }
    }
*/

    private fun exists(): Boolean {
        return realFile.exists()
    }

    private fun deleteTemp(tempFile: File) {
        if (!tempFile.delete()) {
            logger.warn("Failed to delete $tempFile")
        }
    }

    private fun renameTempToDifferent(tempFile: File) {
        val trapDifferentFile =
            File.createTempFile(realFile.getName() + ".", ".trap.different" + extension, parentDir)
        if (tempFile.renameTo(trapDifferentFile)) {
            logger.warn("TRAP difference: $realFile vs $trapDifferentFile")
        } else {
            logger.warn("Failed to rename $tempFile to $realFile")
        }
    }

    private fun renameTempToReal(tempFile: File) {
        if (!tempFile.renameTo(realFile)) {
            logger.warn("Failed to rename $tempFile to $realFile")
        }
        logger.info("Finished writing TRAP file $realFile")
    }
}

private class NonCompressedTrapFileWriter(logger: FileLogger, checkTrapIdentical: Boolean, trapName: String) :
    TrapFileWriter(logger, checkTrapIdentical, trapName, "") {
    override protected fun getReader(file: File): BufferedReader {
        return file.bufferedReader()
    }

    override protected fun getWriter(file: File): BufferedWriter {
        return file.bufferedWriter()
    }
}

private class GZipCompressedTrapFileWriter(logger: FileLogger, checkTrapIdentical: Boolean, trapName: String) :
    TrapFileWriter(logger, checkTrapIdentical, trapName, ".gz") {
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
}

/*
This function determines whether 2 TRAP files should be considered to be
equivalent. It returns `true` iff all of their non-comment lines are
identical.
*/
private fun equivalentTrap(r1: BufferedReader, r2: BufferedReader): Boolean {
    r1.use { br1 ->
        r2.use { br2 ->
            while (true) {
                val l1 = br1.readLine()
                val l2 = br2.readLine()
                if (l1 == null && l2 == null) {
                    return true
                } else if (l1 == null || l2 == null) {
                    return false
                } else if (l1 != l2) {
                    if (!l1.startsWith("//") || !l2.startsWith("//")) {
                        return false
                    }
                }
            }
        }
    }
}
