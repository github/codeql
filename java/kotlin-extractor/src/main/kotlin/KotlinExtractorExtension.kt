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
import org.jetbrains.kotlin.ir.symbols.IrClassSymbol
import org.jetbrains.kotlin.ir.symbols.IrClassifierSymbol
import org.jetbrains.kotlin.ir.symbols.IrConstructorSymbol
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
                doFile(invocationTrapFile, fileTrapWriter, checkTrapIdentical, logCounter, trapDir, srcDir, file, pluginContext)
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

fun doFile(invocationTrapFile: String,
           fileTrapWriter: FileTrapWriter,
           checkTrapIdentical: Boolean,
           logCounter: LogCounter,
           trapDir: File,
           srcDir: File,
           file: IrFile,
           pluginContext: IrPluginContext) {
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
            val fileExtractor = KotlinFileExtractor(logger, tw, file, pluginContext)
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

class KotlinFileExtractor(val logger: FileLogger, val tw: FileTrapWriter, val file: IrFile, val pluginContext: IrPluginContext) {
    val fileClass by lazy {
        extractFileClass(file)
    }

    fun extractFileContents(id: Label<DbFile>) {
        val pkg = file.fqName.asString()
        val pkgId = extractPackage(pkg)
        tw.writeCupackage(id, pkgId)
        file.declarations.map { extractDeclaration(it) }
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

    fun extractDeclaration(declaration: IrDeclaration) {
        when (declaration) {
            is IrClass -> extractClass(declaration, listOf())
            is IrFunction -> extractFunction(declaration)
            is IrAnonymousInitializer -> {
                // Leaving this intentionally empty. init blocks are extracted during class extraction.
            }
            is IrProperty -> extractProperty(declaration)
            else -> logger.warnElement(Severity.ErrorSevere, "Unrecognised IrDeclaration: " + declaration.javaClass, declaration)
        }
    }

    fun useSimpleType(s: IrSimpleType, canReturnPrimitiveTypes: Boolean): Label<out DbType> {
        fun primitiveType(name: String): Label<DbPrimitive> {
            return tw.getLabelFor("@\"type;$name\"", {
                tw.writePrimitives(it, name)
            })
        }
        when {
            // temporary fix for type parameters types that would otherwise be primitive types
            !canReturnPrimitiveTypes && (s.isPrimitiveType() || s.isUnsignedType() || s.isString()) -> {
                val classifier: IrClassifierSymbol = s.classifier
                val cls: IrClass = classifier.owner as IrClass

                return useClass(cls, s.arguments)
            }

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

            s.isNullable() && s.hasQuestionMark -> return useType(s.makeNotNull(), canReturnPrimitiveTypes) // TODO: Wrong

            s.isNothing() -> return primitiveType("<nulltype>")

            s.isArray() && s.arguments.isNotEmpty() -> {
                // todo: fix this, this is only a dummy implementation to let the tests pass
                val elementType = useType(s.getArrayElementType(pluginContext.irBuiltIns))
                val id = tw.getLabelFor<DbArray>("@\"array;1;{$elementType}\"")
                tw.writeArrays(id, "ARRAY", elementType, 1, elementType)
                return id
            }

            s.classifier.owner is IrClass -> {
                val classifier: IrClassifierSymbol = s.classifier
                val cls: IrClass = classifier.owner as IrClass

                return useClass(cls, s.arguments)
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
            is IrClass -> return getClassLabel(element, listOf())
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
        val l = getTypeParameterLabel(param)
        val label = tw.getExistingLabelFor<DbTypevariable>(l)
        if (label != null) {
            return label
        }

        // todo: fix this
        if (param.origin == IrDeclarationOrigin.IR_EXTERNAL_DECLARATION_STUB ||
            param.origin == IrDeclarationOrigin.IR_EXTERNAL_JAVA_DECLARATION_STUB){
            return extractTypeParameter(param)
        }

        logger.warnElement(Severity.ErrorSevere, "Missing type parameter label", param)
        return tw.getLabelFor(l)
    }

    private fun extractTypeParameter(tp: IrTypeParameter): Label<out DbTypevariable> {
        val id = tw.getLabelFor<DbTypevariable>(getTypeParameterLabel(tp))

        val parentId: Label<out DbTypeorcallable> = when (val parent = tp.parent) {
            is IrFunction -> useFunction(parent)
            is IrClass -> useClass(parent, listOf())
            else -> {
                logger.warnElement(Severity.ErrorSevere, "Unexpected type parameter parent", tp)
                fakeLabel()
            }
        }

        tw.writeTypeVars(id, tp.name.asString(), tp.index, 0, parentId)
        val locId = tw.getLocation(tp)
        tw.writeHasLocation(id, locId)

        // todo: add type bounds

        return id
    }

    private fun getClassLabel(c: IrClass, typeArgs: List<IrTypeArgument>): String {
        val pkg = c.packageFqName?.asString() ?: ""
        val cls = c.name.asString()
        var label: String
        val parent = c.parent
        if (parent is IrClass) {
            // todo: fix this. Ugly string concat to handle nested class IDs.
            // todo: Can the containing class have type arguments?
            val p = getClassLabel(parent, listOf())
            label = "${p.substring(0, p.length - 1)}\$$cls"
        } else {
            val qualClassName = if (pkg.isEmpty()) cls else "$pkg.$cls"
            label = "@\"class;$qualClassName"
        }

        for (arg in typeArgs) {
            val argId = getTypeArgumentLabel(arg, c)
            label += ";{$argId}"
        }

        label += "\""
        return label
    }

    private fun getTypeArgumentLabel(
        arg: IrTypeArgument,
        reportOn: IrElement
    ): Label<out DbReftype> {
        when (arg) {
            is IrStarProjection -> {
                val wildcardLabel = "@\"wildcard;\""
                val wildcardId: Label<DbWildcard> = tw.getLabelFor(wildcardLabel)
                tw.writeWildcards(wildcardId, "*", 1)
                tw.writeHasLocation(wildcardId, tw.getLocation(-1, -1))
                return wildcardId
            }
            is IrTypeProjection -> {
                return useType(arg.type, false) as Label<out DbReftype>
            }
            else -> {
                logger.warnElement(Severity.ErrorSevere, "Unexpected type argument.", reportOn)
                return fakeLabel()
            }
        }
    }

    fun addClassLabel(c: IrClass, typeArgs: List<IrTypeArgument>): Label<out DbClassorinterface> {
        var label = getClassLabel(c, typeArgs)
        val id: Label<DbClassorinterface> = tw.getLabelFor(label)
        return id
    }

    fun useClass(c: IrClass, typeArgs: List<IrTypeArgument>): Label<out DbClassorinterface> {
        // todo: find a better way of finding if we're dealing with the source type.
        // The return type of a constructor in a generic class is a simple type with the class as the classifier, and
        // the type parameters added as type arguments. The same constructed source type can show up as parameter types
        // of functions inside the class.
        val args = if (typeArgsMatchTypeParameters(typeArgs, c.typeParameters)) {
            listOf()
        } else {
            typeArgs
        }

        val classId = getClassLabel(c, args)
        val label = tw.getExistingLabelFor<DbClass>(classId)
        if (label != null) {
            return label
        }

        if (typeArgs.isNotEmpty()) {
            return extractClass(c, typeArgs)
        }

        // todo: fix this
        if (c.origin == IrDeclarationOrigin.IR_EXTERNAL_DECLARATION_STUB ||
            c.origin == IrDeclarationOrigin.IR_EXTERNAL_JAVA_DECLARATION_STUB){
            return extractClass(c, listOf())
        }

        return tw.getLabelFor(classId)
    }

    private fun typeArgsMatchTypeParameters(typeArgs: List<IrTypeArgument>, typeParameters: List<IrTypeParameter>): Boolean {
        val args = typeArgs.map { if (it !is IrTypeProjection) null else it.type }
        for ((idx, ta) in args.withIndex()){
            val tp = typeParameters.elementAtOrNull(idx)
            if (tp?.symbol?.typeWith() != ta) {
                return false
            }
        }
        return true
    }

    fun extractClass(c: IrClass, typeArgs: List<IrTypeArgument>): Label<out DbClassorinterface> {
        val id = addClassLabel(c, typeArgs)
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

            if (c.kind == ClassKind.ENUM_CLASS) {
                tw.writeIsEnumType(classId)
            }
        }
        val locId = tw.getLocation(c)
        tw.writeHasLocation(id, locId)

        if (typeArgs.isEmpty()) {
            c.typeParameters.map { extractTypeParameter(it) }
        }

        for(t in c.superTypes) {
            when(t) {
                is IrSimpleType -> {
                    when {
                        t.classifier.owner is IrClass -> {
                            val classifier: IrClassifierSymbol = t.classifier
                            val tcls: IrClass = classifier.owner as IrClass
                            val l = useClass(tcls, t.arguments)
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

        if (typeArgs.isNotEmpty()) {
            for ((idx, arg) in typeArgs.withIndex()) {
                val argId = getTypeArgumentLabel(arg, c)
                tw.writeTypeArgs(argId, idx, id)
            }
            tw.writeIsParameterized(id)
            val unbound = useClass(c, listOf())
            tw.writeErasure(id, unbound)
        } else {
            c.declarations.map { extractDeclaration(it) }

            extractObjectInitializerFunction(c, id)
        }

        return id
    }

    fun useType(t: IrType, canReturnPrimitiveTypes: Boolean = true): Label<out DbType> {
        when(t) {
            is IrSimpleType -> return useSimpleType(t, canReturnPrimitiveTypes)
            is IrClass -> return useClass(t, listOf())
            else -> {
                logger.warn(Severity.ErrorSevere, "Unrecognised IrType: " + t.javaClass)
                return fakeLabel()
            }
        }
    }

    fun useDeclarationParent(dp: IrDeclarationParent): Label<out DbElement> {
        when(dp) {
            is IrFile -> return usePackage(dp.fqName.asString())
            is IrClass -> return useClass(dp, listOf())
            is IrFunction -> return useFunction(dp)
            else -> {
                logger.warnElement(Severity.ErrorSevere, "Unrecognised IrDeclarationParent: " + dp.javaClass, dp)
                return fakeLabel()
            }
        }
    }

    fun erase (t: IrType): IrType {
        if (t is IrSimpleType) {
            val classifier = t.classifier
            val owner = classifier.owner
            if(owner is IrTypeParameter) {
                return erase(owner.superTypes.get(0))
            }

            // todo: fix this:
            if (t.makeNotNull().isArray()) {
                val elementType = t.getArrayElementType(pluginContext.irBuiltIns)
                val erasedElementType = erase(elementType)
                return (classifier as IrClassSymbol).typeWith(erasedElementType)
            }

            if (owner is IrClass) {
                return (classifier as IrClassSymbol).typeWith()
            }
        }
        return t
    }

    private fun getFunctionLabel(f: IrFunction) : String {
        return getFunctionLabel(f.parent, f.name.asString(), f.valueParameters, f.returnType)
    }

    private fun getFunctionLabel(parent: IrDeclarationParent, name: String, parameters: List<IrValueParameter>, returnType: IrType) : String {
        val paramTypeIds = parameters.joinToString() { "{${useType(erase(it.type)).toString()}}" }
        val returnTypeId = useType(erase(returnType))
        val parentId = useDeclarationParent(parent)
        val label = "@\"callable;{$parentId}.$name($paramTypeIds){$returnTypeId}\""
        return label
    }

    fun <T: DbCallable> useFunction(f: IrFunction): Label<out T> {
        val label = getFunctionLabel(f)
        val id: Label<T> = tw.getLabelFor(label)
        return id
    }

    private fun getValueParameterLabel(vp: IrValueParameter) : String {
        @Suppress("UNCHECKED_CAST")
        val parentId: Label<out DbMethod> = useDeclarationParent(vp.parent) as Label<out DbMethod>
        var idx = vp.index
        if (idx < 0) {
            // We're not extracting this and this@TYPE parameters of functions:
            logger.warnElement(Severity.ErrorSevere, "Unexpected negative index for parameter", vp)
        }
        val label = "@\"params;{$parentId};$idx\""
        return label
    }

    private fun isQualifiedThis(vp: IrValueParameter): Boolean {
        return isQualifiedThisFunction(vp) ||
               isQualifiedThisClass(vp)
    }

    private fun isQualifiedThisFunction(vp: IrValueParameter): Boolean {
        val parent = vp.parent
        return vp.index == -1 &&
               parent is IrFunction &&
               parent.dispatchReceiverParameter == vp &&
               parent.extensionReceiverParameter != null
    }

    private fun isQualifiedThisClass(vp: IrValueParameter): Boolean {
        val parent = vp.parent
        return vp.index == -1 &&
               parent is IrClass &&
               parent.thisReceiver == vp
    }

    fun useValueParameter(vp: IrValueParameter): Label<out DbParam> {
        val label = getValueParameterLabel(vp)
        val id = tw.getLabelFor<DbParam>(label)
        return id
    }

    fun extractValueParameter(vp: IrValueParameter, parent: Label<out DbCallable>, idx: Int) {
        val id = useValueParameter(vp)
        val typeId = useType(vp.type)
        val locId = tw.getLocation(vp.startOffset, vp.endOffset)
        tw.writeParams(id, typeId, idx, parent, id)
        tw.writeHasLocation(id, locId)
        tw.writeParamName(id, vp.name.asString())
    }

    private fun extractObjectInitializerFunction(c: IrClass, parentId: Label<out DbReftype>) {
        if (c.origin == IrDeclarationOrigin.IR_EXTERNAL_DECLARATION_STUB ||
            c.origin == IrDeclarationOrigin.IR_EXTERNAL_JAVA_DECLARATION_STUB) {
            return
        }

        // add method:
        var obinitLabel = getFunctionLabel(c, "<obinit>", listOf(), pluginContext.irBuiltIns.unitType)
        val obinitId = tw.getLabelFor<DbMethod>(obinitLabel)
        val signature = "TODO"
        val returnTypeId = useType(pluginContext.irBuiltIns.unitType)
        tw.writeMethods(obinitId, "<obinit>", signature, returnTypeId, parentId, obinitId)

        val locId = tw.getLocation(c)
        tw.writeHasLocation(obinitId, locId)

        // add body:
        val blockId = tw.getFreshIdLabel<DbBlock>()
        tw.writeStmts_block(blockId, obinitId, 0, obinitId)
        tw.writeHasLocation(blockId, locId)

        // body content with field initializers and init blocks
        var idx = 0
        for (decl in c.declarations) {
            when (decl) {
                is IrProperty -> {
                    val backingField = decl.backingField
                    val initializer = backingField?.initializer

                    if (backingField == null || backingField.isStatic || initializer == null) {
                        continue
                    }

                    val assignmentId = tw.getFreshIdLabel<DbAssignexpr>()
                    val typeId = useType(initializer.expression.type)
                    val declLocId = tw.getLocation(decl)
                    tw.writeExprs_assignexpr(assignmentId, typeId, blockId, idx++)
                    tw.writeHasLocation(assignmentId, declLocId)

                    val lhsId = tw.getFreshIdLabel<DbVaraccess>()
                    val lhsTypeId = useType(backingField.type)
                    tw.writeExprs_varaccess(lhsId, lhsTypeId, assignmentId, 0)
                    tw.writeHasLocation(lhsId, declLocId)
                    val vId = useProperty(decl) // todo: fix this. We should be assigning the field, and not the property
                    tw.writeVariableBinding(lhsId, vId)

                    extractExpression(initializer.expression, obinitId, assignmentId, 1)
                }
                is IrAnonymousInitializer -> {
                    if (decl.isStatic) {
                        continue
                    }

                    for (stmt in decl.body.statements) {
                        extractStatement(stmt, obinitId, blockId, idx++)
                    }
                }
                else -> continue
            }
        }
    }

    fun extractFunction(f: IrFunction) {
        currentFunction = f

        f.typeParameters.map { extractTypeParameter(it) }

        val locId = tw.getLocation(f)
        val signature = "TODO"
        val returnTypeId = useType(f.returnType)

        val parentId = if (f.parent is IrClass ) useClass(f.parent as IrClass, listOf()) else fileClass

        val id: Label<out DbCallable>
        if (f.symbol is IrConstructorSymbol) {
            id = useFunction<DbConstructor>(f)
            tw.writeConstrs(id, f.returnType.classFqName?.shortName()?.asString() ?: f.name.asString(), signature, returnTypeId, parentId, id)
        } else {
            id = useFunction<DbMethod>(f)
            tw.writeMethods(id, f.name.asString(), signature, returnTypeId, parentId, id)

            val extReceiver = f.extensionReceiverParameter
            if (extReceiver != null) {
                val extendedType = useType(extReceiver.type)
                tw.writeKtExtensionFunctions(id, extendedType)
            }
        }

        tw.writeHasLocation(id, locId)
        val body = f.body
        if(body != null) {
            extractBody(body, id)
        }
        f.valueParameters.forEachIndexed { i, vp ->
            extractValueParameter(vp, id, i)
        }

        currentFunction = null
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

    fun extractProperty(p: IrProperty) {
        val bf = p.backingField
        if(bf == null) {
            logger.warnElement(Severity.ErrorSevere, "IrProperty without backing field", p)
        } else {
            val id = useProperty(p)
            val locId = tw.getLocation(p)
            val typeId = useType(bf.type)
            val parentId = if (p.parent is IrClass ) useClass(p.parent as IrClass, listOf()) else fileClass
            tw.writeFields(id, p.name.asString(), typeId, parentId, id)
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
                val methodId = useFunction<DbMethod>(c.symbol.owner)
                tw.writeExprs_methodaccess(id, typeId, parent, idx)
                tw.writeHasLocation(id, locId)
                tw.writeCallableBinding(id, methodId)

                // type arguments at index -2, -3, ...
                extractTypeArguments(c, id, -2, true)
                id
            }
        }
        val dr = c.dispatchReceiver
        if(dr != null) {
            extractExpression(dr, callable, exprId, -1)
        }
        for(i in 0 until c.valueArgumentsCount) {
            val arg = c.getValueArgument(i)
            if(arg != null) {
                extractExpression(arg, callable, exprId, i)
            }
        }
    }

    private fun extractTypeArguments(
        c: IrFunctionAccessExpression,
        id: Label<out DbExprparent>,
        startIndex: Int = 0,
        reverse: Boolean = false
    ) {
        for (argIdx in 0 until c.typeArgumentsCount) {
            val arg = c.getTypeArgument(argIdx)!!
            val argTypeId = useType(arg, false)
            val argId = tw.getFreshIdLabel<DbUnannotatedtypeaccess>()
            val mul = if (reverse) -1 else 1
            tw.writeExprs_unannotatedtypeaccess(argId, argTypeId, id, argIdx * mul + startIndex)
        }
    }

    private fun extractConstructorCall(
        e: IrFunctionAccessExpression,
        parent: Label<out DbExprparent>,
        idx: Int,
        callable: Label<out DbCallable>
    ) {
        val id = tw.getFreshIdLabel<DbNewexpr>()
        val typeId = useType(e.type)
        val locId = tw.getLocation(e)
        val methodId = useFunction<DbConstructor>(e.symbol.owner)
        tw.writeExprs_newexpr(id, typeId, parent, idx)
        tw.writeHasLocation(id, locId)
        tw.writeCallableBinding(id, methodId)
        for (i in 0 until e.valueArgumentsCount) {
            val arg = e.getValueArgument(i)
            if (arg != null) {
                extractExpression(arg, callable, id, i)
            }
        }
        val dr = e.dispatchReceiver
        if (dr != null) {
            extractExpression(dr, callable, id, -2)
        }

        if (e.typeArgumentsCount > 0) {
            val typeAccessId = tw.getFreshIdLabel<DbUnannotatedtypeaccess>()
            tw.writeExprs_unannotatedtypeaccess(typeAccessId, typeId, id, -3)
            extractTypeArguments(e, typeAccessId)
        }
    }

    private val loopIdMap: MutableMap<IrLoop, Label<out DbKtloopstmt>> = mutableMapOf()

    private var currentFunction: IrFunction? = null

    fun extractExpression(e: IrExpression, callable: Label<out DbCallable>, parent: Label<out DbExprparent>, idx: Int) {
        when(e) {
            is IrInstanceInitializerCall -> {
                val irCallable = currentFunction
                if (irCallable == null) {
                    logger.warnElement(Severity.ErrorSevere, "Current function is not set", e)
                    return
                }

                if (irCallable is IrConstructor && irCallable.isPrimary) {
                    // Todo add parameter to field assignments
                }

                // Add call to <obinit>:
                val id = tw.getFreshIdLabel<DbMethodaccess>()
                val typeId = useType(e.type)
                val locId = tw.getLocation(e)
                var methodLabel = getFunctionLabel(irCallable.parent, "<obinit>", listOf(), e.type)
                val methodId = tw.getLabelFor<DbMethod>(methodLabel)
                tw.writeExprs_methodaccess(id, typeId, parent, idx)
                tw.writeHasLocation(id, locId)
                tw.writeCallableBinding(id, methodId)
            }
            is IrDelegatingConstructorCall -> {
                val irCallable = currentFunction
                if (irCallable == null) {
                    logger.warnElement(Severity.ErrorSevere, "Current function is not set", e)
                    return
                }

                val delegatingClass = e.symbol.owner.parent as IrClass
                val currentClass = irCallable.parent as IrClass

                val id: Label<out DbStmt>
                if (delegatingClass != currentClass) {
                    id = tw.getFreshIdLabel<DbSuperconstructorinvocationstmt>()
                    tw.writeStmts_superconstructorinvocationstmt(id, parent, idx, callable)
                } else {
                    id = tw.getFreshIdLabel<DbConstructorinvocationstmt>()
                    tw.writeStmts_constructorinvocationstmt(id, parent, idx, callable)
                }

                val locId = tw.getLocation(e)
                val methodId = useFunction<DbConstructor>(e.symbol.owner)

                tw.writeHasLocation(id, locId)
                @Suppress("UNCHECKED_CAST")
                tw.writeCallableBinding(id as Label<DbCaller>, methodId)
                for (i in 0 until e.valueArgumentsCount) {
                    val arg = e.getValueArgument(i)
                    if (arg != null) {
                        extractExpression(arg, callable, id, i)
                    }
                }
                val dr = e.dispatchReceiver
                if (dr != null) {
                    extractExpression(dr, callable, id, -1)
                }

                // todo: type arguments at index -2, -3, ...
            }
            is IrConstructorCall -> {
                extractConstructorCall(e, parent, idx, callable)
            }
            is IrEnumConstructorCall -> {
                extractConstructorCall(e, parent, idx, callable)
            }
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
        tw.writeHasLocation(id, locId)
        val label = e.label
        if (label != null) {
            tw.writeNamestrings(label, "", id)
        }

        val loopId = loopIdMap[e.loop]
        if (loopId == null) {
            logger.warnElement(Severity.ErrorSevere, "Missing break/continue target", e)
            return
        }

        tw.writeKtBreakContinueTargets(id, loopId)
    }
}

