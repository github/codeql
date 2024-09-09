package com.github.codeql

import com.intellij.openapi.editor.Document
import com.intellij.psi.impl.DebugUtil
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
*/
        val compression = getCompression(logger)

/*
OLD: KE1
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
        doAnalysis(compression, trapDir, srcDir, loggerBase, dtw, compilation, invocationExtractionProblems, kotlinArgs)
        loggerBase.printLimitedDiagnosticCounts(dtw)
/*
OLD: KE1
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
    compression : Compression,
    trapDir : File,
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

    val checkTrapIdentical = false // TODO

    val psiFiles = session.modulesWithFiles.getValue(sourceModule)
/*
OLD: KE1
            moduleFragment.files.mapIndexed { index: Int, file: IrFile ->
*/
    var fileNumber = 0
    val dump_psi = System.getenv("CODEQL_EXTRACTOR_JAVA_KOTLIN_DUMP") == "true"
    for (psiFile in psiFiles) {
        if (psiFile is KtFile) {
            analyze(psiFile) {
                if (dump_psi) {
                    val showWhitespaces = false
                    val showRanges = true
                    loggerBase.info(dtw, DebugUtil.psiToString(psiFile, showWhitespaces, showRanges))
                }
                val fileExtractionProblems = FileExtractionProblems(invocationExtractionProblems)
                try {
                    val fileDiagnosticTrapWriter = dtw.makeSourceFileTrapWriter(psiFile, true)
                    fileDiagnosticTrapWriter.writeCompilation_compiling_files(
                        compilation,
                        fileNumber,
                        fileDiagnosticTrapWriter.fileId
                    )
                    doFile(
                        fileNumber,
                        compression,
/*
OLD: KE1
                    fileExtractionProblems,
                    invocationTrapFile,
*/
                        fileDiagnosticTrapWriter,
                        loggerBase,
                        checkTrapIdentical,
                        trapDir,
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
                        fileNumber,
                        fileExtractionProblems.extractionResult()
                    )
                // We catch Throwable rather than Exception, as we want to
                // continue trying to extract everything else even if we get a
                // stack overflow or an assertion failure in one file.
                } catch (e: Throwable) {
/*
OLD: KE1
                    logger.error("Extraction failed while extracting '${psiFile.virtualFilePath}'.", e)
                    fileExtractionProblems.setNonRecoverableProblem()
*/
                }
            }
            fileNumber += 1
        } else {
            System.out.println("Warning: Not a KtFile")
        }
    }
}

context (KaSession)
fun dumpFunction(f: KtFunction) {
    println("=== Have function")
    println(f)
    println(f.parent)
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

context (KaSession)
private fun doFile(
    fileNumber: Int,
    compression: Compression,
/*
OLD: KE1
    fileExtractionProblems: FileExtractionProblems,
    invocationTrapFile: String,
*/
    fileDiagnosticTrapWriter: FileTrapWriter,
    loggerBase: LoggerBase,
    checkTrapIdentical: Boolean,
    dbTrapDir: File,
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
    if (c is KtFunction) {
        if (c.name == "test") {
            dumpFunction(c)
        }
    }

    val srcFilePath = srcFile.virtualFilePath
    val logger = FileLogger(loggerBase, fileDiagnosticTrapWriter, fileNumber)
    logger.info("Extracting file $srcFilePath")
    logger.flush()

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

    val trapFileName = FileUtil.appendAbsolutePath(dbTrapDir, "$srcFileRelativePath.trap").getAbsolutePath()
    val trapFileWriter = getTrapFileWriter(compression, logger, checkTrapIdentical, trapFileName)

    trapFileWriter.run { trapFileBW ->
        // We want our comments to be the first thing in the file,
        // so start off with a PlainTrapWriter
        val tw =
            PlainTrapWriter(
                logger,
                TrapLabelManager(),
                trapFileBW,
                fileDiagnosticTrapWriter.getDiagnosticTrapWriter()
            )
        tw.writeComment("Generated by the CodeQL Kotlin extractor for kotlin source code")
/*
OLD: KE1
        tw.writeComment("Part of invocation $invocationTrapFile")
*/
        // Now elevate to a SourceFileTrapWriter, and populate the
        // file information
        val sftw = tw.makeSourceFileTrapWriter(srcFile, true)
/*
OLD: KE1
        val externalDeclExtractor =
            ExternalDeclExtractor(
                logger,
                compression,
                invocationTrapFile,
                srcFilePath,
                primitiveTypeMapping,
                pluginContext,
                globalExtensionState,
                fileDiagnosticTrapWriter.getDiagnosticTrapWriter()
            )
        val linesOfCode = LinesOfCode(logger, sftw, srcFile)
*/
        val fileExtractor =
            KotlinFileExtractor(
                logger,
                sftw,
/*
OLD: KE1
                linesOfCode,
                srcFilePath,
                null,
                externalDeclExtractor,
                primitiveTypeMapping,
                pluginContext,
                KotlinFileExtractor.DeclarationStack(),
                globalExtensionState
*/
            )

        fileExtractor.extractFileContents(srcFile, sftw.fileId)
/*
OLD: KE1
        externalDeclExtractor.extractExternalClasses()
*/
    }
}
