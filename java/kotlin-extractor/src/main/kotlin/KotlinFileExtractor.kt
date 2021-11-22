package com.github.codeql

import com.semmle.extractor.java.OdasaOutput
import org.jetbrains.kotlin.backend.common.extensions.IrPluginContext
import org.jetbrains.kotlin.descriptors.ClassKind
import org.jetbrains.kotlin.descriptors.Modality
import org.jetbrains.kotlin.ir.IrElement
import org.jetbrains.kotlin.ir.IrStatement
import org.jetbrains.kotlin.ir.declarations.*
import org.jetbrains.kotlin.ir.expressions.*
import org.jetbrains.kotlin.ir.symbols.IrConstructorSymbol
import org.jetbrains.kotlin.ir.types.IrSimpleType
import org.jetbrains.kotlin.ir.types.IrType
import org.jetbrains.kotlin.ir.types.IrTypeArgument
import org.jetbrains.kotlin.ir.types.classFqName
import org.jetbrains.kotlin.ir.util.isAnonymousObject
import org.jetbrains.kotlin.ir.util.isNonCompanionObject
import org.jetbrains.kotlin.ir.util.packageFqName
import org.jetbrains.kotlin.ir.util.render

open class KotlinFileExtractor(
    override val logger: FileLogger,
    override val tw: FileTrapWriter,
    dependencyCollector: OdasaOutput.TrapFileManager?,
    externalClassExtractor: ExternalClassExtractor,
    pluginContext: IrPluginContext
): KotlinUsesExtractor(logger, tw, dependencyCollector, externalClassExtractor, pluginContext) {

    fun extractDeclaration(declaration: IrDeclaration, parentId: Label<out DbReftype>) {
        when (declaration) {
            is IrClass -> extractClassSource(declaration)
            is IrFunction -> extractFunction(declaration, parentId)
            is IrAnonymousInitializer -> {
                // Leaving this intentionally empty. init blocks are extracted during class extraction.
            }
            is IrProperty -> extractProperty(declaration, parentId)
            is IrEnumEntry -> extractEnumEntry(declaration, parentId)
            is IrTypeAlias -> extractTypeAlias(declaration) // TODO: Pass in and use parentId
            else -> logger.warnElement(Severity.ErrorSevere, "Unrecognised IrDeclaration: " + declaration.javaClass, declaration)
        }
    }



    fun getLabel(element: IrElement) : String? {
        when (element) {
            is IrFile -> return "@\"${element.path};sourcefile\"" // todo: remove copy-pasted code
            is IrClass -> return getClassLabel(element, listOf()).classLabel
            is IrTypeParameter -> return getTypeParameterLabel(element)
            is IrFunction -> return getFunctionLabel(element)
            is IrValueParameter -> return getValueParameterLabel(element)
            is IrProperty -> return getPropertyLabel(element)
            is IrField -> return getFieldLabel(element)

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

    fun extractTypeParameter(tp: IrTypeParameter): Label<out DbTypevariable> {
        val id = tw.getLabelFor<DbTypevariable>(getTypeParameterLabel(tp))

        val parentId: Label<out DbClassorinterfaceorcallable> = when (val parent = tp.parent) {
            is IrFunction -> useFunction(parent)
            is IrClass -> useClassSource(parent)
            else -> {
                logger.warnElement(Severity.ErrorSevere, "Unexpected type parameter parent", tp)
                fakeLabel()
            }
        }

        tw.writeTypeVars(id, tp.name.asString(), tp.index, 0, parentId)
        val locId = tw.getLocation(tp)
        tw.writeHasLocation(id, locId)

        // todo: add type bounds

        return id
    }

    fun extractClassInstance(c: IrClass, typeArgs: List<IrTypeArgument>): Label<out DbClassorinterface> {
        if (typeArgs.isEmpty()) {
            logger.warn(Severity.ErrorSevere, "Instance without type arguments: " + c.name.asString())
        }

        val results = addClassLabel(c, typeArgs)
        val id = results.id
        val pkg = c.packageFqName?.asString() ?: ""
        val cls = results.shortName
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

        for ((idx, arg) in typeArgs.withIndex()) {
            val argId = getTypeArgumentLabel(arg).id
            tw.writeTypeArgs(argId, idx, id)
        }
        tw.writeIsParameterized(id)
        val unbound = useClassSource(c)
        tw.writeErasure(id, unbound)
        extractClassModifiers(c, id)
        extractClassSupertypes(c, id)

        val locId = tw.getLocation(c)
        tw.writeHasLocation(id, locId)

        return id
    }

    private val anonymousTypeMap: MutableMap<IrClass, TypeResults> = mutableMapOf()

    override fun useAnonymousClass(c: IrClass): TypeResults {
        var res = anonymousTypeMap[c]
        if (res == null) {
            val javaResult = TypeResult(tw.getFreshIdLabel<DbClass>(), "", "")
            val kotlinResult = TypeResult(tw.getFreshIdLabel<DbKt_notnull_type>(), "", "")
            tw.writeKt_notnull_types(kotlinResult.id, javaResult.id)
            res = TypeResults(javaResult, kotlinResult)
            anonymousTypeMap[c] = res
        }

        return res
    }

    fun extractClassSource(c: IrClass): Label<out DbClassorinterface> {
        val id = if (c.isAnonymousObject) {
            @Suppress("UNCHECKED_CAST")
            useAnonymousClass(c).javaResult.id as Label<out DbClass>
        } else {
            useClassSource(c)
        }
        val pkg = c.packageFqName?.asString() ?: ""
        val cls = if (c.isAnonymousObject) "" else c.name.asString()
        val pkgId = extractPackage(pkg)
        if(c.kind == ClassKind.INTERFACE) {
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

        var parent: IrDeclarationParent? = c.parent
        while (parent != null) {
            if (parent is IrClass) {
                val parentId =
                    if (parent.isAnonymousObject) {
                        @Suppress("UNCHECKED_CAST")
                        useAnonymousClass(c).javaResult.id as Label<out DbClass>
                    } else {
                        useClassInstance(parent, listOf()).typeResult.id
                    }
                tw.writeEnclInReftype(id, parentId)
                if(c.isCompanion) {
                    // If we are a companion then our parent has a
                    //     public static final ParentClass$CompanionObjectClass CompanionObjectName;
                    // that we need to fabricate here
                    val instance = useCompanionObjectClassInstance(c)
                    if(instance != null) {
                        val type = useSimpleTypeClass(c, emptyList(), false)
                        tw.writeFields(instance.id, instance.name, type.javaResult.id, type.kotlinResult.id, id, instance.id)
                        tw.writeHasLocation(instance.id, locId)
                        addModifiers(instance.id, "public", "static", "final")
                        @Suppress("UNCHECKED_CAST")
                        tw.writeClass_companion_object(parentId as Label<DbClass>, instance.id, id as Label<DbClass>)
                    }
                }

                break
            }

            parent = (parent as? IrDeclaration)?.parent
        }

        c.typeParameters.map { extractTypeParameter(it) }
        c.declarations.map { extractDeclaration(it, id) }
        extractObjectInitializerFunction(c, id)
        if(c.isNonCompanionObject) {
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
        extractClassSupertypes(c, id)

        return id
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

    fun extractValueParameter(vp: IrValueParameter, parent: Label<out DbCallable>, idx: Int): TypeResults {
        val id = useValueParameter(vp)
        val type = useType(vp.type)
        val locId = tw.getLocation(vp)
        tw.writeParams(id, type.javaResult.id, type.kotlinResult.id, idx, parent, id)
        tw.writeHasLocation(id, locId)
        tw.writeParamName(id, vp.name.asString())
        return type
    }

    private fun extractObjectInitializerFunction(c: IrClass, parentId: Label<out DbReftype>) {
        if (isExternalDeclaration(c)) {
            return
        }

        // add method:
        val obinitLabel = getFunctionLabel(c, "<obinit>", listOf(), pluginContext.irBuiltIns.unitType)
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

                    val declLocId = tw.getLocation(decl)
                    val stmtId = tw.getFreshIdLabel<DbExprstmt>()
                    tw.writeStmts_exprstmt(stmtId, blockId, idx++, obinitId)
                    tw.writeHasLocation(stmtId, declLocId)
                    val assignmentId = tw.getFreshIdLabel<DbAssignexpr>()
                    val type = useType(initializer.expression.type)
                    tw.writeExprs_assignexpr(assignmentId, type.javaResult.id, type.kotlinResult.id, stmtId, 0)
                    tw.writeHasLocation(assignmentId, declLocId)
                    tw.writeCallableEnclosingExpr(assignmentId, obinitId)

                    val lhsId = tw.getFreshIdLabel<DbVaraccess>()
                    val lhsType = useType(backingField.type)
                    tw.writeExprs_varaccess(lhsId, lhsType.javaResult.id, lhsType.kotlinResult.id, assignmentId, 0)
                    tw.writeHasLocation(lhsId, declLocId)
                    tw.writeCallableEnclosingExpr(lhsId, obinitId)
                    val vId = useField(backingField)
                    tw.writeVariableBinding(lhsId, vId)

                    extractExpressionExpr(initializer.expression, obinitId, assignmentId, 1)
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

    fun extractFunction(f: IrFunction, parentId: Label<out DbReftype>): Label<out DbCallable> {
        currentFunction = f

        f.typeParameters.map { extractTypeParameter(it) }

        val locId = tw.getLocation(f)

        val id = useFunction<DbCallable>(f)
        val paramTypes = f.valueParameters.mapIndexed { i, vp ->
            extractValueParameter(vp, id, i)
        }
        val paramsSignature = paramTypes.joinToString(separator = ",", prefix = "(", postfix = ")") { it.javaResult.signature!! }

        if (f.symbol is IrConstructorSymbol) {
            val returnType = useType(erase(f.returnType))
            val shortName = if (f.returnType.isAnonymous) "" else f.returnType.classFqName?.shortName()?.asString() ?: f.name.asString()
            @Suppress("UNCHECKED_CAST")
            tw.writeConstrs(id as Label<DbConstructor>, shortName, "$shortName$paramsSignature", returnType.javaResult.id, returnType.kotlinResult.id, parentId, id)
        } else {
            val returnType = useType(f.returnType)
            val shortName = f.name.asString()
            @Suppress("UNCHECKED_CAST")
            tw.writeMethods(id as Label<DbMethod>, shortName, "$shortName$paramsSignature", returnType.javaResult.id, returnType.kotlinResult.id, parentId, id)

            val extReceiver = f.extensionReceiverParameter
            if (extReceiver != null) {
                val extendedType = useType(extReceiver.type)
                tw.writeKtExtensionFunctions(id, extendedType.javaResult.id, extendedType.kotlinResult.id)
            }
        }

        tw.writeHasLocation(id, locId)
        val body = f.body
        if(body != null) {
            extractBody(body, id)
        }

        currentFunction = null
        return id
    }

    fun extractField(f: IrField, parentId: Label<out DbReftype>): Label<out DbField> {
        val id = useField(f)
        val locId = tw.getLocation(f)
        val type = useType(f.type)
        tw.writeFields(id, f.name.asString(), type.javaResult.id, type.kotlinResult.id, parentId, id)
        tw.writeHasLocation(id, locId)
        return id
    }

    fun extractProperty(p: IrProperty, parentId: Label<out DbReftype>) {
        val id = useProperty(p)
        val locId = tw.getLocation(p)
        tw.writeKtProperties(id, p.name.asString())
        tw.writeHasLocation(id, locId)

        val bf = p.backingField
        val getter = p.getter
        val setter = p.setter

        if(getter != null) {
            @Suppress("UNCHECKED_CAST")
            val getterId = extractFunction(getter, parentId) as Label<out DbMethod>
            tw.writeKtPropertyGetters(id, getterId)
        } else {
            if (p.modality != Modality.FINAL || !isExternalDeclaration(p)) {
                logger.warnElement(Severity.ErrorSevere, "IrProperty without a getter", p)
            }
        }

        if(setter != null) {
            if(!p.isVar) {
                logger.warnElement(Severity.ErrorSevere, "!isVar property with a setter", p)
            }
            @Suppress("UNCHECKED_CAST")
            val setterId = extractFunction(setter, parentId) as Label<out DbMethod>
            tw.writeKtPropertySetters(id, setterId)
        } else {
            if (p.isVar && !isExternalDeclaration(p)) {
                logger.warnElement(Severity.ErrorSevere, "isVar property without a setter", p)
            }
        }

        if(bf != null) {
            val fieldId = extractField(bf, parentId)
            tw.writeKtPropertyBackingFields(id, fieldId)
        }
    }

    fun extractEnumEntry(ee: IrEnumEntry, parentId: Label<out DbReftype>) {
        val id = useEnumEntry(ee)
        val parent = ee.parent
        if(parent !is IrClass) {
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
            is IrBlockBody -> extractBlockBody(b, callable, callable, 0)
            else -> logger.warnElement(Severity.ErrorSevere, "Unrecognised IrBody: " + b.javaClass, b)
        }
    }

    fun extractBlockBody(b: IrBlockBody, callable: Label<out DbCallable>, parent: Label<out DbStmtparent>, idx: Int) {
        val id = tw.getFreshIdLabel<DbBlock>()
        val locId = tw.getLocation(b)
        tw.writeStmts_block(id, parent, idx, callable)
        tw.writeHasLocation(id, locId)
        for((sIdx, stmt) in b.statements.withIndex()) {
            extractStatement(stmt, callable, id, sIdx)
        }
    }

    fun extractVariable(v: IrVariable, callable: Label<out DbCallable>, parent: Label<out DbStmtparent>, idx: Int) {
        val stmtId = tw.getFreshIdLabel<DbLocalvariabledeclstmt>()
        val locId = tw.getLocation(v)
        tw.writeStmts_localvariabledeclstmt(stmtId, parent, idx, callable)
        tw.writeHasLocation(stmtId, locId)
        extractVariableExpr(v, callable, stmtId, 1)
    }

    fun extractVariableExpr(v: IrVariable, callable: Label<out DbCallable>, parent: Label<out DbExprparent>, idx: Int) {
        val varId = useVariable(v)
        val exprId = tw.getFreshIdLabel<DbLocalvariabledeclexpr>()
        val locId = tw.getLocation(v)
        val type = useType(v.type)
        tw.writeLocalvars(varId, v.name.asString(), type.javaResult.id, type.kotlinResult.id, exprId)
        tw.writeHasLocation(varId, locId)
        tw.writeExprs_localvariabledeclexpr(exprId, type.javaResult.id, type.kotlinResult.id, parent, idx)
        tw.writeHasLocation(exprId, locId)
        tw.writeCallableEnclosingExpr(exprId, callable)
        val i = v.initializer
        if(i != null) {
            extractExpressionExpr(i, callable, exprId, 0)
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
                if (s.isAnonymousObject) {
                    logger.info("Skipping extracting anonymous object class. It will be extracted later where it's instantiated.")
                } else {
                    logger.warnElement(Severity.ErrorSevere, "Found non anonymous IrClass as IrStatement: " + s.javaClass, s)
                }
            }
            else -> {
                logger.warnElement(Severity.ErrorSevere, "Unrecognised IrStatement: " + s.javaClass, s)
            }
        }
    }

    fun isBuiltinCall(c: IrCall, fName: String): Boolean {
        val verbose = false
        fun verboseln(s: String) { if(verbose) println(s) }
        verboseln("Attempting builtin match for $fName")
        val target = c.symbol.owner
        if (target.name.asString() != fName) {
            verboseln("No match as function name is ${target.name.asString()} not $fName")
            return false
        }
        val extensionReceiverParameter = target.extensionReceiverParameter
        // TODO: Are both branches of this `if` possible?:
        val targetPkg = if (extensionReceiverParameter == null) target.parent
                        else (extensionReceiverParameter.type as? IrSimpleType)?.classifier?.owner
        if (targetPkg !is IrPackageFragment) {
            verboseln("No match as didn't find target package")
            return false
        }
        if (targetPkg.fqName.asString() != "kotlin.internal.ir") {
            verboseln("No match as package name is ${targetPkg.fqName.asString()}")
            return false
        }
        verboseln("Match")
        return true
    }

    fun binop(id: Label<out DbExpr>, c: IrCall, callable: Label<out DbCallable>) {
        val locId = tw.getLocation(c)
        tw.writeHasLocation(id, locId)
        tw.writeCallableEnclosingExpr(id, callable)

        val dr = c.dispatchReceiver
        if(dr != null) {
            logger.warnElement(Severity.ErrorSevere, "Unexpected dispatch receiver found", c)
        }
        if(c.valueArgumentsCount < 1) {
            logger.warnElement(Severity.ErrorSevere, "No arguments found", c)
        } else {
            val lhs = c.getValueArgument(0)
            if(lhs == null) {
                logger.warnElement(Severity.ErrorSevere, "LHS null", c)
            } else {
                extractExpressionExpr(lhs, callable, id, 0)
            }
            if(c.valueArgumentsCount < 2) {
                logger.warnElement(Severity.ErrorSevere, "No RHS found", c)
            } else {
                val rhs = c.getValueArgument(1)
                if(rhs == null) {
                    logger.warnElement(Severity.ErrorSevere, "RHS null", c)
                } else {
                    extractExpressionExpr(rhs, callable, id, 1)
                }
            }
            if(c.valueArgumentsCount > 2) {
                logger.warnElement(Severity.ErrorSevere, "Extra arguments found", c)
            }
        }
    }

    fun extractCall(c: IrCall, callable: Label<out DbCallable>, parent: Label<out DbExprparent>, idx: Int) {
        fun isFunction(pkgName: String, className: String, fName: String): Boolean {
            val verbose = false
            fun verboseln(s: String) { if(verbose) println(s) }
            verboseln("Attempting match for $pkgName $className $fName")
            val target = c.symbol.owner
            if (target.name.asString() != fName) {
                verboseln("No match as function name is ${target.name.asString()} not $fName")
                return false
            }
            val extensionReceiverParameter = target.extensionReceiverParameter
            // TODO: Are both branches of this `if` possible?:
            val targetClass = if (extensionReceiverParameter == null) target.parent
                              else (extensionReceiverParameter.type as? IrSimpleType)?.classifier?.owner
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
                   isFunction("kotlin", "Short", fName) ||
                   isFunction("kotlin", "Long", fName) ||
                   isFunction("kotlin", "Float", fName) ||
                   isFunction("kotlin", "Double", fName)
        }

        fun binopDisp(id: Label<out DbExpr>) {
            val locId = tw.getLocation(c)
            tw.writeHasLocation(id, locId)
            tw.writeCallableEnclosingExpr(id, callable)

            val dr = c.dispatchReceiver
            if(dr == null) {
                logger.warnElement(Severity.ErrorSevere, "Dispatch receiver not found", c)
            } else {
                extractExpressionExpr(dr, callable, id, 0)
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
                    extractExpressionExpr(arg, callable, id, 1)
                }
            }
        }

        val dr = c.dispatchReceiver
        when {
            c.origin == IrStatementOrigin.PLUS &&
            (isNumericFunction("plus") || isFunction("kotlin", "String", "plus")) -> {
                val id = tw.getFreshIdLabel<DbAddexpr>()
                val type = useType(c.type)
                tw.writeExprs_addexpr(id, type.javaResult.id, type.kotlinResult.id, parent, idx)
                binopDisp(id)
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
            c.origin == IrStatementOrigin.EXCLEQ && isFunction("kotlin", "Boolean", "not") && c.valueArgumentsCount == 0 && dr != null && dr is IrCall && isBuiltinCall(dr, "EQEQ") -> {
                val id = tw.getFreshIdLabel<DbNeexpr>()
                val type = useType(c.type)
                tw.writeExprs_neexpr(id, type.javaResult.id, type.kotlinResult.id, parent, idx)
                binop(id, dr, callable)
            }
            c.origin == IrStatementOrigin.EXCLEQEQ && isFunction("kotlin", "Boolean", "not") && c.valueArgumentsCount == 0 && dr != null && dr is IrCall && isBuiltinCall(dr, "EQEQEQ") -> {
                val id = tw.getFreshIdLabel<DbNeexpr>()
                val type = useType(c.type)
                tw.writeExprs_neexpr(id, type.javaResult.id, type.kotlinResult.id, parent, idx)
                binop(id, dr, callable)
            }
            c.origin == IrStatementOrigin.EXCLEQ && isFunction("kotlin", "Boolean", "not") && c.valueArgumentsCount == 0 && dr != null && dr is IrCall && isBuiltinCall(dr, "ieee754equals") -> {
                val id = tw.getFreshIdLabel<DbNeexpr>()
                val type = useType(c.type)
                // TODO: Is this consistent with Java?
                tw.writeExprs_neexpr(id, type.javaResult.id, type.kotlinResult.id, parent, idx)
                binop(id, dr, callable)
            }
            // We need to handle all the builtin operators defines in BuiltInOperatorNames in
            //     compiler/ir/ir.tree/src/org/jetbrains/kotlin/ir/IrBuiltIns.kt
            // as they can't be extracted as external dependencies.
            isBuiltinCall(c, "less") -> {
                if(c.origin != IrStatementOrigin.LT) {
                    logger.warnElement(Severity.ErrorSevere, "Unexpected origin for LT: ${c.origin}", c)
                }
                val id = tw.getFreshIdLabel<DbLtexpr>()
                val type = useType(c.type)
                tw.writeExprs_ltexpr(id, type.javaResult.id, type.kotlinResult.id, parent, idx)
                binop(id, c, callable)
            }
            isBuiltinCall(c, "lessOrEqual") -> {
                if(c.origin != IrStatementOrigin.LTEQ) {
                    logger.warnElement(Severity.ErrorSevere, "Unexpected origin for LTEQ: ${c.origin}", c)
                }
                val id = tw.getFreshIdLabel<DbLeexpr>()
                val type = useType(c.type)
                tw.writeExprs_leexpr(id, type.javaResult.id, type.kotlinResult.id, parent, idx)
                binop(id, c, callable)
            }
            isBuiltinCall(c, "greater") -> {
                if(c.origin != IrStatementOrigin.GT) {
                    logger.warnElement(Severity.ErrorSevere, "Unexpected origin for GT: ${c.origin}", c)
                }
                val id = tw.getFreshIdLabel<DbGtexpr>()
                val type = useType(c.type)
                tw.writeExprs_gtexpr(id, type.javaResult.id, type.kotlinResult.id, parent, idx)
                binop(id, c, callable)
            }
            isBuiltinCall(c, "greaterOrEqual") -> {
                if(c.origin != IrStatementOrigin.GTEQ) {
                    logger.warnElement(Severity.ErrorSevere, "Unexpected origin for GTEQ: ${c.origin}", c)
                }
                val id = tw.getFreshIdLabel<DbGeexpr>()
                val type = useType(c.type)
                tw.writeExprs_geexpr(id, type.javaResult.id, type.kotlinResult.id, parent, idx)
                binop(id, c, callable)
            }
            isBuiltinCall(c, "EQEQ") -> {
                if(c.origin != IrStatementOrigin.EQEQ) {
                    logger.warnElement(Severity.ErrorSevere, "Unexpected origin for EQEQ: ${c.origin}", c)
                }
                // TODO: This is wrong. Kotlin `a == b` is `a?.equals(b) ?: (b === null)`
                val id = tw.getFreshIdLabel<DbEqexpr>()
                val type = useType(c.type)
                tw.writeExprs_eqexpr(id, type.javaResult.id, type.kotlinResult.id, parent, idx)
                binop(id, c, callable)
            }
            isBuiltinCall(c, "EQEQEQ") -> {
                if(c.origin != IrStatementOrigin.EQEQEQ) {
                    logger.warnElement(Severity.ErrorSevere, "Unexpected origin for EQEQEQ: ${c.origin}", c)
                }
                val id = tw.getFreshIdLabel<DbEqexpr>()
                val type = useType(c.type)
                tw.writeExprs_eqexpr(id, type.javaResult.id, type.kotlinResult.id, parent, idx)
                binop(id, c, callable)
            }
            isBuiltinCall(c, "ieee754equals") -> {
                if(c.origin != IrStatementOrigin.EQEQ) {
                    logger.warnElement(Severity.ErrorSevere, "Unexpected origin for ieee754equals: ${c.origin}", c)
                }
                // TODO: Is this consistent with Java?
                val id = tw.getFreshIdLabel<DbEqexpr>()
                val type = useType(c.type)
                tw.writeExprs_eqexpr(id, type.javaResult.id, type.kotlinResult.id, parent, idx)
                binop(id, c, callable)
            }
            isBuiltinCall(c, "THROW_CCE") -> {
                // TODO
                logger.warnElement(Severity.ErrorSevere, "Unhandled builtin", c)
            }
            isBuiltinCall(c, "THROW_ISE") -> {
                // TODO
                logger.warnElement(Severity.ErrorSevere, "Unhandled builtin", c)
            }
            isBuiltinCall(c, "noWhenBranchMatchedException") -> {
                // TODO
                logger.warnElement(Severity.ErrorSevere, "Unhandled builtin", c)
            }
            isBuiltinCall(c, "illegalArgumentException") -> {
                // TODO
                logger.warnElement(Severity.ErrorSevere, "Unhandled builtin", c)
            }
            isBuiltinCall(c, "ANDAND") -> {
                // TODO
                logger.warnElement(Severity.ErrorSevere, "Unhandled builtin", c)
            }
            isBuiltinCall(c, "OROR") -> {
                // TODO
                logger.warnElement(Severity.ErrorSevere, "Unhandled builtin", c)
            }
            else -> {
                val id = tw.getFreshIdLabel<DbMethodaccess>()
                val type = useType(c.type)
                val locId = tw.getLocation(c)
                val methodId = useFunction<DbMethod>(c.symbol.owner)
                tw.writeExprs_methodaccess(id, type.javaResult.id, type.kotlinResult.id, parent, idx)
                tw.writeHasLocation(id, locId)
                tw.writeCallableEnclosingExpr(id, callable)
                tw.writeCallableBinding(id, methodId)

                // type arguments at index -2, -3, ...
                extractTypeArguments(c, id, callable, -2, true)

                if(dr != null) {
                    extractExpressionExpr(dr, callable, id, -1)
                }
                for(i in 0 until c.valueArgumentsCount) {
                    val arg = c.getValueArgument(i)
                    if(arg != null) {
                        extractExpressionExpr(arg, callable, id, i)
                    }
                }
            }
        }
    }

    private fun extractTypeArguments(
        c: IrFunctionAccessExpression,
        id: Label<out DbExprparent>,
        callable: Label<out DbCallable>,
        startIndex: Int = 0,
        reverse: Boolean = false
    ) {
        for (argIdx in 0 until c.typeArgumentsCount) {
            val arg = c.getTypeArgument(argIdx)!!
            val argType = useType(arg, false)
            val argId = tw.getFreshIdLabel<DbUnannotatedtypeaccess>()
            val mul = if (reverse) -1 else 1
            tw.writeExprs_unannotatedtypeaccess(argId, argType.javaResult.id, argType.kotlinResult.id, id, argIdx * mul + startIndex)
            tw.writeCallableEnclosingExpr(argId, callable)
        }
    }

    private fun extractConstructorCall(
        e: IrFunctionAccessExpression,
        parent: Label<out DbExprparent>,
        idx: Int,
        callable: Label<out DbCallable>
    ) {
        val id = tw.getFreshIdLabel<DbNewexpr>()
        val type: TypeResults
        val isAnonymous = e.type.isAnonymous
        if (isAnonymous) {
            if (e.typeArgumentsCount > 0) {
                logger.warn("Unexpected type arguments for anonymous class constructor call")
            }

            val c = (e.type as IrSimpleType).classifier.owner as IrClass
            @Suppress("UNCHECKED_CAST")
            val classId = extractClassSource(c) as Label<out DbClass>
            tw.writeIsAnonymClass(classId, id)

            type = useAnonymousClass(c)
        } else {
            type = useType(e.type)
        }
        val locId = tw.getLocation(e)
        val methodId = useFunction<DbConstructor>(e.symbol.owner)
        tw.writeExprs_newexpr(id, type.javaResult.id, type.kotlinResult.id, parent, idx)
        tw.writeHasLocation(id, locId)
        tw.writeCallableEnclosingExpr(id, callable)
        tw.writeCallableBinding(id, methodId)
        for (i in 0 until e.valueArgumentsCount) {
            val arg = e.getValueArgument(i)
            if (arg != null) {
                extractExpressionExpr(arg, callable, id, i)
            }
        }
        val dr = e.dispatchReceiver
        if (dr != null) {
            extractExpressionExpr(dr, callable, id, -2)
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

        val typeAccessId = tw.getFreshIdLabel<DbUnannotatedtypeaccess>()
        tw.writeExprs_unannotatedtypeaccess(typeAccessId, typeAccessType.javaResult.id, typeAccessType.kotlinResult.id, id, -3)
        tw.writeCallableEnclosingExpr(typeAccessId, callable)

        if (e.typeArgumentsCount > 0) {
            extractTypeArguments(e, typeAccessId, callable)
        }
    }

    private val loopIdMap: MutableMap<IrLoop, Label<out DbKtloopstmt>> = mutableMapOf()

    private var currentFunction: IrFunction? = null

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
            return ExprParent(id, 0)
        }
    }
    inner class ExprParent(val parent: Label<out DbExprparent>, val idx: Int): StmtExprParent() {
        override fun stmt(e: IrExpression, callable: Label<out DbCallable>): StmtParent {
            val id = tw.getFreshIdLabel<DbStmtexpr>()
            val type = useType(e.type)
            val locId = tw.getLocation(e)
            tw.writeExprs_stmtexpr(id, type.javaResult.id, type.kotlinResult.id, parent, idx)
            tw.writeHasLocation(id, locId)
            tw.writeCallableEnclosingExpr(id, callable)
            return StmtParent(id, 0)
        }
        override fun expr(e: IrExpression, callable: Label<out DbCallable>): ExprParent {
            return this
        }
    }

    fun extractExpressionStmt(e: IrExpression, callable: Label<out DbCallable>, parent: Label<out DbStmtparent>, idx: Int) {
        extractExpression(e, callable, StmtParent(parent, idx))
    }

    fun extractExpressionExpr(e: IrExpression, callable: Label<out DbCallable>, parent: Label<out DbExprparent>, idx: Int) {
        extractExpression(e, callable, ExprParent(parent, idx))
    }

    fun extractExpression(e: IrExpression, callable: Label<out DbCallable>, parent: StmtExprParent) {
        when(e) {
            is IrDelegatingConstructorCall -> {
                val stmtParent = parent.stmt(e, callable)

                val irCallable = currentFunction
                if (irCallable == null) {
                    logger.warnElement(Severity.ErrorSevere, "Current function is not set", e)
                    return
                }

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
                        extractExpressionExpr(arg, callable, id, i)
                    }
                }
                val dr = e.dispatchReceiver
                if (dr != null) {
                    extractExpressionExpr(dr, callable, id, -1)
                }

                // todo: type arguments at index -2, -3, ...
            }
            is IrThrow -> {
                val stmtParent = parent.stmt(e, callable)
                val id = tw.getFreshIdLabel<DbThrowstmt>()
                val locId = tw.getLocation(e)
                tw.writeStmts_throwstmt(id, stmtParent.parent, stmtParent.idx, callable)
                tw.writeHasLocation(id, locId)
                extractExpressionExpr(e.value, callable, id, 0)
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
                extractExpressionExpr(e.value, callable, id, 0)
            }
            is IrTry -> {
                val stmtParent = parent.stmt(e, callable)
                val id = tw.getFreshIdLabel<DbTrystmt>()
                val locId = tw.getLocation(e)
                tw.writeStmts_trystmt(id, stmtParent.parent, stmtParent.idx, callable)
                tw.writeHasLocation(id, locId)
                extractExpressionExpr(e.tryResult, callable, id, -1)
                val finallyStmt = e.finallyExpression
                if(finallyStmt != null) {
                    extractExpressionExpr(finallyStmt, callable, id, -2)
                }
                for((catchIdx, catchClause) in e.catches.withIndex()) {
                    val catchId = tw.getFreshIdLabel<DbCatchclause>()
                    tw.writeStmts_catchclause(catchId, id, catchIdx, callable)
                    // TODO: Index -1: unannotatedtypeaccess
                    extractVariableExpr(catchClause.catchParameter, callable, catchId, 0)
                    extractExpressionExpr(catchClause.result, callable, catchId, 1)
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
                extractExpressionExpr(e.condition, callable, id, 0)
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
                extractExpressionExpr(e.condition, callable, id, 0)
                val body = e.body
                if(body != null) {
                    extractExpressionStmt(body, callable, id, 1)
                }
                loopIdMap.remove(e)
            }
            is IrInstanceInitializerCall -> {
                val exprParent = parent.expr(e, callable)
                val irCallable = currentFunction
                if (irCallable == null) {
                    logger.warnElement(Severity.ErrorSevere, "Current function is not set", e)
                    return
                }

                if (irCallable is IrConstructor && irCallable.isPrimary) {
                    // Todo add parameter to field assignments
                }

                // Add call to <obinit>:
                val id = tw.getFreshIdLabel<DbMethodaccess>()
                val type = useType(e.type)
                val locId = tw.getLocation(e)
                val methodLabel = getFunctionLabel(irCallable.parent, "<obinit>", listOf(), e.type)
                val methodId = tw.getLabelFor<DbMethod>(methodLabel)
                tw.writeExprs_methodaccess(id, type.javaResult.id, type.kotlinResult.id, exprParent.parent, exprParent.idx)
                tw.writeHasLocation(id, locId)
                tw.writeCallableEnclosingExpr(id, callable)
                tw.writeCallableBinding(id, methodId)
            }
            is IrConstructorCall -> {
                val exprParent = parent.expr(e, callable)
                extractConstructorCall(e, exprParent.parent, exprParent.idx, callable)
            }
            is IrEnumConstructorCall -> {
                val exprParent = parent.expr(e, callable)
                extractConstructorCall(e, exprParent.parent, exprParent.idx, callable)
            }
            is IrCall -> {
                val exprParent = parent.expr(e, callable)
                extractCall(e, callable, exprParent.parent, exprParent.idx)
            }
            is IrStringConcatenation -> {
                val exprParent = parent.expr(e, callable)
                val id = tw.getFreshIdLabel<DbStringtemplateexpr>()
                val type = useType(e.type)
                val locId = tw.getLocation(e)
                tw.writeExprs_stringtemplateexpr(id, type.javaResult.id, type.kotlinResult.id, exprParent.parent, exprParent.idx)
                tw.writeHasLocation(id, locId)
                tw.writeCallableEnclosingExpr(id, callable)
                e.arguments.forEachIndexed { i, a ->
                    extractExpressionExpr(a, callable, id, i)
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
                        tw.writeNamestrings(v.toString(), v.toString(), id)
                    } is Long -> {
                        val id = tw.getFreshIdLabel<DbLongliteral>()
                        val type = useType(e.type)
                        val locId = tw.getLocation(e)
                        tw.writeExprs_longliteral(id, type.javaResult.id, type.kotlinResult.id, exprParent.parent, exprParent.idx)
                        tw.writeHasLocation(id, locId)
                        tw.writeCallableEnclosingExpr(id, callable)
                        tw.writeNamestrings(v.toString(), v.toString(), id)
                    } is Float -> {
                        val id = tw.getFreshIdLabel<DbFloatingpointliteral>()
                        val type = useType(e.type)
                        val locId = tw.getLocation(e)
                        tw.writeExprs_floatingpointliteral(id, type.javaResult.id, type.kotlinResult.id, exprParent.parent, exprParent.idx)
                        tw.writeHasLocation(id, locId)
                        tw.writeCallableEnclosingExpr(id, callable)
                        tw.writeNamestrings(v.toString(), v.toString(), id)
                    } is Double -> {
                        val id = tw.getFreshIdLabel<DbDoubleliteral>()
                        val type = useType(e.type)
                        val locId = tw.getLocation(e)
                        tw.writeExprs_doubleliteral(id, type.javaResult.id, type.kotlinResult.id, exprParent.parent, exprParent.idx)
                        tw.writeHasLocation(id, locId)
                        tw.writeCallableEnclosingExpr(id, callable)
                        tw.writeNamestrings(v.toString(), v.toString(), id)
                    } is Boolean -> {
                        val id = tw.getFreshIdLabel<DbBooleanliteral>()
                        val type = useType(e.type)
                        val locId = tw.getLocation(e)
                        tw.writeExprs_booleanliteral(id, type.javaResult.id, type.kotlinResult.id, exprParent.parent, exprParent.idx)
                        tw.writeHasLocation(id, locId)
                        tw.writeCallableEnclosingExpr(id, callable)
                        tw.writeNamestrings(v.toString(), v.toString(), id)
                    } is Char -> {
                        val id = tw.getFreshIdLabel<DbCharacterliteral>()
                        val type = useType(e.type)
                        val locId = tw.getLocation(e)
                        tw.writeExprs_characterliteral(id, type.javaResult.id, type.kotlinResult.id, exprParent.parent, exprParent.idx)
                        tw.writeHasLocation(id, locId)
                        tw.writeCallableEnclosingExpr(id, callable)
                        tw.writeNamestrings(v.toString(), v.toString(), id)
                    } is String -> {
                        val id = tw.getFreshIdLabel<DbStringliteral>()
                        val type = useType(e.type)
                        val locId = tw.getLocation(e)
                        tw.writeExprs_stringliteral(id, type.javaResult.id, type.kotlinResult.id, exprParent.parent, exprParent.idx)
                        tw.writeHasLocation(id, locId)
                        tw.writeCallableEnclosingExpr(id, callable)
                        tw.writeNamestrings(v.toString(), v.toString(), id)
                    }
                    null -> {
                        val id = tw.getFreshIdLabel<DbNullliteral>()
                        val type = useType(e.type) // class;kotlin.Nothing
                        val locId = tw.getLocation(e)
                        tw.writeExprs_nullliteral(id, type.javaResult.id, type.kotlinResult.id, exprParent.parent, exprParent.idx)
                        tw.writeHasLocation(id, locId)
                        tw.writeCallableEnclosingExpr(id, callable)
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

                    when(val ownerParent = owner.parent) {
                        is IrFunction -> {
                            if (ownerParent.dispatchReceiverParameter == owner &&
                                ownerParent.extensionReceiverParameter != null) {
                                logger.warnElement(Severity.ErrorSevere, "Function-qualifier for this", e)
                            }
                        }
                        is IrClass -> {
                            if (ownerParent.thisReceiver == owner) {
                                val qualId = tw.getFreshIdLabel<DbUnannotatedtypeaccess>()
                                // TODO: Type arguments
                                val qualType = useSimpleTypeClass(ownerParent, listOf(), false)
                                tw.writeExprs_unannotatedtypeaccess(qualId, qualType.javaResult.id, qualType.kotlinResult.id, id, 0)
                                tw.writeHasLocation(qualId, locId)
                                tw.writeCallableEnclosingExpr(qualId, callable)
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
                val owner = e.symbol.owner
                val vId = useField(owner)
                tw.writeVariableBinding(id, vId)
            }
            is IrGetEnumValue -> {
                val exprParent = parent.expr(e, callable)
                val id = tw.getFreshIdLabel<DbVaraccess>()
                val type = useType(e.type)
                val locId = tw.getLocation(e)
                tw.writeExprs_varaccess(id, type.javaResult.id, type.kotlinResult.id, exprParent.parent, exprParent.idx)
                tw.writeHasLocation(id, locId)
                tw.writeCallableEnclosingExpr(id, callable)
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

                val lhsId = tw.getFreshIdLabel<DbVaraccess>()
                tw.writeHasLocation(id, locId)
                tw.writeCallableEnclosingExpr(lhsId, callable)

                when (e) {
                    is IrSetValue -> {
                        val lhsType = useType(e.symbol.owner.type)
                        tw.writeExprs_varaccess(lhsId, lhsType.javaResult.id, lhsType.kotlinResult.id, id, 0)
                        val vId = useValueDeclaration(e.symbol.owner)
                        tw.writeVariableBinding(lhsId, vId)
                        extractExpressionExpr(e.value, callable, id, 1)
                    }
                    is IrSetField -> {
                        val lhsType = useType(e.symbol.owner.type)
                        tw.writeExprs_varaccess(lhsId, lhsType.javaResult.id, lhsType.kotlinResult.id, id, 0)
                        val vId = useField(e.symbol.owner)
                        tw.writeVariableBinding(lhsId, vId)
                        extractExpressionExpr(e.value, callable, id, 1)
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
                if(e.origin == IrStatementOrigin.IF) {
                    tw.writeWhen_if(id)
                }
                e.branches.forEachIndexed { i, b ->
                    val bId = tw.getFreshIdLabel<DbWhenbranch>()
                    val bLocId = tw.getLocation(b)
                    tw.writeWhen_branch(bId, id, i)
                    tw.writeHasLocation(bId, bLocId)
                    extractExpressionExpr(b.condition, callable, bId, 0)
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
                extractExpressionExpr(e.argument, callable, id, 0)
            }
            is IrTypeOperatorCall -> {
                val exprParent = parent.expr(e, callable)
                extractTypeOperatorCall(e, callable, exprParent.parent, exprParent.idx)
            }
            is IrVararg -> {
                val exprParent = parent.expr(e, callable)
                val id = tw.getFreshIdLabel<DbVarargexpr>()
                val locId = tw.getLocation(e)
                val type = useType(e.type)
                tw.writeExprs_varargexpr(id, type.javaResult.id, type.kotlinResult.id, exprParent.parent, exprParent.idx)
                tw.writeHasLocation(id, locId)
                tw.writeCallableEnclosingExpr(id, callable)
                e.elements.forEachIndexed { i, arg -> extractVarargElement(arg, callable, id, i) }
            }
            is IrGetObjectValue -> {
                // For `object MyObject { ... }`, the .class has an
                // automatically-generated `public static final MyObject INSTANCE`
                // field that we are accessing here.
                val exprParent = parent.expr(e, callable)
                val c: IrClass = e.symbol.owner
                val instance = if (c.isCompanion) useCompanionObjectClassInstance(c) else useObjectClassInstance(c)

                if(instance != null) {
                    val id = tw.getFreshIdLabel<DbVaraccess>()
                    val type = useType(e.type)
                    val locId = tw.getLocation(e)
                    tw.writeExprs_varaccess(id, type.javaResult.id, type.kotlinResult.id, exprParent.parent, exprParent.idx)
                    tw.writeHasLocation(id, locId)
                    tw.writeCallableEnclosingExpr(id, callable)

                    tw.writeVariableBinding(id, instance.id)
                }
            }
            else -> {
                logger.warnElement(Severity.ErrorSevere, "Unrecognised IrExpression: " + e.javaClass, e)
            }
        }
    }

    fun extractVarargElement(e: IrVarargElement, callable: Label<out DbCallable>, parent: Label<out DbExprparent>, idx: Int) {
        when(e) {
            is IrExpression -> {
                extractExpressionExpr(e, callable, parent, idx)
            }
            else -> {
                logger.warnElement(Severity.ErrorSevere, "Unrecognised IrVarargElement: " + e.javaClass, e)
            }
        }
    }

    fun extractTypeAccess(t: IrType, callable: Label<out DbCallable>, parent: Label<out DbExprparent>, idx: Int, elementForLocation: IrElement) {
        // TODO: elementForLocation allows us to give some sort of
        // location, but a proper location for the type access will
        // require upstream changes
        val type = useType(t)
        val id = tw.getFreshIdLabel<DbUnannotatedtypeaccess>()
        tw.writeExprs_unannotatedtypeaccess(id, type.javaResult.id, type.kotlinResult.id, parent, idx)
        val locId = tw.getLocation(elementForLocation)
        tw.writeHasLocation(id, locId)
        tw.writeCallableEnclosingExpr(id, callable)
    }

    fun extractTypeOperatorCall(e: IrTypeOperatorCall, callable: Label<out DbCallable>, parent: Label<out DbExprparent>, idx: Int) {
        when(e.operator) {
            IrTypeOperator.CAST -> {
                val id = tw.getFreshIdLabel<DbCastexpr>()
                val locId = tw.getLocation(e)
                val type = useType(e.type)
                tw.writeExprs_castexpr(id, type.javaResult.id, type.kotlinResult.id, parent, idx)
                tw.writeHasLocation(id, locId)
                tw.writeCallableEnclosingExpr(id, callable)
                extractTypeAccess(e.typeOperand, callable, id, 0, e)
                extractExpressionExpr(e.argument, callable, id, 1)
            }
            IrTypeOperator.IMPLICIT_CAST -> {
                // TODO: Make this distinguishable from an explicit cast?
                val id = tw.getFreshIdLabel<DbCastexpr>()
                val locId = tw.getLocation(e)
                val type = useType(e.type)
                tw.writeExprs_castexpr(id, type.javaResult.id, type.kotlinResult.id, parent, idx)
                tw.writeHasLocation(id, locId)
                tw.writeCallableEnclosingExpr(id, callable)
                extractTypeAccess(e.typeOperand, callable, id, 0, e)
                extractExpressionExpr(e.argument, callable, id, 1)
            }
            IrTypeOperator.IMPLICIT_NOTNULL -> {
                // TODO: Make this distinguishable from an explicit cast?
                val id = tw.getFreshIdLabel<DbCastexpr>()
                val locId = tw.getLocation(e)
                val type = useType(e.type)
                tw.writeExprs_castexpr(id, type.javaResult.id, type.kotlinResult.id, parent, idx)
                tw.writeHasLocation(id, locId)
                tw.writeCallableEnclosingExpr(id, callable)
                extractTypeAccess(e.typeOperand, callable, id, 0, e)
                extractExpressionExpr(e.argument, callable, id, 1)
            }
            IrTypeOperator.IMPLICIT_COERCION_TO_UNIT -> {
                // TODO: Make this distinguishable from an explicit cast?
                val id = tw.getFreshIdLabel<DbCastexpr>()
                val locId = tw.getLocation(e)
                val type = useType(e.type)
                tw.writeExprs_castexpr(id, type.javaResult.id, type.kotlinResult.id, parent, idx)
                tw.writeHasLocation(id, locId)
                tw.writeCallableEnclosingExpr(id, callable)
                extractTypeAccess(e.typeOperand, callable, id, 0, e)
                extractExpressionExpr(e.argument, callable, id, 1)
            }
            IrTypeOperator.INSTANCEOF -> {
                val id = tw.getFreshIdLabel<DbInstanceofexpr>()
                val locId = tw.getLocation(e)
                val type = useType(e.type)
                tw.writeExprs_instanceofexpr(id, type.javaResult.id, type.kotlinResult.id, parent, idx)
                tw.writeHasLocation(id, locId)
                tw.writeCallableEnclosingExpr(id, callable)
                extractExpressionExpr(e.argument, callable, id, 0)
                extractTypeAccess(e.typeOperand, callable, id, 1, e)
            }
            IrTypeOperator.NOT_INSTANCEOF -> {
                val id = tw.getFreshIdLabel<DbNotinstanceofexpr>()
                val locId = tw.getLocation(e)
                val type = useType(e.type)
                tw.writeExprs_notinstanceofexpr(id, type.javaResult.id, type.kotlinResult.id, parent, idx)
                tw.writeHasLocation(id, locId)
                tw.writeCallableEnclosingExpr(id, callable)
                extractExpressionExpr(e.argument, callable, id, 0)
                extractTypeAccess(e.typeOperand, callable, id, 1, e)
            }
            else -> {
                logger.warnElement(Severity.ErrorSevere, "Unrecognised IrTypeOperatorCall: " + e.render(), e)
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
}
