package com.github.codeql

import com.intellij.openapi.util.TextRange
import com.intellij.psi.PsiElement
import org.jetbrains.kotlin.analysis.api.components.KaDiagnosticCheckerFilter
import org.jetbrains.kotlin.analysis.api.diagnostics.KaSeverity
import org.jetbrains.kotlin.analysis.api.KaSession
import org.jetbrains.kotlin.analysis.api.types.KaType
import org.jetbrains.kotlin.KtNodeTypes
import org.jetbrains.kotlin.analysis.api.resolution.*
import org.jetbrains.kotlin.analysis.api.symbols.*
import org.jetbrains.kotlin.psi.*
import org.jetbrains.kotlin.parsing.parseNumericLiteral

/*
OLD: KE1
import com.github.codeql.comments.CommentExtractorLighterAST
import com.github.codeql.comments.CommentExtractorPSI
import com.github.codeql.utils.*
import com.github.codeql.utils.versions.*
import com.semmle.extractor.java.OdasaOutput
import java.io.Closeable
import java.util.*
import kotlin.collections.ArrayList
import org.jetbrains.kotlin.backend.common.extensions.IrPluginContext
import org.jetbrains.kotlin.backend.common.pop
import org.jetbrains.kotlin.builtins.functions.BuiltInFunctionArity
import org.jetbrains.kotlin.config.JvmAnalysisFlags
import org.jetbrains.kotlin.descriptors.*
import org.jetbrains.kotlin.descriptors.java.JavaVisibilities
import org.jetbrains.kotlin.ir.IrElement
import org.jetbrains.kotlin.ir.IrStatement
import org.jetbrains.kotlin.ir.ObsoleteDescriptorBasedAPI
import org.jetbrains.kotlin.ir.UNDEFINED_OFFSET
import org.jetbrains.kotlin.ir.backend.js.utils.realOverrideTarget
import org.jetbrains.kotlin.ir.builders.declarations.*
import org.jetbrains.kotlin.ir.declarations.*
import org.jetbrains.kotlin.ir.declarations.lazy.IrLazyFunction
import org.jetbrains.kotlin.ir.expressions.*
import org.jetbrains.kotlin.ir.expressions.impl.*
import org.jetbrains.kotlin.ir.symbols.*
import org.jetbrains.kotlin.ir.types.*
import org.jetbrains.kotlin.ir.types.impl.makeTypeProjection
import org.jetbrains.kotlin.ir.util.companionObject
import org.jetbrains.kotlin.ir.util.constructors
import org.jetbrains.kotlin.ir.util.fqNameWhenAvailable
import org.jetbrains.kotlin.ir.util.hasAnnotation
import org.jetbrains.kotlin.ir.util.hasInterfaceParent
import org.jetbrains.kotlin.ir.util.isAnnotationClass
import org.jetbrains.kotlin.ir.util.isAnonymousObject
import org.jetbrains.kotlin.ir.util.isFunctionOrKFunction
import org.jetbrains.kotlin.ir.util.isInterface
import org.jetbrains.kotlin.ir.util.isLocal
import org.jetbrains.kotlin.ir.util.isNonCompanionObject
import org.jetbrains.kotlin.ir.util.isObject
import org.jetbrains.kotlin.ir.util.isSuspend
import org.jetbrains.kotlin.ir.util.isSuspendFunctionOrKFunction
import org.jetbrains.kotlin.ir.util.isVararg
import org.jetbrains.kotlin.ir.util.kotlinFqName
import org.jetbrains.kotlin.ir.util.packageFqName
import org.jetbrains.kotlin.ir.util.parentAsClass
import org.jetbrains.kotlin.ir.util.parentClassOrNull
import org.jetbrains.kotlin.ir.util.parents
import org.jetbrains.kotlin.ir.util.primaryConstructor
import org.jetbrains.kotlin.ir.util.render
import org.jetbrains.kotlin.ir.util.target
import org.jetbrains.kotlin.load.java.JvmAnnotationNames
import org.jetbrains.kotlin.load.java.NOT_NULL_ANNOTATIONS
import org.jetbrains.kotlin.load.java.NULLABLE_ANNOTATIONS
import org.jetbrains.kotlin.load.java.sources.JavaSourceElement
import org.jetbrains.kotlin.load.java.structure.JavaAnnotation
import org.jetbrains.kotlin.load.java.structure.JavaClass
import org.jetbrains.kotlin.load.java.structure.JavaConstructor
import org.jetbrains.kotlin.load.java.structure.JavaMethod
import org.jetbrains.kotlin.load.java.structure.JavaTypeParameter
import org.jetbrains.kotlin.load.java.structure.JavaTypeParameterListOwner
import org.jetbrains.kotlin.load.java.structure.impl.classFiles.BinaryJavaClass
import org.jetbrains.kotlin.name.FqName
import org.jetbrains.kotlin.types.Variance
import org.jetbrains.kotlin.util.OperatorNameConventions
import org.jetbrains.kotlin.utils.addToStdlib.firstIsInstanceOrNull
*/

context (KaSession)
open class KotlinFileExtractor(
    override val logger: FileLogger,
    override val tw: FileTrapWriter,
    externalClassExtractor: ExternalDeclExtractor,
    /*
    OLD: KE1
        val linesOfCode: LinesOfCode?,
        val filePath: String,
        dependencyCollector: OdasaOutput.TrapFileManager?,
        primitiveTypeMapping: PrimitiveTypeMapping,
        pluginContext: IrPluginContext,
        val declarationStack: DeclarationStack,
        globalExtensionState: KotlinExtractorGlobalState,
    */
) :
    KotlinUsesExtractor(
        logger,
        tw,
        externalClassExtractor,
        /*
        OLD: KE1
                dependencyCollector,
                primitiveTypeMapping,
                pluginContext,
                globalExtensionState
        */
    ) {

    /*
    OLD: KE1
        val usesK2 = usesK2(pluginContext)
        val metaAnnotationSupport = MetaAnnotationSupport(logger, pluginContext, this)
    */

    inline fun <T> with(kind: String, element: PsiElement, f: () -> T) = with(kind, PsiElementOrSymbol.of(element), f)
    inline fun <T> with(kind: String, element: KaSymbol, f: () -> T) = with(kind, PsiElementOrSymbol.of(element), f)
    inline fun <T> with(kind: String, element: PsiElementOrSymbol, f: () -> T): T {
        val name = element.getName()
        val loc = element.getLocationString(tw)
        val context = logger.loggerState.extractorContextStack
        context.push(ExtractorContext(kind, element, name, loc))
        try {
            val depth = context.size
            val depthDescription = "${"-".repeat(depth)} (${depth.toString()})"
            logger.trace("$depthDescription: Starting a $kind ($name) at $loc")
            val result = f()
            logger.trace("$depthDescription: Finished a $kind ($name) at $loc")
            return result
        } catch (exception: Exception) {
            throw Exception("While extracting a $kind ($name) at $loc", exception)
        } finally {
            context.pop()
        }
    }

    fun extractFileContents(file: KtFile, id: Label<DbFile>) {
        with("file", file) {
            extractDiagnostics(file)

            val locId = tw.getWholeFileLocation()
            val pkg = file.packageFqName.asString()
            val pkgId = extractPackage(pkg)
            tw.writeHasLocation(id, locId)
            tw.writeCupackage(id, pkgId)

            val exceptionOnFile =
                System.getenv("CODEQL_KOTLIN_INTERNAL_EXCEPTION_WHILE_EXTRACTING_FILE")
            if (exceptionOnFile != null) {
                if (exceptionOnFile.lowercase() == file.name.lowercase()) {
                    throw Exception("Internal testing exception")
                }
            }

            file.getDeclarations().forEach {
                extractDeclaration(
                    it.symbol,
                    /*
                    OLD: KE1
                                        extractPrivateMembers = true,
                                        extractFunctionBodies = true,
                                        extractAnnotations = true
                    */
                )
                /*
                OLD: KE1
                                if (it is IrProperty || it is IrField || it is IrFunction) {
                                    externalClassExtractor.writeStubTrapFile(it, getTrapFileSignature(it))
                                }
                */
            }
            /*
            OLD: KE1
                        extractStaticInitializer(file, { extractFileClass(file) })
                        val psiCommentsExtracted = CommentExtractorPSI(this, file, tw.fileId).extract()
                        val lighterAstCommentsExtracted =
                            CommentExtractorLighterAST(this, file, tw.fileId).extract()
                        if (psiCommentsExtracted == lighterAstCommentsExtracted) {
                            if (psiCommentsExtracted) {
                                logger.warnElement(
                                    "Found both PSI and LighterAST comments in ${file.path}.",
                                    file
                                )
                            } else {
                                logger.warnElement("Comments could not be processed in ${file.path}.", file)
                            }
                        }

                        if (!declarationStack.isEmpty()) {
                            logger.errorElement(
                                "Declaration stack is not empty after processing the file",
                                file
                            )
                        }

                        linesOfCode?.linesOfCodeInFile(id)

                        externalClassExtractor.writeStubTrapFile(file)
            */
        }
    }

    // TODO: Add comment
    private fun extractDiagnostics(file: KtFile) {
        val dcf = KaDiagnosticCheckerFilter.ONLY_COMMON_CHECKERS
        for (d in file.collectDiagnostics(dcf)) {
            val diagLabel = tw.getFreshIdLabel<DbDiagnostic>()
            val severity = when (d.severity) {
                               KaSeverity.ERROR -> Severity.Error.sev
                               KaSeverity.WARNING -> Severity.Warn.sev
                               KaSeverity.INFO -> null
                           }
            if (severity != null) {
                val location = if (d.textRanges.isEmpty()) {
                                   tw.getWholeFileLocation()
                               } else {
                                   // We just use a random location from the set
                                   tw.getLocation(file, d.textRanges.first())
                               }
                tw.writeDiagnostics(
                    diagLabel,
                    "CodeQL Kotlin: Analysis API",
                    severity,
                    d.factoryName,
                    d.defaultMessage,
                    "",
                    location)
                // TODO: We could try to link diagnostics to d.psi, but we
                // don't have labels for lots of things. We'd either have
                // to cache the labels, or extract diagnostics from all the
                // element extractors.
            }
        }
        println("--- End diagnostics")
    }

    /*
    OLD: KE1
        private fun javaBinaryDeclaresMethod(c: IrClass, name: String) =
            ((c.source as? JavaSourceElement)?.javaElement as? BinaryJavaClass)?.methods?.any {
                it.name.asString() == name
            }

        private fun isJavaBinaryDeclaration(f: IrFunction) =
            f.parentClassOrNull?.let { javaBinaryDeclaresMethod(it, f.name.asString()) } ?: false

        private fun isJavaBinaryObjectMethodRedeclaration(d: IrDeclaration) =
            when (d) {
                is IrFunction ->
                    when (d.name.asString()) {
                        "toString" -> d.valueParameters.isEmpty()
                        "hashCode" -> d.valueParameters.isEmpty()
                        "equals" -> d.valueParameters.singleOrNull()?.type?.isNullableAny() ?: false
                        else -> false
                    } && isJavaBinaryDeclaration(d)
                else -> false
            }

        private fun shouldExtractDecl(declaration: IrDeclaration, extractPrivateMembers: Boolean) =
            extractPrivateMembers || !isPrivate(declaration)
    */

    fun extractDeclaration(
        declaration: KaDeclarationSymbol,
        /*
        OLD: KE1
                extractPrivateMembers: Boolean,
                extractFunctionBodies: Boolean,
                extractAnnotations: Boolean
        */
    ) {
        with("declaration", declaration) {
/*
OLD: KE1
            if (!shouldExtractDecl(declaration, extractPrivateMembers)) return
*/
            when (declaration) {
                is KaClassSymbol -> {
                    /*
                    OLD: KE1
                                        if (isExternalDeclaration(declaration)) {
                                            extractExternalClassLater(declaration)
                                        } else {
                                        */
                    extractClassSource(
                        declaration,
                        extractDeclarations = true,
                        /*
                        OLD: KE1
                           extractStaticInitializer = true,
                           extractPrivateMembers = extractPrivateMembers,
                           extractFunctionBodies = extractFunctionBodies
                       */
                    )
                    /*
                    OLD: KE1
                                       }
                    */
                }

                // TODO: the below should be KaFunctionSymbol
                is KaNamedFunctionSymbol -> {
                    val parentId = useDeclarationParentOf(declaration, false)?.cast<DbReftype>()
                    if (parentId != null) {
                        // TODO: Float this PSI further up
                        val func = declaration.psi as? KtFunction
                        if (func == null) {
                            extractFunctionSymbol(
                                declaration,
                                parentId,
                                /*
                                OLD: KE1
                                                            extractBody = extractFunctionBodies,
                                                            extractMethodAndParameterTypeAccesses = extractFunctionBodies,
                                                            extractAnnotations = extractAnnotations,
                                                            null,
                                                            listOf()
                                */
                            )
                        } else {
                            extractFunction(
                                func,
                                parentId,
                                /*
                                OLD: KE1
                                                            extractBody = extractFunctionBodies,
                                                            extractMethodAndParameterTypeAccesses = extractFunctionBodies,
                                                            extractAnnotations = extractAnnotations,
                                                            null,
                                                            listOf()
                                */
                            )
                        }
                    } else {
                        Unit
                    }
                }
                /*
                OLD: KE1
                                is IrAnonymousInitializer -> {
                                    // Leaving this intentionally empty. init blocks are extracted during class
                                    // extraction.
                                }
                                is IrProperty -> {
                                    val parentId = useDeclarationParentOf(declaration, false)?.cast<DbReftype>()
                                    if (parentId != null) {
                                        extractProperty(
                                            declaration,
                                            parentId,
                                            extractBackingField = true,
                                            extractFunctionBodies = extractFunctionBodies,
                                            extractPrivateMembers = extractPrivateMembers,
                                            extractAnnotations = extractAnnotations,
                                            null,
                                            listOf()
                                        )
                                    }
                                    Unit
                                }
                                is IrEnumEntry -> {
                                    val parentId = useDeclarationParentOf(declaration, false)?.cast<DbReftype>()
                                    if (parentId != null) {
                                        extractEnumEntry(
                                            declaration,
                                            parentId,
                                            extractPrivateMembers,
                                            extractFunctionBodies
                                        )
                                    }
                                    Unit
                                }
                                is IrField -> {
                                    val parentId = useDeclarationParentOf(declaration, false)?.cast<DbReftype>()
                                    if (parentId != null) {
                                        // For consistency with the Java extractor, enum entries get type accesses
                                        // only if we're extracting from .kt source (i.e., when
                                        // `extractFunctionBodies` is set)
                                        extractField(
                                            declaration,
                                            parentId,
                                            extractAnnotationEnumTypeAccesses = extractFunctionBodies
                                        )
                                    }
                                    Unit
                                }
                                is IrTypeAlias -> extractTypeAlias(declaration)
                */
                else ->
                    // TODO
                    Unit
                /*
                OLD: KE1
                                    logger.errorElement(
                                        "Unrecognised IrDeclaration: " + declaration.javaClass,
                                        declaration
                                    )
                */
            }
        }
    }

    /*
    OLD: KE1
        private fun extractTypeParameter(
            tp: IrTypeParameter,
            apparentIndex: Int,
            javaTypeParameter: JavaTypeParameter?
        ): Label<out DbTypevariable>? {
            with("type parameter", tp) {
                val parentId = getTypeParameterParentLabel(tp) ?: return null
                val id = tw.getLabelFor<DbTypevariable>(getTypeParameterLabel(tp))

                // Note apparentIndex does not necessarily equal `tp.index`, because at least
                // constructor type parameters
                // have indices offset from the type parameters of the constructed class (i.e. the
                // parameter S of
                // `class Generic<T> { public <S> Generic(T t, S s) { ... } }` will have `tp.index` 1,
                // not 0).
                tw.writeTypeVars(id, tp.name.asString(), apparentIndex, 0, parentId)
                val locId = tw.getLocation(tp)
                tw.writeHasLocation(id, locId)

                // Annoyingly, we have no obvious way to pair up the bounds of an IrTypeParameter and a
                // JavaTypeParameter
                // because JavaTypeParameter provides a Collection not an ordered list, so we can only
                // do our best here:
                fun tryGetJavaBound(idx: Int) =
                    when (tp.superTypes.size) {
                        1 -> javaTypeParameter?.upperBounds?.singleOrNull()
                        else -> (javaTypeParameter?.upperBounds as? List)?.getOrNull(idx)
                    }

                tp.superTypes.forEachIndexed { boundIdx, bound ->
                    if (!(bound.isAny() || bound.isNullableAny())) {
                        tw.getLabelFor<DbTypebound>("@\"bound;$boundIdx;{$id}\"") {
                            // Note we don't look for @JvmSuppressWildcards here because it doesn't seem
                            // to have any impact
                            // on kotlinc adding wildcards to type parameter bounds.
                            val boundWithWildcards =
                                addJavaLoweringWildcards(bound, true, tryGetJavaBound(tp.index))
                            tw.writeTypeBounds(
                                it,
                                useType(boundWithWildcards).javaResult.id.cast<DbReftype>(),
                                boundIdx,
                                id
                            )
                        }
                    }
                }

                if (tp.isReified) {
                    addModifiers(id, "reified")
                }

                if (tp.variance == Variance.IN_VARIANCE) {
                    addModifiers(id, "in")
                } else if (tp.variance == Variance.OUT_VARIANCE) {
                    addModifiers(id, "out")
                }

                // extractAnnotations(tp, id)
                // TODO: introduce annotations once they can be disambiguated from bounds, which are
                // also child expressions.
                return id
            }
        }

        private fun extractVisibility(
            elementForLocation: IrElement,
            id: Label<out DbModifiable>,
            v: DescriptorVisibility
        ) {
            with("visibility", elementForLocation) {
                when (v) {
                    DescriptorVisibilities.PRIVATE -> addModifiers(id, "private")
                    DescriptorVisibilities.PRIVATE_TO_THIS -> addModifiers(id, "private")
                    DescriptorVisibilities.PROTECTED -> addModifiers(id, "protected")
                    DescriptorVisibilities.PUBLIC -> addModifiers(id, "public")
                    DescriptorVisibilities.INTERNAL -> addModifiers(id, "internal")
                    DescriptorVisibilities.LOCAL ->
                        if (elementForLocation is IrFunction && elementForLocation.isLocalFunction()) {
                            // The containing class is `private`.
                            addModifiers(id, "public")
                        } else {
                            addVisibilityModifierToLocalOrAnonymousClass(id)
                        }
                    is DelegatedDescriptorVisibility -> {
                        when (v.delegate) {
                            JavaVisibilities.ProtectedStaticVisibility -> {
                                addModifiers(id, "protected")
                                addModifiers(id, "static")
                            }
                            JavaVisibilities.PackageVisibility -> {
                                // default java visibility (top level)
                            }
                            JavaVisibilities.ProtectedAndPackage -> {
                                addModifiers(id, "protected")
                            }
                            else ->
                                logger.errorElement(
                                    "Unexpected delegated visibility: $v",
                                    elementForLocation
                                )
                        }
                    }
                    else -> logger.errorElement("Unexpected visibility: $v", elementForLocation)
                }
            }
        }

        private fun extractClassModifiers(c: IrClass, id: Label<out DbClassorinterface>) {
            with("class modifiers", c) {
                when (c.modality) {
                    Modality.FINAL -> addModifiers(id, "final")
                    Modality.SEALED -> addModifiers(id, "sealed")
                    Modality.OPEN -> {} // This is the default
                    Modality.ABSTRACT -> addModifiers(id, "abstract")
                    else -> logger.errorElement("Unexpected class modality: ${c.modality}", c)
                }
                extractVisibility(c, id, c.visibility)
            }
        }

        fun extractClassInstance(
            classLabel: Label<out DbClassorinterface>,
            c: IrClass,
            argsIncludingOuterClasses: List<IrTypeArgument>?,
            shouldExtractOutline: Boolean,
            shouldExtractDetails: Boolean
        ) {
            DeclarationStackAdjuster(c).use {
                if (shouldExtractOutline) {
                    extractClassWithoutMembers(c, argsIncludingOuterClasses)
                }

                if (shouldExtractDetails) {
                    val supertypeMode =
                        if (argsIncludingOuterClasses == null) ExtractSupertypesMode.Raw
                        else ExtractSupertypesMode.Specialised(argsIncludingOuterClasses)
                    extractClassSupertypes(c, classLabel, supertypeMode, true)
                    extractNonPrivateMemberPrototypes(c, argsIncludingOuterClasses, classLabel)
                }
            }
        }

        // `argsIncludingOuterClasses` can be null to describe a raw generic type.
        // For non-generic types it will be zero-length list.
        private fun extractClassWithoutMembers(
            c: IrClass,
            argsIncludingOuterClasses: List<IrTypeArgument>?
        ): Label<out DbClassorinterface> {
            with("class instance", c) {
                if (argsIncludingOuterClasses?.isEmpty() == true) {
                    logger.error("Instance without type arguments: " + c.name.asString())
                }

                val classLabelResults = getClassLabel(c, argsIncludingOuterClasses)
                val id = tw.getLabelFor<DbClassorinterface>(classLabelResults.classLabel)
                val pkg = c.packageFqName?.asString() ?: ""
                val cls = classLabelResults.shortName
                val pkgId = extractPackage(pkg)
                // TODO: There's lots of duplication between this and extractClassSource.
                // Can we share it?
                val sourceId = useClassSource(c)
                tw.writeClasses_or_interfaces(id, cls, pkgId, sourceId)
                if (c.isInterfaceLike) {
                    tw.writeIsInterface(id)
                } else {
                    val kind = c.kind
                    if (kind == ClassKind.ENUM_CLASS) {
                        tw.writeIsEnumType(id)
                    } else if (
                        kind != ClassKind.CLASS &&
                            kind != ClassKind.OBJECT &&
                            kind != ClassKind.ENUM_ENTRY
                    ) {
                        logger.errorElement("Unrecognised class kind $kind", c)
                    }
                }

                val typeArgs = removeOuterClassTypeArgs(c, argsIncludingOuterClasses)
                if (typeArgs != null) {
                    // From 1.9, the list might change when we call erase,
                    // so we make a copy that it is safe to iterate over.
                    val typeArgsCopy = typeArgs.toList()
                    for ((idx, arg) in typeArgsCopy.withIndex()) {
                        val argId = getTypeArgumentLabel(arg).id
                        tw.writeTypeArgs(argId, idx, id)
                    }
                    tw.writeIsParameterized(id)
                } else {
                    tw.writeIsRaw(id)
                }

                extractClassModifiers(c, id)
                extractClassSupertypes(
                    c,
                    id,
                    if (argsIncludingOuterClasses == null) ExtractSupertypesMode.Raw
                    else ExtractSupertypesMode.Specialised(argsIncludingOuterClasses)
                )

                val locId = getLocation(c, argsIncludingOuterClasses)
                tw.writeHasLocation(id, locId)

                // Extract the outer <-> inner class relationship, passing on any type arguments in
                // excess to this class' parameters if this is an inner class.
                // For example, in `class Outer<T> { inner class Inner<S> { } }`, `Inner<Int, String>`
                // nests within `Outer<Int>` and raw `Inner<>` within `Outer<>`,
                // but for a similar non-`inner` (in Java terms, static nested) class both `Inner<Int>`
                // and `Inner<>` nest within the unbound type `Outer`.
                val useBoundOuterType =
                    (c.isInner || c.isLocal) &&
                        (c.parents.firstNotNullOfOrNull {
                            when (it) {
                                is IrClass ->
                                    when {
                                        it.typeParameters.isNotEmpty() ->
                                            true // Type parameters visible to this class -- extract an
                                                 // enclosing bound or raw type.
                                        !(it.isInner || it.isLocal) ->
                                            false // No type parameters seen yet, and this is a static
                                                  // class -- extract an enclosing unbound type.
                                        else ->
                                            null // No type parameters seen here, but may be visible
                                                 // enclosing type parameters; keep searching.
                                    }
                                else ->
                                    null // Look through enclosing non-class entities (this may need to
                                         // change)
                            }
                        } ?: false)

                extractEnclosingClass(
                    c.parent,
                    id,
                    c,
                    locId,
                    if (useBoundOuterType) argsIncludingOuterClasses?.drop(c.typeParameters.size)
                    else listOf()
                )

                return id
            }
        }

        private fun getLocation(
            decl: IrDeclaration,
            typeArgs: List<IrTypeArgument>?
        ): Label<DbLocation> {
            return if (typeArgs != null && typeArgs.isNotEmpty()) {
                val binaryPath = getIrDeclarationBinaryPath(decl)
                if (binaryPath == null) {
                    tw.getLocation(decl)
                } else {
                    val newTrapWriter = tw.makeFileTrapWriter(binaryPath, true)
                    newTrapWriter.getWholeFileLocation()
                }
            } else {
                tw.getLocation(decl)
            }
        }

        private fun makeTypeParamSubstitution(
            c: IrClass,
            argsIncludingOuterClasses: List<IrTypeArgument>?
        ) =
            when (argsIncludingOuterClasses) {
                null -> { x: IrType, _: TypeContext, _: IrPluginContext -> x.toRawType() }
                else -> makeGenericSubstitutionFunction(c, argsIncludingOuterClasses)
            }

        fun extractDeclarationPrototype(
            d: IrDeclaration,
            parentId: Label<out DbReftype>,
            argsIncludingOuterClasses: List<IrTypeArgument>?,
            typeParamSubstitutionQ: TypeSubstitution? = null
        ) {
            val typeParamSubstitution =
                typeParamSubstitutionQ
                    ?: when (val parent = d.parent) {
                        is IrClass -> makeTypeParamSubstitution(parent, argsIncludingOuterClasses)
                        else -> {
                            logger.warnElement("Unable to extract prototype of local declaration", d)
                            return
                        }
                    }
            when (d) {
                is IrFunction ->
                    extractFunction(
                        d,
                        parentId,
                        extractBody = false,
                        extractMethodAndParameterTypeAccesses = false,
                        extractAnnotations = false,
                        typeParamSubstitution,
                        argsIncludingOuterClasses
                    )
                is IrProperty ->
                    extractProperty(
                        d,
                        parentId,
                        extractBackingField = false,
                        extractFunctionBodies = false,
                        extractPrivateMembers = false,
                        extractAnnotations = false,
                        typeParamSubstitution,
                        argsIncludingOuterClasses
                    )
                else -> {}
            }
        }

        // `argsIncludingOuterClasses` can be null to describe a raw generic type.
        // For non-generic types it will be zero-length list.
        private fun extractNonPrivateMemberPrototypes(
            c: IrClass,
            argsIncludingOuterClasses: List<IrTypeArgument>?,
            id: Label<out DbClassorinterface>
        ) {
            with("member prototypes", c) {
                val typeParamSubstitution = makeTypeParamSubstitution(c, argsIncludingOuterClasses)

                c.declarations.map {
                    if (shouldExtractDecl(it, false)) {
                        extractDeclarationPrototype(
                            it,
                            id,
                            argsIncludingOuterClasses,
                            typeParamSubstitution
                        )
                    }
                }
            }
        }

        private fun extractLocalTypeDeclStmt(
            c: IrClass,
            callable: Label<out DbCallable>,
            parent: Label<out DbStmtparent>,
            idx: Int
        ) {
            val id =
                extractClassSource(
                    c,
                    extractDeclarations = true,
                    extractStaticInitializer = true,
                    extractPrivateMembers = true,
                    extractFunctionBodies = true
                )
            extractLocalTypeDeclStmt(id, c, callable, parent, idx)
        }

        private fun extractLocalTypeDeclStmt(
            id: Label<out DbClassorinterface>,
            locElement: IrElement,
            callable: Label<out DbCallable>,
            parent: Label<out DbStmtparent>,
            idx: Int
        ) {
            val stmtId = tw.getFreshIdLabel<DbLocaltypedeclstmt>()
            tw.writeStmts_localtypedeclstmt(stmtId, parent, idx, callable)
            tw.writeIsLocalClassOrInterface(id, stmtId)
            val locId = tw.getLocation(locElement)
            tw.writeHasLocation(stmtId, locId)
        }

        private fun extractObinitFunction(c: IrClass, parentId: Label<out DbClassorinterface>) {
            // add method:
            val obinitLabel = getObinitLabel(c, parentId)
            val obinitId = tw.getLabelFor<DbMethod>(obinitLabel)
            val returnType = useType(pluginContext.irBuiltIns.unitType, TypeContext.RETURN)
            tw.writeMethods(
                obinitId,
                "<obinit>",
                "<obinit>()",
                returnType.javaResult.id,
                parentId,
                obinitId
            )
            tw.writeMethodsKotlinType(obinitId, returnType.kotlinResult.id)

            val locId = tw.getLocation(c)
            tw.writeHasLocation(obinitId, locId)

            addModifiers(obinitId, "private")

            // add body:
            val blockId = extractBlockBody(obinitId, locId)

            extractDeclInitializers(c.declarations, false) { Pair(blockId, obinitId) }
        }

        private val javaLangDeprecated by lazy { referenceExternalClass("java.lang.Deprecated") }

        private val javaLangDeprecatedConstructor by lazy {
            javaLangDeprecated?.constructors?.singleOrNull()
        }

        private fun replaceKotlinDeprecatedAnnotation(
            annotations: List<IrConstructorCall>
        ): List<IrConstructorCall> {
            val shouldReplace =
                annotations.any {
                    (it.type as? IrSimpleType)?.classFqName?.asString() == "kotlin.Deprecated"
                } && annotations.none { it.type.classOrNull == javaLangDeprecated?.symbol }
            val jldConstructor = javaLangDeprecatedConstructor
            if (!shouldReplace || jldConstructor == null) return annotations
            return annotations.filter {
                (it.type as? IrSimpleType)?.classFqName?.asString() != "kotlin.Deprecated"
            } +
                // Note we lose any arguments to @java.lang.Deprecated that were written in source.
                IrConstructorCallImpl.fromSymbolOwner(
                    UNDEFINED_OFFSET,
                    UNDEFINED_OFFSET,
                    jldConstructor.returnType,
                    jldConstructor.symbol,
                    0
                )
        }

        private fun extractAnnotations(
            c: IrAnnotationContainer,
            annotations: List<IrConstructorCall>,
            parent: Label<out DbExprparent>,
            extractEnumTypeAccesses: Boolean
        ) {
            val origin =
                (c as? IrDeclaration)?.origin
                    ?: run {
                        logger.warn("Unexpected annotation container: $c")
                        return
                    }
            val replacedAnnotations =
                if (origin == IrDeclarationOrigin.IR_EXTERNAL_JAVA_DECLARATION_STUB)
                    replaceKotlinDeprecatedAnnotation(annotations)
                else annotations
            val groupedAnnotations =
                metaAnnotationSupport.groupRepeatableAnnotations(replacedAnnotations)
            for ((idx, constructorCall: IrConstructorCall) in
                groupedAnnotations.sortedBy { v -> v.type.classFqName?.asString() }.withIndex()) {
                extractAnnotation(constructorCall, parent, idx, extractEnumTypeAccesses)
            }
        }

        private fun extractAnnotations(
            c: IrAnnotationContainer,
            parent: Label<out DbExprparent>,
            extractEnumTypeAccesses: Boolean
        ) {
            extractAnnotations(c, c.annotations, parent, extractEnumTypeAccesses)
        }

        private fun extractAnnotation(
            constructorCall: IrConstructorCall,
            parent: Label<out DbExprparent>,
            idx: Int,
            extractEnumTypeAccesses: Boolean,
            contextLabel: String? = null
        ): Label<out DbExpr> {
            // Erase the type here because the JVM lowering erases the annotation type, and so the Java
            // extractor will see it in erased form.
            val t = useType(erase(constructorCall.type))
            val annotationContextLabel = contextLabel ?: "{${t.javaResult.id}}"
            val id =
                tw.getLabelFor<DbDeclannotation>("@\"annotation;{$parent};$annotationContextLabel\"")
            tw.writeExprs_declannotation(id, t.javaResult.id, parent, idx)
            tw.writeExprsKotlinType(id, t.kotlinResult.id)

            val locId = tw.getLocation(constructorCall)
            tw.writeHasLocation(id, locId)

            for (i in 0 until constructorCall.valueArgumentsCount) {
                val param = constructorCall.symbol.owner.valueParameters[i]
                val prop =
                    constructorCall.symbol.owner.parentAsClass.declarations
                        .filterIsInstance<IrProperty>()
                        .first { it.name == param.name }
                val v = constructorCall.getValueArgument(i) ?: param.defaultValue?.expression
                val getter = prop.getter
                if (getter == null) {
                    logger.warnElement("Expected annotation property to define a getter", prop)
                } else {
                    val getterId = useFunction<DbMethod>(getter)
                    if (getterId == null) {
                        logger.errorElement("Couldn't get ID for getter", getter)
                    } else {
                        val exprId =
                            extractAnnotationValueExpression(
                                v,
                                id,
                                i,
                                "{$getterId}",
                                getter.returnType,
                                extractEnumTypeAccesses
                            )
                        if (exprId != null) {
                            tw.writeAnnotValue(id, getterId, exprId)
                        }
                    }
                }
            }
            return id
        }

        private fun extractAnnotationValueExpression(
            v: IrExpression?,
            parent: Label<out DbExprparent>,
            idx: Int,
            contextLabel: String,
            contextType: IrType?,
            extractEnumTypeAccesses: Boolean
        ): Label<out DbExpr>? {

            fun exprId() = tw.getLabelFor<DbExpr>("@\"annotationExpr;{$parent};$idx\"")

            return when (v) {
                is IrConst<*> -> {
                    extractConstant(v, null, parent, idx, null, overrideId = exprId())
                }
                is IrGetEnumValue -> {
                    extractEnumValue(
                        v,
                        parent,
                        idx,
                        null,
                        null,
                        extractTypeAccess = extractEnumTypeAccesses,
                        overrideId = exprId()
                    )
                }
                is IrClassReference -> {
                    val classRefId = exprId()
                    val typeAccessId =
                        tw.getLabelFor<DbUnannotatedtypeaccess>("@\"annotationExpr;{$classRefId};0\"")
                    extractClassReference(
                        v,
                        parent,
                        idx,
                        null,
                        null,
                        overrideId = classRefId,
                        typeAccessOverrideId = typeAccessId,
                        useJavaLangClassType = true
                    )
                }
                is IrConstructorCall -> {
                    extractAnnotation(v, parent, idx, extractEnumTypeAccesses, contextLabel)
                }
                is IrVararg -> {
                    tw.getLabelFor<DbArrayinit>("@\"annotationarray;{$parent};$contextLabel\"").also {
                        arrayId ->
                        // Use the context type (i.e., the type the annotation expects, not the actual
                        // type of the array)
                        // because the Java extractor fills in array types using the same technique.
                        // These should only
                        // differ for generic annotations.
                        if (contextType == null) {
                            logger.warnElement(
                                "Expected an annotation array to have an enclosing context",
                                v
                            )
                        } else {
                            val type = useType(kClassToJavaClass(contextType))
                            tw.writeExprs_arrayinit(arrayId, type.javaResult.id, parent, idx)
                            tw.writeExprsKotlinType(arrayId, type.kotlinResult.id)
                            tw.writeHasLocation(arrayId, tw.getLocation(v))

                            v.elements.forEachIndexed { index, irVarargElement ->
                                run {
                                    val argExpr =
                                        when (irVarargElement) {
                                            is IrExpression -> irVarargElement
                                            is IrSpreadElement -> irVarargElement.expression
                                            else -> {
                                                logger.errorElement(
                                                    "Unrecognised IrVarargElement: " +
                                                        irVarargElement.javaClass,
                                                    irVarargElement
                                                )
                                                null
                                            }
                                        }
                                    extractAnnotationValueExpression(
                                        argExpr,
                                        arrayId,
                                        index,
                                        "child;$index",
                                        null,
                                        extractEnumTypeAccesses
                                    )
                                }
                            }
                        }
                    }
                }
                // is IrErrorExpression
                // null
                // Note: emitting an ErrorExpr here would induce an inconsistency if this annotation is
                // later seen from source or by the Java extractor,
                // in both of which cases the real value will get extracted.
                else -> null
            }
        }

     */


    /*
        OLD: KE1
        val jvmStaticFqName = FqName("kotlin.jvm.JvmStatic")

        private fun extractJvmStaticProxyMethods(
            c: IrClass,
            classId: Label<out DbClassorinterface>,
            extractPrivateMembers: Boolean,
            extractFunctionBodies: Boolean
        ) {

            // Add synthetic forwarders for any JvmStatic methods or properties:
            val companionObject = c.companionObject() ?: return

            val cType = c.typeWith()
            val companionType = companionObject.typeWith()

            fun makeProxyFunction(f: IrFunction) {
                // Emit a function in class `c` that delegates to the same function defined on
                // `c.CompanionInstance`.
                val proxyFunctionId = tw.getLabelFor<DbMethod>(getFunctionLabel(f, classId, listOf()))
                // We extract the function prototype with its ID overridden to belong to `c` not the
                // companion object,
                // but suppress outputting the body, which we will replace with a delegating call below.
                forceExtractFunction(
                    f,
                    classId,
                    extractBody = false,
                    extractMethodAndParameterTypeAccesses = extractFunctionBodies,
                    extractAnnotations = false,
                    typeSubstitution = null,
                    classTypeArgsIncludingOuterClasses = listOf(),
                    extractOrigin = false,
                    OverriddenFunctionAttributes(id = proxyFunctionId)
                )
                addModifiers(proxyFunctionId, "static")
                tw.writeCompiler_generated(
                    proxyFunctionId,
                    CompilerGeneratedKinds.JVMSTATIC_PROXY_METHOD.kind
                )
                if (extractFunctionBodies) {
                    val realFunctionLocId = tw.getLocation(f)
                    extractExpressionBody(proxyFunctionId, realFunctionLocId).also { returnId ->
                        extractRawMethodAccess(
                            f,
                            realFunctionLocId,
                            f.returnType,
                            proxyFunctionId,
                            returnId,
                            0,
                            returnId,
                            f.valueParameters.size,
                            { argParent, idxOffset ->
                                f.valueParameters.forEachIndexed { idx, param ->
                                    val syntheticParamId = useValueParameter(param, proxyFunctionId)
                                    extractVariableAccess(
                                        syntheticParamId,
                                        param.type,
                                        realFunctionLocId,
                                        argParent,
                                        idxOffset + idx,
                                        proxyFunctionId,
                                        returnId
                                    )
                                }
                            },
                            companionType,
                            { callId ->
                                val companionField =
                                    useCompanionObjectClassInstance(companionObject)?.id
                                extractVariableAccess(
                                        companionField,
                                        companionType,
                                        realFunctionLocId,
                                        callId,
                                        -1,
                                        proxyFunctionId,
                                        returnId
                                    )
                                    .also { varAccessId ->
                                        extractTypeAccessRecursive(
                                            cType,
                                            realFunctionLocId,
                                            varAccessId,
                                            -1,
                                            proxyFunctionId,
                                            returnId
                                        )
                                    }
                            },
                            null
                        )
                    }
                }
            }

            companionObject.declarations.forEach {
                if (shouldExtractDecl(it, extractPrivateMembers)) {
                    val wholeDeclAnnotated = it.hasAnnotation(jvmStaticFqName)
                    when (it) {
                        is IrFunction -> {
                            if (wholeDeclAnnotated) {
                                makeProxyFunction(it)
                                if (it.hasAnnotation(jvmOverloadsFqName)) {
                                    extractGeneratedOverloads(
                                        it,
                                        classId,
                                        classId,
                                        extractFunctionBodies,
                                        extractMethodAndParameterTypeAccesses = extractFunctionBodies,
                                        typeSubstitution = null,
                                        classTypeArgsIncludingOuterClasses = listOf()
                                    )
                                }
                            }
                        }
                        is IrProperty -> {
                            it.getter?.let { getter ->
                                if (wholeDeclAnnotated || getter.hasAnnotation(jvmStaticFqName))
                                    makeProxyFunction(getter)
                            }
                            it.setter?.let { setter ->
                                if (wholeDeclAnnotated || setter.hasAnnotation(jvmStaticFqName))
                                    makeProxyFunction(setter)
                            }
                        }
                    }
                }
            }
        }

        /**
         * This function traverses the declaration-parent hierarchy upwards, and retrieves the enclosing
         * class of a class to extract the `enclInReftype` relation. Additionally, it extracts a
         * companion field for a companion object into its parent class.
         *
         * Note that the nested class can also be a local class declared inside a function, so the
         * upwards traversal is skipping the non-class parents. Also, in some cases the file class is
         * the enclosing one, which has no IR representation.
         */
        private fun extractEnclosingClass(
            declarationParent:
                IrDeclarationParent, // The declaration parent of the element for which we are
                                     // extracting the enclosing class
            innerId: Label<out DbClassorinterface>, // ID of the inner class
            innerClass:
                IrClass?, // The inner class, if available. It's not available if the enclosing class of
                          // a generated class is being extracted
            innerLocId: Label<DbLocation>, // Location of the inner class
            parentClassTypeArguments:
                List<
                    IrTypeArgument
                >? // Type arguments of the parent class. If `parentClassTypeArguments` is null, the
                   // parent class is a raw type
        ) {
            with("enclosing class", declarationParent) {
                var parent: IrDeclarationParent? = declarationParent
                while (parent != null) {
                    if (parent is IrClass) {
                        val parentId = useClassInstance(parent, parentClassTypeArguments).typeResult.id
                        tw.writeEnclInReftype(innerId, parentId)
                        if (innerClass != null && innerClass.isCompanion) {
                            // If we are a companion then our parent has a
                            //     public static final ParentClass$CompanionObjectClass
                            // CompanionObjectName;
                            // that we need to fabricate here
                            val instance = useCompanionObjectClassInstance(innerClass)
                            if (instance != null) {
                                val type = useSimpleTypeClass(innerClass, emptyList(), false)
                                tw.writeFields(
                                    instance.id,
                                    instance.name,
                                    type.javaResult.id,
                                    parentId,
                                    instance.id
                                )
                                tw.writeFieldsKotlinType(instance.id, type.kotlinResult.id)
                                tw.writeHasLocation(instance.id, innerLocId)
                                addModifiers(instance.id, "public", "static", "final")
                                tw.writeType_companion_object(parentId, instance.id, innerId)
                            }
                        }

                        break
                    } else if (parent is IrFile) {
                        if (innerClass != null && !innerClass.isLocal) {
                            // We don't have to extract file class containers for classes except for
                            // local classes
                            break
                        }
                        if (this.filePath != parent.path) {
                            logger.error("Unexpected file parent found")
                        }
                        val fileId = extractFileClass(parent)
                        tw.writeEnclInReftype(innerId, fileId)
                        break
                    }

                    parent = (parent as? IrDeclaration)?.parent
                }
            }
        }

        private data class FieldResult(val id: Label<DbField>, val name: String)

        private fun useCompanionObjectClassInstance(c: IrClass): FieldResult? {
            val parent = c.parent
            if (!c.isCompanion) {
                logger.error("Using companion instance for non-companion class")
                return null
            } else if (parent !is IrClass) {
                logger.error("Using companion instance for non-companion class")
                return null
            } else {
                val parentId = useClassInstance(parent, listOf()).typeResult.id
                val instanceName = c.name.asString()
                val instanceLabel = "@\"field;{$parentId};$instanceName\""
                val instanceId: Label<DbField> = tw.getLabelFor(instanceLabel)
                return FieldResult(instanceId, instanceName)
            }
        }

        private fun useObjectClassInstance(c: IrClass): FieldResult {
            if (!c.isNonCompanionObject) {
                logger.error("Using instance for non-object class")
            }
            val classId = useClassInstance(c, listOf()).typeResult.id
            val instanceName = "INSTANCE"
            val instanceLabel = "@\"field;{$classId};$instanceName\""
            val instanceId: Label<DbField> = tw.getLabelFor(instanceLabel)
            return FieldResult(instanceId, instanceName)
        }

        @OptIn(ObsoleteDescriptorBasedAPI::class)
        private fun hasSynthesizedParameterNames(f: IrFunction) =
            f.descriptor.hasSynthesizedParameterNames()

        private fun extractValueParameter(
            vp: IrValueParameter,
            parent: Label<out DbCallable>,
            idx: Int,
            typeSubstitution: TypeSubstitution?,
            parentSourceDeclaration: Label<out DbCallable>,
            classTypeArgsIncludingOuterClasses: List<IrTypeArgument>?,
            extractTypeAccess: Boolean,
            locOverride: Label<DbLocation>? = null
        ): TypeResults {
            with("value parameter", vp) {
                val location = locOverride ?: getLocation(vp, classTypeArgsIncludingOuterClasses)
                val maybeAlteredType =
                    (vp.parent as? IrFunction)?.let {
                        if (overridesCollectionsMethodWithAlteredParameterTypes(it))
                            eraseCollectionsMethodParameterType(vp.type, it.name.asString(), idx)
                        else if (
                            (vp.parent as? IrConstructor)?.parentClassOrNull?.kind ==
                                ClassKind.ANNOTATION_CLASS
                        )
                            kClassToJavaClass(vp.type)
                        else null
                    } ?: vp.type
                val javaType =
                    (vp.parent as? IrFunction)?.let {
                        getJavaCallable(it)?.let { jCallable ->
                            getJavaValueParameterType(jCallable, idx)
                        }
                    }
                val typeWithWildcards =
                    addJavaLoweringWildcards(
                        maybeAlteredType,
                        !getInnermostWildcardSupppressionAnnotation(vp),
                        javaType
                    )
                val substitutedType =
                    typeSubstitution?.let { it(typeWithWildcards, TypeContext.OTHER, pluginContext) }
                        ?: typeWithWildcards
                val id = useValueParameter(vp, parent)
                if (extractTypeAccess) {
                    extractTypeAccessRecursive(substitutedType, location, id, -1)
                }
                val syntheticParameterNames =
                    isUnderscoreParameter(vp) ||
                        ((vp.parent as? IrFunction)?.let { hasSynthesizedParameterNames(it) } ?: true)
                val javaParameter =
                    when (val callable = (vp.parent as? IrFunction)?.let { getJavaCallable(it) }) {
                        is JavaConstructor -> callable.valueParameters.getOrNull(idx)
                        is JavaMethod -> callable.valueParameters.getOrNull(idx)
                        else -> null
                    }
                val extraAnnotations =
                    listOfNotNull(
                        getNullabilityAnnotation(
                            vp.type,
                            vp.origin,
                            vp.annotations,
                            javaParameter?.annotations
                        )
                    )
                extractAnnotations(vp, vp.annotations + extraAnnotations, id, extractTypeAccess)
                return extractValueParameter(
                    id,
                    substitutedType,
                    vp.name.asString(),
                    location,
                    parent,
                    idx,
                    useValueParameter(vp, parentSourceDeclaration),
                    syntheticParameterNames,
                    vp.isVararg,
                    vp.isNoinline,
                    vp.isCrossinline
                )
            }
        }

        /**
         * mkContainerLabel is a lambda so that we get laziness: If the container is a file, then we
         * don't want to extract the file class unless something actually needs it.
         */
        private fun extractStaticInitializer(
            container: IrDeclarationContainer,
            mkContainerLabel: () -> Label<out DbClassorinterface>
        ) {
            with("static initializer extraction", container) {
                extractDeclInitializers(container.declarations, true) {
                    val containerId = mkContainerLabel()
                    val clinitLabel =
                        getFunctionLabel(
                            container,
                            containerId,
                            "<clinit>",
                            listOf(),
                            pluginContext.irBuiltIns.unitType,
                            extensionParamType = null,
                            functionTypeParameters = listOf(),
                            classTypeArgsIncludingOuterClasses = listOf(),
                            overridesCollectionsMethod = false,
                            javaSignature = null,
                            addParameterWildcardsByDefault = false
                        )
                    val clinitId = tw.getLabelFor<DbMethod>(clinitLabel)
                    val returnType = useType(pluginContext.irBuiltIns.unitType, TypeContext.RETURN)
                    tw.writeMethods(
                        clinitId,
                        "<clinit>",
                        "<clinit>()",
                        returnType.javaResult.id,
                        containerId,
                        clinitId
                    )
                    tw.writeMethodsKotlinType(clinitId, returnType.kotlinResult.id)

                    tw.writeCompiler_generated(
                        clinitId,
                        CompilerGeneratedKinds.CLASS_INITIALISATION_METHOD.kind
                    )

                    val locId = tw.getWholeFileLocation()
                    tw.writeHasLocation(clinitId, locId)

                    addModifiers(clinitId, "static")

                    // add and return body block:
                    Pair(extractBlockBody(clinitId, locId), clinitId)
                }
            }
        }

        private fun extractInstanceInitializerBlock(
            parent: StmtParent,
            enclosingConstructor: IrConstructor
        ) {
            with("object initializer block", enclosingConstructor) {
                val constructorId = useFunction<DbConstructor>(enclosingConstructor)
                if (constructorId == null) {
                    logger.errorElement("Cannot get ID for constructor", enclosingConstructor)
                    return
                }
                val enclosingClass = enclosingConstructor.parentClassOrNull
                if (enclosingClass == null) {
                    logger.errorElement("Constructor's parent is not a class", enclosingConstructor)
                    return
                }

                // Don't make this block lazily since we need to insert something at the given
                // parent.idx position,
                // and in the case where there are no initializers to emit an empty block is an
                // acceptable filler.
                val initBlockId =
                    tw.getFreshIdLabel<DbBlock>().also {
                        tw.writeStmts_block(it, parent.parent, parent.idx, constructorId)
                        val locId = tw.getLocation(enclosingConstructor)
                        tw.writeHasLocation(it, locId)
                    }
                extractDeclInitializers(enclosingClass.declarations, false) {
                    Pair(initBlockId, constructorId)
                }
            }
        }

        private fun extractDeclInitializers(
            declarations: List<IrDeclaration>,
            extractStaticInitializers: Boolean,
            makeEnclosingBlock: () -> Pair<Label<DbBlock>, Label<out DbCallable>>
        ) {
            val blockAndFunctionId by lazy { makeEnclosingBlock() }

            // Extract field initializers and init blocks (the latter can only occur in object
            // initializers)
            var idx = 0

            fun extractFieldInitializer(f: IrDeclaration) {
                val static: Boolean
                val initializer: IrExpressionBody?
                val lhsType: TypeResults?
                val vId: Label<out DbVariable>?
                val isAnnotationClassField: Boolean
                if (f is IrField) {
                    static = f.isStatic
                    initializer = f.initializer
                    isAnnotationClassField = isAnnotationClassField(f)
                    lhsType = useType(if (isAnnotationClassField) kClassToJavaClass(f.type) else f.type)
                    vId = useField(f)
                } else if (f is IrEnumEntry) {
                    static = true
                    initializer = f.initializerExpression
                    isAnnotationClassField = false
                    lhsType = getEnumEntryType(f)
                    if (lhsType == null) {
                        return
                    }
                    vId = useEnumEntry(f)
                } else {
                    return
                }

                if (static != extractStaticInitializers || initializer == null) {
                    return
                }

                val expr = initializer.expression

                val declLocId = tw.getLocation(f)
                extractExpressionStmt(
                        declLocId,
                        blockAndFunctionId.first,
                        idx++,
                        blockAndFunctionId.second
                    )
                    .also { stmtId ->
                        val type =
                            if (isAnnotationClassField) kClassToJavaClass(expr.type) else expr.type
                        extractAssignExpr(type, declLocId, stmtId, 0, blockAndFunctionId.second, stmtId)
                            .also { assignmentId ->
                                tw.writeKtInitializerAssignment(assignmentId)
                                extractVariableAccess(
                                        vId,
                                        lhsType,
                                        declLocId,
                                        assignmentId,
                                        0,
                                        blockAndFunctionId.second,
                                        stmtId
                                    )
                                    .also { lhsId ->
                                        if (static) {
                                            extractStaticTypeAccessQualifier(
                                                f,
                                                lhsId,
                                                declLocId,
                                                blockAndFunctionId.second,
                                                stmtId
                                            )
                                        }
                                    }
                                extractExpressionExpr(
                                    expr,
                                    blockAndFunctionId.second,
                                    assignmentId,
                                    1,
                                    stmtId
                                )
                            }
                    }
            }

            for (decl in declarations) {
                when (decl) {
                    is IrProperty -> {
                        decl.backingField?.let { extractFieldInitializer(it) }
                    }
                    is IrField -> {
                        extractFieldInitializer(decl)
                    }
                    is IrEnumEntry -> {
                        extractFieldInitializer(decl)
                    }
                    is IrAnonymousInitializer -> {
                        if (decl.isStatic != extractStaticInitializers) {
                            continue
                        }

                        for (stmt in decl.body.statements) {
                            extractStatement(
                                stmt,
                                blockAndFunctionId.second,
                                blockAndFunctionId.first,
                                idx++
                            )
                        }
                    }
                    else -> continue
                }
            }
        }

        private fun isKotlinDefinedInterface(cls: IrClass?) =
            cls != null &&
                cls.isInterface &&
                cls.origin != IrDeclarationOrigin.IR_EXTERNAL_JAVA_DECLARATION_STUB

        private fun needsInterfaceForwarder(f: IrFunction) =
            // jvmDefaultModeEnabledIsEnabled means that -Xjvm-default=all or all-compatibility was
            // used, in which case real Java default interfaces are used, and we don't need to do
            // anything.
            // Otherwise, for a Kotlin-defined method inheriting a Kotlin-defined default, we need to
            // create a synthetic method like
            // `int f(int x) { return super.InterfaceWithDefault.f(x); }`, because kotlinc will generate
            // a public method and Java callers may directly target it.
            // (NB. kotlinc's actual implementation strategy is different -- it makes an inner class
            // called InterfaceWithDefault$DefaultImpls and stores the default methods
            // there to allow default method usage in Java < 8, but this is hopefully niche.
            !jvmDefaultModeEnabledIsEnabled(
                pluginContext.languageVersionSettings
                .getFlag(JvmAnalysisFlags.jvmDefaultMode)) &&
                f.parentClassOrNull.let {
                    it != null &&
                        it.origin != IrDeclarationOrigin.IR_EXTERNAL_JAVA_DECLARATION_STUB &&
                        it.modality != Modality.ABSTRACT
                } &&
                f.realOverrideTarget.let {
                    it != f &&
                        (it as? IrSimpleFunction)?.modality != Modality.ABSTRACT &&
                        isKotlinDefinedInterface(it.parentClassOrNull)
                }

        private fun makeInterfaceForwarder(
            f: IrFunction,
            parentId: Label<out DbReftype>,
            extractBody: Boolean,
            extractMethodAndParameterTypeAccesses: Boolean,
            typeSubstitution: TypeSubstitution?,
            classTypeArgsIncludingOuterClasses: List<IrTypeArgument>?
        ) =
            forceExtractFunction(
                    f,
                    parentId,
                    extractBody = false,
                    extractMethodAndParameterTypeAccesses,
                    extractAnnotations = false,
                    typeSubstitution,
                    classTypeArgsIncludingOuterClasses,
                    overriddenAttributes =
                        OverriddenFunctionAttributes(
                            visibility = DescriptorVisibilities.PUBLIC,
                            modality = Modality.OPEN
                        )
                )
                .also { functionId ->
                    tw.writeCompiler_generated(
                        functionId,
                        CompilerGeneratedKinds.INTERFACE_FORWARDER.kind
                    )
                    if (extractBody) {
                        val realFunctionLocId = tw.getLocation(f)
                        val inheritedDefaultFunction = f.realOverrideTarget
                        val directlyInheritedSymbol =
                            when (f) {
                                is IrSimpleFunction ->
                                    f.overriddenSymbols.find { it.owner === inheritedDefaultFunction }
                                        ?: f.overriddenSymbols.find {
                                            it.owner.realOverrideTarget === inheritedDefaultFunction
                                        }
                                        ?: inheritedDefaultFunction.symbol
                                else ->
                                    inheritedDefaultFunction
                                        .symbol // This is strictly invalid, since we shouldn't use
                                                // A.super.f(...) where A may not be a direct supertype,
                                                // but this path should also be unreachable.
                            }
                        val defaultDefiningInterfaceType =
                            (directlyInheritedSymbol.owner.parentClassOrNull ?: return functionId)
                                .typeWith()

                        extractExpressionBody(functionId, realFunctionLocId).also { returnId ->
                            extractRawMethodAccess(
                                f,
                                realFunctionLocId,
                                f.returnType,
                                functionId,
                                returnId,
                                0,
                                returnId,
                                f.valueParameters.size,
                                { argParentId, idxOffset ->
                                    f.valueParameters.mapIndexed { idx, param ->
                                        val syntheticParamId = useValueParameter(param, functionId)
                                        extractVariableAccess(
                                            syntheticParamId,
                                            param.type,
                                            realFunctionLocId,
                                            argParentId,
                                            idxOffset + idx,
                                            functionId,
                                            returnId
                                        )
                                    }
                                },
                                f.dispatchReceiverParameter?.type,
                                { callId ->
                                    extractSuperAccess(
                                        defaultDefiningInterfaceType,
                                        functionId,
                                        callId,
                                        -1,
                                        returnId,
                                        realFunctionLocId
                                    )
                                },
                                null
                            )
                        }
                    }
                }
    */

    /*
    OLD: KE1
        private fun extractDefaultsFunction(
            f: IrFunction,
            parentId: Label<out DbReftype>,
            extractBody: Boolean,
            extractMethodAndParameterTypeAccesses: Boolean
        ) {
            if (f.valueParameters.none { it.defaultValue != null }) return

            val id = getDefaultsMethodLabel(f)
            if (id == null) {
                logger.errorElement("Cannot get defaults method label for function", f)
                return
            }
            val locId = getLocation(f, null)
            val extReceiver = f.extensionReceiverParameter
            val dispatchReceiver = if (f.shouldExtractAsStatic) null else f.dispatchReceiverParameter
            val parameterTypes = getDefaultsMethodArgTypes(f)
            val allParamTypeResults =
                parameterTypes.mapIndexed { i, paramType ->
                    val paramId = tw.getLabelFor<DbParam>(getValueParameterLabel(id, i))
                    extractValueParameter(
                            paramId,
                            paramType,
                            "p$i",
                            locId,
                            id,
                            i,
                            paramId,
                            isVararg = false,
                            syntheticParameterNames = true,
                            isCrossinline = false,
                            isNoinline = false
                        )
                        .also {
                            if (extractMethodAndParameterTypeAccesses)
                                extractTypeAccess(useType(paramType), locId, paramId, -1)
                        }
                }
            val paramsSignature =
                allParamTypeResults.joinToString(separator = ",", prefix = "(", postfix = ")") {
                    signatureOrWarn(it.javaResult, f)
                }
            val shortName = getDefaultsMethodName(f)

            if (f.symbol is IrConstructorSymbol) {
                val constrId = id.cast<DbConstructor>()
                extractConstructor(constrId, shortName, paramsSignature, parentId, constrId)
            } else {
                val methodId = id.cast<DbMethod>()
                extractMethod(
                    methodId,
                    locId,
                    shortName,
                    erase(f.returnType),
                    paramsSignature,
                    parentId,
                    methodId,
                    origin = null,
                    extractTypeAccess = extractMethodAndParameterTypeAccesses
                )
                addModifiers(id, "static")
                if (extReceiver != null) {
                    val idx = if (dispatchReceiver != null) 1 else 0
                    val extendedType = allParamTypeResults[idx]
                    tw.writeKtExtensionFunctions(
                        methodId,
                        extendedType.javaResult.id,
                        extendedType.kotlinResult.id
                    )
                }
            }
            tw.writeHasLocation(id, locId)
            if (
                f.visibility != DescriptorVisibilities.PRIVATE &&
                    f.visibility != DescriptorVisibilities.PRIVATE_TO_THIS
            ) {
                // Private methods have package-private (default) visibility $default methods; all other
                // visibilities seem to produce a public $default method.
                addModifiers(id, "public")
            }
            tw.writeCompiler_generated(id, CompilerGeneratedKinds.DEFAULT_ARGUMENTS_METHOD.kind)

            if (extractBody) {
                val nonSyntheticParams = listOfNotNull(dispatchReceiver) + f.valueParameters
                // This stack entry represents as if we're extracting the 'real' function `f`, giving
                // the indices of its non-synthetic parameters
                // such that when we extract the default expressions below, any reference to f's nth
                // parameter will resolve to f$default's
                // n + o'th parameter, where `o` is the parameter offset caused by adding any dispatch
                // receiver to the parameter list.
                // Note we don't need to add the extension receiver here because `useValueParameter`
                // always assumes an extension receiver
                // will be prepended if one exists.
                val realFunctionId = useFunction<DbCallable>(f, parentId, null)
                DeclarationStackAdjuster(
                        f,
                        OverriddenFunctionAttributes(
                            id,
                            id,
                            locId,
                            nonSyntheticParams,
                            typeParameters = listOf(),
                            isStatic = true
                        )
                    )
                    .use {
                        val realParamsVarId = getValueParameterLabel(id, parameterTypes.size - 2)
                        val intType = pluginContext.irBuiltIns.intType
                        val paramIdxOffset =
                            listOf(dispatchReceiver, f.extensionReceiverParameter).count { it != null }
                        extractBlockBody(id, locId).also { blockId ->
                            var nextStmt = 0
                            // For each parameter with a default, sub in the default value if the caller
                            // hasn't supplied a value:
                            f.valueParameters.forEachIndexed { paramIdx, param ->
                                val defaultVal = param.defaultValue
                                if (defaultVal != null) {
                                    extractIfStmt(locId, blockId, nextStmt++, id).also { ifId ->
                                        // if (realParams & thisParamBit == 0) ...
                                        extractEqualsExpression(locId, ifId, 0, id, ifId).also { eqId ->
                                            extractAndbitExpression(intType, locId, eqId, 0, id, ifId)
                                                .also { opId ->
                                                    extractConstantInteger(
                                                        1 shl paramIdx,
                                                        locId,
                                                        opId,
                                                        0,
                                                        id,
                                                        ifId
                                                    )
                                                    extractVariableAccess(
                                                        tw.getLabelFor<DbParam>(realParamsVarId),
                                                        intType,
                                                        locId,
                                                        opId,
                                                        1,
                                                        id,
                                                        ifId
                                                    )
                                                }
                                            extractConstantInteger(0, locId, eqId, 1, id, ifId)
                                        }
                                        // thisParamVar = defaultExpr...
                                        extractExpressionStmt(locId, ifId, 1, id).also { exprStmtId ->
                                            extractAssignExpr(
                                                    param.type,
                                                    locId,
                                                    exprStmtId,
                                                    0,
                                                    id,
                                                    exprStmtId
                                                )
                                                .also { assignId ->
                                                    extractVariableAccess(
                                                        tw.getLabelFor<DbParam>(
                                                            getValueParameterLabel(
                                                                id,
                                                                paramIdx + paramIdxOffset
                                                            )
                                                        ),
                                                        param.type,
                                                        locId,
                                                        assignId,
                                                        0,
                                                        id,
                                                        exprStmtId
                                                    )
                                                    extractExpressionExpr(
                                                        defaultVal.expression,
                                                        id,
                                                        assignId,
                                                        1,
                                                        exprStmtId
                                                    )
                                                }
                                        }
                                    }
                                }
                            }
                            // Now call the real function:
                            if (f is IrConstructor) {
                                tw.getFreshIdLabel<DbConstructorinvocationstmt>().also { thisCallId ->
                                    tw.writeStmts_constructorinvocationstmt(
                                        thisCallId,
                                        blockId,
                                        nextStmt++,
                                        id
                                    )
                                    tw.writeHasLocation(thisCallId, locId)
                                    f.valueParameters.forEachIndexed { idx, param ->
                                        extractVariableAccess(
                                            tw.getLabelFor<DbParam>(getValueParameterLabel(id, idx)),
                                            param.type,
                                            locId,
                                            thisCallId,
                                            idx,
                                            id,
                                            thisCallId
                                        )
                                    }
                                    tw.writeCallableBinding(thisCallId, realFunctionId)
                                }
                            } else {
                                tw.getFreshIdLabel<DbReturnstmt>().also { returnId ->
                                    tw.writeStmts_returnstmt(returnId, blockId, nextStmt++, id)
                                    tw.writeHasLocation(returnId, locId)
                                    extractMethodAccessWithoutArgs(
                                            f.returnType,
                                            locId,
                                            id,
                                            returnId,
                                            0,
                                            returnId,
                                            realFunctionId
                                        )
                                        .also { thisCallId ->
                                            val realFnIdxOffset =
                                                if (f.extensionReceiverParameter != null) 1 else 0
                                            val paramMappings =
                                                f.valueParameters.mapIndexed { idx, param ->
                                                    Triple(
                                                        param.type,
                                                        idx + paramIdxOffset,
                                                        idx + realFnIdxOffset
                                                    )
                                                } +
                                                    listOfNotNull(
                                                        dispatchReceiver?.let {
                                                            Triple(it.type, 0, -1)
                                                        },
                                                        extReceiver?.let {
                                                            Triple(
                                                                it.type,
                                                                if (dispatchReceiver != null) 1 else 0,
                                                                0
                                                            )
                                                        }
                                                    )
                                            paramMappings.forEach { (type, fromIdx, toIdx) ->
                                                extractVariableAccess(
                                                    tw.getLabelFor<DbParam>(
                                                        getValueParameterLabel(id, fromIdx)
                                                    ),
                                                    type,
                                                    locId,
                                                    thisCallId,
                                                    toIdx,
                                                    id,
                                                    returnId
                                                )
                                            }
                                            if (f.shouldExtractAsStatic)
                                                extractStaticTypeAccessQualifier(
                                                    f,
                                                    thisCallId,
                                                    locId,
                                                    id,
                                                    returnId
                                                )
                                            else if (f.isLocalFunction()) {
                                                extractNewExprForLocalFunction(
                                                    getLocallyVisibleFunctionLabels(f),
                                                    thisCallId,
                                                    locId,
                                                    id,
                                                    returnId
                                                )
                                            }
                                        }
                                }
                            }
                        }
                    }
            }
        }

        private val jvmOverloadsFqName = FqName("kotlin.jvm.JvmOverloads")

        private fun extractGeneratedOverloads(
            f: IrFunction,
            parentId: Label<out DbReftype>,
            maybeSourceParentId: Label<out DbReftype>?,
            extractBody: Boolean,
            extractMethodAndParameterTypeAccesses: Boolean,
            typeSubstitution: TypeSubstitution?,
            classTypeArgsIncludingOuterClasses: List<IrTypeArgument>?
        ) {

            fun extractGeneratedOverload(paramList: List<IrValueParameter?>) {
                val overloadParameters = paramList.filterNotNull()
                // Note `overloadParameters` have incorrect parents and indices, since there is no
                // actual IrFunction describing the required synthetic overload.
                // We have to use the `overriddenAttributes` element of `DeclarationStackAdjuster` to
                // fix up references to these parameters while we're extracting
                // these synthetic overloads.
                val overloadId =
                    tw.getLabelFor<DbCallable>(
                        getFunctionLabel(
                            f,
                            parentId,
                            classTypeArgsIncludingOuterClasses,
                            overloadParameters
                        )
                    )
                val sourceParentId =
                    maybeSourceParentId
                        ?: if (typeSubstitution != null) useDeclarationParentOf(f, false) else parentId
                if (sourceParentId == null) {
                    logger.errorElement("Cannot get source parent ID for function", f)
                    return
                }
                val sourceDeclId =
                    tw.getLabelFor<DbCallable>(
                        getFunctionLabel(f, sourceParentId, listOf(), overloadParameters)
                    )
                val overriddenAttributes =
                    OverriddenFunctionAttributes(
                        id = overloadId,
                        sourceDeclarationId = sourceDeclId,
                        valueParameters = overloadParameters
                    )
                forceExtractFunction(
                    f,
                    parentId,
                    extractBody = false,
                    extractMethodAndParameterTypeAccesses,
                    extractAnnotations = false,
                    typeSubstitution,
                    classTypeArgsIncludingOuterClasses,
                    overriddenAttributes = overriddenAttributes
                )
                tw.writeCompiler_generated(overloadId, CompilerGeneratedKinds.JVMOVERLOADS_METHOD.kind)
                val realFunctionLocId = tw.getLocation(f)
                if (extractBody) {

                    DeclarationStackAdjuster(f, overriddenAttributes).use {

                        // Create a synthetic function body that calls the corresponding $default
                        // function:
                        val regularArgs =
                            paramList.map { it?.let { p -> IrGetValueImpl(-1, -1, p.symbol) } }

                        if (f is IrConstructor) {
                            val blockId = extractBlockBody(overloadId, realFunctionLocId)
                            val constructorCallId = tw.getFreshIdLabel<DbConstructorinvocationstmt>()
                            tw.writeStmts_constructorinvocationstmt(
                                constructorCallId,
                                blockId,
                                0,
                                overloadId
                            )
                            tw.writeHasLocation(constructorCallId, realFunctionLocId)
                            tw.writeCallableBinding(
                                constructorCallId,
                                getDefaultsMethodLabel(f, parentId)
                            )

                            extractDefaultsCallArguments(
                                constructorCallId,
                                f,
                                overloadId,
                                constructorCallId,
                                regularArgs,
                                null,
                                null
                            )
                        } else {
                            val dispatchReceiver =
                                f.dispatchReceiverParameter?.let { IrGetValueImpl(-1, -1, it.symbol) }
                            val extensionReceiver =
                                f.extensionReceiverParameter?.let { IrGetValueImpl(-1, -1, it.symbol) }

                            extractExpressionBody(overloadId, realFunctionLocId).also { returnId ->
                                extractsDefaultsCall(
                                    f,
                                    realFunctionLocId,
                                    f.returnType,
                                    overloadId,
                                    returnId,
                                    0,
                                    returnId,
                                    regularArgs,
                                    dispatchReceiver,
                                    extensionReceiver
                                )
                            }
                        }
                    }
                }
            }

            if (!f.hasAnnotation(jvmOverloadsFqName)) {
                if (
                    f is IrConstructor &&
                        f.valueParameters.isNotEmpty() &&
                        f.valueParameters.all { it.defaultValue != null } &&
                        f.parentClassOrNull?.let {
                            // Don't create a default constructor for an annotation class, or a class
                            // that explicitly declares a no-arg constructor.
                            !it.isAnnotationClass &&
                                it.declarations.none { d ->
                                    d is IrConstructor && d.valueParameters.isEmpty()
                                }
                        } == true
                ) {
                    // Per https://kotlinlang.org/docs/classes.html#creating-instances-of-classes, a
                    // single default overload gets created specifically
                    // when we have all default parameters, regardless of `@JvmOverloads`.
                    extractGeneratedOverload(f.valueParameters.map { _ -> null })
                }
                return
            }

            val paramList: MutableList<IrValueParameter?> = f.valueParameters.toMutableList()
            for (n in (f.valueParameters.size - 1) downTo 0) {
                if (f.valueParameters[n].defaultValue != null) {
                    paramList[n] = null // Remove this parameter, to be replaced by a default value
                    extractGeneratedOverload(paramList)
                }
            }
        }

        private fun extractConstructor(
            id: Label<out DbConstructor>,
            shortName: String,
            paramsSignature: String,
            parentId: Label<out DbReftype>,
            sourceDeclaration: Label<out DbConstructor>
        ) {
            val unitType = useType(pluginContext.irBuiltIns.unitType, TypeContext.RETURN)
            tw.writeConstrs(
                id,
                shortName,
                "$shortName$paramsSignature",
                unitType.javaResult.id,
                parentId,
                sourceDeclaration
            )
            tw.writeConstrsKotlinType(id, unitType.kotlinResult.id)
        }
    */


    /*
    OLD: KE1
        private fun signatureOrWarn(t: TypeResult<*>, associatedElement: IrElement?) =
            t.signature
                ?: "<signature unavailable>"
                    .also {
                        if (associatedElement != null)
                            logger.warnElement(
                                "Needed a signature for a type that doesn't have one",
                                associatedElement
                            )
                        else logger.warn("Needed a signature for a type that doesn't have one")
                    }

        private fun getNullabilityAnnotationName(
            t: IrType,
            declOrigin: IrDeclarationOrigin,
            existingAnnotations: List<IrConstructorCall>,
            javaAnnotations: Collection<JavaAnnotation>?
        ): FqName? {
            if (t !is IrSimpleType) return null

            fun hasExistingAnnotation(name: FqName) =
                existingAnnotations.any { existing -> existing.type.classFqName == name }

            return if (declOrigin == IrDeclarationOrigin.IR_EXTERNAL_JAVA_DECLARATION_STUB) {
                // Java declaration: restore a NotNull or Nullable annotation if the original Java
                // member had one but the Kotlin compiler removed it.
                javaAnnotations
                    ?.mapNotNull { it.classId?.asSingleFqName() }
                    ?.singleOrNull {
                        NOT_NULL_ANNOTATIONS.contains(it) || NULLABLE_ANNOTATIONS.contains(it)
                    }
                    ?.takeUnless { hasExistingAnnotation(it) }
            } else {
                // Kotlin declaration: add a NotNull annotation to a non-nullable non-primitive type,
                // unless one is already present.
                // Usually Kotlin declarations can't have a manual `@NotNull`, but this happens at least
                // when delegating members are
                // synthesised and inherit the annotation from the delegate (which given it has
                // @NotNull, is likely written in Java)
                JvmAnnotationNames.JETBRAINS_NOT_NULL_ANNOTATION.takeUnless {
                    t.isNullable() ||
                        primitiveTypeMapping.getPrimitiveInfo(t) != null ||
                        hasExistingAnnotation(it)
                }
            }
        }

        private fun getNullabilityAnnotation(
            t: IrType,
            declOrigin: IrDeclarationOrigin,
            existingAnnotations: List<IrConstructorCall>,
            javaAnnotations: Collection<JavaAnnotation>?
        ) =
            getNullabilityAnnotationName(t, declOrigin, existingAnnotations, javaAnnotations)?.let {
                getClassByFqName(pluginContext, it)?.let { annotationClass ->
                    annotationClass.owner.declarations.firstIsInstanceOrNull<IrConstructor>()?.let {
                        annotationConstructor ->
                        IrConstructorCallImpl.fromSymbolOwner(
                            UNDEFINED_OFFSET,
                            UNDEFINED_OFFSET,
                            annotationConstructor.returnType,
                            annotationConstructor.symbol,
                            0
                        )
                    }
                }
            }
    */

    /*
    OLD: KE1
        private fun isStaticFunction(f: IrFunction): Boolean {
            return f.dispatchReceiverParameter == null // Has no dispatch receiver,
            &&
                !f
                    .isLocalFunction() // not a local function. Local functions are extracted as
                                       // instance methods with the local class instantiation as the
                                       // qualifier
                &&
                f.symbol !is IrConstructorSymbol // not a constructor
        }

        private fun extractField(
            f: IrField,
            parentId: Label<out DbReftype>,
            extractAnnotationEnumTypeAccesses: Boolean
        ): Label<out DbField> {
            with("field", f) {
                DeclarationStackAdjuster(f).use {
                    val fNameSuffix =
                        getExtensionReceiverType(f)?.let {
                            it.classFqName?.asString()?.replace(".", "$$")
                        } ?: ""
                    val extractType =
                        if (isAnnotationClassField(f)) kClassToJavaClass(f.type) else f.type
                    val id = useField(f)
                    extractAnnotations(f, id, extractAnnotationEnumTypeAccesses)
                    return extractField(
                        id,
                        "${f.name.asString()}$fNameSuffix",
                        extractType,
                        parentId,
                        tw.getLocation(f),
                        f.visibility,
                        f,
                        isExternalDeclaration(f),
                        f.isFinal,
                        isDirectlyExposedCompanionObjectField(f)
                    )
                }
            }
        }

        private fun extractField(
            id: Label<out DbField>,
            name: String,
            type: IrType,
            parentId: Label<out DbReftype>,
            locId: Label<DbLocation>,
            visibility: DescriptorVisibility,
            errorElement: IrElement,
            isExternalDeclaration: Boolean,
            isFinal: Boolean,
            isStatic: Boolean
        ): Label<out DbField> {
            val t = useType(type)
            tw.writeFields(id, name, t.javaResult.id, parentId, id)
            tw.writeFieldsKotlinType(id, t.kotlinResult.id)
            tw.writeHasLocation(id, locId)

            extractVisibility(errorElement, id, visibility)
            if (isFinal) {
                addModifiers(id, "final")
            }
            if (isStatic) {
                addModifiers(id, "static")
            }

            if (!isExternalDeclaration) {
                val fieldDeclarationId = tw.getFreshIdLabel<DbFielddecl>()
                tw.writeFielddecls(fieldDeclarationId, parentId)
                tw.writeFieldDeclaredIn(id, fieldDeclarationId, 0)
                tw.writeHasLocation(fieldDeclarationId, locId)

                extractTypeAccessRecursive(type, locId, fieldDeclarationId, 0)
            }

            return id
        }

        private fun extractProperty(
            p: IrProperty,
            parentId: Label<out DbReftype>,
            extractBackingField: Boolean,
            extractFunctionBodies: Boolean,
            extractPrivateMembers: Boolean,
            extractAnnotations: Boolean,
            typeSubstitution: TypeSubstitution?,
            classTypeArgsIncludingOuterClasses: List<IrTypeArgument>?
        ) {
            with("property", p) {
                fun needsInterfaceForwarderQ(f: IrFunction?) =
                    f?.let { needsInterfaceForwarder(f) } ?: false

                DeclarationStackAdjuster(p).use {
                    val id = useProperty(p, parentId, classTypeArgsIncludingOuterClasses)
                    val locId = getLocation(p, classTypeArgsIncludingOuterClasses)
                    tw.writeKtProperties(id, p.name.asString())
                    tw.writeHasLocation(id, locId)

                    val bf = p.backingField
                    val getter = p.getter
                    val setter = p.setter

                    if (getter == null) {
                        if (!isExternalDeclaration(p)) {
                            logger.warnElement("IrProperty without a getter", p)
                        }
                    } else if (shouldExtractDecl(getter, extractPrivateMembers)) {
                        val getterId =
                            extractFunction(
                                    getter,
                                    parentId,
                                    extractBody = extractFunctionBodies,
                                    extractMethodAndParameterTypeAccesses = extractFunctionBodies,
                                    extractAnnotations = extractAnnotations,
                                    typeSubstitution,
                                    classTypeArgsIncludingOuterClasses
                                )
                                ?.cast<DbMethod>()
                        if (getterId != null) {
                            tw.writeKtPropertyGetters(id, getterId)
                            if (getter.origin == IrDeclarationOrigin.DELEGATED_PROPERTY_ACCESSOR) {
                                tw.writeCompiler_generated(
                                    getterId,
                                    CompilerGeneratedKinds.DELEGATED_PROPERTY_GETTER.kind
                                )
                            }
                        }
                    }

                    if (setter == null) {
                        if (p.isVar && !isExternalDeclaration(p)) {
                            logger.warnElement("isVar property without a setter", p)
                        }
                    } else if (shouldExtractDecl(setter, extractPrivateMembers)) {
                        if (!p.isVar) {
                            logger.warnElement("!isVar property with a setter", p)
                        }
                        val setterId =
                            extractFunction(
                                    setter,
                                    parentId,
                                    extractBody = extractFunctionBodies,
                                    extractMethodAndParameterTypeAccesses = extractFunctionBodies,
                                    extractAnnotations = extractAnnotations,
                                    typeSubstitution,
                                    classTypeArgsIncludingOuterClasses
                                )
                                ?.cast<DbMethod>()
                        if (setterId != null) {
                            tw.writeKtPropertySetters(id, setterId)
                            if (setter.origin == IrDeclarationOrigin.DELEGATED_PROPERTY_ACCESSOR) {
                                tw.writeCompiler_generated(
                                    setterId,
                                    CompilerGeneratedKinds.DELEGATED_PROPERTY_SETTER.kind
                                )
                            }
                        }
                    }

                    if (bf != null && extractBackingField) {
                        val fieldParentId = useDeclarationParentOf(bf, false)
                        if (fieldParentId != null) {
                            val fieldId = extractField(bf, fieldParentId.cast(), extractFunctionBodies)
                            tw.writeKtPropertyBackingFields(id, fieldId)
                            if (p.isDelegated) {
                                tw.writeKtPropertyDelegates(id, fieldId)
                            }
                        }
                    }

                    extractVisibility(p, id, p.visibility)

                    // TODO: extract annotations

                    if (p.isLateinit) {
                        addModifiers(id, "lateinit")
                    }
                }
            }
        }

        private fun getEnumEntryType(ee: IrEnumEntry): TypeResults? {
            val parent = ee.parent
            if (parent !is IrClass) {
                logger.errorElement("Enum entry with unexpected parent: " + parent.javaClass, ee)
                return null
            } else if (parent.typeParameters.isNotEmpty()) {
                logger.errorElement("Enum entry parent class has type parameters: " + parent.name, ee)
                return null
            } else {
                return useSimpleTypeClass(parent, emptyList(), false)
            }
        }

        private fun extractEnumEntry(
            ee: IrEnumEntry,
            parentId: Label<out DbReftype>,
            extractPrivateMembers: Boolean,
            extractFunctionBodies: Boolean
        ) {
            with("enum entry", ee) {
                DeclarationStackAdjuster(ee).use {
                    val id = useEnumEntry(ee)
                    val type = getEnumEntryType(ee) ?: return
                    tw.writeFields(id, ee.name.asString(), type.javaResult.id, parentId, id)
                    tw.writeFieldsKotlinType(id, type.kotlinResult.id)
                    val locId = tw.getLocation(ee)
                    tw.writeHasLocation(id, locId)
                    tw.writeIsEnumConst(id)

                    if (extractFunctionBodies) {
                        val fieldDeclarationId = tw.getFreshIdLabel<DbFielddecl>()
                        tw.writeFielddecls(fieldDeclarationId, parentId)
                        tw.writeFieldDeclaredIn(id, fieldDeclarationId, 0)
                        tw.writeHasLocation(fieldDeclarationId, locId)

                        extractTypeAccess(type, locId, fieldDeclarationId, 0)
                    }

                    ee.correspondingClass?.let {
                        extractDeclaration(
                            it,
                            extractPrivateMembers,
                            extractFunctionBodies,
                            extractAnnotations = true
                        )
                    }

                    extractAnnotations(ee, id, extractFunctionBodies)
                }
            }
        }

        private fun extractTypeAlias(ta: IrTypeAlias) {
            with("type alias", ta) {
                if (ta.typeParameters.isNotEmpty()) {
                    // TODO: Extract this information
                    return
                }
                val id = useTypeAlias(ta)
                val locId = tw.getLocation(ta)
                // TODO: We don't really want to generate any Java types here; we only want the KT type:
                val type = useType(ta.expandedType)
                tw.writeKt_type_alias(id, ta.name.asString(), type.kotlinResult.id)
                tw.writeHasLocation(id, locId)

                // TODO: extract annotations
            }
        }
    */


    /*
    OLD: KE1
        private fun extractIfStmt(
            locId: Label<DbLocation>,
            parent: Label<out DbStmtparent>,
            idx: Int,
            callable: Label<out DbCallable>
        ) =
            tw.getFreshIdLabel<DbIfstmt>().also {
                tw.writeStmts_ifstmt(it, parent, idx, callable)
                tw.writeHasLocation(it, locId)
            }

        /**
         * Returns true iff `c` is a call to the function `fName` in the `kotlin.internal.ir` package.
         * This is used to find calls to builtin functions, which need to be handled specially as they
         * do not have corresponding source definitions.
         */
        private fun isBuiltinCallInternal(c: IrCall, fName: String) =
            isBuiltinCall(c, fName, "kotlin.internal.ir")
        /**
         * Returns true iff `c` is a call to the function `fName` in the `kotlin` package. This is used
         * to find calls to builtin functions, which need to be handled specially as they do not have
         * corresponding source definitions.
         */
        private fun isBuiltinCallKotlin(c: IrCall, fName: String) = isBuiltinCall(c, fName, "kotlin")

        /**
         * Returns true iff `c` is a call to the function `fName` in package `pName`. This is used to
         * find calls to builtin functions, which need to be handled specially as they do not have
         * corresponding source definitions.
         */
        private fun isBuiltinCall(c: IrCall, fName: String, pName: String): Boolean {
            val verbose = false
            fun verboseln(s: String) {
                if (verbose) println(s)
            }
            verboseln("Attempting builtin match for $fName")
            val target = c.symbol.owner
            if (target.name.asString() != fName) {
                verboseln("No match as function name is ${target.name.asString()} not $fName")
                return false
            }

            val targetPkg = target.parent
            if (targetPkg !is IrPackageFragment) {
                verboseln("No match as didn't find target package")
                return false
            }
            val targetName = targetPkg.packageFqName.asString()
            if (targetName != pName) {
                verboseln("No match as package name is $targetName")
                return false
            }
            verboseln("Match")
            return true
        }

        private fun unaryOp(
            id: Label<out DbExpr>,
            c: IrCall,
            callable: Label<out DbCallable>,
            enclosingStmt: Label<out DbStmt>
        ) {
            val locId = tw.getLocation(c)
            extractExprContext(id, locId, callable, enclosingStmt)

            val dr = c.dispatchReceiver
            if (dr != null) {
                logger.errorElement("Unexpected dispatch receiver found", c)
            }

            if (c.valueArgumentsCount < 1) {
                logger.errorElement("No arguments found", c)
                return
            }

            extractArgument(id, c, callable, enclosingStmt, 0, "Operand null")

            if (c.valueArgumentsCount > 1) {
                logger.errorElement("Extra arguments found", c)
            }
        }

        private fun binOp(
            id: Label<out DbExpr>,
            c: IrCall,
            callable: Label<out DbCallable>,
            enclosingStmt: Label<out DbStmt>
        ) {
            val locId = tw.getLocation(c)
            extractExprContext(id, locId, callable, enclosingStmt)

            val dr = c.dispatchReceiver
            if (dr != null) {
                logger.errorElement("Unexpected dispatch receiver found", c)
            }

            if (c.valueArgumentsCount < 1) {
                logger.errorElement("No arguments found", c)
                return
            }

            extractArgument(id, c, callable, enclosingStmt, 0, "LHS null")

            if (c.valueArgumentsCount < 2) {
                logger.errorElement("No RHS found", c)
                return
            }

            extractArgument(id, c, callable, enclosingStmt, 1, "RHS null")

            if (c.valueArgumentsCount > 2) {
                logger.errorElement("Extra arguments found", c)
            }
        }

        private fun extractArgument(
            id: Label<out DbExpr>,
            c: IrCall,
            callable: Label<out DbCallable>,
            enclosingStmt: Label<out DbStmt>,
            idx: Int,
            msg: String
        ) {
            val op = c.getValueArgument(idx)
            if (op == null) {
                logger.errorElement(msg, c)
            } else {
                extractExpressionExpr(op, callable, id, idx, enclosingStmt)
            }
        }

        private fun findFunction(cls: IrClass, name: String): IrFunction? =
            cls.declarations.findSubType<IrFunction> { it.name.asString() == name }

        val jvmIntrinsicsClass by lazy { referenceExternalClass("kotlin.jvm.internal.Intrinsics") }

        private fun findJdkIntrinsicOrWarn(name: String, warnAgainstElement: IrElement): IrFunction? {
            val result = jvmIntrinsicsClass?.let { findFunction(it, name) }
            if (result == null) {
                logger.errorElement("Couldn't find JVM intrinsic function $name", warnAgainstElement)
            }
            return result
        }

        private fun findTopLevelFunctionOrWarn(
            functionPkg: String,
            functionName: String,
            type: String,
            parameterTypes: Array<String>,
            warnAgainstElement: IrElement
        ): IrFunction? {

            val fn =
                getFunctionsByFqName(pluginContext, functionPkg, functionName)
                    .firstOrNull { fnSymbol ->
                        val owner = fnSymbol.owner
                        (owner.parentClassOrNull?.fqNameWhenAvailable?.asString() == type ||
                            (owner.parent is IrExternalPackageFragment &&
                                getFileClassFqName(owner)?.asString() == type)) &&
                            owner.valueParameters
                                .map { it.type.classFqName?.asString() }
                                .toTypedArray() contentEquals parameterTypes
                    }
                    ?.owner

            if (fn != null) {
                if (fn.parentClassOrNull != null) {
                    extractExternalClassLater(fn.parentAsClass)
                }
            } else {
                logger.errorElement(
                    "Couldn't find JVM intrinsic function $functionPkg $functionName in $type",
                    warnAgainstElement
                )
            }

            return fn
        }

        private fun findTopLevelPropertyOrWarn(
            propertyPkg: String,
            propertyName: String,
            type: String,
            warnAgainstElement: IrElement
        ): IrProperty? {

            val prop =
                getPropertiesByFqName(pluginContext, propertyPkg, propertyName)
                    .firstOrNull { it.owner.parentClassOrNull?.fqNameWhenAvailable?.asString() == type }
                    ?.owner

            if (prop != null) {
                if (prop.parentClassOrNull != null) {
                    extractExternalClassLater(prop.parentAsClass)
                }
            } else {
                logger.errorElement(
                    "Couldn't find JVM intrinsic property $propertyPkg $propertyName in $type",
                    warnAgainstElement
                )
            }

            return prop
        }

        val javaLangString by lazy { referenceExternalClass("java.lang.String") }

        val stringValueOfObjectMethod by lazy {
            val result =
                javaLangString?.declarations?.findSubType<IrFunction> {
                    it.name.asString() == "valueOf" &&
                        it.valueParameters.size == 1 &&
                        it.valueParameters[0].type == pluginContext.irBuiltIns.anyNType
                }
            if (result == null) {
                logger.error("Couldn't find declaration java.lang.String.valueOf(Object)")
            }
            result
        }

        val objectCloneMethod by lazy {
            val result =
                javaLangObject?.declarations?.findSubType<IrFunction> { it.name.asString() == "clone" }
            if (result == null) {
                logger.error("Couldn't find declaration java.lang.Object.clone(...)")
            }
            result
        }

        val kotlinNoWhenBranchMatchedExn by lazy {
            referenceExternalClass("kotlin.NoWhenBranchMatchedException")
        }

        val kotlinNoWhenBranchMatchedConstructor by lazy {
            val result =
                kotlinNoWhenBranchMatchedExn?.declarations?.findSubType<IrConstructor> {
                    it.valueParameters.isEmpty()
                }
            if (result == null) {
                logger.error("Couldn't find no-arg constructor for kotlin.NoWhenBranchMatchedException")
            }
            result
        }

        val javaUtilArrays by lazy { referenceExternalClass("java.util.Arrays") }

        private fun isFunction(
            target: IrFunction,
            pkgName: String,
            classNameLogged: String,
            classNamePredicate: (String) -> Boolean,
            vararg fNames: String,
            isNullable: Boolean? = false
        ) =
            fNames.any {
                isFunction(target, pkgName, classNameLogged, classNamePredicate, it, isNullable)
            }

        private fun isFunction(
            target: IrFunction,
            pkgName: String,
            classNameLogged: String,
            classNamePredicate: (String) -> Boolean,
            fName: String,
            isNullable: Boolean? = false
        ): Boolean {
            val verbose = false
            fun verboseln(s: String) {
                if (verbose) println(s)
            }
            verboseln("Attempting match for $pkgName $classNameLogged $fName")
            if (target.name.asString() != fName) {
                verboseln("No match as function name is ${target.name.asString()} not $fName")
                return false
            }
            val extensionReceiverParameter = target.extensionReceiverParameter
            val targetClass =
                if (extensionReceiverParameter == null) {
                    if (isNullable == true) {
                        verboseln(
                            "Nullablility of type didn't match (target is not an extension method)"
                        )
                        return false
                    }
                    target.parent
                } else {
                    val st = extensionReceiverParameter.type as? IrSimpleType
                    if (isNullable != null && st?.isNullable() != isNullable) {
                        verboseln("Nullablility of type didn't match")
                        return false
                    }
                    st?.classifier?.owner
                }
            if (targetClass !is IrClass) {
                verboseln("No match as didn't find target class")
                return false
            }
            if (!classNamePredicate(targetClass.name.asString())) {
                verboseln(
                    "No match as class name is ${targetClass.name.asString()} not $classNameLogged"
                )
                return false
            }
            val targetPkg = targetClass.parent
            if (targetPkg !is IrPackageFragment) {
                verboseln("No match as didn't find target package")
                return false
            }
            val targetName = targetPkg.packageFqName.asString()
            if (targetName != pkgName) {
                verboseln("No match as package name is $targetName not $pkgName")
                return false
            }
            verboseln("Match")
            return true
        }

        private fun isFunction(
            target: IrFunction,
            pkgName: String,
            className: String,
            fName: String,
            isNullable: Boolean? = false
        ) = isFunction(target, pkgName, className, { it == className }, fName, isNullable)

        private fun isArrayType(typeName: String) =
            when (typeName) {
                "Array" -> true
                "IntArray" -> true
                "ByteArray" -> true
                "ShortArray" -> true
                "LongArray" -> true
                "FloatArray" -> true
                "DoubleArray" -> true
                "CharArray" -> true
                "BooleanArray" -> true
                else -> false
            }

        private fun isGenericArrayType(typeName: String) =
            when (typeName) {
                "Array" -> true
                else -> false
            }

        private fun extractCall(
            c: IrCall,
            callable: Label<out DbCallable>,
            stmtExprParent: StmtExprParent
        ) {
            with("call", c) {
                val owner = getBoundSymbolOwner(c.symbol, c) ?: return
                val target = tryReplaceSyntheticFunction(owner)

                // The vast majority of types of call want an expr context, so make one available
                // lazily:
                val exprParent by lazy { stmtExprParent.expr(c, callable) }

                val parent by lazy { exprParent.parent }

                val idx by lazy { exprParent.idx }

                val enclosingStmt by lazy { exprParent.enclosingStmt }

                fun extractMethodAccess(
                    syntacticCallTarget: IrFunction,
                    extractMethodTypeArguments: Boolean = true,
                    extractClassTypeArguments: Boolean = false
                ) {
                    val typeArgs =
                        if (extractMethodTypeArguments)
                            (0 until c.typeArgumentsCount)
                                .map { c.getTypeArgument(it) }
                                .requireNoNullsOrNull()
                        else listOf()

                    if (typeArgs == null) {
                        logger.warn("Missing type argument in extractMethodAccess")
                        return
                    }

                    extractRawMethodAccess(
                        syntacticCallTarget,
                        c,
                        c.type,
                        callable,
                        parent,
                        idx,
                        enclosingStmt,
                        (0 until c.valueArgumentsCount).map { c.getValueArgument(it) },
                        c.dispatchReceiver,
                        c.extensionReceiver,
                        typeArgs,
                        extractClassTypeArguments,
                        c.superQualifierSymbol
                    )
                }

                fun extractSpecialEnumFunction(fnName: String) {
                    if (c.typeArgumentsCount != 1) {
                        logger.errorElement("Expected to find exactly one type argument", c)
                        return
                    }

                    val enumType = (c.getTypeArgument(0) as? IrSimpleType)?.classifier?.owner
                    if (enumType == null) {
                        logger.errorElement("Couldn't find type of enum type", c)
                        return
                    }

                    if (enumType is IrClass) {
                        val func =
                            enumType.declarations.findSubType<IrFunction> {
                                it.name.asString() == fnName
                            }
                        if (func == null) {
                            logger.errorElement("Couldn't find function $fnName on enum type", c)
                            return
                        }

                        extractMethodAccess(func, false)
                    } else if (enumType is IrTypeParameter && enumType.isReified) {
                        // A call to `enumValues<T>()` is being extracted, where `T` is a reified type
                        // parameter of an `inline` function.
                        // We can't generate a valid expression here, because we would need to know the
                        // type of T on the call site.
                        // TODO: replace error expression with something that better shows this
                        // expression is unrepresentable.
                        val id = tw.getFreshIdLabel<DbErrorexpr>()
                        val type = useType(c.type)

                        tw.writeExprs_errorexpr(id, type.javaResult.id, parent, idx)
                        tw.writeExprsKotlinType(id, type.kotlinResult.id)
                        extractExprContext(id, tw.getLocation(c), callable, enclosingStmt)
                    } else {
                        logger.errorElement("Unexpected enum type rep ${enumType.javaClass}", c)
                    }
                }

                fun binopReceiver(
                    id: Label<out DbExpr>,
                    receiver: IrExpression?,
                    receiverDescription: String
                ) {
                    extractExprContext(id, tw.getLocation(c), callable, enclosingStmt)

                    if (receiver == null) {
                        logger.errorElement("$receiverDescription not found", c)
                    } else {
                        extractExpressionExpr(receiver, callable, id, 0, enclosingStmt)
                    }
                    if (c.valueArgumentsCount < 1) {
                        logger.errorElement("No RHS found", c)
                    } else {
                        if (c.valueArgumentsCount > 1) {
                            logger.errorElement("Extra arguments found", c)
                        }
                        val arg = c.getValueArgument(0)
                        if (arg == null) {
                            logger.errorElement("RHS null", c)
                        } else {
                            extractExpressionExpr(arg, callable, id, 1, enclosingStmt)
                        }
                    }
                }

                fun unaryopReceiver(
                    id: Label<out DbExpr>,
                    receiver: IrExpression?,
                    receiverDescription: String
                ) {
                    extractExprContext(id, tw.getLocation(c), callable, enclosingStmt)

                    if (receiver == null) {
                        logger.errorElement("$receiverDescription not found", c)
                    } else {
                        extractExpressionExpr(receiver, callable, id, 0, enclosingStmt)
                    }
                    if (c.valueArgumentsCount > 0) {
                        logger.errorElement("Extra arguments found", c)
                    }
                }

                /**
                 * Populate the lhs of a binary op from this call's dispatch receiver, and the rhs from
                 * its sole argument.
                 */
                fun binopDisp(id: Label<out DbExpr>) {
                    binopReceiver(id, c.dispatchReceiver, "Dispatch receiver")
                }

                fun binopExt(id: Label<out DbExpr>) {
                    binopReceiver(id, c.extensionReceiver, "Extension receiver")
                }

                fun unaryopDisp(id: Label<out DbExpr>) {
                    unaryopReceiver(id, c.dispatchReceiver, "Dispatch receiver")
                }

                fun unaryopExt(id: Label<out DbExpr>) {
                    unaryopReceiver(id, c.extensionReceiver, "Extension receiver")
                }

                val dr = c.dispatchReceiver
                when {
                    // != gets desugared into not and ==. Here we resugar it.
                    c.origin == IrStatementOrigin.EXCLEQ &&
                        isFunction(target, "kotlin", "Boolean", "not") &&
                        c.valueArgumentsCount == 0 &&
                        dr != null &&
                        dr is IrCall &&
                        isBuiltinCallInternal(dr, "EQEQ") -> {
                        val id = tw.getFreshIdLabel<DbValueneexpr>()
                        val type = useType(c.type)
                        tw.writeExprs_valueneexpr(id, type.javaResult.id, parent, idx)
                        tw.writeExprsKotlinType(id, type.kotlinResult.id)
                        binOp(id, dr, callable, enclosingStmt)
                    }
                    c.origin == IrStatementOrigin.EXCLEQ &&
                        isFunction(target, "kotlin", "Boolean", "not") &&
                        c.valueArgumentsCount == 0 &&
                        dr != null &&
                        dr is IrCall &&
                        isBuiltinCallInternal(dr, "ieee754equals") -> {
                        val id = tw.getFreshIdLabel<DbNeexpr>()
                        val type = useType(c.type)
                        tw.writeExprs_neexpr(id, type.javaResult.id, parent, idx)
                        tw.writeExprsKotlinType(id, type.kotlinResult.id)
                        binOp(id, dr, callable, enclosingStmt)
                    }
                    isNumericFunction(target, "inv") -> {
                        val type = useType(c.type)
                        val id: Label<out DbExpr> =
                            when (val targetName = target.name.asString()) {
                                "inv" -> {
                                    val id = tw.getFreshIdLabel<DbBitnotexpr>()
                                    tw.writeExprs_bitnotexpr(id, type.javaResult.id, parent, idx)
                                    id
                                }
                                else -> {
                                    logger.errorElement("Unhandled unary target name: $targetName", c)
                                    return
                                }
                            }
                        tw.writeExprsKotlinType(id, type.kotlinResult.id)
                        if (
                            isFunction(
                                target,
                                "kotlin",
                                "Byte or Short",
                                { it == "Byte" || it == "Short" },
                                "inv"
                            )
                        )
                            unaryopExt(id)
                        else unaryopDisp(id)
                    }
                    // We need to handle all the builtin operators defines in BuiltInOperatorNames in
                    //     compiler/ir/ir.tree/src/org/jetbrains/kotlin/ir/IrBuiltIns.kt
                    // as they can't be extracted as external dependencies.
                    isBuiltinCallInternal(c, "EQEQ") -> {
                        if (c.origin != IrStatementOrigin.EQEQ) {
                            logger.warnElement("Unexpected origin for EQEQ: ${c.origin}", c)
                        }
                        val id = tw.getFreshIdLabel<DbValueeqexpr>()
                        val type = useType(c.type)
                        tw.writeExprs_valueeqexpr(id, type.javaResult.id, parent, idx)
                        tw.writeExprsKotlinType(id, type.kotlinResult.id)
                        binOp(id, c, callable, enclosingStmt)
                    }
                    isBuiltinCallInternal(c, "ieee754equals") -> {
                        if (c.origin != IrStatementOrigin.EQEQ) {
                            logger.warnElement("Unexpected origin for ieee754equals: ${c.origin}", c)
                        }
                        val id = tw.getFreshIdLabel<DbEqexpr>()
                        val type = useType(c.type)
                        tw.writeExprs_eqexpr(id, type.javaResult.id, parent, idx)
                        tw.writeExprsKotlinType(id, type.kotlinResult.id)
                        binOp(id, c, callable, enclosingStmt)
                    }
                    isBuiltinCallInternal(c, "CHECK_NOT_NULL") -> {
                        if (c.origin != IrStatementOrigin.EXCLEXCL) {
                            logger.warnElement("Unexpected origin for CHECK_NOT_NULL: ${c.origin}", c)
                        }

                        val id = tw.getFreshIdLabel<DbNotnullexpr>()
                        val type = useType(c.type)
                        tw.writeExprs_notnullexpr(id, type.javaResult.id, parent, idx)
                        tw.writeExprsKotlinType(id, type.kotlinResult.id)
                        unaryOp(id, c, callable, enclosingStmt)
                    }
                    isBuiltinCallInternal(c, "THROW_CCE") -> {
                        // TODO
                        logger.errorElement("Unhandled builtin", c)
                    }
                    isBuiltinCallInternal(c, "THROW_ISE") -> {
                        // TODO
                        logger.errorElement("Unhandled builtin", c)
                    }
                    isBuiltinCallInternal(c, "noWhenBranchMatchedException") -> {
                        kotlinNoWhenBranchMatchedConstructor?.let {
                            val locId = tw.getLocation(c)
                            val thrownType = useSimpleTypeClass(it.parentAsClass, listOf(), false)
                            val stmtParent = stmtExprParent.stmt(c, callable)
                            val throwId = tw.getFreshIdLabel<DbThrowstmt>()
                            tw.writeStmts_throwstmt(
                                throwId,
                                stmtParent.parent,
                                stmtParent.idx,
                                callable
                            )
                            tw.writeHasLocation(throwId, locId)
                            val newExprId =
                                extractNewExpr(
                                    it,
                                    null,
                                    thrownType,
                                    locId,
                                    throwId,
                                    0,
                                    callable,
                                    throwId
                                )
                            if (newExprId == null) {
                                logger.errorElement(
                                    "No ID for newExpr in noWhenBranchMatchedException",
                                    c
                                )
                            } else {
                                extractTypeAccess(thrownType, locId, newExprId, -3, callable, throwId)
                            }
                        }
                    }
                    isBuiltinCallInternal(c, "illegalArgumentException") -> {
                        // TODO
                        logger.errorElement("Unhandled builtin", c)
                    }
                    isBuiltinCallInternal(c, "ANDAND") -> {
                        // TODO
                        logger.errorElement("Unhandled builtin", c)
                    }
                    isBuiltinCallInternal(c, "OROR") -> {
                        // TODO
                        logger.errorElement("Unhandled builtin", c)
                    }
                    isFunction(target, "kotlin", "Any", "toString", true) -> {
                        stringValueOfObjectMethod?.let {
                            extractRawMethodAccess(
                                it,
                                c,
                                c.type,
                                callable,
                                parent,
                                idx,
                                enclosingStmt,
                                listOf(c.extensionReceiver),
                                null,
                                null
                            )
                        }
                    }
                    isBuiltinCallKotlin(c, "enumValues") -> {
                        extractSpecialEnumFunction("values")
                    }
                    isBuiltinCallKotlin(c, "enumValueOf") -> {
                        extractSpecialEnumFunction("valueOf")
                    }
                    isBuiltinCallKotlin(c, "arrayOfNulls") -> {
                        val id = tw.getFreshIdLabel<DbArraycreationexpr>()
                        val type = useType(c.type)
                        tw.writeExprs_arraycreationexpr(id, type.javaResult.id, parent, idx)
                        tw.writeExprsKotlinType(id, type.kotlinResult.id)
                        val locId = tw.getLocation(c)
                        extractExprContext(id, locId, callable, enclosingStmt)

                        if (c.typeArgumentsCount == 1) {
                            val typeArgument = c.getTypeArgument(0)
                            if (typeArgument == null) {
                                logger.errorElement("Type argument missing in an arrayOfNulls call", c)
                            } else {
                                extractTypeAccessRecursive(
                                    typeArgument,
                                    locId,
                                    id,
                                    -1,
                                    callable,
                                    enclosingStmt,
                                    TypeContext.GENERIC_ARGUMENT
                                )
                            }
                        } else {
                            logger.errorElement(
                                "Expected to find exactly one type argument in an arrayOfNulls call",
                                c
                            )
                        }

                        if (c.valueArgumentsCount == 1) {
                            val dim = c.getValueArgument(0)
                            if (dim != null) {
                                extractExpressionExpr(dim, callable, id, 0, enclosingStmt)
                            } else {
                                logger.errorElement(
                                    "Expected to find non-null argument in an arrayOfNulls call",
                                    c
                                )
                            }
                        } else {
                            logger.errorElement(
                                "Expected to find only one argument in an arrayOfNulls call",
                                c
                            )
                        }
                    }
                    isBuiltinCallKotlin(c, "arrayOf") ||
                        isBuiltinCallKotlin(c, "doubleArrayOf") ||
                        isBuiltinCallKotlin(c, "floatArrayOf") ||
                        isBuiltinCallKotlin(c, "longArrayOf") ||
                        isBuiltinCallKotlin(c, "intArrayOf") ||
                        isBuiltinCallKotlin(c, "charArrayOf") ||
                        isBuiltinCallKotlin(c, "shortArrayOf") ||
                        isBuiltinCallKotlin(c, "byteArrayOf") ||
                        isBuiltinCallKotlin(c, "booleanArrayOf") -> {

                        val isPrimitiveArrayCreation = !isBuiltinCallKotlin(c, "arrayOf")
                        val elementType =
                            if (isPrimitiveArrayCreation) {
                                c.type.getArrayElementType(pluginContext.irBuiltIns)
                            } else {
                                // TODO: is there any reason not to always use getArrayElementType?
                                if (c.typeArgumentsCount == 1) {
                                    c.getTypeArgument(0).also {
                                        if (it == null) {
                                            logger.errorElement(
                                                "Type argument missing in an arrayOf call",
                                                c
                                            )
                                        }
                                    }
                                } else {
                                    logger.errorElement(
                                        "Expected to find one type argument in arrayOf call",
                                        c
                                    )
                                    null
                                }
                            }

                        val arg =
                            if (c.valueArgumentsCount == 1) c.getValueArgument(0)
                                else {
                                    logger.errorElement(
                                        "Expected to find only one (vararg) argument in ${c.symbol.owner.name.asString()} call",
                                        c
                                    )
                                    null
                                }
                                ?.let {
                                    if (it is IrVararg) it
                                    else {
                                        logger.errorElement(
                                            "Expected to find vararg argument in ${c.symbol.owner.name.asString()} call",
                                            c
                                        )
                                        null
                                    }
                                }

                        extractArrayCreation(
                            arg,
                            c.type,
                            elementType,
                            isPrimitiveArrayCreation,
                            c,
                            parent,
                            idx,
                            callable,
                            enclosingStmt
                        )
                    }
                    isBuiltinCall(c, "<get-java>", "kotlin.jvm") -> {
                        // Special case for KClass<*>.java, which is used in the Parcelize plugin. In
                        // normal cases, this is already rewritten to the property referenced below:
                        findTopLevelPropertyOrWarn(
                                "kotlin.jvm",
                                "java",
                                "kotlin.jvm.JvmClassMappingKt",
                                c
                            )
                            ?.let { javaProp ->
                                val getter = javaProp.getter
                                if (getter == null) {
                                    logger.error(
                                        "Couldn't find getter of `kotlin.jvm.JvmClassMappingKt::java`"
                                    )
                                    return
                                }

                                val ext = c.extensionReceiver
                                if (ext == null) {
                                    logger.errorElement(
                                        "No extension receiver found for `KClass::java` call",
                                        c
                                    )
                                    return
                                }

                                val argType =
                                    (ext.type as? IrSimpleType)?.arguments?.firstOrNull()?.typeOrNull
                                val typeArguments = if (argType == null) listOf() else listOf(argType)

                                extractRawMethodAccess(
                                    getter,
                                    c,
                                    c.type,
                                    callable,
                                    parent,
                                    idx,
                                    enclosingStmt,
                                    listOf(),
                                    null,
                                    ext,
                                    typeArguments
                                )
                            }
                    }
                    isFunction(
                        target,
                        "kotlin",
                        "(some array type)",
                        { isArrayType(it) },
                        "iterator"
                    ) -> {
                        val parentClass = target.parent
                        if (parentClass !is IrClass) {
                            logger.errorElement("Iterator parent is not a class", c)
                            return
                        }

                        var typeFilter =
                            if (isGenericArrayType(parentClass.name.asString())) {
                                "kotlin.jvm.internal.ArrayIteratorKt"
                            } else {
                                "kotlin.jvm.internal.ArrayIteratorsKt"
                            }

                        findTopLevelFunctionOrWarn(
                                "kotlin.jvm.internal",
                                "iterator",
                                typeFilter,
                                arrayOf(parentClass.kotlinFqName.asString()),
                                c
                            )
                            ?.let { iteratorFn ->
                                val dispatchReceiver = c.dispatchReceiver
                                if (dispatchReceiver == null) {
                                    logger.errorElement(
                                        "No dispatch receiver found for array iterator call",
                                        c
                                    )
                                } else {
                                    val drType = dispatchReceiver.type
                                    if (drType !is IrSimpleType) {
                                        logger.errorElement(
                                            "Dispatch receiver with unexpected type rep found for array iterator call: ${drType.javaClass}",
                                            c
                                        )
                                    } else {
                                        val typeArgs =
                                            drType.arguments.map {
                                                when (it) {
                                                    is IrTypeProjection -> it.type
                                                    else -> pluginContext.irBuiltIns.anyNType
                                                }
                                            }
                                        extractRawMethodAccess(
                                            iteratorFn,
                                            c,
                                            c.type,
                                            callable,
                                            parent,
                                            idx,
                                            enclosingStmt,
                                            listOf(c.dispatchReceiver),
                                            null,
                                            null,
                                            typeArgs
                                        )
                                    }
                                }
                            }
                    }
                    isFunction(target, "kotlin", "(some array type)", { isArrayType(it) }, "get") &&
                        c.origin == IrStatementOrigin.GET_ARRAY_ELEMENT &&
                        c.dispatchReceiver != null -> {
                        val id = tw.getFreshIdLabel<DbArrayaccess>()
                        val type = useType(c.type)
                        tw.writeExprs_arrayaccess(id, type.javaResult.id, parent, idx)
                        tw.writeExprsKotlinType(id, type.kotlinResult.id)
                        binopDisp(id)
                    }
                    isFunction(target, "kotlin", "(some array type)", { isArrayType(it) }, "set") &&
                        c.origin == IrStatementOrigin.EQ &&
                        c.dispatchReceiver != null -> {
                        val array = c.dispatchReceiver
                        val arrayIdx = c.getValueArgument(0)
                        val assignedValue = c.getValueArgument(1)

                        if (array != null && arrayIdx != null && assignedValue != null) {

                            val locId = tw.getLocation(c)
                            extractAssignExpr(c.type, locId, parent, idx, callable, enclosingStmt)
                                .also { assignId ->
                                    tw.getFreshIdLabel<DbArrayaccess>().also { arrayAccessId ->
                                        val arrayType = useType(array.type)
                                        tw.writeExprs_arrayaccess(
                                            arrayAccessId,
                                            arrayType.javaResult.id,
                                            assignId,
                                            0
                                        )
                                        tw.writeExprsKotlinType(
                                            arrayAccessId,
                                            arrayType.kotlinResult.id
                                        )
                                        extractExprContext(
                                            arrayAccessId,
                                            locId,
                                            callable,
                                            enclosingStmt
                                        )

                                        extractExpressionExpr(
                                            array,
                                            callable,
                                            arrayAccessId,
                                            0,
                                            enclosingStmt
                                        )
                                        extractExpressionExpr(
                                            arrayIdx,
                                            callable,
                                            arrayAccessId,
                                            1,
                                            enclosingStmt
                                        )
                                    }
                                    extractExpressionExpr(
                                        assignedValue,
                                        callable,
                                        assignId,
                                        1,
                                        enclosingStmt
                                    )
                                }
                        } else {
                            logger.errorElement("Unexpected Array.set function signature", c)
                        }
                    }
                    isBuiltinCall(c, "<unsafe-coerce>", "kotlin.jvm.internal") -> {

                        if (c.valueArgumentsCount != 1) {
                            logger.errorElement(
                                "Expected to find one argument for a kotlin.jvm.internal.<unsafe-coerce>() call, but found ${c.valueArgumentsCount}",
                                c
                            )
                            return
                        }

                        if (c.typeArgumentsCount != 2) {
                            logger.errorElement(
                                "Expected to find two type arguments for a kotlin.jvm.internal.<unsafe-coerce>() call, but found ${c.typeArgumentsCount}",
                                c
                            )
                            return
                        }
                        val valueArg = c.getValueArgument(0)
                        if (valueArg == null) {
                            logger.errorElement(
                                "Cannot find value argument for a kotlin.jvm.internal.<unsafe-coerce>() call",
                                c
                            )
                            return
                        }
                        val typeArg = c.getTypeArgument(1)
                        if (typeArg == null) {
                            logger.errorElement(
                                "Cannot find type argument for a kotlin.jvm.internal.<unsafe-coerce>() call",
                                c
                            )
                            return
                        }

                        val id = tw.getFreshIdLabel<DbUnsafecoerceexpr>()
                        val locId = tw.getLocation(c)
                        val type = useType(c.type)
                        tw.writeExprs_unsafecoerceexpr(id, type.javaResult.id, parent, idx)
                        tw.writeExprsKotlinType(id, type.kotlinResult.id)
                        extractExprContext(id, locId, callable, enclosingStmt)
                        extractTypeAccessRecursive(typeArg, locId, id, 0, callable, enclosingStmt)
                        extractExpressionExpr(valueArg, callable, id, 1, enclosingStmt)
                    }
                    isBuiltinCallInternal(c, "dataClassArrayMemberToString") -> {
                        val arrayArg = c.getValueArgument(0)
                        val realArrayClass = arrayArg?.type?.classOrNull
                        if (realArrayClass == null) {
                            logger.errorElement(
                                "Argument to dataClassArrayMemberToString not a class",
                                c
                            )
                            return
                        }
                        val realCallee =
                            javaUtilArrays?.declarations?.findSubType<IrFunction> { decl ->
                                decl.name.asString() == "toString" &&
                                    decl.valueParameters.size == 1 &&
                                    decl.valueParameters[0].type.classOrNull?.let {
                                        it == realArrayClass
                                    } == true
                            }
                        if (realCallee == null) {
                            logger.errorElement(
                                "Couldn't find a java.lang.Arrays.toString method matching class ${realArrayClass.owner.name}",
                                c
                            )
                        } else {
                            extractRawMethodAccess(
                                realCallee,
                                c,
                                c.type,
                                callable,
                                parent,
                                idx,
                                enclosingStmt,
                                listOf(arrayArg),
                                null,
                                null
                            )
                        }
                    }
                    isBuiltinCallInternal(c, "dataClassArrayMemberHashCode") -> {
                        val arrayArg = c.getValueArgument(0)
                        val realArrayClass = arrayArg?.type?.classOrNull
                        if (realArrayClass == null) {
                            logger.errorElement(
                                "Argument to dataClassArrayMemberHashCode not a class",
                                c
                            )
                            return
                        }
                        val realCallee =
                            javaUtilArrays?.declarations?.findSubType<IrFunction> { decl ->
                                decl.name.asString() == "hashCode" &&
                                    decl.valueParameters.size == 1 &&
                                    decl.valueParameters[0].type.classOrNull?.let {
                                        it == realArrayClass
                                    } == true
                            }
                        if (realCallee == null) {
                            logger.errorElement(
                                "Couldn't find a java.lang.Arrays.hashCode method matching class ${realArrayClass.owner.name}",
                                c
                            )
                        } else {
                            extractRawMethodAccess(
                                realCallee,
                                c,
                                c.type,
                                callable,
                                parent,
                                idx,
                                enclosingStmt,
                                listOf(arrayArg),
                                null,
                                null
                            )
                        }
                    }
                    else -> {
                        extractMethodAccess(target, true, true)
                    }
                }
            }
        }

        private fun extractArrayCreation(
            elementList: IrVararg?,
            resultType: IrType,
            elementType: IrType?,
            allowPrimitiveElementType: Boolean,
            locElement: IrElement,
            parent: Label<out DbExprparent>,
            idx: Int,
            enclosingCallable: Label<out DbCallable>,
            enclosingStmt: Label<out DbStmt>
        ) {
            // If this is [someType]ArrayOf(*x), x, otherwise null
            val clonedArray =
                elementList?.let {
                    if (it.elements.size == 1) {
                        val onlyElement = it.elements[0]
                        if (onlyElement is IrSpreadElement) onlyElement.expression else null
                    } else null
                }

            if (clonedArray != null) {
                // This is an array clone: extract is as a call to java.lang.Object.clone
                objectCloneMethod?.let {
                    extractRawMethodAccess(
                        it,
                        locElement,
                        resultType,
                        enclosingCallable,
                        parent,
                        idx,
                        enclosingStmt,
                        listOf(),
                        clonedArray,
                        null
                    )
                }
            } else {
                // This is array creation: extract it as a call to new ArrayType[] { ... }
                val id = tw.getFreshIdLabel<DbArraycreationexpr>()
                val type = useType(resultType)
                tw.writeExprs_arraycreationexpr(id, type.javaResult.id, parent, idx)
                tw.writeExprsKotlinType(id, type.kotlinResult.id)
                val locId = tw.getLocation(locElement)
                extractExprContext(id, locId, enclosingCallable, enclosingStmt)

                if (elementType != null) {
                    val typeContext =
                        if (allowPrimitiveElementType) TypeContext.OTHER
                        else TypeContext.GENERIC_ARGUMENT
                    extractTypeAccessRecursive(
                        elementType,
                        locId,
                        id,
                        -1,
                        enclosingCallable,
                        enclosingStmt,
                        typeContext
                    )
                }

                if (elementList != null) {
                    val initId = tw.getFreshIdLabel<DbArrayinit>()
                    tw.writeExprs_arrayinit(initId, type.javaResult.id, id, -2)
                    tw.writeExprsKotlinType(initId, type.kotlinResult.id)
                    extractExprContext(initId, locId, enclosingCallable, enclosingStmt)
                    elementList.elements.forEachIndexed { i, arg ->
                        extractVarargElement(arg, enclosingCallable, initId, i, enclosingStmt)
                    }

                    extractConstantInteger(
                        elementList.elements.size,
                        locId,
                        id,
                        0,
                        enclosingCallable,
                        enclosingStmt
                    )
                }
            }
        }

        private fun extractNewExpr(
            methodId: Label<out DbConstructor>,
            constructedType: TypeResults,
            locId: Label<DbLocation>,
            parent: Label<out DbExprparent>,
            idx: Int,
            callable: Label<out DbCallable>,
            enclosingStmt: Label<out DbStmt>
        ): Label<DbNewexpr> {
            val id = tw.getFreshIdLabel<DbNewexpr>()
            tw.writeExprs_newexpr(id, constructedType.javaResult.id, parent, idx)
            tw.writeExprsKotlinType(id, constructedType.kotlinResult.id)
            extractExprContext(id, locId, callable, enclosingStmt)
            tw.writeCallableBinding(id, methodId)
            return id
        }

        private fun extractNewExpr(
            calledConstructor: IrFunction,
            constructorTypeArgs: List<IrTypeArgument>?,
            constructedType: TypeResults,
            locId: Label<DbLocation>,
            parent: Label<out DbExprparent>,
            idx: Int,
            callable: Label<out DbCallable>,
            enclosingStmt: Label<out DbStmt>
        ): Label<DbNewexpr>? {
            val funId = useFunction<DbConstructor>(calledConstructor, constructorTypeArgs)
            if (funId == null) {
                logger.error("Cannot get ID for newExpr function")
                return null
            }
            return extractNewExpr(funId, constructedType, locId, parent, idx, callable, enclosingStmt)
        }

        private fun needsObinitFunction(c: IrClass) =
            c.primaryConstructor == null && c.constructors.count() > 1

        private fun getObinitLabel(c: IrClass, parentId: Label<out DbElement>): String =
            getFunctionLabel(
                c,
                parentId,
                "<obinit>",
                listOf(),
                pluginContext.irBuiltIns.unitType,
                null,
                functionTypeParameters = listOf(),
                classTypeArgsIncludingOuterClasses = listOf(),
                overridesCollectionsMethod = false,
                javaSignature = null,
                addParameterWildcardsByDefault = false
            )

        private fun extractConstructorCall(
            e: IrFunctionAccessExpression,
            parent: Label<out DbExprparent>,
            idx: Int,
            callable: Label<out DbCallable>,
            enclosingStmt: Label<out DbStmt>
        ) {
            val eType = e.type
            if (eType !is IrSimpleType) {
                logger.errorElement("Constructor call has non-simple type ${eType.javaClass}", e)
                return
            }
            val type = useType(eType)
            val isAnonymous = eType.isAnonymous
            val locId = tw.getLocation(e)
            val valueArgs = (0 until e.valueArgumentsCount).map { e.getValueArgument(it) }

            val id =
                if (
                    e !is IrEnumConstructorCall && callUsesDefaultArguments(e.symbol.owner, valueArgs)
                ) {
                    val defaultsMethodId = getDefaultsMethodLabel(e.symbol.owner)
                    if (defaultsMethodId == null) {
                        logger.errorElement("Cannot get defaults method ID", e)
                        return
                    }
                    extractNewExpr(
                            defaultsMethodId.cast(),
                            type,
                            locId,
                            parent,
                            idx,
                            callable,
                            enclosingStmt
                        )
                        .also {
                            extractDefaultsCallArguments(
                                it,
                                e.symbol.owner,
                                callable,
                                enclosingStmt,
                                valueArgs,
                                null,
                                null
                            )
                        }
                } else {
                    val newExprId =
                        extractNewExpr(
                            e.symbol.owner,
                            eType.arguments,
                            type,
                            locId,
                            parent,
                            idx,
                            callable,
                            enclosingStmt
                        )
                    if (newExprId == null) {
                        logger.errorElement("Cannot get newExpr ID", e)
                        return
                    }

                    val realCallTarget = e.symbol.owner.realOverrideTarget
                    // Generated constructor calls to kotlin.Enum have no arguments in IR, but the
                    // constructor takes two parameters.
                    if (
                        e is IrEnumConstructorCall &&
                            realCallTarget is IrConstructor &&
                            realCallTarget.parentClassOrNull?.fqNameWhenAvailable?.asString() ==
                                "kotlin.Enum" &&
                            realCallTarget.valueParameters.size == 2 &&
                            realCallTarget.valueParameters[0].type ==
                                pluginContext.irBuiltIns.stringType &&
                            realCallTarget.valueParameters[1].type == pluginContext.irBuiltIns.intType
                    ) {

                        val id0 =
                            extractNull(
                                pluginContext.irBuiltIns.stringType,
                                locId,
                                newExprId,
                                0,
                                callable,
                                enclosingStmt
                            )
                        tw.writeCompiler_generated(
                            id0,
                            CompilerGeneratedKinds.ENUM_CONSTRUCTOR_ARGUMENT.kind
                        )

                        val id1 =
                            extractConstantInteger(0, locId, newExprId, 1, callable, enclosingStmt)
                        tw.writeCompiler_generated(
                            id1,
                            CompilerGeneratedKinds.ENUM_CONSTRUCTOR_ARGUMENT.kind
                        )
                    } else {
                        extractCallValueArguments(newExprId, e, enclosingStmt, callable, 0)
                    }

                    newExprId
                }

            if (isAnonymous) {
                tw.writeIsAnonymClass(type.javaResult.id.cast(), id)
            }

            val dr = e.dispatchReceiver
            if (dr != null) {
                extractExpressionExpr(dr, callable, id, -2, enclosingStmt)
            }

            val typeAccessType =
                if (isAnonymous) {
                    val c = eType.classifier.owner
                    if (c !is IrClass) {
                        logger.warnElement("Anonymous type not a class (${c.javaClass})", e)
                    }
                    if ((c as? IrClass)?.superTypes?.size == 1) {
                        useType(c.superTypes.first())
                    } else {
                        useType(pluginContext.irBuiltIns.anyType)
                    }
                } else {
                    type
                }

            if (e is IrConstructorCall) {
                extractConstructorTypeAccess(
                    eType,
                    typeAccessType,
                    e.symbol,
                    locId,
                    id,
                    -3,
                    callable,
                    enclosingStmt
                )
            } else if (e is IrEnumConstructorCall) {
                val enumClass = e.symbol.owner.parent as? IrClass
                if (enumClass == null) {
                    logger.warnElement("Couldn't find declaring class of enum constructor call", e)
                    return
                }

                val args =
                    (0 until e.typeArgumentsCount).map { e.getTypeArgument(it) }.requireNoNullsOrNull()
                if (args == null) {
                    logger.warnElement("Found null type argument in enum constructor call", e)
                    return
                }

                val enumType = enumClass.typeWith(args)
                extractConstructorTypeAccess(
                    enumType,
                    useType(enumType),
                    e.symbol,
                    locId,
                    id,
                    -3,
                    callable,
                    enclosingStmt
                )
            } else {
                logger.errorElement("Unexpected constructor call type: ${e.javaClass}", e)
            }
        }
    */

    abstract inner class StmtExprParent {
        abstract fun stmt(e: KtExpression, callable: Label<out DbCallable>): StmtParent
        abstract fun expr(e: KtExpression, callable: Label<out DbCallable>): ExprParent
    }

    inner class StmtParent(val parent: Label<out DbStmtparent>, val idx: Int) : StmtExprParent() {
        override fun stmt(e: KtExpression, callable: Label<out DbCallable>) = this

        override fun expr(e: KtExpression, callable: Label<out DbCallable>) =
            extractExpressionStmt(tw.getLocation(e), parent, idx, callable).let { id ->
                ExprParent(id, 0, id)
            }
    }

    inner class ExprParent(
        val parent: Label<out DbExprparent>,
        val idx: Int,
        val enclosingStmt: Label<out DbStmt>
    ) : StmtExprParent() {
        override fun stmt(e: KtExpression, callable: Label<out DbCallable>): StmtParent {
            val id = tw.getFreshIdLabel<DbStmtexpr>()
            val et = e.expressionType
            val type = useType(et)
            val locId = tw.getLocation(e)
            tw.writeExprs_stmtexpr(id, type.javaResult.id, parent, idx)
            tw.writeExprsKotlinType(id, type.kotlinResult.id)
            extractExprContext(id, locId, callable, enclosingStmt)
            return StmtParent(id, 0)
        }

        override fun expr(e: KtExpression, callable: Label<out DbCallable>): ExprParent {
            return this
        }
    }

    /*
    OLD: KE1
        private fun IrValueParameter.isExtensionReceiver(): Boolean {
            val parentFun = parent as? IrFunction ?: return false
            return parentFun.extensionReceiverParameter == this
        }

        private open inner class GeneratedClassHelper(
            protected val locId: Label<DbLocation>,
            protected val ids: GeneratedClassLabels
        ) {
            protected val classId = ids.type.javaResult.id.cast<DbClassorinterface>()

            /**
             * Extract a parameter to field assignment, such as `this.field = paramName` below:
             * ```
             * constructor(paramName: type) {
             *   this.field = paramName
             * }
             * ```
             */
            fun extractParameterToFieldAssignmentInConstructor(
                paramName: String,
                paramType: IrType,
                fieldId: Label<DbField>,
                paramIdx: Int,
                stmtIdx: Int
            ) {
                val paramId = tw.getFreshIdLabel<DbParam>()
                extractValueParameter(
                    paramId,
                    paramType,
                    paramName,
                    locId,
                    ids.constructor,
                    paramIdx,
                    paramId,
                    syntheticParameterNames = false,
                    isVararg = false,
                    isNoinline = false,
                    isCrossinline = false
                )

                extractExpressionStmt(locId, ids.constructorBlock, stmtIdx, ids.constructor).also {
                    assignmentStmtId ->
                    extractAssignExpr(
                            paramType,
                            locId,
                            assignmentStmtId,
                            0,
                            ids.constructor,
                            assignmentStmtId
                        )
                        .also { assignmentId ->
                            extractVariableAccess(
                                    fieldId,
                                    paramType,
                                    locId,
                                    assignmentId,
                                    0,
                                    ids.constructor,
                                    assignmentStmtId
                                )
                                .also { lhsId ->
                                    extractThisAccess(
                                        ids.type,
                                        ids.constructor,
                                        lhsId,
                                        -1,
                                        assignmentStmtId,
                                        locId
                                    )
                                }
                            extractVariableAccess(
                                paramId,
                                paramType,
                                locId,
                                assignmentId,
                                1,
                                ids.constructor,
                                assignmentStmtId
                            )
                        }
                }
            }
        }

        data class ReceiverInfo(
            val receiver: IrExpression,
            val type: IrType,
            val field: Label<DbField>,
            val indexOffset: Int
        )

        private fun makeReceiverInfo(receiver: IrExpression?, indexOffset: Int): ReceiverInfo? {
            if (receiver == null) {
                return null
            }
            val type = receiver.type
            val field: Label<DbField> = tw.getFreshIdLabel()
            return ReceiverInfo(receiver, type, field, indexOffset)
        }

        /**
         * This is used when extracting callable references, i.e. `::someCallable` or
         * `::someReceiver::someCallable`.
         */
        private open inner class CallableReferenceHelper(
            protected val callableReferenceExpr: IrCallableReference<out IrSymbol>,
            locId: Label<DbLocation>,
            ids: GeneratedClassLabels
        ) : GeneratedClassHelper(locId, ids) {

            // Only one of the receivers can be non-null, but we defensively handle the case when both
            // are null anyway
            private val dispatchReceiverInfo =
                makeReceiverInfo(callableReferenceExpr.dispatchReceiver, 0)
            private val extensionReceiverInfo =
                makeReceiverInfo(
                    callableReferenceExpr.extensionReceiver,
                    if (dispatchReceiverInfo == null) 0 else 1
                )

            fun extractReceiverField() {
                val firstAssignmentStmtIdx = 1

                if (dispatchReceiverInfo != null) {
                    extractField(
                        dispatchReceiverInfo.field,
                        "<dispatchReceiver>",
                        dispatchReceiverInfo.type,
                        classId,
                        locId,
                        DescriptorVisibilities.PRIVATE,
                        callableReferenceExpr,
                        isExternalDeclaration = false,
                        isFinal = true,
                        isStatic = false
                    )
                    extractParameterToFieldAssignmentInConstructor(
                        "<dispatchReceiver>",
                        dispatchReceiverInfo.type,
                        dispatchReceiverInfo.field,
                        0 + dispatchReceiverInfo.indexOffset,
                        firstAssignmentStmtIdx + dispatchReceiverInfo.indexOffset
                    )
                }

                if (extensionReceiverInfo != null) {
                    extractField(
                        extensionReceiverInfo.field,
                        "<extensionReceiver>",
                        extensionReceiverInfo.type,
                        classId,
                        locId,
                        DescriptorVisibilities.PRIVATE,
                        callableReferenceExpr,
                        isExternalDeclaration = false,
                        isFinal = true,
                        isStatic = false
                    )
                    extractParameterToFieldAssignmentInConstructor(
                        "<extensionReceiver>",
                        extensionReceiverInfo.type,
                        extensionReceiverInfo.field,
                        0 + extensionReceiverInfo.indexOffset,
                        firstAssignmentStmtIdx + extensionReceiverInfo.indexOffset
                    )
                }
            }

            protected fun writeVariableAccessInFunctionBody(
                pType: TypeResults,
                idx: Int,
                variable: Label<out DbVariable>,
                parent: Label<out DbExprparent>,
                callable: Label<out DbCallable>,
                stmt: Label<out DbStmt>
            ): Label<DbVaraccess> {
                val pId = tw.getFreshIdLabel<DbVaraccess>()
                tw.writeExprs_varaccess(pId, pType.javaResult.id, parent, idx)
                tw.writeExprsKotlinType(pId, pType.kotlinResult.id)
                tw.writeVariableBinding(pId, variable)
                extractExprContext(pId, locId, callable, stmt)
                return pId
            }

            private fun writeFieldAccessInFunctionBody(
                pType: IrType,
                idx: Int,
                variable: Label<out DbField>,
                parent: Label<out DbExprparent>,
                callable: Label<out DbCallable>,
                stmt: Label<out DbStmt>
            ) {
                val accessId =
                    writeVariableAccessInFunctionBody(
                        useType(pType),
                        idx,
                        variable,
                        parent,
                        callable,
                        stmt
                    )
                writeThisAccess(accessId, callable, stmt)
            }

            protected fun writeThisAccess(
                parent: Label<out DbExprparent>,
                callable: Label<out DbCallable>,
                stmt: Label<out DbStmt>
            ) {
                extractThisAccess(ids.type, callable, parent, -1, stmt, locId)
            }

            fun extractFieldWriteOfReflectionTarget(
                labels: FunctionLabels, // labels of the containing function
                target: IrFieldSymbol, // the target field being accessed)
            ) {
                val fieldType = useType(target.owner.type)

                extractExpressionStmt(locId, labels.blockId, 0, labels.methodId).also { exprStmtId ->
                    extractAssignExpr(
                            target.owner.type,
                            locId,
                            exprStmtId,
                            0,
                            labels.methodId,
                            exprStmtId
                        )
                        .also { assignExprId ->
                            extractFieldAccess(fieldType, assignExprId, exprStmtId, labels, target)
                            val p = labels.parameters.first()
                            writeVariableAccessInFunctionBody(
                                p.second,
                                1,
                                p.first,
                                assignExprId,
                                labels.methodId,
                                exprStmtId
                            )
                        }
                }
            }

            fun extractFieldReturnOfReflectionTarget(
                labels: FunctionLabels, // labels of the containing function
                target: IrFieldSymbol, // the target field being accessed
            ) {
                val retId = tw.getFreshIdLabel<DbReturnstmt>()
                tw.writeStmts_returnstmt(retId, labels.blockId, 0, labels.methodId)
                tw.writeHasLocation(retId, locId)

                val fieldType = useType(target.owner.type)
                extractFieldAccess(fieldType, retId, retId, labels, target)
            }

            private fun extractFieldAccess(
                fieldType: TypeResults,
                parent: Label<out DbExprparent>,
                stmt: Label<out DbStmt>,
                labels: FunctionLabels,
                target: IrFieldSymbol
            ) {
                val accessId = tw.getFreshIdLabel<DbVaraccess>()
                tw.writeExprs_varaccess(accessId, fieldType.javaResult.id, parent, 0)
                tw.writeExprsKotlinType(accessId, fieldType.kotlinResult.id)

                extractExprContext(accessId, locId, labels.methodId, stmt)

                val fieldId = useField(target.owner)
                tw.writeVariableBinding(accessId, fieldId)

                if (dispatchReceiverInfo != null) {
                    writeFieldAccessInFunctionBody(
                        dispatchReceiverInfo.type,
                        -1,
                        dispatchReceiverInfo.field,
                        accessId,
                        labels.methodId,
                        stmt
                    )
                }
            }

            /**
             * Extracts a call to `target` inside the function identified by `labels`. Special
             * parameters (`dispatch` and `extension`) are also handled.
             *
             * Examples are:
             * ```
             * this.<dispatchReceiver>.fn(this.<extensionReceiver>, param1, param2, param3, ...)
             * param1.fn(this.<extensionReceiver>, param2, ...)
             * param1.fn(param2, param3, ...)
             * fn(this.<extensionReceiver>, param1, param2, ...)
             * fn(param1, param2, ...)
             * new MyType(param1, param2, ...)
             * ```
             *
             * The parameters with default argument values cover special cases:
             * - dispatchReceiverIdx is usually -1, except if a constructor is referenced
             * - big arity function references need to call `invoke` with arguments received in an
             *   object array: `fn(param1[0] as T0, param1[1] as T1, ...)`
             */
            fun extractCallToReflectionTarget(
                labels: FunctionLabels, // labels of the containing function
                target: IrFunctionSymbol, // the target function/constructor being called
                returnType:
                    IrType, // the return type of the called function. Note that
                            // `target.owner.returnType` and `returnType` doesn't match for generic
                            // functions
                expressionTypeArgs: List<IrType>, // type arguments of the extracted expression
                classTypeArgsIncludingOuterClasses:
                    List<
                        IrTypeArgument
                    >?, // type arguments of the class containing the callable reference
                dispatchReceiverIdx: Int =
                    -1, // dispatch receiver index: -1 in case of functions, -2 for constructors
                bigArityParameterTypes: List<IrType>? =
                    null // parameter types used for the cast expressions in a big arity `invoke`
                         // invocation. null if not a big arity invocation.
            ) {
                // Return statement of generated function:
                val retId = tw.getFreshIdLabel<DbReturnstmt>()
                tw.writeStmts_returnstmt(retId, labels.blockId, 0, labels.methodId)
                tw.writeHasLocation(retId, locId)

                // Call to target function:
                val callType = useType(returnType)

                val callId: Label<out DbExpr> =
                    if (target is IrConstructorSymbol) {
                        val callId = tw.getFreshIdLabel<DbNewexpr>()
                        tw.writeExprs_newexpr(callId, callType.javaResult.id, retId, 0)
                        tw.writeExprsKotlinType(callId, callType.kotlinResult.id)

                        extractConstructorTypeAccess(
                            returnType,
                            callType,
                            target,
                            locId,
                            callId,
                            -3,
                            labels.methodId,
                            retId
                        )
                        callId
                    } else {
                        val callId = tw.getFreshIdLabel<DbMethodaccess>()
                        tw.writeExprs_methodaccess(callId, callType.javaResult.id, retId, 0)
                        tw.writeExprsKotlinType(callId, callType.kotlinResult.id)
                        extractTypeArguments(
                            expressionTypeArgs,
                            locId,
                            callId,
                            labels.methodId,
                            retId,
                            -2,
                            true
                        )
                        callId
                    }

                extractExprContext(callId, locId, labels.methodId, retId)

                val callableId =
                    useFunction<DbCallable>(
                        target.owner.realOverrideTarget,
                        classTypeArgsIncludingOuterClasses
                    )
                if (callableId == null) {
                    logger.error("Cannot get ID for reflection target")
                } else {
                    tw.writeCallableBinding(callId.cast<DbCaller>(), callableId)
                }

                val useFirstArgAsDispatch: Boolean
                if (dispatchReceiverInfo != null) {
                    writeFieldAccessInFunctionBody(
                        dispatchReceiverInfo.type,
                        dispatchReceiverIdx,
                        dispatchReceiverInfo.field,
                        callId,
                        labels.methodId,
                        retId
                    )

                    useFirstArgAsDispatch = false
                } else {
                    if (target.owner.isLocalFunction()) {
                        val ids = getLocallyVisibleFunctionLabels(target.owner)
                        extractNewExprForLocalFunction(ids, callId, locId, labels.methodId, retId)
                        useFirstArgAsDispatch = false
                    } else {
                        useFirstArgAsDispatch = target.owner.dispatchReceiverParameter != null

                        if (isStaticFunction(target.owner)) {
                            extractStaticTypeAccessQualifier(
                                target.owner,
                                callId,
                                locId,
                                labels.methodId,
                                retId
                            )
                        }
                    }
                }

                val extensionIdxOffset: Int
                if (extensionReceiverInfo != null) {
                    writeFieldAccessInFunctionBody(
                        extensionReceiverInfo.type,
                        0,
                        extensionReceiverInfo.field,
                        callId,
                        labels.methodId,
                        retId
                    )
                    extensionIdxOffset = 1
                } else {
                    extensionIdxOffset = 0
                }

                if (bigArityParameterTypes != null) {
                    // In case we're extracting a big arity function reference:
                    addArgumentsToInvocationInInvokeNBody(
                        bigArityParameterTypes,
                        labels,
                        retId,
                        callId,
                        locId,
                        extensionIdxOffset,
                        useFirstArgAsDispatch,
                        dispatchReceiverIdx
                    )
                } else {
                    val dispatchIdxOffset = if (useFirstArgAsDispatch) 1 else 0
                    for ((pIdx, p) in labels.parameters.withIndex()) {
                        val childIdx =
                            if (pIdx == 0 && useFirstArgAsDispatch) {
                                dispatchReceiverIdx
                            } else {
                                pIdx + extensionIdxOffset - dispatchIdxOffset
                            }
                        writeVariableAccessInFunctionBody(
                            p.second,
                            childIdx,
                            p.first,
                            callId,
                            labels.methodId,
                            retId
                        )
                    }
                }
            }

            fun extractConstructorArguments(
                callable: Label<out DbCallable>,
                idCtorRef: Label<out DbClassinstancexpr>,
                enclosingStmt: Label<out DbStmt>
            ) {
                if (dispatchReceiverInfo != null) {
                    extractExpressionExpr(
                        dispatchReceiverInfo.receiver,
                        callable,
                        idCtorRef,
                        0 + dispatchReceiverInfo.indexOffset,
                        enclosingStmt
                    )
                }

                if (extensionReceiverInfo != null) {
                    extractExpressionExpr(
                        extensionReceiverInfo.receiver,
                        callable,
                        idCtorRef,
                        0 + extensionReceiverInfo.indexOffset,
                        enclosingStmt
                    )
                }
            }
        }

        private inner class PropertyReferenceHelper(
            callableReferenceExpr: IrCallableReference<out IrSymbol>,
            locId: Label<DbLocation>,
            ids: GeneratedClassLabels
        ) : CallableReferenceHelper(callableReferenceExpr, locId, ids) {

            fun extractPropertyReferenceInvoke(
                getId: Label<DbMethod>,
                getterParameterTypes: List<IrType>,
                getterReturnType: IrType
            ) {
                // Extracting this method is not (strictly) needed for interface member implementation.
                // `[Mutable]PropertyReferenceX` already implements it, but its signature doesn't match
                // the
                // generic one, because it's a raw method implementation. Also, by adding the `invoke`
                // explicitly,
                // we have better data flow analysis support.
                val invokeLabels =
                    addFunctionManual(
                        tw.getFreshIdLabel(),
                        OperatorNameConventions.INVOKE.asString(),
                        getterParameterTypes,
                        getterReturnType,
                        classId,
                        locId
                    )

                // return this.get(a0, a1, ...)
                val retId = tw.getFreshIdLabel<DbReturnstmt>()
                tw.writeStmts_returnstmt(retId, invokeLabels.blockId, 0, invokeLabels.methodId)
                tw.writeHasLocation(retId, locId)

                // Call to target function:
                val callType = useType(getterReturnType)
                val callId = tw.getFreshIdLabel<DbMethodaccess>()
                tw.writeExprs_methodaccess(callId, callType.javaResult.id, retId, 0)
                tw.writeExprsKotlinType(callId, callType.kotlinResult.id)
                extractExprContext(callId, locId, invokeLabels.methodId, retId)

                tw.writeCallableBinding(callId, getId)

                this.writeThisAccess(callId, invokeLabels.methodId, retId)
                for ((pIdx, p) in invokeLabels.parameters.withIndex()) {
                    this.writeVariableAccessInFunctionBody(
                        p.second,
                        pIdx,
                        p.first,
                        callId,
                        invokeLabels.methodId,
                        retId
                    )
                }
            }
        }

        private val propertyRefType by lazy {
            referenceExternalClass("kotlin.jvm.internal.PropertyReference")?.typeWith()
        }

        private fun extractPropertyReference(
            exprKind: String,
            propertyReferenceExpr: IrCallableReference<out IrSymbol>,
            getter: IrSimpleFunctionSymbol?,
            setter: IrSimpleFunctionSymbol?,
            backingField: IrFieldSymbol?,
            parent: StmtExprParent,
            callable: Label<out DbCallable>
        ) {
            with(exprKind, propertyReferenceExpr) {
                /*
                 * Extract generated class:
                 * ```
                 * class C : kotlin.jvm.internal.PropertyReference, kotlin.reflect.KMutableProperty0<R> {
                 *   private dispatchReceiver: TD
                 *   constructor(dispatchReceiver: TD) {
                 *       super()
                 *       this.dispatchReceiver = dispatchReceiver
                 *   }
                 *
                 *   override fun get(): R { return this.dispatchReceiver.FN1() }
                 *
                 *   override fun set(a0: R): Unit { return this.dispatchReceiver.FN2(a0) }
                 *
                 *   override fun invoke(): R { return this.get() }
                 * }
                 * ```
                 *
                 * Variations:
                 * - KProperty vs KMutableProperty
                 * - KProperty0<> vs KProperty1<,>
                 * - no receiver vs dispatchReceiver vs extensionReceiver
                 **/

                val kPropertyType = propertyReferenceExpr.type
                if (kPropertyType !is IrSimpleType) {
                    logger.errorElement(
                        "Unexpected: property reference with non simple type. ${kPropertyType.classFqName?.asString()}",
                        propertyReferenceExpr
                    )
                    return
                }
                val kPropertyClass = kPropertyType.classOrNull
                if (kPropertyClass == null) {
                    logger.errorElement(
                        "Cannot find class for kPropertyType. ${kPropertyType.classFqName?.asString()}",
                        propertyReferenceExpr
                    )
                    return
                }
                val parameterTypes: List<IrType>? =
                    kPropertyType.arguments
                        .map {
                            if (it is IrType) {
                                it
                            } else {
                                logger.errorElement(
                                    "Unexpected: Non-IrType (${it.javaClass}) property reference parameter.",
                                    propertyReferenceExpr
                                )
                                null
                            }
                        }
                        .requireNoNullsOrNull()
                if (parameterTypes == null) {
                    logger.errorElement(
                        "Unexpected: One or more non-IrType property reference parameters.",
                        propertyReferenceExpr
                    )
                    return
                }

                val locId = tw.getLocation(propertyReferenceExpr)

                val javaResult = TypeResult(tw.getFreshIdLabel<DbClassorinterface>(), "", "")
                val kotlinResult = TypeResult(tw.getFreshIdLabel<DbKt_notnull_type>(), "", "")
                tw.writeKt_notnull_types(kotlinResult.id, javaResult.id)
                val ids =
                    GeneratedClassLabels(
                        TypeResults(javaResult, kotlinResult),
                        constructor = tw.getFreshIdLabel(),
                        constructorBlock = tw.getFreshIdLabel()
                    )

                val declarationParent =
                    peekDeclStackAsDeclarationParent(propertyReferenceExpr) ?: return
                // The base class could be `Any`. `PropertyReference` is used to keep symmetry with
                // function references.
                val baseClass = propertyRefType ?: pluginContext.irBuiltIns.anyType

                val classId =
                    extractGeneratedClass(
                        ids,
                        listOf(baseClass, kPropertyType),
                        locId,
                        propertyReferenceExpr,
                        declarationParent
                    )

                val helper = PropertyReferenceHelper(propertyReferenceExpr, locId, ids)

                helper.extractReceiverField()

                val classTypeArguments =
                    (propertyReferenceExpr.dispatchReceiver?.type as? IrSimpleType)?.arguments
                        ?: if (
                            (getter?.owner?.dispatchReceiverParameter
                                ?: setter?.owner?.dispatchReceiverParameter) != null
                        ) {
                            (kPropertyType.arguments.first() as? IrSimpleType)?.arguments
                        } else {
                            null
                        }

                val expressionTypeArguments =
                    (0 until propertyReferenceExpr.typeArgumentsCount).mapNotNull {
                        propertyReferenceExpr.getTypeArgument(it)
                    }

                val idPropertyRef = tw.getFreshIdLabel<DbPropertyref>()

                val getterParameterTypes = parameterTypes.dropLast(1)
                val getterReturnType = parameterTypes.last()

                if (getter != null) {
                    val getterCallableId =
                        useFunction<DbCallable>(getter.owner.realOverrideTarget, classTypeArguments)
                    if (getterCallableId == null) {
                        logger.errorElement("Cannot get ID for getter", propertyReferenceExpr)
                    } else {
                        val getLabels =
                            addFunctionManual(
                                tw.getFreshIdLabel(),
                                OperatorNameConventions.GET.asString(),
                                getterParameterTypes,
                                getterReturnType,
                                classId,
                                locId
                            )

                        helper.extractCallToReflectionTarget(
                            getLabels,
                            getter,
                            getterReturnType,
                            expressionTypeArguments,
                            classTypeArguments
                        )

                        tw.writePropertyRefGetBinding(idPropertyRef, getterCallableId)

                        helper.extractPropertyReferenceInvoke(
                            getLabels.methodId,
                            getterParameterTypes,
                            getterReturnType
                        )
                    }
                } else {
                    // Property without a getter.
                    if (backingField == null) {
                        logger.errorElement(
                            "Expected to find getter or backing field for property reference.",
                            propertyReferenceExpr
                        )
                        return
                    }

                    val getLabels =
                        addFunctionManual(
                            tw.getFreshIdLabel(),
                            OperatorNameConventions.GET.asString(),
                            getterParameterTypes,
                            getterReturnType,
                            classId,
                            locId
                        )
                    val fieldId = useField(backingField.owner)

                    helper.extractFieldReturnOfReflectionTarget(getLabels, backingField)

                    tw.writePropertyRefFieldBinding(idPropertyRef, fieldId)

                    helper.extractPropertyReferenceInvoke(
                        getLabels.methodId,
                        getterParameterTypes,
                        getterReturnType
                    )
                }

                if (setter != null) {
                    val setterCallableId =
                        useFunction<DbCallable>(setter.owner.realOverrideTarget, classTypeArguments)
                    if (setterCallableId == null) {
                        logger.errorElement("Cannot get ID for setter", propertyReferenceExpr)
                    } else {
                        val setLabels =
                            addFunctionManual(
                                tw.getFreshIdLabel(),
                                OperatorNameConventions.SET.asString(),
                                parameterTypes,
                                pluginContext.irBuiltIns.unitType,
                                classId,
                                locId
                            )

                        helper.extractCallToReflectionTarget(
                            setLabels,
                            setter,
                            pluginContext.irBuiltIns.unitType,
                            expressionTypeArguments,
                            classTypeArguments
                        )

                        tw.writePropertyRefSetBinding(idPropertyRef, setterCallableId)
                    }
                } else {
                    if (backingField != null && !backingField.owner.isFinal) {
                        val setLabels =
                            addFunctionManual(
                                tw.getFreshIdLabel(),
                                OperatorNameConventions.SET.asString(),
                                parameterTypes,
                                pluginContext.irBuiltIns.unitType,
                                classId,
                                locId
                            )
                        val fieldId = useField(backingField.owner)

                        helper.extractFieldWriteOfReflectionTarget(setLabels, backingField)

                        tw.writePropertyRefFieldBinding(idPropertyRef, fieldId)
                    }
                }

                // Add constructor (property ref) call:
                val exprParent = parent.expr(propertyReferenceExpr, callable)
                tw.writeExprs_propertyref(
                    idPropertyRef,
                    ids.type.javaResult.id,
                    exprParent.parent,
                    exprParent.idx
                )
                tw.writeExprsKotlinType(idPropertyRef, ids.type.kotlinResult.id)
                extractExprContext(idPropertyRef, locId, callable, exprParent.enclosingStmt)
                tw.writeCallableBinding(idPropertyRef, ids.constructor)

                extractTypeAccessRecursive(
                    kPropertyType,
                    locId,
                    idPropertyRef,
                    -3,
                    callable,
                    exprParent.enclosingStmt
                )

                helper.extractConstructorArguments(callable, idPropertyRef, exprParent.enclosingStmt)

                tw.writeIsAnonymClass(classId, idPropertyRef)
            }
        }

        private val functionRefType by lazy {
            referenceExternalClass("kotlin.jvm.internal.FunctionReference")?.typeWith()
        }

        private fun extractFunctionReference(
            functionReferenceExpr: IrFunctionReference,
            parent: StmtExprParent,
            callable: Label<out DbCallable>
        ) {
            with("function reference", functionReferenceExpr) {
                val target =
                    if (functionReferenceExpr.origin == IrStatementOrigin.ADAPTED_FUNCTION_REFERENCE)
                    // For an adaptation (e.g. to adjust the number or type of arguments or results),
                    // the symbol field points at the adapter while `.reflectionTarget` points at the
                    // source-level target.
                    functionReferenceExpr.symbol
                    else
                    // TODO: Consider whether we could always target the symbol
                    functionReferenceExpr.reflectionTarget
                            ?: run {
                                logger.warnElement(
                                    "Expected to find reflection target for function reference. Using underlying symbol instead.",
                                    functionReferenceExpr
                                )
                                functionReferenceExpr.symbol
                            }

                /*
                 * Extract generated class:
                 * ```
                 * class C : kotlin.jvm.internal.FunctionReference, kotlin.FunctionI<T0,T1, ... TI, R> {
                 *   private dispatchReceiver: TD
                 *   private extensionReceiver: TE
                 *   constructor(dispatchReceiver: TD, extensionReceiver: TE) {
                 *       super()
                 *       this.dispatchReceiver = dispatchReceiver
                 *       this.extensionReceiver = extensionReceiver
                 *   }
                 *   fun invoke(a0:T0, a1:T1, ... aI: TI): R { return this.dispatchReceiver.FN(a0,a1,...,aI) }                       OR
                 *   fun invoke(       a1:T1, ... aI: TI): R { return this.dispatchReceiver.FN(this.dispatchReceiver,a1,...,aI) }    OR
                 *   fun invoke(a0:T0, a1:T1, ... aI: TI): R { return Ctor(a0,a1,...,aI) }
                 * }
                 * ```
                 * or in case of big arity lambdas ????
                 * ```
                 * class C : kotlin.jvm.internal.FunctionReference, kotlin.FunctionN<R> {
                 *   private receiver: TD
                 *   constructor(receiver: TD) { super(); this.receiver = receiver; }
                 *   fun invoke(vararg args: Any?): R {
                 *     return this.receiver.FN(args[0] as T0, args[1] as T1, ..., args[I] as TI)
                 *   }
                 * }
                 * ```
                 **/

                if (
                    functionReferenceExpr.dispatchReceiver != null &&
                        functionReferenceExpr.extensionReceiver != null
                ) {
                    logger.errorElement(
                        "Unexpected: dispatchReceiver and extensionReceiver are both non-null",
                        functionReferenceExpr
                    )
                    return
                }

                if (
                    target.owner.dispatchReceiverParameter != null &&
                        target.owner.extensionReceiverParameter != null
                ) {
                    logger.errorElement(
                        "Unexpected: dispatch and extension parameters are both non-null",
                        functionReferenceExpr
                    )
                    return
                }

                val type = functionReferenceExpr.type
                if (type !is IrSimpleType) {
                    logger.errorElement(
                        "Unexpected: function reference with non simple type. ${type.classFqName?.asString()}",
                        functionReferenceExpr
                    )
                    return
                }

                val parameterTypes: List<IrType>? =
                    type.arguments
                        .map {
                            if (it is IrType) {
                                it
                            } else {
                                logger.errorElement(
                                    "Unexpected: Non-IrType (${it.javaClass}) function reference parameter.",
                                    functionReferenceExpr
                                )
                                null
                            }
                        }
                        .requireNoNullsOrNull()
                if (parameterTypes == null) {
                    logger.errorElement(
                        "Unexpected: One or more non-IrType function reference parameters.",
                        functionReferenceExpr
                    )
                    return
                }

                val dispatchReceiverIdx: Int
                val expressionTypeArguments: List<IrType>
                val classTypeArguments: List<IrTypeArgument>?

                if (target is IrConstructorSymbol) {
                    // In case a constructor is referenced, the return type of the `KFunctionX<,,,>` is
                    // the type if the constructed type.
                    classTypeArguments = (type.arguments.last() as? IrSimpleType)?.arguments
                    expressionTypeArguments = listOf(parameterTypes.last())
                    dispatchReceiverIdx = -2
                } else {
                    classTypeArguments =
                        (functionReferenceExpr.dispatchReceiver?.type as? IrSimpleType)?.arguments
                            ?: if (target.owner.dispatchReceiverParameter != null) {
                                (type.arguments.first() as? IrSimpleType)?.arguments
                            } else {
                                null
                            }
                    expressionTypeArguments =
                        (0 until functionReferenceExpr.typeArgumentsCount).mapNotNull {
                            functionReferenceExpr.getTypeArgument(it)
                        }
                    dispatchReceiverIdx = -1
                }

                val locId = tw.getLocation(functionReferenceExpr)

                val javaResult = TypeResult(tw.getFreshIdLabel<DbClassorinterface>(), "", "")
                val kotlinResult = TypeResult(tw.getFreshIdLabel<DbKt_notnull_type>(), "", "")
                tw.writeKt_notnull_types(kotlinResult.id, javaResult.id)
                val ids =
                    LocallyVisibleFunctionLabels(
                        TypeResults(javaResult, kotlinResult),
                        constructor = tw.getFreshIdLabel(),
                        function = tw.getFreshIdLabel(),
                        constructorBlock = tw.getFreshIdLabel()
                    )

                // Add constructor (member ref) call:
                val exprParent = parent.expr(functionReferenceExpr, callable)
                val idMemberRef = tw.getFreshIdLabel<DbMemberref>()
                tw.writeExprs_memberref(
                    idMemberRef,
                    ids.type.javaResult.id,
                    exprParent.parent,
                    exprParent.idx
                )
                tw.writeExprsKotlinType(idMemberRef, ids.type.kotlinResult.id)
                extractExprContext(idMemberRef, locId, callable, exprParent.enclosingStmt)
                tw.writeCallableBinding(idMemberRef, ids.constructor)

                val targetCallableId =
                    useFunction<DbCallable>(target.owner.realOverrideTarget, classTypeArguments)
                if (targetCallableId == null) {
                    logger.errorElement(
                        "Cannot get ID for function reference callable",
                        functionReferenceExpr
                    )
                } else {
                    tw.writeMemberRefBinding(idMemberRef, targetCallableId)
                }

                val helper = CallableReferenceHelper(functionReferenceExpr, locId, ids)

                val fnInterfaceType = getFunctionalInterfaceTypeWithTypeArgs(type.arguments)
                if (fnInterfaceType == null) {
                    logger.warnElement(
                        "Cannot find functional interface type for function reference",
                        functionReferenceExpr
                    )
                } else {
                    val declarationParent =
                        peekDeclStackAsDeclarationParent(functionReferenceExpr) ?: return
                    // `FunctionReference` base class is required, because that's implementing
                    // `KFunction`.
                    val baseClass = functionRefType ?: pluginContext.irBuiltIns.anyType

                    val classId =
                        extractGeneratedClass(
                            ids,
                            listOf(baseClass, fnInterfaceType),
                            locId,
                            functionReferenceExpr,
                            declarationParent,
                            null,
                            { it.valueParameters.size == 1 }
                        ) {
                            // The argument to FunctionReference's constructor is the function arity.
                            extractConstantInteger(
                                type.arguments.size - 1,
                                locId,
                                it,
                                0,
                                ids.constructor,
                                it
                            )
                        }

                    helper.extractReceiverField()

                    val isBigArity = type.arguments.size > BuiltInFunctionArity.BIG_ARITY
                    val funLabels =
                        if (isBigArity) {
                            addFunctionNInvoke(ids.function, parameterTypes.last(), classId, locId)
                        } else {
                            addFunctionInvoke(
                                ids.function,
                                parameterTypes.dropLast(1),
                                parameterTypes.last(),
                                classId,
                                locId
                            )
                        }

                    helper.extractCallToReflectionTarget(
                        funLabels,
                        target,
                        parameterTypes.last(),
                        expressionTypeArguments,
                        classTypeArguments,
                        dispatchReceiverIdx,
                        if (isBigArity) parameterTypes.dropLast(1) else null
                    )

                    val typeAccessArguments =
                        if (isBigArity) listOf(parameterTypes.last()) else parameterTypes
                    if (target is IrConstructorSymbol) {
                        val returnType = typeAccessArguments.last()

                        val typeAccessId =
                            extractTypeAccess(
                                useType(fnInterfaceType, TypeContext.OTHER),
                                locId,
                                idMemberRef,
                                -3,
                                callable,
                                exprParent.enclosingStmt
                            )
                        typeAccessArguments.dropLast(1).forEachIndexed { argIdx, arg ->
                            extractTypeAccessRecursive(
                                arg,
                                locId,
                                typeAccessId,
                                argIdx,
                                callable,
                                exprParent.enclosingStmt,
                                TypeContext.GENERIC_ARGUMENT
                            )
                        }

                        extractConstructorTypeAccess(
                            returnType,
                            useType(returnType),
                            target,
                            locId,
                            typeAccessId,
                            typeAccessArguments.count() - 1,
                            callable,
                            exprParent.enclosingStmt
                        )
                    } else {
                        extractTypeAccessRecursive(
                            fnInterfaceType,
                            locId,
                            idMemberRef,
                            -3,
                            callable,
                            exprParent.enclosingStmt
                        )
                    }

                    helper.extractConstructorArguments(callable, idMemberRef, exprParent.enclosingStmt)

                    tw.writeIsAnonymClass(classId, idMemberRef)
                }
            }
        }

        private fun getFunctionalInterfaceType(functionNTypeArguments: List<IrType>) =
            getFunctionalInterfaceTypeWithTypeArgs(
                functionNTypeArguments.map { makeTypeProjection(it, Variance.INVARIANT) }
            )

        private fun extractVarargElement(
            e: IrVarargElement,
            callable: Label<out DbCallable>,
            parent: Label<out DbExprparent>,
            idx: Int,
            enclosingStmt: Label<out DbStmt>
        ) {
            with("vararg element", e) {
                val argExpr =
                    when (e) {
                        is IrExpression -> e
                        is IrSpreadElement -> e.expression
                        else -> {
                            logger.errorElement("Unrecognised IrVarargElement: " + e.javaClass, e)
                            null
                        }
                    }
                argExpr?.let { extractExpressionExpr(it, callable, parent, idx, enclosingStmt) }
            }
        }

        /**
         * Extracts a type access expression and its generic arguments for a constructor call. It only
         * extracts type arguments relating to the constructed type, not the constructor itself, which
         * makes a difference in case of nested generics.
         */
        private fun extractConstructorTypeAccess(
            irType: IrType,
            type: TypeResults,
            target: IrFunctionSymbol,
            locId: Label<DbLocation>,
            parent: Label<out DbExprparent>,
            idx: Int,
            enclosingCallable: Label<out DbCallable>,
            enclosingStmt: Label<out DbStmt>
        ) {
            val typeAccessId =
                extractTypeAccess(type, locId, parent, idx, enclosingCallable, enclosingStmt)
            if (irType is IrSimpleType) {
                extractTypeArguments(
                    irType.arguments
                        .take(target.owner.parentAsClass.typeParameters.size)
                        .filterIsInstance<IrType>(),
                    locId,
                    typeAccessId,
                    enclosingCallable,
                    enclosingStmt
                )
            }
        }

        /**
         * Extracts a single wildcard type access expression with no enclosing callable and statement.
         */
        private fun extractWildcardTypeAccess(
            type: TypeResultsWithoutSignatures,
            location: Label<out DbLocation>,
            parent: Label<out DbExprparent>,
            idx: Int
        ): Label<out DbExpr> {
            val id = tw.getFreshIdLabel<DbWildcardtypeaccess>()
            tw.writeExprs_wildcardtypeaccess(id, type.javaResult.id, parent, idx)
            tw.writeExprsKotlinType(id, type.kotlinResult.id)
            tw.writeHasLocation(id, location)
            return id
        }

        /** Extracts a single type access expression with no enclosing callable and statement. */
        private fun extractTypeAccess(
            type: TypeResults,
            location: Label<out DbLocation>,
            parent: Label<out DbExprparent>,
            idx: Int,
            overrideId: Label<out DbExpr>? = null
        ): Label<out DbExpr> {
            // TODO: elementForLocation allows us to give some sort of
            //   location, but a proper location for the type access will
            //   require upstream changes
            val id = exprIdOrFresh<DbUnannotatedtypeaccess>(overrideId)
            tw.writeExprs_unannotatedtypeaccess(id, type.javaResult.id, parent, idx)
            tw.writeExprsKotlinType(id, type.kotlinResult.id)
            tw.writeHasLocation(id, location)
            return id
        }

        /** Extracts a single type access expression with enclosing callable and statement. */
        private fun extractTypeAccess(
            type: TypeResults,
            location: Label<DbLocation>,
            parent: Label<out DbExprparent>,
            idx: Int,
            enclosingCallable: Label<out DbCallable>?,
            enclosingStmt: Label<out DbStmt>?,
            overrideId: Label<out DbExpr>? = null
        ): Label<out DbExpr> {
            val id = extractTypeAccess(type, location, parent, idx, overrideId = overrideId)
            if (enclosingCallable != null) {
                tw.writeCallableEnclosingExpr(id, enclosingCallable)
            }
            if (enclosingStmt != null) {
                tw.writeStatementEnclosingExpr(id, enclosingStmt)
            }
            return id
        }

        /**
         * Extracts a type argument type access, introducing a wildcard type access if appropriate, or
         * directly calling `extractTypeAccessRecursive` if the argument is invariant. No enclosing
         * callable and statement is extracted, this is useful for type access extraction in field
         * declarations.
         */
        private fun extractWildcardTypeAccessRecursive(
            t: IrTypeArgument,
            location: Label<out DbLocation>,
            parent: Label<out DbExprparent>,
            idx: Int
        ) {
            val typeLabels by lazy {
                TypeResultsWithoutSignatures(
                    getTypeArgumentLabel(t),
                    TypeResultWithoutSignature(fakeKotlinType(), Unit, "TODO")
                )
            }
            when (t) {
                is IrStarProjection -> extractWildcardTypeAccess(typeLabels, location, parent, idx)
                is IrTypeProjection ->
                    when (t.variance) {
                        Variance.INVARIANT ->
                            extractTypeAccessRecursive(
                                t.type,
                                location,
                                parent,
                                idx,
                                TypeContext.GENERIC_ARGUMENT
                            )
                        else -> {
                            val wildcardLabel =
                                extractWildcardTypeAccess(typeLabels, location, parent, idx)
                            // Mimic a Java extractor oddity, that it uses the child index to indicate
                            // what kind of wildcard this is
                            val boundChildIdx = if (t.variance == Variance.OUT_VARIANCE) 0 else 1
                            extractTypeAccessRecursive(
                                t.type,
                                location,
                                wildcardLabel,
                                boundChildIdx,
                                TypeContext.GENERIC_ARGUMENT
                            )
                        }
                    }
            }
        }

        /**
         * Extracts a type access expression and its child type access expressions in case of a generic
         * type. Nested generics are also handled. No enclosing callable and statement is extracted,
         * this is useful for type access extraction in field declarations.
         */
        private fun extractTypeAccessRecursive(
            t: IrType,
            location: Label<out DbLocation>,
            parent: Label<out DbExprparent>,
            idx: Int,
            typeContext: TypeContext = TypeContext.OTHER
        ): Label<out DbExpr> {
            val typeAccessId = extractTypeAccess(useType(t, typeContext), location, parent, idx)
            if (t is IrSimpleType) {
                // From 1.9, the list might change when we call erase,
                // so we make a copy that it is safe to iterate over.
                val argumentsCopy = t.arguments.toList()
                argumentsCopy.forEachIndexed { argIdx, arg ->
                    extractWildcardTypeAccessRecursive(arg, location, typeAccessId, argIdx)
                }
            }
            return typeAccessId
        }

        /**
         * Extracts a type access expression and its child type access expressions in case of a generic
         * type. Nested generics are also handled.
         */
        private fun extractTypeAccessRecursive(
            t: IrType,
            location: Label<DbLocation>,
            parent: Label<out DbExprparent>,
            idx: Int,
            enclosingCallable: Label<out DbCallable>?,
            enclosingStmt: Label<out DbStmt>?,
            typeContext: TypeContext = TypeContext.OTHER,
            overrideId: Label<out DbExpr>? = null
        ): Label<out DbExpr> {
            // TODO: `useType` substitutes types to their java equivalent, and sometimes that also means
            // changing the number of type arguments. The below logic doesn't take this into account.
            // For example `KFunction2<Int,Double,String>` becomes `KFunction<String>` with three child
            // type access expressions: `Int`, `Double`, `String`.
            val typeAccessId =
                extractTypeAccess(
                    useType(t, typeContext),
                    location,
                    parent,
                    idx,
                    enclosingCallable,
                    enclosingStmt,
                    overrideId = overrideId
                )
            if (t is IrSimpleType) {
                if (t.arguments.isNotEmpty() && overrideId != null) {
                    logger.error(
                        "Unexpected parameterized type with an overridden expression ID; children will be assigned fresh IDs"
                    )
                }
                extractTypeArguments(
                    t.arguments.filterIsInstance<IrType>(),
                    location,
                    typeAccessId,
                    enclosingCallable,
                    enclosingStmt
                )
            }
            return typeAccessId
        }

        /**
         * Extracts a list of types as type access expressions. Nested generics are also handled. Used
         * for extracting nested type access expressions, and type arguments of constructor or function
         * calls.
         */
        private fun extractTypeArguments(
            typeArgs: List<IrType>,
            location: Label<DbLocation>,
            parentExpr: Label<out DbExprparent>,
            enclosingCallable: Label<out DbCallable>?,
            enclosingStmt: Label<out DbStmt>?,
            startIndex: Int = 0,
            reverse: Boolean = false
        ) {
            typeArgs.forEachIndexed { argIdx, arg ->
                val mul = if (reverse) -1 else 1
                extractTypeAccessRecursive(
                    arg,
                    location,
                    parentExpr,
                    argIdx * mul + startIndex,
                    enclosingCallable,
                    enclosingStmt,
                    TypeContext.GENERIC_ARGUMENT
                )
            }
        }

        /**
         * Extracts type arguments of a member access expression as type access expressions. Nested
         * generics are also handled. Used for extracting nested type access expressions, and type
         * arguments of constructor or function calls.
         */
        private fun <T : IrSymbol> extractTypeArguments(
            c: IrMemberAccessExpression<T>,
            parentExpr: Label<out DbExprparent>,
            enclosingCallable: Label<out DbCallable>,
            enclosingStmt: Label<out DbStmt>,
            startIndex: Int = 0,
            reverse: Boolean = false
        ) {
            val typeArguments =
                (0 until c.typeArgumentsCount).map { c.getTypeArgument(it) }.requireNoNullsOrNull()
            if (typeArguments == null) {
                logger.errorElement("Found a null type argument for a member access expression", c)
            } else {
                extractTypeArguments(
                    typeArguments,
                    tw.getLocation(c),
                    parentExpr,
                    enclosingCallable,
                    enclosingStmt,
                    startIndex,
                    reverse
                )
            }
        }

        private val IrType.isAnonymous: Boolean
            get() = ((this as? IrSimpleType)?.classifier?.owner as? IrClass)?.isAnonymousObject ?: false

        private fun addVisibilityModifierToLocalOrAnonymousClass(id: Label<out DbModifiable>) {
            addModifiers(id, "private")
        }

    inner class DeclarationStackAdjuster(
        val declaration: KaDeclarationSymbol,
        val overriddenAttributes: OverriddenFunctionAttributes? = null
    ) : Closeable {
        init {
            declarationStack.push(declaration, overriddenAttributes)
        }

        override fun close() {
            declarationStack.pop()
        }
    }

    class DeclarationStack {
        private val stack: Stack<Pair<KaDeclarationSymbol, OverriddenFunctionAttributes?>> = Stack()

        fun push(item: KaDeclarationSymbol, overriddenAttributes: OverriddenFunctionAttributes?) =
            stack.push(Pair(item, overriddenAttributes))

        fun pop() = stack.pop()

        fun isEmpty() = stack.isEmpty()

        fun peek() = stack.peek()

        fun tryPeek() = if (stack.isEmpty()) null else stack.peek()

        fun findOverriddenAttributes(f: KaFunctionSymbol) = stack.lastOrNull { it.first == f }?.second
    }
     */

    data class OverriddenFunctionAttributes(
        val id: Label<out DbCallable>? = null,
        val sourceDeclarationId: Label<out DbCallable>? = null,
        val sourceLoc: Label<DbLocation>? = null,
        val valueParameters: List<KaValueParameterSymbol>? = null,
        val typeParameters: List<KaTypeParameterSymbol>? = null,
        val isStatic: Boolean? = null,
        val visibility: KaSymbolVisibility? = null,
        val modality: KaSymbolModality? = null,
    )
    /*
    OLD: KE1
        private fun peekDeclStackAsDeclarationParent(
            elementToReportOn: IrElement
        ): IrDeclarationParent? {
            val trapWriter = tw
            if (declarationStack.isEmpty() && trapWriter is SourceFileTrapWriter) {
                // If the current declaration is used as a parent, we might end up with an empty stack.
                // In this case, the source file is the parent.
                return trapWriter.irFile
            }

            val dp = declarationStack.peek().first as? IrDeclarationParent
            if (dp == null)
                logger.errorElement("Couldn't find current declaration parent", elementToReportOn)
            return dp
        }
    */
}
