package com.github.codeql

import java.text.SimpleDateFormat
import java.util.Date
import org.jetbrains.kotlin.ir.IrElement

class LogCounter() {
    public val warningCounts = mutableMapOf<String, Int>()
    public val warningLimit: Int
    init {
        warningLimit = System.getenv("CODEQL_EXTRACTOR_KOTLIN_WARNING_LIMIT")?.toIntOrNull() ?: 100
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

    fun flush() {
        tw.flush()
        System.out.flush()
    }
    fun info(msg: String) {
        val fullMsg = "${timestamp()} $msg"
        tw.writeTrap("// " + fullMsg.replace("\n", "\n//") + "\n")
        println(fullMsg)
    }
    fun warn(severity: Severity, msg: String, locationString: String? = null, locationId: Label<DbLocation> = tw.unknownLocation, stackIndex: Int = 2) {
        val st = Exception().stackTrace
        val suffix =
            if(st.size < stackIndex + 1) {
                "    Missing caller information.\n"
            } else {
                val caller = st[stackIndex].toString()
                val count = logCounter.warningCounts.getOrDefault(caller, 0) + 1
                logCounter.warningCounts[caller] = count
                when {
                    logCounter.warningLimit <= 0 -> ""
                    count == logCounter.warningLimit -> "    Limit reached for warnings from $caller.\n"
                    count > logCounter.warningLimit -> return
                    else -> ""
                }
            }
        val ts = timestamp()
        tw.writeDiagnostics(StarLabel(), severity.sev, "", msg, "$ts $msg\n$suffix", locationId)
        val locStr = if (locationString == null) "" else "At " + locationString + ": "
        print("$ts Warning: $locStr$msg\n$suffix")
    }
    fun printLimitedWarningCounts() {
        for((caller, count) in logCounter.warningCounts) {
            if(count >= logCounter.warningLimit) {
                val msg = "Total of $count warnings from $caller.\n"
                tw.writeTrap("// $msg")
                print(msg)
            }
        }
    }
}

class FileLogger(logCounter: LogCounter, override val tw: FileTrapWriter): Logger(logCounter, tw) {
    private fun timestamp(): String {
        return "[${SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(Date())} K]"
    }

    fun warnElement(severity: Severity, msg: String, element: IrElement, stackIndex: Int = 3) {
        val locationString = tw.getLocationString(element)
        val locationId = tw.getLocation(element)
        warn(severity, msg, locationString, locationId, stackIndex)
    }
}
