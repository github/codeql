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
    pluginContext: IrPluginContext,
    genericSpecialisationsExtracted: MutableSet<String>
) :
  KotlinFileExtractor(logger, tw, null, externalClassExtractor, primitiveTypeMapping, pluginContext, genericSpecialisationsExtracted) {

    fun extractFileContents(id: Label<DbFile>) {
        val locId = tw.getWholeFileLocation()
        val pkg = file.fqName.asString()
        val pkgId = extractPackage(pkg)
        tw.writeHasLocation(id, locId)
        tw.writeCupackage(id, pkgId)
        file.declarations.map { extractDeclaration(it) }
        CommentExtractor(this).extract()
    }
}
