package com.github.codeql

import com.github.codeql.KotlinFileExtractor.StmtExprParent
import org.jetbrains.kotlin.KtNodeTypes
import org.jetbrains.kotlin.analysis.api.KaSession
import org.jetbrains.kotlin.analysis.api.resolution.KaSimpleFunctionCall
import org.jetbrains.kotlin.analysis.api.resolution.KaSuccessCallInfo
import org.jetbrains.kotlin.analysis.api.resolution.calls
import org.jetbrains.kotlin.analysis.api.resolution.symbol
import org.jetbrains.kotlin.analysis.api.symbols.KaClassSymbol
import org.jetbrains.kotlin.analysis.api.symbols.KaFunctionSymbol
import org.jetbrains.kotlin.analysis.api.symbols.KaSymbol
import org.jetbrains.kotlin.analysis.api.symbols.pointers.symbolPointer
import org.jetbrains.kotlin.analysis.api.types.KaType
import org.jetbrains.kotlin.analysis.api.types.KaTypeNullability
import org.jetbrains.kotlin.analysis.api.types.KtType
import org.jetbrains.kotlin.analysis.api.types.symbol
import org.jetbrains.kotlin.fir.resolve.transformers.resolveToPackageOrClass
import org.jetbrains.kotlin.idea.references.KtReference
import org.jetbrains.kotlin.lexer.KtTokens
import org.jetbrains.kotlin.name.CallableId
import org.jetbrains.kotlin.name.ClassId
import org.jetbrains.kotlin.name.FqName
import org.jetbrains.kotlin.name.Name
import org.jetbrains.kotlin.parsing.parseNumericLiteral
import org.jetbrains.kotlin.psi.*
import org.jetbrains.kotlin.psi.psiUtil.getQualifiedExpressionForReceiver
import org.jetbrains.kotlin.resolve.calls.util.getType

context(KaSession)
private fun KotlinFileExtractor.extractExpressionBody(e: KtExpression, callable: Label<out DbCallable>) {
    with("expression body", e) {
        val locId = tw.getLocation(e)
        extractExpressionBody(callable, locId).also { returnId ->
            extractExpression(e, callable, ExprParent(returnId, 0, returnId))
        }
    }
}

// TODO: Inline this? It used to be public
private fun KotlinFileExtractor.extractExpressionBody(
    callable: Label<out DbCallable>,
    locId: Label<DbLocation>
): Label<out DbStmt> {
    val blockId = extractBlockBody(callable, locId)
    return tw.getFreshIdLabel<DbReturnstmt>().also { returnId ->
        tw.writeStmts_returnstmt(returnId, blockId, 0, callable)
        tw.writeHasLocation(returnId, locId)
    }
}

context(KaSession)
fun KotlinFileExtractor.extractBody(b: KtExpression, callable: Label<out DbCallable>) {
    with("body", b) {
        when (b) {
            is KtBlockExpression -> extractBlockBody(b, callable)
            /*
            OLD: KE1
                            is IrSyntheticBody -> extractSyntheticBody(b, callable)
            */
            else -> extractExpressionBody(b, callable)
        }
    }
}

// TODO: Can this be inlined?
private fun KotlinFileExtractor.extractBlockBody(callable: Label<out DbCallable>, locId: Label<DbLocation>) =
    tw.getFreshIdLabel<DbBlock>().also {
        tw.writeStmts_block(it, callable, 0, callable)
        tw.writeHasLocation(it, locId)
    }

context(KaSession)
private fun KotlinFileExtractor.extractBlockBody(b: KtBlockExpression, callable: Label<out DbCallable>) {
    with("block body", b) {
        extractBlockBody(callable, tw.getLocation(b)).also {
            for ((sIdx, stmt) in b.statements.withIndex()) {
                extractExpression(stmt, callable, StmtParent(it, sIdx))
            }
        }
    }
}

/*
OLD: KE1
    private fun extractSyntheticBody(b: IrSyntheticBody, callable: Label<out DbCallable>) {
        with("synthetic body", b) {
            val kind = b.kind
            when {
                kind == IrSyntheticBodyKind.ENUM_VALUES -> tw.writeKtSyntheticBody(callable, 1)
                kind == IrSyntheticBodyKind.ENUM_VALUEOF -> tw.writeKtSyntheticBody(callable, 2)
                kind == kind_ENUM_ENTRIES -> tw.writeKtSyntheticBody(callable, 3)
                else -> {
                    logger.errorElement("Unhandled synthetic body kind " + kind, b)
                }
            }
        }
    }
*/

/*private*/ fun KotlinFileExtractor.extractExpressionStmt(
    locId: Label<DbLocation>,
    parent: Label<out DbStmtparent>,
    idx: Int,
    callable: Label<out DbCallable>
) =
    tw.getFreshIdLabel<DbExprstmt>().also {
        tw.writeStmts_exprstmt(it, parent, idx, callable)
        tw.writeHasLocation(it, locId)
    }

context(KaSession)
private fun KotlinFileExtractor.extractExpressionStmt(
    e: KtExpression,
    callable: Label<out DbCallable>,
    parent: Label<out DbStmtparent>,
    idx: Int
) {
    extractExpression(e, callable, StmtParent(parent, idx))
}

context(KaSession)
fun KotlinFileExtractor.extractExpressionExpr(
    e: KtExpression,
    callable: Label<out DbCallable>,
    parent: Label<out DbExprparent>,
    idx: Int,
    enclosingStmt: Label<out DbStmt>
) {
    extractExpression(e, callable, ExprParent(parent, idx, enclosingStmt))
}

private fun KotlinFileExtractor.extractExprContext(
    id: Label<out DbExpr>,
    locId: Label<DbLocation>,
    callable: Label<out DbCallable>?,
    enclosingStmt: Label<out DbStmt>?
) {
    tw.writeHasLocation(id, locId)
    callable?.let { tw.writeCallableEnclosingExpr(id, it) }
    enclosingStmt?.let { tw.writeStatementEnclosingExpr(id, it) }
}

/*
OLD: KE1
    private fun extractEqualsExpression(
        locId: Label<DbLocation>,
        parent: Label<out DbExprparent>,
        idx: Int,
        callable: Label<out DbCallable>,
        enclosingStmt: Label<out DbStmt>
    ) =
        tw.getFreshIdLabel<DbEqexpr>().also {
            val type = useType(pluginContext.irBuiltIns.booleanType)
            tw.writeExprs_eqexpr(it, type.javaResult.id, parent, idx)
            tw.writeExprsKotlinType(it, type.kotlinResult.id)
            extractExprContext(it, locId, callable, enclosingStmt)
        }

    private fun extractAndbitExpression(
        type: IrType,
        locId: Label<DbLocation>,
        parent: Label<out DbExprparent>,
        idx: Int,
        callable: Label<out DbCallable>,
        enclosingStmt: Label<out DbStmt>
    ) =
        tw.getFreshIdLabel<DbAndbitexpr>().also {
            val typeResults = useType(type)
            tw.writeExprs_andbitexpr(it, typeResults.javaResult.id, parent, idx)
            tw.writeExprsKotlinType(it, typeResults.kotlinResult.id)
            extractExprContext(it, locId, callable, enclosingStmt)
        }
*/

private fun KotlinFileExtractor.extractConstantInteger(
    text: String,
    t: KaType,
    v: Number,
    locId: Label<DbLocation>,
    parent: Label<out DbExprparent>,
    idx: Int,
    callable: Label<out DbCallable>?,
    enclosingStmt: Label<out DbStmt>?,
    /*
    OLD: KE1
            overrideId: Label<out DbExpr>? = null
    */
) =
    // OLD: KE1: Was: exprIdOrFresh<DbIntegerliteral>(overrideId).also {
    tw.getFreshIdLabel<DbIntegerliteral>().also {
        val type = useType(t)
        tw.writeExprs_integerliteral(it, type.javaResult.id, parent, idx)
        tw.writeExprsKotlinType(it, type.kotlinResult.id)
        tw.writeNamestrings(text, v.toString(), it)
        extractExprContext(it, locId, callable, enclosingStmt)
    }

/*
OLD: KE1
    private fun extractNull(
        t: IrType,
        locId: Label<DbLocation>,
        parent: Label<out DbExprparent>,
        idx: Int,
        callable: Label<out DbCallable>?,
        enclosingStmt: Label<out DbStmt>?,
        overrideId: Label<out DbExpr>? = null
    ) =
        exprIdOrFresh<DbNullliteral>(overrideId).also {
            val type = useType(t)
            tw.writeExprs_nullliteral(it, type.javaResult.id, parent, idx)
            tw.writeExprsKotlinType(it, type.kotlinResult.id)
            extractExprContext(it, locId, callable, enclosingStmt)
        }

    private fun extractAssignExpr(
        type: IrType,
        locId: Label<DbLocation>,
        parent: Label<out DbExprparent>,
        idx: Int,
        callable: Label<out DbCallable>,
        enclosingStmt: Label<out DbStmt>
    ) =
        tw.getFreshIdLabel<DbAssignexpr>().also {
            val typeResults = useType(type)
            tw.writeExprs_assignexpr(it, typeResults.javaResult.id, parent, idx)
            tw.writeExprsKotlinType(it, typeResults.kotlinResult.id)
            extractExprContext(it, locId, callable, enclosingStmt)
        }
*/

private fun KaFunctionSymbol.hasMatchingNames(
    name: CallableId,
    extensionReceiverClassName: ClassId? = null,
    nullability: KaTypeNullability? = null,
): Boolean {

    if (this.callableId != name)
        return false

    val receiverType = this.receiverParameter?.type
    if (receiverType != null && extensionReceiverClassName != null) {
        return receiverType.nullability == nullability &&
                receiverType.symbol?.classId == extensionReceiverClassName
    }

    return receiverType == null &&
            extensionReceiverClassName == null &&
            nullability == null
}

private fun KaFunctionSymbol.hasName(
    packageName: String,
    className: String?,
    functionName: String
): Boolean {

    return this.hasMatchingNames(
        CallableId(
            FqName(packageName),
            if (className == null) null else FqName(className),
            Name.identifier(functionName)
        )
    )
}

private fun KaFunctionSymbol.isNumericWithName(functionName: String): Boolean {
    return this.hasName("kotlin", "Int", functionName) ||
            this.hasName("kotlin", "Byte", functionName) ||
            this.hasName("kotlin", "Short", functionName) ||
            this.hasName("kotlin", "Long", functionName) ||
            this.hasName("kotlin", "Float", functionName) ||
            this.hasName("kotlin", "Double", functionName)
}

/**
 * Extracts a binary expression as either a binary expression or a function call.
 *
 * Overloaded operators are extracted as function calls.
 *
 * ```
 * data class Counter(val dayIndex: Int) {
 *     operator fun plus(increment: Int): Counter {
 *         return Counter(dayIndex + increment)
 *     }
 * }
 * ```
 *
 * `Counter(1) + 3` is extracted as `Counter(1).plus(3)`.
 *
 */
context(KaSession)
private fun KotlinFileExtractor.extractBinaryExpression(
    expression: KtBinaryExpression,
    callable: Label<out DbCallable>,
    parent: StmtExprParent
) {
    val op = expression.operationToken
    val target = ((expression.resolveToCall() as? KaSuccessCallInfo)?.call as? KaSimpleFunctionCall)?.symbol

    when (op) {
        KtTokens.PLUS -> {
            if (target == null) {
                TODO()
            }

            if (target.isNumericWithName("plus") ||
                target.hasName("kotlin", "String", "plus") ||
                target.hasMatchingNames(
                    CallableId(FqName("kotlin"), null, Name.identifier("plus")),
                    ClassId(FqName("kotlin"), Name.identifier("String")),
                    nullability = KaTypeNullability.NULLABLE,
                )
            ) {
                val id = tw.getFreshIdLabel<DbAddexpr>()
                val type = useType(expression.expressionType)
                val exprParent = parent.expr(expression, callable)
                tw.writeExprs_addexpr(id, type.javaResult.id, exprParent.parent, exprParent.idx)
                tw.writeExprsKotlinType(id, type.kotlinResult.id)

                extractExprContext(id, tw.getLocation(expression), callable, exprParent.enclosingStmt)
                extractExpressionExpr(expression.left!!, callable, id, 0, exprParent.enclosingStmt)
                extractExpressionExpr(expression.right!!, callable, id, 1, exprParent.enclosingStmt)
            } else {
                TODO("Extract as method call")
            }
        }

        else -> TODO()
    }

}

context(KaSession)
private fun KotlinFileExtractor.extractExpression(
    e: KtExpression,
    callable: Label<out DbCallable>,
    parent: StmtExprParent
) {
    with("expression", e) {
        when (e) {
            is KtLabeledExpression -> {
                // TODO: we could handle this here, or in each child that might have a label
                // We're handling it in the children with the below
                extractExpression(e.baseExpression!!, callable, parent)
            }

            is KtBinaryExpression -> {
                extractBinaryExpression(e, callable, parent)
            }

            is KtIsExpression -> {

                val locId = tw.getLocation(e)
                val type = useType(e.expressionType!!)
                val exprParent = parent.expr(e, callable)

                val id: Label<out DbExpr>
                if (e.isNegated) {
                    id = tw.getFreshIdLabel<DbNotinstanceofexpr>()
                    tw.writeExprs_notinstanceofexpr(id, type.javaResult.id, exprParent.parent, exprParent.idx)
                } else {
                    id = tw.getFreshIdLabel<DbInstanceofexpr>()
                    tw.writeExprs_instanceofexpr(id, type.javaResult.id, exprParent.parent, exprParent.idx)
                }

                tw.writeExprsKotlinType(id, type.kotlinResult.id)
                extractExprContext(id, locId, callable, exprParent.enclosingStmt)
                extractExpressionExpr(e.leftHandSide, callable, id, 0, exprParent.enclosingStmt)

                // TODO: KE1
                //extractTypeAccessRecursive(e.typeReference, locId, id, 1, callable, exprParent.enclosingStmt)
            }

            is KtBinaryExpressionWithTypeRHS -> {
                val locId = tw.getLocation(e)
                val type = useType(e.expressionType!!)
                val exprParent = parent.expr(e, callable)

                val id: Label<out DbExpr>
                val op = (e.operationReference as? KtOperationReferenceExpression)?.operationSignTokenType

                when (op) {
                    KtTokens.AS_KEYWORD -> {
                        id = tw.getFreshIdLabel<DbCastexpr>()
                        tw.writeExprs_castexpr(id, type.javaResult.id, exprParent.parent, exprParent.idx)
                    }

                    KtTokens.AS_SAFE -> {
                        id = tw.getFreshIdLabel<DbSafecastexpr>()
                        tw.writeExprs_safecastexpr(id, type.javaResult.id, exprParent.parent, exprParent.idx)
                    }

                    else -> {
                        TODO()
                    }
                }

                tw.writeExprsKotlinType(id, type.kotlinResult.id)
                extractExprContext(id, locId, callable, exprParent.enclosingStmt)
                // TODO: KE1
                //extractTypeAccessRecursive(e.typeOperand, locId, id, 0, callable, exprParent.enclosingStmt)
                extractExpressionExpr(e.left, callable, id, 1, exprParent.enclosingStmt)
            }

            is KtProperty -> {
                val stmtParent = parent.stmt(e, callable)
                extractVariable(e, callable, stmtParent.parent, stmtParent.idx)
            }

            /*
            OLD: KE1
                            is IrDelegatingConstructorCall -> {
                                val stmtParent = parent.stmt(e, callable)

                                val irCallable = declarationStack.peek().first

                                val delegatingClass = e.symbol.owner.parent
                                val currentClass = irCallable.parent

                                if (delegatingClass !is IrClass) {
                                    logger.warnElement(
                                        "Delegating class isn't a class: " + delegatingClass.javaClass,
                                        e
                                    )
                                }
                                if (currentClass !is IrClass) {
                                    logger.warnElement(
                                        "Current class isn't a class: " + currentClass.javaClass,
                                        e
                                    )
                                }

                                val id: Label<out DbStmt>
                                if (delegatingClass != currentClass) {
                                    id = tw.getFreshIdLabel<DbSuperconstructorinvocationstmt>()
                                    tw.writeStmts_superconstructorinvocationstmt(
                                        id,
                                        stmtParent.parent,
                                        stmtParent.idx,
                                        callable
                                    )
                                } else {
                                    id = tw.getFreshIdLabel<DbConstructorinvocationstmt>()
                                    tw.writeStmts_constructorinvocationstmt(
                                        id,
                                        stmtParent.parent,
                                        stmtParent.idx,
                                        callable
                                    )
                                }

                                val locId = tw.getLocation(e)
                                val methodId = useFunction<DbConstructor>(e.symbol.owner)
                                if (methodId == null) {
                                    logger.errorElement("Cannot get ID for delegating constructor", e)
                                } else {
                                    tw.writeCallableBinding(id.cast<DbCaller>(), methodId)
                                }

                                tw.writeHasLocation(id, locId)
                                extractCallValueArguments(id, e, id, callable, 0)
                                val dr = e.dispatchReceiver
                                if (dr != null) {
                                    extractExpressionExpr(dr, callable, id, -1, id)
                                }

                                // todo: type arguments at index -2, -3, ...
                            }
            */
            is KtThrowExpression -> {
                val stmtParent = parent.stmt(e, callable)
                val id = tw.getFreshIdLabel<DbThrowstmt>()
                val locId = tw.getLocation(e)
                tw.writeStmts_throwstmt(id, stmtParent.parent, stmtParent.idx, callable)
                tw.writeHasLocation(id, locId)
                val thrown = e.thrownExpression!!
                extractExpressionExpr(thrown, callable, id, 0, id)
            }

            is KtBreakExpression -> {
                val stmtParent = parent.stmt(e, callable)
                val id = tw.getFreshIdLabel<DbBreakstmt>()
                tw.writeStmts_breakstmt(id, stmtParent.parent, stmtParent.idx, callable)
                extractBreakContinue(e, id)
            }

            is KtContinueExpression -> {
                val stmtParent = parent.stmt(e, callable)
                val id = tw.getFreshIdLabel<DbContinuestmt>()
                tw.writeStmts_continuestmt(id, stmtParent.parent, stmtParent.idx, callable)
                extractBreakContinue(e, id)
            }

            is KtReturnExpression -> {
                val stmtParent = parent.stmt(e, callable)
                val id = tw.getFreshIdLabel<DbReturnstmt>()
                val locId = tw.getLocation(e)
                tw.writeStmts_returnstmt(id, stmtParent.parent, stmtParent.idx, callable)
                tw.writeHasLocation(id, locId)
                val returned = e.getReturnedExpression()
                if (returned != null) {
                    extractExpression(returned, callable, ExprParent(id, 0, id))
                }
                // TODO: e.getLabeledExpression()
            }

            is KtTryExpression -> {
                val stmtParent = parent.stmt(e, callable)
                val id = tw.getFreshIdLabel<DbTrystmt>()
                val locId = tw.getLocation(e)
                tw.writeStmts_trystmt(id, stmtParent.parent, stmtParent.idx, callable)
                tw.writeHasLocation(id, locId)
                extractExpressionStmt(e.tryBlock, callable, id, -1)
                val finallyStmt = e.finallyBlock?.finalExpression
                if (finallyStmt != null) {
                    extractExpressionStmt(finallyStmt, callable, id, -2)
                }
                for ((catchIdx, catchClause) in e.catchClauses.withIndex()) {
                    val catchId = tw.getFreshIdLabel<DbCatchclause>()
                    tw.writeStmts_catchclause(catchId, id, catchIdx, callable)
                    val catchLocId = tw.getLocation(catchClause)
                    tw.writeHasLocation(catchId, catchLocId)
                    /*
                    OLD: KE1
                    extractTypeAccessRecursive(
                        catchClause.catchParameter.type,
                        tw.getLocation(catchClause.catchParameter),
                        catchId,
                        -1,
                        callable,
                        catchId
                    )
                    extractVariableExpr(
                        catchClause.catchParameter,
                        callable,
                        catchId,
                        0,
                        catchId
                    )
                    */
                    extractExpressionStmt(catchClause.catchBody!!, callable, catchId, 1)
                }
            }

            is KtBlockExpression -> {
                /*
                OLD: KE1
                if (
                    !tryExtractArrayUpdate(e, callable, parent) &&
                        !tryExtractForLoop(e, callable, parent)
                ) {
                    extractBlock(e, e.statements, parent, callable)
                }
                */
                extractBlock(e, e.statements, parent, callable)
            }

            is KtWhileExpression -> {
                extractLoopWithCondition(e, parent, callable)
            }

            is KtDoWhileExpression -> {
                extractLoopWithCondition(e, parent, callable)
            }
            /*
                            is IrInstanceInitializerCall -> {
                                val irConstructor = declarationStack.peek().first as? IrConstructor
                                if (irConstructor == null) {
                                    logger.errorElement("IrInstanceInitializerCall outside constructor", e)
                                    return
                                }
                                if (needsObinitFunction(irConstructor.parentAsClass)) {
                                    val exprParent = parent.expr(e, callable)
                                    val id = tw.getFreshIdLabel<DbMethodaccess>()
                                    val type = useType(pluginContext.irBuiltIns.unitType)
                                    val locId = tw.getLocation(e)
                                    val parentClass = irConstructor.parentAsClass
                                    val parentId = useDeclarationParentOf(irConstructor, false, null, true)
                                    if (parentId == null) {
                                        logger.errorElement("Cannot get parent ID for obinit", e)
                                        return
                                    }
                                    val methodLabel = getObinitLabel(parentClass, parentId)
                                    val methodId = tw.getLabelFor<DbMethod>(methodLabel)
                                    tw.writeExprs_methodaccess(
                                        id,
                                        type.javaResult.id,
                                        exprParent.parent,
                                        exprParent.idx
                                    )
                                    tw.writeExprsKotlinType(id, type.kotlinResult.id)
                                    extractExprContext(id, locId, callable, exprParent.enclosingStmt)
                                    tw.writeCallableBinding(id, methodId)
                                } else {
                                    val stmtParent = parent.stmt(e, callable)
                                    extractInstanceInitializerBlock(stmtParent, irConstructor)
                                }
                            }
                            is IrConstructorCall -> {
                                val exprParent = parent.expr(e, callable)
                                extractConstructorCall(
                                    e,
                                    exprParent.parent,
                                    exprParent.idx,
                                    callable,
                                    exprParent.enclosingStmt
                                )
                            }
                            is IrEnumConstructorCall -> {
                                val exprParent = parent.expr(e, callable)
                                extractConstructorCall(
                                    e,
                                    exprParent.parent,
                                    exprParent.idx,
                                    callable,
                                    exprParent.enclosingStmt
                                )
                            }
            */
            is KtCallExpression -> {
                extractCall(e, callable, parent)
            }
            /*
            OLD: KE1
                            is IrStringConcatenation -> {
                                val exprParent = parent.expr(e, callable)
                                val id = tw.getFreshIdLabel<DbStringtemplateexpr>()
                                val type = useType(e.type)
                                val locId = tw.getLocation(e)
                                tw.writeExprs_stringtemplateexpr(
                                    id,
                                    type.javaResult.id,
                                    exprParent.parent,
                                    exprParent.idx
                                )
                                tw.writeExprsKotlinType(id, type.kotlinResult.id)
                                extractExprContext(id, locId, callable, exprParent.enclosingStmt)
                                e.arguments.forEachIndexed { i, a ->
                                    extractExpressionExpr(a, callable, id, i, exprParent.enclosingStmt)
                                }
                            }
            */
            is KtConstantExpression -> {
                val exprParent = parent.expr(e, callable)
                extractConstant(
                    e,
                    callable,
                    exprParent.parent,
                    exprParent.idx,
                    exprParent.enclosingStmt
                )
            }
            /*
            OLD: KE1
                            is IrGetValue -> {
                                val exprParent = parent.expr(e, callable)
                                val owner = e.symbol.owner
                                if (
                                    owner is IrValueParameter &&
                                        owner.index == -1 &&
                                        !owner.isExtensionReceiver()
                                ) {
                                    extractThisAccess(e, owner.parent, exprParent, callable)
                                } else {
                                    val isAnnotationClassParameter =
                                        ((owner as? IrValueParameter)?.parent as? IrConstructor)
                                            ?.parentClassOrNull
                                            ?.kind == ClassKind.ANNOTATION_CLASS
                                    val extractType =
                                        if (isAnnotationClassParameter) kClassToJavaClass(e.type) else e.type
                                    extractVariableAccess(
                                        useValueDeclaration(owner),
                                        extractType,
                                        tw.getLocation(e),
                                        exprParent.parent,
                                        exprParent.idx,
                                        callable,
                                        exprParent.enclosingStmt
                                    )
                                }
                            }
                            is IrGetField -> {
                                val exprParent = parent.expr(e, callable)
                                val owner = tryReplaceAndroidSyntheticField(e.symbol.owner)
                                val locId = tw.getLocation(e)
                                val fieldType =
                                    if (isAnnotationClassField(owner)) kClassToJavaClass(e.type) else e.type
                                extractVariableAccess(
                                        useField(owner),
                                        fieldType,
                                        locId,
                                        exprParent.parent,
                                        exprParent.idx,
                                        callable,
                                        exprParent.enclosingStmt
                                    )
                                    .also { id ->
                                        val receiver = e.receiver
                                        if (receiver != null) {
                                            extractExpressionExpr(
                                                receiver,
                                                callable,
                                                id,
                                                -1,
                                                exprParent.enclosingStmt
                                            )
                                        } else if (owner.isStatic) {
                                            extractStaticTypeAccessQualifier(
                                                owner,
                                                id,
                                                locId,
                                                callable,
                                                exprParent.enclosingStmt
                                            )
                                        }
                                    }
                            }
                            is IrGetEnumValue -> {
                                val exprParent = parent.expr(e, callable)
                                extractEnumValue(
                                    e,
                                    exprParent.parent,
                                    exprParent.idx,
                                    callable,
                                    exprParent.enclosingStmt
                                )
                            }
                            is IrSetValue,
                            is IrSetField -> {
                                val exprParent = parent.expr(e, callable)
                                val id = tw.getFreshIdLabel<DbAssignexpr>()
                                val type = useType(e.type)
                                val rhsValue =
                                    when (e) {
                                        is IrSetValue -> e.value
                                        is IrSetField -> e.value
                                        else -> {
                                            logger.errorElement("Unhandled IrSet* element.", e)
                                            return
                                        }
                                    }
                                // The set operation's location as actually that of its LHS. Hence, the
                                // assignment spans the
                                // set op plus its RHS, while the varAccess takes its location from `e`.
                                val locId = tw.getLocation(e.startOffset, rhsValue.endOffset)
                                tw.writeExprsKotlinType(id, type.kotlinResult.id)
                                extractExprContext(id, locId, callable, exprParent.enclosingStmt)

                                val lhsId = tw.getFreshIdLabel<DbVaraccess>()
                                val lhsLocId = tw.getLocation(e)
                                extractExprContext(lhsId, lhsLocId, callable, exprParent.enclosingStmt)

                                when (e) {
                                    is IrSetValue -> {
                                        // Check for a desugared in-place update operator, such as "v += e":
                                        val inPlaceUpdateRhs =
                                            getUpdateInPlaceRHS(
                                                e.origin,
                                                { it is IrGetValue && it.symbol.owner == e.symbol.owner },
                                                rhsValue
                                            )
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
                                                writeUpdateInPlaceExprFun(
                                                    tw,
                                                    id,
                                                    type.javaResult.id,
                                                    exprParent.parent,
                                                    exprParent.idx
                                                )
                                            }
                                        } else {
                                            tw.writeExprs_assignexpr(
                                                id,
                                                type.javaResult.id,
                                                exprParent.parent,
                                                exprParent.idx
                                            )
                                        }

                                        val lhsType = useType(e.symbol.owner.type)
                                        tw.writeExprs_varaccess(lhsId, lhsType.javaResult.id, id, 0)
                                        tw.writeExprsKotlinType(lhsId, lhsType.kotlinResult.id)
                                        val vId = useValueDeclaration(e.symbol.owner)
                                        if (vId != null) {
                                            tw.writeVariableBinding(lhsId, vId)
                                        }
                                        extractExpressionExpr(
                                            inPlaceUpdateRhs ?: rhsValue,
                                            callable,
                                            id,
                                            1,
                                            exprParent.enclosingStmt
                                        )
                                    }
                                    is IrSetField -> {
                                        tw.writeExprs_assignexpr(
                                            id,
                                            type.javaResult.id,
                                            exprParent.parent,
                                            exprParent.idx
                                        )
                                        val realField = tryReplaceAndroidSyntheticField(e.symbol.owner)
                                        val lhsType = useType(realField.type)
                                        tw.writeExprs_varaccess(lhsId, lhsType.javaResult.id, id, 0)
                                        tw.writeExprsKotlinType(lhsId, lhsType.kotlinResult.id)
                                        val vId = useField(realField)
                                        tw.writeVariableBinding(lhsId, vId)
                                        extractExpressionExpr(
                                            e.value,
                                            callable,
                                            id,
                                            1,
                                            exprParent.enclosingStmt
                                        )

                                        val receiver = e.receiver
                                        if (receiver != null) {
                                            extractExpressionExpr(
                                                receiver,
                                                callable,
                                                lhsId,
                                                -1,
                                                exprParent.enclosingStmt
                                            )
                                        } else if (realField.isStatic) {
                                            extractStaticTypeAccessQualifier(
                                                realField,
                                                lhsId,
                                                lhsLocId,
                                                callable,
                                                exprParent.enclosingStmt
                                            )
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

                                if (
                                    (isAndAnd || isOrOr) &&
                                        e.branches.size == 2 &&
                                        (e.branches[1].condition as? IrConst<*>)?.value == true &&
                                        (e.branches[if (e.origin == IrStatementOrigin.ANDAND) 1 else 0].result
                                                as? IrConst<*>)
                                            ?.value == isOrOr
                                ) {

                                    // resugar binary logical operators:

                                    val exprParent = parent.expr(e, callable)
                                    val type = useType(e.type)

                                    val id =
                                        if (e.origin == IrStatementOrigin.ANDAND) {
                                            val id = tw.getFreshIdLabel<DbAndlogicalexpr>()
                                            tw.writeExprs_andlogicalexpr(
                                                id,
                                                type.javaResult.id,
                                                exprParent.parent,
                                                exprParent.idx
                                            )
                                            id
                                        } else {
                                            val id = tw.getFreshIdLabel<DbOrlogicalexpr>()
                                            tw.writeExprs_orlogicalexpr(
                                                id,
                                                type.javaResult.id,
                                                exprParent.parent,
                                                exprParent.idx
                                            )
                                            id
                                        }
                                    val locId = tw.getLocation(e)

                                    tw.writeExprsKotlinType(id, type.kotlinResult.id)
                                    extractExprContext(id, locId, callable, exprParent.enclosingStmt)

                                    extractExpressionExpr(
                                        e.branches[0].condition,
                                        callable,
                                        id,
                                        0,
                                        exprParent.enclosingStmt
                                    )

                                    var rhsIdx = if (e.origin == IrStatementOrigin.ANDAND) 0 else 1
                                    extractExpressionExpr(
                                        e.branches[rhsIdx].result,
                                        callable,
                                        id,
                                        1,
                                        exprParent.enclosingStmt
                                    )

                                    return
                                }

                                val exprParent = parent.expr(e, callable)
                                val id = tw.getFreshIdLabel<DbWhenexpr>()
                                val type = useType(e.type)
                                val locId = tw.getLocation(e)
                                tw.writeExprs_whenexpr(
                                    id,
                                    type.javaResult.id,
                                    exprParent.parent,
                                    exprParent.idx
                                )
                                tw.writeExprsKotlinType(id, type.kotlinResult.id)
                                extractExprContext(id, locId, callable, exprParent.enclosingStmt)
                                if (e.origin == IrStatementOrigin.IF) {
                                    tw.writeWhen_if(id)
                                }
                                e.branches.forEachIndexed { i, b ->
                                    val bId = tw.getFreshIdLabel<DbWhenbranch>()
                                    val bLocId = tw.getLocation(b)
                                    tw.writeStmts_whenbranch(bId, id, i, callable)
                                    tw.writeHasLocation(bId, bLocId)
                                    extractExpressionExpr(b.condition, callable, bId, 0, bId)
                                    extractExpressionStmt(b.result, callable, bId, 1)
                                    if (b is IrElseBranch) {
                                        tw.writeWhen_branch_else(bId)
                                    }
                                }
                            }
                            is IrGetClass -> {
                                val exprParent = parent.expr(e, callable)
                                val id = tw.getFreshIdLabel<DbGetclassexpr>()
                                val locId = tw.getLocation(e)
                                val type = useType(e.type)
                                tw.writeExprs_getclassexpr(
                                    id,
                                    type.javaResult.id,
                                    exprParent.parent,
                                    exprParent.idx
                                )
                                tw.writeExprsKotlinType(id, type.kotlinResult.id)
                                extractExprContext(id, locId, callable, exprParent.enclosingStmt)
                                extractExpressionExpr(e.argument, callable, id, 0, exprParent.enclosingStmt)
                            }
                            is IrTypeOperatorCall -> {
                                val exprParent = parent.expr(e, callable)
                                extractTypeOperatorCall(
                                    e,
                                    callable,
                                    exprParent.parent,
                                    exprParent.idx,
                                    exprParent.enclosingStmt
                                )
                            }
                            is IrVararg -> {
                                // There are lowered IR cases when the vararg expression is not within a call,
                                // such as
                                // val temp0 = [*expr].
                                // This AST element can also occur as a collection literal in an annotation
                                // class, such as
                                // annotation class Ann(val strings: Array<String> = [])
                                val exprParent = parent.expr(e, callable)
                                extractArrayCreation(
                                    e,
                                    e.type,
                                    e.varargElementType,
                                    true,
                                    e,
                                    exprParent.parent,
                                    exprParent.idx,
                                    callable,
                                    exprParent.enclosingStmt
                                )
                            }
                            is IrGetObjectValue -> {
                                // For `object MyObject { ... }`, the .class has an
                                // automatically-generated `public static final MyObject INSTANCE`
                                // field that we are accessing here.
                                val exprParent = parent.expr(e, callable)
                                val c = getBoundSymbolOwner(e.symbol, e) ?: return

                                val instance =
                                    if (c.isCompanion) useCompanionObjectClassInstance(c)
                                    else useObjectClassInstance(c)

                                if (instance != null) {
                                    val id = tw.getFreshIdLabel<DbVaraccess>()
                                    val type = useType(e.type)
                                    val locId = tw.getLocation(e)
                                    tw.writeExprs_varaccess(
                                        id,
                                        type.javaResult.id,
                                        exprParent.parent,
                                        exprParent.idx
                                    )
                                    tw.writeExprsKotlinType(id, type.kotlinResult.id)
                                    extractExprContext(id, locId, callable, exprParent.enclosingStmt)

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
                                val parameters =
                                    if (ext != null) {
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
                                tw.writeExprs_lambdaexpr(
                                    idLambdaExpr,
                                    ids.type.javaResult.id,
                                    exprParent.parent,
                                    exprParent.idx
                                )
                                tw.writeExprsKotlinType(idLambdaExpr, ids.type.kotlinResult.id)
                                extractExprContext(idLambdaExpr, locId, callable, exprParent.enclosingStmt)
                                tw.writeCallableBinding(idLambdaExpr, ids.constructor)

                                // todo: fix hard coded block body of lambda
                                tw.writeLambdaKind(idLambdaExpr, 1)

                                val fnInterfaceType = getFunctionalInterfaceType(types)
                                if (fnInterfaceType == null) {
                                    logger.warnElement(
                                        "Cannot find functional interface type for function expression",
                                        e
                                    )
                                } else {
                                    val id =
                                        extractGeneratedClass(
                                            e
                                                .function, // We're adding this function as a member, and
                                                           // changing its name to `invoke` to implement
                                                           // `kotlin.FunctionX<,,,>.invoke(,,)`
                                            listOf(pluginContext.irBuiltIns.anyType, fnInterfaceType)
                                        )

                                    extractTypeAccessRecursive(
                                        fnInterfaceType,
                                        locId,
                                        idLambdaExpr,
                                        -3,
                                        callable,
                                        exprParent.enclosingStmt
                                    )

                                    tw.writeIsAnonymClass(id, idLambdaExpr)
                                }
                            }
                            is IrClassReference -> {
                                val exprParent = parent.expr(e, callable)
                                extractClassReference(
                                    e,
                                    exprParent.parent,
                                    exprParent.idx,
                                    callable,
                                    exprParent.enclosingStmt
                                )
                            }
                            is IrPropertyReference -> {
                                extractPropertyReference(
                                    "property reference",
                                    e,
                                    e.getter,
                                    e.setter,
                                    e.field,
                                    parent,
                                    callable
                                )
                            }
                            is IrLocalDelegatedPropertyReference -> {
                                extractPropertyReference(
                                    "local delegated property reference",
                                    e,
                                    e.getter,
                                    e.setter,
                                    null,
                                    parent,
                                    callable
                                )
                            }
            */
            else -> {
                logger.errorElement("Unrecognised KtExpression: " + e.javaClass, e)
            }
        }
        return
    }
}

context(KaSession)
private fun KotlinFileExtractor.extractBlock(
    e: KtBlockExpression,
    statements: List<KtExpression>,
    parent: StmtExprParent,
    callable: Label<out DbCallable>
) {
    val stmtParent = parent.stmt(e, callable)
    extractBlock(e, statements, stmtParent.parent, stmtParent.idx, callable)
}

context(KaSession)
private fun KotlinFileExtractor.extractBlock(
    e: KtBlockExpression,
    statements: List<KtExpression>,
    parent: Label<out DbStmtparent>,
    idx: Int,
    callable: Label<out DbCallable>
) {
    val id = tw.getFreshIdLabel<DbBlock>()
    val locId = tw.getLocation(e)
    tw.writeStmts_block(id, parent, idx, callable)
    tw.writeHasLocation(id, locId)
    statements.forEachIndexed { i, s -> extractStatement(s, callable, id, i) }
}

context(KaSession)
private fun KotlinFileExtractor.extractStatement(
    s: KtExpression,
    callable: Label<out DbCallable>,
    parent: Label<out DbStmtparent>,
    idx: Int
) {
    with("statement", s) {
        when (s) {
            is KtStatementExpression -> {
                extractExpressionStmt(s, callable, parent, idx)
            }
            /*
            OLD: KE1
            is IrVariable -> {
                extractVariable(s, callable, parent, idx)
            }
            is IrClass -> {
                extractLocalTypeDeclStmt(s, callable, parent, idx)
            }
            is IrFunction -> {
                if (s.isLocalFunction()) {
                    val compilerGeneratedKindOverride =
                        if (s.origin == IrDeclarationOrigin.ADAPTER_FOR_CALLABLE_REFERENCE) {
                            CompilerGeneratedKinds.DECLARING_CLASSES_OF_ADAPTER_FUNCTIONS
                        } else {
                            null
                        }
                    val classId =
                        extractGeneratedClass(
                            s,
                            listOf(pluginContext.irBuiltIns.anyType),
                            compilerGeneratedKindOverride = compilerGeneratedKindOverride
                        )
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
                val getterLabel = getLocallyVisibleFunctionLabels(s.getter).function
                tw.writeKtPropertyGetters(propId, getterLabel)

                val setter = s.setter
                if (setter != null) {
                    extractStatement(setter, callable, blockId, 2)
                    val setterLabel = getLocallyVisibleFunctionLabels(setter).function
                    tw.writeKtPropertySetters(propId, setterLabel)
                }
            }

             */
            else -> {
                logger.errorElement("Unhandled statement: " + s.javaClass, s)
            }
        }
    }
}

/*
OLD: KE1
    private inline fun <D : DeclarationDescriptor, reified B : IrSymbolOwner> getBoundSymbolOwner(
        symbol: IrBindableSymbol<D, B>,
        e: IrExpression
    ): B? {
        if (symbol.isBound) {
            return symbol.owner
        }

        logger.errorElement("Unbound symbol found, skipping extraction of expression", e)
        return null
    }

    private fun extractSuperAccess(
        irType: IrType,
        callable: Label<out DbCallable>,
        parent: Label<out DbExprparent>,
        idx: Int,
        enclosingStmt: Label<out DbStmt>,
        locId: Label<DbLocation>
    ) =
        tw.getFreshIdLabel<DbSuperaccess>().also {
            val type = useType(irType)
            tw.writeExprs_superaccess(it, type.javaResult.id, parent, idx)
            tw.writeExprsKotlinType(it, type.kotlinResult.id)
            extractExprContext(it, locId, callable, enclosingStmt)
            extractTypeAccessRecursive(irType, locId, it, 0)
        }

    private fun extractThisAccess(
        type: TypeResults,
        callable: Label<out DbCallable>,
        parent: Label<out DbExprparent>,
        idx: Int,
        enclosingStmt: Label<out DbStmt>,
        locId: Label<DbLocation>
    ) =
        tw.getFreshIdLabel<DbThisaccess>().also {
            tw.writeExprs_thisaccess(it, type.javaResult.id, parent, idx)
            tw.writeExprsKotlinType(it, type.kotlinResult.id)
            extractExprContext(it, locId, callable, enclosingStmt)
        }

    private fun extractThisAccess(
        irType: IrType,
        callable: Label<out DbCallable>,
        parent: Label<out DbExprparent>,
        idx: Int,
        enclosingStmt: Label<out DbStmt>,
        locId: Label<DbLocation>
    ) = extractThisAccess(useType(irType), callable, parent, idx, enclosingStmt, locId)

    private fun extractThisAccess(
        e: IrGetValue,
        thisParamParent: IrDeclarationParent,
        exprParent: ExprParent,
        callable: Label<out DbCallable>
    ) {
        val containingDeclaration = declarationStack.peek().first
        val locId = tw.getLocation(e)

        if (
            containingDeclaration.shouldExtractAsStatic &&
                containingDeclaration.parentClassOrNull?.isNonCompanionObject == true
        ) {
            // Use of `this` in a non-companion object member that will be lowered to a static
            // function -- replace with a reference
            // to the corresponding static object instance.
            val instanceField = useObjectClassInstance(containingDeclaration.parentAsClass)
            extractVariableAccess(
                    instanceField.id,
                    e.type,
                    locId,
                    exprParent.parent,
                    exprParent.idx,
                    callable,
                    exprParent.enclosingStmt
                )
                .also { varAccessId ->
                    extractStaticTypeAccessQualifier(
                        containingDeclaration,
                        varAccessId,
                        locId,
                        callable,
                        exprParent.enclosingStmt
                    )
                }
        } else {
            if (thisParamParent is IrFunction) {
                val overriddenAttributes =
                    declarationStack.findOverriddenAttributes(thisParamParent)
                val replaceWithParamIdx =
                    overriddenAttributes?.valueParameters?.indexOf(e.symbol.owner)
                if (replaceWithParamIdx != null && replaceWithParamIdx != -1) {
                    // Use of 'this' in a function where the dispatch receiver is passed like an
                    // ordinary parameter,
                    // such as a `$default` static function that substitutes in default arguments as
                    // needed.
                    val paramDeclarerId =
                        overriddenAttributes.id ?: useDeclarationParent(thisParamParent, false)
                    val replacementParamId =
                        tw.getLabelFor<DbParam>(
                            getValueParameterLabel(paramDeclarerId, replaceWithParamIdx)
                        )
                    extractVariableAccess(
                        replacementParamId,
                        e.type,
                        locId,
                        exprParent.parent,
                        exprParent.idx,
                        callable,
                        exprParent.enclosingStmt
                    )
                    return
                }
            }

            val id =
                extractThisAccess(
                    e.type,
                    callable,
                    exprParent.parent,
                    exprParent.idx,
                    exprParent.enclosingStmt,
                    locId
                )

            fun extractTypeAccess(parent: IrClass) {
                extractTypeAccessRecursive(
                    parent.typeWith(listOf()),
                    locId,
                    id,
                    0,
                    callable,
                    exprParent.enclosingStmt
                )
            }

            val owner = e.symbol.owner
            when (val ownerParent = owner.parent) {
                is IrFunction -> {
                    if (
                        ownerParent.dispatchReceiverParameter == owner &&
                            ownerParent.extensionReceiverParameter != null
                    ) {

                        val ownerParent2 = ownerParent.parent
                        if (ownerParent2 is IrClass) {
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
                    logger.errorElement(
                        "Unexpected owner parent for this access: " + ownerParent.javaClass,
                        e
                    )
                }
            }
        }
    }

    private fun extractVariableAccess(
        variable: Label<out DbVariable>?,
        type: TypeResults,
        locId: Label<DbLocation>,
        parent: Label<out DbExprparent>,
        idx: Int,
        callable: Label<out DbCallable>,
        enclosingStmt: Label<out DbStmt>
    ) =
        tw.getFreshIdLabel<DbVaraccess>().also {
            tw.writeExprs_varaccess(it, type.javaResult.id, parent, idx)
            tw.writeExprsKotlinType(it, type.kotlinResult.id)
            extractExprContext(it, locId, callable, enclosingStmt)

            if (variable != null) {
                tw.writeVariableBinding(it, variable)
            }
        }

    private fun extractVariableAccess(
        variable: Label<out DbVariable>?,
        irType: IrType,
        locId: Label<DbLocation>,
        parent: Label<out DbExprparent>,
        idx: Int,
        callable: Label<out DbCallable>,
        enclosingStmt: Label<out DbStmt>
    ) =
        extractVariableAccess(
            variable,
            useType(irType),
            locId,
            parent,
            idx,
            callable,
            enclosingStmt
        )
*/
context(KaSession)
private fun KotlinFileExtractor.extractLoop(
    loop: KtLoopExpression,
    bodyIdx: Int?,
    stmtExprParent: StmtExprParent,
    callable: Label<out DbCallable>,
    getId: (Label<out DbStmtparent>, Int) -> Label<out DbStmt>
): Label<out DbStmt> {
    val stmtParent = stmtExprParent.stmt(loop, callable)
    val locId = tw.getLocation(loop)

    val idx: Int
    val parent: Label<out DbStmtparent>

    // TODO: the below can be removed if KtLabeledExpression is handled in extractExpression.
    val label = (loop.parent as? KtLabeledExpression)?.getLabelName()
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

    val id = getId(parent, idx)
    tw.writeHasLocation(id, locId)

    val body = loop.body
    if (body != null && bodyIdx != null) {
        extractExpressionStmt(body, callable, id, bodyIdx)
    }

    return id
}

context(KaSession)
private fun KotlinFileExtractor.extractLoopWithCondition(
    loop: KtWhileExpressionBase,
    stmtExprParent: StmtExprParent,
    callable: Label<out DbCallable>
) {
    val id =
        extractLoop(loop, 1, stmtExprParent, callable) { parent, idx ->
            if (loop is KtWhileExpression) {
                tw.getFreshIdLabel<DbWhilestmt>().also {
                    tw.writeStmts_whilestmt(it, parent, idx, callable)
                }
            } else {
                tw.getFreshIdLabel<DbDostmt>().also {
                    tw.writeStmts_dostmt(it, parent, idx, callable)
                }
            }
        }
    val condition = loop.condition!!
    extractExpressionExpr(condition, callable, id, 0, id)
}

/*
OLD: KE1
    private fun <T : DbExpr> exprIdOrFresh(id: Label<out DbExpr>?) =
        id?.cast<T>() ?: tw.getFreshIdLabel()

    private fun extractClassReference(
        e: IrClassReference,
        parent: Label<out DbExprparent>,
        idx: Int,
        enclosingCallable: Label<out DbCallable>?,
        enclosingStmt: Label<out DbStmt>?,
        overrideId: Label<out DbExpr>? = null,
        typeAccessOverrideId: Label<out DbExpr>? = null,
        useJavaLangClassType: Boolean = false
    ) =
        exprIdOrFresh<DbTypeliteral>(overrideId).also { id ->
            val locId = tw.getLocation(e)
            val jlcType =
                if (useJavaLangClassType) this.javaLangClass?.let { it.typeWith() } else null
            val type = useType(jlcType ?: e.type)
            tw.writeExprs_typeliteral(id, type.javaResult.id, parent, idx)
            tw.writeExprsKotlinType(id, type.kotlinResult.id)
            extractExprContext(id, locId, enclosingCallable, enclosingStmt)

            extractTypeAccessRecursive(
                e.classType,
                locId,
                id,
                0,
                enclosingCallable,
                enclosingStmt,
                overrideId = typeAccessOverrideId
            )
        }

    private fun extractEnumValue(
        e: IrGetEnumValue,
        parent: Label<out DbExprparent>,
        idx: Int,
        enclosingCallable: Label<out DbCallable>?,
        enclosingStmt: Label<out DbStmt>?,
        extractTypeAccess: Boolean = true,
        overrideId: Label<out DbExpr>? = null
    ) =
        exprIdOrFresh<DbVaraccess>(overrideId).also { id ->
            val type = useType(e.type)
            val locId = tw.getLocation(e)
            tw.writeExprs_varaccess(id, type.javaResult.id, parent, idx)
            tw.writeExprsKotlinType(id, type.kotlinResult.id)
            extractExprContext(id, locId, enclosingCallable, enclosingStmt)

            getBoundSymbolOwner(e.symbol, e)?.let { owner ->
                val vId = useEnumEntry(owner)
                tw.writeVariableBinding(id, vId)

                if (extractTypeAccess)
                    extractStaticTypeAccessQualifier(
                        owner,
                        id,
                        locId,
                        enclosingCallable,
                        enclosingStmt
                    )
            }
        }

    private fun escapeCharForQuotedLiteral(c: Char) =
        when (c) {
            '\r' -> "\\r"
            '\n' -> "\\n"
            '\t' -> "\\t"
            '\\' -> "\\\\"
            '"' -> "\\\""
            else -> c.toString()
        }

    // Render a string literal as it might occur in Kotlin source. Note this is a reasonable guess;
    // the real source
    // could use other escape sequences to describe the same String. Importantly, this is the same
    // guess the Java
    // extractor makes regarding string literals occurring within annotations, which we need to
    // coincide with to ensure
    // database consistency.
    private fun toQuotedLiteral(s: String) =
        s.toCharArray().joinToString(separator = "", prefix = "\"", postfix = "\"") { c ->
            escapeCharForQuotedLiteral(c)
        }
*/

context(KaSession)
private fun KotlinFileExtractor.extractCall(
    c: KtCallExpression,
    callable: Label<out DbCallable>,
    stmtExprParent: StmtExprParent
) {
    with("call", c) {
        // OLD: KE1 val owner = getBoundSymbolOwner(c.symbol, c) ?: return
        // OLD: KE1 val target = tryReplaceSyntheticFunction(owner) */

        val calleeRefs = c.calleeExpression?.references

        if (calleeRefs == null || calleeRefs.size != 1) {
            // TODO
            return
        }

        val target = (calleeRefs[0] as? KtReference)?.resolveToSymbol() as? KaFunctionSymbol ?: return // TODO

        // The vast majority of types of call want an expr context, so make one available
        // lazily:
        val exprParent by lazy { stmtExprParent.expr(c, callable) }

        val parent by lazy { exprParent.parent }

        val idx by lazy { exprParent.idx }

        val enclosingStmt by lazy { exprParent.enclosingStmt }

        fun extractMethodAccess(
            syntacticCallTarget: KaFunctionSymbol,
            extractMethodTypeArguments: Boolean = true,
            extractClassTypeArguments: Boolean = false
        ) {
            val typeArgs = listOf<KaType>()
            /*
            OLD: KE1
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
            */

            extractRawMethodAccess(
                syntacticCallTarget,
                c,
                c.expressionType!!, // TODO
                callable,
                parent,
                idx,
                enclosingStmt,
                c.valueArguments.map { it.getArgumentExpression() },
                null, // OLD: KE1 c.dispatchReceiver,
                null, // OLD: KE1 c.extensionReceiver,
                typeArgs,
                extractClassTypeArguments,
                null, // OLD: KE1 c.superQualifierSymbol
            )
        }

        /*
        OLD: KE1
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
         */

        /*
        OLD: KE1
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
        val dr = c.
        */

        when {
        /*
        OLD: KE1
            isNumericFunction(
                target,
                "plus",
                "minus",
                "times",
                "div",
                "rem",
                "and",
                "or",
                "xor",
                "shl",
                "shr",
                "ushr"
            ) -> {
                val type = useType(c.type)
                val id: Label<out DbExpr> =
                    when (val targetName = target.name.asString()) {
                        "minus" -> {
                            val id = tw.getFreshIdLabel<DbSubexpr>()
                            tw.writeExprs_subexpr(id, type.javaResult.id, parent, idx)
                            id
                        }
                        "times" -> {
                            val id = tw.getFreshIdLabel<DbMulexpr>()
                            tw.writeExprs_mulexpr(id, type.javaResult.id, parent, idx)
                            id
                        }
                        "div" -> {
                            val id = tw.getFreshIdLabel<DbDivexpr>()
                            tw.writeExprs_divexpr(id, type.javaResult.id, parent, idx)
                            id
                        }
                        "rem" -> {
                            val id = tw.getFreshIdLabel<DbRemexpr>()
                            tw.writeExprs_remexpr(id, type.javaResult.id, parent, idx)
                            id
                        }
                        "and" -> {
                            val id = tw.getFreshIdLabel<DbAndbitexpr>()
                            tw.writeExprs_andbitexpr(id, type.javaResult.id, parent, idx)
                            id
                        }
                        "or" -> {
                            val id = tw.getFreshIdLabel<DbOrbitexpr>()
                            tw.writeExprs_orbitexpr(id, type.javaResult.id, parent, idx)
                            id
                        }
                        "xor" -> {
                            val id = tw.getFreshIdLabel<DbXorbitexpr>()
                            tw.writeExprs_xorbitexpr(id, type.javaResult.id, parent, idx)
                            id
                        }
                        "shl" -> {
                            val id = tw.getFreshIdLabel<DbLshiftexpr>()
                            tw.writeExprs_lshiftexpr(id, type.javaResult.id, parent, idx)
                            id
                        }
                        "shr" -> {
                            val id = tw.getFreshIdLabel<DbRshiftexpr>()
                            tw.writeExprs_rshiftexpr(id, type.javaResult.id, parent, idx)
                            id
                        }
                        "ushr" -> {
                            val id = tw.getFreshIdLabel<DbUrshiftexpr>()
                            tw.writeExprs_urshiftexpr(id, type.javaResult.id, parent, idx)
                            id
                        }
                        else -> {
                            logger.errorElement("Unhandled binary target name: $targetName", c)
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
                        "and",
                        "or",
                        "xor"
                    )
                )
                    binopExt(id)
                else binopDisp(id)
            }
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
            c.origin == IrStatementOrigin.EXCLEQEQ &&
                    isFunction(target, "kotlin", "Boolean", "not") &&
                    c.valueArgumentsCount == 0 &&
                    dr != null &&
                    dr is IrCall &&
                    isBuiltinCallInternal(dr, "EQEQEQ") -> {
                val id = tw.getFreshIdLabel<DbNeexpr>()
                val type = useType(c.type)
                tw.writeExprs_neexpr(id, type.javaResult.id, parent, idx)
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
            isFunction(target, "kotlin", "Boolean", "not") -> {
                val id = tw.getFreshIdLabel<DbLognotexpr>()
                val type = useType(c.type)
                tw.writeExprs_lognotexpr(id, type.javaResult.id, parent, idx)
                tw.writeExprsKotlinType(id, type.kotlinResult.id)
                unaryopDisp(id)
            }
            isNumericFunction(target, "inv", "unaryMinus", "unaryPlus") -> {
                val type = useType(c.type)
                val id: Label<out DbExpr> =
                    when (val targetName = target.name.asString()) {
                        "inv" -> {
                            val id = tw.getFreshIdLabel<DbBitnotexpr>()
                            tw.writeExprs_bitnotexpr(id, type.javaResult.id, parent, idx)
                            id
                        }
                        "unaryMinus" -> {
                            val id = tw.getFreshIdLabel<DbMinusexpr>()
                            tw.writeExprs_minusexpr(id, type.javaResult.id, parent, idx)
                            id
                        }
                        "unaryPlus" -> {
                            val id = tw.getFreshIdLabel<DbPlusexpr>()
                            tw.writeExprs_plusexpr(id, type.javaResult.id, parent, idx)
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
            isBuiltinCallInternal(c, "less") -> {
                if (c.origin != IrStatementOrigin.LT) {
                    logger.warnElement("Unexpected origin for LT: ${c.origin}", c)
                }
                val id = tw.getFreshIdLabel<DbLtexpr>()
                val type = useType(c.type)
                tw.writeExprs_ltexpr(id, type.javaResult.id, parent, idx)
                tw.writeExprsKotlinType(id, type.kotlinResult.id)
                binOp(id, c, callable, enclosingStmt)
            }
            isBuiltinCallInternal(c, "lessOrEqual") -> {
                if (c.origin != IrStatementOrigin.LTEQ) {
                    logger.warnElement("Unexpected origin for LTEQ: ${c.origin}", c)
                }
                val id = tw.getFreshIdLabel<DbLeexpr>()
                val type = useType(c.type)
                tw.writeExprs_leexpr(id, type.javaResult.id, parent, idx)
                tw.writeExprsKotlinType(id, type.kotlinResult.id)
                binOp(id, c, callable, enclosingStmt)
            }
            isBuiltinCallInternal(c, "greater") -> {
                if (c.origin != IrStatementOrigin.GT) {
                    logger.warnElement("Unexpected origin for GT: ${c.origin}", c)
                }
                val id = tw.getFreshIdLabel<DbGtexpr>()
                val type = useType(c.type)
                tw.writeExprs_gtexpr(id, type.javaResult.id, parent, idx)
                tw.writeExprsKotlinType(id, type.kotlinResult.id)
                binOp(id, c, callable, enclosingStmt)
            }
            isBuiltinCallInternal(c, "greaterOrEqual") -> {
                if (c.origin != IrStatementOrigin.GTEQ) {
                    logger.warnElement("Unexpected origin for GTEQ: ${c.origin}", c)
                }
                val id = tw.getFreshIdLabel<DbGeexpr>()
                val type = useType(c.type)
                tw.writeExprs_geexpr(id, type.javaResult.id, parent, idx)
                tw.writeExprsKotlinType(id, type.kotlinResult.id)
                binOp(id, c, callable, enclosingStmt)
            }
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
            isBuiltinCallInternal(c, "EQEQEQ") -> {
                if (c.origin != IrStatementOrigin.EQEQEQ) {
                    logger.warnElement("Unexpected origin for EQEQEQ: ${c.origin}", c)
                }
                val id = tw.getFreshIdLabel<DbEqexpr>()
                val type = useType(c.type)
                tw.writeExprs_eqexpr(id, type.javaResult.id, parent, idx)
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
           */
            else -> {
                extractMethodAccess(target, true, true)
            }
        }
    }
}

context(KaSession)
fun KotlinFileExtractor.extractRawMethodAccess(
    syntacticCallTarget: KaFunctionSymbol,
    locElement: KtElement,
    resultType: KaType,
    enclosingCallable: Label<out DbCallable>,
    callsiteParent: Label<out DbExprparent>,
    childIdx: Int,
    enclosingStmt: Label<out DbStmt>,
    valueArguments: List<KtExpression?>,
    dispatchReceiver: KtExpression?,
    extensionReceiver: KtExpression?,
    typeArguments: List<KaType> = listOf(),
    extractClassTypeArguments: Boolean = false,
    superQualifierSymbol: KaClassSymbol? = null
) {

    val locId = tw.getLocation(locElement)

    /* OLD: KE1
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
     */
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
            null,// OLD: KE1 dispatchReceiver?.getType(),
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
    // }
}

context(KaSession)
private fun KotlinFileExtractor.getCalleeMethodId(
    callTarget: KaFunctionSymbol,
    drType: KaType?,
    allowInstantiatedGenericMethod: Boolean
): Label<out DbCallable>? {
    /*
    KE1: old
    if (callTarget.isLocalFunction())
        return getLocallyVisibleFunctionLabels(callTarget).function
    */

    /*
    KE1: old
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
     */
        return useDeclarationParentOf(callTarget, false)?.let { useFunction(callTarget, it) }
    //}
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

context(KaSession)
private fun KotlinFileExtractor.extractCallValueArguments(
    callId: Label<out DbExprparent>,
    call: KtCallExpression,
    enclosingStmt: Label<out DbStmt>,
    enclosingCallable: Label<out DbCallable>,
    idxOffset: Int
) =
    extractCallValueArguments(
        callId,
        call.valueArguments.map { it.getArgumentExpression() },
        enclosingStmt,
        enclosingCallable,
        idxOffset
    )

context(KaSession)
private fun KotlinFileExtractor.extractCallValueArguments(
    callId: Label<out DbExprparent>,
    valueArguments: List<KtExpression?>,
    enclosingStmt: Label<out DbStmt>,
    enclosingCallable: Label<out DbCallable>,
    idxOffset: Int,
    extractVarargAsArray: Boolean = false
) {
    var i = 0
    valueArguments.forEach { arg ->
        if (arg != null) {
            /* OLD: KE1
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
private fun KotlinFileExtractor.extractRawMethodAccess(
    syntacticCallTarget: KaFunctionSymbol,
    locId: Label<DbLocation>,
    returnType: KaType,
    enclosingCallable: Label<out DbCallable>,
    callsiteParent: Label<out DbExprparent>,
    childIdx: Int,
    enclosingStmt: Label<out DbStmt>,
    nValueArguments: Int,
    extractValueArguments: (Label<out DbExpr>, Int) -> Unit,
    drType: KaType?,
    extractDispatchReceiver: ((Label<out DbExpr>) -> Unit)?,
    extractExtensionReceiver: ((Label<out DbExpr>) -> Unit)?,
    typeArguments: List<KaType> = listOf(),
    extractClassTypeArguments: Boolean = false,
    superQualifierSymbol: KaClassSymbol? = null
) {

    val callTarget = syntacticCallTarget // OLD: KE1 getCalleeRealOverrideTarget(syntacticCallTarget)
    val methodId = getCalleeMethodId(callTarget, drType, extractClassTypeArguments)
    if (methodId == null) {
        logger.warn("No method to bind call to for raw method access")
    }

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

    // type arguments at index -2, -3, ...
    // OLD: KE1 extractTypeArguments(typeArguments, locId, id, enclosingCallable, enclosingStmt, -2, true)

    /* OLD: KE1
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

    val isBigArityFunctionInvoke =
        drType is IrSimpleType &&
                isFunctionInvoke(callTarget, drType) &&
                drType.arguments.size > BuiltInFunctionArity.BIG_ARITY

    if (extractExtensionReceiver != null) {
        extractExtensionReceiver(argParent)
    }
    */

    val idxOffset = if (extractExtensionReceiver != null) 1 else 0

    val argParent =
        /* OLD: KE1
        if (isBigArityFunctionInvoke) {
            extractArrayCreationWithInitializer(
                id,
                nValueArguments + idxOffset,
                locId,
                enclosingCallable,
                enclosingStmt
            )
        } else { */
            id
        //}

    extractValueArguments(argParent, idxOffset)
}

context(KaSession)
private fun KotlinFileExtractor.extractConstant(
    e: KtConstantExpression,
    enclosingCallable: Label<out DbCallable>, // OLD: KE1: ?,
    // TODO: Pass ExprParent rather than these 3?
    parent: Label<out DbExprparent>,
    idx: Int,
    enclosingStmt: Label<out DbStmt>, // OLD: KE1: ?,
    /*
    OLD: KE1
            overrideId: Label<out DbExpr>? = null
    */
): Label<out DbExpr>? {
    val text = e.text
    if (text == null) {
        TODO()
    }

    val elementType = e.node.elementType
    when (elementType) {
        KtNodeTypes.INTEGER_CONSTANT -> {
            val t = e.expressionType
            val i = parseNumericLiteral(text, elementType)
            println("=== parsed")
            println(text)
            println(i)
            println(i?.javaClass)
            when {
                i == null -> {
                    TODO()
                }

                t == null -> {
                    TODO()
                }

                t.isIntType || t.isShortType || t.isByteType -> {
                    extractConstantInteger(
                        text,
                        t,
                        i,
                        tw.getLocation(e),
                        parent,
                        idx,
                        enclosingCallable,
                        enclosingStmt,
                        /*
                        OLD: KE1
                                                    overrideId = overrideId
                        */
                    )
                }

                t.isLongType -> {
                    // OLD: KE1: Was: exprIdOrFresh<DbLongliteral>(overrideId).also { id ->
                    tw.getFreshIdLabel<DbLongliteral>().also { id ->
                        val type = useType(t)
                        val locId = tw.getLocation(e)
                        tw.writeExprs_longliteral(id, type.javaResult.id, parent, idx)
                        tw.writeExprsKotlinType(id, type.kotlinResult.id)
                        /*
                        OLD: KE1
                                                    extractExprContext(id, locId, enclosingCallable, enclosingStmt)
                        */
                        tw.writeNamestrings(text, i.toString(), id)
                    }
                }

                else -> {
                    TODO()
                }
            }
        }

        else -> {
            TODO()
        }
    }

    // TODO: Wrong
    return null
    /*
    OLD: KE1
            val v = e.value
            return when {
                v is Float -> {
                    exprIdOrFresh<DbFloatingpointliteral>(overrideId).also { id ->
                        val type = useType(e.type)
                        val locId = tw.getLocation(e)
                        tw.writeExprs_floatingpointliteral(id, type.javaResult.id, parent, idx)
                        tw.writeExprsKotlinType(id, type.kotlinResult.id)
                        extractExprContext(id, locId, enclosingCallable, enclosingStmt)
                        tw.writeNamestrings(v.toString(), v.toString(), id)
                    }
                }
                v is Double -> {
                    exprIdOrFresh<DbDoubleliteral>(overrideId).also { id ->
                        val type = useType(e.type)
                        val locId = tw.getLocation(e)
                        tw.writeExprs_doubleliteral(id, type.javaResult.id, parent, idx)
                        tw.writeExprsKotlinType(id, type.kotlinResult.id)
                        extractExprContext(id, locId, enclosingCallable, enclosingStmt)
                        tw.writeNamestrings(v.toString(), v.toString(), id)
                    }
                }
                v is Boolean -> {
                    exprIdOrFresh<DbBooleanliteral>(overrideId).also { id ->
                        val type = useType(e.type)
                        val locId = tw.getLocation(e)
                        tw.writeExprs_booleanliteral(id, type.javaResult.id, parent, idx)
                        tw.writeExprsKotlinType(id, type.kotlinResult.id)
                        extractExprContext(id, locId, enclosingCallable, enclosingStmt)
                        tw.writeNamestrings(v.toString(), v.toString(), id)
                    }
                }
                v is Char -> {
                    exprIdOrFresh<DbCharacterliteral>(overrideId).also { id ->
                        val type = useType(e.type)
                        val locId = tw.getLocation(e)
                        tw.writeExprs_characterliteral(id, type.javaResult.id, parent, idx)
                        tw.writeExprsKotlinType(id, type.kotlinResult.id)
                        extractExprContext(id, locId, enclosingCallable, enclosingStmt)
                        tw.writeNamestrings(v.toString(), v.toString(), id)
                    }
                }
                v is String -> {
                    exprIdOrFresh<DbStringliteral>(overrideId).also { id ->
                        val type = useType(e.type)
                        val locId = tw.getLocation(e)
                        tw.writeExprs_stringliteral(id, type.javaResult.id, parent, idx)
                        tw.writeExprsKotlinType(id, type.kotlinResult.id)
                        extractExprContext(id, locId, enclosingCallable, enclosingStmt)
                        tw.writeNamestrings(toQuotedLiteral(v.toString()), v.toString(), id)
                    }
                }
                v == null -> {
                    extractNull(
                        e.type,
                        tw.getLocation(e),
                        parent,
                        idx,
                        enclosingCallable,
                        enclosingStmt,
                        overrideId = overrideId
                    )
                }
                else -> {
                    null.also { logger.errorElement("Unrecognised IrConst: " + v.javaClass, e) }
                }
            }
    */
}

/*
    OLD: KE1
        private fun getStatementOriginOperator(origin: IrStatementOrigin?) =
            when (origin) {
                IrStatementOrigin.PLUSEQ -> "plus"
                IrStatementOrigin.MINUSEQ -> "minus"
                IrStatementOrigin.MULTEQ -> "times"
                IrStatementOrigin.DIVEQ -> "div"
                IrStatementOrigin.PERCEQ -> "rem"
                else -> null
            }

        private fun getUpdateInPlaceRHS(
            origin: IrStatementOrigin?,
            isExpectedLhs: (IrExpression?) -> Boolean,
            updateRhs: IrExpression
        ): IrExpression? {
            // Check for a desugared in-place update operator, such as "v += e":
            return getStatementOriginOperator(origin)?.let {
                if (updateRhs is IrCall && isNumericFunction(updateRhs.symbol.owner, it)) {
                    // Check for an expression like x = get(x).op(e):
                    val opReceiver = updateRhs.dispatchReceiver
                    if (isExpectedLhs(opReceiver)) {
                        updateRhs.getValueArgument(0)
                    } else null
                } else null
            }
        }

        private fun writeUpdateInPlaceExpr(
            origin: IrStatementOrigin
        ): ((
            tw: TrapWriter,
            id: Label<out DbAssignexpr>,
            type: Label<out DbType>,
            exprParent: Label<out DbExprparent>,
            index: Int
        ) -> Unit)? {
            when (origin) {
                IrStatementOrigin.PLUSEQ ->
                    return {
                        tw: TrapWriter,
                        id: Label<out DbAssignexpr>,
                        type: Label<out DbType>,
                        exprParent: Label<out DbExprparent>,
                        index: Int ->
                        tw.writeExprs_assignaddexpr(id.cast<DbAssignaddexpr>(), type, exprParent, index)
                    }
                IrStatementOrigin.MINUSEQ ->
                    return {
                        tw: TrapWriter,
                        id: Label<out DbAssignexpr>,
                        type: Label<out DbType>,
                        exprParent: Label<out DbExprparent>,
                        index: Int ->
                        tw.writeExprs_assignsubexpr(id.cast<DbAssignsubexpr>(), type, exprParent, index)
                    }
                IrStatementOrigin.MULTEQ ->
                    return {
                        tw: TrapWriter,
                        id: Label<out DbAssignexpr>,
                        type: Label<out DbType>,
                        exprParent: Label<out DbExprparent>,
                        index: Int ->
                        tw.writeExprs_assignmulexpr(id.cast<DbAssignmulexpr>(), type, exprParent, index)
                    }
                IrStatementOrigin.DIVEQ ->
                    return {
                        tw: TrapWriter,
                        id: Label<out DbAssignexpr>,
                        type: Label<out DbType>,
                        exprParent: Label<out DbExprparent>,
                        index: Int ->
                        tw.writeExprs_assigndivexpr(id.cast<DbAssigndivexpr>(), type, exprParent, index)
                    }
                IrStatementOrigin.PERCEQ ->
                    return {
                        tw: TrapWriter,
                        id: Label<out DbAssignexpr>,
                        type: Label<out DbType>,
                        exprParent: Label<out DbExprparent>,
                        index: Int ->
                        tw.writeExprs_assignremexpr(id.cast<DbAssignremexpr>(), type, exprParent, index)
                    }
                else -> return null
            }
        }

        /**
         * This method tries to extract a block as an enhanced for loop. It returns true if it succeeds,
         * and false otherwise.
         */
        private fun tryExtractForLoop(
            e: IrContainerExpression,
            callable: Label<out DbCallable>,
            parent: StmtExprParent
        ): Boolean {
            /*
             * We're expecting the pattern
             * {
             *   val iterator = [expr].iterator()
             *   while (iterator.hasNext()) {
             *    val [loopVar] = iterator.next()
             *    [block]
             *   }
             * }
             */

            if (e.origin != IrStatementOrigin.FOR_LOOP || e.statements.size != 2) {
                return false
            }

            val iteratorVariable = e.statements[0] as? IrVariable
            val innerWhile = e.statements[1] as? IrWhileLoop

            if (
                iteratorVariable == null ||
                    iteratorVariable.origin != IrDeclarationOrigin.FOR_LOOP_ITERATOR ||
                    innerWhile == null ||
                    innerWhile.origin != IrStatementOrigin.FOR_LOOP_INNER_WHILE
            ) {
                return false
            }

            val initializer = iteratorVariable.initializer as? IrCall
            if (
                initializer == null ||
                    initializer.origin != IrStatementOrigin.FOR_LOOP_ITERATOR ||
                    initializer.symbol.owner.name.asString() != "iterator"
            ) {
                return false
            }

            val expr = initializer.dispatchReceiver
            val cond = innerWhile.condition as? IrCall
            val body = innerWhile.body as? IrBlock

            if (
                expr == null ||
                    cond == null ||
                    cond.origin != IrStatementOrigin.FOR_LOOP_HAS_NEXT ||
                    (cond.dispatchReceiver as? IrGetValue)?.symbol?.owner != iteratorVariable ||
                    body == null ||
                    body.origin != IrStatementOrigin.FOR_LOOP_INNER_WHILE ||
                    body.statements.size < 2
            ) {
                return false
            }

            val loopVar = body.statements[0] as? IrVariable
            val nextCall = loopVar?.initializer as? IrCall

            if (
                loopVar == null ||
                    !(loopVar.origin == IrDeclarationOrigin.FOR_LOOP_VARIABLE ||
                        loopVar.origin == IrDeclarationOrigin.IR_TEMPORARY_VARIABLE) ||
                    nextCall == null ||
                    nextCall.origin != IrStatementOrigin.FOR_LOOP_NEXT ||
                    (nextCall.dispatchReceiver as? IrGetValue)?.symbol?.owner != iteratorVariable
            ) {
                return false
            }

            val id =
                extractLoop(innerWhile, null, parent, callable) { p, idx ->
                    tw.getFreshIdLabel<DbEnhancedforstmt>().also {
                        tw.writeStmts_enhancedforstmt(it, p, idx, callable)
                    }
                }

            extractVariableExpr(loopVar, callable, id, 0, id, extractInitializer = false)
            extractExpressionExpr(expr, callable, id, 1, id)
            val block = body.statements[1] as? IrBlock
            if (body.statements.size == 2 && block != null) {
                // Extract the body that was given to us by the compiler
                extractExpressionStmt(block, callable, id, 2)
            } else {
                // Extract a block with all but the first (loop variable declaration) statement
                extractBlock(body, body.statements.takeLast(body.statements.size - 1), id, 2, callable)
            }

            return true
        }

        /**
         * This tried to extract a block as an array update. It returns true if it succeeds, and false
         * otherwise.
         */
        private fun tryExtractArrayUpdate(
            e: IrContainerExpression,
            callable: Label<out DbCallable>,
            parent: StmtExprParent
        ): Boolean {
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
            if (e.statements.size != 3) return false
            (e.statements[0] as? IrVariable)?.let { arrayVarDecl ->
                arrayVarDecl.initializer?.let { arrayVarInitializer ->
                    (e.statements[1] as? IrVariable)?.let { indexVarDecl ->
                        indexVarDecl.initializer?.let { indexVarInitializer ->
                            (e.statements[2] as? IrCall)?.let { arraySetCall ->
                                if (
                                    isFunction(
                                        arraySetCall.symbol.owner,
                                        "kotlin",
                                        "(some array type)",
                                        { isArrayType(it) },
                                        "set"
                                    )
                                ) {
                                    val updateRhs0 = arraySetCall.getValueArgument(1)
                                    if (updateRhs0 == null) {
                                        logger.errorElement("Update RHS not found", e)
                                        return false
                                    }
                                    getUpdateInPlaceRHS(
                                            e
                                                .origin, // Using e.origin not arraySetCall.origin here
                                                         // distinguishes a compiler-generated block
                                                         // from a user manually code that looks the
                                                         // same.
                                            { oldValue ->
                                                oldValue is IrCall &&
                                                    isFunction(
                                                        oldValue.symbol.owner,
                                                        "kotlin",
                                                        "(some array type)",
                                                        { typeName -> isArrayType(typeName) },
                                                        "get"
                                                    ) &&
                                                    (oldValue.dispatchReceiver as? IrGetValue)?.let {
                                                        receiverVal ->
                                                        receiverVal.symbol.owner ==
                                                            arrayVarDecl.symbol.owner
                                                    } ?: false
                                            },
                                            updateRhs0
                                        )
                                        ?.let { updateRhs ->
                                            val origin = e.origin
                                            if (origin == null) {
                                                logger.errorElement("No origin found", e)
                                                return false
                                            }
                                            val writeUpdateInPlaceExprFun =
                                                writeUpdateInPlaceExpr(origin)
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
                                            extractExprContext(
                                                assignId,
                                                locId,
                                                callable,
                                                exprParent.enclosingStmt
                                            )

                                            writeUpdateInPlaceExprFun(
                                                tw,
                                                assignId,
                                                type.javaResult.id,
                                                exprParent.parent,
                                                exprParent.idx
                                            )

                                            // Extract e1[e2]
                                            val lhsId = tw.getFreshIdLabel<DbArrayaccess>()
                                            val elementType = useType(updateRhs.type)
                                            tw.writeExprs_arrayaccess(
                                                lhsId,
                                                elementType.javaResult.id,
                                                assignId,
                                                0
                                            )
                                            tw.writeExprsKotlinType(lhsId, elementType.kotlinResult.id)
                                            extractExprContext(
                                                lhsId,
                                                locId,
                                                callable,
                                                exprParent.enclosingStmt
                                            )
                                            extractExpressionExpr(
                                                arrayVarInitializer,
                                                callable,
                                                lhsId,
                                                0,
                                                exprParent.enclosingStmt
                                            )
                                            extractExpressionExpr(
                                                indexVarInitializer,
                                                callable,
                                                lhsId,
                                                1,
                                                exprParent.enclosingStmt
                                            )

                                            // Extract e3
                                            extractExpressionExpr(
                                                updateRhs,
                                                callable,
                                                assignId,
                                                1,
                                                exprParent.enclosingStmt
                                            )

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


        private fun extractArrayCreationWithInitializer(
            parent: Label<out DbExprparent>,
            arraySize: Int,
            locId: Label<DbLocation>,
            enclosingCallable: Label<out DbCallable>,
            enclosingStmt: Label<out DbStmt>
        ): Label<DbArrayinit> {

            val arrayCreationId = tw.getFreshIdLabel<DbArraycreationexpr>()
            val arrayType =
                pluginContext.irBuiltIns.arrayClass.typeWith(pluginContext.irBuiltIns.anyNType)
            val at = useType(arrayType)
            tw.writeExprs_arraycreationexpr(arrayCreationId, at.javaResult.id, parent, 0)
            tw.writeExprsKotlinType(arrayCreationId, at.kotlinResult.id)
            extractExprContext(arrayCreationId, locId, enclosingCallable, enclosingStmt)

            extractTypeAccessRecursive(
                pluginContext.irBuiltIns.anyNType,
                locId,
                arrayCreationId,
                -1,
                enclosingCallable,
                enclosingStmt
            )

            val initId = tw.getFreshIdLabel<DbArrayinit>()
            tw.writeExprs_arrayinit(initId, at.javaResult.id, arrayCreationId, -2)
            tw.writeExprsKotlinType(initId, at.kotlinResult.id)
            extractExprContext(initId, locId, enclosingCallable, enclosingStmt)

            extractConstantInteger(
                arraySize,
                locId,
                arrayCreationId,
                0,
                enclosingCallable,
                enclosingStmt
            )

            return initId
        }

        private fun extractTypeOperatorCall(
            e: IrTypeOperatorCall,
            callable: Label<out DbCallable>,
            parent: Label<out DbExprparent>,
            idx: Int,
            enclosingStmt: Label<out DbStmt>
        ) {
            with("type operator call", e) {
                when (e.operator) {
                    IrTypeOperator.IMPLICIT_CAST -> {
                        val id = tw.getFreshIdLabel<DbImplicitcastexpr>()
                        val locId = tw.getLocation(e)
                        val type = useType(e.type)
                        tw.writeExprs_implicitcastexpr(id, type.javaResult.id, parent, idx)
                        tw.writeExprsKotlinType(id, type.kotlinResult.id)
                        extractExprContext(id, locId, callable, enclosingStmt)
                        extractTypeAccessRecursive(e.typeOperand, locId, id, 0, callable, enclosingStmt)
                        extractExpressionExpr(e.argument, callable, id, 1, enclosingStmt)
                    }
                    IrTypeOperator.IMPLICIT_NOTNULL -> {
                        val id = tw.getFreshIdLabel<DbImplicitnotnullexpr>()
                        val locId = tw.getLocation(e)
                        val type = useType(e.type)
                        tw.writeExprs_implicitnotnullexpr(id, type.javaResult.id, parent, idx)
                        tw.writeExprsKotlinType(id, type.kotlinResult.id)
                        extractExprContext(id, locId, callable, enclosingStmt)
                        extractTypeAccessRecursive(e.typeOperand, locId, id, 0, callable, enclosingStmt)
                        extractExpressionExpr(e.argument, callable, id, 1, enclosingStmt)
                    }
                    IrTypeOperator.IMPLICIT_COERCION_TO_UNIT -> {
                        val id = tw.getFreshIdLabel<DbImplicitcoerciontounitexpr>()
                        val locId = tw.getLocation(e)
                        val type = useType(e.type)
                        tw.writeExprs_implicitcoerciontounitexpr(id, type.javaResult.id, parent, idx)
                        tw.writeExprsKotlinType(id, type.kotlinResult.id)
                        extractExprContext(id, locId, callable, enclosingStmt)
                        extractTypeAccessRecursive(e.typeOperand, locId, id, 0, callable, enclosingStmt)
                        extractExpressionExpr(e.argument, callable, id, 1, enclosingStmt)
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
                              public override Boolean accept(Integer i) { return <fn>.invoke(i); }
                          }

                          IntPredicate x = (IntPredicate)new <Anon>(...);
                          ```
                        */

                        val st = e.argument.type as? IrSimpleType
                        if (st == null) {
                            logger.errorElement("Expected to find a simple type in SAM conversion.", e)
                            return
                        }

                        fun IrSimpleType.isKProperty() =
                            classFqName?.asString()?.startsWith("kotlin.reflect.KProperty") == true

                        if (
                            !st.isFunctionOrKFunction() &&
                                !st.isSuspendFunctionOrKFunction() &&
                                !st.isKProperty()
                        ) {
                            logger.errorElement(
                                "Expected to find expression with function type in SAM conversion.",
                                e
                            )
                            return
                        }

                        // Either Function1, ... Function22 or FunctionN type, but not Function23 or
                        // above.
                        val functionType = getFunctionalInterfaceTypeWithTypeArgs(st.arguments)
                        if (functionType == null) {
                            logger.errorElement("Cannot find functional interface.", e)
                            return
                        }

                        val invokeMethod =
                            functionType.classOrNull?.owner?.declarations?.findSubType<IrFunction> {
                                it.name.asString() == OperatorNameConventions.INVOKE.asString()
                            }
                        if (invokeMethod == null) {
                            logger.errorElement(
                                "Couldn't find `invoke` method on functional interface.",
                                e
                            )
                            return
                        }

                        val typeOwner = e.typeOperand.classifierOrFail.owner
                        if (typeOwner !is IrClass) {
                            logger.errorElement(
                                "Expected to find SAM conversion to IrClass. Found '${typeOwner.javaClass}' instead. Can't implement SAM interface.",
                                e
                            )
                            return
                        }
                        val samMember =
                            typeOwner.declarations.findSubType<IrFunction> {
                                it is IrOverridableMember && it.modality == Modality.ABSTRACT
                            }
                        if (samMember == null) {
                            logger.errorElement(
                                "Couldn't find SAM member in type '${typeOwner.kotlinFqName.asString()}'. Can't implement SAM interface.",
                                e
                            )
                            return
                        }

                        val javaResult = TypeResult(tw.getFreshIdLabel<DbClassorinterface>(), "", "")
                        val kotlinResult = TypeResult(tw.getFreshIdLabel<DbKt_notnull_type>(), "", "")
                        tw.writeKt_notnull_types(kotlinResult.id, javaResult.id)
                        val ids =
                            LocallyVisibleFunctionLabels(
                                TypeResults(javaResult, kotlinResult),
                                constructor = tw.getFreshIdLabel(),
                                constructorBlock = tw.getFreshIdLabel(),
                                function = tw.getFreshIdLabel()
                            )

                        val locId = tw.getLocation(e)
                        val helper = GeneratedClassHelper(locId, ids)

                        val declarationParent = peekDeclStackAsDeclarationParent(e) ?: return
                        val classId =
                            extractGeneratedClass(
                                ids,
                                listOf(pluginContext.irBuiltIns.anyType, e.typeOperand),
                                locId,
                                e,
                                declarationParent
                            )

                        // add field
                        val fieldId = tw.getFreshIdLabel<DbField>()
                        extractField(
                            fieldId,
                            "<fn>",
                            functionType,
                            classId,
                            locId,
                            DescriptorVisibilities.PRIVATE,
                            e,
                            isExternalDeclaration = false,
                            isFinal = true,
                            isStatic = false
                        )

                        // adjust constructor
                        helper.extractParameterToFieldAssignmentInConstructor(
                            "<fn>",
                            functionType,
                            fieldId,
                            0,
                            1
                        )

                        // add implementation function
                        val classTypeArgs = (e.type as? IrSimpleType)?.arguments
                        val typeSub =
                            classTypeArgs?.let { makeGenericSubstitutionFunction(typeOwner, it) }

                        fun trySub(t: IrType, context: TypeContext) =
                            if (typeSub == null) t else typeSub(t, context, pluginContext)

                        // Force extraction of this function even if this is a fake override --
                        // This happens in the case where a functional interface inherits its only
                        // abstract member,
                        // which usually we wouldn't extract, but in this case we're effectively using
                        // it as a template
                        // for the real function we're extracting that will implement this interface,
                        // and it serves fine
                        // for that purpose. By contrast if we looked through the fake to the underlying
                        // abstract method
                        // we would need to compose generic type substitutions -- for example, if we're
                        // implementing
                        // T UnaryOperator<T>.apply(T t) here, we would need to compose substitutions so
                        // we can implement
                        // the real underlying R Function<T, R>.apply(T t).
                        forceExtractFunction(
                            samMember,
                            classId,
                            extractBody = false,
                            extractMethodAndParameterTypeAccesses = true,
                            extractAnnotations = false,
                            typeSub,
                            classTypeArgs,
                            overriddenAttributes =
                                OverriddenFunctionAttributes(
                                    id = ids.function,
                                    sourceLoc = tw.getLocation(e),
                                    modality = Modality.FINAL
                                )
                        )

                        addModifiers(ids.function, "override")
                        if (st.isSuspendFunctionOrKFunction()) {
                            addModifiers(ids.function, "suspend")
                        }

                        // body
                        val blockId = extractBlockBody(ids.function, locId)

                        // return stmt
                        val returnId = tw.getFreshIdLabel<DbReturnstmt>()
                        tw.writeStmts_returnstmt(returnId, blockId, 0, ids.function)
                        tw.writeHasLocation(returnId, locId)

                        // <fn>.invoke(vp0, cp1, vp2, vp3, ...) or
                        // <fn>.invoke(new Object[x]{vp0, vp1, vp2, ...})

                        // Call to original `invoke`:
                        val callId = tw.getFreshIdLabel<DbMethodaccess>()
                        val callType = useType(trySub(samMember.returnType, TypeContext.RETURN))
                        tw.writeExprs_methodaccess(callId, callType.javaResult.id, returnId, 0)
                        tw.writeExprsKotlinType(callId, callType.kotlinResult.id)
                        extractExprContext(callId, locId, ids.function, returnId)
                        val calledMethodId = useFunction<DbMethod>(invokeMethod, functionType.arguments)
                        if (calledMethodId == null) {
                            logger.errorElement("Cannot get ID for called method", invokeMethod)
                        } else {
                            tw.writeCallableBinding(callId, calledMethodId)
                        }

                        // <fn> access
                        val lhsId = tw.getFreshIdLabel<DbVaraccess>()
                        val lhsType = useType(functionType)
                        tw.writeExprs_varaccess(lhsId, lhsType.javaResult.id, callId, -1)
                        tw.writeExprsKotlinType(lhsId, lhsType.kotlinResult.id)
                        extractExprContext(lhsId, locId, ids.function, returnId)
                        tw.writeVariableBinding(lhsId, fieldId)

                        val parameters = mutableListOf<IrValueParameter>()
                        val extParam = samMember.extensionReceiverParameter
                        if (extParam != null) {
                            parameters.add(extParam)
                        }
                        parameters.addAll(samMember.valueParameters)

                        fun extractArgument(
                            p: IrValueParameter,
                            idx: Int,
                            parent: Label<out DbExprparent>
                        ) {
                            val argsAccessId = tw.getFreshIdLabel<DbVaraccess>()
                            val paramType = useType(trySub(p.type, TypeContext.OTHER))
                            tw.writeExprs_varaccess(argsAccessId, paramType.javaResult.id, parent, idx)
                            tw.writeExprsKotlinType(argsAccessId, paramType.kotlinResult.id)
                            extractExprContext(argsAccessId, locId, ids.function, returnId)
                            tw.writeVariableBinding(argsAccessId, useValueParameter(p, ids.function))
                        }

                        val isBigArity = st.arguments.size > BuiltInFunctionArity.BIG_ARITY
                        val argParent =
                            if (isBigArity) {
                                // <fn>.invoke(new Object[x]{vp0, vp1, vp2, ...})
                                extractArrayCreationWithInitializer(
                                    callId,
                                    parameters.size,
                                    locId,
                                    ids.function,
                                    returnId
                                )
                            } else {
                                // <fn>.invoke(vp0, cp1, vp2, vp3, ...) or
                                callId
                            }

                        for ((parameterIdx, vp) in parameters.withIndex()) {
                            extractArgument(vp, parameterIdx, argParent)
                        }

                        val id = tw.getFreshIdLabel<DbCastexpr>()
                        val type = useType(e.typeOperand)
                        tw.writeExprs_castexpr(id, type.javaResult.id, parent, idx)
                        tw.writeExprsKotlinType(id, type.kotlinResult.id)
                        extractExprContext(id, locId, callable, enclosingStmt)
                        extractTypeAccessRecursive(e.typeOperand, locId, id, 0, callable, enclosingStmt)

                        val idNewexpr =
                            extractNewExpr(
                                ids.constructor,
                                ids.type,
                                locId,
                                id,
                                1,
                                callable,
                                enclosingStmt
                            )

                        tw.writeIsAnonymClass(
                            ids.type.javaResult.id.cast<DbClassorinterface>(),
                            idNewexpr
                        )

                        extractTypeAccessRecursive(
                            e.typeOperand,
                            locId,
                            idNewexpr,
                            -3,
                            callable,
                            enclosingStmt
                        )

                        extractExpressionExpr(e.argument, callable, idNewexpr, 0, enclosingStmt)
                    }
                    else -> {
                        logger.errorElement(
                            "Unrecognised IrTypeOperatorCall for ${e.operator}: " + e.render(),
                            e
                        )
                    }
                }
            }
        }
 */

private fun KotlinFileExtractor.extractBreakContinue(e: KtExpressionWithLabel, id: Label<out DbNamedexprorstmt>) {
    with("break/continue", e) {
        val locId = tw.getLocation(e)
        tw.writeHasLocation(id, locId)
        val label = e.getLabelName()
        if (label != null) {
            tw.writeNamestrings(label, "", id)
        }
    }
}

/*
OLD KE1:
private fun KotlinFileExtractor.getVariableLocationProvider(v: KtProperty): IrElement {
    val init = v.initializer
    if (v.startOffset < 0 && init != null) {
        // IR_TEMPORARY_VARIABLEs have no proper location
        return init
    }

    return v
}
*/

context(KaSession)
private fun KotlinFileExtractor.extractVariable(
    v: KtProperty,
    callable: Label<out DbCallable>,
    parent: Label<out DbStmtparent>,
    idx: Int
) {
    with("variable", v) {
        val stmtId = tw.getFreshIdLabel<DbLocalvariabledeclstmt>()
        val locId = tw.getLocation(v) // OLD KE1: getVariableLocationProvider(v))
        tw.writeStmts_localvariabledeclstmt(stmtId, parent, idx, callable)
        tw.writeHasLocation(stmtId, locId)
        extractVariableExpr(v, callable, stmtId, 1, stmtId)
    }
}

context(KaSession)
private fun KotlinFileExtractor.extractVariableExpr(
    v: KtProperty,
    callable: Label<out DbCallable>,
    parent: Label<out DbExprparent>,
    idx: Int,
    enclosingStmt: Label<out DbStmt>,
    //extractInitializer: Boolean = true  // OLD KE1
) {
    with("variable expr", v) {
        val varId = useVariable(v)
        val exprId = tw.getFreshIdLabel<DbLocalvariabledeclexpr>()
        val locId = tw.getLocation(v) // OLD KE1: getVariableLocationProvider(v))
        val type = useType(v.returnType)
        tw.writeLocalvars(varId, v.name!!, type.javaResult.id, exprId)
        tw.writeLocalvarsKotlinType(varId, type.kotlinResult.id)
        tw.writeHasLocation(varId, locId)
        tw.writeExprs_localvariabledeclexpr(exprId, type.javaResult.id, parent, idx)
        tw.writeExprsKotlinType(exprId, type.kotlinResult.id)
        extractExprContext(exprId, locId, callable, enclosingStmt)
        val i = v.initializer
        //OLD KE1: if (i != null && extractInitializer) {
        if (i != null) {
            extractExpressionExpr(i, callable, exprId, 0, enclosingStmt)
        }
        if (!v.isVar) {
            addModifiers(varId, "final")
        }
        /*
        OLD KE1:
        if (v.isLateinit) {
            addModifiers(varId, "lateinit")
        }
        */
    }
}

private fun KotlinFileExtractor.useVariable(v: KtProperty): Label<out DbLocalvar> {
    return tw.getVariableLabelFor<DbLocalvar>(v)
}
