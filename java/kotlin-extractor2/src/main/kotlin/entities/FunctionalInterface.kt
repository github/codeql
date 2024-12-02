import com.github.codeql.*
import com.github.codeql.KotlinFileExtractor.StmtExprParent
import com.github.codeql.utils.type
import com.intellij.psi.PsiElement
import org.jetbrains.kotlin.analysis.api.KaExperimentalApi
import org.jetbrains.kotlin.analysis.api.KaSession
import org.jetbrains.kotlin.analysis.api.symbols.*
import org.jetbrains.kotlin.analysis.api.types.KaClassType
import org.jetbrains.kotlin.analysis.api.types.KaFunctionType
import org.jetbrains.kotlin.analysis.api.types.KaType
import org.jetbrains.kotlin.builtins.StandardNames
import org.jetbrains.kotlin.builtins.functions.BuiltInFunctionArity
import org.jetbrains.kotlin.name.ClassId
import org.jetbrains.kotlin.name.FqName
import org.jetbrains.kotlin.name.Name
import org.jetbrains.kotlin.psi.KtFunctionLiteral

/**
 * Extract a lambda expression as a generated anonymous class implementing
 * the appropriate functional interface.
 *
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
context(KaSession)
fun KotlinFileExtractor.extractFunctionLiteral(
    e: KtFunctionLiteral,
    parent: StmtExprParent
): Label<out DbExpr> {

    val locId = tw.getLocation(e)
    val functionSymbol = e.symbol
    val ids = getLocallyVisibleFunctionLabels(functionSymbol)

    val parameters = if (functionSymbol.isExtension) {
        listOf(functionSymbol.receiverParameter!!) + functionSymbol.valueParameters
    } else {
        functionSymbol.valueParameters
    }

    val isBigArity = parameters.size >= BuiltInFunctionArity.BIG_ARITY
    if (isBigArity) {
        implementFunctionNInvoke(functionSymbol, ids, locId, parameters)
    } else {
        addModifiers(ids.function, "override")
    }

    val exprParent = parent.expr(e)
    val idLambdaExpr = tw.getFreshIdLabel<DbLambdaexpr>()
    tw.writeExprs_lambdaexpr(
        idLambdaExpr,
        ids.type.javaResult.id,
        exprParent.parent,
        exprParent.idx
    )
    tw.writeExprsKotlinType(idLambdaExpr, ids.type.kotlinResult.id)
    extractExprContext(idLambdaExpr, locId, exprParent.callable, exprParent.enclosingStmt)
    tw.writeCallableBinding(idLambdaExpr, ids.constructor)

    // todo: fix hard coded block body of lambda
    tw.writeLambdaKind(idLambdaExpr, 1)

    val functionType = getRealFunctionalInterfaceType(e.functionType as KaFunctionType)
    if (!functionType.isFunctionType) {
        logger.warnElement(
            "Cannot find functional interface type for function expression",
            e
        )
    } else {
        val id =
            extractGeneratedClass(
                // We're adding this function as a member, and
                // changing its name to `invoke` to implement
                // `kotlin.FunctionX<,,,>.invoke(,,)`
                functionSymbol,
                e,
                listOf(builtinTypes.any, functionType),
                CompilerGeneratedKinds.CALLABLE_CLASS
            )

        /*
        OLD: KE1
        extractTypeAccessRecursive(
            fnInterfaceType,
            locId,
            idLambdaExpr,
            -3,
            callable,
            exprParent.enclosingStmt
        )
         */

        tw.writeIsAnonymClass(id, idLambdaExpr)
    }

    return idLambdaExpr
}

context(KaSession)
private fun KotlinFileExtractor.getRealFunctionalInterfaceType(typeFromApi: KaFunctionType): KaType {
    if (typeFromApi.arity < BuiltInFunctionArity.BIG_ARITY) {
        return typeFromApi
    }

    // TODO: the below doesn't work, see https://youtrack.jetbrains.com/issue/KT-73421/
    return buildClassType(
        ClassId(
            FqName("kotlin.jvm.functions"),
            Name.identifier("FunctionN")
        )
    ) {
        argument(typeFromApi.typeArguments.last().type!!)
    }
}

/**
 * This function generates an implementation for `fun kotlin.FunctionN<R>.invoke(vararg args: Any?): R`
 *
 * The following body is added:
 * ```
 * fun invoke(vararg a0: Any?): R {
 *   return invoke(a0[0] as T0, a0[1] as T1, ..., a0[I] as TI)
 * }
 * ```
 * */
context(KaSession)
private fun KotlinFileExtractor.implementFunctionNInvoke(
    lambda: KaFunctionSymbol,
    ids: LocallyVisibleFunctionLabels,
    locId: Label<DbLocation>,
    parameters: List<KaParameterSymbol>
) {
    val funLabels =
        addFunctionNInvoke(
            tw.getFreshIdLabel(),
            lambda.returnType,
            ids.type.javaResult.id.cast<DbReftype>(),
            locId
        )

    // Return
    val retId = tw.getFreshIdLabel<DbReturnstmt>()
    tw.writeStmts_returnstmt(retId, funLabels.blockId, 0, funLabels.methodId)
    tw.writeHasLocation(retId, locId)

    // Call to original `invoke`:
    val callId = tw.getFreshIdLabel<DbMethodaccess>()
    val callType = useType(lambda.returnType)
    tw.writeExprs_methodaccess(callId, callType.javaResult.id, retId, 0)
    tw.writeExprsKotlinType(callId, callType.kotlinResult.id)
    extractExprContext(callId, locId, funLabels.methodId, retId)
    tw.writeCallableBinding(callId, ids.function)

    // this access
    // OLD: KE1
    // extractThisAccess(ids.type, funLabels.methodId, callId, -1, retId, locId)

    addArgumentsToInvocationInInvokeNBody(
        parameters.map { it.type },
        funLabels,
        retId,
        callId,
        locId
    )
}

private data class FunctionLabels(
    val methodId: Label<DbMethod>,
    val blockId: Label<DbBlock>,
    val parameters: List<Pair<Label<DbParam>, TypeResults>>
)

/**
 * Adds a function `invoke(a: Any[])` with the specified return type to the class identified by
 * `parentId`.
 */
context(KaSession)
private fun KotlinFileExtractor.addFunctionNInvoke(
    methodId: Label<DbMethod>,
    returnType: KaType,
    parentId: Label<out DbReftype>,
    locId: Label<DbLocation>
): FunctionLabels {
    return addFunctionInvoke(
        methodId,
        listOf(nullableAnyArrayType),
        returnType,
        parentId,
        locId
    )
}

context(KaSession)
private val nullableAnyArrayType: KaType
    get() = buildClassType(ClassId.topLevel(StandardNames.FqNames.array.toSafe())) {
        argument(builtinTypes.nullableAny)
    }

/**
 * Adds a function named `invoke` with the specified parameter types and return type to the
 * class identified by `parentId`.
 */
context(KaSession)
private fun KotlinFileExtractor.addFunctionInvoke(
    methodId: Label<DbMethod>,
    parameterTypes: List<KaType>,
    returnType: KaType,
    parentId: Label<out DbReftype>,
    locId: Label<DbLocation>
): FunctionLabels {
    return addFunctionManual(
        methodId,
        "invoke",
        parameterTypes,
        returnType,
        parentId,
        locId
    )
}

/**
 * Extracts a function with the given name, parameter types, return type, containing type, and
 * location.
 */
context(KaSession)
private fun KotlinFileExtractor.addFunctionManual(
    methodId: Label<DbMethod>,
    name: String,
    parameterTypes: List<KaType>,
    returnType: KaType,
    parentId: Label<out DbReftype>,
    locId: Label<DbLocation>
): FunctionLabels {

    val parameters =
        parameterTypes.mapIndexed { idx, p ->
            val paramId = tw.getFreshIdLabel<DbParam>()
            val paramType =
                extractValueParameter(
                    paramId,
                    p,
                    "a$idx",
                    locId,
                    methodId,
                    idx,
                    paramId,
                    isVararg = false,
                    isNoinline = false,
                    isCrossinline = false
                )

            Pair(paramId, paramType)
        }

    /* OLD: KE1
    val paramsSignature =
        parameters.joinToString(separator = ",", prefix = "(", postfix = ")") {
            signatureOrWarn(it.second.javaResult, declarationStack.tryPeek()?.first)
        }
     */
    val paramsSignature = "()" // TODO

    val rt = useType(returnType, TypeContext.RETURN)
    tw.writeMethods(
        methodId,
        name,
        "$name$paramsSignature",
        rt.javaResult.id,
        parentId,
        methodId
    )
    tw.writeMethodsKotlinType(methodId, rt.kotlinResult.id)
    tw.writeHasLocation(methodId, locId)

    addModifiers(methodId, "public")
    addModifiers(methodId, "override")

    return FunctionLabels(methodId, extractBlockBody(methodId, locId), parameters)
}

/**
 * Adds the arguments to the method call inside `invoke(a0: Any[])`. Each argument is an array
 * access with a cast:
 * ```
 * fun invoke(a0: Any[]) : T {
 *   return fn(a0[0] as T0, a0[1] as T1, ...)
 * }
 * ```
 */
context(KaSession)
private fun KotlinFileExtractor.addArgumentsToInvocationInInvokeNBody(
    parameterTypes: List<KaType>,   // list of parameter types
    funLabels: FunctionLabels,      // already generated labels for the function definition
    enclosingStmtId: Label<out DbStmt>,     // label for the enclosing statement (return)
    exprParentId: Label<out DbExprparent>,  // label for the expression parent (call)
    locId: Label<DbLocation>,       // label for the location of all generated items
    firstArgumentOffset: Int =
        0,              // 0 or 1, the index used for the first argument. 1 in case an extension parameter is already accessed at index 0
    useFirstArgAsDispatch: Boolean =
        false,          // true if the first argument should be used as the dispatch receiver
    dispatchReceiverIdx: Int =
        -1              // index of the dispatch receiver. -1 in case of functions, -2 in case of constructors
) {
    val argsParamType = nullableAnyArrayType
    val argsType = useType(argsParamType)
    val anyNType = useType(builtinTypes.nullableAny)

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
        extractExprContext(castId, locId, funLabels.methodId, enclosingStmtId)

        // type access `Ti`
        // TODO: extractTypeAccessRecursive(pType, locId, castId, 0, funLabels.methodId, enclosingStmtId)

        // element access: `a0[i]`
        val arrayAccessId = tw.getFreshIdLabel<DbArrayaccess>()
        tw.writeExprs_arrayaccess(arrayAccessId, anyNType.javaResult.id, castId, 1)
        tw.writeExprsKotlinType(arrayAccessId, anyNType.kotlinResult.id)
        extractExprContext(arrayAccessId, locId, funLabels.methodId, enclosingStmtId)

        // parameter access: `a0`
        val argsAccessId = tw.getFreshIdLabel<DbVaraccess>()
        tw.writeExprs_varaccess(argsAccessId, argsType.javaResult.id, arrayAccessId, 0)
        tw.writeExprsKotlinType(argsAccessId, argsType.kotlinResult.id)
        extractExprContext(argsAccessId, locId, funLabels.methodId, enclosingStmtId)
        tw.writeVariableBinding(argsAccessId, funLabels.parameters.first().first)

        // index access: `i`
        extractConstantInteger(
            pIdx.toString(),
            builtinTypes.int,
            pIdx,
            locId,
            arrayAccessId,
            1,
            funLabels.methodId,
            enclosingStmtId
        )
    }
}


/**
 * Gets the labels for functions belonging to
 * - local functions, and
 * - lambdas.
 */
private fun KotlinFileExtractor.getLocallyVisibleFunctionLabels(f: KaAnonymousFunctionSymbol): LocallyVisibleFunctionLabels {
    if (!f.isLocal) {
        logger.error("Extracting a non-local function as a local one")
    }

    return tw.lm.getOrAddLocallyVisibleFunctionLabelMapping(f) {
        val classId = tw.getFreshIdLabel<DbClassorinterface>()
        val javaResult = TypeResult(classId/* , "TODO", "TODO" */)
        val kotlinTypeId =
            tw.getLabelFor<DbKt_class_type>("@\"kt_class;{$classId}\"") {
                tw.writeKt_class_types(it, classId)
            }
        val kotlinResult = TypeResult(kotlinTypeId /* , "TODO", "TODO" */)

        LocallyVisibleFunctionLabels(
            type = TypeResults(javaResult, kotlinResult),
            constructor = tw.getFreshIdLabel(),
            constructorBlock = tw.getFreshIdLabel(),
            function = tw.getFreshIdLabel()
        )
    }
}

/**
 * Extracts the class around a local function or a lambda. The superclass must have a no-arg
 * constructor.
 */
context(KaSession)
private fun KotlinFileExtractor.extractGeneratedClass(
    localFunction: KaFunctionSymbol,
    elementToReportOn: PsiElement,
    superTypes: List<KaType>,
    compilerGeneratedKindOverride: CompilerGeneratedKinds
): Label<out DbClassorinterface> {
    val ids = tw.lm.getLocallyVisibleFunctionLabelMapping(localFunction)

    val id =
        extractGeneratedClass(
            ids,
            superTypes,
            tw.getLocation(elementToReportOn),
            elementToReportOn,
            compilerGeneratedKindOverride = compilerGeneratedKindOverride
            /*
            OLD: KE1
            localFunction.parent,
             */
        )

    // Extract local function as a member
    extractFunction(
        localFunction,
        id,
        /*
        OLD: KE1
        extractBody = true,
        extractMethodAndParameterTypeAccesses = true,
        extractAnnotations = false,
        null,
        listOf()
         */
    )

    return id
}

/** Extracts the class around a local function, a lambda, or a function reference. */
context(KaSession)
@OptIn(KaExperimentalApi::class)
private fun KotlinFileExtractor.extractGeneratedClass(
    ids: GeneratedClassLabels,
    superTypes: List<KaType>,
    locId: Label<DbLocation>,
    elementToReportOn: PsiElement,
    compilerGeneratedKindOverride: CompilerGeneratedKinds
    /*
    OLD: KE1
    declarationParent: IrDeclarationParent,
     */
): Label<out DbClassorinterface> {
    // Write class
    val id = ids.type.javaResult.id.cast<DbClassorinterface>()
    val pkgId = extractPackage("")
    tw.writeClasses_or_interfaces(id, "", pkgId, id)
    tw.writeCompiler_generated(id, compilerGeneratedKindOverride.kind)
    tw.writeHasLocation(id, locId)

    // Extract constructor
    val unitType = useType(builtinTypes.unit/*TODO , TypeContext.RETURN*/)
    tw.writeConstrs(ids.constructor, "", "", unitType.javaResult.id, id, ids.constructor)
    tw.writeConstrsKotlinType(ids.constructor, unitType.kotlinResult.id)
    tw.writeHasLocation(ids.constructor, locId)
    addModifiers(ids.constructor, "public")

    // Constructor body
    val constructorBlockId = ids.constructorBlock
    tw.writeStmts_block(constructorBlockId, ids.constructor, 0, ids.constructor)
    tw.writeHasLocation(constructorBlockId, locId)

    // Super call
    val baseClass = superTypes.first() as? KaClassType
    if ((baseClass?.symbol as? KaClassSymbol)?.classKind != KaClassKind.CLASS) {
        logger.warnElement("Cannot find base class", elementToReportOn)
    } else {
        val baseConstructor =
            baseClass.scope?.declarationScope?.constructors?.find {
                it.valueParameters.isEmpty()
            }
        if (baseConstructor == null) {
            logger.warnElement("Cannot find base constructor", elementToReportOn)
        } else {
            val baseConstructorParentId = useDeclarationParentOf(baseConstructor, false)
            if (baseConstructorParentId == null) {
                logger.errorElement("Cannot find base constructor ID", elementToReportOn)
            } else {
                val baseConstructorId = useFunction<DbConstructor>(baseConstructor, baseConstructorParentId)
                val superCallId = tw.getFreshIdLabel<DbSuperconstructorinvocationstmt>()
                tw.writeStmts_superconstructorinvocationstmt(
                    superCallId,
                    constructorBlockId,
                    0,
                    ids.constructor
                )

                tw.writeHasLocation(superCallId, locId)
                tw.writeCallableBinding(superCallId.cast<DbCaller>(), baseConstructorId)
            }
        }
    }

    addModifiers(id, "final")
    addModifiers(id, "private")
    //OLD: KE1
    //    extractClassSupertypes(
    //        superTypes,
    //        //listOf(),
    //        id,
    //        //isInterface = false,
    //        //inReceiverContext = true
    //    )

    // TODO: OLD KE1:
    // extractEnclosingClass(declarationParent, id, null, locId, listOf())

    return id
}

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


private enum class CompilerGeneratedKinds(val kind: Int) {
    // OLD: KE1
    //    DECLARING_CLASSES_OF_ADAPTER_FUNCTIONS(1),
    //    GENERATED_DATA_CLASS_MEMBER(2),
    //    DEFAULT_PROPERTY_ACCESSOR(3),
    //    CLASS_INITIALISATION_METHOD(4),
    //    ENUM_CLASS_SPECIAL_MEMBER(5),
    //    DELEGATED_PROPERTY_GETTER(6),
    //    DELEGATED_PROPERTY_SETTER(7),
    //    JVMSTATIC_PROXY_METHOD(8),
    //    JVMOVERLOADS_METHOD(9),
    //    DEFAULT_ARGUMENTS_METHOD(10),
    //    INTERFACE_FORWARDER(11),
    //    ENUM_CONSTRUCTOR_ARGUMENT(12),
    CALLABLE_CLASS(13),
}
