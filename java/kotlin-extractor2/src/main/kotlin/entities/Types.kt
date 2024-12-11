package com.github.codeql

import com.github.codeql.entities.getTypeParameterLabel
import org.jetbrains.kotlin.analysis.api.KaSession
import org.jetbrains.kotlin.analysis.api.components.DefaultTypeClassIds
import org.jetbrains.kotlin.analysis.api.symbols.KaClassSymbol
import org.jetbrains.kotlin.analysis.api.symbols.KaFunctionSymbol
import org.jetbrains.kotlin.analysis.api.symbols.KaTypeParameterSymbol
import org.jetbrains.kotlin.analysis.api.types.*

context(KaSession)
private fun KotlinUsesExtractor.useClassType(
    c: KaClassType
): TypeResults {
    // TODO: this cast is unsafe; .symbol is actually a KaClassLikeSymbol
    val javaResult = addClassLabel(c.symbol as KaClassSymbol, c.qualifiers.map { it.typeArguments })
    val kotlinTypeId =
        tw.getLabelFor<DbKt_class_type>("@\"kt_class;{${javaResult.id}}\"") {
            tw.writeKt_class_types(it, javaResult.id)
        }
    val kotlinResult = TypeResult(kotlinTypeId /* , "TODO"*/, "TODO")
    return TypeResults(javaResult, kotlinResult)
}

context(KaSession)
fun KotlinUsesExtractor.getTypeParameterParentLabel(param: KaTypeParameterSymbol) =
    param.containingSymbol?.let {
        when (it) {
            is KaClassSymbol -> useClassSource(it)
            is KaFunctionSymbol ->
                /* OLD: KE1
                (if (this is KotlinFileExtractor)
                    this.declarationStack
                        .findOverriddenAttributes(it)
                        ?.takeUnless {
                            // When extracting the `static fun f$default(...)` that accompanies
                            // `fun <T> f(val x: T? = defaultExpr, ...)`,
                            // `f$default` has no type parameters, and so there is no
                            // `f$default::T` to refer to.
                            // We have no good way to extract references to `T` in
                            // `defaultExpr`, so we just fall back on describing it
                            // in terms of `f::T`, even though that type variable ought to be
                            // out of scope here.
                                attribs ->
                            attribs.typeParameters?.isEmpty() == true
                        }
                        ?.id
                else null) ?:
                */
                useFunction(it, useDeclarationParentOf(it, true) ?: TODO(), listOf(),  /* OLD: KE1 noReplace = true */)
            else -> {
                logger.error("Unexpected type parameter parent $it")
                null
            }
        }
    }

context(KaSession)
private fun KotlinUsesExtractor.useTypeParameterType(param: KaTypeParameterType) =
    getTypeParameterLabel(param.symbol)?.let {
        TypeResult(
            tw.getLabelFor<DbTypevariable>(it),
            /* OLD: KE1
            useType(eraseTypeParameter(param)).javaResult.signature,
             */
            param.name.asString()
        )
    } ?: extractErrorType()

context(KaSession)
fun KotlinUsesExtractor.useType(t: KaType?, context: TypeContext = TypeContext.OTHER): TypeResults {
    val tr = when (t) {
        null -> {
            logger.error("Unexpected null type")
            return extractErrorType()
        }
        is KaClassType -> useClassType(t)
        is KaFlexibleType -> useType(t.lowerBound) // TODO: take a more reasoned choice here
        is KaTypeParameterType -> TypeResults(useTypeParameterType(t), extractErrorType().kotlinResult /* TODO */)
        else -> TODO()
    }
    val javaResult = tr.javaResult
    val kotlinResultBase = tr.kotlinResult
    val abbreviation = t.abbreviatedType
    val kotlinResultAlias = if (abbreviation == null) kotlinResultBase else {
                                // TODO: this cast is unsafe; .symbol is actually a KaClassLikeSymbol
                                val classId = addClassLabel(abbreviation.symbol as KaClassSymbol, listOf<Nothing>() /* TODO */)
                                val kotlinBaseTypeId = kotlinResultBase.id
                                val kotlinAliasTypeId =
                                    tw.getLabelFor<DbKt_type_alias>("@\"kt_type_alias;{$classId};{$kotlinBaseTypeId}\"") {
                                        tw.writeKt_type_aliases(it, classId.id, kotlinBaseTypeId)
                                    }
                                TypeResult(kotlinAliasTypeId , "TODO"/*, "TODO" */)
                            }
    val kotlinResultNullability = if (t.nullability.isNullable) {
                                      val kotlinAliasTypeId = kotlinResultAlias.id
                                      val kotlinNullableTypeId =
                                          tw.getLabelFor<DbKt_nullable_type>("@\"kt_nullable_type;{$kotlinAliasTypeId}\"") {
                                              tw.writeKt_nullable_types(it, kotlinAliasTypeId)
                                          }
                                      TypeResult(kotlinNullableTypeId, "TODO", /* "TODO" */)
                                  } else kotlinResultAlias
    return TypeResults(javaResult, kotlinResultNullability)
}

fun KotlinUsesExtractor.extractJavaErrorType(): TypeResult<DbErrortype> {
    val typeId = tw.getLabelFor<DbErrortype>("@\"errorType\"") { tw.writeError_type(it) }
    return TypeResult(typeId, /* TODO , */ "<CodeQL error type>")
}

private fun KotlinUsesExtractor.extractErrorType(): TypeResults {
    val javaResult = extractJavaErrorType()
    val kotlinTypeId =
        tw.getLabelFor<DbKt_error_type>("@\"errorKotlinType\"") {
            tw.writeKt_error_types(it)
        }
    return TypeResults(
        javaResult,
        TypeResult(kotlinTypeId, /* TODO, */"<CodeQL error type>")
    )
}

/*
OLD: KE1
    // `args` can be null to describe a raw generic type.
    // For non-generic types it will be zero-length list.
    fun useSimpleTypeClass(
        c: IrClass,
        args: List<IrTypeArgument>?,
        hasQuestionMark: Boolean
    ): TypeResults {
        val classInstanceResult = useClassInstance(c, args)
        val javaClassId = classInstanceResult.typeResult.id
        val kotlinQualClassName = getUnquotedClassLabel(c, args).classLabel
        val javaResult = classInstanceResult.typeResult
        val kotlinResult =
            if (true) TypeResult(fakeKotlinType(), "TODO", "TODO")
            else if (hasQuestionMark) {
                val kotlinSignature = "$kotlinQualClassName?" // TODO: Is this right?
                val kotlinLabel = "@\"kt_type;nullable;$kotlinQualClassName\""
                val kotlinId: Label<DbKt_nullable_type> =
                    tw.getLabelFor(kotlinLabel, { tw.writeKt_nullable_types(it, javaClassId) })
                TypeResult(kotlinId, kotlinSignature, "TODO")
            } else {
                val kotlinSignature = kotlinQualClassName // TODO: Is this right?
                val kotlinLabel = "@\"kt_type;notnull;$kotlinQualClassName\""
                val kotlinId: Label<DbKt_notnull_type> =
                    tw.getLabelFor(kotlinLabel, { tw.writeKt_notnull_types(it, javaClassId) })
                TypeResult(kotlinId, kotlinSignature, "TODO")
            }
        return TypeResults(javaResult, kotlinResult)
    }
*/

enum class TypeContext {
    RETURN,
    GENERIC_ARGUMENT,
    OTHER
}

/*
OLD: KE1
    private fun useSimpleType(s: IrSimpleType, context: TypeContext): TypeResults {
        if (s.abbreviation != null) {
            // TODO: Extract this information
        }
        // We use this when we don't actually have an IrClass for a class
        // we want to refer to
        // TODO: Eliminate the need for this if possible
        fun makeClass(pkgName: String, className: String): Label<DbClassorinterface> {
            val pkgId = extractPackage(pkgName)
            val label = "@\"class;$pkgName.$className\""
            val classId: Label<DbClassorinterface> =
                tw.getLabelFor(label, { tw.writeClasses_or_interfaces(it, className, pkgId, it) })
            return classId
        }
        fun primitiveType(
            kotlinClass: IrClass,
            primitiveName: String?,
            otherIsPrimitive: Boolean,
            javaClass: IrClass,
            kotlinPackageName: String,
            kotlinClassName: String
        ): TypeResults {
            // Note the use of `hasEnhancedNullability` here covers cases like `@NotNull Integer`,
            // which must be extracted as `Integer` not `int`.
            val javaResult =
                if (
                    (context == TypeContext.RETURN ||
                        (context == TypeContext.OTHER && otherIsPrimitive)) &&
                        !s.isNullable() &&
                        getKotlinType(s)?.hasEnhancedNullability() != true &&
                        primitiveName != null
                ) {
                    val label: Label<DbPrimitive> =
                        tw.getLabelFor(
                            "@\"type;$primitiveName\"",
                            { tw.writePrimitives(it, primitiveName) }
                        )
                    TypeResult(label, primitiveName, primitiveName)
                } else {
                    addClassLabel(javaClass, listOf())
                }
            val kotlinClassId = useClassInstance(kotlinClass, listOf()).typeResult.id
            val kotlinResult =
                if (true) TypeResult(fakeKotlinType(), "TODO", "TODO")
                else if (s.isNullable()) {
                    val kotlinSignature =
                        "$kotlinPackageName.$kotlinClassName?" // TODO: Is this right?
                    val kotlinLabel = "@\"kt_type;nullable;$kotlinPackageName.$kotlinClassName\""
                    val kotlinId: Label<DbKt_nullable_type> =
                        tw.getLabelFor(
                            kotlinLabel,
                            { tw.writeKt_nullable_types(it, kotlinClassId) }
                        )
                    TypeResult(kotlinId, kotlinSignature, "TODO")
                } else {
                    val kotlinSignature =
                        "$kotlinPackageName.$kotlinClassName" // TODO: Is this right?
                    val kotlinLabel = "@\"kt_type;notnull;$kotlinPackageName.$kotlinClassName\""
                    val kotlinId: Label<DbKt_notnull_type> =
                        tw.getLabelFor(kotlinLabel, { tw.writeKt_notnull_types(it, kotlinClassId) })
                    TypeResult(kotlinId, kotlinSignature, "TODO")
                }
            return TypeResults(javaResult, kotlinResult)
        }

        val owner = s.classifier.owner
        val primitiveInfo = primitiveTypeMapping.getPrimitiveInfo(s)

        when {
            primitiveInfo != null -> {
                if (owner is IrClass) {
                    return primitiveType(
                        owner,
                        primitiveInfo.primitiveName,
                        primitiveInfo.otherIsPrimitive,
                        primitiveInfo.javaClass,
                        primitiveInfo.kotlinPackageName,
                        primitiveInfo.kotlinClassName
                    )
                } else {
                    logger.error(
                        "Got primitive info for non-class (${owner.javaClass}) for ${s.render()}"
                    )
                    return extractErrorType()
                }
            }
            (s.isBoxedArray && s.arguments.isNotEmpty()) || s.isPrimitiveArray() -> {
                val arrayInfo = useArrayType(s, false)
                return arrayInfo.componentTypeResults
            }
            owner is IrClass -> {
                val args = if (s.isRawType()) null else s.arguments

                return useSimpleTypeClass(owner, args, s.isNullable())
            }
            owner is IrTypeParameter -> {
                val javaResult = useTypeParameter(owner)
                val aClassId = makeClass("kotlin", "TypeParam") // TODO: Wrong
                val kotlinResult =
                    if (true) TypeResult(fakeKotlinType(), "TODO", "TODO")
                    else if (s.isNullable()) {
                        val kotlinSignature = "${javaResult.signature}?" // TODO: Wrong
                        val kotlinLabel = "@\"kt_type;nullable;type_param\"" // TODO: Wrong
                        val kotlinId: Label<DbKt_nullable_type> =
                            tw.getLabelFor(kotlinLabel, { tw.writeKt_nullable_types(it, aClassId) })
                        TypeResult(kotlinId, kotlinSignature, "TODO")
                    } else {
                        val kotlinSignature = javaResult.signature // TODO: Wrong
                        val kotlinLabel = "@\"kt_type;notnull;type_param\"" // TODO: Wrong
                        val kotlinId: Label<DbKt_notnull_type> =
                            tw.getLabelFor(kotlinLabel, { tw.writeKt_notnull_types(it, aClassId) })
                        TypeResult(kotlinId, kotlinSignature, "TODO")
                    }
                return TypeResults(javaResult, kotlinResult)
            }
            else -> {
                logger.error("Unrecognised IrSimpleType: " + s.javaClass + ": " + s.render())
                return extractErrorType()
            }
        }
    }
*/

/**
 * Returns `t` with generic types replaced by raw types, and type parameters replaced by their first bound.
 *
 * Note that `Array<T>` is retained (with `T` itself erased) because these are expected to be lowered to Java arrays,
 * which are not generic.
 */
context(KaSession)
fun erase(t: KaType): KaType =
    when (t) {
        is KaTypeParameterType -> erase(t.symbol.upperBounds.getOrElse(0) { buildClassType(DefaultTypeClassIds.ANY) })
        is KaClassType -> buildClassType(t.classId)
        is KaFlexibleType -> erase(t.lowerBound) // TODO: Check this -- see also useType's treatment of flexible types.
        else -> t
    }
/* OLD: KE1 -- note might need to restore creation of a RAW type
    when (val sym = t.symbol) {
        is KaTypeParameterSymbol -> erase(sym.upperBounds[0])
        is KaClassSymbol -> {
            buildClassType()
        }

        if (owner is IrClass) {
            if (t.isBoxedArray) {
                val elementType = t.getArrayElementType(pluginContext.irBuiltIns)
                val erasedElementType = erase(elementType)
                return owner
                    .typeWith(erasedElementType)
                    .codeQlWithHasQuestionMark(t.isNullable())
            }

            return if (t.arguments.isNotEmpty())
                t.addAnnotations(listOf(RawTypeAnnotation.annotationConstructor))
            else t
        }
    }
    return t
}

private fun eraseTypeParameter(t: KaTypeParameterSymbol) = erase(t.upperBounds[0])
*/