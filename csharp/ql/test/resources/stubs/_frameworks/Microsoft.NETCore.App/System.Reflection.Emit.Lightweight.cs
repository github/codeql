// This file contains auto-generated code.

namespace System
{
    namespace Reflection
    {
        namespace Emit
        {
            // Generated from `System.Reflection.Emit.DynamicILInfo` in `System.Reflection.Emit.Lightweight, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class DynamicILInfo
            {
                public System.Reflection.Emit.DynamicMethod DynamicMethod { get => throw null; }
                public int GetTokenFor(System.Byte[] signature) => throw null;
                public int GetTokenFor(System.Reflection.Emit.DynamicMethod method) => throw null;
                public int GetTokenFor(System.RuntimeFieldHandle field) => throw null;
                public int GetTokenFor(System.RuntimeFieldHandle field, System.RuntimeTypeHandle contextType) => throw null;
                public int GetTokenFor(System.RuntimeMethodHandle method) => throw null;
                public int GetTokenFor(System.RuntimeMethodHandle method, System.RuntimeTypeHandle contextType) => throw null;
                public int GetTokenFor(System.RuntimeTypeHandle type) => throw null;
                public int GetTokenFor(string literal) => throw null;
                public void SetCode(System.Byte[] code, int maxStackSize) => throw null;
                unsafe public void SetCode(System.Byte* code, int codeSize, int maxStackSize) => throw null;
                public void SetExceptions(System.Byte[] exceptions) => throw null;
                unsafe public void SetExceptions(System.Byte* exceptions, int exceptionsSize) => throw null;
                public void SetLocalSignature(System.Byte[] localSignature) => throw null;
                unsafe public void SetLocalSignature(System.Byte* localSignature, int signatureSize) => throw null;
            }

            // Generated from `System.Reflection.Emit.DynamicMethod` in `System.Reflection.Emit.Lightweight, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class DynamicMethod : System.Reflection.MethodInfo
            {
                public override System.Reflection.MethodAttributes Attributes { get => throw null; }
                public override System.Reflection.CallingConventions CallingConvention { get => throw null; }
                public override System.Delegate CreateDelegate(System.Type delegateType) => throw null;
                public override System.Delegate CreateDelegate(System.Type delegateType, object target) => throw null;
                public override System.Type DeclaringType { get => throw null; }
                public System.Reflection.Emit.ParameterBuilder DefineParameter(int position, System.Reflection.ParameterAttributes attributes, string parameterName) => throw null;
                public DynamicMethod(string name, System.Reflection.MethodAttributes attributes, System.Reflection.CallingConventions callingConvention, System.Type returnType, System.Type[] parameterTypes, System.Reflection.Module m, bool skipVisibility) => throw null;
                public DynamicMethod(string name, System.Reflection.MethodAttributes attributes, System.Reflection.CallingConventions callingConvention, System.Type returnType, System.Type[] parameterTypes, System.Type owner, bool skipVisibility) => throw null;
                public DynamicMethod(string name, System.Type returnType, System.Type[] parameterTypes) => throw null;
                public DynamicMethod(string name, System.Type returnType, System.Type[] parameterTypes, System.Reflection.Module m) => throw null;
                public DynamicMethod(string name, System.Type returnType, System.Type[] parameterTypes, System.Reflection.Module m, bool skipVisibility) => throw null;
                public DynamicMethod(string name, System.Type returnType, System.Type[] parameterTypes, System.Type owner) => throw null;
                public DynamicMethod(string name, System.Type returnType, System.Type[] parameterTypes, System.Type owner, bool skipVisibility) => throw null;
                public DynamicMethod(string name, System.Type returnType, System.Type[] parameterTypes, bool restrictedSkipVisibility) => throw null;
                public override System.Reflection.MethodInfo GetBaseDefinition() => throw null;
                public override object[] GetCustomAttributes(System.Type attributeType, bool inherit) => throw null;
                public override object[] GetCustomAttributes(bool inherit) => throw null;
                public System.Reflection.Emit.DynamicILInfo GetDynamicILInfo() => throw null;
                public System.Reflection.Emit.ILGenerator GetILGenerator() => throw null;
                public System.Reflection.Emit.ILGenerator GetILGenerator(int streamSize) => throw null;
                public override System.Reflection.MethodImplAttributes GetMethodImplementationFlags() => throw null;
                public override System.Reflection.ParameterInfo[] GetParameters() => throw null;
                public bool InitLocals { get => throw null; set => throw null; }
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
