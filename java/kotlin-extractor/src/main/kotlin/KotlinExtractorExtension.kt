package com.github.codeql

import com.github.codeql.comments.CommentExtractor
import org.jetbrains.kotlin.backend.common.extensions.IrGenerationExtension
import org.jetbrains.kotlin.backend.common.extensions.IrPluginContext
import org.jetbrains.kotlin.descriptors.ClassKind
import org.jetbrains.kotlin.ir.IrElement
import org.jetbrains.kotlin.ir.IrStatement
import org.jetbrains.kotlin.ir.declarations.*
import org.jetbrains.kotlin.ir.expressions.*
import org.jetbrains.kotlin.ir.expressions.IrStatementOrigin.*
import org.jetbrains.kotlin.ir.symbols.IrClassifierSymbol
import org.jetbrains.kotlin.ir.types.*
import org.jetbrains.kotlin.ir.util.packageFqName
import org.jetbrains.kotlin.ir.util.render
import java.io.File
import java.io.FileOutputStream
import java.io.PrintWriter
import java.io.StringWriter
import java.nio.file.Files
import java.nio.file.Paths
import java.util.*
import kotlin.system.exitProcess

class KotlinExtractorExtension(private val invocationTrapFile: String, private val checkTrapIdentical: Boolean) : IrGenerationExtension {
    override fun generate(moduleFragment: IrModuleFragment, pluginContext: IrPluginContext) {
        val startTimeMs = System.currentTimeMillis()
        // This default should be kept in sync with language-packs/java/tools/kotlin-extractor
        val trapDir = File(System.getenv("CODEQL_EXTRACTOR_JAVA_TRAP_DIR").takeUnless { it.isNullOrEmpty() } ?: "kotlin-extractor/trap")
        FileOutputStream(File(invocationTrapFile), true).bufferedWriter().use { invocationTrapFileBW ->
            val lm = TrapLabelManager()
            val tw = TrapWriter(lm, invocationTrapFileBW)
            // The python wrapper has already defined #compilation = *
            val compilation: Label<DbCompilation> = StringLabel("compilation")
            tw.writeCompilation_started(compilation)
            tw.flush()
            val logCounter = LogCounter()
            val logger = Logger(logCounter, tw)
            logger.info("Extraction started")
            logger.flush()
            val srcDir = File(System.getenv("CODEQL_EXTRACTOR_JAVA_SOURCE_ARCHIVE_DIR").takeUnless { it.isNullOrEmpty() } ?: "kotlin-extractor/src")
            srcDir.mkdirs()
            moduleFragment.files.mapIndexed { index: Int, file: IrFile ->
                val fileTrapWriter = FileTrapWriter(lm, invocationTrapFileBW, file)
                fileTrapWriter.writeCompilation_compiling_files(compilation, index, fileTrapWriter.fileId)
                doFile(invocationTrapFile, fileTrapWriter, checkTrapIdentical, logCounter, trapDir, srcDir, file)
            }
            logger.printLimitedWarningCounts()
            // We don't want the compiler to continue and generate class
            // files etc, so we just exit when we are finished extracting.
            logger.info("Extraction completed")
            logger.flush()
            val compilationTimeMs = System.currentTimeMillis() - startTimeMs
            tw.writeCompilation_finished(compilation, -1.0, compilationTimeMs.toDouble() / 1000)
            tw.flush()
        }
        exitProcess(0)
    }
}

interface Label<T>

class IntLabel<T>(val name: Int): Label<T> {
    override fun toString(): String = "#$name"
}

class StringLabel<T>(val name: String): Label<T> {
    override fun toString(): String = "#$name"
}

class StarLabel<T>(): Label<T> {
    override fun toString(): String = "*"
}

fun escapeTrapString(str: String) = str.replace("\"", "\"\"")

private fun equivalentTrap(f1: File, f2: File): Boolean {
    f1.bufferedReader().use { bw1 ->
        f2.bufferedReader().use { bw2 ->
            while(true) {
                val l1 = bw1.readLine()
                val l2 = bw2.readLine()
                if (l1 == null && l2 == null) {
                    return true
                } else if (l1 == null || l2 == null) {
                    return false
                } else if (l1 != l2) {
                    if (!l1.startsWith("//") || !l2.startsWith("//")) {
                        return false
                    }
                }
            }
        }
    }
}

fun doFile(invocationTrapFile: String, fileTrapWriter: FileTrapWriter, checkTrapIdentical: Boolean, logCounter: LogCounter, trapDir: File, srcDir: File, file: IrFile) {
    val filePath = file.path
    val logger = FileLogger(logCounter, fileTrapWriter)
    logger.info("Extracting file $filePath")
    logger.flush()
    val dest = Paths.get("$srcDir/${file.path}")
    val destDir = dest.getParent()
    Files.createDirectories(destDir)
    val srcTmpFile = File.createTempFile(dest.getFileName().toString() + ".", ".src.tmp", destDir.toFile())
    val srcTmpOS = FileOutputStream(srcTmpFile)
    Files.copy(Paths.get(file.path), srcTmpOS)
    srcTmpOS.close()
    srcTmpFile.renameTo(dest.toFile())

    val trapFile = File("$trapDir/$filePath.trap")
    val trapFileDir = trapFile.getParentFile()
    trapFileDir.mkdirs()
    if (checkTrapIdentical || !trapFile.exists()) {
        val trapTmpFile = File.createTempFile("$filePath.", ".trap.tmp", trapFileDir)
        trapTmpFile.bufferedWriter().use { trapFileBW ->
            trapFileBW.write("// Generated by invocation ${invocationTrapFile.replace("\n", "\n//    ")}\n")
            val tw = FileTrapWriter(TrapLabelManager(), trapFileBW, file)
            val fileExtractor = KotlinFileExtractor(logger, tw, file)
            fileExtractor.extractFileContents(tw.fileId)
        }
        if (checkTrapIdentical && trapFile.exists()) {
            if(equivalentTrap(trapTmpFile, trapFile)) {
                if(!trapTmpFile.delete()) {
                    logger.warn(Severity.WarnLow, "Failed to delete $trapTmpFile")
                }
            } else {
                val trapDifferentFile = File.createTempFile("$filePath.", ".trap.different", trapDir)
                if(trapTmpFile.renameTo(trapDifferentFile)) {
                    logger.warn(Severity.Warn, "TRAP difference: $trapFile vs $trapDifferentFile")
                } else {
                    logger.warn(Severity.WarnLow, "Failed to rename $trapTmpFile to $trapFile")
                }
            }
        } else {
            if(!trapTmpFile.renameTo(trapFile)) {
                logger.warn(Severity.WarnLow, "Failed to rename $trapTmpFile to $trapFile")
            }
        }
    }
}

fun <T> fakeLabel(): Label<T> {
    if (true) {
        println("Fake label")
    } else {
        val sw = StringWriter()
        Exception().printStackTrace(PrintWriter(sw))
        println("Fake label from:\n$sw")
    }
    return IntLabel(0)
}

class KotlinFileExtractor(val logger: FileLogger, val tw: FileTrapWriter, val file: IrFile) {
    val fileClass by lazy {
        extractFileClass(file)
    }

    fun extractFileContents(id: Label<DbFile>) {
        val pkg = file.fqName.asString()
        val pkgId = extractPackage(pkg)
        tw.writeCupackage(id, pkgId)
        file.declarations.map { extractDeclaration(it, Optional.empty()) }
        CommentExtractor(this).extract()
    }

  fun extractFileClass(f: IrFile): Label<out DbClass> {
      val fileName = f.fileEntry.name
      val pkg = f.fqName.asString()
      val defaultName = fileName.replaceFirst(Regex(""".*[/\\]"""), "").replaceFirst(Regex("""\.kt$"""), "").replaceFirstChar({ it.uppercase() }) + "Kt"
      var jvmName = defaultName
      for(a: IrConstructorCall in f.annotations) {
          val t = a.type
          if(t is IrSimpleType && a.valueArgumentsCount == 1) {
              val owner = t.classifier.owner
              val v = a.getValueArgument(0)
              if(owner is IrClass) {
                  val aPkg = owner.packageFqName?.asString()
                  val name = owner.name.asString()
                  if(aPkg == "kotlin.jvm" && name == "JvmName" && v is IrConst<*>) {
                      val value = v.value
                      if(value is String) {
                          jvmName = value
                      }
                  }
              }
          }
      }
      val qualClassName = if (pkg.isEmpty()) jvmName else "$pkg.$jvmName"
      val label = "@\"class;$qualClassName\""
      val id: Label<DbClass> = tw.getLabelFor(label)
      val locId = tw.getLocation(-1, -1) // TODO: This should be the whole file
      val pkgId = extractPackage(pkg)
      tw.writeClasses(id, jvmName, pkgId, id)
      tw.writeHasLocation(id, locId)
      return id
  }

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

    fun extractDeclaration(declaration: IrDeclaration, optParentid: Optional<Label<out DbReftype>>) {
        when (declaration) {
            is IrClass -> extractClass(declaration)
            is IrFunction -> extractFunction(declaration, if (optParentid.isPresent()) optParentid.get() else fileClass)
            is IrProperty -> extractProperty(declaration, if (optParentid.isPresent()) optParentid.get() else fileClass)
            else -> logger.warnElement(Severity.ErrorSevere, "Unrecognised IrDeclaration: " + declaration.javaClass, declaration)
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
                logger.warn(Severity.ErrorSevere, "Unhandled unsigned type")
                return fakeLabel()
            }

            s.isDouble() -> return primitiveType("double")
            s.isFloat() -> return primitiveType("float")

            s.isBoolean() -> return primitiveType("boolean")

            s.isChar() -> return primitiveType("char")
            s.isString() -> return primitiveType("string") // TODO: Wrong

            s.isNullable() && s.hasQuestionMark -> return useType(s.makeNotNull()) // TODO: Wrong

            s.isNothing() -> return primitiveType("<nulltype>")

            s.classifier.owner is IrClass -> {
                val classifier: IrClassifierSymbol = s.classifier
                val cls: IrClass = classifier.owner as IrClass
                return useClass(cls)
            }
            s.classifier.owner is IrTypeParameter -> {
                return useTypeParameter(s.classifier.owner as IrTypeParameter)
            }
            else -> {
                logger.warn(Severity.ErrorSevere, "Unrecognised IrSimpleType: " + s.javaClass + ": " + s.render())
                return fakeLabel()
            }
        }
    }



    fun getLabel(element: IrElement) : String? {
        when (element) {
            is IrFile -> return "@\"${element.path};sourcefile\"" // todo: remove copy-pasted code
            is IrClass -> return getClassLabel(element)
            is IrTypeParameter -> return getTypeParameterLabel(element)
            is IrFunction -> return getFunctionLabel(element)
            is IrValueParameter -> return getValueParameterLabel(element)
            is IrProperty -> return getPropertyLabel(element)

            // Fresh entities:
            is IrBody -> return null
            is IrExpression -> return null

            // todo add others:
            else -> {
                logger.warnElement(Severity.ErrorSevere, "Unhandled element type: ${element::class}", element)
                return null
            }
        }
    }

    private fun getTypeParameterLabel(param: IrTypeParameter): String {
        val parentLabel = useDeclarationParent(param.parent)
        return "@\"typevar;{$parentLabel};${param.name}\""
    }

    fun useTypeParameter(param: IrTypeParameter): Label<out DbTypevariable> {
        return tw.getLabelFor(getTypeParameterLabel(param))
    }

    private fun getClassLabel(c: IrClass): String {
        val pkg = c.packageFqName?.asString() ?: ""
        val cls = c.name.asString()
        val qualClassName = if (pkg.isEmpty()) cls else "$pkg.$cls"
        val label = "@\"class;$qualClassName\""
        return label
    }

    fun addClassLabel(c: IrClass): Label<out DbClassorinterface> {
        val label = getClassLabel(c)
        val id: Label<DbClassorinterface> = tw.getLabelFor(label)
        return id
    }

    fun useClass(c: IrClass): Label<out DbClassorinterface> {
        // todo: fix this
        if (c.origin == IrDeclarationOrigin.IR_EXTERNAL_DECLARATION_STUB ||
            c.origin == IrDeclarationOrigin.IR_EXTERNAL_JAVA_DECLARATION_STUB) {
            if(tw.getExistingLabelFor<DbClass>(getClassLabel(c)) == null) {
                return extractExternalClass(c)
            }
        }
        return addClassLabel(c)
    }

    fun extractExternalClass(c: IrClass): Label<out DbClassorinterface> {
        // todo: fix this.
        // temporarily only extract the class or interface without any members.
        val id = addClassLabel(c)
        val pkg = c.packageFqName?.asString() ?: ""
        val cls = c.name.asString()
        val pkgId = extractPackage(pkg)
        if(c.kind == ClassKind.INTERFACE) {
            @Suppress("UNCHECKED_CAST")
            val interfaceId = id as Label<out DbInterface>
            tw.writeInterfaces(interfaceId, cls, pkgId, interfaceId)
        } else {
            @Suppress("UNCHECKED_CAST")
            val classId = id as Label<out DbClass>
            tw.writeClasses(classId, cls, pkgId, classId)
        }
        return id
    }

    fun extractClass(c: IrClass): Label<out DbClassorinterface> {
        val id = extractExternalClass(c)
        val locId = tw.getLocation(c)
        tw.writeHasLocation(id, locId)
        for(t in c.superTypes) {
            when(t) {
                is IrSimpleType -> {
                    when {
                        t.classifier.owner is IrClass -> {
                            val classifier: IrClassifierSymbol = t.classifier
                            val tcls: IrClass = classifier.owner as IrClass
                            val l = useClass(tcls)
                            tw.writeExtendsReftype(id, l)
                        } else -> {
                            logger.warn(Severity.ErrorSevere, "Unexpected simple type supertype: " + t.javaClass + ": " + t.render())
                        }
                    }
                } else -> {
                    logger.warn(Severity.ErrorSevere, "Unexpected supertype: " + t.javaClass + ": " + t.render())
                }
            }
        }
        c.declarations.map { extractDeclaration(it, Optional.of(id)) }
        return id
    }

    fun useType(t: IrType): Label<out DbType> {
        when(t) {
            is IrSimpleType -> return useSimpleType(t)
            is IrClass -> return useClass(t)
            else -> {
                logger.warn(Severity.ErrorSevere, "Unrecognised IrType: " + t.javaClass)
                return fakeLabel()
            }
        }
    }

    fun useDeclarationParent(dp: IrDeclarationParent): Label<out DbElement> {
        when(dp) {
            is IrFile -> return usePackage(dp.fqName.asString())
            is IrClass -> return useClass(dp)
            is IrFunction -> return useFunction(dp)
            else -> {
                logger.warnElement(Severity.ErrorSevere, "Unrecognised IrDeclarationParent: " + dp.javaClass, dp)
                return fakeLabel()
            }
        }
    }

    fun erase (t: IrType): IrType {
        if(t is IrSimpleType) {
            if(t.classifier.owner is IrTypeParameter) {
                return erase((t.classifier.owner as IrTypeParameter).superTypes.get(0))
            }
        }
        return t
    }

    private fun getFunctionLabel(f: IrFunction) : String {
        val paramTypeIds = f.valueParameters.joinToString() { "{${useType(erase(it.type)).toString()}}" }
        val returnTypeId = useType(erase(f.returnType))
        val parentId = useDeclarationParent(f.parent)
        val label = "@\"callable;{$parentId}.${f.name.asString()}($paramTypeIds){$returnTypeId}\""
        return label
    }

    fun useFunction(f: IrFunction): Label<out DbMethod> {
        val label = getFunctionLabel(f)
        val id: Label<DbMethod> = tw.getLabelFor(label)
        return id
    }

    private fun getValueParameterLabel(vp: IrValueParameter) : String {
        @Suppress("UNCHECKED_CAST")
        val parentId: Label<out DbMethod> = useDeclarationParent(vp.parent) as Label<out DbMethod>
        var idx = vp.index
        if (isQualifiedThis(vp)) {
            idx = -2
        }
        val label = "@\"params;{$parentId};$idx\""
        return label
    }

    private fun isQualifiedThis(vp: IrValueParameter) : Boolean {
        val parent = vp.parent
        return vp.index == -1 &&
                parent is IrFunction &&
                parent.dispatchReceiverParameter == vp &&
                parent.extensionReceiverParameter != null
    }

    fun useValueParameter(vp: IrValueParameter): Label<out DbParam> {
        val label = getValueParameterLabel(vp)
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

    fun extractFunction(f: IrFunction, parentid: Label<out DbReftype>) {
        val id = useFunction(f)
        val locId = tw.getLocation(f)
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

        var index = -1
        val extReceiver = f.extensionReceiverParameter
        if (extReceiver != null) {
            extractValueParameter(extReceiver, id, index--)
        }

        val dispReceiver = f.dispatchReceiverParameter
        if (dispReceiver != null) {
            extractValueParameter(dispReceiver, id, index)
        }
    }

    private fun getPropertyLabel(p: IrProperty) : String {
        val parentId = useDeclarationParent(p.parent)
        val label = "@\"field;{$parentId};${p.name.asString()}\""
        return label
    }

    fun useProperty(p: IrProperty): Label<out DbField> {
        var label = getPropertyLabel(p)
        val id: Label<DbField> = tw.getLabelFor(label)
        return id
    }

    fun extractProperty(p: IrProperty, parentid: Label<out DbReftype>) {
        val bf = p.backingField
        if(bf == null) {
            logger.warnElement(Severity.ErrorSevere, "IrProperty without backing field", p)
        } else {
            val id = useProperty(p)
            val locId = tw.getLocation(p)
            val typeId = useType(bf.type)
            tw.writeFields(id, p.name.asString(), typeId, parentid, id)
            tw.writeHasLocation(id, locId)
        }
    }

    fun extractBody(b: IrBody, callable: Label<out DbCallable>) {
        when(b) {
            is IrBlockBody -> extractBlockBody(b, callable, callable, 0)
            else -> logger.warnElement(Severity.ErrorSevere, "Unrecognised IrBody: " + b.javaClass, b)
        }
    }

    fun extractBlockBody(b: IrBlockBody, callable: Label<out DbCallable>, parent: Label<out DbStmtparent>, idx: Int) {
        val id = tw.getFreshIdLabel<DbBlock>()
        val locId = tw.getLocation(b)
        tw.writeStmts_block(id, parent, idx, callable)
        tw.writeHasLocation(id, locId)
        for((sIdx, stmt) in b.statements.withIndex()) {
            extractStatement(stmt, callable, id, sIdx)
        }
    }

    fun useVariable(v: IrVariable): Label<out DbLocalvar> {
        return tw.getVariableLabelFor<DbLocalvar>(v)
    }

    fun extractVariable(v: IrVariable, callable: Label<out DbCallable>) {
        val id = useVariable(v)
        val locId = tw.getLocation(v)
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
                logger.warnElement(Severity.ErrorSevere, "Unrecognised IrStatement: " + s.javaClass, s)
            }
        }
    }

    fun useValueDeclaration(d: IrValueDeclaration): Label<out DbVariable> {
        when(d) {
            is IrValueParameter -> {
                return useValueParameter(d)
            }
            is IrVariable -> {
                return useVariable(d)
            }
            else -> {
                logger.warnElement(Severity.ErrorSevere, "Unrecognised IrValueDeclaration: " + d.javaClass, d)
                return fakeLabel()
            }
        }
    }

    fun extractCall(c: IrCall, callable: Label<out DbCallable>, parent: Label<out DbExprparent>, idx: Int) {
        val exprId: Label<out DbExpr> = when {
            c.origin == PLUS -> {
                val id = tw.getFreshIdLabel<DbAddexpr>()
                val typeId = useType(c.type)
                val locId = tw.getLocation(c)
                tw.writeExprs_addexpr(id, typeId, parent, idx)
                tw.writeHasLocation(id, locId)
                id
            } c.origin == MINUS -> {
                val id = tw.getFreshIdLabel<DbSubexpr>()
                val typeId = useType(c.type)
                val locId = tw.getLocation(c)
                tw.writeExprs_subexpr(id, typeId, parent, idx)
                tw.writeHasLocation(id, locId)
                id
            } c.origin == DIV -> {
                val id = tw.getFreshIdLabel<DbDivexpr>()
                val typeId = useType(c.type)
                val locId = tw.getLocation(c)
                tw.writeExprs_divexpr(id, typeId, parent, idx)
                tw.writeHasLocation(id, locId)
                id
            } c.origin == PERC -> {
                val id = tw.getFreshIdLabel<DbRemexpr>()
                val typeId = useType(c.type)
                val locId = tw.getLocation(c)
                tw.writeExprs_remexpr(id, typeId, parent, idx)
                tw.writeHasLocation(id, locId)
                id
            } c.origin == EQEQ -> {
                val id = tw.getFreshIdLabel<DbEqexpr>()
                val typeId = useType(c.type)
                val locId = tw.getLocation(c)
                tw.writeExprs_eqexpr(id, typeId, parent, idx)
                tw.writeHasLocation(id, locId)
                id
            } c.origin == EXCLEQ -> {
                val id = tw.getFreshIdLabel<DbNeexpr>()
                val typeId = useType(c.type)
                val locId = tw.getLocation(c)
                tw.writeExprs_neexpr(id, typeId, parent, idx)
                tw.writeHasLocation(id, locId)
                id
            } c.origin == LT -> {
                val id = tw.getFreshIdLabel<DbLtexpr>()
                val typeId = useType(c.type)
                val locId = tw.getLocation(c)
                tw.writeExprs_ltexpr(id, typeId, parent, idx)
                tw.writeHasLocation(id, locId)
                id
            } c.origin == LTEQ -> {
                val id = tw.getFreshIdLabel<DbLeexpr>()
                val typeId = useType(c.type)
                val locId = tw.getLocation(c)
                tw.writeExprs_leexpr(id, typeId, parent, idx)
                tw.writeHasLocation(id, locId)
                id
            } c.origin == GT -> {
                val id = tw.getFreshIdLabel<DbGtexpr>()
                val typeId = useType(c.type)
                val locId = tw.getLocation(c)
                tw.writeExprs_gtexpr(id, typeId, parent, idx)
                tw.writeHasLocation(id, locId)
                id
            } c.origin == GTEQ -> {
                val id = tw.getFreshIdLabel<DbGeexpr>()
                val typeId = useType(c.type)
                val locId = tw.getLocation(c)
                tw.writeExprs_geexpr(id, typeId, parent, idx)
                tw.writeHasLocation(id, locId)
                id
            } else -> {
                val id = tw.getFreshIdLabel<DbMethodaccess>()
                val typeId = useType(c.type)
                val locId = tw.getLocation(c)
                val methodId = useFunction(c.symbol.owner)
                tw.writeExprs_methodaccess(id, typeId, parent, idx)
                tw.writeHasLocation(id, locId)
                tw.writeCallableBinding(id, methodId)
                id
            }
        }
        val dr = c.dispatchReceiver
        val offset = if(dr == null) 0 else 1
        if(dr != null) {
            extractExpression(dr, callable, exprId, 0)
        }
        for(i in 0 until c.valueArgumentsCount) {
            val arg = c.getValueArgument(i)
            if(arg != null) {
                extractExpression(arg, callable, exprId, i + offset)
            }
        }
    }

    private val loopIdMap: MutableMap<IrLoop, Label<out DbKtloopstmt>> = mutableMapOf()

    fun extractExpression(e: IrExpression, callable: Label<out DbCallable>, parent: Label<out DbExprparent>, idx: Int) {
        when(e) {
            is IrCall -> extractCall(e, callable, parent, idx)
            is IrConst<*> -> {
                val v = e.value
                when(v) {
                    is Int -> {
                        val id = tw.getFreshIdLabel<DbIntegerliteral>()
                        val typeId = useType(e.type)
                        val locId = tw.getLocation(e)
                        tw.writeExprs_integerliteral(id, typeId, parent, idx)
                        tw.writeHasLocation(id, locId)
                        tw.writeNamestrings(v.toString(), v.toString(), id)
                    } is Boolean -> {
                        val id = tw.getFreshIdLabel<DbBooleanliteral>()
                        val typeId = useType(e.type)
                        val locId = tw.getLocation(e)
                        tw.writeExprs_booleanliteral(id, typeId, parent, idx)
                        tw.writeHasLocation(id, locId)
                        tw.writeNamestrings(v.toString(), v.toString(), id)
                    } is Char -> {
                        val id = tw.getFreshIdLabel<DbCharacterliteral>()
                        val typeId = useType(e.type)
                        val locId = tw.getLocation(e)
                        tw.writeExprs_characterliteral(id, typeId, parent, idx)
                        tw.writeHasLocation(id, locId)
                        tw.writeNamestrings(v.toString(), v.toString(), id)
                    } is String -> {
                        val id = tw.getFreshIdLabel<DbStringliteral>()
                        val typeId = useType(e.type)
                        val locId = tw.getLocation(e)
                        tw.writeExprs_stringliteral(id, typeId, parent, idx)
                        tw.writeHasLocation(id, locId)
                        tw.writeNamestrings(v.toString(), v.toString(), id)
                    }
                    null -> {
                        val id = tw.getFreshIdLabel<DbNullliteral>()
                        val typeId = useType(e.type) // class;kotlin.Nothing
                        val locId = tw.getLocation(e)
                        tw.writeExprs_nullliteral(id, typeId, parent, idx)
                        tw.writeHasLocation(id, locId)
                    }
                    else -> {
                        logger.warnElement(Severity.ErrorSevere, "Unrecognised IrConst: " + v.javaClass, e)
                    }
                }
            }
            is IrGetValue -> {
                val owner = e.symbol.owner
                if (owner is IrValueParameter && owner.index == -1) {
                    val id = tw.getFreshIdLabel<DbThisaccess>()
                    val typeId = useType(e.type)
                    val locId = tw.getLocation(e)
                    tw.writeExprs_thisaccess(id, typeId, parent, idx)
                    if (isQualifiedThis(owner)) {
                        // todo: add type access as child of 'id' at index 0
                        logger.warnElement(Severity.ErrorSevere, "TODO: Qualified this access found.", e)
                    }
                    tw.writeHasLocation(id, locId)
                } else {
                    val id = tw.getFreshIdLabel<DbVaraccess>()
                    val typeId = useType(e.type)
                    val locId = tw.getLocation(e)
                    tw.writeExprs_varaccess(id, typeId, parent, idx)
                    tw.writeHasLocation(id, locId)

                    val vId = useValueDeclaration(owner)
                    tw.writeVariableBinding(id, vId)
                }
            }
            is IrSetValue -> {
                val id = tw.getFreshIdLabel<DbAssignexpr>()
                val typeId = useType(e.type)
                val locId = tw.getLocation(e)
                tw.writeExprs_assignexpr(id, typeId, parent, idx)
                tw.writeHasLocation(id, locId)

                val lhsId = tw.getFreshIdLabel<DbVaraccess>()
                val lhsTypeId = useType(e.symbol.owner.type)
                tw.writeExprs_varaccess(lhsId, lhsTypeId, id, 0)
                tw.writeHasLocation(id, locId)
                val vId = useValueDeclaration(e.symbol.owner)
                tw.writeVariableBinding(lhsId, vId)

                extractExpression(e.value, callable, id, 1)
            }
            is IrThrow -> {
                val id = tw.getFreshIdLabel<DbThrowstmt>()
                val locId = tw.getLocation(e)
                tw.writeStmts_throwstmt(id, parent, idx, callable)
                tw.writeHasLocation(id, locId)
                extractExpression(e.value, callable, id, 0)
            }
            is IrBreak -> {
                val id = tw.getFreshIdLabel<DbBreakstmt>()
                tw.writeStmts_breakstmt(id, parent, idx, callable)
                extractBreakContinue(e, id)
            }
            is IrContinue -> {
                val id = tw.getFreshIdLabel<DbContinuestmt>()
                tw.writeStmts_continuestmt(id, parent, idx, callable)
                extractBreakContinue(e, id)
            }
            is IrReturn -> {
                val id = tw.getFreshIdLabel<DbReturnstmt>()
                val locId = tw.getLocation(e)
                tw.writeStmts_returnstmt(id, parent, idx, callable)
                tw.writeHasLocation(id, locId)
                extractExpression(e.value, callable, id, 0)
            }
            is IrContainerExpression -> {
                val id = tw.getFreshIdLabel<DbBlock>()
                val locId = tw.getLocation(e)
                tw.writeStmts_block(id, parent, idx, callable)
                tw.writeHasLocation(id, locId)
                e.statements.forEachIndexed { i, s ->
                    extractStatement(s, callable, id, i)
                }
            }
            is IrWhileLoop -> {
                val id = tw.getFreshIdLabel<DbWhilestmt>()
                loopIdMap[e] = id
                val locId = tw.getLocation(e)
                tw.writeStmts_whilestmt(id, parent, idx, callable)
                tw.writeHasLocation(id, locId)
                extractExpression(e.condition, callable, id, 0)
                val body = e.body
                if(body != null) {
                    extractExpression(body, callable, id, 1)
                }
                loopIdMap.remove(e)
            }
            is IrDoWhileLoop -> {
                val id = tw.getFreshIdLabel<DbDostmt>()
                loopIdMap[e] = id
                val locId = tw.getLocation(e)
                tw.writeStmts_dostmt(id, parent, idx, callable)
                tw.writeHasLocation(id, locId)
                extractExpression(e.condition, callable, id, 0)
                val body = e.body
                if(body != null) {
                    extractExpression(body, callable, id, 1)
                }
                loopIdMap.remove(e)
            }
            is IrWhen -> {
                val id = tw.getFreshIdLabel<DbWhenexpr>()
                val typeId = useType(e.type)
                val locId = tw.getLocation(e)
                tw.writeExprs_whenexpr(id, typeId, parent, idx)
                tw.writeHasLocation(id, locId)
                if(e.origin == IF) {
                    tw.writeWhen_if(id)
                }
                e.branches.forEachIndexed { i, b ->
                    val bId = tw.getFreshIdLabel<DbWhenbranch>()
                    val bLocId = tw.getLocation(b)
                    tw.writeWhen_branch(bId, id, i)
                    tw.writeHasLocation(bId, bLocId)
                    extractExpression(b.condition, callable, bId, 0)
                    extractExpression(b.result, callable, bId, 1)
                    if(b is IrElseBranch) {
                        tw.writeWhen_branch_else(bId)
                    }
                }
            }
            is IrGetClass -> {
                val id = tw.getFreshIdLabel<DbGetclassexpr>()
                val locId = tw.getLocation(e)
                val typeId = useType(e.type)
                tw.writeExprs_getclassexpr(id, typeId, parent, idx)
                tw.writeHasLocation(id, locId)
                extractExpression(e.argument, callable, id, 0)
            }
            else -> {
                logger.warnElement(Severity.ErrorSevere, "Unrecognised IrExpression: " + e.javaClass, e)
            }
        }
    }

    private fun extractBreakContinue(
        e: IrBreakContinue,
        id: Label<out DbBreakcontinuestmt>
    ) {
        val locId = tw.getLocation(e)
        @Suppress("UNCHECKED_CAST")
        tw.writeHasLocation(id as Label<out DbLocatable>, locId)
        val label = e.label
        if (label != null) {
            @Suppress("UNCHECKED_CAST")
            tw.writeNamestrings(label, "", id as Label<out DbNamedexprorstmt>)
        }

        val loopId = loopIdMap[e.loop]
        if (loopId == null) {
            logger.warnElement(Severity.ErrorSevere, "Missing break/continue target", e)
            return
        }

        tw.writeKtBreakContinueTarget(id, loopId)
    }
}

