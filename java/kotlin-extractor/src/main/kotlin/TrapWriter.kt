package com.github.codeql

import java.io.BufferedWriter
import java.io.File
import org.jetbrains.kotlin.ir.IrElement
import org.jetbrains.kotlin.ir.IrFileEntry
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

abstract class SourceOffsetResolver {
    abstract fun getLineNumber(offset: Int): Int
    abstract fun getColumnNumber(offset: Int): Int
}

class FileSourceOffsetResolver(val fileEntry: IrFileEntry) : SourceOffsetResolver() {
    override fun getLineNumber(offset: Int) = fileEntry.getLineNumber(offset)
    override fun getColumnNumber(offset: Int) = fileEntry.getLineNumber(offset)
}

object NullSourceOffsetResolver : SourceOffsetResolver() {
    override fun getLineNumber(offset: Int) = 0
    override fun getColumnNumber(offset: Int) = 0
}

class SourceFileTrapWriter (
    lm: TrapLabelManager,
    bw: BufferedWriter,
    irFile: IrFile) :
    FileTrapWriter(lm, bw, irFile.path, FileSourceOffsetResolver(irFile.fileEntry)) {
}

class ClassFileTrapWriter (
    lm: TrapLabelManager,
    bw: BufferedWriter,
    filePath: String) :
    FileTrapWriter(lm, bw, filePath, NullSourceOffsetResolver) {
}

open class FileTrapWriter (
    lm: TrapLabelManager,
    bw: BufferedWriter,
    val filePath: String,
    val sourceOffsetResolver: SourceOffsetResolver
): TrapWriter (lm, bw) {
    val populateFile = PopulateFile(this)
    val splitFilePath = filePath.split("!/")
    val fileId =
        (if(splitFilePath.size == 1)
            populateFile.populateFile(File(filePath))
         else
            populateFile.relativeFileId(File(splitFilePath.get(0)), splitFilePath.get(1))
        ) as Label<DbFile>

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
        val startLine =   if(unknownLoc) 0 else sourceOffsetResolver.getLineNumber(startOffset) + 1
        val startColumn = if(unknownLoc) 0 else sourceOffsetResolver.getColumnNumber(startOffset) + 1
        val endLine =     if(unknownLoc) 0 else sourceOffsetResolver.getLineNumber(endOffset) + 1
        val endColumn =   if(unknownLoc) 0 else sourceOffsetResolver.getColumnNumber(endOffset)
        val endColumn2 =  if(zeroWidthLoc) endColumn + 1 else endColumn
        val locFileId: Label<DbFile> = if (unknownLoc) unknownFileId else fileId
        return getLocation(locFileId, startLine, startColumn, endLine, endColumn2)
    }
    fun getLocationString(e: IrElement): String {
        if (e.startOffset == -1 && e.endOffset == -1) {
            return "unknown location, while processing $filePath"
        } else {
            val startLine =   sourceOffsetResolver.getLineNumber(e.startOffset) + 1
            val startColumn = sourceOffsetResolver.getColumnNumber(e.startOffset) + 1
            val endLine =     sourceOffsetResolver.getLineNumber(e.endOffset) + 1
            val endColumn =   sourceOffsetResolver.getColumnNumber(e.endOffset)
            return "file://$filePath:$startLine:$startColumn:$endLine:$endColumn"
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
