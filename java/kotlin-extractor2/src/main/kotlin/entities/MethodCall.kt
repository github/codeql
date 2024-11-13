package com.github.codeql

import com.github.codeql.KotlinFileExtractor.StmtExprParent
import org.jetbrains.kotlin.analysis.api.KaSession
import org.jetbrains.kotlin.analysis.api.resolution.symbol
import org.jetbrains.kotlin.analysis.api.symbols.KaFunctionSymbol
import org.jetbrains.kotlin.analysis.api.types.KaType
import org.jetbrains.kotlin.psi.KtCallExpression
import org.jetbrains.kotlin.psi.KtExpression
import org.jetbrains.kotlin.psi.KtQualifiedExpression
import org.jetbrains.kotlin.psi.KtSafeQualifiedExpression
import org.jetbrains.kotlin.utils.mapToIndex

context(KaSession)
fun KotlinFileExtractor.extractMethodCall(
    call: KtCallExpression,
    enclosingCallable: Label<out DbCallable>,
    stmtExprParent: StmtExprParent
) {
    val callTarget = call.resolveCallTarget()
    val target = callTarget?.symbol
    val argMapping = callTarget?.argumentMapping

    if (target == null || argMapping == null) TODO()

    val parameterIndexMap = target.valueParameters.mapToIndex()

    // TODO: we need to handle
    // - arguments passed to vararg parameters, in which case there can be multiple (idx, expr) pairs with the same idx.
    // - missing arguments due to default parameter values, in which case some indices are missing.
    val args = call.valueArguments
        .map { arg ->
            val expr = arg.argumentExpression
            val p = argMapping[expr]
            if (p == null) {
                TODO("This is unexpected, no parameter was found for the argument")
            }
            val idx = parameterIndexMap[p.symbol]
            if (idx == null) {
                TODO("This is unexpected, we couldn't find the parameter that the argument was mapped to")
            }
            Pair(idx, expr)
        }
        .sortedBy { p -> p.first }
        .map { p -> p.second }

    val callQualifiedParent = call.parent as? KtQualifiedExpression
    val qualifier =
        if (callQualifiedParent?.selectorExpression == call) callQualifiedParent.receiverExpression else null
    val extensionReceiver = if (target.isExtension) qualifier else null
    val dispatchReceiver = if (!target.isExtension) qualifier else null

    val exprParent = stmtExprParent.expr(call, enclosingCallable)

    val callId = extractRawMethodAccess(
        target,
        tw.getLocation(call),
        call.expressionType!!,
        enclosingCallable,
        exprParent.parent,
        exprParent.idx,
        exprParent.enclosingStmt,
        dispatchReceiver,
        extensionReceiver,
        args
    )

    if (call.parent is KtSafeQualifiedExpression) {
        tw.writeKtSafeAccess(callId)
    }
}

context(KaSession)
private fun KotlinFileExtractor.extractCallValueArguments(
    callId: Label<out DbExprparent>,
    valueArguments: List<KtExpression?>,
    enclosingStmt: Label<out DbStmt>,
    enclosingCallable: Label<out DbCallable>,
    idxOffset: Int,
    // extractVarargAsArray: Boolean = false // OLD KE1
) {
    var i = 0
    valueArguments.forEach { arg ->
        if (arg != null) {
            /* OLD KE1:
            if (arg is IrVararg && !extractVarargAsArray) {
                arg.elements.forEachIndexed { varargNo, vararg ->
                    extractVarargElement(
                        vararg,
                        enclosingCallable,
                        callId,
                        i + idxOffset + varargNo,
                        enclosingStmt
                    )
                }
                i += arg.elements.size
            } else {
            */
            extractExpressionExpr(
                arg,
                enclosingCallable,
                callId,
                (i++) + idxOffset,
                enclosingStmt
            )
            //}
        }
    }
}

context(KaSession)
private fun KotlinFileExtractor.getCalleeMethodId(callTarget: KaFunctionSymbol): Label<out DbCallable> {
    // TODO: is the below `useDeclarationParentOf` call correct?
    // TODO: what should happen if the parent label is null?
    return useFunction<DbCallable>(callTarget, useDeclarationParentOf(callTarget, false)!!)
}

context(KaSession)
fun KotlinFileExtractor.extractRawMethodAccess(
    callTarget: KaFunctionSymbol,
    locId: Label<DbLocation>,
    returnType: KaType,
    enclosingCallable: Label<out DbCallable>,
    callsiteParent: Label<out DbExprparent>,
    childIdx: Int,
    enclosingStmt: Label<out DbStmt>,
    dispatchReceiver: KtExpression?,
    extensionReceiver: KtExpression?,
    valueArguments: List<KtExpression?>,
    /* OLD KE1
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
    superQualifierSymbol: IrClassSymbol? = null
     */
): Label<DbMethodaccess> {
    /* OLD KE1:
    val callTarget = getCalleeRealOverrideTarget(syntacticCallTarget)
    val methodId = getCalleeMethodId(callTarget, drType, extractClassTypeArguments)
    if (methodId == null) {
        logger.warn("No method to bind call to for raw method access")
    }
     */

    val methodId = getCalleeMethodId(callTarget)

    val id =
        extractMethodAccessWithoutArgs(
            returnType,
            locId,
            enclosingCallable,
            callsiteParent,
            childIdx,
            enclosingStmt,
            methodId
        )

    /* OLD KE1:
    // type arguments at index -2, -3, ...
    extractTypeArguments(typeArguments, locId, id, enclosingCallable, enclosingStmt, -2, true)

    if (callTarget.isLocalFunction()) {
        extractNewExprForLocalFunction(
            getLocallyVisibleFunctionLabels(callTarget),
            id,
            locId,
            enclosingCallable,
            enclosingStmt
        )
    } else if (callTarget.shouldExtractAsStatic) {
        extractStaticTypeAccessQualifier(
            callTarget,
            id,
            locId,
            enclosingCallable,
            enclosingStmt
        )
    } else if (superQualifierSymbol != null) {
        extractSuperAccess(
            superQualifierSymbol.typeWith(),
            enclosingCallable,
            id,
            -1,
            enclosingStmt,
            locId
        )
    } else if (extractDispatchReceiver != null) {
        extractDispatchReceiver(id)
    }

    val idxOffset = if (extractExtensionReceiver != null) 1 else 0

    val isBigArityFunctionInvoke =
        drType is IrSimpleType &&
                isFunctionInvoke(callTarget, drType) &&
                drType.arguments.size > BuiltInFunctionArity.BIG_ARITY

    val argParent =
        if (isBigArityFunctionInvoke) {
            extractArrayCreationWithInitializer(
                id,
                nValueArguments + idxOffset,
                locId,
                enclosingCallable,
                enclosingStmt
            )
        } else {
            id
        }

    if (extractExtensionReceiver != null) {
        extractExtensionReceiver(argParent)
    }

    extractValueArguments(argParent, idxOffset)

    */

    if (dispatchReceiver != null) {
        extractExpressionExpr(dispatchReceiver, enclosingCallable, id, -1, enclosingStmt)
    }
    if (extensionReceiver != null) {
        extractExpressionExpr(extensionReceiver, enclosingCallable, id, 0, enclosingStmt)
    }
    val idxOffset = if (extensionReceiver != null) 1 else 0
    extractCallValueArguments(id, valueArguments, enclosingStmt, enclosingCallable, idxOffset)

    return id
}

context(KaSession)
private fun KotlinFileExtractor.extractMethodAccessWithoutArgs(
    returnType: KaType,
    locId: Label<DbLocation>,
    enclosingCallable: Label<out DbCallable>,
    callsiteParent: Label<out DbExprparent>,
    childIdx: Int,
    enclosingStmt: Label<out DbStmt>,
    methodLabel: Label<out DbCallable>?
) =
    tw.getFreshIdLabel<DbMethodaccess>().also { id ->
        val type = useType(returnType)

        tw.writeExprs_methodaccess(id, type.javaResult.id, callsiteParent, childIdx)
        tw.writeExprsKotlinType(id, type.kotlinResult.id)
        extractExprContext(id, locId, enclosingCallable, enclosingStmt)

        // The caller should have warned about this before, so we don't repeat the warning here.
        if (methodLabel != null) tw.writeCallableBinding(id, methodLabel)
    }

/*
OLD: KE1

private fun getDeclaringTypeArguments(
            callTarget: IrFunction,
            receiverType: IrSimpleType
        ): List<IrTypeArgument> {
            val declaringType = callTarget.parentAsClass
            val receiverClass = receiverType.classifier.owner as? IrClass ?: return listOf()
            val ancestorTypes = ArrayList<IrSimpleType>()

            // KFunctionX doesn't implement FunctionX on versions before 1.7.0:
            if (
                (callTarget.name.asString() == "invoke") &&
                    (receiverClass.fqNameWhenAvailable
                        ?.asString()
                        ?.startsWith("kotlin.reflect.KFunction") == true) &&
                    (callTarget.parentClassOrNull
                        ?.fqNameWhenAvailable
                        ?.asString()
                        ?.startsWith("kotlin.Function") == true)
            ) {
                return receiverType.arguments
            }

            // Populate ancestorTypes with the path from receiverType's class to its ancestor,
            // callTarget's declaring type.
            fun walkFrom(c: IrClass): Boolean {
                if (declaringType == c) return true
                else {
                    c.superTypes.forEach {
                        val ancestorClass =
                            (it as? IrSimpleType)?.classifier?.owner as? IrClass ?: return false
                        ancestorTypes.add(it)
                        if (walkFrom(ancestorClass)) return true else ancestorTypes.pop()
                    }
                    return false
                }
            }

            // If a path was found, repeatedly substitute types to get the corresponding specialisation
            // of that ancestor.
            if (!walkFrom(receiverClass)) {
                logger.errorElement(
                    "Failed to find a class declaring ${callTarget.name} starting at ${receiverClass.name}",
                    callTarget
                )
                return listOf()
            } else {
                var subbedType: IrSimpleType = receiverType
                ancestorTypes.forEach {
                    val thisClass = subbedType.classifier.owner
                    if (thisClass !is IrClass) {
                        logger.errorElement(
                            "Found ancestor with unexpected type ${thisClass.javaClass}",
                            callTarget
                        )
                        return listOf()
                    }
                    val itSubbed =
                        it.substituteTypeArguments(thisClass.typeParameters, subbedType.arguments)
                    if (itSubbed !is IrSimpleType) {
                        logger.errorElement(
                            "Substituted type has unexpected type ${itSubbed.javaClass}",
                            callTarget
                        )
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
            enclosingStmt: Label<out DbStmt>
        ) {

            val idNewexpr =
                extractNewExpr(
                    ids.constructor,
                    ids.type,
                    locId,
                    parent,
                    -1,
                    enclosingCallable,
                    enclosingStmt
                )
            extractTypeAccessRecursive(
                pluginContext.irBuiltIns.anyType,
                locId,
                idNewexpr,
                -3,
                enclosingCallable,
                enclosingStmt
            )
        }

        private fun extractMethodAccessWithoutArgs(
            returnType: IrType,
            locId: Label<DbLocation>,
            enclosingCallable: Label<out DbCallable>,
            callsiteParent: Label<out DbExprparent>,
            childIdx: Int,
            enclosingStmt: Label<out DbStmt>,
            methodLabel: Label<out DbCallable>?
        ) =
            tw.getFreshIdLabel<DbMethodaccess>().also { id ->
                val type = useType(returnType)

                tw.writeExprs_methodaccess(id, type.javaResult.id, callsiteParent, childIdx)
                tw.writeExprsKotlinType(id, type.kotlinResult.id)
                extractExprContext(id, locId, enclosingCallable, enclosingStmt)

                // The caller should have warned about this before, so we don't repeat the warning here.
                if (methodLabel != null) tw.writeCallableBinding(id, methodLabel)
            }

        private val defaultConstructorMarkerClass by lazy {
            referenceExternalClass("kotlin.jvm.internal.DefaultConstructorMarker")
        }

        private val defaultConstructorMarkerType by lazy { defaultConstructorMarkerClass?.typeWith() }

        private fun getDefaultsMethodLastArgType(f: IrFunction) =
            (if (f is IrConstructor) defaultConstructorMarkerType else null)
                ?: pluginContext.irBuiltIns.anyType

        private fun getDefaultsMethodArgTypes(f: IrFunction) =
            // The $default method has type ([dispatchReceiver], [extensionReceiver], paramTypes...,
            // int, Object)
            // All parameter types are erased. The trailing int is a mask indicating which parameter
            // values are real
            // and which should be replaced by defaults. The final Object parameter is apparently always
            // null.
            (listOfNotNull(if (f.shouldExtractAsStatic) null else f.dispatchReceiverParameter?.type) +
                    listOfNotNull(f.extensionReceiverParameter?.type) +
                    f.valueParameters.map { it.type } +
                    listOf(pluginContext.irBuiltIns.intType, getDefaultsMethodLastArgType(f)))
                .map { erase(it) }

        private fun getDefaultsMethodName(f: IrFunction) =
            if (f is IrConstructor) {
                f.returnType.let {
                    when {
                        it.isAnonymous -> ""
                        else -> it.classFqName?.shortName()?.asString() ?: f.name.asString()
                    }
                }
            } else {
                getFunctionShortName(f).nameInDB + "\$default"
            }

        private fun getDefaultsMethodLabel(f: IrFunction): Label<out DbCallable>? {
            val classTypeArgsIncludingOuterClasses = null
            val parentId = useDeclarationParentOf(f, false, classTypeArgsIncludingOuterClasses, true)
            if (parentId == null) {
                logger.errorElement("Couldn't get parent ID for defaults method", f)
                return null
            }
            return getDefaultsMethodLabel(f, parentId)
        }

        private fun getDefaultsMethodLabel(
            f: IrFunction,
            parentId: Label<out DbElement>
        ): Label<out DbCallable> {
            val defaultsMethodName = if (f is IrConstructor) "<init>" else getDefaultsMethodName(f)
            val argTypes = getDefaultsMethodArgTypes(f)

            val defaultMethodLabelStr =
                getFunctionLabel(
                    f.parent,
                    parentId,
                    defaultsMethodName,
                    argTypes,
                    erase(f.returnType),
                    extensionParamType = null, // if there's any, that's included already in argTypes
                    functionTypeParameters = listOf(),
                    classTypeArgsIncludingOuterClasses = null,
                    overridesCollectionsMethod = false,
                    javaSignature = null,
                    addParameterWildcardsByDefault = false
                )

            return tw.getLabelFor(defaultMethodLabelStr)
        }

        private fun extractsDefaultsCall(
            syntacticCallTarget: IrFunction,
            locId: Label<DbLocation>,
            resultType: IrType,
            enclosingCallable: Label<out DbCallable>,
            callsiteParent: Label<out DbExprparent>,
            childIdx: Int,
            enclosingStmt: Label<out DbStmt>,
            valueArguments: List<IrExpression?>,
            dispatchReceiver: IrExpression?,
            extensionReceiver: IrExpression?
        ) {
            val callTarget = syntacticCallTarget.target.realOverrideTarget
            if (isExternalDeclaration(callTarget)) {
                // Ensure the real target gets extracted, as we might not every directly touch it thanks
                // to this call being redirected to a $default method.
                useFunction<DbCallable>(callTarget)
            }

            // Default parameter values are inherited by overrides; in this case the call should
            // dispatch against the $default method belonging to the class
            // that specified the default values, which will in turn dynamically dispatch back to the
            // relevant override.
            val overriddenCallTarget =
                (callTarget as? IrSimpleFunction)?.allOverriddenIncludingSelf()?.firstOrNull {
                    it.overriddenSymbols.isEmpty() &&
                        it.valueParameters.any { p -> p.defaultValue != null }
                } ?: callTarget
            if (isExternalDeclaration(overriddenCallTarget)) {
                // Likewise, ensure the overridden target gets extracted.
                useFunction<DbCallable>(overriddenCallTarget)
            }

            val defaultMethodLabel = getDefaultsMethodLabel(overriddenCallTarget)
            val id =
                extractMethodAccessWithoutArgs(
                    resultType,
                    locId,
                    enclosingCallable,
                    callsiteParent,
                    childIdx,
                    enclosingStmt,
                    defaultMethodLabel
                )

            if (overriddenCallTarget.isLocalFunction()) {
                extractTypeAccess(
                    getLocallyVisibleFunctionLabels(overriddenCallTarget).type,
                    locId,
                    id,
                    -1,
                    enclosingCallable,
                    enclosingStmt
                )
            } else {
                extractStaticTypeAccessQualifierUnchecked(
                    overriddenCallTarget,
                    id,
                    locId,
                    enclosingCallable,
                    enclosingStmt
                )
            }

            extractDefaultsCallArguments(
                id,
                overriddenCallTarget,
                enclosingCallable,
                enclosingStmt,
                valueArguments,
                dispatchReceiver,
                extensionReceiver
            )
        }

        private fun extractDefaultsCallArguments(
            id: Label<out DbExprparent>,
            callTarget: IrFunction,
            enclosingCallable: Label<out DbCallable>,
            enclosingStmt: Label<out DbStmt>,
            valueArguments: List<IrExpression?>,
            dispatchReceiver: IrExpression?,
            extensionReceiver: IrExpression?
        ) {
            var nextIdx = 0
            if (dispatchReceiver != null && !callTarget.shouldExtractAsStatic) {
                extractExpressionExpr(dispatchReceiver, enclosingCallable, id, nextIdx++, enclosingStmt)
            }

            if (extensionReceiver != null) {
                extractExpressionExpr(
                    extensionReceiver,
                    enclosingCallable,
                    id,
                    nextIdx++,
                    enclosingStmt
                )
            }

            val valueArgsWithDummies =
                valueArguments.zip(callTarget.valueParameters).map { (expr, param) ->
                    expr ?: IrConstImpl.defaultValueForType(0, 0, param.type)
                }

            var realParamsMask = 0
            valueArguments.forEachIndexed { index, arg ->
                if (arg != null) realParamsMask = realParamsMask or (1 shl index)
            }

            val extraArgs =
                listOf(
                    IrConstImpl.int(0, 0, pluginContext.irBuiltIns.intType, realParamsMask),
                    IrConstImpl.defaultValueForType(0, 0, getDefaultsMethodLastArgType(callTarget))
                )

            extractCallValueArguments(
                id,
                valueArgsWithDummies + extraArgs,
                enclosingStmt,
                enclosingCallable,
                nextIdx,
                extractVarargAsArray = true
            )
        }

        private fun getFunctionInvokeMethod(typeArgs: List<IrTypeArgument>): IrFunction? {
            // For `kotlin.FunctionX` and `kotlin.reflect.KFunctionX` interfaces, we're making sure that
            // we
            // extract the call to the `invoke` method that does exist,
            // `kotlin.jvm.functions.FunctionX::invoke`.
            val functionalInterface = getFunctionalInterfaceTypeWithTypeArgs(typeArgs)
            if (functionalInterface == null) {
                logger.warn("Cannot find functional interface type for raw method access")
                return null
            }
            val functionalInterfaceClass = functionalInterface.classOrNull
            if (functionalInterfaceClass == null) {
                logger.warn("Cannot find functional interface class for raw method access")
                return null
            }
            val interfaceType = functionalInterfaceClass.owner
            val substituted = getJavaEquivalentClass(interfaceType) ?: interfaceType
            val function = findFunction(substituted, OperatorNameConventions.INVOKE.asString())
            if (function == null) {
                logger.warn("Cannot find invoke function for raw method access")
                return null
            }
            return function
        }

        private fun isFunctionInvoke(callTarget: IrFunction, drType: IrSimpleType) =
            (drType.isFunctionOrKFunction() || drType.isSuspendFunctionOrKFunction()) &&
                callTarget.name.asString() == OperatorNameConventions.INVOKE.asString()

        private fun getCalleeMethodId(
            callTarget: IrFunction,
            drType: IrType?,
            allowInstantiatedGenericMethod: Boolean
        ): Label<out DbCallable>? {
            if (callTarget.isLocalFunction())
                return getLocallyVisibleFunctionLabels(callTarget).function

            if (
                allowInstantiatedGenericMethod &&
                    drType is IrSimpleType &&
                    !isUnspecialised(drType, logger)
            ) {
                val calleeIsInvoke = isFunctionInvoke(callTarget, drType)

                val extractionMethod =
                    if (calleeIsInvoke) getFunctionInvokeMethod(drType.arguments) else callTarget

                return extractionMethod?.let {
                    val typeArgs =
                        if (calleeIsInvoke && drType.arguments.size > BuiltInFunctionArity.BIG_ARITY) {
                            // Big arity `invoke` methods have a special implementation on JVM, they are
                            // transformed to a call to
                            // `kotlin.jvm.functions.FunctionN<out R>::invoke(vararg args: Any?)`, so we
                            // only need to pass the type
                            // argument for the return type. Additionally, the arguments are extracted
                            // inside an array literal below.
                            listOf(drType.arguments.last())
                        } else {
                            getDeclaringTypeArguments(callTarget, drType)
                        }
                    useFunction<DbCallable>(extractionMethod, typeArgs)
                }
            } else {
                return useFunction<DbCallable>(callTarget)
            }
        }

        private fun getCalleeRealOverrideTarget(f: IrFunction): IrFunction {
            val target = f.target.realOverrideTarget
            return if (overridesCollectionsMethodWithAlteredParameterTypes(f))
            // Cope with the case where an inherited callee can be rewritten with substituted parameter
            // types
            // if the child class uses it to implement a collections interface
            // (for example, `class A { boolean contains(Object o) { ... } }; class B<T> extends A
            // implements Set<T> { ... }`
            // leads to generating a function `A.contains(B::T)`, with `initialSignatureFunction`
            // pointing to `A.contains(Object)`.
            (target as? IrLazyFunction)?.initialSignatureFunction ?: target
            else target
        }

        private fun callUsesDefaultArguments(
            callTarget: IrFunction,
            valueArguments: List<IrExpression?>
        ): Boolean {
            val varargParam = callTarget.valueParameters.withIndex().find { it.value.isVararg }
            // If the vararg param is the only one not specified, and it has no default value, then we
            // don't need to call a $default method,
            // as omitting it already implies passing an empty vararg array.
            val nullAllowedIdx =
                if (varargParam != null && varargParam.value.defaultValue == null) varargParam.index
                else -1
            return valueArguments.withIndex().any { (index, it) ->
                it == null && index != nullAllowedIdx
            }
        }

        fun extractRawMethodAccess(
            syntacticCallTarget: IrFunction,
            locElement: IrElement,
            resultType: IrType,
            enclosingCallable: Label<out DbCallable>,
            callsiteParent: Label<out DbExprparent>,
            childIdx: Int,
            enclosingStmt: Label<out DbStmt>,
            valueArguments: List<IrExpression?>,
            dispatchReceiver: IrExpression?,
            extensionReceiver: IrExpression?,
            typeArguments: List<IrType> = listOf(),
            extractClassTypeArguments: Boolean = false,
            superQualifierSymbol: IrClassSymbol? = null
        ) {

            val locId = tw.getLocation(locElement)

            if (callUsesDefaultArguments(syntacticCallTarget, valueArguments)) {
                extractsDefaultsCall(
                    syntacticCallTarget,
                    locId,
                    resultType,
                    enclosingCallable,
                    callsiteParent,
                    childIdx,
                    enclosingStmt,
                    valueArguments,
                    dispatchReceiver,
                    extensionReceiver
                )
            } else {
                extractRawMethodAccess(
                    syntacticCallTarget,
                    locId,
                    resultType,
                    enclosingCallable,
                    callsiteParent,
                    childIdx,
                    enclosingStmt,
                    valueArguments.size,
                    { argParent, idxOffset ->
                        extractCallValueArguments(
                            argParent,
                            valueArguments,
                            enclosingStmt,
                            enclosingCallable,
                            idxOffset
                        )
                    },
                    dispatchReceiver?.type,
                    dispatchReceiver?.let {
                        { callId ->
                            extractExpressionExpr(
                                dispatchReceiver,
                                enclosingCallable,
                                callId,
                                -1,
                                enclosingStmt
                            )
                        }
                    },
                    extensionReceiver?.let {
                        { argParent ->
                            extractExpressionExpr(
                                extensionReceiver,
                                enclosingCallable,
                                argParent,
                                0,
                                enclosingStmt
                            )
                        }
                    },
                    typeArguments,
                    extractClassTypeArguments,
                    superQualifierSymbol
                )
            }
        }

        private fun extractStaticTypeAccessQualifierUnchecked(
            target: IrDeclaration,
            parentExpr: Label<out DbExprparent>,
            locId: Label<DbLocation>,
            enclosingCallable: Label<out DbCallable>?,
            enclosingStmt: Label<out DbStmt>?
        ) {
            val parent = target.parent
            if (parent is IrExternalPackageFragment) {
                // This is in a file class.
                val fqName = getFileClassFqName(target)
                if (fqName == null) {
                    logger.error(
                        "Can't get FqName for static type access qualifier in external package fragment ${target.javaClass}"
                    )
                } else {
                    extractTypeAccess(
                        useFileClassType(fqName),
                        locId,
                        parentExpr,
                        -1,
                        enclosingCallable,
                        enclosingStmt
                    )
                }
            } else if (parent is IrClass) {
                extractTypeAccessRecursive(
                    parent.toRawType(),
                    locId,
                    parentExpr,
                    -1,
                    enclosingCallable,
                    enclosingStmt
                )
            } else if (parent is IrFile) {
                extractTypeAccess(
                    useFileClassType(parent),
                    locId,
                    parentExpr,
                    -1,
                    enclosingCallable,
                    enclosingStmt
                )
            } else {
                logger.warnElement(
                    "Unexpected static type access qualifier ${parent.javaClass}",
                    parent
                )
            }
        }

        private fun extractStaticTypeAccessQualifier(
            target: IrDeclaration,
            parentExpr: Label<out DbExprparent>,
            locId: Label<DbLocation>,
            enclosingCallable: Label<out DbCallable>?,
            enclosingStmt: Label<out DbStmt>?
        ) {
            if (target.shouldExtractAsStatic) {
                extractStaticTypeAccessQualifierUnchecked(
                    target,
                    parentExpr,
                    locId,
                    enclosingCallable,
                    enclosingStmt
                )
            }
        }

        private fun isStaticAnnotatedNonCompanionMember(f: IrSimpleFunction) =
            f.parentClassOrNull?.isNonCompanionObject == true &&
                (f.hasAnnotation(jvmStaticFqName) ||
                    f.correspondingPropertySymbol?.owner?.hasAnnotation(jvmStaticFqName) == true)

        private val IrDeclaration.shouldExtractAsStatic: Boolean
            get() =
                this is IrSimpleFunction &&
                    (isStaticFunction(this) || isStaticAnnotatedNonCompanionMember(this)) ||
                    this is IrField && this.isStatic ||
                    this is IrEnumEntry

        private fun extractCallValueArguments(
            callId: Label<out DbExprparent>,
            call: IrFunctionAccessExpression,
            enclosingStmt: Label<out DbStmt>,
            enclosingCallable: Label<out DbCallable>,
            idxOffset: Int
        ) =
            extractCallValueArguments(
                callId,
                (0 until call.valueArgumentsCount).map { call.getValueArgument(it) },
                enclosingStmt,
                enclosingCallable,
                idxOffset
            )



 */