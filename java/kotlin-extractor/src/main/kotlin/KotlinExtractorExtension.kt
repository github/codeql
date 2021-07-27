package com.github.codeql

import java.io.BufferedWriter
import java.io.File
import java.nio.file.Files
import java.nio.file.Paths
import kotlin.system.exitProcess
import org.jetbrains.kotlin.backend.common.extensions.IrGenerationExtension
import org.jetbrains.kotlin.backend.common.extensions.IrPluginContext
import org.jetbrains.kotlin.ir.IrElement
import org.jetbrains.kotlin.ir.declarations.IrModuleFragment
import org.jetbrains.kotlin.ir.declarations.IrClass
import org.jetbrains.kotlin.ir.declarations.IrFile
import org.jetbrains.kotlin.ir.declarations.path
import org.jetbrains.kotlin.ir.util.dump
import org.jetbrains.kotlin.ir.util.packageFqName
import org.jetbrains.kotlin.ir.visitors.IrElementVisitor
import org.jetbrains.kotlin.ir.IrFileEntry

class KotlinExtractorExtension(private val tests: List<String>) : IrGenerationExtension {
    override fun generate(moduleFragment: IrModuleFragment, pluginContext: IrPluginContext) {
        val trapDir = File(System.getenv("CODEQL_EXTRACTOR_JAVA_TRAP_DIR").takeUnless { it.isNullOrEmpty() } ?: "kotlin-extractor/trap")
        trapDir.mkdirs()
        val srcDir = File(System.getenv("CODEQL_EXTRACTOR_JAVA_SOURCE_ARCHIVE_DIR").takeUnless { it.isNullOrEmpty() } ?: "kotlin-extractor/src")
        srcDir.mkdirs()
        moduleFragment.accept(KotlinExtractorVisitor(trapDir, srcDir), RootTrapWriter())
        // We don't want the compiler to continue and generate class
        // files etc, so we just exit when we are finished extracting.
        exitProcess(0)
    }
}

fun extractorBug(msg: String) {
    println(msg)
}

interface TrapWriter {
    fun writeTrap(trap: String)
    fun getLocation(startOffset: Int, endOffset: Int): Int
    fun getIdFor(label: String): Int
    fun getFreshId(): Int
}

class RootTrapWriter: TrapWriter {
    override fun writeTrap(trap: String) {
        extractorBug("Tried to write TRAP outside a file: $trap")
    }
    override fun getLocation(startOffset: Int, endOffset: Int): Int {
        extractorBug("Asked for location, but not in a file")
        return 0
    }
    override fun getIdFor(label: String): Int {
        extractorBug("Asked for ID for '$label' outside a file")
        return 0
    }
    override fun getFreshId(): Int {
        extractorBug("Asked for fresh ID outside a file")
        return 0
    }
}

class FileTrapWriter(
    val fileLabel: String,
    val file: BufferedWriter,
    val fileEntry: IrFileEntry
): TrapWriter {
    var nextId: Int = 100
    override fun writeTrap(trap: String) {
        file.write(trap)
    }
    override fun getLocation(startOffset: Int, endOffset: Int): Int {
        val startLine = fileEntry.getLineNumber(startOffset) + 1
        val startColumn = fileEntry.getColumnNumber(startOffset) + 1
        val endLine = fileEntry.getLineNumber(endOffset) + 1
        val endColumn = fileEntry.getColumnNumber(endOffset)
        val id = getFreshId()
        val fileId = getIdFor(fileLabel)
        writeTrap("#$id = @\"loc,{#$fileId},$startLine,$startColumn,$endLine,$endColumn\"\n")
        writeTrap("locations_default(#$id, #$fileId, $startLine, $startColumn, $endLine, $endColumn)\n")
        return id
    }
    val labelMapping: MutableMap<String, Int> = mutableMapOf<String, Int>()
    override fun getIdFor(label: String): Int {
        val maybeId = labelMapping.get(label)
        if(maybeId == null) {
            val id = getFreshId()
            labelMapping.put(label, id)
            return id
        } else {
            return maybeId
        }
    }
    override fun getFreshId(): Int {
        return nextId++
    }
}

class KotlinExtractorVisitor(val trapDir: File, val srcDir: File) : IrElementVisitor<Unit, TrapWriter> {
    override fun visitElement(element: IrElement, data: TrapWriter) {
        extractorBug("Unrecognised IrElement: " + element.javaClass)
        if(data is RootTrapWriter) {
            extractorBug("... and outside any file!")
        }
        element.acceptChildren(this, data)
    }
    override fun visitClass(declaration: IrClass, data: TrapWriter) {
        val id = data.getFreshId()
        val pkgId = data.getFreshId()
        val locId = data.getLocation(declaration.startOffset, declaration.endOffset)
        val pkg = declaration.packageFqName?.asString() ?: ""
        val cls = declaration.name.asString()
        data.writeTrap("#$pkgId = @\"pkg;$pkg\"\n")
        data.writeTrap("packages(#$pkgId, \"$pkg\")\n")
        data.writeTrap("#$id = @\"class;$pkg.$cls\"\n")
        data.writeTrap("classes(#$id, \"$cls\", #$pkgId, #$id)\n")
        data.writeTrap("hasLocation(#$id, #$locId)\n")
        declaration.acceptChildren(this, data)
    }
    override fun visitFile(declaration: IrFile, data: TrapWriter) {
        val filePath = declaration.path
        val file = File(filePath)
        val fileLabel = "@\"$filePath;sourcefile\""
        val basename = file.nameWithoutExtension
        val extension = file.extension
        val dest = Paths.get("$srcDir/${declaration.path}")
        val destDir = dest.getParent()
        Files.createDirectories(destDir)
        Files.copy(Paths.get(declaration.path), dest)

        val trapFile = File("$trapDir/$filePath.trap")
        val trapFileDir = trapFile.getParentFile()
        trapFileDir.mkdirs()
        trapFile.bufferedWriter().use { trapFileBW ->
            val tw = FileTrapWriter(fileLabel, trapFileBW, declaration.fileEntry)
            val id = tw.getIdFor(fileLabel)
            tw.writeTrap("#$id = $fileLabel\n")
            tw.writeTrap("files(#$id, \"$filePath\", \"$basename\", \"$extension\", 0)\n")
            declaration.acceptChildren(this, tw)
        }
    }
}

