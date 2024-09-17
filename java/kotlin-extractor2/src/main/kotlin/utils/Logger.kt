package com.github.codeql

import com.intellij.psi.PsiElement
import java.io.File
import java.io.FileWriter
import java.io.OutputStreamWriter
import java.io.Writer
import java.text.SimpleDateFormat
import java.util.Date
/*
OLD: KE1
import java.util.Stack
import org.jetbrains.kotlin.ir.IrElement
*/

/**
 * Counts the number of times each diagnostic message (based on the
 * location of the diagnostic from the stack trace, and its severity)
 * has been emitted.
 */
class DiagnosticCounter() {
    public val diagnosticInfo = mutableMapOf<Pair<String, Severity>, Int>()
    public val diagnosticLimit: Int

    init {
        diagnosticLimit =
            System.getenv("CODEQL_EXTRACTOR_KOTLIN_DIAGNOSTIC_LIMIT")?.toIntOrNull() ?: 100
    }
}

/**
 * The severity of a diagnostic message.
 */
enum class Severity(val sev: Int) {
    WarnLow(1),
    Warn(2),
    WarnHigh(3),
    /** Minor extractor errors, with minimal impact on analysis. */
    ErrorLow(4),
    /** Most extractor errors, with local impact on analysis. */
    Error(5),
    /** Javac errors. */
    ErrorHigh(6),
    /** Severe extractor errors affecting a single source file. */
    ErrorSevere(7),
    /** Severe extractor errors likely to affect multiple source files. */
    ErrorGlobal(8)
}

/**
 * Given a log message, this wrapper class adds info like a timestamp,
 * and formats it for the different output targets.
 */
class LogMessage(private val kind: String, private val message: String) {
    val timestamp: String

    init {
        timestamp = "${SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(Date())}"
    }

    fun toText(): String {
        return "[$timestamp K] [$kind] $message"
    }

    private fun escapeForJson(str: String): String {
        return str.replace("\\", "\\\\")
            .replace("\"", "\\\"")
            .replace("\u0000", "\\u0000")
            .replace("\u0001", "\\u0001")
            .replace("\u0002", "\\u0002")
            .replace("\u0003", "\\u0003")
            .replace("\u0004", "\\u0004")
            .replace("\u0005", "\\u0005")
            .replace("\u0006", "\\u0006")
            .replace("\u0007", "\\u0007")
            .replace("\u0008", "\\b")
            .replace("\u0009", "\\t")
            .replace("\u000A", "\\n")
            .replace("\u000B", "\\u000B")
            .replace("\u000C", "\\f")
            .replace("\u000D", "\\r")
            .replace("\u000E", "\\u000E")
            .replace("\u000F", "\\u000F")
    }

    fun toJsonLine(): String {
        val kvs =
            listOf(
                Pair("origin", "CodeQL Kotlin extractor"),
                Pair("timestamp", timestamp),
                Pair("kind", kind),
                Pair("message", message)
            )
        return "{ " +
            kvs.map { p -> "\"${p.first}\": \"${escapeForJson(p.second)}\"" }.joinToString(", ") +
            " }\n"
    }
}

/*
OLD: KE1
data class ExtractorContext(
    val kind: String,
    val element: IrElement,
    val name: String,
    val loc: String
)
*/

/**
 * LoggerBase actually writes log messages to a log file, and to
 * the DiagnosticTrapWriter that it is passed.
 * It is only usde directly from the DiagnosticTrapWriter. Everything
 * else will use a Logger that wraps it (and the DiagnosticTrapWriter).
 */
open class LoggerBase(val diagnosticCounter: DiagnosticCounter) {
    private val verbosity: Int

    init {
        verbosity = System.getenv("CODEQL_EXTRACTOR_KOTLIN_VERBOSITY")?.toIntOrNull() ?: 3
    }

    private val logStream: Writer

    init {
        val extractorLogDir = System.getenv("CODEQL_EXTRACTOR_JAVA_LOG_DIR")
        if (extractorLogDir == null || extractorLogDir == "") {
            logStream = OutputStreamWriter(System.out)
        } else {
            val logFile = File.createTempFile("kotlin-extractor.", ".log", File(extractorLogDir))
            logStream = FileWriter(logFile)
        }
    }

    private fun getDiagnosticLocation(): String? {
        val st = Exception().stackTrace
        for (x in st) {
            when (x.className) {
                "com.github.codeql.LoggerBase",
                "com.github.codeql.Logger",
                "com.github.codeql.FileLogger" -> {}
                else -> {
                    return x.toString()
                }
            }
        }
        return null
    }

/*
OLD: KE1
    private var file_number = -1
    private var file_number_diagnostic_number = 0

    fun setFileNumber(index: Int) {
        file_number = index
        file_number_diagnostic_number = 0
    }
*/

    fun diagnostic(
        dtw: DiagnosticTrapWriter,
        severity: Severity,
        msg: String,
        extraInfo: String?,
        locationString: String? = null,
        mkLocationId: () -> Label<DbLocation> = { dtw.unknownLocation }
    ) {
        val diagnosticLoc = getDiagnosticLocation()
        val diagnosticLocStr = if (diagnosticLoc == null) "<unknown location>" else diagnosticLoc
        val suffix =
            if (diagnosticLoc == null) {
                "    Missing caller information.\n"
            } else {
                val key = Pair(diagnosticLoc, severity)
                val count = 1 + diagnosticCounter.diagnosticInfo.getOrDefault(key, 0)
                diagnosticCounter.diagnosticInfo[key] = count
                when {
                    diagnosticCounter.diagnosticLimit <= 0 -> ""
                    count == diagnosticCounter.diagnosticLimit ->
                        "    Limit reached for diagnostics from $diagnosticLoc.\n"
                    count > diagnosticCounter.diagnosticLimit -> return
                    else -> ""
                }
            }
        val fullMsgBuilder = StringBuilder()
        fullMsgBuilder.append(msg)
        if (extraInfo != null) {
            fullMsgBuilder.append('\n')
            fullMsgBuilder.append(extraInfo)
        }

/*
OLD: KE1
        val iter = extractorContextStack.listIterator(extractorContextStack.size)
        while (iter.hasPrevious()) {
            val x = iter.previous()
            fullMsgBuilder.append("  ...while extracting a ${x.kind} (${x.name}) at ${x.loc}\n")
        }
*/
        fullMsgBuilder.append(suffix)

        val fullMsg = fullMsgBuilder.toString()
        // Now that we have passed the early returns above, we know that
        // we're actually going to need the location, so let's create it
        val locationId = mkLocationId()
        emitDiagnostic(dtw, severity, diagnosticLocStr, msg, fullMsg, locationString, locationId)
    }

    private fun emitDiagnostic(
        dtw: DiagnosticTrapWriter,
        severity: Severity,
        diagnosticLocStr: String,
        msg: String,
        fullMsg: String,
        locationString: String? = null,
        locationId: Label<DbLocation>
    ) {
        val locStr = if (locationString == null) "" else "At " + locationString + ": "
        val kind = if (severity <= Severity.WarnHigh) "WARN" else "ERROR"
        val logMessage = LogMessage(kind, "Diagnostic($diagnosticLocStr): $locStr$fullMsg")
        val diagLabel = dtw.getFreshIdLabel<DbDiagnostic>()
        dtw.writeDiagnostics(
            diagLabel,
            "CodeQL Kotlin extractor",
            severity.sev,
            "",
            msg,
            "${logMessage.timestamp} $fullMsg",
            locationId
        )
/*
OLD: KE1
        dtw.writeDiagnostic_for(
            diagLabel,
            StringLabel("compilation"),
            file_number,
            file_number_diagnostic_number++
        )
*/
        logStream.write(logMessage.toJsonLine())
    }

    fun trace(dtw: DiagnosticTrapWriter, msg: String) {
        if (verbosity >= 4) {
            val logMessage = LogMessage("TRACE", msg)
            dtw.writeComment(logMessage.toText())
            logStream.write(logMessage.toJsonLine())
        }
    }

    fun debug(dtw: DiagnosticTrapWriter, msg: String) {
        if (verbosity >= 4) {
            val logMessage = LogMessage("DEBUG", msg)
            dtw.writeComment(logMessage.toText())
            logStream.write(logMessage.toJsonLine())
        }
    }

    fun info(dtw: DiagnosticTrapWriter, msg: String) {
        if (verbosity >= 3) {
            val logMessage = LogMessage("INFO", msg)
            dtw.writeComment(logMessage.toText())
            logStream.write(logMessage.toJsonLine())
        }
    }

    fun warn(dtw: DiagnosticTrapWriter, msg: String, extraInfo: String?) {
        if (verbosity >= 2) {
            diagnostic(dtw, Severity.Warn, msg, extraInfo)
        }
    }

    fun error(dtw: DiagnosticTrapWriter, msg: String, extraInfo: String?) {
        if (verbosity >= 1) {
            diagnostic(dtw, Severity.Error, msg, extraInfo)
        }
    }

/*
OLD: KE1
    fun printLimitedDiagnosticCounts(dtw: DiagnosticTrapWriter) {
        for ((caller, info) in diagnosticCounter.diagnosticInfo) {
            val severity = info.first
            val count = info.second
            if (count >= diagnosticCounter.diagnosticLimit) {
                val message =
                    "Total of $count diagnostics (reached limit of ${diagnosticCounter.diagnosticLimit}) from $caller."
                if (verbosity >= 1) {
                    emitDiagnostic(dtw, severity, "Limit", message, message, null, dtw.unknownLocation)
                }
            }
        }
    }
*/

    fun flush() {
        logStream.flush()
    }

    fun close() {
        logStream.close()
    }
}

/**
 * Logger is the high-level interface for writint log messages.
 */
open class Logger(val loggerBase: LoggerBase, val dtw: DiagnosticTrapWriter) {
/*
OLD: KE1
    val extractorContextStack = Stack<ExtractorContext>()
*/

    fun flush() {
        dtw.flush()
        loggerBase.flush()
    }

    fun trace(msg: String) {
        loggerBase.trace(dtw, msg)
    }

    fun trace(msg: String, exn: Throwable) {
        trace(msg + "\n" + exn.stackTraceToString())
    }

    fun debug(msg: String) {
        loggerBase.debug(dtw, msg)
    }

    fun info(msg: String) {
        loggerBase.info(dtw, msg)
    }

    private fun warn(msg: String, extraInfo: String?) {
        loggerBase.warn(dtw, msg, extraInfo)
    }

    fun warn(msg: String, exn: Throwable) {
        warn(msg, exn.stackTraceToString())
    }

    fun warn(msg: String) {
        warn(msg, null)
    }

    private fun error(msg: String, extraInfo: String?) {
        loggerBase.error(dtw, msg, extraInfo)
    }

    fun error(msg: String) {
        error(msg, null)
    }

    fun error(msg: String, exn: Throwable) {
        error(msg, exn.stackTraceToString())
    }
}

class FileLogger(loggerBase: LoggerBase, val ftw: FileTrapWriter) :
    Logger(loggerBase, ftw.getDiagnosticTrapWriter()) {
/*
OLD: KE1
    fun warnElement(msg: String, element: IrElement, exn: Throwable? = null) {
        val locationString = ftw.getLocationString(element)
        val mkLocationId = { ftw.getLocation(element) }
        loggerBase.diagnostic(
            ftw.getDiagnosticTrapWriter(),
            Severity.Warn,
            msg,
            exn?.stackTraceToString(),
            locationString,
            mkLocationId
        )
    }
*/

    fun errorElement(msg: String, element: PsiElement /* TODO , exn: Throwable? = null */) {
        val locationString = ftw.getLocationString(element)
        val mkLocationId = { ftw.getLocation(element) }
        loggerBase.diagnostic(
            ftw.getDiagnosticTrapWriter(),
            Severity.Error,
            msg,
            null, // OLD: KE1: exn?.stackTraceToString(),
            locationString,
            mkLocationId
        )
    }
}
