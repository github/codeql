package com.github.codeql

import com.github.codeql.utils.versions.FileEntry
import java.io.BufferedWriter
import java.io.File
import org.jetbrains.kotlin.ir.IrElement
import org.jetbrains.kotlin.ir.declarations.path
import org.jetbrains.kotlin.ir.declarations.IrFile
import org.jetbrains.kotlin.ir.declarations.IrVariable
import org.jetbrains.kotlin.ir.UNDEFINED_OFFSET
import org.jetbrains.kotlin.ir.util.SYNTHETIC_OFFSET

import com.semmle.extractor.java.PopulateFile

/**
 * Each `.trap` file has a `TrapLabelManager` while we are writing it.
 * It provides fresh TRAP label names, and maintains a mapping from keys
 * (`@"..."`) to labels.
 */
class TrapLabelManager {
    /** The next integer to use as a label name. */
    private var nextInt: Int = 100

    /** Returns a fresh label. */
    fun <T> getFreshLabel(): Label<T> {
        return IntLabel(nextInt++)
    }

    /**
     * A mapping from a key (`@"..."`) to the label defined to be that
     * key, if any.
     */
    val labelMapping: MutableMap<String, Label<*>> = mutableMapOf<String, Label<*>>()
}

/**
 * A `TrapWriter` is used to write TRAP to a particular TRAP file.
 * There may be multiple `TrapWriter`s for the same file, as different
 * instances will have different additional state, but they must all
 * share the same `TrapLabelManager` and `BufferedWriter`.
 */
open class TrapWriter (protected val lm: TrapLabelManager, private val bw: BufferedWriter) {
    /**
     * Returns the label that is defined to be the given key, if such
     * a label exists, and `null` otherwise. Most users will want to use
     * `getLabelFor` instead, which allows non-existent labels to be
     * initialised.
     */
    fun <T> getExistingLabelFor(key: String): Label<T>? {
        @Suppress("UNCHECKED_CAST")
        return lm.labelMapping.get(key) as Label<T>?
    }
    /**
     * Returns the label for the given key, if one exists.
     * Otherwise, a fresh label is bound to that key, `initialise`
     * is run on it, and it is returned.
     */
    @JvmOverloads // Needed so Java can call a method with an optional argument
    fun <T> getLabelFor(key: String, initialise: (Label<T>) -> Unit = {}): Label<T> {
        val maybeLabel: Label<T>? = getExistingLabelFor(key)
        if(maybeLabel == null) {
            val label: Label<T> = lm.getFreshLabel()
            lm.labelMapping.put(key, label)
            writeTrap("$label = $key\n")
            initialise(label)
            return label
        } else {
            return maybeLabel
        }
    }

    fun <T> getFreshIdLabel(): Label<T> {
        val label: Label<T> = lm.getFreshLabel()
        writeTrap("$label = *\n")
        return label
    }

    /**
     * It is not easy to assign keys to local variables, so they get
     * given `*` IDs. However, the same variable may be referred to
     * from distant places in the IR, so we need a way to find out
     * which label is used for a given local variable. This information
     * is stored in this mapping.
     */
    private val variableLabelMapping: MutableMap<IrVariable, Label<out DbLocalvar>> = mutableMapOf<IrVariable, Label<out DbLocalvar>>()
    /**
     * This returns the label used for a local variable, creating one
     * if none currently exists.
     */
    fun <T> getVariableLabelFor(v: IrVariable): Label<out DbLocalvar> {
        val maybeLabel = variableLabelMapping.get(v)
        if(maybeLabel == null) {
            val label = lm.getFreshLabel<DbLocalvar>()
            variableLabelMapping.put(v, label)
            writeTrap("$label = *\n")
            return label
        } else {
            return maybeLabel
        }
    }

    /**
     * This returns a label for the location described by its arguments.
     * Typically users will not want to call this directly, but instead
     * use `unknownLocation`, or overloads of this defined by subclasses.
     */
    fun getLocation(fileId: Label<DbFile>, startLine: Int, startColumn: Int, endLine: Int, endColumn: Int): Label<DbLocation> {
        return getLabelFor("@\"loc,{$fileId},$startLine,$startColumn,$endLine,$endColumn\"") {
            writeLocations_default(it, fileId, startLine, startColumn, endLine, endColumn)
        }
    }

    /**
     * The label for the 'unknown' file ID.
     * Users will want to use `unknownLocation` instead.
     * This is lazy, as we don't want to define it in a TRAP file unless
     * the TRAP file actually contains something in the 'unknown' file.
     */
    protected val unknownFileId: Label<DbFile> by lazy {
        val unknownFileLabel = "@\";sourcefile\""
        getLabelFor(unknownFileLabel, {
            writeFiles(it, "")
        })
    }

    /**
     * The label for the 'unknown' location.
     * This is lazy, as we don't want to define it in a TRAP file unless
     * the TRAP file actually contains something with an 'unknown'
     * location.
     */
    val unknownLocation: Label<DbLocation> by lazy {
        getLocation(unknownFileId, 0, 0, 0, 0)
    }

    /**
     * Write a raw string into the TRAP file. Users should call one of
     * the wrapper functions instead.
     */
    fun writeTrap(trap: String) {
        bw.write(trap)
    }

    /**
     * Write a comment into the TRAP file.
     */
    fun writeComment(comment: String) {
        writeTrap("// ${comment.replace("\n", "\n//    ")}\n")
    }

    /**
     * Flush the TRAP file.
     */
    fun flush() {
        bw.flush()
    }

    /**
     * Gets a FileTrapWriter like this one (using the same label manager,
     * writer etc), but using the given `filePath` for locations.
     */
    fun makeFileTrapWriter(filePath: String, populateFileTables: Boolean) =
        FileTrapWriter(lm, bw, filePath, populateFileTables)

    /**
     * Gets a FileTrapWriter like this one (using the same label manager,
     * writer etc), but using the given `IrFile` for locations.
     */
    fun makeSourceFileTrapWriter(file: IrFile, populateFileTables: Boolean) =
        SourceFileTrapWriter(lm, bw, file, populateFileTables)
}

/**
 * A `FileTrapWriter` is used when we know which file we are extracting
 * entities from, so we can at least give the right file as a location.
 */
open class FileTrapWriter (
    lm: TrapLabelManager,
    bw: BufferedWriter,
    val filePath: String,
    populateFileTables: Boolean
): TrapWriter (lm, bw) {
    // If a file is in a jar, then the Kotlin compiler gives
    // `<jar file>!/<path within jar>` as its path. We need to split
    // it as appropriate, to make the right file ID.
    val populateFile = PopulateFile(this)
    val splitFilePath = filePath.split("!/")
    val fileId =
        if(splitFilePath.size == 1)
            populateFile.getFileLabel(File(filePath), populateFileTables)
         else
            populateFile.getFileInJarLabel(File(splitFilePath.get(0)), splitFilePath.get(1), populateFileTables)

    /**
     * Gets a label for the location of `e`.
     */
    fun getLocation(e: IrElement): Label<DbLocation> {
        return getLocation(e.startOffset, e.endOffset)
    }
    /**
     * Gets a label for the location representing the whole of this file.
     */
    fun getWholeFileLocation(): Label<DbLocation> {
        return getLocation(fileId, 0, 0, 0, 0)
    }
    /**
     * Gets a label for the location corresponding to `startOffset` and
     * `endOffset` within this file.
     */
    open fun getLocation(startOffset: Int, endOffset: Int): Label<DbLocation> {
        // We don't have a FileEntry to look up the offsets in, so all
        // we can do is return a whole-file location.
        return getWholeFileLocation()
    }
    /**
     * Gets the location of `e` as a human-readable string. Only Used by
     * the logger, in messages it produces.
     */
    open fun getLocationString(e: IrElement): String {
        // We don't have a FileEntry to look up the offsets in, so all
        // we can do is return a whole-file location. These are only
        // for human consumption, so we omit the :0:0:0:0 so that the
        // user knows where it came from.
        return "file://$filePath"
    }
}

/**
 * A `FileTrapWriter` is used when not only do we know which file we
 * are extracting entities from, but we also have an `IrFileEntry`
 * (from an `IrFile`) which allows us to map byte offsets to line
 * and column numbers.
 */
class SourceFileTrapWriter (
    lm: TrapLabelManager,
    bw: BufferedWriter,
    irFile: IrFile,
    populateFileTables: Boolean) :
    FileTrapWriter(lm, bw, irFile.path, populateFileTables) {

    private val fileEntry = irFile.fileEntry

    override fun getLocation(startOffset: Int, endOffset: Int): Label<DbLocation> {
        if (startOffset == UNDEFINED_OFFSET || endOffset == UNDEFINED_OFFSET) {
            if (startOffset != endOffset) {
                // TODO: Warn
            }
            return getWholeFileLocation()
        }

        if (startOffset == SYNTHETIC_OFFSET || endOffset == SYNTHETIC_OFFSET) {
            if (startOffset != endOffset) {
                // TODO: Warn
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
            fileEntry.getColumnNumber(endOffset) + endColumnOffset)
    }

    override fun getLocationString(e: IrElement): String {
        if (e.startOffset == UNDEFINED_OFFSET || e.endOffset == UNDEFINED_OFFSET) {
            if (e.startOffset != e.endOffset) {
                // TODO: Warn
            }
            return "<unknown location while processing $filePath>"
        }

        if (e.startOffset == SYNTHETIC_OFFSET || e.endOffset == SYNTHETIC_OFFSET) {
            if (e.startOffset != e.endOffset) {
                // TODO: Warn
            }
            return "<synthetic location while processing $filePath>"
        }

        val startLine =   fileEntry.getLineNumber(e.startOffset) + 1
        val startColumn = fileEntry.getColumnNumber(e.startOffset) + 1
        val endLine =     fileEntry.getLineNumber(e.endOffset) + 1
        val endColumn =   fileEntry.getColumnNumber(e.endOffset)
        return "file://$filePath:$startLine:$startColumn:$endLine:$endColumn"
    }
}
