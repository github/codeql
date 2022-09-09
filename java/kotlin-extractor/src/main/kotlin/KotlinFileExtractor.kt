package com.github.codeql

import com.github.codeql.comments.CommentExtractor
import com.github.codeql.utils.*
import com.github.codeql.utils.versions.functionN
import com.github.codeql.utils.versions.getIrStubFromDescriptor
import com.github.codeql.utils.versions.isUnderscoreParameter
import com.semmle.extractor.java.OdasaOutput
import org.jetbrains.kotlin.backend.common.extensions.IrPluginContext
import org.jetbrains.kotlin.backend.common.lower.parents
import org.jetbrains.kotlin.backend.common.pop
import org.jetbrains.kotlin.builtins.functions.BuiltInFunctionArity
import org.jetbrains.kotlin.descriptors.*
import org.jetbrains.kotlin.descriptors.java.JavaVisibilities
import org.jetbrains.kotlin.ir.IrElement
import org.jetbrains.kotlin.ir.IrStatement
import org.jetbrains.kotlin.ir.ObsoleteDescriptorBasedAPI
import org.jetbrains.kotlin.ir.backend.js.utils.realOverrideTarget
import org.jetbrains.kotlin.ir.declarations.*
import org.jetbrains.kotlin.ir.expressions.*
import org.jetbrains.kotlin.ir.symbols.*
import org.jetbrains.kotlin.ir.types.*
import org.jetbrains.kotlin.ir.util.*
import org.jetbrains.kotlin.load.java.sources.JavaSourceElement
import org.jetbrains.kotlin.load.java.structure.JavaClass
import org.jetbrains.kotlin.load.java.structure.JavaMethod
import org.jetbrains.kotlin.load.java.structure.JavaTypeParameter
import org.jetbrains.kotlin.load.java.structure.JavaTypeParameterListOwner
import org.jetbrains.kotlin.name.FqName
import org.jetbrains.kotlin.types.Variance
import org.jetbrains.kotlin.util.OperatorNameConventions
import java.io.Closeable
import java.util.*

open class KotlinFileExtractor(
    override val logger: FileLogger,
    override val tw: FileTrapWriter,
    val filePath: String,
    dependencyCollector: OdasaOutput.TrapFileManager?,
    externalClassExtractor: ExternalDeclExtractor,
    primitiveTypeMapping: PrimitiveTypeMapping,
    pluginContext: IrPluginContext,
    globalExtensionState: KotlinExtractorGlobalState
): KotlinUsesExtractor(logger, tw, dependencyCollector, externalClassExtractor, primitiveTypeMapping, pluginContext, globalExtensionState) {

    private inline fun <T> with(kind: String, element: IrElement, f: () -> T): T {
        val name = when (element) {
            is IrFile -> element.name
            is IrDeclarationWithName -> element.name.asString()
            else -> "<no name>"
        }
        val loc = tw.getLocationString(element)
        val context = logger.loggerBase.extractorContextStack
        context.push(ExtractorContext(kind, element, name, loc))
        try {
            val depth = context.size
            val depthDescription = "${"-".repeat(depth)} (${depth.toString()})"
            logger.trace("$depthDescription: Starting a $kind ($name) at $loc")
            val result = f()
            logger.trace("$depthDescription: Finished a $kind ($name) at $loc")
            return result
        } catch(exception: Exception) {
            throw Exception("While extracting a $kind ($name) at $loc", exception)
        } finally {
            context.pop()
        }
    }

    fun extractFileContents(file: IrFile, id: Label<DbFile>) {
        with("file", file) {
            val locId = tw.getWholeFileLocation()
            val pkg = file.fqName.asString()
            val pkgId = extractPackage(pkg)
            tw.writeHasLocation(id, locId)
            tw.writeCupackage(id, pkgId)

            val exceptionOnFile = System.getenv("CODEQL_KOTLIN_INTERNAL_EXCEPTION_WHILE_EXTRACTING_FILE")
            if(exceptionOnFile != null) {
                @OptIn(kotlin.ExperimentalStdlibApi::class) // Annotation required by kotlin versions < 1.5
                if(exceptionOnFile.lowercase() == file.name.lowercase()) {
                    throw Exception("Internal testing exception")
                }
            }

            file.declarations.forEach { extractDeclaration(it, extractPrivateMembers = true, extractFunctionBodies = true) }
            extractStaticInitializer(file, { extractFileClass(file) })
            CommentExtractor(this, file, tw.fileId).extract()
        }
    }

    @OptIn(ObsoleteDescriptorBasedAPI::class)
    private fun isFake(d: IrDeclarationWithVisibility): Boolean {
        val visibility = d.visibility
        if (visibility is DelegatedDescriptorVisibility && visibility.delegate == Visibilities.InvisibleFake) {
            return true
        }
        if (d.isFakeOverride) {
            return true
        }
        if ((d as? IrFunction)?.descriptor?.isHiddenToOvercomeSignatureClash == true) {
            return true
        }
        return false
    }

    private fun shouldExtractDecl(declaration: IrDeclaration, extractPrivateMembers: Boolean) =
        extractPrivateMembers ||
        when(declaration) {
            is IrDeclarationWithVisibility -> declaration.visibility.let { it != DescriptorVisibilities.PRIVATE && it != DescriptorVisibilities.PRIVATE_TO_THIS }
            else -> true
        }

    fun extractDeclaration(declaration: IrDeclaration, extractPrivateMembers: Boolean, extractFunctionBodies: Boolean) {
        with("declaration", declaration) {
            if (!shouldExtractDecl(declaration, extractPrivateMembers))
                return
            when (declaration) {
                is IrClass -> {
                    if (isExternalDeclaration(declaration)) {
                        extractExternalClassLater(declaration)
                    } else {
                        extractClassSource(declaration, extractDeclarations = true, extractStaticInitializer = true, extractPrivateMembers = extractPrivateMembers, extractFunctionBodies = extractFunctionBodies)
                    }
                }
                is IrFunction -> {
                    val parentId = useDeclarationParent(declaration.parent, false)?.cast<DbReftype>()
                    if (parentId != null) {
                        extractFunction(declaration, parentId, extractBody = extractFunctionBodies, extractMethodAndParameterTypeAccesses = extractFunctionBodies, null, listOf())
                    }
                    Unit
                }
                is IrAnonymousInitializer -> {
                    // Leaving this intentionally empty. init blocks are extracted during class extraction.
                }
                is IrProperty -> {
                    val parentId = useDeclarationParent(declaration.parent, false)?.cast<DbReftype>()
                    if (parentId != null) {
                        extractProperty(declaration, parentId, extractBackingField = true, extractFunctionBodies = extractFunctionBodies, extractPrivateMembers = extractPrivateMembers, null, listOf())
                    }
                    Unit
                }
                is IrEnumEntry -> {
                    val parentId = useDeclarationParent(declaration.parent, false)?.cast<DbReftype>()
                    if (parentId != null) {
                        extractEnumEntry(declaration, parentId, extractFunctionBodies)
                    }
                    Unit
                }
                is IrField -> {
                    val parentId = useDeclarationParent(getFieldParent(declaration), false)?.cast<DbReftype>()
                    if (parentId != null) {
                        extractField(declaration, parentId)
                    }
                    Unit
                }
                is IrTypeAlias -> extractTypeAlias(declaration)
                else -> logger.errorElement("Unrecognised IrDeclaration: " + declaration.javaClass, declaration)
            }
        }
    }

    private fun extractTypeParameter(tp: IrTypeParameter, apparentIndex: Int, javaTypeParameter: JavaTypeParameter?): Label<out DbTypevariable>? {
        with("type parameter", tp) {
            val parentId = getTypeParameterParentLabel(tp) ?: return null
            val id = tw.getLabelFor<DbTypevariable>(getTypeParameterLabel(tp))

            // Note apparentIndex does not necessarily equal `tp.index`, because at least constructor type parameters
            // have indices offset from the type parameters of the constructed class (i.e. the parameter S of
            // `class Generic<T> { public <S> Generic(T t, S s) { ... } }` will have `tp.index` 1, not 0).
            tw.writeTypeVars(id, tp.name.asString(), apparentIndex, 0, parentId)
            val locId = tw.getLocation(tp)
            tw.writeHasLocation(id, locId)

            // Annoyingly, we have no obvious way to pair up the bounds of an IrTypeParameter and a JavaTypeParameter
            // because JavaTypeParameter provides a Collection not an ordered list, so we can only do our best here:
            fun tryGetJavaBound(idx: Int) =
                when(tp.superTypes.size) {
                    1 -> javaTypeParameter?.upperBounds?.singleOrNull()
                    else -> (javaTypeParameter?.upperBounds as? List)?.getOrNull(idx)
                }

            tp.superTypes.forEachIndexed { boundIdx, bound ->
                if(!(bound.isAny() || bound.isNullableAny())) {
                    tw.getLabelFor<DbTypebound>("@\"bound;$boundIdx;{$id}\"") {
                        // Note we don't look for @JvmSuppressWildcards here because it doesn't seem to have any impact
                        // on kotlinc adding wildcards to type parameter bounds.
                        val boundWithWildcards = addJavaLoweringWildcards(bound, true, tryGetJavaBound(tp.index))
                        tw.writeTypeBounds(it, useType(boundWithWildcards).javaResult.id.cast<DbReftype>(), boundIdx, id)
                    }
                }
            }

            return id
        }
    }

    private fun extractVisibility(elementForLocation: IrElement, id: Label<out DbModifiable>, v: DescriptorVisibility) {
        with("visibility", elementForLocation) {
            when (v) {
                DescriptorVisibilities.PRIVATE -> addModifiers(id, "private")
                DescriptorVisibilities.PRIVATE_TO_THIS -> addModifiers(id, "private")
                DescriptorVisibilities.PROTECTED -> addModifiers(id, "protected")
                DescriptorVisibilities.PUBLIC -> addModifiers(id, "public")
                DescriptorVisibilities.INTERNAL -> addModifiers(id, "internal")
                DescriptorVisibilities.LOCAL -> if (elementForLocation is IrFunction && elementForLocation.isLocalFunction()) {
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
                            // default java visibility (member level)
                        }
                        else -> logger.errorElement("Unexpected delegated visibility: $v", elementForLocation)
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
                Modality.OPEN -> { } // This is the default
                Modality.ABSTRACT -> addModifiers(id, "abstract")
                else -> logger.errorElement("Unexpected class modality: ${c.modality}", c)
            }
            extractVisibility(c, id, c.visibility)
        }
    }

    // `argsIncludingOuterClasses` can be null to describe a raw generic type.
    // For non-generic types it will be zero-length list.
    fun extractClassInstance(c: IrClass, argsIncludingOuterClasses: List<IrTypeArgument>?): Label<out DbClassorinterface> {
        with("class instance", c) {
            if (argsIncludingOuterClasses?.isEmpty() == true) {
                logger.error("Instance without type arguments: " + c.name.asString())
            }

            val classLabelResults = getClassLabel(c, argsIncludingOuterClasses)
            val id = tw.getLabelFor<DbClassorinterface>(classLabelResults.classLabel)
            val pkg = c.packageFqName?.asString() ?: ""
            val cls = classLabelResults.shortName
            val pkgId = extractPackage(pkg)
            val kind = c.kind
            // TODO: There's lots of duplication between this and extractClassSource.
            // Can we share it?
            if(kind == ClassKind.INTERFACE || kind == ClassKind.ANNOTATION_CLASS) {
                val interfaceId = id.cast<DbInterface>()
                val sourceInterfaceId = useClassSource(c).cast<DbInterface>()
                tw.writeInterfaces(interfaceId, cls, pkgId, sourceInterfaceId)
            } else {
                val classId = id.cast<DbClass>()
                val sourceClassId = useClassSource(c).cast<DbClass>()
                tw.writeClasses(classId, cls, pkgId, sourceClassId)

                if (kind == ClassKind.ENUM_CLASS) {
                    tw.writeIsEnumType(classId)
                } else if (kind != ClassKind.CLASS && kind != ClassKind.OBJECT) {
                    logger.errorElement("Unrecognised class kind $kind", c)
                }
            }

            val typeArgs = removeOuterClassTypeArgs(c, argsIncludingOuterClasses)
            if (typeArgs != null) {
                for ((idx, arg) in typeArgs.withIndex()) {
                    val argId = getTypeArgumentLabel(arg).id
                    tw.writeTypeArgs(argId, idx, id)
                }
                tw.writeIsParameterized(id)
            } else {
                tw.writeIsRaw(id)
            }

            val unbound = useClassSource(c)
            tw.writeErasure(id, unbound)
            extractClassModifiers(c, id)
            extractClassSupertypes(c, id, if (argsIncludingOuterClasses == null) ExtractSupertypesMode.Raw else ExtractSupertypesMode.Specialised(argsIncludingOuterClasses))

            val locId = getLocation(c, argsIncludingOuterClasses)
            tw.writeHasLocation(id, locId)

            // Extract the outer <-> inner class relationship, passing on any type arguments in excess to this class' parameters if this is an inner class.
            // For example, in `class Outer<T> { inner class Inner<S> { } }`, `Inner<Int, String>` nests within `Outer<Int>` and raw `Inner<>` within `Outer<>`,
            // but for a similar non-`inner` (in Java terms, static nested) class both `Inner<Int>` and `Inner<>` nest within the unbound type `Outer`.
            val useBoundOuterType = (c.isInner || c.isLocal) && (c.parents.map { // Would use `firstNotNullOfOrNull`, but this doesn't exist in Kotlin 1.4
                when(it) {
                    is IrClass -> when {
                        it.typeParameters.isNotEmpty() -> true // Type parameters visible to this class -- extract an enclosing bound or raw type.
                        !(it.isInner || it.isLocal) -> false // No type parameters seen yet, and this is a static class -- extract an enclosing unbound type.
                        else -> null // No type parameters seen here, but may be visible enclosing type parameters; keep searching.
                    }
                    else -> null // Look through enclosing non-class entities (this may need to change)
                }
            }.firstOrNull { it != null } ?: false)

            extractEnclosingClass(c, id, locId, if (useBoundOuterType) argsIncludingOuterClasses?.drop(c.typeParameters.size) else listOf())

            return id
        }
    }

    private fun getLocation(decl: IrDeclaration, typeArgs: List<IrTypeArgument>?): Label<DbLocation> {
        return if (typeArgs != null && typeArgs.isNotEmpty()) {
            val c = getContainingClassOrSelf(decl)
            if (c == null) {
                tw.getLocation(decl)
            } else {
                val binaryPath = getIrClassBinaryPath(c)
                val newTrapWriter = tw.makeFileTrapWriter(binaryPath, true)
                newTrapWriter.getWholeFileLocation()
            }
        } else {
            tw.getLocation(decl)
        }
    }

    // `argsIncludingOuterClasses` can be null to describe a raw generic type.
    // For non-generic types it will be zero-length list.
    fun extractNonPrivateMemberPrototypes(c: IrClass, argsIncludingOuterClasses: List<IrTypeArgument>?, id: Label<out DbClassorinterface>) {
        with("member prototypes", c) {
            val typeParamSubstitution =
                when (argsIncludingOuterClasses) {
                    null -> { x: IrType, _: TypeContext, _: IrPluginContext -> x.toRawType() }
                    else -> makeGenericSubstitutionFunction(c, argsIncludingOuterClasses)
                }

            c.declarations.map {
                if (shouldExtractDecl(it, false)) {
                    when(it) {
                        is IrFunction -> extractFunction(it, id, extractBody = false, extractMethodAndParameterTypeAccesses = false, typeParamSubstitution, argsIncludingOuterClasses)
                        is IrProperty -> extractProperty(it, id, extractBackingField = false, extractFunctionBodies = false, extractPrivateMembers = false, typeParamSubstitution, argsIncludingOuterClasses)
                        else -> {}
                    }
                }
            }
        }
    }

    private fun extractLocalTypeDeclStmt(c: IrClass, callable: Label<out DbCallable>, parent: Label<out DbStmtparent>, idx: Int) {
        val id = extractClassSource(c, extractDeclarations = true, extractStaticInitializer = true, extractPrivateMembers = true, extractFunctionBodies = true).cast<DbClass>()
        extractLocalTypeDeclStmt(id, c, callable, parent, idx)
    }

    private fun extractLocalTypeDeclStmt(id: Label<out DbClass>, locElement: IrElement, callable: Label<out DbCallable>, parent: Label<out DbStmtparent>, idx: Int) {
        val stmtId = tw.getFreshIdLabel<DbLocaltypedeclstmt>()
        tw.writeStmts_localtypedeclstmt(stmtId, parent, idx, callable)
        tw.writeIsLocalClassOrInterface(id, stmtId)
        val locId = tw.getLocation(locElement)
        tw.writeHasLocation(stmtId, locId)
    }

    private fun extractObinitFunction(c: IrClass, parentId: Label<out DbClassorinterface>) {
        // add method:
        val obinitLabel = getObinitLabel(c)
        val obinitId = tw.getLabelFor<DbMethod>(obinitLabel)
        val returnType = useType(pluginContext.irBuiltIns.unitType, TypeContext.RETURN)
        tw.writeMethods(obinitId, "<obinit>", "<obinit>()", returnType.javaResult.id, parentId, obinitId)
        tw.writeMethodsKotlinType(obinitId, returnType.kotlinResult.id)

        val locId = tw.getLocation(c)
        tw.writeHasLocation(obinitId, locId)

        addModifiers(obinitId, "private")

        // add body:
        val blockId = tw.getFreshIdLabel<DbBlock>()
        tw.writeStmts_block(blockId, obinitId, 0, obinitId)
        tw.writeHasLocation(blockId, locId)

        extractDeclInitializers(c.declarations, false) { Pair(blockId, obinitId) }
    }

    val jvmStaticFqName = FqName("kotlin.jvm.JvmStatic")

    fun extractClassSource(c: IrClass, extractDeclarations: Boolean, extractStaticInitializer: Boolean, extractPrivateMembers: Boolean, extractFunctionBodies: Boolean): Label<out DbClassorinterface> {
        with("class source", c) {
            DeclarationStackAdjuster(c).use {

                val id = useClassSource(c)
                val pkg = c.packageFqName?.asString() ?: ""
                val cls = if (c.isAnonymousObject) "" else c.name.asString()
                val pkgId = extractPackage(pkg)
                val kind = c.kind
                if (kind == ClassKind.INTERFACE || kind == ClassKind.ANNOTATION_CLASS) {
                    val interfaceId = id.cast<DbInterface>()
                    tw.writeInterfaces(interfaceId, cls, pkgId, interfaceId)
                } else {
                    val classId = id.cast<DbClass>()
                    tw.writeClasses(classId, cls, pkgId, classId)

                    if (kind == ClassKind.ENUM_CLASS) {
                        tw.writeIsEnumType(classId)
                    } else if (kind != ClassKind.CLASS && kind != ClassKind.OBJECT) {
                        logger.warnElement("Unrecognised class kind $kind", c)
                    }

                    if (c.isData) {
                        tw.writeKtDataClasses(classId)
                    }
                }

                val locId = tw.getLocation(c)
                tw.writeHasLocation(id, locId)

                extractEnclosingClass(c, id, locId, listOf())

                val javaClass = (c.source as? JavaSourceElement)?.javaElement as? JavaClass

                c.typeParameters.mapIndexed { idx, param -> extractTypeParameter(param, idx, javaClass?.typeParameters?.getOrNull(idx)) }
                if (extractDeclarations) {
                    c.declarations.forEach { extractDeclaration(it, extractPrivateMembers = extractPrivateMembers, extractFunctionBodies = extractFunctionBodies) }
                    if (extractStaticInitializer)
                        extractStaticInitializer(c, { id })
                    extractJvmStaticProxyMethods(c, id, extractPrivateMembers, extractFunctionBodies)
                }
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
                    tw.writeClass_object(id.cast<DbClass>(), instance.id)
                }
                if (extractFunctionBodies && needsObinitFunction(c)) {
                    extractObinitFunction(c, id)
                }

                extractClassModifiers(c, id)
                extractClassSupertypes(c, id, inReceiverContext = true) // inReceiverContext = true is specified to force extraction of member prototypes of base types

                return id
            }
        }
    }

    private fun extractJvmStaticProxyMethods(c: IrClass, classId: Label<out DbClassorinterface>, extractPrivateMembers: Boolean, extractFunctionBodies: Boolean) {

        // Add synthetic forwarders for any JvmStatic methods or properties:
        val companionObject = c.companionObject() ?: return

        val cType = c.typeWith()
        val companionType = companionObject.typeWith()

        fun makeProxyFunction(f: IrFunction) {
            // Emit a function in class `c` that delegates to the same function defined on `c.CompanionInstance`.
            val proxyFunctionId = tw.getLabelFor<DbMethod>(getFunctionLabel(f, classId, listOf()))
            // We extract the function prototype with its ID overridden to belong to `c` not the companion object,
            // but suppress outputting the body, which we will replace with a delegating call below.
            forceExtractFunction(f, classId, extractBody = false, extractMethodAndParameterTypeAccesses = extractFunctionBodies, typeSubstitution = null, classTypeArgsIncludingOuterClasses = listOf(), idOverride = proxyFunctionId, locOverride = null, extractOrigin = false)
            addModifiers(proxyFunctionId, "static")
            tw.writeCompiler_generated(proxyFunctionId, CompilerGeneratedKinds.JVMSTATIC_PROXY_METHOD.kind)
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
                                extractVariableAccess(syntheticParamId, param.type, realFunctionLocId, argParent, idxOffset + idx, proxyFunctionId, returnId)
                            }
                        },
                        companionType,
                        { callId ->
                            val companionField = useCompanionObjectClassInstance(companionObject)?.id
                            extractVariableAccess(companionField, companionType, realFunctionLocId, callId, -1, proxyFunctionId, returnId).also { varAccessId ->
                                extractTypeAccessRecursive(cType, realFunctionLocId, varAccessId, -1, proxyFunctionId, returnId)
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
                when(it) {
                    is IrFunction -> {
                        if (wholeDeclAnnotated)
                            makeProxyFunction(it)
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

    // If `parentClassTypeArguments` is null, the parent class is a raw type.
    private fun extractEnclosingClass(innerDeclaration: IrDeclaration, innerId: Label<out DbClassorinterface>, innerLocId: Label<DbLocation>, parentClassTypeArguments: List<IrTypeArgument>?) {
        with("enclosing class", innerDeclaration) {
            var parent: IrDeclarationParent? = innerDeclaration.parent
            while (parent != null) {
                if (parent is IrClass) {
                    val parentId =
                        if (parent.isAnonymousObject) {
                            useAnonymousClass(parent).javaResult.id.cast<DbClass>()
                        } else {
                            useClassInstance(parent, parentClassTypeArguments).typeResult.id
                        }
                    tw.writeEnclInReftype(innerId, parentId)
                    if (innerDeclaration is IrClass && innerDeclaration.isCompanion) {
                        // If we are a companion then our parent has a
                        //     public static final ParentClass$CompanionObjectClass CompanionObjectName;
                        // that we need to fabricate here
                        val instance = useCompanionObjectClassInstance(innerDeclaration)
                        if (instance != null) {
                            val type = useSimpleTypeClass(innerDeclaration, emptyList(), false)
                            tw.writeFields(instance.id, instance.name, type.javaResult.id, parentId, instance.id)
                            tw.writeFieldsKotlinType(instance.id, type.kotlinResult.id)
                            tw.writeHasLocation(instance.id, innerLocId)
                            addModifiers(instance.id, "public", "static", "final")
                            tw.writeType_companion_object(parentId, instance.id, innerId.cast<DbClass>())
                        }
                    }

                    break
                } else if (parent is IrFile) {
                    if (innerDeclaration is IrClass) {
                        // We don't have to extract file class containers for classes
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
        if(!c.isCompanion) {
            logger.error("Using companion instance for non-companion class")
            return null
        }
        else if (parent !is IrClass) {
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
        if(!c.isNonCompanionObject) {
            logger.error("Using instance for non-object class")
        }
        val classId = useClassInstance(c, listOf()).typeResult.id
        val instanceName = "INSTANCE"
        val instanceLabel = "@\"field;{$classId};$instanceName\""
        val instanceId: Label<DbField> = tw.getLabelFor(instanceLabel)
        return FieldResult(instanceId, instanceName)
    }

    @OptIn(ObsoleteDescriptorBasedAPI::class)
    private fun hasSynthesizedParameterNames(f: IrFunction) = f.descriptor.hasSynthesizedParameterNames()

    private fun extractValueParameter(vp: IrValueParameter, parent: Label<out DbCallable>, idx: Int, typeSubstitution: TypeSubstitution?, parentSourceDeclaration: Label<out DbCallable>, classTypeArgsIncludingOuterClasses: List<IrTypeArgument>?, extractTypeAccess: Boolean, locOverride: Label<DbLocation>? = null): TypeResults {
        with("value parameter", vp) {
            val location = locOverride ?: getLocation(vp, classTypeArgsIncludingOuterClasses)
            val maybeErasedType = (vp.parent as? IrFunction)?.let {
                if (overridesCollectionsMethodWithAlteredParameterTypes(it))
                    eraseCollectionsMethodParameterType(vp.type, it.name.asString(), idx)
                else
                    null
            } ?: vp.type
            val javaType = (vp.parent as? IrFunction)?.let { getJavaCallable(it)?.let { jCallable -> getJavaValueParameterType(jCallable, idx) } }
            val typeWithWildcards = addJavaLoweringWildcards(maybeErasedType, !hasWildcardSuppressionAnnotation(vp), javaType)
            val substitutedType = typeSubstitution?.let { it(typeWithWildcards, TypeContext.OTHER, pluginContext) } ?: typeWithWildcards
            val id = useValueParameter(vp, parent)
            if (extractTypeAccess) {
                extractTypeAccessRecursive(substitutedType, location, id, -1)
            }
            val syntheticParameterNames = isUnderscoreParameter(vp) || ((vp.parent as? IrFunction)?.let { hasSynthesizedParameterNames(it) } ?: true)
            return extractValueParameter(id, substitutedType, vp.name.asString(), location, parent, idx, useValueParameter(vp, parentSourceDeclaration), vp.isVararg, syntheticParameterNames)
        }
    }

    private fun extractValueParameter(id: Label<out DbParam>, t: IrType, name: String, locId: Label<DbLocation>, parent: Label<out DbCallable>, idx: Int, paramSourceDeclaration: Label<out DbParam>, isVararg: Boolean, syntheticParameterNames: Boolean): TypeResults {
        val type = useType(t)
        tw.writeParams(id, type.javaResult.id, idx, parent, paramSourceDeclaration)
        tw.writeParamsKotlinType(id, type.kotlinResult.id)
        tw.writeHasLocation(id, locId)
        if (!syntheticParameterNames) {
            tw.writeParamName(id, name)
        }
        if (isVararg) {
            tw.writeIsVarargsParam(id)
        }
        return type
    }

    /**
     * mkContainerLabel is a lambda so that we get laziness: If the
     * container is a file, then we don't want to extract the file class
     * unless something actually needs it.
     */
    private fun extractStaticInitializer(container: IrDeclarationContainer, mkContainerLabel: () -> Label<out DbClassorinterface>) {
        with("static initializer extraction", container) {
            extractDeclInitializers(container.declarations, true) {
                val containerId = mkContainerLabel()
                val clinitLabel = getFunctionLabel(
                    container,
                    containerId,
                    "<clinit>",
                    listOf(),
                    pluginContext.irBuiltIns.unitType,
                    extensionReceiverParameter = null,
                    functionTypeParameters = listOf(),
                    classTypeArgsIncludingOuterClasses = listOf(),
                    overridesCollectionsMethod = false,
                    javaSignature = null,
                    addParameterWildcardsByDefault = false
                )
                val clinitId = tw.getLabelFor<DbMethod>(clinitLabel)
                val returnType = useType(pluginContext.irBuiltIns.unitType, TypeContext.RETURN)
                tw.writeMethods(clinitId, "<clinit>", "<clinit>()", returnType.javaResult.id, containerId, clinitId)
                tw.writeMethodsKotlinType(clinitId, returnType.kotlinResult.id)

                tw.writeCompiler_generated(clinitId, CompilerGeneratedKinds.CLASS_INITIALISATION_METHOD.kind)

                val locId = tw.getWholeFileLocation()
                tw.writeHasLocation(clinitId, locId)

                // add and return body block:
                Pair(tw.getFreshIdLabel<DbBlock>().also({
                    tw.writeStmts_block(it, clinitId, 0, clinitId)
                    tw.writeHasLocation(it, locId)
                }), clinitId)
            }
        }
    }

    private fun extractInstanceInitializerBlock(parent: StmtParent, enclosingConstructor: IrConstructor) {
        with("object initializer block", enclosingConstructor) {
            val constructorId = useFunction<DbConstructor>(enclosingConstructor)
            val enclosingClass = enclosingConstructor.parentClassOrNull
            if (enclosingClass == null) {
                logger.errorElement("Constructor's parent is not a class", enclosingConstructor)
                return
            }

            // Don't make this block lazily since we need to insert something at the given parent.idx position,
            // and in the case where there are no initializers to emit an empty block is an acceptable filler.
            val initBlockId = tw.getFreshIdLabel<DbBlock>().also {
                tw.writeStmts_block(it, parent.parent, parent.idx, constructorId)
                val locId = tw.getLocation(enclosingConstructor)
                tw.writeHasLocation(it, locId)
            }
            extractDeclInitializers(enclosingClass.declarations, false) { Pair(initBlockId, constructorId) }
        }
    }

    private fun extractDeclInitializers(declarations: List<IrDeclaration>, extractStaticInitializers: Boolean, makeEnclosingBlock: () -> Pair<Label<DbBlock>, Label<out DbCallable>>) {
        val blockAndFunctionId by lazy {
            makeEnclosingBlock()
        }

        // Extract field initializers and init blocks (the latter can only occur in object initializers)
        var idx = 0

        fun extractFieldInitializer(f: IrDeclaration) {
            val static: Boolean
            val initializer: IrExpressionBody?
            val lhsType: TypeResults?
            val vId: Label<out DbVariable>?
            if (f is IrField) {
                static = f.isStatic
                initializer = f.initializer
                lhsType = useType(f.type)
                vId = useField(f)
            } else if (f is IrEnumEntry) {
                static = true
                initializer = f.initializerExpression
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
            val stmtId = tw.getFreshIdLabel<DbExprstmt>()
            tw.writeStmts_exprstmt(stmtId, blockAndFunctionId.first, idx++, blockAndFunctionId.second)
            tw.writeHasLocation(stmtId, declLocId)
            val assignmentId = tw.getFreshIdLabel<DbAssignexpr>()
            val type = useType(expr.type)
            tw.writeExprs_assignexpr(assignmentId, type.javaResult.id, stmtId, 0)
            tw.writeExprsKotlinType(assignmentId, type.kotlinResult.id)
            tw.writeHasLocation(assignmentId, declLocId)
            tw.writeCallableEnclosingExpr(assignmentId, blockAndFunctionId.second)
            tw.writeStatementEnclosingExpr(assignmentId, stmtId)
            tw.writeKtInitializerAssignment(assignmentId)

            val lhsId = tw.getFreshIdLabel<DbVaraccess>()
            tw.writeExprs_varaccess(lhsId, lhsType.javaResult.id, assignmentId, 0)
            tw.writeExprsKotlinType(lhsId, lhsType.kotlinResult.id)
            tw.writeHasLocation(lhsId, declLocId)
            tw.writeCallableEnclosingExpr(lhsId, blockAndFunctionId.second)
            tw.writeStatementEnclosingExpr(lhsId, stmtId)

            tw.writeVariableBinding(lhsId, vId)

            if (static) {
                extractStaticTypeAccessQualifier(f, lhsId, declLocId, blockAndFunctionId.second, stmtId)
            }

            extractExpressionExpr(expr, blockAndFunctionId.second, assignmentId, 1, stmtId)
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
                        extractStatement(stmt, blockAndFunctionId.second, blockAndFunctionId.first, idx++)
                    }
                }
                else -> continue
            }
        }
    }

    private fun extractFunction(f: IrFunction, parentId: Label<out DbReftype>, extractBody: Boolean, extractMethodAndParameterTypeAccesses: Boolean, typeSubstitution: TypeSubstitution?, classTypeArgsIncludingOuterClasses: List<IrTypeArgument>?) =
        if (isFake(f))
            null
        else
            forceExtractFunction(f, parentId, extractBody, extractMethodAndParameterTypeAccesses, typeSubstitution, classTypeArgsIncludingOuterClasses, null, null)

    private fun forceExtractFunction(f: IrFunction, parentId: Label<out DbReftype>, extractBody: Boolean, extractMethodAndParameterTypeAccesses: Boolean, typeSubstitution: TypeSubstitution?, classTypeArgsIncludingOuterClasses: List<IrTypeArgument>?, idOverride: Label<DbMethod>?, locOverride: Label<DbLocation>?, extractOrigin: Boolean = true): Label<out DbCallable>  {
        with("function", f) {
            DeclarationStackAdjuster(f).use {

                val javaCallable = getJavaCallable(f)
                getFunctionTypeParameters(f).mapIndexed { idx, tp -> extractTypeParameter(tp, idx, (javaCallable as? JavaTypeParameterListOwner)?.typeParameters?.getOrNull(idx)) }

                val id =
                    idOverride
                        ?: // If this is a class that would ordinarily be replaced by a Java equivalent (e.g. kotlin.Map -> java.util.Map),
                           // don't replace here, really extract the Kotlin version:
                           useFunction<DbCallable>(f, parentId, classTypeArgsIncludingOuterClasses, noReplace = true)

                val sourceDeclaration =
                    if (typeSubstitution != null && idOverride == null)
                        useFunction(f)
                    else
                        id

                val extReceiver = f.extensionReceiverParameter
                val idxOffset = if (extReceiver != null) 1 else 0
                val paramTypes = f.valueParameters.mapIndexed { i, vp ->
                    extractValueParameter(vp, id, i + idxOffset, typeSubstitution, sourceDeclaration, classTypeArgsIncludingOuterClasses, extractTypeAccess = extractMethodAndParameterTypeAccesses, locOverride)
                }
                val allParamTypes = if (extReceiver != null) {
                    val extendedType = useType(extReceiver.type)
                    tw.writeKtExtensionFunctions(id.cast<DbMethod>(), extendedType.javaResult.id, extendedType.kotlinResult.id)

                    val t = extractValueParameter(extReceiver, id, 0, null, sourceDeclaration, classTypeArgsIncludingOuterClasses, extractTypeAccess = extractMethodAndParameterTypeAccesses, locOverride)
                    listOf(t) + paramTypes
                } else {
                    paramTypes
                }

                val paramsSignature = allParamTypes.joinToString(separator = ",", prefix = "(", postfix = ")") { it.javaResult.signature }

                val adjustedReturnType = addJavaLoweringWildcards(getAdjustedReturnType(f), false, (javaCallable as? JavaMethod)?.returnType)
                val substReturnType = typeSubstitution?.let { it(adjustedReturnType, TypeContext.RETURN, pluginContext) } ?: adjustedReturnType

                val locId = locOverride ?: getLocation(f, classTypeArgsIncludingOuterClasses)

                if (f.symbol is IrConstructorSymbol) {
                    val unitType = useType(pluginContext.irBuiltIns.unitType, TypeContext.RETURN)
                    val shortName = when {
                        adjustedReturnType.isAnonymous -> ""
                        typeSubstitution != null -> useType(substReturnType).javaResult.shortName
                        else -> adjustedReturnType.classFqName?.shortName()?.asString() ?: f.name.asString()
                    }
                    val constrId = id.cast<DbConstructor>()
                    tw.writeConstrs(constrId, shortName, "$shortName$paramsSignature", unitType.javaResult.id, parentId, sourceDeclaration.cast<DbConstructor>())
                    tw.writeConstrsKotlinType(constrId, unitType.kotlinResult.id)
                } else {
                    val returnType = useType(substReturnType, TypeContext.RETURN)
                    val shortName = getFunctionShortName(f)
                    val methodId = id.cast<DbMethod>()
                    tw.writeMethods(methodId, shortName.nameInDB, "${shortName.nameInDB}$paramsSignature", returnType.javaResult.id, parentId, sourceDeclaration.cast<DbMethod>())
                    tw.writeMethodsKotlinType(methodId, returnType.kotlinResult.id)
                    if (extractOrigin) {
                        when (f.origin) {
                            IrDeclarationOrigin.GENERATED_DATA_CLASS_MEMBER ->
                                tw.writeCompiler_generated(methodId, CompilerGeneratedKinds.GENERATED_DATA_CLASS_MEMBER.kind)
                            IrDeclarationOrigin.DEFAULT_PROPERTY_ACCESSOR ->
                                tw.writeCompiler_generated(methodId, CompilerGeneratedKinds.DEFAULT_PROPERTY_ACCESSOR.kind)
                            IrDeclarationOrigin.ENUM_CLASS_SPECIAL_MEMBER ->
                                tw.writeCompiler_generated(methodId, CompilerGeneratedKinds.ENUM_CLASS_SPECIAL_MEMBER.kind)
                        }
                    }

                    if (extractMethodAndParameterTypeAccesses) {
                        extractTypeAccessRecursive(substReturnType, locId, id, -1)
                    }

                    if (shortName.nameInDB != shortName.kotlinName) {
                        tw.writeKtFunctionOriginalNames(methodId, shortName.kotlinName)
                    }

                    if (f.hasInterfaceParent() && f.body != null) {
                        addModifiers(id, "default") // The actual output class file may or may not have this modifier, depending on the -Xjvm-default setting.
                    }
                }

                tw.writeHasLocation(id, locId)
                val body = f.body
                if (body != null && extractBody) {
                    if (typeSubstitution != null)
                        logger.errorElement("Type substitution should only be used to extract a function prototype, not the body", f)
                    extractBody(body, id)
                }

                extractVisibility(f, id, f.visibility)

                if (f.isInline) {
                    addModifiers(id, "inline")
                }
                if (f.shouldExtractAsStatic) {
                    addModifiers(id, "static")
                }
                if (f is IrSimpleFunction && f.overriddenSymbols.isNotEmpty()) {
                    addModifiers(id, "override")
                }

                return id
            }
        }
    }

    private fun isStaticFunction(f: IrFunction): Boolean {
        return f.dispatchReceiverParameter == null      // Has no dispatch receiver,
                && !f.isLocalFunction()                 // not a local function. Local functions are extracted as instance methods with the local class instantiation as the qualifier
                && f.symbol !is IrConstructorSymbol     // not a constructor
    }

    private fun extractField(f: IrField, parentId: Label<out DbReftype>): Label<out DbField> {
        with("field", f) {
           DeclarationStackAdjuster(f).use {
               declarationStack.push(f)
               val fNameSuffix = getExtensionReceiverType(f)?.let { it.classFqName?.asString()?.replace(".", "$$") } ?: ""
               return extractField(useField(f), "${f.name.asString()}$fNameSuffix", f.type, parentId, tw.getLocation(f), f.visibility, f, isExternalDeclaration(f), f.isFinal)
           }
        }
    }


    private fun extractField(id: Label<out DbField>, name: String, type: IrType, parentId: Label<out DbReftype>, locId: Label<DbLocation>, visibility: DescriptorVisibility, errorElement: IrElement, isExternalDeclaration: Boolean, isFinal: Boolean): Label<out DbField> {
        val t = useType(type)
        tw.writeFields(id, name, t.javaResult.id, parentId, id)
        tw.writeFieldsKotlinType(id, t.kotlinResult.id)
        tw.writeHasLocation(id, locId)

        extractVisibility(errorElement, id, visibility)
        if (isFinal) {
            addModifiers(id, "final")
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

    private fun extractProperty(p: IrProperty, parentId: Label<out DbReftype>, extractBackingField: Boolean, extractFunctionBodies: Boolean, extractPrivateMembers: Boolean, typeSubstitution: TypeSubstitution?, classTypeArgsIncludingOuterClasses: List<IrTypeArgument>?) {
        with("property", p) {
            if (isFake(p)) return

            DeclarationStackAdjuster(p).use {

                val id = useProperty(p, parentId, classTypeArgsIncludingOuterClasses)
                val locId = getLocation(p, classTypeArgsIncludingOuterClasses)
                tw.writeKtProperties(id, p.name.asString())
                tw.writeHasLocation(id, locId)

                val bf = p.backingField
                val getter = p.getter
                val setter = p.setter

                if (getter == null) {
                    if (p.modality != Modality.FINAL || !isExternalDeclaration(p)) {
                        logger.warnElement("IrProperty without a getter", p)
                    }
                } else if (shouldExtractDecl(getter, extractPrivateMembers)) {
                    val getterId = extractFunction(getter, parentId, extractBody = extractFunctionBodies, extractMethodAndParameterTypeAccesses = extractFunctionBodies, typeSubstitution, classTypeArgsIncludingOuterClasses)?.cast<DbMethod>()
                    if (getterId != null) {
                        tw.writeKtPropertyGetters(id, getterId)
                        if (getter.origin == IrDeclarationOrigin.DELEGATED_PROPERTY_ACCESSOR) {
                            tw.writeCompiler_generated(getterId, CompilerGeneratedKinds.DELEGATED_PROPERTY_GETTER.kind)
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
                    val setterId = extractFunction(setter, parentId, extractBody = extractFunctionBodies, extractMethodAndParameterTypeAccesses = extractFunctionBodies, typeSubstitution, classTypeArgsIncludingOuterClasses)?.cast<DbMethod>()
                    if (setterId != null) {
                        tw.writeKtPropertySetters(id, setterId)
                        if (setter.origin == IrDeclarationOrigin.DELEGATED_PROPERTY_ACCESSOR) {
                            tw.writeCompiler_generated(setterId, CompilerGeneratedKinds.DELEGATED_PROPERTY_SETTER.kind)
                        }
                    }
                }

                if (bf != null && extractBackingField) {
                    val fieldParentId = useDeclarationParent(getFieldParent(bf), false)
                    if (fieldParentId != null) {
                        val fieldId = extractField(bf, fieldParentId.cast())
                        tw.writeKtPropertyBackingFields(id, fieldId)
                        if (p.isDelegated) {
                            tw.writeKtPropertyDelegates(id, fieldId)
                        }
                    }
                }

                extractVisibility(p, id, p.visibility)
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

    private fun extractEnumEntry(ee: IrEnumEntry, parentId: Label<out DbReftype>, extractTypeAccess: Boolean) {
        with("enum entry", ee) {
            DeclarationStackAdjuster(ee).use {
                val id = useEnumEntry(ee)
                val type = getEnumEntryType(ee) ?: return
                tw.writeFields(id, ee.name.asString(), type.javaResult.id, parentId, id)
                tw.writeFieldsKotlinType(id, type.kotlinResult.id)
                val locId = tw.getLocation(ee)
                tw.writeHasLocation(id, locId)

                if (extractTypeAccess) {
                    val fieldDeclarationId = tw.getFreshIdLabel<DbFielddecl>()
                    tw.writeFielddecls(fieldDeclarationId, parentId)
                    tw.writeFieldDeclaredIn(id, fieldDeclarationId, 0)
                    tw.writeHasLocation(fieldDeclarationId, locId)

                    extractTypeAccess(type, locId, fieldDeclarationId, 0)
                }
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
        }
    }

    private fun extractBody(b: IrBody, callable: Label<out DbCallable>) {
        with("body", b) {
            when (b) {
                is IrBlockBody -> extractBlockBody(b, callable)
                is IrSyntheticBody -> extractSyntheticBody(b, callable)
                is IrExpressionBody -> extractExpressionBody(b, callable)
                else -> {
                    logger.errorElement("Unrecognised IrBody: " + b.javaClass, b)
                }
            }
        }
    }

    private fun extractBlockBody(b: IrBlockBody, callable: Label<out DbCallable>) {
        with("block body", b) {
            val id = tw.getFreshIdLabel<DbBlock>()
            val locId = tw.getLocation(b)
            tw.writeStmts_block(id, callable, 0, callable)
            tw.writeHasLocation(id, locId)
            for ((sIdx, stmt) in b.statements.withIndex()) {
                extractStatement(stmt, callable, id, sIdx)
            }
        }
    }

    private fun extractSyntheticBody(b: IrSyntheticBody, callable: Label<out DbCallable>) {
        with("synthetic body", b) {
            when (b.kind) {
                IrSyntheticBodyKind.ENUM_VALUES -> tw.writeKtSyntheticBody(callable, 1)
                IrSyntheticBodyKind.ENUM_VALUEOF -> tw.writeKtSyntheticBody(callable, 2)
            }
        }
    }

    private fun extractExpressionBody(b: IrExpressionBody, callable: Label<out DbCallable>) {
        with("expression body", b) {
            val locId = tw.getLocation(b)
            extractExpressionBody(callable, locId).also { returnId ->
                extractExpressionExpr(b.expression, callable, returnId, 0, returnId)
            }
        }
    }

    fun extractExpressionBody(callable: Label<out DbCallable>, locId: Label<out DbLocation>): Label<out DbStmt> {
        val blockId = tw.getFreshIdLabel<DbBlock>()
        tw.writeStmts_block(blockId, callable, 0, callable)
        tw.writeHasLocation(blockId, locId)

        return tw.getFreshIdLabel<DbReturnstmt>().also { returnId ->
            tw.writeStmts_returnstmt(returnId, blockId, 0, callable)
            tw.writeHasLocation(returnId, locId)
        }
    }

    private fun getVariableLocationProvider(v: IrVariable): IrElement {
        val init = v.initializer
        if (v.startOffset < 0 && init != null) {
            // IR_TEMPORARY_VARIABLEs have no proper location
            return init
        }

        return v
    }

    private fun extractVariable(v: IrVariable, callable: Label<out DbCallable>, parent: Label<out DbStmtparent>, idx: Int) {
        with("variable", v) {
            val stmtId = tw.getFreshIdLabel<DbLocalvariabledeclstmt>()
            val locId = tw.getLocation(getVariableLocationProvider(v))
            tw.writeStmts_localvariabledeclstmt(stmtId, parent, idx, callable)
            tw.writeHasLocation(stmtId, locId)
            extractVariableExpr(v, callable, stmtId, 1, stmtId)
        }
    }

    private fun extractVariableExpr(v: IrVariable, callable: Label<out DbCallable>, parent: Label<out DbExprparent>, idx: Int, enclosingStmt: Label<out DbStmt>) {
        with("variable expr", v) {
            val varId = useVariable(v)
            val exprId = tw.getFreshIdLabel<DbLocalvariabledeclexpr>()
            val locId = tw.getLocation(getVariableLocationProvider(v))
            val type = useType(v.type)
            tw.writeLocalvars(varId, v.name.asString(), type.javaResult.id, exprId)
            tw.writeLocalvarsKotlinType(varId, type.kotlinResult.id)
            tw.writeHasLocation(varId, locId)
            tw.writeExprs_localvariabledeclexpr(exprId, type.javaResult.id, parent, idx)
            tw.writeExprsKotlinType(exprId, type.kotlinResult.id)
            tw.writeHasLocation(exprId, locId)
            tw.writeCallableEnclosingExpr(exprId, callable)
            tw.writeStatementEnclosingExpr(exprId, enclosingStmt)
            val i = v.initializer
            if (i != null) {
                extractExpressionExpr(i, callable, exprId, 0, enclosingStmt)
            }
            if (!v.isVar) {
                addModifiers(varId, "final")
            }
        }
    }

    private fun extractStatement(s: IrStatement, callable: Label<out DbCallable>, parent: Label<out DbStmtparent>, idx: Int) {
        with("statement", s) {
            when(s) {
                is IrExpression -> {
                    extractExpressionStmt(s, callable, parent, idx)
                }
                is IrVariable -> {
                    extractVariable(s, callable, parent, idx)
                }
                is IrClass -> {
                    extractLocalTypeDeclStmt(s, callable, parent, idx)
                }
                is IrFunction -> {
                    if (s.isLocalFunction()) {
                        val classId = extractGeneratedClass(s, listOf(pluginContext.irBuiltIns.anyType))
                        extractLocalTypeDeclStmt(classId, s, callable, parent, idx)
                        val ids = getLocallyVisibleFunctionLabels(s)
                        tw.writeKtLocalFunction(ids.function)

                        if (s.origin == IrDeclarationOrigin.ADAPTER_FOR_CALLABLE_REFERENCE) {
                            tw.writeCompiler_generated(classId, CompilerGeneratedKinds.DECLARING_CLASSES_OF_ADAPTER_FUNCTIONS.kind)
                        }
                    } else {
                        logger.errorElement("Expected to find local function", s)
                    }
                }
                is IrLocalDelegatedProperty -> {
                    val blockId = tw.getFreshIdLabel<DbBlock>()
                    val locId = tw.getLocation(s)
                    tw.writeStmts_block(blockId, parent, idx, callable)
                    tw.writeHasLocation(blockId, locId)
                    extractVariable(s.delegate, callable, blockId, 0)

                    val propId = tw.getFreshIdLabel<DbKt_property>()
                    tw.writeKtProperties(propId, s.name.asString())
                    tw.writeHasLocation(propId, locId)
                    tw.writeKtPropertyDelegates(propId, useVariable(s.delegate))

                    // Getter:
                    extractStatement(s.getter, callable, blockId, 1)
                    val getterLabel = getLocallyVisibleFunctionLabels(s.getter).function
                    tw.writeKtPropertyGetters(propId, getterLabel)

                    val setter = s.setter
                    if (setter != null) {
                        extractStatement(setter, callable, blockId, 2)
                        val setterLabel = getLocallyVisibleFunctionLabels(setter).function
                        tw.writeKtPropertySetters(propId, setterLabel)
                    }
                }
                else -> {
                    logger.errorElement("Unrecognised IrStatement: " + s.javaClass, s)
                }
            }
        }
    }

    /**
    Returns true iff `c` is a call to the function `fName` in the
    `kotlin.internal.ir` package. This is used to find calls to builtin
    functions, which need to be handled specially as they do not have
    corresponding source definitions.
    */
    private fun isBuiltinCallInternal(c: IrCall, fName: String) = isBuiltinCall(c, fName, "kotlin.internal.ir")
    /**
    Returns true iff `c` is a call to the function `fName` in the
    `kotlin` package. This is used to find calls to builtin
    functions, which need to be handled specially as they do not have
    corresponding source definitions.
    */
    private fun isBuiltinCallKotlin(c: IrCall, fName: String) = isBuiltinCall(c, fName, "kotlin")

    /**
    Returns true iff `c` is a call to the function `fName` in package
    `pName`. This is used to find calls to builtin functions, which need
    to be handled specially as they do not have corresponding source
    definitions.
    */
    private fun isBuiltinCall(c: IrCall, fName: String, pName: String): Boolean {
        val verbose = false
        fun verboseln(s: String) { if(verbose) println(s) }
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
        if (targetPkg.fqName.asString() != pName) {
            verboseln("No match as package name is ${targetPkg.fqName.asString()}")
            return false
        }
        verboseln("Match")
        return true
    }

    private fun unaryOp(id: Label<out DbExpr>, c: IrCall, callable: Label<out DbCallable>, enclosingStmt: Label<out DbStmt>) {
        val locId = tw.getLocation(c)
        tw.writeHasLocation(id, locId)
        tw.writeCallableEnclosingExpr(id, callable)
        tw.writeStatementEnclosingExpr(id, enclosingStmt)

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

    private fun binOp(id: Label<out DbExpr>, c: IrCall, callable: Label<out DbCallable>, enclosingStmt: Label<out DbStmt>) {
        val locId = tw.getLocation(c)
        tw.writeHasLocation(id, locId)
        tw.writeCallableEnclosingExpr(id, callable)
        tw.writeStatementEnclosingExpr(id, enclosingStmt)

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

    private fun extractArgument(id: Label<out DbExpr>, c: IrCall, callable: Label<out DbCallable>, enclosingStmt: Label<out DbStmt>, idx: Int, msg: String) {
        val op = c.getValueArgument(idx)
        if (op == null) {
            logger.errorElement(msg, c)
        } else {
            extractExpressionExpr(op, callable, id, idx, enclosingStmt)
        }
    }

    private fun getDeclaringTypeArguments(callTarget: IrFunction, receiverType: IrSimpleType): List<IrTypeArgument> {
        val declaringType = callTarget.parentAsClass
        val receiverClass = receiverType.classifier.owner as? IrClass ?: return listOf()
        val ancestorTypes = ArrayList<IrSimpleType>()

        // Populate ancestorTypes with the path from receiverType's class to its ancestor, callTarget's declaring type.
        fun walkFrom(c: IrClass): Boolean {
            if(declaringType == c)
                return true
            else {
                c.superTypes.forEach {
                    val ancestorClass = (it as? IrSimpleType)?.classifier?.owner as? IrClass ?: return false
                    ancestorTypes.add(it)
                    if (walkFrom(ancestorClass))
                        return true
                    else
                        ancestorTypes.pop()
                }
                return false
            }
        }

        // If a path was found, repeatedly substitute types to get the corresponding specialisation of that ancestor.
        if (!walkFrom(receiverClass)) {
            logger.errorElement("Failed to find a class declaring ${callTarget.name} starting at ${receiverClass.name}", callTarget)
            return listOf()
        } else {
            var subbedType: IrSimpleType = receiverType
            ancestorTypes.forEach {
                val thisClass = subbedType.classifier.owner
                if (thisClass !is IrClass) {
                    logger.errorElement("Found ancestor with unexpected type ${thisClass.javaClass}", callTarget)
                    return listOf()
                }
                val itSubbed = it.substituteTypeArguments(thisClass.typeParameters, subbedType.arguments)
                if (itSubbed !is IrSimpleType) {
                    logger.errorElement("Substituted type has unexpected type ${itSubbed.javaClass}", callTarget)
                    return listOf()
                }
                subbedType = itSubbed
            }
            return subbedType.arguments
        }
    }

    private fun extractNewExprForLocalFunction(
        ids: LocallyVisibleFunctionLabels,
        parent: Label<out DbExprparent>,
        locId: Label<DbLocation>,
        enclosingCallable: Label<out DbCallable>,
        enclosingStmt: Label<out DbStmt>) {

        val idNewexpr = extractNewExpr(ids.constructor, ids.type, locId, parent, -1, enclosingCallable, enclosingStmt)
        extractTypeAccessRecursive(pluginContext.irBuiltIns.anyType, locId, idNewexpr, -3, enclosingCallable, enclosingStmt)
    }

    fun extractRawMethodAccess(
        syntacticCallTarget: IrFunction,
        callsite: IrCall,
        enclosingCallable: Label<out DbCallable>,
        callsiteParent: Label<out DbExprparent>,
        childIdx: Int,
        enclosingStmt: Label<out DbStmt>,
        valueArguments: List<IrExpression?>,
        dispatchReceiver: IrExpression?,
        extensionReceiver: IrExpression?,
        typeArguments: List<IrType> = listOf(),
        extractClassTypeArguments: Boolean = false,
        superQualifierSymbol: IrClassSymbol? = null) {

        val locId = tw.getLocation(callsite)

        extractRawMethodAccess(
            syntacticCallTarget,
            locId,
            callsite.type,
            enclosingCallable,
            callsiteParent,
            childIdx,
            enclosingStmt,
            valueArguments.size,
            { argParent, idxOffset -> extractCallValueArguments(argParent, valueArguments, enclosingStmt, enclosingCallable, idxOffset) },
            dispatchReceiver?.type,
            dispatchReceiver?.let { { callId -> extractExpressionExpr(dispatchReceiver, enclosingCallable, callId, -1, enclosingStmt) } },
            extensionReceiver?.let { { argParent -> extractExpressionExpr(extensionReceiver, enclosingCallable, argParent, 0, enclosingStmt) } },
            typeArguments,
            extractClassTypeArguments,
            superQualifierSymbol
        )

    }


    fun extractRawMethodAccess(
        syntacticCallTarget: IrFunction,
        locId: Label<DbLocation>,
        returnType: IrType,
        enclosingCallable: Label<out DbCallable>,
        callsiteParent: Label<out DbExprparent>,
        childIdx: Int,
        enclosingStmt: Label<out DbStmt>,
        nValueArguments: Int,
        extractValueArguments: (Label<out DbExpr>, Int) -> Unit,
        drType: IrType?,
        extractDispatchReceiver: ((Label<out DbExpr>) -> Unit)?,
        extractExtensionReceiver: ((Label<out DbExpr>) -> Unit)?,
        typeArguments: List<IrType> = listOf(),
        extractClassTypeArguments: Boolean = false,
        superQualifierSymbol: IrClassSymbol? = null) {

        val callTarget = syntacticCallTarget.target.realOverrideTarget
        val id = tw.getFreshIdLabel<DbMethodaccess>()
        val type = useType(returnType)

        tw.writeExprs_methodaccess(id, type.javaResult.id, callsiteParent, childIdx)
        tw.writeExprsKotlinType(id, type.kotlinResult.id)
        tw.writeHasLocation(id, locId)
        tw.writeCallableEnclosingExpr(id, enclosingCallable)
        tw.writeStatementEnclosingExpr(id, enclosingStmt)

        // type arguments at index -2, -3, ...
        extractTypeArguments(typeArguments, locId, id, enclosingCallable, enclosingStmt, -2, true)

        val (isFunctionInvoke, isBigArityFunctionInvoke) =
                if (drType is IrSimpleType &&
                    drType.isFunctionOrKFunction() &&
                    callTarget.name.asString() == OperatorNameConventions.INVOKE.asString()) {
                    Pair(true, drType.arguments.size > BuiltInFunctionArity.BIG_ARITY)
                } else {
                    Pair(false, false)
                }

        if (callTarget.isLocalFunction()) {
            val ids = getLocallyVisibleFunctionLabels(callTarget)

            val methodId = ids.function
            tw.writeCallableBinding(id, methodId)

            extractNewExprForLocalFunction(ids, id, locId, enclosingCallable, enclosingStmt)
        } else {
            val methodId =
                if (extractClassTypeArguments && drType is IrSimpleType && !isUnspecialised(drType)) {

                    val extractionMethod = if (isFunctionInvoke) {
                        // For `kotlin.FunctionX` and `kotlin.reflect.KFunctionX` interfaces, we're making sure that we
                        // extract the call to the `invoke` method that does exist, `kotlin.jvm.functions.FunctionX::invoke`.
                        val functionalInterface = getFunctionalInterfaceTypeWithTypeArgs(drType.arguments)
                        if (functionalInterface == null) {
                            logger.warn("Cannot find functional interface type for raw method access")
                            null
                        } else {
                            val functionalInterfaceClass = functionalInterface.classOrNull
                            if (functionalInterfaceClass == null) {
                                logger.warn("Cannot find functional interface class for raw method access")
                                null
                            } else {
                                val interfaceType = functionalInterfaceClass.owner
                                val substituted = getJavaEquivalentClass(interfaceType) ?: interfaceType
                                val function = findFunction(substituted, OperatorNameConventions.INVOKE.asString())
                                if (function == null) {
                                    logger.warn("Cannot find invoke function for raw method access")
                                    null
                                } else {
                                    function
                                }
                            }
                        }
                    } else {
                        callTarget
                    }

                    if (extractionMethod == null) {
                        null
                    } else if (isBigArityFunctionInvoke) {
                        // Big arity `invoke` methods have a special implementation on JVM, they are transformed to a call to
                        // `kotlin.jvm.functions.FunctionN<out R>::invoke(vararg args: Any?)`, so we only need to pass the type
                        // argument for the return type. Additionally, the arguments are extracted inside an array literal below.
                        useFunction<DbCallable>(extractionMethod, listOf(drType.arguments.last()))
                    } else {
                        useFunction<DbCallable>(extractionMethod, getDeclaringTypeArguments(callTarget, drType))
                    }
                }
                else {
                    useFunction<DbCallable>(callTarget)
                }

            if (methodId == null) {
                logger.warn("No method to bind call to for raw method access")
            } else {
                tw.writeCallableBinding(id, methodId)
            }

            if (callTarget.shouldExtractAsStatic) {
                extractStaticTypeAccessQualifier(callTarget, id, locId, enclosingCallable, enclosingStmt)
            } else if (superQualifierSymbol != null) {
                extractSuperAccess(superQualifierSymbol.typeWith(), enclosingCallable, id, -1, enclosingStmt, locId)
            } else if (extractDispatchReceiver != null) {
                extractDispatchReceiver(id)
            }
        }

        val idxOffset = if (extractExtensionReceiver != null) 1 else 0

        val argParent = if (isBigArityFunctionInvoke) {
            extractArrayCreationWithInitializer(id, nValueArguments + idxOffset, locId, enclosingCallable, enclosingStmt)
        } else {
            id
        }

        if (extractExtensionReceiver != null) {
            extractExtensionReceiver(argParent)
        }

        extractValueArguments(argParent, idxOffset)
    }

    private fun extractStaticTypeAccessQualifier(target: IrDeclaration, parentExpr: Label<out DbExprparent>, locId: Label<DbLocation>, enclosingCallable: Label<out DbCallable>, enclosingStmt: Label<out DbStmt>) {
        if (target.shouldExtractAsStatic) {
            val parent = target.parent
            if (parent is IrClass) {
                extractTypeAccessRecursive(parent.toRawType(), locId, parentExpr, -1, enclosingCallable, enclosingStmt)
            } else if (parent is IrFile) {
                extractTypeAccess(useFileClassType(parent), locId, parentExpr, -1, enclosingCallable, enclosingStmt)
            } else {
                logger.warnElement("Unexpected static type access qualifer ${parent.javaClass}", target)
            }
        }
    }

    private fun isStaticAnnotatedNonCompanionMember(f: IrSimpleFunction) =
        f.parentClassOrNull?.isNonCompanionObject == true &&
                (f.hasAnnotation(jvmStaticFqName) || f.correspondingPropertySymbol?.owner?.hasAnnotation(jvmStaticFqName) == true)

    private val IrDeclaration.shouldExtractAsStatic: Boolean
        get() = this is IrSimpleFunction && (isStaticFunction(this) || isStaticAnnotatedNonCompanionMember(this)) ||
                this is IrField && this.isStatic ||
                this is IrEnumEntry


    private fun extractCallValueArguments(callId: Label<out DbExprparent>, call: IrFunctionAccessExpression, enclosingStmt: Label<out DbStmt>, enclosingCallable: Label<out DbCallable>, idxOffset: Int) =
        extractCallValueArguments(callId, (0 until call.valueArgumentsCount).map { call.getValueArgument(it) }, enclosingStmt, enclosingCallable, idxOffset)

    private fun extractCallValueArguments(callId: Label<out DbExprparent>, valueArguments: List<IrExpression?>, enclosingStmt: Label<out DbStmt>, enclosingCallable: Label<out DbCallable>, idxOffset: Int) {
        var i = 0
        valueArguments.forEach { arg ->
            if(arg != null) {
                if (arg is IrVararg) {
                    arg.elements.forEachIndexed { varargNo, vararg -> extractVarargElement(vararg, enclosingCallable, callId, i + idxOffset + varargNo, enclosingStmt) }
                    i += arg.elements.size
                } else {
                    extractExpressionExpr(arg, enclosingCallable, callId, (i++) + idxOffset, enclosingStmt)
                }
            }
        }
    }

    private fun findFunction(cls: IrClass, name: String): IrFunction? = cls.declarations.findSubType<IrFunction> { it.name.asString() == name }

    val jvmIntrinsicsClass by lazy {
        val result = pluginContext.referenceClass(FqName("kotlin.jvm.internal.Intrinsics"))?.owner
        result?.let { extractExternalClassLater(it) }
        result
    }

    private fun findJdkIntrinsicOrWarn(name: String, warnAgainstElement: IrElement): IrFunction? {
        val result = jvmIntrinsicsClass?.let { findFunction(it, name) }
        if(result == null) {
            logger.errorElement("Couldn't find JVM intrinsic function $name", warnAgainstElement)
        }
        return result
    }

    private fun findTopLevelFunctionOrWarn(functionFilter: String, type: String, parameterTypes: Array<String>, warnAgainstElement: IrElement): IrFunction? {

        val fn = pluginContext.referenceFunctions(FqName(functionFilter))
            .firstOrNull { fnSymbol ->
                fnSymbol.owner.parentClassOrNull?.fqNameWhenAvailable?.asString() == type &&
                fnSymbol.owner.valueParameters.map { it.type.classFqName?.asString() }.toTypedArray() contentEquals parameterTypes
            }?.owner

        if (fn != null) {
            if (fn.parentClassOrNull != null) {
                extractExternalClassLater(fn.parentAsClass)
            }
        } else {
            logger.errorElement("Couldn't find JVM intrinsic function $functionFilter in $type", warnAgainstElement)
        }

        return fn
    }

    private fun findTopLevelPropertyOrWarn(propertyFilter: String, type: String, warnAgainstElement: IrElement): IrProperty? {

        val prop = pluginContext.referenceProperties(FqName(propertyFilter))
            .firstOrNull { it.owner.parentClassOrNull?.fqNameWhenAvailable?.asString() == type }
            ?.owner

        if (prop != null) {
            if (prop.parentClassOrNull != null) {
                extractExternalClassLater(prop.parentAsClass)
            }
        } else {
            logger.errorElement("Couldn't find JVM intrinsic property $propertyFilter in $type", warnAgainstElement)
        }

        return prop
    }

    val javaLangString by lazy {
        val result = pluginContext.referenceClass(FqName("java.lang.String"))?.owner
        result?.let { extractExternalClassLater(it) }
        result
    }

    val stringValueOfObjectMethod by lazy {
        val result = javaLangString?.declarations?.findSubType<IrFunction> {
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
        val result = javaLangObject?.declarations?.findSubType<IrFunction> {
            it.name.asString() == "clone"
        }
        if (result == null) {
            logger.error("Couldn't find declaration java.lang.Object.clone(...)")
        }
        result
    }

    val kotlinNoWhenBranchMatchedExn by lazy {
        val result = pluginContext.referenceClass(FqName("kotlin.NoWhenBranchMatchedException"))?.owner
        result?.let { extractExternalClassLater(it) }
        result
    }

    val kotlinNoWhenBranchMatchedConstructor by lazy {
        val result = kotlinNoWhenBranchMatchedExn?.declarations?.findSubType<IrConstructor> {
            it.valueParameters.isEmpty()
        }
        if (result == null) {
            logger.error("Couldn't find no-arg constructor for kotlin.NoWhenBranchMatchedException")
        }
        result
    }

    val javaUtilArrays by lazy {
        val result = pluginContext.referenceClass(FqName("java.util.Arrays"))?.owner
        result?.let { extractExternalClassLater(it) }
        result
    }

    private fun isFunction(target: IrFunction, pkgName: String, classNameLogged: String, classNamePredicate: (String) -> Boolean, fName: String, hasQuestionMark: Boolean? = false): Boolean {
        val verbose = false
        fun verboseln(s: String) { if(verbose) println(s) }
        verboseln("Attempting match for $pkgName $classNameLogged $fName")
        if (target.name.asString() != fName) {
            verboseln("No match as function name is ${target.name.asString()} not $fName")
            return false
        }
        val extensionReceiverParameter = target.extensionReceiverParameter
        val targetClass = if (extensionReceiverParameter == null) {
            if (hasQuestionMark == true) {
                verboseln("Nullablility of type didn't match (target is not an extension method)")
                return false
            }
            target.parent
        } else {
            val st = extensionReceiverParameter.type as? IrSimpleType
            if (hasQuestionMark != null && st?.hasQuestionMark != hasQuestionMark) {
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
            verboseln("No match as class name is ${targetClass.name.asString()} not $classNameLogged")
            return false
        }
        val targetPkg = targetClass.parent
        if (targetPkg !is IrPackageFragment) {
            verboseln("No match as didn't find target package")
            return false
        }
        if (targetPkg.fqName.asString() != pkgName) {
            verboseln("No match as package name is ${targetPkg.fqName.asString()} not $pkgName")
            return false
        }
        verboseln("Match")
        return true
    }

    private fun isFunction(target: IrFunction, pkgName: String, className: String, fName: String, hasQuestionMark: Boolean? = false) =
        isFunction(target, pkgName, className, { it == className }, fName, hasQuestionMark)

    private fun isNumericFunction(target: IrFunction, fName: String): Boolean {
        return isFunction(target, "kotlin", "Int", fName) ||
                isFunction(target, "kotlin", "Byte", fName) ||
                isFunction(target, "kotlin", "Short", fName) ||
                isFunction(target, "kotlin", "Long", fName) ||
                isFunction(target, "kotlin", "Float", fName) ||
                isFunction(target, "kotlin", "Double", fName)
    }

    private fun isArrayType(typeName: String) =
        when(typeName) {
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
        when(typeName) {
            "Array" -> true
            else -> false
        }

    private fun extractCall(c: IrCall, callable: Label<out DbCallable>, stmtExprParent: StmtExprParent) {
        with("call", c) {
            val target = tryReplaceSyntheticFunction(c.symbol.owner)

            // The vast majority of types of call want an expr context, so make one available lazily:
            val exprParent by lazy {
                stmtExprParent.expr(c, callable)
            }

            val parent by lazy {
                exprParent.parent
            }

            val idx by lazy {
                exprParent.idx
            }

            val enclosingStmt by lazy {
                exprParent.enclosingStmt
            }

            fun extractMethodAccess(syntacticCallTarget: IrFunction, extractMethodTypeArguments: Boolean = true, extractClassTypeArguments: Boolean = false) {
                val typeArgs =
                    if (extractMethodTypeArguments)
                        (0 until c.typeArgumentsCount).map { c.getTypeArgument(it) }.requireNoNullsOrNull()
                    else
                        listOf()

                if (typeArgs == null) {
                    logger.warn("Missing type argument in extractMethodAccess")
                    return
                }

                extractRawMethodAccess(syntacticCallTarget, c, callable, parent, idx, enclosingStmt, (0 until c.valueArgumentsCount).map { c.getValueArgument(it) }, c.dispatchReceiver, c.extensionReceiver, typeArgs, extractClassTypeArguments, c.superQualifierSymbol)
            }

            fun extractSpecialEnumFunction(fnName: String){
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
                    val func = enumType.declarations.findSubType<IrFunction> { it.name.asString() == fnName }
                    if (func == null) {
                        logger.errorElement("Couldn't find function $fnName on enum type", c)
                        return
                    }

                    extractMethodAccess(func, false)
                } else if (enumType is IrTypeParameter && enumType.isReified) {
                    // A call to `enumValues<T>()` is being extracted, where `T` is a reified type parameter of an `inline` function.
                    // We can't generate a valid expression here, because we would need to know the type of T on the call site.
                    // TODO: replace error expression with something that better shows this expression is unrepresentable.
                    val id = tw.getFreshIdLabel<DbErrorexpr>()
                    val type = useType(c.type)

                    tw.writeExprs_errorexpr(id, type.javaResult.id, parent, idx)
                    tw.writeExprsKotlinType(id, type.kotlinResult.id)
                    tw.writeHasLocation(id, tw.getLocation(c))
                    tw.writeCallableEnclosingExpr(id, callable)
                    tw.writeStatementEnclosingExpr(id, enclosingStmt)
                } else {
                    logger.errorElement("Unexpected enum type rep ${enumType.javaClass}", c)
                }
            }

            fun binopReceiver(id: Label<out DbExpr>, receiver: IrExpression?, receiverDescription: String) {
                val locId = tw.getLocation(c)
                tw.writeHasLocation(id, locId)
                tw.writeCallableEnclosingExpr(id, callable)
                tw.writeStatementEnclosingExpr(id, enclosingStmt)

                if(receiver == null) {
                    logger.errorElement("$receiverDescription not found", c)
                } else {
                    extractExpressionExpr(receiver, callable, id, 0, enclosingStmt)
                }
                if(c.valueArgumentsCount < 1) {
                    logger.errorElement("No RHS found", c)
                } else {
                    if(c.valueArgumentsCount > 1) {
                        logger.errorElement("Extra arguments found", c)
                    }
                    val arg = c.getValueArgument(0)
                    if(arg == null) {
                        logger.errorElement("RHS null", c)
                    } else {
                        extractExpressionExpr(arg, callable, id, 1, enclosingStmt)
                    }
                }
            }

            /**
             * Populate the lhs of a binary op from this call's dispatch receiver, and the rhs from its sole argument.
             */
            fun binopDisp(id: Label<out DbExpr>) {
                binopReceiver(id, c.dispatchReceiver, "Dispatch receiver")
            }

            /**
             * Populate the lhs of a binary op from this call's extension receiver, and the rhs from its sole argument.
             */
            fun binopExtensionMethod(id: Label<out DbExpr>) {
                binopReceiver(id, c.extensionReceiver, "Extension receiver")
            }

            val dr = c.dispatchReceiver
            when {
                c.origin == IrStatementOrigin.PLUS &&
                (isNumericFunction(target, "plus")
                        || isFunction(target, "kotlin", "String", "plus", null)) -> {
                    val id = tw.getFreshIdLabel<DbAddexpr>()
                    val type = useType(c.type)
                    tw.writeExprs_addexpr(id, type.javaResult.id, parent, idx)
                    tw.writeExprsKotlinType(id, type.kotlinResult.id)
                    if (c.extensionReceiver != null)
                        binopExtensionMethod(id)
                    else
                        binopDisp(id)
                }
                isFunction(target, "kotlin", "String", "plus", true) -> {
                    findJdkIntrinsicOrWarn("stringPlus", c)?.let { stringPlusFn ->
                        extractRawMethodAccess(stringPlusFn, c, callable, parent, idx, enclosingStmt, listOf(c.extensionReceiver, c.getValueArgument(0)), null, null)
                    }
                }
                c.origin == IrStatementOrigin.MINUS && isNumericFunction(target, "minus") -> {
                    val id = tw.getFreshIdLabel<DbSubexpr>()
                    val type = useType(c.type)
                    tw.writeExprs_subexpr(id, type.javaResult.id, parent, idx)
                    tw.writeExprsKotlinType(id, type.kotlinResult.id)
                    binopDisp(id)
                }
                c.origin == IrStatementOrigin.MUL && isNumericFunction(target, "times") -> {
                    val id = tw.getFreshIdLabel<DbMulexpr>()
                    val type = useType(c.type)
                    tw.writeExprs_mulexpr(id, type.javaResult.id, parent, idx)
                    tw.writeExprsKotlinType(id, type.kotlinResult.id)
                    binopDisp(id)
                }
                c.origin == IrStatementOrigin.DIV && isNumericFunction(target, "div") -> {
                    val id = tw.getFreshIdLabel<DbDivexpr>()
                    val type = useType(c.type)
                    tw.writeExprs_divexpr(id, type.javaResult.id, parent, idx)
                    tw.writeExprsKotlinType(id, type.kotlinResult.id)
                    binopDisp(id)
                }
                c.origin == IrStatementOrigin.PERC && isNumericFunction(target, "rem") -> {
                    val id = tw.getFreshIdLabel<DbRemexpr>()
                    val type = useType(c.type)
                    tw.writeExprs_remexpr(id, type.javaResult.id, parent, idx)
                    tw.writeExprsKotlinType(id, type.kotlinResult.id)
                    binopDisp(id)
                }
                // != gets desugared into not and ==. Here we resugar it.
                c.origin == IrStatementOrigin.EXCLEQ && isFunction(target, "kotlin", "Boolean", "not") && c.valueArgumentsCount == 0 && dr != null && dr is IrCall && isBuiltinCallInternal(dr, "EQEQ") -> {
                    val id = tw.getFreshIdLabel<DbValueneexpr>()
                    val type = useType(c.type)
                    tw.writeExprs_valueneexpr(id, type.javaResult.id, parent, idx)
                    tw.writeExprsKotlinType(id, type.kotlinResult.id)
                    binOp(id, dr, callable, enclosingStmt)
                }
                c.origin == IrStatementOrigin.EXCLEQEQ && isFunction(target, "kotlin", "Boolean", "not") && c.valueArgumentsCount == 0 && dr != null && dr is IrCall && isBuiltinCallInternal(dr, "EQEQEQ") -> {
                    val id = tw.getFreshIdLabel<DbNeexpr>()
                    val type = useType(c.type)
                    tw.writeExprs_neexpr(id, type.javaResult.id, parent, idx)
                    tw.writeExprsKotlinType(id, type.kotlinResult.id)
                    binOp(id, dr, callable, enclosingStmt)
                }
                c.origin == IrStatementOrigin.EXCLEQ && isFunction(target, "kotlin", "Boolean", "not") && c.valueArgumentsCount == 0 && dr != null && dr is IrCall && isBuiltinCallInternal(dr, "ieee754equals") -> {
                    val id = tw.getFreshIdLabel<DbNeexpr>()
                    val type = useType(c.type)
                    tw.writeExprs_neexpr(id, type.javaResult.id, parent, idx)
                    tw.writeExprsKotlinType(id, type.kotlinResult.id)
                    binOp(id, dr, callable, enclosingStmt)
                }
                // We need to handle all the builtin operators defines in BuiltInOperatorNames in
                //     compiler/ir/ir.tree/src/org/jetbrains/kotlin/ir/IrBuiltIns.kt
                // as they can't be extracted as external dependencies.
                isBuiltinCallInternal(c, "less") -> {
                    if(c.origin != IrStatementOrigin.LT) {
                        logger.warnElement("Unexpected origin for LT: ${c.origin}", c)
                    }
                    val id = tw.getFreshIdLabel<DbLtexpr>()
                    val type = useType(c.type)
                    tw.writeExprs_ltexpr(id, type.javaResult.id, parent, idx)
                    tw.writeExprsKotlinType(id, type.kotlinResult.id)
                    binOp(id, c, callable, enclosingStmt)
                }
                isBuiltinCallInternal(c, "lessOrEqual") -> {
                    if(c.origin != IrStatementOrigin.LTEQ) {
                        logger.warnElement("Unexpected origin for LTEQ: ${c.origin}", c)
                    }
                    val id = tw.getFreshIdLabel<DbLeexpr>()
                    val type = useType(c.type)
                    tw.writeExprs_leexpr(id, type.javaResult.id, parent, idx)
                    tw.writeExprsKotlinType(id, type.kotlinResult.id)
                    binOp(id, c, callable, enclosingStmt)
                }
                isBuiltinCallInternal(c, "greater") -> {
                    if(c.origin != IrStatementOrigin.GT) {
                        logger.warnElement("Unexpected origin for GT: ${c.origin}", c)
                    }
                    val id = tw.getFreshIdLabel<DbGtexpr>()
                    val type = useType(c.type)
                    tw.writeExprs_gtexpr(id, type.javaResult.id, parent, idx)
                    tw.writeExprsKotlinType(id, type.kotlinResult.id)
                    binOp(id, c, callable, enclosingStmt)
                }
                isBuiltinCallInternal(c, "greaterOrEqual") -> {
                    if(c.origin != IrStatementOrigin.GTEQ) {
                        logger.warnElement("Unexpected origin for GTEQ: ${c.origin}", c)
                    }
                    val id = tw.getFreshIdLabel<DbGeexpr>()
                    val type = useType(c.type)
                    tw.writeExprs_geexpr(id, type.javaResult.id, parent, idx)
                    tw.writeExprsKotlinType(id, type.kotlinResult.id)
                    binOp(id, c, callable, enclosingStmt)
                }
                isBuiltinCallInternal(c, "EQEQ") -> {
                    if(c.origin != IrStatementOrigin.EQEQ) {
                        logger.warnElement("Unexpected origin for EQEQ: ${c.origin}", c)
                    }
                    val id = tw.getFreshIdLabel<DbValueeqexpr>()
                    val type = useType(c.type)
                    tw.writeExprs_valueeqexpr(id, type.javaResult.id, parent, idx)
                    tw.writeExprsKotlinType(id, type.kotlinResult.id)
                    binOp(id, c, callable, enclosingStmt)
                }
                isBuiltinCallInternal(c, "EQEQEQ") -> {
                    if(c.origin != IrStatementOrigin.EQEQEQ) {
                        logger.warnElement("Unexpected origin for EQEQEQ: ${c.origin}", c)
                    }
                    val id = tw.getFreshIdLabel<DbEqexpr>()
                    val type = useType(c.type)
                    tw.writeExprs_eqexpr(id, type.javaResult.id, parent, idx)
                    tw.writeExprsKotlinType(id, type.kotlinResult.id)
                    binOp(id, c, callable, enclosingStmt)
                }
                isBuiltinCallInternal(c, "ieee754equals") -> {
                    if(c.origin != IrStatementOrigin.EQEQ) {
                        logger.warnElement("Unexpected origin for ieee754equals: ${c.origin}", c)
                    }
                    val id = tw.getFreshIdLabel<DbEqexpr>()
                    val type = useType(c.type)
                    tw.writeExprs_eqexpr(id, type.javaResult.id, parent, idx)
                    tw.writeExprsKotlinType(id, type.kotlinResult.id)
                    binOp(id, c, callable, enclosingStmt)
                }
                isBuiltinCallInternal(c, "CHECK_NOT_NULL") -> {
                    if(c.origin != IrStatementOrigin.EXCLEXCL) {
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
                        tw.writeStmts_throwstmt(throwId, stmtParent.parent, stmtParent.idx, callable)
                        tw.writeHasLocation(throwId, locId)
                        val newExprId = extractNewExpr(it, null, thrownType, locId, throwId, 0, callable, throwId)
                        extractTypeAccess(thrownType, locId, newExprId, -3, callable, throwId)
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
                        extractRawMethodAccess(it, c, callable, parent, idx, enclosingStmt, listOf(c.extensionReceiver), null, null)
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
                    tw.writeHasLocation(id, locId)
                    tw.writeCallableEnclosingExpr(id, callable)

                    if (c.typeArgumentsCount == 1) {
                        val typeArgument = c.getTypeArgument(0)
                        if (typeArgument == null) {
                            logger.errorElement("Type argument missing in an arrayOfNulls call", c)
                        } else {
                            extractTypeAccessRecursive(typeArgument, locId, id, -1, callable, enclosingStmt, TypeContext.GENERIC_ARGUMENT)
                        }
                    } else {
                        logger.errorElement("Expected to find exactly one type argument in an arrayOfNulls call", c)
                    }

                    if (c.valueArgumentsCount == 1) {
                        val dim = c.getValueArgument(0)
                        if (dim != null) {
                            extractExpressionExpr(dim, callable, id, 0, enclosingStmt)
                        } else {
                            logger.errorElement("Expected to find non-null argument in an arrayOfNulls call", c)
                        }
                    } else {
                        logger.errorElement("Expected to find only one argument in an arrayOfNulls call", c)
                    }
                }
                isBuiltinCallKotlin(c, "arrayOf")
                        || isBuiltinCallKotlin(c, "doubleArrayOf")
                        || isBuiltinCallKotlin(c, "floatArrayOf")
                        || isBuiltinCallKotlin(c, "longArrayOf")
                        || isBuiltinCallKotlin(c, "intArrayOf")
                        || isBuiltinCallKotlin(c, "charArrayOf")
                        || isBuiltinCallKotlin(c, "shortArrayOf")
                        || isBuiltinCallKotlin(c, "byteArrayOf")
                        || isBuiltinCallKotlin(c, "booleanArrayOf") -> {

                    val arg = if (c.valueArgumentsCount == 1) c.getValueArgument(0) else {
                        logger.errorElement("Expected to find only one (vararg) argument in ${c.symbol.owner.name.asString()} call", c)
                        null
                    }?.let {
                        if (it is IrVararg) it else {
                            logger.errorElement("Expected to find vararg argument in ${c.symbol.owner.name.asString()} call", c)
                            null
                        }
                    }

                    // If this is [someType]ArrayOf(*x), x, otherwise null
                    val clonedArray = arg?.let {
                        if (arg.elements.size == 1) {
                            val onlyElement = arg.elements[0]
                            if (onlyElement is IrSpreadElement)
                                onlyElement.expression
                            else null
                        } else null
                    }

                    if (clonedArray != null) {
                        // This is an array clone: extract is as a call to java.lang.Object.clone
                        objectCloneMethod?.let {
                            extractRawMethodAccess(it, c, callable, parent, idx, enclosingStmt, listOf(), clonedArray, null)
                        }
                    } else {
                        // This is array creation: extract it as a call to new ArrayType[] { ... }
                        val id = tw.getFreshIdLabel<DbArraycreationexpr>()
                        val type = useType(c.type)
                        tw.writeExprs_arraycreationexpr(id, type.javaResult.id, parent, idx)
                        tw.writeExprsKotlinType(id, type.kotlinResult.id)
                        val locId = tw.getLocation(c)
                        tw.writeHasLocation(id, locId)
                        tw.writeCallableEnclosingExpr(id, callable)

                        if (isBuiltinCallKotlin(c, "arrayOf")) {
                            if (c.typeArgumentsCount == 1) {
                                val typeArgument = c.getTypeArgument(0)
                                if (typeArgument == null) {
                                    logger.errorElement("Type argument missing in an arrayOf call", c)
                                } else {
                                    extractTypeAccessRecursive(typeArgument, locId, id, -1, callable, enclosingStmt, TypeContext.GENERIC_ARGUMENT)
                                }
                            } else {
                                logger.errorElement("Expected to find one type argument in arrayOf call", c )
                            }
                        } else {
                            val elementType = c.type.getArrayElementType(pluginContext.irBuiltIns)
                            extractTypeAccessRecursive(elementType, locId, id, -1, callable, enclosingStmt)
                        }

                        arg?.let {
                            val initId = tw.getFreshIdLabel<DbArrayinit>()
                            tw.writeExprs_arrayinit(initId, type.javaResult.id, id, -2)
                            tw.writeExprsKotlinType(initId, type.kotlinResult.id)
                            tw.writeHasLocation(initId, locId)
                            tw.writeCallableEnclosingExpr(initId, callable)
                            tw.writeStatementEnclosingExpr(initId, enclosingStmt)
                            it.elements.forEachIndexed { i, arg -> extractVarargElement(arg, callable, initId, i, enclosingStmt) }

                            val dim = it.elements.size
                            val dimId = tw.getFreshIdLabel<DbIntegerliteral>()
                            val dimType = useType(pluginContext.irBuiltIns.intType)
                            tw.writeExprs_integerliteral(dimId, dimType.javaResult.id, id, 0)
                            tw.writeExprsKotlinType(dimId, dimType.kotlinResult.id)
                            tw.writeHasLocation(dimId, locId)
                            tw.writeCallableEnclosingExpr(dimId, callable)
                            tw.writeStatementEnclosingExpr(dimId, enclosingStmt)
                            tw.writeNamestrings(dim.toString(), dim.toString(), dimId)
                        }
                    }
                }
                isBuiltinCall(c, "<get-java>", "kotlin.jvm") -> {
                    // Special case for KClass<*>.java, which is used in the Parcelize plugin. In normal cases, this is already rewritten to the property referenced below:
                    findTopLevelPropertyOrWarn("kotlin.jvm.java", "kotlin.jvm.JvmClassMappingKt", c)?.let { javaProp ->
                        val getter = javaProp.getter
                        if (getter == null) {
                            logger.error("Couldn't find getter of `kotlin.jvm.JvmClassMappingKt::java`")
                            return
                        }

                        val ext = c.extensionReceiver
                        if (ext == null) {
                            logger.errorElement("No extension receiver found for `KClass::java` call", c)
                            return
                        }

                        val argType = (ext.type as? IrSimpleType)?.arguments?.firstOrNull()?.typeOrNull
                        val typeArguments = if (argType == null) listOf() else listOf(argType)

                        extractRawMethodAccess(getter, c, callable, parent, idx, enclosingStmt, listOf(), null, ext, typeArguments)
                    }
                }
                isFunction(target, "kotlin", "(some array type)", { isArrayType(it) }, "iterator") -> {
                    val parentClass = target.parent
                    if (parentClass !is IrClass) {
                        logger.errorElement("Iterator parent is not a class", c)
                        return
                    }

                    var typeFilter = if (isGenericArrayType(parentClass.name.asString())) {
                        "kotlin.jvm.internal.ArrayIteratorKt"
                    } else {
                        "kotlin.jvm.internal.ArrayIteratorsKt"
                    }

                    findTopLevelFunctionOrWarn("kotlin.jvm.internal.iterator", typeFilter, arrayOf(parentClass.kotlinFqName.asString()), c)?.let { iteratorFn ->
                        val dispatchReceiver = c.dispatchReceiver
                        if (dispatchReceiver == null) {
                            logger.errorElement("No dispatch receiver found for array iterator call", c)
                        } else {
                            val drType = dispatchReceiver.type
                            if (drType !is IrSimpleType) {
                                logger.errorElement("Dispatch receiver with unexpected type rep found for array iterator call: ${drType.javaClass}", c)
                            } else {
                                val typeArgs = drType.arguments.map {
                                    when(it) {
                                        is IrTypeProjection -> it.type
                                        else -> pluginContext.irBuiltIns.anyNType
                                    }
                                }
                                extractRawMethodAccess(iteratorFn, c, callable, parent, idx, enclosingStmt, listOf(c.dispatchReceiver), null, null, typeArgs)
                            }
                        }
                    }
                }
                isFunction(target, "kotlin", "(some array type)", { isArrayType(it) }, "get") && c.origin == IrStatementOrigin.GET_ARRAY_ELEMENT && c.dispatchReceiver != null -> {
                    val id = tw.getFreshIdLabel<DbArrayaccess>()
                    val type = useType(c.type)
                    tw.writeExprs_arrayaccess(id, type.javaResult.id, parent, idx)
                    tw.writeExprsKotlinType(id, type.kotlinResult.id)
                    binopDisp(id)
                }
                isFunction(target, "kotlin", "(some array type)", { isArrayType(it) }, "set") && c.origin == IrStatementOrigin.EQ && c.dispatchReceiver != null -> {
                    val array = c.dispatchReceiver
                    val arrayIdx = c.getValueArgument(0)
                    val assignedValue = c.getValueArgument(1)

                    if (array != null && arrayIdx != null && assignedValue != null) {

                        val assignId = tw.getFreshIdLabel<DbAssignexpr>()
                        val type = useType(c.type)
                        val locId = tw.getLocation(c)
                        tw.writeExprs_assignexpr(assignId, type.javaResult.id, parent, idx)
                        tw.writeExprsKotlinType(assignId, type.kotlinResult.id)
                        tw.writeHasLocation(assignId, locId)
                        tw.writeCallableEnclosingExpr(assignId, callable)
                        tw.writeStatementEnclosingExpr(assignId, enclosingStmt)

                        val arrayAccessId = tw.getFreshIdLabel<DbArrayaccess>()
                        val arrayType = useType(array.type)
                        tw.writeExprs_arrayaccess(arrayAccessId, arrayType.javaResult.id, assignId, 0)
                        tw.writeExprsKotlinType(arrayAccessId, arrayType.kotlinResult.id)
                        tw.writeHasLocation(arrayAccessId, locId)
                        tw.writeCallableEnclosingExpr(arrayAccessId, callable)
                        tw.writeStatementEnclosingExpr(arrayAccessId, enclosingStmt)

                        extractExpressionExpr(array, callable, arrayAccessId, 0, enclosingStmt)
                        extractExpressionExpr(arrayIdx, callable, arrayAccessId, 1, enclosingStmt)

                        extractExpressionExpr(assignedValue, callable, assignId, 1, enclosingStmt)

                    } else {
                        logger.errorElement("Unexpected Array.set function signature", c)
                    }
                }
                isBuiltinCall(c, "<unsafe-coerce>", "kotlin.jvm.internal") -> {

                    if (c.valueArgumentsCount != 1) {
                        logger.errorElement("Expected to find one argument for a kotlin.jvm.internal.<unsafe-coerce>() call, but found ${c.valueArgumentsCount}", c)
                        return
                    }

                    if (c.typeArgumentsCount != 2) {
                        logger.errorElement("Expected to find two type arguments for a kotlin.jvm.internal.<unsafe-coerce>() call, but found ${c.typeArgumentsCount}", c)
                        return
                    }
                    val valueArg = c.getValueArgument(0)
                    if (valueArg == null) {
                        logger.errorElement("Cannot find value argument for a kotlin.jvm.internal.<unsafe-coerce>() call", c)
                        return
                    }
                    val typeArg = c.getTypeArgument(1)
                    if (typeArg == null) {
                        logger.errorElement("Cannot find type argument for a kotlin.jvm.internal.<unsafe-coerce>() call", c)
                        return
                    }

                    val id = tw.getFreshIdLabel<DbUnsafecoerceexpr>()
                    val locId = tw.getLocation(c)
                    val type = useType(c.type)
                    tw.writeExprs_unsafecoerceexpr(id, type.javaResult.id, parent, idx)
                    tw.writeExprsKotlinType(id, type.kotlinResult.id)
                    tw.writeHasLocation(id, locId)
                    tw.writeCallableEnclosingExpr(id, callable)
                    tw.writeStatementEnclosingExpr(id, enclosingStmt)
                    extractTypeAccessRecursive(typeArg, locId, id, 0, callable, enclosingStmt)
                    extractExpressionExpr(valueArg, callable, id, 1, enclosingStmt)
                }
                isBuiltinCallInternal(c, "dataClassArrayMemberToString") -> {
                    val arrayArg = c.getValueArgument(0)
                    val realArrayClass = arrayArg?.type?.classOrNull
                    if (realArrayClass == null) {
                        logger.errorElement("Argument to dataClassArrayMemberToString not a class", c)
                        return
                    }
                    val realCallee = javaUtilArrays?.declarations?.findSubType<IrFunction> { decl ->
                        decl.name.asString() == "toString" && decl.valueParameters.size == 1 &&
                                decl.valueParameters[0].type.classOrNull?.let { it == realArrayClass } == true
                    }
                    if (realCallee == null) {
                        logger.errorElement("Couldn't find a java.lang.Arrays.toString method matching class ${realArrayClass.owner.name}", c)
                    } else {
                        extractRawMethodAccess(
                            realCallee,
                            c,
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
                        logger.errorElement("Argument to dataClassArrayMemberHashCode not a class", c)
                        return
                    }
                    val realCallee = javaUtilArrays?.declarations?.findSubType<IrFunction> { decl ->
                        decl.name.asString() == "hashCode" && decl.valueParameters.size == 1 &&
                                decl.valueParameters[0].type.classOrNull?.let { it == realArrayClass } == true
                    }
                    if (realCallee == null) {
                        logger.errorElement("Couldn't find a java.lang.Arrays.hashCode method matching class ${realArrayClass.owner.name}", c)
                    } else {
                        extractRawMethodAccess(
                            realCallee,
                            c,
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

    private fun extractNewExpr(
        methodId: Label<out DbConstructor>,
        constructedType: TypeResults,
        locId: Label<out DbLocation>,
        parent: Label<out DbExprparent>,
        idx: Int,
        callable: Label<out DbCallable>,
        enclosingStmt: Label<out DbStmt>
    ): Label<DbNewexpr> {
        val id = tw.getFreshIdLabel<DbNewexpr>()
        tw.writeExprs_newexpr(id, constructedType.javaResult.id, parent, idx)
        tw.writeExprsKotlinType(id, constructedType.kotlinResult.id)
        tw.writeHasLocation(id, locId)
        tw.writeCallableEnclosingExpr(id, callable)
        tw.writeStatementEnclosingExpr(id, enclosingStmt)
        tw.writeCallableBinding(id, methodId)
        return id
    }

    private fun extractNewExpr(
        calledConstructor: IrFunction,
        constructorTypeArgs: List<IrTypeArgument>?,
        constructedType: TypeResults,
        locId: Label<out DbLocation>,
        parent: Label<out DbExprparent>,
        idx: Int,
        callable: Label<out DbCallable>,
        enclosingStmt: Label<out DbStmt>
    ): Label<DbNewexpr> = extractNewExpr(useFunction<DbConstructor>(calledConstructor, constructorTypeArgs), constructedType, locId, parent, idx, callable, enclosingStmt)

    private fun needsObinitFunction(c: IrClass) = c.primaryConstructor == null && c.constructors.count() > 1

    private fun getObinitLabel(c: IrClass) = getFunctionLabel(
        c,
        null,
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
        val isAnonymous = eType.isAnonymous
        val type: TypeResults = if (isAnonymous) {
            if (e.typeArgumentsCount > 0) {
                logger.warnElement("Unexpected type arguments (${e.typeArgumentsCount}) for anonymous class constructor call", e)
            }
            val c = eType.classifier.owner
            if (c !is IrClass) {
                logger.errorElement("Anonymous constructor call type not a class (${c.javaClass})", e)
                return
            }
            useAnonymousClass(c)
        } else {
            useType(eType)
        }
        val locId = tw.getLocation(e)
        val id = extractNewExpr(e.symbol.owner, eType.arguments, type, locId, parent, idx, callable, enclosingStmt)

        if (isAnonymous) {
            tw.writeIsAnonymClass(type.javaResult.id.cast<DbClass>(), id)
        }

        extractCallValueArguments(id, e, enclosingStmt, callable, 0)

        val dr = e.dispatchReceiver
        if (dr != null) {
            extractExpressionExpr(dr, callable, id, -2, enclosingStmt)
        }

        val typeAccessType = if (isAnonymous) {
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
            extractConstructorTypeAccess(eType, typeAccessType, e.symbol, locId, id, -3, callable, enclosingStmt)
        } else {
            val typeAccessId =
                extractTypeAccess(typeAccessType, locId, id, -3, callable, enclosingStmt)

            extractTypeArguments(e, typeAccessId, callable, enclosingStmt)
        }
    }

    // todo: calculating the enclosing ref type could be done through this, instead of walking up the declaration parent chain
    private val declarationStack: Stack<IrDeclaration> = Stack()

    abstract inner class StmtExprParent {
        abstract fun stmt(e: IrExpression, callable: Label<out DbCallable>): StmtParent
        abstract fun expr(e: IrExpression, callable: Label<out DbCallable>): ExprParent
    }

    inner class StmtParent(val parent: Label<out DbStmtparent>, val idx: Int): StmtExprParent() {
        override fun stmt(e: IrExpression, callable: Label<out DbCallable>): StmtParent {
            return this
        }
        override fun expr(e: IrExpression, callable: Label<out DbCallable>): ExprParent {
            val id = tw.getFreshIdLabel<DbExprstmt>()
            val locId = tw.getLocation(e)
            tw.writeStmts_exprstmt(id, parent, idx, callable)
            tw.writeHasLocation(id, locId)
            return ExprParent(id, 0, id)
        }
    }
    inner class ExprParent(val parent: Label<out DbExprparent>, val idx: Int, val enclosingStmt: Label<out DbStmt>): StmtExprParent() {
        override fun stmt(e: IrExpression, callable: Label<out DbCallable>): StmtParent {
            val id = tw.getFreshIdLabel<DbStmtexpr>()
            val type = useType(e.type)
            val locId = tw.getLocation(e)
            tw.writeExprs_stmtexpr(id, type.javaResult.id, parent, idx)
            tw.writeExprsKotlinType(id, type.kotlinResult.id)
            tw.writeHasLocation(id, locId)
            tw.writeCallableEnclosingExpr(id, callable)
            tw.writeStatementEnclosingExpr(id, enclosingStmt)
            return StmtParent(id, 0)
        }
        override fun expr(e: IrExpression, callable: Label<out DbCallable>): ExprParent {
            return this
        }
    }

    private fun getStatementOriginOperator(origin: IrStatementOrigin?) = when (origin) {
        IrStatementOrigin.PLUSEQ -> "plus"
        IrStatementOrigin.MINUSEQ -> "minus"
        IrStatementOrigin.MULTEQ -> "times"
        IrStatementOrigin.DIVEQ -> "div"
        IrStatementOrigin.PERCEQ -> "rem"
        else -> null
    }

    private fun getUpdateInPlaceRHS(origin: IrStatementOrigin?, isExpectedLhs: (IrExpression?) -> Boolean, updateRhs: IrExpression): IrExpression? {
        // Check for a desugared in-place update operator, such as "v += e":
        return getStatementOriginOperator(origin)?.let {
            if (updateRhs is IrCall &&
                isNumericFunction(updateRhs.symbol.owner, it)
            ) {
                // Check for an expression like x = get(x).op(e):
                val opReceiver = updateRhs.dispatchReceiver
                if (isExpectedLhs(opReceiver)) {
                    updateRhs.getValueArgument(0)
                } else null
            } else null
        }
    }

    private fun writeUpdateInPlaceExpr(origin: IrStatementOrigin): ((tw: TrapWriter, id: Label<out DbAssignexpr>, type: Label<out DbType>, exprParent: Label<out DbExprparent>, index: Int) -> Unit)? {
        when(origin) {
            IrStatementOrigin.PLUSEQ -> return { tw: TrapWriter, id: Label<out DbAssignexpr>, type: Label<out DbType>, exprParent: Label<out DbExprparent>, index: Int -> tw.writeExprs_assignaddexpr(id.cast<DbAssignaddexpr>(), type, exprParent, index) }
            IrStatementOrigin.MINUSEQ -> return { tw: TrapWriter, id: Label<out DbAssignexpr>, type: Label<out DbType>, exprParent: Label<out DbExprparent>, index: Int -> tw.writeExprs_assignsubexpr(id.cast<DbAssignsubexpr>(), type, exprParent, index) }
            IrStatementOrigin.MULTEQ -> return { tw: TrapWriter, id: Label<out DbAssignexpr>, type: Label<out DbType>, exprParent: Label<out DbExprparent>, index: Int -> tw.writeExprs_assignmulexpr(id.cast<DbAssignmulexpr>(), type, exprParent, index) }
            IrStatementOrigin.DIVEQ -> return { tw: TrapWriter, id: Label<out DbAssignexpr>, type: Label<out DbType>, exprParent: Label<out DbExprparent>, index: Int -> tw.writeExprs_assigndivexpr(id.cast<DbAssigndivexpr>(), type, exprParent, index) }
            IrStatementOrigin.PERCEQ -> return { tw: TrapWriter, id: Label<out DbAssignexpr>, type: Label<out DbType>, exprParent: Label<out DbExprparent>, index: Int -> tw.writeExprs_assignremexpr(id.cast<DbAssignremexpr>(), type, exprParent, index) }
            else -> return null
        }
    }

    /**
     * This tried to extract a block as an array update.
     * It returns true if it succeeds, and false otherwise.
     */
    private fun tryExtractArrayUpdate(e: IrContainerExpression, callable: Label<out DbCallable>, parent: StmtExprParent): Boolean {
        /*
         * We're expecting the pattern
         * {
         *   val array = e1
         *   val idx = e2
         *   array.set(idx, array.get(idx).op(e3))
         * }
         *
         * If we find it, we'll extract e1[e2] op= e3 (op is +, -, ...)
         */
        if(e.statements.size != 3)
            return false
        (e.statements[0] as? IrVariable)?.let { arrayVarDecl ->
            arrayVarDecl.initializer?.let { arrayVarInitializer ->
                (e.statements[1] as? IrVariable)?.let { indexVarDecl ->
                    indexVarDecl.initializer?.let { indexVarInitializer ->
                        (e.statements[2] as? IrCall)?.let { arraySetCall ->
                            if (isFunction(arraySetCall.symbol.owner, "kotlin", "(some array type)", { isArrayType(it) }, "set")) {
                                val updateRhs = arraySetCall.getValueArgument(1)
                                if (updateRhs == null) {
                                    logger.errorElement("Update RHS not found", e)
                                    return false
                                }
                                getUpdateInPlaceRHS(
                                    e.origin, // Using e.origin not arraySetCall.origin here distinguishes a compiler-generated block from a user manually code that looks the same.
                                    {   oldValue ->
                                        oldValue is IrCall &&
                                        isFunction(oldValue.symbol.owner, "kotlin", "(some array type)", { typeName -> isArrayType(typeName) }, "get") &&
                                        (oldValue.dispatchReceiver as? IrGetValue)?.let {
                                            receiverVal -> receiverVal.symbol.owner == arrayVarDecl.symbol.owner
                                        } ?: false
                                    },
                                    updateRhs
                                )?.let { updateRhs ->
                                    val origin = e.origin
                                    if (origin == null) {
                                        logger.errorElement("No origin found", e)
                                        return false
                                    }
                                    val writeUpdateInPlaceExprFun = writeUpdateInPlaceExpr(origin)
                                    if (writeUpdateInPlaceExprFun == null) {
                                        logger.errorElement("Unexpected origin", e)
                                        return false
                                    }

                                    // Create an assignment skeleton _ op= _
                                    val exprParent = parent.expr(e, callable)
                                    val assignId = tw.getFreshIdLabel<DbAssignexpr>()
                                    val type = useType(arrayVarInitializer.type)
                                    val locId = tw.getLocation(e)
                                    tw.writeExprsKotlinType(assignId, type.kotlinResult.id)
                                    tw.writeHasLocation(assignId, locId)
                                    tw.writeCallableEnclosingExpr(assignId, callable)
                                    tw.writeStatementEnclosingExpr(assignId, exprParent.enclosingStmt)

                                    writeUpdateInPlaceExprFun(tw, assignId, type.javaResult.id, exprParent.parent, exprParent.idx)

                                    // Extract e1[e2]
                                    val lhsId = tw.getFreshIdLabel<DbArrayaccess>()
                                    val elementType = useType(updateRhs.type)
                                    tw.writeExprs_arrayaccess(lhsId, elementType.javaResult.id, assignId, 0)
                                    tw.writeExprsKotlinType(lhsId, elementType.kotlinResult.id)
                                    tw.writeHasLocation(lhsId, locId)
                                    tw.writeCallableEnclosingExpr(lhsId, callable)
                                    tw.writeStatementEnclosingExpr(lhsId, exprParent.enclosingStmt)
                                    extractExpressionExpr(arrayVarInitializer, callable, lhsId, 0, exprParent.enclosingStmt)
                                    extractExpressionExpr(indexVarInitializer, callable, lhsId, 1, exprParent.enclosingStmt)

                                    // Extract e3
                                    extractExpressionExpr(updateRhs, callable, assignId, 1, exprParent.enclosingStmt)

                                    return true
                                }
                            }
                        }
                    }
                }
            }
        }

        return false
    }

    private fun extractExpressionStmt(e: IrExpression, callable: Label<out DbCallable>, parent: Label<out DbStmtparent>, idx: Int) {
        extractExpression(e, callable, StmtParent(parent, idx))
    }

    fun extractExpressionExpr(e: IrExpression, callable: Label<out DbCallable>, parent: Label<out DbExprparent>, idx: Int, enclosingStmt: Label<out DbStmt>) {
        extractExpression(e, callable, ExprParent(parent, idx, enclosingStmt))
    }

    private fun extractExpression(e: IrExpression, callable: Label<out DbCallable>, parent: StmtExprParent) {
        with("expression", e) {
            when(e) {
                is IrDelegatingConstructorCall -> {
                    val stmtParent = parent.stmt(e, callable)

                    val irCallable = declarationStack.peek()

                    val delegatingClass = e.symbol.owner.parent
                    val currentClass = irCallable.parent

                    if (delegatingClass !is IrClass) {
                        logger.warnElement("Delegating class isn't a class: " + delegatingClass.javaClass, e)
                    }
                    if (currentClass !is IrClass) {
                        logger.warnElement("Current class isn't a class: " + currentClass.javaClass, e)
                    }

                    val id: Label<out DbStmt>
                    if (delegatingClass != currentClass) {
                        id = tw.getFreshIdLabel<DbSuperconstructorinvocationstmt>()
                        tw.writeStmts_superconstructorinvocationstmt(id, stmtParent.parent, stmtParent.idx, callable)
                    } else {
                        id = tw.getFreshIdLabel<DbConstructorinvocationstmt>()
                        tw.writeStmts_constructorinvocationstmt(id, stmtParent.parent, stmtParent.idx, callable)
                    }

                    val locId = tw.getLocation(e)
                    val methodId = useFunction<DbConstructor>(e.symbol.owner)

                    tw.writeHasLocation(id, locId)
                    tw.writeCallableBinding(id.cast<DbCaller>(), methodId)
                    extractCallValueArguments(id, e, id, callable, 0)
                    val dr = e.dispatchReceiver
                    if (dr != null) {
                        extractExpressionExpr(dr, callable, id, -1, id)
                    }

                    // todo: type arguments at index -2, -3, ...
                }
                is IrThrow -> {
                    val stmtParent = parent.stmt(e, callable)
                    val id = tw.getFreshIdLabel<DbThrowstmt>()
                    val locId = tw.getLocation(e)
                    tw.writeStmts_throwstmt(id, stmtParent.parent, stmtParent.idx, callable)
                    tw.writeHasLocation(id, locId)
                    extractExpressionExpr(e.value, callable, id, 0, id)
                }
                is IrBreak -> {
                    val stmtParent = parent.stmt(e, callable)
                    val id = tw.getFreshIdLabel<DbBreakstmt>()
                    tw.writeStmts_breakstmt(id, stmtParent.parent, stmtParent.idx, callable)
                    extractBreakContinue(e, id)
                }
                is IrContinue -> {
                    val stmtParent = parent.stmt(e, callable)
                    val id = tw.getFreshIdLabel<DbContinuestmt>()
                    tw.writeStmts_continuestmt(id, stmtParent.parent, stmtParent.idx, callable)
                    extractBreakContinue(e, id)
                }
                is IrReturn -> {
                    val stmtParent = parent.stmt(e, callable)
                    val id = tw.getFreshIdLabel<DbReturnstmt>()
                    val locId = tw.getLocation(e)
                    tw.writeStmts_returnstmt(id, stmtParent.parent, stmtParent.idx, callable)
                    tw.writeHasLocation(id, locId)
                    extractExpressionExpr(e.value, callable, id, 0, id)
                }
                is IrTry -> {
                    val stmtParent = parent.stmt(e, callable)
                    val id = tw.getFreshIdLabel<DbTrystmt>()
                    val locId = tw.getLocation(e)
                    tw.writeStmts_trystmt(id, stmtParent.parent, stmtParent.idx, callable)
                    tw.writeHasLocation(id, locId)
                    extractExpressionStmt(e.tryResult, callable, id, -1)
                    val finallyStmt = e.finallyExpression
                    if(finallyStmt != null) {
                        extractExpressionStmt(finallyStmt, callable, id, -2)
                    }
                    for((catchIdx, catchClause) in e.catches.withIndex()) {
                        val catchId = tw.getFreshIdLabel<DbCatchclause>()
                        tw.writeStmts_catchclause(catchId, id, catchIdx, callable)
                        val catchLocId = tw.getLocation(catchClause)
                        tw.writeHasLocation(catchId, catchLocId)
                        extractTypeAccessRecursive(catchClause.catchParameter.type, tw.getLocation(catchClause.catchParameter), catchId, -1, callable, catchId)
                        extractVariableExpr(catchClause.catchParameter, callable, catchId, 0, catchId)
                        extractExpressionStmt(catchClause.result, callable, catchId, 1)
                    }
                }
                is IrContainerExpression -> {
                    if(!tryExtractArrayUpdate(e, callable, parent)) {
                        val stmtParent = parent.stmt(e, callable)
                        val id = tw.getFreshIdLabel<DbBlock>()
                        val locId = tw.getLocation(e)
                        tw.writeStmts_block(id, stmtParent.parent, stmtParent.idx, callable)
                        tw.writeHasLocation(id, locId)
                        e.statements.forEachIndexed { i, s ->
                            extractStatement(s, callable, id, i)
                        }
                    }
                }
                is IrWhileLoop -> {
                    extractLoop(e, parent, callable)
                }
                is IrDoWhileLoop -> {
                    extractLoop(e, parent, callable)
                }
                is IrInstanceInitializerCall -> {
                    val irConstructor = declarationStack.peek() as? IrConstructor
                    if (irConstructor == null) {
                        logger.errorElement("IrInstanceInitializerCall outside constructor", e)
                        return
                    }
                    if (needsObinitFunction(irConstructor.parentAsClass)) {
                        val exprParent = parent.expr(e, callable)
                        val id = tw.getFreshIdLabel<DbMethodaccess>()
                        val type = useType(pluginContext.irBuiltIns.unitType)
                        val locId = tw.getLocation(e)
                        val methodLabel = getObinitLabel(irConstructor.parentAsClass)
                        val methodId = tw.getLabelFor<DbMethod>(methodLabel)
                        tw.writeExprs_methodaccess(id, type.javaResult.id, exprParent.parent, exprParent.idx)
                        tw.writeExprsKotlinType(id, type.kotlinResult.id)
                        tw.writeHasLocation(id, locId)
                        tw.writeCallableEnclosingExpr(id, callable)
                        tw.writeStatementEnclosingExpr(id, exprParent.enclosingStmt)
                        tw.writeCallableBinding(id, methodId)
                    }
                    else {
                        val stmtParent = parent.stmt(e, callable)
                        extractInstanceInitializerBlock(stmtParent, irConstructor)
                    }
                }
                is IrConstructorCall -> {
                    val exprParent = parent.expr(e, callable)
                    extractConstructorCall(e, exprParent.parent, exprParent.idx, callable, exprParent.enclosingStmt)
                }
                is IrEnumConstructorCall -> {
                    val exprParent = parent.expr(e, callable)
                    extractConstructorCall(e, exprParent.parent, exprParent.idx, callable, exprParent.enclosingStmt)
                }
                is IrCall -> {
                    extractCall(e, callable, parent)
                }
                is IrStringConcatenation -> {
                    val exprParent = parent.expr(e, callable)
                    val id = tw.getFreshIdLabel<DbStringtemplateexpr>()
                    val type = useType(e.type)
                    val locId = tw.getLocation(e)
                    tw.writeExprs_stringtemplateexpr(id, type.javaResult.id, exprParent.parent, exprParent.idx)
                    tw.writeExprsKotlinType(id, type.kotlinResult.id)
                    tw.writeHasLocation(id, locId)
                    tw.writeCallableEnclosingExpr(id, callable)
                    tw.writeStatementEnclosingExpr(id, exprParent.enclosingStmt)
                    e.arguments.forEachIndexed { i, a ->
                        extractExpressionExpr(a, callable, id, i, exprParent.enclosingStmt)
                    }
                }
                is IrConst<*> -> {
                    val exprParent = parent.expr(e, callable)
                    when(val v = e.value) {
                        is Int, is Short, is Byte -> {
                            val id = tw.getFreshIdLabel<DbIntegerliteral>()
                            val type = useType(e.type)
                            val locId = tw.getLocation(e)
                            tw.writeExprs_integerliteral(id, type.javaResult.id, exprParent.parent, exprParent.idx)
                            tw.writeExprsKotlinType(id, type.kotlinResult.id)
                            tw.writeHasLocation(id, locId)
                            tw.writeCallableEnclosingExpr(id, callable)
                            tw.writeStatementEnclosingExpr(id, exprParent.enclosingStmt)
                            tw.writeNamestrings(v.toString(), v.toString(), id)
                        } is Long -> {
                            val id = tw.getFreshIdLabel<DbLongliteral>()
                            val type = useType(e.type)
                            val locId = tw.getLocation(e)
                            tw.writeExprs_longliteral(id, type.javaResult.id, exprParent.parent, exprParent.idx)
                            tw.writeExprsKotlinType(id, type.kotlinResult.id)
                            tw.writeHasLocation(id, locId)
                            tw.writeCallableEnclosingExpr(id, callable)
                            tw.writeStatementEnclosingExpr(id, exprParent.enclosingStmt)
                            tw.writeNamestrings(v.toString(), v.toString(), id)
                        } is Float -> {
                            val id = tw.getFreshIdLabel<DbFloatingpointliteral>()
                            val type = useType(e.type)
                            val locId = tw.getLocation(e)
                            tw.writeExprs_floatingpointliteral(id, type.javaResult.id, exprParent.parent, exprParent.idx)
                            tw.writeExprsKotlinType(id, type.kotlinResult.id)
                            tw.writeHasLocation(id, locId)
                            tw.writeCallableEnclosingExpr(id, callable)
                            tw.writeStatementEnclosingExpr(id, exprParent.enclosingStmt)
                            tw.writeNamestrings(v.toString(), v.toString(), id)
                        } is Double -> {
                            val id = tw.getFreshIdLabel<DbDoubleliteral>()
                            val type = useType(e.type)
                            val locId = tw.getLocation(e)
                            tw.writeExprs_doubleliteral(id, type.javaResult.id, exprParent.parent, exprParent.idx)
                            tw.writeExprsKotlinType(id, type.kotlinResult.id)
                            tw.writeHasLocation(id, locId)
                            tw.writeCallableEnclosingExpr(id, callable)
                            tw.writeStatementEnclosingExpr(id, exprParent.enclosingStmt)
                            tw.writeNamestrings(v.toString(), v.toString(), id)
                        } is Boolean -> {
                            val id = tw.getFreshIdLabel<DbBooleanliteral>()
                            val type = useType(e.type)
                            val locId = tw.getLocation(e)
                            tw.writeExprs_booleanliteral(id, type.javaResult.id, exprParent.parent, exprParent.idx)
                            tw.writeExprsKotlinType(id, type.kotlinResult.id)
                            tw.writeHasLocation(id, locId)
                            tw.writeCallableEnclosingExpr(id, callable)
                            tw.writeStatementEnclosingExpr(id, exprParent.enclosingStmt)
                            tw.writeNamestrings(v.toString(), v.toString(), id)
                        } is Char -> {
                            val id = tw.getFreshIdLabel<DbCharacterliteral>()
                            val type = useType(e.type)
                            val locId = tw.getLocation(e)
                            tw.writeExprs_characterliteral(id, type.javaResult.id, exprParent.parent, exprParent.idx)
                            tw.writeExprsKotlinType(id, type.kotlinResult.id)
                            tw.writeHasLocation(id, locId)
                            tw.writeCallableEnclosingExpr(id, callable)
                            tw.writeStatementEnclosingExpr(id, exprParent.enclosingStmt)
                            tw.writeNamestrings(v.toString(), v.toString(), id)
                        } is String -> {
                            val id = tw.getFreshIdLabel<DbStringliteral>()
                            val type = useType(e.type)
                            val locId = tw.getLocation(e)
                            tw.writeExprs_stringliteral(id, type.javaResult.id, exprParent.parent, exprParent.idx)
                            tw.writeExprsKotlinType(id, type.kotlinResult.id)
                            tw.writeHasLocation(id, locId)
                            tw.writeCallableEnclosingExpr(id, callable)
                            tw.writeStatementEnclosingExpr(id, exprParent.enclosingStmt)
                            tw.writeNamestrings(v.toString(), v.toString(), id)
                        }
                        null -> {
                            val id = tw.getFreshIdLabel<DbNullliteral>()
                            val type = useType(e.type) // class;kotlin.Nothing
                            val locId = tw.getLocation(e)
                            tw.writeExprs_nullliteral(id, type.javaResult.id, exprParent.parent, exprParent.idx)
                            tw.writeExprsKotlinType(id, type.kotlinResult.id)
                            tw.writeHasLocation(id, locId)
                            tw.writeCallableEnclosingExpr(id, callable)
                            tw.writeStatementEnclosingExpr(id, exprParent.enclosingStmt)
                        }
                        else -> {
                            logger.errorElement("Unrecognised IrConst: " + v.javaClass, e)
                        }
                    }
                }
                is IrGetValue -> {
                    val exprParent = parent.expr(e, callable)
                    val owner = e.symbol.owner
                    if (owner is IrValueParameter && owner.index == -1 && !owner.isExtensionReceiver()) {
                        extractThisAccess(e, exprParent, callable)
                    } else {
                        extractVariableAccess(useValueDeclaration(owner), e.type, tw.getLocation(e), exprParent.parent, exprParent.idx, callable, exprParent.enclosingStmt)
                    }
                }
                is IrGetField -> {
                    val exprParent = parent.expr(e, callable)
                    val owner = tryReplaceAndroidSyntheticField(e.symbol.owner)
                    val locId = tw.getLocation(e)
                    extractVariableAccess(useField(owner), e.type, locId, exprParent.parent, exprParent.idx, callable, exprParent.enclosingStmt).also { id ->
                        val receiver = e.receiver
                        if (receiver != null) {
                            extractExpressionExpr(receiver, callable, id, -1, exprParent.enclosingStmt)
                        } else if (owner.isStatic) {
                            extractStaticTypeAccessQualifier(owner, id, locId, callable, exprParent.enclosingStmt)
                        }
                    }
                }
                is IrGetEnumValue -> {
                    val exprParent = parent.expr(e, callable)
                    val id = tw.getFreshIdLabel<DbVaraccess>()
                    val type = useType(e.type)
                    val locId = tw.getLocation(e)
                    tw.writeExprs_varaccess(id, type.javaResult.id, exprParent.parent, exprParent.idx)
                    tw.writeExprsKotlinType(id, type.kotlinResult.id)
                    tw.writeHasLocation(id, locId)
                    tw.writeCallableEnclosingExpr(id, callable)
                    tw.writeStatementEnclosingExpr(id, exprParent.enclosingStmt)

                    val owner = if (e.symbol.isBound) {
                        e.symbol.owner
                    }
                    else {
                        logger.warnElement("Unbound enum value, trying to use enum entry stub from descriptor", e)

                        @OptIn(ObsoleteDescriptorBasedAPI::class)
                        getIrStubFromDescriptor() { it.generateEnumEntryStub(e.symbol.descriptor) }
                    } ?: return

                    val vId = useEnumEntry(owner)
                    tw.writeVariableBinding(id, vId)

                    extractStaticTypeAccessQualifier(owner, id, locId, callable, exprParent.enclosingStmt)
                }
                is IrSetValue,
                is IrSetField -> {
                    val exprParent = parent.expr(e, callable)
                    val id = tw.getFreshIdLabel<DbAssignexpr>()
                    val type = useType(e.type)
                    val rhsValue = when(e) {
                        is IrSetValue -> e.value
                        is IrSetField -> e.value
                        else -> { logger.errorElement("Unhandled IrSet* element.", e); return }
                    }
                    // The set operation's location as actually that of its LHS. Hence, the assignment spans the
                    // set op plus its RHS, while the varAccess takes its location from `e`.
                    val locId = tw.getLocation(e.startOffset, rhsValue.endOffset)
                    tw.writeExprsKotlinType(id, type.kotlinResult.id)
                    tw.writeHasLocation(id, locId)
                    tw.writeCallableEnclosingExpr(id, callable)
                    tw.writeStatementEnclosingExpr(id, exprParent.enclosingStmt)

                    val lhsId = tw.getFreshIdLabel<DbVaraccess>()
                    val lhsLocId = tw.getLocation(e)
                    tw.writeHasLocation(lhsId, lhsLocId)
                    tw.writeCallableEnclosingExpr(lhsId, callable)
                    tw.writeStatementEnclosingExpr(lhsId, exprParent.enclosingStmt)

                    when (e) {
                        is IrSetValue -> {
                            // Check for a desugared in-place update operator, such as "v += e":
                            val inPlaceUpdateRhs = getUpdateInPlaceRHS(e.origin, { it is IrGetValue && it.symbol.owner == e.symbol.owner }, rhsValue)
                            if (inPlaceUpdateRhs != null) {
                                val origin = e.origin
                                if (origin == null) {
                                    logger.errorElement("No origin for set-value", e)
                                    return
                                } else {
                                    val writeUpdateInPlaceExprFun = writeUpdateInPlaceExpr(origin)
                                    if (writeUpdateInPlaceExprFun == null) {
                                        logger.errorElement("Unexpected origin for set-value", e)
                                        return
                                    }
                                    writeUpdateInPlaceExprFun(tw, id, type.javaResult.id, exprParent.parent, exprParent.idx)
                                }
                            } else {
                                tw.writeExprs_assignexpr(id, type.javaResult.id, exprParent.parent, exprParent.idx)
                            }

                            val lhsType = useType(e.symbol.owner.type)
                            tw.writeExprs_varaccess(lhsId, lhsType.javaResult.id, id, 0)
                            tw.writeExprsKotlinType(lhsId, lhsType.kotlinResult.id)
                            val vId = useValueDeclaration(e.symbol.owner)
                            if (vId != null) {
                                tw.writeVariableBinding(lhsId, vId)
                            }
                            extractExpressionExpr(inPlaceUpdateRhs ?: rhsValue, callable, id, 1, exprParent.enclosingStmt)
                        }
                        is IrSetField -> {
                            tw.writeExprs_assignexpr(id, type.javaResult.id, exprParent.parent, exprParent.idx)
                            val realField = tryReplaceAndroidSyntheticField(e.symbol.owner)
                            val lhsType = useType(realField.type)
                            tw.writeExprs_varaccess(lhsId, lhsType.javaResult.id, id, 0)
                            tw.writeExprsKotlinType(lhsId, lhsType.kotlinResult.id)
                            val vId = useField(realField)
                            tw.writeVariableBinding(lhsId, vId)
                            extractExpressionExpr(e.value, callable, id, 1, exprParent.enclosingStmt)

                            val receiver = e.receiver
                            if (receiver != null) {
                                extractExpressionExpr(receiver, callable, lhsId, -1, exprParent.enclosingStmt)
                            } else if (realField.isStatic) {
                                extractStaticTypeAccessQualifier(realField, lhsId, lhsLocId, callable, exprParent.enclosingStmt)
                            }
                        }
                        else -> {
                            logger.errorElement("Unhandled IrSet* element.", e)
                        }
                    }
                }
                is IrWhen -> {
                    val isAndAnd = e.origin == IrStatementOrigin.ANDAND
                    val isOrOr = e.origin == IrStatementOrigin.OROR

                    if ((isAndAnd || isOrOr) &&
                        e.branches.size == 2 &&
                        (e.branches[1].condition as? IrConst<*>)?.value == true &&
                        (e.branches[if (e.origin == IrStatementOrigin.ANDAND) 1 else 0].result as? IrConst<*>)?.value == isOrOr) {

                        // resugar binary logical operators:

                        val exprParent = parent.expr(e, callable)
                        val type = useType(e.type)

                        val id = if (e.origin == IrStatementOrigin.ANDAND){
                            val id = tw.getFreshIdLabel<DbAndlogicalexpr>()
                            tw.writeExprs_andlogicalexpr(id, type.javaResult.id, exprParent.parent, exprParent.idx)
                            id
                        }
                        else {
                            val id = tw.getFreshIdLabel<DbOrlogicalexpr>()
                            tw.writeExprs_orlogicalexpr(id, type.javaResult.id, exprParent.parent, exprParent.idx)
                            id
                        }
                        val locId = tw.getLocation(e)

                        tw.writeExprsKotlinType(id, type.kotlinResult.id)
                        tw.writeHasLocation(id, locId)
                        tw.writeCallableEnclosingExpr(id, callable)
                        tw.writeStatementEnclosingExpr(id, exprParent.enclosingStmt)

                        extractExpressionExpr(e.branches[0].condition, callable, id, 0, exprParent.enclosingStmt)

                        var rhsIdx = if (e.origin == IrStatementOrigin.ANDAND) 0 else 1
                        extractExpressionExpr(e.branches[rhsIdx].result, callable, id, 1, exprParent.enclosingStmt)

                        return
                    }

                    val exprParent = parent.expr(e, callable)
                    val id = tw.getFreshIdLabel<DbWhenexpr>()
                    val type = useType(e.type)
                    val locId = tw.getLocation(e)
                    tw.writeExprs_whenexpr(id, type.javaResult.id, exprParent.parent, exprParent.idx)
                    tw.writeExprsKotlinType(id, type.kotlinResult.id)
                    tw.writeHasLocation(id, locId)
                    tw.writeCallableEnclosingExpr(id, callable)
                    tw.writeStatementEnclosingExpr(id, exprParent.enclosingStmt)
                    if(e.origin == IrStatementOrigin.IF) {
                        tw.writeWhen_if(id)
                    }
                    e.branches.forEachIndexed { i, b ->
                        val bId = tw.getFreshIdLabel<DbWhenbranch>()
                        val bLocId = tw.getLocation(b)
                        tw.writeStmts_whenbranch(bId, id, i, callable)
                        tw.writeHasLocation(bId, bLocId)
                        extractExpressionExpr(b.condition, callable, bId, 0, bId)
                        extractExpressionStmt(b.result, callable, bId, 1)
                        if(b is IrElseBranch) {
                            tw.writeWhen_branch_else(bId)
                        }
                    }
                }
                is IrGetClass -> {
                    val exprParent = parent.expr(e, callable)
                    val id = tw.getFreshIdLabel<DbGetclassexpr>()
                    val locId = tw.getLocation(e)
                    val type = useType(e.type)
                    tw.writeExprs_getclassexpr(id, type.javaResult.id, exprParent.parent, exprParent.idx)
                    tw.writeExprsKotlinType(id, type.kotlinResult.id)
                    tw.writeHasLocation(id, locId)
                    tw.writeCallableEnclosingExpr(id, callable)
                    tw.writeStatementEnclosingExpr(id, exprParent.enclosingStmt)
                    extractExpressionExpr(e.argument, callable, id, 0, exprParent.enclosingStmt)
                }
                is IrTypeOperatorCall -> {
                    val exprParent = parent.expr(e, callable)
                    extractTypeOperatorCall(e, callable, exprParent.parent, exprParent.idx, exprParent.enclosingStmt)
                }
                is IrVararg -> {
                    logger.errorElement("Unexpected IrVararg", e)
                }
                is IrGetObjectValue -> {
                    // For `object MyObject { ... }`, the .class has an
                    // automatically-generated `public static final MyObject INSTANCE`
                    // field that we are accessing here.
                    val exprParent = parent.expr(e, callable)
                    val c = if (e.symbol.isBound) {
                        e.symbol.owner
                    }
                    else {
                        logger.warnElement("Unbound object value, trying to use class stub from descriptor", e)

                        @OptIn(ObsoleteDescriptorBasedAPI::class)
                        getIrStubFromDescriptor() { it.generateClassStub(e.symbol.descriptor) }
                    } ?: return

                    val instance = if (c.isCompanion) useCompanionObjectClassInstance(c) else useObjectClassInstance(c)

                    if (instance != null) {
                        val id = tw.getFreshIdLabel<DbVaraccess>()
                        val type = useType(e.type)
                        val locId = tw.getLocation(e)
                        tw.writeExprs_varaccess(id, type.javaResult.id, exprParent.parent, exprParent.idx)
                        tw.writeExprsKotlinType(id, type.kotlinResult.id)
                        tw.writeHasLocation(id, locId)
                        tw.writeCallableEnclosingExpr(id, callable)
                        tw.writeStatementEnclosingExpr(id, exprParent.enclosingStmt)

                        tw.writeVariableBinding(id, instance.id)
                    }
                }
                is IrFunctionReference -> {
                    extractFunctionReference(e, parent, callable)
                }
                is IrFunctionExpression -> {
                    /*
                     * Extract generated class:
                     * ```
                     * class C : Any, kotlin.FunctionI<T0,T1, ... TI, R> {
                     *   constructor() { super(); }
                     *   fun invoke(a0:T0, a1:T1, ... aI: TI): R { ... }
                     * }
                     * ```
                     * or in case of big arity lambdas
                     * ```
                     * class C : Any, kotlin.FunctionN<R> {
                     *   constructor() { super(); }
                     *   fun invoke(a0:T0, a1:T1, ... aI: TI): R { ... }
                     *   fun invoke(vararg args: Any?): R {
                     *     return invoke(args[0] as T0, args[1] as T1, ..., args[I] as TI)
                     *   }
                     * }
                     * ```
                     **/

                    val ids = getLocallyVisibleFunctionLabels(e.function)
                    val locId = tw.getLocation(e)

                    val ext = e.function.extensionReceiverParameter
                    val parameters = if (ext != null) {
                        listOf(ext) + e.function.valueParameters
                    } else {
                        e.function.valueParameters
                    }

                    var types = parameters.map { it.type }
                    types += e.function.returnType

                    val isBigArity = types.size > BuiltInFunctionArity.BIG_ARITY
                    if (isBigArity) {
                        implementFunctionNInvoke(e.function, ids, locId, parameters)
                    } else {
                        addModifiers(ids.function, "override")
                    }

                    val exprParent = parent.expr(e, callable)
                    val idLambdaExpr = tw.getFreshIdLabel<DbLambdaexpr>()
                    tw.writeExprs_lambdaexpr(idLambdaExpr, ids.type.javaResult.id, exprParent.parent, exprParent.idx)
                    tw.writeExprsKotlinType(idLambdaExpr, ids.type.kotlinResult.id)
                    tw.writeHasLocation(idLambdaExpr, locId)
                    tw.writeCallableEnclosingExpr(idLambdaExpr, callable)
                    tw.writeStatementEnclosingExpr(idLambdaExpr, exprParent.enclosingStmt)
                    tw.writeCallableBinding(idLambdaExpr, ids.constructor)

                    // todo: fix hard coded block body of lambda
                    tw.writeLambdaKind(idLambdaExpr, 1)

                    val fnInterfaceType = getFunctionalInterfaceType(types)
                    if (fnInterfaceType == null) {
                        logger.warnElement("Cannot find functional interface type for function expression", e)
                    } else {
                        val id = extractGeneratedClass(
                            e.function, // We're adding this function as a member, and changing its name to `invoke` to implement `kotlin.FunctionX<,,,>.invoke(,,)`
                            listOf(pluginContext.irBuiltIns.anyType, fnInterfaceType))

                        extractTypeAccessRecursive(fnInterfaceType, locId, idLambdaExpr, -3, callable, exprParent.enclosingStmt)

                        tw.writeIsAnonymClass(id, idLambdaExpr)
                    }
                }
                is IrClassReference -> {
                    val exprParent = parent.expr(e, callable)
                    val id = tw.getFreshIdLabel<DbTypeliteral>()
                    val locId = tw.getLocation(e)
                    val type = useType(e.type)
                    tw.writeExprs_typeliteral(id, type.javaResult.id, exprParent.parent, exprParent.idx)
                    tw.writeExprsKotlinType(id, type.kotlinResult.id)
                    tw.writeHasLocation(id, locId)
                    tw.writeCallableEnclosingExpr(id, callable)
                    tw.writeStatementEnclosingExpr(id, exprParent.enclosingStmt)

                    extractTypeAccessRecursive(e.classType, locId, id, 0, callable, exprParent.enclosingStmt)
                }
                is IrPropertyReference -> {
                    extractPropertyReference("property reference", e, e.getter, e.setter, e.field, parent, callable)
                }
                is IrLocalDelegatedPropertyReference -> {
                    extractPropertyReference("local delegated property reference", e, e.getter, e.setter, null, parent, callable)
                }
                else -> {
                    logger.errorElement("Unrecognised IrExpression: " + e.javaClass, e)
                }
            }
            return
        }
    }

    private fun extractSuperAccess(irType: IrType, callable: Label<out DbCallable>, parent: Label<out DbExprparent>, idx: Int, enclosingStmt: Label<out DbStmt>, locId: Label<out DbLocation>) =
        tw.getFreshIdLabel<DbSuperaccess>().also {
            val type = useType(irType)
            tw.writeExprs_superaccess(it, type.javaResult.id, parent, idx)
            tw.writeExprsKotlinType(it, type.kotlinResult.id)
            tw.writeHasLocation(it, locId)
            tw.writeCallableEnclosingExpr(it, callable)
            tw.writeStatementEnclosingExpr(it, enclosingStmt)
            extractTypeAccessRecursive(irType, locId, it, 0)
        }

    private fun extractThisAccess(e: IrGetValue, exprParent: ExprParent, callable: Label<out DbCallable>) {
        val containingDeclaration = declarationStack.peek()
        val locId = tw.getLocation(e)
        val type = useType(e.type)

        if (containingDeclaration.shouldExtractAsStatic && containingDeclaration.parentClassOrNull?.isNonCompanionObject == true) {
            // Use of `this` in a non-companion object member that will be lowered to a static function -- replace with a reference
            // to the corresponding static object instance.
            val instanceField = useObjectClassInstance(containingDeclaration.parentAsClass)
            extractVariableAccess(instanceField.id, e.type, locId, exprParent.parent, exprParent.idx, callable, exprParent.enclosingStmt).also { varAccessId ->
                extractStaticTypeAccessQualifier(containingDeclaration, varAccessId, locId, callable, exprParent.enclosingStmt)
            }
        } else {
            val id = tw.getFreshIdLabel<DbThisaccess>()

            tw.writeExprs_thisaccess(id, type.javaResult.id, exprParent.parent, exprParent.idx)
            tw.writeExprsKotlinType(id, type.kotlinResult.id)
            tw.writeHasLocation(id, locId)
            tw.writeCallableEnclosingExpr(id, callable)
            tw.writeStatementEnclosingExpr(id, exprParent.enclosingStmt)

            fun extractTypeAccess(parent: IrClass) {
                extractTypeAccessRecursive(parent.typeWith(listOf()), locId, id, 0, callable, exprParent.enclosingStmt)
            }

            val owner = e.symbol.owner
            when(val ownerParent = owner.parent) {
                is IrFunction -> {
                    if (ownerParent.dispatchReceiverParameter == owner &&
                        ownerParent.extensionReceiverParameter != null) {

                        val ownerParent2 = ownerParent.parent
                        if (ownerParent2 is IrClass){
                            extractTypeAccess(ownerParent2)
                        } else {
                            logger.errorElement("Unhandled qualifier for this", e)
                        }
                    }
                }
                is IrClass -> {
                    if (ownerParent.thisReceiver == owner) {
                        extractTypeAccess(ownerParent)
                    }
                }
                else -> {
                    logger.errorElement("Unexpected owner parent for this access: " + ownerParent.javaClass, e)
                }
            }
        }
    }

    private fun extractVariableAccess(variable: Label<out DbVariable>?, irType: IrType, locId: Label<out DbLocation>, parent: Label<out DbExprparent>, idx: Int, callable: Label<out DbCallable>, enclosingStmt: Label<out DbStmt>) =
        tw.getFreshIdLabel<DbVaraccess>().also {
            val type = useType(irType)
            tw.writeExprs_varaccess(it, type.javaResult.id, parent, idx)
            tw.writeExprsKotlinType(it, type.kotlinResult.id)
            tw.writeHasLocation(it, locId)
            tw.writeCallableEnclosingExpr(it, callable)
            tw.writeStatementEnclosingExpr(it, enclosingStmt)

            if (variable != null) {
                tw.writeVariableBinding(it, variable)
            }
        }

    private fun extractLoop(
        loop: IrLoop,
        stmtExprParent: StmtExprParent,
        callable: Label<out DbCallable>
    ) {
        val stmtParent = stmtExprParent.stmt(loop, callable)
        val locId = tw.getLocation(loop)

        val idx: Int
        val parent: Label<out DbStmtparent>

        val label = loop.label
        if (label != null) {
            val labeledStmt = tw.getFreshIdLabel<DbLabeledstmt>()
            tw.writeStmts_labeledstmt(labeledStmt, stmtParent.parent, stmtParent.idx, callable)
            tw.writeHasLocation(labeledStmt, locId)

            tw.writeNamestrings(label, "", labeledStmt)
            idx = 0
            parent = labeledStmt
        } else {
            idx = stmtParent.idx
            parent = stmtParent.parent
        }

        val id = if (loop is IrWhileLoop) {
            val id = tw.getFreshIdLabel<DbWhilestmt>()
            tw.writeStmts_whilestmt(id, parent, idx, callable)
            id
        } else {
            val id = tw.getFreshIdLabel<DbDostmt>()
            tw.writeStmts_dostmt(id, parent, idx, callable)
            id
        }

        tw.writeHasLocation(id, locId)
        extractExpressionExpr(loop.condition, callable, id, 0, id)
        val body = loop.body
        if (body != null) {
            extractExpressionStmt(body, callable, id, 1)
        }
    }

    private fun IrValueParameter.isExtensionReceiver(): Boolean {
        val parentFun = parent as? IrFunction ?: return false
        return parentFun.extensionReceiverParameter == this
    }

    private open inner class GeneratedClassHelper(protected val locId: Label<DbLocation>, protected val ids: GeneratedClassLabels) {
        protected val classId = ids.type.javaResult.id.cast<DbClass>()

        fun writeExpressionMetadataToTrapFile(id: Label<out DbExpr>, callable: Label<out DbCallable>, stmt: Label<out DbStmt>) {
            tw.writeHasLocation(id, locId)
            tw.writeCallableEnclosingExpr(id, callable)
            tw.writeStatementEnclosingExpr(id, stmt)
        }

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
            val paramTypeRes = extractValueParameter(paramId, paramType, paramName, locId, ids.constructor, paramIdx, paramId, isVararg = false, syntheticParameterNames = false)

            val assignmentStmtId = tw.getFreshIdLabel<DbExprstmt>()
            tw.writeStmts_exprstmt(assignmentStmtId, ids.constructorBlock, stmtIdx, ids.constructor)
            tw.writeHasLocation(assignmentStmtId, locId)

            val assignmentId = tw.getFreshIdLabel<DbAssignexpr>()
            tw.writeExprs_assignexpr(assignmentId, paramTypeRes.javaResult.id, assignmentStmtId, 0)
            tw.writeExprsKotlinType(assignmentId, paramTypeRes.kotlinResult.id)
            writeExpressionMetadataToTrapFile(assignmentId, ids.constructor, assignmentStmtId)

            val lhsId = tw.getFreshIdLabel<DbVaraccess>()
            tw.writeExprs_varaccess(lhsId, paramTypeRes.javaResult.id, assignmentId, 0)
            tw.writeExprsKotlinType(lhsId, paramTypeRes.kotlinResult.id)
            tw.writeVariableBinding(lhsId, fieldId)
            writeExpressionMetadataToTrapFile(lhsId, ids.constructor, assignmentStmtId)

            val thisId = tw.getFreshIdLabel<DbThisaccess>()
            tw.writeExprs_thisaccess(thisId, ids.type.javaResult.id, lhsId, -1)
            tw.writeExprsKotlinType(thisId, ids.type.kotlinResult.id)
            writeExpressionMetadataToTrapFile(thisId, ids.constructor, assignmentStmtId)

            val rhsId = tw.getFreshIdLabel<DbVaraccess>()
            tw.writeExprs_varaccess(rhsId, paramTypeRes.javaResult.id, assignmentId, 1)
            tw.writeExprsKotlinType(rhsId, paramTypeRes.kotlinResult.id)
            tw.writeVariableBinding(rhsId, paramId)
            writeExpressionMetadataToTrapFile(rhsId, ids.constructor, assignmentStmtId)
        }
    }

    data class ReceiverInfo(val receiver: IrExpression, val type: IrType, val field: Label<DbField>, val indexOffset: Int)

    private fun makeReceiverInfo(callableReferenceExpr: IrCallableReference<out IrSymbol>, receiver: IrExpression?, indexOffset: Int): ReceiverInfo? {
        if (receiver == null) {
            return null
        }
        val type = receiver.type
        if (type == null) {
            logger.warnElement("Receiver has no type", callableReferenceExpr)
            return null
        }
        val field: Label<DbField> = tw.getFreshIdLabel()
        return ReceiverInfo(receiver, type, field, indexOffset)
    }

    /**
     * This is used when extracting callable references,
     * i.e. `::someCallable` or `::someReceiver::someCallable`.
     */
    private open inner class CallableReferenceHelper(protected val callableReferenceExpr: IrCallableReference<out IrSymbol>, locId: Label<DbLocation>, ids: GeneratedClassLabels)
        : GeneratedClassHelper(locId, ids) {

        // Only one of the receivers can be non-null, but we defensively handle the case when both are null anyway
        private val dispatchReceiverInfo = makeReceiverInfo(callableReferenceExpr, callableReferenceExpr.dispatchReceiver, 0)
        private val extensionReceiverInfo = makeReceiverInfo(callableReferenceExpr, callableReferenceExpr.extensionReceiver, if (dispatchReceiverInfo == null) 0 else 1)

        fun extractReceiverField() {
            val firstAssignmentStmtIdx = 1

            if (dispatchReceiverInfo != null) {
                extractField(dispatchReceiverInfo.field, "<dispatchReceiver>", dispatchReceiverInfo.type, classId, locId, DescriptorVisibilities.PRIVATE, callableReferenceExpr, isExternalDeclaration = false, isFinal = true)
                extractParameterToFieldAssignmentInConstructor("<dispatchReceiver>", dispatchReceiverInfo.type, dispatchReceiverInfo.field, 0 + dispatchReceiverInfo.indexOffset, firstAssignmentStmtIdx + dispatchReceiverInfo.indexOffset)
            }

            if (extensionReceiverInfo != null) {
                extractField(extensionReceiverInfo.field, "<extensionReceiver>", extensionReceiverInfo.type, classId, locId, DescriptorVisibilities.PRIVATE, callableReferenceExpr, isExternalDeclaration = false, isFinal = true)
                extractParameterToFieldAssignmentInConstructor( "<extensionReceiver>", extensionReceiverInfo.type, extensionReceiverInfo.field, 0 + extensionReceiverInfo.indexOffset, firstAssignmentStmtIdx + extensionReceiverInfo.indexOffset)
            }
        }

        protected fun writeVariableAccessInFunctionBody(pType: TypeResults, idx: Int, variable: Label<out DbVariable>,
                                                      parent: Label<out DbExprparent>, callable: Label<out DbCallable>, stmt: Label<out DbStmt>
        ): Label<DbVaraccess> {
            val pId = tw.getFreshIdLabel<DbVaraccess>()
            tw.writeExprs_varaccess(pId, pType.javaResult.id, parent, idx)
            tw.writeExprsKotlinType(pId, pType.kotlinResult.id)
            tw.writeVariableBinding(pId, variable)
            writeExpressionMetadataToTrapFile(pId, callable, stmt)
            return pId
        }

        private fun writeFieldAccessInFunctionBody(pType: IrType, idx: Int, variable: Label<out DbField>,
                                                   parent: Label<out DbExprparent>, callable: Label<out DbCallable>, stmt: Label<out DbStmt>) {
            val accessId = writeVariableAccessInFunctionBody(useType(pType), idx, variable, parent, callable, stmt)
            writeThisAccess(accessId, callable, stmt)
        }

        protected fun writeThisAccess(parent: Label<out DbExprparent>, callable: Label<out DbCallable>, stmt: Label<out DbStmt>) {
            val thisId = tw.getFreshIdLabel<DbThisaccess>()
            tw.writeExprs_thisaccess(thisId, ids.type.javaResult.id, parent, -1)
            tw.writeExprsKotlinType(thisId, ids.type.kotlinResult.id)
            writeExpressionMetadataToTrapFile(thisId, callable, stmt)
        }

        fun extractFieldWriteOfReflectionTarget(
            labels: FunctionLabels,         // labels of the containing function
            target: IrFieldSymbol,          // the target field being accessed)
        ) {
            // ...;
            val exprStmtId = tw.getFreshIdLabel<DbExprstmt>()
            tw.writeStmts_exprstmt(exprStmtId, labels.blockId, 0, labels.methodId)
            tw.writeHasLocation(exprStmtId, locId)

            val fieldType = useType(target.owner.type)

            // ... = ...
            val assignExprId = tw.getFreshIdLabel<DbAssignexpr>()
            tw.writeExprs_assignexpr(assignExprId, fieldType.javaResult.id, exprStmtId, 0)
            tw.writeExprsKotlinType(assignExprId, fieldType.kotlinResult.id)
            writeExpressionMetadataToTrapFile(assignExprId, labels.methodId, exprStmtId)

            // LHS
            extractFieldAccess(fieldType, assignExprId, exprStmtId, labels, target)

            // RHS
            val p = labels.parameters.first()
            writeVariableAccessInFunctionBody(p.second, 1, p.first, assignExprId, labels.methodId, exprStmtId)
        }

        fun extractFieldReturnOfReflectionTarget(
            labels: FunctionLabels,         // labels of the containing function
            target: IrFieldSymbol,          // the target field being accessed
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

            writeExpressionMetadataToTrapFile(accessId, labels.methodId, stmt)

            val fieldId = useField(target.owner)
            tw.writeVariableBinding(accessId, fieldId)

            if (dispatchReceiverInfo != null) {
                writeFieldAccessInFunctionBody(dispatchReceiverInfo.type, -1, dispatchReceiverInfo.field, accessId, labels.methodId, stmt)
            }
        }

        /**
         * Extracts a call to `target` inside the function identified by `labels`. Special parameters (`dispatch` and `extension`) are also handled.
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
         * - big arity function references need to call `invoke` with arguments received in an object array: `fn(param1[0] as T0, param1[1] as T1, ...)`
         */
        fun extractCallToReflectionTarget(
            labels: FunctionLabels,         // labels of the containing function
            target: IrFunctionSymbol,       // the target function/constructor being called
            returnType: IrType,             // the return type of the called function. Note that `target.owner.returnType` and `returnType` doesn't match for generic functions
            expressionTypeArgs: List<IrType>,                           // type arguments of the extracted expression
            classTypeArgsIncludingOuterClasses: List<IrTypeArgument>?,  // type arguments of the class containing the callable reference
            dispatchReceiverIdx: Int = -1,                              // dispatch receiver index: -1 in case of functions, -2 for constructors
            bigArityParameterTypes: List<IrType>? = null                // parameter types used for the cast expressions in a big arity `invoke` invocation. null if not a big arity invocation.
        ) {
            // Return statement of generated function:
            val retId = tw.getFreshIdLabel<DbReturnstmt>()
            tw.writeStmts_returnstmt(retId, labels.blockId, 0, labels.methodId)
            tw.writeHasLocation(retId, locId)

            // Call to target function:
            val callType = useType(returnType)

            val callId: Label<out DbExpr> = if (target is IrConstructorSymbol) {
                val callId = tw.getFreshIdLabel<DbNewexpr>()
                tw.writeExprs_newexpr(callId, callType.javaResult.id, retId, 0)
                tw.writeExprsKotlinType(callId, callType.kotlinResult.id)

                extractConstructorTypeAccess(returnType, callType, target, locId, callId, -3, labels.methodId, retId)
                callId
            } else {
                val callId = tw.getFreshIdLabel<DbMethodaccess>()
                tw.writeExprs_methodaccess(callId, callType.javaResult.id, retId, 0)
                tw.writeExprsKotlinType(callId, callType.kotlinResult.id)
                extractTypeArguments(expressionTypeArgs, locId, callId, labels.methodId, retId, -2, true)
                callId
            }

            writeExpressionMetadataToTrapFile(callId, labels.methodId, retId)

            val callableId = useFunction<DbCallable>(target.owner.realOverrideTarget, classTypeArgsIncludingOuterClasses)
            tw.writeCallableBinding(callId.cast<DbCaller>(), callableId)

            val useFirstArgAsDispatch: Boolean
            if (dispatchReceiverInfo != null) {
                writeFieldAccessInFunctionBody(dispatchReceiverInfo.type, dispatchReceiverIdx, dispatchReceiverInfo.field, callId, labels.methodId, retId)

                useFirstArgAsDispatch = false
            } else {
                if (target.owner.isLocalFunction()) {
                    val ids = getLocallyVisibleFunctionLabels(target.owner)
                    extractNewExprForLocalFunction(ids, callId, locId, labels.methodId, retId)
                    useFirstArgAsDispatch = false
                }
                else {
                    useFirstArgAsDispatch = target.owner.dispatchReceiverParameter != null

                    if (isStaticFunction(target.owner)) {
                        extractStaticTypeAccessQualifier(target.owner, callId, locId, labels.methodId, retId)
                    }
                }
            }

            val extensionIdxOffset: Int
            if (extensionReceiverInfo != null) {
                writeFieldAccessInFunctionBody(extensionReceiverInfo.type, 0, extensionReceiverInfo.field, callId, labels.methodId, retId)
                extensionIdxOffset = 1
            } else {
                extensionIdxOffset = 0
            }

            if (bigArityParameterTypes != null) {
                // In case we're extracting a big arity function reference:
                addArgumentsToInvocationInInvokeNBody(
                    bigArityParameterTypes, labels, retId, callId, locId,
                    { exp -> writeExpressionMetadataToTrapFile(exp, labels.methodId, retId) },
                    extensionIdxOffset, useFirstArgAsDispatch, dispatchReceiverIdx)
            } else {
                val dispatchIdxOffset = if (useFirstArgAsDispatch) 1 else 0
                for ((pIdx, p) in labels.parameters.withIndex()) {
                    val childIdx = if (pIdx == 0 && useFirstArgAsDispatch) {
                        dispatchReceiverIdx
                    } else {
                        pIdx + extensionIdxOffset - dispatchIdxOffset
                    }
                    writeVariableAccessInFunctionBody(p.second, childIdx, p.first, callId, labels.methodId, retId)
                }
            }
        }

        fun extractConstructorArguments(
            callable: Label<out DbCallable>,
            idCtorRef: Label<out DbClassinstancexpr>,
            enclosingStmt: Label<out DbStmt>
        ) {
            if (dispatchReceiverInfo != null) {
                extractExpressionExpr(dispatchReceiverInfo.receiver, callable, idCtorRef, 0 + dispatchReceiverInfo.indexOffset, enclosingStmt)
            }

            if (extensionReceiverInfo != null) {
                extractExpressionExpr(extensionReceiverInfo.receiver, callable, idCtorRef, 0 + extensionReceiverInfo.indexOffset, enclosingStmt)
            }
        }
    }

    private inner class PropertyReferenceHelper(callableReferenceExpr: IrCallableReference<out IrSymbol>, locId: Label<DbLocation>, ids: GeneratedClassLabels)
        : CallableReferenceHelper(callableReferenceExpr, locId, ids) {

        fun extractPropertyReferenceInvoke(
            getId: Label<DbMethod>,
            getterParameterTypes: List<IrType>,
            getterReturnType: IrType
        ) {
            // Extracting this method is not (strictly) needed for interface member implementation.
            // `[Mutable]PropertyReferenceX` already implements it, but its signature doesn't match the
            // generic one, because it's a raw method implementation. Also, by adding the `invoke` explicitly,
            // we have better data flow analysis support.
            val invokeLabels = addFunctionManual(tw.getFreshIdLabel(), OperatorNameConventions.INVOKE.asString(), getterParameterTypes, getterReturnType, classId, locId)

            // return this.get(a0, a1, ...)
            val retId = tw.getFreshIdLabel<DbReturnstmt>()
            tw.writeStmts_returnstmt(retId, invokeLabels.blockId, 0, invokeLabels.methodId)
            tw.writeHasLocation(retId, locId)

            // Call to target function:
            val callType = useType(getterReturnType)
            val callId = tw.getFreshIdLabel<DbMethodaccess>()
            tw.writeExprs_methodaccess(callId, callType.javaResult.id, retId, 0)
            tw.writeExprsKotlinType(callId, callType.kotlinResult.id)
            this.writeExpressionMetadataToTrapFile(callId, invokeLabels.methodId, retId)

            tw.writeCallableBinding(callId, getId)

            this.writeThisAccess(callId, invokeLabels.methodId, retId)
            for ((pIdx, p) in invokeLabels.parameters.withIndex()) {
                this.writeVariableAccessInFunctionBody(p.second, pIdx, p.first, callId, invokeLabels.methodId, retId)
            }
        }
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
             *   fun get(): R { return this.dispatchReceiver.FN1() }
             *
             *   fun set(a0: R): Unit { return this.dispatchReceiver.FN2(a0) }
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
                logger.errorElement("Unexpected: property reference with non simple type. ${kPropertyType.classFqName?.asString()}", propertyReferenceExpr)
                return
            }
            val kPropertyClass = kPropertyType.classOrNull
            if (kPropertyClass == null) {
                logger.errorElement("Cannot find class for kPropertyType. ${kPropertyType.classFqName?.asString()}", propertyReferenceExpr)
                return
            }
            val parameterTypes = kPropertyType.arguments.map { it as? IrType }.requireNoNullsOrNull()
            if (parameterTypes == null) {
                logger.errorElement("Unexpected: Non-IrType parameter.", propertyReferenceExpr)
                return
            }

            val locId = tw.getLocation(propertyReferenceExpr)

            val javaResult = TypeResult(tw.getFreshIdLabel<DbClass>(), "", "")
            val kotlinResult = TypeResult(tw.getFreshIdLabel<DbKt_notnull_type>(), "", "")
            tw.writeKt_notnull_types(kotlinResult.id, javaResult.id)
            val ids = GeneratedClassLabels(
                TypeResults(javaResult, kotlinResult),
                constructor = tw.getFreshIdLabel(),
                constructorBlock = tw.getFreshIdLabel()
            )

            val currentDeclaration = declarationStack.peek()
            val prefix = if (kPropertyClass.owner.name.asString().startsWith("KMutableProperty")) "Mutable" else ""
            val baseClass = pluginContext.referenceClass(FqName("kotlin.jvm.internal.${prefix}PropertyReference${kPropertyType.arguments.size - 1}"))?.owner?.typeWith()
                ?: pluginContext.irBuiltIns.anyType

            val classId = extractGeneratedClass(ids, listOf(baseClass, kPropertyType), locId, currentDeclaration)

            val helper = PropertyReferenceHelper(propertyReferenceExpr, locId, ids)

            helper.extractReceiverField()

            val classTypeArguments = (propertyReferenceExpr.dispatchReceiver?.type as? IrSimpleType)?.arguments ?:
                if ((getter?.owner?.dispatchReceiverParameter ?: setter?.owner?.dispatchReceiverParameter )!= null) { (kPropertyType.arguments.first() as? IrSimpleType)?.arguments } else { null }

            val expressionTypeArguments = (0 until propertyReferenceExpr.typeArgumentsCount).mapNotNull { propertyReferenceExpr.getTypeArgument(it) }

            val idPropertyRef = tw.getFreshIdLabel<DbPropertyref>()

            val getterParameterTypes = parameterTypes.dropLast(1)
            val getterReturnType = parameterTypes.last()

            if (getter != null) {
                val getLabels = addFunctionManual(tw.getFreshIdLabel(), OperatorNameConventions.GET.asString(), getterParameterTypes, getterReturnType, classId, locId)
                val getterCallableId = useFunction<DbCallable>(getter.owner.realOverrideTarget, classTypeArguments)

                helper.extractCallToReflectionTarget(
                    getLabels,
                    getter,
                    getterReturnType,
                    expressionTypeArguments,
                    classTypeArguments
                )

                tw.writePropertyRefGetBinding(idPropertyRef, getterCallableId)

                helper.extractPropertyReferenceInvoke(getLabels.methodId, getterParameterTypes, getterReturnType)
            } else {
                // Property without a getter.
                if (backingField == null) {
                    logger.errorElement("Expected to find getter or backing field for property reference.", propertyReferenceExpr)
                    return
                }

                val getLabels = addFunctionManual(tw.getFreshIdLabel(), OperatorNameConventions.GET.asString(), getterParameterTypes, getterReturnType, classId, locId)
                val fieldId = useField(backingField.owner)

                helper.extractFieldReturnOfReflectionTarget(
                    getLabels,
                    backingField)

                tw.writePropertyRefFieldBinding(idPropertyRef, fieldId)

                helper.extractPropertyReferenceInvoke(getLabels.methodId, getterParameterTypes, getterReturnType)
            }

            if (setter != null) {
                val setLabels = addFunctionManual(tw.getFreshIdLabel(), OperatorNameConventions.SET.asString(), parameterTypes, pluginContext.irBuiltIns.unitType, classId, locId)

                val setterCallableId = useFunction<DbCallable>(setter.owner.realOverrideTarget, classTypeArguments)

                helper.extractCallToReflectionTarget(
                    setLabels,
                    setter,
                    pluginContext.irBuiltIns.unitType,
                    expressionTypeArguments,
                    classTypeArguments
                )

                tw.writePropertyRefSetBinding(idPropertyRef, setterCallableId)
            } else {
                if (backingField != null && !backingField.owner.isFinal) {
                    val setLabels = addFunctionManual(tw.getFreshIdLabel(), OperatorNameConventions.SET.asString(), parameterTypes, pluginContext.irBuiltIns.unitType, classId, locId)
                    val fieldId = useField(backingField.owner)

                    helper.extractFieldWriteOfReflectionTarget(
                        setLabels,
                        backingField)

                    tw.writePropertyRefFieldBinding(idPropertyRef, fieldId)
                }
            }

            // Add constructor (property ref) call:
            val exprParent = parent.expr(propertyReferenceExpr, callable)
            tw.writeExprs_propertyref(idPropertyRef, ids.type.javaResult.id, exprParent.parent, exprParent.idx)
            tw.writeExprsKotlinType(idPropertyRef, ids.type.kotlinResult.id)
            tw.writeHasLocation(idPropertyRef, locId)
            tw.writeCallableEnclosingExpr(idPropertyRef, callable)
            tw.writeStatementEnclosingExpr(idPropertyRef, exprParent.enclosingStmt)
            tw.writeCallableBinding(idPropertyRef, ids.constructor)

            extractTypeAccessRecursive(kPropertyType, locId, idPropertyRef, -3, callable, exprParent.enclosingStmt)

            helper.extractConstructorArguments(callable, idPropertyRef, exprParent.enclosingStmt)

            tw.writeIsAnonymClass(classId, idPropertyRef)
        }
    }

    private fun extractFunctionReference(
        functionReferenceExpr: IrFunctionReference,
        parent: StmtExprParent,
        callable: Label<out DbCallable>
    ) {
        with("function reference", functionReferenceExpr) {
            val target = functionReferenceExpr.reflectionTarget ?: run {
                logger.warnElement("Expected to find reflection target for function reference. Using underlying symbol instead.", functionReferenceExpr)
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

            if (functionReferenceExpr.dispatchReceiver != null && functionReferenceExpr.extensionReceiver != null) {
                logger.errorElement("Unexpected: dispatchReceiver and extensionReceiver are both non-null", functionReferenceExpr)
                return
            }

            if (target.owner.dispatchReceiverParameter != null && target.owner.extensionReceiverParameter != null) {
                logger.errorElement("Unexpected: dispatch and extension parameters are both non-null", functionReferenceExpr)
                return
            }

            val type = functionReferenceExpr.type
            if (type !is IrSimpleType) {
                logger.errorElement("Unexpected: function reference with non simple type. ${type.classFqName?.asString()}", functionReferenceExpr)
                return
            }

            val parameterTypes = type.arguments.map { it as? IrType }.requireNoNullsOrNull()
            if (parameterTypes == null) {
                logger.errorElement("Unexpected: Non-IrType parameter.", functionReferenceExpr)
                return
            }

            val dispatchReceiverIdx: Int
            val expressionTypeArguments: List<IrType>
            val classTypeArguments: List<IrTypeArgument>?

            if (target is IrConstructorSymbol) {
                // In case a constructor is referenced, the return type of the `KFunctionX<,,,>` is the type if the constructed type.
                classTypeArguments = (type.arguments.last() as? IrSimpleType)?.arguments
                expressionTypeArguments = listOf(parameterTypes.last())
                dispatchReceiverIdx = -2
            } else {
                classTypeArguments = (functionReferenceExpr.dispatchReceiver?.type as? IrSimpleType)?.arguments
                    ?: if (target.owner.dispatchReceiverParameter != null) { (type.arguments.first() as? IrSimpleType)?.arguments } else { null }
                expressionTypeArguments = (0 until functionReferenceExpr.typeArgumentsCount).mapNotNull { functionReferenceExpr.getTypeArgument(it) }
                dispatchReceiverIdx = -1
            }

            val locId = tw.getLocation(functionReferenceExpr)

            val javaResult = TypeResult(tw.getFreshIdLabel<DbClass>(), "", "")
            val kotlinResult = TypeResult(tw.getFreshIdLabel<DbKt_notnull_type>(), "", "")
            tw.writeKt_notnull_types(kotlinResult.id, javaResult.id)
            val ids = LocallyVisibleFunctionLabels(
                TypeResults(javaResult, kotlinResult),
                constructor = tw.getFreshIdLabel(),
                function = tw.getFreshIdLabel(),
                constructorBlock = tw.getFreshIdLabel()
            )

            // Add constructor (member ref) call:
            val exprParent = parent.expr(functionReferenceExpr, callable)
            val idMemberRef = tw.getFreshIdLabel<DbMemberref>()
            tw.writeExprs_memberref(idMemberRef, ids.type.javaResult.id, exprParent.parent, exprParent.idx)
            tw.writeExprsKotlinType(idMemberRef, ids.type.kotlinResult.id)
            tw.writeHasLocation(idMemberRef, locId)
            tw.writeCallableEnclosingExpr(idMemberRef, callable)
            tw.writeStatementEnclosingExpr(idMemberRef, exprParent.enclosingStmt)
            tw.writeCallableBinding(idMemberRef, ids.constructor)

            val targetCallableId = useFunction<DbCallable>(target.owner.realOverrideTarget, classTypeArguments)
            tw.writeMemberRefBinding(idMemberRef, targetCallableId)

            val helper = CallableReferenceHelper(functionReferenceExpr, locId, ids)

            val fnInterfaceType = getFunctionalInterfaceTypeWithTypeArgs(type.arguments)
            if (fnInterfaceType == null) {
                logger.warnElement("Cannot find functional interface type for function reference", functionReferenceExpr)
            } else {
                val currentDeclaration = declarationStack.peek()
                // `FunctionReference` base class is required, because that's implementing `KFunction`.
                val baseClass = pluginContext.referenceClass(FqName("kotlin.jvm.internal.FunctionReference"))?.owner?.typeWith()
                    ?: pluginContext.irBuiltIns.anyType

                val classId = extractGeneratedClass(ids, listOf(baseClass, fnInterfaceType), locId, currentDeclaration)

                helper.extractReceiverField()

                val isBigArity = type.arguments.size > BuiltInFunctionArity.BIG_ARITY
                val funLabels = if (isBigArity) {
                    addFunctionNInvoke(ids.function, parameterTypes.last(), classId, locId)
                } else {
                    addFunctionInvoke(ids.function, parameterTypes.dropLast(1), parameterTypes.last(), classId, locId)
                }

                helper.extractCallToReflectionTarget(
                    funLabels,
                    target,
                    parameterTypes.last(),
                    expressionTypeArguments,
                    classTypeArguments,
                    dispatchReceiverIdx,
                    if (isBigArity) parameterTypes.dropLast(1) else null)

                val typeAccessArguments = if (isBigArity) listOf(parameterTypes.last()) else parameterTypes
                if (target is IrConstructorSymbol) {
                    val returnType = typeAccessArguments.last()

                    val typeAccessId = extractTypeAccess(useType(fnInterfaceType, TypeContext.OTHER), locId, idMemberRef, -3, callable, exprParent.enclosingStmt)
                    typeAccessArguments.dropLast(1).forEachIndexed { argIdx, arg ->
                        extractTypeAccessRecursive(arg, locId, typeAccessId, argIdx, callable, exprParent.enclosingStmt, TypeContext.GENERIC_ARGUMENT)
                    }

                    extractConstructorTypeAccess(returnType, useType(returnType), target, locId, typeAccessId, typeAccessArguments.count() - 1, callable, exprParent.enclosingStmt)
                } else {
                    extractTypeAccessRecursive(fnInterfaceType, locId, idMemberRef, -3, callable, exprParent.enclosingStmt)
                }

                helper.extractConstructorArguments(callable, idMemberRef, exprParent.enclosingStmt)

                tw.writeIsAnonymClass(classId, idMemberRef)
            }
        }
    }

    private fun getFunctionalInterfaceType(functionNTypeArguments: List<IrType>): IrSimpleType? {
        if (functionNTypeArguments.size > BuiltInFunctionArity.BIG_ARITY) {
            val funName = "kotlin.jvm.functions.FunctionN"
            val theFun = pluginContext.referenceClass(FqName(funName))
            if (theFun == null) {
                logger.warn("Cannot find $funName for getFunctionalInterfaceType")
                return null
            } else {
                return theFun.typeWith(functionNTypeArguments.last())
            }
        } else {
            return functionN(pluginContext)(functionNTypeArguments.size - 1).typeWith(functionNTypeArguments)
        }
    }

    private fun getFunctionalInterfaceTypeWithTypeArgs(functionNTypeArguments: List<IrTypeArgument>): IrSimpleType? =
        if (functionNTypeArguments.size > BuiltInFunctionArity.BIG_ARITY) {
            val funName = "kotlin.jvm.functions.FunctionN"
            val theFun = pluginContext.referenceClass(FqName(funName))
            if (theFun == null) {
                logger.warn("Cannot find $funName for getFunctionalInterfaceTypeWithTypeArgs")
                null
            } else {
                theFun.typeWithArguments(listOf(functionNTypeArguments.last()))
            }
        } else {
            functionN(pluginContext)(functionNTypeArguments.size - 1).symbol.typeWithArguments(functionNTypeArguments)
        }

    private data class FunctionLabels(
        val methodId: Label<DbMethod>,
        val blockId: Label<DbBlock>,
        val parameters: List<Pair<Label<DbParam>, TypeResults>>)

    /**
     * Adds a function `invoke(a: Any[])` with the specified return type to the class identified by `parentId`.
     */
    private fun addFunctionNInvoke(methodId: Label<DbMethod>, returnType: IrType, parentId: Label<out DbReftype>, locId: Label<DbLocation>): FunctionLabels {
        return addFunctionInvoke(methodId, listOf(pluginContext.irBuiltIns.arrayClass.typeWith(pluginContext.irBuiltIns.anyNType)), returnType, parentId, locId)
    }

    /**
     * Adds a function named `invoke` with the specified parameter types and return type to the class identified by `parentId`.
     */
    private fun addFunctionInvoke(methodId: Label<DbMethod>, parameterTypes: List<IrType>, returnType: IrType, parentId: Label<out DbReftype>, locId: Label<DbLocation>): FunctionLabels {
        return addFunctionManual(methodId, OperatorNameConventions.INVOKE.asString(), parameterTypes, returnType, parentId, locId)
    }

    /**
     * Extracts a function with the given name, parameter types, return type, containing type, and location.
     */
    private fun addFunctionManual(
        methodId: Label<DbMethod>,
        name: String,
        parameterTypes: List<IrType>,
        returnType: IrType,
        parentId: Label<out DbReftype>,
        locId: Label<DbLocation>)
    : FunctionLabels {

        val parameters = parameterTypes.mapIndexed { idx, p ->
            val paramId = tw.getFreshIdLabel<DbParam>()
            val paramType = extractValueParameter(paramId, p, "a$idx", locId, methodId, idx, paramId, isVararg = false, syntheticParameterNames = false)

            Pair(paramId, paramType)
        }

        val paramsSignature = parameters.joinToString(separator = ",", prefix = "(", postfix = ")") { it.second.javaResult.signature }

        val rt = useType(returnType, TypeContext.RETURN)
        tw.writeMethods(methodId, name, "$name$paramsSignature", rt.javaResult.id, parentId, methodId)
        tw.writeMethodsKotlinType(methodId, rt.kotlinResult.id)
        tw.writeHasLocation(methodId, locId)

        addModifiers(methodId, "public")
        addModifiers(methodId, "override")

        // Block
        val blockId = tw.getFreshIdLabel<DbBlock>()
        tw.writeStmts_block(blockId, methodId, 0, methodId)
        tw.writeHasLocation(blockId, locId)

        return FunctionLabels(methodId, blockId, parameters)
    }

    /*
    * This function generates an implementation for `fun kotlin.FunctionN<R>.invoke(vararg args: Any?): R`
    *
    * The following body is added:
    * ```
    * fun invoke(vararg a0: Any?): R {
    *   return invoke(a0[0] as T0, a0[1] as T1, ..., a0[I] as TI)
    * }
    * ```
    * */
    private fun implementFunctionNInvoke(
        lambda: IrFunction,
        ids: LocallyVisibleFunctionLabels,
        locId: Label<DbLocation>,
        parameters: List<IrValueParameter>
    ) {
        val funLabels = addFunctionNInvoke(tw.getFreshIdLabel(), lambda.returnType, ids.type.javaResult.id.cast<DbReftype>(), locId)

        // Return
        val retId = tw.getFreshIdLabel<DbReturnstmt>()
        tw.writeStmts_returnstmt(retId, funLabels.blockId, 0, funLabels.methodId)
        tw.writeHasLocation(retId, locId)

        fun extractCommonExpr(id: Label<out DbExpr>) {
            tw.writeHasLocation(id, locId)
            tw.writeCallableEnclosingExpr(id, funLabels.methodId)
            tw.writeStatementEnclosingExpr(id, retId)
        }

        // Call to original `invoke`:
        val callId = tw.getFreshIdLabel<DbMethodaccess>()
        val callType = useType(lambda.returnType)
        tw.writeExprs_methodaccess(callId, callType.javaResult.id, retId, 0)
        tw.writeExprsKotlinType(callId, callType.kotlinResult.id)
        extractCommonExpr(callId)
        val calledMethodId = useFunction<DbMethod>(lambda)
        tw.writeCallableBinding(callId, calledMethodId)

        // this access
        val thisId = tw.getFreshIdLabel<DbThisaccess>()
        tw.writeExprs_thisaccess(thisId, ids.type.javaResult.id, callId, -1)
        tw.writeExprsKotlinType(thisId, ids.type.kotlinResult.id)
        extractCommonExpr(thisId)

        addArgumentsToInvocationInInvokeNBody(parameters.map { it.type }, funLabels, retId, callId, locId, ::extractCommonExpr)
    }

    /**
     * Adds the arguments to the method call inside `invoke(a0: Any[])`. Each argument is an array access with a cast:
     *
     * ```
     * fun invoke(a0: Any[]) : T {
     *   return fn(a0[0] as T0, a0[1] as T1, ...)
     * }
     * ```
     */
    private fun addArgumentsToInvocationInInvokeNBody(
        parameterTypes: List<IrType>,                   // list of parameter types
        funLabels: FunctionLabels,                      // already generated labels for the function definition
        enclosingStmtId: Label<out DbStmt>,             // label for the enclosing statement (return)
        exprParentId: Label<out DbExprparent>,          // label for the expression parent (call)
        locId: Label<DbLocation>,                       // label for the location of all generated items
        extractCommonExpr: (Label<out DbExpr>) -> Unit, // lambda used for extracting location, enclosing stmt and expr for all new expressions
        firstArgumentOffset: Int = 0,                   // 0 or 1, the index used for the first argument. 1 in case an extension parameter is already accessed at index 0
        useFirstArgAsDispatch: Boolean = false,         // true if the first argument should be used as the dispatch receiver
        dispatchReceiverIdx: Int = -1                   // index of the dispatch receiver. -1 in case of functions, -2 in case of constructors
    ) {
        val intType = useType(pluginContext.irBuiltIns.intType)
        val argsParamType = pluginContext.irBuiltIns.arrayClass.typeWith(pluginContext.irBuiltIns.anyNType)
        val argsType = useType(argsParamType)
        val anyNType = useType(pluginContext.irBuiltIns.anyNType)

        val dispatchIdxOffset = if (useFirstArgAsDispatch) 1 else 0

        for ((pIdx, pType) in parameterTypes.withIndex()) {
            // `a0[i] as Ti` is generated below for each parameter

            val childIdx =
                if (pIdx == 0 && useFirstArgAsDispatch) {
                    dispatchReceiverIdx
                } else {
                    pIdx + firstArgumentOffset - dispatchIdxOffset
                }

            // cast: `(Ti)a0[i]`
            val castId = tw.getFreshIdLabel<DbCastexpr>()
            val type = useType(pType)
            tw.writeExprs_castexpr(castId, type.javaResult.id, exprParentId, childIdx)
            tw.writeExprsKotlinType(castId, type.kotlinResult.id)
            extractCommonExpr(castId)

            // type access `Ti`
            extractTypeAccessRecursive(pType, locId, castId, 0, funLabels.methodId, enclosingStmtId)

            // element access: `a0[i]`
            val arrayAccessId = tw.getFreshIdLabel<DbArrayaccess>()
            tw.writeExprs_arrayaccess(arrayAccessId, anyNType.javaResult.id, castId, 1)
            tw.writeExprsKotlinType(arrayAccessId, anyNType.kotlinResult.id)
            extractCommonExpr(arrayAccessId)

            // parameter access: `a0`
            val argsAccessId = tw.getFreshIdLabel<DbVaraccess>()
            tw.writeExprs_varaccess(argsAccessId, argsType.javaResult.id, arrayAccessId, 0)
            tw.writeExprsKotlinType(argsAccessId, argsType.kotlinResult.id)
            extractCommonExpr(argsAccessId)
            tw.writeVariableBinding(argsAccessId, funLabels.parameters.first().first)

            // index access: `i`
            val indexId = tw.getFreshIdLabel<DbIntegerliteral>()
            tw.writeExprs_integerliteral(indexId, intType.javaResult.id, arrayAccessId, 1)
            tw.writeExprsKotlinType(indexId, intType.kotlinResult.id)
            extractCommonExpr(indexId)
            tw.writeNamestrings(pIdx.toString(), pIdx.toString(), indexId)
        }
    }

    private fun extractVarargElement(e: IrVarargElement, callable: Label<out DbCallable>, parent: Label<out DbExprparent>, idx: Int, enclosingStmt: Label<out DbStmt>) {
        with("vararg element", e) {
            val argExpr = when(e) {
                is IrExpression -> e
                is IrSpreadElement -> e.expression
                else -> {
                    logger.errorElement("Unrecognised IrVarargElement: " + e.javaClass, e)
                    null
                }
            }
            argExpr?.let {
                extractExpressionExpr(it, callable, parent, idx, enclosingStmt)
            }
        }
    }

    /**
     * Extracts a type access expression and its generic arguments for a constructor call.
     * It only extracts type arguments relating to the constructed type, not the constructor itself, which makes a
     * difference in case of nested generics.
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
        val typeAccessId = extractTypeAccess(type, locId, parent, idx, enclosingCallable, enclosingStmt)
        if (irType is IrSimpleType) {
            extractTypeArguments(irType.arguments.take(target.owner.parentAsClass.typeParameters.size).filterIsInstance<IrType>(),
                locId, typeAccessId, enclosingCallable, enclosingStmt)
        }
    }

    /**
     * Extracts a single wildcard type access expression with no enclosing callable and statement.
     */
    private fun extractWildcardTypeAccess(type: TypeResultsWithoutSignatures, location: Label<out DbLocation>, parent: Label<out DbExprparent>, idx: Int): Label<out DbExpr> {
        val id = tw.getFreshIdLabel<DbWildcardtypeaccess>()
        tw.writeExprs_wildcardtypeaccess(id, type.javaResult.id, parent, idx)
        tw.writeExprsKotlinType(id, type.kotlinResult.id)
        tw.writeHasLocation(id, location)
        return id
    }

    /**
     * Extracts a single type access expression with no enclosing callable and statement.
     */
    private fun extractTypeAccess(type: TypeResults, location: Label<out DbLocation>, parent: Label<out DbExprparent>, idx: Int): Label<out DbExpr> {
        // TODO: elementForLocation allows us to give some sort of
        //   location, but a proper location for the type access will
        //   require upstream changes
        val id = tw.getFreshIdLabel<DbUnannotatedtypeaccess>()
        tw.writeExprs_unannotatedtypeaccess(id, type.javaResult.id, parent, idx)
        tw.writeExprsKotlinType(id, type.kotlinResult.id)
        tw.writeHasLocation(id, location)
        return id
    }

    /**
     * Extracts a single type access expression with enclosing callable and statement.
     */
    private fun extractTypeAccess(type: TypeResults, location: Label<DbLocation>, parent: Label<out DbExprparent>, idx: Int, enclosingCallable: Label<out DbCallable>, enclosingStmt: Label<out DbStmt>): Label<out DbExpr> {
        val id = extractTypeAccess(type, location, parent, idx)
        tw.writeCallableEnclosingExpr(id, enclosingCallable)
        tw.writeStatementEnclosingExpr(id, enclosingStmt)
        return id
    }

    /**
     * Extracts a type argument type access, introducing a wildcard type access if appropriate, or directly calling
     * `extractTypeAccessRecursive` if the argument is invariant.
     * No enclosing callable and statement is extracted, this is useful for type access extraction in field declarations.
     */
    private fun extractWildcardTypeAccessRecursive(t: IrTypeArgument, location: Label<out DbLocation>, parent: Label<out DbExprparent>, idx: Int) {
        val typeLabels by lazy { TypeResultsWithoutSignatures(getTypeArgumentLabel(t), TypeResultWithoutSignature(fakeKotlinType(), Unit, "TODO")) }
        when (t) {
            is IrStarProjection -> extractWildcardTypeAccess(typeLabels, location, parent, idx)
            is IrTypeProjection -> when(t.variance) {
                Variance.INVARIANT -> extractTypeAccessRecursive(t.type, location, parent, idx, TypeContext.GENERIC_ARGUMENT)
                else -> {
                    val wildcardLabel = extractWildcardTypeAccess(typeLabels, location, parent, idx)
                    // Mimic a Java extractor oddity, that it uses the child index to indicate what kind of wildcard this is
                    val boundChildIdx = if (t.variance == Variance.OUT_VARIANCE) 0 else 1
                    extractTypeAccessRecursive(t.type, location, wildcardLabel, boundChildIdx, TypeContext.GENERIC_ARGUMENT)
                }
            }
        }
    }

    /**
     * Extracts a type access expression and its child type access expressions in case of a generic type. Nested generics are also handled.
     * No enclosing callable and statement is extracted, this is useful for type access extraction in field declarations.
     */
    private fun extractTypeAccessRecursive(t: IrType, location: Label<out DbLocation>, parent: Label<out DbExprparent>, idx: Int, typeContext: TypeContext = TypeContext.OTHER): Label<out DbExpr> {
        val typeAccessId = extractTypeAccess(useType(t, typeContext), location, parent, idx)
        if (t is IrSimpleType) {
            t.arguments.forEachIndexed { argIdx, arg ->
                extractWildcardTypeAccessRecursive(arg, location, typeAccessId, argIdx)
            }
        }
        return typeAccessId
    }

    /**
     * Extracts a type access expression and its child type access expressions in case of a generic type. Nested generics are also handled.
     */
    private fun extractTypeAccessRecursive(t: IrType, location: Label<DbLocation>, parent: Label<out DbExprparent>, idx: Int, enclosingCallable: Label<out DbCallable>, enclosingStmt: Label<out DbStmt>, typeContext: TypeContext = TypeContext.OTHER): Label<out DbExpr> {
        // TODO: `useType` substitutes types to their java equivalent, and sometimes that also means changing the number of type arguments. The below logic doesn't take this into account.
        // For example `KFunction2<Int,Double,String>` becomes `KFunction<String>` with three child type access expressions: `Int`, `Double`, `String`.
        val typeAccessId = extractTypeAccess(useType(t, typeContext), location, parent, idx, enclosingCallable, enclosingStmt)
        if (t is IrSimpleType) {
            extractTypeArguments(t.arguments.filterIsInstance<IrType>(), location, typeAccessId, enclosingCallable, enclosingStmt)
        }
        return typeAccessId
    }

    /**
     * Extracts a list of types as type access expressions. Nested generics are also handled.
     * Used for extracting nested type access expressions, and type arguments of constructor or function calls.
     */
    private fun extractTypeArguments(
        typeArgs: List<IrType>,
        location: Label<DbLocation>,
        parentExpr: Label<out DbExprparent>,
        enclosingCallable: Label<out DbCallable>,
        enclosingStmt: Label<out DbStmt>,
        startIndex: Int = 0,
        reverse: Boolean = false
    ) {
        typeArgs.forEachIndexed { argIdx, arg ->
            val mul = if (reverse) -1 else 1
            extractTypeAccessRecursive(arg, location, parentExpr, argIdx * mul + startIndex, enclosingCallable, enclosingStmt, TypeContext.GENERIC_ARGUMENT)
        }
    }

    /**
     * Extracts type arguments of a member access expression as type access expressions. Nested generics are also handled.
     * Used for extracting nested type access expressions, and type arguments of constructor or function calls.
     */
    private fun <T : IrSymbol> extractTypeArguments(
        c: IrMemberAccessExpression<T>,
        parentExpr: Label<out DbExprparent>,
        enclosingCallable: Label<out DbCallable>,
        enclosingStmt: Label<out DbStmt>,
        startIndex: Int = 0,
        reverse: Boolean = false
    ) {
        val typeArguments = (0 until c.typeArgumentsCount).map { c.getTypeArgument(it) }.requireNoNullsOrNull()
        if (typeArguments == null) {
            logger.errorElement("Found a null type argument for a member access expression", c)
        } else {
            extractTypeArguments(typeArguments, tw.getLocation(c), parentExpr, enclosingCallable, enclosingStmt, startIndex, reverse)
        }
    }

    private fun extractArrayCreationWithInitializer(
        parent: Label<out DbExprparent>,
        arraySize: Int,
        locId: Label<DbLocation>,
        enclosingCallable: Label<out DbCallable>,
        enclosingStmt: Label<out DbStmt>
    ) : Label<DbArrayinit> {

        fun extractCommonExpr(id: Label<out DbExpr>) {
            tw.writeHasLocation(id, locId)
            tw.writeCallableEnclosingExpr(id, enclosingCallable)
            tw.writeStatementEnclosingExpr(id, enclosingStmt)
        }

        val arrayCreationId = tw.getFreshIdLabel<DbArraycreationexpr>()
        val arrayType = pluginContext.irBuiltIns.arrayClass.typeWith(pluginContext.irBuiltIns.anyNType)
        val at = useType(arrayType)
        tw.writeExprs_arraycreationexpr(arrayCreationId, at.javaResult.id, parent, 0)
        tw.writeExprsKotlinType(arrayCreationId, at.kotlinResult.id)
        extractCommonExpr(arrayCreationId)

        extractTypeAccessRecursive(pluginContext.irBuiltIns.anyNType, locId, arrayCreationId, -1, enclosingCallable, enclosingStmt)

        val initId = tw.getFreshIdLabel<DbArrayinit>()
        tw.writeExprs_arrayinit(initId, at.javaResult.id, arrayCreationId, -2)
        tw.writeExprsKotlinType(initId, at.kotlinResult.id)
        extractCommonExpr(initId)

        val dim = arraySize.toString()
        val dimId = tw.getFreshIdLabel<DbIntegerliteral>()
        val dimType = useType(pluginContext.irBuiltIns.intType)
        tw.writeExprs_integerliteral(dimId, dimType.javaResult.id, arrayCreationId, 0)
        tw.writeExprsKotlinType(dimId, dimType.kotlinResult.id)
        extractCommonExpr(dimId)
        tw.writeNamestrings(dim, dim, dimId)

        return initId
    }

    private fun extractTypeOperatorCall(e: IrTypeOperatorCall, callable: Label<out DbCallable>, parent: Label<out DbExprparent>, idx: Int, enclosingStmt: Label<out DbStmt>) {
        with("type operator call", e) {
            when(e.operator) {
                IrTypeOperator.CAST -> {
                    val id = tw.getFreshIdLabel<DbCastexpr>()
                    val locId = tw.getLocation(e)
                    val type = useType(e.type)
                    tw.writeExprs_castexpr(id, type.javaResult.id, parent, idx)
                    tw.writeExprsKotlinType(id, type.kotlinResult.id)
                    tw.writeHasLocation(id, locId)
                    tw.writeCallableEnclosingExpr(id, callable)
                    tw.writeStatementEnclosingExpr(id, enclosingStmt)
                    extractTypeAccessRecursive(e.typeOperand, locId, id, 0, callable, enclosingStmt)
                    extractExpressionExpr(e.argument, callable, id, 1, enclosingStmt)
                }
                IrTypeOperator.IMPLICIT_CAST -> {
                    val id = tw.getFreshIdLabel<DbImplicitcastexpr>()
                    val locId = tw.getLocation(e)
                    val type = useType(e.type)
                    tw.writeExprs_implicitcastexpr(id, type.javaResult.id, parent, idx)
                    tw.writeExprsKotlinType(id, type.kotlinResult.id)
                    tw.writeHasLocation(id, locId)
                    tw.writeCallableEnclosingExpr(id, callable)
                    tw.writeStatementEnclosingExpr(id, enclosingStmt)
                    extractTypeAccessRecursive(e.typeOperand, locId, id, 0, callable, enclosingStmt)
                    extractExpressionExpr(e.argument, callable, id, 1, enclosingStmt)
                }
                IrTypeOperator.IMPLICIT_NOTNULL -> {
                    val id = tw.getFreshIdLabel<DbImplicitnotnullexpr>()
                    val locId = tw.getLocation(e)
                    val type = useType(e.type)
                    tw.writeExprs_implicitnotnullexpr(id, type.javaResult.id, parent, idx)
                    tw.writeExprsKotlinType(id, type.kotlinResult.id)
                    tw.writeHasLocation(id, locId)
                    tw.writeCallableEnclosingExpr(id, callable)
                    tw.writeStatementEnclosingExpr(id, enclosingStmt)
                    extractTypeAccessRecursive(e.typeOperand, locId, id, 0, callable, enclosingStmt)
                    extractExpressionExpr(e.argument, callable, id, 1, enclosingStmt)
                }
                IrTypeOperator.IMPLICIT_COERCION_TO_UNIT -> {
                    val id = tw.getFreshIdLabel<DbImplicitcoerciontounitexpr>()
                    val locId = tw.getLocation(e)
                    val type = useType(e.type)
                    tw.writeExprs_implicitcoerciontounitexpr(id, type.javaResult.id, parent, idx)
                    tw.writeExprsKotlinType(id, type.kotlinResult.id)
                    tw.writeHasLocation(id, locId)
                    tw.writeCallableEnclosingExpr(id, callable)
                    tw.writeStatementEnclosingExpr(id, enclosingStmt)
                    extractTypeAccessRecursive(e.typeOperand, locId, id, 0, callable, enclosingStmt)
                    extractExpressionExpr(e.argument, callable, id, 1, enclosingStmt)
                }
                IrTypeOperator.SAFE_CAST -> {
                    val id = tw.getFreshIdLabel<DbSafecastexpr>()
                    val locId = tw.getLocation(e)
                    val type = useType(e.type)
                    tw.writeExprs_safecastexpr(id, type.javaResult.id, parent, idx)
                    tw.writeExprsKotlinType(id, type.kotlinResult.id)
                    tw.writeHasLocation(id, locId)
                    tw.writeCallableEnclosingExpr(id, callable)
                    tw.writeStatementEnclosingExpr(id, enclosingStmt)
                    extractTypeAccessRecursive(e.typeOperand, locId, id, 0, callable, enclosingStmt)
                    extractExpressionExpr(e.argument, callable, id, 1, enclosingStmt)
                }
                IrTypeOperator.INSTANCEOF -> {
                    val id = tw.getFreshIdLabel<DbInstanceofexpr>()
                    val locId = tw.getLocation(e)
                    val type = useType(e.type)
                    tw.writeExprs_instanceofexpr(id, type.javaResult.id, parent, idx)
                    tw.writeExprsKotlinType(id, type.kotlinResult.id)
                    tw.writeHasLocation(id, locId)
                    tw.writeCallableEnclosingExpr(id, callable)
                    tw.writeStatementEnclosingExpr(id, enclosingStmt)
                    extractExpressionExpr(e.argument, callable, id, 0, enclosingStmt)
                    extractTypeAccessRecursive(e.typeOperand, locId, id, 1, callable, enclosingStmt)
                }
                IrTypeOperator.NOT_INSTANCEOF -> {
                    val id = tw.getFreshIdLabel<DbNotinstanceofexpr>()
                    val locId = tw.getLocation(e)
                    val type = useType(e.type)
                    tw.writeExprs_notinstanceofexpr(id, type.javaResult.id, parent, idx)
                    tw.writeExprsKotlinType(id, type.kotlinResult.id)
                    tw.writeHasLocation(id, locId)
                    tw.writeCallableEnclosingExpr(id, callable)
                    tw.writeStatementEnclosingExpr(id, enclosingStmt)
                    extractExpressionExpr(e.argument, callable, id, 0, enclosingStmt)
                    extractTypeAccessRecursive(e.typeOperand, locId, id, 1, callable, enclosingStmt)
                }
                IrTypeOperator.SAM_CONVERSION -> {

                    /*
                       The following Kotlin code

                       ```
                       fun interface IntPredicate {
                           fun accept(i: Int): Boolean
                       }

                       val x = IntPredicate { it % 2 == 0 }
                       ```

                       is extracted as

                       ```
                       interface IntPredicate {
                           Boolean accept(Integer i);
                       }
                       class <Anon> extends Object implements IntPredicate {
                           Function1<Integer, Boolean> <fn>;
                           public <Anon>(Function1<Integer, Boolean> <fn>) { this.<fn> = <fn>; }
                           public Boolean accept(Integer i) { return <fn>.invoke(i); }
                       }

                       IntPredicate x = (IntPredicate)new <Anon>(...);
                       ```
                     */

                    if (!e.argument.type.isFunctionOrKFunction()) {
                        logger.errorElement("Expected to find expression with function type in SAM conversion.", e)
                        return
                    }

                    val st = e.argument.type as? IrSimpleType
                    if (st == null) {
                        logger.errorElement("Expected to find a simple type in SAM conversion.", e)
                        return
                    }

                    // Either Function1, ... Function22 or FunctionN type, but not Function23 or above.
                    val functionType = getFunctionalInterfaceTypeWithTypeArgs(st.arguments)
                    if (functionType == null) {
                        logger.errorElement("Cannot find functional interface.", e)
                        return
                    }

                    val invokeMethod = functionType.classOrNull?.owner?.declarations?.findSubType<IrFunction> { it.name.asString() == OperatorNameConventions.INVOKE.asString()}
                    if (invokeMethod == null) {
                        logger.errorElement("Couldn't find `invoke` method on functional interface.", e)
                        return
                    }

                    val typeOwner = e.typeOperandClassifier.owner
                    if (typeOwner !is IrClass) {
                        logger.errorElement("Expected to find SAM conversion to IrClass. Found '${typeOwner.javaClass}' instead. Can't implement SAM interface.", e)
                        return
                    }
                    val samMember = typeOwner.declarations.findSubType<IrFunction> { it is IrOverridableMember && it.modality == Modality.ABSTRACT }
                    if (samMember == null) {
                        logger.errorElement("Couldn't find SAM member in type '${typeOwner.kotlinFqName.asString()}'. Can't implement SAM interface.", e)
                        return
                    }

                    val javaResult = TypeResult(tw.getFreshIdLabel<DbClass>(), "", "")
                    val kotlinResult = TypeResult(tw.getFreshIdLabel<DbKt_notnull_type>(), "", "")
                    tw.writeKt_notnull_types(kotlinResult.id, javaResult.id)
                    val ids = LocallyVisibleFunctionLabels(
                        TypeResults(javaResult, kotlinResult),
                        constructor = tw.getFreshIdLabel(),
                        constructorBlock = tw.getFreshIdLabel(),
                        function = tw.getFreshIdLabel())

                    val locId = tw.getLocation(e)
                    val helper = GeneratedClassHelper(locId, ids)

                    val currentDeclaration = declarationStack.peek()
                    val classId = extractGeneratedClass(ids, listOf(pluginContext.irBuiltIns.anyType, e.typeOperand), locId, currentDeclaration)

                    // add field
                    val fieldId = tw.getFreshIdLabel<DbField>()
                    extractField(fieldId, "<fn>", functionType, classId, locId, DescriptorVisibilities.PRIVATE, e, isExternalDeclaration = false, isFinal = true)

                    // adjust constructor
                    helper.extractParameterToFieldAssignmentInConstructor("<fn>", functionType, fieldId, 0, 1)

                    // add implementation function
                    val classTypeArgs = (e.type as? IrSimpleType)?.arguments
                    val typeSub = classTypeArgs?.let { makeGenericSubstitutionFunction(typeOwner, it) }

                    fun trySub(t: IrType, context: TypeContext) = if (typeSub == null) t else typeSub(t, context, pluginContext)

                    // Force extraction of this function even if this is a fake override --
                    // This happens in the case where a functional interface inherits its only abstract member,
                    // which usually we wouldn't extract, but in this case we're effectively using it as a template
                    // for the real function we're extracting that will implement this interface, and it serves fine
                    // for that purpose. By contrast if we looked through the fake to the underlying abstract method
                    // we would need to compose generic type substitutions -- for example, if we're implementing
                    // T UnaryOperator<T>.apply(T t) here, we would need to compose substitutions so we can implement
                    // the real underlying R Function<T, R>.apply(T t).
                    forceExtractFunction(samMember, classId, extractBody = false, extractMethodAndParameterTypeAccesses = true, typeSub, classTypeArgs, ids.function, tw.getLocation(e))

                    //body
                    val blockId = tw.getFreshIdLabel<DbBlock>()
                    tw.writeStmts_block(blockId, ids.function, 0, ids.function)
                    tw.writeHasLocation(blockId, locId)

                    //return stmt
                    val returnId = tw.getFreshIdLabel<DbReturnstmt>()
                    tw.writeStmts_returnstmt(returnId, blockId, 0, ids.function)
                    tw.writeHasLocation(returnId, locId)

                    //<fn>.invoke(vp0, cp1, vp2, vp3, ...) or
                    //<fn>.invoke(new Object[x]{vp0, vp1, vp2, ...})

                    fun extractCommonExpr(id: Label<out DbExpr>) {
                        tw.writeHasLocation(id, locId)
                        tw.writeCallableEnclosingExpr(id, ids.function)
                        tw.writeStatementEnclosingExpr(id, returnId)
                    }

                    // Call to original `invoke`:
                    val callId = tw.getFreshIdLabel<DbMethodaccess>()
                    val callType = useType(trySub(samMember.returnType, TypeContext.RETURN))
                    tw.writeExprs_methodaccess(callId, callType.javaResult.id, returnId, 0)
                    tw.writeExprsKotlinType(callId, callType.kotlinResult.id)
                    extractCommonExpr(callId)
                    val calledMethodId = useFunction<DbMethod>(invokeMethod, functionType.arguments)
                    tw.writeCallableBinding(callId, calledMethodId)

                    // <fn> access
                    val lhsId = tw.getFreshIdLabel<DbVaraccess>()
                    val lhsType = useType(functionType)
                    tw.writeExprs_varaccess(lhsId, lhsType.javaResult.id, callId, -1)
                    tw.writeExprsKotlinType(lhsId, lhsType.kotlinResult.id)
                    extractCommonExpr(lhsId)
                    tw.writeVariableBinding(lhsId, fieldId)

                    val parameters = mutableListOf<IrValueParameter>()
                    val extParam = samMember.extensionReceiverParameter
                    if (extParam != null) {
                        parameters.add(extParam)
                    }
                    parameters.addAll(samMember.valueParameters)

                    fun extractArgument(p: IrValueParameter, idx: Int, parent: Label<out DbExprparent>) {
                        val argsAccessId = tw.getFreshIdLabel<DbVaraccess>()
                        val paramType = useType(trySub(p.type, TypeContext.OTHER))
                        tw.writeExprs_varaccess(argsAccessId, paramType.javaResult.id, parent, idx)
                        tw.writeExprsKotlinType(argsAccessId, paramType.kotlinResult.id)
                        extractCommonExpr(argsAccessId)
                        tw.writeVariableBinding(argsAccessId, useValueParameter(p, ids.function))
                    }

                    val isBigArity = st.arguments.size > BuiltInFunctionArity.BIG_ARITY
                    val argParent = if (isBigArity) {
                        //<fn>.invoke(new Object[x]{vp0, vp1, vp2, ...})
                        extractArrayCreationWithInitializer(callId, parameters.size, locId, ids.function, returnId)
                    } else {
                        //<fn>.invoke(vp0, cp1, vp2, vp3, ...) or
                        callId
                    }

                    for ((parameterIdx, vp) in parameters.withIndex()) {
                        extractArgument(vp, parameterIdx, argParent)
                    }

                    val id = tw.getFreshIdLabel<DbCastexpr>()
                    val type = useType(e.typeOperand)
                    tw.writeExprs_castexpr(id, type.javaResult.id, parent, idx)
                    tw.writeExprsKotlinType(id, type.kotlinResult.id)
                    tw.writeHasLocation(id, locId)
                    tw.writeCallableEnclosingExpr(id, callable)
                    tw.writeStatementEnclosingExpr(id, enclosingStmt)
                    extractTypeAccessRecursive(e.typeOperand, locId, id, 0, callable, enclosingStmt)

                    val idNewexpr = extractNewExpr(ids.constructor, ids.type, locId, id, 1, callable, enclosingStmt)

                    tw.writeIsAnonymClass(ids.type.javaResult.id.cast<DbClass>(), idNewexpr)

                    extractTypeAccessRecursive(e.typeOperand, locId, idNewexpr, -3, callable, enclosingStmt)

                    extractExpressionExpr(e.argument, callable, idNewexpr, 0, enclosingStmt)
                }
                else -> {
                    logger.errorElement("Unrecognised IrTypeOperatorCall for ${e.operator}: " + e.render(), e)
                }
            }
        }
    }

    private fun extractBreakContinue(
        e: IrBreakContinue,
        id: Label<out DbNamedexprorstmt>
    ) {
        with("break/continue", e) {
            val locId = tw.getLocation(e)
            tw.writeHasLocation(id, locId)
            val label = e.label
            if (label != null) {
                tw.writeNamestrings(label, "", id)
            }
        }
    }

    private val IrType.isAnonymous: Boolean
        get() = ((this as? IrSimpleType)?.classifier?.owner as? IrClass)?.isAnonymousObject ?: false

    private fun addVisibilityModifierToLocalOrAnonymousClass(id: Label<out DbModifiable>) {
        addModifiers(id, "private")
    }

    /**
     * Extracts the class around a local function, a lambda, or a function reference.
     */
    private fun extractGeneratedClass(
        ids: GeneratedClassLabels,
        superTypes: List<IrType>,
        locId: Label<DbLocation>,
        currentDeclaration: IrDeclaration
    ): Label<out DbClass> {
        // Write class
        val id = ids.type.javaResult.id.cast<DbClass>()
        val pkgId = extractPackage("")
        tw.writeClasses(id, "", pkgId, id)
        tw.writeHasLocation(id, locId)

        // Extract constructor
        val unitType = useType(pluginContext.irBuiltIns.unitType)
        tw.writeConstrs(ids.constructor, "", "", unitType.javaResult.id, id, ids.constructor)
        tw.writeConstrsKotlinType(ids.constructor, unitType.kotlinResult.id)
        tw.writeHasLocation(ids.constructor, locId)
        addModifiers(ids.constructor, "public")

        // Constructor body
        val constructorBlockId = ids.constructorBlock
        tw.writeStmts_block(constructorBlockId, ids.constructor, 0, ids.constructor)
        tw.writeHasLocation(constructorBlockId, locId)

        // Super call
        val baseClass = superTypes.first().classOrNull
        if (baseClass == null) {
            logger.warnElement("Cannot find base class", currentDeclaration)
        } else {
            val baseConstructor = baseClass.owner.declarations.findSubType<IrFunction> { it.symbol is IrConstructorSymbol }
            if (baseConstructor == null) {
                logger.warnElement("Cannot find base constructor", currentDeclaration)
            } else {
                val superCallId = tw.getFreshIdLabel<DbSuperconstructorinvocationstmt>()
                tw.writeStmts_superconstructorinvocationstmt(superCallId, constructorBlockId, 0, ids.constructor)

                val baseConstructorId = useFunction<DbConstructor>(baseConstructor)

                tw.writeHasLocation(superCallId, locId)
                tw.writeCallableBinding(superCallId.cast<DbCaller>(), baseConstructorId)
            }
        }

        addModifiers(id, "final")
        addVisibilityModifierToLocalOrAnonymousClass(id)
        extractClassSupertypes(superTypes, listOf(), id, inReceiverContext = true)

        extractEnclosingClass(currentDeclaration, id, locId, listOf())

        return id
    }

    /**
     * Extracts the class around a local function or a lambda.
     */
    private fun extractGeneratedClass(localFunction: IrFunction, superTypes: List<IrType>) : Label<out DbClass> {
        with("generated class", localFunction) {
            val ids = getLocallyVisibleFunctionLabels(localFunction)

            val id = extractGeneratedClass(ids, superTypes, tw.getLocation(localFunction), localFunction)

            // Extract local function as a member
            extractFunction(localFunction, id, extractBody = true, extractMethodAndParameterTypeAccesses = true, null, listOf())

            return id
        }
    }


    private inner class DeclarationStackAdjuster(declaration: IrDeclaration): Closeable {
        init {
            declarationStack.push(declaration)
        }
        override fun close() {
            declarationStack.pop()
        }
    }

    private enum class CompilerGeneratedKinds(val kind: Int) {
        DECLARING_CLASSES_OF_ADAPTER_FUNCTIONS(1),
        GENERATED_DATA_CLASS_MEMBER(2),
        DEFAULT_PROPERTY_ACCESSOR(3),
        CLASS_INITIALISATION_METHOD(4),
        ENUM_CLASS_SPECIAL_MEMBER(5),
        DELEGATED_PROPERTY_GETTER(6),
        DELEGATED_PROPERTY_SETTER(7),
        JVMSTATIC_PROXY_METHOD(8),
    }
}
