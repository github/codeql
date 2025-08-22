package com.github.codeql.utils

import com.github.codeql.KotlinUsesExtractor
import com.github.codeql.Logger
import com.github.codeql.getJavaEquivalentClassId
import com.github.codeql.utils.versions.codeQlWithHasQuestionMark
import com.github.codeql.utils.versions.createImplicitParameterDeclarationWithWrappedDescriptor
import com.github.codeql.utils.versions.*
import org.jetbrains.kotlin.backend.common.extensions.IrPluginContext
import org.jetbrains.kotlin.descriptors.ClassKind
import org.jetbrains.kotlin.ir.builders.declarations.addConstructor
import org.jetbrains.kotlin.ir.builders.declarations.buildClass
import org.jetbrains.kotlin.ir.declarations.IrClass
import org.jetbrains.kotlin.ir.declarations.IrTypeParameter
import org.jetbrains.kotlin.ir.declarations.IrTypeParametersContainer
import org.jetbrains.kotlin.ir.declarations.impl.IrExternalPackageFragmentImpl
import org.jetbrains.kotlin.ir.declarations.impl.IrFactoryImpl
import org.jetbrains.kotlin.ir.expressions.IrConstructorCall
import org.jetbrains.kotlin.ir.expressions.impl.*
import org.jetbrains.kotlin.ir.symbols.IrTypeParameterSymbol
import org.jetbrains.kotlin.ir.symbols.impl.DescriptorlessExternalPackageFragmentSymbol
import org.jetbrains.kotlin.ir.types.addAnnotations
import org.jetbrains.kotlin.ir.types.classifierOrNull
import org.jetbrains.kotlin.ir.types.typeWith
import org.jetbrains.kotlin.ir.types.IrSimpleType
import org.jetbrains.kotlin.ir.types.IrStarProjection
import org.jetbrains.kotlin.ir.types.IrType
import org.jetbrains.kotlin.ir.types.IrTypeArgument
import org.jetbrains.kotlin.ir.types.IrTypeProjection
import org.jetbrains.kotlin.ir.types.impl.IrSimpleTypeImpl
import org.jetbrains.kotlin.ir.types.impl.IrStarProjectionImpl
import org.jetbrains.kotlin.ir.types.impl.makeTypeProjection
import org.jetbrains.kotlin.ir.util.*
import org.jetbrains.kotlin.name.FqName
import org.jetbrains.kotlin.name.Name
import org.jetbrains.kotlin.types.Variance
import org.jetbrains.kotlin.utils.addToStdlib.firstIsInstanceOrNull

fun IrType.substituteTypeArguments(params: List<IrTypeParameter>, arguments: List<IrTypeArgument>) =
    when (this) {
        is IrSimpleType -> substituteTypeArguments(params.map { it.symbol }.zip(arguments).toMap())
        else -> this
    }

private fun IrSimpleType.substituteTypeArguments(
    substitutionMap: Map<IrTypeParameterSymbol, IrTypeArgument>
): IrSimpleType {
    if (substitutionMap.isEmpty()) return this

    val newArguments =
        arguments.map {
            if (it is IrTypeProjection) {
                val itType = it.type
                if (itType is IrSimpleType) {
                    subProjectedType(substitutionMap, itType, it.variance)
                } else {
                    it
                }
            } else {
                it
            }
        }

    return IrSimpleTypeImpl(classifier, isNullableCodeQL(), newArguments, annotations)
}

/**
 * Returns true if substituting `innerVariance T` into the context `outerVariance []` discards all
 * knowledge about what T could be.
 *
 * Note this throws away slightly more information than it could: for example, the projection "in
 * (out List)" can refer to any superclass of anything that implements List, which specifically
 * excludes e.g. String, but can't be represented as a type projection. The projection "out (in
 * List)" on the other hand really is equivalent to "out Any?", which is to say no bound at all.
 */
private fun conflictingVariance(outerVariance: Variance, innerVariance: Variance) =
    (outerVariance == Variance.IN_VARIANCE && innerVariance == Variance.OUT_VARIANCE) ||
        (outerVariance == Variance.OUT_VARIANCE && innerVariance == Variance.IN_VARIANCE)

/**
 * When substituting `innerVariance T` into the context `outerVariance []`, returns the variance
 * part of the result `resultVariance T`. We already know they don't conflict.
 */
private fun combineVariance(outerVariance: Variance, innerVariance: Variance) =
    when {
        outerVariance != Variance.INVARIANT -> outerVariance
        innerVariance != Variance.INVARIANT -> innerVariance
        else -> Variance.INVARIANT
    }

private fun subProjectedType(
    substitutionMap: Map<IrTypeParameterSymbol, IrTypeArgument>,
    t: IrSimpleType,
    outerVariance: Variance
): IrTypeArgument =
    substitutionMap[t.classifier]?.let { substitutedTypeArg ->
        if (substitutedTypeArg is IrTypeProjection) {
            if (conflictingVariance(outerVariance, substitutedTypeArg.variance))
                IrStarProjectionImpl
            else {
                val newProjectedType =
                    substitutedTypeArg.type.let {
                        if (t.isNullableCodeQL()) it.codeQlWithHasQuestionMark(true) else it
                    }
                val newVariance = combineVariance(outerVariance, substitutedTypeArg.variance)
                makeTypeProjection(newProjectedType, newVariance)
            }
        } else {
            substitutedTypeArg
        }
    } ?: makeTypeProjection(t.substituteTypeArguments(substitutionMap), outerVariance)

private fun IrTypeArgument.upperBound(context: IrPluginContext) =
    when (this) {
        is IrStarProjection -> context.irBuiltIns.anyNType
        is IrTypeProjection ->
            when (this.variance) {
                Variance.INVARIANT -> this.type
                Variance.IN_VARIANCE ->
                    if (this.type.isNullableCodeQL()) context.irBuiltIns.anyNType
                    else context.irBuiltIns.anyType
                Variance.OUT_VARIANCE -> this.type
            }
        else -> context.irBuiltIns.anyNType
    }

private fun IrTypeArgument.lowerBound(context: IrPluginContext) =
    when (this) {
        is IrStarProjection -> context.irBuiltIns.nothingType
        is IrTypeProjection ->
            when (this.variance) {
                Variance.INVARIANT -> this.type
                Variance.IN_VARIANCE -> this.type
                Variance.OUT_VARIANCE ->
                    if (this.type.isNullableCodeQL()) context.irBuiltIns.nothingNType
                    else context.irBuiltIns.nothingType
            }
        else -> context.irBuiltIns.nothingType
    }

fun IrType.substituteTypeAndArguments(
    substitutionMap: Map<IrTypeParameterSymbol, IrTypeArgument>?,
    useContext: KotlinUsesExtractor.TypeContext,
    pluginContext: IrPluginContext
): IrType =
    substitutionMap?.let { substMap ->
        if (this is IrSimpleType) {
            val typeClassifier = this.classifier
            substMap[typeClassifier]?.let {
                when (useContext) {
                    KotlinUsesExtractor.TypeContext.RETURN -> it.upperBound(pluginContext)
                    else -> it.lowerBound(pluginContext)
                }
            } ?: this.substituteTypeArguments(substMap)
        } else {
            this
        }
    } ?: this

object RawTypeAnnotation {
    // Much of this is taken from JvmGeneratorExtensionsImpl.kt, which is not easily accessible in
    // plugin context.
    // The constants "kotlin.internal.ir" and "RawType" could be referred to symbolically, but they
    // move package
    // between different versions of the Kotlin compiler.
    val annotationConstructor: IrConstructorCall by lazy {
        val irInternalPackage = FqName("kotlin.internal.ir")
        val parent =
            IrExternalPackageFragmentImpl(
                DescriptorlessExternalPackageFragmentSymbol(),
                irInternalPackage
            )
        val annoClass =
            IrFactoryImpl.buildClass {
                    kind = ClassKind.ANNOTATION_CLASS
                    name = irInternalPackage.child(Name.identifier("RawType")).shortName()
                }
                .apply {
                    createImplicitParameterDeclarationWithWrappedDescriptor()
                    this.parent = parent
                    addConstructor { isPrimary = true }
                }
        val constructor = annoClass.constructors.single()
        IrConstructorCallImpl.fromSymbolOwner(constructor.constructedClassType, constructor.symbol)
    }
}

fun IrType.toRawType(): IrType =
    when (this) {
        is IrSimpleType -> {
            when (val owner = this.classifier.owner) {
                is IrClass -> {
                    if (this.arguments.isNotEmpty())
                        this.addAnnotations(listOf(RawTypeAnnotation.annotationConstructor))
                    else this
                }
                is IrTypeParameter -> owner.superTypes[0].toRawType()
                else -> this
            }
        }
        else -> this
    }

fun IrClass.toRawType(): IrType {
    val result = this.typeWith(listOf())
    return if (this.typeParameters.isNotEmpty())
        result.addAnnotations(listOf(RawTypeAnnotation.annotationConstructor))
    else result
}

fun IrTypeArgument.withQuestionMark(b: Boolean): IrTypeArgument =
    when (this) {
        is IrStarProjection -> this
        is IrTypeProjection ->
            this.type.let {
                when (it) {
                    is IrSimpleType ->
                        if (it.isNullableCodeQL() == b) this
                        else makeTypeProjection(it.codeQlWithHasQuestionMark(b), this.variance)
                    else -> this
                }
            }
        else -> this
    }

typealias TypeSubstitution = (IrType, KotlinUsesExtractor.TypeContext, IrPluginContext) -> IrType

private fun matchingTypeParameters(l: IrTypeParameter?, r: IrTypeParameter): Boolean {
    if (l === r) return true
    if (l == null) return false
    // Special case: match List's E and MutableList's E, for example, because in the JVM lowering
    // they will map to the same thing.
    val lParent = l.parent as? IrClass ?: return false
    val rParent = r.parent as? IrClass ?: return false
    val lJavaId = getJavaEquivalentClassId(lParent) ?: lParent.classId
    return (getJavaEquivalentClassId(rParent) ?: rParent.classId) == lJavaId && l.name == r.name
}

// Returns true if type is C<T1, T2, ...> where C is declared `class C<T1, T2, ...> { ... }`
fun isUnspecialised(
    paramsContainer: IrTypeParametersContainer,
    args: List<IrTypeArgument>,
    logger: Logger
): Boolean {
    return isUnspecialised(paramsContainer, args, logger, paramsContainer)
}

private fun isUnspecialised(
    paramsContainer: IrTypeParametersContainer,
    args: List<IrTypeArgument>,
    logger: Logger,
    origParamsContainer: IrTypeParametersContainer
): Boolean {
    val unspecialisedHere =
        paramsContainer.typeParameters.zip(args).all { paramAndArg ->
            (paramAndArg.second as? IrTypeProjection)?.let {
                // Type arg refers to the class' own type parameter?
                it.variance == Variance.INVARIANT &&
                    matchingTypeParameters(
                        it.type.classifierOrNull?.owner as? IrTypeParameter,
                        paramAndArg.first
                    )
            } ?: false
        }
    val remainingArgs = args.drop(paramsContainer.typeParameters.size)

    val parentTypeContainer =
        paramsContainer.parents.firstIsInstanceOrNull<IrTypeParametersContainer>()

    val parentUnspecialised =
        when {
            remainingArgs.isEmpty() -> true
            parentTypeContainer == null -> {
                logger.error(
                    "Found more type arguments than parameters: ${origParamsContainer.kotlinFqName.asString()}"
                )
                false
            }
            else -> isUnspecialised(parentTypeContainer, remainingArgs, logger, origParamsContainer)
        }
    return unspecialisedHere && parentUnspecialised
}

// Returns true if type is C<T1, T2, ...> where C is declared `class C<T1, T2, ...> { ... }`
fun isUnspecialised(type: IrSimpleType, logger: Logger) =
    (type.classifier.owner as? IrClass)?.let { isUnspecialised(it, type.arguments, logger) }
        ?: false
