package com.github.codeql

import com.github.codeql.comments.CommentExtractor
import com.github.codeql.utils.*
import com.github.codeql.utils.versions.functionN
import com.github.codeql.utils.versions.getIrStubFromDescriptor
import com.semmle.extractor.java.OdasaOutput
import org.jetbrains.kotlin.backend.common.extensions.IrPluginContext
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
import org.jetbrains.kotlin.name.FqName
import org.jetbrains.kotlin.util.OperatorNameConventions
import org.jetbrains.kotlin.types.Variance
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

    inline fun <T> with(kind: String, element: IrElement, f: () -> T): T {
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

            file.declarations.map { extractDeclaration(it) }
            extractStaticInitializer(file)
            CommentExtractor(this, file, tw.fileId).extract()
        }
    }

    private fun isFake(d: IrDeclarationWithVisibility): Boolean {
        val visibility = d.visibility
        if (visibility is DelegatedDescriptorVisibility && visibility.delegate == Visibilities.InvisibleFake) {
            return true
        }
        if (d.isFakeOverride) {
            return true
        }
        return false
    }

    fun extractDeclaration(declaration: IrDeclaration) {
        with("declaration", declaration) {
            when (declaration) {
                is IrClass -> {
                    if (isExternalDeclaration(declaration)) {
                        extractExternalClassLater(declaration)
                    } else {
                        extractClassSource(declaration, true)
                    }
                }
                is IrFunction -> {
                    @Suppress("UNCHECKED_CAST")
                    val parentId = useDeclarationParent(declaration.parent, false) as Label<DbReftype>
                    extractFunction(declaration, parentId, true, null, listOf())
                }
                is IrAnonymousInitializer -> {
                    // Leaving this intentionally empty. init blocks are extracted during class extraction.
                }
                is IrProperty -> {
                    @Suppress("UNCHECKED_CAST")
                    val parentId = useDeclarationParent(declaration.parent, false) as Label<DbReftype>
                    extractProperty(declaration, parentId, true, null, listOf())
                }
                is IrEnumEntry -> {
                    @Suppress("UNCHECKED_CAST")
                    val parentId = useDeclarationParent(declaration.parent, false) as Label<DbReftype>
                    extractEnumEntry(declaration, parentId)
                }
                is IrField -> {
                    @Suppress("UNCHECKED_CAST")
                    val parentId = useDeclarationParent(declaration.parent, false) as Label<DbReftype>
                    extractField(declaration, parentId)
                }
                is IrTypeAlias -> extractTypeAlias(declaration)
                else -> logger.errorElement("Unrecognised IrDeclaration: " + declaration.javaClass, declaration)
            }
        }
    }



    fun getLabel(element: IrElement) : String? {
        when (element) {
            is IrClass -> return getClassLabel(element, listOf()).classLabel
            is IrTypeParameter -> return getTypeParameterLabel(element)
            is IrFunction -> return getFunctionLabel(element, null)
            is IrValueParameter -> return getValueParameterLabel(element, null)
            is IrProperty -> return getPropertyLabel(element)
            is IrField -> return getFieldLabel(element)
            is IrEnumEntry -> return getEnumEntryLabel(element)

            // Fresh entities:
            is IrBody -> return null
            is IrExpression -> return null

            // todo add others:
            else -> {
                logger.errorElement("Unhandled element type: ${element::class}", element)
                return null
            }
        }
    }

    fun extractTypeParameter(tp: IrTypeParameter, apparentIndex: Int): Label<out DbTypevariable> {
        with("type parameter", tp) {
            val id = tw.getLabelFor<DbTypevariable>(getTypeParameterLabel(tp))

            val parentId: Label<out DbClassorinterfaceorcallable> = when (val parent = tp.parent) {
                is IrFunction -> useFunction(parent)
                is IrClass -> useClassSource(parent)
                else -> {
                    logger.errorElement("Unexpected type parameter parent", tp)
                    fakeLabel()
                }
            }

            // Note apparentIndex does not necessarily equal `tp.index`, because at least constructor type parameters
            // have indices offset from the type parameters of the constructed class (i.e. the parameter S of
            // `class Generic<T> { public <S> Generic(T t, S s) { ... } }` will have `tp.index` 1, not 0).
            tw.writeTypeVars(id, tp.name.asString(), apparentIndex, 0, parentId)
            val locId = tw.getLocation(tp)
            tw.writeHasLocation(id, locId)

            tp.superTypes.forEachIndexed { boundIdx, bound ->
                if(!(bound.isAny() || bound.isNullableAny())) {
                    tw.getLabelFor<DbTypebound>("@\"bound;$boundIdx;{$id}\"") {
                        tw.writeTypeBounds(it, useType(bound).javaResult.id as Label<out DbReftype>, boundIdx, id)
                    }
                }
            }

            return id
        }
    }

    fun extractVisibility(elementForLocation: IrElement, id: Label<out DbModifiable>, v: DescriptorVisibility) {
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

    fun extractClassModifiers(c: IrClass, id: Label<out DbClassorinterface>) {
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
            if(c.kind == ClassKind.INTERFACE) {
                @Suppress("UNCHECKED_CAST")
                val interfaceId = id as Label<out DbInterface>
                @Suppress("UNCHECKED_CAST")
                val sourceInterfaceId = useClassSource(c) as Label<out DbInterface>
                tw.writeInterfaces(interfaceId, cls, pkgId, sourceInterfaceId)
            } else {
                @Suppress("UNCHECKED_CAST")
                val classId = id as Label<out DbClass>
                @Suppress("UNCHECKED_CAST")
                val sourceClassId = useClassSource(c) as Label<out DbClass>
                tw.writeClasses(classId, cls, pkgId, sourceClassId)

                if (c.kind == ClassKind.ENUM_CLASS) {
                    tw.writeIsEnumType(classId)
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

            val locId = tw.getLocation(c)
            tw.writeHasLocation(id, locId)

            // Extract the outer <-> inner class relationship, passing on any type arguments in excess to this class' parameters.
            extractEnclosingClass(c, id, locId, argsIncludingOuterClasses?.drop(c.typeParameters.size) ?: listOf())

            return id
        }
    }

    // `typeArgs` can be null to describe a raw generic type.
    // For non-generic types it will be zero-length list.
    fun extractMemberPrototypes(c: IrClass, argsIncludingOuterClasses: List<IrTypeArgument>?, id: Label<out DbClassorinterface>) {
        with("member prototypes", c) {
            val typeParamSubstitution =
                when (argsIncludingOuterClasses) {
                    null -> { x: IrType, _: TypeContext, _: IrPluginContext -> x.toRawType() }
                    else -> {
                        makeTypeGenericSubstitutionMap(c, argsIncludingOuterClasses).let {
                            { x: IrType, useContext: TypeContext, pluginContext: IrPluginContext ->
                                x.substituteTypeAndArguments(
                                    it,
                                    useContext,
                                    pluginContext
                                )
                            }
                        }
                    }
                }

            c.declarations.map {
                when(it) {
                    is IrFunction -> extractFunction(it, id, false, typeParamSubstitution, argsIncludingOuterClasses)
                    is IrProperty -> extractProperty(it, id, false, typeParamSubstitution, argsIncludingOuterClasses)
                    else -> {}
                }
            }
        }
    }

    private fun extractLocalTypeDeclStmt(c: IrClass, callable: Label<out DbCallable>, parent: Label<out DbStmtparent>, idx: Int) {
        @Suppress("UNCHECKED_CAST")
        val id = extractClassSource(c, true) as Label<out DbClass>
        extractLocalTypeDeclStmt(id, c, callable, parent, idx)
    }

    private fun extractLocalTypeDeclStmt(id: Label<out DbClass>, locElement: IrElement, callable: Label<out DbCallable>, parent: Label<out DbStmtparent>, idx: Int) {
        val stmtId = tw.getFreshIdLabel<DbLocaltypedeclstmt>()
        tw.writeStmts_localtypedeclstmt(stmtId, parent, idx, callable)
        tw.writeIsLocalClassOrInterface(id, stmtId)
        val locId = tw.getLocation(locElement)
        tw.writeHasLocation(stmtId, locId)
    }

    fun extractClassSource(c: IrClass, extractDeclarations: Boolean): Label<out DbClassorinterface> {
        with("class source", c) {
            DeclarationStackAdjuster(c).use {

                val id = if (c.isAnonymousObject) {
                    @Suppress("UNCHECKED_CAST")
                    useAnonymousClass(c).javaResult.id as Label<out DbClass>
                } else {
                    useClassSource(c)
                }
                val pkg = c.packageFqName?.asString() ?: ""
                val cls = if (c.isAnonymousObject) "" else c.name.asString()
                val pkgId = extractPackage(pkg)
                if (c.kind == ClassKind.INTERFACE) {
                    @Suppress("UNCHECKED_CAST")
                    val interfaceId = id as Label<out DbInterface>
                    tw.writeInterfaces(interfaceId, cls, pkgId, interfaceId)
                } else {
                    @Suppress("UNCHECKED_CAST")
                    val classId = id as Label<out DbClass>
                    tw.writeClasses(classId, cls, pkgId, classId)

                    if (c.kind == ClassKind.ENUM_CLASS) {
                        tw.writeIsEnumType(classId)
                    }
                }

                val locId = tw.getLocation(c)
                tw.writeHasLocation(id, locId)

                extractEnclosingClass(c, id, locId, listOf())

                c.typeParameters.mapIndexed { idx, it -> extractTypeParameter(it, idx) }
                if (extractDeclarations)
                    c.declarations.map { extractDeclaration(it) }
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
                    @Suppress("UNCHECKED_CAST")
                    tw.writeClass_object(id as Label<DbClass>, instance.id)
                }

                extractClassModifiers(c, id)
                val forceExtractSupertypeMembers = !isExternalDeclaration(c)
                extractClassSupertypes(c, id, inReceiverContext = forceExtractSupertypeMembers)

                return id
            }
        }
    }

    fun extractEnclosingClass(innerClass: IrClass, innerId: Label<out DbClassorinterface>, innerLocId: Label<DbLocation>, parentClassTypeArguments: List<IrTypeArgument>) {
        with("inner class", innerClass) {
            var parent: IrDeclarationParent? = innerClass.parent
            while (parent != null) {
                if (parent is IrClass) {
                    val parentId =
                        if (parent.isAnonymousObject) {
                            @Suppress("UNCHECKED_CAST")
                            useAnonymousClass(parent).javaResult.id as Label<out DbClass>
                        } else {
                            useClassInstance(parent, parentClassTypeArguments).typeResult.id
                        }
                    tw.writeEnclInReftype(innerId, parentId)
                    if(innerClass.isCompanion) {
                        // If we are a companion then our parent has a
                        //     public static final ParentClass$CompanionObjectClass CompanionObjectName;
                        // that we need to fabricate here
                        val instance = useCompanionObjectClassInstance(innerClass)
                        if(instance != null) {
                            val type = useSimpleTypeClass(innerClass, emptyList(), false)
                            tw.writeFields(instance.id, instance.name, type.javaResult.id, innerId, instance.id)
                            tw.writeFieldsKotlinType(instance.id, type.kotlinResult.id)
                            tw.writeHasLocation(instance.id, innerLocId)
                            addModifiers(instance.id, "public", "static", "final")
                            @Suppress("UNCHECKED_CAST")
                            tw.writeType_companion_object(parentId, instance.id, innerId as Label<DbClass>)
                        }
                    }

                    break
                }

                parent = (parent as? IrDeclaration)?.parent
            }
        }
    }

    data class FieldResult(val id: Label<DbField>, val name: String)

    fun useCompanionObjectClassInstance(c: IrClass): FieldResult? {
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

    fun useObjectClassInstance(c: IrClass): FieldResult {
        if(!c.isNonCompanionObject) {
            logger.error("Using instance for non-object class")
        }
        val classId = useClassInstance(c, listOf()).typeResult.id
        val instanceName = "INSTANCE"
        val instanceLabel = "@\"field;{$classId};$instanceName\""
        val instanceId: Label<DbField> = tw.getLabelFor(instanceLabel)
        return FieldResult(instanceId, instanceName)
    }

    private fun extractValueParameter(vp: IrValueParameter, parent: Label<out DbCallable>, idx: Int, typeSubstitution: TypeSubstitution?, parentSourceDeclaration: Label<out DbCallable>): TypeResults {
        with("value parameter", vp) {
            return extractValueParameter(useValueParameter(vp, parent), vp.type, vp.name.asString(), tw.getLocation(vp), parent, idx, typeSubstitution, useValueParameter(vp, parentSourceDeclaration), vp.isVararg)
        }
    }

    private fun extractValueParameter(id: Label<out DbParam>, t: IrType, name: String, locId: Label<DbLocation>, parent: Label<out DbCallable>, idx: Int, typeSubstitution: TypeSubstitution?, paramSourceDeclaration: Label<out DbParam>, isVararg: Boolean): TypeResults {
        val substitutedType = typeSubstitution?.let { it(t, TypeContext.OTHER, pluginContext) } ?: t
        val type = useType(substitutedType)
        tw.writeParams(id, type.javaResult.id, idx, parent, paramSourceDeclaration)
        tw.writeParamsKotlinType(id, type.kotlinResult.id)
        tw.writeHasLocation(id, locId)
        tw.writeParamName(id, name)
        if (isVararg) {
            tw.writeIsVarargsParam(id)
        }
        return type
    }

    private fun extractStaticInitializer(file: IrFile) {
        with("static initializer extraction", file) {
            extractDeclInitializers(file.declarations, true) {
                val parentId = extractFileClass(file)
                val clinitLabel = getFunctionLabel(
                    file,
                    parentId,
                    "<clinit>",
                    listOf(),
                    pluginContext.irBuiltIns.unitType,
                    extensionReceiverParameter = null,
                    functionTypeParameters = listOf(),
                    classTypeArgsIncludingOuterClasses = listOf()
                )
                val clinitId = tw.getLabelFor<DbMethod>(clinitLabel)
                val returnType = useType(pluginContext.irBuiltIns.unitType)
                tw.writeMethods(clinitId, "<clinit>", "<clinit>()", returnType.javaResult.id, parentId, clinitId)
                tw.writeMethodsKotlinType(clinitId, returnType.kotlinResult.id)

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
                logger.warnElement("Constructor's parent is not a class", enclosingConstructor)
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
        for (decl in declarations) {
            when (decl) {
                is IrProperty -> {
                    val backingField = decl.backingField
                    val initializer = backingField?.initializer

                    if (backingField == null || backingField.isStatic != extractStaticInitializers || initializer == null) {
                        continue
                    }

                    val expr = initializer.expression

                    val declLocId = tw.getLocation(decl)
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
                    val lhsType = useType(backingField.type)
                    tw.writeExprs_varaccess(lhsId, lhsType.javaResult.id, assignmentId, 0)
                    tw.writeExprsKotlinType(lhsId, lhsType.kotlinResult.id)
                    tw.writeHasLocation(lhsId, declLocId)
                    tw.writeCallableEnclosingExpr(lhsId, blockAndFunctionId.second)
                    tw.writeStatementEnclosingExpr(lhsId, stmtId)
                    val vId = useField(backingField)
                    tw.writeVariableBinding(lhsId, vId)

                    extractExpressionExpr(expr, blockAndFunctionId.second, assignmentId, 1, stmtId)
                }
                is IrAnonymousInitializer -> {
                    if (decl.isStatic) {
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

    fun extractFunction(f: IrFunction, parentId: Label<out DbReftype>, extractBody: Boolean, typeSubstitution: TypeSubstitution?, classTypeArgsIncludingOuterClasses: List<IrTypeArgument>?, idOverride: Label<DbMethod>? = null): Label<out DbCallable>? {
        if (isFake(f)) return null

        with("function", f) {
            DeclarationStackAdjuster(f).use {

                getFunctionTypeParameters(f).mapIndexed { idx, tp -> extractTypeParameter(tp, idx) }

                val locId = tw.getLocation(f)

                val id =
                    if (idOverride != null)
                        idOverride
                    else if (f.isLocalFunction())
                        getLocallyVisibleFunctionLabels(f).function
                    else
                        useFunction<DbCallable>(f, parentId, classTypeArgsIncludingOuterClasses)

                val sourceDeclaration =
                    if (typeSubstitution != null)
                        useFunction(f)
                    else
                        id

                val extReceiver = f.extensionReceiverParameter
                val idxOffset = if (extReceiver != null) 1 else 0
                val paramTypes = f.valueParameters.mapIndexed { i, vp ->
                    extractValueParameter(vp, id, i + idxOffset, typeSubstitution, sourceDeclaration)
                }
                val allParamTypes = if (extReceiver != null) {
                    val extendedType = useType(extReceiver.type)
                    @Suppress("UNCHECKED_CAST")
                    tw.writeKtExtensionFunctions(id as Label<DbMethod>, extendedType.javaResult.id, extendedType.kotlinResult.id)

                    val t = extractValueParameter(extReceiver, id, 0, null, sourceDeclaration)
                    listOf(t) + paramTypes
                } else {
                    paramTypes
                }

                val paramsSignature = allParamTypes.joinToString(separator = ",", prefix = "(", postfix = ")") { it.javaResult.signature!! }

                val substReturnType = typeSubstitution?.let { it(f.returnType, TypeContext.RETURN, pluginContext) } ?: f.returnType

                if (f.symbol is IrConstructorSymbol) {
                    val unitType = useType(pluginContext.irBuiltIns.unitType, TypeContext.RETURN)
                    val shortName = when {
                        f.returnType.isAnonymous -> ""
                        typeSubstitution != null -> useType(substReturnType).javaResult.shortName
                        else -> f.returnType.classFqName?.shortName()?.asString() ?: f.name.asString()
                    }
                    @Suppress("UNCHECKED_CAST")
                    val constrId = id as Label<DbConstructor>
                    tw.writeConstrs(constrId, shortName, "$shortName$paramsSignature", unitType.javaResult.id, parentId, sourceDeclaration as Label<DbConstructor>)
                    tw.writeConstrsKotlinType(constrId, unitType.kotlinResult.id)
                } else {
                    val returnType = useType(substReturnType, TypeContext.RETURN)
                    val shortName = getFunctionShortName(f)
                    @Suppress("UNCHECKED_CAST")
                    val methodId = id as Label<DbMethod>
                    tw.writeMethods(methodId, shortName, "$shortName$paramsSignature", returnType.javaResult.id, parentId, sourceDeclaration as Label<DbMethod>)
                    tw.writeMethodsKotlinType(methodId, returnType.kotlinResult.id)
                }

                tw.writeHasLocation(id, locId)
                val body = f.body
                if (body != null && extractBody) {
                    if (typeSubstitution != null)
                        logger.errorElement("Type substitution should only be used to extract a function prototype, not the body", f)
                    extractBody(body, id)
                }

                extractVisibility(f, id, f.visibility)

                return id
            }
        }
    }

    fun extractField(f: IrField, parentId: Label<out DbReftype>): Label<out DbField> {
        with("field", f) {
           DeclarationStackAdjuster(f).use {
               declarationStack.push(f)
               return extractField(useField(f), f.name.asString(), f.type, parentId, tw.getLocation(f), f.visibility, f, isExternalDeclaration(f))
           }
        }
    }


    private fun extractField(id: Label<out DbField>, name: String, type: IrType, parentId: Label<out DbReftype>, locId: Label<DbLocation>, visibility: DescriptorVisibility, errorElement: IrElement, isExternalDeclaration: Boolean): Label<out DbField> {
        val t = useType(type)
        tw.writeFields(id, name, t.javaResult.id, parentId, id)
        tw.writeFieldsKotlinType(id, t.kotlinResult.id)
        tw.writeHasLocation(id, locId)

        extractVisibility(errorElement, id, visibility)

        if (!isExternalDeclaration) {
            val fieldDeclarationId = tw.getFreshIdLabel<DbFielddecl>()
            tw.writeFielddecls(fieldDeclarationId, parentId)
            tw.writeFieldDeclaredIn(id, fieldDeclarationId, 0)
            tw.writeHasLocation(fieldDeclarationId, locId)

            extractTypeAccessRecursive(type, locId, fieldDeclarationId, 0)
        }

        return id
    }

    fun extractProperty(p: IrProperty, parentId: Label<out DbReftype>, extractBackingField: Boolean, typeSubstitution: TypeSubstitution?, classTypeArgs: List<IrTypeArgument>?) {
        with("property", p) {
            if (isFake(p)) return

            DeclarationStackAdjuster(p).use {

                val id = useProperty(p, parentId)
                val locId = tw.getLocation(p)
                tw.writeKtProperties(id, p.name.asString())
                tw.writeHasLocation(id, locId)

                val bf = p.backingField
                val getter = p.getter
                val setter = p.setter

                if (getter != null) {
                    @Suppress("UNCHECKED_CAST")
                    val getterId = extractFunction(getter, parentId, extractBackingField, typeSubstitution, classTypeArgs) as Label<out DbMethod>?
                    if (getterId != null) {
                        tw.writeKtPropertyGetters(id, getterId)
                    }
                } else {
                    if (p.modality != Modality.FINAL || !isExternalDeclaration(p)) {
                        logger.errorElement("IrProperty without a getter", p)
                    }
                }

                if (setter != null) {
                    if (!p.isVar) {
                        logger.errorElement("!isVar property with a setter", p)
                    }
                    @Suppress("UNCHECKED_CAST")
                    val setterId = extractFunction(setter, parentId, extractBackingField, typeSubstitution, classTypeArgs) as Label<out DbMethod>?
                    if (setterId != null) {
                        tw.writeKtPropertySetters(id, setterId)
                    }
                } else {
                    if (p.isVar && !isExternalDeclaration(p)) {
                        logger.errorElement("isVar property without a setter", p)
                    }
                }

                if (bf != null && extractBackingField) {
                    val fieldId = extractField(bf, parentId)
                    tw.writeKtPropertyBackingFields(id, fieldId)
                    if (p.isDelegated) {
                        tw.writeKtPropertyDelegates(id, fieldId)
                    }
                }

                extractVisibility(p, id, p.visibility)
            }
        }
    }

    fun extractEnumEntry(ee: IrEnumEntry, parentId: Label<out DbReftype>) {
        with("enum entry", ee) {
            DeclarationStackAdjuster(ee).use {
                val id = useEnumEntry(ee)
                val parent = ee.parent
                if (parent !is IrClass) {
                    logger.errorElement("Enum entry with unexpected parent: " + parent.javaClass, ee)
                } else if (parent.typeParameters.isNotEmpty()) {
                    logger.errorElement("Enum entry parent class has type parameters: " + parent.name, ee)
                } else {
                    val type = useSimpleTypeClass(parent, emptyList(), false)
                    tw.writeFields(id, ee.name.asString(), type.javaResult.id, parentId, id)
                    tw.writeFieldsKotlinType(id, type.kotlinResult.id)
                    val locId = tw.getLocation(ee)
                    tw.writeHasLocation(id, locId)
                }
            }
        }
    }

    fun extractTypeAlias(ta: IrTypeAlias) {
        with("type alias", ta) {
            if (ta.typeParameters.isNotEmpty()) {
                // TODO: Extract this information
                logger.error("Type alias with type parameters discarded: " + ta.render())
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

    fun extractBody(b: IrBody, callable: Label<out DbCallable>) {
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

    fun extractBlockBody(b: IrBlockBody, callable: Label<out DbCallable>) {
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

    fun extractSyntheticBody(b: IrSyntheticBody, callable: Label<out DbCallable>) {
        with("synthetic body", b) {
            when (b.kind) {
                IrSyntheticBodyKind.ENUM_VALUES -> tw.writeKtSyntheticBody(callable, 1)
                IrSyntheticBodyKind.ENUM_VALUEOF -> tw.writeKtSyntheticBody(callable, 2)
            }
        }
    }

    fun extractExpressionBody(b: IrExpressionBody, callable: Label<out DbCallable>) {
        with("expression body", b) {
            val blockId = tw.getFreshIdLabel<DbBlock>()
            val locId = tw.getLocation(b)
            tw.writeStmts_block(blockId, callable, 0, callable)
            tw.writeHasLocation(blockId, locId)

            val returnId = tw.getFreshIdLabel<DbReturnstmt>()
            tw.writeStmts_returnstmt(returnId, blockId, 0, callable)
            tw.writeHasLocation(returnId, locId)
            extractExpressionExpr(b.expression, callable, returnId, 0, returnId)
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

    fun extractVariable(v: IrVariable, callable: Label<out DbCallable>, parent: Label<out DbStmtparent>, idx: Int) {
        with("variable", v) {
            val stmtId = tw.getFreshIdLabel<DbLocalvariabledeclstmt>()
            val locId = tw.getLocation(getVariableLocationProvider(v))
            tw.writeStmts_localvariabledeclstmt(stmtId, parent, idx, callable)
            tw.writeHasLocation(stmtId, locId)
            extractVariableExpr(v, callable, stmtId, 1, stmtId)
        }
    }

    fun extractVariableExpr(v: IrVariable, callable: Label<out DbCallable>, parent: Label<out DbExprparent>, idx: Int, enclosingStmt: Label<out DbStmt>) {
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
            if(i != null) {
                extractExpressionExpr(i, callable, exprId, 0, enclosingStmt)
            }
        }
    }

    fun extractStatement(s: IrStatement, callable: Label<out DbCallable>, parent: Label<out DbStmtparent>, idx: Int) {
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
                    val l = getLocallyVisibleFunctionLabels(s.getter).function
                    tw.writeKtPropertyGetters(propId, l)

                    val setter = s.setter
                    if (setter != null) {
                        extractStatement(setter, callable, blockId, 2)
                        val l = getLocallyVisibleFunctionLabels(setter).function
                        tw.writeKtPropertySetters(propId, l)
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
        return if (!walkFrom(receiverClass)) {
            logger.errorElement("Failed to find a class declaring ${callTarget.name}", callTarget)
            listOf()
        } else {
            var subbedType = receiverType
            ancestorTypes.forEach {
                val thisClass = subbedType.classifier.owner as IrClass
                subbedType = it.substituteTypeArguments(thisClass.typeParameters, subbedType.arguments) as IrSimpleType
            }
            subbedType.arguments
        }
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
        extractClassTypeArguments: Boolean = false) {

        val callTarget = syntacticCallTarget.target.realOverrideTarget
        val id = tw.getFreshIdLabel<DbMethodaccess>()
        val type = useType(callsite.type)
        val locId = tw.getLocation(callsite)
        tw.writeExprs_methodaccess(id, type.javaResult.id, callsiteParent, childIdx)
        tw.writeExprsKotlinType(id, type.kotlinResult.id)
        tw.writeHasLocation(id, locId)
        tw.writeCallableEnclosingExpr(id, enclosingCallable)
        tw.writeStatementEnclosingExpr(id, enclosingStmt)

        // type arguments at index -2, -3, ...
        extractTypeArguments(typeArguments, locId, id, enclosingCallable, enclosingStmt, -2, true)

        if (callTarget.isLocalFunction()) {
            val ids = getLocallyVisibleFunctionLabels(callTarget)

            val methodId = ids.function
            tw.writeCallableBinding(id, methodId)

            val idNewexpr = extractNewExpr(ids.constructor, ids.type, locId, id, -1, enclosingCallable, enclosingStmt)

            extractTypeAccessRecursive(pluginContext.irBuiltIns.anyType, locId, idNewexpr, -3, enclosingCallable, enclosingStmt)
        } else {
            // Returns true if type is C<T1, T2, ...> where C is declared `class C<T1, T2, ...> { ... }`
            fun isUnspecialised(type: IrSimpleType) =
                type.classifier.owner is IrClass &&
                        (type.classifier.owner as IrClass).typeParameters.zip(type.arguments).all { paramAndArg ->
                            (paramAndArg.second as? IrTypeProjection)?.let {
                                // Type arg refers to the class' own type parameter?
                                it.variance == Variance.INVARIANT &&
                                        it.type.classifierOrNull?.owner === paramAndArg.first
                            } ?: false
                        }

            val drType = dispatchReceiver?.type
            val methodId =
                if (drType != null && extractClassTypeArguments && drType is IrSimpleType && !isUnspecialised(drType))
                    useFunction<DbCallable>(callTarget, getDeclaringTypeArguments(callTarget, drType))
                else
                    useFunction<DbCallable>(callTarget)

            tw.writeCallableBinding(id, methodId)

            if (dispatchReceiver != null) {
                extractExpressionExpr(dispatchReceiver, enclosingCallable, id, -1, enclosingStmt)
            } else if(callTarget.isStaticMethodOfClass) {
                extractTypeAccessRecursive(callTarget.parentAsClass.toRawType(), locId, id, -1, enclosingCallable, enclosingStmt)
            }
        }

        val idxOffset: Int
        if (extensionReceiver != null) {
            extractExpressionExpr(extensionReceiver, enclosingCallable, id, 0, enclosingStmt)
            idxOffset = 1
        } else {
            idxOffset = 0
        }

        var i = 0
        valueArguments.forEach { arg ->
            if(arg != null) {
                if (arg is IrVararg) {
                    arg.elements.forEachIndexed { varargNo, vararg -> extractVarargElement(vararg, enclosingCallable, id, i + idxOffset + varargNo, enclosingStmt) }
                    i += arg.elements.size
                } else {
                    extractExpressionExpr(arg, enclosingCallable, id, (i++) + idxOffset, enclosingStmt)
                }
            }
        }
    }

    fun findFunction(cls: IrClass, name: String): IrFunction? = cls.declarations.find { it is IrFunction && it.name.asString() == name } as IrFunction?

    val jvmIntrinsicsClass by lazy {
        val result = pluginContext.referenceClass(FqName("kotlin.jvm.internal.Intrinsics"))?.owner
        result?.let { extractExternalClassLater(it) }
        result
    }

    fun findJdkIntrinsicOrWarn(name: String, warnAgainstElement: IrElement): IrFunction? {
        val result = jvmIntrinsicsClass?.let { findFunction(it, name) }
        if(result == null) {
            logger.errorElement("Couldn't find JVM intrinsic function $name", warnAgainstElement)
        }
        return result
    }

    val javaLangString by lazy {
        val result = pluginContext.referenceClass(FqName("java.lang.String"))?.owner
        result?.let { extractExternalClassLater(it) }
        result
    }

    val stringValueOfObjectMethod by lazy {
        val result = javaLangString?.declarations?.find {
            it is IrFunction &&
            it.name.asString() == "valueOf" &&
            it.valueParameters.size == 1 &&
            it.valueParameters[0].type == pluginContext.irBuiltIns.anyNType
        } as IrFunction?
        if (result == null) {
            logger.error("Couldn't find declaration java.lang.String.valueOf(Object)")
        }
        result
    }

    val javaLangObject by lazy {
        val result = pluginContext.referenceClass(FqName("java.lang.Object"))?.owner
        result?.let { extractExternalClassLater(it) }
        result
    }

    val objectCloneMethod by lazy {
        val result = javaLangObject?.declarations?.find {
            it is IrFunction && it.name.asString() == "clone"
        } as IrFunction?
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
        val result = kotlinNoWhenBranchMatchedExn?.declarations?.find {
            it is IrConstructor &&
            it.valueParameters.isEmpty()
        } as IrConstructor?
        if (result == null) {
            logger.error("Couldn't find no-arg constructor for kotlin.NoWhenBranchMatchedException")
        }
        result
    }

    fun isFunction(target: IrFunction, pkgName: String, classNameLogged: String, classNamePredicate: (String) -> Boolean, fName: String, hasQuestionMark: Boolean? = false): Boolean {
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

    fun isFunction(target: IrFunction, pkgName: String, className: String, fName: String, hasQuestionMark: Boolean? = false) =
        isFunction(target, pkgName, className, { it == className }, fName, hasQuestionMark)

    fun isNumericFunction(target: IrFunction, fName: String): Boolean {
        return isFunction(target, "kotlin", "Int", fName) ||
                isFunction(target, "kotlin", "Byte", fName) ||
                isFunction(target, "kotlin", "Short", fName) ||
                isFunction(target, "kotlin", "Long", fName) ||
                isFunction(target, "kotlin", "Float", fName) ||
                isFunction(target, "kotlin", "Double", fName)
    }

    fun isArrayType(typeName: String) =
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

    fun extractCall(c: IrCall, callable: Label<out DbCallable>, stmtExprParent: StmtExprParent) {
        with("call", c) {
            val target = tryReplaceAndroidSyntheticFunction(c.symbol.owner)

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
                        (0 until c.typeArgumentsCount).map { c.getTypeArgument(it)!! }
                    else
                        listOf()

                extractRawMethodAccess(syntacticCallTarget, c, callable, parent, idx, enclosingStmt, (0 until c.valueArgumentsCount).map { c.getValueArgument(it) }, c.dispatchReceiver, c.extensionReceiver, typeArgs, extractClassTypeArguments)
            }

            fun extractSpecialEnumFunction(fnName: String){
                if (c.typeArgumentsCount != 1) {
                    logger.errorElement("Expected to find exactly one type argument", c)
                    return
                }

                val func = ((c.getTypeArgument(0) as? IrSimpleType)?.classifier?.owner as? IrClass)?.declarations?.find { it is IrFunction && it.name.asString() == fnName }
                if (func == null) {
                    logger.errorElement("Couldn't find function $fnName on enum type", c)
                    return
                }

                extractMethodAccess(func as IrFunction, false)
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
                    var id = tw.getFreshIdLabel<DbValueneexpr>()
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
                        logger.errorElement("Unexpected origin for LT: ${c.origin}", c)
                    }
                    val id = tw.getFreshIdLabel<DbLtexpr>()
                    val type = useType(c.type)
                    tw.writeExprs_ltexpr(id, type.javaResult.id, parent, idx)
                    tw.writeExprsKotlinType(id, type.kotlinResult.id)
                    binOp(id, c, callable, enclosingStmt)
                }
                isBuiltinCallInternal(c, "lessOrEqual") -> {
                    if(c.origin != IrStatementOrigin.LTEQ) {
                        logger.errorElement("Unexpected origin for LTEQ: ${c.origin}", c)
                    }
                    val id = tw.getFreshIdLabel<DbLeexpr>()
                    val type = useType(c.type)
                    tw.writeExprs_leexpr(id, type.javaResult.id, parent, idx)
                    tw.writeExprsKotlinType(id, type.kotlinResult.id)
                    binOp(id, c, callable, enclosingStmt)
                }
                isBuiltinCallInternal(c, "greater") -> {
                    if(c.origin != IrStatementOrigin.GT) {
                        logger.errorElement("Unexpected origin for GT: ${c.origin}", c)
                    }
                    val id = tw.getFreshIdLabel<DbGtexpr>()
                    val type = useType(c.type)
                    tw.writeExprs_gtexpr(id, type.javaResult.id, parent, idx)
                    tw.writeExprsKotlinType(id, type.kotlinResult.id)
                    binOp(id, c, callable, enclosingStmt)
                }
                isBuiltinCallInternal(c, "greaterOrEqual") -> {
                    if(c.origin != IrStatementOrigin.GTEQ) {
                        logger.errorElement("Unexpected origin for GTEQ: ${c.origin}", c)
                    }
                    val id = tw.getFreshIdLabel<DbGeexpr>()
                    val type = useType(c.type)
                    tw.writeExprs_geexpr(id, type.javaResult.id, parent, idx)
                    tw.writeExprsKotlinType(id, type.kotlinResult.id)
                    binOp(id, c, callable, enclosingStmt)
                }
                isBuiltinCallInternal(c, "EQEQ") -> {
                    if(c.origin != IrStatementOrigin.EQEQ) {
                        logger.errorElement("Unexpected origin for EQEQ: ${c.origin}", c)
                    }
                    var id = tw.getFreshIdLabel<DbValueeqexpr>()
                    val type = useType(c.type)
                    tw.writeExprs_valueeqexpr(id, type.javaResult.id, parent, idx)
                    tw.writeExprsKotlinType(id, type.kotlinResult.id)
                    binOp(id, c, callable, enclosingStmt)
                }
                isBuiltinCallInternal(c, "EQEQEQ") -> {
                    if(c.origin != IrStatementOrigin.EQEQEQ) {
                        logger.errorElement("Unexpected origin for EQEQEQ: ${c.origin}", c)
                    }
                    val id = tw.getFreshIdLabel<DbEqexpr>()
                    val type = useType(c.type)
                    tw.writeExprs_eqexpr(id, type.javaResult.id, parent, idx)
                    tw.writeExprsKotlinType(id, type.kotlinResult.id)
                    binOp(id, c, callable, enclosingStmt)
                }
                isBuiltinCallInternal(c, "ieee754equals") -> {
                    if(c.origin != IrStatementOrigin.EQEQ) {
                        logger.errorElement("Unexpected origin for ieee754equals: ${c.origin}", c)
                    }
                    val id = tw.getFreshIdLabel<DbEqexpr>()
                    val type = useType(c.type)
                    tw.writeExprs_eqexpr(id, type.javaResult.id, parent, idx)
                    tw.writeExprsKotlinType(id, type.kotlinResult.id)
                    binOp(id, c, callable, enclosingStmt)
                }
                isBuiltinCallInternal(c, "CHECK_NOT_NULL") -> {
                    if(c.origin != IrStatementOrigin.EXCLEXCL) {
                        logger.errorElement("Unexpected origin for CHECK_NOT_NULL: ${c.origin}", c)
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
                        extractTypeAccessRecursive(c.getTypeArgument(0)!!, locId, id, -1, callable, enclosingStmt, TypeContext.GENERIC_ARGUMENT)
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
                                extractTypeAccessRecursive(c.getTypeArgument(0)!!, locId, id, -1, callable, enclosingStmt, TypeContext.GENERIC_ARGUMENT)
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
                isFunction(target, "kotlin", "(some array type)", { isArrayType(it) }, "get") && c.origin == IrStatementOrigin.GET_ARRAY_ELEMENT -> {
                    val id = tw.getFreshIdLabel<DbArrayaccess>()
                    val type = useType(c.type)
                    tw.writeExprs_arrayaccess(id, type.javaResult.id, parent, idx)
                    tw.writeExprsKotlinType(id, type.kotlinResult.id)
                    binopDisp(id)
                }
                isFunction(target, "kotlin", "(some array type)", { isArrayType(it) }, "set") && c.origin == IrStatementOrigin.EQ -> {
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
                        logger.errorElement("Expected to find only one argument for a kotlin.jvm.internal.<unsafe-coerce>() call", c)
                        return
                    }

                    if (c.typeArgumentsCount != 2) {
                        logger.errorElement("Expected to find two type arguments for a kotlin.jvm.internal.<unsafe-coerce>() call", c)
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
                    extractTypeAccessRecursive(c.getTypeArgument(1)!!, locId, id, 0, callable, enclosingStmt)
                    extractExpressionExpr(c.getValueArgument(0)!!, callable, id, 1, enclosingStmt)
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

    private fun extractConstructorCall(
        e: IrFunctionAccessExpression,
        parent: Label<out DbExprparent>,
        idx: Int,
        callable: Label<out DbCallable>,
        enclosingStmt: Label<out DbStmt>
    ) {
        val isAnonymous = e.type.isAnonymous
        val type: TypeResults = if (isAnonymous) {
            if (e.typeArgumentsCount > 0) {
                logger.warn("Unexpected type arguments for anonymous class constructor call")
            }
            val c = (e.type as IrSimpleType).classifier.owner as IrClass
            useAnonymousClass(c)
        } else {
            useType(e.type)
        }
        val locId = tw.getLocation(e)
        val id = extractNewExpr(e.symbol.owner, (e.type as? IrSimpleType)?.arguments, type, locId, parent, idx, callable, enclosingStmt)

        if (isAnonymous) {
            @Suppress("UNCHECKED_CAST")
            tw.writeIsAnonymClass(type.javaResult.id as Label<DbClass>, id)
        }

        for (i in 0 until e.valueArgumentsCount) {
            val arg = e.getValueArgument(i)
            if (arg != null) {
                extractExpressionExpr(arg, callable, id, i, enclosingStmt)
            }
        }
        val dr = e.dispatchReceiver
        if (dr != null) {
            extractExpressionExpr(dr, callable, id, -2, enclosingStmt)
        }

        val typeAccessType = if (isAnonymous) {
            val c = (e.type as IrSimpleType).classifier.owner as IrClass
            if (c.superTypes.size == 1) {
                useType(c.superTypes.first())
            } else {
                useType(pluginContext.irBuiltIns.anyType)
            }
        } else {
            type
        }

        if (e is IrConstructorCall) {
            extractConstructorTypeAccess(e.type, typeAccessType, e.symbol, locId, id, -3, callable, enclosingStmt)
        } else {
            val typeAccessId =
                extractTypeAccess(typeAccessType, locId, id, -3, callable, enclosingStmt)

            extractTypeArguments(e, typeAccessId, callable, enclosingStmt)
        }
    }

    private val loopIdMap: MutableMap<IrLoop, Label<out DbKtloopstmt>> = mutableMapOf()

    // todo: add all declaration types, not only IrFunctions.
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

    fun getStatementOriginOperator(origin: IrStatementOrigin?) = when (origin) {
        IrStatementOrigin.PLUSEQ -> "plus"
        IrStatementOrigin.MINUSEQ -> "minus"
        IrStatementOrigin.MULTEQ -> "times"
        IrStatementOrigin.DIVEQ -> "div"
        IrStatementOrigin.PERCEQ -> "rem"
        else -> null
    }

    fun getUpdateInPlaceRHS(origin: IrStatementOrigin?, isExpectedLhs: (IrExpression?) -> Boolean, updateRhs: IrExpression): IrExpression? {
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
        } ?: null
    }

    fun writeUpdateInPlaceExpr(origin: IrStatementOrigin, tw: TrapWriter, id: Label<DbAssignexpr>, type: TypeResults, exprParent: ExprParent): Boolean {
        when(origin) {
            IrStatementOrigin.PLUSEQ -> tw.writeExprs_assignaddexpr(id as Label<DbAssignaddexpr>, type.javaResult.id, exprParent.parent, exprParent.idx)
            IrStatementOrigin.MINUSEQ -> tw.writeExprs_assignsubexpr(id as Label<DbAssignsubexpr>, type.javaResult.id, exprParent.parent, exprParent.idx)
            IrStatementOrigin.MULTEQ -> tw.writeExprs_assignmulexpr(id as Label<DbAssignmulexpr>, type.javaResult.id, exprParent.parent, exprParent.idx)
            IrStatementOrigin.DIVEQ -> tw.writeExprs_assigndivexpr(id as Label<DbAssigndivexpr>, type.javaResult.id, exprParent.parent, exprParent.idx)
            IrStatementOrigin.PERCEQ -> tw.writeExprs_assignremexpr(id as Label<DbAssignremexpr>, type.javaResult.id, exprParent.parent, exprParent.idx)
            else -> return false
        }
        return true
    }

    fun tryExtractArrayUpdate(e: IrContainerExpression, callable: Label<out DbCallable>, parent: StmtExprParent): Boolean {
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
                                getUpdateInPlaceRHS(
                                    e.origin, // Using e.origin not arraySetCall.origin here distinguishes a compiler-generated block from a user manually code that looks the same.
                                    {   oldValue ->
                                        oldValue is IrCall &&
                                        isFunction(oldValue.symbol.owner, "kotlin", "(some array type)", { typeName -> isArrayType(typeName) }, "get") &&
                                        (oldValue.dispatchReceiver as? IrGetValue)?.let {
                                            receiverVal -> receiverVal.symbol.owner == arrayVarDecl.symbol.owner
                                        } ?: false
                                    },
                                    arraySetCall.getValueArgument(1)!!
                                )?.let { updateRhs ->
                                    // Create an assignment skeleton _ op= _
                                    val exprParent = parent.expr(e, callable)
                                    val assignId = tw.getFreshIdLabel<DbAssignexpr>()
                                    val type = useType(arrayVarInitializer.type)
                                    val locId = tw.getLocation(e)
                                    tw.writeExprsKotlinType(assignId, type.kotlinResult.id)
                                    tw.writeHasLocation(assignId, locId)
                                    tw.writeCallableEnclosingExpr(assignId, callable)
                                    tw.writeStatementEnclosingExpr(assignId, exprParent.enclosingStmt)

                                    if (!writeUpdateInPlaceExpr(e.origin!!, tw, assignId, type, exprParent)) {
                                        logger.errorElement("Unexpected origin", e)
                                        return false
                                    }

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

    fun extractExpressionStmt(e: IrExpression, callable: Label<out DbCallable>, parent: Label<out DbStmtparent>, idx: Int) {
        extractExpression(e, callable, StmtParent(parent, idx))
    }

    fun extractExpressionExpr(e: IrExpression, callable: Label<out DbCallable>, parent: Label<out DbExprparent>, idx: Int, enclosingStmt: Label<out DbStmt>) {
        extractExpression(e, callable, ExprParent(parent, idx, enclosingStmt))
    }

    fun extractExpression(e: IrExpression, callable: Label<out DbCallable>, parent: StmtExprParent) {
        with("expression", e) {
            when(e) {
                is IrDelegatingConstructorCall -> {
                    val stmtParent = parent.stmt(e, callable)

                    val irCallable = declarationStack.peek()

                    val delegatingClass = e.symbol.owner.parent as IrClass
                    val currentClass = irCallable.parent as IrClass

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
                    @Suppress("UNCHECKED_CAST")
                    tw.writeCallableBinding(id as Label<DbCaller>, methodId)
                    for (i in 0 until e.valueArgumentsCount) {
                        val arg = e.getValueArgument(i)
                        if (arg != null) {
                            extractExpressionExpr(arg, callable, id, i, id)
                        }
                    }
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
                    val stmtParent = parent.stmt(e, callable)
                    val id = tw.getFreshIdLabel<DbWhilestmt>()
                    loopIdMap[e] = id
                    val locId = tw.getLocation(e)
                    tw.writeStmts_whilestmt(id, stmtParent.parent, stmtParent.idx, callable)
                    tw.writeHasLocation(id, locId)
                    extractExpressionExpr(e.condition, callable, id, 0, id)
                    val body = e.body
                    if(body != null) {
                        extractExpressionStmt(body, callable, id, 1)
                    }
                    loopIdMap.remove(e)
                }
                is IrDoWhileLoop -> {
                    val stmtParent = parent.stmt(e, callable)
                    val id = tw.getFreshIdLabel<DbDostmt>()
                    loopIdMap[e] = id
                    val locId = tw.getLocation(e)
                    tw.writeStmts_dostmt(id, stmtParent.parent, stmtParent.idx, callable)
                    tw.writeHasLocation(id, locId)
                    extractExpressionExpr(e.condition, callable, id, 0, id)
                    val body = e.body
                    if(body != null) {
                        extractExpressionStmt(body, callable, id, 1)
                    }
                    loopIdMap.remove(e)
                }
                is IrInstanceInitializerCall -> {
                    val stmtParent = parent.stmt(e, callable)
                    val irConstructor = declarationStack.peek() as? IrConstructor
                    if (irConstructor == null) {
                        logger.warnElement("IrInstanceInitializerCall outside constructor", e)
                        return
                    }
                    extractInstanceInitializerBlock(stmtParent, irConstructor)
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
                        val id = tw.getFreshIdLabel<DbThisaccess>()
                        val type = useType(e.type)
                        val locId = tw.getLocation(e)
                        tw.writeExprs_thisaccess(id, type.javaResult.id, exprParent.parent, exprParent.idx)
                        tw.writeExprsKotlinType(id, type.kotlinResult.id)
                        tw.writeHasLocation(id, locId)
                        tw.writeCallableEnclosingExpr(id, callable)
                        tw.writeStatementEnclosingExpr(id, exprParent.enclosingStmt)


                        fun extractTypeAccess(parent: IrClass){
                            extractTypeAccessRecursive(parent.typeWith(listOf()), locId, id, 0, callable, exprParent.enclosingStmt)
                        }

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
                    } else {
                        val id = tw.getFreshIdLabel<DbVaraccess>()
                        val type = useType(e.type)
                        val locId = tw.getLocation(e)
                        tw.writeExprs_varaccess(id, type.javaResult.id, exprParent.parent, exprParent.idx)
                        tw.writeExprsKotlinType(id, type.kotlinResult.id)
                        tw.writeHasLocation(id, locId)
                        tw.writeCallableEnclosingExpr(id, callable)
                        tw.writeStatementEnclosingExpr(id, exprParent.enclosingStmt)

                        val vId = if (owner is IrValueParameter && owner.isExtensionReceiver())
                            useValueParameter(owner, useFunction(owner.parent as IrFunction))
                        else
                            useValueDeclaration(owner)
                        tw.writeVariableBinding(id, vId)
                    }
                }
                is IrGetField -> {
                    val exprParent = parent.expr(e, callable)
                    val id = tw.getFreshIdLabel<DbVaraccess>()
                    val type = useType(e.type)
                    val locId = tw.getLocation(e)
                    tw.writeExprs_varaccess(id, type.javaResult.id, exprParent.parent, exprParent.idx)
                    tw.writeExprsKotlinType(id, type.kotlinResult.id)
                    tw.writeHasLocation(id, locId)
                    tw.writeCallableEnclosingExpr(id, callable)
                    tw.writeStatementEnclosingExpr(id, exprParent.enclosingStmt)
                    val owner = tryReplaceAndroidSyntheticField(e.symbol.owner)
                    val vId = useField(owner)
                    tw.writeVariableBinding(id, vId)
                    tw.writeStatementEnclosingExpr(id, exprParent.enclosingStmt)

                    val receiver = e.receiver
                    if (receiver != null) {
                        extractExpressionExpr(receiver, callable, id, -1, exprParent.enclosingStmt)
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
                                if (!writeUpdateInPlaceExpr(e.origin!!, tw, id, type, exprParent)) {
                                    logger.errorElement("Unexpected origin", e)
                                    return
                                }
                            } else {
                                tw.writeExprs_assignexpr(id, type.javaResult.id, exprParent.parent, exprParent.idx)
                            }

                            val lhsType = useType(e.symbol.owner.type)
                            tw.writeExprs_varaccess(lhsId, lhsType.javaResult.id, id, 0)
                            tw.writeExprsKotlinType(lhsId, lhsType.kotlinResult.id)
                            val vId = useValueDeclaration(e.symbol.owner)
                            tw.writeVariableBinding(lhsId, vId)
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
                            }
                        }
                        else -> {
                            logger.errorElement("Unhandled IrSet* element.", e)
                        }
                    }
                }
                is IrWhen -> {
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

                    val fnInterfaceType = getFunctionalInterfaceType(types)
                    val id = extractGeneratedClass(
                        e.function, // We're adding this function as a member, and changing its name to `invoke` to implement `kotlin.FunctionX<,,,>.invoke(,,)`
                        listOf(pluginContext.irBuiltIns.anyType, fnInterfaceType))

                    val isBigArity = types.size > BuiltInFunctionArity.BIG_ARITY
                    if (isBigArity) {
                        implementFunctionNInvoke(e.function, ids, locId, parameters)
                    }

                    val exprParent = parent.expr(e, callable)
                    val idLambdaExpr = tw.getFreshIdLabel<DbLambdaexpr>()
                    tw.writeExprs_lambdaexpr(idLambdaExpr, ids.type.javaResult.id, exprParent.parent, exprParent.idx)
                    tw.writeExprsKotlinType(idLambdaExpr, ids.type.kotlinResult.id)
                    tw.writeHasLocation(idLambdaExpr, locId)
                    tw.writeCallableEnclosingExpr(idLambdaExpr, callable)
                    tw.writeStatementEnclosingExpr(idLambdaExpr, exprParent.enclosingStmt)
                    tw.writeCallableBinding(idLambdaExpr, ids.constructor)

                    extractTypeAccessRecursive(fnInterfaceType, locId, idLambdaExpr, -3, callable, exprParent.enclosingStmt)

                    // todo: fix hard coded block body of lambda
                    tw.writeLambdaKind(idLambdaExpr, 1)

                    tw.writeIsAnonymClass(id, idLambdaExpr)
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

    private fun IrValueParameter.isExtensionReceiver(): Boolean {
        val parentFun = parent as? IrFunction ?: return false
        return parentFun.extensionReceiverParameter == this
    }

    private open inner class GeneratedClassHelper(protected val locId: Label<DbLocation>, protected val ids: GeneratedClassLabels) {

        protected fun writeExpressionMetadataToTrapFile(id: Label<out DbExpr>, callable: Label<out DbCallable>, stmt: Label<out DbStmt>) {
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
            val paramType = extractValueParameter(paramId, paramType, paramName, locId, ids.constructor, paramIdx, null, paramId, false)

            val assignmentStmtId = tw.getFreshIdLabel<DbExprstmt>()
            tw.writeStmts_exprstmt(assignmentStmtId, ids.constructorBlock, stmtIdx, ids.constructor)
            tw.writeHasLocation(assignmentStmtId, locId)

            val assignmentId = tw.getFreshIdLabel<DbAssignexpr>()
            tw.writeExprs_assignexpr(assignmentId, paramType.javaResult.id, assignmentStmtId, 0)
            tw.writeExprsKotlinType(assignmentId, paramType.kotlinResult.id)
            writeExpressionMetadataToTrapFile(assignmentId, ids.constructor, assignmentStmtId)

            val lhsId = tw.getFreshIdLabel<DbVaraccess>()
            tw.writeExprs_varaccess(lhsId, paramType.javaResult.id, assignmentId, 0)
            tw.writeExprsKotlinType(lhsId, paramType.kotlinResult.id)
            tw.writeVariableBinding(lhsId, fieldId)
            writeExpressionMetadataToTrapFile(lhsId, ids.constructor, assignmentStmtId)

            val thisId = tw.getFreshIdLabel<DbThisaccess>()
            tw.writeExprs_thisaccess(thisId, ids.type.javaResult.id, lhsId, -1)
            tw.writeExprsKotlinType(thisId, ids.type.kotlinResult.id)
            writeExpressionMetadataToTrapFile(thisId, ids.constructor, assignmentStmtId)

            val rhsId = tw.getFreshIdLabel<DbVaraccess>()
            tw.writeExprs_varaccess(rhsId, paramType.javaResult.id, assignmentId, 1)
            tw.writeExprsKotlinType(rhsId, paramType.kotlinResult.id)
            tw.writeVariableBinding(rhsId, paramId)
            writeExpressionMetadataToTrapFile(rhsId, ids.constructor, assignmentStmtId)
        }
    }

    private inner class CallableReferenceHelper(private val callableReferenceExpr: IrCallableReference<out IrSymbol>, locId: Label<DbLocation>, ids: GeneratedClassLabels)
        : GeneratedClassHelper(locId, ids) {

        private val dispatchReceiver = callableReferenceExpr.dispatchReceiver
        private val extensionReceiver = callableReferenceExpr.extensionReceiver
        private val receiverType = callableReferenceExpr.dispatchReceiver?.type ?: callableReferenceExpr.extensionReceiver?.type

        private val dispatchFieldId: Label<DbField>? = if (dispatchReceiver != null) tw.getFreshIdLabel() else null
        private val extensionFieldId: Label<DbField>? = if (extensionReceiver != null) tw.getFreshIdLabel() else null
        private val extensionParameterIndex: Int = if (dispatchReceiver != null) 1 else 0

        fun extractReceiverField(classId: Label<out DbClass>) {
            val firstAssignmentStmtIdx = 1

            // only one of the following can be non-null:
            if (dispatchReceiver != null) {
                extractField(dispatchFieldId!!, "<dispatchReceiver>", receiverType!!, classId, locId, DescriptorVisibilities.PRIVATE, callableReferenceExpr, false)
                extractParameterToFieldAssignmentInConstructor("<dispatchReceiver>", dispatchReceiver.type, dispatchFieldId!!, 0, firstAssignmentStmtIdx)
            }

            if (extensionReceiver != null) {
                extractField(extensionFieldId!!, "<extensionReceiver>", receiverType!!, classId, locId, DescriptorVisibilities.PRIVATE, callableReferenceExpr, false)
                extractParameterToFieldAssignmentInConstructor( "<extensionReceiver>", extensionReceiver.type, extensionFieldId!!, 0 + extensionParameterIndex, firstAssignmentStmtIdx + extensionParameterIndex)
            }
        }

        private fun writeVariableAccessInFunctionBody(pType: TypeResults, idx: Int, variable: Label<out DbVariable>,
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
            val thisId = tw.getFreshIdLabel<DbThisaccess>()
            tw.writeExprs_thisaccess(thisId, ids.type.javaResult.id, accessId, -1)
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
            var accessId = tw.getFreshIdLabel<DbVaraccess>()
            tw.writeExprs_varaccess(accessId, fieldType.javaResult.id, parent, 0)
            tw.writeExprsKotlinType(accessId, fieldType.kotlinResult.id)

            writeExpressionMetadataToTrapFile(accessId, labels.methodId, stmt)

            val fieldId = useField(target.owner)
            tw.writeVariableBinding(accessId, fieldId)

            if (dispatchReceiver != null) {
                writeFieldAccessInFunctionBody(receiverType!!, -1, dispatchFieldId!!, accessId, labels.methodId, stmt)
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
            isBigArity: Boolean = false,                                // whether a big arity `invoke` is being extracted
            bigArityParameterTypes: List<IrType>? = null                // parameter types used for the cast expressions in the big arity `invoke` invocation
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
                var callId = tw.getFreshIdLabel<DbMethodaccess>()
                tw.writeExprs_methodaccess(callId, callType.javaResult.id, retId, 0)
                tw.writeExprsKotlinType(callId, callType.kotlinResult.id)
                extractTypeArguments(expressionTypeArgs, locId, callId, labels.methodId, retId, -2, true)
                callId
            }

            writeExpressionMetadataToTrapFile(callId, labels.methodId, retId)

            val callableId = useFunction<DbCallable>(target.owner.realOverrideTarget, classTypeArgsIncludingOuterClasses)
            @Suppress("UNCHECKED_CAST")
            tw.writeCallableBinding(callId as Label<out DbCaller>, callableId)

            val useFirstArgAsDispatch: Boolean
            if (dispatchReceiver != null) {
                writeFieldAccessInFunctionBody(receiverType!!, dispatchReceiverIdx, dispatchFieldId!!, callId, labels.methodId, retId)

                useFirstArgAsDispatch = false
            } else {
                useFirstArgAsDispatch = target.owner.dispatchReceiverParameter != null
            }

            val extensionIdxOffset: Int
            if (extensionReceiver != null) {
                writeFieldAccessInFunctionBody(receiverType!!, 0, extensionFieldId!!, callId, labels.methodId, retId)
                extensionIdxOffset = 1
            } else {
                extensionIdxOffset = 0
            }

            if (isBigArity) {
                // In case we're extracting a big arity function reference:
                addArgumentsToInvocationInInvokeNBody(
                    bigArityParameterTypes!!, labels, retId, callId, locId,
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
            if (dispatchReceiver != null) {
                extractExpressionExpr(dispatchReceiver, callable, idCtorRef, 0, enclosingStmt)
            }

            if (extensionReceiver != null) {
                extractExpressionExpr(extensionReceiver, callable, idCtorRef, 0 + extensionParameterIndex, enclosingStmt)
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
            // The base class could be `Any`. `PropertyReference` is used to keep symmetry with function references.
            val baseClass = pluginContext.referenceClass(FqName("kotlin.jvm.internal.PropertyReference"))?.owner?.typeWith()
                ?: pluginContext.irBuiltIns.anyType

            val classId = extractGeneratedClass(ids, listOf(baseClass, kPropertyType), locId, currentDeclaration)

            val helper = CallableReferenceHelper(propertyReferenceExpr, locId, ids)
            val parameterTypes = kPropertyType.arguments.map { it as IrType }

            helper.extractReceiverField(classId)

            val classTypeArguments = (propertyReferenceExpr.dispatchReceiver?.type as? IrSimpleType)?.arguments ?:
                if ((getter?.owner?.dispatchReceiverParameter ?: setter?.owner?.dispatchReceiverParameter )!= null) { (kPropertyType.arguments.first() as? IrSimpleType)?.arguments } else { null }

            val expressionTypeArguments = (0 until propertyReferenceExpr.typeArgumentsCount).mapNotNull { propertyReferenceExpr.getTypeArgument(it) }

            val idPropertyRef = tw.getFreshIdLabel<DbPropertyref>()

            if (getter != null) {
                val getterParameterTypes = parameterTypes.dropLast(1)
                val getLabels = addFunctionManual(tw.getFreshIdLabel(), "get", getterParameterTypes, parameterTypes.last(), classId, locId)
                val getterCallableId = useFunction<DbCallable>(getter.owner.realOverrideTarget, classTypeArguments)

                helper.extractCallToReflectionTarget(
                    getLabels,
                    getter,
                    parameterTypes.last(),
                    expressionTypeArguments,
                    classTypeArguments
                )

                tw.writePropertyRefGetBinding(idPropertyRef, getterCallableId)
            } else {
                // Property without a getter.
                if (backingField == null) {
                    logger.errorElement("Expected to find getter or backing field for property reference.", propertyReferenceExpr)
                    return
                }

                val getterParameterTypes = parameterTypes.dropLast(1)
                val getLabels = addFunctionManual(tw.getFreshIdLabel(), "get", getterParameterTypes, parameterTypes.last(), classId, locId)
                val fieldId = useField(backingField.owner)

                helper.extractFieldReturnOfReflectionTarget(
                    getLabels,
                    backingField)

                tw.writePropertyRefFieldBinding(idPropertyRef, fieldId)
            }

            if (setter != null) {
                val setLabels = addFunctionManual(tw.getFreshIdLabel(), "set", parameterTypes, pluginContext.irBuiltIns.unitType, classId, locId)

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
                    val setLabels = addFunctionManual(tw.getFreshIdLabel(), "set", parameterTypes, pluginContext.irBuiltIns.unitType, classId, locId)
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
                logger.errorElement("Expected to find reflection target for function reference. Using underlying symbol instead.", functionReferenceExpr)
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

            val parameterTypes = type.arguments.map { it as IrType }

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

            val targetCallableId = useFunction<DbCallable>(target.owner.realOverrideTarget, classTypeArguments)
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

            val helper = CallableReferenceHelper(functionReferenceExpr, locId, ids)

            val fnInterfaceType = getFunctionalInterfaceTypeWithTypeArgs(type.arguments)

            val currentDeclaration = declarationStack.peek()
            // `FunctionReference` base class is required, because that's implementing `KFunction`.
            val baseClass = pluginContext.referenceClass(FqName("kotlin.jvm.internal.FunctionReference"))?.owner?.typeWith()
                ?: pluginContext.irBuiltIns.anyType

            val classId = extractGeneratedClass(ids, listOf(baseClass, fnInterfaceType), locId, currentDeclaration)

            helper.extractReceiverField(classId)

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
                isBigArity,
                parameterTypes.dropLast(1))

            // Add constructor (member ref) call:
            val exprParent = parent.expr(functionReferenceExpr, callable)
            val idMemberRef = tw.getFreshIdLabel<DbMemberref>()
            tw.writeExprs_memberref(idMemberRef, ids.type.javaResult.id, exprParent.parent, exprParent.idx)
            tw.writeExprsKotlinType(idMemberRef, ids.type.kotlinResult.id)
            tw.writeHasLocation(idMemberRef, locId)
            tw.writeCallableEnclosingExpr(idMemberRef, callable)
            tw.writeStatementEnclosingExpr(idMemberRef, exprParent.enclosingStmt)
            tw.writeCallableBinding(idMemberRef, ids.constructor)

            var typeAccessArguments = if (isBigArity) listOf(parameterTypes.last()) else parameterTypes
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

            tw.writeMemberRefBinding(idMemberRef, targetCallableId)

            helper.extractConstructorArguments(callable, idMemberRef, exprParent.enclosingStmt)

            tw.writeIsAnonymClass(classId, idMemberRef)
        }
    }

    private fun getFunctionalInterfaceType(functionNTypeArguments: List<IrType>) =
        if (functionNTypeArguments.size > BuiltInFunctionArity.BIG_ARITY) {
            pluginContext.referenceClass(FqName("kotlin.jvm.functions.FunctionN"))!!
                .typeWith(functionNTypeArguments.last())
        } else {
            functionN(pluginContext)(functionNTypeArguments.size - 1).typeWith(functionNTypeArguments)
        }

    private fun getFunctionalInterfaceTypeWithTypeArgs(functionNTypeArguments: List<IrTypeArgument>) =
        if (functionNTypeArguments.size > BuiltInFunctionArity.BIG_ARITY) {
            pluginContext.referenceClass(FqName("kotlin.jvm.functions.FunctionN"))!!
                .typeWithArguments(listOf(functionNTypeArguments.last()))
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
            val paramType = extractValueParameter(paramId, p, "a$idx", locId, methodId, idx, null, paramId, false)

            Pair(paramId, paramType)
        }

        val paramsSignature = parameters.joinToString(separator = ",", prefix = "(", postfix = ")") { it.second.javaResult.signature!! }

        val rt = useType(returnType, TypeContext.RETURN)
        tw.writeMethods(methodId, name, "$name$paramsSignature", rt.javaResult.id, parentId, methodId)
        tw.writeMethodsKotlinType(methodId, rt.kotlinResult.id)
        tw.writeHasLocation(methodId, locId)

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
        @Suppress("UNCHECKED_CAST")
        val funLabels = addFunctionNInvoke(tw.getFreshIdLabel(), lambda.returnType, ids.type.javaResult.id as Label<DbReftype>, locId)

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

    fun extractVarargElement(e: IrVarargElement, callable: Label<out DbCallable>, parent: Label<out DbExprparent>, idx: Int, enclosingStmt: Label<out DbStmt>) {
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
     * Extracts a single type access expression with no enclosing callable and statement.
     */
    private fun extractTypeAccess(type: TypeResults, location: Label<DbLocation>, parent: Label<out DbExprparent>, idx: Int): Label<out DbExpr> {
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
     * Extracts a type access expression and its child type access expressions in case of a generic type. Nested generics are also handled.
     * No enclosing callable and statement is extracted, this is useful for type access extraction in field declarations.
     */
    private fun extractTypeAccessRecursive(t: IrType, location: Label<DbLocation>, parent: Label<out DbExprparent>, idx: Int, typeContext: TypeContext = TypeContext.OTHER): Label<out DbExpr> {
        val typeAccessId = extractTypeAccess(useType(t, typeContext), location, parent, idx)
        if (t is IrSimpleType) {
            t.arguments.filterIsInstance<IrType>().forEachIndexed { argIdx, arg ->
                extractTypeAccessRecursive(arg, location, typeAccessId, argIdx, TypeContext.GENERIC_ARGUMENT)
            }
        }
        return typeAccessId
    }

    /**
     * Extracts a type access expression and its child type access expressions in case of a generic type. Nested generics are also handled.
     */
    private fun extractTypeAccessRecursive(t: IrType, location: Label<DbLocation>, parent: Label<out DbExprparent>, idx: Int, enclosingCallable: Label<out DbCallable>, enclosingStmt: Label<out DbStmt>, typeContext: TypeContext = TypeContext.OTHER): Label<out DbExpr> {
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
        extractTypeArguments((0 until c.typeArgumentsCount).map { c.getTypeArgument(it)!! }, tw.getLocation(c), parentExpr, enclosingCallable, enclosingStmt, startIndex, reverse)
    }

    fun extractTypeOperatorCall(e: IrTypeOperatorCall, callable: Label<out DbCallable>, parent: Label<out DbExprparent>, idx: Int, enclosingStmt: Label<out DbStmt>) {
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

                    val invokeMethod = functionType.classOrNull?.owner?.declarations?.filterIsInstance<IrFunction>()?.find { it.name.asString() == "invoke"}
                    if (invokeMethod == null) {
                        logger.errorElement("Couldn't find `invoke` method on functional interface.", e)
                        return
                    }

                    val typeOwner = e.typeOperandClassifier.owner
                    val samMember = if (typeOwner !is IrClass) {
                        logger.errorElement("Expected to find SAM conversion to IrClass. Found '${typeOwner.javaClass}' instead. Can't implement SAM interface.", e)
                        return
                    } else {
                        val samMember = typeOwner.declarations.filterIsInstance<IrFunction>().find { it is IrOverridableMember && it.modality == Modality.ABSTRACT }
                        if (samMember == null) {
                            logger.errorElement("Couldn't find SAM member in type '${typeOwner.kotlinFqName.asString()}'. Can't implement SAM interface.", e)
                            return
                        } else {
                            samMember
                        }
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
                    extractField(fieldId, "<fn>", functionType, classId, locId, DescriptorVisibilities.PRIVATE, e, false)

                    // adjust constructor
                    helper.extractParameterToFieldAssignmentInConstructor("<fn>", functionType, fieldId, 0, 1)

                    // add implementation function
                    extractFunction(samMember, classId, false, null, null, ids.function)

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
                    val callType = useType(samMember.returnType)
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
                        val paramType = useType(p.type)
                        tw.writeExprs_varaccess(argsAccessId, paramType.javaResult.id, parent, idx)
                        tw.writeExprsKotlinType(argsAccessId, paramType.kotlinResult.id)
                        extractCommonExpr(argsAccessId)
                        tw.writeVariableBinding(argsAccessId, useValueParameter(p, ids.function))
                    }

                    val isBigArity = st.arguments.size > BuiltInFunctionArity.BIG_ARITY
                    if (isBigArity) {
                        //<fn>.invoke(new Object[x]{vp0, vp1, vp2, ...})
                        val arrayCreationId = tw.getFreshIdLabel<DbArraycreationexpr>()
                        val arrayType = pluginContext.irBuiltIns.arrayClass.typeWith(pluginContext.irBuiltIns.anyNType)
                        val at = useType(arrayType)
                        tw.writeExprs_arraycreationexpr(arrayCreationId, at.javaResult.id, callId, 0)
                        tw.writeExprsKotlinType(arrayCreationId, at.kotlinResult.id)
                        extractCommonExpr(arrayCreationId)

                        extractTypeAccessRecursive(pluginContext.irBuiltIns.anyNType, locId, arrayCreationId, -1, ids.function, returnId)

                        val initId = tw.getFreshIdLabel<DbArrayinit>()
                        tw.writeExprs_arrayinit(initId, at.javaResult.id, arrayCreationId, -2)
                        tw.writeExprsKotlinType(initId, at.kotlinResult.id)
                        extractCommonExpr(initId)

                        for ((idx, vp) in parameters.withIndex()) {
                            extractArgument(vp, idx, initId)
                        }

                        val dim = parameters.size.toString()
                        val dimId = tw.getFreshIdLabel<DbIntegerliteral>()
                        val dimType = useType(pluginContext.irBuiltIns.intType)
                        tw.writeExprs_integerliteral(dimId, dimType.javaResult.id, arrayCreationId, 0)
                        tw.writeExprsKotlinType(dimId, dimType.kotlinResult.id)
                        extractCommonExpr(dimId)
                        tw.writeNamestrings(dim, dim, dimId)

                    } else {
                        //<fn>.invoke(vp0, cp1, vp2, vp3, ...) or
                        for ((idx, vp) in parameters.withIndex()) {
                            extractArgument(vp, idx, callId)
                        }
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

                    @Suppress("UNCHECKED_CAST")
                    tw.writeIsAnonymClass(ids.type.javaResult.id as Label<DbClass>, idNewexpr)

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
        id: Label<out DbBreakcontinuestmt>
    ) {
        with("break/continue", e) {
            val locId = tw.getLocation(e)
            tw.writeHasLocation(id, locId)
            val label = e.label
            if (label != null) {
                tw.writeNamestrings(label, "", id)
            }

            val loopId = loopIdMap[e.loop]
            if (loopId == null) {
                logger.errorElement("Missing break/continue target", e)
                return
            }

            tw.writeKtBreakContinueTargets(id, loopId)
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
        @Suppress("UNCHECKED_CAST")
        val id = ids.type.javaResult.id as Label<out DbClass>
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
        val superCallId = tw.getFreshIdLabel<DbSuperconstructorinvocationstmt>()
        tw.writeStmts_superconstructorinvocationstmt(superCallId, constructorBlockId, 0, ids.constructor)

        val baseConstructor = superTypes.first().classOrNull!!.owner.declarations.find { it is IrFunction && it.symbol is IrConstructorSymbol }
        val baseConstructorId = useFunction<DbConstructor>(baseConstructor as IrFunction)

        tw.writeHasLocation(superCallId, locId)
        @Suppress("UNCHECKED_CAST")
        tw.writeCallableBinding(superCallId as Label<DbCaller>, baseConstructorId)

        // TODO: We might need to add an `<obinit>` function, and a call to it to match other classes

        addModifiers(id, "final")
        addVisibilityModifierToLocalOrAnonymousClass(id)
        extractClassSupertypes(superTypes, listOf(), id)

        var parent: IrDeclarationParent? = currentDeclaration.parent
        while (parent != null) {
            // todo: merge this with the implementation in `extractClassSource`
            if (parent is IrClass) {
                val parentId =
                    if (parent.isAnonymousObject) {
                        @Suppress("UNCHECKED_CAST")
                        useAnonymousClass(parent).javaResult.id as Label<out DbClass>
                    } else {
                        useClassInstance(parent, listOf()).typeResult.id
                    }
                tw.writeEnclInReftype(id, parentId)

                break
            }

            if (parent is IrFile) {
                if (this.filePath != parent.path) {
                    logger.error("Unexpected file parent found")
                }
                val fileId = extractFileClass(parent)
                tw.writeEnclInReftype(id, fileId)
                break
            }

            parent = (parent as? IrDeclaration)?.parent
        }

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
            extractFunction(localFunction, id, true, null, listOf())

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
}
