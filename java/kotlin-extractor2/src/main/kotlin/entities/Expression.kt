package com.github.codeql

import com.github.codeql.KotlinFileExtractor.StmtExprParent
import org.jetbrains.kotlin.KtNodeTypes
import org.jetbrains.kotlin.analysis.api.KaSession
import org.jetbrains.kotlin.analysis.api.resolution.*
import org.jetbrains.kotlin.analysis.api.symbols.KaFunctionSymbol
import org.jetbrains.kotlin.analysis.api.symbols.KaPropertySymbol
import org.jetbrains.kotlin.analysis.api.symbols.KaVariableSymbol
import org.jetbrains.kotlin.analysis.api.types.KaType
import org.jetbrains.kotlin.analysis.api.types.KaTypeNullability
import org.jetbrains.kotlin.analysis.api.types.symbol
import org.jetbrains.kotlin.lexer.KtToken
import org.jetbrains.kotlin.lexer.KtTokens
import org.jetbrains.kotlin.name.CallableId
import org.jetbrains.kotlin.name.ClassId
import org.jetbrains.kotlin.name.FqName
import org.jetbrains.kotlin.name.Name
import org.jetbrains.kotlin.parsing.parseNumericLiteral
import org.jetbrains.kotlin.psi.*
import org.jetbrains.kotlin.utils.mapToIndex

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

fun KotlinFileExtractor.extractExprContext(
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

context(KaSession)
private fun KotlinFileExtractor.extractPrefixUnaryExpression(
    expression: KtPrefixExpression,
    callable: Label<out DbCallable>,
    parent: StmtExprParent
): Label<out DbExpr> {
    val op = expression.operationToken as? KtToken
    val target = ((expression.resolveToCall() as? KaSuccessCallInfo)?.call as? KaSimpleFunctionCall)?.symbol

    if (target == null) {
        TODO("Extract error expression")
    }

    val trapWriterWriteExpr = when {
        op == KtTokens.PLUS && target.isNumericWithName("unaryPlus") -> tw::writeExprs_plusexpr
        op == KtTokens.MINUS && target.isNumericWithName("unaryMinus") -> tw::writeExprs_minusexpr
        op == KtTokens.EXCL && target.hasName("kotlin", "Boolean", "not") -> tw::writeExprs_lognotexpr
        else -> null
    }

    if (trapWriterWriteExpr != null) {
        return extractUnaryExpression(expression, callable, parent, trapWriterWriteExpr)
    }

    TODO("Extract as method call")
}

context(KaSession)
private fun KotlinFileExtractor.extractPostfixUnaryExpression(
    expression: KtPostfixExpression,
    callable: Label<out DbCallable>,
    parent: StmtExprParent
): Label<out DbExpr> {
    val op = expression.operationToken as? KtToken
    val target =
        ((expression.resolveToCall() as? KaSuccessCallInfo)?.call as? KaCompoundAccessCall)?.compoundAccess?.operationPartiallyAppliedSymbol?.symbol

    if (target == null) {
        TODO("Extract error expression")
    }

    val trapWriterWriteExpr = when {
        op == KtTokens.PLUSPLUS && target.isNumericWithName("inc") -> tw::writeExprs_postincexpr
        op == KtTokens.MINUSMINUS && target.isNumericWithName("dec") -> tw::writeExprs_postdecexpr
        else -> null
    }

    if (trapWriterWriteExpr != null) {
        return extractUnaryExpression(expression, callable, parent, trapWriterWriteExpr)
    }

    TODO("Extract as method call")
}

context(KaSession)
fun KtExpression.resolveCallTarget(): KaCallableMemberCall<*, *>? {
    val callInfo = this.resolveToCall() as? KaSuccessCallInfo
    val functionCall = callInfo?.call as? KaCallableMemberCall<*, *>
    return functionCall
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
): Label<out DbExpr> {
    val op = expression.operationToken
    val target = expression.resolveCallTarget()?.symbol as? KaFunctionSymbol?

    if (target == null) {
        val trapWriterWriteExpr = when (op) {
            KtTokens.EQEQEQ -> tw::writeExprs_eqexpr
            KtTokens.EXCLEQEQEQ -> tw::writeExprs_neexpr
            else -> TODO("Extract error expression")
        }

        return extractBinaryExpression(expression, callable, parent, trapWriterWriteExpr)
    }

    val trapWriterWriteExpr = when {
        op == KtTokens.PLUS && target.isBinaryPlus() -> tw::writeExprs_addexpr
        op == KtTokens.MINUS && target.isNumericWithName("minus") -> tw::writeExprs_subexpr
        op == KtTokens.MUL && target.isNumericWithName("times") -> tw::writeExprs_mulexpr
        op == KtTokens.DIV && target.isNumericWithName("div") -> tw::writeExprs_divexpr
        op == KtTokens.PERC && target.isNumericWithName("rem") -> tw::writeExprs_remexpr
        op == KtTokens.IDENTIFIER && target.isNumericWithName("and") -> tw::writeExprs_andbitexpr
        op == KtTokens.IDENTIFIER && target.isNumericWithName("or") -> tw::writeExprs_orbitexpr
        op == KtTokens.IDENTIFIER && target.isNumericWithName("xor") -> tw::writeExprs_xorbitexpr
        op == KtTokens.IDENTIFIER && target.isNumericWithName("shl") -> tw::writeExprs_lshiftexpr
        op == KtTokens.IDENTIFIER && target.isNumericWithName("shr") -> tw::writeExprs_rshiftexpr
        op == KtTokens.IDENTIFIER && target.isNumericWithName("ushr") -> tw::writeExprs_urshiftexpr
        op == KtTokens.LT && target.isNumericWithName("compareTo") -> tw::writeExprs_ltexpr
        op == KtTokens.GT && target.isNumericWithName("compareTo") -> tw::writeExprs_gtexpr
        op == KtTokens.LTEQ && target.isNumericWithName("compareTo") -> tw::writeExprs_leexpr
        op == KtTokens.GTEQ && target.isNumericWithName("compareTo") -> tw::writeExprs_geexpr
        else -> null
    }

    if (trapWriterWriteExpr != null) {
        return extractBinaryExpression(expression, callable, parent, trapWriterWriteExpr)
    }

    val trapWriterWriteExprComparison = when (op) {
        KtTokens.LT -> tw::writeExprs_ltexpr
        KtTokens.GT -> tw::writeExprs_gtexpr
        KtTokens.LTEQ -> tw::writeExprs_leexpr
        KtTokens.GTEQ -> tw::writeExprs_geexpr
        else -> null
    }

    if (trapWriterWriteExprComparison != null) {
        // Extract lowered equivalent call, such as `a.compareTo(b) < 0` instead of `a < b` in the below:
        // ```
        //   fun test(a: Data, b: Data) {
        //     a < b
        //   }
        //
        //   class Data(val v: Int) : Comparable<Data> {
        //     override fun compareTo(other: Data) = v.compareTo(other.v)
        //   }
        // ```

        val exprParent = parent.expr(expression, callable)

        val id = extractRawBinaryExpression(builtinTypes.boolean, exprParent, trapWriterWriteExprComparison)
        extractExprContext(id, tw.getLocation(expression), callable, exprParent.enclosingStmt)

        extractRawMethodAccess(
            target,
            tw.getLocation(expression),
            target.returnType,
            callable,
            id,
            0,
            exprParent.enclosingStmt,
            if (target.isExtension) null else expression.left!!,
            if (target.isExtension) expression.left!! else null,
            listOf(expression.right!!)
        )

        extractConstantInteger(
            "0",
            builtinTypes.int,
            0,
            tw.getLocation(expression),
            id,
            1,
            callable,
            exprParent.enclosingStmt,
            /*
            OLD: KE1
                                        overrideId = overrideId
            */
        )

        return id
    }

    // todo: other operators, such as .., ..<, in, !in, =, +=, -=, *=, /=, %=, ==, !=,
    TODO("Extract as method call")
}


private fun KaFunctionSymbol.isBinaryPlus(): Boolean {
    return this.isNumericWithName("plus") ||
            this.hasName("kotlin", "String", "plus") ||
            /* The target for `(null as String?) + null` is `public operator fun String?.plus(other: Any?): String` */
            this.hasMatchingNames(
                CallableId(FqName("kotlin"), null, Name.identifier("plus")),
                ClassId(FqName("kotlin"), Name.identifier("String")),
                nullability = KaTypeNullability.NULLABLE,
            )
}

context(KaSession)
private fun <T : DbBinaryexpr> KotlinFileExtractor.extractRawBinaryExpression(
    expressionType: KaType,
    exprParent: KotlinFileExtractor.ExprParent,
    extractExpression: (
        id: Label<out T>,
        typeid: Label<out DbType>,
        parent: Label<out DbExprparent>,
        idx: Int
    ) -> Unit
): Label<T> {
    val id = tw.getFreshIdLabel<T>()
    val type = useType(expressionType)
    extractExpression(id, type.javaResult.id, exprParent.parent, exprParent.idx)
    tw.writeExprsKotlinType(id, type.kotlinResult.id)
    return id
}

context(KaSession)
private fun <T : DbBinaryexpr> KotlinFileExtractor.extractBinaryExpression(
    expression: KtBinaryExpression,
    callable: Label<out DbCallable>,
    parent: StmtExprParent,
    extractExpression: (
        id: Label<out T>,
        typeid: Label<out DbType>,
        parent: Label<out DbExprparent>,
        idx: Int
    ) -> Unit
): Label<out DbExpr> {
    val exprParent = parent.expr(expression, callable)
    val id = extractRawBinaryExpression(expression.expressionType!!, exprParent, extractExpression)

    extractExprContext(id, tw.getLocation(expression), callable, exprParent.enclosingStmt)
    extractExpressionExpr(expression.left!!, callable, id, 0, exprParent.enclosingStmt)
    extractExpressionExpr(expression.right!!, callable, id, 1, exprParent.enclosingStmt)

    return id
}

context(KaSession)
private fun <T : DbUnaryexpr> KotlinFileExtractor.extractUnaryExpression(
    expression: KtUnaryExpression,
    callable: Label<out DbCallable>,
    parent: StmtExprParent,
    extractExpression: (
        id: Label<out T>,
        typeid: Label<out DbType>,
        parent: Label<out DbExprparent>,
        idx: Int
    ) -> Unit
): Label<out DbExpr> {
    val id = tw.getFreshIdLabel<T>()
    val type = useType(expression.expressionType)
    val exprParent = parent.expr(expression, callable)
    extractExpression(id, type.javaResult.id, exprParent.parent, exprParent.idx)
    tw.writeExprsKotlinType(id, type.kotlinResult.id)

    extractExprContext(id, tw.getLocation(expression), callable, exprParent.enclosingStmt)
    extractExpressionExpr(expression.baseExpression!!, callable, id, 0, exprParent.enclosingStmt)

    return id
}

fun KotlinFileExtractor.drillIntoParenthesizedExpression(expr: KtExpression): Pair<KtExpression, Int> {
    var parensCount = 0
    var e = expr
    while (e is KtParenthesizedExpression) {
        parensCount++
        e = e.expression!!
    }

    return Pair(e, parensCount)
}

context(KaSession)
private fun KotlinFileExtractor.extractExpression(
    e: KtExpression,
    callable: Label<out DbCallable>,
    parent: StmtExprParent
): Label<out DbExpr>? {
    with("expression", e) {
        when (e) {
            is KtParenthesizedExpression -> {
                val (childExpr, parensCount) = drillIntoParenthesizedExpression(e)
                val id = extractExpression(childExpr, callable, parent)

                if (id == null) {
                    logger.errorElement("No expression extracted as the child of the parenthesized expression", e)
                } else {
                    tw.writeIsParenthesized(id, parensCount)
                }

                return id
            }

            is KtLabeledExpression -> {
                // TODO: we could handle this here, or in each child that might have a label
                // We're handling it in the children with the below
                return extractExpression(e.baseExpression!!, callable, parent)
            }

            is KtQualifiedExpression -> {
                // We're propagating the extraction to the child, and then getting the qualifier from the parent of the
                // child. The selector could be many expression kind, such as KtCallExpression, KtReferenceExpression,
                // and each of those would need to look for the qualifier
                return extractExpression(e.selectorExpression!!, callable, parent)
            }

            is KtPrefixExpression -> {
                return extractPrefixUnaryExpression(e, callable, parent)
            }

            is KtPostfixExpression -> {
                return extractPostfixUnaryExpression(e, callable, parent)
            }

            is KtBinaryExpression -> {
                return extractBinaryExpression(e, callable, parent)
            }

            is KtCallExpression -> {
                return extractMethodCall(e, callable, parent)
            }

            is KtReferenceExpression -> {
                return extractReferenceExpression(e, callable, parent)
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

                return id
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

                return id
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
                } else {
                    TODO()
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

            is KtIfExpression -> {
                return extractIf(e, parent, callable)
            }

            is KtWhenExpression -> {
                return extractWhen(e, parent, callable)
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
                            is IrCall -> {
                                extractCall(e, callable, parent)
                            }
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
                return extractConstant(
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
    }

    // In case of statements, we're returning null:
    return null
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

// TODO: Can this function be inlined?
context(KaSession)
private fun KotlinFileExtractor.extractStatement(
    s: KtExpression,
    callable: Label<out DbCallable>,
    parent: Label<out DbStmtparent>,
    idx: Int
) {
    with("statement", s) {
        when (s) {
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
                extractExpressionStmt(s, callable, parent, idx)
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
    */

private fun KotlinFileExtractor.extractVariableAccess(
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

private fun KotlinFileExtractor.extractVariableAccess(
    variable: Label<out DbVariable>?,
    type: KaType,
    locId: Label<DbLocation>,
    parent: Label<out DbExprparent>,
    idx: Int,
    callable: Label<out DbCallable>,
    enclosingStmt: Label<out DbStmt>
) =
    extractVariableAccess(
        variable,
        useType(type),
        locId,
        parent,
        idx,
        callable,
        enclosingStmt
    )

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
private fun KotlinFileExtractor.extractWhen(
    e: KtWhenExpression,
    parent: StmtExprParent,
    callable: Label<out DbCallable>
): Label<out DbExpr>? {
    val exprParent = parent.expr(e, callable)
    val id = tw.getFreshIdLabel<DbWhenexpr>()
    val type = useType(e.expressionType)
    val locId = tw.getLocation(e)
    tw.writeExprs_whenexpr(
        id,
        type.javaResult.id,
        exprParent.parent,
        exprParent.idx
    )
    tw.writeExprsKotlinType(id, type.kotlinResult.id)
    extractExprContext(id, locId, callable, exprParent.enclosingStmt)

    val subjectVariable = e.subjectVariable
    val subjectExpression = e.subjectExpression

    if (subjectVariable != null) {
        extractVariableExpr(subjectVariable, callable, id, -1, exprParent.enclosingStmt)
    } else if (subjectExpression != null) {
        extractExpressionExpr(subjectExpression, callable, id, -1, exprParent.enclosingStmt)
    }

    e.entries.forEachIndexed { i, b ->
        val bId = tw.getFreshIdLabel<DbWhenbranch>()
        val bLocId = tw.getLocation(b)
        tw.writeStmts_whenbranch(bId, id, i, callable)
        tw.writeHasLocation(bId, bLocId)
        for ((idx, cond) in b.conditions.withIndex()) {
            val condId = tw.getFreshIdLabel<DbWhenbranchcondition>()
            val locId = tw.getLocation(cond)
            tw.writeStmts_whenbranchcondition(condId, bId, -1 * idx, callable)
            tw.writeHasLocation(id, locId)

            when (cond) {
                is KtWhenConditionWithExpression -> {
                    tw.writeWhen_branch_condition_with_expr(condId)
                    extractExpressionExpr(
                        cond.expression!!,
                        callable,
                        condId,
                        0,
                        condId
                    )
                }

                is KtWhenConditionInRange -> {
                    // [!]in 1..10
                    tw.writeWhen_branch_condition_with_range(condId, cond.isNegated)
                    extractExpressionExpr(
                        cond.rangeExpression!!,
                        callable,
                        condId,
                        0,
                        condId
                    )
                }

                is KtWhenConditionIsPattern -> {
                    // [!]is Type
                    val type = useType(cond.typeReference?.type)
                    tw.writeWhen_branch_condition_with_pattern(
                        condId,
                        cond.isNegated,
                        type.javaResult.id,
                        type.kotlinResult.id
                    )
                }
            }
        }

        extractExpressionStmt(b.expression!!, callable, bId, 1)
        val guardExpr = b.guard?.getExpression()
        if (guardExpr != null) {
            extractExpressionStmt(guardExpr, callable, bId, 2)
        }

        if (b.isElse) {
            tw.writeWhen_branch_else(bId)
        }
    }

    return id
}

context(KaSession)
private fun KotlinFileExtractor.extractIf(
    ifStmt: KtIfExpression,
    stmtExprParent: StmtExprParent,
    callable: Label<out DbCallable>
): Label<out DbExpr>? {
    if (!ifStmt.isUsedAsExpression) {
        // We're extracting this `if` as a statement
        val stmtParent = stmtExprParent.stmt(ifStmt, callable)
        val id = tw.getFreshIdLabel<DbIfstmt>()
        val locId = tw.getLocation(ifStmt)
        tw.writeStmts_ifstmt(id, stmtParent.parent, stmtParent.idx, callable)
        tw.writeHasLocation(id, locId)

        extractExpressionExpr(ifStmt.condition!!, callable, id, 0, id)
        extractExpressionStmt(ifStmt.then!!, callable, id, 1)
        val elseBranch = ifStmt.`else`
        if (elseBranch != null) {
            extractExpressionStmt(elseBranch, callable, id, 2)
        }

        return null
    }

    // We're extracting this `if` as a conditional expression
    val exprParent = stmtExprParent.expr(ifStmt, callable)
    val id = tw.getFreshIdLabel<DbConditionalexpr>()
    val type = useType(ifStmt.expressionType)
    tw.writeExprs_conditionalexpr(id, type.javaResult.id, exprParent.parent, exprParent.idx)
    tw.writeExprsKotlinType(id, type.kotlinResult.id)

    extractExprContext(id, tw.getLocation(ifStmt), callable, exprParent.enclosingStmt)

    extractExpressionExpr(ifStmt.condition!!, callable, id, 0, exprParent.enclosingStmt)
    extractExpressionExpr(ifStmt.then!!, callable, id, 1, exprParent.enclosingStmt)
    extractExpressionExpr(ifStmt.`else`!!, callable, id, 2, exprParent.enclosingStmt)

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
): Label<out DbExpr> {
    val text = e.text
    if (text == null) {
        TODO()
    }

    val elementType = e.node.elementType
    when (elementType) {
        KtNodeTypes.INTEGER_CONSTANT -> {
            val t = e.expressionType
            val i = parseNumericLiteral(text, elementType)
            when {
                i == null -> {
                    TODO()
                }

                t == null -> {
                    TODO()
                }

                t.isIntType || t.isShortType || t.isByteType -> {
                    return extractConstantInteger(
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
                    return tw.getFreshIdLabel<DbLongliteral>().also { id ->
                        val type = useType(t)
                        val locId = tw.getLocation(e)
                        tw.writeExprs_longliteral(id, type.javaResult.id, parent, idx)
                        tw.writeExprsKotlinType(id, type.kotlinResult.id)
                        extractExprContext(id, locId, enclosingCallable, enclosingStmt)
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
    return TODO()
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
): Label<out DbStmt> {
    with("variable", v) {
        val stmtId = tw.getFreshIdLabel<DbLocalvariabledeclstmt>()
        val locId = tw.getLocation(v) // OLD KE1: getVariableLocationProvider(v))
        tw.writeStmts_localvariabledeclstmt(stmtId, parent, idx, callable)
        tw.writeHasLocation(stmtId, locId)
        extractVariableExpr(v, callable, stmtId, 1, stmtId)
        return stmtId
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
        val varId = useVariable(v.symbol)
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

private fun KotlinFileExtractor.useVariable(v: KaVariableSymbol): Label<out DbLocalvar> {
    return tw.getVariableLabelFor<DbLocalvar>(v)
}

context(KaSession)
fun KotlinFileExtractor.extractReferenceExpression(
    ref: KtReferenceExpression,
    enclosingCallable: Label<out DbCallable>,
    stmtExprParent: StmtExprParent
): Label<out DbExpr> {
    val exprParent = stmtExprParent.expr(ref, enclosingCallable)

    when (val resolvedCall = ref.resolveCallTarget()) {
        is KaSimpleVariableAccessCall -> {
            when (val varSymbol = resolvedCall.symbol) {
                is KaPropertySymbol -> {
                    // Note this could be a native Kotlin property, or a synthetic one for a Java object inferred
                    // from getters/setters.
                    val (target, args) = when (val access = resolvedCall.simpleAccess) {
                        is KaSimpleVariableAccess.Read -> Pair(varSymbol.getter, listOf())
                        is KaSimpleVariableAccess.Write -> Pair(varSymbol.setter, listOf(access.value))
                    }

                    val qualifier: KtExpression? = (ref.parent as? KtQualifiedExpression)?.receiverExpression

                    if (target == null) {
                        TODO()
                    }

                    return extractRawMethodAccess(
                        target,
                        tw.getLocation(ref),
                        ref.expressionType!!,
                        enclosingCallable,
                        exprParent.parent,
                        exprParent.idx,
                        exprParent.enclosingStmt,
                        qualifier,
                        null,
                        args
                    )
                }

                else -> {
                    // TODO: field access, enum entries, others?
                    // but aren't property accesses?
                    return extractVariableAccess(
                        useVariable(varSymbol),
                        varSymbol.returnType,
                        tw.getLocation(ref),
                        exprParent.parent,
                        exprParent.idx,
                        enclosingCallable,
                        exprParent.enclosingStmt
                    )
                }
            }
        }

        else -> {
            TODO()
        }
    }
}
