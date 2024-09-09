package com.github.codeql

/*
OLD: KE1
import com.github.codeql.KotlinUsesExtractor.LocallyVisibleFunctionLabels
*/
import com.intellij.psi.PsiElement
import com.semmle.extractor.java.PopulateFile
import com.semmle.util.unicode.UTF8Util
import java.io.BufferedWriter
import java.io.File
/*
OLD: KE1
import org.jetbrains.kotlin.ir.IrElement
import org.jetbrains.kotlin.ir.UNDEFINED_OFFSET
import org.jetbrains.kotlin.ir.declarations.IrClass
import org.jetbrains.kotlin.ir.declarations.IrFile
import org.jetbrains.kotlin.ir.declarations.IrFunction
import org.jetbrains.kotlin.ir.declarations.IrVariable
import org.jetbrains.kotlin.ir.declarations.path
import org.jetbrains.kotlin.ir.expressions.IrCall
import org.jetbrains.kotlin.ir.util.SYNTHETIC_OFFSET
*/
import org.jetbrains.kotlin.psi.*

/**
 * Each `.trap` file has a `TrapLabelManager` while we are writing it. It provides fresh TRAP label
 * names, and maintains a mapping from keys (`@"..."`) to labels.
 */
class TrapLabelManager {
    /** The next integer to use as a label name. */
    private var nextInt: Int = 100

    /** Returns a fresh label. */
    fun <T : AnyDbType> getFreshLabel(): Label<T> {
        return IntLabel(nextInt++)
    }

    /** A mapping from a key (`@"..."`) to the label defined to be that key, if any. */
    val labelMapping: MutableMap<String, Label<*>> = mutableMapOf<String, Label<*>>()

/*
OLD: KE1
    val anonymousTypeMapping: MutableMap<IrClass, TypeResults> = mutableMapOf()

    val locallyVisibleFunctionLabelMapping: MutableMap<IrFunction, LocallyVisibleFunctionLabels> =
        mutableMapOf()

    /**
     * The set of labels of generic specialisations that we have extracted in this TRAP file. We
     * can't easily avoid duplication between TRAP files, as the labels contain references to other
     * labels, so we just accept this duplication.
     */
    val genericSpecialisationsExtracted = HashSet<String>()
*/

    /**
     * Sometimes, when we extract a file class we don't have the KtFile for it, so we are not able
     * to give it a location. This means that the location is written outside of the label creation.
     * This allows us to keep track of whether we've written the location already in this TRAP file,
     * to avoid duplication.
     */
    val fileClassLocationsExtracted = HashSet<KtFile>()
}

/**
 * A `TrapWriter` is used to write TRAP to a particular TRAP file. There may be multiple
 * `TrapWriter`s for the same file, as different instances will have different additional state, but
 * they must all share the same `TrapLabelManager` and `BufferedWriter`.
 */
abstract class TrapWriter(
    protected val basicLogger: BasicLogger,
    val lm: TrapLabelManager,
    private val bw: BufferedWriter
) {
    abstract fun getDiagnosticTrapWriter(): DiagnosticTrapWriter

/*
OLD: KE1
    /**
     * Returns the label that is defined to be the given key, if such a label exists, and `null`
     * otherwise. Most users will want to use `getLabelFor` instead, which allows non-existent
     * labels to be initialised.
     */
TODO: Inline this if it can remain private
*/
    private fun <T : AnyDbType> getExistingLabelFor(key: String): Label<T>? {
        return lm.labelMapping.get(key)?.cast<T>()
    }

    /**
     * Returns the label for the given key, if one exists. Otherwise, a fresh label is bound to that
     * key, `initialise` is run on it, and it is returned.
     */
    @JvmOverloads // Needed so Java can call a method with an optional argument
    fun <T : AnyDbType> getLabelFor(key: String, initialise: (Label<T>) -> Unit = {}): Label<T> {
        val maybeLabel: Label<T>? = getExistingLabelFor(key)
        if (maybeLabel == null) {
            val label: Label<T> = lm.getFreshLabel()
            lm.labelMapping.put(key, label)
            writeTrap("$label = $key\n")
            initialise(label)
            return label
        } else {
            return maybeLabel
        }
    }

    /** Returns a label for a fresh ID (i.e. a new label bound to `*`). */
    fun <T : AnyDbType> getFreshIdLabel(): Label<T> {
        val label: Label<T> = lm.getFreshLabel()
        writeTrap("$label = *\n")
        return label
    }

/*
OLD: KE1
    /**
     * It is not easy to assign keys to local variables, so they get given `*` IDs. However, the
     * same variable may be referred to from distant places in the IR, so we need a way to find out
     * which label is used for a given local variable. This information is stored in this mapping.
     */
    private val variableLabelMapping: MutableMap<IrVariable, Label<out DbLocalvar>> =
        mutableMapOf<IrVariable, Label<out DbLocalvar>>()
    /** This returns the label used for a local variable, creating one if none currently exists. */
    fun <T> getVariableLabelFor(v: IrVariable): Label<out DbLocalvar> {
        val maybeLabel = variableLabelMapping.get(v)
        if (maybeLabel == null) {
            val label = getFreshIdLabel<DbLocalvar>()
            variableLabelMapping.put(v, label)
            return label
        } else {
            return maybeLabel
        }
    }

    fun getExistingVariableLabelFor(v: IrVariable): Label<out DbLocalvar>? {
        return variableLabelMapping.get(v)
    }
*/

    /**
     * This returns a label for the location described by its arguments. Typically users will not
     * want to call this directly, but instead use `unknownLocation`, or overloads of this defined
     * by subclasses.
     */
    fun getLocation(
        fileId: Label<DbFile>,
        startLine: Int,
        startColumn: Int,
        endLine: Int,
        endColumn: Int
    ): Label<DbLocation> {
        return getLabelFor("@\"loc,{$fileId},$startLine,$startColumn,$endLine,$endColumn\"") {
            writeLocations_default(it, fileId, startLine, startColumn, endLine, endColumn)
        }
    }

    /**
     * The label for the 'unknown' location. This is lazy, as we don't want to define it in a TRAP
     * file unless the TRAP file actually contains something with an 'unknown' location.
     */
    val unknownLocation: Label<DbLocation> by lazy {
        val unknownFileLabel = "@\";sourcefile\""
        val unknownFileId = getLabelFor(unknownFileLabel, { writeFiles(it, "") })
        getWholeFileLocation(unknownFileId)
    }

    /**
     * Returns the label for the file `filePath`. If `populateFileTables` is true, then this also
     * adds rows to the `files` and `folders` tables for this file.
     */
    fun mkFileId(filePath: String, populateFileTables: Boolean): Label<DbFile> {
        // If a file is in a jar, then the Kotlin compiler gives
        // `<jar file>!/<path within jar>` as its path. We need to split
        // it as appropriate, to make the right file ID.
        val populateFile = PopulateFile(this)
        val splitFilePath = filePath.split("!/")
        if (splitFilePath.size == 1) {
            return populateFile.getFileLabel(File(filePath), populateFileTables)
        } else {
            return populateFile.getFileInJarLabel(
                File(splitFilePath.get(0)),
                splitFilePath.get(1),
                populateFileTables
            )
        }
    }

    /**
     * If you have an ID for a file, then this gets a label for the location representing the whole
     * of that file.
     */
    fun getWholeFileLocation(fileId: Label<DbFile>): Label<DbLocation> {
        return getLocation(fileId, 0, 0, 0, 0)
    }

    /**
     * Write a raw string into the TRAP file.
     * The only external caller of this should be the generated
     * KotlinExtractorDbScheme.kt.
     */
    fun writeTrap(trap: String) {
        bw.write(trap)
    }

    /** Write a comment into the TRAP file. */
    fun writeComment(comment: String) {
        writeTrap("// ${comment.replace("\n", "\n//    ")}\n")
    }

    /** Flush the TRAP file. */
    fun flush() {
        bw.flush()
    }

    /**
     * Escape a string so that it can be used in a TRAP string literal, i.e. with `"` escaped as
     * `""`.
     * The only external caller of this should be the generated
     * KotlinExtractorDbScheme.kt.
     */
    fun escapeTrapString(str: String) = str.replace("\"", "\"\"")

    /** TRAP string literals are limited to 1 megabyte. */
    private val MAX_STRLEN = 1.shl(20)

    /**
     * Truncate a string, if necessary, so that it can be used as a TRAP string literal. TRAP string
     * literals are limited to 1 megabyte.
     * The only external caller of this should be the generated
     * KotlinExtractorDbScheme.kt.
     */
    fun truncateString(str: String): String {
        val len = str.length
        val newLen = UTF8Util.encodablePrefixLength(str, MAX_STRLEN)
        if (newLen < len) {
            basicLogger.warn(
                this.getDiagnosticTrapWriter(),
                "Truncated string of length $len",
                "Truncated string of length $len, starting '${str.take(100)}', ending '${str.takeLast(100)}'"
            )
            return str.take(newLen)
        } else {
            return str
        }
    }

/*
OLD: KE1
    /**
     * Gets a FileTrapWriter like this one (using the same label manager, writer etc), but using the
     * given `filePath` for locations.
     */
    fun makeFileTrapWriter(filePath: String, populateFileTables: Boolean) =
        FileTrapWriter(
            basicLogger,
            lm,
            bw,
            this.getDiagnosticTrapWriter(),
            filePath,
            populateFileTables
        )

    /**
     * Gets a FileTrapWriter like this one (using the same label manager, writer etc), but using the
     * given `IrFile` for locations.
     */
*/
    fun makeSourceFileTrapWriter(file: KtFile, populateFileTables: Boolean) =
        SourceFileTrapWriter(
            basicLogger,
            lm,
            bw,
            this.getDiagnosticTrapWriter(),
            file,
            populateFileTables
        )
}

/** A `PlainTrapWriter` has no additional context of its own. */
class PlainTrapWriter(
    basicLogger: BasicLogger,
    lm: TrapLabelManager,
    bw: BufferedWriter,
    val dtw: DiagnosticTrapWriter
) : TrapWriter(basicLogger, lm, bw) {
    override fun getDiagnosticTrapWriter(): DiagnosticTrapWriter {
        return dtw
    }
}

/**
 * A `DiagnosticTrapWriter` is a TrapWriter that diagnostics can be written to; i.e. it has
 * the #compilation label defined. In practice, this means that it is a TrapWriter for the
 * invocation TRAP file.
 */
class DiagnosticTrapWriter(basicLogger: BasicLogger, lm: TrapLabelManager, bw: BufferedWriter) :
    TrapWriter(basicLogger, lm, bw) {
    override fun getDiagnosticTrapWriter(): DiagnosticTrapWriter {
        return this
    }
}

/*
OLD: KE1
/**
 * A `FileTrapWriter` is used when we know which file we are extracting entities from, so we can at
 * least give the right file as a location.
 *
 * An ID for the file will be created, and if `populateFileTables` is true then we will also add
 * rows to the `files` and `folders` tables for it.
 */
*/
open class FileTrapWriter(
    basicLogger: BasicLogger,
    lm: TrapLabelManager,
    bw: BufferedWriter,
    val dtw: DiagnosticTrapWriter,
    val filePath: String,
    populateFileTables: Boolean
) : TrapWriter(basicLogger, lm, bw) {

    /** The ID for the file that we are extracting from. */
    val fileId = mkFileId(filePath, populateFileTables)

    override fun getDiagnosticTrapWriter(): DiagnosticTrapWriter {
        return dtw
    }

/*
OLD: KE1
    private fun offsetMinOf(default: Int, vararg options: Int?): Int {
        if (default == UNDEFINED_OFFSET || default == SYNTHETIC_OFFSET) {
            return default
        }

        var currentMin = default
        for (option in options) {
            if (
                option != null &&
                    option != UNDEFINED_OFFSET &&
                    option != SYNTHETIC_OFFSET &&
                    option < currentMin
            ) {
                currentMin = option
            }
        }

        return currentMin
    }

    private fun getStartOffset(e: IrElement): Int {
        return when (e) {
            is IrCall -> {
                // Calls have incorrect startOffset, so we adjust them:
                val dr = e.dispatchReceiver?.let { getStartOffset(it) }
                val er = e.extensionReceiver?.let { getStartOffset(it) }
                offsetMinOf(e.startOffset, dr, er)
            }
            else -> e.startOffset
        }
    }

    private fun getEndOffset(e: IrElement): Int {
        return e.endOffset
    }
*/

    private data class Location(val startLine: Int, val startColumn: Int, val endLine: Int, val endColumn: Int)

    private fun getLocationInfo(e: PsiElement): Location {
        val range = e.getTextRange()
        val document = e.getContainingFile().getViewProvider().getDocument()
        val start = range.getStartOffset()
        val startLine0 = document.getLineNumber(start)
        val startCol0 = start - document.getLineStartOffset(startLine0)
        val end = range.getEndOffset()
        val endLine0 = document.getLineNumber(end)
        val endCol1 = end - document.getLineStartOffset(endLine0)
        // TODO: unknown/synthetic locations?
        return Location(startLine0 + 1, startCol0 + 1, endLine0 + 1, endCol1)
    }

    /** Gets a label for the location of `e`. */
    fun getLocation(e: PsiElement): Label<DbLocation> {
        val loc = getLocationInfo(e)
        return getLocation(fileId, loc.startLine, loc.startColumn, loc.endLine, loc.endColumn)
    }

/*
OLD: KE1
    /** Gets a label for the location of `e`. */
    fun getLocation(e: IrElement): Label<DbLocation> {
        return getLocation(getStartOffset(e), getEndOffset(e))
    }
    /**
     * Gets a label for the location corresponding to `startOffset` and `endOffset` within this
     * file.
     */
    open fun getLocation(startOffset: Int, endOffset: Int): Label<DbLocation> {
        // We don't have a FileEntry to look up the offsets in, so all
        // we can do is return a whole-file location.
        return getWholeFileLocation()
    }
*/

    /**
     * Gets the location of `e` as a human-readable string. Only used in log messages and exception
     * messages.
     */
    /* TODO open */ fun getLocationString(e: PsiElement): String {
        val loc = getLocationInfo(e)
        return "file://$filePath:${loc.startLine}:${loc.startColumn}:${loc.endLine}:${loc.endColumn}"

/*
OLD: KE1
        // We don't have a FileEntry to look up the offsets in, so all
        // we can do is return a whole-file location. We omit the
        // `:0:0:0:0` so that it is easy to distinguish from a location
        // where we have actually determined the start/end lines/columns
        // to be 0.
        return "file://$filePath"
*/
    }

    /** Gets a label for the location representing the whole of this file. */
    fun getWholeFileLocation(): Label<DbLocation> {
        return getWholeFileLocation(fileId)
    }
}

/*
OLD: KE1
/**
 * A `SourceFileTrapWriter` is used when not only do we know which file we are extracting entities
 * from, but we also have an `IrFileEntry` (from an `IrFile`) which allows us to map byte offsets to
 * line and column numbers.
 *
 * An ID for the file will be created, and if `populateFileTables` is true then we will also add
 * rows to the `files` and `folders` tables for it.
 */
*/
class SourceFileTrapWriter(
    basicLogger: BasicLogger,
    lm: TrapLabelManager,
    bw: BufferedWriter,
    dtw: DiagnosticTrapWriter,
    val ktFile: KtFile,
    populateFileTables: Boolean
) : FileTrapWriter(basicLogger, lm, bw, dtw, ktFile.virtualFilePath, populateFileTables) {
/*
OLD: KE1
    /**
     * The file entry for the file that we are extracting from. Used to map offsets to line/column
     * numbers.
     */
    private val fileEntry = irFile.fileEntry

    override fun getLocation(startOffset: Int, endOffset: Int): Label<DbLocation> {
        if (startOffset == UNDEFINED_OFFSET || endOffset == UNDEFINED_OFFSET) {
            if (startOffset != endOffset) {
                basicLogger.warn(
                    dtw,
                    "Location with inconsistent offsets (start $startOffset, end $endOffset)",
                    null
                )
            }
            return getWholeFileLocation()
        }

        if (startOffset == SYNTHETIC_OFFSET || endOffset == SYNTHETIC_OFFSET) {
            if (startOffset != endOffset) {
                basicLogger.warn(
                    dtw,
                    "Location with inconsistent offsets (start $startOffset, end $endOffset)",
                    null
                )
            }
            return getWholeFileLocation()
        }

        // If this is the location for a compiler-generated element, then it will
        // be a zero-width location. QL doesn't support these, so we translate it
        // into a one-width location.
        val endColumnOffset = if (startOffset == endOffset) 1 else 0
        return getLocation(
            fileId,
            fileEntry.getLineNumber(startOffset) + 1,
            fileEntry.getColumnNumber(startOffset) + 1,
            fileEntry.getLineNumber(endOffset) + 1,
            fileEntry.getColumnNumber(endOffset) + endColumnOffset
        )
    }

    override fun getLocationString(e: IrElement): String {
        if (e.startOffset == UNDEFINED_OFFSET || e.endOffset == UNDEFINED_OFFSET) {
            if (e.startOffset != e.endOffset) {
                basicLogger.warn(
                    dtw,
                    "Location with inconsistent offsets (start ${e.startOffset}, end ${e.endOffset})",
                    null
                )
            }
            return "<unknown location while processing $filePath>"
        }

        if (e.startOffset == SYNTHETIC_OFFSET || e.endOffset == SYNTHETIC_OFFSET) {
            if (e.startOffset != e.endOffset) {
                basicLogger.warn(
                    dtw,
                    "Location with inconsistent offsets (start ${e.startOffset}, end ${e.endOffset})",
                    null
                )
            }
            return "<synthetic location while processing $filePath>"
        }

        val startLine = fileEntry.getLineNumber(e.startOffset) + 1
        val startColumn = fileEntry.getColumnNumber(e.startOffset) + 1
        val endLine = fileEntry.getLineNumber(e.endOffset) + 1
        val endColumn = fileEntry.getColumnNumber(e.endOffset)
        return "file://$filePath:$startLine:$startColumn:$endLine:$endColumn"
    }
*/
}
