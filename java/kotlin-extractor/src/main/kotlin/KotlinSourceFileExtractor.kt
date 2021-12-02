package com.github.codeql

import com.github.codeql.comments.CommentExtractor
import org.jetbrains.kotlin.backend.common.extensions.IrPluginContext
import org.jetbrains.kotlin.ir.declarations.IrClass
import org.jetbrains.kotlin.ir.declarations.IrFile
import org.jetbrains.kotlin.ir.expressions.IrConst
import org.jetbrains.kotlin.ir.expressions.IrConstructorCall
import org.jetbrains.kotlin.ir.types.IrSimpleType
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

    val fileClass by lazy {
        extractFileClass(file)
    }

    fun extractFileContents(id: Label<DbFile>) {
        val locId = tw.getWholeFileLocation()
        val pkg = file.fqName.asString()
        val pkgId = extractPackage(pkg)
        tw.writeHasLocation(id, locId)
        tw.writeCupackage(id, pkgId)
        // TODO: Use of fileClass looks like it will defeat laziness since 3502e5c5720e981c913bdafdccf7f5e9237be070
        // TODO: Fix, then reenable consistency-queries/file_classes.ql
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
      tw.writeFile_class(id)
      tw.writeHasLocation(id, locId)
      return id
  }

}
