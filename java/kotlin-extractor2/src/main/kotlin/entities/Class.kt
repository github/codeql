import com.github.codeql.*
import com.github.codeql.KotlinUsesExtractor.ClassLabelResults
import com.github.codeql.KotlinUsesExtractor.TypeContext
import com.github.codeql.utils.isInterfaceLike
import org.jetbrains.kotlin.analysis.api.KaExperimentalApi
import org.jetbrains.kotlin.analysis.api.KaSession
import org.jetbrains.kotlin.analysis.api.symbols.*
import org.jetbrains.kotlin.analysis.api.types.KaClassType
import org.jetbrains.kotlin.analysis.api.types.KaType

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
    with("class source", c.psiSafe() ?: TODO()) {
        DeclarationStackAdjuster(c).use {
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
                ) {
                    logger.warnElement("Unrecognised class kind $kind", c.psiSafe() ?: TODO())
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

            val locId = tw.getLocation(c.psiSafe() ?: TODO())
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
                        val decl = c.declaredMemberScope.declarations.toList()
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
        }
    }
}

/*
    OLD: KE1
        // `args` can be null to describe a raw generic type.
        // For non-generic types it will be zero-length list.
    */
private fun KotlinUsesExtractor.getClassLabel(
    c: KaClassType,
    /*
    OLD: KE1
            argsIncludingOuterClasses: List<IrTypeArgument>?
    */
): ClassLabelResults {
    val unquotedLabel = getUnquotedClassLabel(c /* TODO , argsIncludingOuterClasses */)
    return ClassLabelResults("@\"class;${unquotedLabel.classLabel}\"" /* TODO , unquotedLabel.shortName */)
}

context(KaSession)
fun KotlinUsesExtractor.useClassSource(c: KaClassSymbol): Label<out DbClassorinterface> {
    // For source classes, the label doesn't include any type arguments
    val classTypeResult = addClassLabel(buildClassType(c) as KaClassType)
    return classTypeResult.id
}

// `typeArgs` can be null to describe a raw generic type.
// For non-generic types it will be zero-length list.
private fun KotlinUsesExtractor.addClassLabel(
    c: KaClassType, // TODO cBeforeReplacement: IrClass,
    /*
    OLD: KE1
            argsIncludingOuterClassesBeforeReplacement: List<IrTypeArgument>?,
            inReceiverContext: Boolean = false
    */
): TypeResult<DbClassorinterface> {
    /*
    OLD: KE1
            val replaced =
                tryReplaceType(cBeforeReplacement, argsIncludingOuterClassesBeforeReplacement)
            val replacedClass = replaced.first
            val replacedArgsIncludingOuterClasses = replaced.second

    */
    val classLabelResult = getClassLabel(c /* TODO replacedClass, replacedArgsIncludingOuterClasses */)

    /*
    OLD: KE1
            var instanceSeenBefore = true
    */

    val classLabel: Label<out DbClassorinterface> =
        tw.getLabelFor(classLabelResult.classLabel) {
/*
OLD: KE1
                instanceSeenBefore = false

                extractClassLaterIfExternal(replacedClass)
*/
            // TODO: This shouldn't be done here, but keeping it simple for now
            val pkgId = extractPackage(c.classId.packageFqName.asString())
            tw.writeClasses_or_interfaces(it, c.classId.relativeClassName.asString(), pkgId, it)
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
    */
    return TypeResult(classLabel /* TODO , signature, classLabelResult.shortName */)
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
private fun KotlinUsesExtractor.getUnquotedClassLabel(
    c: KaClassType,
    /*
    OLD: KE1
            argsIncludingOuterClasses: List<IrTypeArgument>?
    */
): ClassLabelResults {
    val pkg = c.classId.packageFqName.asString()
    val cls = c.classId.relativeClassName.asString()
    val label =
        /*
        OLD: KE1
                    if (c.isAnonymousObject) "{${useAnonymousClass(c).javaResult.id}}"
                    else
                        when (val parent = c.parent) {
                            is IrClass -> {
                                "${getUnquotedClassLabel(parent, listOf()).classLabel}\$$cls"
                            }
                            is IrFunction -> {
                                "{${useFunction<DbMethod>(parent)}}.$cls"
                            }
                            is IrField -> {
                                "{${useField(parent)}}.$cls"
                            }
                            else -> {
        */
        if (pkg.isEmpty()) cls else "$pkg.$cls"
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

private fun KotlinUsesExtractor.useClassType(
    c: KaClassType
): TypeResults {
    val javaResult = addClassLabel(c)
    val kotlinResult = TypeResult(fakeKotlinType() /* , "TODO", "TODO" */)
    return TypeResults(javaResult, kotlinResult)
}

fun KotlinUsesExtractor.useType(t: KaType, context: TypeContext = TypeContext.OTHER): TypeResults {
    when (t) {
        is KaClassType -> return useClassType(t)
        else -> TODO()
    }
    /*
    OLD: KE1
            when (t) {
                is IrSimpleType -> return useSimpleType(t, context)
                else -> {
                    logger.error("Unrecognised IrType: " + t.javaClass)
                    return extractErrorType()
                }
            }
    */
}