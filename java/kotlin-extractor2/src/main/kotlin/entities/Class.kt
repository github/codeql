package com.github.codeql

import com.github.codeql.KotlinUsesExtractor.ClassLabelResults
import com.github.codeql.utils.isInterfaceLike
import org.jetbrains.kotlin.analysis.api.KaExperimentalApi
import org.jetbrains.kotlin.analysis.api.KaSession
import org.jetbrains.kotlin.analysis.api.symbols.*
import org.jetbrains.kotlin.analysis.api.types.KaClassType
import org.jetbrains.kotlin.psi.KtElement

context(KaSession)
@OptIn(KaExperimentalApi::class)
fun KotlinFileExtractor.extractClassSource(
    c: KaClassSymbol,
    extractDeclarations: Boolean,
    /*
    OLD: KE1
    extractStaticInitializer: Boolean,
    extractPrivateMembers: Boolean,
    extractFunctionBodies: Boolean
     */
): Label<out DbClassorinterface> {
    with("class source", c) {
        // OLD: KE1: DeclarationStackAdjuster(c).use {
            val id = useClassSource(c)
            val pkg = c.classId?.packageFqName?.asString() ?: ""
            val cls =
                if (c.classKind == KaClassKind.ANONYMOUS_OBJECT) "" else c.name!!.asString() // TODO: Remove !!
            val pkgId = extractPackage(pkg)
            tw.writeClasses_or_interfaces(id, cls, pkgId, id)
            if (c.isInterfaceLike) {
                tw.writeIsInterface(id)
                if (c.classKind == KaClassKind.ANNOTATION_CLASS) {
                    tw.writeIsAnnotType(id)
                }
            } else {
                val kind = c.classKind
                if (kind == KaClassKind.ENUM_CLASS) {
                    tw.writeIsEnumType(id)
                } else if (
                    kind != KaClassKind.CLASS &&
                    kind != KaClassKind.OBJECT //&&
                //OLD KE1: kind != ClassKind.ENUM_ENTRY
                ) else {
                    c.psiSafe<KtElement>().let { e ->
                        if (e != null)
                            logger.warnElement("Unrecognised class kind $kind", e)
                        else
                            logger.warn("Unrecognised class kind $kind")
                    }
                }

                /*
                OLD: KE1
                if (c.origin == IrDeclarationOrigin.FILE_CLASS) {
                    tw.writeFile_class(id)
                }
                 */

                if ((c as? KaNamedClassSymbol)?.isData == true) {
                    tw.writeKtDataClasses(id)
                }
            }

            val locId = c.psiSafe<KtElement>()?.let { tw.getLocation(it) } ?: tw.getFileOnlyLocation()
            tw.writeHasLocation(id, locId)

            // OLD: KE1
            //extractEnclosingClass(c.parent, id, c, locId, listOf())
            //val javaClass = (c.source as? JavaSourceElement)?.javaElement as? JavaClass

            c.typeParameters.mapIndexed { idx, param ->
                //extractTypeParameter(param, idx, javaClass?.typeParameters?.getOrNull(idx))
            }
            if (extractDeclarations) {
                if (c.classKind == KaClassKind.ANNOTATION_CLASS) {
                    c.declaredMemberScope.declarations.filterIsInstance<KaPropertySymbol>().forEach {
                        val getter = it.getter
                        if (getter == null) {
                            logger.warnElement(
                                "Expected an annotation property to have a getter",
                                it.psiSafe() ?: TODO()
                            )
                        } else {
                            extractFunction(
                                getter,
                                id,
                                /* OLD: KE1
                                extractBody = false,
                                extractMethodAndParameterTypeAccesses =
                                extractFunctionBodies,
                                extractAnnotations = true,
                                null,
                                listOf()
                                 */
                            )
                                ?.also { functionLabel ->
                                    tw.writeIsAnnotElem(functionLabel.cast())
                                }
                        }
                    }
                } else {
                    try {
                        c.declaredMemberScope.declarations.forEach {
                            extractDeclaration(
                                it,
                                /*
                                OLD: KE1
                                extractPrivateMembers = extractPrivateMembers,
                                extractFunctionBodies = extractFunctionBodies,
                                extractAnnotations = true
                                 */
                            )
                        }
                        /*
                        OLD: KE1
                        if (extractStaticInitializer) extractStaticInitializer(c, { id })
                        extractJvmStaticProxyMethods(
                            c,
                            id,
                            extractPrivateMembers,
                            extractFunctionBodies
                        )
                         */
                    } catch (e: IllegalArgumentException) {
                        // A Kotlin bug causes this to throw: https://youtrack.jetbrains.com/issue/KT-63847/K2-IllegalStateException-IrFieldPublicSymbolImpl-for-java.time-Clock.OffsetClock.offset0-is-already-bound
                        // TODO: This should either be removed or log something, once the bug is fixed
                    }
                }
            }
            /*
            OLD: KE1
            if (c.isNonCompanionObject) {
                // For `object MyObject { ... }`, the .class has an
                // automatically-generated `public static final MyObject INSTANCE`
                // field that may be referenced from Java code, and is used in our
                // IrGetObjectValue support. We therefore need to fabricate it
                // here.
                val instance = useObjectClassInstance(c)
                val type = useSimpleTypeClass(c, emptyList(), false)
                tw.writeFields(instance.id, instance.name, type.javaResult.id, id, instance.id)
                tw.writeFieldsKotlinType(instance.id, type.kotlinResult.id)
                tw.writeHasLocation(instance.id, locId)
                addModifiers(instance.id, "public", "static", "final")
                tw.writeClass_object(id, instance.id)
            }
            */
            if (c.classKind == KaClassKind.OBJECT) {
                addModifiers(id, "static")
            }
            /*
            OLD: KE1
            if (extractFunctionBodies && needsObinitFunction(c)) {
                extractObinitFunction(c, id)
            }

            extractClassModifiers(c, id)
            extractClassSupertypes(
                c,
                id,
                inReceiverContext = true
            ) // inReceiverContext = true is specified to force extraction of member prototypes
            // of base types

            linesOfCode?.linesOfCodeInDeclaration(c, id)

            val additionalAnnotations =
                if (
                    c.kind == ClassKind.ANNOTATION_CLASS &&
                    c.origin != IrDeclarationOrigin.IR_EXTERNAL_JAVA_DECLARATION_STUB
                )
                    metaAnnotationSupport.generateJavaMetaAnnotations(c, extractFunctionBodies)
                else listOf()

            extractAnnotations(
                c,
                c.annotations + additionalAnnotations,
                id,
                extractFunctionBodies
            )

            if (extractFunctionBodies && !c.isAnonymousObject && !c.isLocal)
                externalClassExtractor.writeStubTrapFile(c)
            */

            return id
        // }
    }
}

/*
    OLD: KE1
        // `args` can be null to describe a raw generic type.
        // For non-generic types it will be zero-length list.
    */
context(KaSession)
private fun KotlinUsesExtractor.getClassLabel(
    c: KaClassSymbol,
    argsIncludingOuterClasses: List<Nothing>?
): ClassLabelResults {
    val unquotedLabel = getUnquotedClassLabel(c /* TODO , argsIncludingOuterClasses */)
    return ClassLabelResults("@\"class;${unquotedLabel.classLabel}\"" /* TODO , unquotedLabel.shortName */)
}

context(KaSession)
fun KotlinUsesExtractor.useClassSource(c: KaClassSymbol): Label<out DbClassorinterface> {
    // For source classes, the label doesn't include any type arguments
    val id = addClassLabel(c, listOf())
    return id
}

private fun tryReplaceType(
    cBeforeReplacement: KaClassSymbol,
    argsIncludingOuterClassesBeforeReplacement: List<Nothing>?
): Pair<KaClassSymbol, List<Nothing>?> {
    return Pair(cBeforeReplacement, argsIncludingOuterClassesBeforeReplacement)
    /*
    OLD: KE1
    val c = tryReplaceAndroidSyntheticClass(cBeforeReplacement)
    val p = tryReplaceParcelizeRawType(c)
    return Pair(p?.first ?: c, p?.second ?: argsIncludingOuterClassesBeforeReplacement)
    */
}

private fun isExternalDeclaration(d: KaSymbol): Boolean {
    return d.origin == KaSymbolOrigin.LIBRARY || d.origin == KaSymbolOrigin.JAVA_LIBRARY
}

private fun KotlinUsesExtractor.extractExternalClassLater(c: KaClassSymbol) {
    /* OLD: KE1
    dependencyCollector?.addDependency(c)
     */
    externalClassExtractor.extractLater(c)
}


private fun KotlinUsesExtractor.extractClassLaterIfExternal(c: KaClassSymbol) {
    if (isExternalDeclaration(c)) {
        extractExternalClassLater(c)
    }
}

// `typeArgs` can be null to describe a raw generic type.
// For non-generic types it will be zero-length list.
// TODO: Should this be private?
context(KaSession)
fun KotlinUsesExtractor.addClassLabel(
    cBeforeReplacement: KaClassSymbol, // TODO cBeforeReplacement: IrClass,
    argsIncludingOuterClassesBeforeReplacement: List<Nothing>?,
    /*
    OLD: KE1
            inReceiverContext: Boolean = false
    */
): Label<out DbClassorinterface> {
    val replaced =
        tryReplaceType(cBeforeReplacement, argsIncludingOuterClassesBeforeReplacement)
    val replacedClass = replaced.first
    val replacedArgsIncludingOuterClasses = replaced.second

    val classLabelResult = getClassLabel(replacedClass, replacedArgsIncludingOuterClasses)

    /*
    OLD: KE1
            var instanceSeenBefore = true
    */

    val classLabel: Label<out DbClassorinterface> =
        tw.getLabelFor(classLabelResult.classLabel) {
/*
OLD: KE1
                instanceSeenBefore = false

*/
            extractClassLaterIfExternal(replacedClass)
            // TODO: This shouldn't be done here, but keeping it simple for now
        }

    /*
    OLD: KE1
            if (
                replacedArgsIncludingOuterClasses == null ||
                    replacedArgsIncludingOuterClasses.isNotEmpty()
            ) {
                // If this is a generic type instantiation or a raw type then it has no
                // source entity, so we need to extract it here
                val shouldExtractClassDetails =
                    inReceiverContext &&
                        tw.lm.genericSpecialisationsExtracted.add(classLabelResult.classLabel)
                if (!instanceSeenBefore || shouldExtractClassDetails) {
                    this.withFileOfClass(replacedClass)
                        .extractClassInstance(
                            classLabel,
                            replacedClass,
                            replacedArgsIncludingOuterClasses,
                            !instanceSeenBefore,
                            shouldExtractClassDetails
                        )
                }
            }

            // TODO: This used to do the below, but that is a "type" thing rather than a "class" thing
            val fqName = replacedClass.fqNameWhenAvailable
            val signature =
                if (replacedClass.isAnonymousObject) {
                    null
                } else if (fqName == null) {
                    logger.error("Unable to find signature/fqName for ${replacedClass.name}")
                    null
                } else {
                    fqName.asString()
                }
            return TypeResult(classLabel /* TODO , signature, classLabelResult.shortName */)
    */
    return classLabel
}

/*
    OLD: KE1
        /**
         * This returns the `X` in c's label `@"class;X"`.
         *
         * `argsIncludingOuterClasses` can be null to describe a raw generic type. For non-generic types
         * it will be zero-length list.
         */
    */
context(KaSession)
private fun KotlinUsesExtractor.getUnquotedClassLabel(
    c: KaClassSymbol,
    /*
    OLD: KE1
            argsIncludingOuterClasses: List<IrTypeArgument>?
    */
): ClassLabelResults {
    val classId = c.classId
    if (classId == null) {
        TODO() // This is a local class
    }
    val pkg = classId.packageFqName.asString()
    val cls = classId.shortClassName.asString()
    val label =
        /* OLD: KE1
        if (c.isAnonymousObject) "{${useAnonymousClass(c).javaResult.id}}"
        else
         */
            when (val parent = c.containingSymbol) {
                is KaClassSymbol -> {
                    "${getUnquotedClassLabel(parent).classLabel}\$$cls"
                }

                is KaFunctionSymbol -> {
                    "{${useFunction<DbMethod>(parent)}}.$cls"
                }

                is KaPropertySymbol -> {
                    TODO()
                    /* OLD: KE1
                    "{${useField(parent)}}.$cls"
                    */
                }

                else -> {
                    if (pkg.isEmpty()) cls else "$pkg.$cls"
                }
            }
    /*
    OLD: KE1
                        }
                    }

            val reorderedArgs = orderTypeArgsLeftToRight(c, argsIncludingOuterClasses)
            val typeArgLabels = reorderedArgs?.map { getTypeArgumentLabel(it) }
            val typeArgsShortName =
                if (typeArgLabels == null) "<>"
                else if (typeArgLabels.isEmpty()) ""
                else
                    typeArgLabels.takeLast(c.typeParameters.size).joinToString(
                        prefix = "<",
                        postfix = ">",
                        separator = ","
                    ) {
                        it.shortName
                    }
            val shortNamePrefix = if (c.isAnonymousObject) "" else cls
    */

    return ClassLabelResults(
        label // OLD: KE1: + (typeArgLabels?.joinToString(separator = "") { ";{${it.id}}" } ?: "<>"),
        /*
        OLD: KE1
                    shortNamePrefix + typeArgsShortName
        */
    )
}
