package com.github.codeql

import com.github.codeql.comments.CommentExtractor
import org.jetbrains.kotlin.backend.common.extensions.IrPluginContext
import org.jetbrains.kotlin.ir.IrElement
import org.jetbrains.kotlin.ir.declarations.IrClass
import org.jetbrains.kotlin.ir.declarations.IrFile
import org.jetbrains.kotlin.ir.declarations.IrFunction
import org.jetbrains.kotlin.ir.expressions.IrConst
import org.jetbrains.kotlin.ir.expressions.IrConstructorCall
import org.jetbrains.kotlin.ir.symbols.IrConstructorSymbol
import org.jetbrains.kotlin.ir.types.IrSimpleType
import org.jetbrains.kotlin.ir.types.IrType
import org.jetbrains.kotlin.ir.types.classOrNull
import org.jetbrains.kotlin.ir.util.packageFqName
import org.jetbrains.kotlin.ir.util.IdSignature

// TODO: Is a separate class for this, vs KotlinFileExtractor, useful?
class KotlinSourceFileExtractor(
    logger: FileLogger,
    tw: FileTrapWriter,
    val file: IrFile,
    externalClassExtractor: ExternalClassExtractor,
    primitiveTypeMapping: PrimitiveTypeMapping,
    pluginContext: IrPluginContext
) :
  KotlinFileExtractor(logger, tw, null, externalClassExtractor, primitiveTypeMapping, pluginContext) {

    init {
        if (!stateCache.containsKey(file)){
            stateCache[file] = SourceFileExtractionState()
        }
    }

    data class SourceFileExtractionState(val anonymousTypeMap: MutableMap<IrClass, TypeResults> = mutableMapOf(),
                                         val generatedLocalFunctionTypeMap: MutableMap<IrFunction, LocalFunctionLabels> = mutableMapOf())

    companion object {
        private val stateCache: MutableMap<IrFile, SourceFileExtractionState> = mutableMapOf()
    }

    private val fileExtractionState by lazy {
        stateCache[file]!!
    }

    private val fileClass by lazy {
        extractFileClass(file)
    }

    fun extractFileContents(id: Label<DbFile>) {
        val locId = tw.getWholeFileLocation()
        val pkg = file.fqName.asString()
        val pkgId = extractPackage(pkg)
        tw.writeHasLocation(id, locId)
        tw.writeCupackage(id, pkgId)
        // TODO: Use of fileClass looks like it will defeat laziness since 3502e5c5720e981c913bdafdccf7f5e9237be070
        // TODO: Consistency query for unused file classes
        file.declarations.map { extractDeclaration(it, fileClass) }
        CommentExtractor(this).extract()
    }

  @OptIn(kotlin.ExperimentalStdlibApi::class) // Annotation required by kotlin versions < 1.5
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
      val locId = tw.getWholeFileLocation()
      val pkgId = extractPackage(pkg)
      tw.writeClasses(id, jvmName, pkgId, id)
      tw.writeHasLocation(id, locId)
      return id
  }

    fun useAnonymousClass(c: IrClass): TypeResults {
        var res = fileExtractionState.anonymousTypeMap[c]
        if (res == null) {
            val javaResult = TypeResult(tw.getFreshIdLabel<DbClass>(), "", "")
            val kotlinResult = TypeResult(tw.getFreshIdLabel<DbKt_notnull_type>(), "", "")
            tw.writeKt_notnull_types(kotlinResult.id, javaResult.id)
            res = TypeResults(javaResult, kotlinResult)
            fileExtractionState.anonymousTypeMap[c] = res
        }

        return res
    }

    data class LocalFunctionLabels(val type: TypeResults, val constructor: Label<DbConstructor>, val function: Label<DbMethod>)

    fun getLocalFunctionLabels(f: IrFunction): LocalFunctionLabels {
        if (!f.isLocalFunction()){
            logger.warnElement(Severity.ErrorSevere, "Extracting a non-local function as a local one", f)
        }

        var res = fileExtractionState.generatedLocalFunctionTypeMap[f]
        if (res == null) {
            val javaResult = TypeResult(tw.getFreshIdLabel<DbClass>(), "", "")
            val kotlinResult = TypeResult(tw.getFreshIdLabel<DbKt_notnull_type>(), "", "")
            tw.writeKt_notnull_types(kotlinResult.id, javaResult.id)
            res = LocalFunctionLabels(
                TypeResults(javaResult, kotlinResult),
                tw.getFreshIdLabel(),
                tw.getFreshIdLabel())
            fileExtractionState.generatedLocalFunctionTypeMap[f] = res
        }

        return res
    }

    fun extractGeneratedClass(localFunction: IrFunction, superTypes: List<IrType>) : Label<out DbClass> {
        val ids = getLocalFunctionLabels(localFunction)

        // Write class
        @Suppress("UNCHECKED_CAST")
        val id = ids.type.javaResult.id as Label<out DbClass>
        val pkgId = extractPackage("")
        tw.writeClasses(id, "", pkgId, id)
        val locId = tw.getLocation(localFunction)
        tw.writeHasLocation(id, locId)

        // Extract local function as a member
        extractFunction(localFunction, id)

        // Extract constructor
        tw.writeConstrs(ids.constructor, "", "", ids.type.javaResult.id, ids.type.kotlinResult.id, id, ids.constructor)
        tw.writeHasLocation(ids.constructor, locId)

        // Constructor body
        val constructorBlockId = tw.getFreshIdLabel<DbBlock>()
        tw.writeStmts_block(constructorBlockId, ids.constructor, 0, ids.constructor)
        tw.writeHasLocation(constructorBlockId, locId)

        // Super call
        val superCallId = tw.getFreshIdLabel<DbSuperconstructorinvocationstmt>()
        tw.writeStmts_superconstructorinvocationstmt(superCallId, constructorBlockId, 0, ids.function)

        val baseConstructor = superTypes.first().classOrNull!!.owner.declarations.find { it is IrFunction && it.symbol is IrConstructorSymbol }
        val baseConstructorId = useFunction<DbConstructor>(baseConstructor as IrFunction)

        tw.writeHasLocation(superCallId, locId)
        @Suppress("UNCHECKED_CAST")
        tw.writeCallableBinding(superCallId as Label<DbCaller>, baseConstructorId)

        // TODO: We might need to add an `<obinit>` function, and a call to it to match other classes

        addModifiers(id, "public", "static", "final")
        extractClassSupertypes(superTypes, listOf(), id)

        return id
    }

    fun extractAnonymousClassStmt(c: IrClass, callable: Label<out DbCallable>, parent: Label<out DbStmtparent>, idx: Int) {
        @Suppress("UNCHECKED_CAST")
        val id = extractClassSource(c) as Label<out DbClass>
        extractAnonymousClassStmt(id, c, callable, parent, idx)
    }

    fun extractAnonymousClassStmt(id: Label<out DbClass>, locElement: IrElement, callable: Label<out DbCallable>, parent: Label<out DbStmtparent>, idx: Int) {
        val stmtId = tw.getFreshIdLabel<DbAnonymousclassdeclstmt>()
        tw.writeStmts_anonymousclassdeclstmt(stmtId, parent, idx, callable)
        tw.writeKtAnonymousClassDeclarationStmts(stmtId, id)
        val locId = tw.getLocation(locElement)
        tw.writeHasLocation(stmtId, locId)
    }
}
