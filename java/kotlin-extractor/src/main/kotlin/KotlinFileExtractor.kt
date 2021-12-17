package com.github.codeql

import com.github.codeql.comments.CommentExtractor
import com.github.codeql.utils.TypeSubstitution
import com.github.codeql.utils.versions.functionN
import com.github.codeql.utils.substituteTypeAndArguments
import com.github.codeql.utils.toRawType
import com.semmle.extractor.java.OdasaOutput
import org.jetbrains.kotlin.backend.common.extensions.IrPluginContext
import org.jetbrains.kotlin.builtins.functions.BuiltInFunctionArity
import org.jetbrains.kotlin.descriptors.*
import org.jetbrains.kotlin.descriptors.java.JavaVisibilities
import org.jetbrains.kotlin.ir.IrElement
import org.jetbrains.kotlin.ir.IrStatement
import org.jetbrains.kotlin.ir.declarations.*
import org.jetbrains.kotlin.ir.expressions.*
import org.jetbrains.kotlin.ir.symbols.IrConstructorSymbol
import org.jetbrains.kotlin.ir.symbols.IrSymbol
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
    externalClassExtractor: ExternalClassExtractor,
    primitiveTypeMapping: PrimitiveTypeMapping,
    pluginContext: IrPluginContext,
    genericSpecialisationsExtracted: MutableSet<String>
): KotlinUsesExtractor(logger, tw, dependencyCollector, externalClassExtractor, primitiveTypeMapping, pluginContext, genericSpecialisationsExtracted) {

    fun extractFileContents(file: IrFile, id: Label<DbFile>) {
        val locId = tw.getWholeFileLocation()
        val pkg = file.fqName.asString()
        val pkgId = extractPackage(pkg)
        tw.writeHasLocation(id, locId)
        tw.writeCupackage(id, pkgId)
        file.declarations.map { extractDeclaration(it) }
        CommentExtractor(this, file).extract()
    }

    fun extractDeclaration(declaration: IrDeclaration) {
        when (declaration) {
            is IrClass -> {
                if (isExternalDeclaration(declaration)) {
                    extractExternalClassLater(declaration)
                } else {
                    extractClassSource(declaration)
                }
            }
            is IrFunction -> {
                @Suppress("UNCHECKED_CAST")
                val parentId = useDeclarationParent(declaration.parent, false) as Label<DbReftype>
                extractFunctionIfReal(declaration, parentId, true, null, listOf())
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
            else -> logger.warnElement(Severity.ErrorSevere, "Unrecognised IrDeclaration: " + declaration.javaClass, declaration)
        }
    }



    fun getLabel(element: IrElement) : String? {
        when (element) {
            is IrFile -> return "@\"${element.path};sourcefile\"" // todo: remove copy-pasted code
            is IrClass -> return getClassLabel(element, listOf()).classLabel
            is IrTypeParameter -> return getTypeParameterLabel(element)
            is IrFunction -> return getFunctionLabel(element)
            is IrValueParameter -> return getValueParameterLabel(element, null)
            is IrProperty -> return getPropertyLabel(element)
            is IrField -> return getFieldLabel(element)
            is IrEnumEntry -> return getEnumEntryLabel(element)

            // Fresh entities:
            is IrBody -> return null
            is IrExpression -> return null

            // todo add others:
            else -> {
                logger.warnElement(Severity.ErrorSevere, "Unhandled element type: ${element::class}", element)
                return null
            }
        }
    }

    fun extractTypeParameter(tp: IrTypeParameter, apparentIndex: Int): Label<out DbTypevariable> {
        val id = tw.getLabelFor<DbTypevariable>(getTypeParameterLabel(tp))

        val parentId: Label<out DbClassorinterfaceorcallable> = when (val parent = tp.parent) {
            is IrFunction -> useFunction(parent)
            is IrClass -> useClassSource(parent)
            else -> {
                logger.warnElement(Severity.ErrorSevere, "Unexpected type parameter parent", tp)
                fakeLabel()
            }
        }

        // Note apparentIndex does not necessarily equal `tp.index`, because at least constructor type parameters
        // have indices offset from the type parameters of the constructed class (i.e. the parameter S of
        // `class Generic<T> { public <S> Generic(T t, S s) { ... } }` will have `tp.index` 1, not 0).
        tw.writeTypeVars(id, tp.name.asString(), apparentIndex, 0, parentId)
        val locId = tw.getLocation(tp)
        tw.writeHasLocation(id, locId)

        // todo: add type bounds

        return id
    }

    fun extractVisibility(elementForLocation: IrElement, id: Label<out DbModifiable>, v: DescriptorVisibility) {
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
                    else -> logger.warnElement(Severity.ErrorSevere, "Unexpected delegated visibility: $v", elementForLocation)
                }
            }
            else -> logger.warnElement(Severity.ErrorSevere, "Unexpected visibility: $v", elementForLocation)
        }
    }

    fun extractClassModifiers(c: IrClass, id: Label<out DbClassorinterface>) {
        when (c.modality) {
            Modality.FINAL -> addModifiers(id, "final")
            Modality.SEALED -> addModifiers(id, "sealed")
            Modality.OPEN -> { } // This is the default
            Modality.ABSTRACT -> addModifiers(id, "abstract")
            else -> logger.warnElement(Severity.ErrorSevere, "Unexpected class modality: ${c.modality}", c)
        }
        extractVisibility(c, id, c.visibility)
    }

    // `argsIncludingOuterClasses` can be null to describe a raw generic type.
    // For non-generic types it will be zero-length list.
    fun extractClassInstance(c: IrClass, argsIncludingOuterClasses: List<IrTypeArgument>?): Label<out DbClassorinterface> {
        if (argsIncludingOuterClasses?.isEmpty() == true) {
            logger.warn(Severity.ErrorSevere, "Instance without type arguments: " + c.name.asString())
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

    // `typeArgs` can be null to describe a raw generic type.
    // For non-generic types it will be zero-length list.
    fun extractMemberPrototypes(c: IrClass, argsIncludingOuterClasses: List<IrTypeArgument>?, id: Label<out DbClassorinterface>) {
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
                is IrFunction -> extractFunctionIfReal(it, id, false, typeParamSubstitution, argsIncludingOuterClasses)
                is IrProperty -> extractProperty(it, id, false, typeParamSubstitution, argsIncludingOuterClasses)
                else -> {}
            }
        }
    }

    private fun extractLocalTypeDeclStmt(c: IrClass, callable: Label<out DbCallable>, parent: Label<out DbStmtparent>, idx: Int) {
        @Suppress("UNCHECKED_CAST")
        val id = extractClassSource(c) as Label<out DbClass>
        extractLocalTypeDeclStmt(id, c, callable, parent, idx)
    }

    private fun extractLocalTypeDeclStmt(id: Label<out DbClass>, locElement: IrElement, callable: Label<out DbCallable>, parent: Label<out DbStmtparent>, idx: Int) {
        val stmtId = tw.getFreshIdLabel<DbLocaltypedeclstmt>()
        tw.writeStmts_localtypedeclstmt(stmtId, parent, idx, callable)
        tw.writeIsLocalClassOrInterface(id, stmtId)
        val locId = tw.getLocation(locElement)
        tw.writeHasLocation(stmtId, locId)
    }

    fun extractClassSource(c: IrClass): Label<out DbClassorinterface> {
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
            c.declarations.map { extractDeclaration(it) }
            extractObjectInitializerFunction(c, id)
            if (c.isNonCompanionObject) {
                // For `object MyObject { ... }`, the .class has an
                // automatically-generated `public static final MyObject INSTANCE`
                // field that may be referenced from Java code, and is used in our
                // IrGetObjectValue support. We therefore need to fabricate it
                // here.
                val instance = useObjectClassInstance(c)
                val type = useSimpleTypeClass(c, emptyList(), false)
                tw.writeFields(instance.id, instance.name, type.javaResult.id, type.kotlinResult.id, id, instance.id)
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

    fun extractEnclosingClass(innerClass: IrClass, innerId: Label<out DbClassorinterface>, innerLocId: Label<DbLocation>, parentClassTypeArguments: List<IrTypeArgument>) {
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
                        tw.writeFields(instance.id, instance.name, type.javaResult.id, type.kotlinResult.id, innerId, instance.id)
                        tw.writeHasLocation(instance.id, innerLocId)
                        addModifiers(instance.id, "public", "static", "final")
                        @Suppress("UNCHECKED_CAST")
                        tw.writeClass_companion_object(parentId as Label<DbClass>, instance.id, innerId as Label<DbClass>)
                    }
                }

                break
            }

            parent = (parent as? IrDeclaration)?.parent
        }
    }

    data class FieldResult(val id: Label<DbField>, val name: String)

    fun useCompanionObjectClassInstance(c: IrClass): FieldResult? {
        val parent = c.parent
        if(!c.isCompanion) {
            logger.warn(Severity.ErrorSevere, "Using companion instance for non-companion class")
            return null
        }
        else if (parent !is IrClass) {
            logger.warn(Severity.ErrorSevere, "Using companion instance for non-companion class")
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
            logger.warn(Severity.ErrorSevere, "Using instance for non-object class")
        }
        val classId = useClassInstance(c, listOf()).typeResult.id
        val instanceName = "INSTANCE"
        val instanceLabel = "@\"field;{$classId};$instanceName\""
        val instanceId: Label<DbField> = tw.getLabelFor(instanceLabel)
        return FieldResult(instanceId, instanceName)
    }

    private fun extractValueParameter(vp: IrValueParameter, parent: Label<out DbCallable>, idx: Int, typeSubstitution: TypeSubstitution?, parentSourceDeclaration: Label<out DbCallable>): TypeResults {
        return extractValueParameter(useValueParameter(vp, parent), vp.type, vp.name.asString(), tw.getLocation(vp), parent, idx, typeSubstitution, useValueParameter(vp, parentSourceDeclaration))
    }

    private fun extractValueParameter(id: Label<out DbParam>, t: IrType, name: String, locId: Label<DbLocation>, parent: Label<out DbCallable>, idx: Int, typeSubstitution: TypeSubstitution?, paramSourceDeclaration: Label<out DbParam>): TypeResults {
        val substitutedType = typeSubstitution?.let { it(t, TypeContext.OTHER, pluginContext) } ?: t
        val type = useType(substitutedType)
        tw.writeParams(id, type.javaResult.id, type.kotlinResult.id, idx, parent, paramSourceDeclaration)
        tw.writeHasLocation(id, locId)
        tw.writeParamName(id, name)
        return type
    }

    private fun extractObjectInitializerFunction(c: IrClass, parentId: Label<out DbReftype>) {
        if (isExternalDeclaration(c)) {
            return
        }

        // add method:
        val obinitLabel = getFunctionLabel(c, "<obinit>", listOf(), pluginContext.irBuiltIns.unitType, extensionReceiverParameter = null, functionTypeParameters = listOf(), classTypeArguments = listOf())
        val obinitId = tw.getLabelFor<DbMethod>(obinitLabel)
        val returnType = useType(pluginContext.irBuiltIns.unitType)
        tw.writeMethods(obinitId, "<obinit>", "<obinit>()", returnType.javaResult.id, returnType.kotlinResult.id, parentId, obinitId)

        val locId = tw.getLocation(c)
        tw.writeHasLocation(obinitId, locId)

        // add body:
        val blockId = tw.getFreshIdLabel<DbBlock>()
        tw.writeStmts_block(blockId, obinitId, 0, obinitId)
        tw.writeHasLocation(blockId, locId)

        // body content with field initializers and init blocks
        var idx = 0
        for (decl in c.declarations) {
            when (decl) {
                is IrProperty -> {
                    val backingField = decl.backingField
                    val initializer = backingField?.initializer

                    if (backingField == null || backingField.isStatic || initializer == null) {
                        continue
                    }

                    val expr = initializer.expression

                    if (expr is IrGetValue && expr.origin == IrStatementOrigin.INITIALIZE_PROPERTY_FROM_PARAMETER) {
                        // TODO: this initialization should go into the default constructor
                        continue
                    }

                    val declLocId = tw.getLocation(decl)
                    val stmtId = tw.getFreshIdLabel<DbExprstmt>()
                    tw.writeStmts_exprstmt(stmtId, blockId, idx++, obinitId)
                    tw.writeHasLocation(stmtId, declLocId)
                    val assignmentId = tw.getFreshIdLabel<DbAssignexpr>()
                    val type = useType(expr.type)
                    tw.writeExprs_assignexpr(assignmentId, type.javaResult.id, type.kotlinResult.id, stmtId, 0)
                    tw.writeHasLocation(assignmentId, declLocId)
                    tw.writeCallableEnclosingExpr(assignmentId, obinitId)
                    tw.writeStatementEnclosingExpr(assignmentId, stmtId)

                    val lhsId = tw.getFreshIdLabel<DbVaraccess>()
                    val lhsType = useType(backingField.type)
                    tw.writeExprs_varaccess(lhsId, lhsType.javaResult.id, lhsType.kotlinResult.id, assignmentId, 0)
                    tw.writeHasLocation(lhsId, declLocId)
                    tw.writeCallableEnclosingExpr(lhsId, obinitId)
                    tw.writeStatementEnclosingExpr(lhsId, stmtId)
                    val vId = useField(backingField)
                    tw.writeVariableBinding(lhsId, vId)

                    extractExpressionExpr(expr, obinitId, assignmentId, 1, stmtId)
                }
                is IrAnonymousInitializer -> {
                    if (decl.isStatic) {
                        continue
                    }

                    for (stmt in decl.body.statements) {
                        extractStatement(stmt, obinitId, blockId, idx++)
                    }
                }
                else -> continue
            }
        }
    }

    fun extractFunctionIfReal(f: IrFunction, parentId: Label<out DbReftype>, extractBody: Boolean, typeSubstitution: TypeSubstitution?, classTypeArgsIncludingOuterClasses: List<IrTypeArgument>?) {
        if (f.origin == IrDeclarationOrigin.FAKE_OVERRIDE)
            return
        extractFunction(f, parentId, extractBody, typeSubstitution, classTypeArgsIncludingOuterClasses)
    }

    fun extractFunction(f: IrFunction, parentId: Label<out DbReftype>, extractBody: Boolean, typeSubstitution: TypeSubstitution?, classTypeArgsIncludingOuterClasses: List<IrTypeArgument>?): Label<out DbCallable> {
        DeclarationStackAdjuster(f).use {

            getFunctionTypeParameters(f).mapIndexed { idx, it -> extractTypeParameter(it, idx) }

            val locId = tw.getLocation(f)

            val id =
                if (f.isLocalFunction())
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
                val l = mutableListOf(t)
                l.addAll(paramTypes)
                l
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
                tw.writeConstrs(id as Label<DbConstructor>, shortName, "$shortName$paramsSignature", unitType.javaResult.id, unitType.kotlinResult.id, parentId, sourceDeclaration as Label<DbConstructor>)
            } else {
                val returnType = useType(substReturnType, TypeContext.RETURN)
                val shortName = getFunctionShortName(f)
                @Suppress("UNCHECKED_CAST")
                tw.writeMethods(id as Label<DbMethod>, shortName, "$shortName$paramsSignature", returnType.javaResult.id, returnType.kotlinResult.id, parentId, sourceDeclaration as Label<DbMethod>)
                // TODO: fix `sourceId`. It doesn't always match the method ID.
            }

            tw.writeHasLocation(id, locId)
            val body = f.body
            if (body != null && extractBody) {
                if (typeSubstitution != null)
                    logger.warnElement(Severity.ErrorSevere, "Type substitution should only be used to extract a function prototype, not the body", f)
                extractBody(body, id)
            }

            extractVisibility(f, id, f.visibility)

            return id
        }
    }

    fun extractField(f: IrField, parentId: Label<out DbReftype>): Label<out DbField> {
        DeclarationStackAdjuster(f).use {
            declarationStack.push(f)
            return extractField(useField(f), f.name.asString(), f.type, parentId, tw.getLocation(f), f.visibility, f, isExternalDeclaration(f))
        }
    }


    private fun extractField(id: Label<out DbField>, name: String, type: IrType, parentId: Label<out DbReftype>, locId: Label<DbLocation>, visibility: DescriptorVisibility, errorElement: IrElement, isExternalDeclaration: Boolean): Label<out DbField> {
        val t = useType(type)
        tw.writeFields(id, name, t.javaResult.id, t.kotlinResult.id, parentId, id)
        tw.writeHasLocation(id, locId)

        extractVisibility(errorElement, id, visibility)

        if (!isExternalDeclaration) {
            val fieldDeclarationId = tw.getFreshIdLabel<DbFielddecl>()
            tw.writeFielddecls(fieldDeclarationId, parentId)
            tw.writeFieldDeclaredIn(id, fieldDeclarationId, 0)
            tw.writeHasLocation(fieldDeclarationId, locId)

            extractTypeAccess(t, locId, fieldDeclarationId, 0)
        }

        return id
    }

    fun extractProperty(p: IrProperty, parentId: Label<out DbReftype>, extractBackingField: Boolean, typeSubstitution: TypeSubstitution?, classTypeArgs: List<IrTypeArgument>?) {
        DeclarationStackAdjuster(p).use {

            val visibility = p.visibility
            if (visibility is DelegatedDescriptorVisibility && visibility.delegate == Visibilities.InvisibleFake) {
                return
            }

            val id = useProperty(p, parentId)
            val locId = tw.getLocation(p)
            tw.writeKtProperties(id, p.name.asString())
            tw.writeHasLocation(id, locId)

            val bf = p.backingField
            val getter = p.getter
            val setter = p.setter

            if (getter != null) {
                @Suppress("UNCHECKED_CAST")
                val getterId = extractFunction(getter, parentId, extractBackingField, typeSubstitution, classTypeArgs) as Label<out DbMethod>
                tw.writeKtPropertyGetters(id, getterId)
            } else {
                if (p.modality != Modality.FINAL || !isExternalDeclaration(p)) {
                    logger.warnElement(Severity.ErrorSevere, "IrProperty without a getter", p)
                }
            }

            if (setter != null) {
                if (!p.isVar) {
                    logger.warnElement(Severity.ErrorSevere, "!isVar property with a setter", p)
                }
                @Suppress("UNCHECKED_CAST")
                val setterId = extractFunction(setter, parentId, extractBackingField, typeSubstitution, classTypeArgs) as Label<out DbMethod>
                tw.writeKtPropertySetters(id, setterId)
            } else {
                if (p.isVar && !isExternalDeclaration(p)) {
                    logger.warnElement(Severity.ErrorSevere, "isVar property without a setter", p)
                }
            }

            if (bf != null && extractBackingField) {
                val fieldId = extractField(bf, parentId)
                tw.writeKtPropertyBackingFields(id, fieldId)
            }

            extractVisibility(p, id, p.visibility)
        }
    }

    fun extractEnumEntry(ee: IrEnumEntry, parentId: Label<out DbReftype>) {
        DeclarationStackAdjuster(ee).use {
            val id = useEnumEntry(ee)
            val parent = ee.parent
            if (parent !is IrClass) {
                logger.warnElement(Severity.ErrorSevere, "Enum entry with unexpected parent: " + parent.javaClass, ee)
            } else if (parent.typeParameters.isNotEmpty()) {
                logger.warnElement(Severity.ErrorSevere, "Enum entry parent class has type parameters: " + parent.name, ee)
            } else {
                val type = useSimpleTypeClass(parent, emptyList(), false)
                tw.writeFields(id, ee.name.asString(), type.javaResult.id, type.kotlinResult.id, parentId, id)
                val locId = tw.getLocation(ee)
                tw.writeHasLocation(id, locId)
            }
        }
    }

    fun extractTypeAlias(ta: IrTypeAlias) {
        if (ta.typeParameters.isNotEmpty()) {
            // TODO: Extract this information
            logger.warn(Severity.ErrorSevere, "Type alias type parameters ignored for " + ta.render())
        }
        val id = useTypeAlias(ta)
        val locId = tw.getLocation(ta)
        // TODO: We don't really want to generate any Java types here; we only want the KT type:
        val type = useType(ta.expandedType)
        tw.writeKt_type_alias(id, ta.name.asString(), type.kotlinResult.id)
        tw.writeHasLocation(id, locId)
    }

    fun extractBody(b: IrBody, callable: Label<out DbCallable>) {
        when(b) {
            is IrBlockBody -> extractBlockBody(b, callable)
            is IrSyntheticBody -> extractSyntheticBody(b, callable)
            is IrExpressionBody -> {
                // TODO
                logger.warnElement(Severity.ErrorSevere, "Unhandled IrExpressionBody", b)
            }
            else -> {
                logger.warnElement(Severity.ErrorSevere, "Unrecognised IrBody: " + b.javaClass, b)
            }
        }
    }

    fun extractBlockBody(b: IrBlockBody, callable: Label<out DbCallable>) {
        val id = tw.getFreshIdLabel<DbBlock>()
        val locId = tw.getLocation(b)
        tw.writeStmts_block(id, callable, 0, callable)
        tw.writeHasLocation(id, locId)
        for((sIdx, stmt) in b.statements.withIndex()) {
            extractStatement(stmt, callable, id, sIdx)
        }
    }

    fun extractSyntheticBody(b: IrSyntheticBody, callable: Label<out DbCallable>) {
        when (b.kind) {
            IrSyntheticBodyKind.ENUM_VALUES -> tw.writeKtSyntheticBody(callable, 1)
            IrSyntheticBodyKind.ENUM_VALUEOF -> tw.writeKtSyntheticBody(callable, 2)
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
        val stmtId = tw.getFreshIdLabel<DbLocalvariabledeclstmt>()
        val locId = tw.getLocation(getVariableLocationProvider(v))
        tw.writeStmts_localvariabledeclstmt(stmtId, parent, idx, callable)
        tw.writeHasLocation(stmtId, locId)
        extractVariableExpr(v, callable, stmtId, 1, stmtId)
    }

    fun extractVariableExpr(v: IrVariable, callable: Label<out DbCallable>, parent: Label<out DbExprparent>, idx: Int, enclosingStmt: Label<out DbStmt>) {
        val varId = useVariable(v)
        val exprId = tw.getFreshIdLabel<DbLocalvariabledeclexpr>()
        val locId = tw.getLocation(getVariableLocationProvider(v))
        val type = useType(v.type)
        tw.writeLocalvars(varId, v.name.asString(), type.javaResult.id, type.kotlinResult.id, exprId)
        tw.writeHasLocation(varId, locId)
        tw.writeExprs_localvariabledeclexpr(exprId, type.javaResult.id, type.kotlinResult.id, parent, idx)
        tw.writeHasLocation(exprId, locId)
        tw.writeCallableEnclosingExpr(exprId, callable)
        tw.writeStatementEnclosingExpr(exprId, enclosingStmt)
        val i = v.initializer
        if(i != null) {
            extractExpressionExpr(i, callable, exprId, 0, enclosingStmt)
        }
    }

    fun extractStatement(s: IrStatement, callable: Label<out DbCallable>, parent: Label<out DbStmtparent>, idx: Int) {
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
                    logger.warnElement(Severity.ErrorSevere, "Expected to find local function", s)
                }
            }
            is IrLocalDelegatedProperty -> {
                // TODO:
                logger.warnElement(Severity.ErrorSevere, "Unhandled IrLocalDelegatedProperty", s)
            }
            else -> {
                logger.warnElement(Severity.ErrorSevere, "Unrecognised IrStatement: " + s.javaClass, s)
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
            logger.warnElement(Severity.ErrorSevere, "Unexpected dispatch receiver found", c)
        }

        if (c.valueArgumentsCount < 1) {
            logger.warnElement(Severity.ErrorSevere, "No arguments found", c)
            return
        }

        extractArgument(id, c, callable, enclosingStmt, 0, "Operand null")

        if (c.valueArgumentsCount > 1) {
            logger.warnElement(Severity.ErrorSevere, "Extra arguments found", c)
        }
    }

    private fun binOp(id: Label<out DbExpr>, c: IrCall, callable: Label<out DbCallable>, enclosingStmt: Label<out DbStmt>) {
        val locId = tw.getLocation(c)
        tw.writeHasLocation(id, locId)
        tw.writeCallableEnclosingExpr(id, callable)
        tw.writeStatementEnclosingExpr(id, enclosingStmt)

        val dr = c.dispatchReceiver
        if (dr != null) {
            logger.warnElement(Severity.ErrorSevere, "Unexpected dispatch receiver found", c)
        }

        if (c.valueArgumentsCount < 1) {
            logger.warnElement(Severity.ErrorSevere, "No arguments found", c)
            return
        }

        extractArgument(id, c, callable, enclosingStmt, 0, "LHS null")

        if (c.valueArgumentsCount < 2) {
            logger.warnElement(Severity.ErrorSevere, "No RHS found", c)
            return
        }

        extractArgument(id, c, callable, enclosingStmt, 1, "RHS null")

        if (c.valueArgumentsCount > 2) {
            logger.warnElement(Severity.ErrorSevere, "Extra arguments found", c)
        }
    }

    private fun extractArgument(id: Label<out DbExpr>, c: IrCall, callable: Label<out DbCallable>, enclosingStmt: Label<out DbStmt>, idx: Int, msg: String) {
        val op = c.getValueArgument(idx)
        if (op == null) {
            logger.warnElement(Severity.ErrorSevere, msg, c)
        } else {
            extractExpressionExpr(op, callable, id, idx, enclosingStmt)
        }
    }

    fun extractCall(c: IrCall, callable: Label<out DbCallable>, parent: Label<out DbExprparent>, idx: Int, enclosingStmt: Label<out DbStmt>) {
        fun isFunction(pkgName: String, className: String, fName: String, hasQuestionMark: Boolean = false): Boolean {
            val verbose = false
            fun verboseln(s: String) { if(verbose) println(s) }
            verboseln("Attempting match for $pkgName $className $fName")
            val target = c.symbol.owner
            if (target.name.asString() != fName) {
                verboseln("No match as function name is ${target.name.asString()} not $fName")
                return false
            }
            val extensionReceiverParameter = target.extensionReceiverParameter
            val targetClass = if (extensionReceiverParameter == null) {
                                  target.parent
                              } else {
                                  val st = extensionReceiverParameter.type as? IrSimpleType
                                  if (st?.hasQuestionMark != hasQuestionMark) {
                                      verboseln("Nullablility of type didn't match")
                                      return false
                                  }
                                  st?.classifier?.owner
                              }
            if (targetClass !is IrClass) {
                verboseln("No match as didn't find target class")
                return false
            }
            if (targetClass.name.asString() != className) {
                verboseln("No match as class name is ${targetClass.name.asString()} not $className")
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

        fun isNumericFunction(fName: String): Boolean {
            return isFunction("kotlin", "Int", fName) ||
                   isFunction("kotlin", "Byte", fName) ||
                   isFunction("kotlin", "Short", fName) ||
                   isFunction("kotlin", "Long", fName) ||
                   isFunction("kotlin", "Float", fName) ||
                   isFunction("kotlin", "Double", fName)
        }

        fun extractMethodAccess(syntacticCallTarget: IrFunction, extractMethodTypeArguments: Boolean = true, extractClassTypeArguments: Boolean = false) {
            val callTarget = syntacticCallTarget.target
            val id = tw.getFreshIdLabel<DbMethodaccess>()
            val type = useType(c.type)
            val locId = tw.getLocation(c)
            tw.writeExprs_methodaccess(id, type.javaResult.id, type.kotlinResult.id, parent, idx)
            tw.writeHasLocation(id, locId)
            tw.writeCallableEnclosingExpr(id, callable)
            tw.writeStatementEnclosingExpr(id, enclosingStmt)

            if (extractMethodTypeArguments) {
                // type arguments at index -2, -3, ...
                extractTypeArguments(c, id, callable, enclosingStmt, -2, true)
            }

            if (callTarget.isLocalFunction()) {
                val ids = getLocallyVisibleFunctionLabels(callTarget)

                val methodId = ids.function
                tw.writeCallableBinding(id, methodId)

                val idNewexpr = tw.getFreshIdLabel<DbNewexpr>()
                tw.writeExprs_newexpr(idNewexpr, ids.type.javaResult.id, ids.type.kotlinResult.id, id, -1)
                tw.writeHasLocation(idNewexpr, locId)
                tw.writeCallableEnclosingExpr(idNewexpr, callable)
                tw.writeStatementEnclosingExpr(idNewexpr, enclosingStmt)
                tw.writeCallableBinding(idNewexpr, ids.constructor)

                @Suppress("UNCHECKED_CAST")
                tw.writeIsAnonymClass(ids.type.javaResult.id as Label<DbClass>, idNewexpr)

                extractTypeAccess(pluginContext.irBuiltIns.anyType, callable, idNewexpr, -3, c, enclosingStmt)
            } else {
                val dr = c.dispatchReceiver

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

                val drType = dr?.type
                val methodId =
                    if (drType != null && extractClassTypeArguments && drType is IrSimpleType && !isUnspecialised(drType))
                        useFunction<DbCallable>(callTarget, drType.arguments)
                    else
                        useFunction<DbCallable>(callTarget)

                tw.writeCallableBinding(id, methodId)

                if (dr != null) {
                    extractExpressionExpr(dr, callable, id, -1, enclosingStmt)
                } else if(callTarget.isStaticMethodOfClass) {
                    extractTypeAccess(callTarget.parentAsClass.toRawType(), callable, id, -1, c, enclosingStmt)
                }
            }

            val er = c.extensionReceiver
            val idxOffset: Int
            if (er != null) {
                extractExpressionExpr(er, callable, id, 0, enclosingStmt)
                idxOffset = 1
            } else {
                idxOffset = 0
            }

            for(i in 0 until c.valueArgumentsCount) {
                val arg = c.getValueArgument(i)
                if(arg != null) {
                    extractExpressionExpr(arg, callable, id, i + idxOffset, enclosingStmt)
                }
            }
        }

        fun extractSpecialEnumFunction(fnName: String){
            if (c.typeArgumentsCount != 1) {
                logger.warnElement(Severity.ErrorSevere, "Expected to find exactly one type argument", c)
                return
            }

            val func = ((c.getTypeArgument(0) as? IrSimpleType)?.classifier?.owner as? IrClass)?.declarations?.find { it is IrFunction && it.name.asString() == fnName }
            if (func == null) {
                logger.warnElement(Severity.ErrorSevere, "Couldn't find function $fnName on enum type", c)
                return
            }

            extractMethodAccess(func as IrFunction, false)
        }

        fun binopDisp(id: Label<out DbExpr>) {
            val locId = tw.getLocation(c)
            tw.writeHasLocation(id, locId)
            tw.writeCallableEnclosingExpr(id, callable)
            tw.writeStatementEnclosingExpr(id, enclosingStmt)

            val dr = c.dispatchReceiver
            if(dr == null) {
                logger.warnElement(Severity.ErrorSevere, "Dispatch receiver not found", c)
            } else {
                extractExpressionExpr(dr, callable, id, 0, enclosingStmt)
            }
            if(c.valueArgumentsCount < 1) {
                logger.warnElement(Severity.ErrorSevere, "No RHS found", c)
            } else {
                if(c.valueArgumentsCount > 1) {
                    logger.warnElement(Severity.ErrorSevere, "Extra arguments found", c)
                }
                val arg = c.getValueArgument(0)
                if(arg == null) {
                    logger.warnElement(Severity.ErrorSevere, "RHS null", c)
                } else {
                    extractExpressionExpr(arg, callable, id, 1, enclosingStmt)
                }
            }
        }

        val dr = c.dispatchReceiver
        when {
            c.origin == IrStatementOrigin.PLUS &&
            (isNumericFunction("plus")
                    || isFunction("kotlin", "String", "plus")) -> {
                val id = tw.getFreshIdLabel<DbAddexpr>()
                val type = useType(c.type)
                tw.writeExprs_addexpr(id, type.javaResult.id, type.kotlinResult.id, parent, idx)
                binopDisp(id)
            }
            isFunction("kotlin", "String", "plus", true) -> {
                // TODO: this is not correct. `a + b` becomes `(a?:"\"null\"") + (b?:"\"null\"")`.
                val func = pluginContext.irBuiltIns.stringType.classOrNull?.owner?.declarations?.find { it is IrFunction && it.name.asString() == "plus" }
                if (func == null) {
                    logger.warnElement(Severity.ErrorSevere, "Couldn't find plus function on string type", c)
                    return
                }
                extractMethodAccess(func as IrFunction)
            }
            c.origin == IrStatementOrigin.MINUS && isNumericFunction("minus") -> {
                val id = tw.getFreshIdLabel<DbSubexpr>()
                val type = useType(c.type)
                tw.writeExprs_subexpr(id, type.javaResult.id, type.kotlinResult.id, parent, idx)
                binopDisp(id)
            }
            c.origin == IrStatementOrigin.DIV && isNumericFunction("div") -> {
                val id = tw.getFreshIdLabel<DbDivexpr>()
                val type = useType(c.type)
                tw.writeExprs_divexpr(id, type.javaResult.id, type.kotlinResult.id, parent, idx)
                binopDisp(id)
            }
            c.origin == IrStatementOrigin.PERC && isNumericFunction("rem") -> {
                val id = tw.getFreshIdLabel<DbRemexpr>()
                val type = useType(c.type)
                tw.writeExprs_remexpr(id, type.javaResult.id, type.kotlinResult.id, parent, idx)
                binopDisp(id)
            }
            // != gets desugared into not and ==. Here we resugar it.
            // TODO: This is wrong. Kotlin `a == b` is `a?.equals(b) ?: (b === null)`
            c.origin == IrStatementOrigin.EXCLEQ && isFunction("kotlin", "Boolean", "not") && c.valueArgumentsCount == 0 && dr != null && dr is IrCall && isBuiltinCallInternal(dr, "EQEQ") -> {
                val id = tw.getFreshIdLabel<DbNeexpr>()
                val type = useType(c.type)
                tw.writeExprs_neexpr(id, type.javaResult.id, type.kotlinResult.id, parent, idx)
                binOp(id, dr, callable, enclosingStmt)
            }
            c.origin == IrStatementOrigin.EXCLEQEQ && isFunction("kotlin", "Boolean", "not") && c.valueArgumentsCount == 0 && dr != null && dr is IrCall && isBuiltinCallInternal(dr, "EQEQEQ") -> {
                val id = tw.getFreshIdLabel<DbNeexpr>()
                val type = useType(c.type)
                tw.writeExprs_neexpr(id, type.javaResult.id, type.kotlinResult.id, parent, idx)
                binOp(id, dr, callable, enclosingStmt)
            }
            c.origin == IrStatementOrigin.EXCLEQ && isFunction("kotlin", "Boolean", "not") && c.valueArgumentsCount == 0 && dr != null && dr is IrCall && isBuiltinCallInternal(dr, "ieee754equals") -> {
                val id = tw.getFreshIdLabel<DbNeexpr>()
                val type = useType(c.type)
                // TODO: Is this consistent with Java?
                tw.writeExprs_neexpr(id, type.javaResult.id, type.kotlinResult.id, parent, idx)
                binOp(id, dr, callable, enclosingStmt)
            }
            // We need to handle all the builtin operators defines in BuiltInOperatorNames in
            //     compiler/ir/ir.tree/src/org/jetbrains/kotlin/ir/IrBuiltIns.kt
            // as they can't be extracted as external dependencies.
            isBuiltinCallInternal(c, "less") -> {
                if(c.origin != IrStatementOrigin.LT) {
                    logger.warnElement(Severity.ErrorSevere, "Unexpected origin for LT: ${c.origin}", c)
                }
                val id = tw.getFreshIdLabel<DbLtexpr>()
                val type = useType(c.type)
                tw.writeExprs_ltexpr(id, type.javaResult.id, type.kotlinResult.id, parent, idx)
                binOp(id, c, callable, enclosingStmt)
            }
            isBuiltinCallInternal(c, "lessOrEqual") -> {
                if(c.origin != IrStatementOrigin.LTEQ) {
                    logger.warnElement(Severity.ErrorSevere, "Unexpected origin for LTEQ: ${c.origin}", c)
                }
                val id = tw.getFreshIdLabel<DbLeexpr>()
                val type = useType(c.type)
                tw.writeExprs_leexpr(id, type.javaResult.id, type.kotlinResult.id, parent, idx)
                binOp(id, c, callable, enclosingStmt)
            }
            isBuiltinCallInternal(c, "greater") -> {
                if(c.origin != IrStatementOrigin.GT) {
                    logger.warnElement(Severity.ErrorSevere, "Unexpected origin for GT: ${c.origin}", c)
                }
                val id = tw.getFreshIdLabel<DbGtexpr>()
                val type = useType(c.type)
                tw.writeExprs_gtexpr(id, type.javaResult.id, type.kotlinResult.id, parent, idx)
                binOp(id, c, callable, enclosingStmt)
            }
            isBuiltinCallInternal(c, "greaterOrEqual") -> {
                if(c.origin != IrStatementOrigin.GTEQ) {
                    logger.warnElement(Severity.ErrorSevere, "Unexpected origin for GTEQ: ${c.origin}", c)
                }
                val id = tw.getFreshIdLabel<DbGeexpr>()
                val type = useType(c.type)
                tw.writeExprs_geexpr(id, type.javaResult.id, type.kotlinResult.id, parent, idx)
                binOp(id, c, callable, enclosingStmt)
            }
            isBuiltinCallInternal(c, "EQEQ") -> {
                if(c.origin != IrStatementOrigin.EQEQ) {
                    logger.warnElement(Severity.ErrorSevere, "Unexpected origin for EQEQ: ${c.origin}", c)
                }
                // TODO: This is wrong. Kotlin `a == b` is `a?.equals(b) ?: (b === null)`
                val id = tw.getFreshIdLabel<DbEqexpr>()
                val type = useType(c.type)
                tw.writeExprs_eqexpr(id, type.javaResult.id, type.kotlinResult.id, parent, idx)
                binOp(id, c, callable, enclosingStmt)
            }
            isBuiltinCallInternal(c, "EQEQEQ") -> {
                if(c.origin != IrStatementOrigin.EQEQEQ) {
                    logger.warnElement(Severity.ErrorSevere, "Unexpected origin for EQEQEQ: ${c.origin}", c)
                }
                val id = tw.getFreshIdLabel<DbEqexpr>()
                val type = useType(c.type)
                tw.writeExprs_eqexpr(id, type.javaResult.id, type.kotlinResult.id, parent, idx)
                binOp(id, c, callable, enclosingStmt)
            }
            isBuiltinCallInternal(c, "ieee754equals") -> {
                if(c.origin != IrStatementOrigin.EQEQ) {
                    logger.warnElement(Severity.ErrorSevere, "Unexpected origin for ieee754equals: ${c.origin}", c)
                }
                // TODO: Is this consistent with Java?
                val id = tw.getFreshIdLabel<DbEqexpr>()
                val type = useType(c.type)
                tw.writeExprs_eqexpr(id, type.javaResult.id, type.kotlinResult.id, parent, idx)
                binOp(id, c, callable, enclosingStmt)
            }
            isBuiltinCallInternal(c, "CHECK_NOT_NULL") -> {
                if(c.origin != IrStatementOrigin.EXCLEXCL) {
                    logger.warnElement(Severity.ErrorSevere, "Unexpected origin for CHECK_NOT_NULL: ${c.origin}", c)
                }

                val id = tw.getFreshIdLabel<DbNotnullexpr>()
                val type = useType(c.type)
                tw.writeExprs_notnullexpr(id, type.javaResult.id, type.kotlinResult.id, parent, idx)
                unaryOp(id, c, callable, enclosingStmt)
            }
            isBuiltinCallInternal(c, "THROW_CCE") -> {
                // TODO
                logger.warnElement(Severity.ErrorSevere, "Unhandled builtin", c)
            }
            isBuiltinCallInternal(c, "THROW_ISE") -> {
                // TODO
                logger.warnElement(Severity.ErrorSevere, "Unhandled builtin", c)
            }
            isBuiltinCallInternal(c, "noWhenBranchMatchedException") -> {
                // TODO
                logger.warnElement(Severity.ErrorSevere, "Unhandled builtin", c)
            }
            isBuiltinCallInternal(c, "illegalArgumentException") -> {
                // TODO
                logger.warnElement(Severity.ErrorSevere, "Unhandled builtin", c)
            }
            isBuiltinCallInternal(c, "ANDAND") -> {
                // TODO
                logger.warnElement(Severity.ErrorSevere, "Unhandled builtin", c)
            }
            isBuiltinCallInternal(c, "OROR") -> {
                // TODO
                logger.warnElement(Severity.ErrorSevere, "Unhandled builtin", c)
            }
            isFunction("kotlin", "Any", "toString", true) -> {
                // TODO: this is not correct. `a.toString()` becomes `(a?:"\"null\"").toString()`
                val func = pluginContext.irBuiltIns.anyType.classOrNull?.owner?.declarations?.find { it is IrFunction && it.name.asString() == "toString" }
                if (func == null) {
                    logger.warnElement(Severity.ErrorSevere, "Couldn't find toString function", c)
                    return
                }
                extractMethodAccess(func as IrFunction)
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
                tw.writeExprs_arraycreationexpr(id, type.javaResult.id, type.kotlinResult.id, parent, idx)
                val locId = tw.getLocation(c)
                tw.writeHasLocation(id, locId)
                tw.writeCallableEnclosingExpr(id, callable)

                if (c.typeArgumentsCount == 1) {
                    extractTypeArguments(c, id, callable, enclosingStmt, -1)
                } else {
                    logger.warnElement(Severity.ErrorSevere, "Expected to find exactly one type argument in an arrayOfNulls call", c)
                }

                if (c.valueArgumentsCount == 1) {
                    val dim = c.getValueArgument(0)
                    if (dim != null) {
                        extractExpressionExpr(dim, callable, id, 0, enclosingStmt)
                    } else {
                        logger.warnElement(Severity.ErrorSevere, "Expected to find non-null argument in an arrayOfNulls call", c)
                    }
                } else {
                    logger.warnElement(Severity.ErrorSevere, "Expected to find only one argument in an arrayOfNulls call", c)
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
                val id = tw.getFreshIdLabel<DbArraycreationexpr>()
                val type = useType(c.type)
                tw.writeExprs_arraycreationexpr(id, type.javaResult.id, type.kotlinResult.id, parent, idx)
                val locId = tw.getLocation(c)
                tw.writeHasLocation(id, locId)
                tw.writeCallableEnclosingExpr(id, callable)

                if (isBuiltinCallKotlin(c, "arrayOf")) {
                    if (c.typeArgumentsCount == 1) {
                        extractTypeArguments(c, id, callable, enclosingStmt,-1)
                    } else {
                        logger.warnElement( Severity.ErrorSevere, "Expected to find one type argument in arrayOf call", c )
                    }
                } else {
                    val elementType = c.type.getArrayElementType(pluginContext.irBuiltIns)
                    extractTypeAccess(elementType, callable, id, -1, c, enclosingStmt)
                }

                if (c.valueArgumentsCount == 1) {
                    val vararg = c.getValueArgument(0)
                    if (vararg is IrVararg) {
                        val initId = tw.getFreshIdLabel<DbArrayinit>()
                        tw.writeExprs_arrayinit(initId, type.javaResult.id, type.kotlinResult.id, id, -2)
                        tw.writeHasLocation(initId, locId)
                        tw.writeCallableEnclosingExpr(initId, callable)
                        tw.writeStatementEnclosingExpr(initId, enclosingStmt)
                        vararg.elements.forEachIndexed { i, arg -> extractVarargElement(arg, callable, initId, i, enclosingStmt) }

                        val dim = vararg.elements.size
                        val dimId = tw.getFreshIdLabel<DbIntegerliteral>()
                        val dimType = useType(pluginContext.irBuiltIns.intType)
                        tw.writeExprs_integerliteral(dimId, dimType.javaResult.id, dimType.kotlinResult.id, id, 0)
                        tw.writeHasLocation(dimId, locId)
                        tw.writeCallableEnclosingExpr(dimId, callable)
                        tw.writeStatementEnclosingExpr(dimId, enclosingStmt)
                        tw.writeNamestrings(dim.toString(), dim.toString(), dimId)
                    } else {
                        logger.warnElement(Severity.ErrorSevere, "Expected to find vararg argument in ${c.symbol.owner.name.asString()} call", c)
                    }
                } else {
                    logger.warnElement(Severity.ErrorSevere, "Expected to find only one (vararg) argument in ${c.symbol.owner.name.asString()} call", c)
                }
            }
            else -> {
                extractMethodAccess(c.symbol.owner, true, true)
            }
        }
    }

    private fun <T : IrSymbol> extractTypeArguments(
        c: IrMemberAccessExpression<T>,
        id: Label<out DbExprparent>,
        callable: Label<out DbCallable>,
        enclosingStmt: Label<out DbStmt>,
        startIndex: Int = 0,
        reverse: Boolean = false
    ) {
        for (argIdx in 0 until c.typeArgumentsCount) {
            val arg = c.getTypeArgument(argIdx)!!
            val mul = if (reverse) -1 else 1
            extractTypeAccess(arg, callable, id, argIdx * mul + startIndex, c, enclosingStmt, TypeContext.GENERIC_ARGUMENT)
        }
    }

    private fun extractConstructorCall(
        e: IrFunctionAccessExpression,
        parent: Label<out DbExprparent>,
        idx: Int,
        callable: Label<out DbCallable>,
        enclosingStmt: Label<out DbStmt>
    ) {
        val id = tw.getFreshIdLabel<DbNewexpr>()
        val type: TypeResults
        val isAnonymous = e.type.isAnonymous
        if (isAnonymous) {
            if (e.typeArgumentsCount > 0) {
                logger.warn("Unexpected type arguments for anonymous class constructor call")
            }

            val c = (e.type as IrSimpleType).classifier.owner as IrClass

            type = useAnonymousClass(c)

            @Suppress("UNCHECKED_CAST")
            tw.writeIsAnonymClass(type.javaResult.id as Label<DbClass>, id)
        } else {
            type = useType(e.type)
        }
        val locId = tw.getLocation(e)
        val methodId = useFunction<DbConstructor>(e.symbol.owner, (e.type as? IrSimpleType)?.arguments)
        tw.writeExprs_newexpr(id, type.javaResult.id, type.kotlinResult.id, parent, idx)
        tw.writeHasLocation(id, locId)
        tw.writeCallableEnclosingExpr(id, callable)
        tw.writeStatementEnclosingExpr(id, enclosingStmt)
        tw.writeCallableBinding(id, methodId)
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

        val typeAccessId = extractTypeAccess(typeAccessType, callable, id, -3, e, enclosingStmt)

        if (e is IrConstructorCall) {
            // Only extract type arguments relating to the constructed type, not the constructor itself:
            e.getClassTypeArguments().forEachIndexed({ argIdx, argType ->
                extractTypeAccess(argType!!, callable, typeAccessId, argIdx, e, enclosingStmt, TypeContext.GENERIC_ARGUMENT)
            })
        } else {
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
            tw.writeExprs_stmtexpr(id, type.javaResult.id, type.kotlinResult.id, parent, idx)
            tw.writeHasLocation(id, locId)
            tw.writeCallableEnclosingExpr(id, callable)
            tw.writeStatementEnclosingExpr(id, enclosingStmt)
            return StmtParent(id, 0)
        }
        override fun expr(e: IrExpression, callable: Label<out DbCallable>): ExprParent {
            return this
        }
    }

    fun extractExpressionStmt(e: IrExpression, callable: Label<out DbCallable>, parent: Label<out DbStmtparent>, idx: Int) {
        extractExpression(e, callable, StmtParent(parent, idx))
    }

    fun extractExpressionExpr(e: IrExpression, callable: Label<out DbCallable>, parent: Label<out DbExprparent>, idx: Int, enclosingStmt: Label<out DbStmt>) {
        extractExpression(e, callable, ExprParent(parent, idx, enclosingStmt))
    }

    fun extractExpression(e: IrExpression, callable: Label<out DbCallable>, parent: StmtExprParent) {
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
                    extractTypeAccess(catchClause.catchParameter.type, callable, catchId, -1, catchClause.catchParameter, catchId)
                    extractVariableExpr(catchClause.catchParameter, callable, catchId, 0, catchId)
                    extractExpressionStmt(catchClause.result, callable, catchId, 1)
                }
            }
            is IrContainerExpression -> {
                val stmtParent = parent.stmt(e, callable)
                val id = tw.getFreshIdLabel<DbBlock>()
                val locId = tw.getLocation(e)
                tw.writeStmts_block(id, stmtParent.parent, stmtParent.idx, callable)
                tw.writeHasLocation(id, locId)
                e.statements.forEachIndexed { i, s ->
                    extractStatement(s, callable, id, i)
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
                val exprParent = parent.expr(e, callable)
                val irCallable = declarationStack.peek()

                if (irCallable is IrConstructor && irCallable.isPrimary) {
                    // Todo add parameter to field assignments
                }

                // Add call to <obinit>:
                val id = tw.getFreshIdLabel<DbMethodaccess>()
                val type = useType(e.type)
                val locId = tw.getLocation(e)
                val methodLabel = getFunctionLabel(irCallable.parent, "<obinit>", listOf(), e.type, null, functionTypeParameters = listOf(), classTypeArguments = listOf())
                val methodId = tw.getLabelFor<DbMethod>(methodLabel)
                tw.writeExprs_methodaccess(id, type.javaResult.id, type.kotlinResult.id, exprParent.parent, exprParent.idx)
                tw.writeHasLocation(id, locId)
                tw.writeCallableEnclosingExpr(id, callable)
                tw.writeStatementEnclosingExpr(id, exprParent.enclosingStmt)
                tw.writeCallableBinding(id, methodId)
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
                val exprParent = parent.expr(e, callable)
                extractCall(e, callable, exprParent.parent, exprParent.idx, exprParent.enclosingStmt)
            }
            is IrStringConcatenation -> {
                val exprParent = parent.expr(e, callable)
                val id = tw.getFreshIdLabel<DbStringtemplateexpr>()
                val type = useType(e.type)
                val locId = tw.getLocation(e)
                tw.writeExprs_stringtemplateexpr(id, type.javaResult.id, type.kotlinResult.id, exprParent.parent, exprParent.idx)
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
                        tw.writeExprs_integerliteral(id, type.javaResult.id, type.kotlinResult.id, exprParent.parent, exprParent.idx)
                        tw.writeHasLocation(id, locId)
                        tw.writeCallableEnclosingExpr(id, callable)
                        tw.writeStatementEnclosingExpr(id, exprParent.enclosingStmt)
                        tw.writeNamestrings(v.toString(), v.toString(), id)
                    } is Long -> {
                        val id = tw.getFreshIdLabel<DbLongliteral>()
                        val type = useType(e.type)
                        val locId = tw.getLocation(e)
                        tw.writeExprs_longliteral(id, type.javaResult.id, type.kotlinResult.id, exprParent.parent, exprParent.idx)
                        tw.writeHasLocation(id, locId)
                        tw.writeCallableEnclosingExpr(id, callable)
                        tw.writeStatementEnclosingExpr(id, exprParent.enclosingStmt)
                        tw.writeNamestrings(v.toString(), v.toString(), id)
                    } is Float -> {
                        val id = tw.getFreshIdLabel<DbFloatingpointliteral>()
                        val type = useType(e.type)
                        val locId = tw.getLocation(e)
                        tw.writeExprs_floatingpointliteral(id, type.javaResult.id, type.kotlinResult.id, exprParent.parent, exprParent.idx)
                        tw.writeHasLocation(id, locId)
                        tw.writeCallableEnclosingExpr(id, callable)
                        tw.writeStatementEnclosingExpr(id, exprParent.enclosingStmt)
                        tw.writeNamestrings(v.toString(), v.toString(), id)
                    } is Double -> {
                        val id = tw.getFreshIdLabel<DbDoubleliteral>()
                        val type = useType(e.type)
                        val locId = tw.getLocation(e)
                        tw.writeExprs_doubleliteral(id, type.javaResult.id, type.kotlinResult.id, exprParent.parent, exprParent.idx)
                        tw.writeHasLocation(id, locId)
                        tw.writeCallableEnclosingExpr(id, callable)
                        tw.writeStatementEnclosingExpr(id, exprParent.enclosingStmt)
                        tw.writeNamestrings(v.toString(), v.toString(), id)
                    } is Boolean -> {
                        val id = tw.getFreshIdLabel<DbBooleanliteral>()
                        val type = useType(e.type)
                        val locId = tw.getLocation(e)
                        tw.writeExprs_booleanliteral(id, type.javaResult.id, type.kotlinResult.id, exprParent.parent, exprParent.idx)
                        tw.writeHasLocation(id, locId)
                        tw.writeCallableEnclosingExpr(id, callable)
                        tw.writeStatementEnclosingExpr(id, exprParent.enclosingStmt)
                        tw.writeNamestrings(v.toString(), v.toString(), id)
                    } is Char -> {
                        val id = tw.getFreshIdLabel<DbCharacterliteral>()
                        val type = useType(e.type)
                        val locId = tw.getLocation(e)
                        tw.writeExprs_characterliteral(id, type.javaResult.id, type.kotlinResult.id, exprParent.parent, exprParent.idx)
                        tw.writeHasLocation(id, locId)
                        tw.writeCallableEnclosingExpr(id, callable)
                        tw.writeStatementEnclosingExpr(id, exprParent.enclosingStmt)
                        tw.writeNamestrings(v.toString(), v.toString(), id)
                    } is String -> {
                        val id = tw.getFreshIdLabel<DbStringliteral>()
                        val type = useType(e.type)
                        val locId = tw.getLocation(e)
                        tw.writeExprs_stringliteral(id, type.javaResult.id, type.kotlinResult.id, exprParent.parent, exprParent.idx)
                        tw.writeHasLocation(id, locId)
                        tw.writeCallableEnclosingExpr(id, callable)
                        tw.writeStatementEnclosingExpr(id, exprParent.enclosingStmt)
                        tw.writeNamestrings(v.toString(), v.toString(), id)
                    }
                    null -> {
                        val id = tw.getFreshIdLabel<DbNullliteral>()
                        val type = useType(e.type) // class;kotlin.Nothing
                        val locId = tw.getLocation(e)
                        tw.writeExprs_nullliteral(id, type.javaResult.id, type.kotlinResult.id, exprParent.parent, exprParent.idx)
                        tw.writeHasLocation(id, locId)
                        tw.writeCallableEnclosingExpr(id, callable)
                        tw.writeStatementEnclosingExpr(id, exprParent.enclosingStmt)
                    }
                    else -> {
                        logger.warnElement(Severity.ErrorSevere, "Unrecognised IrConst: " + v.javaClass, e)
                    }
                }
            }
            is IrGetValue -> {
                val exprParent = parent.expr(e, callable)
                val owner = e.symbol.owner
                if (owner is IrValueParameter && owner.index == -1) {
                    val id = tw.getFreshIdLabel<DbThisaccess>()
                    val type = useType(e.type)
                    val locId = tw.getLocation(e)
                    tw.writeExprs_thisaccess(id, type.javaResult.id, type.kotlinResult.id, exprParent.parent, exprParent.idx)
                    tw.writeHasLocation(id, locId)
                    tw.writeCallableEnclosingExpr(id, callable)
                    tw.writeStatementEnclosingExpr(id, exprParent.enclosingStmt)

                    when(val ownerParent = owner.parent) {
                        is IrFunction -> {
                            if (ownerParent.dispatchReceiverParameter == owner &&
                                ownerParent.extensionReceiverParameter != null) {
                                logger.warnElement(Severity.ErrorSevere, "Function-qualifier for this", e)
                            }
                        }
                        is IrClass -> {
                            if (ownerParent.thisReceiver == owner) {
                                // TODO: Type arguments
                                extractTypeAccess(ownerParent.typeWith(listOf()), locId, callable, id, 0, exprParent.enclosingStmt)
                            }
                        }
                        else -> {
                            logger.warnElement(Severity.ErrorSevere, "Unexpected owner parent for this access: " + ownerParent.javaClass, e)
                        }
                    }
                } else {
                    val id = tw.getFreshIdLabel<DbVaraccess>()
                    val type = useType(e.type)
                    val locId = tw.getLocation(e)
                    tw.writeExprs_varaccess(id, type.javaResult.id, type.kotlinResult.id, exprParent.parent, exprParent.idx)
                    tw.writeHasLocation(id, locId)
                    tw.writeCallableEnclosingExpr(id, callable)
                    tw.writeStatementEnclosingExpr(id, exprParent.enclosingStmt)

                    val vId = useValueDeclaration(owner)
                    tw.writeVariableBinding(id, vId)
                }
            }
            is IrGetField -> {
                val exprParent = parent.expr(e, callable)
                val id = tw.getFreshIdLabel<DbVaraccess>()
                val type = useType(e.type)
                val locId = tw.getLocation(e)
                tw.writeExprs_varaccess(id, type.javaResult.id, type.kotlinResult.id, exprParent.parent, exprParent.idx)
                tw.writeHasLocation(id, locId)
                tw.writeCallableEnclosingExpr(id, callable)
                tw.writeStatementEnclosingExpr(id, exprParent.enclosingStmt)
                val owner = e.symbol.owner
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
                tw.writeExprs_varaccess(id, type.javaResult.id, type.kotlinResult.id, exprParent.parent, exprParent.idx)
                tw.writeHasLocation(id, locId)
                tw.writeCallableEnclosingExpr(id, callable)
                tw.writeStatementEnclosingExpr(id, exprParent.enclosingStmt)
                if (!e.symbol.isBound) {
                    logger.warnElement(Severity.ErrorSevere, "Unbound enum value", e)
                    return
                }
                val owner = e.symbol.owner
                val vId = useEnumEntry(owner)
                tw.writeVariableBinding(id, vId)
            }
            is IrSetValue,
            is IrSetField -> {
                val exprParent = parent.expr(e, callable)
                val id = tw.getFreshIdLabel<DbAssignexpr>()
                val type = useType(e.type)
                val locId = tw.getLocation(e)
                tw.writeExprs_assignexpr(id, type.javaResult.id, type.kotlinResult.id, exprParent.parent, exprParent.idx)
                tw.writeHasLocation(id, locId)
                tw.writeCallableEnclosingExpr(id, callable)
                tw.writeStatementEnclosingExpr(id, exprParent.enclosingStmt)

                val lhsId = tw.getFreshIdLabel<DbVaraccess>()
                tw.writeHasLocation(lhsId, locId)
                tw.writeCallableEnclosingExpr(lhsId, callable)

                when (e) {
                    is IrSetValue -> {
                        val lhsType = useType(e.symbol.owner.type)
                        tw.writeExprs_varaccess(lhsId, lhsType.javaResult.id, lhsType.kotlinResult.id, id, 0)
                        // TODO: location, enclosing callable?
                        tw.writeStatementEnclosingExpr(id, exprParent.enclosingStmt)
                        val vId = useValueDeclaration(e.symbol.owner)
                        tw.writeVariableBinding(lhsId, vId)
                        extractExpressionExpr(e.value, callable, id, 1, exprParent.enclosingStmt)
                    }
                    is IrSetField -> {
                        val lhsType = useType(e.symbol.owner.type)
                        tw.writeExprs_varaccess(lhsId, lhsType.javaResult.id, lhsType.kotlinResult.id, id, 0)
                        // TODO: location, enclosing callable?
                        tw.writeStatementEnclosingExpr(id, exprParent.enclosingStmt)
                        val vId = useField(e.symbol.owner)
                        tw.writeVariableBinding(lhsId, vId)
                        extractExpressionExpr(e.value, callable, id, 1, exprParent.enclosingStmt)

                        val receiver = e.receiver
                        if (receiver != null) {
                            extractExpressionExpr(receiver, callable, lhsId, -1, exprParent.enclosingStmt)
                        }
                    }
                    else -> {
                        logger.warnElement(Severity.ErrorSevere, "Unhandled IrSet* element.", e)
                    }
                }
            }
            is IrWhen -> {
                val exprParent = parent.expr(e, callable)
                val id = tw.getFreshIdLabel<DbWhenexpr>()
                val type = useType(e.type)
                val locId = tw.getLocation(e)
                tw.writeExprs_whenexpr(id, type.javaResult.id, type.kotlinResult.id, exprParent.parent, exprParent.idx)
                tw.writeHasLocation(id, locId)
                tw.writeCallableEnclosingExpr(id, callable)
                tw.writeStatementEnclosingExpr(id, exprParent.enclosingStmt)
                if(e.origin == IrStatementOrigin.IF) {
                    tw.writeWhen_if(id)
                }
                e.branches.forEachIndexed { i, b ->
                    val bId = tw.getFreshIdLabel<DbWhenbranch>()
                    val bLocId = tw.getLocation(b)
                    tw.writeWhen_branch(bId, id, i)
                    tw.writeHasLocation(bId, bLocId)
                    extractExpressionExpr(b.condition, callable, bId, 0, exprParent.enclosingStmt)
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
                tw.writeExprs_getclassexpr(id, type.javaResult.id, type.kotlinResult.id, exprParent.parent, exprParent.idx)
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
                val exprParent = parent.expr(e, callable)
                val id = tw.getFreshIdLabel<DbVarargexpr>()
                val locId = tw.getLocation(e)
                val type = useType(e.type)
                tw.writeExprs_varargexpr(id, type.javaResult.id, type.kotlinResult.id, exprParent.parent, exprParent.idx)
                tw.writeHasLocation(id, locId)
                tw.writeCallableEnclosingExpr(id, callable)
                tw.writeStatementEnclosingExpr(id, exprParent.enclosingStmt)
                e.elements.forEachIndexed { i, arg -> extractVarargElement(arg, callable, id, i, exprParent.enclosingStmt) }
            }
            is IrGetObjectValue -> {
                // For `object MyObject { ... }`, the .class has an
                // automatically-generated `public static final MyObject INSTANCE`
                // field that we are accessing here.
                val exprParent = parent.expr(e, callable)
                if (!e.symbol.isBound) {
                    logger.warnElement(Severity.ErrorSevere, "Unbound object value", e)
                    return
                }

                val c: IrClass = e.symbol.owner
                val instance = if (c.isCompanion) useCompanionObjectClassInstance(c) else useObjectClassInstance(c)

                if (instance != null) {
                    val id = tw.getFreshIdLabel<DbVaraccess>()
                    val type = useType(e.type)
                    val locId = tw.getLocation(e)
                    tw.writeExprs_varaccess(id, type.javaResult.id, type.kotlinResult.id, exprParent.parent, exprParent.idx)
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
                    val l = mutableListOf(ext)
                    l.addAll(e.function.valueParameters)
                    l
                } else {
                    e.function.valueParameters
                }

                var types = parameters.map { it.type }
                types += e.function.returnType

                val fnInterfaceType = getFunctionalInterfaceType(types)
                val id = extractGeneratedClass(
                    e.function, // We're adding this function as a member, and changing its name to `invoke` to implement `kotlin.FunctionX<,,,>.invoke(,,)`
                    listOf(pluginContext.irBuiltIns.anyType, fnInterfaceType))

                if (types.size > BuiltInFunctionArity.BIG_ARITY) {
                    implementFunctionNInvoke(e.function, ids, locId, parameters)
                }

                val exprParent = parent.expr(e, callable)
                val idLambdaExpr = tw.getFreshIdLabel<DbLambdaexpr>()
                tw.writeExprs_lambdaexpr(idLambdaExpr, ids.type.javaResult.id, ids.type.kotlinResult.id, exprParent.parent, exprParent.idx)
                tw.writeHasLocation(idLambdaExpr, locId)
                tw.writeCallableEnclosingExpr(idLambdaExpr, callable)
                tw.writeStatementEnclosingExpr(idLambdaExpr, exprParent.enclosingStmt)
                tw.writeCallableBinding(idLambdaExpr, ids.constructor)

                extractTypeAccess(fnInterfaceType, callable, idLambdaExpr, -3, e, exprParent.enclosingStmt)

                // todo: fix hard coded block body of lambda
                tw.writeLambdaKind(idLambdaExpr, 1)

                tw.writeIsAnonymClass(id, idLambdaExpr)
            }
            is IrClassReference -> {
                val exprParent = parent.expr(e, callable)
                val id = tw.getFreshIdLabel<DbTypeliteral>()
                val locId = tw.getLocation(e)
                val type = useType(e.type)
                tw.writeExprs_typeliteral(id, type.javaResult.id, type.kotlinResult.id, exprParent.parent, exprParent.idx)
                tw.writeHasLocation(id, locId)
                tw.writeCallableEnclosingExpr(id, callable)
                tw.writeStatementEnclosingExpr(id, exprParent.enclosingStmt)

                extractTypeAccess(e.classType, locId, callable, id, 0, exprParent.enclosingStmt)
            }
            is IrPropertyReference -> {
                // TODO
                logger.warnElement(Severity.ErrorSevere, "Unhandled IrPropertyReference", e)
            }
            else -> {
                logger.warnElement(Severity.ErrorSevere, "Unrecognised IrExpression: " + e.javaClass, e)
            }
        }
    }

    private fun extractFunctionReference(
        functionReferenceExpr: IrFunctionReference,
        parent: StmtExprParent,
        callable: Label<out DbCallable>
    ) {
        val target = functionReferenceExpr.reflectionTarget
        if (target == null) {
            logger.warnElement(Severity.ErrorSevere, "Expected to find reflection target for function reference", functionReferenceExpr)
            return
        }

        /*
         * Extract generated class:
         * ```
         * class C : Any, kotlin.FunctionI<T0,T1, ... TI, R> {
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
         * class C : Any, kotlin.FunctionN<R> {
         *   private receiver: TD
         *   constructor(receiver: TD) { super(); this.receiver = receiver; }
         *   fun invoke(vararg args: Any?): R {
         *     return this.receiver.FN(args[0] as T0, args[1] as T1, ..., args[I] as TI)
         *   }
         * }
         * ```
         **/

        val typeArguments = if (target is IrConstructorSymbol) {
            (target.owner.returnType as? IrSimpleType)?.arguments
        } else {
            (functionReferenceExpr.dispatchReceiver?.type as? IrSimpleType)?.arguments
        }

        val targetCallableId = useFunction<DbCallable>(target.owner, typeArguments)
        val locId = tw.getLocation(functionReferenceExpr)

        val extensionParameter = target.owner.extensionReceiverParameter
        val dispatchParameter = target.owner.dispatchReceiverParameter

        var parameters = LinkedList(target.owner.valueParameters)
        if (extensionParameter != null && functionReferenceExpr.extensionReceiver == null) {
            parameters.addFirst(extensionParameter)
        }
        if (dispatchParameter != null && functionReferenceExpr.dispatchReceiver == null) {
            parameters.addFirst(dispatchParameter)
        }

        val parameterTypes = parameters.map { it.type }
        val functionNTypeArguments = parameterTypes + target.owner.returnType
        val fnInterfaceType = getFunctionalInterfaceType(functionNTypeArguments)

        val javaResult = TypeResult(tw.getFreshIdLabel<DbClass>(), "", "")
        val kotlinResult = TypeResult(tw.getFreshIdLabel<DbKt_notnull_type>(), "", "")
        tw.writeKt_notnull_types(kotlinResult.id, javaResult.id)
        val ids = LocallyVisibleFunctionLabels(
            TypeResults(javaResult, kotlinResult),
            tw.getFreshIdLabel(),
            tw.getFreshIdLabel(),
            tw.getFreshIdLabel()
        )

        val currentDeclaration = declarationStack.peek()
        val id = extractGeneratedClass(ids, listOf(pluginContext.irBuiltIns.anyType, fnInterfaceType), locId, currentDeclaration)

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
            type: IrType,
            fieldId: Label<DbField>,
            paramIdx: Int,
            stmtIdx: Int
        ) {
            val paramId = tw.getFreshIdLabel<DbParam>()
            val paramType = extractValueParameter(paramId, type, paramName, locId, ids.constructor, paramIdx, null, paramId)

            val assignmentStmtId = tw.getFreshIdLabel<DbExprstmt>()
            tw.writeStmts_exprstmt(assignmentStmtId, ids.constructorBlock, stmtIdx, ids.constructor)
            tw.writeHasLocation(assignmentStmtId, locId)

            val assignmentId = tw.getFreshIdLabel<DbAssignexpr>()
            tw.writeExprs_assignexpr(assignmentId, paramType.javaResult.id, paramType.kotlinResult.id, assignmentStmtId, 0)
            writeExpressionMetadataToTrapFile(assignmentId, ids.constructor, assignmentStmtId)

            val lhsId = tw.getFreshIdLabel<DbVaraccess>()
            tw.writeExprs_varaccess(lhsId, paramType.javaResult.id, paramType.kotlinResult.id, assignmentId, 0)
            tw.writeVariableBinding(lhsId, fieldId)
            writeExpressionMetadataToTrapFile(lhsId, ids.constructor, assignmentStmtId)

            val thisId = tw.getFreshIdLabel<DbThisaccess>()
            tw.writeExprs_thisaccess(thisId, ids.type.javaResult.id, ids.type.kotlinResult.id, lhsId, -1)
            writeExpressionMetadataToTrapFile(thisId, ids.constructor, assignmentStmtId)

            val rhsId = tw.getFreshIdLabel<DbVaraccess>()
            tw.writeExprs_varaccess(rhsId, paramType.javaResult.id, paramType.kotlinResult.id, assignmentId, 1)
            tw.writeVariableBinding(rhsId, paramId)
            writeExpressionMetadataToTrapFile(rhsId, ids.constructor, assignmentStmtId)
        }

        val firstAssignmentStmtIdx = 1
        val extensionParameterIndex: Int
        val dispatchReceiver = functionReferenceExpr.dispatchReceiver
        val dispatchFieldId: Label<DbField>?
        if (dispatchReceiver != null) {
            dispatchFieldId = tw.getFreshIdLabel()
            extensionParameterIndex = 1

            extractField(dispatchFieldId, "<dispatchReceiver>", dispatchReceiver.type, id, locId, DescriptorVisibilities.PRIVATE, functionReferenceExpr, false)
            extractParameterToFieldAssignmentInConstructor("<dispatchReceiver>", dispatchReceiver.type, dispatchFieldId, 0, firstAssignmentStmtIdx)
        } else {
            dispatchFieldId = null
            extensionParameterIndex = 0
        }

        val extensionReceiver = functionReferenceExpr.extensionReceiver
        val extensionFieldId: Label<out DbField>?
        if (extensionReceiver != null) {
            extensionFieldId = tw.getFreshIdLabel()

            extractField(extensionFieldId, "<extensionReceiver>", extensionReceiver.type, id, locId, DescriptorVisibilities.PRIVATE, functionReferenceExpr, false)
            extractParameterToFieldAssignmentInConstructor( "<extensionReceiver>", extensionReceiver.type, extensionFieldId, 0 + extensionParameterIndex, firstAssignmentStmtIdx + extensionParameterIndex)
        } else {
            extensionFieldId = null
        }

        val funLabels = if (functionNTypeArguments.size > BuiltInFunctionArity.BIG_ARITY) {
            addFunctionNInvoke(target.owner.returnType, id, locId)
        } else {
            addFunctionInvoke(parameterTypes, target.owner.returnType, id, locId)
        }

        // Return statement of generated function:
        val retId = tw.getFreshIdLabel<DbReturnstmt>()
        tw.writeStmts_returnstmt(retId, funLabels.blockId, 0, funLabels.methodId)
        tw.writeHasLocation(retId, locId)

        // Call to target function:
        val dispatchReceiverIdx: Int
        val callId: Label<out DbExpr>
        val callType = useType(target.owner.returnType)
        if (target is IrConstructorSymbol) {
            callId = tw.getFreshIdLabel<DbNewexpr>()
            tw.writeExprs_newexpr(callId, callType.javaResult.id, callType.kotlinResult.id, retId, 0)

            val typeAccessId = extractTypeAccess(callType, locId, funLabels.methodId, callId, -3, retId)

            extractTypeArguments(functionReferenceExpr, typeAccessId, funLabels.methodId, retId)
            dispatchReceiverIdx = -2
        } else {
            callId = tw.getFreshIdLabel<DbMethodaccess>()
            tw.writeExprs_methodaccess(callId, callType.javaResult.id, callType.kotlinResult.id, retId, 0)

            extractTypeArguments(functionReferenceExpr, callId, funLabels.methodId, retId, -2, true)
            dispatchReceiverIdx = -1
        }

        writeExpressionMetadataToTrapFile(callId, funLabels.methodId, retId)
        @Suppress("UNCHECKED_CAST")
        tw.writeCallableBinding(callId as Label<out DbCaller>, targetCallableId)

        fun writeVariableAccessInInvokeBody(
            pType: TypeResults,
            idx: Int,
            variable: Label<out DbVariable>
        ): Label<DbVaraccess> {
            val pId = tw.getFreshIdLabel<DbVaraccess>()
            tw.writeExprs_varaccess(pId, pType.javaResult.id, pType.kotlinResult.id, callId, idx)
            tw.writeVariableBinding(pId, variable)
            writeExpressionMetadataToTrapFile(pId, funLabels.methodId, retId)
            return pId
        }

        fun writeFieldAccessInInvokeBody(pType: IrType, idx: Int, variable: Label<out DbField>) {
            val accessId = writeVariableAccessInInvokeBody(useType(pType), idx, variable)
            val thisId = tw.getFreshIdLabel<DbThisaccess>()
            tw.writeExprs_thisaccess(thisId, ids.type.javaResult.id, ids.type.kotlinResult.id, accessId, -1)
            writeExpressionMetadataToTrapFile(thisId, funLabels.methodId, retId)
        }

        val useFirstArgAsDispatch: Boolean
        if (dispatchReceiver != null) {
            writeFieldAccessInInvokeBody(dispatchReceiver.type, dispatchReceiverIdx, dispatchFieldId!!)

            useFirstArgAsDispatch = false
        } else {
            useFirstArgAsDispatch = dispatchParameter != null
        }

        val extensionIdxOffset: Int
        if (extensionReceiver != null) {
            writeFieldAccessInInvokeBody(extensionReceiver.type, 0, extensionFieldId!!)
            extensionIdxOffset = 1
        } else {
            extensionIdxOffset = 0
        }

        if (functionNTypeArguments.size > BuiltInFunctionArity.BIG_ARITY) {
            addArgumentsToInvocationInInvokeNBody(parameters, funLabels, retId, callId, locId, { exp -> writeExpressionMetadataToTrapFile(exp, funLabels.methodId, retId) }, extensionIdxOffset, useFirstArgAsDispatch, dispatchReceiverIdx)
        } else {
            val dispatchIdxOffset = if (useFirstArgAsDispatch) 1 else 0
            for ((pIdx, p) in funLabels.parameters.withIndex()) {
                val childIdx = if (pIdx == 0 && useFirstArgAsDispatch) {
                    dispatchReceiverIdx
                } else {
                    pIdx + extensionIdxOffset - dispatchIdxOffset
                }
                writeVariableAccessInInvokeBody(p.second, childIdx, p.first)
            }
        }

        // Add constructor (member ref) call:
        val exprParent = parent.expr(functionReferenceExpr, callable)
        val idMemberRef = tw.getFreshIdLabel<DbMemberref>()
        tw.writeExprs_memberref(idMemberRef, ids.type.javaResult.id, ids.type.kotlinResult.id, exprParent.parent, exprParent.idx)
        tw.writeHasLocation(idMemberRef, locId)
        tw.writeCallableEnclosingExpr(idMemberRef, callable)
        tw.writeStatementEnclosingExpr(idMemberRef, exprParent.enclosingStmt)
        tw.writeCallableBinding(idMemberRef, ids.constructor)

        extractTypeAccess(fnInterfaceType, locId, callable, idMemberRef, -3, exprParent.enclosingStmt)

        tw.writeMemberRefBinding(idMemberRef, targetCallableId)

        // constructor arguments:
        if (dispatchReceiver != null) {
            extractExpressionExpr(dispatchReceiver, callable, idMemberRef, 0, exprParent.enclosingStmt)
        }

        if (extensionReceiver != null) {
            extractExpressionExpr(extensionReceiver, callable, idMemberRef, 0 + extensionParameterIndex, exprParent.enclosingStmt)
        }

        tw.writeIsAnonymClass(id, idMemberRef)
    }

    private fun getFunctionalInterfaceType(functionNTypeArguments: List<IrType>) =
        if (functionNTypeArguments.size > BuiltInFunctionArity.BIG_ARITY) {
            pluginContext.referenceClass(FqName("kotlin.jvm.functions.FunctionN"))!!
                .typeWith(functionNTypeArguments.last())
        } else {
            functionN(pluginContext)(functionNTypeArguments.size - 1).typeWith(functionNTypeArguments)
        }

    private data class FunctionLabels(
        val methodId: Label<DbMethod>,
        val blockId: Label<DbBlock>,
        val parameters: List<Pair<Label<DbParam>, TypeResults>>)

    /**
     * Adds a function `invoke(a: Any[])` with the specified return type to the class identified by parentId.
     */
    private fun addFunctionNInvoke(returnType: IrType, parentId: Label<out DbReftype>, locId: Label<DbLocation>): FunctionLabels {
        return addFunctionInvoke(listOf(pluginContext.irBuiltIns.arrayClass.typeWith(pluginContext.irBuiltIns.anyNType)), returnType, parentId, locId)
    }

    /**
     * Adds a function named "invoke" with the specified parameter types and return type to the class identified by parentId.
     */
    private fun addFunctionInvoke(parameterTypes: List<IrType>, returnType: IrType, parentId: Label<out DbReftype>, locId: Label<DbLocation>): FunctionLabels {
        val methodId = tw.getFreshIdLabel<DbMethod>()

        val parameters = parameterTypes.mapIndexed { idx, p ->
            val paramId = tw.getFreshIdLabel<DbParam>()
            val paramType = extractValueParameter(paramId, p, "a$idx", locId, methodId, idx, null, paramId)

            Pair(paramId, paramType)
        }

        val paramsSignature = parameters.joinToString(separator = ",", prefix = "(", postfix = ")") { it.second.javaResult.signature!! }

        val rt = useType(returnType, TypeContext.RETURN)
        val shortName = OperatorNameConventions.INVOKE.asString()
        tw.writeMethods(methodId, shortName, "$shortName$paramsSignature", rt.javaResult.id, rt.kotlinResult.id, parentId, methodId)
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
    * fun invoke(vararg args: Any?): R {
    *   return invoke(args[0] as T0, args[1] as T1, ..., args[I] as TI)
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
        val funLabels = addFunctionNInvoke(lambda.returnType, ids.type.javaResult.id as Label<DbReftype>, locId)

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
        tw.writeExprs_methodaccess(callId, callType.javaResult.id, callType.kotlinResult.id, retId, 0)
        extractCommonExpr(callId)
        val calledMethodId = useFunction<DbMethod>(lambda)
        tw.writeCallableBinding(callId, calledMethodId)

        // this access
        val thisId = tw.getFreshIdLabel<DbThisaccess>()
        tw.writeExprs_thisaccess(thisId, ids.type.javaResult.id, ids.type.kotlinResult.id, callId, -1)
        extractCommonExpr(thisId)

        addArgumentsToInvocationInInvokeNBody(parameters, funLabels, retId, callId, locId, ::extractCommonExpr)
    }

    /**
     * Adds the arguments to the method call inside `invoke(a0: Any[])`. Each argument is an array access with a cast:
     *
     * ```
     * fun invoke(args: Any[]) : T {
     *   return fn(args[0] as T0, args[1] as T1, ...)
     * }
     * ```
     */
    private fun addArgumentsToInvocationInInvokeNBody(
        parameters: List<IrValueParameter>,
        funLabels: FunctionLabels,
        retId: Label<DbReturnstmt>,
        callId: Label<out DbExprparent>,
        locId: Label<DbLocation>,
        extractCommonExpr: (Label<out DbExpr>) -> Unit,
        firstArgumentOffset: Int = 0,
        useFirstArgAsDispatch: Boolean = false,
        dispatchReceiverIdx: Int = -1
    ) {
        val intType = useType(pluginContext.irBuiltIns.intType)
        val argsParamType = pluginContext.irBuiltIns.arrayClass.typeWith(pluginContext.irBuiltIns.anyNType)
        val argsType = useType(argsParamType)
        val anyNType = useType(pluginContext.irBuiltIns.anyNType)

        val arrayIndexerFunction = pluginContext.irBuiltIns.arrayClass.owner.declarations.find { it is IrFunction && it.name.asString() == "get" }

        @Suppress("UNCHECKED_CAST")
        val arrayIndexerFunctionId = useFunction<DbMethod>(arrayIndexerFunction as IrFunction)

        val dispatchIdxOffset = if (useFirstArgAsDispatch) 1 else 0

        for ((pIdx, p) in parameters.withIndex()) {
            // `args[i] as Ti` is generated below for each parameter

            val childIdx =
                if (pIdx == 0 && useFirstArgAsDispatch) {
                    dispatchReceiverIdx
                } else {
                    pIdx + firstArgumentOffset - dispatchIdxOffset
                }

            // cast
            val castId = tw.getFreshIdLabel<DbCastexpr>()
            val type = useType(p.type)
            tw.writeExprs_castexpr(castId, type.javaResult.id, type.kotlinResult.id, callId, childIdx)
            extractCommonExpr(castId)

            // type access
            extractTypeAccess(p.type, locId, funLabels.methodId, castId, 0,  retId)

            // element access: `args.get(i)`
            val getCallId = tw.getFreshIdLabel<DbMethodaccess>()
            tw.writeExprs_methodaccess(getCallId, anyNType.javaResult.id, anyNType.kotlinResult.id, castId, 1)
            extractCommonExpr(getCallId)
            tw.writeCallableBinding(getCallId, arrayIndexerFunctionId)

            // parameter access:
            val argsAccessId = tw.getFreshIdLabel<DbVaraccess>()
            tw.writeExprs_varaccess(argsAccessId, argsType.javaResult.id, argsType.kotlinResult.id, getCallId, -1)
            extractCommonExpr(argsAccessId)
            tw.writeVariableBinding(argsAccessId, funLabels.parameters.first().first)

            // index access:
            val indexId = tw.getFreshIdLabel<DbIntegerliteral>()
            tw.writeExprs_integerliteral(indexId, intType.javaResult.id, intType.kotlinResult.id, getCallId, pIdx)
            extractCommonExpr(indexId)
            tw.writeNamestrings(pIdx.toString(), pIdx.toString(), indexId)
        }
    }

    fun extractVarargElement(e: IrVarargElement, callable: Label<out DbCallable>, parent: Label<out DbExprparent>, idx: Int, enclosingStmt: Label<out DbStmt>) {
        when(e) {
            is IrExpression -> {
                extractExpressionExpr(e, callable, parent, idx, enclosingStmt)
            }
            is IrSpreadElement -> {
                // TODO:
                logger.warnElement(Severity.ErrorSevere, "Unhandled IrSpreadElement", e)
            }
            else -> {
                logger.warnElement(Severity.ErrorSevere, "Unrecognised IrVarargElement: " + e.javaClass, e)
            }
        }
    }

    private fun extractTypeAccess(type: TypeResults, location: Label<DbLocation>, callable: Label<out DbCallable>, parent: Label<out DbExprparent>, idx: Int, enclosingStmt: Label<out DbStmt>): Label<out DbExpr> {
        val id = extractTypeAccess(type, location, parent, idx)
        tw.writeCallableEnclosingExpr(id, callable)
        tw.writeStatementEnclosingExpr(id, enclosingStmt)
        return id
    }

    private fun extractTypeAccess(type: TypeResults, location: Label<DbLocation>, parent: Label<out DbExprparent>, idx: Int): Label<out DbExpr> {
        // TODO: elementForLocation allows us to give some sort of
        // location, but a proper location for the type access will
        // require upstream changes
        val id = tw.getFreshIdLabel<DbUnannotatedtypeaccess>()
        tw.writeExprs_unannotatedtypeaccess(id, type.javaResult.id, type.kotlinResult.id, parent, idx)
        tw.writeHasLocation(id, location)
        return id
    }

    private fun extractTypeAccess(t: IrType, location: Label<DbLocation>, callable: Label<out DbCallable>, parent: Label<out DbExprparent>, idx: Int, enclosingStmt: Label<out DbStmt>, typeContext: TypeContext = TypeContext.OTHER): Label<out DbExpr> {
        return extractTypeAccess(useType(t, typeContext), location, callable, parent, idx, enclosingStmt)
    }

    private fun extractTypeAccess(t: TypeResults, callable: Label<out DbCallable>, parent: Label<out DbExprparent>, idx: Int, elementForLocation: IrElement, enclosingStmt: Label<out DbStmt>): Label<out DbExpr> {
        return extractTypeAccess(t, tw.getLocation(elementForLocation), callable, parent, idx, enclosingStmt)
    }

    private fun extractTypeAccess(t: IrType, callable: Label<out DbCallable>, parent: Label<out DbExprparent>, idx: Int, elementForLocation: IrElement, enclosingStmt: Label<out DbStmt>, typeContext: TypeContext = TypeContext.OTHER): Label<out DbExpr> {
        return extractTypeAccess(useType(t, typeContext), callable, parent, idx, elementForLocation, enclosingStmt)
    }

    fun extractTypeOperatorCall(e: IrTypeOperatorCall, callable: Label<out DbCallable>, parent: Label<out DbExprparent>, idx: Int, enclosingStmt: Label<out DbStmt>) {
        when(e.operator) {
            IrTypeOperator.CAST -> {
                val id = tw.getFreshIdLabel<DbCastexpr>()
                val locId = tw.getLocation(e)
                val type = useType(e.type)
                tw.writeExprs_castexpr(id, type.javaResult.id, type.kotlinResult.id, parent, idx)
                tw.writeHasLocation(id, locId)
                tw.writeCallableEnclosingExpr(id, callable)
                tw.writeStatementEnclosingExpr(id, enclosingStmt)
                extractTypeAccess(e.typeOperand, callable, id, 0, e, enclosingStmt)
                extractExpressionExpr(e.argument, callable, id, 1, enclosingStmt)
            }
            IrTypeOperator.IMPLICIT_CAST -> {
                val id = tw.getFreshIdLabel<DbImplicitcastexpr>()
                val locId = tw.getLocation(e)
                val type = useType(e.type)
                tw.writeExprs_implicitcastexpr(id, type.javaResult.id, type.kotlinResult.id, parent, idx)
                tw.writeHasLocation(id, locId)
                tw.writeCallableEnclosingExpr(id, callable)
                tw.writeStatementEnclosingExpr(id, enclosingStmt)
                extractTypeAccess(e.typeOperand, callable, id, 0, e, enclosingStmt)
                extractExpressionExpr(e.argument, callable, id, 1, enclosingStmt)
            }
            IrTypeOperator.IMPLICIT_NOTNULL -> {
                val id = tw.getFreshIdLabel<DbImplicitnotnullexpr>()
                val locId = tw.getLocation(e)
                val type = useType(e.type)
                tw.writeExprs_implicitnotnullexpr(id, type.javaResult.id, type.kotlinResult.id, parent, idx)
                tw.writeHasLocation(id, locId)
                tw.writeCallableEnclosingExpr(id, callable)
                tw.writeStatementEnclosingExpr(id, enclosingStmt)
                extractTypeAccess(e.typeOperand, callable, id, 0, e, enclosingStmt)
                extractExpressionExpr(e.argument, callable, id, 1, enclosingStmt)
            }
            IrTypeOperator.IMPLICIT_COERCION_TO_UNIT -> {
                val id = tw.getFreshIdLabel<DbImplicitcoerciontounitexpr>()
                val locId = tw.getLocation(e)
                val type = useType(e.type)
                tw.writeExprs_implicitcoerciontounitexpr(id, type.javaResult.id, type.kotlinResult.id, parent, idx)
                tw.writeHasLocation(id, locId)
                tw.writeCallableEnclosingExpr(id, callable)
                tw.writeStatementEnclosingExpr(id, enclosingStmt)
                extractTypeAccess(e.typeOperand, callable, id, 0, e, enclosingStmt)
                extractExpressionExpr(e.argument, callable, id, 1, enclosingStmt)
            }
            IrTypeOperator.SAFE_CAST -> {
                val id = tw.getFreshIdLabel<DbSafecastexpr>()
                val locId = tw.getLocation(e)
                val type = useType(e.type)
                tw.writeExprs_safecastexpr(id, type.javaResult.id, type.kotlinResult.id, parent, idx)
                tw.writeHasLocation(id, locId)
                tw.writeCallableEnclosingExpr(id, callable)
                tw.writeStatementEnclosingExpr(id, enclosingStmt)
                extractTypeAccess(e.typeOperand, callable, id, 0, e, enclosingStmt)
                extractExpressionExpr(e.argument, callable, id, 1, enclosingStmt)
            }
            IrTypeOperator.INSTANCEOF -> {
                val id = tw.getFreshIdLabel<DbInstanceofexpr>()
                val locId = tw.getLocation(e)
                val type = useType(e.type)
                tw.writeExprs_instanceofexpr(id, type.javaResult.id, type.kotlinResult.id, parent, idx)
                tw.writeHasLocation(id, locId)
                tw.writeCallableEnclosingExpr(id, callable)
                tw.writeStatementEnclosingExpr(id, enclosingStmt)
                extractExpressionExpr(e.argument, callable, id, 0, enclosingStmt)
                extractTypeAccess(e.typeOperand, callable, id, 1, e, enclosingStmt)
            }
            IrTypeOperator.NOT_INSTANCEOF -> {
                val id = tw.getFreshIdLabel<DbNotinstanceofexpr>()
                val locId = tw.getLocation(e)
                val type = useType(e.type)
                tw.writeExprs_notinstanceofexpr(id, type.javaResult.id, type.kotlinResult.id, parent, idx)
                tw.writeHasLocation(id, locId)
                tw.writeCallableEnclosingExpr(id, callable)
                tw.writeStatementEnclosingExpr(id, enclosingStmt)
                extractExpressionExpr(e.argument, callable, id, 0, enclosingStmt)
                extractTypeAccess(e.typeOperand, callable, id, 1, e, enclosingStmt)
            }
            IrTypeOperator.SAM_CONVERSION -> {
                // TODO:
                logger.warnElement(Severity.ErrorSevere, "Unhandled IrTypeOperatorCall for SAM_CONVERSION: " + e.render(), e)
            }
            else -> {
                logger.warnElement(Severity.ErrorSevere, "Unrecognised IrTypeOperatorCall for ${e.operator}: " + e.render(), e)
            }
        }
    }

    private fun extractBreakContinue(
        e: IrBreakContinue,
        id: Label<out DbBreakcontinuestmt>
    ) {
        val locId = tw.getLocation(e)
        tw.writeHasLocation(id, locId)
        val label = e.label
        if (label != null) {
            tw.writeNamestrings(label, "", id)
        }

        val loopId = loopIdMap[e.loop]
        if (loopId == null) {
            logger.warnElement(Severity.ErrorSevere, "Missing break/continue target", e)
            return
        }

        tw.writeKtBreakContinueTargets(id, loopId)
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
        ids: LocallyVisibleFunctionLabels,
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
        tw.writeConstrs(ids.constructor, "", "", unitType.javaResult.id, unitType.kotlinResult.id, id, ids.constructor)
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
                    logger.warn(Severity.ErrorSevere, "Unexpected file parent found")
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
        val ids = getLocallyVisibleFunctionLabels(localFunction)

        val id = extractGeneratedClass(ids, superTypes, tw.getLocation(localFunction), localFunction)

        // Extract local function as a member
        extractFunctionIfReal(localFunction, id, true, null, listOf())

        return id
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
