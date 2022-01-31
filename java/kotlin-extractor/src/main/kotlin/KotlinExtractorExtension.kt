package com.github.codeql

import org.jetbrains.kotlin.backend.common.extensions.IrGenerationExtension
import org.jetbrains.kotlin.backend.common.extensions.IrPluginContext
import org.jetbrains.kotlin.ir.declarations.*
import java.io.File
import java.io.FileOutputStream
import java.nio.file.Files
import java.nio.file.Paths
import com.semmle.util.files.FileUtil
import com.semmle.util.unicode.UTF8Util
import kotlin.system.exitProcess

class KotlinExtractorExtension(
    private val invocationTrapFile: String,
    private val checkTrapIdentical: Boolean,
    private val compilationStartTime: Long?,
    private val exitAfterExtraction: Boolean)
    : IrGenerationExtension {

    override fun generate(moduleFragment: IrModuleFragment, pluginContext: IrPluginContext) {
        try {
            runExtractor(moduleFragment, pluginContext)
        } catch(e: Exception) {
            // If we get an exception at the top level, then we don't
            // have many options. We just print it to stderr, and then
            // return so the rest of the compilation can complete.
            System.err.println("CodeQL Kotlin extractor: Top-level exception.")
            e.printStackTrace(System.err)
        }
        if (exitAfterExtraction) {
            exitProcess(0)
        }
    }

    private fun runExtractor(moduleFragment: IrModuleFragment, pluginContext: IrPluginContext) {
        val startTimeMs = System.currentTimeMillis()
        val invocationExtractionProblems = ExtractionProblems()
        // This default should be kept in sync with com.semmle.extractor.java.interceptors.KotlinInterceptor.initializeExtractionContext
        val trapDir = File(System.getenv("CODEQL_EXTRACTOR_JAVA_TRAP_DIR").takeUnless { it.isNullOrEmpty() } ?: "kotlin-extractor/trap")
        FileOutputStream(File(invocationTrapFile), true).bufferedWriter().use { invocationTrapFileBW ->
            val lm = TrapLabelManager()
            val tw = TrapWriter(lm, invocationTrapFileBW)
            // The interceptor has already defined #compilation = *
            val compilation: Label<DbCompilation> = StringLabel("compilation")
            tw.writeCompilation_started(compilation)
            if (compilationStartTime != null) {
                tw.writeCompilation_compiler_times(compilation, -1.0, (System.currentTimeMillis()-compilationStartTime)/1000.0)
            }
            tw.flush()
            val logCounter = LogCounter()
            val logger = Logger(logCounter, tw)
            logger.info("Extraction started")
            logger.flush()
            val primitiveTypeMapping = PrimitiveTypeMapping(logger, pluginContext)
            // FIXME: FileUtil expects a static global logger
            // which should be provided by SLF4J's factory facility. For now we set it here.
            FileUtil.logger = logger
            val srcDir = File(System.getenv("CODEQL_EXTRACTOR_JAVA_SOURCE_ARCHIVE_DIR").takeUnless { it.isNullOrEmpty() } ?: "kotlin-extractor/src")
            srcDir.mkdirs()
            val genericSpecialisationsExtracted = HashSet<String>()
            moduleFragment.files.mapIndexed { index: Int, file: IrFile ->
                val fileExtractionProblems = FileExtractionProblems(invocationExtractionProblems)
                val fileTrapWriter = tw.makeSourceFileTrapWriter(file, true)
                fileTrapWriter.writeCompilation_compiling_files(compilation, index, fileTrapWriter.fileId)
                doFile(fileExtractionProblems, invocationTrapFile, fileTrapWriter, checkTrapIdentical, logCounter, trapDir, srcDir, file, primitiveTypeMapping, pluginContext, genericSpecialisationsExtracted)
                fileTrapWriter.writeCompilation_compiling_files_completed(compilation, index, fileExtractionProblems.extractionResult())
            }
            logger.printLimitedWarningCounts()
            // We don't want the compiler to continue and generate class
            // files etc, so we just exit when we are finished extracting.
            logger.info("Extraction completed")
            logger.flush()
            val compilationTimeMs = System.currentTimeMillis() - startTimeMs
            tw.writeCompilation_finished(compilation, -1.0, compilationTimeMs.toDouble() / 1000, invocationExtractionProblems.extractionResult())
            tw.flush()
        }
    }
}

/*
ExtractionProblems distinguish 2 kinds of problems:
* Recoverable problems: e.g. if we check something that we expect to be
  non-null and find that it is null.
* Non-recoverable problems: if we catch an exception
*/
open class ExtractionProblems {
    private var recoverableProblem = false
    private var nonRecoverableProblem = false

    open fun setRecoverableProblem() {
        recoverableProblem = true
    }
    open fun setNonRecoverableProblem() {
        nonRecoverableProblem = true
    }
    fun extractionResult(): Int {
        if(nonRecoverableProblem) {
            return 2
        } else if(recoverableProblem) {
            return 1
        } else {
            return 0
        }
    }
}

class FileExtractionProblems(val invocationExtractionProblems: ExtractionProblems): ExtractionProblems() {
    override fun setRecoverableProblem() {
        super.setRecoverableProblem()
        invocationExtractionProblems.setRecoverableProblem()
    }
    override fun setNonRecoverableProblem() {
        super.setNonRecoverableProblem()
        invocationExtractionProblems.setNonRecoverableProblem()
    }
}

fun escapeTrapString(str: String) = str.replace("\"", "\"\"")

const val MAX_STRLEN = 1.shl(20) // 1 megabyte

fun truncateString(str: String) = str.substring(0, UTF8Util.encodablePrefixLength(str, MAX_STRLEN))

private fun equivalentTrap(f1: File, f2: File): Boolean {
    f1.bufferedReader().use { bw1 ->
        f2.bufferedReader().use { bw2 ->
            while(true) {
                val l1 = bw1.readLine()
                val l2 = bw2.readLine()
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

fun doFile(fileExtractionProblems: FileExtractionProblems,
           invocationTrapFile: String,
           fileTrapWriter: FileTrapWriter,
           checkTrapIdentical: Boolean,
           logCounter: LogCounter,
           dbTrapDir: File,
           dbSrcDir: File,
           srcFile: IrFile,
           primitiveTypeMapping: PrimitiveTypeMapping,
           pluginContext: IrPluginContext,
           genericSpecialisationsExtracted: MutableSet<String>) {
    val srcFilePath = srcFile.path
    val logger = FileLogger(logCounter, fileTrapWriter)
    logger.info("Extracting file $srcFilePath")
    logger.flush()

    val dbSrcFilePath = Paths.get("$dbSrcDir/$srcFilePath")
    val dbSrcDirPath = dbSrcFilePath.parent
    Files.createDirectories(dbSrcDirPath)
    val srcTmpFile = File.createTempFile(dbSrcFilePath.fileName.toString() + ".", ".src.tmp", dbSrcDirPath.toFile())
    srcTmpFile.outputStream().use {
        Files.copy(Paths.get(srcFilePath), it)
    }
    srcTmpFile.renameTo(dbSrcFilePath.toFile())

    val trapFile = File("$dbTrapDir/$srcFilePath.trap")
    val trapFileDir = trapFile.parentFile
    trapFileDir.mkdirs()

    if (checkTrapIdentical || !trapFile.exists()) {
        val trapTmpFile = File.createTempFile("$srcFilePath.", ".trap.tmp", trapFileDir)

        try {
            trapTmpFile.bufferedWriter().use { trapFileBW ->
                // We want our comments to be the first thing in the file,
                // so start off with a mere TrapWriter
                val tw = TrapWriter(TrapLabelManager(), trapFileBW)
                tw.writeComment("Generated by the CodeQL Kotlin extractor for kotlin source code")
                tw.writeComment("Part of invocation $invocationTrapFile")
                // Now elevate to a SourceFileTrapWriter, and populate the
                // file information
                val sftw = tw.makeSourceFileTrapWriter(srcFile, true)
                val externalClassExtractor = ExternalClassExtractor(logger, invocationTrapFile, srcFilePath, primitiveTypeMapping, pluginContext, genericSpecialisationsExtracted)
                val fileExtractor = KotlinFileExtractor(logger, sftw, srcFilePath, null, externalClassExtractor, primitiveTypeMapping, pluginContext, genericSpecialisationsExtracted)

                fileExtractor.extractFileContents(srcFile, sftw.fileId)
                externalClassExtractor.extractExternalClasses()
            }

            if (checkTrapIdentical && trapFile.exists()) {
                if (equivalentTrap(trapTmpFile, trapFile)) {
                    if (!trapTmpFile.delete()) {
                        logger.warn(Severity.WarnLow, "Failed to delete $trapTmpFile")
                    }
                } else {
                    val trapDifferentFile = File.createTempFile("$srcFilePath.", ".trap.different", dbTrapDir)
                    if (trapTmpFile.renameTo(trapDifferentFile)) {
                        logger.warn(Severity.Warn, "TRAP difference: $trapFile vs $trapDifferentFile")
                    } else {
                        logger.warn(Severity.WarnLow, "Failed to rename $trapTmpFile to $trapFile")
                    }
                }
            } else {
                if (!trapTmpFile.renameTo(trapFile)) {
                    logger.warn(Severity.WarnLow, "Failed to rename $trapTmpFile to $trapFile")
                }
            }
        } catch (e: Exception) {
            logger.error("Failed to extract '$srcFilePath'. Partial TRAP file location is $trapTmpFile", e)
            fileExtractionProblems.setNonRecoverableProblem()
        }
    }
}
