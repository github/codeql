// This file contains auto-generated code.
// Generated from `System.Reflection.Emit.ILGeneration, Version=8.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`.
namespace System
{
    namespace Reflection
    {
        namespace Emit
        {
            public class CustomAttributeBuilder
            {
                public CustomAttributeBuilder(System.Reflection.ConstructorInfo con, object[] constructorArgs) => throw null;
                public CustomAttributeBuilder(System.Reflection.ConstructorInfo con, object[] constructorArgs, System.Reflection.FieldInfo[] namedFields, object[] fieldValues) => throw null;
                public CustomAttributeBuilder(System.Reflection.ConstructorInfo con, object[] constructorArgs, System.Reflection.PropertyInfo[] namedProperties, object[] propertyValues) => throw null;
                public CustomAttributeBuilder(System.Reflection.ConstructorInfo con, object[] constructorArgs, System.Reflection.PropertyInfo[] namedProperties, object[] propertyValues, System.Reflection.FieldInfo[] namedFields, object[] fieldValues) => throw null;
            }
            public abstract class ILGenerator
            {
                public abstract void BeginCatchBlock(System.Type exceptionType);
                public abstract void BeginExceptFilterBlock();
                public abstract System.Reflection.Emit.Label BeginExceptionBlock();
                public abstract void BeginFaultBlock();
                public abstract void BeginFinallyBlock();
                public abstract void BeginScope();
                protected ILGenerator() => throw null;
                public virtual System.Reflection.Emit.LocalBuilder DeclareLocal(System.Type localType) => throw null;
                public abstract System.Reflection.Emit.LocalBuilder DeclareLocal(System.Type localType, bool pinned);
                public abstract System.Reflection.Emit.Label DefineLabel();
                public abstract void Emit(System.Reflection.Emit.OpCode opcode);
                public abstract void Emit(System.Reflection.Emit.OpCode opcode, byte arg);
                public abstract void Emit(System.Reflection.Emit.OpCode opcode, double arg);
                public abstract void Emit(System.Reflection.Emit.OpCode opcode, short arg);
                public abstract void Emit(System.Reflection.Emit.OpCode opcode, int arg);
                public abstract void Emit(System.Reflection.Emit.OpCode opcode, long arg);
                public abstract void Emit(System.Reflection.Emit.OpCode opcode, System.Reflection.ConstructorInfo con);
                public abstract void Emit(System.Reflection.Emit.OpCode opcode, System.Reflection.Emit.Label label);
                public abstract void Emit(System.Reflection.Emit.OpCode opcode, System.Reflection.Emit.Label[] labels);
                public abstract void Emit(System.Reflection.Emit.OpCode opcode, System.Reflection.Emit.LocalBuilder local);
                public abstract void Emit(System.Reflection.Emit.OpCode opcode, System.Reflection.Emit.SignatureHelper signature);
                public abstract void Emit(System.Reflection.Emit.OpCode opcode, System.Reflection.FieldInfo field);
                public abstract void Emit(System.Reflection.Emit.OpCode opcode, System.Reflection.MethodInfo meth);
                public void Emit(System.Reflection.Emit.OpCode opcode, sbyte arg) => throw null;
                public abstract void Emit(System.Reflection.Emit.OpCode opcode, float arg);
                public abstract void Emit(System.Reflection.Emit.OpCode opcode, string str);
                public abstract void Emit(System.Reflection.Emit.OpCode opcode, System.Type cls);
                public abstract void EmitCall(System.Reflection.Emit.OpCode opcode, System.Reflection.MethodInfo methodInfo, System.Type[] optionalParameterTypes);
                public abstract void EmitCalli(System.Reflection.Emit.OpCode opcode, System.Reflection.CallingConventions callingConvention, System.Type returnType, System.Type[] parameterTypes, System.Type[] optionalParameterTypes);
                public abstract void EmitCalli(System.Reflection.Emit.OpCode opcode, System.Runtime.InteropServices.CallingConvention unmanagedCallConv, System.Type returnType, System.Type[] parameterTypes);
                public virtual void EmitWriteLine(System.Reflection.Emit.LocalBuilder localBuilder) => throw null;
                public virtual void EmitWriteLine(System.Reflection.FieldInfo fld) => throw null;
                public virtual void EmitWriteLine(string value) => throw null;
                public abstract void EndExceptionBlock();
                public abstract void EndScope();
                public abstract int ILOffset { get; }
                public abstract void MarkLabel(System.Reflection.Emit.Label loc);
                public virtual void ThrowException(System.Type excType) => throw null;
                public abstract void UsingNamespace(string usingNamespace);
            }
            public struct Label : System.IEquatable<System.Reflection.Emit.Label>
            {
                public override bool Equals(object obj) => throw null;
                public bool Equals(System.Reflection.Emit.Label obj) => throw null;
                public override int GetHashCode() => throw null;
                public static bool operator ==(System.Reflection.Emit.Label a, System.Reflection.Emit.Label b) => throw null;
                public static bool operator !=(System.Reflection.Emit.Label a, System.Reflection.Emit.Label b) => throw null;
            }
            public sealed class LocalBuilder : System.Reflection.LocalVariableInfo
            {
                public override bool IsPinned { get => throw null; }
                public override int LocalIndex { get => throw null; }
                public override System.Type LocalType { get => throw null; }
            }
            public abstract class ParameterBuilder
            {
                public virtual int Attributes { get => throw null; }
                protected ParameterBuilder() => throw null;
                public bool IsIn { get => throw null; }
                public bool IsOptional { get => throw null; }
                public bool IsOut { get => throw null; }
                public virtual string Name { get => throw null; }
                public virtual int Position { get => throw null; }
                public virtual void SetConstant(object defaultValue) => throw null;
                public void SetCustomAttribute(System.Reflection.ConstructorInfo con, byte[] binaryAttribute) => throw null;
                public void SetCustomAttribute(System.Reflection.Emit.CustomAttributeBuilder customBuilder) => throw null;
                protected abstract void SetCustomAttributeCore(System.Reflection.ConstructorInfo con, System.ReadOnlySpan<byte> binaryAttribute);
            }
            public sealed class SignatureHelper
            {
                public void AddArgument(System.Type clsArgument) => throw null;
                public void AddArgument(System.Type argument, bool pinned) => throw null;
                public void AddArgument(System.Type argument, System.Type[] requiredCustomModifiers, System.Type[] optionalCustomModifiers) => throw null;
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
                public byte[] GetSignature() => throw null;
                public override string ToString() => throw null;
            }
        }
    }
}
