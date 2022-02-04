package com.github.codeql

import java.text.SimpleDateFormat
import java.util.Date
import org.jetbrains.kotlin.ir.IrElement

class LogCounter() {
    public val diagnosticCounts = mutableMapOf<String, Int>()
    public val diagnosticLimit: Int
    init {
        diagnosticLimit = System.getenv("CODEQL_EXTRACTOR_KOTLIN_DIAGNOSTIC_LIMIT")?.toIntOrNull() ?: 100
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

open class Logger(val logCounter: LogCounter, open val tw: TrapWriter) {
    private fun timestamp(): String {
        return "[${SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(Date())} K]"
    }

    private fun getDiagnosticLocation(): String? {
        val st = Exception().stackTrace
        for(x in st) {
            when(x.className) {
                "com.github.codeql.Logger",
                "com.github.codeql.FileLogger" -> {}
                else -> {
                    return x.toString()
                }
            }
        }
        return null
    }

    fun flush() {
        tw.flush()
        System.out.flush()
    }

    fun diagnostic(severity: Severity, msg: String, extraInfo: String?, locationString: String? = null, mkLocationId: () -> Label<DbLocation> = { tw.unknownLocation }) {
        val diagnosticLoc = getDiagnosticLocation()
        val diagnosticLocStr = if(diagnosticLoc == null) "<unknown location>" else diagnosticLoc
        val extraInfoStr = if (extraInfo == null) "" else (extraInfo + "\n")
        val suffix =
            if(diagnosticLoc == null) {
                "    Missing caller information.\n"
            } else {
                val count = logCounter.diagnosticCounts.getOrDefault(diagnosticLoc, 0) + 1
                logCounter.diagnosticCounts[diagnosticLoc] = count
                when {
                    logCounter.diagnosticLimit <= 0 -> ""
                    count == logCounter.diagnosticLimit -> "    Limit reached for diagnostics from $diagnosticLoc.\n"
                    count > logCounter.diagnosticLimit -> return
                    else -> ""
                }
            }
        val fullMsg = "$msg\n$extraInfoStr$suffix"
        val ts = timestamp()
        // We don't actually make the location until after the `return` above
        val locationId = mkLocationId()
        tw.writeDiagnostics(StarLabel(), "CodeQL Kotlin extractor", severity.sev, "", msg, "$ts $fullMsg", locationId)
        val locStr = if (locationString == null) "" else "At " + locationString + ": "
        print("$ts Diagnostic($diagnosticLocStr): $locStr$fullMsg")
    }

    fun info(msg: String) {
        val fullMsg = "${timestamp()} $msg"
        tw.writeComment(fullMsg)
        println(fullMsg)
    }
    fun trace(msg: String) {
        if(false) {
            info(msg)
        }
    }
    fun debug(msg: String) {
        info(msg)
    }
    fun trace(msg: String, exn: Exception) {
        trace(msg + "\n" + exn.stackTraceToString())
    }
    fun warn(msg: String, exn: Exception) {
        warn(msg, exn.stackTraceToString())
    }
    fun warn(msg: String, extraInfo: String?) {
        diagnostic(Severity.Warn, msg, extraInfo)
    }
    fun warn(msg: String) {
        warn(msg, null)
    }
    fun error(msg: String, extraInfo: String?) {
        diagnostic(Severity.Error, msg, extraInfo)
    }
    fun error(msg: String) {
        error(msg, null)
    }
    fun error(msg: String, exn: Exception) {
        error(msg, exn.stackTraceToString())
    }
    fun printLimitedDiagnosticCounts() {
        for((caller, count) in logCounter.diagnosticCounts) {
            if(count >= logCounter.diagnosticLimit) {
                val msg = "Total of $count diagnostics from $caller.\n"
                tw.writeComment(msg)
                print(msg)
            }
        }
    }
}

class FileLogger(logCounter: LogCounter, override val tw: FileTrapWriter): Logger(logCounter, tw) {
    private fun timestamp(): String {
        return "[${SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(Date())} K]"
    }

    fun warnElement(msg: String, element: IrElement) {
        val locationString = tw.getLocationString(element)
        val mkLocationId = { tw.getLocation(element) }
        diagnostic(Severity.Warn, msg, null, locationString, mkLocationId)
    }

    fun errorElement(msg: String, element: IrElement) {
        val locationString = tw.getLocationString(element)
        val mkLocationId = { tw.getLocation(element) }
        diagnostic(Severity.Error, msg, null, locationString, mkLocationId)
    }
}
