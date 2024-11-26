import com.github.codeql.*
import com.github.codeql.KotlinFileExtractor.StmtExprParent
import com.intellij.psi.PsiElement
import org.jetbrains.kotlin.analysis.api.KaExperimentalApi
import org.jetbrains.kotlin.analysis.api.KaSession
import org.jetbrains.kotlin.analysis.api.symbols.*
import org.jetbrains.kotlin.analysis.api.types.KaClassType
import org.jetbrains.kotlin.analysis.api.types.KaType
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
    callable: Label<out DbCallable>,
    parent: StmtExprParent
): Label<out DbExpr> {

    val locId = tw.getLocation(e)
    val functionSymbol = e.symbol
    val ids = getLocallyVisibleFunctionLabels(functionSymbol)

    // todo: is it possible that the receiver parameter is a dispatch receiver?
    val ext = if (functionSymbol.isExtension) functionSymbol.receiverParameter else null
    val parameterTypes = functionSymbol.valueParameters.map { (it as KaVariableSymbol).returnType }.toMutableList()
    if (ext != null) {
        parameterTypes.add(0, ext.type)
    }

    parameterTypes += functionSymbol.returnType

    val isBigArity = parameterTypes.size > BuiltInFunctionArity.BIG_ARITY
    if (isBigArity) {
        // OLD: KE1
        // implementFunctionNInvoke(e.function, ids, locId, parameters)
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

    val functionType =
        e.functionType // TODO: change this type for BIG_ARITY lambdas, this should be kotlin.FunctionN<R> and not kotlin.Function33<....,R>. The latter doesn't exist.
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
                listOf(builtinTypes.any, functionType)
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
    compilerGeneratedKindOverride: CompilerGeneratedKinds? = null // OLD: KE1
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
    compilerGeneratedKindOverride: CompilerGeneratedKinds? = null,
    /*
    OLD: KE1
    declarationParent: IrDeclarationParent,
    superConstructorSelector: (IrFunction) -> Boolean = { it.valueParameters.isEmpty() },
    extractSuperconstructorArgs: (Label<DbSuperconstructorinvocationstmt>) -> Unit = {},
     */
): Label<out DbClassorinterface> {
    // Write class
    val id = ids.type.javaResult.id.cast<DbClassorinterface>()
    val pkgId = extractPackage("")
    tw.writeClasses_or_interfaces(id, "", pkgId, id)
    tw.writeCompiler_generated(
        id,
        (compilerGeneratedKindOverride ?: CompilerGeneratedKinds.CALLABLE_CLASS).kind
    )
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
    // TODO: we should check if this is class or not
    val baseClass = superTypes.first() as? KaClassType // superTypes.first().classOrNull
    if (baseClass == null) {
        logger.warnElement("Cannot find base class", elementToReportOn)
    } else {
        val baseConstructor =
            baseClass.scope?.declarationScope?.constructors?.find {
                // TODO: OLD KE1 superConstructorSelector(it)
                true
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
                // TODO: OLD KE1 extractSuperconstructorArgs(superCallId)
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