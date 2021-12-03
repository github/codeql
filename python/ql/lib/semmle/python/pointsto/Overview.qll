
/*
 * ## Points-to analysis for Python
 *
 *
 * The purpose of points-to analysis is to determine what values a variable might hold at runtime.
 * This allows us to write useful queries to check for the misuse of those values.
 * In the academic and technical literature, points-to analysis (AKA pointer analysis) attempts to determine which variables can refer to which heap allocated objects.
 * From the point of view of Python we can treat all Python objects as "heap allocated objects".
 *
 *
 * The output of the points-to analysis consists of a large set of relations which provide not only points-to information, but call-graph, pruned flow-graph and exception-raising information.
 *
 * These relations are computed by a large set of mutually recursive predicates which infer the flow of values through the program.
 * Our analysis is inter-procedural use contexts to maintain the precision of an intra-procedural analysis.
 *
 * ### Precision
 *
 * In conventional points-to, the computed points-to set should be a super-set of the real points-to set (were it possible to determine such a thing).
 * However for our purposes we want the points-to set to be a sub-set of the real points-to set.
 * This is simply because conventional points-to is used to determine compiler optimisations, so the points-to set needs to be a conservative over-estimate of what is possible.
 * We have the opposite concern; we want to eliminate false positives where possible.
 *
 * This should be born in mind when reading the literature about points-to analysis. In conventional points-to, a precise analysis produces as small a points-to set as possible.
 * Our analysis is precise (or very close to it). Instead of seeking to maximise precision, we seek to maximise *recall* and produce as large a points-to set as possible (whilst remaining precise).
 *
 * When it comes to designing the inference, we always choose precision over recall.
 * We want to minimise false positives so it is important to avoid making incorrect inferences, even if it means losing a lot of potential information.
 * If a potential new points-to fact would increase the number of values we are able to infer, but decrease precision, then we omit it.
 *
 * ###Objects
 *
 * In convention points-to an 'object' is generally considered to be any static instantiation. E.g. in Java this is simply anything looking like `new X(..)`.
 * However, in Python as there is no `new` expression we cannot known what is a class merely from the syntax.
 * Consequently, we must start with only with the simplest objects and extend to instance creation as we can infer classes.
 *
 * To perform points-to analysis we start with the set of built-in objects, all literal constants, and class and function definitions.
 * From there we can propagate those values. Whenever we see a call `x()` we add a new object if `x` refers to some class.
 *
 * In the `PointsTo::points_to` relation, the second argument, `Object value` is the "value" referred to by the ControlFlowNode (which will correspond to an rvalue in the source code).
 * The set of "values" used will change as the library continues to improve, but currently include the following:
 *
 * * Classes (both in the source and builtin)
 * * Functions (both in the source and builtin)
 * * Literal constants defined in the source (string and numbers)
 * * Constant objects defined in compiled libraries and the interpreter (None, boolean, strings and numbers)
 * * A few other constants such as small integers.
 * * Instances of classes
 * * Bound methods, static- and class-methods, and properties.
 * * Instances of `super`.
 * * Missing modules, where no concrete module is found for an import.
 *
 * A number of constructs that might create a new object, such as binary operations, are omitted if there is no useful information to can be attached to them and they would just increase the size of the database.
 *
 * ###Contexts
 *
 * In order to better handle value tracking in functions, we introduce context to the points-to relation.
 * There is one `default` context, equivalent to having no context, a `main` context for scripts and any number of call-site contexts.
 *
 * Adding context to a conventional points-to analysis can significantly improve its precision. Whereas, for our points-to analysis adding context significantly improves the recall of our analysis.
 * The consensus in the academic literature is that "object sensitivity" is superior to "call-site sensitivity".
 * However, since we are seeking to maximise not minimise our points-to set, it is entirely possible that the reverse is true for us.
 * We use "call-site sensitivity" at the moment, although the exact set of contexts used will change.
 *
 * ### Points-to analysis over the ESSA dataflow graph
 *
 * In order to perform points-to analysis on the dataflow graph, we
 * need to understand the many implicit "definitions" that occur within Python code.
 *
 * These are:
 *
 *    1. Implicit definition as "undefined" for any local or global variable at the start of its scope.
 *       Many of these will be dead and will be eliminated during construction of the dataflow graph.
 *    2. Implicit definition of `__name__`, `__package__` and `__module__` at the start of the relevant scopes.
 *    3. Implicit definition of all submodules as global variables at the start of an `__init__` module
 *
 * In addition, there are the "artificial", data-flow definitions:
 *
 *    1. Phi functions
 *    2. Pi (guard, or filter) functions.
 *    3. "Refinements" of a variable. These are not definitions of the variable, but may modify the object referred to by the variable,
 *       possibly changing some inferred facts about the object.
 *    4. Definition of any variable that escapes the scope, at entry, exit and at all call-sites.
 *
 * As an example, consider:
 * ```python
 * if a:
 *     float = "global"
 *     #float can now be either the class 'float' or the string "global"
 *
 * class C2:
 *     if b:
 *         float = "local"
 *     float
 *
 * float #Cannot be "local"
 * ```
 *
 * Ignoring `__name__` and `__package__`, the data-flow graph looks something like this, noting that there are two variables named "float"
 * in the scope `C2`, the local and the global.
 *
 * ```
 * a_0 = undefined
 * b_0 = undefined
 * float_0 = undefined
 * int_0 = undefined
 * float_1 = "global"
 * float_2 = phi(float_0, float_1)
 * float_3 = float_2 (Definition on entry to C2 for global variable)
 * float_4 = undefined (Definition on entry to C2 for local variable)
 * float_5 = "local" |
 * float_6 = phi(float_4, float_5) |
 * float_7 = float_3 (transfer values in global 'float', but not local, back to module scope).
 * ```
 *
 * ### Implementation
 *
 * <b>This section is for information purposes only. Any or all details may change without notice.</b>
 *
 * QL, being based on Datalog, has fixed-point semantics which makes it impossible to make negative statements that are recursive.
 * To work around this we need to define many predicates over boolean variables. Suppose we have a predicate with determines whether a test can be true or false at runtime.
 * We might naively implement this as `predicate test_is_true(ControlFlowNode test, Context ctx)` but this would lead to negative recursion if we want to know when the test can be false.
 * Instead we implement it as `boolean test_result(ControlFlowNode test, Context ctx)` where the absence of a value indicates merely that we do (yet) know what value the test may have.
 */

