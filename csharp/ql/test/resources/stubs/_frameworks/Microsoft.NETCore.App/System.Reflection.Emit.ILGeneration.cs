// This file contains auto-generated code.

namespace System
{
    namespace Reflection
    {
        namespace Emit
        {
            // Generated from `System.Reflection.Emit.CustomAttributeBuilder` in `System.Reflection.Emit.ILGeneration, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class CustomAttributeBuilder
            {
                public CustomAttributeBuilder(System.Reflection.ConstructorInfo con, object[] constructorArgs) => throw null;
                public CustomAttributeBuilder(System.Reflection.ConstructorInfo con, object[] constructorArgs, System.Reflection.FieldInfo[] namedFields, object[] fieldValues) => throw null;
                public CustomAttributeBuilder(System.Reflection.ConstructorInfo con, object[] constructorArgs, System.Reflection.PropertyInfo[] namedProperties, object[] propertyValues) => throw null;
                public CustomAttributeBuilder(System.Reflection.ConstructorInfo con, object[] constructorArgs, System.Reflection.PropertyInfo[] namedProperties, object[] propertyValues, System.Reflection.FieldInfo[] namedFields, object[] fieldValues) => throw null;
            }

            // Generated from `System.Reflection.Emit.ILGenerator` in `System.Reflection.Emit.ILGeneration, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class ILGenerator
            {
                public virtual void BeginCatchBlock(System.Type exceptionType) => throw null;
                public virtual void BeginExceptFilterBlock() => throw null;
                public virtual System.Reflection.Emit.Label BeginExceptionBlock() => throw null;
                public virtual void BeginFaultBlock() => throw null;
                public virtual void BeginFinallyBlock() => throw null;
                public virtual void BeginScope() => throw null;
                public virtual System.Reflection.Emit.LocalBuilder DeclareLocal(System.Type localType) => throw null;
                public virtual System.Reflection.Emit.LocalBuilder DeclareLocal(System.Type localType, bool pinned) => throw null;
                public virtual System.Reflection.Emit.Label DefineLabel() => throw null;
                public virtual void Emit(System.Reflection.Emit.OpCode opcode) => throw null;
                public virtual void Emit(System.Reflection.Emit.OpCode opcode, System.Reflection.ConstructorInfo con) => throw null;
                public virtual void Emit(System.Reflection.Emit.OpCode opcode, System.Reflection.FieldInfo field) => throw null;
                public virtual void Emit(System.Reflection.Emit.OpCode opcode, System.Reflection.Emit.Label label) => throw null;
                public virtual void Emit(System.Reflection.Emit.OpCode opcode, System.Reflection.Emit.Label[] labels) => throw null;
                public virtual void Emit(System.Reflection.Emit.OpCode opcode, System.Reflection.Emit.LocalBuilder local) => throw null;
                public virtual void Emit(System.Reflection.Emit.OpCode opcode, System.Reflection.MethodInfo meth) => throw null;
                public virtual void Emit(System.Reflection.Emit.OpCode opcode, System.Reflection.Emit.SignatureHelper signature) => throw null;
                public virtual void Emit(System.Reflection.Emit.OpCode opcode, System.Type cls) => throw null;
                public virtual void Emit(System.Reflection.Emit.OpCode opcode, System.Byte arg) => throw null;
                public virtual void Emit(System.Reflection.Emit.OpCode opcode, double arg) => throw null;
                public virtual void Emit(System.Reflection.Emit.OpCode opcode, float arg) => throw null;
                public virtual void Emit(System.Reflection.Emit.OpCode opcode, int arg) => throw null;
                public virtual void Emit(System.Reflection.Emit.OpCode opcode, System.Int64 arg) => throw null;
                public void Emit(System.Reflection.Emit.OpCode opcode, System.SByte arg) => throw null;
                public virtual void Emit(System.Reflection.Emit.OpCode opcode, System.Int16 arg) => throw null;
                public virtual void Emit(System.Reflection.Emit.OpCode opcode, string str) => throw null;
                public virtual void EmitCall(System.Reflection.Emit.OpCode opcode, System.Reflection.MethodInfo methodInfo, System.Type[] optionalParameterTypes) => throw null;
                public virtual void EmitCalli(System.Reflection.Emit.OpCode opcode, System.Runtime.InteropServices.CallingConvention unmanagedCallConv, System.Type returnType, System.Type[] parameterTypes) => throw null;
                public virtual void EmitCalli(System.Reflection.Emit.OpCode opcode, System.Reflection.CallingConventions callingConvention, System.Type returnType, System.Type[] parameterTypes, System.Type[] optionalParameterTypes) => throw null;
                public virtual void EmitWriteLine(System.Reflection.FieldInfo fld) => throw null;
                public virtual void EmitWriteLine(System.Reflection.Emit.LocalBuilder localBuilder) => throw null;
                public virtual void EmitWriteLine(string value) => throw null;
                public virtual void EndExceptionBlock() => throw null;
                public virtual void EndScope() => throw null;
                public virtual int ILOffset { get => throw null; }
                public virtual void MarkLabel(System.Reflection.Emit.Label loc) => throw null;
                public virtual void ThrowException(System.Type excType) => throw null;
                public virtual void UsingNamespace(string usingNamespace) => throw null;
            }

            // Generated from `System.Reflection.Emit.Label` in `System.Reflection.Emit.ILGeneration, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public struct Label : System.IEquatable<System.Reflection.Emit.Label>
            {
                public static bool operator !=(System.Reflection.Emit.Label a, System.Reflection.Emit.Label b) => throw null;
                public static bool operator ==(System.Reflection.Emit.Label a, System.Reflection.Emit.Label b) => throw null;
                public bool Equals(System.Reflection.Emit.Label obj) => throw null;
                public override bool Equals(object obj) => throw null;
                public override int GetHashCode() => throw null;
                // Stub generator skipped constructor 
            }

            // Generated from `System.Reflection.Emit.LocalBuilder` in `System.Reflection.Emit.ILGeneration, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class LocalBuilder : System.Reflection.LocalVariableInfo
            {
                public override bool IsPinned { get => throw null; }
                public override int LocalIndex { get => throw null; }
                public override System.Type LocalType { get => throw null; }
            }

            // Generated from `System.Reflection.Emit.ParameterBuilder` in `System.Reflection.Emit.ILGeneration, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class ParameterBuilder
            {
                public virtual int Attributes { get => throw null; }
                public bool IsIn { get => throw null; }
                public bool IsOptional { get => throw null; }
                public bool IsOut { get => throw null; }
                public virtual string Name { get => throw null; }
                public virtual int Position { get => throw null; }
                public virtual void SetConstant(object defaultValue) => throw null;
                public void SetCustomAttribute(System.Reflection.ConstructorInfo con, System.Byte[] binaryAttribute) => throw null;
                public void SetCustomAttribute(System.Reflection.Emit.CustomAttributeBuilder customBuilder) => throw null;
            }

            // Generated from `System.Reflection.Emit.SignatureHelper` in `System.Reflection.Emit.ILGeneration, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class SignatureHelper
            {
                public void AddArgument(System.Type clsArgument) => throw null;
                public void AddArgument(System.Type argument, System.Type[] requiredCustomModifiers, System.Type[] optionalCustomModifiers) => throw null;
                public void AddArgument(System.Type argument, bool pinned) => throw null;
                public void AddArguments(System.Type[] arguments, System.Type[][] requiredCustomModifiers, System.Type[][] optionalCustomModifiers) => throw null;
                public void AddSentinel() => throw null;
                public override bool Equals(object obj) => throw null;
                public static System.Reflection.Emit.SignatureHelper GetFieldSigHelper(System.Reflection.Module mod) => throw null;
                public override int GetHashCode() => throw null;
                public static System.Reflection.Emit.SignatureHelper GetLocalVarSigHelper() => throw null;
                public static System.Reflection.Emit.SignatureHelper GetLocalVarSigHelper(System.Reflection.Module mod) => throw null;
                public static System.Reflection.Emit.SignatureHelper GetMethodSigHelper(System.Reflection.CallingConventions callingConvention, System.Type returnType) => throw null;
                public static System.Reflection.Emit.SignatureHelper GetMethodSigHelper(System.Reflection.Module mod, System.Reflection.CallingConventions callingConvention, System.Type returnType) => throw null;
                public static System.Reflection.Emit.SignatureHelper GetMethodSigHelper(System.Reflection.Module mod, System.Type returnType, System.Type[] parameterTypes) => throw null;
                public static System.Reflection.Emit.SignatureHelper GetPropertySigHelper(System.Reflection.Module mod, System.Reflection.CallingConventions callingConvention, System.Type returnType, System.Type[] requiredReturnTypeCustomModifiers, System.Type[] optionalReturnTypeCustomModifiers, System.Type[] parameterTypes, System.Type[][] requiredParameterTypeCustomModifiers, System.Type[][] optionalParameterTypeCustomModifiers) => throw null;
                public static System.Reflection.Emit.SignatureHelper GetPropertySigHelper(System.Reflection.Module mod, System.Type returnType, System.Type[] parameterTypes) => throw null;
                public static System.Reflection.Emit.SignatureHelper GetPropertySigHelper(System.Reflection.Module mod, System.Type returnType, System.Type[] requiredReturnTypeCustomModifiers, System.Type[] optionalReturnTypeCustomModifiers, System.Type[] parameterTypes, System.Type[][] requiredParameterTypeCustomModifiers, System.Type[][] optionalParameterTypeCustomModifiers) => throw null;
                public System.Byte[] GetSignature() => throw null;
                public override string ToString() => throw null;
            }

        }
    }
}
