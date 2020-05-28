using Semmle.Extraction.CommentProcessing;
using Semmle.Extraction.CSharp.Entities;
using Semmle.Extraction.Entities;
using Semmle.Extraction.Kinds;
using Semmle.Util;
using System.IO;

namespace Semmle.Extraction.CSharp
{
    /// <summary>
    /// Methods for writing DB tuples.
    /// </summary>
    ///
    /// <remarks>
    /// The parameters to the tuples are well-typed.
    /// </remarks>
    internal static class Tuples
    {
        internal static void accessor_location(this TextWriter trapFile, Accessor accessorKey, Location location)
        {
            trapFile.WriteTuple("accessor_location", accessorKey, location);
        }

        internal static void accessors(this TextWriter trapFile, Accessor accessorKey, int kind, string name, Property propKey, Accessor unboundAccessor)
        {
            trapFile.WriteTuple("accessors", accessorKey, kind, name, propKey, unboundAccessor);
        }

        internal static void array_element_type(this TextWriter trapFile, ArrayType array, int dimension, int rank, Type elementType)
        {
            trapFile.WriteTuple("array_element_type", array, dimension, rank, elementType);
        }

        internal static void attributes(this TextWriter trapFile, Attribute attribute, Type attributeType, IEntity entity)
        {
            trapFile.WriteTuple("attributes", attribute, attributeType, entity);
        }

        internal static void attribute_location(this TextWriter trapFile, Attribute attribute, Location location)
        {
            trapFile.WriteTuple("attribute_location", attribute, location);
        }

        internal static void catch_type(this TextWriter trapFile, Entities.Statements.Catch @catch, Type type, bool explicityCaught)
        {
            trapFile.WriteTuple("catch_type", @catch, type, explicityCaught ? 1 : 2);
        }

        internal static void commentblock(this TextWriter trapFile, CommentBlock k)
        {
            trapFile.WriteTuple("commentblock", k);
        }

        internal static void commentblock_binding(this TextWriter trapFile, CommentBlock commentBlock, Label entity, CommentBinding binding)
        {
            trapFile.WriteTuple("commentblock_binding", commentBlock, entity, (int)binding);
        }

        internal static void commentblock_child(this TextWriter trapFile, CommentBlock commentBlock, CommentLine commentLine, int child)
        {
            trapFile.WriteTuple("commentblock_child", commentBlock, commentLine, child);
        }

        internal static void commentblock_location(this TextWriter trapFile, CommentBlock k, Location l)
        {
            trapFile.WriteTuple("commentblock_location", k, l);
        }

        internal static void commentline(this TextWriter trapFile, CommentLine commentLine, CommentLineType type, string text, string rawtext)
        {
            trapFile.WriteTuple("commentline", commentLine, (int)type, text, rawtext);
        }

        internal static void commentline_location(this TextWriter trapFile, CommentLine commentLine, Location location)
        {
            trapFile.WriteTuple("commentline_location", commentLine, location);
        }

        internal static void compilation_args(this TextWriter trapFile, Compilation compilation, int index, string arg)
        {
            trapFile.WriteTuple("compilation_args", compilation, index, arg);
        }

        internal static void compilation_compiling_files(this TextWriter trapFile, Compilation compilation, int index, Extraction.Entities.File file)
        {
            trapFile.WriteTuple("compilation_compiling_files", compilation, index, file);
        }

        internal static void compilation_referencing_files(this TextWriter trapFile, Compilation compilation, int index, Extraction.Entities.File file)
        {
            trapFile.WriteTuple("compilation_referencing_files", compilation, index, file);
        }

        internal static void compilation_finished(this TextWriter trapFile, Compilation compilation, float cpuSeconds, float elapsedSeconds)
        {
            trapFile.WriteTuple("compilation_finished", compilation, cpuSeconds, elapsedSeconds);
        }

        internal static void compilation_time(this TextWriter trapFile, Compilation compilation, int num, int index, float metric)
        {
            trapFile.WriteTuple("compilation_time", compilation, num, index, metric);
        }

        internal static void compilations(this TextWriter trapFile, Compilation compilation, string cwd)
        {
            trapFile.WriteTuple("compilations", compilation, cwd);
        }

        internal static void compiler_generated(this TextWriter trapFile, IEntity entity)
        {
            trapFile.WriteTuple("compiler_generated", entity);
        }

        internal static void conditional_access(this TextWriter trapFile, Expression access)
        {
            trapFile.WriteTuple("conditional_access", access);
        }

        internal static void constant_value(this TextWriter trapFile, IEntity field, string value)
        {
            trapFile.WriteTuple("constant_value", field, value);
        }

        internal static void constructed_generic(this TextWriter trapFile, IEntity constructedTypeOrMethod, IEntity unboundTypeOrMethod)
        {
            trapFile.WriteTuple("constructed_generic", constructedTypeOrMethod, unboundTypeOrMethod);
        }

        internal static void constructor_location(this TextWriter trapFile, Constructor constructor, Location location)
        {
            trapFile.WriteTuple("constructor_location", constructor, location);
        }

        internal static void constructors(this TextWriter trapFile, Constructor key, string name, Type definingType, Constructor originalDefinition)
        {
            trapFile.WriteTuple("constructors", key, name, definingType, originalDefinition);
        }

        internal static void delegate_return_type(this TextWriter trapFile, Type delegateKey, Type returnType)
        {
            trapFile.WriteTuple("delegate_return_type", delegateKey, returnType);
        }

        internal static void destructor_location(this TextWriter trapFile, Destructor destructor, Location location)
        {
            trapFile.WriteTuple("destructor_location", destructor, location);
        }

        internal static void destructors(this TextWriter trapFile, Destructor destructor, string name, Type containingType, Destructor original)
        {
            trapFile.WriteTuple("destructors", destructor, name, containingType, original);
        }

        internal static void diagnostic_for(this TextWriter trapFile, Diagnostic diag, Compilation comp, int fileNo, int index)
        {
            trapFile.WriteTuple("diagnostic_for", diag, comp, fileNo, index);
        }

        internal static void diagnostics(this TextWriter trapFile, Diagnostic diag, int severity, string errorTag, string errorMessage, string fullErrorMessage, Location location)
        {
            trapFile.WriteTuple("diagnostics", diag, severity, errorTag, errorMessage, fullErrorMessage, location);
        }

        internal static void dynamic_member_name(this TextWriter trapFile, Expression e, string name)
        {
            trapFile.WriteTuple("dynamic_member_name", e, name);
        }

        internal static void enum_underlying_type(this TextWriter trapFile, Type @enum, Type type)
        {
            trapFile.WriteTuple("enum_underlying_type", @enum, type);
        }

        internal static void event_accessor_location(this TextWriter trapFile, EventAccessor accessor, Location location)
        {
            trapFile.WriteTuple("event_accessor_location", accessor, location);
        }

        internal static void event_accessors(this TextWriter trapFile, EventAccessor accessorKey, int type, string name, Event eventKey, EventAccessor unboundAccessor)
        {
            trapFile.WriteTuple("event_accessors", accessorKey, type, name, eventKey, unboundAccessor);
        }

        internal static void event_location(this TextWriter trapFile, Event eventKey, Location locationKey)
        {
            trapFile.WriteTuple("event_location", eventKey, locationKey);
        }

        internal static void events(this TextWriter trapFile, Event eventKey, string name, Type declaringType, Type memberType, Event originalDefinition)
        {
            trapFile.WriteTuple("events", eventKey, name, declaringType, memberType, originalDefinition);
        }

        internal static void explicitly_implements(this TextWriter trapFile, IEntity member, Type @interface)
        {
            trapFile.WriteTuple("explicitly_implements", member, @interface);
        }

        internal static void explicitly_sized_array_creation(this TextWriter trapFile, Expression array)
        {
            trapFile.WriteTuple("explicitly_sized_array_creation", array);
        }

        internal static void expr_access(this TextWriter trapFile, Expression expr, IEntity access)
        {
            trapFile.WriteTuple("expr_access", expr, access);
        }

        internal static void expr_argument(this TextWriter trapFile, Expression expr, int mode)
        {
            trapFile.WriteTuple("expr_argument", expr, mode);
        }

        internal static void expr_argument_name(this TextWriter trapFile, Expression expr, string name)
        {
            trapFile.WriteTuple("expr_argument_name", expr, name);
        }

        internal static void expr_call(this TextWriter trapFile, Expression expr, Method target)
        {
            trapFile.WriteTuple("expr_call", expr, target);
        }

        internal static void expr_compiler_generated(this TextWriter trapFile, Expression expr)
        {
            trapFile.WriteTuple("expr_compiler_generated", expr);
        }

        internal static void expr_flowstate(this TextWriter trapFile, Expression expr, int flowState)
        {
            trapFile.WriteTuple("expr_flowstate", expr, flowState);
        }

        internal static void expr_location(this TextWriter trapFile, Expression expr, Location location)
        {
            trapFile.WriteTuple("expr_location", expr, location);
        }

        internal static void expr_parent(this TextWriter trapFile, Expression expr, int child, IExpressionParentEntity parent)
        {
            trapFile.WriteTuple("expr_parent", expr, child, parent);
        }

        internal static void expr_parent_top_level(this TextWriter trapFile, Expression expr, int child, IExpressionParentEntity parent)
        {
            trapFile.WriteTuple("expr_parent_top_level", expr, child, parent);
        }

        internal static void expr_value(this TextWriter trapFile, Expression expr, string value)
        {
            trapFile.WriteTuple("expr_value", expr, value);
        }

        internal static void expressions(this TextWriter trapFile, Expression expr, ExprKind kind, Type exprType)
        {
            trapFile.WriteTuple("expressions", expr, (int)kind, exprType);
        }

        internal static void exprorstmt_name(this TextWriter trapFile, IEntity expr, string name)
        {
            trapFile.WriteTuple("exprorstmt_name", expr, name);
        }

        internal static void extend(this TextWriter trapFile, Type type, Type super)
        {
            trapFile.WriteTuple("extend", type, super);
        }

        internal static void field_location(this TextWriter trapFile, Field field, Location location)
        {
            trapFile.WriteTuple("field_location", field, location);
        }

        internal static void fields(this TextWriter trapFile, Field field, int @const, string name, Type declaringType, Type fieldType, Field unboundKey)
        {
            trapFile.WriteTuple("fields", field, @const, name, declaringType, fieldType, unboundKey);
        }

        internal static void general_type_parameter_constraints(this TextWriter trapFile, TypeParameterConstraints constraints, int hasKind)
        {
            trapFile.WriteTuple("general_type_parameter_constraints", constraints, hasKind);
        }

        internal static void has_modifiers(this TextWriter trapFile, IEntity entity, Modifier modifier)
        {
            trapFile.WriteTuple("has_modifiers", entity, modifier);
        }

        internal static void implement(this TextWriter trapFile, Type type, Type @interface)
        {
            trapFile.WriteTuple("implement", type, @interface);
        }

        internal static void implicitly_typed_array_creation(this TextWriter trapFile, Expression array)
        {
            trapFile.WriteTuple("implicitly_typed_array_creation", array);
        }

        internal static void indexer_location(this TextWriter trapFile, Indexer indexer, Location location)
        {
            trapFile.WriteTuple("indexer_location", indexer, location);
        }

        internal static void indexers(this TextWriter trapFile, Indexer propKey, string name, Type declaringType, Type memberType, Indexer unboundProperty)
        {
            trapFile.WriteTuple("indexers", propKey, name, declaringType, memberType, unboundProperty);
        }

        internal static void local_function_stmts(this TextWriter trapFile, Entities.Statements.LocalFunction fnStmt, LocalFunction fn)
        {
            trapFile.WriteTuple("local_function_stmts", fnStmt, fn);
        }

        internal static void local_functions(this TextWriter trapFile, LocalFunction fn, string name, Type returnType, LocalFunction unboundFn)
        {
            trapFile.WriteTuple("local_functions", fn, name, returnType, unboundFn);
        }

        internal static void localvar_location(this TextWriter trapFile, LocalVariable var, Location location)
        {
            trapFile.WriteTuple("localvar_location", var, location);
        }

        internal static void localvars(this TextWriter trapFile, LocalVariable key, int @const, string name, int @var, Type type, Expression expr)
        {
            trapFile.WriteTuple("localvars", key, @const, name, @var, type, expr);
        }

        public static void metadata_handle(this TextWriter trapFile, IEntity entity, Location assembly, int handleValue)
        {
            trapFile.WriteTuple("metadata_handle", entity, assembly, handleValue);
        }

        internal static void method_location(this TextWriter trapFile, Method method, Location location)
        {
            trapFile.WriteTuple("method_location", method, location);
        }

        internal static void methods(this TextWriter trapFile, Method method, string name, Type declType, Type retType, Method originalDefinition)
        {
            trapFile.WriteTuple("methods", method, name, declType, retType, originalDefinition);
        }

        internal static void modifiers(this TextWriter trapFile, Label entity, string modifier)
        {
            trapFile.WriteTuple("modifiers", entity, modifier);
        }

        internal static void mutator_invocation_mode(this TextWriter trapFile, Expression expr, int mode)
        {
            trapFile.WriteTuple("mutator_invocation_mode", expr, mode);
        }

        internal static void namespace_declaration_location(this TextWriter trapFile, NamespaceDeclaration decl, Location location)
        {
            trapFile.WriteTuple("namespace_declaration_location", decl, location);
        }

        internal static void namespace_declarations(this TextWriter trapFile, NamespaceDeclaration decl, Namespace ns)
        {
            trapFile.WriteTuple("namespace_declarations", decl, ns);
        }

        internal static void namespaces(this TextWriter trapFile, Namespace ns, string name)
        {
            trapFile.WriteTuple("namespaces", ns, name);
        }

        internal static void nested_types(this TextWriter trapFile, Type typeKey, Type declaringTypeKey, Type unboundTypeKey)
        {
            trapFile.WriteTuple("nested_types", typeKey, declaringTypeKey, unboundTypeKey);
        }

        internal static void nullable_underlying_type(this TextWriter trapFile, Type nullableType, Type underlyingType)
        {
            trapFile.WriteTuple("nullable_underlying_type", nullableType, underlyingType);
        }

        internal static void nullability(this TextWriter trapFile, NullabilityEntity nullability, int annotation)
        {
            trapFile.WriteTuple("nullability", nullability, annotation);
        }

        internal static void nullability_parent(this TextWriter trapFile, NullabilityEntity nullability, int index, NullabilityEntity parent)
        {
            trapFile.WriteTuple("nullability_parent", nullability, index, parent);
        }

        internal static void numlines(this TextWriter trapFile, IEntity label, LineCounts lineCounts)
        {
            trapFile.WriteTuple("numlines", label, lineCounts.Total, lineCounts.Code, lineCounts.Comment);
        }

        internal static void operator_location(this TextWriter trapFile, UserOperator @operator, Location location)
        {
            trapFile.WriteTuple("operator_location", @operator, location);
        }

        internal static void operators(this TextWriter trapFile, UserOperator method, string methodName, string symbol, Type classKey, Type returnType, UserOperator originalDefinition)
        {
            trapFile.WriteTuple("operators", method, methodName, symbol, classKey, returnType, originalDefinition);
        }

        internal static void overrides(this TextWriter trapFile, Method overriding, Method overridden)
        {
            trapFile.WriteTuple("overrides", overriding, overridden);
        }

        internal static void param_location(this TextWriter trapFile, Parameter param, Location location)
        {
            trapFile.WriteTuple("param_location", param, location);
        }

        internal static void @params(this TextWriter trapFile, Parameter param, string name, Type type, int child, Parameter.Kind mode, IEntity method, Parameter originalDefinition)
        {
            trapFile.WriteTuple("params", param, name, type, child, (int)mode, method, originalDefinition);
        }

        internal static void parent_namespace(this TextWriter trapFile, IEntity type, Namespace parent)
        {
            trapFile.WriteTuple("parent_namespace", type, parent);
        }

        internal static void parent_namespace_declaration(this TextWriter trapFile, IEntity item, NamespaceDeclaration parent)
        {
            trapFile.WriteTuple("parent_namespace_declaration", item, parent);
        }

        internal static void pointer_referent_type(this TextWriter trapFile, PointerType pointerType, Type referentType)
        {
            trapFile.WriteTuple("pointer_referent_type", pointerType, referentType);
        }

        internal static void property_location(this TextWriter trapFile, Property property, Location location)
        {
            trapFile.WriteTuple("property_location", property, location);
        }

        internal static void properties(this TextWriter trapFile, Property propKey, string name, Type declaringType, Type memberType, Property unboundProperty)
        {
            trapFile.WriteTuple("properties", propKey, name, declaringType, memberType, unboundProperty);
        }

        internal static void statements(this TextWriter trapFile, Statement stmt, StmtKind kind)
        {
            trapFile.WriteTuple("statements", stmt, (int)kind);
        }

        internal static void specific_type_parameter_constraints(this TextWriter trapFile, TypeParameterConstraints constraints, Type baseType)
        {
            trapFile.WriteTuple("specific_type_parameter_constraints", constraints, baseType);
        }

        internal static void specific_type_parameter_nullability(this TextWriter trapFile, TypeParameterConstraints constraints, Type baseType, NullabilityEntity nullability)
        {
            trapFile.WriteTuple("specific_type_parameter_nullability", constraints, baseType, nullability);
        }

        internal static void stackalloc_array_creation(this TextWriter trapFile, Expression array)
        {
            trapFile.WriteTuple("stackalloc_array_creation", array);
        }

        internal static void stmt_location(this TextWriter trapFile, Statement stmt, Location location)
        {
            trapFile.WriteTuple("stmt_location", stmt, location);
        }

        internal static void stmt_parent(this TextWriter trapFile, Statement stmt, int child, IStatementParentEntity parent)
        {
            trapFile.WriteTuple("stmt_parent", stmt, child, parent);
        }

        internal static void stmt_parent_top_level(this TextWriter trapFile, Statement stmt, int child, IStatementParentEntity parent)
        {
            trapFile.WriteTuple("stmt_parent_top_level", stmt, child, parent);
        }

        internal static void tuple_element(this TextWriter trapFile, TupleType type, int index, Field field)
        {
            trapFile.WriteTuple("tuple_element", type, index, field);
        }

        internal static void tuple_underlying_type(this TextWriter trapFile, TupleType type, NamedType underlying)
        {
            trapFile.WriteTuple("tuple_underlying_type", type, underlying);
        }

        internal static void type_annotation(this TextWriter trapFile, IEntity element, Kinds.TypeAnnotation annotation)
        {
            trapFile.WriteTuple("type_annotation", element, (int)annotation);
        }

        internal static void type_arguments(this TextWriter trapFile, Type arg, int n, IEntity typeOrMethod)
        {
            trapFile.WriteTuple("type_arguments", arg, n, typeOrMethod);
        }

        internal static void type_location(this TextWriter trapFile, Type type, Location location)
        {
            trapFile.WriteTuple("type_location", type, location);
        }

        internal static void type_mention(this TextWriter trapFile, TypeMention ta, Type type, IEntity parent)
        {
            trapFile.WriteTuple("type_mention", ta, type, parent);
        }

        internal static void type_mention_location(this TextWriter trapFile, TypeMention ta, Location loc)
        {
            trapFile.WriteTuple("type_mention_location", ta, loc);
        }

        internal static void type_nullability(this TextWriter trapFile, IEntity element, NullabilityEntity nullability)
        {
            trapFile.WriteTuple("type_nullability", element, nullability);
        }

        internal static void type_parameter_constraints(this TextWriter trapFile, TypeParameterConstraints constraints, TypeParameter typeParam)
        {
            trapFile.WriteTuple("type_parameter_constraints", constraints, typeParam);
        }

        internal static void type_parameters(this TextWriter trapFile, TypeParameter param, int child, IEntity typeOrMethod)
        {
            trapFile.WriteTuple("type_parameters", param, child, typeOrMethod, (int)param.Variance);
        }

        internal static void typeref_type(this TextWriter trapFile, NamedTypeRef typeref, Type type)
        {
            trapFile.WriteTuple("typeref_type", typeref, type);
        }

        internal static void typerefs(this TextWriter trapFile, NamedTypeRef type, string name)
        {
            trapFile.WriteTuple("typerefs", type, name);
        }

        internal static void types(this TextWriter trapFile, Type type, TypeKind kind, string name)
        {
            trapFile.WriteTuple("types", type, (int)kind, name);
        }

        internal static void using_namespace_directives(this TextWriter trapFile, UsingDirective @using, Namespace ns)
        {
            trapFile.WriteTuple("using_namespace_directives", @using, ns);
        }

        internal static void using_directive_location(this TextWriter trapFile, UsingDirective @using, Location location)
        {
            trapFile.WriteTuple("using_directive_location", @using, location);
        }

        internal static void using_static_directives(this TextWriter trapFile, UsingDirective @using, Type type)
        {
            trapFile.WriteTuple("using_static_directives", @using, type);
        }
    }
}
