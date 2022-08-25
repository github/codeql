package com.github.codeql

import com.github.codeql.utils.*
import com.github.codeql.utils.versions.codeQlWithHasQuestionMark
import com.github.codeql.utils.versions.isRawType
import com.semmle.extractor.java.OdasaOutput
import org.jetbrains.kotlin.backend.common.extensions.IrPluginContext
import org.jetbrains.kotlin.backend.common.ir.*
import org.jetbrains.kotlin.backend.common.lower.parents
import org.jetbrains.kotlin.backend.common.lower.parentsWithSelf
import org.jetbrains.kotlin.backend.jvm.ir.propertyIfAccessor
import org.jetbrains.kotlin.codegen.JvmCodegenUtil
import org.jetbrains.kotlin.descriptors.*
import org.jetbrains.kotlin.ir.ObsoleteDescriptorBasedAPI
import org.jetbrains.kotlin.ir.declarations.*
import org.jetbrains.kotlin.ir.expressions.*
import org.jetbrains.kotlin.ir.symbols.*
import org.jetbrains.kotlin.ir.types.*
import org.jetbrains.kotlin.ir.types.impl.*
import org.jetbrains.kotlin.ir.util.*
import org.jetbrains.kotlin.load.java.BuiltinMethodsWithSpecialGenericSignature
import org.jetbrains.kotlin.load.java.JvmAbi
import org.jetbrains.kotlin.load.java.sources.JavaSourceElement
import org.jetbrains.kotlin.load.java.structure.*
import org.jetbrains.kotlin.load.kotlin.getJvmModuleNameForDeserializedDescriptor
import org.jetbrains.kotlin.name.FqName
import org.jetbrains.kotlin.name.NameUtils
import org.jetbrains.kotlin.name.SpecialNames
import org.jetbrains.kotlin.types.Variance
import org.jetbrains.kotlin.util.OperatorNameConventions

open class KotlinUsesExtractor(
    open val logger: Logger,
    open val tw: TrapWriter,
    val dependencyCollector: OdasaOutput.TrapFileManager?,
    val externalClassExtractor: ExternalDeclExtractor,
    val primitiveTypeMapping: PrimitiveTypeMapping,
    val pluginContext: IrPluginContext,
    val globalExtensionState: KotlinExtractorGlobalState
) {

    val javaLangObject by lazy {
        val result = pluginContext.referenceClass(FqName("java.lang.Object"))?.owner
        result?.let { extractExternalClassLater(it) }
        result
    }

    val javaLangObjectType by lazy {
        javaLangObject?.typeWith()
    }

    private fun usePackage(pkg: String): Label<out DbPackage> {
        return extractPackage(pkg)
    }

    fun extractPackage(pkg: String): Label<out DbPackage> {
        val pkgLabel = "@\"package;$pkg\""
        val id: Label<DbPackage> = tw.getLabelFor(pkgLabel, {
            tw.writePackages(it, pkg)
        })
        return id
    }

    fun useFileClassType(f: IrFile) = TypeResults(
        TypeResult(extractFileClass(f), "", ""),
        TypeResult(fakeKotlinType(), "", "")
    )

    @OptIn(kotlin.ExperimentalStdlibApi::class) // Annotation required by kotlin versions < 1.5
    fun extractFileClass(f: IrFile): Label<out DbClass> {
        val fileName = f.fileEntry.name
        val pkg = f.fqName.asString()
        val defaultName = fileName.replaceFirst(Regex(""".*[/\\]"""), "").replaceFirst(Regex("""\.kt$"""), "").replaceFirstChar({ it.uppercase() }) + "Kt"
        var jvmName = getJvmName(f) ?: defaultName
        val qualClassName = if (pkg.isEmpty()) jvmName else "$pkg.$jvmName"
        val label = "@\"class;$qualClassName\""
        val id: Label<DbClass> = tw.getLabelFor(label, {
            val fileId = tw.mkFileId(f.path, false)
            val locId = tw.getWholeFileLocation(fileId)
            val pkgId = extractPackage(pkg)
            tw.writeClasses(it, jvmName, pkgId, it)
            tw.writeFile_class(it)
            tw.writeHasLocation(it, locId)

            addModifiers(it, "public", "final")
        })
        return id
    }

    data class UseClassInstanceResult(val typeResult: TypeResult<DbClassorinterface>, val javaClass: IrClass)

    fun useType(t: IrType, context: TypeContext = TypeContext.OTHER): TypeResults {
        when(t) {
            is IrSimpleType -> return useSimpleType(t, context)
            else -> {
                logger.error("Unrecognised IrType: " + t.javaClass)
                return extractErrorType()
            }
        }
    }

    private fun extractJavaErrorType(): TypeResult<DbErrortype> {
        val typeId = tw.getLabelFor<DbErrortype>("@\"errorType\"") {
            tw.writeError_type(it)
        }
        return TypeResult(typeId, "<CodeQL error type>", "<CodeQL error type>")
    }

    private fun extractErrorType(): TypeResults {
        val javaResult = extractJavaErrorType()
        val kotlinTypeId = tw.getLabelFor<DbKt_nullable_type>("@\"errorKotlinType\"") {
            tw.writeKt_nullable_types(it, javaResult.id)
        }
        return TypeResults(javaResult,
                           TypeResult(kotlinTypeId, "<CodeQL error type>", "<CodeQL error type>"))
    }

    fun getJavaEquivalentClass(c: IrClass) =
        getJavaEquivalentClassId(c)?.let { pluginContext.referenceClass(it.asSingleFqName()) }?.owner

    /**
     * Gets a KotlinFileExtractor based on this one, except it attributes locations to the file that declares the given class.
     */
    private fun withFileOfClass(cls: IrClass): KotlinFileExtractor {
        val clsFile = cls.fileOrNull

        if (this is KotlinFileExtractor && this.filePath == clsFile?.path) {
            return this
        }

        if (clsFile == null || isExternalDeclaration(cls)) {
            val filePath = getIrClassBinaryPath(cls)
            val newTrapWriter = tw.makeFileTrapWriter(filePath, true)
            val newLoggerTrapWriter = logger.tw.makeFileTrapWriter(filePath, false)
            val newLogger = FileLogger(logger.loggerBase, newLoggerTrapWriter)
            return KotlinFileExtractor(newLogger, newTrapWriter, filePath, dependencyCollector, externalClassExtractor, primitiveTypeMapping, pluginContext, globalExtensionState)
        }

        val newTrapWriter = tw.makeSourceFileTrapWriter(clsFile, true)
        val newLoggerTrapWriter = logger.tw.makeSourceFileTrapWriter(clsFile, false)
        val newLogger = FileLogger(logger.loggerBase, newLoggerTrapWriter)
        return KotlinFileExtractor(newLogger, newTrapWriter, clsFile.path, dependencyCollector, externalClassExtractor, primitiveTypeMapping, pluginContext, globalExtensionState)
    }

    // The Kotlin compiler internal representation of Outer<T>.Inner<S>.InnerInner<R> is InnerInner<R, S, T>. This function returns just `R`.
    fun removeOuterClassTypeArgs(c: IrClass, argsIncludingOuterClasses: List<IrTypeArgument>?): List<IrTypeArgument>? {
        return argsIncludingOuterClasses?.let {
            if (it.size > c.typeParameters.size)
                it.take(c.typeParameters.size)
            else
                null
        } ?: argsIncludingOuterClasses
    }

    private fun isStaticClass(c: IrClass) = c.visibility != DescriptorVisibilities.LOCAL && !c.isInner

    // Gets nested inner classes starting at `c` and proceeding outwards to the innermost enclosing static class.
    // For example, for (java syntax) `class A { static class B { class C { class D { } } } }`,
    // `nonStaticParentsWithSelf(D)` = `[D, C, B]`.
    private fun parentsWithTypeParametersInScope(c: IrClass): List<IrDeclarationParent> {
        val parentsList = c.parentsWithSelf.toList()
        val firstOuterClassIdx = parentsList.indexOfFirst { it is IrClass && isStaticClass(it) }
        return if (firstOuterClassIdx == -1) parentsList else parentsList.subList(0, firstOuterClassIdx + 1)
    }

    // Gets the type parameter symbols that are in scope for class `c` in Kotlin order (i.e. for
    // `class NotInScope<T> { static class OutermostInScope<A, B> { class QueryClass<C, D> { } } }`,
    // `getTypeParametersInScope(QueryClass)` = `[C, D, A, B]`.
    private fun getTypeParametersInScope(c: IrClass) =
        parentsWithTypeParametersInScope(c).mapNotNull({ getTypeParameters(it) }).flatten()

    // Returns a map from `c`'s type variables in scope to type arguments `argsIncludingOuterClasses`.
    // Hack for the time being: the substituted types are always nullable, to prevent downstream code
    // from replacing a generic parameter by a primitive. As and when we extract Kotlin types we will
    // need to track this information in more detail.
    private fun makeTypeGenericSubstitutionMap(c: IrClass, argsIncludingOuterClasses: List<IrTypeArgument>) =
        getTypeParametersInScope(c).map({ it.symbol }).zip(argsIncludingOuterClasses.map { it.withQuestionMark(true) }).toMap()

    fun makeGenericSubstitutionFunction(c: IrClass, argsIncludingOuterClasses: List<IrTypeArgument>) =
        makeTypeGenericSubstitutionMap(c, argsIncludingOuterClasses).let {
            { x: IrType, useContext: TypeContext, pluginContext: IrPluginContext ->
                x.substituteTypeAndArguments(
                    it,
                    useContext,
                    pluginContext
                )
            }
        }

    // The Kotlin compiler internal representation of Outer<A, B>.Inner<C, D>.InnerInner<E, F>.someFunction<G, H>.LocalClass<I, J> is LocalClass<I, J, G, H, E, F, C, D, A, B>. This function returns [A, B, C, D, E, F, G, H, I, J].
    private fun orderTypeArgsLeftToRight(c: IrClass, argsIncludingOuterClasses: List<IrTypeArgument>?): List<IrTypeArgument>? {
        if(argsIncludingOuterClasses.isNullOrEmpty())
            return argsIncludingOuterClasses
        val ret = ArrayList<IrTypeArgument>()
        // Iterate over nested inner classes starting at `c`'s surrounding top-level or static nested class and ending at `c`, from the outermost inwards:
        val truncatedParents = parentsWithTypeParametersInScope(c)
        for(parent in truncatedParents.reversed()) {
            val parentTypeParameters = getTypeParameters(parent)
            val firstArgIdx = argsIncludingOuterClasses.size - (ret.size + parentTypeParameters.size)
            ret.addAll(argsIncludingOuterClasses.subList(firstArgIdx, firstArgIdx + parentTypeParameters.size))
        }
        return ret
    }

    // `typeArgs` can be null to describe a raw generic type.
    // For non-generic types it will be zero-length list.
    fun useClassInstance(c: IrClass, typeArgs: List<IrTypeArgument>?, inReceiverContext: Boolean = false): UseClassInstanceResult {
        if (c.isAnonymousObject) {
            logger.error("Unexpected access to anonymous class instance")
        }

        val substituteClass = getJavaEquivalentClass(c)

        val extractClass = substituteClass ?: c

        // `KFunction1<T1,T2>` is substituted by `KFunction<T>`. The last type argument is the return type.
        // Similarly Function23 and above get replaced by kotlin.jvm.functions.FunctionN with only one type arg, the result type.
        // References to SomeGeneric<T1, T2, ...> where SomeGeneric is declared SomeGeneric<T1, T2, ...> are extracted
        // as if they were references to the unbound type SomeGeneric.
        val extractedTypeArgs = when {
            extractClass.symbol.isKFunction() && typeArgs != null && typeArgs.isNotEmpty() -> listOf(typeArgs.last())
            extractClass.fqNameWhenAvailable == FqName("kotlin.jvm.functions.FunctionN") && typeArgs != null && typeArgs.isNotEmpty() -> listOf(typeArgs.last())
            typeArgs != null && isUnspecialised(c, typeArgs) -> listOf()
            else -> typeArgs
        }

        val classTypeResult = addClassLabel(extractClass, extractedTypeArgs, inReceiverContext)

        // Extract both the Kotlin and equivalent Java classes, so that we have database entries
        // for both even if all internal references to the Kotlin type are substituted.
        if(c != extractClass) {
            extractClassLaterIfExternal(c)
        }

        return UseClassInstanceResult(classTypeResult, extractClass)
    }

    private fun isArray(t: IrSimpleType) = t.isBoxedArray || t.isPrimitiveArray()

    private fun extractClassLaterIfExternal(c: IrClass) {
        if (isExternalDeclaration(c)) {
            extractExternalClassLater(c)
        }
    }

    private fun extractExternalEnclosingClassLater(d: IrDeclaration) {
        when (val parent = d.parent) {
            is IrClass -> extractExternalClassLater(parent)
            is IrFunction -> extractExternalEnclosingClassLater(parent)
            is IrFile -> logger.error("extractExternalEnclosingClassLater but no enclosing class.")
            else -> logger.error("Unrecognised extractExternalEnclosingClassLater: " + d.javaClass)
        }
    }

    private fun extractPropertyLaterIfExternalFileMember(p: IrProperty) {
        if (isExternalFileClassMember(p)) {
            extractExternalClassLater(p.parentAsClass)
            dependencyCollector?.addDependency(p, externalClassExtractor.propertySignature)
            externalClassExtractor.extractLater(p)
        }
    }

    private fun extractFieldLaterIfExternalFileMember(f: IrField) {
        if (isExternalFileClassMember(f)) {
            extractExternalClassLater(f.parentAsClass)
            dependencyCollector?.addDependency(f, externalClassExtractor.fieldSignature)
            externalClassExtractor.extractLater(f)
        }
    }

    private fun extractFunctionLaterIfExternalFileMember(f: IrFunction) {
        if (isExternalFileClassMember(f)) {
            extractExternalClassLater(f.parentAsClass)
            (f as? IrSimpleFunction)?.correspondingPropertySymbol?.let {
                extractPropertyLaterIfExternalFileMember(it.owner)
                // No need to extract the function specifically, as the property's
                // getters and setters are extracted alongside it
                return
            }
            // Note we erase the parameter types before calling useType even though the signature should be the same
            // in order to prevent an infinite loop through useTypeParameter -> useDeclarationParent -> useFunction
            // -> extractFunctionLaterIfExternalFileMember, which would result for `fun <T> f(t: T) { ... }` for example.
            val ext = f.extensionReceiverParameter
            val parameters = if (ext != null) {
                listOf(ext) + f.valueParameters
            } else {
                f.valueParameters
            }

            val paramSigs = parameters.map { useType(erase(it.type)).javaResult.signature }
            val signature = paramSigs.joinToString(separator = ",", prefix = "(", postfix = ")")
            dependencyCollector?.addDependency(f, signature)
            externalClassExtractor.extractLater(f, signature)
        }
    }

    fun extractExternalClassLater(c: IrClass) {
        dependencyCollector?.addDependency(c)
        externalClassExtractor.extractLater(c)
    }

    private fun tryReplaceAndroidSyntheticClass(c: IrClass): IrClass {
        // The Android Kotlin Extensions Gradle plugin introduces synthetic functions, fields and classes. The most
        // obvious signature is that they lack any supertype information even though they are not root classes.
        // If possible, replace them by a real version of the same class.
        if (c.superTypes.isNotEmpty() ||
            c.origin != IrDeclarationOrigin.IR_EXTERNAL_JAVA_DECLARATION_STUB ||
            c.hasEqualFqName(FqName("java.lang.Object")))
            return c
        return globalExtensionState.syntheticToRealClassMap.getOrPut(c) {
            val result = c.fqNameWhenAvailable?.let {
                pluginContext.referenceClass(it)?.owner
            }
            if (result == null) {
                logger.warn("Failed to replace synthetic class ${c.name}")
            } else {
                logger.info("Replaced synthetic class ${c.name} with its real equivalent")
            }
            result
        } ?: c
    }

    private fun tryReplaceFunctionInSyntheticClass(f: IrFunction, getClassReplacement: (IrClass) -> IrClass): IrFunction {
        val parentClass = f.parent as? IrClass ?: return f
        val replacementClass = getClassReplacement(parentClass)
        if (replacementClass === parentClass)
            return f
        return globalExtensionState.syntheticToRealFunctionMap.getOrPut(f) {
            val result = replacementClass.declarations.find { replacementDecl ->
                replacementDecl is IrSimpleFunction && replacementDecl.name == f.name && replacementDecl.valueParameters.size == f.valueParameters.size && replacementDecl.valueParameters.zip(f.valueParameters).all {
                    erase(it.first.type) == erase(it.second.type)
                }
            } as IrFunction?
            if (result == null) {
                logger.warn("Failed to replace synthetic class function ${f.name}")
            } else {
                logger.info("Replaced synthetic class function ${f.name} with its real equivalent")
            }
            result
        } ?: f
    }

    fun tryReplaceSyntheticFunction(f: IrFunction): IrFunction {
        val androidReplacement = tryReplaceFunctionInSyntheticClass(f) { tryReplaceAndroidSyntheticClass(it) }
        return tryReplaceFunctionInSyntheticClass(androidReplacement) { tryReplaceParcelizeRawType(it)?.first ?: it }
    }

    fun tryReplaceAndroidSyntheticField(f: IrField): IrField {
        val parentClass = f.parent as? IrClass ?: return f
        val replacementClass = tryReplaceAndroidSyntheticClass(parentClass)
        if (replacementClass === parentClass)
            return f
        return globalExtensionState.syntheticToRealFieldMap.getOrPut(f) {
            val result = replacementClass.declarations.find { replacementDecl ->
                replacementDecl is IrField && replacementDecl.name == f.name
            } as IrField?
            if (result == null) {
                logger.warn("Failed to replace synthetic class field ${f.name}")
            } else {
                logger.info("Replaced synthetic class field ${f.name} with its real equivalent")
            }
            result
        } ?: f
    }

    private fun tryReplaceType(cBeforeReplacement: IrClass, argsIncludingOuterClassesBeforeReplacement: List<IrTypeArgument>?): Pair<IrClass, List<IrTypeArgument>?> {
        val c = tryReplaceAndroidSyntheticClass(cBeforeReplacement)
        val p = tryReplaceParcelizeRawType(c)
        return Pair(
            p?.first ?: c,
            p?.second ?: argsIncludingOuterClassesBeforeReplacement
        )
    }

    // `typeArgs` can be null to describe a raw generic type.
    // For non-generic types it will be zero-length list.
    private fun addClassLabel(cBeforeReplacement: IrClass, argsIncludingOuterClassesBeforeReplacement: List<IrTypeArgument>?, inReceiverContext: Boolean = false): TypeResult<DbClassorinterface> {
        val replaced = tryReplaceType(cBeforeReplacement, argsIncludingOuterClassesBeforeReplacement)
        val replacedClass = replaced.first
        val replacedArgsIncludingOuterClasses = replaced.second

        val classLabelResult = getClassLabel(replacedClass, replacedArgsIncludingOuterClasses)

        var instanceSeenBefore = true

        val classLabel : Label<out DbClassorinterface> = tw.getLabelFor(classLabelResult.classLabel) {
            instanceSeenBefore = false

            extractClassLaterIfExternal(replacedClass)
        }

        if (replacedArgsIncludingOuterClasses == null || replacedArgsIncludingOuterClasses.isNotEmpty()) {
            // If this is a generic type instantiation or a raw type then it has no
            // source entity, so we need to extract it here
            val extractorWithCSource by lazy { this.withFileOfClass(replacedClass) }

            if (!instanceSeenBefore) {
                extractorWithCSource.extractClassInstance(replacedClass, replacedArgsIncludingOuterClasses)
            }

            if (inReceiverContext && tw.lm.genericSpecialisationsExtracted.add(classLabelResult.classLabel)) {
                val supertypeMode = if (replacedArgsIncludingOuterClasses == null) ExtractSupertypesMode.Raw else ExtractSupertypesMode.Specialised(replacedArgsIncludingOuterClasses)
                extractorWithCSource.extractClassSupertypes(replacedClass, classLabel, supertypeMode, true)
                extractorWithCSource.extractNonPrivateMemberPrototypes(replacedClass, replacedArgsIncludingOuterClasses, classLabel)
            }
        }

        val fqName = replacedClass.fqNameWhenAvailable
        val signature = if (fqName == null) {
            logger.error("Unable to find signature/fqName for ${replacedClass.name}")
            // TODO: Should we return null here instead?
            "<no signature available>"
        } else {
            fqName.asString()
        }
        return TypeResult(
            classLabel,
            signature,
            classLabelResult.shortName)
    }

    private fun tryReplaceParcelizeRawType(c: IrClass): Pair<IrClass, List<IrTypeArgument>?>? {
        if (c.superTypes.isNotEmpty() ||
            c.origin != IrDeclarationOrigin.DEFINED ||
            c.hasEqualFqName(FqName("java.lang.Object"))) {
            return null
        }

        val fqName = c.fqNameWhenAvailable
        if (fqName == null) {
            return null
        }

        fun tryGetPair(arity: Int): Pair<IrClass, List<IrTypeArgument>?>? {
            val replaced = pluginContext.referenceClass(fqName)?.owner ?: return null
            return Pair(replaced, List(arity) { makeTypeProjection(pluginContext.irBuiltIns.anyNType, Variance.INVARIANT) })
        }

        // The list of types handled here match https://github.com/JetBrains/kotlin/blob/d7c7d1efd2c0983c13b175e9e4b1cda979521159/plugins/parcelize/parcelize-compiler/src/org/jetbrains/kotlin/parcelize/ir/AndroidSymbols.kt
        // Specifically, types are added for generic types created in AndroidSymbols.kt.
        // This replacement is from a raw type to its matching parameterized type with `Object` type arguments.
        return when (fqName.asString()) {
            "java.util.ArrayList" -> tryGetPair(1)
            "java.util.LinkedHashMap" -> tryGetPair(2)
            "java.util.LinkedHashSet" -> tryGetPair(1)
            "java.util.List" -> tryGetPair(1)
            "java.util.TreeMap" -> tryGetPair(2)
            "java.util.TreeSet" -> tryGetPair(1)

            "java.lang.Class" -> tryGetPair(1)

            else -> null
        }
    }

    fun useAnonymousClass(c: IrClass) =
        tw.lm.anonymousTypeMapping.getOrPut(c) {
            TypeResults(
                TypeResult(tw.getFreshIdLabel<DbClass>(), "", ""),
                TypeResult(fakeKotlinType(), "TODO", "TODO")
            )
        }

    fun fakeKotlinType(): Label<out DbKt_type> {
        val fakeKotlinPackageId: Label<DbPackage> = tw.getLabelFor("@\"FakeKotlinPackage\"", {
            tw.writePackages(it, "fake.kotlin")
        })
        val fakeKotlinClassId: Label<DbClass> = tw.getLabelFor("@\"FakeKotlinClass\"", {
            tw.writeClasses(it, "FakeKotlinClass", fakeKotlinPackageId, it)
        })
        val fakeKotlinTypeId: Label<DbKt_nullable_type> = tw.getLabelFor("@\"FakeKotlinType\"", {
            tw.writeKt_nullable_types(it, fakeKotlinClassId)
        })
        return fakeKotlinTypeId
    }

    // `args` can be null to describe a raw generic type.
    // For non-generic types it will be zero-length list.
    fun useSimpleTypeClass(c: IrClass, args: List<IrTypeArgument>?, hasQuestionMark: Boolean): TypeResults {
        if (c.isAnonymousObject) {
            args?.let {
                if (it.isNotEmpty() && !isUnspecialised(c, it)) {
                    logger.error("Unexpected specialised instance of generic anonymous class")
                }
            }

            return useAnonymousClass(c)
        }

        val classInstanceResult = useClassInstance(c, args)
        val javaClassId = classInstanceResult.typeResult.id
        val kotlinQualClassName = getUnquotedClassLabel(c, args).classLabel
        val javaResult = classInstanceResult.typeResult
        val kotlinResult = if (true) TypeResult(fakeKotlinType(), "TODO", "TODO") else
            if (hasQuestionMark) {
                val kotlinSignature = "$kotlinQualClassName?" // TODO: Is this right?
                val kotlinLabel = "@\"kt_type;nullable;$kotlinQualClassName\""
                val kotlinId: Label<DbKt_nullable_type> = tw.getLabelFor(kotlinLabel, {
                    tw.writeKt_nullable_types(it, javaClassId)
                })
                TypeResult(kotlinId, kotlinSignature, "TODO")
            } else {
                val kotlinSignature = kotlinQualClassName // TODO: Is this right?
                val kotlinLabel = "@\"kt_type;notnull;$kotlinQualClassName\""
                val kotlinId: Label<DbKt_notnull_type> = tw.getLabelFor(kotlinLabel, {
                    tw.writeKt_notnull_types(it, javaClassId)
                })
                TypeResult(kotlinId, kotlinSignature, "TODO")
            }
        return TypeResults(javaResult, kotlinResult)
    }

    // Given either a primitive array or a boxed array, returns primitive arrays unchanged,
    // but returns boxed arrays with a nullable, invariant component type, with any nested arrays
    // similarly transformed. For example, Array<out Array<in E>> would become Array<Array<E?>?>
    // Array<*> will become Array<Any?>.
    private fun getInvariantNullableArrayType(arrayType: IrSimpleType): IrSimpleType =
        if (arrayType.isPrimitiveArray())
            arrayType
        else {
            val componentType = arrayType.getArrayElementType(pluginContext.irBuiltIns)
            val componentTypeBroadened = when (componentType) {
                is IrSimpleType ->
                    if (isArray(componentType)) getInvariantNullableArrayType(componentType) else componentType
                else -> componentType
            }
            val unchanged =
                componentType == componentTypeBroadened &&
                        (arrayType.arguments[0] as? IrTypeProjection)?.variance == Variance.INVARIANT &&
                        componentType.isNullable()
            if (unchanged)
                arrayType
            else
                IrSimpleTypeImpl(
                    arrayType.classifier,
                    true,
                    listOf(makeTypeProjection(componentTypeBroadened, Variance.INVARIANT)),
                    listOf()
                )
        }

    private fun useArrayType(arrayType: IrSimpleType, componentType: IrType, elementType: IrType, dimensions: Int, isPrimitiveArray: Boolean): TypeResults {

        // Ensure we extract Array<Int> as Integer[], not int[], for example:
        fun nullableIfNotPrimitive(type: IrType) = if (type.isPrimitiveType() && !isPrimitiveArray) type.makeNullable() else type

        val componentTypeResults = useType(nullableIfNotPrimitive(componentType))
        val elementTypeLabel = useType(nullableIfNotPrimitive(elementType)).javaResult.id

        val javaShortName = componentTypeResults.javaResult.shortName + "[]"

        val id = tw.getLabelFor<DbArray>("@\"array;$dimensions;{${elementTypeLabel}}\"") {
            tw.writeArrays(
                it,
                javaShortName,
                elementTypeLabel,
                dimensions,
                componentTypeResults.javaResult.id)

            extractClassSupertypes(arrayType.classifier.owner as IrClass, it, ExtractSupertypesMode.Specialised(arrayType.arguments))

            // array.length
            val length = tw.getLabelFor<DbField>("@\"field;{$it};length\"")
            val intTypeIds = useType(pluginContext.irBuiltIns.intType)
            tw.writeFields(length, "length", intTypeIds.javaResult.id, it, length)
            tw.writeFieldsKotlinType(length, intTypeIds.kotlinResult.id)
            addModifiers(length, "public", "final")

            // Note we will only emit one `clone()` method per Java array type, so we choose `Array<C?>` as its Kotlin
            // return type, where C is the component type with any nested arrays themselves invariant and nullable.
            val kotlinCloneReturnType = getInvariantNullableArrayType(arrayType).makeNullable()
            val kotlinCloneReturnTypeLabel = useType(kotlinCloneReturnType).kotlinResult.id

            val clone = tw.getLabelFor<DbMethod>("@\"callable;{$it}.clone(){$it}\"")
            tw.writeMethods(clone, "clone", "clone()", it, it, clone)
            tw.writeMethodsKotlinType(clone, kotlinCloneReturnTypeLabel)
            addModifiers(clone, "public")
        }

        val javaResult = TypeResult(
            id,
            componentTypeResults.javaResult.signature + "[]",
            javaShortName)

        val arrayClassResult = useSimpleTypeClass(arrayType.classifier.owner as IrClass, arrayType.arguments, arrayType.hasQuestionMark)
        return TypeResults(javaResult, arrayClassResult.kotlinResult)
    }

    enum class TypeContext {
        RETURN, GENERIC_ARGUMENT, OTHER
    }

    private fun useSimpleType(s: IrSimpleType, context: TypeContext): TypeResults {
        if (s.abbreviation != null) {
            // TODO: Extract this information
        }
        // We use this when we don't actually have an IrClass for a class
        // we want to refer to
        // TODO: Eliminate the need for this if possible
        fun makeClass(pkgName: String, className: String): Label<DbClass> {
            val pkgId = extractPackage(pkgName)
            val label = "@\"class;$pkgName.$className\""
            val classId: Label<DbClass> = tw.getLabelFor(label, {
                tw.writeClasses(it, className, pkgId, it)
            })
            return classId
        }
        fun primitiveType(kotlinClass: IrClass, primitiveName: String?,
                          otherIsPrimitive: Boolean,
                          javaClass: IrClass,
                          kotlinPackageName: String, kotlinClassName: String): TypeResults {
            val javaResult = if ((context == TypeContext.RETURN || (context == TypeContext.OTHER && otherIsPrimitive)) && !s.hasQuestionMark && primitiveName != null) {
                    val label: Label<DbPrimitive> = tw.getLabelFor("@\"type;$primitiveName\"", {
                        tw.writePrimitives(it, primitiveName)
                    })
                    TypeResult(label, primitiveName, primitiveName)
                } else {
                    addClassLabel(javaClass, listOf())
                }
            val kotlinClassId = useClassInstance(kotlinClass, listOf()).typeResult.id
            val kotlinResult = if (true) TypeResult(fakeKotlinType(), "TODO", "TODO") else
                if (s.hasQuestionMark) {
                    val kotlinSignature = "$kotlinPackageName.$kotlinClassName?" // TODO: Is this right?
                    val kotlinLabel = "@\"kt_type;nullable;$kotlinPackageName.$kotlinClassName\""
                    val kotlinId: Label<DbKt_nullable_type> = tw.getLabelFor(kotlinLabel, {
                        tw.writeKt_nullable_types(it, kotlinClassId)
                    })
                    TypeResult(kotlinId, kotlinSignature, "TODO")
                } else {
                    val kotlinSignature = "$kotlinPackageName.$kotlinClassName" // TODO: Is this right?
                    val kotlinLabel = "@\"kt_type;notnull;$kotlinPackageName.$kotlinClassName\""
                    val kotlinId: Label<DbKt_notnull_type> = tw.getLabelFor(kotlinLabel, {
                        tw.writeKt_notnull_types(it, kotlinClassId)
                    })
                    TypeResult(kotlinId, kotlinSignature, "TODO")
                }
            return TypeResults(javaResult, kotlinResult)
        }

        val primitiveInfo = primitiveTypeMapping.getPrimitiveInfo(s)

        when {
            primitiveInfo != null -> return primitiveType(
                s.classifier.owner as IrClass,
                primitiveInfo.primitiveName, primitiveInfo.otherIsPrimitive,
                primitiveInfo.javaClass,
                primitiveInfo.kotlinPackageName, primitiveInfo.kotlinClassName
            )

            (s.isBoxedArray && s.arguments.isNotEmpty()) || s.isPrimitiveArray() -> {

                fun replaceComponentTypeWithAny(t: IrSimpleType, dimensions: Int): IrSimpleType =
                    if (dimensions == 0)
                        pluginContext.irBuiltIns.anyType as IrSimpleType
                    else
                        t.toBuilder().also { it.arguments = (it.arguments[0] as IrTypeProjection)
                            .let { oldArg ->
                                listOf(makeTypeProjection(replaceComponentTypeWithAny(oldArg.type as IrSimpleType, dimensions - 1), oldArg.variance))
                            }
                        }.buildSimpleType()

                var componentType = s.getArrayElementType(pluginContext.irBuiltIns)
                var isPrimitiveArray = false
                var dimensions = 0
                var elementType: IrType = s
                while (elementType.isBoxedArray || elementType.isPrimitiveArray()) {
                    dimensions++
                    if (elementType.isPrimitiveArray())
                        isPrimitiveArray = true
                    if (((elementType as IrSimpleType).arguments.singleOrNull() as? IrTypeProjection)?.variance == Variance.IN_VARIANCE) {
                        // Because Java's arrays are covariant, Kotlin will render Array<in X> as Object[], Array<Array<in X>> as Object[][] etc.
                        componentType = replaceComponentTypeWithAny(s, dimensions - 1)
                        elementType = pluginContext.irBuiltIns.anyType as IrSimpleType
                        break
                    }
                    elementType = elementType.getArrayElementType(pluginContext.irBuiltIns)
                }

                return useArrayType(
                    s,
                    componentType,
                    elementType,
                    dimensions,
                    isPrimitiveArray
                )
            }

            s.classifier.owner is IrClass -> {
                val classifier: IrClassifierSymbol = s.classifier
                val cls: IrClass = classifier.owner as IrClass
                val args = if (s.isRawType()) null else s.arguments

                return useSimpleTypeClass(cls, args, s.hasQuestionMark)
            }
            s.classifier.owner is IrTypeParameter -> {
                val javaResult = useTypeParameter(s.classifier.owner as IrTypeParameter)
                val aClassId = makeClass("kotlin", "TypeParam") // TODO: Wrong
                val kotlinResult = if (true) TypeResult(fakeKotlinType(), "TODO", "TODO") else
                    if (s.hasQuestionMark) {
                        val kotlinSignature = "${javaResult.signature}?" // TODO: Wrong
                        val kotlinLabel = "@\"kt_type;nullable;type_param\"" // TODO: Wrong
                        val kotlinId: Label<DbKt_nullable_type> = tw.getLabelFor(kotlinLabel, {
                            tw.writeKt_nullable_types(it, aClassId)
                        })
                        TypeResult(kotlinId, kotlinSignature, "TODO")
                    } else {
                        val kotlinSignature = javaResult.signature // TODO: Wrong
                        val kotlinLabel = "@\"kt_type;notnull;type_param\"" // TODO: Wrong
                        val kotlinId: Label<DbKt_notnull_type> = tw.getLabelFor(kotlinLabel, {
                            tw.writeKt_notnull_types(it, aClassId)
                        })
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

    fun useDeclarationParent(
        // The declaration parent according to Kotlin
        dp: IrDeclarationParent,
        // Whether the type of entity whose parent this is can be a
        // top-level entity in the JVM's eyes. If so, then its parent may
        // be a file; otherwise, if dp is a file foo.kt, then the parent
        // is really the JVM class FooKt.
        canBeTopLevel: Boolean,
        classTypeArguments: List<IrTypeArgument>? = null,
        inReceiverContext: Boolean = false):
        Label<out DbElement>? =
        when(dp) {
            is IrFile ->
                if(canBeTopLevel) {
                    usePackage(dp.fqName.asString())
                } else {
                    extractFileClass(dp)
                }
            is IrClass ->
                if (classTypeArguments != null && !dp.isAnonymousObject) {
                    useClassInstance(dp, classTypeArguments, inReceiverContext).typeResult.id
                } else {
                    val replacedType = tryReplaceParcelizeRawType(dp)
                    if (replacedType == null) {
                        useClassSource(dp)
                    } else {
                        useClassInstance(replacedType.first, replacedType.second, inReceiverContext).typeResult.id
                    }
                }
            is IrFunction -> useFunction(dp)
            is IrExternalPackageFragment -> {
                // TODO
                logger.error("Unhandled IrExternalPackageFragment")
                null
            }
            else -> {
                logger.error("Unrecognised IrDeclarationParent: " + dp.javaClass)
                null
            }
        }

    private val IrDeclaration.isAnonymousFunction get() = this is IrSimpleFunction && name == SpecialNames.NO_NAME_PROVIDED

    data class FunctionNames(val nameInDB: String, val kotlinName: String)

    @OptIn(ObsoleteDescriptorBasedAPI::class)
    private fun getJvmModuleName(f: IrFunction) =
        NameUtils.sanitizeAsJavaIdentifier(
            getJvmModuleNameForDeserializedDescriptor(f.descriptor) ?: JvmCodegenUtil.getModuleName(pluginContext.moduleDescriptor)
        )

    fun getFunctionShortName(f: IrFunction) : FunctionNames {
        if (f.origin == IrDeclarationOrigin.LOCAL_FUNCTION_FOR_LAMBDA || f.isAnonymousFunction)
            return FunctionNames(
                OperatorNameConventions.INVOKE.asString(),
                OperatorNameConventions.INVOKE.asString())

        fun getSuffixIfInternal() =
            if (f.visibility == DescriptorVisibilities.INTERNAL) {
                "\$" + getJvmModuleName(f)
            } else {
                ""
            }

        (f as? IrSimpleFunction)?.correspondingPropertySymbol?.let {
            val propName = it.owner.name.asString()
            val getter = it.owner.getter
            val setter = it.owner.setter

            if (it.owner.parentClassOrNull?.kind == ClassKind.ANNOTATION_CLASS) {
                if (getter == null) {
                    logger.error("Expected to find a getter for a property inside an annotation class")
                    return FunctionNames(propName, propName)
                } else {
                    val jvmName = getJvmName(getter)
                    return FunctionNames(jvmName ?: propName, propName)
                }
            }

            val maybeFunctionName = when (f) {
                getter -> JvmAbi.getterName(propName)
                setter -> JvmAbi.setterName(propName)
                else -> {
                    logger.error(
                        "Function has a corresponding property, but is neither the getter nor the setter"
                    )
                    null
                }
            }
            maybeFunctionName?.let { defaultFunctionName ->
                val suffix = if (f.visibility == DescriptorVisibilities.PRIVATE && f.origin == IrDeclarationOrigin.DEFAULT_PROPERTY_ACCESSOR) {
                    "\$private"
                } else {
                    getSuffixIfInternal()
                }
                return FunctionNames(getJvmName(f) ?: "$defaultFunctionName$suffix", defaultFunctionName)
            }
        }
        return FunctionNames(getJvmName(f) ?: "${f.name.asString()}${getSuffixIfInternal()}", f.name.asString())
    }

    // This excludes class type parameters that show up in (at least) constructors' typeParameters list.
    fun getFunctionTypeParameters(f: IrFunction): List<IrTypeParameter> {
        return if (f is IrConstructor) f.typeParameters else f.typeParameters.filter { it.parent == f }
    }

    private fun getTypeParameters(dp: IrDeclarationParent): List<IrTypeParameter> =
        when(dp) {
            is IrClass -> dp.typeParameters
            is IrFunction -> getFunctionTypeParameters(dp)
            else -> listOf()
        }

    private fun getEnclosingClass(it: IrDeclarationParent): IrClass? =
        when(it) {
            is IrClass -> it
            is IrFunction -> getEnclosingClass(it.parent)
            else -> null
        }

    val javaUtilCollection by lazy {
        val result = pluginContext.referenceClass(FqName("java.util.Collection"))?.owner
        result?.let { extractExternalClassLater(it) }
        result
    }

    val wildcardCollectionType by lazy {
        javaUtilCollection?.let {
            it.symbol.typeWithArguments(listOf(IrStarProjectionImpl))
        }
    }

    private fun makeCovariant(t: IrTypeArgument) =
        t.typeOrNull?.let { makeTypeProjection(it, Variance.OUT_VARIANCE) } ?: t

    private fun makeArgumentsCovariant(t: IrType) = (t as? IrSimpleType)?.let {
        t.toBuilder().also { b -> b.arguments = b.arguments.map(this::makeCovariant) }.buildSimpleType()
    } ?: t

    fun eraseCollectionsMethodParameterType(t: IrType, collectionsMethodName: String, paramIdx: Int) =
        when(collectionsMethodName) {
            "contains", "remove", "containsKey", "containsValue", "get", "indexOf", "lastIndexOf" -> javaLangObjectType
            "getOrDefault" -> if (paramIdx == 0) javaLangObjectType else null
            "containsAll", "removeAll", "retainAll" -> wildcardCollectionType
            // Kotlin defines these like addAll(Collection<E>); Java uses addAll(Collection<? extends E>)
            "putAll", "addAll" -> makeArgumentsCovariant(t)
            else -> null
        } ?: t

    private fun overridesFunctionDefinedOn(f: IrFunction, packageName: String, className: String) =
        (f as? IrSimpleFunction)?.let {
            it.overriddenSymbols.any { overridden ->
                overridden.owner.parentClassOrNull?.let { defnClass ->
                    defnClass.name.asString() == className &&
                    defnClass.packageFqName?.asString() == packageName
                } ?: false
            }
        } ?: false

    @OptIn(ObsoleteDescriptorBasedAPI::class)
    fun overridesCollectionsMethodWithAlteredParameterTypes(f: IrFunction) =
        BuiltinMethodsWithSpecialGenericSignature.getOverriddenBuiltinFunctionWithErasedValueParametersInJava(f.descriptor) != null ||
                (f.name.asString() == "putAll" && overridesFunctionDefinedOn(f, "kotlin.collections", "MutableMap")) ||
                (f.name.asString() == "addAll" && overridesFunctionDefinedOn(f, "kotlin.collections", "MutableCollection")) ||
                (f.name.asString() == "addAll" && overridesFunctionDefinedOn(f, "kotlin.collections", "MutableList"))


    private val jvmWildcardAnnotation = FqName("kotlin.jvm.JvmWildcard")
    private val jvmWildcardSuppressionAnnotaton = FqName("kotlin.jvm.JvmSuppressWildcards")

    private fun arrayExtendsAdditionAllowed(t: IrSimpleType): Boolean =
        // Note the array special case includes Array<*>, which does permit adding `? extends ...` (making `? extends Object[]` in that case)
        // Surprisingly Array<in X> does permit this as well, though the contravariant array lowers to Object[] so this ends up `? extends Object[]` as well.
        t.arguments[0].let {
            when (it) {
                is IrTypeProjection -> when (it.variance) {
                    Variance.INVARIANT -> false
                    Variance.IN_VARIANCE -> !(it.type.isAny() || it.type.isNullableAny())
                    Variance.OUT_VARIANCE -> extendsAdditionAllowed(it.type)
                }
                else -> true
            }
        }

    private fun extendsAdditionAllowed(t: IrType) =
        if (t.isBoxedArray)
            arrayExtendsAdditionAllowed(t as IrSimpleType)
        else
            ((t as? IrSimpleType)?.classOrNull?.owner?.isFinalClass) != true

    private fun wildcardAdditionAllowed(v: Variance, t: IrType, addByDefault: Boolean) =
        when {
            t.hasAnnotation(jvmWildcardAnnotation) -> true
            !addByDefault -> false
            t.hasAnnotation(jvmWildcardSuppressionAnnotaton) -> false
            v == Variance.IN_VARIANCE -> !(t.isNullableAny() || t.isAny())
            v == Variance.OUT_VARIANCE -> extendsAdditionAllowed(t)
            else -> false
        }

    private fun addJavaLoweringArgumentWildcards(p: IrTypeParameter, t: IrTypeArgument, addByDefault: Boolean, javaType: JavaType?): IrTypeArgument =
        (t as? IrTypeProjection)?.let {
            val newBase = addJavaLoweringWildcards(it.type, addByDefault, javaType)
            val newVariance =
                if (it.variance == Variance.INVARIANT &&
                    p.variance != Variance.INVARIANT &&
                    // The next line forbids inferring a wildcard type when we have a corresponding Java type with conflicting variance.
                    // For example, Java might declare f(Comparable<CharSequence> cs), in which case we shouldn't add a `? super ...`
                    // wildcard. Note if javaType is unknown (e.g. this is a Kotlin source element), we assume wildcards should be added.
                    (javaType?.let { jt -> jt is JavaWildcardType && jt.isExtends == (p.variance == Variance.OUT_VARIANCE) } != false) &&
                    wildcardAdditionAllowed(p.variance, it.type, addByDefault))
                    p.variance
                else
                    it.variance
            if (newBase !== it.type || newVariance != it.variance)
                makeTypeProjection(newBase, newVariance)
            else
                null
        } ?: t

    private fun getJavaTypeArgument(jt: JavaType, idx: Int) =
        when(jt) {
            is JavaClassifierType -> jt.typeArguments.getOrNull(idx)
            is JavaArrayType -> if (idx == 0) jt.componentType else null
            else -> null
        }

    fun addJavaLoweringWildcards(t: IrType, addByDefault: Boolean, javaType: JavaType?): IrType =
        (t as? IrSimpleType)?.let {
            val typeParams = it.classOrNull?.owner?.typeParameters ?: return t
            val newArgs = typeParams.zip(it.arguments).mapIndexed { idx, pair ->
                addJavaLoweringArgumentWildcards(
                    pair.first,
                    pair.second,
                    addByDefault,
                    javaType?.let { jt -> getJavaTypeArgument(jt, idx) }
                )
            }
            return if (newArgs.zip(it.arguments).all { pair -> pair.first === pair.second })
                t
            else
                it.toBuilder().also { builder -> builder.arguments = newArgs }.buildSimpleType()
        } ?: t

    /*
     * This is the normal getFunctionLabel function to use. If you want
     * to refer to the function in its source class then
     * classTypeArgsIncludingOuterClasses should be null. Otherwise, it
     * is the list of type arguments that need to be applied to its
     * enclosing classes to get the instantiation that this function is
     * in.
     */
    fun getFunctionLabel(f: IrFunction, classTypeArgsIncludingOuterClasses: List<IrTypeArgument>?) : String {
        return getFunctionLabel(f, null, classTypeArgsIncludingOuterClasses)
    }

    /*
     * There are some pairs of classes (e.g. `kotlin.Throwable` and
     * `java.lang.Throwable`) which are really just 2 different names
     * for the same class. However, we extract them as separate
     * classes. When extracting `kotlin.Throwable`'s methods, if we
     * looked up the parent ID ourselves, we would get as ID for
     * `java.lang.Throwable`, which isn't what we want. So we have to
     * allow it to be passed in.
    */
    @OptIn(ObsoleteDescriptorBasedAPI::class)
    fun getFunctionLabel(f: IrFunction, maybeParentId: Label<out DbElement>?, classTypeArgsIncludingOuterClasses: List<IrTypeArgument>?) =
        getFunctionLabel(
            f.parent,
            maybeParentId,
            getFunctionShortName(f).nameInDB,
            f.valueParameters,
            getAdjustedReturnType(f),
            f.extensionReceiverParameter,
            getFunctionTypeParameters(f),
            classTypeArgsIncludingOuterClasses,
            overridesCollectionsMethodWithAlteredParameterTypes(f),
            getJavaCallable(f),
            !hasWildcardSuppressionAnnotation(f)
        )

    /*
     * This function actually generates the label for a function.
     * Sometimes, a function is only generated by kotlinc when writing a
     * class file, so there is no corresponding `IrFunction` for it.
     * This function therefore takes all the constituent parts of a
     * function instead.
     */
    fun getFunctionLabel(
        // The parent of the function; normally f.parent.
        parent: IrDeclarationParent,
        // The ID of the function's parent, or null if we should work it out ourselves.
        maybeParentId: Label<out DbElement>?,
        // The name of the function; normally f.name.asString().
        name: String,
        // The value parameters that the functions takes; normally f.valueParameters.
        parameters: List<IrValueParameter>,
        // The return type of the function; normally f.returnType.
        returnType: IrType,
        // The extension receiver of the function, if any; normally f.extensionReceiverParameter.
        extensionReceiverParameter: IrValueParameter?,
        // The type parameters of the function. This does not include type parameters of enclosing classes.
        functionTypeParameters: List<IrTypeParameter>,
        // The type arguments of enclosing classes of the function.
        classTypeArgsIncludingOuterClasses: List<IrTypeArgument>?,
        // If true, this method implements a Java Collections interface (Collection, Map or List) and may need
        // parameter erasure to match the way this class will appear to an external consumer of the .class file.
        overridesCollectionsMethod: Boolean,
        // The Java signature of this callable, if known.
        javaSignature: JavaMember?,
        // If true, Java wildcards implied by Kotlin type parameter variance should be added by default to this function's value parameters' types.
        // (Return-type wildcard addition is always off by default)
        addParameterWildcardsByDefault: Boolean,
        // The prefix used in the label. "callable", unless a property label is created, then it's "property".
        prefix: String = "callable"
    ): String {
        val parentId = maybeParentId ?: useDeclarationParent(parent, false, classTypeArgsIncludingOuterClasses, true)
        val allParams = if (extensionReceiverParameter == null) {
                            parameters
                        } else {
                            listOf(extensionReceiverParameter) + parameters
                        }

        val substitutionMap = classTypeArgsIncludingOuterClasses?.let { notNullArgs ->
            if (notNullArgs.isEmpty()) {
                null
            } else {
                val enclosingClass = getEnclosingClass(parent)
                enclosingClass?.let { notNullClass -> makeTypeGenericSubstitutionMap(notNullClass, notNullArgs) }
            }
        }
        val getIdForFunctionLabel = { it: IndexedValue<IrValueParameter> ->
            // Kotlin rewrites certain Java collections types adding additional generic constraints-- for example,
            // Collection.remove(Object) because Collection.remove(Collection::E) in the Kotlin universe.
            // If this has happened, erase the type again to get the correct Java signature.
            val maybeAmendedForCollections = if (overridesCollectionsMethod) eraseCollectionsMethodParameterType(it.value.type, name, it.index) else it.value.type
            // Add any wildcard types that the Kotlin compiler would add in the Java lowering of this function:
            val withAddedWildcards = addJavaLoweringWildcards(maybeAmendedForCollections, addParameterWildcardsByDefault, javaSignature?.let { sig -> getJavaValueParameterType(sig, it.index) })
            // Now substitute any class type parameters in:
            val maybeSubbed = withAddedWildcards.substituteTypeAndArguments(substitutionMap, TypeContext.OTHER, pluginContext)
            // Finally, mimic the Java extractor's behaviour by naming functions with type parameters for their erased types;
            // those without type parameters are named for the generic type.
            val maybeErased = if (functionTypeParameters.isEmpty()) maybeSubbed else erase(maybeSubbed)
            "{${useType(maybeErased).javaResult.id}}"
        }
        val paramTypeIds = allParams.withIndex().joinToString(separator = ",", transform = getIdForFunctionLabel)
        val labelReturnType =
            if (name == "<init>")
                pluginContext.irBuiltIns.unitType
            else
                erase(returnType.substituteTypeAndArguments(substitutionMap, TypeContext.RETURN, pluginContext))
        // Note that `addJavaLoweringWildcards` is not required here because the return type used to form the function
        // label is always erased.
        val returnTypeId = useType(labelReturnType, TypeContext.RETURN).javaResult.id
        // This suffix is added to generic methods (and constructors) to match the Java extractor's behaviour.
        // Comments in that extractor indicates it didn't want the label of the callable to clash with the raw
        // method (and presumably that disambiguation is never needed when the method belongs to a parameterized
        // instance of a generic class), but as of now I don't know when the raw method would be referred to.
        val typeArgSuffix = if (functionTypeParameters.isNotEmpty() && classTypeArgsIncludingOuterClasses.isNullOrEmpty()) "<${functionTypeParameters.size}>" else "";
        return "@\"$prefix;{$parentId}.$name($paramTypeIds){$returnTypeId}${typeArgSuffix}\""
    }

    fun getAdjustedReturnType(f: IrFunction) : IrType {
        // The return type of `java.util.concurrent.ConcurrentHashMap<K,V>.keySet/0` is defined as `Set<K>` in the stubs inside the Android SDK.
        // This does not match the Java SDK return type: `ConcurrentHashMap.KeySetView<K,V>`, so it's adjusted here.
        // This is a deliberate change in the Android SDK: https://github.com/AndroidSDKSources/android-sdk-sources-for-api-level-31/blob/2c56b25f619575bea12f9c5520ed2259620084ac/java/util/concurrent/ConcurrentHashMap.java#L1244-L1249
        // The annotation on the source is not visible in the android.jar, so we can't make the change based on that.
        // TODO: there are other instances of `dalvik.annotation.codegen.CovariantReturnType` in the Android SDK, we should handle those too if they cause DB inconsistencies
        val parentClass = f.parentClassOrNull
        if (parentClass == null ||
            parentClass.fqNameWhenAvailable?.asString() != "java.util.concurrent.ConcurrentHashMap" ||
            getFunctionShortName(f).nameInDB != "keySet" ||
            f.valueParameters.isNotEmpty() ||
            f.returnType.classFqName?.asString() != "kotlin.collections.MutableSet") {
            return f.returnType
        }

        val otherKeySet = parentClass.declarations.filterIsInstance<IrFunction>().find { it.name.asString() == "keySet" && it.valueParameters.size == 1 }
            ?: return f.returnType

        return otherKeySet.returnType.codeQlWithHasQuestionMark(false)
    }

    @OptIn(ObsoleteDescriptorBasedAPI::class)
    fun getJavaCallable(f: IrFunction) = (f.descriptor.source as? JavaSourceElement)?.javaElement as? JavaMember

    fun getJavaValueParameterType(m: JavaMember, idx: Int) = when(m) {
        is JavaMethod -> m.valueParameters[idx].type
        is JavaConstructor -> m.valueParameters[idx].type
        else -> null
    }

    fun hasWildcardSuppressionAnnotation(d: IrDeclaration) =
        d.hasAnnotation(jvmWildcardSuppressionAnnotaton) ||
        // Note not using `parentsWithSelf` as that only works if `d` is an IrDeclarationParent
        d.parents.any { (it as? IrAnnotationContainer)?.hasAnnotation(jvmWildcardSuppressionAnnotaton) == true }

    protected fun IrFunction.isLocalFunction(): Boolean {
        return this.visibility == DescriptorVisibilities.LOCAL
    }

    /**
     * Class to hold labels for generated classes around local functions, lambdas, function references, and property references.
     */
    open class GeneratedClassLabels(val type: TypeResults, val constructor: Label<DbConstructor>, val constructorBlock: Label<DbBlock>)

    /**
     * Class to hold labels generated for locally visible functions, such as
     *  - local functions,
     *  - lambdas, and
     *  - wrappers around function references.
     */
    class LocallyVisibleFunctionLabels(type: TypeResults, constructor: Label<DbConstructor>, constructorBlock: Label<DbBlock>, val function: Label<DbMethod>)
        : GeneratedClassLabels(type, constructor, constructorBlock)

    /**
     * Gets the labels for functions belonging to
     *  - local functions, and
     *  - lambdas.
     */
    fun getLocallyVisibleFunctionLabels(f: IrFunction): LocallyVisibleFunctionLabels {
        if (!f.isLocalFunction()){
            logger.error("Extracting a non-local function as a local one")
        }

        var res = tw.lm.locallyVisibleFunctionLabelMapping[f]
        if (res == null) {
            val javaResult = TypeResult(tw.getFreshIdLabel<DbClass>(), "", "")
            val kotlinResult = TypeResult(tw.getFreshIdLabel<DbKt_notnull_type>(), "", "")
            tw.writeKt_notnull_types(kotlinResult.id, javaResult.id)
            res = LocallyVisibleFunctionLabels(
                TypeResults(javaResult, kotlinResult),
                tw.getFreshIdLabel(),
                tw.getFreshIdLabel(),
                tw.getFreshIdLabel()
            )
            tw.lm.locallyVisibleFunctionLabelMapping[f] = res
        }

        return res
    }

    // These are classes with Java equivalents, but whose methods don't all exist on those Java equivalents--
    // for example, the numeric classes define arithmetic functions (Int.plus, Long.or and so on) that lower to
    // primitive arithmetic on the JVM, but which we extract as calls to reflect the source syntax more closely.
    private val expectedMissingEquivalents = setOf(
        "kotlin.Boolean", "kotlin.Byte", "kotlin.Char", "kotlin.Double", "kotlin.Float", "kotlin.Int", "kotlin.Long", "kotlin.Number", "kotlin.Short"
    )

    private fun kotlinFunctionToJavaEquivalent(f: IrFunction, noReplace: Boolean) =
        if (noReplace)
            f
        else
            f.parentClassOrNull?.let { parentClass ->
                getJavaEquivalentClass(parentClass)?.let { javaClass ->
                    if (javaClass != parentClass)
                        // Look for an exact type match...
                        javaClass.declarations.find { decl ->
                            decl is IrFunction &&
                            decl.name == f.name &&
                            decl.valueParameters.size == f.valueParameters.size &&
                            // Note matching by classifier not the whole type so that generic arguments are allowed to differ,
                            // as they always will for method type parameters occurring in parameter types (e.g. <T> toArray(T[] array)
                            // Differing only by nullability would also be insignificant if it came up.
                            decl.valueParameters.zip(f.valueParameters).all { p -> p.first.type.classifierOrNull == p.second.type.classifierOrNull }
                        } ?:
                        // Or if there is none, look for the only viable overload
                        javaClass.declarations.singleOrNull { decl ->
                            decl is IrFunction &&
                            decl.name == f.name &&
                            decl.valueParameters.size == f.valueParameters.size
                        } ?:
                        // Or check property accessors:
                        if (f.isAccessor) {
                            val prop = javaClass.declarations.filterIsInstance<IrProperty>().find { decl ->
                                decl.name == (f.propertyIfAccessor as IrProperty).name
                            }
                            if (prop?.getter?.name == f.name)
                                prop.getter
                            else if (prop?.setter?.name == f.name)
                                prop.setter
                            else null
                        } else {
                            null
                        } ?: run {
                            val parentFqName = parentClass.fqNameWhenAvailable?.asString()
                            if (!expectedMissingEquivalents.contains(parentFqName)) {
                                logger.warn("Couldn't find a Java equivalent function to $parentFqName.${f.name} in ${javaClass.fqNameWhenAvailable}")
                            }
                            null
                        }
                    else
                        null
                }
            } as IrFunction? ?: f

    fun <T: DbCallable> useFunction(f: IrFunction, classTypeArgsIncludingOuterClasses: List<IrTypeArgument>? = null, noReplace: Boolean = false): Label<out T> {
        return useFunction(f, null, classTypeArgsIncludingOuterClasses, noReplace)
    }

    fun <T: DbCallable> useFunction(f: IrFunction, parentId: Label<out DbElement>?, classTypeArgsIncludingOuterClasses: List<IrTypeArgument>?, noReplace: Boolean = false): Label<out T> {
        if (f.isLocalFunction()) {
            val ids = getLocallyVisibleFunctionLabels(f)
            return ids.function.cast<T>()
        }
        val javaFun = kotlinFunctionToJavaEquivalent(f, noReplace)
        val label = getFunctionLabel(javaFun, parentId, classTypeArgsIncludingOuterClasses)
        val id: Label<T> = tw.getLabelFor(label)
        if (isExternalDeclaration(javaFun)) {
            extractFunctionLaterIfExternalFileMember(javaFun)
            extractExternalEnclosingClassLater(javaFun)
        }
        return id
    }

    fun getTypeArgumentLabel(
        arg: IrTypeArgument
    ): TypeResultWithoutSignature<DbReftype> {

        fun extractBoundedWildcard(wildcardKind: Int, wildcardLabelStr: String, wildcardShortName: String, boundLabel: Label<out DbReftype>): Label<DbWildcard> =
            tw.getLabelFor(wildcardLabelStr) { wildcardLabel ->
                tw.writeWildcards(wildcardLabel, wildcardShortName, wildcardKind)
                tw.writeHasLocation(wildcardLabel, tw.unknownLocation)
                tw.getLabelFor<DbTypebound>("@\"bound;0;{$wildcardLabel}\"") {
                    tw.writeTypeBounds(it, boundLabel, 0, wildcardLabel)
                }
            }

        // Note this function doesn't return a signature because type arguments are never incorporated into function signatures.
        return when (arg) {
            is IrStarProjection -> {
                val anyTypeLabel = useType(pluginContext.irBuiltIns.anyType).javaResult.id.cast<DbReftype>()
                TypeResultWithoutSignature(extractBoundedWildcard(1, "@\"wildcard;\"", "?", anyTypeLabel), Unit, "?")
            }
            is IrTypeProjection -> {
                val boundResults = useType(arg.type, TypeContext.GENERIC_ARGUMENT)
                val boundLabel = boundResults.javaResult.id.cast<DbReftype>()

                return if(arg.variance == Variance.INVARIANT)
                    boundResults.javaResult.cast<DbReftype>().forgetSignature()
                else {
                    val keyPrefix = if (arg.variance == Variance.IN_VARIANCE) "super" else "extends"
                    val wildcardKind = if (arg.variance == Variance.IN_VARIANCE) 2 else 1
                    val wildcardShortName = "? $keyPrefix ${boundResults.javaResult.shortName}"
                    TypeResultWithoutSignature(
                        extractBoundedWildcard(wildcardKind, "@\"wildcard;$keyPrefix{$boundLabel}\"", wildcardShortName, boundLabel),
                        Unit,
                        wildcardShortName)
                }
            }
            else -> {
                logger.error("Unexpected type argument.")
                return extractJavaErrorType().forgetSignature()
            }
        }
    }

    data class ClassLabelResults(
        val classLabel: String, val shortName: String
    )

    /**
     * This returns the `X` in c's label `@"class;X"`.
     *
     * `argsIncludingOuterClasses` can be null to describe a raw generic type.
     * For non-generic types it will be zero-length list.
     */
    private fun getUnquotedClassLabel(c: IrClass, argsIncludingOuterClasses: List<IrTypeArgument>?): ClassLabelResults {
        val pkg = c.packageFqName?.asString() ?: ""
        val cls = c.name.asString()
        val label = when (val parent = c.parent) {
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
                if (pkg.isEmpty()) cls else "$pkg.$cls"
            }
        }

        val reorderedArgs = orderTypeArgsLeftToRight(c, argsIncludingOuterClasses)
        val typeArgLabels = reorderedArgs?.map { getTypeArgumentLabel(it) }
        val typeArgsShortName =
            if (typeArgLabels == null)
                "<>"
            else if(typeArgLabels.isEmpty())
                ""
            else
                typeArgLabels.takeLast(c.typeParameters.size).joinToString(prefix = "<", postfix = ">", separator = ",") { it.shortName }

        return ClassLabelResults(
            label + (typeArgLabels?.joinToString(separator = "") { ";{${it.id}}" } ?: "<>"),
            cls + typeArgsShortName
        )
    }

    // `args` can be null to describe a raw generic type.
    // For non-generic types it will be zero-length list.
    fun getClassLabel(c: IrClass, argsIncludingOuterClasses: List<IrTypeArgument>?): ClassLabelResults {
        if (c.isAnonymousObject) {
            logger.error("Label generation should not be requested for an anonymous class")
        }

        val unquotedLabel = getUnquotedClassLabel(c, argsIncludingOuterClasses)
        return ClassLabelResults(
            "@\"class;${unquotedLabel.classLabel}\"",
            unquotedLabel.shortName)
    }

    fun useClassSource(c: IrClass): Label<out DbClassorinterface> {
        if (c.isAnonymousObject) {
            return useAnonymousClass(c).javaResult.id.cast<DbClass>()
        }

        // For source classes, the label doesn't include any type arguments
        val classTypeResult = addClassLabel(c, listOf())
        return classTypeResult.id
    }

    fun getTypeParameterParentLabel(param: IrTypeParameter) =
        param.parent.let {
            when (it) {
                is IrClass -> useClassSource(it)
                is IrFunction -> useFunction(it, noReplace = true)
                else -> { logger.error("Unexpected type parameter parent $it"); null }
            }
        }

    fun getTypeParameterLabel(param: IrTypeParameter): String {
        // Use this instead of `useDeclarationParent` so we can use useFunction with noReplace = true,
        // ensuring that e.g. a method-scoped type variable declared on kotlin.String.transform <R> gets
        // a different name to the corresponding java.lang.String.transform <R>, even though useFunction
        // will usually replace references to one function with the other.
        val parentLabel = getTypeParameterParentLabel(param)
        return "@\"typevar;{$parentLabel};${param.name}\""
    }

    private fun useTypeParameter(param: IrTypeParameter) =
        TypeResult(
            tw.getLabelFor<DbTypevariable>(getTypeParameterLabel(param)),
            useType(eraseTypeParameter(param)).javaResult.signature,
            param.name.asString()
        )

    private fun extractModifier(m: String): Label<DbModifier> {
        val modifierLabel = "@\"modifier;$m\""
        val id: Label<DbModifier> = tw.getLabelFor(modifierLabel, {
            tw.writeModifiers(it, m)
        })
        return id
    }

    fun addModifiers(modifiable: Label<out DbModifiable>, vararg modifiers: String) =
        modifiers.forEach { tw.writeHasModifier(modifiable, extractModifier(it)) }

    sealed class ExtractSupertypesMode {
        object Unbound : ExtractSupertypesMode()
        object Raw : ExtractSupertypesMode()
        data class Specialised(val typeArgs : List<IrTypeArgument>) : ExtractSupertypesMode()
    }

    /**
     * Extracts the supertypes of class `c`, either the unbound version, raw version or a specialisation to particular
     * type arguments, depending on the value of `mode`. `id` is the label of this class or class instantiation.
     *
     * For example, for type `List` if `mode` `Specialised([String])` then we will extract the supertypes
     * of `List<String>`, i.e. `Appendable<String>` etc, or if `mode` is `Unbound` we will extract `Appendable<E>`
     * where `E` is the type variable declared as `List<E>`. Finally if `mode` is `Raw` we will extract the raw type
     * `Appendable`, represented in QL as `Appendable<>`.
     *
     * Argument `inReceiverContext` will be passed onto the `useClassInstance` invocation for each supertype.
     */
    fun extractClassSupertypes(c: IrClass, id: Label<out DbReftype>, mode: ExtractSupertypesMode = ExtractSupertypesMode.Unbound, inReceiverContext: Boolean = false) {
        extractClassSupertypes(c.superTypes, c.typeParameters, id, mode, inReceiverContext)
    }

    fun extractClassSupertypes(superTypes: List<IrType>, typeParameters: List<IrTypeParameter>, id: Label<out DbReftype>, mode: ExtractSupertypesMode = ExtractSupertypesMode.Unbound, inReceiverContext: Boolean = false) {
        // Note we only need to substitute type args here because it is illegal to directly extend a type variable.
        // (For example, we can't have `class A<E> : E`, but can have `class A<E> : Comparable<E>`)
        val subbedSupertypes = when(mode) {
            is ExtractSupertypesMode.Specialised -> {
                superTypes.map {
                    it.substituteTypeArguments(typeParameters, mode.typeArgs)
                }
            }
            else -> superTypes
        }

        for(t in subbedSupertypes) {
            when(t) {
                is IrSimpleType -> {
                    when (t.classifier.owner) {
                        is IrClass -> {
                            val classifier: IrClassifierSymbol = t.classifier
                            val tcls: IrClass = classifier.owner as IrClass
                            val typeArgs = if (t.arguments.isNotEmpty() && mode is ExtractSupertypesMode.Raw) null else t.arguments
                            val l = useClassInstance(tcls, typeArgs, inReceiverContext).typeResult.id
                            tw.writeExtendsReftype(id, l)
                        }
                        else -> {
                            logger.error("Unexpected simple type supertype: " + t.javaClass + ": " + t.render())
                        }
                    }
                } else -> {
                    logger.error("Unexpected supertype: " + t.javaClass + ": " + t.render())
                }
            }
        }
    }

    fun useValueDeclaration(d: IrValueDeclaration): Label<out DbVariable>? =
        when(d) {
            is IrValueParameter -> useValueParameter(d, null)
            is IrVariable -> useVariable(d)
            else -> {
                logger.error("Unrecognised IrValueDeclaration: " + d.javaClass)
                null
            }
        }

    /**
     * Returns `t` with generic types replaced by raw types, and type parameters replaced by their first bound.
     *
     * Note that `Array<T>` is retained (with `T` itself erased) because these are expected to be lowered to Java
     * arrays, which are not generic.
     */
    private fun erase (t: IrType): IrType {
        if (t is IrSimpleType) {
            val classifier = t.classifier
            val owner = classifier.owner
            if(owner is IrTypeParameter) {
                return eraseTypeParameter(owner)
            }

            if (t.isArray() || t.isNullableArray()) {
                val elementType = t.getArrayElementType(pluginContext.irBuiltIns)
                val erasedElementType = erase(elementType)
                return (classifier as IrClassSymbol).typeWith(erasedElementType).codeQlWithHasQuestionMark(t.hasQuestionMark)
            }

            if (owner is IrClass) {
                return if (t.arguments.isNotEmpty())
                    t.addAnnotations(listOf(RawTypeAnnotation.annotationConstructor))
                else
                    t
            }
        }
        return t
    }

    private fun eraseTypeParameter(t: IrTypeParameter) =
        erase(t.superTypes[0])

    /**
     * Gets the label for `vp` in the context of function instance `parent`, or in that of its declaring function if
     * `parent` is null.
     */
    fun getValueParameterLabel(vp: IrValueParameter, parent: Label<out DbCallable>?): String {
        val declarationParent = vp.parent
        val parentId = parent ?: useDeclarationParent(declarationParent, false)

        val idx = if (declarationParent is IrFunction && declarationParent.extensionReceiverParameter != null)
            // For extension functions increase the index to match what the java extractor sees:
            vp.index + 1
        else
            vp.index

        if (idx < 0) {
            // We're not extracting this and this@TYPE parameters of functions:
            logger.error("Unexpected negative index for parameter")
        }

        return "@\"params;{$parentId};$idx\""
    }


    fun useValueParameter(vp: IrValueParameter, parent: Label<out DbCallable>?): Label<out DbParam> =
        tw.getLabelFor(getValueParameterLabel(vp, parent))

    private fun isDirectlyExposedCompanionObjectField(f: IrField) =
        f.hasAnnotation(FqName("kotlin.jvm.JvmField")) ||
        f.correspondingPropertySymbol?.owner?.let {
            it.isConst || it.isLateinit
        } ?: false

    fun getFieldParent(f: IrField) =
        f.parentClassOrNull?.let {
            if (it.isCompanion && isDirectlyExposedCompanionObjectField(f))
                it.parent
            else
                null
        } ?: f.parent

    // Gets a field's corresponding property's extension receiver type, if any
    fun getExtensionReceiverType(f: IrField) =
        f.correspondingPropertySymbol?.owner?.let {
            (it.getter ?: it.setter)?.extensionReceiverParameter?.type
        }

    fun getFieldLabel(f: IrField): String {
        val parentId = useDeclarationParent(getFieldParent(f), false)
        // Distinguish backing fields of properties based on their extension receiver type;
        // otherwise two extension properties declared in the same enclosing context will get
        // clashing trap labels. These are always private, so we can just make up a label without
        // worrying about their names as seen from Java.
        val extensionPropertyDiscriminator = getExtensionReceiverType(f)?.let { "extension;${useType(it).javaResult.id}" } ?: ""
        return "@\"field;{$parentId};${extensionPropertyDiscriminator}${f.name.asString()}\""
    }

    fun useField(f: IrField): Label<out DbField> =
        tw.getLabelFor<DbField>(getFieldLabel(f)).also { extractFieldLaterIfExternalFileMember(f) }

    fun getPropertyLabel(p: IrProperty): String? {
        val parentId = useDeclarationParent(p.parent, false)
        if (parentId == null) {
            return null
        } else {
            return getPropertyLabel(p, parentId, null)
        }
    }

    private fun getPropertyLabel(p: IrProperty, parentId: Label<out DbElement>, classTypeArgsIncludingOuterClasses: List<IrTypeArgument>?): String {
        val getter = p.getter
        val setter = p.setter

        val func = getter ?: setter
        val ext = func?.extensionReceiverParameter

        return if (ext == null) {
            "@\"property;{$parentId};${p.name.asString()}\""
        } else {
            val returnType = getter?.returnType ?: setter?.valueParameters?.singleOrNull()?.type ?: pluginContext.irBuiltIns.unitType
            val typeParams = getFunctionTypeParameters(func)

            getFunctionLabel(p.parent, parentId, p.name.asString(), listOf(), returnType, ext, typeParams, classTypeArgsIncludingOuterClasses, overridesCollectionsMethod = false, javaSignature = null, addParameterWildcardsByDefault = false, prefix = "property")
        }
    }

    fun useProperty(p: IrProperty, parentId: Label<out DbElement>, classTypeArgsIncludingOuterClasses: List<IrTypeArgument>?): Label<out DbKt_property> =
        tw.getLabelFor<DbKt_property>(getPropertyLabel(p, parentId, classTypeArgsIncludingOuterClasses)).also { extractPropertyLaterIfExternalFileMember(p) }

    fun getEnumEntryLabel(ee: IrEnumEntry): String {
        val parentId = useDeclarationParent(ee.parent, false)
        return "@\"field;{$parentId};${ee.name.asString()}\""
    }

    fun useEnumEntry(ee: IrEnumEntry): Label<out DbField> =
        tw.getLabelFor(getEnumEntryLabel(ee))

    fun getTypeAliasLabel(ta: IrTypeAlias): String {
        val parentId = useDeclarationParent(ta.parent, true)
        return "@\"type_alias;{$parentId};${ta.name.asString()}\""
    }

    fun useTypeAlias(ta: IrTypeAlias): Label<out DbKt_type_alias> =
        tw.getLabelFor(getTypeAliasLabel(ta))

    fun useVariable(v: IrVariable): Label<out DbLocalvar> {
        return tw.getVariableLabelFor<DbLocalvar>(v)
    }

}
