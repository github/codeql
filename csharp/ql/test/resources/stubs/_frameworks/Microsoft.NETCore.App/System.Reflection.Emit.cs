// This file contains auto-generated code.
// Generated from `System.Reflection.Emit, Version=8.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`.
namespace System
{
    namespace Reflection
    {
        namespace Emit
        {
            public abstract class AssemblyBuilder : System.Reflection.Assembly
            {
                public override string CodeBase { get => throw null; }
                protected AssemblyBuilder() => throw null;
                public static System.Reflection.Emit.AssemblyBuilder DefineDynamicAssembly(System.Reflection.AssemblyName name, System.Reflection.Emit.AssemblyBuilderAccess access) => throw null;
                public static System.Reflection.Emit.AssemblyBuilder DefineDynamicAssembly(System.Reflection.AssemblyName name, System.Reflection.Emit.AssemblyBuilderAccess access, System.Collections.Generic.IEnumerable<System.Reflection.Emit.CustomAttributeBuilder> assemblyAttributes) => throw null;
                public System.Reflection.Emit.ModuleBuilder DefineDynamicModule(string name) => throw null;
                protected abstract System.Reflection.Emit.ModuleBuilder DefineDynamicModuleCore(string name);
                public override System.Reflection.MethodInfo EntryPoint { get => throw null; }
                public override bool Equals(object obj) => throw null;
                public override string FullName { get => throw null; }
                public override object[] GetCustomAttributes(bool inherit) => throw null;
                public override object[] GetCustomAttributes(System.Type attributeType, bool inherit) => throw null;
                public override System.Collections.Generic.IList<System.Reflection.CustomAttributeData> GetCustomAttributesData() => throw null;
                public System.Reflection.Emit.ModuleBuilder GetDynamicModule(string name) => throw null;
                protected abstract System.Reflection.Emit.ModuleBuilder GetDynamicModuleCore(string name);
                public override System.Type[] GetExportedTypes() => throw null;
                public override System.IO.FileStream GetFile(string name) => throw null;
                public override System.IO.FileStream[] GetFiles(bool getResourceModules) => throw null;
                public override int GetHashCode() => throw null;
                public override System.Reflection.Module[] GetLoadedModules(bool getResourceModules) => throw null;
                public override System.Reflection.ManifestResourceInfo GetManifestResourceInfo(string resourceName) => throw null;
                public override string[] GetManifestResourceNames() => throw null;
                public override System.IO.Stream GetManifestResourceStream(string name) => throw null;
                public override System.IO.Stream GetManifestResourceStream(System.Type type, string name) => throw null;
                public override System.Reflection.Module GetModule(string name) => throw null;
                public override System.Reflection.Module[] GetModules(bool getResourceModules) => throw null;
                public override System.Reflection.AssemblyName GetName(bool copiedName) => throw null;
                public override System.Reflection.AssemblyName[] GetReferencedAssemblies() => throw null;
                public override System.Reflection.Assembly GetSatelliteAssembly(System.Globalization.CultureInfo culture) => throw null;
                public override System.Reflection.Assembly GetSatelliteAssembly(System.Globalization.CultureInfo culture, System.Version version) => throw null;
                public override System.Type GetType(string name, bool throwOnError, bool ignoreCase) => throw null;
                public override long HostContext { get => throw null; }
                public override bool IsCollectible { get => throw null; }
                public override bool IsDefined(System.Type attributeType, bool inherit) => throw null;
                public override bool IsDynamic { get => throw null; }
                public override string Location { get => throw null; }
                public override System.Reflection.Module ManifestModule { get => throw null; }
                public override bool ReflectionOnly { get => throw null; }
                public void SetCustomAttribute(System.Reflection.ConstructorInfo con, byte[] binaryAttribute) => throw null;
                public void SetCustomAttribute(System.Reflection.Emit.CustomAttributeBuilder customBuilder) => throw null;
                protected abstract void SetCustomAttributeCore(System.Reflection.ConstructorInfo con, System.ReadOnlySpan<byte> binaryAttribute);
            }
            [System.Flags]
            public enum AssemblyBuilderAccess
            {
                Run = 1,
                RunAndCollect = 9,
            }
            public abstract class ConstructorBuilder : System.Reflection.ConstructorInfo
            {
                public override System.Reflection.MethodAttributes Attributes { get => throw null; }
                public override System.Reflection.CallingConventions CallingConvention { get => throw null; }
                protected ConstructorBuilder() => throw null;
                public override System.Type DeclaringType { get => throw null; }
                public System.Reflection.Emit.ParameterBuilder DefineParameter(int iSequence, System.Reflection.ParameterAttributes attributes, string strParamName) => throw null;
                protected abstract System.Reflection.Emit.ParameterBuilder DefineParameterCore(int iSequence, System.Reflection.ParameterAttributes attributes, string strParamName);
                public override object[] GetCustomAttributes(bool inherit) => throw null;
                public override object[] GetCustomAttributes(System.Type attributeType, bool inherit) => throw null;
                public System.Reflection.Emit.ILGenerator GetILGenerator() => throw null;
                public System.Reflection.Emit.ILGenerator GetILGenerator(int streamSize) => throw null;
                protected abstract System.Reflection.Emit.ILGenerator GetILGeneratorCore(int streamSize);
                public override System.Reflection.MethodImplAttributes GetMethodImplementationFlags() => throw null;
                public override System.Reflection.ParameterInfo[] GetParameters() => throw null;
                public bool InitLocals { get => throw null; set { } }
                protected abstract bool InitLocalsCore { get; set; }
                public override object Invoke(object obj, System.Reflection.BindingFlags invokeAttr, System.Reflection.Binder binder, object[] parameters, System.Globalization.CultureInfo culture) => throw null;
                public override object Invoke(System.Reflection.BindingFlags invokeAttr, System.Reflection.Binder binder, object[] parameters, System.Globalization.CultureInfo culture) => throw null;
                public override bool IsDefined(System.Type attributeType, bool inherit) => throw null;
                public override int MetadataToken { get => throw null; }
                public override System.RuntimeMethodHandle MethodHandle { get => throw null; }
                public override System.Reflection.Module Module { get => throw null; }
                public override string Name { get => throw null; }
                public override System.Type ReflectedType { get => throw null; }
                public void SetCustomAttribute(System.Reflection.ConstructorInfo con, byte[] binaryAttribute) => throw null;
                public void SetCustomAttribute(System.Reflection.Emit.CustomAttributeBuilder customBuilder) => throw null;
                protected abstract void SetCustomAttributeCore(System.Reflection.ConstructorInfo con, System.ReadOnlySpan<byte> binaryAttribute);
                public void SetImplementationFlags(System.Reflection.MethodImplAttributes attributes) => throw null;
                protected abstract void SetImplementationFlagsCore(System.Reflection.MethodImplAttributes attributes);
                public override string ToString() => throw null;
            }
            public abstract class EnumBuilder : System.Reflection.TypeInfo
            {
                public override System.Reflection.Assembly Assembly { get => throw null; }
                public override string AssemblyQualifiedName { get => throw null; }
                public override System.Type BaseType { get => throw null; }
                public System.Type CreateType() => throw null;
                public System.Reflection.TypeInfo CreateTypeInfo() => throw null;
                protected abstract System.Reflection.TypeInfo CreateTypeInfoCore();
                protected EnumBuilder() => throw null;
                public override System.Type DeclaringType { get => throw null; }
                public System.Reflection.Emit.FieldBuilder DefineLiteral(string literalName, object literalValue) => throw null;
                protected abstract System.Reflection.Emit.FieldBuilder DefineLiteralCore(string literalName, object literalValue);
                public override string FullName { get => throw null; }
                protected override System.Reflection.TypeAttributes GetAttributeFlagsImpl() => throw null;
                protected override System.Reflection.ConstructorInfo GetConstructorImpl(System.Reflection.BindingFlags bindingAttr, System.Reflection.Binder binder, System.Reflection.CallingConventions callConvention, System.Type[] types, System.Reflection.ParameterModifier[] modifiers) => throw null;
                public override System.Reflection.ConstructorInfo[] GetConstructors(System.Reflection.BindingFlags bindingAttr) => throw null;
                public override object[] GetCustomAttributes(bool inherit) => throw null;
                public override object[] GetCustomAttributes(System.Type attributeType, bool inherit) => throw null;
                public override System.Type GetElementType() => throw null;
                public override System.Type GetEnumUnderlyingType() => throw null;
                public override System.Reflection.EventInfo GetEvent(string name, System.Reflection.BindingFlags bindingAttr) => throw null;
                public override System.Reflection.EventInfo[] GetEvents() => throw null;
                public override System.Reflection.EventInfo[] GetEvents(System.Reflection.BindingFlags bindingAttr) => throw null;
                public override System.Reflection.FieldInfo GetField(string name, System.Reflection.BindingFlags bindingAttr) => throw null;
                public override System.Reflection.FieldInfo[] GetFields(System.Reflection.BindingFlags bindingAttr) => throw null;
                public override System.Type GetInterface(string name, bool ignoreCase) => throw null;
                public override System.Reflection.InterfaceMapping GetInterfaceMap(System.Type interfaceType) => throw null;
                public override System.Type[] GetInterfaces() => throw null;
                public override System.Reflection.MemberInfo[] GetMember(string name, System.Reflection.MemberTypes type, System.Reflection.BindingFlags bindingAttr) => throw null;
                public override System.Reflection.MemberInfo[] GetMembers(System.Reflection.BindingFlags bindingAttr) => throw null;
                protected override System.Reflection.MethodInfo GetMethodImpl(string name, System.Reflection.BindingFlags bindingAttr, System.Reflection.Binder binder, System.Reflection.CallingConventions callConvention, System.Type[] types, System.Reflection.ParameterModifier[] modifiers) => throw null;
                public override System.Reflection.MethodInfo[] GetMethods(System.Reflection.BindingFlags bindingAttr) => throw null;
                public override System.Type GetNestedType(string name, System.Reflection.BindingFlags bindingAttr) => throw null;
                public override System.Type[] GetNestedTypes(System.Reflection.BindingFlags bindingAttr) => throw null;
                public override System.Reflection.PropertyInfo[] GetProperties(System.Reflection.BindingFlags bindingAttr) => throw null;
                protected override System.Reflection.PropertyInfo GetPropertyImpl(string name, System.Reflection.BindingFlags bindingAttr, System.Reflection.Binder binder, System.Type returnType, System.Type[] types, System.Reflection.ParameterModifier[] modifiers) => throw null;
                public override System.Guid GUID { get => throw null; }
                protected override bool HasElementTypeImpl() => throw null;
                public override object InvokeMember(string name, System.Reflection.BindingFlags invokeAttr, System.Reflection.Binder binder, object target, object[] args, System.Reflection.ParameterModifier[] modifiers, System.Globalization.CultureInfo culture, string[] namedParameters) => throw null;
                protected override bool IsArrayImpl() => throw null;
                public override bool IsAssignableFrom(System.Reflection.TypeInfo typeInfo) => throw null;
                protected override bool IsByRefImpl() => throw null;
                public override bool IsByRefLike { get => throw null; }
                protected override bool IsCOMObjectImpl() => throw null;
                public override bool IsConstructedGenericType { get => throw null; }
                public override bool IsDefined(System.Type attributeType, bool inherit) => throw null;
                protected override bool IsPointerImpl() => throw null;
                protected override bool IsPrimitiveImpl() => throw null;
                public override bool IsSZArray { get => throw null; }
                public override bool IsTypeDefinition { get => throw null; }
                protected override bool IsValueTypeImpl() => throw null;
                public override System.Type MakeArrayType() => throw null;
                public override System.Type MakeArrayType(int rank) => throw null;
                public override System.Type MakeByRefType() => throw null;
                public override System.Type MakePointerType() => throw null;
                public override System.Reflection.Module Module { get => throw null; }
                public override string Name { get => throw null; }
                public override string Namespace { get => throw null; }
                public override System.Type ReflectedType { get => throw null; }
                public void SetCustomAttribute(System.Reflection.ConstructorInfo con, byte[] binaryAttribute) => throw null;
                public void SetCustomAttribute(System.Reflection.Emit.CustomAttributeBuilder customBuilder) => throw null;
                protected abstract void SetCustomAttributeCore(System.Reflection.ConstructorInfo con, System.ReadOnlySpan<byte> binaryAttribute);
                public override System.RuntimeTypeHandle TypeHandle { get => throw null; }
                public System.Reflection.Emit.FieldBuilder UnderlyingField { get => throw null; }
                protected abstract System.Reflection.Emit.FieldBuilder UnderlyingFieldCore { get; }
                public override System.Type UnderlyingSystemType { get => throw null; }
            }
            public abstract class EventBuilder
            {
                public void AddOtherMethod(System.Reflection.Emit.MethodBuilder mdBuilder) => throw null;
                protected abstract void AddOtherMethodCore(System.Reflection.Emit.MethodBuilder mdBuilder);
                protected EventBuilder() => throw null;
                public void SetAddOnMethod(System.Reflection.Emit.MethodBuilder mdBuilder) => throw null;
                protected abstract void SetAddOnMethodCore(System.Reflection.Emit.MethodBuilder mdBuilder);
                public void SetCustomAttribute(System.Reflection.ConstructorInfo con, byte[] binaryAttribute) => throw null;
                public void SetCustomAttribute(System.Reflection.Emit.CustomAttributeBuilder customBuilder) => throw null;
                protected abstract void SetCustomAttributeCore(System.Reflection.ConstructorInfo con, System.ReadOnlySpan<byte> binaryAttribute);
                public void SetRaiseMethod(System.Reflection.Emit.MethodBuilder mdBuilder) => throw null;
                protected abstract void SetRaiseMethodCore(System.Reflection.Emit.MethodBuilder mdBuilder);
                public void SetRemoveOnMethod(System.Reflection.Emit.MethodBuilder mdBuilder) => throw null;
                protected abstract void SetRemoveOnMethodCore(System.Reflection.Emit.MethodBuilder mdBuilder);
            }
            public abstract class FieldBuilder : System.Reflection.FieldInfo
            {
                public override System.Reflection.FieldAttributes Attributes { get => throw null; }
                protected FieldBuilder() => throw null;
                public override System.Type DeclaringType { get => throw null; }
                public override System.RuntimeFieldHandle FieldHandle { get => throw null; }
                public override System.Type FieldType { get => throw null; }
                public override object[] GetCustomAttributes(bool inherit) => throw null;
                public override object[] GetCustomAttributes(System.Type attributeType, bool inherit) => throw null;
                public override object GetValue(object obj) => throw null;
                public override bool IsDefined(System.Type attributeType, bool inherit) => throw null;
                public override int MetadataToken { get => throw null; }
                public override System.Reflection.Module Module { get => throw null; }
                public override string Name { get => throw null; }
                public override System.Type ReflectedType { get => throw null; }
                public void SetConstant(object defaultValue) => throw null;
                protected abstract void SetConstantCore(object defaultValue);
                public void SetCustomAttribute(System.Reflection.ConstructorInfo con, byte[] binaryAttribute) => throw null;
                public void SetCustomAttribute(System.Reflection.Emit.CustomAttributeBuilder customBuilder) => throw null;
                protected abstract void SetCustomAttributeCore(System.Reflection.ConstructorInfo con, System.ReadOnlySpan<byte> binaryAttribute);
                public void SetOffset(int iOffset) => throw null;
                protected abstract void SetOffsetCore(int iOffset);
                public override void SetValue(object obj, object val, System.Reflection.BindingFlags invokeAttr, System.Reflection.Binder binder, System.Globalization.CultureInfo culture) => throw null;
            }
            public abstract class GenericTypeParameterBuilder : System.Reflection.TypeInfo
            {
                public override System.Reflection.Assembly Assembly { get => throw null; }
                public override string AssemblyQualifiedName { get => throw null; }
                public override System.Type BaseType { get => throw null; }
                public override bool ContainsGenericParameters { get => throw null; }
                protected GenericTypeParameterBuilder() => throw null;
                public override System.Reflection.MethodBase DeclaringMethod { get => throw null; }
                public override System.Type DeclaringType { get => throw null; }
                public override bool Equals(object o) => throw null;
                public override string FullName { get => throw null; }
                public override System.Reflection.GenericParameterAttributes GenericParameterAttributes { get => throw null; }
                public override int GenericParameterPosition { get => throw null; }
                protected override System.Reflection.TypeAttributes GetAttributeFlagsImpl() => throw null;
                protected override System.Reflection.ConstructorInfo GetConstructorImpl(System.Reflection.BindingFlags bindingAttr, System.Reflection.Binder binder, System.Reflection.CallingConventions callConvention, System.Type[] types, System.Reflection.ParameterModifier[] modifiers) => throw null;
                public override System.Reflection.ConstructorInfo[] GetConstructors(System.Reflection.BindingFlags bindingAttr) => throw null;
                public override object[] GetCustomAttributes(bool inherit) => throw null;
                public override object[] GetCustomAttributes(System.Type attributeType, bool inherit) => throw null;
                public override System.Type GetElementType() => throw null;
                public override System.Reflection.EventInfo GetEvent(string name, System.Reflection.BindingFlags bindingAttr) => throw null;
                public override System.Reflection.EventInfo[] GetEvents() => throw null;
                public override System.Reflection.EventInfo[] GetEvents(System.Reflection.BindingFlags bindingAttr) => throw null;
                public override System.Reflection.FieldInfo GetField(string name, System.Reflection.BindingFlags bindingAttr) => throw null;
                public override System.Reflection.FieldInfo[] GetFields(System.Reflection.BindingFlags bindingAttr) => throw null;
                public override System.Type[] GetGenericArguments() => throw null;
                public override System.Type GetGenericTypeDefinition() => throw null;
                public override int GetHashCode() => throw null;
                public override System.Type GetInterface(string name, bool ignoreCase) => throw null;
                public override System.Reflection.InterfaceMapping GetInterfaceMap(System.Type interfaceType) => throw null;
                public override System.Type[] GetInterfaces() => throw null;
                public override System.Reflection.MemberInfo[] GetMember(string name, System.Reflection.MemberTypes type, System.Reflection.BindingFlags bindingAttr) => throw null;
                public override System.Reflection.MemberInfo[] GetMembers(System.Reflection.BindingFlags bindingAttr) => throw null;
                protected override System.Reflection.MethodInfo GetMethodImpl(string name, System.Reflection.BindingFlags bindingAttr, System.Reflection.Binder binder, System.Reflection.CallingConventions callConvention, System.Type[] types, System.Reflection.ParameterModifier[] modifiers) => throw null;
                public override System.Reflection.MethodInfo[] GetMethods(System.Reflection.BindingFlags bindingAttr) => throw null;
                public override System.Type GetNestedType(string name, System.Reflection.BindingFlags bindingAttr) => throw null;
                public override System.Type[] GetNestedTypes(System.Reflection.BindingFlags bindingAttr) => throw null;
                public override System.Reflection.PropertyInfo[] GetProperties(System.Reflection.BindingFlags bindingAttr) => throw null;
                protected override System.Reflection.PropertyInfo GetPropertyImpl(string name, System.Reflection.BindingFlags bindingAttr, System.Reflection.Binder binder, System.Type returnType, System.Type[] types, System.Reflection.ParameterModifier[] modifiers) => throw null;
                public override System.Guid GUID { get => throw null; }
                protected override bool HasElementTypeImpl() => throw null;
                public override object InvokeMember(string name, System.Reflection.BindingFlags invokeAttr, System.Reflection.Binder binder, object target, object[] args, System.Reflection.ParameterModifier[] modifiers, System.Globalization.CultureInfo culture, string[] namedParameters) => throw null;
                protected override bool IsArrayImpl() => throw null;
                public override bool IsAssignableFrom(System.Reflection.TypeInfo typeInfo) => throw null;
                public override bool IsAssignableFrom(System.Type c) => throw null;
                protected override bool IsByRefImpl() => throw null;
                public override bool IsByRefLike { get => throw null; }
                protected override bool IsCOMObjectImpl() => throw null;
                public override bool IsConstructedGenericType { get => throw null; }
                public override bool IsDefined(System.Type attributeType, bool inherit) => throw null;
                public override bool IsGenericParameter { get => throw null; }
                public override bool IsGenericType { get => throw null; }
                public override bool IsGenericTypeDefinition { get => throw null; }
                protected override bool IsPointerImpl() => throw null;
                protected override bool IsPrimitiveImpl() => throw null;
                public override bool IsSubclassOf(System.Type c) => throw null;
                public override bool IsSZArray { get => throw null; }
                public override bool IsTypeDefinition { get => throw null; }
                protected override bool IsValueTypeImpl() => throw null;
                public override System.Type MakeArrayType() => throw null;
                public override System.Type MakeArrayType(int rank) => throw null;
                public override System.Type MakeByRefType() => throw null;
                public override System.Type MakeGenericType(params System.Type[] typeArguments) => throw null;
                public override System.Type MakePointerType() => throw null;
                public override int MetadataToken { get => throw null; }
                public override System.Reflection.Module Module { get => throw null; }
                public override string Name { get => throw null; }
                public override string Namespace { get => throw null; }
                public override System.Type ReflectedType { get => throw null; }
                public void SetBaseTypeConstraint(System.Type baseTypeConstraint) => throw null;
                protected abstract void SetBaseTypeConstraintCore(System.Type baseTypeConstraint);
                public void SetCustomAttribute(System.Reflection.ConstructorInfo con, byte[] binaryAttribute) => throw null;
                public void SetCustomAttribute(System.Reflection.Emit.CustomAttributeBuilder customBuilder) => throw null;
                protected abstract void SetCustomAttributeCore(System.Reflection.ConstructorInfo con, System.ReadOnlySpan<byte> binaryAttribute);
                public void SetGenericParameterAttributes(System.Reflection.GenericParameterAttributes genericParameterAttributes) => throw null;
                protected abstract void SetGenericParameterAttributesCore(System.Reflection.GenericParameterAttributes genericParameterAttributes);
                public void SetInterfaceConstraints(params System.Type[] interfaceConstraints) => throw null;
                protected abstract void SetInterfaceConstraintsCore(params System.Type[] interfaceConstraints);
                public override string ToString() => throw null;
                public override System.RuntimeTypeHandle TypeHandle { get => throw null; }
                public override System.Type UnderlyingSystemType { get => throw null; }
            }
            public abstract class MethodBuilder : System.Reflection.MethodInfo
            {
                public override System.Reflection.MethodAttributes Attributes { get => throw null; }
                public override System.Reflection.CallingConventions CallingConvention { get => throw null; }
                public override bool ContainsGenericParameters { get => throw null; }
                protected MethodBuilder() => throw null;
                public override System.Type DeclaringType { get => throw null; }
                public System.Reflection.Emit.GenericTypeParameterBuilder[] DefineGenericParameters(params string[] names) => throw null;
                protected abstract System.Reflection.Emit.GenericTypeParameterBuilder[] DefineGenericParametersCore(params string[] names);
                public System.Reflection.Emit.ParameterBuilder DefineParameter(int position, System.Reflection.ParameterAttributes attributes, string strParamName) => throw null;
                protected abstract System.Reflection.Emit.ParameterBuilder DefineParameterCore(int position, System.Reflection.ParameterAttributes attributes, string strParamName);
                public override bool Equals(object obj) => throw null;
                public override System.Reflection.MethodInfo GetBaseDefinition() => throw null;
                public override object[] GetCustomAttributes(bool inherit) => throw null;
                public override object[] GetCustomAttributes(System.Type attributeType, bool inherit) => throw null;
                public override System.Type[] GetGenericArguments() => throw null;
                public override System.Reflection.MethodInfo GetGenericMethodDefinition() => throw null;
                public override int GetHashCode() => throw null;
                public System.Reflection.Emit.ILGenerator GetILGenerator() => throw null;
                public System.Reflection.Emit.ILGenerator GetILGenerator(int size) => throw null;
                protected abstract System.Reflection.Emit.ILGenerator GetILGeneratorCore(int size);
                public override System.Reflection.MethodImplAttributes GetMethodImplementationFlags() => throw null;
                public override System.Reflection.ParameterInfo[] GetParameters() => throw null;
                public bool InitLocals { get => throw null; set { } }
                protected abstract bool InitLocalsCore { get; set; }
                public override object Invoke(object obj, System.Reflection.BindingFlags invokeAttr, System.Reflection.Binder binder, object[] parameters, System.Globalization.CultureInfo culture) => throw null;
                public override bool IsDefined(System.Type attributeType, bool inherit) => throw null;
                public override bool IsGenericMethod { get => throw null; }
                public override bool IsGenericMethodDefinition { get => throw null; }
                public override bool IsSecurityCritical { get => throw null; }
                public override bool IsSecuritySafeCritical { get => throw null; }
                public override bool IsSecurityTransparent { get => throw null; }
                public override System.Reflection.MethodInfo MakeGenericMethod(params System.Type[] typeArguments) => throw null;
                public override int MetadataToken { get => throw null; }
                public override System.RuntimeMethodHandle MethodHandle { get => throw null; }
                public override System.Reflection.Module Module { get => throw null; }
                public override string Name { get => throw null; }
                public override System.Type ReflectedType { get => throw null; }
                public override System.Reflection.ParameterInfo ReturnParameter { get => throw null; }
                public override System.Type ReturnType { get => throw null; }
                public override System.Reflection.ICustomAttributeProvider ReturnTypeCustomAttributes { get => throw null; }
                public void SetCustomAttribute(System.Reflection.ConstructorInfo con, byte[] binaryAttribute) => throw null;
                public void SetCustomAttribute(System.Reflection.Emit.CustomAttributeBuilder customBuilder) => throw null;
                protected abstract void SetCustomAttributeCore(System.Reflection.ConstructorInfo con, System.ReadOnlySpan<byte> binaryAttribute);
                public void SetImplementationFlags(System.Reflection.MethodImplAttributes attributes) => throw null;
                protected abstract void SetImplementationFlagsCore(System.Reflection.MethodImplAttributes attributes);
                public void SetParameters(params System.Type[] parameterTypes) => throw null;
                public void SetReturnType(System.Type returnType) => throw null;
                public void SetSignature(System.Type returnType, System.Type[] returnTypeRequiredCustomModifiers, System.Type[] returnTypeOptionalCustomModifiers, System.Type[] parameterTypes, System.Type[][] parameterTypeRequiredCustomModifiers, System.Type[][] parameterTypeOptionalCustomModifiers) => throw null;
                protected abstract void SetSignatureCore(System.Type returnType, System.Type[] returnTypeRequiredCustomModifiers, System.Type[] returnTypeOptionalCustomModifiers, System.Type[] parameterTypes, System.Type[][] parameterTypeRequiredCustomModifiers, System.Type[][] parameterTypeOptionalCustomModifiers);
                public override string ToString() => throw null;
            }
            public abstract class ModuleBuilder : System.Reflection.Module
            {
                public override System.Reflection.Assembly Assembly { get => throw null; }
                public void CreateGlobalFunctions() => throw null;
                protected abstract void CreateGlobalFunctionsCore();
                protected ModuleBuilder() => throw null;
                public System.Reflection.Emit.EnumBuilder DefineEnum(string name, System.Reflection.TypeAttributes visibility, System.Type underlyingType) => throw null;
                protected abstract System.Reflection.Emit.EnumBuilder DefineEnumCore(string name, System.Reflection.TypeAttributes visibility, System.Type underlyingType);
                public System.Reflection.Emit.MethodBuilder DefineGlobalMethod(string name, System.Reflection.MethodAttributes attributes, System.Reflection.CallingConventions callingConvention, System.Type returnType, System.Type[] parameterTypes) => throw null;
                public System.Reflection.Emit.MethodBuilder DefineGlobalMethod(string name, System.Reflection.MethodAttributes attributes, System.Reflection.CallingConventions callingConvention, System.Type returnType, System.Type[] requiredReturnTypeCustomModifiers, System.Type[] optionalReturnTypeCustomModifiers, System.Type[] parameterTypes, System.Type[][] requiredParameterTypeCustomModifiers, System.Type[][] optionalParameterTypeCustomModifiers) => throw null;
                public System.Reflection.Emit.MethodBuilder DefineGlobalMethod(string name, System.Reflection.MethodAttributes attributes, System.Type returnType, System.Type[] parameterTypes) => throw null;
                protected abstract System.Reflection.Emit.MethodBuilder DefineGlobalMethodCore(string name, System.Reflection.MethodAttributes attributes, System.Reflection.CallingConventions callingConvention, System.Type returnType, System.Type[] requiredReturnTypeCustomModifiers, System.Type[] optionalReturnTypeCustomModifiers, System.Type[] parameterTypes, System.Type[][] requiredParameterTypeCustomModifiers, System.Type[][] optionalParameterTypeCustomModifiers);
                public System.Reflection.Emit.FieldBuilder DefineInitializedData(string name, byte[] data, System.Reflection.FieldAttributes attributes) => throw null;
                protected abstract System.Reflection.Emit.FieldBuilder DefineInitializedDataCore(string name, byte[] data, System.Reflection.FieldAttributes attributes);
                public System.Reflection.Emit.MethodBuilder DefinePInvokeMethod(string name, string dllName, System.Reflection.MethodAttributes attributes, System.Reflection.CallingConventions callingConvention, System.Type returnType, System.Type[] parameterTypes, System.Runtime.InteropServices.CallingConvention nativeCallConv, System.Runtime.InteropServices.CharSet nativeCharSet) => throw null;
                public System.Reflection.Emit.MethodBuilder DefinePInvokeMethod(string name, string dllName, string entryName, System.Reflection.MethodAttributes attributes, System.Reflection.CallingConventions callingConvention, System.Type returnType, System.Type[] parameterTypes, System.Runtime.InteropServices.CallingConvention nativeCallConv, System.Runtime.InteropServices.CharSet nativeCharSet) => throw null;
                protected abstract System.Reflection.Emit.MethodBuilder DefinePInvokeMethodCore(string name, string dllName, string entryName, System.Reflection.MethodAttributes attributes, System.Reflection.CallingConventions callingConvention, System.Type returnType, System.Type[] parameterTypes, System.Runtime.InteropServices.CallingConvention nativeCallConv, System.Runtime.InteropServices.CharSet nativeCharSet);
                public System.Reflection.Emit.TypeBuilder DefineType(string name) => throw null;
                public System.Reflection.Emit.TypeBuilder DefineType(string name, System.Reflection.TypeAttributes attr) => throw null;
                public System.Reflection.Emit.TypeBuilder DefineType(string name, System.Reflection.TypeAttributes attr, System.Type parent) => throw null;
                public System.Reflection.Emit.TypeBuilder DefineType(string name, System.Reflection.TypeAttributes attr, System.Type parent, int typesize) => throw null;
                public System.Reflection.Emit.TypeBuilder DefineType(string name, System.Reflection.TypeAttributes attr, System.Type parent, System.Reflection.Emit.PackingSize packsize) => throw null;
                public System.Reflection.Emit.TypeBuilder DefineType(string name, System.Reflection.TypeAttributes attr, System.Type parent, System.Reflection.Emit.PackingSize packingSize, int typesize) => throw null;
                public System.Reflection.Emit.TypeBuilder DefineType(string name, System.Reflection.TypeAttributes attr, System.Type parent, System.Type[] interfaces) => throw null;
                protected abstract System.Reflection.Emit.TypeBuilder DefineTypeCore(string name, System.Reflection.TypeAttributes attr, System.Type parent, System.Type[] interfaces, System.Reflection.Emit.PackingSize packingSize, int typesize);
                public System.Reflection.Emit.FieldBuilder DefineUninitializedData(string name, int size, System.Reflection.FieldAttributes attributes) => throw null;
                protected abstract System.Reflection.Emit.FieldBuilder DefineUninitializedDataCore(string name, int size, System.Reflection.FieldAttributes attributes);
                public override bool Equals(object obj) => throw null;
                public override string FullyQualifiedName { get => throw null; }
                public System.Reflection.MethodInfo GetArrayMethod(System.Type arrayClass, string methodName, System.Reflection.CallingConventions callingConvention, System.Type returnType, System.Type[] parameterTypes) => throw null;
                protected abstract System.Reflection.MethodInfo GetArrayMethodCore(System.Type arrayClass, string methodName, System.Reflection.CallingConventions callingConvention, System.Type returnType, System.Type[] parameterTypes);
                public override object[] GetCustomAttributes(bool inherit) => throw null;
                public override object[] GetCustomAttributes(System.Type attributeType, bool inherit) => throw null;
                public override System.Collections.Generic.IList<System.Reflection.CustomAttributeData> GetCustomAttributesData() => throw null;
                public override System.Reflection.FieldInfo GetField(string name, System.Reflection.BindingFlags bindingAttr) => throw null;
                public abstract int GetFieldMetadataToken(System.Reflection.FieldInfo field);
                public override System.Reflection.FieldInfo[] GetFields(System.Reflection.BindingFlags bindingFlags) => throw null;
                public override int GetHashCode() => throw null;
                protected override System.Reflection.MethodInfo GetMethodImpl(string name, System.Reflection.BindingFlags bindingAttr, System.Reflection.Binder binder, System.Reflection.CallingConventions callConvention, System.Type[] types, System.Reflection.ParameterModifier[] modifiers) => throw null;
                public abstract int GetMethodMetadataToken(System.Reflection.ConstructorInfo constructor);
                public abstract int GetMethodMetadataToken(System.Reflection.MethodInfo method);
                public override System.Reflection.MethodInfo[] GetMethods(System.Reflection.BindingFlags bindingFlags) => throw null;
                public override void GetPEKind(out System.Reflection.PortableExecutableKinds peKind, out System.Reflection.ImageFileMachine machine) => throw null;
                public abstract int GetSignatureMetadataToken(System.Reflection.Emit.SignatureHelper signature);
                public abstract int GetStringMetadataToken(string stringConstant);
                public override System.Type GetType(string className) => throw null;
                public override System.Type GetType(string className, bool ignoreCase) => throw null;
                public override System.Type GetType(string className, bool throwOnError, bool ignoreCase) => throw null;
                public abstract int GetTypeMetadataToken(System.Type type);
                public override System.Type[] GetTypes() => throw null;
                public override bool IsDefined(System.Type attributeType, bool inherit) => throw null;
                public override bool IsResource() => throw null;
                public override int MDStreamVersion { get => throw null; }
                public override int MetadataToken { get => throw null; }
                public override System.Guid ModuleVersionId { get => throw null; }
                public override string Name { get => throw null; }
                public override System.Reflection.FieldInfo ResolveField(int metadataToken, System.Type[] genericTypeArguments, System.Type[] genericMethodArguments) => throw null;
                public override System.Reflection.MemberInfo ResolveMember(int metadataToken, System.Type[] genericTypeArguments, System.Type[] genericMethodArguments) => throw null;
                public override System.Reflection.MethodBase ResolveMethod(int metadataToken, System.Type[] genericTypeArguments, System.Type[] genericMethodArguments) => throw null;
                public override byte[] ResolveSignature(int metadataToken) => throw null;
                public override string ResolveString(int metadataToken) => throw null;
                public override System.Type ResolveType(int metadataToken, System.Type[] genericTypeArguments, System.Type[] genericMethodArguments) => throw null;
                public override string ScopeName { get => throw null; }
                public void SetCustomAttribute(System.Reflection.ConstructorInfo con, byte[] binaryAttribute) => throw null;
                public void SetCustomAttribute(System.Reflection.Emit.CustomAttributeBuilder customBuilder) => throw null;
                protected abstract void SetCustomAttributeCore(System.Reflection.ConstructorInfo con, System.ReadOnlySpan<byte> binaryAttribute);
            }
            public abstract class PropertyBuilder : System.Reflection.PropertyInfo
            {
                public void AddOtherMethod(System.Reflection.Emit.MethodBuilder mdBuilder) => throw null;
                protected abstract void AddOtherMethodCore(System.Reflection.Emit.MethodBuilder mdBuilder);
                public override System.Reflection.PropertyAttributes Attributes { get => throw null; }
                public override bool CanRead { get => throw null; }
                public override bool CanWrite { get => throw null; }
                protected PropertyBuilder() => throw null;
                public override System.Type DeclaringType { get => throw null; }
                public override System.Reflection.MethodInfo[] GetAccessors(bool nonPublic) => throw null;
                public override object[] GetCustomAttributes(bool inherit) => throw null;
                public override object[] GetCustomAttributes(System.Type attributeType, bool inherit) => throw null;
                public override System.Reflection.MethodInfo GetGetMethod(bool nonPublic) => throw null;
                public override System.Reflection.ParameterInfo[] GetIndexParameters() => throw null;
                public override System.Reflection.MethodInfo GetSetMethod(bool nonPublic) => throw null;
                public override object GetValue(object obj, object[] index) => throw null;
                public override object GetValue(object obj, System.Reflection.BindingFlags invokeAttr, System.Reflection.Binder binder, object[] index, System.Globalization.CultureInfo culture) => throw null;
                public override bool IsDefined(System.Type attributeType, bool inherit) => throw null;
                public override System.Reflection.Module Module { get => throw null; }
                public override string Name { get => throw null; }
                public override System.Type PropertyType { get => throw null; }
                public override System.Type ReflectedType { get => throw null; }
                public void SetConstant(object defaultValue) => throw null;
                protected abstract void SetConstantCore(object defaultValue);
                public void SetCustomAttribute(System.Reflection.ConstructorInfo con, byte[] binaryAttribute) => throw null;
                public void SetCustomAttribute(System.Reflection.Emit.CustomAttributeBuilder customBuilder) => throw null;
                protected abstract void SetCustomAttributeCore(System.Reflection.ConstructorInfo con, System.ReadOnlySpan<byte> binaryAttribute);
                public void SetGetMethod(System.Reflection.Emit.MethodBuilder mdBuilder) => throw null;
                protected abstract void SetGetMethodCore(System.Reflection.Emit.MethodBuilder mdBuilder);
                public void SetSetMethod(System.Reflection.Emit.MethodBuilder mdBuilder) => throw null;
                protected abstract void SetSetMethodCore(System.Reflection.Emit.MethodBuilder mdBuilder);
                public override void SetValue(object obj, object value, object[] index) => throw null;
                public override void SetValue(object obj, object value, System.Reflection.BindingFlags invokeAttr, System.Reflection.Binder binder, object[] index, System.Globalization.CultureInfo culture) => throw null;
            }
            public abstract class TypeBuilder : System.Reflection.TypeInfo
            {
                public void AddInterfaceImplementation(System.Type interfaceType) => throw null;
                protected abstract void AddInterfaceImplementationCore(System.Type interfaceType);
                public override System.Reflection.Assembly Assembly { get => throw null; }
                public override string AssemblyQualifiedName { get => throw null; }
                public override System.Type BaseType { get => throw null; }
                public System.Type CreateType() => throw null;
                public System.Reflection.TypeInfo CreateTypeInfo() => throw null;
                protected abstract System.Reflection.TypeInfo CreateTypeInfoCore();
                protected TypeBuilder() => throw null;
                public override System.Reflection.MethodBase DeclaringMethod { get => throw null; }
                public override System.Type DeclaringType { get => throw null; }
                public System.Reflection.Emit.ConstructorBuilder DefineConstructor(System.Reflection.MethodAttributes attributes, System.Reflection.CallingConventions callingConvention, System.Type[] parameterTypes) => throw null;
                public System.Reflection.Emit.ConstructorBuilder DefineConstructor(System.Reflection.MethodAttributes attributes, System.Reflection.CallingConventions callingConvention, System.Type[] parameterTypes, System.Type[][] requiredCustomModifiers, System.Type[][] optionalCustomModifiers) => throw null;
                protected abstract System.Reflection.Emit.ConstructorBuilder DefineConstructorCore(System.Reflection.MethodAttributes attributes, System.Reflection.CallingConventions callingConvention, System.Type[] parameterTypes, System.Type[][] requiredCustomModifiers, System.Type[][] optionalCustomModifiers);
                public System.Reflection.Emit.ConstructorBuilder DefineDefaultConstructor(System.Reflection.MethodAttributes attributes) => throw null;
                protected abstract System.Reflection.Emit.ConstructorBuilder DefineDefaultConstructorCore(System.Reflection.MethodAttributes attributes);
                public System.Reflection.Emit.EventBuilder DefineEvent(string name, System.Reflection.EventAttributes attributes, System.Type eventtype) => throw null;
                protected abstract System.Reflection.Emit.EventBuilder DefineEventCore(string name, System.Reflection.EventAttributes attributes, System.Type eventtype);
                public System.Reflection.Emit.FieldBuilder DefineField(string fieldName, System.Type type, System.Reflection.FieldAttributes attributes) => throw null;
                public System.Reflection.Emit.FieldBuilder DefineField(string fieldName, System.Type type, System.Type[] requiredCustomModifiers, System.Type[] optionalCustomModifiers, System.Reflection.FieldAttributes attributes) => throw null;
                protected abstract System.Reflection.Emit.FieldBuilder DefineFieldCore(string fieldName, System.Type type, System.Type[] requiredCustomModifiers, System.Type[] optionalCustomModifiers, System.Reflection.FieldAttributes attributes);
                public System.Reflection.Emit.GenericTypeParameterBuilder[] DefineGenericParameters(params string[] names) => throw null;
                protected abstract System.Reflection.Emit.GenericTypeParameterBuilder[] DefineGenericParametersCore(params string[] names);
                public System.Reflection.Emit.FieldBuilder DefineInitializedData(string name, byte[] data, System.Reflection.FieldAttributes attributes) => throw null;
                protected abstract System.Reflection.Emit.FieldBuilder DefineInitializedDataCore(string name, byte[] data, System.Reflection.FieldAttributes attributes);
                public System.Reflection.Emit.MethodBuilder DefineMethod(string name, System.Reflection.MethodAttributes attributes) => throw null;
                public System.Reflection.Emit.MethodBuilder DefineMethod(string name, System.Reflection.MethodAttributes attributes, System.Reflection.CallingConventions callingConvention) => throw null;
                public System.Reflection.Emit.MethodBuilder DefineMethod(string name, System.Reflection.MethodAttributes attributes, System.Reflection.CallingConventions callingConvention, System.Type returnType, System.Type[] parameterTypes) => throw null;
                public System.Reflection.Emit.MethodBuilder DefineMethod(string name, System.Reflection.MethodAttributes attributes, System.Reflection.CallingConventions callingConvention, System.Type returnType, System.Type[] returnTypeRequiredCustomModifiers, System.Type[] returnTypeOptionalCustomModifiers, System.Type[] parameterTypes, System.Type[][] parameterTypeRequiredCustomModifiers, System.Type[][] parameterTypeOptionalCustomModifiers) => throw null;
                public System.Reflection.Emit.MethodBuilder DefineMethod(string name, System.Reflection.MethodAttributes attributes, System.Type returnType, System.Type[] parameterTypes) => throw null;
                protected abstract System.Reflection.Emit.MethodBuilder DefineMethodCore(string name, System.Reflection.MethodAttributes attributes, System.Reflection.CallingConventions callingConvention, System.Type returnType, System.Type[] returnTypeRequiredCustomModifiers, System.Type[] returnTypeOptionalCustomModifiers, System.Type[] parameterTypes, System.Type[][] parameterTypeRequiredCustomModifiers, System.Type[][] parameterTypeOptionalCustomModifiers);
                public void DefineMethodOverride(System.Reflection.MethodInfo methodInfoBody, System.Reflection.MethodInfo methodInfoDeclaration) => throw null;
                protected abstract void DefineMethodOverrideCore(System.Reflection.MethodInfo methodInfoBody, System.Reflection.MethodInfo methodInfoDeclaration);
                public System.Reflection.Emit.TypeBuilder DefineNestedType(string name) => throw null;
                public System.Reflection.Emit.TypeBuilder DefineNestedType(string name, System.Reflection.TypeAttributes attr) => throw null;
                public System.Reflection.Emit.TypeBuilder DefineNestedType(string name, System.Reflection.TypeAttributes attr, System.Type parent) => throw null;
                public System.Reflection.Emit.TypeBuilder DefineNestedType(string name, System.Reflection.TypeAttributes attr, System.Type parent, int typeSize) => throw null;
                public System.Reflection.Emit.TypeBuilder DefineNestedType(string name, System.Reflection.TypeAttributes attr, System.Type parent, System.Reflection.Emit.PackingSize packSize) => throw null;
                public System.Reflection.Emit.TypeBuilder DefineNestedType(string name, System.Reflection.TypeAttributes attr, System.Type parent, System.Reflection.Emit.PackingSize packSize, int typeSize) => throw null;
                public System.Reflection.Emit.TypeBuilder DefineNestedType(string name, System.Reflection.TypeAttributes attr, System.Type parent, System.Type[] interfaces) => throw null;
                protected abstract System.Reflection.Emit.TypeBuilder DefineNestedTypeCore(string name, System.Reflection.TypeAttributes attr, System.Type parent, System.Type[] interfaces, System.Reflection.Emit.PackingSize packSize, int typeSize);
                public System.Reflection.Emit.MethodBuilder DefinePInvokeMethod(string name, string dllName, System.Reflection.MethodAttributes attributes, System.Reflection.CallingConventions callingConvention, System.Type returnType, System.Type[] parameterTypes, System.Runtime.InteropServices.CallingConvention nativeCallConv, System.Runtime.InteropServices.CharSet nativeCharSet) => throw null;
                public System.Reflection.Emit.MethodBuilder DefinePInvokeMethod(string name, string dllName, string entryName, System.Reflection.MethodAttributes attributes, System.Reflection.CallingConventions callingConvention, System.Type returnType, System.Type[] parameterTypes, System.Runtime.InteropServices.CallingConvention nativeCallConv, System.Runtime.InteropServices.CharSet nativeCharSet) => throw null;
                public System.Reflection.Emit.MethodBuilder DefinePInvokeMethod(string name, string dllName, string entryName, System.Reflection.MethodAttributes attributes, System.Reflection.CallingConventions callingConvention, System.Type returnType, System.Type[] returnTypeRequiredCustomModifiers, System.Type[] returnTypeOptionalCustomModifiers, System.Type[] parameterTypes, System.Type[][] parameterTypeRequiredCustomModifiers, System.Type[][] parameterTypeOptionalCustomModifiers, System.Runtime.InteropServices.CallingConvention nativeCallConv, System.Runtime.InteropServices.CharSet nativeCharSet) => throw null;
                protected abstract System.Reflection.Emit.MethodBuilder DefinePInvokeMethodCore(string name, string dllName, string entryName, System.Reflection.MethodAttributes attributes, System.Reflection.CallingConventions callingConvention, System.Type returnType, System.Type[] returnTypeRequiredCustomModifiers, System.Type[] returnTypeOptionalCustomModifiers, System.Type[] parameterTypes, System.Type[][] parameterTypeRequiredCustomModifiers, System.Type[][] parameterTypeOptionalCustomModifiers, System.Runtime.InteropServices.CallingConvention nativeCallConv, System.Runtime.InteropServices.CharSet nativeCharSet);
                public System.Reflection.Emit.PropertyBuilder DefineProperty(string name, System.Reflection.PropertyAttributes attributes, System.Reflection.CallingConventions callingConvention, System.Type returnType, System.Type[] parameterTypes) => throw null;
                public System.Reflection.Emit.PropertyBuilder DefineProperty(string name, System.Reflection.PropertyAttributes attributes, System.Reflection.CallingConventions callingConvention, System.Type returnType, System.Type[] returnTypeRequiredCustomModifiers, System.Type[] returnTypeOptionalCustomModifiers, System.Type[] parameterTypes, System.Type[][] parameterTypeRequiredCustomModifiers, System.Type[][] parameterTypeOptionalCustomModifiers) => throw null;
                public System.Reflection.Emit.PropertyBuilder DefineProperty(string name, System.Reflection.PropertyAttributes attributes, System.Type returnType, System.Type[] parameterTypes) => throw null;
                public System.Reflection.Emit.PropertyBuilder DefineProperty(string name, System.Reflection.PropertyAttributes attributes, System.Type returnType, System.Type[] returnTypeRequiredCustomModifiers, System.Type[] returnTypeOptionalCustomModifiers, System.Type[] parameterTypes, System.Type[][] parameterTypeRequiredCustomModifiers, System.Type[][] parameterTypeOptionalCustomModifiers) => throw null;
                protected abstract System.Reflection.Emit.PropertyBuilder DefinePropertyCore(string name, System.Reflection.PropertyAttributes attributes, System.Reflection.CallingConventions callingConvention, System.Type returnType, System.Type[] returnTypeRequiredCustomModifiers, System.Type[] returnTypeOptionalCustomModifiers, System.Type[] parameterTypes, System.Type[][] parameterTypeRequiredCustomModifiers, System.Type[][] parameterTypeOptionalCustomModifiers);
                public System.Reflection.Emit.ConstructorBuilder DefineTypeInitializer() => throw null;
                protected abstract System.Reflection.Emit.ConstructorBuilder DefineTypeInitializerCore();
                public System.Reflection.Emit.FieldBuilder DefineUninitializedData(string name, int size, System.Reflection.FieldAttributes attributes) => throw null;
                protected abstract System.Reflection.Emit.FieldBuilder DefineUninitializedDataCore(string name, int size, System.Reflection.FieldAttributes attributes);
                public override string FullName { get => throw null; }
                public override System.Reflection.GenericParameterAttributes GenericParameterAttributes { get => throw null; }
                public override int GenericParameterPosition { get => throw null; }
                protected override System.Reflection.TypeAttributes GetAttributeFlagsImpl() => throw null;
                public static System.Reflection.ConstructorInfo GetConstructor(System.Type type, System.Reflection.ConstructorInfo constructor) => throw null;
                protected override System.Reflection.ConstructorInfo GetConstructorImpl(System.Reflection.BindingFlags bindingAttr, System.Reflection.Binder binder, System.Reflection.CallingConventions callConvention, System.Type[] types, System.Reflection.ParameterModifier[] modifiers) => throw null;
                public override System.Reflection.ConstructorInfo[] GetConstructors(System.Reflection.BindingFlags bindingAttr) => throw null;
                public override object[] GetCustomAttributes(bool inherit) => throw null;
                public override object[] GetCustomAttributes(System.Type attributeType, bool inherit) => throw null;
                public override System.Type GetElementType() => throw null;
                public override System.Reflection.EventInfo GetEvent(string name, System.Reflection.BindingFlags bindingAttr) => throw null;
                public override System.Reflection.EventInfo[] GetEvents() => throw null;
                public override System.Reflection.EventInfo[] GetEvents(System.Reflection.BindingFlags bindingAttr) => throw null;
                public override System.Reflection.FieldInfo GetField(string name, System.Reflection.BindingFlags bindingAttr) => throw null;
                public static System.Reflection.FieldInfo GetField(System.Type type, System.Reflection.FieldInfo field) => throw null;
                public override System.Reflection.FieldInfo[] GetFields(System.Reflection.BindingFlags bindingAttr) => throw null;
                public override System.Type[] GetGenericArguments() => throw null;
                public override System.Type GetGenericTypeDefinition() => throw null;
                public override System.Type GetInterface(string name, bool ignoreCase) => throw null;
                public override System.Reflection.InterfaceMapping GetInterfaceMap(System.Type interfaceType) => throw null;
                public override System.Type[] GetInterfaces() => throw null;
                public override System.Reflection.MemberInfo[] GetMember(string name, System.Reflection.MemberTypes type, System.Reflection.BindingFlags bindingAttr) => throw null;
                public override System.Reflection.MemberInfo[] GetMembers(System.Reflection.BindingFlags bindingAttr) => throw null;
                public static System.Reflection.MethodInfo GetMethod(System.Type type, System.Reflection.MethodInfo method) => throw null;
                protected override System.Reflection.MethodInfo GetMethodImpl(string name, System.Reflection.BindingFlags bindingAttr, System.Reflection.Binder binder, System.Reflection.CallingConventions callConvention, System.Type[] types, System.Reflection.ParameterModifier[] modifiers) => throw null;
                public override System.Reflection.MethodInfo[] GetMethods(System.Reflection.BindingFlags bindingAttr) => throw null;
                public override System.Type GetNestedType(string name, System.Reflection.BindingFlags bindingAttr) => throw null;
                public override System.Type[] GetNestedTypes(System.Reflection.BindingFlags bindingAttr) => throw null;
                public override System.Reflection.PropertyInfo[] GetProperties(System.Reflection.BindingFlags bindingAttr) => throw null;
                protected override System.Reflection.PropertyInfo GetPropertyImpl(string name, System.Reflection.BindingFlags bindingAttr, System.Reflection.Binder binder, System.Type returnType, System.Type[] types, System.Reflection.ParameterModifier[] modifiers) => throw null;
                public override System.Guid GUID { get => throw null; }
                protected override bool HasElementTypeImpl() => throw null;
                public override object InvokeMember(string name, System.Reflection.BindingFlags invokeAttr, System.Reflection.Binder binder, object target, object[] args, System.Reflection.ParameterModifier[] modifiers, System.Globalization.CultureInfo culture, string[] namedParameters) => throw null;
                protected override bool IsArrayImpl() => throw null;
                public override bool IsAssignableFrom(System.Reflection.TypeInfo typeInfo) => throw null;
                public override bool IsAssignableFrom(System.Type c) => throw null;
                protected override bool IsByRefImpl() => throw null;
                public override bool IsByRefLike { get => throw null; }
                protected override bool IsCOMObjectImpl() => throw null;
                public override bool IsConstructedGenericType { get => throw null; }
                public bool IsCreated() => throw null;
                protected abstract bool IsCreatedCore();
                public override bool IsDefined(System.Type attributeType, bool inherit) => throw null;
                public override bool IsGenericParameter { get => throw null; }
                public override bool IsGenericType { get => throw null; }
                public override bool IsGenericTypeDefinition { get => throw null; }
                protected override bool IsPointerImpl() => throw null;
                protected override bool IsPrimitiveImpl() => throw null;
                public override bool IsSecurityCritical { get => throw null; }
                public override bool IsSecuritySafeCritical { get => throw null; }
                public override bool IsSecurityTransparent { get => throw null; }
                public override bool IsSubclassOf(System.Type c) => throw null;
                public override bool IsSZArray { get => throw null; }
                public override bool IsTypeDefinition { get => throw null; }
                public override System.Type MakeArrayType() => throw null;
                public override System.Type MakeArrayType(int rank) => throw null;
                public override System.Type MakeByRefType() => throw null;
                public override System.Type MakeGenericType(params System.Type[] typeArguments) => throw null;
                public override System.Type MakePointerType() => throw null;
                public override int MetadataToken { get => throw null; }
                public override System.Reflection.Module Module { get => throw null; }
                public override string Name { get => throw null; }
                public override string Namespace { get => throw null; }
                public System.Reflection.Emit.PackingSize PackingSize { get => throw null; }
                protected abstract System.Reflection.Emit.PackingSize PackingSizeCore { get; }
                public override System.Type ReflectedType { get => throw null; }
                public void SetCustomAttribute(System.Reflection.ConstructorInfo con, byte[] binaryAttribute) => throw null;
                public void SetCustomAttribute(System.Reflection.Emit.CustomAttributeBuilder customBuilder) => throw null;
                protected abstract void SetCustomAttributeCore(System.Reflection.ConstructorInfo con, System.ReadOnlySpan<byte> binaryAttribute);
                public void SetParent(System.Type parent) => throw null;
                protected abstract void SetParentCore(System.Type parent);
                public int Size { get => throw null; }
                protected abstract int SizeCore { get; }
                public override string ToString() => throw null;
                public override System.RuntimeTypeHandle TypeHandle { get => throw null; }
                public override System.Type UnderlyingSystemType { get => throw null; }
                public const int UnspecifiedTypeSize = 0;
            }
        }
    }
}
