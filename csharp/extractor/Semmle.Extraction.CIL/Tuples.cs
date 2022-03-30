using Semmle.Extraction.CIL.Entities;

namespace Semmle.Extraction.CIL
{

    internal static class Tuples
    {
        internal static Tuple assemblies(Assembly assembly, File file, string identifier, string name, string version) =>
            new Tuple("assemblies", assembly, file, identifier, name, version);

        internal static Tuple cil_abstract(IMember method) =>
            new Tuple("cil_abstract", method);

        internal static Tuple cil_adder(Event member, Method method) =>
            new Tuple("cil_adder", member, method);

        internal static Tuple cil_access(Instruction i, IExtractedEntity m) =>
            new Tuple("cil_access", i, m);

        internal static Tuple cil_attribute(Attribute attribute, IExtractedEntity @object, Method constructor) =>
            new Tuple("cil_attribute", attribute, @object, constructor);

        internal static Tuple cil_attribute_named_argument(Attribute attribute, string name, string value) =>
            new Tuple("cil_attribute_named_argument", attribute, name, value);

        internal static Tuple cil_attribute_positional_argument(Attribute attribute, int index, string value) =>
            new Tuple("cil_attribute_positional_argument", attribute, index, value);

        internal static Tuple cil_array_type(ArrayType array, Type element, int rank) =>
            new Tuple("cil_array_type", array, element, rank);

        internal static Tuple cil_base_class(Type t, Type @base) =>
            new Tuple("cil_base_class", t, @base);

        internal static Tuple cil_enum_underlying_type(Type t, PrimitiveType underlying) =>
            new Tuple("cil_enum_underlying_type", t, underlying);

        internal static Tuple cil_base_interface(Type t, Type @base) =>
            new Tuple("cil_base_interface", t, @base);

        internal static Tuple cil_class(TypeDefinitionType type) =>
            new Tuple("cil_class", type);

        internal static Tuple cil_event(Event e, Type parent, string name, Type type) =>
            new Tuple("cil_event", e, parent, name, type);

        internal static Tuple cil_field(Field field, Type parent, string name, Type fieldType) =>
            new Tuple("cil_field", field, parent, name, fieldType);

        internal static Tuple cil_getter(Property member, Method method) =>
            new Tuple("cil_getter", member, method);

        internal static Tuple cil_handler(ExceptionRegion region, MethodImplementation method, int index, int kind,
            Instruction region_start,
            Instruction region_end,
            Instruction handler_start) =>
            new Tuple("cil_handler", region, method, index, kind, region_start, region_end, handler_start);

        internal static Tuple cil_handler_filter(ExceptionRegion region, Instruction filter_start) =>
            new Tuple("cil_handler_filter", region, filter_start);

        internal static Tuple cil_handler_type(ExceptionRegion region, Type t) =>
            new Tuple("cil_handler_type", region, t);

        internal static Tuple cil_implements(Method derived, Method declaration) =>
            new Tuple("cil_implements", derived, declaration);

        internal static Tuple cil_instruction(Instruction instruction, int opcode, int index, MethodImplementation parent) =>
            new Tuple("cil_instruction", instruction, opcode, index, parent);

        internal static Tuple cil_instruction_location(Instruction i, PdbSourceLocation loc) =>
            new Tuple("cil_instruction_location", i, loc);

        internal static Tuple cil_interface(TypeDefinitionType type) =>
            new Tuple("cil_interface", type);

        internal static Tuple cil_internal(DefinitionField field) =>
            new Tuple("cil_internal", field);

        internal static Tuple cil_jump(Instruction from, Instruction to) =>
            new Tuple("cil_jump", from, to);

        internal static Tuple cil_local_variable(LocalVariable l, MethodImplementation m, int i, Type t) =>
            new Tuple("cil_local_variable", l, m, i, t);

        internal static Tuple cil_method(Method method, string name, Type declType, Type returnType) =>
            new Tuple("cil_method", method, name, declType, returnType);

        internal static Tuple cil_function_pointer_return_type(FunctionPointerType fnptr, Type returnType) =>
            new Tuple("cil_function_pointer_return_type", fnptr, returnType);

        internal static Tuple cil_function_pointer_calling_conventions(FunctionPointerType fnptr, System.Reflection.Metadata.SignatureCallingConvention callingConvention) =>
            new Tuple("cil_function_pointer_calling_conventions", fnptr, (int)callingConvention);

        internal static Tuple cil_method_implementation(MethodImplementation impl, Method method, Assembly assembly) =>
            new Tuple("cil_method_implementation", impl, method, assembly);

        internal static Tuple cil_method_location(Method m, ILocation a) =>
            new Tuple("cil_method_location", m, a);

        internal static Tuple cil_method_source_declaration(Method method, Method sourceDecl) =>
            new Tuple("cil_method_source_declaration", method, sourceDecl);

        internal static Tuple cil_method_stack_size(MethodImplementation method, int stackSize) =>
            new Tuple("cil_method_stack_size", method, stackSize);

        internal static Tuple cil_newslot(Method method) =>
            new Tuple("cil_newslot", method);

        internal static Tuple cil_parameter(Parameter p, IParameterizable m, int i, Type t) =>
            new Tuple("cil_parameter", p, m, i, t);

        internal static Tuple cil_parameter_in(Parameter p) =>
            new Tuple("cil_parameter_in", p);

        internal static Tuple cil_parameter_out(Parameter p) =>
            new Tuple("cil_parameter_out", p);

        internal static Tuple cil_pointer_type(PointerType t, Type pointee) =>
            new Tuple("cil_pointer_type", t, pointee);

        internal static Tuple cil_private(IMember modifiable) =>
            new Tuple("cil_private", modifiable);

        internal static Tuple cil_protected(IMember modifiable) =>
            new Tuple("cil_protected", modifiable);

        internal static Tuple cil_property(Property p, Type parent, string name, Type propType) =>
            new Tuple("cil_property", p, parent, name, propType);

        internal static Tuple cil_public(IMember modifiable) =>
            new Tuple("cil_public", modifiable);

        internal static Tuple cil_raiser(Event member, Method method) =>
            new Tuple("cil_raiser", member, method);

        internal static Tuple cil_requiresecobject(Method method) =>
            new Tuple("cil_requiresecobject", method);

        internal static Tuple cil_remover(Event member, Method method) =>
            new Tuple("cil_remover", member, method);

        internal static Tuple cil_sealed(IMember modifiable) =>
            new Tuple("cil_sealed", modifiable);

        internal static Tuple cil_security(IMember method) =>
            new Tuple("cil_security", method);

        internal static Tuple cil_setter(Property member, Method method) =>
            new Tuple("cil_setter", member, method);

        internal static Tuple cil_specialname(Method method) =>
            new Tuple("cil_specialname", method);

        internal static Tuple cil_static(IMember modifiable) =>
            new Tuple("cil_static", modifiable);

        internal static Tuple cil_switch(Instruction from, int index, Instruction to) =>
            new Tuple("cil_switch", from, index, to);

        internal static Tuple cil_type(Type t, string name, CilTypeKind kind, TypeContainer parent, Type sourceDecl) =>
            new Tuple("cil_type", t, name, (int)kind, parent, sourceDecl);

        internal static Tuple cil_type_argument(TypeContainer constructedTypeOrMethod, int index, Type argument) =>
            new Tuple("cil_type_argument", constructedTypeOrMethod, index, argument);

        internal static Tuple cil_type_location(Type t, Assembly a) =>
            new Tuple("cil_type_location", t, a);

        internal static Tuple cil_type_parameter(TypeContainer unboundTypeOrMethod, int index, TypeParameter parameter) =>
            new Tuple("cil_type_parameter", unboundTypeOrMethod, index, parameter);

        internal static Tuple cil_typeparam_covariant(TypeParameter p) =>
            new Tuple("cil_typeparam_covariant", p);

        internal static Tuple cil_typeparam_contravariant(TypeParameter p) =>
            new Tuple("cil_typeparam_contravariant", p);

        internal static Tuple cil_typeparam_class(TypeParameter p) =>
            new Tuple("cil_typeparam_class", p);

        internal static Tuple cil_typeparam_constraint(TypeParameter p, Type constraint) =>
            new Tuple("cil_typeparam_constraint", p, constraint);

        internal static Tuple cil_typeparam_new(TypeParameter p) =>
            new Tuple("cil_typeparam_new", p);

        internal static Tuple cil_typeparam_struct(TypeParameter p) =>
            new Tuple("cil_typeparam_struct", p);

        internal static Tuple cil_value(Instruction i, string value) =>
            new Tuple("cil_value", i, value);

        internal static Tuple cil_virtual(Method method) =>
            new Tuple("cil_virtual", method);

        internal static Tuple cil_custom_modifiers(ICustomModifierReceiver receiver, Type modifier, bool isRequired) =>
            new Tuple("cil_custom_modifiers", receiver, modifier, isRequired ? 1 : 0);

        internal static Tuple cil_type_annotation(IExtractedEntity receiver, TypeAnnotation annotation) =>
            new Tuple("cil_type_annotation", receiver, (int)annotation);

        internal static Tuple containerparent(Folder parent, IFileOrFolder child) =>
            new Tuple("containerparent", parent, child);

        internal static Tuple files(File file, string fullName) =>
            new Tuple("files", file, fullName);

        internal static Tuple file_extraction_mode(File file, ExtractorMode mode) =>
            new Tuple("file_extraction_mode", file, mode);

        internal static Tuple folders(Folder folder, string path) =>
            new Tuple("folders", folder, path);

        internal static Tuple locations_default(PdbSourceLocation label, File file, int startLine, int startCol, int endLine, int endCol) =>
            new Tuple("locations_default", label, file, startLine, startCol, endLine, endCol);

        internal static Tuple metadata_handle(IExtractedEntity entity, Assembly assembly, int handleValue) =>
            new Tuple("metadata_handle", entity, assembly, handleValue);

        internal static Tuple namespaces(Namespace ns, string name) =>
            new Tuple("namespaces", ns, name);

        internal static Tuple parent_namespace(TypeContainer child, Namespace parent) =>
            new Tuple("parent_namespace", child, parent);
    }
}
