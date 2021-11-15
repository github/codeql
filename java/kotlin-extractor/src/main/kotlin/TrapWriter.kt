package com.github.codeql

import com.github.codeql.utils.versions.FileEntry
import java.io.BufferedWriter
import java.io.File
import org.jetbrains.kotlin.ir.IrElement
import org.jetbrains.kotlin.ir.declarations.path
import org.jetbrains.kotlin.ir.declarations.IrFile
import org.jetbrains.kotlin.ir.declarations.IrVariable

import com.semmle.extractor.java.PopulateFile

class TrapLabelManager {
    public var nextId: Int = 100

    fun <T> getFreshLabel(): Label<T> {
        return IntLabel(nextId++)
    }

    val labelMapping: MutableMap<String, Label<*>> = mutableMapOf<String, Label<*>>()
}

open class TrapWriter (val lm: TrapLabelManager, val bw: BufferedWriter) {
    fun <T> getExistingLabelFor(label: String): Label<T>? {
        @Suppress("UNCHECKED_CAST")
        return lm.labelMapping.get(label) as Label<T>?
    }
    @JvmOverloads
    fun <T> getLabelFor(label: String, initialise: (Label<T>) -> Unit = {}): Label<T> {
        val maybeId: Label<T>? = getExistingLabelFor(label)
        if(maybeId == null) {
            val id: Label<T> = lm.getFreshLabel()
            lm.labelMapping.put(label, id)
            writeTrap("$id = $label\n")
            initialise(id)
            return id
        } else {
            return maybeId
        }
    }
    val variableLabelMapping: MutableMap<IrVariable, Label<out DbLocalvar>> = mutableMapOf<IrVariable, Label<out DbLocalvar>>()
    fun <T> getVariableLabelFor(v: IrVariable): Label<out DbLocalvar> {
        val maybeId = variableLabelMapping.get(v)
        if(maybeId == null) {
            val id = lm.getFreshLabel<DbLocalvar>()
            variableLabelMapping.put(v, id)
            writeTrap("$id = *\n")
            return id
        } else {
            return maybeId
        }
    }

    fun getLocation(fileId: Label<DbFile>, startLine: Int, startColumn: Int, endLine: Int, endColumn: Int): Label<DbLocation> {
        return getLabelFor("@\"loc,{$fileId},$startLine,$startColumn,$endLine,$endColumn\"") {
            writeLocations_default(it, fileId, startLine, startColumn, endLine, endColumn)
        }
    }

    protected val unknownFileId: Label<DbFile> by lazy {
        val unknownFileLabel = "@\";sourcefile\""
        getLabelFor(unknownFileLabel, {
            writeFiles(it, "")
        })
    }

    val unknownLocation: Label<DbLocation> by lazy {
        getLocation(unknownFileId, 0, 0, 0, 0)
    }

    fun writeTrap(trap: String) {
        bw.write(trap)
    }
    fun writeComment(comment: String) {
        writeTrap("// ${comment.replace("\n", "\n//    ")}\n")
    }
    fun flush() {
        bw.flush()
    }

    /**
     * Gets a FileTrapWriter like this one (using the same label manager, writer etc), but with the given
     * default file used in getLocation etc.
     */
    fun withTargetFile(filePath: String, fileEntry: FileEntry?, populateFileTables: Boolean = true) =
        FileTrapWriter(lm, bw, filePath, fileEntry, populateFileTables)
}

class SourceFileTrapWriter (
    lm: TrapLabelManager,
    bw: BufferedWriter,
    irFile: IrFile) :
    FileTrapWriter(lm, bw, irFile.path, irFile.fileEntry) {
}

class ClassFileTrapWriter (
    lm: TrapLabelManager,
    bw: BufferedWriter,
    filePath: String) :
    FileTrapWriter(lm, bw, filePath, null) {
}

open class FileTrapWriter (
    lm: TrapLabelManager,
    bw: BufferedWriter,
    val filePath: String,
    val sourceFileEntry: FileEntry?,
    populateFileTables: Boolean = true
): TrapWriter (lm, bw) {
    val populateFile = PopulateFile(this)
    val splitFilePath = filePath.split("!/")
    @Suppress("UNCHECKED_CAST")
    val fileId =
        (if(splitFilePath.size == 1)
            populateFile.getFileLabel(File(filePath), populateFileTables)
         else
            populateFile.getFileInJarLabel(File(splitFilePath.get(0)), splitFilePath.get(1), populateFileTables)
        ) as Label<DbFile>

    fun getLocation(e: IrElement): Label<DbLocation> {
        return getLocation(e.startOffset, e.endOffset)
    }
    fun getWholeFileLocation(): Label<DbLocation> {
        return getLocation(fileId, 0, 0, 0, 0)
    }
    fun getLocation(startOffset: Int, endOffset: Int): Label<DbLocation> {
        // If the compiler doesn't have a location, then start and end are both -1
        // If this isn't a source file (sourceFileEntry is null), then nothing has
        // a source location: we report the source .class file regardless.
        if((startOffset == -1 && endOffset == -1) || sourceFileEntry == null) {
            val reportFileId = if (sourceFileEntry == null) fileId else unknownFileId
            return getLocation(reportFileId, 0, 0, 0, 0)
        } else {
            // If this is the location for a compiler-generated element, then it will
            // be a zero-width location. QL doesn't support these, so we translate it
            // into a one-width location.
            val endColumnOffset = if (startOffset == endOffset) 1 else 0
            return getLocation(
                fileId,
                sourceFileEntry.getLineNumber(startOffset) + 1,
                sourceFileEntry.getColumnNumber(startOffset) + 1,
                sourceFileEntry.getLineNumber(endOffset) + 1,
                sourceFileEntry.getColumnNumber(endOffset) + endColumnOffset
            )
        }
    }
    fun getLocationString(e: IrElement): String {
        if ((e.startOffset == -1 && e.endOffset == -1) || sourceFileEntry == null) {
            return "unknown location, while processing $filePath"
        } else {
            val startLine =   sourceFileEntry.getLineNumber(e.startOffset) + 1
            val startColumn = sourceFileEntry.getColumnNumber(e.startOffset) + 1
            val endLine =     sourceFileEntry.getLineNumber(e.endOffset) + 1
            val endColumn =   sourceFileEntry.getColumnNumber(e.endOffset)
            return "file://$filePath:$startLine:$startColumn:$endLine:$endColumn"
        }
    }
    fun <T> getFreshIdLabel(): Label<T> {
        val label = IntLabel<T>(lm.nextId++)
        writeTrap("$label = *\n")
        return label
    }
}
