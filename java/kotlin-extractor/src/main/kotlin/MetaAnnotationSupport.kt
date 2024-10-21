package com.github.codeql

import com.github.codeql.utils.versions.copyParameterToFunction
import com.github.codeql.utils.versions.createImplicitParameterDeclarationWithWrappedDescriptor
import com.github.codeql.utils.versions.getAnnotationType
import java.lang.annotation.ElementType
import java.util.HashSet
import org.jetbrains.kotlin.backend.common.extensions.IrPluginContext
import org.jetbrains.kotlin.builtins.StandardNames
import org.jetbrains.kotlin.config.JvmTarget
import org.jetbrains.kotlin.descriptors.ClassKind
import org.jetbrains.kotlin.descriptors.annotations.KotlinRetention
import org.jetbrains.kotlin.descriptors.annotations.KotlinTarget
import org.jetbrains.kotlin.ir.UNDEFINED_OFFSET
import org.jetbrains.kotlin.ir.builders.declarations.addConstructor
import org.jetbrains.kotlin.ir.builders.declarations.addGetter
import org.jetbrains.kotlin.ir.builders.declarations.addProperty
import org.jetbrains.kotlin.ir.builders.declarations.addValueParameter
import org.jetbrains.kotlin.ir.builders.declarations.buildClass
import org.jetbrains.kotlin.ir.builders.declarations.buildField
import org.jetbrains.kotlin.ir.declarations.IrClass
import org.jetbrains.kotlin.ir.declarations.IrConstructor
import org.jetbrains.kotlin.ir.declarations.IrDeclarationOrigin
import org.jetbrains.kotlin.ir.declarations.IrEnumEntry
import org.jetbrains.kotlin.ir.declarations.IrProperty
import org.jetbrains.kotlin.ir.expressions.IrClassReference
import org.jetbrains.kotlin.ir.expressions.IrConstructorCall
import org.jetbrains.kotlin.ir.expressions.IrGetEnumValue
import org.jetbrains.kotlin.ir.expressions.IrVararg
import org.jetbrains.kotlin.ir.expressions.impl.*
import org.jetbrains.kotlin.ir.symbols.IrClassSymbol
import org.jetbrains.kotlin.ir.types.typeWith
import org.jetbrains.kotlin.ir.util.constructedClass
import org.jetbrains.kotlin.ir.util.constructors
import org.jetbrains.kotlin.ir.util.deepCopyWithSymbols
import org.jetbrains.kotlin.ir.util.defaultType
import org.jetbrains.kotlin.ir.util.fqNameWhenAvailable
import org.jetbrains.kotlin.ir.util.getAnnotation
import org.jetbrains.kotlin.ir.util.hasAnnotation
import org.jetbrains.kotlin.ir.util.hasEqualFqName
import org.jetbrains.kotlin.ir.util.parentAsClass
import org.jetbrains.kotlin.ir.util.primaryConstructor
import org.jetbrains.kotlin.load.java.JvmAnnotationNames
import org.jetbrains.kotlin.name.FqName
import org.jetbrains.kotlin.name.Name
import org.jetbrains.kotlin.utils.addToStdlib.firstIsInstanceOrNull

class MetaAnnotationSupport(
    private val logger: FileLogger,
    private val pluginContext: IrPluginContext,
    private val extractor: KotlinFileExtractor
) {

    // Taken from AdditionalIrUtils.kt (not available in Kotlin < 1.6)
    private val IrConstructorCall.annotationClass
        get() = this.symbol.owner.constructedClass

    // Taken from AdditionalIrUtils.kt (not available in Kotlin < 1.6)
    private fun IrConstructorCall.isAnnotationWithEqualFqName(fqName: FqName): Boolean =
        annotationClass.hasEqualFqName(fqName)

    // Adapted from RepeatedAnnotationLowering.kt
    fun groupRepeatableAnnotations(annotations: List<IrConstructorCall>): List<IrConstructorCall> {
        if (annotations.size < 2) return annotations

        val annotationsByClass = annotations.groupByTo(mutableMapOf()) { it.annotationClass }
        if (annotationsByClass.values.none { it.size > 1 }) return annotations

        val result = mutableListOf<IrConstructorCall>()
        for (annotation in annotations) {
            val annotationClass = annotation.annotationClass
            val grouped = annotationsByClass.remove(annotationClass) ?: continue
            if (grouped.size < 2) {
                result.add(grouped.single())
                continue
            }

            val containerClass = getOrCreateContainerClass(annotationClass)
            if (containerClass != null)
                wrapAnnotationEntriesInContainer(annotationClass, containerClass, grouped)?.let {
                    result.add(it)
                }
            else logger.warnElement("Failed to find an annotation container class", annotationClass)
        }
        return result
    }

    // Adapted from RepeatedAnnotationLowering.kt
    private fun getOrCreateContainerClass(annotationClass: IrClass): IrClass? {
        val metaAnnotations = annotationClass.annotations
        val jvmRepeatable =
            metaAnnotations.find {
                it.symbol.owner.parentAsClass.fqNameWhenAvailable ==
                    JvmAnnotationNames.REPEATABLE_ANNOTATION
            }
        return if (jvmRepeatable != null) {
            ((jvmRepeatable.getValueArgument(0) as? IrClassReference)?.symbol as? IrClassSymbol)
                ?.owner
        } else {
            getOrCreateSyntheticRepeatableAnnotationContainer(annotationClass)
        }
    }

    // Adapted from RepeatedAnnotationLowering.kt
    private fun wrapAnnotationEntriesInContainer(
        annotationClass: IrClass,
        containerClass: IrClass,
        entries: List<IrConstructorCall>
    ): IrConstructorCall? {
        val annotationType = annotationClass.typeWith()
        val containerConstructor = containerClass.primaryConstructor
        if (containerConstructor == null) {
            logger.warnElement(
                "Expected container class to have a primary constructor",
                containerClass
            )
            return null
        } else {
            return IrConstructorCallImpl.fromSymbolOwner(
                    containerClass.defaultType,
                    containerConstructor.symbol
                )
                .apply {
                    putValueArgument(
                        0,
                        IrVarargImpl(
                            UNDEFINED_OFFSET,
                            UNDEFINED_OFFSET,
                            pluginContext.irBuiltIns.arrayClass.typeWith(annotationType),
                            annotationType,
                            entries
                        )
                    )
                }
        }
    }

    // Taken from AdditionalClassAnnotationLowering.kt
    private fun getApplicableTargetSet(c: IrClass): Set<KotlinTarget>? {
        val targetEntry = c.getAnnotation(StandardNames.FqNames.target) ?: return null
        return loadAnnotationTargets(targetEntry)
    }

    // Taken from AdditionalClassAnnotationLowering.kt
    private fun loadAnnotationTargets(targetEntry: IrConstructorCall): Set<KotlinTarget>? {
        val valueArgument = targetEntry.getValueArgument(0) as? IrVararg ?: return null
        return valueArgument.elements
            .filterIsInstance<IrGetEnumValue>()
            .mapNotNull { KotlinTarget.valueOrNull(it.symbol.owner.name.asString()) }
            .toSet()
    }

    private val javaAnnotationTargetElementType by lazy {
        extractor.referenceExternalClass("java.lang.annotation.ElementType")
    }

    private val javaAnnotationTarget by lazy {
        extractor.referenceExternalClass("java.lang.annotation.Target")
    }

    private fun findEnumEntry(c: IrClass, name: String) =
        c.declarations.filterIsInstance<IrEnumEntry>().find { it.name.asString() == name }

    // Adapted from JvmSymbols.kt
    private val jvm6TargetMap by lazy {
        javaAnnotationTargetElementType?.let {
            val etMethod = findEnumEntry(it, "METHOD")
            mapOf(
                KotlinTarget.CLASS to findEnumEntry(it, "TYPE"),
                KotlinTarget.ANNOTATION_CLASS to findEnumEntry(it, "ANNOTATION_TYPE"),
                KotlinTarget.CONSTRUCTOR to findEnumEntry(it, "CONSTRUCTOR"),
                KotlinTarget.LOCAL_VARIABLE to findEnumEntry(it, "LOCAL_VARIABLE"),
                KotlinTarget.FUNCTION to etMethod,
                KotlinTarget.PROPERTY_GETTER to etMethod,
                KotlinTarget.PROPERTY_SETTER to etMethod,
                KotlinTarget.FIELD to findEnumEntry(it, "FIELD"),
                KotlinTarget.VALUE_PARAMETER to findEnumEntry(it, "PARAMETER")
            )
        }
    }

    // Adapted from JvmSymbols.kt
    private val jvm8TargetMap by lazy {
        javaAnnotationTargetElementType?.let {
            jvm6TargetMap?.let { j6Map ->
                j6Map +
                    mapOf(
                        KotlinTarget.TYPE_PARAMETER to findEnumEntry(it, "TYPE_PARAMETER"),
                        KotlinTarget.TYPE to findEnumEntry(it, "TYPE_USE")
                    )
            }
        }
    }

    private fun getAnnotationTargetMap() =
        if (pluginContext.platform?.any { it.targetPlatformVersion == JvmTarget.JVM_1_6 } == true)
            jvm6TargetMap
        else jvm8TargetMap

    // Adapted from AdditionalClassAnnotationLowering.kt
    private fun generateTargetAnnotation(c: IrClass): IrConstructorCall? {
        if (c.hasAnnotation(JvmAnnotationNames.TARGET_ANNOTATION)) return null
        val elementType = javaAnnotationTargetElementType ?: return null
        val targetType = javaAnnotationTarget ?: return null
        val targetConstructor =
            targetType.declarations.firstIsInstanceOrNull<IrConstructor>() ?: return null
        val targets = getApplicableTargetSet(c) ?: return null
        val annotationTargetMap = getAnnotationTargetMap() ?: return null

        val javaTargets =
            targets
                .mapNotNullTo(HashSet()) { annotationTargetMap[it] }
                .sortedBy { ElementType.valueOf(it.symbol.owner.name.asString()) }
        val vararg =
            IrVarargImpl(
                UNDEFINED_OFFSET,
                UNDEFINED_OFFSET,
                type = pluginContext.irBuiltIns.arrayClass.typeWith(elementType.defaultType),
                varargElementType = elementType.defaultType
            )
        for (target in javaTargets) {
            vararg.elements.add(
                IrGetEnumValueImpl(
                    UNDEFINED_OFFSET,
                    UNDEFINED_OFFSET,
                    elementType.defaultType,
                    target.symbol
                )
            )
        }

        return IrConstructorCallImpl.fromSymbolOwner(
                UNDEFINED_OFFSET,
                UNDEFINED_OFFSET,
                targetConstructor.returnType,
                targetConstructor.symbol,
                0
            )
            .apply { putValueArgument(0, vararg) }
    }

    private val javaAnnotationRetention by lazy {
        extractor.referenceExternalClass("java.lang.annotation.Retention")
    }
    private val javaAnnotationRetentionPolicy by lazy {
        extractor.referenceExternalClass("java.lang.annotation.RetentionPolicy")
    }
    private val javaAnnotationRetentionPolicyRuntime by lazy {
        javaAnnotationRetentionPolicy?.let { findEnumEntry(it, "RUNTIME") }
    }

    private val annotationRetentionMap by lazy {
        javaAnnotationRetentionPolicy?.let {
            mapOf(
                KotlinRetention.SOURCE to findEnumEntry(it, "SOURCE"),
                KotlinRetention.BINARY to findEnumEntry(it, "CLASS"),
                KotlinRetention.RUNTIME to javaAnnotationRetentionPolicyRuntime
            )
        }
    }

    // Taken from AnnotationCodegen.kt (not available in Kotlin < 1.6.20)
    private fun IrClass.getAnnotationRetention(): KotlinRetention? {
        val retentionArgument =
            getAnnotation(StandardNames.FqNames.retention)?.getValueArgument(0) as? IrGetEnumValue
                ?: return null
        val retentionArgumentValue = retentionArgument.symbol.owner
        return KotlinRetention.valueOf(retentionArgumentValue.name.asString())
    }

    // Taken from AdditionalClassAnnotationLowering.kt
    private fun generateRetentionAnnotation(irClass: IrClass): IrConstructorCall? {
        if (irClass.hasAnnotation(JvmAnnotationNames.RETENTION_ANNOTATION)) return null
        val retentionMap = annotationRetentionMap ?: return null
        val kotlinRetentionPolicy = irClass.getAnnotationRetention()
        val javaRetentionPolicy =
            kotlinRetentionPolicy?.let { retentionMap[it] }
                ?: javaAnnotationRetentionPolicyRuntime
                ?: return null
        val retentionPolicyType = javaAnnotationRetentionPolicy ?: return null
        val retentionType = javaAnnotationRetention ?: return null
        val targetConstructor =
            retentionType.declarations.firstIsInstanceOrNull<IrConstructor>() ?: return null

        return IrConstructorCallImpl.fromSymbolOwner(
                UNDEFINED_OFFSET,
                UNDEFINED_OFFSET,
                targetConstructor.returnType,
                targetConstructor.symbol,
                0
            )
            .apply {
                putValueArgument(
                    0,
                    IrGetEnumValueImpl(
                        UNDEFINED_OFFSET,
                        UNDEFINED_OFFSET,
                        retentionPolicyType.defaultType,
                        javaRetentionPolicy.symbol
                    )
                )
            }
    }

    private val javaAnnotationRepeatable by lazy {
        extractor.referenceExternalClass("java.lang.annotation.Repeatable")
    }
    private val kotlinAnnotationRepeatableContainer by lazy {
        extractor.referenceExternalClass("kotlin.jvm.internal.RepeatableContainer")
    }

    // Taken from declarationBuilders.kt (not available in Kotlin < 1.6):
    private fun addDefaultGetter(p: IrProperty, parentClass: IrClass) {
        val field =
            p.backingField
                ?: run {
                    logger.warnElement("Expected property to have a backing field", p)
                    return
                }
        p.addGetter {
                origin = IrDeclarationOrigin.DEFAULT_PROPERTY_ACCESSOR
                returnType = field.type
            }
            .apply {
                val thisReceiever =
                    parentClass.thisReceiver
                        ?: run {
                            logger.warnElement(
                                "Expected property's parent class to have a receiver parameter",
                                parentClass
                            )
                            return
                        }
                val newParam = copyParameterToFunction(thisReceiever, this)
                dispatchReceiverParameter = newParam
                body =
                    factory
                        .createBlockBody(UNDEFINED_OFFSET, UNDEFINED_OFFSET)
                        .apply({
                            this.statements.add(
                                IrReturnImpl(
                                    UNDEFINED_OFFSET,
                                    UNDEFINED_OFFSET,
                                    pluginContext.irBuiltIns.nothingType,
                                    symbol,
                                    IrGetFieldImpl(
                                        UNDEFINED_OFFSET,
                                        UNDEFINED_OFFSET,
                                        field.symbol,
                                        field.type,
                                        IrGetValueImpl(
                                            UNDEFINED_OFFSET,
                                            UNDEFINED_OFFSET,
                                            newParam.type,
                                            newParam.symbol
                                        )
                                    )
                                )
                            )
                        })
            }
    }

    // Taken from JvmCachedDeclarations.kt
    private fun getOrCreateSyntheticRepeatableAnnotationContainer(annotationClass: IrClass) =
        extractor.globalExtensionState.syntheticRepeatableAnnotationContainers.getOrPut(
            annotationClass
        ) {
            val containerClass =
                pluginContext.irFactory
                    .buildClass {
                        kind = ClassKind.ANNOTATION_CLASS
                        name = Name.identifier("Container")
                    }
                    .apply {
                        createImplicitParameterDeclarationWithWrappedDescriptor()
                        parent = annotationClass
                        superTypes = listOf(getAnnotationType(pluginContext))
                    }

            val propertyName = Name.identifier("value")
            val propertyType =
                pluginContext.irBuiltIns.arrayClass.typeWith(annotationClass.typeWith())

            containerClass
                .addConstructor { isPrimary = true }
                .apply { addValueParameter(propertyName.identifier, propertyType) }

            containerClass
                .addProperty { name = propertyName }
                .apply property@{
                    backingField =
                        pluginContext.irFactory
                            .buildField {
                                name = propertyName
                                type = propertyType
                            }
                            .apply {
                                parent = containerClass
                                correspondingPropertySymbol = this@property.symbol
                            }
                    addDefaultGetter(this, containerClass)
                }

            val repeatableContainerAnnotation =
                kotlinAnnotationRepeatableContainer?.constructors?.single()

            containerClass.annotations =
                annotationClass.annotations
                    .filter {
                        it.isAnnotationWithEqualFqName(StandardNames.FqNames.retention) ||
                            it.isAnnotationWithEqualFqName(StandardNames.FqNames.target)
                    }
                    .map { it.deepCopyWithSymbols(containerClass) } +
                    listOfNotNull(
                        repeatableContainerAnnotation?.let {
                            IrConstructorCallImpl.fromSymbolOwner(
                                UNDEFINED_OFFSET,
                                UNDEFINED_OFFSET,
                                it.returnType,
                                it.symbol,
                                0
                            )
                        }
                    )

            containerClass
        }

    // Adapted from AdditionalClassAnnotationLowering.kt
    private fun generateRepeatableAnnotation(
        irClass: IrClass,
        extractAnnotationTypeAccesses: Boolean
    ): IrConstructorCall? {
        if (
            !irClass.hasAnnotation(StandardNames.FqNames.repeatable) ||
                irClass.hasAnnotation(JvmAnnotationNames.REPEATABLE_ANNOTATION)
        )
            return null

        val repeatableConstructor =
            javaAnnotationRepeatable?.declarations?.firstIsInstanceOrNull<IrConstructor>()
                ?: return null

        val containerClass = getOrCreateSyntheticRepeatableAnnotationContainer(irClass)
        // Whenever a repeatable annotation with a Kotlin-synthesised container is extracted,
        // extract the synthetic container to the same trap file.
        extractor.extractClassSource(
            containerClass,
            extractDeclarations = true,
            extractStaticInitializer = true,
            extractPrivateMembers = true,
            extractFunctionBodies = extractAnnotationTypeAccesses
        )

        val containerReference =
            IrClassReferenceImpl(
                UNDEFINED_OFFSET,
                UNDEFINED_OFFSET,
                pluginContext.irBuiltIns.kClassClass.typeWith(containerClass.defaultType),
                containerClass.symbol,
                containerClass.defaultType
            )
        return IrConstructorCallImpl.fromSymbolOwner(
                UNDEFINED_OFFSET,
                UNDEFINED_OFFSET,
                repeatableConstructor.returnType,
                repeatableConstructor.symbol,
                0
            )
            .apply { putValueArgument(0, containerReference) }
    }

    private val javaAnnotationDocumented by lazy {
        extractor.referenceExternalClass("java.lang.annotation.Documented")
    }

    // Taken from AdditionalClassAnnotationLowering.kt
    private fun generateDocumentedAnnotation(irClass: IrClass): IrConstructorCall? {
        if (
            !irClass.hasAnnotation(StandardNames.FqNames.mustBeDocumented) ||
                irClass.hasAnnotation(JvmAnnotationNames.DOCUMENTED_ANNOTATION)
        )
            return null

        val documentedConstructor =
            javaAnnotationDocumented?.declarations?.firstIsInstanceOrNull<IrConstructor>()
                ?: return null

        return IrConstructorCallImpl.fromSymbolOwner(
            UNDEFINED_OFFSET,
            UNDEFINED_OFFSET,
            documentedConstructor.returnType,
            documentedConstructor.symbol,
            0
        )
    }

    fun generateJavaMetaAnnotations(c: IrClass, extractAnnotationTypeAccesses: Boolean) =
        // This is essentially AdditionalClassAnnotationLowering adapted to run outside the backend.
        listOfNotNull(
            generateTargetAnnotation(c),
            generateRetentionAnnotation(c),
            generateRepeatableAnnotation(c, extractAnnotationTypeAccesses),
            generateDocumentedAnnotation(c)
        )
}
