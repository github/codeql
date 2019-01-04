using Semmle.Extraction.CommentProcessing;
using Semmle.Extraction.CSharp.Entities;
using Semmle.Extraction.Entities;
using Semmle.Extraction.Kinds;
using Semmle.Util;

namespace Semmle.Extraction.CSharp
{
    /// <summary>
    /// Methods for creating DB tuples.
    /// </summary>
    ///
    /// <remarks>
    /// Notice how the parameters to the tuples are well typed.
    /// In an idea world, each tuple would be its own type, as a typed entity. However
    /// that seems to be overkill.
    /// </remarks>
    internal static class Tuples
    {
        internal static Tuple accessor_location(Accessor accessorKey, Location location) => new Tuple("accessor_location", accessorKey, location);

        internal static Tuple accessors(Accessor accessorKey, int kind, string name, Property propKey, Accessor unboundAccessor) => new Tuple("accessors", accessorKey, kind, name, propKey, unboundAccessor);

        internal static Tuple array_element_type(ArrayType array, int dimension, int rank, Type elementType) => new Tuple("array_element_type", array, dimension, rank, elementType);

        internal static Tuple attributes(Attribute attribute, Type attributeType, IEntity entity) => new Tuple("attributes", attribute, attributeType, entity);

        internal static Tuple attribute_location(Attribute attribute, Location location) => new Tuple("attribute_location", attribute, location);

        internal static Tuple catch_type(Entities.Statements.Catch @catch, Type type, bool explicityCaught) => new Tuple("catch_type", @catch, type, explicityCaught ? 1 : 2);

        internal static Tuple commentblock(CommentBlock k) => new Tuple("commentblock", k);

        internal static Tuple commentblock_binding(CommentBlock commentBlock, Label entity, Binding binding) => new Tuple("commentblock_binding", commentBlock, entity, binding);

        internal static Tuple commentblock_child(CommentBlock commentBlock, CommentLine commentLine, int child) => new Tuple("commentblock_child", commentBlock, commentLine, child);

        internal static Tuple commentblock_location(CommentBlock k, Location l) => new Tuple("commentblock_location", k, l);

        internal static Tuple commentline(CommentLine commentLine, CommentType type, string text, string rawtext) => new Tuple("commentline", commentLine, type, text, rawtext);

        internal static Tuple commentline_location(CommentLine commentLine, Location location) => new Tuple("commentline_location", commentLine, location);

        internal static Tuple compiler_generated(IEntity entity) => new Tuple("compiler_generated", entity);

        internal static Tuple conditional_access(Expression access) => new Tuple("conditional_access", access);

        internal static Tuple constant_value(IEntity field, string value) => new Tuple("constant_value", field, value);

        internal static Tuple constructed_generic(IEntity constructedTypeOrMethod, IEntity unboundTypeOrMethod) => new Tuple("constructed_generic", constructedTypeOrMethod, unboundTypeOrMethod);

        internal static Tuple constructor_location(Constructor constructor, Location location) => new Tuple("constructor_location", constructor, location);

        internal static Tuple constructors(Constructor key, string name, Type definingType, Constructor originalDefinition) => new Tuple("constructors", key, name, definingType, originalDefinition);

        internal static Tuple delegate_return_type(Type delegateKey, Type returnType) => new Tuple("delegate_return_type", delegateKey, returnType);

        internal static Tuple destructor_location(Destructor destructor, Location location) => new Tuple("destructor_location", destructor, location);

        internal static Tuple destructors(Destructor destructor, string name, Type containingType, Destructor original) => new Tuple("destructors", destructor, name, containingType, original);

        internal static Tuple dynamic_member_name(Expression e, string name) => new Tuple("dynamic_member_name", e, name);

        internal static Tuple enum_underlying_type(Type @enum, Type type) => new Tuple("enum_underlying_type", @enum, type);

        internal static Tuple event_accessor_location(EventAccessor accessor, Location location) => new Tuple("event_accessor_location", accessor, location);

        internal static Tuple event_accessors(EventAccessor accessorKey, int type, string name, Event eventKey, EventAccessor unboundAccessor) => new Tuple("event_accessors", accessorKey, type, name, eventKey, unboundAccessor);

        internal static Tuple event_location(Event eventKey, Location locationKey) => new Tuple("event_location", eventKey, locationKey);

        internal static Tuple events(Event eventKey, string name, Type declaringType, Type memberType, Event originalDefinition) => new Tuple("events", eventKey, name, declaringType, memberType, originalDefinition);

        internal static Tuple explicitly_implements(IEntity member, Type @interface) => new Tuple("explicitly_implements", member, @interface);

        internal static Tuple explicitly_sized_array_creation(Expression array) => new Tuple("explicitly_sized_array_creation", array);

        internal static Tuple expr_compiler_generated(Expression expr) => new Tuple("expr_compiler_generated", expr);

        internal static Tuple expr_location(Expression exprKey, Location location) => new Tuple("expr_location", exprKey, location);

        internal static Tuple expr_access(Expression expr, IEntity access) => new Tuple("expr_access", expr, access);

        internal static Tuple expr_argument(Expression expr, int mode) => new Tuple("expr_argument", expr, mode);

        internal static Tuple expr_argument_name(Expression expr, string name) => new Tuple("expr_argument_name", expr, name);

        internal static Tuple expr_call(Expression expr, Method target) => new Tuple("expr_call", expr, target);

        internal static Tuple expr_parent(Expression exprKey, int child, IExpressionParentEntity parent) => new Tuple("expr_parent", exprKey, child, parent);

        internal static Tuple expr_parent_top_level(Expression exprKey, int child, IExpressionParentEntity parent) => new Tuple("expr_parent_top_level", exprKey, child, parent);

        internal static Tuple expr_value(Expression exprKey, string value) => new Tuple("expr_value", exprKey, value);

        internal static Tuple expressions(Expression expr, ExprKind kind, Type exprType) => new Tuple("expressions", expr, kind, exprType);

        internal static Tuple exprorstmt_name(IEntity expr, string name) => new Tuple("exprorstmt_name", expr, name);

        internal static Tuple extend(Type type, Type super) => new Tuple("extend", type, super);

        internal static Tuple field_location(Field field, Location location) => new Tuple("field_location", field, location);

        internal static Tuple fields(Field field, int @const, string name, Type declaringType, Type fieldType, Field unboundKey) => new Tuple("fields", field, @const, name, declaringType, fieldType, unboundKey);


        internal static Tuple general_type_parameter_constraints(TypeParameterConstraints constraints, int hasKind) => new Tuple("general_type_parameter_constraints", constraints, hasKind);

        internal static Tuple has_modifiers(IEntity entity, Modifier modifier) => new Tuple("has_modifiers", entity, modifier);

        internal static Tuple implement(Type type, Type @interface) => new Tuple("implement", type, @interface);

        internal static Tuple implicitly_typed_array_creation(Expression array) => new Tuple("implicitly_typed_array_creation", array);

        internal static Tuple indexer_location(Indexer indexer, Location location) => new Tuple("indexer_location", indexer, location);

        internal static Tuple indexers(Indexer propKey, string name, Type declaringType, Type memberType, Indexer unboundProperty) => new Tuple("indexers", propKey, name, declaringType, memberType, unboundProperty);

        internal static Tuple is_constructed(IEntity typeOrMethod) => new Tuple("is_constructed", typeOrMethod);

        internal static Tuple is_generic(IEntity typeOrMethod) => new Tuple("is_generic", typeOrMethod);

        internal static Tuple jump_step(IEntity origin, IEntity src, Statement dest) => new Tuple("jump_step", origin, src, dest);

        internal static Tuple local_function_stmts(Entities.Statements.LocalFunction fnStmt, LocalFunction fn) => new Tuple("local_function_stmts", fnStmt, fn);

        internal static Tuple local_functions(LocalFunction fn, string name, Type returnType, LocalFunction unboundFn) => new Tuple("local_functions", fn, name, returnType, unboundFn);

        internal static Tuple localvar_location(LocalVariable var, Location location) => new Tuple("localvar_location", var, location);

        internal static Tuple localvars(LocalVariable key, int @const, string name, int @var, Type type, Expression expr) => new Tuple("localvars", key, @const, name, @var, type, expr);

        public static Tuple metadata_handle(IEntity entity, Location assembly, int handleValue) =>
            new Tuple("metadata_handle", entity, assembly, handleValue);

        internal static Tuple method_location(Method method, Location location) => new Tuple("method_location", method, location);

        internal static Tuple methods(Method method, string name, Type declType, Type retType, Method originalDefinition) => new Tuple("methods", method, name, declType, retType, originalDefinition);

        internal static Tuple mutator_invocation_mode(Expression expr, int mode) => new Tuple("mutator_invocation_mode", expr, mode);

        internal static Tuple namespace_declaration_location(NamespaceDeclaration decl, Location location) => new Tuple("namespace_declaration_location", decl, location);

        internal static Tuple namespace_declarations(NamespaceDeclaration decl, Namespace ns) => new Tuple("namespace_declarations", decl, ns);

        internal static Tuple namespaces(Namespace ns, string name) => new Tuple("namespaces", ns, name);

        internal static Tuple nested_types(Type typeKey, Type declaringTypeKey, Type unboundTypeKey) => new Tuple("nested_types", typeKey, declaringTypeKey, unboundTypeKey);

        internal static Tuple nullable_underlying_type(Type nullableType, Type underlyingType) => new Tuple("nullable_underlying_type", nullableType, underlyingType);

        internal static Tuple numlines(IEntity label, LineCounts lineCounts) => new Tuple("numlines", label, lineCounts.Total, lineCounts.Code, lineCounts.Comment);

        internal static Tuple operator_location(UserOperator @operator, Location location) => new Tuple("operator_location", @operator, location);

        internal static Tuple operators(UserOperator method, string methodName, string symbol, Type classKey, Type returnType, UserOperator originalDefinition) => new Tuple("operators", method, methodName, symbol, classKey, returnType, originalDefinition);

        internal static Tuple overrides(Method overriding, Method overridden) => new Tuple("overrides", overriding, overridden);

        internal static Tuple param_location(Parameter param, Location location) => new Tuple("param_location", param, location);

        internal static Tuple @params(Parameter param, string name, Type type, int child, Parameter.Kind mode, IEntity method, Parameter originalDefinition) => new Tuple("params", param, name, type, child, mode, method, originalDefinition);

        internal static Tuple parent_namespace(IEntity type, Namespace parent) => new Tuple("parent_namespace", type, parent);

        internal static Tuple parent_namespace_declaration(IEntity item, NamespaceDeclaration parent) => new Tuple("parent_namespace_declaration", item, parent);

        internal static Tuple pointer_referent_type(PointerType pointerType, Type referentType) => new Tuple("pointer_referent_type", pointerType, referentType);

        internal static Tuple property_location(Property property, Location location) => new Tuple("property_location", property, location);

        internal static Tuple properties(Property propKey, string name, Type declaringType, Type memberType, Property unboundProperty) => new Tuple("properties", propKey, name, declaringType, memberType, unboundProperty);

        internal static Tuple ref_returns(IEntity method) => new Tuple("ref_returns", method);

        internal static Tuple ref_readonly_returns(IEntity method) => new Tuple("ref_readonly_returns", method);

        internal static Tuple statements(Statement stmt, StmtKind kind) => new Tuple("statements", stmt, kind);

        internal static Tuple specific_type_parameter_constraints(TypeParameterConstraints constraints, Type baseType) => new Tuple("specific_type_parameter_constraints", constraints, baseType);

        internal static Tuple successors(IEntity from, IEntity to) => new Tuple("successors", from, to);

        internal static Tuple stmt_location(Statement stmt, Location location) => new Tuple("stmt_location", stmt, location);

        internal static Tuple stmt_parent(Statement stmt, int child, IStatementParentEntity parent) => new Tuple("stmt_parent", stmt, child, parent);

        internal static Tuple stmt_parent_top_level(Statement stmt, int child, IStatementParentEntity parent) => new Tuple("stmt_parent_top_level", stmt, child, parent);

        internal static Tuple tuple_element(TupleType type, int index, Field field) => new Tuple("tuple_element", type, index, field);

        internal static Tuple tuple_underlying_type(TupleType type, NamedType underlying) => new Tuple("tuple_underlying_type", type, underlying);

        internal static Tuple type_mention(TypeMention ta, Type type, IEntity parent) => new Tuple("type_mention", ta, type, parent);

        internal static Tuple type_mention_location(TypeMention ta, Location loc) => new Tuple("type_mention_location", ta, loc);

        internal static Tuple type_arguments(Type arg, int n, IEntity typeOrMethod) => new Tuple("type_arguments", arg, n, typeOrMethod);

        internal static Tuple type_location(Type type, Location location) => new Tuple("type_location", type, location);

        internal static Tuple type_parameter_constraints(TypeParameterConstraints constraints, TypeParameter typeParam) => new Tuple("type_parameter_constraints", constraints, typeParam);

        internal static Tuple type_parameters(TypeParameter param, int child, IEntity typeOrMethod) => new Tuple("type_parameters", param, child, typeOrMethod, param.Variance);

        internal static Tuple typeref_type(NamedTypeRef typeref, Type type) => new Tuple("typeref_type", typeref, type);

        internal static Tuple typerefs(NamedTypeRef type, string name) => new Tuple("typerefs", type, name);

        internal static Tuple types(Type type, TypeKind kind, params string[] name) => new Tuple("types", type, kind, name);

        internal static Tuple using_namespace_directives(UsingDirective @using, Namespace ns) => new Tuple("using_namespace_directives", @using, ns);

        internal static Tuple using_directive_location(UsingDirective @using, Location location) => new Tuple("using_directive_location", @using, location);

        internal static Tuple using_static_directives(UsingDirective @using, Type type) => new Tuple("using_static_directives", @using, type);
    }
}
