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
import org.jetbrains.kotlin.ir.declarations.IrDeclarationParent
import org.jetbrains.kotlin.ir.declarations.IrFile
import org.jetbrains.kotlin.ir.declarations.IrFunction
import org.jetbrains.kotlin.ir.declarations.IrValueParameter
import org.jetbrains.kotlin.ir.util.dump
import org.jetbrains.kotlin.ir.util.packageFqName
import org.jetbrains.kotlin.ir.visitors.IrElementVisitor
import org.jetbrains.kotlin.ir.IrFileEntry
import org.jetbrains.kotlin.ir.types.IrType
import org.jetbrains.kotlin.ir.types.IrSimpleType
import org.jetbrains.kotlin.ir.expressions.IrBody
import org.jetbrains.kotlin.ir.expressions.IrBlockBody
import org.jetbrains.kotlin.ir.expressions.IrReturn
import org.jetbrains.kotlin.ir.expressions.IrExpression
import org.jetbrains.kotlin.ir.expressions.IrCall
import org.jetbrains.kotlin.ir.expressions.IrGetValue
import org.jetbrains.kotlin.ir.expressions.IrConst
import org.jetbrains.kotlin.ir.IrStatement

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
    fun getLocation(startOffset: Int, endOffset: Int): Label<DbLocation> {
        val startLine = fileEntry.getLineNumber(startOffset) + 1
        val startColumn = fileEntry.getColumnNumber(startOffset) + 1
        val endLine = fileEntry.getLineNumber(endOffset) + 1
        val endColumn = fileEntry.getColumnNumber(endOffset)
        val id: Label<DbLocation> = getFreshLabel()
        val fileId: Label<DbFile> = getLabelFor(fileLabel)
        writeTrap("$id = @\"loc,{$fileId},$startLine,$startColumn,$endLine,$endColumn\"\n")
        writeLocations_default(id, fileId, startLine, startColumn, endLine, endColumn)
        return id
    }
    val labelMapping: MutableMap<String, Label<*>> = mutableMapOf<String, Label<*>>()
    fun <T> getLabelFor(label: String, initialise: (Label<T>) -> Unit = {}): Label<T> {
        val maybeId = labelMapping.get(label)
        if(maybeId == null) {
            val id: Label<T> = getFreshLabel()
            labelMapping.put(label, id)
            writeTrap("$id = $label\n")
            initialise(id)
            return id
        } else {
            @Suppress("UNCHECKED_CAST")
            return maybeId as Label<T>
        }
    }
    fun <T> getFreshLabel(): Label<T> {
        return Label(nextId++)
    }
    fun <T> getFreshIdLabel(): Label<T> {
        val label = Label<T>(nextId++)
        writeTrap("$label = *\n")
        return label
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
        val id: Label<DbFile> = tw.getLabelFor(fileLabel)
        tw.writeFiles(id, filePath, basename, extension, 0)
        val fileExtractor = KotlinFileExtractor(tw)
        val pkg = declaration.fqName.asString()
        val pkgId = fileExtractor.extractPackage(pkg)
        tw.writeCupackage(id, pkgId)
        declaration.declarations.map { fileExtractor.extractDeclaration(it, pkgId) }
    }
}

class KotlinFileExtractor(val tw: TrapWriter) {
    fun usePackage(pkg: String): Label<out DbPackage> {
        return extractPackage(pkg)
    }

    fun extractPackage(pkg: String): Label<out DbPackage> {
        val pkgLabel = "@\"package;$pkg\""
        val id: Label<DbPackage> = tw.getLabelFor(pkgLabel, {
            tw.writePackages(it, pkg)
        })
        return id
    }

    fun extractDeclaration(declaration: IrDeclaration, parentid: Label<out DbPackage_or_reftype>) {
        when (declaration) {
            is IrClass -> extractClass(declaration)
            is IrFunction -> extractFunction(declaration, parentid)
            else -> extractorBug("Unrecognised IrDeclaration: " + declaration.javaClass)
        }
    }

    @Suppress("UNUSED_PARAMETER")
    fun useSimpleType(c: IrSimpleType): Label<out DbPrimitive> {
        // TODO: This shouldn't assume all SimpleType's are Int
        val label = "@\"type;int\""
        val id: Label<DbPrimitive> = tw.getLabelFor(label, {
            tw.writePrimitives(it, "int")
        })
        return id
    }

    fun useClass(c: IrClass): Label<out DbClass> {
        val pkg = c.packageFqName?.asString() ?: ""
        val cls = c.name.asString()
        val qualClassName = if (pkg.isEmpty()) cls else "$pkg.$cls"
        val label = "@\"class;$qualClassName\""
        val id: Label<DbClass> = tw.getLabelFor(label)
        return id
    }

    fun extractClass(c: IrClass) {
        val id = useClass(c)
        val locId = tw.getLocation(c.startOffset, c.endOffset)
        val pkg = c.packageFqName?.asString() ?: ""
        val cls = c.name.asString()
        val pkgId = extractPackage(pkg)
        tw.writeClasses(id, cls, pkgId, id)
        tw.writeHasLocation(id, locId)
        c.declarations.map { extractDeclaration(it, id) }
    }

    fun useType(t: IrType): Label<out DbType> {
        when(t) {
            is IrSimpleType -> return useSimpleType(t)
            is IrClass -> return useClass(t)
            else -> {
                extractorBug("Unrecognised IrType: " + t.javaClass)
                return Label(0)
            }
        }
    }

    fun useDeclarationParent(dp: IrDeclarationParent): Label<out DbPackage_or_reftype> {
        when(dp) {
            is IrFile -> return usePackage(dp.fqName.asString())
            is IrClass -> return useClass(dp)
            else -> {
                extractorBug("Unrecognised IrDeclarationParent: " + dp.javaClass)
                return Label(0)
            }
        }
    }

    fun useFunction(f: IrFunction): Label<out DbMethod> {
        val paramTypeIds = f.valueParameters.joinToString() { "{${useType(it.type).toString()}}" }
        val returnTypeId = useType(f.returnType)
        val parentId = useDeclarationParent(f.parent)
        val label = "@\"callable;{$parentId}.${f.name.asString()}($paramTypeIds){$returnTypeId}\""
        val id: Label<DbMethod> = tw.getLabelFor(label)
        return id
    }

    fun extractFunction(f: IrFunction, parentid: Label<out DbPackage_or_reftype>) {
        val id = useFunction(f)
        val locId = tw.getLocation(f.startOffset, f.endOffset)
        val signature = "TODO"
        val returnTypeId = useType(f.returnType)
        tw.writeMethods(id, f.name.asString(), signature, returnTypeId, parentid, id)
        tw.writeHasLocation(id, locId)
        val body = f.body
        if(body != null) {
            extractBody(body, id)
        }
    }

    fun extractBody(b: IrBody, callable: Label<out DbCallable>) {
        when(b) {
            is IrBlockBody -> extractBlockBody(b, callable, callable, 0)
            else -> extractorBug("Unrecognised IrBody: " + b.javaClass)
        }
    }

    fun extractBlockBody(b: IrBlockBody, callable: Label<out DbCallable>, parent: Label<out DbStmtparent>, idx: Int) {
        val id = tw.getFreshIdLabel<DbBlock>()
        val locId = tw.getLocation(b.startOffset, b.endOffset)
        val kind = 0 // TODO: stmt kind for block from generated module
        tw.writeStmts(id, kind, parent, idx, callable)
        tw.writeHasLocation(id, locId)
        for((sIdx, stmt) in b.statements.withIndex()) {
            extractStatement(stmt, callable, id, sIdx)
        }
    }

    fun extractStatement(s: IrStatement, callable: Label<out DbCallable>, parent: Label<out DbStmtparent>, idx: Int) {
        when(s) {
            is IrReturn -> {
                val id = tw.getFreshIdLabel<DbReturnstmt>()
                val locId = tw.getLocation(s.startOffset, s.endOffset)
                val kind = 9 // TODO: stmt kind for return from generated module
                tw.writeStmts(id, kind, parent, idx, callable)
                tw.writeHasLocation(id, locId)
                extractExpression(s.value, id, 0)
            }
        }
    }

    fun extractExpression(e: IrExpression, parent: Label<out DbExprparent>, idx: Int) {
        when(e) {
            is IrCall -> {
                // TODO: This shouldn't assume all IrCalls's are addexpr's
                if(e.valueArgumentsCount == 1) {
                    val left = e.dispatchReceiver
                    val right = e.getValueArgument(0)
                    if(left != null && right != null) {
                        val kind = 27 // TODO: expr kind for addexpr from generated module
                        val id = tw.getFreshIdLabel<DbAddexpr>()
                        val typeId = useType(e.type)
                        val locId = tw.getLocation(e.startOffset, e.endOffset)
                        tw.writeExprs(id, kind, typeId, parent, idx)
                        tw.writeHasLocation(id, locId)
                        extractExpression(left, id, 0)
                        extractExpression(right, id, 1)
                    } else {
                        extractorBug("Unrecognised IrCall: left or right is null")
                    }
                } else {
                    extractorBug("Unrecognised IrCall: Not binary")
                }
            }
            is IrConst<*> -> {
                val v = e.value as Int
                val kind = 17 // TODO: expr kind for integerliteral from generated module
                val id = tw.getFreshIdLabel<DbIntegerliteral>()
                val typeId = useType(e.type)
                val locId = tw.getLocation(e.startOffset, e.endOffset)
                tw.writeExprs(id, kind, typeId, parent, idx)
                tw.writeHasLocation(id, locId)
                tw.writeNamestrings(v.toString(), v.toString(), id)
            }
            else -> {
                extractorBug("Unrecognised IrExpression: " + e.javaClass)
            }
        }
    }
}

