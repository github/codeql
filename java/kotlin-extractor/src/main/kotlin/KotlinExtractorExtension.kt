package com.github.codeql

import java.io.BufferedWriter
import java.io.File
import java.nio.file.Files
import java.nio.file.Paths
import kotlin.system.exitProcess
import org.jetbrains.kotlin.backend.common.extensions.IrGenerationExtension
import org.jetbrains.kotlin.backend.common.extensions.IrPluginContext
import org.jetbrains.kotlin.ir.IrElement
import org.jetbrains.kotlin.ir.declarations.path
import org.jetbrains.kotlin.ir.declarations.IrModuleFragment
import org.jetbrains.kotlin.ir.declarations.IrClass
import org.jetbrains.kotlin.ir.declarations.IrDeclaration
import org.jetbrains.kotlin.ir.declarations.IrFile
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
        moduleFragment.files.map { extractFile(trapDir, srcDir, it) }
        // We don't want the compiler to continue and generate class
        // files etc, so we just exit when we are finished extracting.
        exitProcess(0)
    }
}

fun extractorBug(msg: String) {
    println(msg)
}

class TrapWriter (
    val fileLabel: String,
    val file: BufferedWriter,
    val fileEntry: IrFileEntry
) {
    var nextId: Int = 100
    fun writeTrap(trap: String) {
        file.write(trap)
    }
    fun getLocation(startOffset: Int, endOffset: Int): Label<DbLocation_default> {
        val startLine = fileEntry.getLineNumber(startOffset) + 1
        val startColumn = fileEntry.getColumnNumber(startOffset) + 1
        val endLine = fileEntry.getLineNumber(endOffset) + 1
        val endColumn = fileEntry.getColumnNumber(endOffset)
        val id: Label<DbLocation_default> = getFreshId()
        val fileId: Label<DbFile> = getIdFor(fileLabel)
        writeTrap("$id = @\"loc,{$fileId},$startLine,$startColumn,$endLine,$endColumn\"\n")
        writeLocations_default(id, fileId, startLine, startColumn, endLine, endColumn)
        return id
    }
    val labelMapping: MutableMap<String, Label<*>> = mutableMapOf<String, Label<*>>()
    fun <T> getIdFor(label: String, initialise: (Label<T>) -> Unit = {}): Label<T> {
        val maybeId = labelMapping.get(label)
        if(maybeId == null) {
            val id: Label<T> = getFreshId()
            labelMapping.put(label, id)
            writeTrap("$id = $label\n")
            initialise(id)
            return id
        } else {
            @Suppress("UNCHECKED_CAST")
            return maybeId as Label<T>
        }
    }
    fun <T> getFreshId(): Label<T> {
        return Label(nextId++)
    }
}

fun extractFile(trapDir: File, srcDir: File, declaration: IrFile) {
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
        val tw = TrapWriter(fileLabel, trapFileBW, declaration.fileEntry)
        val id: Label<DbFile> = tw.getIdFor(fileLabel)
        tw.writeFiles(id, filePath, basename, extension, 0)
        val fileExtractor = KotlinFileExtractor(tw)
        val pkg = declaration.fqName.asString()
        val pkgId = fileExtractor.extractPackage(pkg)
        tw.writeCupackage(id, pkgId)
        declaration.declarations.map { fileExtractor.extractDeclaration(it) }
    }
}

class KotlinFileExtractor(val tw: TrapWriter) {
    fun extractPackage(pkg: String): Label<DbPackage> {
        val pkgLabel = "@\"package;$pkg\""
        val id: Label<DbPackage> = tw.getIdFor(pkgLabel, {
            tw.writePackages(it, pkg)
        })
        return id
    }

    fun extractDeclaration(declaration: IrDeclaration) {
        when (declaration) {
            is IrClass -> extractClass(declaration)
            else -> extractorBug("Unrecognised IrDeclaration: " + declaration.javaClass)
        }
    }

    fun extractClass(declaration: IrClass) {
        val id: Label<DbClass> = tw.getFreshId()
        val locId = tw.getLocation(declaration.startOffset, declaration.endOffset)
        val pkg = declaration.packageFqName?.asString() ?: ""
        val cls = declaration.name.asString()
        val qualClassName = if (pkg.isEmpty()) cls else "$pkg.$cls"
        val pkgId = extractPackage(pkg)
        tw.writeTrap("$id = @\"class;$qualClassName\"\n")
        tw.writeClasses(id, cls, pkgId, id)
        tw.writeHasLocation(id, locId)
        declaration.declarations.map { extractDeclaration(it) }
    }
}

