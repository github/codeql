package com.github.codeql

import java.io.BufferedWriter
import java.io.File
import org.jetbrains.kotlin.ir.IrElement
import org.jetbrains.kotlin.ir.declarations.path
import org.jetbrains.kotlin.ir.declarations.IrFile
import org.jetbrains.kotlin.ir.declarations.IrVariable

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
    fun flush() {
        bw.flush()
    }
}

class FileTrapWriter (
    lm: TrapLabelManager,
    bw: BufferedWriter,
    val irFile: IrFile
): TrapWriter (lm, bw) {
    private val fileEntry = irFile.fileEntry
    val fileId = {
        val filePath = irFile.path
        val fileLabel = "@\"$filePath;sourcefile\""
        val id: Label<DbFile> = getLabelFor(fileLabel)
        writeFiles(id, filePath)
        id
    }()

    fun getLocation(e: IrElement): Label<DbLocation> {
        return getLocation(e.startOffset, e.endOffset)
    }
    fun getWholeFileLocation(): Label<DbLocation> {
        return getLocation(fileId, 0, 0, 0, 0)
    }
    fun getLocation(startOffset: Int, endOffset: Int): Label<DbLocation> {
        // If the compiler doesn't have a location, then start and end are both -1
        val unknownLoc = startOffset == -1 && endOffset == -1
        // If this is the location for a compiler-generated element, then it will
        // be a zero-width location. QL doesn't support these, so we translate it
        // into a one-width location.
        val zeroWidthLoc = !unknownLoc && startOffset == endOffset
        val startLine =   if(unknownLoc) 0 else fileEntry.getLineNumber(startOffset) + 1
        val startColumn = if(unknownLoc) 0 else fileEntry.getColumnNumber(startOffset) + 1
        val endLine =     if(unknownLoc) 0 else fileEntry.getLineNumber(endOffset) + 1
        val endColumn =   if(unknownLoc) 0 else fileEntry.getColumnNumber(endOffset)
        val endColumn2 =  if(zeroWidthLoc) endColumn + 1 else endColumn
        val locFileId: Label<DbFile> = if (unknownLoc) unknownFileId else fileId
        return getLocation(locFileId, startLine, startColumn, endLine, endColumn2)
    }
    fun getLocationString(e: IrElement): String {
        val path = irFile.path
        if (e.startOffset == -1 && e.endOffset == -1) {
            return "unknown location, while processing $path"
        } else {
            val startLine =   fileEntry.getLineNumber(e.startOffset) + 1
            val startColumn = fileEntry.getColumnNumber(e.startOffset) + 1
            val endLine =     fileEntry.getLineNumber(e.endOffset) + 1
            val endColumn =   fileEntry.getColumnNumber(e.endOffset)
            return "file://$path:$startLine:$startColumn:$endLine:$endColumn"
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
    fun <T> getFreshIdLabel(): Label<T> {
        val label = IntLabel<T>(lm.nextId++)
        writeTrap("$label = *\n")
        return label
    }
}
