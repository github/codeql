package com.github.codeql

import java.io.File
import java.io.FileWriter
import java.io.OutputStreamWriter
import java.io.Writer
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Stack
import org.jetbrains.kotlin.ir.IrElement

class LogCounter() {
    public val diagnosticInfo = mutableMapOf<String, Pair<Severity, Int>>()
    public val diagnosticLimit: Int

    init {
        diagnosticLimit =
            System.getenv("CODEQL_EXTRACTOR_KOTLIN_DIAGNOSTIC_LIMIT")?.toIntOrNull() ?: 100
    }
}

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

class LogMessage(private val kind: String, private val message: String) {
    val timestamp: String

    init {
        timestamp = "${SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(Date())}"
    }

    fun toText(): String {
        return "[$timestamp K] [$kind] $message"
    }

    private fun escape(str: String): String {
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
            kvs.map { p -> "\"${p.first}\": \"${escape(p.second)}\"" }.joinToString(", ") +
            " }\n"
    }
}

data class ExtractorContext(
    val kind: String,
    val element: IrElement,
    val name: String,
    val loc: String
)

open class LoggerBase(val logCounter: LogCounter) {
    val extractorContextStack = Stack<ExtractorContext>()

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

    private var file_number = -1
    private var file_number_diagnostic_number = 0

    fun setFileNumber(index: Int) {
        file_number = index
        file_number_diagnostic_number = 0
    }

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
                val oldInfo =
                    logCounter.diagnosticInfo.getOrDefault(diagnosticLoc, Pair(severity, 0))
                if (severity != oldInfo.first) {
                    // We don't want to get in a loop, so just emit this
                    // directly without going through the diagnostic
                    // counting machinery
                    if (verbosity >= 1) {
                        val message =
                            "Severity mismatch ($severity vs ${oldInfo.first}) at $diagnosticLoc"
                        emitDiagnostic(dtw, Severity.Error, "Inconsistency", message, message)
                    }
                }
                val newCount = oldInfo.second + 1
                val newInfo = Pair(severity, newCount)
                logCounter.diagnosticInfo[diagnosticLoc] = newInfo
                when {
                    logCounter.diagnosticLimit <= 0 -> ""
                    newCount == logCounter.diagnosticLimit ->
                        "    Limit reached for diagnostics from $diagnosticLoc.\n"
                    newCount > logCounter.diagnosticLimit -> return
                    else -> ""
                }
            }
        val fullMsgBuilder = StringBuilder()
        fullMsgBuilder.append(msg)
        if (extraInfo != null) {
            fullMsgBuilder.append('\n')
            fullMsgBuilder.append(extraInfo)
        }

        val iter = extractorContextStack.listIterator(extractorContextStack.size)
        while (iter.hasPrevious()) {
            val x = iter.previous()
            fullMsgBuilder.append("  ...while extracting a ${x.kind} (${x.name}) at ${x.loc}\n")
        }
        fullMsgBuilder.append(suffix)

        val fullMsg = fullMsgBuilder.toString()
        emitDiagnostic(dtw, severity, diagnosticLocStr, msg, fullMsg, locationString, mkLocationId)
    }

    private fun emitDiagnostic(
        dtw: DiagnosticTrapWriter,
        severity: Severity,
        diagnosticLocStr: String,
        msg: String,
        fullMsg: String,
        locationString: String? = null,
        mkLocationId: () -> Label<DbLocation> = { dtw.unknownLocation }
    ) {
        val locStr = if (locationString == null) "" else "At " + locationString + ": "
        val kind = if (severity <= Severity.WarnHigh) "WARN" else "ERROR"
        val logMessage = LogMessage(kind, "Diagnostic($diagnosticLocStr): $locStr$fullMsg")
        // We don't actually make the location until after the `return` above
        val locationId = mkLocationId()
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
        dtw.writeDiagnostic_for(
            diagLabel,
            StringLabel("compilation"),
            file_number,
            file_number_diagnostic_number++
        )
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

    fun infoVerbosity(dtw: DiagnosticTrapWriter) {
        info(dtw, "Kotlin extractor verbosity is " + verbosity.toString())
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

    fun printLimitedDiagnosticCounts(dtw: DiagnosticTrapWriter) {
        for ((caller, info) in logCounter.diagnosticInfo) {
            val severity = info.first
            val count = info.second
            if (count >= logCounter.diagnosticLimit) {
                val message =
                    "Total of $count diagnostics (reached limit of ${logCounter.diagnosticLimit}) from $caller."
                if (verbosity >= 1) {
                    emitDiagnostic(dtw, severity, "Limit", message, message)
                }
            }
        }
    }

    fun flush() {
        logStream.flush()
    }

    fun close() {
        logStream.close()
    }
}

open class Logger(val loggerBase: LoggerBase, val dtw: DiagnosticTrapWriter) {
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

    fun infoVerbosity() {
        loggerBase.infoVerbosity(dtw)
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

    fun errorElement(msg: String, element: IrElement, exn: Throwable? = null) {
        val locationString = ftw.getLocationString(element)
        val mkLocationId = { ftw.getLocation(element) }
        loggerBase.diagnostic(
            ftw.getDiagnosticTrapWriter(),
            Severity.Error,
            msg,
            exn?.stackTraceToString(),
            locationString,
            mkLocationId
        )
    }
}
