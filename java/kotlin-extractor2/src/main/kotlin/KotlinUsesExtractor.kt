package com.github.codeql

import com.intellij.psi.PsiElement
import org.jetbrains.kotlin.analysis.api.KaSession
import org.jetbrains.kotlin.analysis.api.symbols.*
import org.jetbrains.kotlin.analysis.api.types.KaClassType
import org.jetbrains.kotlin.analysis.api.types.KaType
import org.jetbrains.kotlin.asJava.elements.psiType
import org.jetbrains.kotlin.psi.*

/*
OLD: KE1
import com.github.codeql.utils.*
import com.github.codeql.utils.versions.*
import com.semmle.extractor.java.OdasaOutput
import org.jetbrains.kotlin.backend.common.extensions.IrPluginContext
import org.jetbrains.kotlin.backend.common.ir.*
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
import org.jetbrains.kotlin.load.java.typeEnhancement.hasEnhancedNullability
import org.jetbrains.kotlin.load.kotlin.getJvmModuleNameForDeserializedDescriptor
import org.jetbrains.kotlin.name.FqName
import org.jetbrains.kotlin.name.NameUtils
import org.jetbrains.kotlin.name.SpecialNames
import org.jetbrains.kotlin.types.Variance
import org.jetbrains.kotlin.util.OperatorNameConventions
*/

context (KaSession)
open class KotlinUsesExtractor(
    open val logger: Logger,
    open val tw: TrapWriter,
    /*
    OLD: KE1
        val dependencyCollector: OdasaOutput.TrapFileManager?,
        val externalClassExtractor: ExternalDeclExtractor,
        val primitiveTypeMapping: PrimitiveTypeMapping,
        val pluginContext: IrPluginContext,
        val globalExtensionState: KotlinExtractorGlobalState
    */
) {
    /*
    OLD: KE1
        fun referenceExternalClass(name: String) =
            getClassByFqName(pluginContext, FqName(name))?.owner.also {
                if (it == null) logger.warn("Unable to resolve external class $name")
                else extractExternalClassLater(it)
            }

        val javaLangObject by lazy { referenceExternalClass("java.lang.Object") }

        val javaLangObjectType by lazy { javaLangObject?.typeWith() }
    */

    private fun usePackage(pkg: String): Label<out DbPackage> {
        return extractPackage(pkg)
    }

    fun extractPackage(pkg: String): Label<out DbPackage> {
        val pkgLabel = "@\"package;$pkg\""
        val id: Label<DbPackage> = tw.getLabelFor(pkgLabel, { tw.writePackages(it, pkg) })
        return id
    }

    /*
    OLD: KE1
        fun useFileClassType(f: IrFile) =
            TypeResults(TypeResult(extractFileClass(f), "", ""), TypeResult(fakeKotlinType(), "", ""))

        fun useFileClassType(fqName: FqName) =
            TypeResults(
                TypeResult(extractFileClass(fqName), "", ""),
                TypeResult(fakeKotlinType(), "", "")
            )

        private fun useFileClassType(pkg: String, jvmName: String) =
            TypeResults(
                TypeResult(extractFileClass(pkg, jvmName), "", ""),
                TypeResult(fakeKotlinType(), "", "")
            )
    */

    fun extractFileClass(f: KtFile): Label<out DbClassorinterface> {
        val pkg = f.packageFqName.asString()
        val jvmName = getFileClassName(f)
        val id = extractFileClass(pkg, jvmName)
        if (tw.lm.markFileClassLocationAsExtracted(f)) {
            val fileId = tw.mkFileId(f.virtualFilePath, false)
            val locId = tw.getWholeFileLocation(fileId)
            tw.writeHasLocation(id, locId)
        }
        return id
    }

    /*
    OLD: KE1
        private fun extractFileClass(fqName: FqName): Label<out DbClassorinterface> {
            val pkg = if (fqName.isRoot()) "" else fqName.parent().asString()
            val jvmName = fqName.shortName().asString()
            return extractFileClass(pkg, jvmName)
        }
    */

    private fun extractFileClass(pkg: String, jvmName: String): Label<out DbClassorinterface> {
        val qualClassName = if (pkg.isEmpty()) jvmName else "$pkg.$jvmName"
        val label = "@\"class;$qualClassName\""
        val id: Label<DbClassorinterface> =
            tw.getLabelFor(label) {
                val pkgId = extractPackage(pkg)
                tw.writeClasses_or_interfaces(it, jvmName, pkgId, it)
                tw.writeFile_class(it)

                /*
                OLD: KE1
                                addModifiers(it, "public", "final")
                */
            }
        return id
    }

    /*
    OLD: KE1
        data class UseClassInstanceResult(
            val typeResult: TypeResult<DbClassorinterface>,
            val javaClass: IrClass
        )
    */

    /*
    OLD: KE1
        fun getJavaEquivalentClass(c: IrClass) =
            getJavaEquivalentClassId(c)?.let { getClassByClassId(pluginContext, it) }?.owner

        /**
         * Gets a KotlinFileExtractor based on this one, except it attributes locations to the file that
         * declares the given class.
         */
        private fun withFileOfClass(cls: IrClass): KotlinFileExtractor {
            val clsFile = cls.fileOrNull

            if (this is KotlinFileExtractor && this.filePath == clsFile?.path) {
                return this
            }

            val newDeclarationStack =
                if (this is KotlinFileExtractor) this.declarationStack
                else KotlinFileExtractor.DeclarationStack()

            if (clsFile == null || isExternalDeclaration(cls)) {
                val filePath = getIrClassBinaryPath(cls)
                val newTrapWriter = tw.makeFileTrapWriter(filePath, true)
                val newLoggerTrapWriter = logger.dtw.makeFileTrapWriter(filePath, false)
                val newLogger = FileLogger(logger.loggerBase, newLoggerTrapWriter)
                return KotlinFileExtractor(
                    newLogger,
                    newTrapWriter,
                    null,
                    filePath,
                    dependencyCollector,
                    externalClassExtractor,
                    primitiveTypeMapping,
                    pluginContext,
                    newDeclarationStack,
                    globalExtensionState
                )
            }

            val newTrapWriter = tw.makeSourceFileTrapWriter(clsFile, true)
            val newLoggerTrapWriter = logger.dtw.makeSourceFileTrapWriter(clsFile, false)
            val newLogger = FileLogger(logger.loggerBase, newLoggerTrapWriter)
            return KotlinFileExtractor(
                newLogger,
                newTrapWriter,
                null,
                clsFile.path,
                dependencyCollector,
                externalClassExtractor,
                primitiveTypeMapping,
                pluginContext,
                newDeclarationStack,
                globalExtensionState
            )
        }

        // The Kotlin compiler internal representation of Outer<T>.Inner<S>.InnerInner<R> is
        // InnerInner<R, S, T>. This function returns just `R`.
        fun removeOuterClassTypeArgs(
            c: IrClass,
            argsIncludingOuterClasses: List<IrTypeArgument>?
        ): List<IrTypeArgument>? {
            return argsIncludingOuterClasses?.let {
                if (it.size > c.typeParameters.size) it.take(c.typeParameters.size) else null
            } ?: argsIncludingOuterClasses
        }

        private fun isStaticClass(c: IrClass) =
            c.visibility != DescriptorVisibilities.LOCAL && !c.isInner

        // Gets nested inner classes starting at `c` and proceeding outwards to the innermost enclosing
        // static class.
        // For example, for (java syntax) `class A { static class B { class C { class D { } } } }`,
        // `nonStaticParentsWithSelf(D)` = `[D, C, B]`.
        private fun parentsWithTypeParametersInScope(c: IrClass): List<IrDeclarationParent> {
            val parentsList = c.parentsWithSelf.toList()
            val firstOuterClassIdx = parentsList.indexOfFirst { it is IrClass && isStaticClass(it) }
            return if (firstOuterClassIdx == -1) parentsList
            else parentsList.subList(0, firstOuterClassIdx + 1)
        }

        // Gets the type parameter symbols that are in scope for class `c` in Kotlin order (i.e. for
        // `class NotInScope<T> { static class OutermostInScope<A, B> { class QueryClass<C, D> { } } }`,
        // `getTypeParametersInScope(QueryClass)` = `[C, D, A, B]`.
        private fun getTypeParametersInScope(c: IrClass) =
            parentsWithTypeParametersInScope(c).mapNotNull({ getTypeParameters(it) }).flatten()

        // Returns a map from `c`'s type variables in scope to type arguments
        // `argsIncludingOuterClasses`.
        // Hack for the time being: the substituted types are always nullable, to prevent downstream
        // code
        // from replacing a generic parameter by a primitive. As and when we extract Kotlin types we
        // will
        // need to track this information in more detail.
        private fun makeTypeGenericSubstitutionMap(
            c: IrClass,
            argsIncludingOuterClasses: List<IrTypeArgument>
        ) =
            getTypeParametersInScope(c)
                .map({ it.symbol })
                .zip(argsIncludingOuterClasses.map { it.withQuestionMark(true) })
                .toMap()

        fun makeGenericSubstitutionFunction(
            c: IrClass,
            argsIncludingOuterClasses: List<IrTypeArgument>
        ) =
            makeTypeGenericSubstitutionMap(c, argsIncludingOuterClasses).let {
                { x: IrType, useContext: TypeContext, pluginContext: IrPluginContext ->
                    x.substituteTypeAndArguments(it, useContext, pluginContext)
                }
            }

        // The Kotlin compiler internal representation of Outer<A, B>.Inner<C, D>.InnerInner<E,
        // F>.someFunction<G, H>.LocalClass<I, J> is LocalClass<I, J, G, H, E, F, C, D, A, B>. This
        // function returns [A, B, C, D, E, F, G, H, I, J].
        private fun orderTypeArgsLeftToRight(
            c: IrClass,
            argsIncludingOuterClasses: List<IrTypeArgument>?
        ): List<IrTypeArgument>? {
            if (argsIncludingOuterClasses.isNullOrEmpty()) return argsIncludingOuterClasses
            val ret = ArrayList<IrTypeArgument>()
            // Iterate over nested inner classes starting at `c`'s surrounding top-level or static
            // nested class and ending at `c`, from the outermost inwards:
            val truncatedParents = parentsWithTypeParametersInScope(c)
            for (parent in truncatedParents.reversed()) {
                val parentTypeParameters = getTypeParameters(parent)
                val firstArgIdx =
                    argsIncludingOuterClasses.size - (ret.size + parentTypeParameters.size)
                ret.addAll(
                    argsIncludingOuterClasses.subList(
                        firstArgIdx,
                        firstArgIdx + parentTypeParameters.size
                    )
                )
            }
            return ret
        }

        // `typeArgs` can be null to describe a raw generic type.
        // For non-generic types it will be zero-length list.
        fun useClassInstance(
            c: IrClass,
            typeArgs: List<IrTypeArgument>?,
            inReceiverContext: Boolean = false
        ): UseClassInstanceResult {
            val substituteClass = getJavaEquivalentClass(c)

            val extractClass = substituteClass ?: c

            // `KFunction1<T1,T2>` is substituted by `KFunction<T>`. The last type argument is the
            // return type.
            // Similarly Function23 and above get replaced by kotlin.jvm.functions.FunctionN with only
            // one type arg, the result type.
            // References to SomeGeneric<T1, T2, ...> where SomeGeneric is declared SomeGeneric<T1, T2,
            // ...> are extracted
            // as if they were references to the unbound type SomeGeneric.
            val extractedTypeArgs =
                when {
                    extractClass.symbol.isKFunction() && typeArgs != null && typeArgs.isNotEmpty() ->
                        listOf(typeArgs.last())
                    extractClass.fqNameWhenAvailable == FqName("kotlin.jvm.functions.FunctionN") &&
                        typeArgs != null &&
                        typeArgs.isNotEmpty() -> listOf(typeArgs.last())
                    typeArgs != null && isUnspecialised(c, typeArgs, logger) -> listOf()
                    else -> typeArgs
                }

            val classTypeResult = addClassLabel(extractClass, extractedTypeArgs, inReceiverContext)

            // Extract both the Kotlin and equivalent Java classes, so that we have database entries
            // for both even if all internal references to the Kotlin type are substituted.
            if (c != extractClass) {
                extractClassLaterIfExternal(c)
            }

            return UseClassInstanceResult(classTypeResult, extractClass)
        }

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
                is IrExternalPackageFragment -> {
                    // The parent is a (multi)file class. We don't need
                    // extract it separately.
                }
                else ->
                    logger.error(
                        "Unrecognised extractExternalEnclosingClassLater ${parent.javaClass} for ${d.javaClass}"
                    )
            }
        }

        private fun propertySignature(p: IrProperty) =
            ((p.getter ?: p.setter)?.extensionReceiverParameter?.let {
                useType(erase(it.type)).javaResult.signature
            } ?: "")

        fun getTrapFileSignature(d: IrDeclaration) =
            when (d) {
                is IrFunction ->
                    // Note we erase the parameter types before calling useType even though the
                    // signature should be the same
                    // in order to prevent an infinite loop through useTypeParameter ->
                    // useDeclarationParent -> useFunction
                    // -> extractFunctionLaterIfExternalFileMember, which would result for `fun <T> f(t:
                    // T) { ... }` for example.
                    (listOfNotNull(d.extensionReceiverParameter) + d.valueParameters)
                        .map { useType(erase(it.type)).javaResult.signature }
                        .joinToString(separator = ",", prefix = "(", postfix = ")")
                is IrProperty -> propertySignature(d) + externalClassExtractor.propertySignature
                is IrField ->
                    (d.correspondingPropertySymbol?.let { propertySignature(it.owner) } ?: "") +
                        externalClassExtractor.fieldSignature
                else ->
                    "unknown signature"
                        .also { logger.warn("Trap file signature requested for unexpected element $d") }
            }

        private fun extractParentExternalClassLater(d: IrDeclaration) {
            val p = d.parent
            when (p) {
                is IrClass -> extractExternalClassLater(p)
                is IrExternalPackageFragment -> {
                    // The parent is a (multi)file class. We don't need to
                    // extract it separately.
                }
                else -> {
                    logger.warn("Unexpected parent type ${p.javaClass} for external file class member")
                }
            }
        }

        private fun extractPropertyLaterIfExternalFileMember(p: IrProperty) {
            if (isExternalFileClassMember(p)) {
                extractParentExternalClassLater(p)
                val signature = getTrapFileSignature(p)
                dependencyCollector?.addDependency(p, signature)
                externalClassExtractor.extractLater(p, signature)
            }
        }

        private fun extractFieldLaterIfExternalFileMember(f: IrField) {
            if (isExternalFileClassMember(f)) {
                extractParentExternalClassLater(f)
                val signature = getTrapFileSignature(f)
                dependencyCollector?.addDependency(f, signature)
                externalClassExtractor.extractLater(f, signature)
            }
        }

        private fun extractFunctionLaterIfExternalFileMember(f: IrFunction) {
            if (isExternalFileClassMember(f)) {
                extractParentExternalClassLater(f)
                (f as? IrSimpleFunction)?.correspondingPropertySymbol?.let {
                    extractPropertyLaterIfExternalFileMember(it.owner)
                    // No need to extract the function specifically, as the property's
                    // getters and setters are extracted alongside it
                    return
                }
                val signature = getTrapFileSignature(f)
                dependencyCollector?.addDependency(f, signature)
                externalClassExtractor.extractLater(f, signature)
            }
        }

        fun extractExternalClassLater(c: IrClass) {
            dependencyCollector?.addDependency(c)
            externalClassExtractor.extractLater(c)
        }

        private fun tryReplaceAndroidSyntheticClass(c: IrClass): IrClass {
            // The Android Kotlin Extensions Gradle plugin introduces synthetic functions, fields and
            // classes. The most
            // obvious signature is that they lack any supertype information even though they are not
            // root classes.
            // If possible, replace them by a real version of the same class.
            if (
                c.superTypes.isNotEmpty() ||
                    c.origin != IrDeclarationOrigin.IR_EXTERNAL_JAVA_DECLARATION_STUB ||
                    c.hasEqualFqName(FqName("java.lang.Object"))
            )
                return c
            return globalExtensionState.syntheticToRealClassMap.getOrPut(c) {
                val qualifiedName = c.fqNameWhenAvailable
                if (qualifiedName == null) {
                    logger.warn(
                        "Failed to replace synthetic class ${c.name} because it has no fully qualified name"
                    )
                    return@getOrPut null
                }

                val result = getClassByFqName(pluginContext, qualifiedName)?.owner
                if (result != null) {
                    logger.info("Replaced synthetic class ${c.name} with its real equivalent")
                    return@getOrPut result
                }

                // The above doesn't work for (some) generated nested classes, such as R$id, which
                // should be R.id
                val fqn = qualifiedName.asString()
                if (fqn.indexOf('$') >= 0) {
                    val nested = getClassByFqName(pluginContext, fqn.replace('$', '.'))?.owner
                    if (nested != null) {
                        logger.info(
                            "Replaced synthetic nested class ${c.name} with its real equivalent"
                        )
                        return@getOrPut nested
                    }
                }

                logger.warn("Failed to replace synthetic class ${c.name}")
                return@getOrPut null
            } ?: c
        }

        private fun tryReplaceFunctionInSyntheticClass(
            f: IrFunction,
            getClassReplacement: (IrClass) -> IrClass
        ): IrFunction {
            val parentClass = f.parent as? IrClass ?: return f
            val replacementClass = getClassReplacement(parentClass)
            if (replacementClass === parentClass) return f
            return globalExtensionState.syntheticToRealFunctionMap.getOrPut(f) {
                val result =
                    replacementClass.declarations.findSubType<IrSimpleFunction> { replacementDecl ->
                        replacementDecl.name == f.name &&
                            replacementDecl.valueParameters.size == f.valueParameters.size &&
                            replacementDecl.valueParameters.zip(f.valueParameters).all {
                                erase(it.first.type) == erase(it.second.type)
                            }
                    }
                if (result == null) {
                    logger.warn("Failed to replace synthetic class function ${f.name}")
                } else {
                    logger.info("Replaced synthetic class function ${f.name} with its real equivalent")
                }
                result
            } ?: f
        }

        fun tryReplaceSyntheticFunction(f: IrFunction): IrFunction {
            val androidReplacement =
                tryReplaceFunctionInSyntheticClass(f) { tryReplaceAndroidSyntheticClass(it) }
            return tryReplaceFunctionInSyntheticClass(androidReplacement) {
                tryReplaceParcelizeRawType(it)?.first ?: it
            }
        }

        fun tryReplaceAndroidSyntheticField(f: IrField): IrField {
            val parentClass = f.parent as? IrClass ?: return f
            val replacementClass = tryReplaceAndroidSyntheticClass(parentClass)
            if (replacementClass === parentClass) return f
            return globalExtensionState.syntheticToRealFieldMap.getOrPut(f) {
                val result =
                    replacementClass.declarations.findSubType<IrField> { replacementDecl ->
                        replacementDecl.name == f.name
                    }
                        ?: replacementClass.declarations
                            .findSubType<IrProperty> { it.backingField?.name == f.name }
                            ?.backingField
                if (result == null) {
                    logger.warn("Failed to replace synthetic class field ${f.name}")
                } else {
                    logger.info("Replaced synthetic class field ${f.name} with its real equivalent")
                }
                result
            } ?: f
        }

        private fun tryReplaceType(
            cBeforeReplacement: IrClass,
            argsIncludingOuterClassesBeforeReplacement: List<IrTypeArgument>?
        ): Pair<IrClass, List<IrTypeArgument>?> {
            val c = tryReplaceAndroidSyntheticClass(cBeforeReplacement)
            val p = tryReplaceParcelizeRawType(c)
            return Pair(p?.first ?: c, p?.second ?: argsIncludingOuterClassesBeforeReplacement)
        }

    */

    /*
    OLD: KE1
        private fun tryReplaceParcelizeRawType(c: IrClass): Pair<IrClass, List<IrTypeArgument>?>? {
            if (
                c.superTypes.isNotEmpty() ||
                    c.origin != IrDeclarationOrigin.DEFINED ||
                    c.hasEqualFqName(FqName("java.lang.Object"))
            ) {
                return null
            }

            val fqName = c.fqNameWhenAvailable
            if (fqName == null) {
                return null
            }

            fun tryGetPair(arity: Int): Pair<IrClass, List<IrTypeArgument>?>? {
                val replaced = getClassByFqName(pluginContext, fqName)?.owner ?: return null
                return Pair(
                    replaced,
                    List(arity) {
                        makeTypeProjection(pluginContext.irBuiltIns.anyNType, Variance.INVARIANT)
                    }
                )
            }

            // The list of types handled here match
            // https://github.com/JetBrains/kotlin/blob/d7c7d1efd2c0983c13b175e9e4b1cda979521159/plugins/parcelize/parcelize-compiler/src/org/jetbrains/kotlin/parcelize/ir/AndroidSymbols.kt
            // Specifically, types are added for generic types created in AndroidSymbols.kt.
            // This replacement is from a raw type to its matching parameterized type with `Object` type
            // arguments.
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

        private fun useAnonymousClass(c: IrClass) =
            tw.lm.anonymousTypeMapping.getOrPut(c) {
                TypeResults(
                    TypeResult(tw.getFreshIdLabel<DbClassorinterface>(), "", ""),
                    TypeResult(fakeKotlinType(), "TODO", "TODO")
                )
            }
    */

    /*
    OLD: KE1
        // Given either a primitive array or a boxed array, returns primitive arrays unchanged,
        // but returns boxed arrays with a nullable, invariant component type, with any nested arrays
        // similarly transformed. For example, Array<out Array<in E>> would become Array<Array<E?>?>
        // Array<*> will become Array<Any?>.
        private fun getInvariantNullableArrayType(arrayType: IrSimpleType): IrSimpleType =
            if (arrayType.isPrimitiveArray()) arrayType
            else {
                val componentType = arrayType.getArrayElementType(pluginContext.irBuiltIns)
                val componentTypeBroadened =
                    when (componentType) {
                        is IrSimpleType ->
                            if (isArray(componentType)) getInvariantNullableArrayType(componentType)
                            else componentType
                        else -> componentType
                    }
                val unchanged =
                    componentType == componentTypeBroadened &&
                        (arrayType.arguments[0] as? IrTypeProjection)?.variance == Variance.INVARIANT &&
                        componentType.isNullable()
                if (unchanged) arrayType
                else
                    IrSimpleTypeImpl(
                        arrayType.classifier,
                        true,
                        listOf(makeTypeProjection(componentTypeBroadened, Variance.INVARIANT)),
                        listOf()
                    )
            }

        /*
        Kotlin arrays can be broken down as:

        isArray(t)
        |- t.isBoxedArray
        |  |- t.isArray()         e.g. Array<Boolean>, Array<Boolean?>
        |  |- t.isNullableArray() e.g. Array<Boolean>?, Array<Boolean?>?
        |- t.isPrimitiveArray()   e.g. BooleanArray

        For the corresponding Java types:
        Boxed arrays are represented as e.g. java.lang.Boolean[].
        Primitive arrays are represented as e.g. boolean[].
        */

        private fun isArray(t: IrType) = t.isBoxedArray || t.isPrimitiveArray()

        data class ArrayInfo(
            val elementTypeResults: TypeResults,
            val componentTypeResults: TypeResults,
            val dimensions: Int
        )

        /**
         * `t` is somewhere in a stack of array types, or possibly the element type of the innermost
         * array. For example, in `Array<Array<Int>>`, we will be called with `t` being
         * `Array<Array<Int>>`, then `Array<Int>`, then `Int`. `isPrimitiveArray` is true if we are
         * immediately nested inside a primitive array.
         */
        private fun useArrayType(t: IrType, isPrimitiveArray: Boolean): ArrayInfo {

            if (!isArray(t)) {
                val nullableT = if (t.isPrimitiveType() && !isPrimitiveArray) t.makeNullable() else t
                val typeResults = useType(nullableT)
                return ArrayInfo(typeResults, typeResults, 0)
            }

            if (t !is IrSimpleType) {
                logger.error("Unexpected non-simple array type: ${t.javaClass}")
                return ArrayInfo(extractErrorType(), extractErrorType(), 0)
            }

            val arrayClass = t.classifier.owner
            if (arrayClass !is IrClass) {
                logger.error("Unexpected owner type for array type: ${arrayClass.javaClass}")
                return ArrayInfo(extractErrorType(), extractErrorType(), 0)
            }

            // Because Java's arrays are covariant, Kotlin will render
            // Array<in X> as Object[], Array<Array<in X>> as Object[][] etc.
            val elementType =
                if (
                    (t.arguments.singleOrNull() as? IrTypeProjection)?.variance == Variance.IN_VARIANCE
                ) {
                    pluginContext.irBuiltIns.anyType
                } else {
                    t.getArrayElementType(pluginContext.irBuiltIns)
                }

            val recInfo = useArrayType(elementType, t.isPrimitiveArray())

            val javaShortName = recInfo.componentTypeResults.javaResult.shortName + "[]"
            val kotlinShortName = recInfo.componentTypeResults.kotlinResult.shortName + "[]"
            val elementTypeLabel = recInfo.elementTypeResults.javaResult.id
            val componentTypeLabel = recInfo.componentTypeResults.javaResult.id
            val dimensions = recInfo.dimensions + 1

            val id =
                tw.getLabelFor<DbArray>("@\"array;$dimensions;{$elementTypeLabel}\"") {
                    tw.writeArrays(it, javaShortName, elementTypeLabel, dimensions, componentTypeLabel)

                    extractClassSupertypes(
                        arrayClass,
                        it,
                        ExtractSupertypesMode.Specialised(t.arguments)
                    )

                    // array.length
                    val length = tw.getLabelFor<DbField>("@\"field;{$it};length\"")
                    val intTypeIds = useType(pluginContext.irBuiltIns.intType)
                    tw.writeFields(length, "length", intTypeIds.javaResult.id, it, length)
                    tw.writeFieldsKotlinType(length, intTypeIds.kotlinResult.id)
                    addModifiers(length, "public", "final")

                    // Note we will only emit one `clone()` method per Java array type, so we choose
                    // `Array<C?>` as its Kotlin
                    // return type, where C is the component type with any nested arrays themselves
                    // invariant and nullable.
                    val kotlinCloneReturnType = getInvariantNullableArrayType(t).makeNullable()
                    val kotlinCloneReturnTypeLabel = useType(kotlinCloneReturnType).kotlinResult.id

                    val clone = tw.getLabelFor<DbMethod>("@\"callable;{$it}.clone(){$it}\"")
                    tw.writeMethods(clone, "clone", "clone()", it, it, clone)
                    tw.writeMethodsKotlinType(clone, kotlinCloneReturnTypeLabel)
                    addModifiers(clone, "public")
                }

            val javaResult =
                TypeResult(id, recInfo.componentTypeResults.javaResult.signature + "[]", javaShortName)
            val kotlinResult =
                TypeResult(
                    fakeKotlinType(),
                    recInfo.componentTypeResults.kotlinResult.signature + "[]",
                    kotlinShortName
                )
            val typeResults = TypeResults(javaResult, kotlinResult)

            return ArrayInfo(recInfo.elementTypeResults, typeResults, dimensions)
        }
    */

    context(KaSession)
    private fun parentOf(d: KaDeclarationSymbol): KaSymbol? {
        /*
        OLD: KE1
                if (d is IrField) {
                    return getFieldParent(d)
                }
        */
        val rootSymbol = when (d) {
            is KaPropertyAccessorSymbol -> d.containingSymbol
            else -> d
        }
        return rootSymbol?.containingSymbol ?: rootSymbol?.containingFile
    }

    context(KaSession)
    fun useDeclarationParentOf(
        // The declaration
        d: KaDeclarationSymbol,
        // Whether the type of entity whose parent this is can be a
        // top-level entity in the JVM's eyes. If so, then its parent may
        // be a file; otherwise, if the parent appears to be a file foo.kt,
        // then the parent is really the JVM class FooKt.
        canBeTopLevel: Boolean,
        /*
        OLD: KE1
                classTypeArguments: List<IrTypeArgument>? = null,
                inReceiverContext: Boolean = false
        */
    ): Label<out DbElement>? {

        val parent = parentOf(d) ?: TODO()
        /*
        OLD: KE1
                if (parent is IrExternalPackageFragment) {
                    // This is in a file class.
                    val fqName = getFileClassFqName(d)
                    if (fqName == null) {
                        logger.error(
                            "Can't get FqName for declaration in external package fragment ${d.javaClass}"
                        )
                        return null
                    }
                    return extractFileClass(fqName)
                }
        */
        return useDeclarationParent(parent, canBeTopLevel /* TODO , classTypeArguments, inReceiverContext */)
    }

    /*
    OLD: KE1
        // Generally, useDeclarationParentOf should be used instead of
        // calling this directly, as this cannot handle
        // IrExternalPackageFragment
    */
    private fun useDeclarationParent(
        // The declaration parent according to Kotlin
        dp: KaSymbol,
        // Whether the type of entity whose parent this is can be a
        // top-level entity in the JVM's eyes. If so, then its parent may
        // be a file; otherwise, if dp is a file foo.kt, then the parent
        // is really the JVM class FooKt.
        canBeTopLevel: Boolean,
        /*
        OLD: KE1
                classTypeArguments: List<IrTypeArgument>? = null,
                inReceiverContext: Boolean = false
        */
    ): Label<out DbElement>? =
        when (dp) {
            is KaFileSymbol ->
                dp.psi<KtFile>().let {
                    if (canBeTopLevel) {
                        usePackage(it.packageFqName.asString())
                    } else {
                        extractFileClass(it)
                    }
                }

            is KaClassSymbol ->
                useClassSource(dp)
            /*
            OLD: KE1
                        is IrClass ->
                            if (classTypeArguments != null) {
                                useClassInstance(dp, classTypeArguments, inReceiverContext).typeResult.id
                            } else {
                                val replacedType = tryReplaceParcelizeRawType(dp)
                                if (replacedType == null) {
                                    useClassSource(dp)
                                } else {
                                    useClassInstance(replacedType.first, replacedType.second, inReceiverContext)
                                        .typeResult
                                        .id
                                }
                            }
                        is IrFunction -> useFunction(dp)
                        is IrExternalPackageFragment -> {
                            logger.error("Unable to handle IrExternalPackageFragment as an IrDeclarationParent")
                            null
                        }
            */
            else -> {
                logger.error("Unexpected declaration parent type: " + dp.javaClass)
                null
            }
        }

    /*
    OLD: KE1

        private fun getTypeParameters(dp: IrDeclarationParent): List<IrTypeParameter> =
            when (dp) {
                is IrClass -> dp.typeParameters
                is IrFunction -> getFunctionTypeParameters(dp)
                else -> listOf()
            }

        private fun getEnclosingClass(it: IrDeclarationParent): IrClass? =
            when (it) {
                is IrClass -> it
                is IrFunction -> getEnclosingClass(it.parent)
                else -> null
            }

        val javaUtilCollection by lazy { referenceExternalClass("java.util.Collection") }

        val wildcardCollectionType by lazy {
            javaUtilCollection?.let { it.symbol.typeWithArguments(listOf(IrStarProjectionImpl)) }
        }

        private fun makeCovariant(t: IrTypeArgument) =
            t.typeOrNull?.let { makeTypeProjection(it, Variance.OUT_VARIANCE) } ?: t

        private fun makeArgumentsCovariant(t: IrType) =
            (t as? IrSimpleType)?.let {
                t.toBuilder()
                    .also { b -> b.arguments = b.arguments.map(this::makeCovariant) }
                    .buildSimpleType()
            } ?: t

        fun eraseCollectionsMethodParameterType(
            t: IrType,
            collectionsMethodName: String,
            paramIdx: Int
        ) =
            when (collectionsMethodName) {
                "contains",
                "remove",
                "containsKey",
                "containsValue",
                "get",
                "indexOf",
                "lastIndexOf" -> javaLangObjectType
                "getOrDefault" -> if (paramIdx == 0) javaLangObjectType else null
                "containsAll",
                "removeAll",
                "retainAll" -> wildcardCollectionType
                // Kotlin defines these like addAll(Collection<E>); Java uses addAll(Collection<?
                // extends E>)
                "putAll",
                "addAll" -> makeArgumentsCovariant(t)
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
            BuiltinMethodsWithSpecialGenericSignature
                .getOverriddenBuiltinFunctionWithErasedValueParametersInJava(f.descriptor) != null ||
                (f.name.asString() == "putAll" &&
                    overridesFunctionDefinedOn(f, "kotlin.collections", "MutableMap")) ||
                (f.name.asString() == "addAll" &&
                    overridesFunctionDefinedOn(f, "kotlin.collections", "MutableCollection")) ||
                (f.name.asString() == "addAll" &&
                    overridesFunctionDefinedOn(f, "kotlin.collections", "MutableList"))

        private val jvmWildcardAnnotation = FqName("kotlin.jvm.JvmWildcard")
        private val jvmWildcardSuppressionAnnotation = FqName("kotlin.jvm.JvmSuppressWildcards")

        private fun arrayExtendsAdditionAllowed(t: IrSimpleType): Boolean =
            // Note the array special case includes Array<*>, which does permit adding `? extends ...`
            // (making `? extends Object[]` in that case)
            // Surprisingly Array<in X> does permit this as well, though the contravariant array lowers
            // to Object[] so this ends up `? extends Object[]` as well.
            t.arguments[0].let {
                when (it) {
                    is IrTypeProjection ->
                        when (it.variance) {
                            Variance.INVARIANT -> false
                            Variance.IN_VARIANCE -> !(it.type.isAny() || it.type.isNullableAny())
                            Variance.OUT_VARIANCE -> extendsAdditionAllowed(it.type)
                        }
                    else -> true
                }
            }

        private fun extendsAdditionAllowed(t: IrType) =
            if (t.isBoxedArray) {
                if (t is IrSimpleType) {
                    arrayExtendsAdditionAllowed(t)
                } else {
                    logger.warn("Boxed array of unexpected kind ${t.javaClass}")
                    // Return false, for no particular reason
                    false
                }
            } else {
                ((t as? IrSimpleType)?.classOrNull?.owner?.isFinalClass) != true
            }

        private fun wildcardAdditionAllowed(
            v: Variance,
            t: IrType,
            addByDefault: Boolean,
            javaVariance: Variance?
        ) =
            when {
                t.hasAnnotation(jvmWildcardAnnotation) -> true
                // If a Java declaration specifies a variance, introduce it even if it's pointless (e.g.
                // ? extends FinalClass, or ? super Object)
                javaVariance == v -> true
                !addByDefault -> false
                v == Variance.IN_VARIANCE -> !(t.isNullableAny() || t.isAny())
                v == Variance.OUT_VARIANCE -> extendsAdditionAllowed(t)
                else -> false
            }

        // Returns true if `t` has `@JvmSuppressWildcards` or `@JvmSuppressWildcards(true)`,
        // false if it has `@JvmSuppressWildcards(false)`,
        // and null if the annotation is not present.
        @Suppress("UNCHECKED_CAST")
        private fun getWildcardSuppressionDirective(t: IrAnnotationContainer) =
            t.getAnnotation(jvmWildcardSuppressionAnnotation)?.let {
                (it.getValueArgument(0) as? IrConst<Boolean>)?.value ?: true
            }

        private fun addJavaLoweringArgumentWildcards(
            p: IrTypeParameter,
            t: IrTypeArgument,
            addByDefault: Boolean,
            javaType: JavaType?
        ): IrTypeArgument =
            (t as? IrTypeProjection)?.let {
                val newAddByDefault = getWildcardSuppressionDirective(it.type)?.not() ?: addByDefault
                val newBase = addJavaLoweringWildcards(it.type, newAddByDefault, javaType)
                // Note javaVariance == null means we don't have a Java type to conform to -- for
                // example if this is a Kotlin source definition.
                val javaVariance =
                    javaType?.let { jType ->
                        when (jType) {
                            is JavaWildcardType ->
                                if (jType.isExtends) Variance.OUT_VARIANCE else Variance.IN_VARIANCE
                            else -> Variance.INVARIANT
                        }
                    }
                val newVariance =
                    if (
                        it.variance == Variance.INVARIANT &&
                            p.variance != Variance.INVARIANT &&
                            // The next line forbids inferring a wildcard type when we have a
                            // corresponding Java type with conflicting variance.
                            // For example, Java might declare f(Comparable<CharSequence> cs), in which
                            // case we shouldn't add a `? super ...`
                            // wildcard. Note if javaType is unknown (e.g. this is a Kotlin source
                            // element), we assume wildcards should be added.
                            (javaVariance == null || javaVariance == p.variance) &&
                            wildcardAdditionAllowed(p.variance, it.type, newAddByDefault, javaVariance)
                    )
                        p.variance
                    else it.variance
                if (newBase !== it.type || newVariance != it.variance)
                    makeTypeProjection(newBase, newVariance)
                else null
            } ?: t

        private fun getJavaTypeArgument(jt: JavaType, idx: Int): JavaType? =
            when (jt) {
                is JavaWildcardType -> jt.bound?.let { getJavaTypeArgument(it, idx) }
                is JavaClassifierType -> jt.typeArguments.getOrNull(idx)
                is JavaArrayType -> if (idx == 0) jt.componentType else null
                else -> null
            }

        fun addJavaLoweringWildcards(t: IrType, addByDefault: Boolean, javaType: JavaType?): IrType =
            (t as? IrSimpleType)?.let {
                val newAddByDefault = getWildcardSuppressionDirective(t)?.not() ?: addByDefault
                val typeParams = it.classOrNull?.owner?.typeParameters ?: return t
                val newArgs =
                    typeParams.zip(it.arguments).mapIndexed { idx, pair ->
                        addJavaLoweringArgumentWildcards(
                            pair.first,
                            pair.second,
                            newAddByDefault,
                            javaType?.let { jt -> getJavaTypeArgument(jt, idx) }
                        )
                    }
                return if (newArgs.zip(it.arguments).all { pair -> pair.first === pair.second }) t
                else it.toBuilder().also { builder -> builder.arguments = newArgs }.buildSimpleType()
            } ?: t

        val javaLangClass by lazy { referenceExternalClass("java.lang.Class") }

        fun kClassToJavaClass(t: IrType): IrType {
            when (t) {
                is IrSimpleType -> {
                    if (t.classifier == pluginContext.irBuiltIns.kClassClass) {
                        javaLangClass?.let { jlc ->
                            return jlc.symbol.typeWithArguments(t.arguments)
                        }
                    } else {
                        t.classOrNull?.let { tCls ->
                            if (t.isBoxedArray) {
                                (t.arguments.singleOrNull() as? IrTypeProjection)?.let { elementTypeArg
                                    ->
                                    val elementType = elementTypeArg.type
                                    val replacedElementType = kClassToJavaClass(elementType)
                                    if (replacedElementType !== elementType) {
                                        val newArg =
                                            makeTypeProjection(
                                                replacedElementType,
                                                elementTypeArg.variance
                                            )
                                        return tCls
                                            .typeWithArguments(listOf(newArg))
                                            .codeQlWithHasQuestionMark(t.isNullable())
                                    }
                                }
                            }
                        }
                    }
                }
                is IrDynamicType -> {}
                is IrErrorType -> {}
            }
            return t
        }

        fun isAnnotationClassField(f: IrField) =
            f.correspondingPropertySymbol?.let { isAnnotationClassProperty(it) } ?: false

        private fun isAnnotationClassProperty(p: IrPropertySymbol) =
            p.owner.parentClassOrNull?.kind == ClassKind.ANNOTATION_CLASS

        fun getAdjustedReturnType(f: IrFunction): IrType {
            // Replace annotation val accessor types as needed:
            (f as? IrSimpleFunction)?.correspondingPropertySymbol?.let {
                if (isAnnotationClassProperty(it) && f == it.owner.getter) {
                    val replaced = kClassToJavaClass(f.returnType)
                    if (replaced != f.returnType) return replaced
                }
            }

            // The return type of `java.util.concurrent.ConcurrentHashMap<K,V>.keySet/0` is defined as
            // `Set<K>` in the stubs inside the Android SDK.
            // This does not match the Java SDK return type: `ConcurrentHashMap.KeySetView<K,V>`, so
            // it's adjusted here.
            // This is a deliberate change in the Android SDK:
            // https://github.com/AndroidSDKSources/android-sdk-sources-for-api-level-31/blob/2c56b25f619575bea12f9c5520ed2259620084ac/java/util/concurrent/ConcurrentHashMap.java#L1244-L1249
            // The annotation on the source is not visible in the android.jar, so we can't make the
            // change based on that.
            // TODO: there are other instances of `dalvik.annotation.codegen.CovariantReturnType` in the
            // Android SDK, we should handle those too if they cause DB inconsistencies
            val parentClass = f.parentClassOrNull
            if (
                parentClass == null ||
                    parentClass.fqNameWhenAvailable?.asString() !=
                        "java.util.concurrent.ConcurrentHashMap" ||
                    getFunctionShortName(f).nameInDB != "keySet" ||
                    f.valueParameters.isNotEmpty() ||
                    f.returnType.classFqName?.asString() != "kotlin.collections.MutableSet"
            ) {
                return f.returnType
            }

            val otherKeySet =
                parentClass.declarations.findSubType<IrFunction> {
                    it.name.asString() == "keySet" && it.valueParameters.size == 1
                } ?: return f.returnType

            return otherKeySet.returnType.codeQlWithHasQuestionMark(false)
        }

        @OptIn(ObsoleteDescriptorBasedAPI::class)
        fun getJavaCallable(f: IrFunction) =
            (f.descriptor.source as? JavaSourceElement)?.javaElement as? JavaMember

        fun getJavaValueParameterType(m: JavaMember, idx: Int) =
            when (m) {
                is JavaMethod -> m.valueParameters[idx].type
                is JavaConstructor -> m.valueParameters[idx].type
                else -> null
            }

        fun getInnermostWildcardSupppressionAnnotation(d: IrDeclaration) =
            getWildcardSuppressionDirective(d)
                ?:
                // Note not using `parentsWithSelf` as that only works if `d` is an IrDeclarationParent
                d.parents
                    .filterIsInstance<IrAnnotationContainer>()
                    .mapNotNull { getWildcardSuppressionDirective(it) }
                    .firstOrNull()
                ?: false

        /**
         * Class to hold labels for generated classes around local functions, lambdas, function
         * references, and property references.
         */
        open class GeneratedClassLabels(
            val type: TypeResults,
            val constructor: Label<DbConstructor>,
            val constructorBlock: Label<DbBlock>
        )

        /**
         * Class to hold labels generated for locally visible functions, such as
         * - local functions,
         * - lambdas, and
         * - wrappers around function references.
         */
        class LocallyVisibleFunctionLabels(
            type: TypeResults,
            constructor: Label<DbConstructor>,
            constructorBlock: Label<DbBlock>,
            val function: Label<DbMethod>
        ) : GeneratedClassLabels(type, constructor, constructorBlock)

        /**
         * Gets the labels for functions belonging to
         * - local functions, and
         * - lambdas.
         */
        fun getLocallyVisibleFunctionLabels(f: IrFunction): LocallyVisibleFunctionLabels {
            if (!f.isLocalFunction()) {
                logger.error("Extracting a non-local function as a local one")
            }

            var res = tw.lm.locallyVisibleFunctionLabelMapping[f]
            if (res == null) {
                val javaResult = TypeResult(tw.getFreshIdLabel<DbClassorinterface>(), "", "")
                val kotlinResult = TypeResult(tw.getFreshIdLabel<DbKt_notnull_type>(), "", "")
                tw.writeKt_notnull_types(kotlinResult.id, javaResult.id)
                res =
                    LocallyVisibleFunctionLabels(
                        TypeResults(javaResult, kotlinResult),
                        tw.getFreshIdLabel(),
                        tw.getFreshIdLabel(),
                        tw.getFreshIdLabel()
                    )
                tw.lm.locallyVisibleFunctionLabelMapping[f] = res
            }

            return res
        }

        fun getExistingLocallyVisibleFunctionLabel(f: IrFunction): Label<DbMethod>? {
            if (!f.isLocalFunction()) {
                return null
            }

            return tw.lm.locallyVisibleFunctionLabelMapping[f]?.function
        }

        private fun kotlinFunctionToJavaEquivalent(f: IrFunction, noReplace: Boolean): IrFunction =
            if (noReplace) f
            else
                f.parentClassOrNull?.let { parentClass ->
                    getJavaEquivalentClass(parentClass)?.let { javaClass ->
                        if (javaClass != parentClass) {
                            var jvmName = getFunctionShortName(f).nameInDB
                            if (
                                f.name.asString() == "get" &&
                                    parentClass.fqNameWhenAvailable?.asString() == "kotlin.String"
                            ) {
                                // `kotlin.String.get` has an equivalent `java.lang.String.get`, which
                                // in turn will be stored in the DB as `java.lang.String.charAt`.
                                // Maybe all operators should be handled the same way, but so far I only
                                // found this case that needed to be special cased. This is the
                                // only operator in `JvmNames.specialFunctions`
                                jvmName = "get"
                            }
                            // Look for an exact type match...
                            javaClass.declarations.findSubType<IrFunction> { decl ->
                                !decl.isFakeOverride &&
                                    decl.name.asString() == jvmName &&
                                    decl.valueParameters.size == f.valueParameters.size &&
                                    decl.valueParameters.zip(f.valueParameters).all { p ->
                                        erase(p.first.type).classifierOrNull ==
                                            erase(p.second.type).classifierOrNull
                                    }
                            }
                                ?:
                                // Or check property accessors:
                                (f.propertyIfAccessor as? IrProperty)?.let { kotlinProp ->
                                    val javaProp =
                                        javaClass.declarations.findSubType<IrProperty> { decl ->
                                            decl.name == kotlinProp.name
                                        }
                                    if (javaProp?.getter?.name == f.name) javaProp.getter
                                    else if (javaProp?.setter?.name == f.name) javaProp.setter else null
                                }
                                ?: run {
                                    val parentFqName = parentClass.fqNameWhenAvailable?.asString()
                                    logger.warn(
                                        "Couldn't find a Java equivalent function to $parentFqName.${f.name.asString()} in ${javaClass.fqNameWhenAvailable?.asString()}"
                                    )
                                    null
                                }
                        } else null
                    }
                } ?: f

        fun isPrivate(d: IrDeclaration) =
            when (d) {
                is IrDeclarationWithVisibility ->
                    d.visibility.let {
                        it == DescriptorVisibilities.PRIVATE ||
                            it == DescriptorVisibilities.PRIVATE_TO_THIS
                    }
                else -> false
            }

        fun <T : DbCallable> useFunction(
            f: IrFunction,
            classTypeArgsIncludingOuterClasses: List<IrTypeArgument>? = null,
            noReplace: Boolean = false
        ): Label<out T>? {
            if (f.isLocalFunction()) {
                val ids = getLocallyVisibleFunctionLabels(f)
                return ids.function.cast<T>()
            }
            val javaFun = kotlinFunctionToJavaEquivalent(f, noReplace)
            val parentId =
                useDeclarationParentOf(javaFun, false, classTypeArgsIncludingOuterClasses, true)
            if (parentId == null) {
                logger.error("Couldn't find parent ID for function ${f.name.asString()}")
                return null
            }
            return useFunction(f, javaFun, parentId, classTypeArgsIncludingOuterClasses)
        }
    */

    /*
    OLD: KE1
        private fun extractPrivateSpecialisedDeclaration(
            d: IrDeclaration,
            classTypeArgsIncludingOuterClasses: List<IrTypeArgument>?
        ) {
            // Note here `classTypeArgsIncludingOuterClasses` being null doesn't signify a raw receiver
            // type but rather that no type args were supplied.
            // This is because a call to a private method can only be observed inside Kotlin code, and
            // Kotlin can't represent raw types.
            if (
                this is KotlinFileExtractor &&
                    isPrivate(d) &&
                    classTypeArgsIncludingOuterClasses != null &&
                    classTypeArgsIncludingOuterClasses.isNotEmpty()
            ) {
                d.parent.let {
                    when (it) {
                        is IrClass ->
                            this.extractDeclarationPrototype(
                                d,
                                useClassInstance(it, classTypeArgsIncludingOuterClasses).typeResult.id,
                                classTypeArgsIncludingOuterClasses
                            )
                        else ->
                            logger.warnElement(
                                "Unable to extract specialised declaration that isn't a member of a class",
                                d
                            )
                    }
                }
            }
        }

        fun getTypeArgumentLabel(arg: IrTypeArgument): TypeResultWithoutSignature<DbReftype> {

            fun extractBoundedWildcard(
                wildcardKind: Int,
                wildcardLabelStr: String,
                wildcardShortName: String,
                boundLabel: Label<out DbReftype>
            ): Label<DbWildcard> =
                tw.getLabelFor(wildcardLabelStr) { wildcardLabel ->
                    tw.writeWildcards(wildcardLabel, wildcardShortName, wildcardKind)
                    tw.writeHasLocation(wildcardLabel, tw.unknownLocation)
                    tw.getLabelFor<DbTypebound>("@\"bound;0;{$wildcardLabel}\"") {
                        tw.writeTypeBounds(it, boundLabel, 0, wildcardLabel)
                    }
                }

            // Note this function doesn't return a signature because type arguments are never
            // incorporated into function signatures.
            return when (arg) {
                is IrStarProjection -> {
                    val anyTypeLabel =
                        useType(pluginContext.irBuiltIns.anyType).javaResult.id.cast<DbReftype>()
                    TypeResultWithoutSignature(
                        extractBoundedWildcard(1, "@\"wildcard;\"", "?", anyTypeLabel),
                        Unit,
                        "?"
                    )
                }
                is IrTypeProjection -> {
                    val boundResults = useType(arg.type, TypeContext.GENERIC_ARGUMENT)
                    val boundLabel = boundResults.javaResult.id.cast<DbReftype>()

                    if (arg.variance == Variance.INVARIANT)
                        boundResults.javaResult.cast<DbReftype>().forgetSignature()
                    else {
                        val keyPrefix = if (arg.variance == Variance.IN_VARIANCE) "super" else "extends"
                        val wildcardKind = if (arg.variance == Variance.IN_VARIANCE) 2 else 1
                        val wildcardShortName = "? $keyPrefix ${boundResults.javaResult.shortName}"
                        TypeResultWithoutSignature(
                            extractBoundedWildcard(
                                wildcardKind,
                                "@\"wildcard;$keyPrefix{$boundLabel}\"",
                                wildcardShortName,
                                boundLabel
                            ),
                            Unit,
                            wildcardShortName
                        )
                    }
                }
                else -> {
                    logger.error("Unexpected type argument.")
                    extractJavaErrorType().forgetSignature()
                }
            }
        }
    */

    data class ClassLabelResults(val classLabel: String /* TODO , val shortName: String */)


    /*
       OLD: KE1
        fun getTypeParameterParentLabel(param: IrTypeParameter) =
            param.parent.let {
                when (it) {
                    is IrClass -> useClassSource(it)
                    is IrFunction ->
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
                        else null) ?: useFunction(it, noReplace = true)
                    else -> {
                        logger.error("Unexpected type parameter parent $it")
                        null
                    }
                }
            }

        fun getTypeParameterLabel(param: IrTypeParameter): String {
            // Use this instead of `useDeclarationParent` so we can use useFunction with noReplace =
            // true,
            // ensuring that e.g. a method-scoped type variable declared on kotlin.String.transform <R>
            // gets
            // a different name to the corresponding java.lang.String.transform <R>, even though
            // useFunction
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

        */
    private fun extractModifier(m: String): Label<DbModifier> {
        val modifierLabel = "@\"modifier;$m\""
        val id: Label<DbModifier> = tw.getLabelFor(modifierLabel, { tw.writeModifiers(it, m) })
        return id
    }

    fun addModifiers(modifiable: Label<out DbModifiable>, vararg modifiers: String) =
        modifiers.forEach { tw.writeHasModifier(modifiable, extractModifier(it)) }

    /*
        sealed class ExtractSupertypesMode {
            object Unbound : ExtractSupertypesMode()

            object Raw : ExtractSupertypesMode()

            data class Specialised(val typeArgs: List<IrTypeArgument>) : ExtractSupertypesMode()
        }

        /**
         * Extracts the supertypes of class `c`, either the unbound version, raw version or a
         * specialisation to particular type arguments, depending on the value of `mode`. `id` is the
         * label of this class or class instantiation.
         *
         * For example, for type `List` if `mode` `Specialised([String])` then we will extract the
         * supertypes of `List<String>`, i.e. `Appendable<String>` etc, or if `mode` is `Unbound` we
         * will extract `Appendable<E>` where `E` is the type variable declared as `List<E>`. Finally if
         * `mode` is `Raw` we will extract the raw type `Appendable`, represented in QL as
         * `Appendable<>`.
         *
         * Argument `inReceiverContext` will be passed onto the `useClassInstance` invocation for each
         * supertype.
         */
        fun extractClassSupertypes(
            c: IrClass,
            id: Label<out DbReftype>,
            mode: ExtractSupertypesMode = ExtractSupertypesMode.Unbound,
            inReceiverContext: Boolean = false
        ) {
            extractClassSupertypes(
                c.superTypes,
                c.typeParameters,
                id,
                c.isInterfaceLike,
                mode,
                inReceiverContext
            )
        }

        fun extractClassSupertypes(
            superTypes: List<IrType>,
            typeParameters: List<IrTypeParameter>,
            id: Label<out DbReftype>,
            isInterface: Boolean,
            mode: ExtractSupertypesMode = ExtractSupertypesMode.Unbound,
            inReceiverContext: Boolean = false
        ) {
            // Note we only need to substitute type args here because it is illegal to directly extend a
            // type variable.
            // (For example, we can't have `class A<E> : E`, but can have `class A<E> : Comparable<E>`)
            val subbedSupertypes =
                when (mode) {
                    is ExtractSupertypesMode.Specialised -> {
                        superTypes.map { it.substituteTypeArguments(typeParameters, mode.typeArgs) }
                    }
                    else -> superTypes
                }

            for (t in subbedSupertypes) {
                when (t) {
                    is IrSimpleType -> {
                        when (val owner = t.classifier.owner) {
                            is IrClass -> {
                                val typeArgs =
                                    if (t.arguments.isNotEmpty() && mode is ExtractSupertypesMode.Raw)
                                        null
                                    else t.arguments
                                val l =
                                    useClassInstance(owner, typeArgs, inReceiverContext).typeResult.id
                                if (isInterface || !owner.isInterfaceLike) {
                                    tw.writeExtendsReftype(id, l)
                                } else {
                                    tw.writeImplInterface(id.cast(), l.cast())
                                }
                            }
                            else -> {
                                logger.error(
                                    "Unexpected simple type supertype: " +
                                        t.javaClass +
                                        ": " +
                                        t.render()
                                )
                            }
                        }
                    }
                    else -> {
                        logger.error("Unexpected supertype: " + t.javaClass + ": " + t.render())
                    }
                }
            }
        }

        fun useValueDeclaration(d: IrValueDeclaration): Label<out DbVariable>? =
            when (d) {
                is IrValueParameter -> useValueParameter(d, null)
                is IrVariable -> useVariable(d)
                else -> {
                    logger.error("Unrecognised IrValueDeclaration: " + d.javaClass)
                    null
                }
            }

        /**
         * Returns `t` with generic types replaced by raw types, and type parameters replaced by their
         * first bound.
         *
         * Note that `Array<T>` is retained (with `T` itself erased) because these are expected to be
         * lowered to Java arrays, which are not generic.
         */
        fun erase(t: IrType): IrType {
            if (t is IrSimpleType) {
                val classifier = t.classifier
                val owner = classifier.owner
                if (owner is IrTypeParameter) {
                    return eraseTypeParameter(owner)
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

        private fun eraseTypeParameter(t: IrTypeParameter) = erase(t.superTypes[0])

        fun getValueParameterLabel(parentId: Label<out DbElement>?, idx: Int) =
            "@\"params;{$parentId};$idx\""

        /**
         * Gets the label for `vp` in the context of function instance `parent`, or in that of its
         * declaring function if `parent` is null.
         */
        fun getValueParameterLabel(vp: IrValueParameter, parent: Label<out DbCallable>?): String {
            val declarationParent = vp.parent
            val overriddenParentAttributes =
                (declarationParent as? IrFunction)?.let {
                    (this as? KotlinFileExtractor)?.declarationStack?.findOverriddenAttributes(it)
                }
            val parentId = parent ?: overriddenParentAttributes?.id ?: useDeclarationParentOf(vp, false)

            val idxBase = overriddenParentAttributes?.valueParameters?.indexOf(vp) ?: vp.index
            val idxOffset =
                if (
                    declarationParent is IrFunction &&
                        declarationParent.extensionReceiverParameter != null
                )
                // For extension functions increase the index to match what the java extractor sees:
                1
                else 0
            val idx = idxBase + idxOffset

            if (idx < 0) {
                // We're not extracting this and this@TYPE parameters of functions:
                logger.error("Unexpected negative index for parameter")
            }

            return getValueParameterLabel(parentId, idx)
        }

        fun useValueParameter(
            vp: IrValueParameter,
            parent: Label<out DbCallable>?
        ): Label<out DbParam> = tw.getLabelFor(getValueParameterLabel(vp, parent))

        private fun isDirectlyExposableCompanionObjectField(f: IrField) =
            f.hasAnnotation(FqName("kotlin.jvm.JvmField")) ||
                f.correspondingPropertySymbol?.owner?.let { it.isConst || it.isLateinit } ?: false

        private fun getFieldParent(f: IrField) =
            f.parentClassOrNull?.let {
                if (it.isCompanion && isDirectlyExposableCompanionObjectField(f)) it.parent else null
            } ?: f.parent

        fun isDirectlyExposedCompanionObjectField(f: IrField) = getFieldParent(f) != f.parent

        // Gets a field's corresponding property's extension receiver type, if any
        fun getExtensionReceiverType(f: IrField) =
            f.correspondingPropertySymbol?.owner?.let {
                (it.getter ?: it.setter)?.extensionReceiverParameter?.type
            }

        fun getFieldLabel(f: IrField): String {
            val parentId = useDeclarationParentOf(f, false)
            // Distinguish backing fields of properties based on their extension receiver type;
            // otherwise two extension properties declared in the same enclosing context will get
            // clashing trap labels. These are always private, so we can just make up a label without
            // worrying about their names as seen from Java.
            val extensionPropertyDiscriminator =
                getExtensionReceiverType(f)?.let { "extension;${useType(it).javaResult.id}" } ?: ""
            return "@\"field;{$parentId};$extensionPropertyDiscriminator${f.name.asString()}\""
        }

        fun useField(f: IrField): Label<out DbField> =
            tw.getLabelFor<DbField>(getFieldLabel(f)).also { extractFieldLaterIfExternalFileMember(f) }

        fun getPropertyLabel(p: IrProperty): String? {
            val parentId = useDeclarationParentOf(p, false)
            if (parentId == null) {
                return null
            } else {
                return getPropertyLabel(p, parentId, null)
            }
        }

        private fun getPropertyLabel(
            p: IrProperty,
            parentId: Label<out DbElement>,
            classTypeArgsIncludingOuterClasses: List<IrTypeArgument>?
        ): String {
            val getter = p.getter
            val setter = p.setter

            val func = getter ?: setter
            val ext = func?.extensionReceiverParameter

            return if (ext == null) {
                "@\"property;{$parentId};${p.name.asString()}\""
            } else {
                val returnType =
                    getter?.returnType
                        ?: setter?.valueParameters?.singleOrNull()?.type
                        ?: pluginContext.irBuiltIns.unitType
                val typeParams = getFunctionTypeParameters(func)

                getFunctionLabel(
                    p.parent,
                    parentId,
                    p.name.asString(),
                    listOf(),
                    returnType,
                    ext.type,
                    typeParams,
                    classTypeArgsIncludingOuterClasses,
                    overridesCollectionsMethod = false,
                    javaSignature = null,
                    addParameterWildcardsByDefault = false,
                    prefix = "property"
                )
            }
        }

        fun useProperty(
            p: IrProperty,
            parentId: Label<out DbElement>,
            classTypeArgsIncludingOuterClasses: List<IrTypeArgument>?
        ) =
            tw.getLabelFor<DbKt_property>(
                getPropertyLabel(p, parentId, classTypeArgsIncludingOuterClasses)
            ) {
                extractPropertyLaterIfExternalFileMember(p)
                extractPrivateSpecialisedDeclaration(p, classTypeArgsIncludingOuterClasses)
            }

        fun getEnumEntryLabel(ee: IrEnumEntry): String {
            val parentId = useDeclarationParentOf(ee, false)
            return "@\"field;{$parentId};${ee.name.asString()}\""
        }

        fun useEnumEntry(ee: IrEnumEntry): Label<out DbField> = tw.getLabelFor(getEnumEntryLabel(ee))

        fun getTypeAliasLabel(ta: IrTypeAlias): String {
            val parentId = useDeclarationParentOf(ta, true)
            return "@\"type_alias;{$parentId};${ta.name.asString()}\""
        }

        fun useTypeAlias(ta: IrTypeAlias): Label<out DbKt_type_alias> =
            tw.getLabelFor(getTypeAliasLabel(ta))
    */
}
