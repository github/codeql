package com.github.codeql

import java.io.BufferedWriter
import java.io.File
import java.nio.file.Files
import java.nio.file.Paths
import kotlin.system.exitProcess
import org.jetbrains.kotlin.backend.common.extensions.IrGenerationExtension
import org.jetbrains.kotlin.backend.common.extensions.IrPluginContext
import org.jetbrains.kotlin.ir.IrElement
import org.jetbrains.kotlin.ir.declarations.*
import org.jetbrains.kotlin.ir.util.dump
import org.jetbrains.kotlin.ir.util.IdSignature
import org.jetbrains.kotlin.ir.util.packageFqName
import org.jetbrains.kotlin.ir.util.render
import org.jetbrains.kotlin.ir.visitors.IrElementVisitor
import org.jetbrains.kotlin.ir.IrFileEntry
import org.jetbrains.kotlin.ir.types.*
import org.jetbrains.kotlin.ir.expressions.IrBody
import org.jetbrains.kotlin.ir.expressions.IrBlockBody
import org.jetbrains.kotlin.ir.expressions.IrReturn
import org.jetbrains.kotlin.ir.expressions.IrExpression
import org.jetbrains.kotlin.ir.expressions.IrCall
import org.jetbrains.kotlin.ir.expressions.IrGetValue
import org.jetbrains.kotlin.ir.expressions.IrConst
import org.jetbrains.kotlin.ir.expressions.IrStatementOrigin.*
import org.jetbrains.kotlin.ir.expressions.IrWhen
import org.jetbrains.kotlin.ir.expressions.IrElseBranch
import org.jetbrains.kotlin.ir.expressions.IrWhileLoop
import org.jetbrains.kotlin.ir.expressions.IrBlock
import org.jetbrains.kotlin.ir.expressions.IrDoWhileLoop
import org.jetbrains.kotlin.ir.IrStatement
import org.jetbrains.kotlin.ir.symbols.IrClassifierSymbol

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
        val unknownLoc = startOffset == -1 && endOffset == -1
        val startLine =   if(unknownLoc) 0 else fileEntry.getLineNumber(startOffset) + 1
        val startColumn = if(unknownLoc) 0 else fileEntry.getColumnNumber(startOffset) + 1
        val endLine =     if(unknownLoc) 0 else fileEntry.getLineNumber(endOffset) + 1
        val endColumn =   if(unknownLoc) 0 else fileEntry.getColumnNumber(endOffset)
        val id: Label<DbLocation> = getFreshLabel()
        // TODO: This isn't right for UnknownLocation
        val fileId: Label<DbFile> = getLabelFor(fileLabel)
        writeTrap("$id = @\"loc,{$fileId},$startLine,$startColumn,$endLine,$endColumn\"\n")
        writeLocations_default(id, fileId, startLine, startColumn, endLine, endColumn)
        return id
    }
    val labelMapping: MutableMap<String, Label<*>> = mutableMapOf<String, Label<*>>()
    fun <T> getExistingLabelFor(label: String): Label<T>? {
        @Suppress("UNCHECKED_CAST")
        return labelMapping.get(label) as Label<T>?
    }
    fun <T> getLabelFor(label: String, initialise: (Label<T>) -> Unit = {}): Label<T> {
        val maybeId: Label<T>? = getExistingLabelFor(label)
        if(maybeId == null) {
            val id: Label<T> = getFreshLabel()
            labelMapping.put(label, id)
            writeTrap("$id = $label\n")
            initialise(id)
            return id
        } else {
            return maybeId
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
            is IrProperty -> extractProperty(declaration, parentid)
            else -> extractorBug("Unrecognised IrDeclaration: " + declaration.javaClass)
        }
    }

    @Suppress("UNUSED_PARAMETER")
    fun useSimpleType(s: IrSimpleType): Label<out DbType> {
        fun primitiveType(name: String): Label<DbPrimitive> {
            return tw.getLabelFor("@\"type;$name\"", {
                tw.writePrimitives(it, name)
            })
        }
        when {
            s.isByte() -> return primitiveType("byte")
            s.isShort() -> return primitiveType("short")
            s.isInt() -> return primitiveType("int")
            s.isLong() -> return primitiveType("long")
            s.isUByte() || s.isUShort() || s.isUInt() || s.isULong() -> {
                extractorBug("Unhandled unsigned type")
                return Label(0)
            }

            s.isDouble() -> return primitiveType("double")
            s.isFloat() -> return primitiveType("float")

            s.isBoolean() -> return primitiveType("boolean")

            s.isChar() -> return primitiveType("char")
            s.isString() -> return primitiveType("string") // TODO: Wrong
            s.classifier.owner is IrClass -> {
                val classifier: IrClassifierSymbol = s.classifier
                val cls: IrClass = classifier.owner as IrClass
                return useClass(cls)
            }
            else -> {
                extractorBug("Unrecognised IrSimpleType: " + s.javaClass + ": " + s.render())
                return Label(0)
            }
        }
    }

    fun getClassLabel(c: IrClass): String {
        val pkg = c.packageFqName?.asString() ?: ""
        val cls = c.name.asString()
        val qualClassName = if (pkg.isEmpty()) cls else "$pkg.$cls"
        val label = "@\"class;$qualClassName\""
        return label
    }

    fun addClassLabel(c: IrClass): Label<out DbClass> {
        val label = getClassLabel(c)
        val id: Label<DbClass> = tw.getLabelFor(label)
        return id
    }

    fun useClass(c: IrClass): Label<out DbClass> {
        if(c.name.asString() == "Any" || c.name.asString() == "Unit") {
            if(tw.getExistingLabelFor<DbClass>(getClassLabel(c)) == null) {
                return extractClass(c)
            }
        }
        return addClassLabel(c)
    }

    fun extractClass(c: IrClass): Label<out DbClass> {
        val id = addClassLabel(c)
        val locId = tw.getLocation(c.startOffset, c.endOffset)
        val pkg = c.packageFqName?.asString() ?: ""
        val cls = c.name.asString()
        val pkgId = extractPackage(pkg)
        tw.writeClasses(id, cls, pkgId, id)
        tw.writeHasLocation(id, locId)
        c.declarations.map { extractDeclaration(it, id) }
        return id
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

    fun useDeclarationParent(dp: IrDeclarationParent): Label<out DbElement> {
        when(dp) {
            is IrFile -> return usePackage(dp.fqName.asString())
            is IrClass -> return useClass(dp)
            is IrFunction -> return useFunction(dp)
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

    fun useValueParameter(vp: IrValueParameter): Label<out DbParam> {
        @Suppress("UNCHECKED_CAST")
        val parentId: Label<out DbMethod> = useDeclarationParent(vp.parent) as Label<out DbMethod>
        val idx = vp.index
        val label = "@\"params;{$parentId};$idx\""
        val id = tw.getLabelFor<DbParam>(label)
        return id
    }

    fun extractValueParameter(vp: IrValueParameter, parent: Label<out DbMethod>, idx: Int) {
        val id = useValueParameter(vp)
        val typeId = useType(vp.type)
        val locId = tw.getLocation(vp.startOffset, vp.endOffset)
        tw.writeParams(id, typeId, idx, parent, id)
        tw.writeHasLocation(id, locId)
        tw.writeParamName(id, vp.name.asString())
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
        f.valueParameters.forEachIndexed { i, vp ->
            extractValueParameter(vp, id, i)
        }
    }

    fun useProperty(p: IrProperty): Label<out DbField> {
        val parentId = useDeclarationParent(p.parent)
        val label = "@\"field;{$parentId};${p.name.asString()}\""
        val id: Label<DbField> = tw.getLabelFor(label)
        return id
    }

    fun extractProperty(p: IrProperty, parentid: Label<out DbPackage_or_reftype>) {
        val bf = p.backingField
        if(bf == null) {
            extractorBug("IrProperty without backing field")
        } else {
            val id = useProperty(p)
            val locId = tw.getLocation(p.startOffset, p.endOffset)
            val typeId = useType(bf.type)
            tw.writeFields(id, p.name.asString(), typeId, parentid, id)
            tw.writeHasLocation(id, locId)
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
        tw.writeStmts_block(id, parent, idx, callable)
        tw.writeHasLocation(id, locId)
        for((sIdx, stmt) in b.statements.withIndex()) {
            extractStatement(stmt, callable, id, sIdx)
        }
    }

    fun extractVariable(v: IrVariable, callable: Label<out DbCallable>) {
        val id = tw.getFreshIdLabel<DbLocalvar>()
        val locId = tw.getLocation(v.startOffset, v.endOffset)
        val typeId = useType(v.type)
        val decId = tw.getFreshIdLabel<DbLocalvariabledeclexpr>()
        tw.writeLocalvars(id, v.name.asString(), typeId, decId)
        tw.writeHasLocation(id, locId)
        tw.writeExprs_localvariabledeclexpr(decId, typeId, id, 0)
        tw.writeHasLocation(id, locId)
        val i = v.initializer
        if(i != null) {
            extractExpression(i, callable, decId, 0)
        }
    }

    fun extractStatement(s: IrStatement, callable: Label<out DbCallable>, parent: Label<out DbStmtparent>, idx: Int) {
        when(s) {
            is IrExpression -> {
                extractExpression(s, callable, parent, idx)
            }
            is IrVariable -> {
                extractVariable(s, callable)
            }
            else -> {
                extractorBug("Unrecognised IrStatement: " + s.javaClass)
            }
        }
    }

    fun useValueDeclaration(d: IrValueDeclaration): Label<out DbVariable> {
        when(d) {
            is IrValueParameter -> {
                return useValueParameter(d)
            }
            else -> {
                extractorBug("Unrecognised IrValueDeclaration: " + d.javaClass)
                return Label(0)
            }
        }
    }

    fun extractExpression(e: IrExpression, callable: Label<out DbCallable>, parent: Label<out DbExprparent>, idx: Int) {
        when(e) {
            is IrCall -> {
                val sig: IdSignature.PublicSignature? = e.symbol.signature?.asPublic()
                if(sig == null) {
                    extractorBug("IrCall without public signature")
                } else {
                    when {
                        e.origin == PLUS -> {
                            if(e.valueArgumentsCount == 1) {
                                val left = e.dispatchReceiver
                                val right = e.getValueArgument(0)
                                if(left != null && right != null) {
                                    val id = tw.getFreshIdLabel<DbAddexpr>()
                                    val typeId = useType(e.type)
                                    val locId = tw.getLocation(e.startOffset, e.endOffset)
                                    tw.writeExprs_addexpr(id, typeId, parent, idx)
                                    tw.writeHasLocation(id, locId)
                                    extractExpression(left, callable, id, 0)
                                    extractExpression(right, callable, id, 1)
                                } else {
                                    extractorBug("Unrecognised IrCall: left or right is null")
                                }
                            } else {
                                extractorBug("Unrecognised IrCall: Not binary")
                            }
                        }
                        else -> extractorBug("Unrecognised IrCall: " + e.render())
                    }
                }
            }
            is IrConst<*> -> {
                val v = e.value as Int
                val id = tw.getFreshIdLabel<DbIntegerliteral>()
                val typeId = useType(e.type)
                val locId = tw.getLocation(e.startOffset, e.endOffset)
                tw.writeExprs_integerliteral(id, typeId, parent, idx)
                tw.writeHasLocation(id, locId)
                tw.writeNamestrings(v.toString(), v.toString(), id)
            }
            is IrGetValue -> {
                val id = tw.getFreshIdLabel<DbVaraccess>()
                val typeId = useType(e.type)
                val locId = tw.getLocation(e.startOffset, e.endOffset)
                tw.writeExprs_varaccess(id, typeId, parent, idx)
                tw.writeHasLocation(id, locId)

                val vId = useValueDeclaration(e.symbol.owner)
                tw.writeVariableBinding(id, vId)
            }
            is IrReturn -> {
                val id = tw.getFreshIdLabel<DbReturnstmt>()
                val locId = tw.getLocation(e.startOffset, e.endOffset)
                tw.writeStmts_returnstmt(id, parent, idx, callable)
                tw.writeHasLocation(id, locId)
                extractExpression(e.value, callable, id, 0)
            } is IrBlock -> {
                val id = tw.getFreshIdLabel<DbBlock>()
                val locId = tw.getLocation(e.startOffset, e.endOffset)
                tw.writeStmts_block(id, parent, idx, callable)
                tw.writeHasLocation(id, locId)
                e.statements.forEachIndexed { i, s ->
                    extractStatement(s, callable, id, i)
                }
            } is IrWhileLoop -> {
                val id = tw.getFreshIdLabel<DbWhilestmt>()
                val locId = tw.getLocation(e.startOffset, e.endOffset)
                tw.writeStmts_whilestmt(id, parent, idx, callable)
                tw.writeHasLocation(id, locId)
                extractExpression(e.condition, callable, id, 0)
                val body = e.body
                if(body != null) {
                    extractExpression(body, callable, id, 1) // TODO: The QLLs think this is a Stmt
                }
            } is IrDoWhileLoop -> {
                val id = tw.getFreshIdLabel<DbDostmt>()
                val locId = tw.getLocation(e.startOffset, e.endOffset)
                tw.writeStmts_dostmt(id, parent, idx, callable)
                tw.writeHasLocation(id, locId)
                extractExpression(e.condition, callable, id, 0)
                val body = e.body
                if(body != null) {
                    extractExpression(body, callable, id, 1) // TODO: The QLLs think this is a Stmt
                }
            } is IrWhen -> {
                if(e.origin == IF) {
                    var branchParent = parent
                    var branchIdx = idx
                    for(b in e.branches) {
                        if(b is IrElseBranch) {
                            // TODO
                        } else {
                            val id = tw.getFreshIdLabel<DbIfstmt>()
                            val locId = tw.getLocation(b.startOffset, b.endOffset)
                            tw.writeStmts_ifstmt(id, branchParent, branchIdx, callable)
                            tw.writeHasLocation(id, locId)
                            extractExpression(b.condition, callable, id, 0)
                            extractExpression(b.result, callable, id, 1) // TODO: The QLLs think this is a Stmt
                            branchParent = id
                            branchIdx = 2
                        }
                    }
                } else {
                    extractorBug("Unrecognised IrWhen: " + e.javaClass)
                }
            }
            else -> {
                extractorBug("Unrecognised IrExpression: " + e.javaClass)
            }
        }
    }
}

