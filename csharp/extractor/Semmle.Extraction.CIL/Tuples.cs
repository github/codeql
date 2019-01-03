using Semmle.Extraction.CIL.Entities;

namespace Semmle.Extraction.CIL
{

    internal static class Tuples
    {
        internal static Tuple assemblies(Assembly assembly, File file, string identifier, string name, string version) =>
            new Tuple("assemblies", assembly, file, identifier, name, version);

        internal static Tuple cil_abstract(IMember method) =>
            new Tuple("cil_abstract", method);

        internal static Tuple cil_adder(IEvent member, IMethod method) =>
            new Tuple("cil_adder", member, method);

        internal static Tuple cil_access(IInstruction i, IEntity m) =>
            new Tuple("cil_access", i, m);

        internal static Tuple cil_attribute(IAttribute attribute, IEntity @object, IMethod constructor) =>
            new Tuple("cil_attribute", attribute, @object, constructor);

        internal static Tuple cil_attribute_named_argument(IAttribute attribute, string name, string value) =>
            new Tuple("cil_attribute_named_argument", attribute, name, value);

        internal static Tuple cil_attribute_positional_argument(IAttribute attribute, int index, string value) =>
            new Tuple("cil_attribute_positional_argument", attribute, index, value);

        internal static Tuple cil_array_type(IArrayType array, IType element, int rank) =>
            new Tuple("cil_array_type", array, element, rank);

        internal static Tuple cil_base_class(IType t, IType @base) =>
            new Tuple("cil_base_class", t, @base);

        internal static Tuple cil_base_interface(IType t, IType @base) =>
            new Tuple("cil_base_interface", t, @base);

        internal static Tuple cil_class(IMember method) =>
            new Tuple("cil_class", method);

        internal static Tuple cil_event(IEvent e, IType parent, string name, IType type) =>
            new Tuple("cil_event", e, parent, name, type);

        internal static Tuple cil_field(IField field, IType parent, string name, IType fieldType) =>
            new Tuple("cil_field", field, parent, name, fieldType);

        internal static Tuple cil_getter(IProperty member, IMethod method) =>
            new Tuple("cil_getter", member, method);

        internal static Tuple cil_handler(IExceptionRegion region, IMethodImplementation method, int index, int kind,
            IInstruction region_start,
            IInstruction region_end,
            IInstruction handler_start) =>
            new Tuple("cil_handler", region, method, index, kind, region_start, region_end, handler_start);

        internal static Tuple cil_handler_filter(IExceptionRegion region, IInstruction filter_start) =>
            new Tuple("cil_handler_filter", region, filter_start);

        internal static Tuple cil_handler_type(IExceptionRegion region, Type t) =>
            new Tuple("cil_handler_type", region, t);

        internal static Tuple cil_implements(IMethod derived, IMethod declaration) =>
            new Tuple("cil_implements", derived, declaration);

        internal static Tuple cil_instruction(IInstruction instruction, int opcode, int index, IMethodImplementation parent) =>
            new Tuple("cil_instruction", instruction, opcode, index, parent);

        internal static Tuple cil_instruction_location(Instruction i, ILocation loc) =>
            new Tuple("cil_instruction_location", i, loc);

        internal static Tuple cil_interface(IMember method) =>
            new Tuple("cil_interface", method);

        internal static Tuple cil_internal(IMember modifiable) =>
            new Tuple("cil_internal", modifiable);

        internal static Tuple cil_jump(IInstruction from, IInstruction to) =>
            new Tuple("cil_jump", from, to);

        internal static Tuple cil_local_variable(ILocal l, IMethodImplementation m, int i, Type t) =>
            new Tuple("cil_local_variable", l, m, i, t);

        internal static Tuple cil_method(IMethod method, string name, IType declType, IType returnType) =>
            new Tuple("cil_method", method, name, declType, returnType);

        internal static Tuple cil_method_implementation(IMethodImplementation impl, IMethod method, IAssembly assembly) =>
            new Tuple("cil_method_implementation", impl, method, assembly);

        internal static Tuple cil_method_location(IMethod m, ILocation a) =>
            new Tuple("cil_method_location", m, a);

        internal static Tuple cil_method_source_declaration(IMethod method, IMethod sourceDecl) =>
            new Tuple("cil_method_source_declaration", method, sourceDecl);

        internal static Tuple cil_method_stack_size(IMethodImplementation method, int stackSize) =>
            new Tuple("cil_method_stack_size", method, stackSize);

        internal static Tuple cil_newslot(IMethod method) =>
            new Tuple("cil_newslot", method);

        internal static Tuple cil_parameter(IParameter p, IMethod m, int i, IType t) =>
            new Tuple("cil_parameter", p, m, i, t);

        internal static Tuple cil_parameter_in(IParameter p) =>
            new Tuple("cil_parameter_in", p);

        internal static Tuple cil_parameter_out(IParameter p) =>
            new Tuple("cil_parameter_out", p);

        internal static Tuple cil_pointer_type(IPointerType t, IType pointee) =>
            new Tuple("cil_pointer_type", t, pointee);

        internal static Tuple cil_private(IMember modifiable) =>
            new Tuple("cil_private", modifiable);

        internal static Tuple cil_protected(IMember modifiable) =>
            new Tuple("cil_protected", modifiable);

        internal static Tuple cil_property(IProperty p, IType parent, string name, IType propType) =>
            new Tuple("cil_property", p, parent, name, propType);

        internal static Tuple cil_public(IMember modifiable) =>
            new Tuple("cil_public", modifiable);

        internal static Tuple cil_raiser(IEvent member, IMethod method) =>
            new Tuple("cil_raiser", member, method);

        internal static Tuple cil_requiresecobject(IMethod method) =>
            new Tuple("cil_requiresecobject", method);

        internal static Tuple cil_remover(IEvent member, IMethod method) =>
            new Tuple("cil_remover", member, method);

        internal static Tuple cil_sealed(IMember modifiable) =>
            new Tuple("cil_sealed", modifiable);

        internal static Tuple cil_security(IMember method) =>
            new Tuple("cil_security", method);

        internal static Tuple cil_setter(IProperty member, IMethod method) =>
            new Tuple("cil_setter", member, method);

        internal static Tuple cil_specialname(IMethod method) =>
            new Tuple("cil_specialname", method);

        internal static Tuple cil_static(IMember modifiable) =>
            new Tuple("cil_static", modifiable);

        internal static Tuple cil_switch(IInstruction from, int index, IInstruction to) =>
            new Tuple("cil_switch", from, index, to);

        internal static Tuple cil_type(IType t, string name, CilTypeKind kind, ITypeContainer parent, IType sourceDecl) =>
            new Tuple("cil_type", t, name, (int)kind, parent, sourceDecl);

        internal static Tuple cil_type_argument(ITypeContainer constructedTypeOrMethod, int index, IType argument) =>
            new Tuple("cil_type_argument", constructedTypeOrMethod, index, argument);

        internal static Tuple cil_type_location(IType t, IAssembly a) =>
            new Tuple("cil_type_location", t, a);

        internal static Tuple cil_type_parameter(ITypeContainer unboundTypeOrMethod, int index, ITypeParameter parameter) =>
            new Tuple("cil_type_parameter", unboundTypeOrMethod, index, parameter);

        internal static Tuple cil_typeparam_covariant(ITypeParameter p) =>
            new Tuple("cil_typeparam_covariant", p);

        internal static Tuple cil_typeparam_contravariant(ITypeParameter p) =>
            new Tuple("cil_typeparam_contravariant", p);

        internal static Tuple cil_typeparam_class(ITypeParameter p) =>
            new Tuple("cil_typeparam_class", p);

        internal static Tuple cil_typeparam_constraint(ITypeParameter p, IType constraint) =>
            new Tuple("cil_typeparam_constraint", p, constraint);

        internal static Tuple cil_typeparam_new(ITypeParameter p) =>
            new Tuple("cil_typeparam_new", p);

        internal static Tuple cil_typeparam_struct(ITypeParameter p) =>
            new Tuple("cil_typeparam_struct", p);

        internal static Tuple cil_value(IInstruction i, string value) =>
            new Tuple("cil_value", i, value);

        internal static Tuple cil_virtual(IMethod method) =>
            new Tuple("cil_virtual", method);

        internal static Tuple containerparent(IFolder parent, IFileOrFolder child) =>
            new Tuple("containerparent", parent, child);

        internal static Tuple files(IFile file, string fullName, string name, string extension) =>
            new Tuple("files", file, fullName, name, extension, 0);

        internal static Tuple file_extraction_mode(IFile file, int mode) =>
            new Tuple("file_extraction_mode", file, mode);

        internal static Tuple folders(IFolder folder, string path, string name) =>
            new Tuple("folders", folder, path, name);

        internal static Tuple locations_default(ISourceLocation label, IFile file, int startLine, int startCol, int endLine, int endCol) =>
            new Tuple("locations_default", label, file, startLine, startCol, endLine, endCol);

        internal static Tuple metadata_handle(IEntity entity, Assembly assembly, int handleValue) =>
            new Tuple("metadata_handle", entity, assembly, handleValue);

        internal static Tuple namespaces(INamespace ns, string name) =>
            new Tuple("namespaces", ns, name);

        internal static Tuple parent_namespace(ITypeContainer child, INamespace parent) =>
            new Tuple("parent_namespace", child, parent);
    }
}
