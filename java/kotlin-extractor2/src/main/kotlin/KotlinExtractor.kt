package com.github.codeql

import com.intellij.openapi.editor.Document
import com.intellij.psi.PsiFile
import com.semmle.util.files.FileUtil
import com.semmle.util.trap.pathtransformers.PathTransformer
import java.io.File
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

fun main(args : Array<String>) {
    System.out.println("Kotlin Extractor 2 running")
    try {
        runExtractor(args)
    // We catch Throwable rather than Exception, as we want to
    // log about the failure even if we get a stack overflow
    // or an assertion failure in one file.
    } catch (e: Throwable) {
        // If we get an exception at the top level, then something's
        // gone very wrong. Don't try to be too fancy, but try to
        // log a simple message.
        val msg = "[ERROR] CodeQL Kotlin extractor: Top-level exception."
        // First, if we can find our log directory, then let's try
        // making a log file there:
        val extractorLogDir = System.getenv("CODEQL_EXTRACTOR_JAVA_LOG_DIR")
        if (extractorLogDir != null && extractorLogDir != "") {
            // We use a slightly different filename pattern compared
            // to normal logs. Just the existence of a `-top` log is
            // a sign that something's gone very wrong.
            val logFile = File.createTempFile("kotlin-extractor-top.", ".log", File(extractorLogDir))
            logFile.writeText(msg)
            // Now we've got that out, let's see if we can append a stack trace too
            logFile.appendText(e.stackTraceToString())
        } else {
            // We don't have much choice here except to print to
            // stderr and hope for the best.
            System.err.println(msg)
            e.printStackTrace(System.err)
        }
    }
}

@OptIn(KaAnalysisApiInternals::class)
fun runExtractor(args : Array<String>) {
    val startTimeMs = System.currentTimeMillis()

    val invocationTrapFile = args[0]
    val kotlinArgs = args.drop(1)
    System.out.println("Invocation TRAP file: " + invocationTrapFile)

    // This default should be kept in sync with
    // com.semmle.extractor.java.interceptors.KotlinInterceptor.initializeExtractionContext
    val trapDir =
        File(
            System.getenv("CODEQL_EXTRACTOR_JAVA_TRAP_DIR").takeUnless { it.isNullOrEmpty() }
                ?: "kotlin-extractor/trap"
        )

    // The invocation TRAP file will already have been started
    // as an uncompressed TRAP file before the extractor is run,
    // so we always use no compression and we open it in append mode.
    FileOutputStream(File(invocationTrapFile), true).bufferedWriter().use { invocationTrapFileBW
        ->
/*
OLD: KE1
        val usesK2 = usesK2(pluginContext)
*/
        val invocationExtractionProblems = ExtractionProblems()
        val invocationLabelManager = TrapLabelManager()
        val diagnosticCounter = DiagnosticCounter()
        val loggerBase = LoggerBase(diagnosticCounter)
        val dtw = DiagnosticTrapWriter(loggerBase, invocationLabelManager, invocationTrapFileBW)
        // The diagnostic TRAP file has already defined #compilation = *
        val compilation: Label<DbCompilation> = StringLabel("compilation")
        dtw.writeCompilation_started(compilation)
/*
OLD: KE1
        dtw.writeCompilation_info(
            compilation,
            "Kotlin Compiler Version",
            KotlinCompilerVersion.getVersion() ?: "<unknown>"
        )
        val extractor_name =
            this::class.java.getResource("extractor.name")?.readText() ?: "<unknown>"
        dtw.writeCompilation_info(compilation, "Kotlin Extractor Name", extractor_name)
        dtw.writeCompilation_info(compilation, "Uses Kotlin 2", usesK2.toString())
        if (compilationStartTime != null) {
            dtw.writeCompilation_compiler_times(
                compilation,
                -1.0,
                (System.currentTimeMillis() - compilationStartTime) / 1000.0
            )
        }
*/
        dtw.flush()
        val logger = Logger(loggerBase, dtw)
        logger.info("Extraction started")
        logger.flush()
        logger.info("Extraction for invocation TRAP file $invocationTrapFile")
        logger.flush()
/*
OLD: KE1
        logger.info("Kotlin version ${KotlinCompilerVersion.getVersion()}")
        logger.flush()
        logPeakMemoryUsage(logger, "before extractor")
        if (System.getenv("CODEQL_EXTRACTOR_JAVA_KOTLIN_DUMP") == "true") {
            logger.info("moduleFragment:\n" + moduleFragment.dump())
        }
        val compression = getCompression(logger)

        val primitiveTypeMapping = PrimitiveTypeMapping(logger, pluginContext)
        // FIXME: FileUtil expects a static global logger
        // which should be provided by SLF4J's factory facility. For now we set it here.
        FileUtil.logger = logger
*/
        val srcDir =
            File(
                System.getenv("CODEQL_EXTRACTOR_JAVA_SOURCE_ARCHIVE_DIR").takeUnless {
                    it.isNullOrEmpty()
                } ?: "kotlin-extractor/src"
            )
        srcDir.mkdirs()
/*
OLD: KE1
        val globalExtensionState = KotlinExtractorGlobalState()
*/
        doAnalysis(srcDir, loggerBase, dtw, compilation, invocationExtractionProblems, kotlinArgs)
/*
OLD: KE1
        loggerBase.printLimitedDiagnosticCounts(tw)
        logPeakMemoryUsage(logger, "after extractor")
*/
        logger.info("Extraction completed")
        logger.flush()
        val compilationTimeMs = System.currentTimeMillis() - startTimeMs
        dtw.writeCompilation_finished(
            compilation,
            -1.0,
            compilationTimeMs.toDouble() / 1000,
            invocationExtractionProblems.extractionResult()
        )
        dtw.flush()
        loggerBase.close()
    }
}

fun doAnalysis(
    srcDir : File,
    loggerBase: LoggerBase,
    dtw : DiagnosticTrapWriter,
    compilation: Label<DbCompilation>,
    invocationExtractionProblems : ExtractionProblems,
    args : List<String>
) {
    lateinit var sourceModule: KaSourceModule
    val k2args : K2JVMCompilerArguments = parseCommandLineArguments(args.toList())

    val session = buildStandaloneAnalysisAPISession {
        registerProjectService(KotlinLifetimeTokenProvider::class.java, KotlinAlwaysAccessibleLifetimeTokenProvider())

        buildKtModuleProvider {
            platform = JvmPlatforms.defaultJvmPlatform
            val sdk = addModule(
                buildKtSdkModule {
                    addBinaryRootsFromJdkHome(Paths.get(System.getProperty("java.home")), isJre = true)
                    addBinaryRootsFromJdkHome(Paths.get(System.getProperty("java.home")), isJre = false)
                    platform = JvmPlatforms.defaultJvmPlatform
                    libraryName = "JDK"
                }
            )
            sourceModule = addModule(
                buildKtSourceModule {
                    addSourceRoots(k2args.freeArgs.map { Paths.get(it) })
                    addRegularDependency(sdk)
                    platform = JvmPlatforms.defaultJvmPlatform
                    moduleName = "<source>"
                }
            )
        }
    }

    val psiFiles = session.modulesWithFiles.getValue(sourceModule)
/*
OLD: KE1
            moduleFragment.files.mapIndexed { index: Int, file: IrFile ->
*/
    var fileIndex = 0
    for (psiFile in psiFiles) {
        if (psiFile is KtFile) {
            analyze(psiFile) {
                val fileExtractionProblems = FileExtractionProblems(invocationExtractionProblems)
                val fileDiagnosticTrapWriter = dtw.makeSourceFileTrapWriter(psiFile, true)
/*
OLD: KE1
                loggerBase.setFileNumber(fileIndex)
*/
                fileDiagnosticTrapWriter.writeCompilation_compiling_files(
                    compilation,
                    fileIndex,
                    fileDiagnosticTrapWriter.fileId
                )
                doFile(
/*
OLD: KE1
                    compression,
                    fileExtractionProblems,
                    invocationTrapFile,
*/
                    fileDiagnosticTrapWriter,
                    loggerBase,
/*
OLD: KE1
                    checkTrapIdentical,
                    trapDir,
*/
                    srcDir,
                    psiFile,
/*
OLD: KE1
                    primitiveTypeMapping,
                    pluginContext,
                    globalExtensionState
*/
                )
                fileDiagnosticTrapWriter.writeCompilation_compiling_files_completed(
                    compilation,
                    fileIndex,
                    fileExtractionProblems.extractionResult()
                )
            }
            fileIndex += 1
        } else {
            System.out.println("Warning: Not a KtFile")
        }
    }
}

context (KaSession)
fun dumpFunction(f: KtFunction) {
    val block = f.getBodyExpression() as KtBlockExpression
    for (p: KtExpression in block.getStatements()) {
        if (p is KtProperty) {
            dumpProperty(p)
        }
    }
}

context (KaSession)
fun dumpProperty(p: KtProperty) {
    println("Got property ${p.name}")
    val i = p.getInitializer()!!
    val t = i.expressionType!!
    println("  Location: ${location(i)}")
    println("  Initializer type $t (${t.javaClass})")
    if (i is KtCallExpression) {
        println("  Call info: ${i.resolveToCall()}")
    }
}

fun location(e: KtElement): String {
    val range = e.getTextRange()
    val document = e.getContainingFile().getViewProvider().getDocument()
    val start = showOffset(document, range.getStartOffset(), 1)
    val end = showOffset(document, range.getEndOffset(), 0)
    return "$start-$end"
}

fun showOffset(document: Document, o: Int, colFudge: Int): String {
    val line = document.getLineNumber(o)
    val column = o - document.getLineStartOffset(line)
    return "${line + 1}:${column + colFudge}"
}

/*
OLD: KE1
import com.github.codeql.utils.versions.usesK2
import java.io.BufferedInputStream
import java.io.BufferedOutputStream
import java.io.BufferedReader
import java.io.BufferedWriter
import java.io.File
import java.io.FileInputStream
import java.io.InputStreamReader
import java.io.OutputStreamWriter
import java.lang.management.*
import java.util.zip.GZIPInputStream
import java.util.zip.GZIPOutputStream
import kotlin.system.exitProcess
import org.jetbrains.kotlin.backend.common.extensions.IrGenerationExtension
import org.jetbrains.kotlin.backend.common.extensions.IrPluginContext
import org.jetbrains.kotlin.config.KotlinCompilerVersion
import org.jetbrains.kotlin.ir.declarations.*
import org.jetbrains.kotlin.ir.util.*

class KotlinExtractorExtension(
    // The filepath for the invocation TRAP file.
    // This TRAP file is for this invocation of the extractor as a
    // whole, not tied to a particular source file. It contains
    // information about which files this invocation compiled, and
    // any warnings or errors encountered during the invocation.
    private val invocationTrapFile: String,
    // By default, if a TRAP file we want to generate for a source
    // file already exists, then we will do nothing. If this is set,
    // then we will instead generate the TRAP file, and give a
    // warning if we would generate different TRAP to that which
    // already exists.
    private val checkTrapIdentical: Boolean,
    // If non-null, then this is the number of milliseconds since
    // midnight, January 1, 1970 UTC (as returned by Java's
    // `System.currentTimeMillis()`. If this is given, then it is used
    // to record the time taken to compile the source code, which is
    // presumed to be the difference between this time and the time
    // that this plugin is invoked.
    private val compilationStartTime: Long?,
    // Under normal conditions, the extractor runs during a build of
    // the project, and kotlinc continues after the plugin has finished.
    // If the plugin is being used independently of a build, then this
    // can be set to true to make the plugin terminate the kotlinc
    // invocation when it has finished. This means that kotlinc will not
    // write any `.class` files etc.
    private val exitAfterExtraction: Boolean
) : IrGenerationExtension {

    private fun getCompression(logger: Logger): Compression {
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

    private fun logPeakMemoryUsage(logger: Logger, time: String) {
        logger.info("Peak memory: Usage $time")

        val beans = ManagementFactory.getMemoryPoolMXBeans()
        var heap: Long = 0
        var nonheap: Long = 0
        for (bean in beans) {
            val peak = bean.getPeakUsage().getUsed()
            val kind =
                when (bean.getType()) {
                    MemoryType.HEAP -> {
                        heap += peak
                        "heap"
                    }
                    MemoryType.NON_HEAP -> {
                        nonheap += peak
                        "non-heap"
                    }
                    else -> "unknown"
                }
            logger.info("Peak memory: * Peak for $kind bean ${bean.getName()} is $peak")
        }
        logger.info("Peak memory: * Total heap peak: $heap")
        logger.info("Peak memory: * Total non-heap peak: $nonheap")
    }
}

class KotlinExtractorGlobalState {
    // These three record mappings of classes, functions and fields that should be replaced wherever
    // they are found.
    // As of now these are only used to fix IR generated by the Gradle Android Extensions plugin,
    // hence e.g. IrProperty
    // doesn't have a map as that plugin doesn't generate them. If and when these are used more
    // widely additional maps
    // should be added here.
    val syntheticToRealClassMap = HashMap<IrClass, IrClass?>()
    val syntheticToRealFunctionMap = HashMap<IrFunction, IrFunction?>()
    val syntheticToRealFieldMap = HashMap<IrField, IrField?>()
    val syntheticRepeatableAnnotationContainers = HashMap<IrClass, IrClass>()
}
*/

/*
The `ExtractionProblems` class is used to record whether this invocation
had any problems. It distinguish 2 kinds of problem:
* Recoverable problems: e.g. if we check something that we expect to be
  non-null and find that it is null.
* Non-recoverable problems: if we catch an exception.
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
        if (nonRecoverableProblem) {
            return 2
        } else if (recoverableProblem) {
            return 1
        } else {
            return 0
        }
    }
}

/*
The `FileExtractionProblems` is analogous to `ExtractionProblems`,
except it records whether there were any problems while extracting a
particular source file.
*/
class FileExtractionProblems(val invocationExtractionProblems: ExtractionProblems) :
    ExtractionProblems() {
    override fun setRecoverableProblem() {
        super.setRecoverableProblem()
        invocationExtractionProblems.setRecoverableProblem()
    }

    override fun setNonRecoverableProblem() {
        super.setNonRecoverableProblem()
        invocationExtractionProblems.setNonRecoverableProblem()
    }
}

/*
OLD: KE1
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
*/

context (KaSession)
private fun doFile(
/*
OLD: KE1
    compression: Compression,
    fileExtractionProblems: FileExtractionProblems,
    invocationTrapFile: String,
*/
    fileDiagnosticTrapWriter: FileTrapWriter,
    loggerBase: LoggerBase,
/*
OLD: KE1
    checkTrapIdentical: Boolean,
    dbTrapDir: File,
*/
    dbSrcDir: File,
    srcFile: KtFile,
/*
OLD: KE1
    primitiveTypeMapping: PrimitiveTypeMapping,
    pluginContext: IrPluginContext,
    globalExtensionState: KotlinExtractorGlobalState
*/
) {
    // TODO: Testing
    val c = srcFile.getDeclarations()[0]
    if (c is KtClass) {
        for (d: KtDeclaration in c.getDeclarations()) {
            if (d is KtFunction) {
                if (d.name == "f") {
                    dumpFunction(d)
                }
            }
        }
    }

    val srcFilePath = srcFile.virtualFilePath
    val logger = FileLogger(loggerBase, fileDiagnosticTrapWriter)
    logger.info("Extracting file $srcFilePath")
    logger.flush()

/*
OLD: KE1
    val context = logger.loggerBase.extractorContextStack
    if (!context.empty()) {
        logger.warn("Extractor context was not empty. It thought:")
        context.clear()
    }
*/

    val srcFileRelativePath = PathTransformer.std().fileAsDatabaseString(File(srcFilePath))

    val dbSrcFilePath =  FileUtil.appendAbsolutePath(dbSrcDir, srcFileRelativePath).toPath()
    val dbSrcDirPath = dbSrcFilePath.parent
    Files.createDirectories(dbSrcDirPath)
    val srcTmpFile =
        File.createTempFile(
            dbSrcFilePath.fileName.toString() + ".",
            ".src.tmp",
            dbSrcDirPath.toFile()
        )
    srcTmpFile.outputStream().use { Files.copy(Paths.get(srcFilePath), it) }
    srcTmpFile.renameTo(dbSrcFilePath.toFile())

/*
OLD: KE1
    val trapFileName = FileUtil.appendAbsolutePath(dbTrapDir, "$srcFileRelativePath.trap").getAbsolutePath()
    val trapFileWriter = getTrapFileWriter(compression, logger, trapFileName)

    if (checkTrapIdentical || !trapFileWriter.exists()) {
        trapFileWriter.makeParentDirectory()

        try {
            trapFileWriter.getTempWriter().use { trapFileBW ->
                // We want our comments to be the first thing in the file,
                // so start off with a mere TrapWriter
                val tw =
                    PlainTrapWriter(
                        loggerBase,
                        TrapLabelManager(),
                        trapFileBW,
                        fileTrapWriter.getDiagnosticTrapWriter()
                    )
                tw.writeComment("Generated by the CodeQL Kotlin extractor for kotlin source code")
                tw.writeComment("Part of invocation $invocationTrapFile")
                // Now elevate to a SourceFileTrapWriter, and populate the
                // file information
                val sftw = tw.makeSourceFileTrapWriter(srcFile, true)
                val externalDeclExtractor =
                    ExternalDeclExtractor(
                        logger,
                        compression,
                        invocationTrapFile,
                        srcFilePath,
                        primitiveTypeMapping,
                        pluginContext,
                        globalExtensionState,
                        fileTrapWriter.getDiagnosticTrapWriter()
                    )
                val linesOfCode = LinesOfCode(logger, sftw, srcFile)
                val fileExtractor =
                    KotlinFileExtractor(
                        logger,
                        sftw,
                        linesOfCode,
                        srcFilePath,
                        null,
                        externalDeclExtractor,
                        primitiveTypeMapping,
                        pluginContext,
                        KotlinFileExtractor.DeclarationStack(),
                        globalExtensionState
                    )

                fileExtractor.extractFileContents(srcFile, sftw.fileId)
                externalDeclExtractor.extractExternalClasses()
            }

            if (checkTrapIdentical && trapFileWriter.exists()) {
                if (
                    equivalentTrap(trapFileWriter.getTempReader(), trapFileWriter.getRealReader())
                ) {
                    trapFileWriter.deleteTemp()
                } else {
                    trapFileWriter.renameTempToDifferent()
                }
            } else {
                trapFileWriter.renameTempToReal()
            }
            // We catch Throwable rather than Exception, as we want to
            // continue trying to extract everything else even if we get a
            // stack overflow or an assertion failure in one file.
        } catch (e: Throwable) {
            logger.error("Failed to extract '$srcFilePath'. " + trapFileWriter.debugInfo(), e)
            context.clear()
            fileExtractionProblems.setNonRecoverableProblem()
        }
    }
*/
}

/*
OLD: KE1
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

private fun getTrapFileWriter(
    compression: Compression,
    logger: FileLogger,
    trapFileName: String
): TrapFileWriter {
    return when (compression) {
        Compression.NONE -> NonCompressedTrapFileWriter(logger, trapFileName)
        Compression.GZIP -> GZipCompressedTrapFileWriter(logger, trapFileName)
    }
}

private abstract class TrapFileWriter(
    val logger: FileLogger,
    trapName: String,
    val extension: String
) {
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
}

private class NonCompressedTrapFileWriter(logger: FileLogger, trapName: String) :
    TrapFileWriter(logger, trapName, "") {
    override protected fun getReader(file: File): BufferedReader {
        return file.bufferedReader()
    }

    override protected fun getWriter(file: File): BufferedWriter {
        return file.bufferedWriter()
    }
}

private class GZipCompressedTrapFileWriter(logger: FileLogger, trapName: String) :
    TrapFileWriter(logger, trapName, ".gz") {
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
*/
