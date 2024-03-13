// This file contains auto-generated code.
// Generated from `System.Reflection.Emit.Lightweight, Version=8.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`.
namespace System
{
    namespace Reflection
    {
        namespace Emit
        {
            public sealed class DynamicILInfo
            {
                public System.Reflection.Emit.DynamicMethod DynamicMethod { get => throw null; }
                public int GetTokenFor(byte[] signature) => throw null;
                public int GetTokenFor(System.Reflection.Emit.DynamicMethod method) => throw null;
                public int GetTokenFor(System.RuntimeFieldHandle field) => throw null;
                public int GetTokenFor(System.RuntimeFieldHandle field, System.RuntimeTypeHandle contextType) => throw null;
                public int GetTokenFor(System.RuntimeMethodHandle method) => throw null;
                public int GetTokenFor(System.RuntimeMethodHandle method, System.RuntimeTypeHandle contextType) => throw null;
                public int GetTokenFor(System.RuntimeTypeHandle type) => throw null;
                public int GetTokenFor(string literal) => throw null;
                public unsafe void SetCode(byte* code, int codeSize, int maxStackSize) => throw null;
                public void SetCode(byte[] code, int maxStackSize) => throw null;
                public unsafe void SetExceptions(byte* exceptions, int exceptionsSize) => throw null;
                public void SetExceptions(byte[] exceptions) => throw null;
                public unsafe void SetLocalSignature(byte* localSignature, int signatureSize) => throw null;
                public void SetLocalSignature(byte[] localSignature) => throw null;
            }
            public sealed class DynamicMethod : System.Reflection.MethodInfo
            {
                public override System.Reflection.MethodAttributes Attributes { get => throw null; }
                public override System.Reflection.CallingConventions CallingConvention { get => throw null; }
                public override sealed System.Delegate CreateDelegate(System.Type delegateType) => throw null;
                public override sealed System.Delegate CreateDelegate(System.Type delegateType, object target) => throw null;
                public DynamicMethod(string name, System.Reflection.MethodAttributes attributes, System.Reflection.CallingConventions callingConvention, System.Type returnType, System.Type[] parameterTypes, System.Reflection.Module m, bool skipVisibility) => throw null;
                public DynamicMethod(string name, System.Reflection.MethodAttributes attributes, System.Reflection.CallingConventions callingConvention, System.Type returnType, System.Type[] parameterTypes, System.Type owner, bool skipVisibility) => throw null;
                public DynamicMethod(string name, System.Type returnType, System.Type[] parameterTypes) => throw null;
                public DynamicMethod(string name, System.Type returnType, System.Type[] parameterTypes, bool restrictedSkipVisibility) => throw null;
                public DynamicMethod(string name, System.Type returnType, System.Type[] parameterTypes, System.Reflection.Module m) => throw null;
                public DynamicMethod(string name, System.Type returnType, System.Type[] parameterTypes, System.Reflection.Module m, bool skipVisibility) => throw null;
                public DynamicMethod(string name, System.Type returnType, System.Type[] parameterTypes, System.Type owner) => throw null;
                public DynamicMethod(string name, System.Type returnType, System.Type[] parameterTypes, System.Type owner, bool skipVisibility) => throw null;
                public override System.Type DeclaringType { get => throw null; }
                public System.Reflection.Emit.ParameterBuilder DefineParameter(int position, System.Reflection.ParameterAttributes attributes, string parameterName) => throw null;
                public override System.Reflection.MethodInfo GetBaseDefinition() => throw null;
                public override object[] GetCustomAttributes(bool inherit) => throw null;
                public override object[] GetCustomAttributes(System.Type attributeType, bool inherit) => throw null;
                public System.Reflection.Emit.DynamicILInfo GetDynamicILInfo() => throw null;
                public System.Reflection.Emit.ILGenerator GetILGenerator() => throw null;
                public System.Reflection.Emit.ILGenerator GetILGenerator(int streamSize) => throw null;
                public override System.Reflection.MethodImplAttributes GetMethodImplementationFlags() => throw null;
                public override System.Reflection.ParameterInfo[] GetParameters() => throw null;
                public bool InitLocals { get => throw null; set { } }
                public override object Invoke(object obj, System.Reflection.BindingFlags invokeAttr, System.Reflection.Binder binder, object[] parameters, System.Globalization.CultureInfo culture) => throw null;
                public override bool IsDefined(System.Type attributeType, bool inherit) => throw null;
                public override bool IsSecurityCritical { get => throw null; }
                public override bool IsSecuritySafeCritical { get => throw null; }
                public override bool IsSecurityTransparent { get => throw null; }
                public override System.RuntimeMethodHandle MethodHandle { get => throw null; }
                public override System.Reflection.Module Module { get => throw null; }
                public override string Name { get => throw null; }
                public override System.Type ReflectedType { get => throw null; }
                public override System.Reflection.ParameterInfo ReturnParameter { get => throw null; }
                public override System.Type ReturnType { get => throw null; }
                public override System.Reflection.ICustomAttributeProvider ReturnTypeCustomAttributes { get => throw null; }
                public override string ToString() => throw null;
            }
        }
    }
}
