package com.github.codeql

import com.github.codeql.utils.substituteTypeArguments
import com.semmle.extractor.java.OdasaOutput
import org.jetbrains.kotlin.backend.common.extensions.IrPluginContext
import org.jetbrains.kotlin.backend.jvm.ir.propertyIfAccessor
import org.jetbrains.kotlin.builtins.jvm.JavaToKotlinClassMap
import org.jetbrains.kotlin.descriptors.DescriptorVisibilities
import org.jetbrains.kotlin.descriptors.Modality
import org.jetbrains.kotlin.ir.declarations.*
import org.jetbrains.kotlin.ir.symbols.IrClassSymbol
import org.jetbrains.kotlin.ir.symbols.IrClassifierSymbol
import org.jetbrains.kotlin.ir.types.*
import org.jetbrains.kotlin.ir.types.impl.IrSimpleTypeImpl
import org.jetbrains.kotlin.ir.types.impl.makeTypeProjection
import org.jetbrains.kotlin.ir.util.*
import org.jetbrains.kotlin.load.java.JvmAbi
import org.jetbrains.kotlin.name.SpecialNames
import org.jetbrains.kotlin.types.Variance
import org.jetbrains.kotlin.util.OperatorNameConventions

open class KotlinUsesExtractor(
    open val logger: Logger,
    open val tw: TrapWriter,
    val dependencyCollector: OdasaOutput.TrapFileManager?,
    val externalClassExtractor: ExternalClassExtractor,
    val primitiveTypeMapping: PrimitiveTypeMapping,
    val pluginContext: IrPluginContext,
    val genericSpecialisationsExtracted: MutableSet<String>
) {
    fun usePackage(pkg: String): Label<out DbPackage> {
        return extractPackage(pkg)
    }

    fun extractPackage(pkg: String): Label<out DbPackage> {
        val pkgLabel = "@\"package;$pkg\""
        val id: Label<DbPackage> = tw.getLabelFor(pkgLabel, {
            tw.writePackages(it, pkg)
        })
        return id
    }

    data class UseClassInstanceResult(val typeResult: TypeResult<DbClassorinterface>, val javaClass: IrClass)
    /**
     * A triple of a type's database label, its signature for use in callable signatures, and its short name for use
     * in all tables that provide a user-facing type name.
     *
     * `signature` is a Java primitive name (e.g. "int"), a fully-qualified class name ("package.OuterClass.InnerClass"),
     * or an array ("componentSignature[]")
     * Type variables have the signature of their upper bound.
     * Type arguments and anonymous types do not have a signature.
     *
     * `shortName` is a Java primitive name (e.g. "int"), a class short name with Java-style type arguments ("InnerClass<E>" or
     * "OuterClass<ConcreteArgument>" or "OtherClass<? extends Bound>") or an array ("componentShortName[]").
     */
    data class TypeResult<out LabelType>(val id: Label<out LabelType>, val signature: String?, val shortName: String)
    data class TypeResults(val javaResult: TypeResult<DbType>, val kotlinResult: TypeResult<DbKt_type>)

    fun useType(t: IrType, context: TypeContext = TypeContext.OTHER) =
        when(t) {
            is IrSimpleType -> useSimpleType(t, context)
            else -> {
                logger.warn(Severity.ErrorSevere, "Unrecognised IrType: " + t.javaClass)
                TypeResults(TypeResult(fakeLabel(), "unknown", "unknown"), TypeResult(fakeLabel(), "unknown", "unknown"))
            }
        }

    fun getJavaEquivalentClass(c: IrClass) =
        c.fqNameWhenAvailable?.toUnsafe()
            ?.let { JavaToKotlinClassMap.mapKotlinToJava(it) }
            ?.let { pluginContext.referenceClass(it.asSingleFqName()) }
            ?.owner

    /**
     * Gets a KotlinFileExtractor based on this one, except it attributes locations to the file that declares the given class.
     */
    private fun withSourceFileOfClass(cls: IrClass): KotlinFileExtractor {
        val clsFile = cls.fileOrNull

        if (isExternalDeclaration(cls) || clsFile == null) {
            val newTrapWriter = tw.makeFileTrapWriter(getIrClassBinaryPath(cls), false)
            val newLogger = FileLogger(logger.logCounter, newTrapWriter)
            return KotlinFileExtractor(newLogger, newTrapWriter, dependencyCollector, externalClassExtractor, primitiveTypeMapping, pluginContext, genericSpecialisationsExtracted)
        }

        if (this is KotlinSourceFileExtractor && this.file == clsFile) {
            return this
        }

        val newTrapWriter = tw.makeSourceFileTrapWriter(clsFile, false)
        val newLogger = FileLogger(logger.logCounter, newTrapWriter)
        return KotlinSourceFileExtractor(newLogger, newTrapWriter, clsFile, externalClassExtractor, primitiveTypeMapping, pluginContext, genericSpecialisationsExtracted)
    }

    fun useClassInstance(c: IrClass, typeArgs: List<IrTypeArgument>, inReceiverContext: Boolean = false): UseClassInstanceResult {
        if (c.isAnonymousObject) {
            logger.warn(Severity.ErrorSevere, "Unexpected access to anonymous class instance")
        }

        // TODO: only substitute in class and function signatures
        //       because within function bodies we can get things like Unit.INSTANCE
        //       and List.asIterable (an extension, i.e. static, method)
        // Map Kotlin class to its equivalent Java class:
        val substituteClass = getJavaEquivalentClass(c)

        val extractClass = substituteClass ?: c

        val classTypeResult = addClassLabel(extractClass, typeArgs, inReceiverContext)

        // Extract both the Kotlin and equivalent Java classes, so that we have database entries
        // for both even if all internal references to the Kotlin type are substituted.
        if(c != extractClass) {
            extractClassLaterIfExternal(c)
        }

        return UseClassInstanceResult(classTypeResult, extractClass)
    }

    fun isExternalDeclaration(d: IrDeclaration): Boolean {
        return d.origin == IrDeclarationOrigin.IR_EXTERNAL_DECLARATION_STUB ||
               d.origin == IrDeclarationOrigin.IR_EXTERNAL_JAVA_DECLARATION_STUB
    }

    fun isArray(t: IrSimpleType) = t.isBoxedArray || t.isPrimitiveArray()

    fun extractClassLaterIfExternal(c: IrClass) {
        if (isExternalDeclaration(c)) {
            extractExternalClassLater(c)
        }
    }

    fun extractExternalEnclosingClassLater(d: IrDeclaration) {
        when (val parent = d.parent) {
            is IrClass -> extractExternalClassLater(parent)
            is IrFunction -> extractExternalEnclosingClassLater(parent)
            is IrFile -> logger.warn(Severity.ErrorSevere, "extractExternalEnclosingClassLater but no enclosing class.")
            else -> logger.warn(Severity.ErrorSevere, "Unrecognised extractExternalEnclosingClassLater: " + d.javaClass)
        }
    }

    fun extractExternalClassLater(c: IrClass) {
        dependencyCollector?.addDependency(c)
        externalClassExtractor.extractLater(c)
    }

    fun addClassLabel(c: IrClass, typeArgs: List<IrTypeArgument>, inReceiverContext: Boolean = false): TypeResult<DbClassorinterface> {
        val classLabelResult = getClassLabel(c, typeArgs)

        var instanceSeenBefore = true

        val classLabel : Label<out DbClassorinterface> = tw.getLabelFor(classLabelResult.classLabel, {
            instanceSeenBefore = false

            extractClassLaterIfExternal(c)
        })

        if (typeArgs.isNotEmpty()) {
            // If this is a generic type instantiation then it has no
            // source entity, so we need to extract it here
            val extractorWithCSource by lazy { this.withSourceFileOfClass(c) }

            if (!instanceSeenBefore) {
                extractorWithCSource.extractClassInstance(c, typeArgs)
            }

            if (inReceiverContext && genericSpecialisationsExtracted.add(classLabelResult.classLabel)) {
                extractorWithCSource.extractMemberPrototypes(c, typeArgs, classLabel)
            }
        }

        return TypeResult(
            classLabel,
            c.fqNameWhenAvailable?.asString(),
            classLabelResult.shortName)
    }

    private val anonymousTypeMapping: MutableMap<IrClass, TypeResults> = mutableMapOf()

    fun useAnonymousClass(c: IrClass): TypeResults {
        var res = anonymousTypeMapping[c]
        if (res == null) {
            val javaResult = TypeResult(tw.getFreshIdLabel<DbClass>(), "", "")
            val kotlinResult = TypeResult(tw.getFreshIdLabel<DbKt_notnull_type>(), "", "")
            tw.writeKt_notnull_types(kotlinResult.id, javaResult.id)
            res = TypeResults(javaResult, kotlinResult)
            anonymousTypeMapping[c] = res
        }

        return res
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

    fun useSimpleTypeClass(c: IrClass, args: List<IrTypeArgument>, hasQuestionMark: Boolean): TypeResults {
        if (c.isAnonymousObject) {
            if (args.isNotEmpty()) {
                logger.warn(Severity.ErrorHigh, "Anonymous class with unexpected type arguments")
            }
            if (hasQuestionMark) {
                logger.warn(Severity.ErrorHigh, "Unexpected nullable anonymous class")
            }

            return useAnonymousClass(c)
        }

        val classInstanceResult = useClassInstance(c, args)
        val javaClassId = classInstanceResult.typeResult.id
        val kotlinQualClassName = getUnquotedClassLabel(c, args).classLabel
        // TODO: args ought to be substituted, so e.g. MutableList<MutableList<String>> gets the Java type List<List<String>>
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
    fun getInvariantNullableArrayType(arrayType: IrSimpleType): IrSimpleType =
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

    fun useArrayType(arrayType: IrSimpleType, componentType: IrType, elementType: IrType, dimensions: Int, isPrimitiveArray: Boolean): TypeResults {

        // Ensure we extract Array<Int> as Integer[], not int[], for example:
        fun nullableIfNotPrimitive(type: IrType) = if (type.isPrimitiveType() && !isPrimitiveArray) type.makeNullable() else type

        // TODO: Figure out what signatures should be returned

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

            extractClassSupertypes(arrayType.classifier.owner as IrClass, it, arrayType.arguments)

            // array.length
            val length = tw.getLabelFor<DbField>("@\"field;{$it};length\"")
            val intTypeIds = useType(pluginContext.irBuiltIns.intType)
            tw.writeFields(length, "length", intTypeIds.javaResult.id, intTypeIds.kotlinResult.id, it, length)
            addModifiers(length, "public", "final")

            // Note we will only emit one `clone()` method per Java array type, so we choose `Array<C?>` as its Kotlin
            // return type, where C is the component type with any nested arrays themselves invariant and nullable.
            val kotlinCloneReturnType = getInvariantNullableArrayType(arrayType).makeNullable()
            val kotlinCloneReturnTypeLabel = useType(kotlinCloneReturnType).kotlinResult.id

            val clone = tw.getLabelFor<DbMethod>("@\"callable;{$it}.clone(){$it}\"")
            tw.writeMethods(clone, "clone", "clone()", it, kotlinCloneReturnTypeLabel, it, clone)
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

    fun useSimpleType(s: IrSimpleType, context: TypeContext): TypeResults {
        if (s.abbreviation != null) {
            // TODO: Extract this information
            logger.warn(Severity.ErrorSevere, "Type alias ignored for " + s.render())
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
/*
XXX delete?
            // temporary fix for type parameters types that would otherwise be primitive types
            !canReturnPrimitiveTypes && (s.isPrimitiveType() || s.isUnsignedType() || s.isString()) -> {
                val classifier: IrClassifierSymbol = s.classifier
                val cls: IrClass = classifier.owner as IrClass

                return useClassInstance(cls, s.arguments)
            }

*/
            primitiveInfo != null -> return primitiveType(
                s.classifier.owner as IrClass,
                primitiveInfo.primitiveName, primitiveInfo.otherIsPrimitive,
                primitiveInfo.javaClass,
                primitiveInfo.kotlinPackageName, primitiveInfo.kotlinClassName
            )
/*
TODO: Test case: nullable and has-question-mark type variables:
class X {
    fun <T : Int> f1(t: T?) {
        f1(null)
    }

    fun <T : Int?> f2(t: T) {
        f2(null)
    }
}

TODO: Test case: This breaks kotlinc codegen currently, but up to IR is OK, so we can still have it in a qltest
class X {
    fun <T : Int> f1(t: T?) {
        f1(null)
    }
}
*/

            (s.isBoxedArray && s.arguments.isNotEmpty()) || s.isPrimitiveArray() -> {
                var dimensions = 1
                var isPrimitiveArray = s.isPrimitiveArray()
                val componentType = s.getArrayElementType(pluginContext.irBuiltIns)
                var elementType = componentType
                while (elementType.isBoxedArray || elementType.isPrimitiveArray()) {
                    dimensions++
                    if(elementType.isPrimitiveArray())
                        isPrimitiveArray = true
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

                return useSimpleTypeClass(cls, s.arguments, s.hasQuestionMark)
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
                logger.warn(Severity.ErrorSevere, "Unrecognised IrSimpleType: " + s.javaClass + ": " + s.render())
                return TypeResults(TypeResult(fakeLabel(), "unknown", "unknown"), TypeResult(fakeLabel(), "unknown", "unknown"))
            }
        }
    }

    fun useDeclarationParent(dp: IrDeclarationParent, classTypeArguments: List<IrTypeArgument>? = null, inReceiverContext: Boolean = false): Label<out DbElement> =
        when(dp) {
            is IrFile -> usePackage(dp.fqName.asString())
            is IrClass -> if (classTypeArguments != null && !dp.isAnonymousObject) useClassInstance(dp, classTypeArguments, inReceiverContext).typeResult.id else useClassSource(dp)
            is IrFunction -> useFunction(dp)
            else -> {
                logger.warn(Severity.ErrorSevere, "Unrecognised IrDeclarationParent: " + dp.javaClass)
                fakeLabel()
            }
        }

    private val IrDeclaration.isAnonymousFunction get() = this is IrSimpleFunction && name == SpecialNames.NO_NAME_PROVIDED

    fun getFunctionShortName(f: IrFunction) : String {
        if (f.origin == IrDeclarationOrigin.LOCAL_FUNCTION_FOR_LAMBDA || f.isAnonymousFunction)
            return OperatorNameConventions.INVOKE.asString()
        (f as? IrSimpleFunction)?.correspondingPropertySymbol?.let {
            val propName = it.owner.name.asString()
            when(f) {
                it.owner.getter -> return JvmAbi.getterName(propName)
                it.owner.setter -> return JvmAbi.setterName(propName)
                else -> {
                    logger.warn(
                        Severity.ErrorSevere,
                        "Function has a corresponding property, but is neither the getter nor the setter"
                    )
                }
            }
        }
        return f.name.asString()
    }

    fun getFunctionLabel(f: IrFunction, classTypeArguments: List<IrTypeArgument>? = null) : String {
        return getFunctionLabel(f.parent, getFunctionShortName(f), f.valueParameters, f.returnType, f.extensionReceiverParameter, classTypeArguments)
    }

    fun getFunctionLabel(
        parent: IrDeclarationParent,
        name: String,
        parameters: List<IrValueParameter>,
        returnType: IrType,
        extensionReceiverParameter: IrValueParameter?,
        classTypeArguments: List<IrTypeArgument>? = null
    ): String {
        val parentId = useDeclarationParent(parent, classTypeArguments, true)
        return getFunctionLabel(parentId, name, parameters, returnType, extensionReceiverParameter)
    }

    fun getFunctionLabel(f: IrFunction, parentId: Label<out DbElement>) =
        getFunctionLabel(parentId, getFunctionShortName(f), f.valueParameters, f.returnType, f.extensionReceiverParameter)

    fun getFunctionLabel(
        parentId: Label<out DbElement>,
        name: String,
        parameters: List<IrValueParameter>,
        returnType: IrType,
        extensionReceiverParameter: IrValueParameter?
    ): String {
        val allParams = if (extensionReceiverParameter == null) {
                            parameters
                        } else {
                            val params = mutableListOf(extensionReceiverParameter)
                            params.addAll(parameters)
                            params
                        }
        val paramTypeIds = allParams.joinToString { "{${useType(erase(it.type)).javaResult.id}}" }
        val returnTypeId = useType(erase(returnType)).javaResult.id
        return "@\"callable;{$parentId}.$name($paramTypeIds){$returnTypeId}\""
    }

    protected fun IrFunction.isLocalFunction(): Boolean {
        return this.visibility == DescriptorVisibilities.LOCAL
    }

    private val generatedLocalFunctionTypeMapping: MutableMap<IrFunction, LocalFunctionLabels> = mutableMapOf()

    data class LocalFunctionLabels(val type: TypeResults, val constructor: Label<DbConstructor>, val function: Label<DbMethod>)

    fun getLocalFunctionLabels(f: IrFunction): LocalFunctionLabels {
        if (!f.isLocalFunction()){
            logger.warn(Severity.ErrorSevere, "Extracting a non-local function as a local one")
        }

        var res = generatedLocalFunctionTypeMapping[f]
        if (res == null) {
            val javaResult = TypeResult(tw.getFreshIdLabel<DbClass>(), "", "")
            val kotlinResult = TypeResult(tw.getFreshIdLabel<DbKt_notnull_type>(), "", "")
            tw.writeKt_notnull_types(kotlinResult.id, javaResult.id)
            res = LocalFunctionLabels(
                TypeResults(javaResult, kotlinResult),
                tw.getFreshIdLabel(),
                tw.getFreshIdLabel())
            generatedLocalFunctionTypeMapping[f] = res
        }

        return res
    }

    fun <T: DbCallable> useFunctionCommon(f: IrFunction, label: String): Label<out T> {
        val id: Label<T> = tw.getLabelFor(label)
        if (isExternalDeclaration(f)) {
            extractExternalEnclosingClassLater(f)
        }
        return id
    }

    fun <T: DbCallable> useFunction(f: IrFunction, classTypeArguments: List<IrTypeArgument>? = null): Label<out T> {
        if (f.isLocalFunction()) {
            val ids = getLocalFunctionLabels(f)
            @Suppress("UNCHECKED_CAST")
            return ids.function as Label<out T>
        } else {
            return useFunctionCommon<T>(f, getFunctionLabel(f, classTypeArguments))
        }
    }

    fun <T: DbCallable> useFunction(f: IrFunction, parentId: Label<out DbElement>) =
        useFunctionCommon<T>(f, getFunctionLabel(f, parentId))

    fun getTypeArgumentLabel(
        arg: IrTypeArgument
    ): TypeResult<DbReftype> {

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
                @Suppress("UNCHECKED_CAST")
                val anyTypeLabel = useType(pluginContext.irBuiltIns.anyType).javaResult.id as Label<out DbReftype>
                TypeResult(extractBoundedWildcard(1, "@\"wildcard;\"", "?", anyTypeLabel), null, "?")
            }
            is IrTypeProjection -> {
                val boundResults = useType(arg.type, TypeContext.GENERIC_ARGUMENT)
                @Suppress("UNCHECKED_CAST")
                val boundLabel = boundResults.javaResult.id as Label<out DbReftype>

                return if(arg.variance == Variance.INVARIANT)
                    @Suppress("UNCHECKED_CAST")
                    boundResults.javaResult as TypeResult<DbReftype>
                else {
                    val keyPrefix = if (arg.variance == Variance.IN_VARIANCE) "super" else "extends"
                    val wildcardKind = if (arg.variance == Variance.IN_VARIANCE) 2 else 1
                    val wildcardShortName = "? $keyPrefix ${boundResults.javaResult.shortName}"
                    TypeResult(
                        extractBoundedWildcard(wildcardKind, "@\"wildcard;$keyPrefix{$boundLabel}\"", wildcardShortName, boundLabel),
                        null,
                        wildcardShortName)
                }
            }
            else -> {
                logger.warn(Severity.ErrorSevere, "Unexpected type argument.")
                return TypeResult(fakeLabel(), "unknown", "unknown")
            }
        }
    }

    data class ClassLabelResults(
        val classLabel: String, val shortName: String
    )

    /*
    This returns the `X` in c's label `@"class;X"`.
    */
    private fun getUnquotedClassLabel(c: IrClass, typeArgs: List<IrTypeArgument>): ClassLabelResults {
        val pkg = c.packageFqName?.asString() ?: ""
        val cls = c.name.asString()
        val parent = c.parent
        val label = if (parent is IrClass) {
            // todo: fix this. Ugly string concat to handle nested class IDs.
            // todo: Can the containing class have type arguments?
            "${getUnquotedClassLabel(parent, listOf()).classLabel}\$$cls"
        } else {
            if (pkg.isEmpty()) cls else "$pkg.$cls"
        }

        val typeArgLabels = typeArgs.map { getTypeArgumentLabel(it) }
        val typeArgsShortName =
            if(typeArgs.isEmpty())
                ""
            else
                typeArgLabels.joinToString(prefix = "<", postfix = ">", separator = ",") { it.shortName }

        return ClassLabelResults(
            label + typeArgLabels.joinToString(separator = "") { ";{${it.id}}" },
            cls + typeArgsShortName
        )
    }

    fun getClassLabel(c: IrClass, typeArgs: List<IrTypeArgument>): ClassLabelResults {
        if (c.isAnonymousObject) {
            logger.warn(Severity.ErrorSevere, "Label generation should not be requested for an anonymous class")
        }

        val unquotedLabel = getUnquotedClassLabel(c, typeArgs)
        return ClassLabelResults(
            "@\"class;${unquotedLabel.classLabel}\"",
            unquotedLabel.shortName)
    }

    fun useClassSource(c: IrClass): Label<out DbClassorinterface> {
        if (c.isAnonymousObject) {
            @Suppress("UNCHECKED_CAST")
            return useAnonymousClass(c).javaResult.id as Label<DbClass>
        }

        // For source classes, the label doesn't include and type arguments
        val classTypeResult = addClassLabel(c, listOf())
        return classTypeResult.id
    }

    fun getTypeParameterLabel(param: IrTypeParameter): String {
        val parentLabel = useDeclarationParent(param.parent)
        return "@\"typevar;{$parentLabel};${param.name}\""
    }

    fun useTypeParameter(param: IrTypeParameter) =
        TypeResult(
            tw.getLabelFor<DbTypevariable>(getTypeParameterLabel(param)) {
                // Any type parameter that is in scope should have been extracted already
                // in extractClassSource or extractFunction
                logger.warn(Severity.ErrorSevere, "Missing type parameter label")
            },
            useType(eraseTypeParameter(param)).javaResult.signature,
            param.name.asString()
        )

    fun extractModifier(m: String): Label<DbModifier> {
        val modifierLabel = "@\"modifier;$m\""
        val id: Label<DbModifier> = tw.getLabelFor(modifierLabel, {
            tw.writeModifiers(it, m)
        })
        return id
    }

    fun addModifiers(modifiable: Label<out DbModifiable>, vararg modifiers: String) =
        modifiers.forEach { tw.writeHasModifier(modifiable, extractModifier(it)) }

    fun extractClassModifiers(c: IrClass, id: Label<out DbClassorinterface>) {
        when (c.modality) {
            Modality.FINAL -> addModifiers(id, "final")
            Modality.SEALED -> addModifiers(id, "sealed")
            Modality.OPEN -> { } // This is the default
            Modality.ABSTRACT -> addModifiers(id, "abstract")
            else -> logger.warn(Severity.ErrorSevere, "Unexpected class modality: ${c.modality}")
        }
        when (c.visibility) {
            DescriptorVisibilities.PRIVATE -> addModifiers(id, "private")
            DescriptorVisibilities.PROTECTED -> addModifiers(id, "protected")
            DescriptorVisibilities.PUBLIC -> addModifiers(id, "public")
            DescriptorVisibilities.INTERNAL -> addModifiers(id, "internal")
            else -> logger.warn(Severity.ErrorSevere, "Unexpected class visibility: ${c.visibility}")
        }
    }

    /**
     * Extracts the supertypes of class `c` with arguments `typeArgsQ`, or if `typeArgsQ` is null, the non-paramterised
     * version of `c`. `id` is the label of this class or class instantiation.
     *
     * For example, for type `List` if `typeArgsQ` is non-null list `[String]` then we will extract the supertypes
     * of `List<String>`, i.e. `Appendable<String>` etc, or if `typeArgsQ` is null we will extract `Appendable<E>`
     * where `E` is the type variable declared as `List<E>`.
     */
    fun extractClassSupertypes(c: IrClass, id: Label<out DbReftype>, typeArgsQ: List<IrTypeArgument>? = null) {
        extractClassSupertypes(c.superTypes, c.typeParameters, id, typeArgsQ)
    }

    fun extractClassSupertypes(superTypes: List<IrType>, typeParameters: List<IrTypeParameter>, id: Label<out DbReftype>, typeArgsQ: List<IrTypeArgument>? = null) {
        // Note we only need to substitute type args here because it is illegal to directly extend a type variable.
        // (For example, we can't have `class A<E> : E`, but can have `class A<E> : Comparable<E>`)
        val subbedSupertypes = typeArgsQ?.let { typeArgs ->
            superTypes.map {
                it.substituteTypeArguments(typeParameters, typeArgs)
            }
        } ?: superTypes

        for(t in subbedSupertypes) {
            when(t) {
                is IrSimpleType -> {
                    when (t.classifier.owner) {
                        is IrClass -> {
                            val classifier: IrClassifierSymbol = t.classifier
                            val tcls: IrClass = classifier.owner as IrClass
                            val l = useClassInstance(tcls, t.arguments).typeResult.id
                            tw.writeExtendsReftype(id, l)
                        }
                        else -> {
                            logger.warn(Severity.ErrorSevere, "Unexpected simple type supertype: " + t.javaClass + ": " + t.render())
                        }
                    }
                } else -> {
                    logger.warn(Severity.ErrorSevere, "Unexpected supertype: " + t.javaClass + ": " + t.render())
                }
            }
        }
    }

    fun useValueDeclaration(d: IrValueDeclaration): Label<out DbVariable> =
        when(d) {
            is IrValueParameter -> useValueParameter(d, null)
            is IrVariable -> useVariable(d)
            else -> {
                logger.warn(Severity.ErrorSevere, "Unrecognised IrValueDeclaration: " + d.javaClass)
                fakeLabel()
            }
        }

    fun erase (t: IrType): IrType {
        if (t is IrSimpleType) {
            val classifier = t.classifier
            val owner = classifier.owner
            if(owner is IrTypeParameter) {
                return eraseTypeParameter(owner)
            }

            // todo: fix this:
            if (t.makeNotNull().isArray()) {
                val elementType = t.getArrayElementType(pluginContext.irBuiltIns)
                val erasedElementType = erase(elementType)
                return withQuestionMark((classifier as IrClassSymbol).typeWith(erasedElementType), t.hasQuestionMark)
            }

            if (owner is IrClass) {
                return withQuestionMark((classifier as IrClassSymbol).typeWith(), t.hasQuestionMark)
            }
        }
        return t
    }

    fun eraseTypeParameter(t: IrTypeParameter) =
        erase(t.superTypes[0])

    /**
     * Gets the label for `vp` in the context of function instance `parent`, or in that of its declaring function if
     * `parent` is null.
     */
    fun getValueParameterLabel(vp: IrValueParameter, parent: Label<out DbCallable>?): String {
        val parentId = parent ?: useDeclarationParent(vp.parent)
        val idx = vp.index
        if (idx < 0) {
            // We're not extracting this and this@TYPE parameters of functions:
            logger.warn(Severity.ErrorSevere, "Unexpected negative index for parameter")
        }
        return "@\"params;{$parentId};$idx\""
    }


    fun useValueParameter(vp: IrValueParameter, parent: Label<out DbCallable>?): Label<out DbParam> =
        tw.getLabelFor(getValueParameterLabel(vp, parent))

    fun getFieldLabel(f: IrField): String {
        val parentId = useDeclarationParent(f.parent)
        return "@\"field;{$parentId};${f.name.asString()}\""
    }

    fun useField(f: IrField): Label<out DbField> =
        tw.getLabelFor(getFieldLabel(f))

    fun getPropertyLabel(p: IrProperty) =
        getPropertyLabel(p, useDeclarationParent(p.parent))

    fun getPropertyLabel(p: IrProperty, parentId: Label<out DbElement>) =
        "@\"property;{$parentId};${p.name.asString()}\""

    fun useProperty(p: IrProperty): Label<out DbKt_property> =
        tw.getLabelFor(getPropertyLabel(p))

    fun useProperty(p: IrProperty, parentId: Label<out DbElement>): Label<out DbKt_property> =
        tw.getLabelFor(getPropertyLabel(p, parentId))

    fun getEnumEntryLabel(ee: IrEnumEntry): String {
        val parentId = useDeclarationParent(ee.parent)
        return "@\"field;{$parentId};${ee.name.asString()}\""
    }

    fun useEnumEntry(ee: IrEnumEntry): Label<out DbField> =
        tw.getLabelFor(getEnumEntryLabel(ee))

    private fun getTypeAliasLabel(ta: IrTypeAlias): String {
        val parentId = useDeclarationParent(ta.parent)
        return "@\"type_alias;{$parentId};${ta.name.asString()}\""
    }

    fun useTypeAlias(ta: IrTypeAlias): Label<out DbKt_type_alias> =
        tw.getLabelFor(getTypeAliasLabel(ta))

    fun useVariable(v: IrVariable): Label<out DbLocalvar> {
        return tw.getVariableLabelFor<DbLocalvar>(v)
    }

    fun withQuestionMark(t: IrType, hasQuestionMark: Boolean) = if(hasQuestionMark) t.makeNullable() else t.makeNotNull()

}
