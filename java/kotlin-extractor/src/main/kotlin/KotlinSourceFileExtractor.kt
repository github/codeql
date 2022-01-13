package com.github.codeql

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
    val filePath: String,
    externalClassExtractor: ExternalClassExtractor,
    primitiveTypeMapping: PrimitiveTypeMapping,
    pluginContext: IrPluginContext,
    genericSpecialisationsExtracted: MutableSet<String>
) :
  KotlinFileExtractor(logger, tw, null, externalClassExtractor, primitiveTypeMapping, pluginContext, genericSpecialisationsExtracted) {
}
